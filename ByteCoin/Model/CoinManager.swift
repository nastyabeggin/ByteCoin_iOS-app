//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateValues(_ coinManager: CoinManager, data: CoinData)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "4109EB64-1D5E-41AA-8E4D-7D28935BCA47"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?

    
    func getCoinPrice(initial: String, for currency: String){
        let urlString = "\(baseURL)\(initial)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let decodedData = self.parseJSON(coinData: safeData){
                        self.delegate?.didUpdateValues(self, data: decodedData)
                    }

                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(coinData: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }


}
