//
//  ViewController.swift
//  Sample
//
//  Created by Brandon S. Kane on 2/21/17.
//  Copyright © 2017 Brandon S. Kane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    let orderedAnimation = OrderedAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func down(_ sender: Any) {
        orderedAnimation.addAnimation(duration: 2.0) { 
            self.topConstraint.constant = 100
            self.boxView.backgroundColor = .gray
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func up(_ sender: Any) {
        orderedAnimation.addSpringAnimation(duration: 1.5, options: .curveEaseInOut, damping: 0.9, springVelocity: 0.3) {
            self.topConstraint.constant = 16
            self.boxView.backgroundColor = .red
            self.view.layoutIfNeeded()
        }
        orderedAnimation.addCompletion {
            print("We're back at the top")
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        orderedAnimation.clearRemainingAnimations()
    }
    
    @IBAction func pause(_ sender: Any) {
        orderedAnimation.pauseUnrunAnimations()
    }
    
    @IBAction func resume(_ sender: Any) {
        orderedAnimation.resumeUnrunAnimations()
    }
}

