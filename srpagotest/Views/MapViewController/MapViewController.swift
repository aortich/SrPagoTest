//
//  ViewController.swift
//  srpagotest
//
//  Created by Alberto Ortiz on 2/4/20.
//  Copyright © 2020 Alberto Ortiz. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var btnCity: UIButton!
    let viewModel : MapViewModel = MapViewModel()
    let disposeBag = DisposeBag()
    var gMap: GMSMapView?
    var weatherDisposable: Disposable?
    
    @IBOutlet weak var lblPlaceTitle: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblFeeling: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMap()
        _ = createMarker(latitude: CDMX_COORDINATES.0, longitude: CDMX_COORDINATES.1)
        self.refreshWeather(latitude: CDMX_COORDINATES.0, longitude: CDMX_COORDINATES.1)
    }
    
    func createMap() {
        let camera = GMSCameraPosition.camera(withLatitude: CDMX_COORDINATES.0, longitude: CDMX_COORDINATES.1, zoom: Float(DEFAULT_ZOOM))
        self.gMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
        self.gMap?.delegate = self
        self.mapView.addSubview(gMap!)
        
        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"),
            let style = try? GMSMapStyle(contentsOfFileURL: styleURL) {
            gMap?.mapStyle = style
        }
    }
    
    @IBAction func pressedCity(_ sender: Any) {
        let alert = UIAlertController(title: "Selecciona una ciudad", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CDMX", style: .default, handler: { action in
            self.moveMapToCoordinates(latitude: CDMX_COORDINATES.0, longitude: CDMX_COORDINATES.1)
            self.btnCity.setTitle("CDMX", for: .normal)
        }))
        
        alert.addAction(UIAlertAction(title: "Guadalajara", style: .default, handler: { action in
            self.moveMapToCoordinates(latitude: GUADALAJARA_COORDINATES.0, longitude: GUADALAJARA_COORDINATES.1)
            self.btnCity.setTitle("GUADALAJARA", for: .normal)
        }))
        
        alert.addAction(UIAlertAction(title: "Monterrey", style: .default, handler: { action in
            self.moveMapToCoordinates(latitude: MONTERREY_COORDINATES.0, longitude: MONTERREY_COORDINATES.1)
            self.btnCity.setTitle("MONTERREY", for: .normal)
        }))

        
        self.present(alert, animated: true)
    }
}

extension MapViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.setMarkerToCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.refreshWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
    }
    
    func moveMapToCoordinates(latitude: Double, longitude: Double) {
        guard let gmap = self.gMap else { return }
        gmap.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Float(DEFAULT_ZOOM))
        gmap.clear()
        
        _ = createMarker(latitude: latitude, longitude: longitude)
        self.refreshWeather(latitude: latitude, longitude: longitude)
    }
    
    func setMarkerToCoordinates(latitude: Double, longitude: Double) {
        guard let gmap = self.gMap else { return }
        gmap.clear()
        
        _ = createMarker(latitude: latitude, longitude: longitude)
    }
    
    func refreshWeather(latitude: Double, longitude: Double) {
        weatherDisposable?.dispose()
        
        weatherDisposable = self.viewModel.getCurrentWeather(latitude: latitude, longitude: longitude)?.subscribe(onNext: { response in
            self.lblPlaceTitle.text = response.name
            self.lblWeather.text = "\(response.main.temp)°C"
            self.lblFeeling.text = "Sensación térmica: \(response.main.feelsLike)°C"
            if let url = URL(string: "https://openweathermap.org/img/w/\(response.weather.first?.icon ?? "03n").png") {
                self.ivIcon.loadImageFromURL(url: url)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func createMarker(latitude: Double, longitude: Double) -> GMSMarker? {
        guard let gmap = self.gMap else { return nil }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = gmap
        
        return marker
    }
    
}

