//
//  WeatherRepository.swift
//  srpagotest
//
//  Created by Alberto Ortiz on 2/4/20.
//  Copyright © 2020 Alberto Ortiz. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrentWeatherProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<WeatherResponse>?
}

class CurrentWeatherDataSourceFactory {
    func getCurrentWeatherDataSource(mock: Bool = false) -> CurrentWeatherProtocol {
        if(mock) {
            return CurrentWeatherDataSourceMock()
        }
        
        return CurrentWeatherDataSourceWebService()
    }
}

class CurrentWeatherRepository {
    private let factory = CurrentWeatherDataSourceFactory()
    private let mock: Bool
    
    init(mock: Bool = false) {
        self.mock = mock
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<WeatherResponse>? {
        let dataSource = factory.getCurrentWeatherDataSource(mock: mock)
        return dataSource.getCurrentWeather(latitude: latitude, longitude: longitude)
    }
}
