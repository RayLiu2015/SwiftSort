//
//  Array+Sort.swift
//  SwiftSort
//
//  Created by liuRuiLong on 2017/6/28.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

import Foundation

extension Array{
    typealias Compare = (_ ele1: Element, _ ele2: Element) -> ComparisonResult
    typealias Compared = (_ ele1: Element, _ ele2: Element) -> Void
    
    mutating func bubbleSort(order: ComparisonResult) ->  @noescape (_ compare: Compare, _ compared: Compared) -> Void{
        return {(compare, compared) in
            for i in 0..<self.count{
                for j in 0..<self.count - i - 1{
                    let compareResult = compare(self[j], self[j + 1])
                    if compareResult != ComparisonResult.orderedSame && compareResult != order{
                            self.exchange(indexA: j, indexB: j + 1, compared: compared)
                    }
                }
            }
        }
    }
    
    mutating func selectionSort(order: ComparisonResult) ->  @noescape (_ compare: Compare, _ compared: Compared) -> Void{
        return {(compare, compared) in
            for i in 0..<count-1 {
                for j in i..<count{
                    let compareResult = compare(self[i], self[j])
                    if compareResult != ComparisonResult.orderedSame && compareResult != order{
                        self.exchange(indexA: i, indexB: j, compared: compared)
                    }
                }
            }
        }
    }
    
    mutating func insertSort(order: ComparisonResult) ->  @noescape (_ compare: Compare, _ compared: Compared) -> Void{
        return {(compare, compared) in
            for i in 1..<count {
                for j in (1...i).reversed(){
                    let compareReuslt = compare(self[j], self[j - 1])
                    if compareReuslt != .orderedSame && compare(self[j], self[j - 1]) == order{
                        exchange(indexA: j, indexB: j - 1, compared: compared)
                    }else{
                        break
                    }
                    
                }
            }
        }
    }
    mutating func quickSort(order: ComparisonResult) -> @noescape (_ compare: Compare, _ compared: Compared) -> Void {
        return { (compare, compared) -> Void in
            self.quickSort(order: order, lowIndex: 0, highIndex: self.count - 1, compare: compare, compared: compared)
        }
    }
    private mutating func quickSort(order: ComparisonResult, lowIndex: Int, highIndex: Int, compare: Compare, compared: Compared) {
        guard highIndex > lowIndex else{
            return
        }
        var middle = lowIndex
        let base = self[lowIndex]
        var low = lowIndex
        var high = highIndex
        while high > low {
            while high > low {
                let compareResult = compare(base, self[high])
                if compareResult == order || compareResult == .orderedSame{
                    high -= 1
                }else{
                    break
                }
            }
            
            if high > low{
                exchange(indexA: low, indexB: high, compared: compared)
                low += 1
            }
            while high > low && compare(base, self[low]) != order{
                low += 1
            }
            if high > low{
                exchange(indexA: low, indexB: high, compared: compared)
            }
        }
        middle = low
        quickSort(order: order, lowIndex: middle + 1, highIndex: highIndex, compare: compare, compared: compared)
        quickSort(order: order, lowIndex: lowIndex, highIndex:middle - 1, compare: compare, compared: compared)
        
    }
    
    
    mutating func heapSort(order: ComparisonResult) -> @noescape (_ compare: Compare, _ compared: Compared) -> Void{
        return { (compare, compared) -> Void in
            func sort(start: Int, end: Int, compare: Compare, compared: Compared){
                var index = start
                var inStart = index * 2 + 1
                while inStart <= end {
                    if inStart < end && compare(self[inStart], self[inStart + 1]) == order{
                    inStart += 1
                    }
                    if compare(self[index], self[inStart]) != order{
                        break
                    }
                    exchange(indexA: index, indexB: inStart, compared: compared)
                    index = inStart
                    inStart = inStart * 2 + 1
                }
            }
            for i in  (0...(count-1)/2).reversed(){
                sort(start: i, end: self.count - 1, compare: compare, compared: compared)
            }
        
            for index in (0..<count).reversed() {
                self.exchange(indexA: 0, indexB: index, compared: compared)
                sort(start: 0, end: index - 1, compare: compare, compared: compared)
            }
        }
    }
    
   
    
    
    mutating func twoSort(_ compare: (_ ele1: Element, _ ele2: Element) -> Bool,  compared:(_ ele1: Element, _ ele2: Element) -> ()){
        guard count > 0 else{
            return
        }
        for i in 1..<count{
            var left = 0
            var right = i - 1
            let num = self[i]
            
            while right >= left{
                let middle = (right + left)/2
                if compare(self[middle], num){
                    right = middle - 1
                }else{
                    left = middle + 1
                }
            }
            if left != i{
                for j in (left + 1...i).reversed(){
                    self[j] = self[j - 1]
                }
                self[left] = num
            }
            
        }
    }
    
    
    
    
    private mutating func exchange(indexA: Int, indexB: Int, compared:Compared){
        let ele = self[indexA]
        self[indexA] = self[indexB]
        self[indexB] = ele
        compared(ele, self[indexA])
    }
    
    
    
    
}
