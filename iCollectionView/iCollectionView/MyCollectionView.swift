//
//  MyCollectionView.swift
//  iCollectionView
//
//  Created by Niu Panfeng on 15/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MyCollectionView: UICollectionView {

    /** 布局信息 */
    private let flowLayout = UICollectionViewFlowLayout()
    private var itemWidth: CGFloat = 125 {
        didSet{
            updateViews()
        }
    }
    private var itemSpacing: CGFloat = 5 {
        didSet{
            updateViews()
        }
    }
    /** 数据信息 */
    private var maxNumberOfItemsInSection: Int = 1 {
        didSet{
            //整个类从新加载刷新数据，会调用UICollectionViewDataSource代理方法
            self.reloadData()
        }
    }
    var numberOfTotalItems: Int = 0 {
        didSet{
            self.reloadData()
        }
    }
    var numberOfTotalSections:Int {
        get {
            return Int(ceil( Float(numberOfTotalItems) / Float(maxNumberOfItemsInSection) ))
        }
    }
    
    
    /** 初始化函数 */
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setDefaults()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaults()
    }
    /** 默认设置 */
    private func setDefaults(){
        self.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    /** 更新视图 */
    private func updateViews() {
        //cell宽度和高度
        flowLayout.itemSize = CGSize(width:itemWidth, height:itemWidth)
        //cell间隔
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        //collectionView页边距
        let collectionViewWidth = self.bounds.width
        let collectionViewHeight = self.bounds.height
        let columnsNum = floor(collectionViewWidth / itemWidth)
        let rowsNum = floor(collectionViewHeight / itemWidth)
        let horizontalSectionInset = (collectionViewWidth - itemSpacing * CGFloat(columnsNum - 1) - itemWidth * CGFloat(columnsNum)) / 2.0
        let verticalSectionInset = (collectionViewHeight - itemSpacing * CGFloat(rowsNum - 1) - itemWidth * CGFloat(rowsNum)) / 2.0
        flowLayout.sectionInset = UIEdgeInsets(top: verticalSectionInset, left: horizontalSectionInset, bottom: verticalSectionInset, right: horizontalSectionInset)
        //设置collectionView的基本布局属性
        self.setCollectionViewLayout(flowLayout, animated: true)
        
        //seciton中的item数目
        maxNumberOfItemsInSection = Int(columnsNum * rowsNum)
        
    }
    /** 设置Cell尺寸和间隔 */
    func setItemWidth(itemWidth width: CGFloat) {
        itemWidth = width
    }
    func setItemSpacing(itemSpacing space: CGFloat) {
        itemSpacing = space
    }
    /** 获取每个Section的Item最大数目 */
    func getItemMaxNumberOfEverySection() -> Int {
        return maxNumberOfItemsInSection
    }

    
}
