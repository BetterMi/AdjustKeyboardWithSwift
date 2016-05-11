//
//  ViewController.swift
//  AdjustKeyboardWithSwift
//
//  Created by HM on 16/5/9.
//  Copyright © 2016年 HM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderView: UIView!
    
    var currentTextfeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerKeyboardNotification()
    }
    
    // MARK: - 注册键盘事件
    func registerKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - keyboard
    func keyboardShow(notif:NSNotification) {
        let userinfo = notif.userInfo!
        
        var frame = (userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        // nil 表示window，因此就是将window中的键盘坐标frame转换到slidingView中
        frame = self.sliderView.convertRect(frame, fromView: nil)
        
        //解包
        if let f = self.currentTextfeild?.frame {
            let offset:CGFloat = f.maxY + frame.size.height - self.sliderView.bounds.height + 5
            if frame.origin.y < f.maxY {
                self.topConstraint.constant = -offset
                self.bottomConstraint.constant = offset
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardHide(notif:NSNotification) {
        self.topConstraint.constant = 0
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextfeild = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.currentTextfeild = nil
        
        return true
    }
}

