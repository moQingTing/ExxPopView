//
//  UIViewController+CHSemiViewController.swift
//  bter_app
//
//  Created by 麦志泉 on 16/7/12.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

// MARK: - CHSemiViewController扩展功能
extension UIViewController {
    
    func showSemiViewController(semiVC: CHSemiViewController, direction: CHSemiViewControllerDirection) {
        
        if semiVC.isShowed {  //显示了就收回
            semiVC.dismissSemi()
            return
        }
        
        
        semiVC.direction = direction;
        var selfFrame = self.view.bounds;
        semiVC.view.frame = selfFrame
        self.view.addSubview(semiVC.view)
        
        switch (direction) {
        case .Right:
            selfFrame.origin.x += selfFrame.size.width;
            break;
        case .Left:
            selfFrame.origin.x -= selfFrame.size.width;
            break;
        case .Up:
            selfFrame.origin.y -= selfFrame.size.height;
            break;
        case .Down:
            selfFrame.origin.y += selfFrame.size.height;
            break;
        }

        semiVC.contentView.frame = CGRect(x: semiVC.contentView.frame.origin.x, y: selfFrame.origin.y, width: semiVC.contentView.frame.size.width, height: semiVC.contentView.frame.size.height)
    
        
        self.addChildViewController(semiVC)
        semiVC.willMove(toParentViewController: self)
        
    }
}
