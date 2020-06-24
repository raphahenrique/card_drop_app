//
//  ImageSelectionViewController.swift
//  CardDrop
//
//  Created by Raphael Henrique on 6/24/20.
//  Copyright © 2020 TBD-patrichel. All rights reserved.
//

import UIKit

class ImageSelectionViewController: UIViewController {

    
    var image: UIImage?
    var category: Category?
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = image, let availableCategory = category {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
        
    }
    

}

extension ImageSelectionViewController: Scalling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        
        
        return initialImageView
    
    }
    
    
    
    
}
