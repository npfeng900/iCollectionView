//
//  MyCollectionView.swift
//  iCollectionView
//
//  Created by Niu Panfeng on 15/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MyCollectionView: UICollectionView {

    private let flowLayout = UICollectionViewFlowLayout()
    /** 布局信息 */
    private var itemWidth: CGFloat = 125 {
        didSet{
            updateViews()
            self.reloadData() //调用UICollectionViewDataSource代理方法,方法执行时间可能滞后或者不执行
        }
    }
    private var itemSpacing: CGFloat = 5 {
        didSet{
            updateViews()
            self.reloadData() //调用UICollectionViewDataSource代理方法,方法执行时间可能滞后或者不执行
        }
    }
    /** 数据信息 */
    var totalNumberOfItems: Int = 0 {
        didSet{
            self.reloadData() //调用UICollectionViewDataSource代理方法,方法执行时间可能滞后或者不执行
        }
    }
    /** 只读计算属性 */
    private var columnsNum: Int {
        get{ 
            return Int(floor(self.bounds.width / (itemWidth + itemSpacing)))
        }
    }
    private var rowsNum: Int {
        get{
            return Int(floor(self.bounds.height / (itemWidth + itemSpacing)))
        }
    }
    var maxNumberOfItemsInSection: Int {
        get{
            return Int(columnsNum * rowsNum)
        }
    }
    var totalNumberOfSections:Int {
        get{
            return Int(ceil( Float(totalNumberOfItems) / Float(maxNumberOfItemsInSection) ))
        }
    }
    
    /** 构造函数 */
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initDefaultSettings()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDefaultSettings()
    }
    /** 初始化默认设置 */
    private func initDefaultSettings(){
        //View设置
        self.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
        self.showsHorizontalScrollIndicator = true
        self.pagingEnabled = true
        //流布局设置
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //Notisfication
        //手势通知：长按
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressed:"))
    }
    /** 析构函数 */
    deinit {
        // 移除手势滑动通知
        if let gNotisfications = self.gestureRecognizers
        {
            for gNotisfication in gNotisfications
            {
                self.removeGestureRecognizer(gNotisfication)
            }
        }
    }
    /** 手势通知：长按处理函数 */
    func longPressed(longGesture: UILongPressGestureRecognizer) {
        switch longGesture.state
        {
        case UIGestureRecognizerState.Began:
            //判断手势落点位置是否在路径上
            if let indexPath = self.indexPathForItemAtPoint(longGesture.locationInView(self))
            {
                //在路径上则开始移动该路径上的cell
                self.beginInteractiveMovementForItemAtIndexPath(indexPath)
            }
            break
        case UIGestureRecognizerState.Changed:
            //移动过程当中随时更新cell位置
            self.updateInteractiveMovementTargetPosition(longGesture.locationInView(self))
            break;
        case UIGestureRecognizerState.Ended:
            //移动结束后关闭cell移动
            self.endInteractiveMovement()
            break;
        default:
            //关闭cell移动
            self.cancelInteractiveMovement()
            break
        }
    }
    /** 更新视图 */
    private func updateViews() {
        //cell宽度和高度
        flowLayout.itemSize = CGSize(width:itemWidth, height:itemWidth)
        //cell间隔
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        //collectionView页边距
        let horizontalSectionInset = (self.bounds.width - itemSpacing * CGFloat(columnsNum - 1) - itemWidth * CGFloat(columnsNum)) / 2.0
        let verticalSectionInset = (self.bounds.height - itemSpacing * CGFloat(rowsNum - 1) - itemWidth * CGFloat(rowsNum)) / 2.0
        flowLayout.sectionInset = UIEdgeInsets(top: verticalSectionInset, left: horizontalSectionInset, bottom: verticalSectionInset, right: horizontalSectionInset)
        //设置collectionView的基本布局属性
        self.setCollectionViewLayout(flowLayout, animated: true)
    }
    /** 设置Cell尺寸和间隔 */
    func setItemWidth(itemWidth width: CGFloat) {
        itemWidth = width
    }
    func setItemSpacing(itemSpacing space: CGFloat) {
        itemSpacing = space
    }
}
