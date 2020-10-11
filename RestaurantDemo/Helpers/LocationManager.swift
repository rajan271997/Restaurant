//
//  LocationManager.swift
//  RestaurantDemo
//
//  Created by rajan arora on 11/10/20.
//  Copyright © 2020 rajan arora. All rights reserved.
//

import Foundation
import CoreLocation


typealias LocationHandler = (Result<CLLocation,Error>) -> Void

// This class is used to fectch the user current location
class LocationManager: NSObject,CLLocationManagerDelegate {
    
    private override init() {}
    
    static var instance = LocationManager()
    var locationHandler : LocationHandler?
    
    private var locationManager = CLLocationManager()
    
    func getLocation(locationHandler : @escaping LocationHandler) {
        self.locationHandler = locationHandler
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        self.locationHandler?(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        if CLLocationManager.authorizationStatus() == .denied {
            self.locationHandler?(.failure(error))
        }
    }
}
