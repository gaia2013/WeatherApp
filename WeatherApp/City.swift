//
//  City.swift
//  WeatherApp
//
//  Created by 山口仁志 on 2018/08/12.
//  Copyright © 2018年 weatherapp-hitoshi.jp. All rights reserved.
//

import Foundation
import SwiftyJSON

class City {
    let id:String
    let title:String
    
    init(city: JSON) {
        id = city["id"].stringValue
        title = city["title"].stringValue
    }
}
