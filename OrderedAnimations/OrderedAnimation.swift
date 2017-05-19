//
//  OrderedAnimation.swift
//  OrderedAnimations
//
//  Created by Brandon S. Kane on 2/20/17.
//  Copyright © 2017 Brandon S. Kane. All rights reserved.
//

import Foundation
import UIKit

public typealias Handler = () -> ()

open class OrderedAnimation: NSObject {
    
    fileprivate let operationQueue = OperationQueue()
    
    public override init() {
        super.init()
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    open func addAnimation(duration: TimeInterval, options: UIViewAnimationOptions? = nil, animation: @escaping Handler) {
        operationQueue.addOperation(AnimationOperation(duration: duration,
                                                       options: options,
                                                       animation: animation))
    }
    
    open func addSpringAnimation(duration: TimeInterval, options: UIViewAnimationOptions? = nil, damping: CGFloat, springVelocity: CGFloat, animation: @escaping Handler) {
        operationQueue.addOperation(SpringAnimationOperation(duration: duration,
                                                             options: options,
                                                             damping: damping,
                                                             springVelocity: springVelocity,
                                                             animation: animation))
    }
    
    open func addCompletion(_ animationComplete: @escaping Handler) {
        let completionOperation = BlockOperation()
        completionOperation.addExecutionBlock {
            guard !completionOperation.isCancelled else { return }
            animationComplete()
        }
        operationQueue.addOperation(completionOperation)
    }
    
    open func addWait(_ duration: TimeInterval) {
        operationQueue.addOperation(WaitOperation(waitDuration: duration))
    }
    
    open func clearRemainingAnimations() {
        guard operationQueue.operations.count > 0 else { return }
        operationQueue.cancelAllOperations()
    }
    
    open func pauseUnrunAnimations() {
        operationQueue.isSuspended = true
    }
    
    open func resumeUnrunAnimations() {
        operationQueue.isSuspended = false
    }
}

class WaitOperation: AsyncOperation {
    var waitDuration: TimeInterval
    
    init(waitDuration: TimeInterval) {
        self.waitDuration = waitDuration
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return(finish()) }
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration) {
            self.finish()
        }
    }
}

class AnimationOperation: AsyncOperation {
    
    var animation: Handler
    var duration: TimeInterval
    var options: UIViewAnimationOptions
    
    init(duration: TimeInterval, options: UIViewAnimationOptions? = nil, animation: @escaping () -> ()) {
        self.animation = animation
        self.duration = duration
        if let options = options {
            self.options = options
        } else {
            self.options = []
        }
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return(finish()) }
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.duration,
                           delay: 0.0,
                           options: self.options,
                           animations: self.animation) { (_) in
                            self.finish()
            }
        }
    }
}

class SpringAnimationOperation: AsyncOperation {
    
    var animation: Handler
    var duration: TimeInterval
    var options: UIViewAnimationOptions
    var damping: CGFloat
    var springVelocity: CGFloat
    
    init(duration: TimeInterval, options: UIViewAnimationOptions? = nil, damping: CGFloat, springVelocity: CGFloat, animation: @escaping () -> ()) {
        self.animation = animation
        self.duration = duration
        if let options = options {
            self.options = options
        } else {
            self.options = []
        }
        self.damping = damping
        self.springVelocity = springVelocity
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return(finish()) }
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.duration,
                           delay: 0.0,
                           usingSpringWithDamping: self.damping,
                           initialSpringVelocity: self.springVelocity,
                           options: self.options,
                           animations: self.animation,
                           completion: { (_) in
                            self.finish()
            })
        }
    }
}
