//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kian Chakamian on 4/6/19.
//  Copyright © 2019 Kian Chakamian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var humitidyLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=92127,us&units=imperial&appid=77d981ff25dd24409bb6a0ff411e69d9") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {return}
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any], let weatherWind = json["wind"] as? [String : Any] else {return}
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let description = (weatherDetails.first?["main"] as? String)?.capitalizingFirstLetter()
                    let humidity = Int(weatherMain["humidity"] as? Double ?? 0)
                    let windSpeed = Int(weatherWind["speed"] as? Double ?? 0)
                    let windDirection = Int(weatherWind["deg"] as? Double ?? 0)
                    let low = Int(weatherMain["temp_min"] as? Double ?? 0)
                    let high = Int(weatherMain["temp_max"] as? Double ?? 0)
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, low: low, high: high)
                    }
                } catch {
                    print("We had an error retriving the weather...")
                }
            }
        }
        task.resume()
    }
    //MARK SET WEATHER
    func setWeather(weather: String?, description: String?, temp: Int, humidity: Int, windSpeed: Int, windDirection: Int, low: Int, high: Int) {
        weatherDescriptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp)˚"
        humitidyLabel.text = "Humidity: \(humidity)%"
        windLabel.text = "Wind: \(windSpeed) MPH \(compassDirection(heading: Double(windDirection)))"
        lowLabel.text = "Low: \(low)˚"
        highLabel.text = "High: \(high)˚"
        switch weather {
        case "Sunny":
            weatherImageView.image = UIImage(named: "String")
            background.backgroundColor = UIColor(red: 242, green: 247, blue: 42, alpha: 1)
        case "Partly Cloudy"
        default:
            weatherImageView.image = UIImage(named: "Cloudy")
            background.backgroundColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
    }
}
//MARK: FUNCTIONS
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
func compassDirection(heading: Double) -> String {
    if heading < 0 { return "" }
    
    let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    let index = Int((heading + 22.5) / 45.0) & 7
    return directions[index]
}
