//
//  MyCollectionView.swift
//  iCollectionView
//
//  Created by Niu Panfeng on 15/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MyCollectionView: UICollectionView {

    /*********************************************************************/
    /** 设置布局信息 */
    func setItemWidthAndSpacing(itemWidth width: CGFloat, itemSpacing space: CGFloat) {
        itemWidth = width
        itemSpacing = space
    }
    /** 布局信息 */
    private var itemWidth: CGFloat = 125 {
        didSet{
            updateFlowLayout()
            reloadData() //调用UICollectionViewDataSource代理方法,方法执行时间可能滞后或者不执行
        }
    }
    private var itemSpacing: CGFloat = 5 {
        didSet{
            updateFlowLayout()
            reloadData() //调用UICollectionViewDataSource代理方法,方法执行时间可能滞后或者不执行
        }
    }
    /** 更新视图 */
    private func updateFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        //滑动方向设置
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
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
        setCollectionViewLayout(flowLayout, animated: true)
    }
    /*********************************************************************/
    /** 数据信息 */
    var totalNumberOfItems: Int = 0 {
        didSet{
            reloadData() //调用UICollectionViewDataSource代理方法,方法执行时间可能滞后或者不执行
        }
    }
    /*********************************************************************/
    /** 只读计算属性 */
    var totalNumberOfSections:Int {
        get{
            return Int(ceil( Float(totalNumberOfItems) / Float(maxNumberOfItemsInSection) ))
        }
    }
    var maxNumberOfItemsInSection: Int {
        get{
            return Int(columnsNum * rowsNum)
        }
    }
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
    /*********************************************************************/
    /** 构造函数 */
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initDefaultSettings()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDefaultSettings()
    }
    private func initDefaultSettings(){
        //View设置
        self.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
        self.showsHorizontalScrollIndicator = true
        self.pagingEnabled = true
        //Notisfication手势通知
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressed:"))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "pan:"))
    }
    /** 析构函数 */
    deinit {
        // 移除手势滑动通知
        if let notifies = self.gestureRecognizers {
            for notify in notifies {
                self.removeGestureRecognizer(notify)
            }
        }
    }
    /*********************************************************************/
    var isEidting: Bool = false {
        didSet {
            if isEidting == true {
                enterEditing()
            }
            else {
                resignEditing()
            }
        }
    }
    struct Constants {
        static let ItemWidthDvalue: Float = 2.5
    }
    /*********************************************************************/
    /** 手势通知：长按处理函数 */
    func longPressed(longGesture: UILongPressGestureRecognizer) {
        if self.indexPathForItemAtPoint(longGesture.locationInView(self)) != nil {
            if isEidting == false {
                isEidting = true
            }
        }
    }
    func tap(tapGesture: UITapGestureRecognizer) {
        if self.indexPathForItemAtPoint(tapGesture.locationInView(self)) == nil {
            if isEidting == true {
                isEidting = false
            }
        }
    }
    func pan(panGesture: UIPanGestureRecognizer) {
        if isEidting
        {
            switch panGesture.state
            {
            case UIGestureRecognizerState.Began:    //判断手势落点位置是否在路径上
                if let indexPath = self.indexPathForItemAtPoint(panGesture.locationInView(self))
                {   //在路径上则开始移动该路径上的cell
                    self.beginInteractiveMovementForItemAtIndexPath(indexPath)
                }
            case UIGestureRecognizerState.Changed:  //移动过程当中随时更新cell位置
                self.updateInteractiveMovementTargetPosition(panGesture.locationInView(self))
            case UIGestureRecognizerState.Ended:    //移动结束后关闭cell移动
                self.endInteractiveMovement()
            default:                                //关闭cell移动
                self.cancelInteractiveMovement()
            }
        }
    }
    //进入编辑状态
    func enterEditing() {
        //动画
        UIView.animateWithDuration(0.3) { () -> Void in
            let newItemWidth = self.itemWidth - CGFloat(Constants.ItemWidthDvalue)
            let newItemSpacing = self.itemSpacing + CGFloat(2*Constants.ItemWidthDvalue)
            self.setItemWidthAndSpacing(itemWidth: newItemWidth, itemSpacing: newItemSpacing)
        }
    }
    //离开编辑状态
    func resignEditing() {
        UIView.animateWithDuration(0.3) {
            let newItemWidth = self.itemWidth + CGFloat(Constants.ItemWidthDvalue)
            let newItemSpacing = self.itemSpacing - CGFloat(2*Constants.ItemWidthDvalue)
            self.setItemWidthAndSpacing(itemWidth: newItemWidth, itemSpacing: newItemSpacing)
        }
    }
    
    /*********************************************************************/
}
