//
//  ViewController.swift
//  JSONFun
//
//  Created by Jordan Conner on 1/20/15.
//  Copyright (c) 2015 Jordan Conner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Handle JSON Stuff
    
    let urlString = "http://www.w3schools.com/website/Customers_MYSQL.php"
    let urlSession = NSURLSession.sharedSession()
    var restaurants : [NSDictionary] = []
    
    // Google Maps Marker Info
    var lat : [Double] = []
    var lng : [Double] = []
    var name : [String] = []
    var snippet : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        jsonW3Schools()
        jsonGeocode()
        googleMaps()
        
    }
    
    func jsonW3Schools() {
        // Handle w3 json
        
        let url = NSURL(string: urlString)!
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as [NSDictionary]
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            self.restaurants = jsonResult
            
            dispatch_async(dispatch_get_main_queue(), {
                //println(jsonResult[0]["Name"]!)
            })
        })
        jsonQuery.resume()
    }
    
    func jsonGeocode() {
        // Handle Geocode JSON to lookup lat/longs
        
        while restaurants.count == 0 {
            // This while loop waits for async call to finish
        }
        
        for var x = 0; x < restaurants.count; x++ {
            let curCity = restaurants[x]["City"] as String
            let curCountry = restaurants[x]["Country"] as String
            let urlString2 = "https://maps.googleapis.com/maps/api/geocode/json?address=\(curCity)+\(curCountry)&key=AIzaSyA9ekAMCuUUdyRUaJQb8VSsWmxyeUrWV6A"
            let urlString2WithEncoding = urlString2.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url2 = NSURL(string: urlString2WithEncoding!)
            var error: NSError?
            
            let jsonDataString = NSString(contentsOfURL: url2!, encoding: NSUTF8StringEncoding, error: &error)
            let jsonData = jsonDataString?.dataUsingEncoding(NSUTF8StringEncoding)
            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error) as NSDictionary
            
            let latString: AnyObject! = jsonDict.valueForKeyPath("results.geometry.location.lat")![0]
            let lngString: AnyObject! = jsonDict.valueForKeyPath("results.geometry.location.lng")![0]
            
            lat.append(latString.doubleValue)
            lng.append(lngString.doubleValue)
            name.append(restaurants[x]["Name"] as String)
            snippet.append("\(curCity), \(curCountry)")
        }
    }
    
    func googleMaps() {
        // Handle Google Maps Stuff
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        for var x = 0; x < lat.count; x++ {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lat[x], lng[x])
            marker.title = name[x]
            marker.snippet = snippet[x]
            marker.map = mapView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

