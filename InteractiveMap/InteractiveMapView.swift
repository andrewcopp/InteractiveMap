//
//  InteractiveMapView.swift
//  InteractiveMap
//
//  Created by Andrew Copp on 5/18/15.
//  Copyright (c) 2015 Andrew Copp. All rights reserved.
//

import UIKit

class InteractiveMapView: UIView {

    var fillColor : UIColor?
    var strokeColor : UIColor?

    func loadMap(mapName: String, colors: [String : UIColor]) {
        
    }
    
    func loadMap(mapName: String, data: [String : Float], colorAxis: [UIColor]) {
        loadMap(mapName, colors: getColors(data, colorAxis: colorAxis))
    }
    
    private func getColors(data: [String : Float], colorAxis: [UIColor]) -> [String : UIColor] {
        return [String : UIColor]();
    }
    
}
