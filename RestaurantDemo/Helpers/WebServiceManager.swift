//
//  WebServiceManager.swift
//  RestaurantDemo
//
//  Created by rajan arora on 11/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import UIKit
import CoreLocation

enum RequestType {
    case Restaurant
}

enum FeedDataType : String{
    case category = "category"
    case restaurants = "restaurants"
}

typealias WebServiceResponse = (([[FeedDataType:Any]]) -> Void)

class WebServiceManager {
    
    private init () {} // Singleton class
    
    private let imageCache = NSCache<NSString,UIImage>()
    private var baseUrl = "https://appgrowthcompany.com:3000"
    private var response : WebServiceResponse?
    
    static var instance = WebServiceManager()
    
    public func performRequest(location:CLLocation,type:RequestType,completionHanlder: @escaping WebServiceResponse) {
        self.response = completionHanlder;
        var urlString : String
        var request : URLRequest
        
        switch type {
        case .Restaurant:
            urlString = baseUrl + "/v1/restaurant/"
            guard let url = URL(string: urlString) else {
                print("Url is not in proper format")
                return
            }
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["latitude":location.coordinate.latitude,"longitude":location.coordinate.longitude], options: .fragmentsAllowed)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("SEC eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZTRlODhjYjc1NmE5NTBlNDRmZWViZWQiLCJpYXQiOjE2MDE1NjQ0OTV9.U-F7L4CxErokbGYPFiMIHZFVfsvga-Hov9cMfknK2MI", forHTTPHeaderField: "authorization")
        }
        
        request.timeoutInterval = 15;
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else if data != nil {
                self.handleResponse(type: type, data: data!)
            }
        }.resume()
    }
    
    private func handleResponse(type:RequestType,data : Data) {
        switch type {
        case .Restaurant:
            handleRestaurantResponse(data: data)
        }
    }
    
    private func handleRestaurantResponse(data: Data) {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            
            let response = jsonData["response"] as! [String:Any]
            let success = response["success"] as! Bool
            var feedArray = [[FeedDataType: Any]]()
            var categories = [CategoryModel]()
            if success {
                let data = jsonData["data"] as! [String:Any]
                let keys = data.keys
                
                for key : String in keys {
                    var restaurants = [RestaurantModel]()
                    if key == "categories" {
                        let categorydata = data[key] as! [[String:Any]]
                        for category in categorydata {
                            let name = category["name"] as! String
                            let image = category["image"] as! String
                            let id = category["_id"] as! String
                            let restaurants = category["restaurants"] as! Int
                            categories.append(CategoryModel(title: name, image: image, id: id, restaurants: restaurants))
                        }
                        feedArray.insert([FeedDataType.category:categories], at: 0)
                    } else if (key == "notiCount") {
                        // nothing
                    }else {
                        let restaurantData = data[key] as! [[String:Any]]
                        for restaurant in restaurantData {
                            let name = restaurant["name"] as! String
                            let image = restaurant["image"] as! String
                            let discount = restaurant["discountUpto"] as! Int
                            let rating = restaurant["ratings"] as! Double
                            let rateCount = restaurant["ratingCount"] as! Int
                            let deliveryTime = restaurant["avgDeliveryTime"] as! Int
                            let currency = restaurant["currency"] as? String ?? ""
                            
                            let categoriesData = restaurant["categories"] as! [[String:String]]
                            var category = [String]()
                            for categoryData in categoriesData {
                                let name = categoryData["name"]!
                                category.append(name)
                            }
                            restaurants.append(RestaurantModel(categoryName: key, name: name, categories: category, image: image, discount: discount, deliveryTime: deliveryTime, rating: rating, currency: currency, rateCount: rateCount))
                        }
                        if !restaurants.isEmpty {
                            feedArray.append([.restaurants:restaurants])
                        }
                    }
                }
                
                self.response?(feedArray)
                
            } else {
                print(response)
            }
            
            
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    /// find the image from cache if find then return that image.
    /// If not find from cache, then load image using URL.
    func downloadImage(url: String, completion: @escaping (UIImage) -> Void) {
        let urlString = baseUrl + url;
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        } else {
            UIImageView().loadImageWithURL(url: urlString) { (image) in
                self.imageCache.setObject(image, forKey: urlString as NSString)
                completion(image)
            }
        }
    }
}

extension UIImageView {
    func loadImageWithURL(url : String,poster : @escaping (UIImage) -> Void ) {
        let Url = URL(string: url)!
        var request = URLRequest(url: Url)
        request.timeoutInterval = 15
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            poster(image)
        }.resume()
    }
}
