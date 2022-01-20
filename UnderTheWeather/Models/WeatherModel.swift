//
//  WeatherModel.swift
//  UnderTheWeather
//
//  Created by YANA on 13/01/2022.
//



import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let current: Current
    let hourly: [Current]
    let daily: [Daily]


}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp: Double
    let pressure, humidity: Double
    let uvi: Double
    let clouds, visibility: Double
    let weather: [Weather]
    let pop: Double?

    
}

// MARK: - Weather
struct Weather: Codable {
    let id: Double
    let main: String
    let icon: String
    let description: String

    
}



// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Double
    let temp: Temp
    let pressure, humidity: Int
    let weather: [Weather]
    let clouds: Double
    let pop, uvi: Double
    let snow: Double?

   
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double 
    let eve, morn: Double
}
