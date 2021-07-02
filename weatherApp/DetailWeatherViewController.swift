//
//  DetailWeatherViewController.swift
//  weatherApp
//
//  Created by Damian on 01/07/2021.
//  Copyright © 2021 Damian. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    var model: WeatherModel? = nil
    
    @IBOutlet weak var maxtemp: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var datePicker: UIPickerView!
    
    override func viewDidLoad() {
        if let model = model {
            cityName.text = "City: "+model.cityName
            humidity.text = "Humidity: "+String(model.weatherDays[0].humidity)
            let minimumTemp = model.weatherDays[0].minValue
            let maximumTemp = model.weatherDays[0].maxValue
            minTemp.text = "Min temp: "+String(minimumTemp)+" K / "+String(format: "%.0f", minimumTemp - 273.15) + " C"
            maxtemp.text = "Max temp: "+String(maximumTemp)+" K / "+String(format: "%.0f", maximumTemp - 273.15) + " C"
        }

        datePicker.isHidden = false
        datePicker.dataSource = self
        datePicker.delegate = self
        datePicker.backgroundColor = UIColor.white
        datePicker.transform = CGAffineTransform(scaleX: 0.5, y: 0.5);
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model!.weatherDays[row].date
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let model = model {
            humidity.text = "Humidity: "+String(model.weatherDays[0].humidity)
            let minimumTemp = model.weatherDays[row].minValue
            let maximumTemp = model.weatherDays[row].maxValue
            minTemp.text = "Min temp: "+String(minimumTemp)+" K / "+String(format: "%.0f", minimumTemp - 273.15) + " C"
            maxtemp.text = "Max temp: "+String(maximumTemp)+" K / "+String(format: "%.0f", maximumTemp - 273.15) + " C"
        }
    }

}
