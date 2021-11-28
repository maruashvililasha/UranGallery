//
//  ImageCollectionViewCell.swift
//  UranGallery
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import UIKit
import UranNetworking
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkMarkImageView: UIImageView!

    var isSearchMode = false
    
    func configure(with image: UGImage, isSearchMode: Bool) {
        self.isSearchMode = isSearchMode
        var imageURL : URL?
        if isSearchMode {
            imageURL = URL(string: image.urls.regular)
            checkMarkImageView.alpha = isSelected ? 1 : 0
        } else {
            imageURL = URL(string: image.urls.thumb)
            checkMarkImageView.alpha = 0
        }
        let placeHolder = UIImage(named: "placeholder")
        self.imageView.kf.setImage(with: imageURL, placeholder: placeHolder)
    }
    
    override var isSelected: Bool {
            didSet {
                guard isSearchMode else { return }
                if self.isSelected {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.checkMarkImageView.alpha = 1
                    }
                }
                else {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.checkMarkImageView.alpha = 0
                    }
                }
            }
        }
}
