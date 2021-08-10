//
//  DataModel.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import Foundation

struct DataModels: Codable {
   var allPhotos: [DataModel]
    
    enum CodingKeys: String, CodingKey {
       case allPhotos = "photos"
     }
}

struct DataModel: Codable {
    var camera: Camera
    var rover: Rover
    var id: Int
    var sol: Int
    var imageURL: String
    var earthDate: String
    
    enum CodingKeys: String, CodingKey {
        case camera
        case rover
        case id
        case sol
        case earthDate = "earth_date"
        case imageURL = "img_src"
     }
}

struct Camera: Codable {
    var id: Int
    var roverId: Int
    var name: String
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
     }
}

struct Rover: Codable {
    var id: Int
    var name: String
    var launchDate: String
    var landingDate: String
    var status: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case launchDate = "launch_date"
        case landingDate = "landing_date"
     }
}
