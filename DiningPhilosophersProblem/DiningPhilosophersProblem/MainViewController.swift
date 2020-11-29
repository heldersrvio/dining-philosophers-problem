//
//  ViewController.swift
//  DiningPhilosophersProblem
//
//  Created by Helder on 28/11/20.
//

import UIKit

class ViewController: UIViewController {
    let mutex = DispatchSemaphore(value: 1)
    let philosopherNameList = ["Averroes", "Konfuzius", "Nietzsche", "Voltaire", "Descartes"]
    @IBOutlet weak var ImageView1: UIImageView!
    @IBOutlet weak var ImageView2: UIImageView!
    @IBOutlet weak var ImageView3: UIImageView!
    @IBOutlet weak var ImageView4: UIImageView!
    @IBOutlet weak var ImageView5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hue: 0.3111, saturation: 0.38, brightness: 0.63, alpha: 1)
        let imageViews = [ImageView1, ImageView3, ImageView5, ImageView4, ImageView2]
        for (index, imageView) in imageViews.enumerated() {
            imageView?.layer.borderWidth = 3.0
            imageView?.layer.borderColor = UIColor.black.cgColor
            imageView?.image = UIImage(named: philosopherNameList[index])
            if let width = imageView?.frame.size.width {
                imageView?.layer.cornerRadius = width / 2
            }
        }

        let philosopherList = philosopherNameList.map{ Philosopher(name: $0, mutex: self.mutex) }
        for (index, philosopher) in philosopherList.enumerated() {
            philosopher.imageView = imageViews[index]
            philosopher.leftNeighbor = index - 1 >= 0 ? philosopherList[index - 1] : philosopherList[philosopherList.count - 1]
            philosopher.rightNeighbor = index + 1 < philosopherList.count ? philosopherList[index + 1] : philosopherList[0]
            DispatchQueue.global(qos: .background).async {
                philosopher.run()
            }
        }
        
    }


}

