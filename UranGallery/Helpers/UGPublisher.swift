//
//  UGPublisher.swift
//  UranGallery
//
//  Created by Lasha Maruashvili on 28.11.21.
//

import Foundation
/// Uran Gallery Publisher for emmiting values to listeners
final class UGPublisher<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
    
  init(_ value: T) {
    self.value = value
  }

  func bind(listener: Listener?) {
    self.listener = listener
  }
}
