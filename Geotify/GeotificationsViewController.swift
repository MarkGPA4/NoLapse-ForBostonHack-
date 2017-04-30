/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import CoreLocation
import Alamofire
struct PreferencesKeys {
  static let savedItems = "savedItems"
}

class GeotificationsViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var geotifications: [Geotification] = []
  var locationManager = CLLocationManager()
  private var places = [CLLocationCoordinate2D]()
  
  var place1 = CLLocationCoordinate2D(latitude: CLLocationDegrees(42.350865), longitude: CLLocationDegrees(-71.108835))
  
 
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    super.viewDidLoad()
    // 1
    locationManager.delegate = self
    // 2
    locationManager.requestAlwaysAuthorization()
    // 3
    
    let geotification1 = Geotification(coordinate: place1,radius: 10,identifier: "1",eventType: EventType(rawValue: "On Entry")!)
    
    
    startMonitoring(geotification: geotification1)
    
  
  }
  

  /*
  // MARK: Loading and saving functions
  func loadAllGeotifications() {
    geotifications = []
    guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
    for savedItem in savedItems {
      guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
    
    }
  }
 */
  /*
  func saveAllGeotifications() {
    var items: [Data] = []
    for geotification in geotifications {
      let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
      items.append(item)
    }
    UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
  }
*/
  

  func region(withGeotification geotification: Geotification) -> CLCircularRegion {
    // 1
    let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
    // 2
    region.notifyOnEntry = (geotification.eventType == .onEntry)
    region.notifyOnExit = !region.notifyOnEntry
    return region
  }
  
  func startMonitoring(geotification: Geotification) {
    // 1
    if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
    //  showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
      return
    }
    // 2
    if CLLocationManager.authorizationStatus() != .authorizedAlways {
  //    showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
    }
    // 3
    let region = self.region(withGeotification: geotification)
    // 4
    locationManager.startMonitoring(for: region)
    
  }
  
  
  
  
  
  func stopMonitoring(geotification: Geotification) {
   for region in locationManager.monitoredRegions {
      guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
      locationManager.stopMonitoring(for: circularRegion)
    }
  }
}
/*

func getFilePath(fileName: String) -> String? {
  //Generate a computer readable path
  return NSBundle.mainBundle().pathForResource(fileName, ofType: "gpx")
}



func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
  //Only check for the lines that have a <trkpt> or <wpt> tag. The other lines don't have coordinates and thus don't interest us
  if elementName == "trkpt" || elementName == "wpt" {
    //Create a World map coordinate from the file
    let lat = attributeDict["lat"]!
    let lon = attributeDict["lon"]!
    
    place = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!)
    
    geotification = Geotification(place,500,"1","On Entry")
    
  }
}




func getGeotifications(){
  let filePath = getFilePath(TestLocations.gpx)
  //Setup the parser and initialize it with the filepath's data
  let data = NSData(contentsOfFile: filePath!)
  let parser = NSXMLParser(data: data!)
  let success = parser.parse()
  
  
  //Log an error if the parsing failed
  if !success {
    print ("Failed to parse the following file")
  }

}


*/


// MARK: AddGeotificationViewControllerDelegate
/*
extension GeotificationsViewController: AddGeotificationsViewControllerDelegate {
  
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
    controller.dismiss(animated: true, completion: nil)
    // 1
    let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
    let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
       // 2
   
  }

}


*/

// MARK: - Location Manager Delegate
extension GeotificationsViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    mapView.showsUserLocation = status == .authorizedAlways
  }
  
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Monitoring failed for region with identifier: \(region!.identifier)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager failed with the following error: \(error)")
  }

}

