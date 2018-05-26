//
//  TabButton.swift
//  TabbedCollectionView
//
//  Created by Guilherme Moura on 12/1/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

class TabButton: UIButton {
    var bgColor = UIColor(white: 0.95, alpha: 1.0) {
        didSet {
            backgroundColor = bgColor
        }
    }
    var selectionColor = UIColor(red:0.9, green:0.36, blue:0.13, alpha:1)
    var titleColor = UIColor.darkText {
        didSet {
            buildAttributedTitle()
        }
    }
    private var title = ""
    private var image: UIImage?
    private var attributedTitle = NSAttributedString()
    
    init(title: String, image: UIImage?, color: UIColor) {
        self.title = title
        self.image = image
        super.init(frame: CGRect.zero)
        buildAttributedTitle()
        backgroundColor = bgColor
        tintColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = bgColor
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue || isSelected {
                backgroundColor = UIColor(white: 0.87, alpha: 1.0)
            } else {
                backgroundColor = bgColor
            }
            super.isHighlighted = newValue
        }
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                backgroundColor = UIColor(white: 0.87, alpha: 1.0)
            } else {
                backgroundColor = bgColor
            }
            super.isSelected = newValue
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        
        //修改背景颜色
        self.backgroundColor!.setFill()
        UIRectFill(rect)
        
        if isSelected {
            let underscore = UIBezierPath()
            underscore.lineWidth = 3.0
            underscore.move(to: CGPoint(x:rect.origin.x, y:rect.size.height))
            underscore.addLine(to: CGPoint(x:rect.size.width, y:rect.size.height))
            selectionColor.setStroke()
            underscore.stroke()
        }
        
        if self.image != nil {
            let imageFrame = CGRect(x: rect.width/2.0 - 8.0, y: 3, width: 16, height: 16)
            self.tintColor.setFill()
            image!.draw(in: imageFrame)
            
            let textFrame = CGRect(x: 4, y: 20, width: rect.width - 8, height: 14)
            attributedTitle.draw(in: textFrame)
        } else {
            let textFrame = CGRect(x: 4, y: height / 2 - 10, width: rect.width - 8, height: 20)
            attributedTitle.draw(in: textFrame)
        }
    }
    
    func buildAttributedTitle() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingMiddle
        let attributes: [String: AnyObject] = [NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSParagraphStyleAttributeName: paragraphStyle]
        self.attributedTitle = NSAttributedString(string: title, attributes: attributes)
    }
}
