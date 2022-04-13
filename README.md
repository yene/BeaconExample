# Beacon Example

just a hacked together prototype to see if iBeacon still work as expected on iOS.

## How to test
You cannot get any CoreLocation iBeacon events or CoreBluetooth events from the iOS simulator. This makes it of very limited use in developing iBeacon applications. Use the [BeaconEmitter](https://github.com/lgaches/BeaconEmitter) to simulate a device.

## Notes
* Somewhere it stated the app only gets 5-10 seconds to wake up, and then is suspended again
* The user needs to grant the "always" permission "When in Use" is not enough to wake up the app when it see iBeacon.
* enter and exit Region is called twice, https://stackoverflow.com/a/14128942/279890
* entering a region is instantly, exiting takes a minute
* If you want a task to life a bit longer than when the app is closed, use Background Execution https://abhimuralidharan.medium.com/finite-length-tasks-in-background-ios-swift-60f2db4fa01b
* 

## What I did

## Links
* https://www.raywenderlich.com/632-ibeacon-tutorial-with-ios-and-swift


