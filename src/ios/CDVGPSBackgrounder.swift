//
//  CDVNativeSoma.swift
//  TheBackgrounder
//
//  Created by Mozart Diniz on 8/19/15.
//  Copyright (c) 2015 Razeware, LLC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation

@available(iOS 8.0, *)
@objc(HWPGPSBackgrounder) class CDVGPSBackgrounder : CDVPlugin, CLLocationManagerDelegate {

    var com : CDVInvokedUrlCommand!

    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.pausesLocationUpdatesAutomatically = false;

        if #available(iOS 9, *) {
            manager.allowsBackgroundLocationUpdates = true;
        }

        return manager
    }()

    func initialize(_ command: CDVInvokedUrlCommand) {

        com = command

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        commandDelegate!.send(pluginResult, callbackId: command.callbackId)

    }

    func start(_ command: CDVInvokedUrlCommand) {

        locationManager.startUpdatingLocation()

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        commandDelegate!.send(pluginResult, callbackId: command.callbackId)

    }

    func stop(_ command: CDVInvokedUrlCommand) {

        locationManager.stopUpdatingLocation()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        commandDelegate!.send(pluginResult, callbackId: command.callbackId)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let coordinate = locations.last! as CLLocation
        print(coordinate)
        
        let script = "GPSBackgrounder.onPosition({latitude:\(coordinate.coordinate.latitude), longitude: \(coordinate.coordinate.longitude), speed: \(coordinate.speed), timestamp: '\(coordinate.timestamp)', accuracy: \(coordinate.horizontalAccuracy)})";
        print(script)

        webView!.stringByEvaluatingJavaScript(from: script)
        
    }

}
