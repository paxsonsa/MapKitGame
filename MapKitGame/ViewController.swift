//
//  ViewController.swift
//  MapKitGame
//
//  Created by Andrew Paxson on 2019-06-08.
//  Copyright © 2019 Andrew Paxson. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController, MKMapViewDelegate {

    @IBOutlet var questionLabel: NSTextField!
    @IBOutlet var scorelLabel: NSTextField!
    @IBOutlet var mapView: MKMapView!
    
    var cities = [Pin]()
    var currentCity: Pin?
    
    var score = 0 {
        didSet {
            scorelLabel.stringValue = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(recognizer)
        
        startNewGame()
    }
    
    // MARK: Game Logic
    
    
    /// Starts a fresh game
    func startNewGame() {
        score = 0
        
        cities.append(Pin(title: "London", coordinate:
            CLLocationCoordinate2D(latitude: 51.507222, longitude:
                -0.1275)))
        cities.append(Pin(title: "Oslo", coordinate:
            CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)))
        cities.append(Pin(title: "Paris", coordinate:
            CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)))
        cities.append(Pin(title: "Rome", coordinate:
            CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)))
        cities.append(Pin(title: "Washington DC", coordinate:
            CLLocationCoordinate2D(latitude: 38.895111, longitude:
                -77.036667)))
        
        // Load up the next city
        nextCity()
    }
    
    /// Loads up the next City
    func nextCity() {
        if let city = cities.popLast() {
            currentCity = city
            questionLabel.stringValue = "Where is \(city.title!)"
        } else {
            currentCity = nil
            let alert = NSAlert()
            alert.messageText = "Final Score: \(score)"
            alert.runModal()
            
            startNewGame()
        }
    }
    
    
    // MARK: Map Pin Logic
    
    /// Adds a Pin on the MapView at the given coorindates
    /// - Parameter coorindate: The position on the map to place the pin.
    func addPinToMap(at coorindate: CLLocationCoordinate2D) {
        
        guard let city = currentCity else { return }
        
        let guess =  Pin(title: "Your Guess", coordinate: coorindate, color: .blue)
        mapView.addAnnotation(guess)
        
        mapView.addAnnotation(city)
        
        let point1 = MKMapPoint(guess.coordinate)
        let point2 = MKMapPoint(city.coordinate)
        
        let distance = Int(max(0, 500 - point1.distance(to:
            point2) / 1000))
        
        score += distance
        city.subtitle = "You scored \(distance)"
        mapView.selectAnnotation(city, animated: true)
    }
    
    /// Handle the MapView being clicked and add the pin to the view
    /// - Parameter gestureRecognizer: The gesture that is being recognized
    @objc func mapClicked(gestureRecognizer: NSGestureRecognizer) {
        
        if mapView.annotations.count == 0 {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            addPinToMap(at: coordinate)
        } else {
            mapView.removeAnnotations(mapView.annotations)
            nextCity()
        }
    }
    
    
    /// Add the PinView to the map using our custom color attribute
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pin = annotation as? Pin else { return nil }
        let identifier = "Guess"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier) as? MKPinAnnotationView
        } else {
            pinView!.annotation = annotation
        }
        
        pinView?.canShowCallout = true
        pinView?.pinTintColor = pin.color
        
        return pinView
        
    }
    
}
