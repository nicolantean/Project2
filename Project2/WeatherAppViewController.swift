//
//  WeatherAppViewController.swift
//  Project2
//
//  Created by Nicolas Lantean on 4/18/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit

class WeatherAppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [Informes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TodayCell.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: TodayCell.cellIdentifier)
        tableView.register(UINib(nibName: WeekCell.nibName, bundle: nil), forCellReuseIdentifier: WeekCell.cellIdentifier)
        
        if UserDefaults.standard.object(forKey: "units") == nil {
            UserDefaults.standard.set("&units=metric", forKey: "units")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setTitle(title: "Sunshine", subtitle: "Montevideo, Uruguay")
        WeatherData.getData() { (datos,error) in
            if let datos = datos {
                self.data = datos
                self.tableView.reloadData()
            } else {
                print("error")
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Options", sender: sender)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if data.count > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell", for: indexPath) as? WeekCell else {
            fatalError("The dequeued cell is not an instance of WeekCell.")
        }

        if indexPath.row == 0 {
            cell.day.text = "Tomorrow"
        } else {
            let today = data[indexPath.row+1].dt
            let calendar = Calendar.current
            let hour = calendar.component(.weekday, from: today)
            switch hour {
            case 1: cell.day.text = "Sunday"
            case 2: cell.day.text = "Monday"
            case 3: cell.day.text = "Tuesday"
            case 4: cell.day.text = "Wednesday"
            case 5: cell.day.text = "Thursday"
            case 6: cell.day.text = "Friday"
            case 7: cell.day.text = "Saturday"
            default:
                break
            }
        }
        
        let imagen = data[indexPath.row+1].weather[0].mainDescription
        
        switch imagen {
        case "Clouds": cell.imageWeather.image = UIImage(named: "artClouds")
        case "Clear": cell.imageWeather.image = UIImage(named: "artClear")
        case "Rain" : cell.imageWeather.image = UIImage(named: "artRain")
        default:
            break
        }
        
        cell.weatherDescription.text = data[indexPath.row+1].weather[0].mainDescription
        cell.temperature.text = String(Int(data[indexPath.row+1].main.temp))+symbol()
        cell.temperatureMinMax.text = String(Int(data[indexPath.row].main.tempMin.rounded()))+symbol()+"/"+String(Int(data[indexPath.row].main.tempMax.rounded()))+symbol()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 201
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TodayCell") as? TodayCell  else {
            fatalError("The dequeued cell is not an instance of TodayCell.")
        }
        
        header.backgroundView = UIView(frame: header.bounds)
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.3714076579, green: 0.7189366221, blue: 0.9605181813, alpha: 1)
        
        header.temperature.text = String(Int(data[0].main.temp))+symbol()
        header.temperatureMinMax.text = String(Int(data[0].main.tempMin))+symbol()+"/"+String(Int(data[0].main.tempMax))+symbol()
        header.imageWeather.image = UIImage(named: "artClear")
        header.weatherDescription.text = data[0].weather[0].mainDescription
        
        return header
    }
    
    func symbol() -> String {
        var symbol = "°C"
        
        if let units = UserDefaults.standard.object(forKey: "units") {
            if units as! String == "&units=standard" {
                symbol = "°F"
            }
        }
        
        return symbol
    }
}

extension UINavigationItem {
    
    func setTitle(title:String, subtitle:String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subtitleLabel.textAlignment = NSTextAlignment.center
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = max(titleLabel.frame.size.width, subtitleLabel.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        self.titleView = stackView
    }
    
}

