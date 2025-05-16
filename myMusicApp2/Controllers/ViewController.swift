//
//  ViewController.swift
//  myMusicApp2
//
//  Created by 하다현 on 4/24/25.
//

import UIKit

final class ViewController: UIViewController {
    
    // 서치 컨트롤러 생성 => 네비게이션 아이템에 할당
//    let searchController = UISearchController()
    
    // 서치 ResultsController
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    @IBOutlet weak var musicTableView: UITableView!
    
    // 네트워크 매니저 (싱글톤)
    var networkManager = NetworkManager.shared
    
    // (음악 데이터를 다루기 위함) 빈배열로 시작
    var musicArrays: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpTableView()
        setUpDatas()
    }
    
    // 서치바 세팅
    func setUpSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        // 서치바 사용
//        searchController.searchBar.delegate = self
        
        // 서치 컨트롤러 사용
        searchController.searchResultsUpdater = self
        
        // 첫 글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // 테이블뷰 셋팅
    func setUpTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    // 데이터 셋업
    func setUpDatas() {
        networkManager.fetchMusic(searchTerm: "indie") { result in
            switch result {
            case Result.success(let musicData):
                self.musicArrays = musicData
                
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
                
            case Result.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MyMusicCell
        
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}


//MARK: - 단순 서치바
//extension ViewController: UISearchBarDelegate {
//    
//    // 방법1. 유저가 글자를 입력하는 순간마다 호출되는 메서드
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//        
//        // 다시 빈 배열로 만들기
//        self.musicArrays = []
//        
//        // 네트워킹 시작
//        networkManager.fetchMusic(searchTerm: searchText) { result in
//            switch result {
//            case .success(let musicArrays):
//                self.musicArrays = musicArrays
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
    // 방법2. 검색 버튼을 눌렀을 때 호출되는 메서드
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else { return }
//        print(text)
//        
//        // 다시 빈 배열로 만들기
//        self.musicArrays = []
//        
//        // 네트워킹 시작
//        networkManager.fetchMusic(searchTerm: text) { result in
//            switch result {
//            case .success(let musicArrays):
//                self.musicArrays = musicArrays
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        self.view.endEditing(true)
//    }
//}


//MARK: - 검색하는 동안 새로운 화면을 보여주는 복잡한 기능 구현
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let vc = searchController.searchResultsController as! SearchResultViewController
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
