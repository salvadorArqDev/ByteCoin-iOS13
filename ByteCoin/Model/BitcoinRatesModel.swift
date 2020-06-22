//
//  CoinRateModel.swift
//  ByteCoin
//
//  Created by Jorge Salvador on 21/06/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct BitcoinRates: Decodable {
    let rates: [Rate]
    
}

struct Rate: Decodable{
    let time: String
    let assetIdQuote: String
    let rate: Double
    
    enum CodingKeys: String, CodingKey{
        case time, rate
        case assetIdQuote = "asset_id_quote"
    }
    
}
