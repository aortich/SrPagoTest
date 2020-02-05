//
//  WeatherDataSource.swift
//  srpagotest
//
//  Created by Alberto Ortiz on 2/4/20.
//  Copyright © 2020 Alberto Ortiz. All rights reserved.
//

import Foundation
import RxSwift

class CurrentWeatherDataSourceWebService: CurrentWeatherProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<WeatherResponse>? {
        let route = "\(WEATHER_API_ROUTE)\(API_VERSION)weather?lat=\(latitude)&lon=\(longitude)&APPID=\(WEATHER_API_KEY)&units=metric"
        guard let request = APIRequest.createRequest(url: route, httpMethod: "GET") else {
            return nil
        }
        return APIRequest.execute(request: request)
    }
}

class CurrentWeatherDataSourceMock: CurrentWeatherProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<WeatherResponse>? {
        return Observable<WeatherResponse>.create { obs in
            let response = WeatherResponse(coord: Coord(lon: 139, lat: 35),
                                           weather: [Weather(id: 800, main: "Clear", weatherDescription: "clear sky", icon: "01n")],
                                           base: "stations",
                                           main: Main(temp: 281.52, feelsLike: 278.99, tempMin: 280.15, tempMax: 283.71, pressure: 1016, humidity: 93),
                                           wind: Wind(speed: 0.47, deg: 107.538),
                                           clouds: Clouds(all: 2),
                                           dt: 1560350192,
                                           sys: Sys(type: 3, id: 2019346, country: "JP", sunrise: 1560281377, sunset: 1560333478),
                                           timezone: 32400,
                                           id: 1851632,
                                           name: "Shuzenji",
                                           cod: 200)
            obs.onNext(response)
            return Disposables.create {}
        }
    }
}
