//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ryan Berry on 10/29/17.
//  Copyright © 2017 Ryan Berry. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes:[Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        if memes.isEmpty{
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MemeViewController")as! MemeViewController
            
            
            present(controller, animated: true, completion: nil)
        }else{
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let me = memes[indexPath.row]
        cell.imageView?.image = me.memedImage
         cell.textLabel?.text = "\(me.topText) ...\(me.bottomText)"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "ViewViewController") as! ViewViewController
        let me = memes[indexPath.row]
        detailController.detail = me.memedImage
        navigationController!.pushViewController(detailController, animated: true)
    }

    @IBAction func MemeMaker(_ sender: Any) {

        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemeViewController")as! MemeViewController
        present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.delete {
                
                memes.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                tableView.endUpdates()
                
               tableView.reloadData()
            
        }

        
        
    }
    
    

}
