//
//  ViewController.swift
//  JSONFun
//
//  Created by Jordan Conner on 1/20/15.
//  Copyright (c) 2015 Jordan Conner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Handle JSON Stuff
        
        let urlString = "http://www.w3schools.com/website/Customers_MYSQL.php"
        let url = NSURL(string: urlString)!
        let urlSession = NSURLSession.sharedSession()
        var restaurants : [NSDictionary] = []
        var lat : [Double] = []
        var long : [Double] = []
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as [NSDictionary]
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            // Print # of objects in our json result dictionary array
            //println(jsonResult.count)
            restaurants = jsonResult
            
            dispatch_async(dispatch_get_main_queue(), {
                //println(jsonResult[0]["Name"]!)
                //println(jsonResult[0]["City"]!)
                //println(jsonResult[0]["Country"]!)
            })
        })
        jsonQuery.resume()
        
        
        
        
        
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
            
            //println(jsonDataString)
            let jsonData = jsonDataString?.dataUsingEncoding(NSUTF8StringEncoding)
            
            var error2: NSError?
            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error2) as NSDictionary
            println(jsonDict["results"])
            // TODO PARSE OUT THE LAT AND LONGS INTO PARALLEL ARRAYS TO LATER USE FOR GOOGLE MAP PINS
        }
        
        
        
        
        
        
        // Handle Google Maps Stuff
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

