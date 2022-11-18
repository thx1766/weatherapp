//
//  ContentView.swift
//  weatherapp
//
//  Created by Nate M1 on 11/15/22.
//

import SwiftUI

struct weatherInfo {
    var dayOfWeek: String
    var sfsymbol: String
    var temperature_max: Int
    var temperature_min: Int
}

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    init(){
        var weatherInput: [weatherInfo] = []
        
        weatherInput.append(weatherInfo(dayOfWeek: "TUE", sfsymbol: "cloud.sun.fill", temperature_max: 74, temperature_min: 74))
        weatherInput.append(weatherInfo(dayOfWeek: "WED", sfsymbol: "sun.max.fill", temperature_max: 74, temperature_min: 74))
        weatherInput.append(weatherInfo(dayOfWeek: "THU", sfsymbol: "wind", temperature_max: 74, temperature_min: 74))
        weatherInput.append(weatherInfo(dayOfWeek: "FRI", sfsymbol: "sunset.fill", temperature_max: 74, temperature_min: 74))
        weatherInput.append(weatherInfo(dayOfWeek: "SAT", sfsymbol: "snow", temperature_max: 74, temperature_min: 74))

        self.weatherArray = weatherInput
    }
    
    @State private var isNight = false
    var weatherArray: [weatherInfo]
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack{
                CityTextView(cityName: "Cupertino, CA")
                
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill", temperature: 76)

                HStack(spacing: 20){
                    // array with a struct for day of week, enums for weather
                    //weathewr enum with image attacged to it
                    //create a network call from a basic weather api
                    //take whtever cit and 5 days of weather
                    //tab view for five different vitues based on api
                    //questions to ask in slack channel
                WeatherDayView(weatherInfoItem: network.weatherArray.count != 0 ? network.weatherArray[0] : weatherArray[0])
                    WeatherDayView(weatherInfoItem: network.weatherArray.count != 0 ? network.weatherArray[1] : weatherArray[1])
                    WeatherDayView(weatherInfoItem: network.weatherArray.count != 0 ? network.weatherArray[2] : weatherArray[2])
                    WeatherDayView(weatherInfoItem: network.weatherArray.count != 0 ? network.weatherArray[3] : weatherArray[3])
                    WeatherDayView(weatherInfoItem: network.weatherArray.count != 0 ? network.weatherArray[4] : weatherArray[4])
                    
                }
                
                Spacer()
                
                Button{
                    print("tapped")
                    isNight.toggle()
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                }
                Spacer()
            }
            
        }.onAppear{
            network.getWeather()
            print("got weather")
            print(network.weather.self)
            print("weatherElement:\n\(network.weatherArray.self)")
            //weatherArray = network.weatherArray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    var weatherInput: [weatherInfo]
    
    static var previews: some View {
        ContentView()
    }
}

struct WeatherDayView: View {
    
    var weatherInfoItem: weatherInfo
    
    var body: some View {
        VStack{
            Text(weatherInfoItem.dayOfWeek)
                .font(.system(size: 28))
                .foregroundColor(.white)
//            Image(systemName: weatherInfoItem.sfsymbol)
//                .renderingMode(.original)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 40, height: 40)
            HStack{
                Image(systemName: "thermometer.medium")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                VStack{
                    Text("\(weatherInfoItem.temperature_max)°")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(5)
                    Text("\(weatherInfoItem.temperature_min)°")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
            }
            
        }.background(Color.indigo).cornerRadius(10)
    }
}

struct BackgroundView: View {
    
    @Binding  var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8){
            Image(systemName: imageName).renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°")
                .font(.system(size: 70 , weight: .medium))
                .foregroundColor(.white)
            
        }
        .padding(.bottom, 40)
    }
}

struct WeatherButton: View {
    
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20))
            .cornerRadius(10)
    }
}
