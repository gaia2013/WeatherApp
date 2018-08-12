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
                

                
                // 今日の天気
                let todayWeather = forecasts[0]
                
                self.todayLabel.text = todayWeather["dateLabel"].stringValue
                if let imgUrl = todayWeather["image"]["url"].string {
                    self.todayImage.sd_setImage(with: URL(string: imgUrl))
                }
                self.todayWeatherLabel.text = todayWeather["telop"].stringValue
                self.todayTemperatureLabel.text = self.generateTemperatureText(todayWeather["temperature"])
                
                
                // 明日の天気
                let tomorrowWeather = forecasts[1]
                
                self.tomorrowLabel.text = tomorrowWeather["dateLabel"].stringValue
                if let imgUrl = tomorrowWeather["image"]["url"].string {
                    self.tomorrowImage.sd_setImage(with: URL(string: imgUrl))
                }
                self.tomorrowWeatherLabel.text = tomorrowWeather["telop"].stringValue
                self.tomorrowTemperatureLabel.text = self.generateTemperatureText(tomorrowWeather["temperature"])
                
                
                // 明後日の天気
                // 気象情報の更新が入るまで明後日の天気情報が存在しないばあいがあるので要素数をチェックします
                if forecasts.count >= 3 {
                    let afterTomorrowWeather = forecasts[2]
                    
                    self.afterTomorrowLabel.text = afterTomorrowWeather["dateLabel"].stringValue
                    if let imgUrl = afterTomorrowWeather["image"]["url"].string {
                        self.afterTomorrowImage.sd_setImage(with: URL(string: imgUrl))
                    }
                    self.afterTomorrowWeatherLabel.text = afterTomorrowWeather["telop"].stringValue
                    self.afterTomorrowTemperatureLabel.text = self.generateTemperatureText(afterTomorrowWeather["temperature"])
                        
                }
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
}
