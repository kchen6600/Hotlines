//
//  FirstViewController.swift
//  Hotlines
//
//  Created by Karen Chen on 6/23/20.
//  Copyright © 2020 Karen Chen. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var MHResources: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var LGBTQResources: UITextView!
    
    
    @IBOutlet weak var youthResources: UITextView!
    
    @IBOutlet weak var sadvResources: UITextView!
    
    @IBOutlet weak var hResources: UITextView!
    
    @IBOutlet weak var suResources: UITextView!
    
    @IBOutlet weak var mResources: UITextView!
    
    let locationManager = CLLocationManager()
    var city : String = "nil"
    var state : String = "nil"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) in
            if (error != nil) {
//                print("Reverse geocoder failed with error " + error!.localizedDescription)
                self.displayLocationInfo(city: "nil")
                    return
                }
            if placemarks!.count > 0 {
                let location = (placemarks?.first)! as CLPlacemark
                self.city = (location.locality)!
                self.state = (location.administrativeArea)!
                self.locationManager.stopUpdatingLocation()
                self.displayLocationInfo(city: self.city)
            }
            else {
                // An error occurred during geocoding.
                self.displayLocationInfo(city: "nil")
//                print("problem with data received from geocoder")
            }
        }
        )
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("Error updating location")
    }
     
    func displayLocationInfo(city : String) {
        if city != "nil" {
            self.locationLabel.text = "\(city)".uppercased()
        }
        else {
             self.locationLabel.text = "GENERAL"
        }
        
        updateText()
    }
    
    func updateResources (city : String, state: String, resourceList: [[String:String]]) -> String {
        var cityList : [[String:String]] = []
        var stateList : [[String:String]] = []
        var nationalList : [[String:String]] = []
        
        for resourceInfo in resourceList {
            let location = resourceInfo["Location"]
            if (location != nil){
                if (location!.contains(",")) {
                    let locationArray = location?.components(separatedBy: ", ")
                    if locationArray![0].dropFirst() == city && locationArray![1].dropLast() == state {
                        cityList.append(resourceInfo)
                    }
                }
                else if (state == location){
                    stateList.append(resourceInfo)
                }
                else if (location == "NATIONAL"){
                    nationalList.append(resourceInfo)
                }
            }
        }
        var resourceText = ""
        for info in cityList{
            resourceText += "\(info["Name"]?.uppercased() ?? "")"
            if (info["Description"] != nil){
                if (info["Description"]!.contains(",")){
                    resourceText += ": \(info["Description"]!.dropFirst().dropLast())"
                }
                else{
                    resourceText += ": \(info["Description"]!)"
                }
            }
            else{
                resourceText += ":"
            }
            resourceText += "\n\(info["Phone Number"] ?? "")\n\n"
        }
        for info in stateList{
            resourceText += "\(info["Name"]?.uppercased() ?? "")"
            if (info["Description"] != nil){
                if (info["Description"]!.contains(",")){
                    resourceText += ": \(info["Description"]!.dropFirst().dropLast())"
                }
                else{
                    resourceText += ": \(info["Description"]!)"
                }
            }
            else{
                resourceText += ":"
            }
            resourceText += "\n\(info["Phone Number"] ?? "")\n\n"
        }
        for info in nationalList{
            resourceText += "* \(info["Name"]?.uppercased() ?? "")"
            if (info["Description"] != nil){
                if (info["Description"]!.contains(",")){
                    resourceText += ": \(info["Description"]!.dropFirst().dropLast())"
                }
                else{
                    resourceText += ": \(info["Description"]!)"
                }
            }
            else{
                resourceText += ":"
            }
            resourceText += "\n\(info["Phone Number"] ?? "")\n\n"
        }
        //self.MHResources.text = resourceText
        return resourceText
        
    }
    
    func updateText(){
        let mhResources = appDelegate.mhResourceInfo
        let lgbtqResources = appDelegate.lgbtqResourceInfo
        let yResources = appDelegate.yResourceInfo
        let sadvResources = appDelegate.sadvResourceInfo
        let hResources = appDelegate.hResourceInfo
        let suResources = appDelegate.suResourceInfo
        let mResources = appDelegate.mResourceInfo
        
        self.MHResources.text = updateResources(city : city, state : state, resourceList : mhResources)
        self.LGBTQResources.text = updateResources(city : city, state : state, resourceList : lgbtqResources)
        self.youthResources.text = updateResources(city : city, state : state, resourceList : yResources)
        self.sadvResources.text = updateResources(city : city, state : state,resourceList : sadvResources)
        self.hResources.text = updateResources(city : city, state : state, resourceList : hResources)
        self.suResources.text = updateResources(city : city, state : state, resourceList : suResources)
        self.mResources.text = updateResources(city : city, state : state, resourceList : mResources)
        
        UITextView.appearance().linkTextAttributes = [.underlineStyle: 0, .underlineColor: UIColor.clear, .foregroundColor: UIColor.blue ]
    }
    
}
