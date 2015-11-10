//
//  InterfaceController.swift
//  DataSharing WatchKit Extension
//
//  Created by Salah Alshaal on 11/10/15.
//  Copyright © 2015 Salah Alshaal. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit

class CHeart: HKWorkoutSessionDelegate{
    var workoutSession: HKWorkoutSession!
    var workoutStartDate
    init(){
        // Create a new workout session
        self.workoutSession = HKWorkoutSession(activityType: .Running, locationType: .Indoor)
        self.workoutSession!.delegate = self;
        
        // Start the workout session
        self.healthStore.startWorkoutSession(self.workoutSession!)
        
        // This is the type you want updates on. It can be any health kit type, including heart rate.
        let distanceType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        // Match samples with a start date after the workout start
        let predicate = HKQuery.predicateForSamplesWithStartDate(workoutStartDate, endDate: nil, options: .None)
        
        let distanceQuery = HKAnchoredObjectQuery(type: distanceType!, predicate: predicate, anchor: 0, limit: 0) { (query, samples, deletedObjects, anchor, error) -> Void in
            // Handle when the query first returns results
            // TODO: do whatever you want with samples (note you are not on the main thread)
        }
        
        // This is called each time a new value is entered into HealthKit (samples may be batched together for efficiency)
        distanceQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            // Handle update notifications after the query has initially run
            // TODO: do whatever you want with samples (note you are not on the main thread)
        }
        
        // Start the query
        self.healthStore.executeQuery(distanceQuery)
    }
}

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var mMessageLabel: WKInterfaceLabel!
    var session: WCSession!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
            session.sendMessage(["b":"Session started"], replyHandler: nil, errorHandler: nil)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func sendMessage() {
        if(WCSession.isSupported()){
            session.sendMessage(["b":"goodBye"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    @IBAction func sendHeartRate() {
        // create an instance of CHeart
        if(WCSession.isSupported()){
            session.sendMessage(["b":"goodBye"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieving message from iphone
        self.mMessageLabel.setText(message["a"]! as? String)
    }
}
