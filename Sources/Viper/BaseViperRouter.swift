//
//  BaseViperRouter.swift
//  Viper
//
//  Created by Asad Rana on 3/26/20.
//  Copyright © 2020 anrana. All rights reserved.
//

import Foundation
import Combine
import UIKit

public protocol ActivationListener {
    func didActivateComponent()
}

open class BaseViperRouter<I: ViperInteractor, P: ViperPresenter, V: ViperView>
where P.Action == I.Action, P.Result == I.Result, P.Model == V.Model, P.Event == V.Event {
    public let interactor: I
    public let presenter: P
    public let view: V

    private var viewEventSink: AnyCancellable? = nil
    private var connectionCancellables = [AnyCancellable]()

    public init(interactor: I, presenter: P, view: V) {
        self.interactor = interactor
        self.presenter = presenter
        self.view = view
        self.subscribeForActivation()
    }
    
    open func handle(destination: I.Destination) {
        fatalError("Subclass must implement handle(destination:)")
    }
    
    private func subscribeForActivation() {
        viewEventSink = view.eventStream.receive(on: DispatchQueue.global())
            .sink(receiveValue: { [weak self] event in
                guard let self = self else { return }
                if case .lifeCycle(let lifeEvent) = event {
                    if case .didSetupView = lifeEvent {
                        self.setupConnections()
                        self.viewEventSink = nil
                    }
                }
            }
        )
    }
    
    private func setupConnections() {
        connectionCancellables = [
            view.eventStream.subscribe(presenter.eventScription),
            presenter.actionStream.subscribe(interactor.actionSubscription),
            presenter.modelStream.subscribe(view.modelSubscription),
            interactor.resultStream.subscribe(presenter.resultSubscription)
        ]
        
        connectionCancellables.append(
            view.modelSubscription.receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] model in
                    self?.view.handle(model: model)
                }
            )
        )
        
        connectionCancellables.append(
            presenter.resultSubscription.receive(on: DispatchQueue.global())
                .sink(receiveValue: { [weak self] result in
                    self?.presenter.handle(result: result)
                }
            )
        )
        
        connectionCancellables.append(
            presenter.eventScription.receive(on: DispatchQueue.global())
                .sink(receiveValue: { [weak self] event in
                    self?.presenter.handle(event: event)
                }
            )
        )
        
        connectionCancellables.append(
            interactor.actionSubscription.receive(on: DispatchQueue.global())
                .sink(receiveValue: { [weak self] action in
                    self?.interactor.handle(action: action)
                }
            )
        )
        
        connectionCancellables.append(
            interactor.navigationStream.receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] destination in
                    self?.handle(destination: destination)
                }
            )
        )
        
        let listeners: [ActivationListener] = [presenter, interactor]
        listeners.forEach { $0.didActivateComponent() }
    }
}
