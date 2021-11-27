//
//  UIView+Extensions.swift
//  UranGallery
//
//  Created by Lasha Maruashvili on 27.11.21.
//

import UIKit

extension UIView  {
    @IBInspectable
       var cornerRadius: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
               layer.masksToBounds = newValue > 0
           }
       }
}
