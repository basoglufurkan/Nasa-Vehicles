//
//  CuriosityVC.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var itemImageView : UIImageView!
    override func layoutSubviews() {
        itemImageView.layer.cornerRadius = 10
        itemImageView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CuriosityVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var photosCollectionView : UICollectionView!

    //MARK:- Class Variables
    var curiositiesMasterData : [DataModel] = []
    var curiositiesFilterData : [DataModel] = []
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
    
    //MARK:- Action Methods
    @IBAction func showFilterOption(sender: AnyObject) {
        var optionArray:[FilterModel] = []
        
        optionArray.append(FilterModel(shortName: "FHAZ", fullName: "Front Hazard Avoidance Camera"))
        optionArray.append(FilterModel(shortName: "RHAZ", fullName: "Rear Hazard Avoidance Camera"))
        optionArray.append(FilterModel(shortName: "MAST", fullName: "Mast Camera"))
        optionArray.append(FilterModel(shortName: "CHEMCAM", fullName: "Chemistry and Camera Complex"))
        optionArray.append(FilterModel(shortName: "MAHLI", fullName: "Mars Hand Lens Imager"))
        optionArray.append(FilterModel(shortName: "MARDI", fullName: "Mars Descent Imager"))
        optionArray.append(FilterModel(shortName: "NAVCAM", fullName: "Navigation Camera"))
        optionArray.append(FilterModel(shortName: "Clear", fullName: "Clear"))

        GFunctions.shared.showFilterOption(filterOptionArray: optionArray) { responseString in
            if let _responseString = responseString{
                print("_responseString:\(_responseString)")
                if _responseString == "Clear" {
                    self.isFilter = false
                    self.curiositiesFilterData = self.curiositiesMasterData
                    DispatchQueue.main.async {
                        self.photosCollectionView.reloadData()
                    }
                }else{
                    self.isFilter = true
                    self.getFilteredData(_responseString.lowercased())
               // self.curiositiesFilterData = self.curiositiesMasterData.filter(){ $0.camera.name == _responseString }
                }
                
            }
        }
    }
    
    //MARK:- Custome Methods
    
    @objc func getData(_ page:Int) {
        NVWebService.shared.getRequestedData("\(ApiEndPoints.getUrl(endPoints: .curiosity))&page=\(page)") { curisity in
            if let _curisity = curisity,_curisity.count > 0 {
                print("_curisity:\(_curisity.count)")
                if self.page == 1 {
                    self.curiositiesMasterData = []
                    self.curiositiesFilterData = []
                }
                self.isAPICalled = true
                DispatchQueue.main.async {
                    self.curiositiesMasterData.append(contentsOf: _curisity)
                    self.curiositiesFilterData.append(contentsOf: _curisity)
                    self.photosCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func getFilteredData(_ cameraShortname:String) {
        NVWebService.shared.getFilteredData("\(ApiEndPoints.getUrl(endPoints: .curiosity))&camera=\(cameraShortname)") { curisity in
            if let _curisity = curisity,_curisity.count > 0 {
                self.curiositiesFilterData = []
                //self.isAPICalled = true
                DispatchQueue.main.async {
                    self.curiositiesFilterData.append(contentsOf: _curisity)
                    self.photosCollectionView.reloadData()
                }
            }else{
                self.curiositiesFilterData = []
               // self.isAPICalled = false
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

}

extension CuriosityVC : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curiositiesFilterData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let curiosity = curiositiesFilterData[indexPath.row]
        cell.itemImageView.setImgWebUrl(url: curiosity.imageURL, isIndicator: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isRefreshData = false
        let modelData = curiositiesFilterData[indexPath.row]
        let vehicleDetailsVC : VehicleDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
        vehicleDetailsVC.modelData = modelData
        vehicleDetailsVC.modalPresentationStyle = .fullScreen
        self.present(vehicleDetailsVC, animated: true, completion: nil)

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
         if curiositiesFilterData.count-1 == indexPath.row {
            
            if self.isAPICalled && !isFilter{

                self.isAPICalled = false
                self.page += 1
                self.getData(self.page)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}


