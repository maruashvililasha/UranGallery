//
//  GalleryViewModel.swift
//  UranGallery
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import Foundation
import UranNetworking
import Combine

class GalleryViewModel {
    
    let countPerPage = 30
    
    var imagesPublisher : UGPublisher<[UGImage]> = UGPublisher([])
    var errorPublisher : UGPublisher<UGError?> = UGPublisher(nil)
    
    func getIamges(page: Int) {
        dataRepo.getImages(page: page, countPerPage: countPerPage, sortBy: .latest) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorPublisher.value = error
            case .success(let images):
                self?.imagesPublisher.value = images
            }
        }
    }
    
    func searchForIamges(page: Int, query: String) {
        dataRepo.searchImages(page: page, countPerPage: countPerPage, query: query) {[weak self] result in
            switch result {
            case .failure(let error):
                self?.errorPublisher.value = error
            case .success(let images):
                self?.imagesPublisher.value = images
            }
        }
    }
}
