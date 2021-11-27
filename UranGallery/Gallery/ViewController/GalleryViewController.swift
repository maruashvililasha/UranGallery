//
//  ViewController.swift
//  UranGallery
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import UIKit
import UranNetworking

class GalleryViewController: UIViewController {
    
    var viewModel : GalleryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = GalleryViewModel()
    }
    
    private func setupUI() {
        
    }
    
    private func getData() {
        
    }
    
    func addImageViewWithImage(image: UIImage) {
        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.image! = image
        imageView.tag = 100
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.removeImage))
        dismissTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(dismissTap)
        self.view.addSubview(imageView)
    }
    
   @objc func removeImage() {
        let imageView = (self.view.viewWithTag(100)! as! UIImageView)
        imageView.removeFromSuperview()
    }
}

