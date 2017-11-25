//
//  pullRunsFromDisk.swift
//  interStellarTest
//
//  Created by sami on 2017/11/25.
//  Copyright © 2017年 pancristal. All rights reserved.
//

import Foundation
import Disk

class PullRunsFromDisk: BaseObject  {

    let queue = DispatchQueue(label: "PullRunsFromDiskQueue", qos: .utility)
    let path = "Library/Application support/" //runData"
    //dont store runs here
    
    //pull from disk
    //send with runReceivedObservable¥

    //recipients include mapCombiner (make map)
    //runsListView
    //kill this when finished (no caching here now)
    func _initialize () -> DROPcategoryTypes? {
        
        myCategory = objectCategoryTypes.uniqueServiceProvider  //only one file accessor at a time
        self.name = "PullRunsFromDisk"
        self.myID = "PullRunsFromDisk"
        self.myCategory = objectCategoryTypes.uniqueServiceProvider
        
        //disappears
        _pulse(pulseBySeconds: 60)
        
        //if for some reason we cannot store to disk, give this
        //DROPcategoryTypes.serviceNotAvailable
        
        //if disk space is low, return
        //DROPcategoryTypes.lowDiskspace
        
        return nil
        
    }
    
    func scanForRuns () {
        
        //if Disk.exists("runData", in: .applicationSupport ) {
            // ...
            
        //}
        
        let files = try? Disk.retrieve("runData", from: .caches, as: [Data])
        for i in files! {
            if let j = String(data:i, encoding:.utf8) {
                print (j);
                
            }
            
        }
        
        let fileManager = FileManager()
        
        // Get contents in directory: '.' (current one)
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            print(files)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
}
