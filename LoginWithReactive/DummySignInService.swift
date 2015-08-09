//
//  DummySignInService.swift
//  LoginWithReactive
//
//  Created by Henry AT on 8/9/15.
//  Copyright (c) 2015 Apps4s. All rights reserved.
//

import Foundation

typealias SignInReponse = (Bool) -> ()

func delay(delay: Double, closure:()->()) {
  let time = dispatch_time(
    DISPATCH_TIME_NOW,
    Int64(delay * Double(NSEC_PER_SEC))
  )
  dispatch_after(time, dispatch_get_main_queue(), closure)
}

class DummySignInService {
  
  func signInWithUsername(username: NSString, password: NSString, complete: SignInReponse) {
    delay(2.0) {
      let sucess = username == "user" && password == "password"
      complete(sucess)
    }
  }
}
