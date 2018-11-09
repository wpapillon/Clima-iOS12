//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    let locationManager = CLLocationManager()
    let weatherModel = WeatherDataModel();
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String, param: [String:String])
    {
        Alamofire.request(url, method: .get, parameters: param).responseJSON { (response) in
            if response.result.isSuccess{
                let weather : JSON = JSON(response.result.value!)
                self.updateWeatherData(weatherData:weather)
            }
            else{
                 self.cityLabel.text = "Weather Data Unavailable"
            }
           
            
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(weatherData : JSON){
        if let temp = weatherData["main"]["temp"].double{
        weatherModel.temperature = Int(temp - 273.15)
        weatherModel.city = weatherData["name"].stringValue
        weatherModel.condition = weatherData["weather"][0]["id"].intValue
            updateUIWithWeatherData()
        }
        else{
            cityLabel.text = "data error"
        }
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(){
        temperatureLabel.text = String(weatherModel.temperature)
        cityLabel.text = weatherModel.city
        weatherIcon.image = UIImage(named: weatherModel.updateWeatherIcon(condition: weatherModel.condition))
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
      
            let param : [String:String] = ["lat":String(location.coordinate.latitude),"lon":String(location.coordinate.longitude), "appid":APP_ID]
            
           getWeatherData(url: WEATHER_URL, param: param)
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


