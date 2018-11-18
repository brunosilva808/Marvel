//
//  ImageView.swift
//  Marvel
//
//  Created by Carbon on 18/11/2018.
//

import UIKit

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }).resume()
    }
    
}
