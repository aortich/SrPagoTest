//
//  APIRequest.swift
//  srpagotest
//
//  Created by Alberto Ortiz on 2/4/20.
//  Copyright © 2020 Alberto Ortiz. All rights reserved.
//

import Foundation
import RxSwift

class APIRequest {
    static func execute <T: Codable>(request: URLRequest) -> Observable<T> {
        return Observable<T>.create{ observer in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
           
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func createRequest(url: String, httpMethod: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
