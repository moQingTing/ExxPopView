//
//  SelectExchangeCurrencyViewController.swift
//  bter_app
//
//  Created by 麦志泉 on 16/7/12.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

class Item: ItemInfo {
    @objc var title: String = ""
    @objc var image: UIImage?
    @objc var color = UIColor.black
}

protocol SelectExchangeCurrencyViewDelegate {
    
    /**
     选择交易货币
     
     - parameter vc:
     - parameter didSelectCurrency:
     - parameter exchangeCurrency:
     */
    func selectExchangeCurrencyView(vc: SelectExchangeCurrencyViewController, didSelectCurrency: CurrencySet, exchangeCurrency: CurrencySet)
    
    /**
     点击兑换单位货币
     
     - parameter vc:
     - parameter didSelectExchange:
     */
    func selectExchangeCurrencyView(vc: SelectExchangeCurrencyViewController, didSelectExchange: CurrencySet)
}

class SelectExchangeCurrencyViewController: CHSemiViewController {
    
    var delegate: SelectExchangeCurrencyViewDelegate?
    var exchangeCurrencys = [CurrencySet]()
    var allCurrencys = [CurrencySet]()
    var tabbed = TabbedCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabbed.frame = self.contentView.bounds
        //初始化数据
//        self.setupTabData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

// MARK: - 控制器方法
extension SelectExchangeCurrencyViewController {
    
    /**
     配置UI
     */
    func setupUI() {
        self.contentView.alpha = 1
        self.contentView.backgroundColor = UIColor.white
        
        //添加tab网格选择器
//        tabbed.translatesAutoresizingMaskIntoConstraints = false
        tabbed.dataSource = self
        tabbed.delegate = self

        self.contentView.addSubview(tabbed)


        tabbed.selectionColor = ExchangeType.Buy.typeColor()
        
        
        
        //布局
//        let views = ["tabbed": tabbed]
//        
//        //水平布局
//        self.contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-0-[tabbed]-0-|",
//                options: NSLayoutFormatOptions(),
//                metrics: nil,
//                views:views))
//        //垂直
//        self.contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:|-0-[tabbed]-0-|",
//                options: NSLayoutFormatOptions(),
//                metrics: nil,
//                views:views))
        
        
    }
    
    //配置Tab数据
//    func setupTabData() {
//        
//        var items = [Item]()
//        
//        for currency in self.exchangeCurrencys {
//            let obj = Item()
//            obj.title = "兑".localized() + currency.currencyType
//            items.append(obj)
//        }
//        
//        tabbed.createTabs(items: items)
//    }
    
    /**
     刷新网格数据
     */
    func reloadData() {
        self.tabbed.collectionView.reloadData()
    }
}

extension SelectExchangeCurrencyViewController: TabbedCollectionViewDataSource, TabbedCollectionViewDelegate {
    
    
    
    // MARK: - RFTabbedCollectionView data source methods
    func collectionView(collectionView: TabbedCollectionView, numberOfItemsInTab tab: Int) -> Int {
        return self.allCurrencys.count
    }
    
    func collectionView(collectionView: TabbedCollectionView, titleForItemAtIndexPath indexPath: NSIndexPath) -> String {
        let exchangeCurrency = self.exchangeCurrencys[indexPath.section]
        let currency = self.allCurrencys[indexPath.row]
        let title = currency.currency + "/" + exchangeCurrency.currency
        return title
    }
    
    func collectionView(collectionView: TabbedCollectionView, imageForItemAtIndexPath indexPath: NSIndexPath) -> (UIImage?, NSURL?) {
        let currency = self.allCurrencys[indexPath.row]
        let url = NSURL(string: currency.iconUrl64)!
        return (nil, url)
    }
    
    func collectionView(collectionView: TabbedCollectionView, colorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor {
        return UIColor(hex: 0x3A3A3A)
    }
    
    func collectionView(collectionView: TabbedCollectionView, titleColorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor {
        return UIColor(white: 0.2, alpha: 1.0)
    }
    
    func collectionView(collectionView: TabbedCollectionView, backgroundColorForItemAtIndexPath indexPath: NSIndexPath) -> UIColor {
        return UIColor.white
    }
    
    // MARK: - RFTabbedCollectionView delegate methods
    func collectionView(collectionView: TabbedCollectionView, didSelectItemAtIndex index: Int, forTab tab: Int) {
        let exchangeCurrency = self.exchangeCurrencys[tab]
        let currency = self.allCurrencys[index]
        self.delegate?.selectExchangeCurrencyView(vc: self, didSelectCurrency: currency, exchangeCurrency: exchangeCurrency)
        self.dismissSemi()
    }
    
    
    func collectionView(collectionView: TabbedCollectionView, didSelectTabAtIndex tab: Int) {
        let exchangeCurrency = self.exchangeCurrencys[tab]
        self.delegate?.selectExchangeCurrencyView(vc: self, didSelectExchange: exchangeCurrency)
    }
}
