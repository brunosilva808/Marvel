//
//  ImageViewCell.swift
//  Marvel
//
//  Created by Bruno Silva on 16/11/2018.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var result: Result! {
        didSet {
            let urlString = Service.shared.getImageUrl(thumbnail: result.thumbnail, size: APIConstant.Portrait.medium)
            imageView.loadImageUsingUrlString(urlString: urlString)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
