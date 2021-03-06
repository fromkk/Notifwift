//
//  NotifwiftTests.swift
//  NotifwiftTests
//
//  Created by Yoshitaka Seki on 2016/02/07.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import XCTest
@testable import Notifwift

let notificationName = "Hoge"

class NotifwiftTests: XCTestCase {
    
    func testLifecycle() {
        var received: Bool?
        
        do {
            let nt = Notifwift()
            nt.observe(notificationName) { notification in
                received = true
            }
            received = false
            Notifwift.post(notificationName)
            XCTAssertTrue(received!)
        }
        
        received = false
        Notifwift.post(notificationName)
        XCTAssertFalse(received!)
    }
    
    func testPayloads() {
        var payloadStr: Any?
        var payloadInt: Any?

        let nt = Notifwift()
        nt.observe(notificationName) { (p:String) in
            payloadStr = p
        }
        nt.observe(notificationName) { (p:Int) in
            payloadInt = p
        }

        payloadStr = nil
        payloadInt = nil
        Notifwift.post(notificationName, payload:"aaaa")
        XCTAssertEqual(payloadStr as? String, "aaaa")
        XCTAssertNil(payloadInt)

        payloadStr = nil
        payloadInt = nil
        Notifwift.post(notificationName, payload:1111)
        XCTAssertNil(payloadStr)
        XCTAssertEqual(payloadInt as? Int, 1111)
    }
    func testNotificationAndPayloads() {
        var payloadStr: Any?
        var payloadInt: Any?

        let nt = Notifwift()
        nt.observe(notificationName) { (_, p:String) in
            payloadStr = p
        }
        nt.observe(notificationName) { (_, p:Int) in
            payloadInt = p
        }

        payloadStr = nil
        payloadInt = nil
        Notifwift.post(notificationName, payload:"aaaa")
        XCTAssertEqual(payloadStr as? String, "aaaa")
        XCTAssertNil(payloadInt)

        payloadStr = nil
        payloadInt = nil
        Notifwift.post(notificationName, payload:1111)
        XCTAssertNil(payloadStr)
        XCTAssertEqual(payloadInt as? Int, 1111)
    }

    func testSubtype() {
        var received: Bool?
        var receivedSub: Bool?
        
        class Animal {}
        class Cat: Animal {}
        
        let nt = Notifwift()
        nt.observe(notificationName) { (_, p:Animal) in
            received = true
        }
        nt.observe(notificationName) { (_, p:Cat) in
            receivedSub = true
        }
        
        received = false
        receivedSub = false
        Notifwift.post(notificationName, payload:Animal())
        XCTAssertTrue(received!)
        XCTAssertFalse(receivedSub!)
        
        received = false
        receivedSub = false
        Notifwift.post(notificationName, payload:Cat())
        XCTAssertTrue(received!)
        XCTAssertTrue(receivedSub!)
    }
    
    func testObjects() {
        var received: Bool?
        var receivedFromObj1: Bool?
        var receivedFromObj2: Bool?
        
        let obj1 = NSObject()
        let obj2 = NSObject()
        let nt = Notifwift()
        nt.observe(notificationName) { _ in
            received = true
        }
        nt.observe(notificationName, from: obj1) { _ in
            receivedFromObj1 = true
        }
        nt.observe(notificationName, from: obj2) { _ in
            receivedFromObj2 = true
        }
        
        received = false
        receivedFromObj1 = false
        receivedFromObj2 = false
        Notifwift.post(notificationName, from: obj1)
        XCTAssertTrue(received!)
        XCTAssertTrue(receivedFromObj1!)
        XCTAssertFalse(receivedFromObj2!)
        
        received = false
        receivedFromObj1 = false
        receivedFromObj2 = false
        Notifwift.post(notificationName, from: obj2)
        XCTAssertTrue(received!)
        XCTAssertFalse(receivedFromObj1!)
        XCTAssertTrue(receivedFromObj2!)
    }
    
    func testDispose() {
        var payloadStr: Any?
        var payloadInt: Any?
        
        let nt = Notifwift()
        nt.observe(notificationName) { (p:String) in
            payloadStr = p
        }
        nt.observe(notificationName) { (p:Int) in
            payloadInt = p
        }
        
        payloadStr = nil
        payloadInt = nil
        Notifwift.post(notificationName, payload:"aaaa")
        Notifwift.post(notificationName, payload:1111)
        XCTAssertEqual(payloadStr as? String, "aaaa")
        XCTAssertEqual(payloadInt as? Int, 1111)
        
        payloadStr = nil
        payloadInt = nil
        nt.dispose(notificationName)
        Notifwift.post(notificationName, payload:"aaaa")
        Notifwift.post(notificationName, payload:1111)
        XCTAssertNil(payloadStr)
        XCTAssertNil(payloadInt)
        
        var received: Bool?
        var receivedFromObj1: Bool?
        var receivedFromObj2: Bool?
        
        // MARK: with `from` object.
        let obj1 = NSObject()
        let obj2 = NSObject()
        nt.observe(notificationName) { _ in
            received = true
        }
        nt.observe(notificationName, from: obj1) { _ in
            receivedFromObj1 = true
        }
        nt.observe(notificationName, from: obj2) { _ in
            receivedFromObj2 = true
        }
        
        received = false
        receivedFromObj1 = false
        receivedFromObj2 = false
        Notifwift.post(notificationName, from: obj1)
        XCTAssertTrue(received!)
        XCTAssertTrue(receivedFromObj1!)
        XCTAssertFalse(receivedFromObj2!)
        
        received = false
        receivedFromObj1 = false
        receivedFromObj2 = false
        nt.dispose(notificationName)
        Notifwift.post(notificationName, from: obj2)
        XCTAssertFalse(received!)
        XCTAssertFalse(receivedFromObj1!)
        XCTAssertFalse(receivedFromObj2!)

    }
}
