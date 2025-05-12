//
//  NetworkManager.swift
//  myMusicApp2
//
//  Created by 하다현 on 4/24/25.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정리
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}


//MARK: - 네트워킹 클래스 모델
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
//    let musicURL = "https://itunes.apple.com/search?media=music"
    
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    
    // 네트워킹 요청하는 함수 (음악 데이터 가져오기)
    func fetchMusic(searchTerm: String, completionHandler: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        
        performRequest(with: urlString) { result in
            completionHandler(result)
        }
    }
    
    
    
    
    // 실제 Request하는 함수
    private func performRequest(with urlString: String, completionHandler: @escaping NetworkCompletion) {

        // URL구조체 만들기
        guard let url = URL(string: urlString) else { return }
        
        // URL요청 생성
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        // 요청을 가지고 작업세션시작
        
        let task = session.dataTask(with: url) { data, response, error in
            if  error != nil {
                print(error!)
                completionHandler(.failure(.networkingError))
                return
            }
            
            // 옵셔널 바인딩
            guard let safeData = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            if let musics = self.parseJSON(safeData) {
                print("parse 실행")
                completionHandler(.success(musics))
            } else {
                print("parse 실패")
                completionHandler(.failure(.parseError))
            }

        }
        task.resume()     // 시작
    }
    
    
    
    
    // 받아온 데이터 분석하는 함수
    private func parseJSON(_ musicData: Data) -> [Music]? {
        // success
        do  {
            // 우리가 만들어놓은 구조체로 변환하는 메소드
            // json 데이터 -> MusicData 구조체
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        // fail
        } catch {
            print("📦 서버 응답 데이터:")
            print(String(data: musicData, encoding: .utf8) ?? "JSON 디코딩 불가")
            print(error.localizedDescription)
            return nil
        }
    }
    

}
