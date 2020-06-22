//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRates(_ coinManager: CoinManager, response: BitcoinRates)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC?apikey="
    let apiKey = "F0A78185-7559-4E10-96C8-1388B20322F1"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func updateAllRates(){
        
        let url = URL(string: "\(baseURL)\(apiKey)")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let rates = self.parseDatainRates(data: safeData) {
                    self.delegate?.didUpdateRates(self, response:rates)
                }
            }
        }
        task.resume()
    }
    
    func parseDatainRates(data:Data) -> BitcoinRates?{
                   let decoder = JSONDecoder()
                   do {
                    let decodedData = try decoder.decode(BitcoinRates.self, from: data)
                       return decodedData
                   } catch {
                    self.delegate?.didFailWithError(error: error)
                    return nil
                   }
           }
    
}
