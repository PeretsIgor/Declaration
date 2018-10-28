//
//  NetworkLayer.swift
//  EDeclaration
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SafariServices


typealias JSON = [String : Any]

class NetworkLayer {
    
    static let apiString = "https://public-api.nazk.gov.ua/v1/declaration/"
    static let reportString = "https://nazk.gov.ua/report-corruption"
    static let publicString = "https://public.nazk.gov.ua/declaration/"
    
    static func searchDeclarations(name: String, page: Int = 1, completion: @escaping ([AccountModel]?, PageModel?) -> Void) {
        
        let parameters: [String : Any] = ["q" : name, "page" : page]
        
        Alamofire.request(NetworkLayer.apiString, method: .get, parameters: parameters).responseJSON { (jsonResponse) in
            
            if let jsonValue = jsonResponse.result.value as? JSON,
                let jsonItems = jsonValue["items"],
                let jsonPage = jsonValue ["page"] {
                
                let decoder = JSONDecoder()
                
                if let itemsData = try? JSONSerialization.data(withJSONObject: jsonItems, options: []),
                    let pageData = try? JSONSerialization.data(withJSONObject: jsonPage, options: []) {
                    
                    let itemsArray = try? decoder.decode([AccountModel].self, from: itemsData)
                    let page = try? decoder.decode(PageModel.self, from: pageData)
                    
                    completion(itemsArray, page)
                }
            } else {
                completion(nil, nil)
            }
            
        }
    }
    
    static func getSafariViewController(urlString: String) -> SFSafariViewController? {
        
        if let reportURL = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: reportURL)
            return safariVC
        } else {
            return nil
        }
        
    }
}
