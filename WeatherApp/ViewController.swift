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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var backgroundtwo: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var place: UILabel!
    
    func getWeather(loc: String) {
        let location = loc
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(location)&units=imperial&appid=77d981ff25dd24409bb6a0ff411e69d9") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {return}
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any], let weatherWind = json["wind"] as? [String : Any], let weatherSystem = json["sys"] as? [String : Any]else {return}
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let description = (weatherDetails.first?["main"] as? String)?.capitalizingFirstLetter()
                    let humidity = Int(weatherMain["humidity"] as? Double ?? 0)
                    let windSpeed = Int(weatherWind["speed"] as? Double ?? 0)
                    let windDirection = Int(weatherWind["deg"] as? Double ?? 0)
                    let low = Int(weatherMain["temp_min"] as? Double ?? 0)
                    let high = Int(weatherMain["temp_max"] as? Double ?? 0)
                    let city = (json["name"] ?? "...")
                    let country = (weatherSystem["country"] ?? "...")
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, low: low, high: high, city: city, country: country)
                    }
                } catch {
                    print("We had an error retriving the weather...")
                }
            }
        }
        task.resume()
    }
    
    @IBAction func searchWeather(_ sender: Any) {
        let x = searchBar.text?.replacingOccurrences(of: " ", with: "+") ?? ""
        getWeather(loc: x)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getWeather(loc: "Poway")
    }
    //MARK SET WEATHER
    func setWeather(weather: String?, description: String?, temp: Int, humidity: Int, windSpeed: Int, windDirection: Int, low: Int, high: Int, city: Any, country: Any) {
        weatherDescriptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp)˚"
        humitidyLabel.text = "Humidity: \(humidity)%"
        windLabel.text = "Wind: \(windSpeed) MPH \(compassDirection(heading: Double(windDirection)))"
        lowLabel.text = "Low: \(low)˚"
        highLabel.text = "High: \(high)˚"
        place.text = "\(city), \(country)"
        let clear = UIColor(red: 0.94901960784, green: 0.94901960784, blue: 0.16470588235, alpha: 1)
        let cloud =  UIColor(red: 0.68235294117, green: 0.83921568627, blue: 0.94509803921, alpha: 1)
        let snow = UIColor(red: 0.52156862745, green: 0.5725490196, blue: 0.61960784313, alpha: 1)
        let fog = UIColor(red: 0.94901960784, green: 0.95294117647, blue: 0.95686274509, alpha: 1)
        let rain = UIColor(red: 0, green: 0.47843137254, blue: 1, alpha: 1)
        let thunder = UIColor(red: 0.95294117647, green: 0.61176470588, blue: 0.07058823529  , alpha: 1)
        switch weather {
        case "Clear":
            weatherImageView.image = UIImage(named: "Sunny")
            background.backgroundColor = clear
            backgroundtwo.backgroundColor = clear
            scroll.backgroundColor = clear
            searchButton.setTitleColor(clear, for: .normal)
            searchBar.textColor = clear
        case "Clouds":
            weatherImageView.image = UIImage(named: "Cloudy")
            background.backgroundColor = cloud
            backgroundtwo.backgroundColor = cloud
            scroll.backgroundColor = cloud
            searchButton.setTitleColor(cloud, for: .normal)
            searchBar.textColor = cloud
        case "Snow":
            weatherImageView.image = UIImage(named: "Snow")
            background.backgroundColor = snow
            backgroundtwo.backgroundColor = snow
            scroll.backgroundColor = snow
            searchButton.setTitleColor(snow, for: .normal)
            searchBar.textColor = snow
        case "Atmosphere":
            weatherImageView.image = UIImage(named: "Fog")
            background.backgroundColor = fog
            backgroundtwo.backgroundColor = fog
            scroll.backgroundColor = fog
            searchButton.setTitleColor(fog, for: .normal)
            searchBar.textColor = fog
        case "Rain":
            weatherImageView.image = UIImage(named: "Rain")
            background.backgroundColor = rain
            backgroundtwo.backgroundColor = rain
            scroll.backgroundColor = rain
            searchButton.setTitleColor(rain, for: .normal)
            searchBar.textColor = rain
        case "Drizzle":
            weatherImageView.image = UIImage(named: "Rain")
            background.backgroundColor = rain
            backgroundtwo.backgroundColor = rain
            scroll.backgroundColor = rain
            searchButton.setTitleColor(rain, for: .normal)
            searchBar.textColor = rain
        case "Thunderstorm":
            weatherImageView.image = UIImage(named: "Thunder")
            background.backgroundColor = thunder
            backgroundtwo.backgroundColor = thunder
            scroll.backgroundColor = thunder
            searchButton.setTitleColor(thunder, for: .normal)
            searchBar.textColor = thunder
        default:
            weatherImageView.image = UIImage(named: "Cloudy")
            background.backgroundColor = rain
            backgroundtwo.backgroundColor = rain
            scroll.backgroundColor = rain
            searchButton.setTitleColor(rain, for: .normal)
            searchBar.textColor = rain
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
