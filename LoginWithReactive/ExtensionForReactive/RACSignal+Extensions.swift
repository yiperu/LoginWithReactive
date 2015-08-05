//
//  RACSignal+Extensions.swift
//  LoginWithReactive
//
//  Created by Henry AT on 8/4/15.
//  Copyright (c) 2015 Apps4s. All rights reserved.
//

import Foundation
import ReactiveCocoa

// a collection of extension methods that allows for strongly typed closures
extension RACSignal {
  
  func subscribeNextAs<T>(nextClosure:(T) -> ()) -> () {
    self.subscribeNext {
      (next: AnyObject!) -> () in
      let nextAsT = next! as! T
      nextClosure(nextAsT)
    }
  }
  
  func mapAs<T: AnyObject, U: AnyObject>(mapClosure:(T) -> U) -> RACSignal {
    return self.map {
      (next: AnyObject!) -> AnyObject! in
      let nextAsT = next as! T
      return mapClosure(nextAsT)
    }
  }
  
  func filterAs<T: AnyObject>(filterClosure:(T) -> Bool) -> RACSignal {
    return self.filter {
      (next: AnyObject!) -> Bool in
      let nextAsT = next as! T
      return filterClosure(nextAsT)
    }
  }
  
  func doNextAs<T: AnyObject>(nextClosure:(T) -> ()) -> RACSignal {
    return self.doNext {
      (next: AnyObject!) -> () in
      let nextAsT = next as! T
      nextClosure(nextAsT)
    }
  }
  
  func asSignal() -> Signal<AnyObject?, NSError> {
    return Signal {
      sink in
      self.subscribeNext({
        any in
        sendNext(sink, any)
        }, error: {
          error in
          sendError(sink, error)
        }, completed: {
          sendCompleted(sink)
      })
    }
  }
}

public func toVoidSignal<T, E>(signal: Signal<T, E>) -> Signal<(), NoError> {
  return Signal {
    sink in
    signal.observe(SinkOf {
      event in
      switch event {
      case let .Next:
        sendNext(sink, ())
      default:
        break
      }
      })
  }
}




class RACSignalEx {
  class func combineLatestAs<T, U, R: AnyObject>(signals:[RACSignal], reduce:(T,U) -> R) -> RACSignal {
    return RACSignal.combineLatest(signals).mapAs {
      (tuple: RACTuple) -> R in
      return reduce(tuple.first as! T, tuple.second as! U)
    }
  }
}

