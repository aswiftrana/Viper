//
//  ViperPresenter.swift
//  Viper
//
//  Created by Asad Rana on 3/26/20.
//  Copyright © 2020 anrana. All rights reserved.
//

import Foundation
import Combine

public protocol ViperPresenter: ActivationListener {
    associatedtype Model
    associatedtype Event
    associatedtype Action
    associatedtype Result
    
    var actionStream: PassthroughSubject<Action, Never> { get }
    var resultSubscription: PassthroughSubject<Result, Never> { get }
    var modelStream: PassthroughSubject<Model, Never> { get }
    var eventScription: PassthroughSubject<ViewEvent<Event>, Never> { get }
    
    func handle(result: Result)
    func handle(event: ViewEvent<Event>)
}
