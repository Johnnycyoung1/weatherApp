//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Johnny Young on 7/23/18.
//  Copyright © 2018 Johnny Young. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {

    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var newCityTextField: UITextField!
    
    var delegate : ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.layer.borderWidth = 1
        getWeatherButton.layer.cornerRadius = 5
        getWeatherButton.layer.borderColor = UIColor.white.cgColor

    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        if newCityTextField != nil {
            if let newCity = newCityTextField.text, !newCity.isEmpty {
                delegate?.userDidEnterNew(city: newCity)
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Please enter a new city", message: "", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alert.addAction(dismissAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}
