//
//  VehicleDetaillsVC.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import UIKit

class VehicleDetailsVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vehicleImageView : UIImageView!
    @IBOutlet weak var lblVehicleName : UILabel!
    @IBOutlet weak var lblEarthDate : UILabel!
    @IBOutlet weak var lblCameraName : UILabel!
    @IBOutlet weak var lblMissionStatus : UILabel!
    @IBOutlet weak var lblLunchDate : UILabel!
    @IBOutlet weak var lblLandingDate : UILabel!

    //MARK:- Class Variables
    public var modelData:DataModel!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        
    }
    
    //MARK:- Custome Methods
    func updateUI() {
        
        print("modelData.rover.name:\(modelData.rover.name)")
        vehicleImageView.setImgWebUrl(url: modelData.imageURL, isIndicator: true)
        
        lblVehicleName.text = "Vehicle Name: \(modelData.rover.name)"
        lblEarthDate.text = "Earth date: \(modelData.earthDate)"
        lblCameraName.text = "Camera Name: \(modelData.camera.fullName)"
        lblMissionStatus.text = "Mission status: \(modelData.rover.status)"
        lblLunchDate.text = "Launch date: \(modelData.rover.launchDate)"
        lblLandingDate.text = "Landing date: \(modelData.rover.landingDate)"
        
    }
    
    //MARK:- Action Methods
    @IBAction func closeButtonAction(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}

