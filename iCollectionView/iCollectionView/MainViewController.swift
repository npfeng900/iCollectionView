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
    struct ImageInfo {
        var imageName: String?
        var imagePath: String?
    }
    var images = [ImageInfo]()
    /*********************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initData()
        initNotifications()
    }
    deinit {
        deinitNotifications()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //viewDidAppear之后，autolayout才开始工作
        updateLayout()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    /*********************************************************************/
    //MARK: - SelfDefine
    /** init模型数据 */
    private func initData() {
        let imagePaths = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: "SupportFiles")
        for imagePath in imagePaths {
            let imageName = (NSString(string: imagePath).lastPathComponent as NSString).stringByDeletingPathExtension
            images.append(ImageInfo(imageName: imageName, imagePath: imagePath))
        }
        self.collectionView.totalNumberOfItems = images.count
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
        self.collectionView.setItemWidthAndSpacing(itemWidth: 135, itemSpacing: 5)
    }
    /*********************************************************************/
    //MARK: - UICollectionViewDataSource
    /** numberOfSections */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return  self.collectionView.totalNumberOfSections
    }
    /** numberOfItemsInSection */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == self.collectionView.totalNumberOfSections - 1
        {
            return self.collectionView.totalNumberOfItems % self.collectionView.maxNumberOfItemsInSection
        }
        return self.collectionView.maxNumberOfItemsInSection
    }
    /** cellForItemAtIndexPath */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.section * self.collectionView.maxNumberOfItemsInSection + indexPath.row
        
        let cellID = "ReuseCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(contentsOfFile: images[index].imagePath!)
        imageView.layer.opacity = 1
        
        let label = cell.viewWithTag(2) as! UILabel
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.text = images[index].imageName!
        
        return cell
    }
    /*********************************************************************/
    //MARK: - UICollectionViewDelegate
    //----------------------------------
    /** canMoveItemAtIndexPath */
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    /** moveItemAtIndexPathtoIndexPath */
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let soureIndex = sourceIndexPath.section * self.collectionView.maxNumberOfItemsInSection + sourceIndexPath.row
        let destinationIndex = sourceIndexPath.section * self.collectionView.maxNumberOfItemsInSection + destinationIndexPath.row
        images.insert(images.removeAtIndex(soureIndex), atIndex: destinationIndex)
    }
    //-----------------------------------
    /** didSelectItemAtIndexPath */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let imageView = cell?.viewWithTag(1)
        imageView?.layer.borderWidth = 2
        imageView?.layer.borderColor = UIColor(red: 0, green: 148/255, blue: 247/255, alpha: 1).CGColor
        imageView?.layer.opacity = 1.0
    }
    /** shouldShowMenuForItemAtIndexPath
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    ** canFocusItemAtIndexPath
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    ** didHighlightItemAtIndexPath
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        print("dd")
    }
    ** didUnhighlightItemAtIndexPath
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        print("xx")
    }
    */
    /*********************************************************************/

}

