//
//  SuperHeroesDetailViewController.swift
//  KataSuperHeroesTests
//
//  Created by Fernando García Fernández on 20/11/17.
//  Copyright © 2017 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesDetailViewControllerTests: AcceptanceTestCase {
    
    fileprivate let repository = MockSuperHeroesRepository()
    let superHeroName = "Test"
    
    func testShowSuperHeroAppear(){
        getASuperHero(name: superHeroName)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testShowSuperHeroAndLoaderAppear(){
        getASuperHero(name: superHeroName)
        repository.isInfinite = true
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForView(withAccessibilityLabel: "LoadingView")
    }
    
    func testShowSuperHeroNameIsSuperHeroName(){
        getASuperHero(name: superHeroName)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForView(withAccessibilityLabel: "Name: \(superHeroName)")
    }
    
    func testShowSuperHeroNameIsNotAnotherSuperHeroName(){
        getASuperHero(name: superHeroName)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Name Test2")
    }
    
    func testShowSuperHeroDetailIsSuperHeroDetail(){
        getASuperHero(name: superHeroName)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForView(withAccessibilityLabel: "Description: \(superHeroName)")
    }
    
    func testShowSuperHeroDetailIsNotAnotherSuperHeroDetail(){
        getASuperHero(name: superHeroName)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Description: Test2")
    }
    
    func testShowSuperHeroBadgeAvengerShowedWhenIsAvenger(){
        getASuperHero(name: superHeroName, avengers: true)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForView(withAccessibilityLabel: "Avengers Badge")
    }
    
    func testShowSuperHeroNotBadgeAvengerNotShowedAvengerSymbol(){
        getASuperHero(name: superHeroName)
        
        openSuperHeroDetailViewController(name: superHeroName)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Avengers Badge")
    }
    
    fileprivate func getASuperHero(name: String, avengers: Bool = false){
        var superHeroes = [SuperHero]()
        let superHero = SuperHero(name: name,
            photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
            isAvenger: avengers, description: "Description - \(name)")
        superHeroes.append(superHero)
        repository.superHeroes = superHeroes
    }
    
    fileprivate func getNoOne(){
        repository.superHeroes = []
    }
    
    fileprivate func openSuperHeroDetailViewController(name: String) {
        let superHeroDetailViewController = ServiceLocator()
            .provideSuperHeroDetailViewController(name) as! SuperHeroDetailViewController
        superHeroDetailViewController.presenter = SuperHeroDetailPresenter(ui: superHeroDetailViewController, superHeroName: name, getSuperHeroByName: GetSuperHeroByName(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroDetailViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
    }
}
