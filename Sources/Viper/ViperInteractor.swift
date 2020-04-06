//
//  ViperInteractor.swift
//  Viper
//
//  Created by Asad Rana on 3/26/20.
//  Copyright © 2020 anrana. All rights reserved.
//

import Foundation
import Combine

public protocol ViperInteractor: ActivationListener {
    associatedtype Action
    associatedtype Result
    associatedtype Destination

    var actionSubscription: PassthroughSubject<Action, Never> { get }
    var resultStream: PassthroughSubject<Result, Never> { get }
    var navigationStream: PassthroughSubject<Destination, Never> { get }
    
    func handle(action: Action)
}
