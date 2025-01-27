//
//  PopularArticlesCoordinator.swift
//  Ptt
//
//  Created by Anson on 2021/12/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

final class PopularArticlesCoordinator: BaseCoordinator {
    private let factory: PopularArticlesSceneFactoryProtocol & PopularArticlesSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(router: Routerable, factory: PopularArticlesSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        showPopularArticlesView()
    }
}

private extension PopularArticlesCoordinator {
    func showPopularArticlesView() {
        let popularArticlesView = factory.makePopularArticlesView()
        popularArticlesView.setup { [weak self] boardArticle in
            self?.showArticleView(withBoardArticle: boardArticle)
        }

        router.setRootModule(popularArticlesView)
    }

    func showArticleView(withBoardArticle boardArticle: BoardArticle) {
        let articleView = factory.makeArticleView(withBoardArticle: boardArticle)
        router.push(articleView)
    }
}
