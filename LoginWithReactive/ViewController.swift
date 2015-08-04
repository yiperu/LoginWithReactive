//
//  ViewController.swift
//  LoginWithReactive
//
//  Created by Henry AT on 8/3/15.
//  Copyright (c) 2015 Apps4s. All rights reserved.
//

import UIKit

import ReactiveCocoa







class ViewController: UIViewController {

  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var signInFailureText: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
      // = = = =  Play With Reactive = = = =
    // First Ejemplo;
//    var validUsernameSignal =
//    self.usernameTextField.rac_textSignal().subscribeNext { (valor : AnyObject!) -> Void in
//      println(valor)
//    }
    // - - - -
    // Second Ejemplo;
    self.usernameTextField.rac_textSignal().filter { (valor: AnyObject!) -> Bool in
      var text = valor as! String
        return count(text) > 3
      } .subscribeNext { (valor: AnyObject!) -> Void in
      println(valor)
    }
    
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

