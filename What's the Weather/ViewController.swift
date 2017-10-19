//
//  ViewController.swift
//  What's the Weather
//
//  Created by Christian Alvarez on 09/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var weatherText: UILabel!
    let cityList: [String] = ["Manila", "New York", "London", "Tokyo", "Sydney"]
    var weatherData: [String: Any]?
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var string = cityList[row]
        string = string.replacingOccurrences(of: " ", with: "")
        loadData(from: getURL(with: string)!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func getURL(with city: String) -> URL? {
        let webAddress = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=e539700379953cad19f56981ef0bf4a6"
        return URL(string: webAddress)
    }
    
    
    func loadData(from url:URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error creating task.")
            } else {
                if let data = data {
                    do {
                        self.weatherData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                        print("Name: \(self.weatherData!["name"]!)")
                        
                        var textToDisplay = self.weatherData!["name"]! as! String

                        let coord = self.weatherData!["coord"] as! [String: Any]
                        let longitude = coord["lon"]!
                        let latitude = coord["lat"]!
                        textToDisplay.append("\nLongitude: \(longitude)")
                        textToDisplay.append("\nLatitude: \(latitude)")
                        
                        let weather = self.weatherData!["weather"] as! [[String: Any]]
                        let main = weather[0]["main"]!
                        let description = weather[0]["description"]!
                        textToDisplay.append("\nWeather: \(main)")
                        textToDisplay.append("\nDescription: \(description)")
                        
                        let mainStats = self.weatherData!["main"] as! [String: Any]
                        let temp = mainStats["temp"]!
                        let pressure = mainStats["pressure"]!
                        let humidity = mainStats["humidity"]!
                        let tempMin = mainStats["temp_min"]!
                        let tempMax = mainStats["temp_max"]!
                        textToDisplay.append("\nTemperature: \(temp)")
                        textToDisplay.append("\nPressure: \(pressure)")
                        textToDisplay.append("\nHumidity: \(humidity)")
                        textToDisplay.append("\nMin. Temperature: \(tempMin)")
                        textToDisplay.append("\nMax. Temperature: \(tempMax)")
                        
                        
                        DispatchQueue.main.sync {
                            self.weatherText.text = textToDisplay
                        }
                    } catch let err as NSError {
                        print("Error serializing data \(err)")
                    }
                }
            }
        }
        task.resume()
    }
    
    
 
    
    
}
