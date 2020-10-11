//
//  ViewController.swift
//  RestaurantDemo
//
//  Created by rajan arora on 10/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: Internal Variables
    var feedArray = [[FeedDataType:Any]]()
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show loading Indicator until load the data
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        
        //Regitser Nibs for table view
        registerNibs()
        
        // Fetch Location
        LocationManager.instance.getLocation { (result) in
            switch result {
            case .success(let location): self.fetchData(location: location)
            case .failure( _):
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    let alertController = UIAlertController(title: "Error", message: "Please provide the location permission from settings", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { (action) in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: Helper Methods
    func registerNibs() {
        // CategoryTableViewCell
        let categoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableView.register(categoryNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        // RestaurantTableviewCell
        let restaurantNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        tableView.register(restaurantNib, forCellReuseIdentifier: "RestaurantTableViewCell")
    }
    
    func  fetchData(location : CLLocation) {
        WebServiceManager.instance.performRequest(location: location, type: .Restaurant) { (response) in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.feedArray = response;
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let feedData = feedArray[indexPath.section]
        let key = feedData.keys.first!
        if key == .category {
            return 200
        } else {
            return 250.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedData = feedArray[indexPath.section]
        let key = feedData.keys.first!
        
        switch key {
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.dataSource = feedData[.category] as? [CategoryModel]
            cell.setupLayout()
            return cell
        case .restaurants:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
            cell.dataSource = feedData[.restaurants] as? [RestaurantModel]
            cell.setupLayout()
            return cell
        }
    }
    
}

