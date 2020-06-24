//
//  OverviewCollectionViewController.swift
//  CardDrop
//
//  Created by Raphael Henrique on 6/24/20.
//  Copyright © 2020 TBD-patrichel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class OverviewCollectionViewController: UICollectionViewController {

    let categoryDataRequest = DataRequest<Category>(dataSource: "Categories")
    var categoryData = [Category]()
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func loadData() {
        categoryDataRequest.getData{ [weak self] dataResult in
            
            switch dataResult {
            case .failure:
                print("Could not load")
            case .success(let categories):
                self?.categoryData = categories
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSelectionSegue" {
            if let category = sender as? Category {
                guard let image = UIImage(named: category.categoryImageName) else { return }
                
                if let imageSelectionVC = segue.destination as? ImageSelectionViewController {
                    imageSelectionVC.image = image
                    imageSelectionVC.category = category
                    
                }
            }
            
        }
    }
    
}

 
extension OverviewCollectionViewController {
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { fatalError("unable load cell") }
    
        let category = categoryData[indexPath.row]
        
        guard let image = UIImage(named: category.categoryImageName) else { fatalError("unable load image") }
        
        cell.backgroundImageView.image = image
        cell.categoryLabel.text = category.categoryName
    
        return cell
    }
}

extension OverviewCollectionViewController {
        
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = categoryData[indexPath.row]
        
        selectedIndexPath = indexPath
        
        self.performSegue(withIdentifier: "ImageSelectionSegue", sender: category)
        
    }

}

extension OverviewCollectionViewController: UICollectionViewDelegateFlowLayout {
        
    // MARK: UICollectionView Layout Delegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
   

}

extension OverviewCollectionViewController: Scalling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        
        if let indexPath = selectedIndexPath {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return nil }
            
            return cell.backgroundImageView
            
        }
        
        return nil
        
    }
    
    
    
    
    
    
}
