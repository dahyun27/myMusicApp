//
//  SearchResultViewController.swift
//  myMusicApp2
//
//  Created by 하다현 on 5/16/25.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let flowLayout = UICollectionViewFlowLayout()
    
    let networkManager = NetworkManager.shared
    
    var musicArrays: [Music] = []
    
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupCollectionView()
    }
    

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWidth *
                                   (CVCell.cellColums - 1)) / CVCell.cellColums
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = CVCell.spacingWidth
        flowLayout.minimumLineSpacing = CVCell.spacingWidth
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    
    func setupDatas() {
        guard let term = searchTerm else { return }
        
        self.musicArrays = []
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        
        cell.imageUrl = musicArrays[indexPath.item].imageUrl
        
        return cell
        
    }
}
