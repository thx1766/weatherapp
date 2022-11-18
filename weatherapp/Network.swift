//
//  Network.swift
//  weatherapp
//
//  Created by Nate M1 on 11/17/22.
//

import Foundation

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
        var time: [String]?
        var temperature_2m_max: [Double]?
        var temperature_2m_min: [Double]?
    }
    var daily: daily_S?
    
    init(){
        
    }
    
    
}

class Network: ObservableObject {
    init(){
        self.weather = Weather()
        self.weatherArray = []
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
    
    func getWeather() {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=40.00&longitude=-74.75&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&timezone=America%2FNew_York") else {
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
                        self.weatherArray = []
                        for i in 0...4 {
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let myDate = dateFormatter.date(from: (decodedWeather.daily?.time![i])!)
                            
                            //print("myDate:\(myDate?.dayOfWeek())")
                            
                            self.weatherArray.append(
                                weatherInfo(
                                    dayOfWeek: (myDate?.dayOfWeek())!,
                                    sfsymbol: "star",
                                    temperature_max: Int((decodedWeather.daily?.temperature_2m_max![i])!),
                                    temperature_min:
                                        Int((decodedWeather.daily? .temperature_2m_min![i])!)
                                        )
                                )
                        }
                        //let stringWeather = String(decoding: data, as: UTF8.self)
                        //print(stringWeather)
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
