//
//  mapViewTabViewController.swift
//  interStellarTest
//
//  Created by sami on 2017/07/24.
//  Copyright © 2017年 pancristal. All rights reserved.
//

import UIKit
import MapKit
import Interstellar

class mapViewTabViewController: UIViewController {
    
    var initialMapCentered = false;
    var currentFilteringMode = mapFilteringMode.world
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        if let mlt = storage.getObject(oID: "mapCombiner") as! MapCombiner? {
            
            //if mapCombiner is alive ask for maps
            //mapCombiner will send a mapSnap via observable
            mlt.changeFilteringMode (filteringMode : currentFilteringMode )
            
            //check if we have a snap on the disk for this purpose
            
            
            //if not, process one
            let gump = mlt.createSnapshot()
            
        }
        
        /*var mergedQueueToken = myCurrentGpsLocation.subscribe { t in
            
            if !self.initialMapCentered {
                //getting this signal autodisplays za map
                self.centerMapOnLocation(location: t )
                
            } else {
                
                //follow your movement with a marker
                
                self.centerMapOnLocation(location: t )
            }
            
            self.initialMapCentered=true //dont center map again
            
        }*/
        
        //let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        //let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        mapSnapshotObserver.subscribe { mapSnap in
            
            //got a snapshot from mapCombiner
            self.mapSnapshotReceived( mapSnap : mapSnap )
         
         }
        
        
        
        //if location logger exists, let it tell us where we are
        
        LocationLoggerMessageObserver.subscribe
            { locationMessage in
                
                /*if self.mapView == nil {
                    
                    return
                    
                }*/
                let lc = CLLocation(latitude: locationMessage.lat, longitude: locationMessage.lon)
                
                let center = CLLocationCoordinate2D(latitude: lc.coordinate.latitude, longitude: lc.coordinate.longitude)
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.setCenter(center, animated: true)
                
                //self.centerMapOnLocation(location: lc)
                //self.locationMessageGotFromLocationLogger(locationMessage : locationMessage)
                // Drop a pin at user's Current Location
                let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                myAnnotation.coordinate = CLLocationCoordinate2DMake(lc.coordinate.latitude, lc.coordinate.longitude);
                myAnnotation.title = "Current location"
                self.mapView.addAnnotation(myAnnotation)
                
            }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        initialMapCentered=false
        
    }
    
    func mapSnapshotReceived( mapSnap : mapSnapshot ) {
        
        //MapCombiner gives us a new snap for some reason
        
        /*
         let o : [MKPolyline]
         let filteringMode : mapFilteringMode //throw everything in as default
         let lat : CLLocationDegrees
         let lon : CLLocationDegrees
         let getWithinArea : Double
         */
        
        // track if it is what we want to see now
        
        
        
        
    }
    
}
