//
//  ViperView.swift
//  Viper
//
//  Created by Asad Rana on 3/26/20.
//  Copyright © 2020 anrana. All rights reserved.
//

import Foundation
import Combine

public enum ViewEvent<E> {
    case lifeCycle(LifeCycleEvent)
    case custom(E)
}

public enum LifeCycleEvent {
    case didSetupView
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
}

public protocol ViperView {
    associatedtype Model
    associatedtype Event
    
    var modelSubscription: PassthroughSubject<Model, Never> { get }
    var eventStream: PassthroughSubject<ViewEvent<Event>, Never> { get }
    
    func handle(model: Model)
}
