//
//  CategoryModel.swift
//  RestaurantDemo
//
//  Created by rajan arora on 10/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import Foundation

struct CategoryModel {
    var title : String
    var image : String
    var id : String
    var restaurants : Int
}

struct RestaurantModel {
    var categoryName : String
    var name : String
    var categories : [String]
    var image : String
    var discount : Int
    var deliveryTime : Int
    var rating : Double
    var currency : String
    var rateCount : Int
}
