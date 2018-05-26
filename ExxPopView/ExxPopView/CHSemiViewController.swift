//
//  CHSemiViewController.swift
//  bter_app
//
//  Created by 麦志泉 on 16/7/12.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

/**
 弹出方向
 
 - Left:
 - Right:
 - Top:
 - Bottom:
 */
enum CHSemiViewControllerDirection {
    case Left
    case Right
    case Up
    case Down
}

class CHSemiViewController: UIViewController {
    
    var direction: CHSemiViewControllerDirection = .Up
    var sideAnimationDuration: TimeInterval = 0.3
    var sideOffset: CGFloat = 50

    var contentView: UIView!
    var coverView: UIView!
    var isShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.contentView = UIView()
        self.contentView.backgroundColor = UIColor.clear
        
        let anotherView = UIView()
        anotherView.frame = self.view.bounds
        coverView = anotherView
        anotherView.backgroundColor = UIColor.clear
        anotherView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(CHSemiViewController.dismissSemi))
        
//        let tap = UITapGestureRecognizer(target: self,
//                                         action: nil)
        
        let swipe = UISwipeGestureRecognizer(target: self,
                                             action: #selector(CHSemiViewController.dismissSemi))
        
        
        var selfViewFrame = self.view.bounds
        
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
//        let tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 0
//        let outViewHeight = statusBarHeight + navigationBarHeight + tabbarHeight
        
        switch self.direction {
        case .Left:
            selfViewFrame.size.width = selfViewFrame.width - self.sideOffset
            
            self.contentView.frame = selfViewFrame
            self.contentView.autoresizingMask = [
                UIViewAutoresizing.flexibleWidth,
                UIViewAutoresizing.flexibleHeight,
                UIViewAutoresizing.flexibleLeftMargin
            ]
            
//            anotherView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin;
//            
//            selfViewFrame.size.width = self.sideOffset;
//            selfViewFrame.origin.x = CGRectGetMaxX(self.contentView.frame);
//            anotherView.frame = selfViewFrame;
            
            swipe.direction = UISwipeGestureRecognizerDirection.left;
            
        case .Right:
            selfViewFrame.size.width = selfViewFrame.width - self.sideOffset;
            selfViewFrame.origin.x = self.sideOffset;
            self.contentView.frame = selfViewFrame;
            self.contentView.autoresizingMask = [
                UIViewAutoresizing.flexibleWidth,
                UIViewAutoresizing.flexibleHeight,
                UIViewAutoresizing.flexibleRightMargin
            ]
            
//            selfViewFrame.origin.x = CGRectGetMinX(self.view.bounds);
//            selfViewFrame.size.width = self.sideOffset;
//            anotherView.frame = selfViewFrame;
            
            swipe.direction = UISwipeGestureRecognizerDirection.right;
        case .Up:
            selfViewFrame.size.height = selfViewFrame.height - self.sideOffset;
//            selfViewFrame.size.height = selfViewFrame.height
            self.contentView.frame = selfViewFrame
            self.contentView.autoresizingMask = [
                UIViewAutoresizing.flexibleWidth,
                UIViewAutoresizing.flexibleHeight,
                UIViewAutoresizing.flexibleTopMargin
            ]
            
//            anotherView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin;
//            
//            selfViewFrame.size.height = self.sideOffset;
//            selfViewFrame.origin.y = CGRectGetMaxY(self.contentView.frame);
//            anotherView.frame = selfViewFrame;
            
            swipe.direction = UISwipeGestureRecognizerDirection.up;
        case .Down:
            selfViewFrame.size.height = selfViewFrame.height - self.sideOffset;

//            selfViewFrame.origin.y = self.sideOffset;
            self.contentView.frame = selfViewFrame
            self.contentView.autoresizingMask = [
                UIViewAutoresizing.flexibleWidth,
                UIViewAutoresizing.flexibleHeight,
                UIViewAutoresizing.flexibleBottomMargin
            ]
            
//            selfViewFrame.origin.y = CGRectGetMinX(self.view.bounds);
//            selfViewFrame.size.height = self.sideOffset;
//            anotherView.frame = selfViewFrame;
            
            swipe.direction = UISwipeGestureRecognizerDirection.down;
            
        }
        
        
        self.view.addSubview(anotherView)
        self.view.addSubview(self.contentView)
        anotherView.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(swipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
        
        UIView.animate(withDuration: self.sideAnimationDuration, animations: {
            var selfViewFrame = self.contentView.frame;
            selfViewFrame.origin.x = 0.0
            selfViewFrame.origin.y = 0.0
            self.contentView.frame = selfViewFrame
            self.coverView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        }) { (finished) in
            super.willMove(toParentViewController: parent)
            self.isShowed = true
        }
    }
    
    
    @objc func dismissSemi() {
        
        if !self.isShowed {  //显示了就收回
            return
        }
//        self.willMoveToParentViewController(nil)
        
        //处理多次点击闪退问题,因为多次点击self.parent会丢失为nil
        if (self.parent == nil)
        {
            return
        }
        
        
        let pareViewRect = self.parent!.view.bounds
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        switch (self.direction) {
        case .Left:
            originX -= pareViewRect.width;
            break;
        case .Right:
            originX += pareViewRect.width;
        case .Up:
            originY -= pareViewRect.height;
        case .Down:
            originY += pareViewRect.height;
        }
        
        UIView.animate(
            withDuration: self.sideAnimationDuration, animations: {
//                self.contentView.frame = CGRect(originX, originY,
//                    self.contentView.frame.size.width,
//                    self.contentView.frame.size.height);
//                self.contentView.frame = CGRect(x: originX, y: originY, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
                self.contentView.frame = CGRect(x: originX, y: originY, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
                self.coverView.backgroundColor = UIColor.clear
        }) { (finished) in
            self.view.removeFromSuperview()
            self.isShowed = false
        }
        self.removeFromParentViewController()
    }
    
}
