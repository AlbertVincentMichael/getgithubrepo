//
//  ViewController.swift
//  mapdrappin
//
//  Created by albert Michael on 13/06/22.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{
    var locationManager : CLLocationManager!
   
    let manager = CLLocationManager()
    
    @IBOutlet private weak var myLabel   : UILabel!
   
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()


            }
        if let coor = mapView.userLocation.location?.coordinate{
               mapView.setCenter(coor, animated: true)
           }
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
     

        let geocoder = CLGeocoder()
       let userLocation:CLLocation = locations[0] as CLLocation
       locationManager.stopUpdatingLocation()
//        let latitude = userLocation.coordinate.latitude
//        let longitude = userLocation.coordinate.longitude

       let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta:0.5)

        let region = MKCoordinateRegion (center:  location,span: span)
        
       geocoder.reverseGeocodeLocation(userLocation){ (placeMarks, error) in
            if (error != nil){
                print("error in reverseGeocodelocation")
            }
            let placemark = placeMarks! as [CLPlacemark]
            if(placemark.count>0){
                let placemark = placeMarks![0]
                let locality = placemark.locality ?? ""
                let house = placemark.subThoroughfare ?? ""
                let street = placemark.thoroughfare ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                self.myLabel.text = "\(house), \(street), \(locality), \(administrativeArea), \(country)"
                LocationClass.sharedInstance.location = "\(house), \(street), \(locality), \(administrativeArea), \(country) "
               
               
            }
           
           
        }
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    }
   
}
