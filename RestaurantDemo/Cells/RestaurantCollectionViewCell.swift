//
//  RestaurantCollectionViewCell.swift
//  RestaurantDemo
//
//  Created by rajan arora on 11/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    var dataSource : RestaurantModel!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupLayout() {
        nameLabel.text = dataSource.name
        categoryLabel.text = dataSource.categories.joined(separator: ",")
        ratingLabel.text = "* \(dataSource.rating) (\(dataSource.rateCount))"
        averageTimeLabel.text = "\(dataSource.deliveryTime) min"
        currencyLabel.text = dataSource.currency
        WebServiceManager.instance.downloadImage(url: dataSource.image) { (image) in
            DispatchQueue.main.async {
                self.restaurantImageView.image = image
            }
            
        }
    }

}
