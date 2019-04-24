//
//  WeekCell.swift
//  Project2
//
//  Created by Nicolas Lantean on 4/18/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit
class WeekCell: UITableViewCell {
    
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temperatureMinMax: UILabel!
    
    static let cellIdentifier = "WeekCell"
    static let nibName = "WeekCell"
}
