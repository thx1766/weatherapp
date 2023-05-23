//
//  Network.swift
//  weatherapp
//
//  Created by Nate M1 on 11/17/22.
//

import Foundation

func weatherFromCode(code: Int) -> weatherType {
    var symbol = weatherType.starry
    switch (code) {
    case 0:
        symbol = weatherType.sunny
    case 1:
        symbol = weatherType.sunny
    case 3:
        symbol = weatherType.cloudy
    case 55:
        symbol = weatherType.rainheavy
    case 51:
        symbol = weatherType.rainlight
    case 53:
        symbol = weatherType.rainlight
    default:
        symbol = weatherType.starry
    }
    return symbol
}

enum weatherLocation: String {
    case mountHolly
    case ithaca
    case bridgeton
    case tifton
    case warnerRobins
    
    var info: (location: String, name: String){
        switch self {
        case .mountHolly:
                return ("latitude=39.99&longitude=-74.79", "Mount Holly")
        case .ithaca: return ("latitude=42.44&longitude=-76.50", "Ithaca")
        case .bridgeton: return ("latitude=39.43&longitude=-75.23", "Bridgeton")
        case .warnerRobins: return ("latitude=32.62&longitude=-83.63", "Warner Robins")
        case .tifton: return("latitude=31.45&longitude=-83.51", "Tifton")
        }
    }
}

struct Weather: Decodable {
    
    var latitude: Double?
    var longitude: Double?
    var generationtime_ms: Float?
    var utc_offset_seconds: Int?
    var timezone: String?
    var timezone_abbreviation: String?
    var elevation: Int?
    
    struct daily_units_S: Decodable {
        var time: String?
        var temperature_2m_max: String?
        var temperature_2m_min: String?
    }
    var daily_units: daily_units_S?
    struct daily_S: Decodable{
        var dailycode: [String]?
        var time: [String]?
        var temperature_2m_max: [Double]?
        var temperature_2m_min: [Double]?
        var windspeed_10m_max: [Double]?
        var weathercode: [Int]?
    }
    var daily: daily_S?
    
    init(){
        
    }
    
    
}

class Network: ObservableObject {
    init(){
        self.weather = Weather()
        self.weatherArray = []
        //self.currentDayTemp = "500"
        self.currentDayWeather = weatherInfo(dayOfWeek: "today", sfsymbol: weatherType.starry, temperature_max: 100, temperature_min: 0)
//        let weatherstring = "{\"latitude\":39.99457,\"longitude\":-74.74567,\"generationtime_ms\":0.36203861236572266,\"utc_offset_seconds\":-18000,\"timezone\":\"America/New_York\",\"timezone_abbreviation\":\"EST\",\"elevation\":22.0,\"daily_units\":{\"time\":\"iso8601\",\"temperature_2m_max\":\"°F\",\"temperature_2m_min\":\"°F\"},\"daily\":{\"time\":[\"2022-11-17\",\"2022-11-18\",\"2022-11-19\",\"2022-11-20\",\"2022-11-21\",\"2022-11-22\",\"2022-11-23\"],\"temperature_2m_max\":[42.5,42.0,39.5,36.5,44.8,48.4,53.0],\"temperature_2m_min\":[32.0,31.7,28.6,28.9,27.9,32.0,33.7]}}"
//        var tempData = Data()
//        tempData. append(contentsOf: weatherstring)
//        self.weather = try JSONDecoder().decode(Weather.self, from: tempData)
        //getWeather()
    }
    @Published var weather: Weather//Weather(latitude: 0.0, longitude: 0.0, generationtime_ms: 0.0, utc_offset_seconds: 0, timezone: "", timezone_abbreviation: "", elevation: 0, daily_units: Weather.daily_units_S(time: "", temperature_2m_max: "", temperature_2m_min: ""), daily: Weather.daily_S(time: [], temperature_2m_max: [], temperature_2m_min: []))
//    init(){
//        self.weather = Weather(latitude: 0.0, longitude: 0.0, generationtime_ms: 0.0, utc_offset_seconds: 0, timezone: "", timezone_abbreviation: "", elevation: 0, daily_units: Weather.daily_units_S(time: "", temperature_2m_max: "", temperature_2m_min: ""), daily: Weather.daily_S(time: [], temperature_2m_max: [], temperature_2m_min: []))
//    }
    @Published var weatherArray: [weatherInfo]
    @Published var currentDayWeather: weatherInfo
    
    func getWeather(weatherLocationRequest: weatherLocation) {
        var tiftonurl = "https://api.open-meteo.com/v1/forecast?\(weatherLocation.tifton.rawValue)&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max,windgusts_10m_max&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"
        var warnerRobins = "https://api.open-meteo.com/v1/forecast?\(weatherLocation.warnerRobins.rawValue)&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max,windgusts_10m_max&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"
        
        var bridgeton = "https://api.open-meteo.com/v1/forecast?\(weatherLocation.bridgeton.rawValue)&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max,windgusts_10m_max&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"
        var mountHolly = "https://api.open-meteo.com/v1/forecast?\(weatherLocation.mountHolly.rawValue)&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max,windgusts_10m_max&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"
        
        var ithaca = "https://api.open-meteo.com/v1/forecast?\(weatherLocation.ithaca.rawValue)&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max,windgusts_10m_max&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?\(weatherLocationRequest.info.location)&daily=weathercode,temperature_2m_max,temperature_2m_min,windspeed_10m_max,windgusts_10m_max&temperature_unit=fahrenheit&pastDays=1&timezone=America%2FNew_York") else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest){
            (data, response, error) in
            if let error = error {
                print("Resuest error:", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200{
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do{
                        let decodedWeather = try JSONDecoder().decode(Weather.self, from: data)
                        self.currentDayWeather.temperature_max = Int((decodedWeather.daily?.temperature_2m_max![0])!)
                        self.currentDayWeather.temperature_min = Int((decodedWeather.daily?.temperature_2m_min![0])!)
                        self.currentDayWeather.sfsymbol = weatherFromCode(code: Int((decodedWeather.daily?.weathercode![0])!))
                        //let currentDayAverage = currentDayMax - (currentDayMax - currentDayMin)/2
                        //self.currentDayWeather = "\(currentDayAverage)"
                        self.weatherArray = []
                        for i in 1...5 {
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let myDate = dateFormatter.date(from: (decodedWeather.daily?.time![i])!)
                            
                            //print("myDate:\(myDate?.dayOfWeek())")
                            
                            var symbol: weatherType = weatherType.starry
                            var windspeed = Int((decodedWeather.daily?.windspeed_10m_max![i])!)
                            //if(windspeed > 14){
                                //symbol = weatherType.windy
                            //}else{
                                
                                    symbol = weatherFromCode(code: Int((decodedWeather.daily?.weathercode![i])!))
                                
                            
                                
                            //}
                            
                            self.weatherArray.append(
                                weatherInfo(
                                    dayOfWeek: (myDate?.dayOfWeek())!,
                                    sfsymbol: symbol,
                                    temperature_max: Int((decodedWeather.daily?.temperature_2m_max![i])!),
                                    temperature_min:
                                        Int((decodedWeather.daily? .temperature_2m_min![i])!)
                                        )
                                )
                        }
                        let stringWeather = String(decoding: data, as: UTF8.self)
                        print("stringweather:")
                        print(stringWeather)
                        print("decoded weather:\n\(decodedWeather)")
                        print("self.weatherarray:\n\(self.weatherArray)")
                        //self.weather = decodedWeather
                        //self.setWeather()
                    }catch let error {
                        print("error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
//    func setWeather(){
//        if ((self.weather.latitude) != nil){
//            //should be set
//            self.weatherArray = []
//            self.weatherArray.append(
//                weatherInfo(
//                    dayOfWeek: (self.weather.daily?.time![0])!,
//                    sfsymbol: "star",
//                    temperature:
//                        (
//                            Int((
//                                (self.weather.daily?.temperature_2m_max![0])!
//                                +
//                                (self.weather.daily?.temperature_2m_min![0])!
//                            )/2.0)
//                        )
//                )
//                )
//            print("weatherarry: \(self.weatherArray[0])")
//        }else{
//            return
//        }
//    }
}
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
