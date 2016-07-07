//
//  ViewController.swift
//  WeatherNYC
//
//  Created by Erica Correa on 5/24/16.
//  Copyright © 2016 Turn to Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let apiKey = "c09a6b049f8b4c5bb6e821c087622066"
    var url = "http://api.openweathermap.org/data/2.5/weather?q=New+York&units=imperial"
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func refreshWeather(sender: AnyObject) {
        
        let url = NSURL(string: "\(self.url)&appid=\(self.apiKey)")!

        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let myData:NSData = data, let _:NSURLResponse = response where error == nil
                else { return }
            
            let decodedJson:AnyObject
            
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(myData, options: [])
            } catch {
                print("Something went wrong")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                let temperature = Double(decodedJson["main"]?!["temp"]! as! NSNumber!)
                self.temperatureLabel.text = "\(temperature)"
                
                let weatherTypes = decodedJson["weather"]!! as! [AnyObject]
                let weatherDictionary = weatherTypes.first
                let weatherType = weatherDictionary!["main"]!
                
                self.imageBackground.image = UIImage(named: weatherType as! String)
            })
        }
        task.resume()
    }
    

}

