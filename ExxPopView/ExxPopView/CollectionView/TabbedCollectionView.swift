//
//  TabbedCollectionView.swift
//  TabbedCollectionView
//
//  Created by Guilherme Moura on 12/1/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public protocol TabbedCollectionViewDataSource: class {
    func collectionView(collectionView: TabbedCollectionView, numberOfItemsInTab tab: Int) -> Int
    func collectionView(collectionView: TabbedCollectionView, titleForItemAtIndexPath indexPath: NSIndexPath) -> String
    func collectionView(collectionView: TabbedCollectionView, imageForItemAtIndexPath indexPath: NSIndexPath) -> (UIImage?, NSURL?)
    func collectionView(collectionView: TabbedCollectionView, colorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor
    func collectionView(collectionView: TabbedCollectionView, titleColorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor
    func collectionView(collectionView: TabbedCollectionView, backgroundColorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor
}

public protocol TabbedCollectionViewDelegate: class {
    func collectionView(collectionView: TabbedCollectionView, didSelectItemAtIndex index: Int, forTab tab: Int)
    
    func collectionView(collectionView: TabbedCollectionView, didSelectTabAtIndex tab: Int)
}

@IBDesignable public class TabbedCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var view: UIView!
    var topViewFixWidth = true      //固定宽度
    var col = 4
    var row = 4


    private var tabWidth: CGFloat = 80.0
    private let tabHeight: CGFloat = 32.0
    private var tabsInfo = [ItemInfo]()
    private var buttonTagOffset = 4827
    private var selectedTab = 0
    private var currentPage = 0
    private var cellWidth: CGFloat {
        return collectionView.frame.width / CGFloat(col)
    }
    private var cellHeight: CGFloat {
        return collectionView.frame.height / CGFloat(row) - 0.5
    }
    private var userInteracted = false
    private var storedOffset = CGPoint.zero
    
    let sectionInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    
    @IBOutlet weak var tabsScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public weak var dataSource: TabbedCollectionViewDataSource?
    public weak var delegate: TabbedCollectionViewDelegate?
    public var selectionColor = UIColor(red:0.9, green:0.36, blue:0.13, alpha:1.0)
//    {
//        didSet {
//            reloadTabs()
//        }
//    }
    public var tabTitleColor = UIColor.darkText
//    {
//        didSet {
//            reloadTabs()
//        }
//    }
    public var tabBackgroundColor = UIColor(white: 0.95, alpha: 1.0)
//    {
//        didSet {
//            reloadTabs()
//        }
//    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    public func createTabs(items: [ItemInfo]) {
//        tabsInfo = items
//        reloadTabs()
//    }
    
    public func updateLayout() {
//        let layout = HorizontalFlowLayout()
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Private functions
    private func loadXib() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        setupCollectionView()
    }
    
    private func loadViewFromNib() -> UIView {
//        let bundle = Bundle(for: )
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TabbedCollectionView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupCollectionView() {
//        let bundle = Bundle(for: dynamicType)
        let bundle = Bundle(for: type(of: self))
//        let bundle = Bundle(forClass: dynamicType)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "ItemCell")
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: "ItemCell")
        updateLayout()
        storedOffset = collectionView.contentOffset
    }
    
    private func reloadTabs() {
        if topViewFixWidth {
            tabWidth = self.bounds.width / CGFloat(tabsInfo.count)
            tabsScrollView.isScrollEnabled = false
        }

        let _ = tabsScrollView.subviews.map { $0.removeFromSuperview() }
        var i = 0
        var offsetX: CGFloat = 0
        for item in tabsInfo {
            let button = TabButton(title: item.title, image: item.image, color: item.color)
            button.selectionColor = selectionColor
            button.titleColor = tabTitleColor
            button.bgColor = tabBackgroundColor
            button.frame = CGRect(x: offsetX, y: 0, width: tabWidth, height: tabHeight)
            button.tag = i + buttonTagOffset
            button.addTarget(self, action: #selector(self.tabSelected(sender:)), for: .touchUpInside)
            if i == selectedTab {
                button.isSelected = true
            }
            tabsScrollView.addSubview(button)
            offsetX = offsetX + tabWidth
            i = i + 1
        }
        
        if topViewFixWidth {
            tabsScrollView.contentSize = CGSize(width: self.tabsScrollView.bounds.width, height: tabHeight)
        } else {
            tabsScrollView.contentSize = CGSize(width: CGFloat(i)*tabWidth, height: tabHeight)
        }
    }
    
    @objc func tabSelected(sender: UIButton) {
        // Deselect previous tab
        if let previousSelected = tabsScrollView.viewWithTag(selectedTab + buttonTagOffset) as? UIButton {
            previousSelected.isSelected = false
        }
        // Select current tab
        sender.isSelected = true
        
        let tag = sender.tag
        selectedTab = tag - buttonTagOffset
        // Updated collection view
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 10, height: 10), animated: false)
        
        self.delegate?.collectionView(collectionView: self, didSelectTabAtIndex: selectedTab)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView data source methods

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func getSelectedTab()-> Int{
        return self.selectedTab
    }
    
    public func setSelectedTab(index:Int){
        self.selectedTab = index
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numItems = dataSource?.collectionView(collectionView: self, numberOfItemsInTab: selectedTab) else {
             return 0
        }
       
        return numItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCollectionViewCell
        cell.selectionColor = selectionColor
//        let tabIndexPath = IndexPath(forRow: indexPath.row, inSection: selectedTab)
        let tabIndexPath = IndexPath(row: indexPath.row, section: selectedTab)
//        cell.textLabel.text = dataSource?.collectionView(self, titleForItemAtIndexPath: tabIndexPath)
        cell.textLabel.text = dataSource?.collectionView(collectionView: self, titleForItemAtIndexPath:  tabIndexPath as NSIndexPath)
//        let imageData = dataSource?.collectionView(self, imageForItemAtIndexPath: tabIndexPath)
        let imageData = dataSource?.collectionView(collectionView: self, imageForItemAtIndexPath: tabIndexPath as NSIndexPath)
        if imageData?.0 != nil {
            cell.imageView.image = imageData!.0
        }
        if imageData?.1 != nil {
//            let url = URL(string: imageData!.1!)
//            cell.imageView.af_setImage(withURL: imageData!.1! as URL)
//            cell.imageView.af_setImageWithURL(imageData!.1!)
        }
        
//        cell.imageView.tintColor = dataSource?.collectionView(self, colorForItemAtIndexPath: tabIndexPath)
//        cell.textLabel.textColor = dataSource?.collectionView(self, titleColorForItemAtIndexPath: tabIndexPath)
//        cell.contentView.backgroundColor = dataSource?.collectionView(self, backgroundColorForItemAtIndexPath: tabIndexPath)
        
        cell.imageView.tintColor = dataSource?.collectionView(collectionView: self, colorForItemAtIndexPath: tabIndexPath as NSIndexPath)
        cell.textLabel.textColor = dataSource?.collectionView(collectionView: self, titleColorForItemAtIndexPath: tabIndexPath as NSIndexPath)
        cell.contentView.backgroundColor = dataSource?.collectionView(collectionView: self, backgroundColorForItemAtIndexPath: tabIndexPath as NSIndexPath)
        return cell
    }
    
    // MARK: - UICollectionView delegate methods
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView: self, didSelectItemAtIndex: indexPath.row, forTab: selectedTab)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
//    public func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
    

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userInteracted = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if !decelerate {
            userInteracted = false
//            storedOffset = collectionView.contentOffset
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userInteracted = false
//        storedOffset = collectionView.contentOffset
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !userInteracted {
//            collectionView.contentOffset = storedOffset
        }
    }
}
