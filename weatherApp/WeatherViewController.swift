//
//  ViewController.swift
//  weatherApp
//
//  Created by Damian on 30/06/2021.
//  Copyright © 2021 Damian. All rights reserved.
//

import UIKit
import Alamofire

class WeatherViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate  {

    private static let API_KEY = "eef46179fceeaf4056606bb434341412"
    
    var cityNames: [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var cityCodes = [String: Int]()
    var filteredData: [String]!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        loadCityCodes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        search.delegate = self
        filteredData = cityNames
    }

    func loadCityCodes() {
        if let path = Bundle.main.path(forResource: "citylist", ofType: "json") {
            do {
                var data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonArray = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                if let json = jsonArray {
                    for cityEntity in json {
                        if let name = cityEntity["name"] as? String,
                            let id = cityEntity["id"] as? Int {
                            cityCodes[name] = id
                            cityNames.append(name)
                        }
                    }
                }
              } catch {
              }
        }
    }
    
    func fetchWeather(for cityName: String) {
        //api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
        let utf8CityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let cityRequest = "https://api.openweathermap.org/data/2.5/forecast?q="+utf8CityName+"&appid="+WeatherViewController.API_KEY
        let request = AF.request(cityRequest)
        request.responseJSON { (data) in
            
            switch data.result {
            case .success:
                if let data = data.data {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

                        let model = WeatherModel(json: json!)
                        let storyBoard : UIStoryboard = UIStoryboard(name: "DetailWeather", bundle:nil)
                        let detailWeatherVC = storyBoard.instantiateViewController(withIdentifier: "DetailWeatherViewController") as! DetailWeatherViewController
                        detailWeatherVC.model = model
                        self.present(detailWeatherVC, animated:true, completion:nil)
                    }catch{
                    }
                }

                break
            case .failure :
                break
            }

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetchWeather(for: filteredData[indexPath.row])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? cityNames : cityNames.filter { (item: String) -> Bool in
            return item.starts(with: searchText)
        }
        tableView.reloadData()
    }
}

