//
//  WeatherCollectionViewCell.swift
//  UnderTheWeather
//
//  Created by YANA on 15/01/2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temp: UILabel!
    @IBOutlet var time: UILabel!
    
    func configure(with model: Current){
        self.temp.text = "\(Int(model.temp - 273.15))°"
        let main = model.weather[0].main.lowercased()
        if main.contains("clear"){
            self.icon.image = UIImage(named: "clear")
        }
        else if main.contains("rain"){
            self.icon.image = UIImage(named: "rain")
        }
        
        else if main.contains("snow"){
            self.icon.image = UIImage(named: "snow")
        }
        else {
            // cloud icon
            self.icon.image = UIImage(named: "cloud")
        }
        self.icon.contentMode = .scaleAspectFit
        self.time.text = getTimeDate(Date(timeIntervalSince1970: Double(model.dt)))
    }
    
    func getTimeDate(_ date:Date?)-> String{
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        formatter.dateFormat = "h"
        return formatter.string(from: inputDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
