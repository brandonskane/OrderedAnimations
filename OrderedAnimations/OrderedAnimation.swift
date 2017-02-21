//
//  OrderedAnimation.swift
//  OrderedAnimations
//
//  Created by Brandon S. Kane on 2/20/17.
//  Copyright © 2017 Brandon S. Kane. All rights reserved.
//

import Foundation
import UIKit

typealias Animation = () -> ()
typealias AnimationComplete = () -> ()

class OrderedAnimation: NSObject {
    
    private let operationQueue = OperationQueue()
    
    override init() {
        super.init()
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func addAnimation(duration: TimeInterval, options: UIViewAnimationOptions? = nil, animation: @escaping Animation) {
        operationQueue.addOperation(AnimationOperation(duration: duration,
                                                       options: options,
                                                       animation: animation))
    }
    
    func addCompletion(animationComplete: @escaping AnimationComplete) {
        let operation = BlockOperation()
        operation.addExecutionBlock {
            animationComplete()
        }
    }
    
    func addWait(duration: TimeInterval) {
        operationQueue.addOperation(WaitOperation(waitDuration: duration))
    }
    
    func clearRemainingAnimations() {
        guard operationQueue.operations.count > 0 else { return }
        operationQueue.cancelAllOperations()
    }
}

class WaitOperation: AsyncOperation {
    var waitDuration: TimeInterval
    
    init(waitDuration: TimeInterval) {
        self.waitDuration = waitDuration
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration) {
            self.finish()
        }
    }
}

class AnimationOperation: AsyncOperation {
    
    var animation: Animation
    var duration: TimeInterval
    var options: UIViewAnimationOptions
    
    init(duration: TimeInterval, options: UIViewAnimationOptions? = nil, animation: @escaping () -> ()) {
        self.animation = animation
        self.duration = duration
        if let options = options {
            self.options = options
        }
        else {
            self.options = []
        }
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.duration,
                           delay: 0.0,
                           options: options,
                           animations: self.animation) { (_) in
                            self.finish()
            }
        }
    }
}
