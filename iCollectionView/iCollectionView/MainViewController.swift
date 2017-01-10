//
//  ViewController.swift
//  iCollectionView
//
//  Created by Niu Panfeng on 11/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    /*********************************************************************/
    //MARK: - Model
    struct ImageInfo {
        var imageName: String?
        var imagePath: String?
        var beenSelected: Bool = false
    }
    var images = [ImageInfo]()
    /** init模型数据 */
    private func initData() {
        let imagePaths = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: "SupportFiles")
        for imagePath in imagePaths {
            let imageName = (NSString(string: imagePath).lastPathComponent as NSString).stringByDeletingPathExtension
            images.append(ImageInfo(imageName: imageName, imagePath: imagePath, beenSelected: false))
        }
        self.collectionView.totalNumberOfItems = images.count
    }
    /** 常量 */
    struct Constants {
        static let ResuseCellIdentify: String = "ReuseCell"
        static let ImageBeenSelectedOpacity: Float = 0.5
        static let ImageNeverSelectedOpacity: Float = 1.0
    }
    /*********************************************************************/
    //MARK: - Outlet
    @IBOutlet weak var collectionView: MyCollectionView!
    /*********************************************************************/
    //MARK: - ViewCtroller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.setItemWidthAndSpacing(itemWidth: 130, itemSpacing: 5)
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    /*********************************************************************/
    //MARK: - UICollectionViewDataSource
    /** numberOfSections */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return  self.collectionView.totalNumberOfSections
    }
    /** numberOfItemsInSection */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //最后一个Section
        if section == self.collectionView.totalNumberOfSections - 1
        {
            return self.collectionView.totalNumberOfItems % self.collectionView.maxNumberOfItemsInSection
        }
        //非最后一个Section
        return self.collectionView.maxNumberOfItemsInSection
    }
    /** cellForItemAtIndexPath */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.section * self.collectionView.maxNumberOfItemsInSection + indexPath.row
        
        let cellID = Constants.ResuseCellIdentify
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(contentsOfFile: images[index].imagePath!)
        imageView.layer.opacity = images[index].beenSelected ? Constants.ImageBeenSelectedOpacity : Constants.ImageNeverSelectedOpacity
        
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
        //imageView?.layer.borderWidth = 2
        //imageView?.layer.borderColor = UIColor(red: 0, green: 148/255, blue: 247/255, alpha: 1).CGColor
        let index = indexPath.section * self.collectionView.maxNumberOfItemsInSection + indexPath.row
        images[index].beenSelected = true
        imageView?.layer.opacity = images[index].beenSelected ? Constants.ImageBeenSelectedOpacity : Constants.ImageNeverSelectedOpacity
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

