//
//  NewPostController.swift
//  Tootbot
//
//  Created by Jesus Fernandez on 6/16/18.
//  Copyright © 2018 JO. All rights reserved.
//

import UIKit
import ChameleonFramework

class NewPostController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var newPostView: UIView!
    @IBOutlet weak var newPostContents: UITextView!
    
    override func viewDidLoad() {
        newPostView.layer.cornerRadius = 20
        newPostView.layer.masksToBounds = true
        newPostView.layer.borderWidth = 1
        newPostView.layer.borderColor = FlatGray().cgColor
        newPostContents.delegate = self as? UITextViewDelegate
        newPostContents.becomeFirstResponder()
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if newPostContents.text != "" {
            print("TODO: Post to mastodon with text \(newPostContents.text)")
        }
        
        dismissModal()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismissModal()
    }
    
    func dismissModal() {
        newPostContents.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}
