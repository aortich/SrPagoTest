//
//  UIImageView+UrlImage.swift
//  srpagotest
//
//  Created by Alberto Ortiz on 2/5/20.
//  Copyright © 2020 Alberto Ortiz. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
