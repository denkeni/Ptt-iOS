//
//  ApplicationCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

fileprivate var onboardingWasShown = true
fileprivate var isAutorized = false

fileprivate enum LaunchInstructor {
    case main, auth, onboarding
    
    static func configure(
        tutorialWasShown: Bool = onboardingWasShown,
        isAutorized: Bool = isAutorized) -> LaunchInstructor {
        
        switch (tutorialWasShown, isAutorized) {
        case (true, false), (false, false): return .auth
        case (false, true): return .onboarding
        case (true, true): return .main
        }
    }
}

final class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        switch instructor {
        case .onboarding: runOnboardingFlow()
        case .auth: runAuthFlow()
        case .main: runMainFlow()
        }
    }
    
    private func runAuthFlow() {
        // TODO: 登入流程放這邊
        // uncomment to force logout
        // _ = LoginKeyChainItem.shared.removeToken()
        
        if LoginKeyChainItem.shared.readToken() != nil {
            isAutorized = true
            // TODO: check token Expire from internet
            runMainFlow()
        }
        else {
            isAutorized = false
            
            let loginCoordinator = coordinatorFactory.makeLoginCoordinator(router: self.router)
            (loginCoordinator as? LoginCoordinator)?.finshFlow = { [unowned self] in
                // authed
                self.removeDependency(self)
                start()
            }
            self.addDependency(loginCoordinator)
            loginCoordinator.start()
        }
    }
    
    private func runOnboardingFlow() {
        //  TODO: 目前雖然沒看到，但如果有考慮介紹給使用者官方App的好處可以放這邊
//        let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
//        coordinator.finishFlow = { [weak self, weak coordinator] in
//            onboardingWasShown = true
//            self?.start()
//            self?.removeDependency(coordinator)
//        }
//        addDependency(coordinator)
//        coordinator.start()
    }
    
    private func runMainFlow() {
        let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
        addDependency(coordinator)
        
        (coordinator as? TabBarCoordinator)?.finshFlow = { [unowned self] () in
            print("finish flow in TabBarCoordinator for logout")
            removeDependency(self)
            isAutorized = false
            start()
        }
        router.setRootModule(module, hideBar: true, animated: true)
        coordinator.start()
    }
}
