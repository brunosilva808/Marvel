//
//  HomeViewController.swift
//  Marvel
//
//  Created by Bruno Silva on 16/11/2018.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var comics: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        getComics()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? FullScreenViewController,
           let indexPath = sender as? IndexPath {
            destinationViewController.result = comics?.data.results[indexPath.row]
        }
    }
    
    func getComics() {
        Service.shared.getComics(filters: [.cover, .format], onSuccess: { [weak self] (comics) in
            self?.comics = comics
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }) {}
    }
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.backgroundColor = .black
        self.collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics?.data.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.label.text = "\(indexPath.row)"
        
        cell.result = comics?.data.results[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Home -> FullScreen", sender: indexPath)
    }

}
