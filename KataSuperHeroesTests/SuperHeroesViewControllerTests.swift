//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    fileprivate let repository = MockSuperHeroesRepository()
    let numberOfSuperHeroes = 5
    
    
    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testShowsSuperHeroesIfThereAreSuperHeroes(){
        _ = givenThereAreSomeSuperHeroes(10)
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testShowsListOfSuperHeroesOnScreen(){
        _ = givenThereAreSomeSuperHeroes(numberOfSuperHeroes)
        
        openSuperHeroesViewController()
        
        for i in 0..<numberOfSuperHeroes {
            tester().waitForView(withAccessibilityLabel: "SuperHero - \(i)")
        }
    }
    
    func testShowsListOfSuperHeroesThatSomeoneIsOutOfScreen(){
        _ = givenThereAreSomeSuperHeroes(20)
        
        openSuperHeroesViewController()

        tester().waitForAbsenceOfView(withAccessibilityLabel: "SuperHero - \(20)")
    }
    
    //Slow test -> Must refact
    func testSuperHeroes20AppearOnScreenWillBePainted(){
        _ = givenThereAreSomeSuperHeroes(20)
        
        openSuperHeroesViewController()
        
        for i in 0..<20 {
            testerCellSuperHeroes(index: i)
        }
    }
    
    // Check avenger symbol
    func testShowSuperHeroesAvengersIfSymbolIsPainted(){
        _ = givenThereAreSomeSuperHeroes(numberOfSuperHeroes, avengers: true)
        
        openSuperHeroesViewController()
        
        for i in 0..<numberOfSuperHeroes {
            tester().waitForView(withAccessibilityLabel: "SuperHero - \(i) - Avengers Badge")
        }
    }
    
    // test if loading view appear
    
    fileprivate func testerCellSuperHeroes(index: Int){
        tester().waitForCell(at: IndexPath.init(row: index, section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView")
        //Here we can acces to Cell and check all of properties
        tester().waitForView(withAccessibilityLabel: "SuperHero - \(index)")
    }
    
    fileprivate func givenThereAreNoSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes(0)
    }

    fileprivate func givenThereAreSomeSuperHeroes(_ numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

    fileprivate func openSuperHeroesViewController() {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
    }
}
