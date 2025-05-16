//
//  Constants.swift
//  myMusicApp2
//
//  Created by 하다현 on 4/24/25.
//

//MARK: - Name Space 만들기

import UIKit

public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}


public struct Cell {
    static let musicCellIdentifier = "MyMusicCell"
    static let musicCollectionViewCellIdentifier = "MusicCollectionViewCell"
    private  init() {}
}


public struct CVCell{
    static let spacingWidth: CGFloat = 1
    static let cellColums: CGFloat = 3
    private init() {}
}
