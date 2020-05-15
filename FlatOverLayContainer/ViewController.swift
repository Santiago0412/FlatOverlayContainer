//
//  ViewController.swift
//  FlatOverLayContainer
//
//  Created by Santiago on 2020/5/15.
//  Copyright © 2020 Santiago. All rights reserved.
//

import UIKit

enum OverlayViewState {
    case overlay
    case dismiss
}

class ViewController: UIViewController {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayViewBottomConstrains: NSLayoutConstraint!
    
    struct Constant {
        static let minY: CGFloat = 300
        static let maxY: CGFloat = 834
        static let middleY: CGFloat = (minY + maxY)/2
        static let offSetTouch: CGFloat = 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var marginValue: CGFloat = 0
    @IBAction func viewDragged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let wholeChangeY = marginValue + translation.y
        switch gesture.state {
        case .began:
            marginValue = overlayViewBottomConstrains.constant
            
        case .changed:
            if wholeChangeY > Constant.minY && wholeChangeY < Constant.maxY {
                overlayViewBottomConstrains.constant = wholeChangeY
            }
            
        case .ended:
            if marginValue - wholeChangeY < -Constant.offSetTouch {
                updateSubviewStates(state: .dismiss)
                return
            }
            
            if marginValue - wholeChangeY > Constant.offSetTouch {
                updateSubviewStates(state: .overlay)
                return
            }
            
            if Constant.middleY < wholeChangeY && wholeChangeY < Constant.maxY {
                updateSubviewStates(state: .dismiss)
            }
            if Constant.minY < wholeChangeY && wholeChangeY < Constant.middleY {
                updateSubviewStates(state: .overlay)
            }
            
        default:
            break
        }
    }
    
    fileprivate func updateSubviewStates(state: OverlayViewState) {
        switch state {
        case .overlay:
            self.updateConstraitsWithAnimation(constant: Constant.minY)
        case .dismiss:
            self.updateConstraitsWithAnimation(constant: Constant.maxY)
        }
    }
    
    fileprivate func updateConstraitsWithAnimation(constant: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.overlayViewBottomConstrains.constant = constant
            self.view.layoutIfNeeded()
        })
    }
}
