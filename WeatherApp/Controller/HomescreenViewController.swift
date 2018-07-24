//
//  ViewController.swift
//  WeatherApp
//
//  Created by Johnny Young on 7/22/18.
//  Copyright © 2018 Johnny Young. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class HomescreenViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    @IBOutlet weak var changeCityButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var tempertureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let openWeatherMapService = OpenWeatherMap()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = "\(location.coordinate.latitude)"
            let longitude = "\(location.coordinate.longitude)"
            let openWeatherMapParameters: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : openWeatherMapService.apiKey]
            
            getWeatherData(url: openWeatherMapService.weatherURL, parameters: openWeatherMapParameters)
        
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getWeatherData(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success:
                guard let value = response.result.value else { return }
                let weatherJSON = JSON(value)
                print(weatherJSON)
                self.parseWeatherData(json: weatherJSON)
            case .failure:
                guard let weatherError = response.result.error else { return }
                print("Error: \(weatherError)")
            }
        }
    }
    func parseWeatherData(json: JSON) {

        guard let tempertureResults = json["main"]["temp"].double else { return cityLabel.text = "Weather Unavailable"}
        weatherDataModel.temperture = Int((tempertureResults * 9/5) - 459.67)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.weatherConditionString = json["weather"][0]["description"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherBackgroundName = weatherDataModel.updateWeatherBackground(condition: weatherDataModel.condition)
        updateUserInterface()
    }
    
    func updateUserInterface() {
        
        backgroundImage.image = UIImage(named: weatherDataModel.weatherBackgroundName)
        conditionsLabel.text = weatherDataModel.weatherConditionString
        tempertureLabel.text = "\(weatherDataModel.temperture)°"
        cityLabel.text = weatherDataModel.city
    }
    
    func userDidEnterNew(city: String) {
        let newCityParameters : [String : String ] = ["q" : city, "appid": openWeatherMapService.apiKey]
        getWeatherData(url: openWeatherMapService.weatherURL, parameters: newCityParameters)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCitySegue" {
            guard let changeCityViewController = segue.destination as? ChangeCityViewController else { return }
            changeCityViewController.delegate = self
        }
    }
}



