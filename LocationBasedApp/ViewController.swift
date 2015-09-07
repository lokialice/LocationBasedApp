//
//  ViewController.swift
//  LocationBasedApp
//
//  Created by Macbook Pro MD102 on 6/2/15.
//  Copyright (c) 2015 Macbook Pro MD102. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet var mapView: MKMapView!
    var lm:CLLocationManager = CLLocationManager()
    var anotation:MKPointAnnotation = MKPointAnnotation()
    var geoCoder = CLGeocoder()
    var location:CLLocation?
    @IBAction func showLocation(sender: UIButton) {
        if let location = location {
            geoCoder.reverseGeocodeLocation(location, completionHandler: {
                placeMarks, error in
                if error == nil && !placeMarks.isEmpty {
                    var placeMark = placeMarks.last as! CLPlacemark
                    var locationString = "\(placeMark.locality) \(placeMark.postalCode),\(placeMark.country)"
                    self.anotation.subtitle = locationString
                }
            })
        }
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        var region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        anotation.title = "I am here!"
        anotation.coordinate = newLocation.coordinate
        mapView.showAnnotations([anotation], animated: true)
        location = newLocation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let authStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            lm.requestWhenInUseAuthorization()
            
        }
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = kCLDistanceFilterNone
        lm.startUpdatingLocation()
        mapView.mapType = MKMapType.Hybrid
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

