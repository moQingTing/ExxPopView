//
//  VerticalFlowLayout.swift
//  bter_app
//
//  Created by 麦志泉 on 16/7/13.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

class VerticalFlowLayout: UICollectionViewLayout {
    var itemSize = CGSize.zero {
        didSet {
            invalidateLayout()
        }
    }
    private var cellCount = 0
    private var boundsSize = CGSize.zero
    
    override func prepare() {
        cellCount = self.collectionView!.numberOfItems(inSection: 0)
        boundsSize = self.collectionView!.bounds.size
    }
    
    override var collectionViewContentSize: CGSize {
        
            let verticalItemsCount = Int(floor(boundsSize.height / itemSize.height))
            let horizontalItemsCount = Int(floor(boundsSize.width / itemSize.width))
            
            let itemsPerPage = verticalItemsCount * horizontalItemsCount
            let numberOfItems = cellCount
            let numberOfPages = Int(ceil(Double(numberOfItems) / Double(itemsPerPage)))
            
            var size = boundsSize
            size.width = CGFloat(numberOfPages) * boundsSize.width
            return size
    }
    
//    func collectionViewContentSize() -> CGSize {
//        let verticalItemsCount = Int(floor(boundsSize.height / itemSize.height))
//        let horizontalItemsCount = Int(floor(boundsSize.width / itemSize.width))
//        
//        let itemsPerPage = verticalItemsCount * horizontalItemsCount
//        let numberOfItems = cellCount
//        let numberOfPages = Int(ceil(Double(numberOfItems) / Double(itemsPerPage)))
//        
//        var size = boundsSize
//        size.width = CGFloat(numberOfPages) * boundsSize.width
//        return size
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< cellCount {
            let indexPath = IndexPath(row: i, section: 0)
            let attr = self.computeLayoutAttributesForCellAtIndexPath(indexPath: indexPath as NSIndexPath)
            allAttributes.append(attr)
        }
        return allAttributes
    }
    
    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.computeLayoutAttributesForCellAtIndexPath(indexPath: indexPath as NSIndexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.bounds.size)
    }
    
    func computeLayoutAttributesForCellAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let row = indexPath.row
        let bounds = self.collectionView!.bounds
        
        let verticalItemsCount = Int(floor(boundsSize.height / itemSize.height))
        let horizontalItemsCount = Int(floor(boundsSize.width / itemSize.width))
        let itemsPerPage = verticalItemsCount * horizontalItemsCount
        
        let columnPosition = row % horizontalItemsCount
        let rowPosition = (row/horizontalItemsCount)%verticalItemsCount
        let itemPage = Int(floor(Double(row)/Double(itemsPerPage)))
        
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
        
        var frame = CGRect.zero
        frame.origin.x = CGFloat(itemPage) * bounds.size.width + CGFloat(columnPosition) * itemSize.width
        frame.origin.y = CGFloat(rowPosition) * itemSize.height
        frame.size = itemSize
        attr.frame = frame
        
        return attr
    }
}
