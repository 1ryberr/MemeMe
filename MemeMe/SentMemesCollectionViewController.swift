//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ryan Berry on 10/29/17.
//  Copyright © 2017 Ryan Berry. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {
    
     var memes:[Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let me = memes[indexPath.row]
        cell.cellPhoto.image = me.memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "ViewViewController") as! ViewViewController
        let me = memes[indexPath.row]
        detailController.detail = me.memedImage
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func memAPhoto(_ sender: Any) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemeViewController")as! MemeViewController
        present(controller, animated: true, completion: nil)
    }
    
}
