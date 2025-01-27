//
//  BoardSceneFactoryProtocol.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/13.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol BoardSceneFactoryProtocol {
    func makeBoardView(withBoardName boardName: String) -> BoardView
    func makeArticleView(withBoardArticle boardArticle: BoardArticle) -> ArticleView
    func makeComposeArticleView(withBoardName boardName: String) -> UIViewController
}
