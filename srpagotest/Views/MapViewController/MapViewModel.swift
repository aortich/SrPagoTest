//
//  MapViewModel.swift
//  srpagotest
//
//  Created by Alberto Ortiz on 2/4/20.
//  Copyright © 2020 Alberto Ortiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel {
    private let weatherRepository = CurrentWeatherRepository.init(mock: ENABLE_MOCK)
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error: PublishSubject<Bool> = PublishSubject()
    
    init() {
        error.onNext(false)
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<WeatherResponse>? {
        loading.onNext(true)
        
        return self.weatherRepository.getCurrentWeather(latitude: latitude, longitude: longitude)?
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in
                self.loading.onNext(false)
            }, afterNext: nil, onError: { _ in
                self.error.onNext(true)
                self.loading.onNext(false)
            }, afterError: nil, onCompleted: nil, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    }
    
}
