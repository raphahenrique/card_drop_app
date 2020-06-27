//
//  ShareCardViewController.swift
//  CardDrop
//
//  Created by Raphael Henrique on 6/27/20.
//  Copyright © 2020 TBD-patrichel. All rights reserved.
//

import UIKit

class ShareCardViewController: UIViewController {

    var backgroundImage: UIImage?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = backgroundImage else { return }
        
        backgroundImageView.image = image
        
    
        
    }
    
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        _ = containerView.subviews.filter({ (view) -> Bool in
            if view is UIButton {
                return true
            }
            return false
        }).map({$0.isHidden = true})
        
        let image = self.view.screenshot()
        
        _ = containerView.subviews.filter({ (view) -> Bool in
            if view is UIButton {
                return true
            }
            return false
        }).map({$0.isHidden = false})
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
    }
    

}

extension UIView {
    
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { (_) in
            
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
            
        }
        
    }
}
