//
//  OpportunityVC.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import UIKit

class OpportunityVC: UIViewController {
    
    //MARK:- UIControl's Outlets
    @IBOutlet weak var photosCollectionView : UICollectionView!

    //MARK:- Class Variables
    var opportunitiesMasterData : [DataModel] = []
    var opportunitiesFilterData : [DataModel] = []
    internal let leftRightInset: CGFloat = 10
    internal let cellSpacing: CGFloat = 20
    var page : Int = 0
    var isAPICalled: Bool = Bool()
    var isRefreshData: Bool = true
    var isFilter: Bool = false


    //MARK:- View life cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureCollectionViewFlowDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        if isRefreshData {
            self.page = 1
            self.isAPICalled = false
            self.getData(self.page)
        }
        isRefreshData = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK:- Custome Methods
    
    @objc func getData(_ page:Int) {
        
        NVWebService.shared.getRequestedData("\(ApiEndPoints.getUrl(endPoints: .opportunity))&page=\(page)") { opportunity in
            if let _opportunity = opportunity,_opportunity.count>0 {
                if self.page == 1 {
                    self.opportunitiesMasterData = []
                    self.opportunitiesFilterData = []
                }
                self.isAPICalled = true
                DispatchQueue.main.async {
                    self.opportunitiesMasterData.append(contentsOf: _opportunity)
                    self.opportunitiesFilterData.append(contentsOf: _opportunity)
                    self.photosCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func getFilteredData(_ cameraShortname:String) {
        NVWebService.shared.getFilteredData("\(ApiEndPoints.getUrl(endPoints: .opportunity))&camera=\(cameraShortname)") { opportunity in
            if let _opportunity = opportunity,_opportunity.count > 0 {
                self.opportunitiesFilterData = []
                //self.isAPICalled = true
                DispatchQueue.main.async {
                    self.opportunitiesFilterData.append(contentsOf: _opportunity)
                    self.photosCollectionView.reloadData()
                }
            }else{
                self.opportunitiesFilterData = []
                //self.isAPICalled = false
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
                }
            }
        }
    }
    
    func configureCollectionViewFlowDelegate() {
        let cellWidth : CGFloat = (photosCollectionView.frame.size.width - leftRightInset * 2 - cellSpacing * 1) / 2.0
            let cellSize = CGSize(width: cellWidth , height:cellWidth)

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: leftRightInset, left: leftRightInset, bottom: leftRightInset, right: leftRightInset)
            layout.minimumLineSpacing = cellSpacing
            layout.minimumInteritemSpacing = cellSpacing
            photosCollectionView.setCollectionViewLayout(layout, animated: true)

    }
    
    //MARK:- Action Methods
    @IBAction func showFilterOption(sender: AnyObject) {
        var optionArray:[FilterModel] = []
        
        optionArray.append(FilterModel(shortName: "FHAZ", fullName: "Front Hazard Avoidance Camera"))
        optionArray.append(FilterModel(shortName: "RHAZ", fullName: "Rear Hazard Avoidance Camera"))
        optionArray.append(FilterModel(shortName: "NAVCAM", fullName: "Navigation Camera"))
        optionArray.append(FilterModel(shortName: "PANCAM", fullName: "Panoramic Camera"))
        optionArray.append(FilterModel(shortName: "MINITES", fullName: "Miniature Thermal Emission Spectrometer (Mini-TES)"))
        optionArray.append(FilterModel(shortName: "Clear", fullName: "Clear"))

        GFunctions.shared.showFilterOption(filterOptionArray: optionArray) { responseString in
            if let _responseString = responseString{
                print("_responseString:\(_responseString)")
                if _responseString == "Clear" {
                    self.isFilter = false
                    self.opportunitiesFilterData = self.opportunitiesMasterData
                }else{
                    self.isFilter = true
                    self.getFilteredData(_responseString.lowercased())
               // self.opportunitiesFilterData = self.opportunitiesMasterData.filter(){ $0.camera.name == _responseString }
                }
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
                }
            }
        }
    }


}

extension OpportunityVC : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return opportunitiesFilterData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let curiosity = opportunitiesFilterData[indexPath.row]
        cell.itemImageView.setImgWebUrl(url: curiosity.imageURL, isIndicator: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isRefreshData = false
        let modelData = opportunitiesFilterData[indexPath.row]
        let vehicleDetailsVC : VehicleDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
        vehicleDetailsVC.modelData = modelData
        vehicleDetailsVC.modalPresentationStyle = .fullScreen
        self.present(vehicleDetailsVC, animated: true, completion: nil)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
         if opportunitiesFilterData.count-1 == indexPath.row {
            if self.isAPICalled && !isFilter{
                self.isAPICalled = false
                self.page += 1
                self.getData(self.page)
            }
        }
    }


}
