//
//  ViewController.swift
//  interStellarTest
//
//  Created by sami on 2017/07/03.
//  Copyright © 2017年 pancristal. All rights reserved.
//

import UIKit
import Interstellar

class ViewController: UIViewController {
    
    //var objects = [ String : BaseObject]()
    
    
    /*var maxObjectsSliderObserver = Observable<Float>()
    var maxCatObjectsSliderObserver = Observable<Float>()
    var motionLoggerToggleObserver = Observable<Bool>()
    var locationLoggerToggleObserver = Observable<Bool>()*/ //these are in app delegate now
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //get papa
    var storage = MainStorageForObjects()   //should no be here?
    
    //var scheduler: Scheduler!
    //var messageQueue : MessageQueue!
    
    @IBOutlet weak var maxCatObjects: UISlider!
    @IBOutlet weak var maxObjectsSlider: UISlider!
    @IBOutlet weak var loggerSwitch: UISwitch!
    
    @IBOutlet weak var locationLoggerSwitch: UISwitch!
   
    
    
    var runRecordOn = false;
    @IBAction func toggleRunRecord(_ sender: UISwitch) {
        
        let vx = sender.isOn
        
        runRecoderToggleObserver.update(vx)
        if !runRecordOn {
            
            runRecordTime.text = "not running"
            runRecordDistance.text = "0m"
            runRecordPoints.text = "0"
        }
    }
    @IBOutlet weak var runRecordTime: UILabel!
    @IBOutlet weak var runRecordDistance: UILabel!
    @IBOutlet weak var runRecordPoints: UILabel!
    
    
    
    @IBOutlet weak var pedometerSteps: UILabel!
    @IBOutlet weak var pedometerDistance: UILabel!
    
    
    
    @IBAction func maxObjectSliderChanged (_ sender: UISlider) {
        
        let vx = sender.value
        appDelegate.maxObjectsSliderObserver.update(vx)
        
    }
    
    @IBAction func maxCatObjectsChanged(_ sender: UISlider) {
        
        let vx = sender.value
        appDelegate.maxCatObjectsSliderObserver.update(vx)
        
    }
    
    //turning loggers off _teardowns them
    //logger listeners contain the logged data
    //they _finalize according to their own logic
    
    @IBAction func loggerStatusChanged(_ sender: UISwitch) {
        
        let vx = sender.isOn
        appDelegate.motionLoggerToggleObserver.update(vx)
        
    }
    
    @IBAction func locationLoggerStatusChanged(_ sender: UISwitch) {
        
        let vx = sender.isOn
        appDelegate.locationLoggerToggleObserver.update(vx)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //table view top adjust ot show segmented selector
        //tableView.contentInset.top = UIApplication.shared.statusBarFrame.height
        
        // Do any additional setup after loading the view, typically from a nib.
        //weak var scheduler = appDelegate.scheduler;
        
        
        
        //messageQueue = MessageQueue(storage: storage );
        
        //scheduler needs messageQueue to pass to its children. Migth not be wise
        //should this go into storage
        
        //scheduler = Scheduler( storage: storage ,messageQueue : messageQueue );
        
        
        
        
        
        var worryAunt = Worrier( messageQueue : nil );
        
        /*let queue = Observable<BaseObject>()
        
        queue.update(worryAunt);    //attached to quue
        
        queue.subscribe { o in
            
            
            
            print("Hello \(string)")
        }*/
        
        
        //timews1.houseKeepingRole = houseKeepingRoles.master;
        worryAunt.myID = "worryAunt";
        worryAunt.name = "worryAunt";
        worryAunt.myCategory = objectCategoryTypes.debugger
        worryAunt._pulse(pulseBySeconds: 600);
        
        scheduler.addObject(oID: worryAunt.myID, o: worryAunt)
        scheduler.worryAuntID = worryAunt.myID;
        
        
        let mtra = MotionTracker( messageQueue : messageQueue );
        mtra.myCategory=objectCategoryTypes.motionlistener
        scheduler.addObject(oID: mtra.myID, o: mtra)
        mtra.addListener(oCAT: worryAunt.myCategory, oID: worryAunt.myID, name: worryAunt.name)
        
        //add locationTracker to listen to possible location changes
        let loctra = LocationTracker( messageQueue : messageQueue )
        loctra._initialize()
        scheduler.addObject(oID: loctra.myID, o: loctra)
        loctra.addListener(oCAT: worryAunt.myCategory, oID: worryAunt.myID, name: worryAunt.name)
        loctra._pulse(pulseBySeconds: 60)
        
        var timews1 = Timewaster( messageQueue : messageQueue );
        timews1.houseKeepingRole = houseKeepingRoles.master;
        timews1._pulse(pulseBySeconds: 60);
        
        let i1 = scheduler.addObject(oID: timews1.myID , o: timews1 )
        var timews2 = Timewaster( messageQueue : messageQueue );
        timews2.houseKeepingRole = houseKeepingRoles.master;
        timews2._pulse(pulseBySeconds: 60);
        
        
        
        let mc = PullRunsFromDisk(messageQueue: messageQueue)
        mc._initialize()
        mc.scanForRuns()
        
        //scheduler.initHousekeeping();
        //messageQueue.initHousekeeping()
        
        //prime ui changes piped to scheduler with interstellar signals
        signalListeners()
        
        return;
            
            
        //make 2 listen to 1
        timews2.addListener(oCAT: timews1.myCategory, oID: timews1.myID, name: timews1.name)
        timews2.addListener(oCAT: worryAunt.myCategory, oID: worryAunt.myID, name: worryAunt.name)
        
        //let i2 = scheduler.addObject(oID: timews2.myID, o: timews2 )
        //var timews3 = Timewaster( messageQueue : messageQueue );
        //timews3.houseKeepingRole = houseKeepingRoles.master;
        //timews3._pulse(pulseBySeconds: 60);
        
        
        //let i3 = scheduler.addObject(oID: timews3.myID , o: timews3 )
        
        
        var tum = 1;
        
        
        
        /*
         
         let vmcom = LocationLogger(messageQueue: self.messageQueue)
         let rv = vmcom._initialize()
         
        if rv != nil {
            
            //cannot access hardware or service
            switch rv {
            case .serviceNotAvailable :
                //the hardware does not exist at all, alert user about hard not available, turn the slider to off
                
                print()
                break
                
            case .serviceNotActivated :
                
                print()
                break
                
            default:
                <#code#>
            }
            
            
        } else {
            
            
            
            
        }
         
         self.scheduler.addObject(oID: "locationLogger" , o: vmcom)
         
        */
        
        
        
        
        //scheduler.initHousekeeping();
        //messageQueue.initHousekeeping()
        
        //print(storage.objects)
        
        //print (storage.objects);
        
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var toggleRunStreamReader: UISwitch!
    @IBAction func toggleRunStreamReader(_ sender: UISwitch) {
        
        let vx = sender.isOn
        runStreamReaderObserver.update( vx )
        
    }
    func signalListeners () {
    
        appDelegate.maxObjectsSliderObserver.subscribe { sliderVal in
            
            print(sliderVal)
            scheduler.maxObjects = Int(sliderVal)
        }
        
        appDelegate.maxCatObjectsSliderObserver.subscribe { sliderVal in
            
            print(sliderVal)
            //self.scheduler.maxObjects = Int(sliderVal)
            let dum = scheduler.relayConfigurationValue(k: liveConfigurationTypes.maxCategoryObjects, v: sliderVal);
            
            //print ( dum )
            
        }
        
        appDelegate.motionLoggerToggleObserver.subscribe { toggle in
            
            //var queue = DispatchQueue(label: "MainStorageForObjectsQueue")
            //queue.async {
            
            
            let moCo = self.storage.getObject(oID: "motionLogger")
            
            
            
            if toggle == false {
                if moCo != nil {
                    //trouble at sea. motion logger already exists
                    //kill it
                    _ = moCo?._finalize()   //stop motionmanager, data is being saved by some other process
                    //scheduler removes this with its housekeep
                    
                    
                    return
                    
                }
                
                //off, no logger
                
                
            } else {
                
                //strap it on!
                
                let mcom = MotionLogger(messageQueue: messageQueue)
                
                
                mcom.myID="motionLogger"
                _ = mcom._pulse(pulseBySeconds: 10)
                if ( scheduler.addObject(oID: "motionLogger" , o: mcom) ) {
                    
                    
                    _ = mcom._initialize()
                    
                    if let wau = self.storage.getObject(oID: "worryAunt") {
                        
                        _ = mcom.addListener(oCAT: objectCategoryTypes.debugger, oID: "worryaunt", name: "worryaunt")
                        
                    }
                    
                    
                } else {
                    print ("error adding motionLogger. too many objects? bail out")
                }
                
                
                //find current logger, send it a _finalize that calls _teardown message
                //moCo?._finalize()
            }
            
            //}   //queue async, same queue where the objects are
            
        } //end motion logger observer
        
        appDelegate.locationLoggerToggleObserver.subscribe { toggle in
            
            //TODO: move all this to runRecordedJunction.
            
            
            
        } //end location logger observer
        
        runAreaProgressObserver.subscribe { currentRun in
            
            //update screen
            let coordAm = String(currentRun.coordinates.count)
            let tt = currentRun.totalTime
            let dis = String(currentRun.totalDistance())
            
            let time = Int(tt)
            let hours = time / 3600
            let minutes = (time / 60) % 60
            let seconds = time % 60
            let guko = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
            
            /*let hour = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            let seconds = calendar.component(.second, from: date as Date)
            print("\(hour):\(minutes):\(seconds)")*/
            
            self.runRecordTime.text = guko
            self.runRecordDistance.text = dis
            self.runRecordPoints.text = coordAm
            
        }
        
        pedometerMessageObserver.subscribe { pedoMessage in
            
            //pedo meter is talking
            
            let st = String(pedoMessage.steps)
            let di = String(pedoMessage.distance)
            
            self.pedometerSteps.text = st;
            self.pedometerDistance.text = di
            
        }   //pedometerMessageObserver
        
        
    }   //end signal listeners for this view controller
    
}

