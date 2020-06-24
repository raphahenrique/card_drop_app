//
//  ScaleTransitioningDelegate.swift
//  CardDrop
//
//  Created by Raphael Henrique on 6/24/20.
//  Copyright © 2020 TBD-patrichel. All rights reserved.
//

import UIKit

protocol Scalling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView?
}

enum TransitionState {
    case begin
    case end
}

class ScaleTransitioningDelegate: NSObject {

    let animationDuration = 0.5

    var navigationControllerOperation: UINavigationController.Operation = .none
}

extension ScaleTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        var backgroundVC = fromVC
        var foregroundVC = toVC
        
        if navigationControllerOperation == .pop {
            backgroundVC = toVC
            foregroundVC = fromVC
        }
        
        guard let backgroundImageView = (backgroundVC as? Scalling)?.scalingImageView(transition: self) else { return }
        guard let foregroundImageView = (foregroundVC as? Scalling)?.scalingImageView(transition: self) else { return }
     
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true
        
        if self.navigationControllerOperation == .pop {
            imageViewSnapshot.layer.cornerRadius = 8
        }
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundBGColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
        
        var transitionStateA = TransitionState.begin
        var transitionStateB = TransitionState.end
        
        if navigationControllerOperation == .pop {
            transitionStateA = .end
            transitionStateB = .begin
            
        }
        
        
        prepareViews(for: transitionStateA, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshoteImageView: imageViewSnapshot)
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            
            self.prepareViews(for: transitionStateB, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshoteImageView: imageViewSnapshot)
            
        }) { _ in
            
            backgroundVC.view.transform = .identity
            imageViewSnapshot.removeFromSuperview()
            
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            
            foregroundVC.view.backgroundColor = foregroundBGColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
    
    func prepareViews( for state: TransitionState, containerView: UIView, backgroundVC: UIViewController, backgroundImageView: UIImageView, foregroundImageView: UIImageView, snapshoteImageView: UIImageView) {
        
        switch state {
        case .begin:
            backgroundVC.view.transform = .identity
            backgroundVC.view.alpha = 1
            
            snapshoteImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
            
        case .end:
            backgroundVC.view.alpha = 0
            snapshoteImageView.frame = containerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
        }
        
    }
    
}


extension ScaleTransitioningDelegate: UINavigationControllerDelegate  {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is Scalling && toVC is Scalling {
            self.navigationControllerOperation = operation
            
            let navBarVisible = operation == .pop
            navigationController.setNavigationBarHidden(!navBarVisible, animated: true)
            
            return self
        } else {
            return nil
        }
        
    }
    
}
