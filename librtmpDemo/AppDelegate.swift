//
//  AppDelegate.swift
//  librtmpDemo
//
//  Created by 成杰 on 16/6/2.
//  Copyright © 2016年 swiftc.org. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let rtmp = RTMPClient()
    private let urlStr = "rtmp://swiftc.org/live/livestream"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        rtmp.setLogLevel = RTMP_LOGALL
        rtmp.connect(urlStr)
        
        pushLocalFlv()
        
        return true
    }
    
    private func pushLocalFlv() {
        
        let resourcePath = NSBundle.mainBundle().resourcePath!
        let flvPath = resourcePath + "/demo.flv"
        
        let flvData = NSData(contentsOfFile: flvPath)
        guard flvData != nil else {
            print("video data is nil")
            return
        }
        
        let length = flvData!.length
        print("origin video lenght: \(length / 1024 / 1024 )M")
        
        var offset = 0
        let chunkSize = 100 * 5120
        
        while offset < length {
            let thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset
            let chunk = NSData(bytesNoCopy: UnsafeMutablePointer<Void>(flvData!.bytes),
                               length: thisChunkSize,
                               freeWhenDone: false)
            rtmp.push(chunk)
            offset += thisChunkSize
            sleep(1)
        }
        
        print("finished push")
        rtmp.close()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

