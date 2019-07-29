//
//  StartViewController.swift
//  InfinityHud
//
//  Created by Vladimir on 7/25/19.
//  Copyright © 2019 BVV. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBAction func showHudButtonPress(_ sender: Any) {
        showHudAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
    }
    
    private func showHudAction() {
        let hud = InfinityHud.init(in: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(arc4random()%10+5)) {
            hud.hide()
        }
    }

}
