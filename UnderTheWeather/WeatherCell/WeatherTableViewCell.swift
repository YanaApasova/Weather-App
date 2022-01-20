//
//  WeatherTableViewCell.swift
//  UnderTheWeather
//
//  Created by YANA on 12/01/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    var tempInCelvinMax:Double = 0.0
    var tempInCelvinMin: Double = 0.0
    

    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib{
        return UINib( nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: Daily){
        tempInCelvinMax = model.temp.max
        tempInCelvinMin = model.temp.min
        let tempInCelsiusMax = {
            self.tempInCelvinMax-273.15
        }
        let tempInCelsiusMin = {
            self.tempInCelvinMin-273.15
        }
        self.lowTempLabel.text = "\(Int(tempInCelsiusMin()))°"
        self.highTempLabel.text = "\(Int(tempInCelsiusMax()))°"
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textAlignment = .center
        
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.iconImageView.image = UIImage(named: "clear")
        self.iconImageView.contentMode = .scaleAspectFill
        
        let main = model.weather[0].main.lowercased()
        if main.contains("clear"){
            self.iconImageView.image = UIImage(named: "clear")
        }
        else if main.contains("rain"){
            self.iconImageView.image = UIImage(named: "rain")
        }
        
        else if main.contains("snow"){
            self.iconImageView.image = UIImage(named: "snow")
        }
        else {
            // cloud icon
            self.iconImageView.image = UIImage(named: "cloud")
        }
        
    }
    
    func getDayForDate(_ date:Date?)-> String{
        guard let inputDate = date else {
            return ""
        }
        
        let fotmatter = DateFormatter()
        fotmatter.dateFormat = "EEEE"
        return fotmatter.string(from: inputDate)
    }
}
