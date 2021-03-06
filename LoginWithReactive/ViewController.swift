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
  
  // MARK: properties
  
  let signInService: DummySignInService;
  
  // MARK: initialisation
  
  required init(coder aDecoder: NSCoder) {
    signInService = DummySignInService()
    super.init(coder: aDecoder)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
      // = = = =  Play With Reactive = = = =
    // First Example;
//    var validUsernameSignal =
//    self.usernameTextField.rac_textSignal().subscribeNext { (valor : AnyObject!) -> Void in
//      println(valor)
//    }
    // - - - -
    // Second Example;
//    self.usernameTextField.rac_textSignal().filter { (valor: AnyObject!) -> Bool in
//      var text = valor as! String
//        return count(text) > 3
//      } .subscribeNext { (valor: AnyObject!) -> Void in
//      println(valor)
//    }
    // - - - -
    // Third Example;
//    var usernameSourceSignal:RACSignal = self.usernameTextField.rac_textSignal()
//    var filteresUserName:RACSignal = usernameSourceSignal.filter { (valor: AnyObject!) -> Bool in
//      var text = valor as! String
//      return count(text) > 3
//    }
//    
//    // var finalSignal:RACSignal =
//    filteresUserName.subscribeNext { (valor: AnyObject!) -> Void in
//      println(valor)
//    }
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    // Fourth Example; (For now don't run) Aqui no deveria ser necesario castear las signales a String
//    self.usernameTextField.rac_textSignal().filterAs { (text:AnyObject) -> Bool in
//            var text1 = text as! String
//              return count(text1) > 3
//    }.subscribeNextAs { (text:String) -> () in
//      println(count(text))
//    }
    // - - - - - - SI Funciona
//    self.usernameTextField.rac_textSignal().filter { (valor: AnyObject!) -> Bool in
//      var text = valor as! String
//      return count(text) > 3
//      }.subscribeNext { (valor: AnyObject!) -> Void in
//        var text = valor as! String
//        println(text)
//    }
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// Fift, using map:
//  var validAgeSignal: RACSignal =
    
//    self.usernameTextField.rac_textSignal().mapAs { (text: NSString) -> NSNumber in
//      let dd = text as String
//      return count(dd)
//      }.filterAs { (t:NSNumber) -> Bool in
//        let rr = t as Int
//      return rr > 3
//      }.subscribeNextAs { (valor: NSNumber) -> () in  // Tambien fuciona con NSNumber
//        println(valor)
//    }

//    self.usernameTextField.rac_textSignal().mapAs { (text: NSString) -> NSNumber in
//      let dd = text as String
//      return count(dd)
//      }.filterAs { (t:NSNumber) -> Bool in
//        let rr = t as Int
//        return rr > 3
//      }.subscribeNextAs { (valor: AnyObject) -> () in   // Tambien fuciona con AnyObject
//        println(valor)
//    }
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// Creado las señales:
    var validUsernameSignal: RACSignal = self.usernameTextField.rac_textSignal().mapAs { (text: NSString) -> AnyObject in
      return self.isValidUsername(username: text as String) // Devuelve señal Bool
    }
    
    var validPasswordSignal: RACSignal = self.passwordTextField.rac_textSignal().mapAs { (text: NSString) -> AnyObject in
      return self.isValidPassword(password: text as String) // Devuelve señal Bool
    }
// - - --
    
    validUsernameSignal.mapAs({ (xx: NSNumber) -> UIColor in   // Ojo Aqui return UIColor
      return xx.boolValue ? UIColor.clearColor() : UIColor.yellowColor()
    }) ~> RAC(self.usernameTextField, "backgroundColor")
    
    validPasswordSignal.mapAs({ (xx: NSNumber) -> AnyObject in   // Ojo Aqui return AnyObject
      return xx.boolValue ? UIColor.clearColor() : UIColor.yellowColor()
    }) ~> RAC(self.passwordTextField, "backgroundColor")
    
    // Ahora Reducir:
    let signUpActiveSignal = RACSignal.combineLatest([validUsernameSignal, validPasswordSignal]).map {
      (tuple: AnyObject!) -> AnyObject in
      let tupleRAC = tuple as! RACTuple
      let validUsername = tupleRAC.first as! Bool
      let validPassword = tupleRAC.second as! Bool
      
      return validUsername && validPassword
    }
    
    signUpActiveSignal.subscribeNextAs { (active: AnyObject) -> () in
      let active1: NSNumber = (active as? NSNumber)!
      self.signInButton.enabled = active1 as Bool
    }

    //Ahora crear el evento del Boton (TouchUpI)
//    self.signInButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext {
//      (button) in
//        println("Clicked ")
//    }

    let signUpCommand = RACCommand(enabled: signUpActiveSignal) {
      (any) -> RACSignal in
      return self.signInSignal()
    }
    
    signUpCommand.executionSignals
      .flattenMap {
        (any) -> RACSignal in
        any as! RACSignal
      }.subscribeNextAs {
        (success: NSNumber) in
        self.handleSignInResult(success.boolValue)
    }
    
    

    
    signInButton.rac_command = signUpCommand    
    
  }// Fin del viewDidLoad
  
  func handleSignInResult(success: Bool) {
    if success {
      self.performSegueWithIdentifier("signInSuccess", sender: self)
    } else {
      UIAlertView(title: "Sign in failure", message: "try harder next time ;-)",
        delegate: nil, cancelButtonTitle: "OK").show()
    }
  }
  
  
   override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  
  // MARK: implementation
  
  func signInSignal() -> RACSignal {
    return RACSignal.createSignal {
      (subscriber) -> RACDisposable! in
      
      println("Sign-in initiated")
      self.signInService.signInWithUsername(self.usernameTextField.text,
        password: self.passwordTextField.text) {
          (success) in
          println("Sign-in completed")
          subscriber.sendNext(success)
          subscriber.sendCompleted()
      }
      return nil
    }
  }
  // =  = = = = Funciones de Validacion:
  func isValidUsername(#username:String) -> Bool{
    return count(username) > 3
  }
  
  func isValidPassword(#password:String) -> Bool{
    return count(password) > 3
  }
  
  
  

}

