//
//  Pref.swift
//  WeatherApp
//
//  Created by 山口仁志 on 2018/08/12.
//  Copyright © 2018年 weatherapp-hitoshi.jp. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pref {
    let title: String
    let cities: [City]
    
    init(pref: JSON) {
        title = pref["title"].stringValue
        cities = pref["city"].arrayValue.map({ item in
            return City(city: item)
        })
    }
    
}
