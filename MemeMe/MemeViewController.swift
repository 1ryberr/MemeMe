//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Ryan Berry on 10/27/17.
//  Copyright © 2017 Ryan Berry. All rights reserved.
//

import UIKit



class MemeViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navBar1: UINavigationBar!
    @IBOutlet weak var toBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    var keyboardOnScreen = false
    var memes:[Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        textFieldFunction(textField: topText,withText: "TOP")
        textFieldFunction(textField: bottomText,withText: "BOTTOM")
     
        shareButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        keyBoardHideandShow()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        if memes.isEmpty{
            cancelButton.isEnabled = false
        }else{
            cancelButton.isEnabled = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       unsubscribeFromAllNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UIImagePickerController.isSourceTypeAvailable(.camera) && cameraButton.isEnabled{
            cameraButton.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func save() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)

    }
    
    func generateMemedImage() -> UIImage {

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func alertDialog(title: String, message: String){
        let controller = UIAlertController(title:title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func sharePhoto(_ sender: UIBarButtonItem) {
        self.toBar.isHidden = true
        self.navBar1.isHidden = true
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activity,success,items,error) in
            
            if(success && error == nil){
                self.dismiss(animated: true, completion: nil)
                self.save()
                self.navBar1.isHidden = false
                self.toBar.isHidden = false
            }else if (error != nil){
                print("error")
                self.alertDialog(title: "Error", message: "please try again")
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func photoButton(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        switch sender.tag {
        case 0:
            pickerController.sourceType = .camera
        case 1:
            pickerController.sourceType = .photoLibrary
            
        default:
            
            alertDialog(title: "Error", message: "please try again")
        }
        
        present(pickerController, animated: true, completion: nil)
        
    }
}

extension MemeViewController: UITextFieldDelegate{
    
    func textFieldFunction(textField: UITextField, withText: String){
        
        textField.delegate = self
        textField.text = withText
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.isFirstResponder){
            if bottomText.isEditing{
                bottomText.text = ""
            }
            else if (topText.isFirstResponder) {
                topText.text = ""
            }
            
        }
        
    }
    
    func keyBoardHideandShow(){
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        self.view.sendSubview(toBack: imageView)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen && bottomText.isFirstResponder {
            view.frame.origin.y -=  keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen && bottomText.isFirstResponder{
            view.frame.origin.y +=  keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}
struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage!
    let memedImage: UIImage!
}


private extension MemeViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MemeViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            dismiss(animated: true, completion: nil)
             shareButton.isEnabled = true
        }
    }
    
    
}

