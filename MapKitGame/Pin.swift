//
//  Pin.swift
//  MapKitGame
//
//  Created by Andrew Paxson on 2019-06-08.
//  Copyright © 2019 Andrew Paxson. All rights reserved.
//

import Cocoa
import MapKit

class Pin: NSObject, MKAnnotation {

    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var color: NSColor
    
    init(title: String, coordinate: CLLocationCoordinate2D, color: NSColor = .green) {
        self.title = title
        self.coordinate = coordinate
        self.color = color
    }

}
