//
//  singleton.swift
//  mapviewdemo
//
//  Created by albert Michael on 10/06/22.
//

import Foundation
import UIKit
class LocationClass{
    static var sharedInstance = LocationClass()
    var location: String?
   
    private init()
    {
    
    }
    
}
