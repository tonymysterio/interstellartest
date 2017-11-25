//
//  MapCombiner.swift
//  interStellarTest
//
//  Created by sami on 2017/11/25.
//  Copyright © 2017年 pancristal. All rights reserved.
//

import Foundation
import Interstellar


class MapCombiner : BaseObject  {
    
    let queue = DispatchQueue(label: "PullRunsFromDiskQueue", qos: .utility)
    let path = "Library/Application support/" //runData"
    //dont store runs here
    
    //pull from disk
    //send with runReceivedObservable¥
    
    //when we go to map page and need to see previous runs
    //start this component. wait . thats too late.
    //should this guy live long? its ok to be purged with heaps of runs, then read from disk again with pullRunsFromDisk
    //just pass a snapshot for the map to view then
    //only the map view needs this so prime this there?
    
    
    
    //recipients include mapCombiner (make map)
    //runsListView
    //kill this when finished (no caching here now)
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
        
        
        
        
        
    }

}
