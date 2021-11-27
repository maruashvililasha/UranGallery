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
    
    func getIamges(page: Int, successHandler: @escaping([UGImage])  -> Void, errorHandler: @escaping(UGError) -> Void) {
        dataRepo.getImages(page: page, countPerPage: countPerPage, sortBy: .latest) { result in
            switch result {
            case .failure(let error):
                errorHandler(error)
            case .success(let images):
                successHandler(images)
            }
        }
    }
    
    func searchForIamges(page: Int, query: String, successHandler: @escaping([UGImage])  -> Void, errorHandler: @escaping(UGError) -> Void) {
        dataRepo.searchImages(page: page, countPerPage: countPerPage, query: query) { result in
            switch result {
            case .failure(let error):
                errorHandler(error)
            case .success(let images):
                successHandler(images)
            }
        }
    }
}
