//
//  GFunctions.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import Foundation
import MBProgressHUD

class GFunctions: NSObject {
    
    static let shared: GFunctions = GFunctions()
    var progressHud: MBProgressHUD = MBProgressHUD()
        
    func addLoader(_ message : String? = nil) {
        
        self.removeLoader()
        let sDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate

        DispatchQueue.main.async {
            self.progressHud = MBProgressHUD(view: sDelegate.window!)
            self.progressHud.mode = MBProgressHUDMode.indeterminate
            self.progressHud.contentColor = .white
            self.progressHud.bezelView.color = .darkGray
            self.progressHud.bezelView.style = .solidColor
            
            sDelegate.window?.addSubview(self.progressHud)
            self.progressHud.show(animated: true)
        }
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            self.progressHud.hide(animated: true)
            self.progressHud.show(animated: false)
            self.progressHud.removeFromSuperview()
        }
    }
    
    func showFilterOption(filterOptionArray: [FilterModel], completion: @escaping (_ respon: String?) -> Void){
        
        let optionMenu = UIAlertController(title: "Rover Cameras", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        for obj in filterOptionArray {
            let deleteAction = UIAlertAction(title: "\(obj.fullName)", style: .default, handler: { (UIAlertAction) in
                completion(obj.shortName)
            })
            optionMenu.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            completion(nil)
        })
        optionMenu.addAction(cancelAction)
        UIApplication.topViewController()?.present(optionMenu, animated: true, completion: nil)
    }

   
}
