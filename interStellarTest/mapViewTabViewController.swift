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
    
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    
    
    
}
