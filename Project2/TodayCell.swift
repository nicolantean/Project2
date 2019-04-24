//
//  TodayCell.swift
//  
//
//  Created by Nicolas Lantean on 4/18/19.
//

import UIKit
class TodayCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temperatureMinMax: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    
    static let cellIdentifier = "TodayCell"
    static let nibName = "TodayCell"
}
