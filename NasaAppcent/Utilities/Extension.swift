//
//  Extensions.swift
//  NasaAppcent
//
//  Created by Furkan Başoğlu on 8.08.2021.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView{
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setImgWebUrl(url : String, isIndicator : Bool){
        
        if isIndicator == true{
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
            self.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "default"), options: .lowPriority, progress: nil
            , completed: { (image, error, cacheType, url) in
                guard image != nil else {
                    return
                }
            })
    }
}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


