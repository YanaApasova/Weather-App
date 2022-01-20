//
//  ViewController.swift
//  UnderTheWeather
//
//  Created by YANA on 12/01/2022.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var table:UITableView!
    var models = [Daily]()
    var current:Current?
    var hourlyModels = [Current]()
    var locationWeather = String ()
    
   
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register two cells
        table.register(HourTableViewCell.nib(), forCellReuseIdentifier: HourTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(named: "BackgroundColor")
        view.backgroundColor = UIColor(named: "BackgroundColor")
       
        
    }
    
    // MARK: location services
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation(){
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let location = CLLocation(latitude: lat, longitude: long)
        location.fetchCityAndCountry { city, error in
            guard let city = city,  error == nil else { return }
            self.locationWeather = city
        }
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alert&appid=bb78a5b20668adfc77b7c23be65c2163"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            //Validation of data
            guard let data = data, error == nil else {
                return
            }
            guard let string = String(data: data, encoding: String.Encoding.isoLatin1)else { return }
            guard let properData = string.data(using: .utf8, allowLossyConversion: true) else { return }
            
            //convert data to models/object
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: properData)
            }
            catch{
                print("Error: \(error)")
                
            }
            
            guard let result = json else {
                return
            }
            
            let entries = result.daily
            self.models.append(contentsOf: entries)
            
            let current = result.current
            self.current = current
            self.hourlyModels = result.hourly
           
           
            //update UI
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
            
            
        }).resume()
    }
    
    // tableView header
    func createTableHeader()-> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        let locationLable = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/4))
        let temperatureLable = UILabel(frame: CGRect(x: 10, y: 20 + locationLable.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/3))
        let summaryLable = UILabel(frame: CGRect(x: 10, y: 20 + locationLable.frame.size.height + temperatureLable.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        headerView.addSubview(locationLable)
        headerView.addSubview(summaryLable)
        headerView.addSubview(temperatureLable)
        headerView.backgroundColor = UIColor(named: "BackgroundColor")
        
        guard let currentTemp = current?.temp else {
            return UIView()
        }
        let tempInCelsius = { currentTemp - 273.15
        }
        
        temperatureLable.font = UIFont(name: "HelveticaNeue-Light", size: 62)
        temperatureLable.text = " \(String(Int(tempInCelsius())))°"
        summaryLable.font = UIFont(name: "HelveticaNeue-Thin", size: 32)
        summaryLable.text = self.current?.weather[0].description.capitalized
        locationLable.font = UIFont(name: "HelveticaNeue-Thin", size: 42)
        locationLable.text = "\(locationWeather)"
        
        locationLable.textAlignment = .center
        summaryLable.textAlignment = .center
        temperatureLable.textAlignment = .center
        
        
        return headerView
    }
    
    // MARK: tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1 // one cell for collectionView
        }
        return models.count // other cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HourTableViewCell.identifier, for: indexPath) as! HourTableViewCell
        cell.configure(with: hourlyModels )
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        cell.isUserInteractionEnabled = false
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $1) }
    }
}
