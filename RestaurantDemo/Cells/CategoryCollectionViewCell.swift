//
//  CategoryCollectionViewCell.swift
//  RestaurantDemo
//
//  Created by rajan arora on 10/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    var dataSource : CategoryModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        categoryTitle.text = dataSource.title + "(\(dataSource.restaurants))"
        WebServiceManager.instance.downloadImage(url: dataSource.image, completion: { (image) in
            DispatchQueue.main.async {
            self.categoryImageView.image = image;
            }
        })
    }

}
