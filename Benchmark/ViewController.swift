//
//  ViewController.swift
//  Benchmark
//
//  Created by David Franko on 9/22/16.
//  Copyright © 2016 David Franko. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    
    
    
//    MARK - IBOUTLETS VARS
    
    @IBOutlet weak var randomNumberLabel: NSTextField!
    
    @IBOutlet weak var randomGenerateButton: NSButton!
    
    @IBOutlet weak var printNegativeValuesButton: NSButton!
    
    
//    MARK - PERSONAL VARIABLES
    
    var dataArray = [Int]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        FIRST STEP, GENERATE N RANDOM NUMBERS
        randomGenerateButton.target = self
        randomGenerateButton.action = #selector(generateNewNumber)
        
        
        printNegativeValuesButton.target = self
        printNegativeValuesButton.action = #selector(printLessThanZero)
        
//        SECOND STEP, SAVE AND LOAD
        
        
//        THIRD STEP, GET METRICS...
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func generateNewNumber() {
        
        
//        GETTING CURRENT DATE/TIME
        var cDate = self.getCurrentTime()
        print("Start time: ", cDate)
        
        
        
//        self.randomNumberLabel.stringValue = "\(randomNum)"
        
        for _ in 1...100000000 {
            let randomNum = self.random64(Int64.max)
            self.dataArray.append(Int(randomNum))
        }
        cDate = self.getCurrentTime()
        
        print("\nThe DataArray size is: ", self.dataArray.count, " and the last value is: ", self.dataArray[self.dataArray.count - 1])
        print("\nFinal time: ", cDate)
        
    }
    
    
    
    func getCurrentTime() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let nanosecond = components.nanosecond
//        print(hour, ":", minute, ":", second, ":", nanosecond)
        return "\(hour):\(minute):\(second):\(nanosecond)"
    }

    
    func printLessThanZero() {
        var i = Int()
        var e = Int()
        for numb in self.dataArray {
            if numb < 0 {
                i += 1
            } else {
                e += 1
            }
        }
        
        print("\nnegative numbers: ", i)
        print("\nPositive numbers: ", e)
        
        var dif = i - e
        
        if dif < 0 { dif = dif * (-1) }
        
        print("\nDifference is: ", dif)
    }

    
    
    func random64(upper_bound: Int64) -> Int64 {
        
        // Generate 64-bit random value in a range that is
        // divisible by upper_bound:
        let range = Int64.max - Int64.max % upper_bound
        var rnd : Int64 = 0
        repeat {
            arc4random_buf(&rnd, sizeofValue(rnd))
        } while rnd >= range
        
        return rnd % upper_bound
    }
    
    
    func getTime(startTime: NSDate, endTime: NSDate) {
    
    }
    
    
    
}

