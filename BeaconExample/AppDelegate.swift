//
//  AppDelegate.swift
//  BeaconExample
//
//  Created by Yannick on 03.04.22.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
	
	var locationManager: CLLocationManager!
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
		
		let aStatus = CLLocationManager.authorizationStatus()
		if (aStatus != .authorizedAlways) {
			print("Error: user did not select authorizedAlways")
			locationManager.requestAlwaysAuthorization()
			return true
		}
		let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: "C45E9ED5-7FFA-43F8-A87F-B4503C51837B")!,  identifier: "bla")
		// locationManager.startRangingBeacons(in: beaconRegion) // we are not interested in the range to the beacon
		
		// monitoring beacon works in front or background
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.startMonitoring(for: beaconRegion)
		
		return true
	}
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		guard region is CLBeaconRegion else { return }
		print("exit region", region.identifier)
		self.httpGet(u: "http://7.tcp.eu.ngrok.io:13096/exit")
	}
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		guard region is CLBeaconRegion else { return }
		print("enter region")
		self.httpGet(u: "http://7.tcp.eu.ngrok.io:13096/enter")
	}
	

	
	func httpGet(u: String) {
		
		let url = URL(string: u)! //PUT Your URL
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
				guard let safeData = data,
							let response = response as? HTTPURLResponse,
							error == nil else {                                              // check for fundamental networking error
									print("error", error ?? "Unknown error")
									return
							}
				
				guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
						print("statusCode should be 2xx, but is \(response.statusCode)")
						print("response = \(response)")
						return
				}
				
				let responseString = String(data: safeData, encoding: .utf8)
		}
		task.resume()
	}
	
	/*
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let dts = dateFormatter.string(from: Date())
		
		// create a corresponding local notification
		let notification = UILocalNotification()
		notification.alertBody = "Enter " + region.identifier + " @" + dts
		notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = Date.init()
		notification.soundName = UILocalNotificationDefaultSoundName // play default sound
		
		UIApplication.shared.scheduleLocalNotification(notification)
	}
	
	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let dts = dateFormatter.string(from: Date())
		
		// create a corresponding local notification
		let notification = UILocalNotification()
		notification.alertBody = "Leave " + region.identifier + " @" + dts
		notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = Date.init()
		notification.soundName = UILocalNotificationDefaultSoundName // play default sound
		
		UIApplication.shared.scheduleLocalNotification(notification)
	}
	 */
	func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
		print("Failed monitoring region: \(error.localizedDescription)")
	}
		
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Location manager failed: \(error.localizedDescription)")
	}
}

