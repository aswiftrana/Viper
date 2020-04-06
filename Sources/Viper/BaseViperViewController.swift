//
//  BaseViperViewController.swift
//  Viper
//
//  Created by Asad Rana on 3/26/20.
//  Copyright © 2020 anrana. All rights reserved.
//

import Foundation
import Combine
import UIKit

open class BaseViperViewController<M, E>: UIViewController, ViperView {
    public typealias Model = M
    public typealias Event = E

    public var modelSubscription = PassthroughSubject<M, Never>()
    public var eventStream = PassthroughSubject<ViewEvent<E>, Never>()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventStream.send(.lifeCycle(.viewWillAppear))
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventStream.send(.lifeCycle(.viewDidAppear))
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventStream.send(.lifeCycle(.viewWillDisappear))
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        eventStream.send(.lifeCycle(.viewWillDisappear))
    }
    
    open func handle(model: M) {
        fatalError("Subclass must implement handle(model:)")
    }
}
