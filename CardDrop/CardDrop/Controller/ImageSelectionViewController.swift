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
    
    let imageRequest = DataRequest<Image>(dataSource: "Images")
    var images = [Image]()
    
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dimmedView: UIView!
    
    var currentScrollPagee = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.alpha = 0
        dimmedView.alpha = 0
        
        self.scrollView.delegate = self
        
        if let availableImage = image, let availableCategory = category {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    func loadData() {
        imageRequest.getData { [ weak self] data in
            switch data {
            case .failure:
                print("could not load img")
            case .success(let images):
                self?.images = images
                DispatchQueue.main.async {
                    self?.setupUI()
                }
                
            }
        }
    }
    
    
    func setupUI() {
        
        UIView.animate(withDuration: 0.5) {
            self.closeButton.alpha = 1
            self.dimmedView.alpha = 1
        }
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(images.count + 1)
        
        for (i, image) in images.enumerated() {
            
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: nil, options: nil)?.first as? PhotoView else { return }
            
            photoView.frame = frame
            photoView.imageView.image = UIImage(named: image.imageName)
            photoView.descriptionLabel.text = image.description
            photoView.photographerLabel.text = image.photographer
            
            scrollView.addSubview(photoView)
        }
        
        
    }
    
    @objc
    func didTapScreen() {
        self.performSegue(withIdentifier: "showCard", sender: self)
    }
    
    
    @IBAction func didTapClose(_ sender: UIButton) {
    
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.dimmedView.alpha = 0
                sender.alpha = 0
            }) { _ in
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showCard" {
            guard let sendCardVC = segue.destination as? ShareCardViewController else { return }
            if currentScrollPagee == 0 {
                currentScrollPagee = 1
            }
            guard let imageSelected = UIImage(named: images[currentScrollPagee - 1].imageName) else { return }
            
            sendCardVC.backgroundImage = imageSelected
            sendCardVC.modalTransitionStyle = .crossDissolve
            
        }
    }
    

}

extension ImageSelectionViewController: Scalling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        
        
        return initialImageView
    
    }
 
}

extension ImageSelectionViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentScrollPagee = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
