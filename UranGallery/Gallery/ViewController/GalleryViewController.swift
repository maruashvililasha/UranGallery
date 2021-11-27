//
//  ViewController.swift
//  UranGallery
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import UIKit
import UranNetworking
import ProgressHUD
import Kingfisher

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var trashbinButton: UIButton!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var viewModel : GalleryViewModel!
    var searchMode = false {
        didSet {
            toggleSearchMode()
        }
    }
    
    var isSelectionMode = false {
        didSet {
            toggleSelectionMode()
        }
    }
    
    var images : [UGImage] = [] {
        didSet {
            galleryCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GalleryViewModel()
        setupUI()
        getGalleryData()
    }
    
    private func setupUI() {
        // Navigation Controller
        self.title = "Uran Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        // Search Controller
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Image"
        navigationItem.searchController = search
        // CollectionView
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        // Buttons
        pageControl.isHidden = false
        trashbinButton.isHidden = true
    }
    
    private func toggleSearchMode() {
        galleryCollectionView.allowsMultipleSelection = searchMode
        galleryCollectionView.reloadData()
        if searchMode {
//            pageLabel.text = "\(currentSearchPage)"
        } else {
//            pageLabel.text = "\(currentPage)"
        }
    }
    
    private func toggleSelectionMode() {
        pageControl.isHidden = isSelectionMode
        trashbinButton.isHidden = !isSelectionMode
    }
    
    private func getGalleryData() {
        ProgressHUD.show()
        viewModel.getIamges(page: 1) { [weak self] images in
            ProgressHUD.dismiss()
            self?.images = images
        } errorHandler: { error in
            guard error.errorType == .toBeShown else {
                print(error)
                return
            }
            ProgressHUD.showError(error.errorMessage)
        }
    }
    
    private func fullScreenImage(image: UGImage) {
        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.black
        let placeHolder = UIImage(named: "placeholder")
        imageView.kf.setImage(with: URL(string: image.urls.regular), placeholder: placeHolder)
        imageView.tag = 100
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.removeImage))
        imageView.addGestureRecognizer(dismissTap)
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0
        let window = self.view.window
        window?.addSubview(imageView)
        window?.bringSubviewToFront(imageView)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            imageView.alpha = 1
        }
    }
    
    @objc private func removeImage() {
        guard let imageView = self.view.window?.viewWithTag(100) as? UIImageView else {
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            imageView.alpha = 0
        } completion: { _ in
            imageView.removeFromSuperview()
        }
    }
    
    @IBAction func trashbinButtonDidTap(_ sender: UIButton) {
        guard let selectedIndexes = galleryCollectionView.indexPathsForSelectedItems else {return}
        for index in selectedIndexes {
            images.remove(at: index.row)
        }
        galleryCollectionView.deleteItems(at: selectedIndexes)
        isSelectionMode = false
    }
}

extension GalleryViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 2 else {
            self.searchMode = false
            return
        }
        searchMode = true
        print(searchText)
        
        galleryCollectionView.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Cell Not Found")
        }
        cell.configure(with: images[indexPath.row], isSearchMode: searchMode)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !searchMode else {
            isSelectionMode = true
            return
        }
        let image = images[indexPath.row]
        fullScreenImage(image: image)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForSelectedItems?.count == 0 {
            isSelectionMode = false
        }
    }

}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat
        if searchMode {
            width = self.view.frame.width
        } else {
            width = (self.view.frame.width - 11) / 3
        }
        return CGSize(width: width, height: width)
    }
}
