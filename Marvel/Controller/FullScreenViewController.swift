//
//  FullScreenViewController.swift
//  Marvel
//
//  Created by Carbon on 18/11/2018.
//

import UIKit

class FullScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    var result: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = Service.shared.getImageUrl(thumbnail: result.thumbnail, size: APIConstant.Portrait.Void())
        imageView.loadImageUsingUrlString(urlString: urlString)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
