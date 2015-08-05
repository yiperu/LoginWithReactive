
//
//  RACObserve.swift
//  LoginWithReactive
//
//  Created by Henry AT on 8/4/15.
//  Copyright (c) 2015 Apps4s. All rights reserved.
//

import Foundation
import ReactiveCocoa

// replaces the RACObserve macro
func RACObserve(target: NSObject!, keyPath: String) -> RACSignal  {
  return target.rac_valuesForKeyPath(keyPath, observer: target)
}