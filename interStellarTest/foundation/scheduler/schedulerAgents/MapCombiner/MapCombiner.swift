//
//  MapCombiner.swift
//  interStellarTest
//
//  Created by sami on 2017/11/25.
//  Copyright © 2017年 pancristal. All rights reserved.
//

import Foundation
import Interstellar
import GEOSwift
import MapKit

class MapCombiner : BaseObject  {
    
    let pullQueue = DispatchQueue(label: "PullRunsFromDiskQueue", qos: .utility)
    let runQueue = DispatchQueue(label: "runQueueManipulation", qos: .utility)
    let path = "Library/Application support/" //runData"
    //dont store runs here
    var runs = Runs()
    var lastInsertTimestamp = Date().timeIntervalSince1970
    let combineAfterIntervalSecons = 1
    var filteringMode = mapFilteringMode.world  //throw everything in as default
    var initialLocation : locationMessage
    var Lat : CLLocationDegrees = 65.822299
    var Lon : CLLocationDegrees = 24.2002689
    var zoomLevelInMeters = 5000;
    let user = "samui@hastur.org"
    
    //pull from disk
    //send with runReceivedObservable¥
    
    //when we go to map page and need to see previous runs
    //start this component. wait . thats too late.
    //should this guy live long? its ok to be purged with heaps of runs, then read from disk again with pullRunsFromDisk
    //just pass a snapshot for the map to view then
    //only the map view needs this so prime this there?
    
    
    //hasTimeoutExpired
    //recipients include mapCombiner (make map)
    //runsListView
    //kill this when finished (no caching here now)
    
    //if we get a mapFilteringModeToggleObserver on mapViewJunction, junction calls my
    
    func _initialize () -> DROPcategoryTypes? {
        
        myCategory = objectCategoryTypes.uniqueServiceProvider  //only one file accessor at a time
        self.name = "MapCombiner"
        self.myID = "MapCombiner"
        self.myCategory = objectCategoryTypes.uniqueServiceProvider
        
        //disappears
        _pulse(pulseBySeconds: 60)
        
        //if for some reason we cannot store to disk, give this
        //DROPcategoryTypes.serviceNotAvailable
        
        //if disk space is low, return
        //DROPcategoryTypes.lowDiskspace
        runReceivedObservable.subscribe
            { run in
                self.addRun( run : run )
                
        }
        
        
        
        return nil
        
    }
    
    func addRun ( run : Run ) {
        
        self.runQueue.sync { [weak self] in
            
            if let ok = self?.runs.append(run : run ) {
                
                //process when time has passed
                lastInsertTimestamp = Date().timeIntervalSince1970
            }
            
        }
    }   //end addRun
    
    func createSnapshot () {
        
        if self.isProcessing { return }
        //ignore further additions
        self.startProcessing()
        //data might appear after this,just copy the existing items and pass to createSnapshots
        self.runQueue.sync { [weak self] in
            //if self is lost, bugger off
            //https://www.swiftbysundell.com/posts/capturing-objects-in-swift-closures
            guard let strongSelf = self else {
                return
            }
            
            if let currentRuns = strongSelf.runs.getWithinArea(self.Lat,self.Lon,self.getWithinArea) {
                
                //pushes the snap output thru an observer if one gets produced
                strongSelf.createSnapshotFromRuns(runs: currentRuns)
                
            } else {
                
                //no data with current location. let this guy TTL unless we get some data
                self.finishProcessing()
            }
            
        }
        
    }   //end create snacreateSnapshot
    
    func createSnapshotFromRuns ( runs : Runs ) {
        
        
        
        switch (self.filteringMode) {
            
        case (.world):
            self.createSnapshotFromRunsForWorld ()
        case (.personal):
            self.createSnapshotFromRunsForPersonal ()
            
        default: self.createSnapshotFromRunsForLocalCompetition ()
        }
        
    }
    
    func createSnapshotFromRunsForWorld ( runs : Runs ) {
        //its all there, put it into a stack
        let r = runs.allSorted()
        
        
        for i in r {
            
            
            
        }
        //do this in background queue
        
        
    }
    
    func createSnapshotFromRunsForPersonal ( runs : Runs ) {
        guard let personalRuns = runs.readByUser(self.user) else {
            //notify about no personal runs?
            
            self.finishProcessing()
            return;
        }
    }
    
    func createSnapshotFromRunsForLocalCompetition ( runs : Runs ) {
        
        //pull clans out, then mix and macho
        
    }
    
    
    func changeFilteringMode ( filteringMode : mapFilteringMode ) {
        
        //might not be a good idea. run map combine with current filtering, then die?
        if self.isProcessing { return }
        self.filteringMode = filteringMode
        
    }
}
