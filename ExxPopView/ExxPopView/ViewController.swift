//
//  ViewController.swift
//  ExxPopView
//
//  Created by mqt on 2018/1/10.
//  Copyright © 2018年 mqt. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var btnTitle = UIButton()
    
    var selectCurrencyPopView: SelectExchangeCurrencyViewController?
    
    @IBOutlet weak var viewTitle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    func setupUI(){
        
        self.viewTitle.addSubview(self.btnTitle)
        self.btnTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(self.viewTitle).offset(0)
            make.trailing.equalTo(self.viewTitle).offset(0)
            make.top.equalTo(self.viewTitle).offset(0)
            make.bottom.equalTo(self.viewTitle).offset(0)
        }
        
        self.btnTitle.setTitle("show", for: .normal)
        self.btnTitle.setTitleColor(UIColor.black, for: .normal)
        self.btnTitle.addTarget(self, action: #selector(self.showPopView), for: .touchUpInside)
    }
      //弹出视图
    @objc func showPopView(){
      print("弹出")
        if self.selectCurrencyPopView == nil {
            self.selectCurrencyPopView = SelectExchangeCurrencyViewController()
            
            //中国比特币目前只有CNY交易区
//            let exchangeCurrencySet = CurrencySet.getCurrencySet(self.selectedExchangeType)
//
//            selectCurrencyPopView!.exchangeCurrencys.append(exchangeCurrencySet)
            
//            selectCurrencyPopView!.delegate = self
        }
        
        selectCurrencyPopView!.sideAnimationDuration = 0.3
        selectCurrencyPopView!.sideOffset = self.view.bounds.height / 2
        self.showSemiViewController(semiVC: self.selectCurrencyPopView!, direction: .Up)
    }
    
    
}

