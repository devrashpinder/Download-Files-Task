//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//
 
 import UIKit
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let tintColor =  UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
  var backgroundSessionCompletionHandler: (() -> Void)?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    customizeAppearance()
    return true
  }
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    backgroundSessionCompletionHandler = completionHandler
  }
  
  // MARK - App Theme Customization
  
  private func customizeAppearance() {
    window?.tintColor = tintColor
    UISearchBar.appearance().barTintColor = tintColor
    UINavigationBar.appearance().barTintColor = tintColor
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.white]
  }
 }
 
