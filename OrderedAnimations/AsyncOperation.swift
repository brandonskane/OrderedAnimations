//
//  AsyncOperation.swift
//  OrderedAnimations
//
//  Created by Brandon S. Kane on 2/20/17.
//  Copyright © 2017 Brandon S. Kane. All rights reserved.
//

import Foundation

class AsyncOperation : Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    
    fileprivate var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    fileprivate var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override func start() {
        _executing = true
        execute()
    }
    
    func execute() {
        fatalError("You must override this")
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
}
