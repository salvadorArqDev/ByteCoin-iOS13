//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var quotes = Dictionary<String, String>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.isHidden = true
        coinManager.delegate = self

        coinManager.updateAllRates()
        
    }
}

// MARK: - UIPICKER implementation

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: coinManager.currencyArray[row])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        
        DispatchQueue.main.async {
            if let quote = self.quotes[selectedCurrency] {
                self.currentValueLabel.text = quote
            }
        }
    }
}

// MARK: - CoinManager Call

extension ViewController: CoinManagerDelegate
{
    func didUpdateRates(_ coinManager: CoinManager, response: BitcoinRates) {
        
        var code: [String] = []
        var quote: [String] = []
        
        for rate in response.rates {
            code.append(rate.assetIdQuote)
            quote.append(String(format:"%.2f",rate.rate))
        }
        
        quotes = Dictionary(uniqueKeysWithValues: zip(code, quote))
        
        DispatchQueue.main.async {
            self.currencyPicker.isHidden = false
            self.currentValueLabel.text = self.quotes["USD"]
            self.currencyPicker.reloadAllComponents()
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

