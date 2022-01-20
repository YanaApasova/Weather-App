//
//  HourTableViewCell.swift
//  UnderTheWeather
//
//  Created by YANA on 12/01/2022.
//

import UIKit

class HourTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    @IBOutlet var collection: UICollectionView!
    
    var models = [Current]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.delegate = self
        collection.dataSource = self
        collection.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HourTableViewCell"
    
    
    
    static func nib() -> UINib{
        return UINib( nibName: "HourTableViewCell", bundle: nil)
    }
    
    func configure(with models: [Current]){
        self.models = models
        collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
}
