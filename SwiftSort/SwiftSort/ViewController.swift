//
//  ViewController.swift
//  SwiftSort
//
//  Created by liuRuiLong on 2017/6/28.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

import UIKit

let barCount = 100

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var sortBackView: UIView!
    
    var sem:DispatchSemaphore? = DispatchSemaphore(value: 0)
    var timer: Timer?
    
    lazy var barArr:[UIView] = {
        var arr: [UIView] = []
        for _ in 0..<barCount {
            let barView = UIView()
            barView.backgroundColor = UIColor.red
            arr.append(barView)
            self.sortBackView.addSubview(barView)
        }
        return arr
    }()
    
    func reset() {
        timer?.invalidate()
        timer = nil
        sem = nil
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        let bCount = CGFloat(barCount)
        let width = sortBackView.bounds.width
        let height = sortBackView.bounds.height
        let barMargin:CGFloat = 1.0
        let barWidth = (width - barMargin * (bCount + 1.0))/bCount
        for (index, view) in barArr.enumerated() {
            let barHeight:CGFloat = 10.0 + CGFloat(arc4random_uniform(UInt32(height - 10.0)))
            view.frame = CGRect(x: barMargin + CGFloat(index) * (barMargin + barWidth), y: height - barHeight, width: barWidth, height: barHeight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    @IBAction func sortAct(_ sender: Any){
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        sem = DispatchSemaphore(value: 0)
        let beginDate = Date()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true, block: { [weak self](t) in
            self?.sem?.signal()
            let time = Date.timeIntervalSince(Date())(beginDate)
            self?.timeLabel.text = NSString(format: "耗时: %2.3fs", time) as String
        })
        DispatchQueue.global().async {
            switch self.segment.selectedSegmentIndex {
            case 0:
                self.bubbleSort()
            case 1:
                self.selectionSort()
            case 2:
                self.insertSort()
            default:
                break
            }
            self.timer?.invalidate()
            self.timer = nil
            DispatchQueue.main.async {
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    @IBAction func segmentChange(_ sender: Any) {
        reset()
    }
    
    func bubbleSort() {
         self.barArr.bubbleSort(order: .orderedAscending)({
            self.compare(v1: $0, v2: $1)
         }, {
            self.compared(v1: $0, v2: $1)
         })
    }
    func selectionSort() {
        self.barArr.selectionSort(order: .orderedAscending)({
            self.compare(v1: $0, v2: $1)
        },{
            self.compared(v1: $0, v2: $1)
        })
    }
    func insertSort() {
        barArr.insertSort(order: .orderedAscending)({
            self.compare(v1: $0, v2: $1)
        },{
           self.compared(v1: $0, v2: $1)
        })
    }
//    func twoSort() {
//        var arr = [3,5,1,5,23,7,123,34,454,234,46,7,34,3]
//        arr.twoSort({ (i1, i2) -> Bool in
//            return i1 > i2
//        }) { (i1, i2) in
//
//        }
//        print(arr)
//        self.barArr.twoSort({[weak self] (v1, v2) -> Bool in
//            self?.sem?.wait()
//            return v1.bounds.size.height > v2.bounds.size.height
//        }) { (v1, v2) in
//
//        }
//    }
    func compare(v1: UIView, v2: UIView) -> ComparisonResult {
        self.sem?.wait()
        if v1.bounds.height == v2.bounds.height{
            return .orderedSame
        }
        return v1.bounds.height > v2.bounds.height ? .orderedDescending : .orderedAscending
    }
    func compared(v1: UIView, v2: UIView) {
        DispatchQueue.main.async {
            let v1X = v1.frame.origin.x
            v1.frame.origin.x = v2.frame.origin.x
            v2.frame.origin.x = v1X
        }
    }
}

