//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by 山口仁志 on 2018/08/12.
//  Copyright © 2018年 weatherapp-hitoshi.jp. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayTemperatureLabel: UILabel!
    
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var tomorrowImage: UIImageView!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    @IBOutlet weak var tomorrowTemperatureLabel: UILabel!
    
    @IBOutlet weak var afterTomorrowLabel: UILabel!
    @IBOutlet weak var afterTomorrowImage: UIImageView!
    @IBOutlet weak var afterTomorrowWeatherLabel: UILabel!
    @IBOutlet weak var afterTomorrowTemperatureLabel: UILabel!
    
    // 一覧画面から渡される地域ID
    var cityId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard !cityId.isEmpty else {
            self.simpleAlert(title: "エラー", message: "CityIDを参照できません")
            return
        }

        Alamofire.request("http://weather.livedoor.com/forecast/webservice/json/v1?city=\(cityId)").responseJSON{ (response: DataResponse<Any>) in
            if response.result.isFailure == true {
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            
            guard let val = response.result.value as? [String: Any] else {
                self.simpleAlert(title: "エラー", message: "レスポンスの形式が不正です")
                return
            }
            
            let json = JSON(val)
            // タイトル部分
            self.titleLabel.text = json["title"].string
            
            // 天気の情報
            if let forecasts = json["forecasts"].array {
                
                self.insertData(dateLabel: self.todayLabel, imageView: self.todayImage, weatherLabel: self.todayWeatherLabel, tempLabel: self.todayTemperatureLabel, data: forecasts[0])
                self.insertData(dateLabel: self.tomorrowLabel, imageView: self.tomorrowImage, weatherLabel: self.tomorrowWeatherLabel, tempLabel: self.tomorrowTemperatureLabel, data: forecasts[1])
                self.insertData(dateLabel: self.afterTomorrowLabel, imageView: self.afterTomorrowImage, weatherLabel: self.afterTomorrowWeatherLabel, tempLabel: self.afterTomorrowTemperatureLabel, data: forecasts[2])
            }
        }
    }
    
    func simpleAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 気温のラベル用テキストを生成します。
    func generateTemperatureText(_ temperature: JSON) -> String {
        var resultText = ""
        
        if let min = temperature["min"]["celsius"].string {
            resultText += min + "℃"
        } else {
            resultText += "-"
        }
        
        resultText += " / "
        
        if let max = temperature["max"]["celsius"].string {
            resultText += max + "℃"
        } else {
            resultText += "-"
        }
        
        return resultText
    }
    
    func insertData(dateLabel: UILabel, imageView: UIImageView, weatherLabel: UILabel, tempLabel: UILabel, data: JSON) {
        
        dateLabel.text = data["dateLabel"].stringValue
        
        if let imgUrl = data["image"]["url"].string {
            imageView.sd_setImage(with: URL(string: imgUrl))
        }
        
        weatherLabel.text = data["telop"].stringValue
        tempLabel.text = self.generateTemperatureText(data["temperature"])
        
    }
    
}
