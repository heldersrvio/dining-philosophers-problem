//
//  Philosopher.swift
//  DiningPhilosophersProblem
//
//  Created by Helder on 28/11/20.
//

import Foundation
import UIKit

class Philosopher {
    let globalMutex: DispatchSemaphore
    let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    var name: String
    var leftNeighbor: Philosopher!
    var rightNeighbor: Philosopher!
    var imageView: UIImageView!
    var state: PhilospherState {
        didSet {
            updateImageView()
        }
    }
    
    init(name: String, mutex: DispatchSemaphore) {
        self.name = name
        self.state = .thinking
        self.globalMutex = mutex
    }
    
    func takeForks() {
        globalMutex.wait()
        state = .hungry
        test()
        do {
            sleep(UInt32(Int.random(in: 0...5)))
        }
        globalMutex.signal()
        semaphore.wait()
    }
    
    func putForks() {
        globalMutex.wait()
        state = .thinking
        leftNeighbor.test()
        rightNeighbor.test()
        do {
            sleep(UInt32(Int.random(in: 0...5)))
        }
        globalMutex.signal()
    }
    
    func test() {
        if state == .hungry && leftNeighbor.state != .eating && rightNeighbor.state != .eating {
            state = .eating
            semaphore.signal()
        }
    }
    
    func updateImageView() {
        DispatchQueue.main.async {
            switch self.state {
            case .eating:
                self.imageView?.layer.borderColor = UIColor.red.cgColor
            case .hungry:
                self.imageView?.layer.borderColor = UIColor.yellow.cgColor
            case .thinking:
                self.imageView?.layer.borderColor = UIColor.blue.cgColor
            }
        }
    }
    
    func run() {
        while true {
            takeForks()
            putForks()
        }
    }
}
