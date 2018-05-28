//
//  ViewViewController.swift
//  MemeMe
//
//  Created by Ryan Berry on 10/30/17.
//  Copyright © 2017 Ryan Berry. All rights reserved.
//

import UIKit

class ViewViewController: UIViewController {
    
    var detail : UIImage!

    @IBOutlet weak var detailImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       detailImage.image = detail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}
