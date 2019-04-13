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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=92127,us&units=imperial&appid=77d981ff25dd24409bb6a0ff411e69d9") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {return}
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any] else {return}
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let description = (weatherDetails.first?["main"] as? String)?.capitalizingFirstLetter()
                    let humidity = Int(weatherMain["humidity"] as? Double ?? 0)
                    let wind = Int(weatherMain["wind"] as? Double ?? 0)
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp, humidity: humidity, wind: wind)
                    }
                } catch {
                    print("We had an error retriving the weather...")
                }
            }
        }
        task.resume()
    }
    func setWeather(weather: String?, description: String?, temp: Int, humidity: Int, wind: Int) {
        weatherDescriptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp)˚"
        humitidyLabel.text = "Humidity: \(humidity)%"
        windLabel.text = "Wind: \(wind) MPH"
        switch weather {
        case "Sunny":
            weatherImageView.image = UIImage(named: "String")
            background.backgroundColor = UIColor(red: 242, green: 247, blue: 42, alpha: 1)
        default:
            weatherImageView.image = UIImage(named: "Cloudy")
            background.backgroundColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
