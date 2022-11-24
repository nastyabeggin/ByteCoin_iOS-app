//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var rubleLabel: UILabel!
    
    @IBOutlet var currencyLabels: [UILabel]!
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didFailWithError(error: Error){
        print(error)
    }
    
    func didUpdateValues(_ coinManager: CoinManager, data: CoinData){
        DispatchQueue.main.async {
            for label in self.currencyLabels{
                label.text = data.asset_id_quote
            }
            if data.asset_id_base == "BTC"{
                self.bitcoinLabel.text = String(formatRate(for: data.rate))
            } else if data.asset_id_base == "USD"{
                self.dollarLabel.text = String(formatRate(for: data.rate))
            } else if data.asset_id_base == "RUB"{
                self.rubleLabel.text = String(formatRate(for: data.rate))}
            }
        }
    }
    
    func formatRate(for rate: Double) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.decimalSeparator = "."
        currencyFormatter.groupingSeparator = " "
        let formattedRate = currencyFormatter.string(from: rate as NSNumber)!
        return formattedRate
    }


//MARK: - UIPickerViewDelegate & DataSource

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(initial: "BTC", for: selectedCurrency)
        coinManager.getCoinPrice(initial: "USD", for: selectedCurrency)
        coinManager.getCoinPrice(initial: "RUB", for: selectedCurrency)
    }
}
