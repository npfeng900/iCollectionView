//
//  ViewController.swift
//  iCollectionView
//
//  Created by Niu Panfeng on 11/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: MyCollectionView!
    private var imagePaths = [String]()
    /*********************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initData()
        initNotifications()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //viewDidAppear之后，autolayout才开始工作
        updateLayout()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    deinit {
        deinitNotifications()
    }
    /*********************************************************************/
    //MARK: - SelfDefine
    /** init模型数据 */
    private func initData() {
        imagePaths = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: "SupportFiles")
    }
    /** init通知消息 */
    private func initNotifications() {
        // 添加设备方向变化的消息通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    /** deninit通知消息 */
    private func deinitNotifications() {
        // 移除设备方向变化的消息通知
        NSNotificationCenter.defaultCenter().removeObserver(UIDeviceOrientationDidChangeNotification)
    }
    /** 设备方向变化的通知处理函数 */
    func orientationChanged(notification: NSNotification) {
        switch UIDevice.currentDevice().orientation
        {
        //下面四种情况，重新布局
        case .Portrait, .PortraitUpsideDown, .LandscapeLeft, .LandscapeRight:
            updateLayout()
            break
        //剩余情况，无变化
        default:
            break
        }
        
    }
    /** update视图布局 */
    private func updateLayout() {
        //collectionView布局设置
        /*
        let sectionInsetTop: CGFloat = 40
        let sectionInsetBottom: CGFloat = 20
        let sectionInsetHorizontal: CGFloat = 20
        self.collectionView.frame = CGRect(x: sectionInsetHorizontal, y: sectionInsetTop, width: self.view.bounds.width - sectionInsetHorizontal * 2, height: self.view.bounds.height - sectionInsetTop - sectionInsetBottom )
        */
        let itemWidth: CGFloat = 125
        let itemSpace: CGFloat = 5
        self.collectionView.setItemWidth(itemWidth: itemWidth)
        self.collectionView.setItemSpacing(itemSpacing: itemSpace)

    }
    /*********************************************************************/
    //MARK: - UICollectionViewDataSource
    /** numberOfSections */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    /** numberOfItemsInSection */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    /** cellForItemAtIndexPath */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellID = "ReuseCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(contentsOfFile: imagePaths[indexPath.row])
        imageView.layer.opacity = 0.5
        
        return cell
    }
    /** didSelectItemAtIndexPath */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let view = cell?.viewWithTag(1)
        view?.layer.opacity = 1.0
    }
    /*********************************************************************/
   
}
