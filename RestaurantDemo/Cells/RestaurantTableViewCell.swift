//
//  RestaurantTableViewCell.swift
//  RestaurantDemo
//
//  Created by rajan arora on 11/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    var dataSource : [RestaurantModel]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let nib = UINib(nibName: "RestaurantCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "RestaurantCollectionViewCell")
        collectionView.dataSource = self;
        collectionView.delegate = self;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout() {
        let restaurant = dataSource[0]
        categoryLabel.text = getTitle(restaurant.categoryName)
        collectionView.reloadData()
    }
    
    func getTitle(_ fromKey: String) -> String {
        switch fromKey {
        case "bestOffers":
            return "Best Offers"
        case "recommended":
            return "Recommended"
        case "saved":
            return "Saved Restaurants"
        default:
            return fromKey
        }
    }
    
}

extension RestaurantTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCollectionViewCell", for: indexPath) as? RestaurantCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.dataSource = dataSource[indexPath.row]
        cell.setupLayout()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 1.8, height: collectionView.bounds.size.height)
    }
    
}
