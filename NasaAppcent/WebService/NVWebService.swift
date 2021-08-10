//
//  NVWebService.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import Foundation
import UIKit
import Alamofire

// a new key was generated
let Key = "TP8pA3daIzhFRXNAdmMuCMbXeV3l9NjMq4zZmnSl"

enum ApiEndPoints {
    case curiosity
    case opportunity
    case spirit
    
    static func getUrl(endPoints : ApiEndPoints) -> String {
        
        switch endPoints {
            
        case .curiosity:
            return "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=\(Key)"
            
        case .opportunity:
            return "https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?sol=1000&api_key=\(Key)"
            
        case .spirit:
            return "https://api.nasa.gov/mars-photos/api/v1/rovers/spirit/photos?sol=1000&api_key=\(Key)"
        }
    }
}


class NVWebService {
    static let shared = NVWebService()
    private init(){}
    
    // MARK: -Get Curiosity
    func getRequestedData(_ urlString: String,completionBlock: @escaping ([DataModel]?) -> Swift.Void){

        let headers:HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        GFunctions.shared.addLoader()
        let request = AF.request(urlString,method: .get,headers: headers)
             request.responseDecodable(of: DataModels.self) { (response) in
                GFunctions.shared.removeLoader()
                switch response.result{
                case .success(let curiosities):
                    completionBlock(curiosities.allPhotos)
                case .failure(_):
                    completionBlock(nil)
                }
           }
     }
    
    func getFilteredData(_ urlString: String,completionBlock: @escaping ([DataModel]?) -> Swift.Void){

        let headers:HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        GFunctions.shared.addLoader()
        let request = AF.request(urlString,method: .get,headers: headers)
             request.responseDecodable(of: DataModels.self) { (response) in
                GFunctions.shared.removeLoader()
                switch response.result{
                case .success(let curiosities):
                    completionBlock(curiosities.allPhotos)
                case .failure(_):
                    completionBlock(nil)
                }
           }
     }
}
