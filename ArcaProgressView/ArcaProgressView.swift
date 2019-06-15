//
//  ArcaProgressVC.swift
//  SampeArcaProgressBar
//
//  Created by Anton Umnitsyn on 5/28/19.
//  Copyright © 2019 Anton Umnitsyn. All rights reserved.
//

import UIKit

class ArcaProgressView: UIView {
    
    public var progressBackgoundColor = UIColor.lightGray
    public var oneProgressForegroundColor = UIColor.red
    public var twoProgressForegroundColor = UIColor.blue
    public var threeProgressForegroundColor = UIColor.green
    
    public var lineWidth:CGFloat = 30 {
        didSet{
            foregroundLayerOne.lineWidth = lineWidth
            backgroundLayerOne.lineWidth = lineWidth
            foregroundLayerTwo.lineWidth = lineWidth
            backgroundLayerTwo.lineWidth = lineWidth
            foregroundLayerThree.lineWidth = lineWidth
            backgroundLayerThree.lineWidth = lineWidth
        }
    }
    
    public var duration: Double = 0.5
    
    public var labelSize: CGFloat = 20.0 {
        didSet {
            oneLabel.font = UIFont.systemFont(ofSize: labelSize, weight: .bold)
            oneLabel.textColor = oneProgressForegroundColor
            oneLabel.sizeToFit()
            configLabel()
        }
    }
    
    public func setProgressOne(to progressConstant: Double, withAnimation: Bool, maxSpeed: Double) {
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        foregroundLayerOne.strokeEnd = CGFloat(progress)
        
        self.oneLabel.text = "\(Int((maxSpeed/100) * progress*100))"
        self.configLabel()
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = duration
            foregroundLayerOne.add(animation, forKey: "foregroundAnimation")
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= self.duration{
                timer.invalidate()
            } else {
                currentTime += 0.05
                self.setForegroundLayerColorForSpeed()
            }
        }
        timer.fire()
    }
    
    public func setProgressTwo(to progressConstant: Double, withAnimation: Bool) {
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        foregroundLayerTwo.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = duration
            foregroundLayerTwo.add(animation, forKey: "foregroundAnimation")
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= self.duration{
                timer.invalidate()
            } else {
                currentTime += 0.05
                self.setForegroundLayerColorForPower()
            }
        }
        timer.fire()
    }
    
    public func setProgressThree(to progressConstant: Double, withAnimation: Bool) {
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        foregroundLayerThree.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = self.duration
            foregroundLayerThree.add(animation, forKey: "foregroundAnimation")
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= self.duration{
                timer.invalidate()
            } else {
                currentTime += 0.05
                self.setForegroundLayerColorForBattary()
            }
        }
        timer.fire()
    }
    
    //MARK: Private
    private var oneLabel = UILabel()
    private let foregroundLayerOne = CAShapeLayer()
    private let backgroundLayerOne = CAShapeLayer()
    
    private let foregroundLayerTwo = CAShapeLayer()
    private let backgroundLayerTwo = CAShapeLayer()
    
    private let foregroundLayerThree = CAShapeLayer()
    private let backgroundLayerThree = CAShapeLayer()
    
    private var radius: CGFloat {
        get{
            return (min(self.frame.width, self.frame.height) - lineWidth)/2
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayerSpeed()
        drawForegroundLayerSpeed()
        drawBackgroundLayerPower()
        drawForegroundLayerPower()
        drawBackgroundLayerBat()
        drawForegroundLayerBat()
    }
    
    
    // MARK: Speed bar
    private let oneStartAngle = CGFloat.pi*2.6/3
    private let oneEndAngle = CGFloat.pi*4.8/3
    
    private func drawBackgroundLayerSpeed(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: oneStartAngle , endAngle: oneEndAngle, clockwise: true)
        self.backgroundLayerOne.path = path.cgPath
        self.backgroundLayerOne.strokeColor = progressBackgoundColor.cgColor
        self.backgroundLayerOne.lineWidth = lineWidth
        self.backgroundLayerOne.lineCap = CAShapeLayerLineCap.round
        self.backgroundLayerOne.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayerOne)
    }
    
    private func drawForegroundLayerSpeed(){
        let startAngle = oneStartAngle
        let endAngle = oneEndAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayerOne.lineCap = CAShapeLayerLineCap.round
        foregroundLayerOne.path = path.cgPath
        foregroundLayerOne.lineWidth = lineWidth
        foregroundLayerOne.fillColor = UIColor.clear.cgColor
        foregroundLayerOne.strokeColor = oneProgressForegroundColor.cgColor
        foregroundLayerOne.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayerOne)
        
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = pathCenter
        return label
    }
    
    private func makeOneTitleLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: lineWidth + 15, y: self.frame.height - lineWidth - 95, width: 50, height: 40))
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = oneProgressForegroundColor
        return label
    }
    
    private func configLabel(){
        oneLabel.sizeToFit()
        oneLabel.center = pathCenter
    }
    
    private func setForegroundLayerColorForSpeed(){
        self.foregroundLayerOne.strokeColor = oneProgressForegroundColor.cgColor
    }
    
    // MARK: Power bar
    private let twoStartAngle = CGFloat.pi*0.4/3
    private let twoEndAngle = CGFloat.pi*5.1/3
    
    private func drawBackgroundLayerPower(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: twoStartAngle, endAngle: twoEndAngle, clockwise: false)
        self.backgroundLayerTwo.path = path.cgPath
        self.backgroundLayerTwo.strokeColor = progressBackgoundColor.cgColor
        self.backgroundLayerTwo.lineWidth = lineWidth
        self.backgroundLayerTwo.lineCap = CAShapeLayerLineCap.round
        self.backgroundLayerTwo.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayerTwo)
        
    }
    
    private func drawForegroundLayerPower(){
        let startAngle = twoStartAngle
        let endAngle = twoEndAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        foregroundLayerTwo.lineCap = CAShapeLayerLineCap.round
        foregroundLayerTwo.path = path.cgPath
        foregroundLayerTwo.lineWidth = lineWidth
        foregroundLayerTwo.fillColor = UIColor.clear.cgColor
        foregroundLayerTwo.strokeColor = twoProgressForegroundColor.cgColor
        foregroundLayerTwo.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayerTwo)
        
    }
    
    private func makeTwoTitleLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: self.frame.width - 95, y: self.frame.height - lineWidth - 95, width: 50, height: 40))
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = twoProgressForegroundColor
        return label
    }
    
    private func setForegroundLayerColorForPower(){
        self.foregroundLayerTwo.strokeColor = twoProgressForegroundColor.cgColor
    }
    
    // MARK: Battary bar
    private let threeStartAngle = CGFloat.pi*2.3/3
    private let threeEndAngle = CGFloat.pi*0.7/3
    
    private func drawBackgroundLayerBat(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: threeStartAngle, endAngle: threeEndAngle, clockwise: false)
        self.backgroundLayerThree.path = path.cgPath
        self.backgroundLayerThree.strokeColor = progressBackgoundColor.cgColor
        self.backgroundLayerThree.lineWidth = lineWidth
        self.backgroundLayerThree.lineCap = CAShapeLayerLineCap.round
        self.backgroundLayerThree.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayerThree)
        
    }
    
    private func drawForegroundLayerBat(){
        let startAngle = threeStartAngle
        let endAngle = threeEndAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        foregroundLayerThree.lineCap = CAShapeLayerLineCap.round
        foregroundLayerThree.path = path.cgPath
        foregroundLayerThree.lineWidth = lineWidth
        foregroundLayerThree.fillColor = UIColor.clear.cgColor
        foregroundLayerThree.strokeColor = threeProgressForegroundColor.cgColor
        foregroundLayerThree.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayerThree)
        
    }
    
    private func makeThreeTitleLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: self.frame.width/2 - 35, y: self.frame.height - lineWidth - 30, width: 70, height: 20))
        label.text = text
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = threeProgressForegroundColor
        return label
    }
    
    private func setForegroundLayerColorForBattary(){
        self.foregroundLayerThree.strokeColor = threeProgressForegroundColor.cgColor
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(oneLabel)
        self.addSubview(makeOneTitleLabel(withText: "First\nvalues"))
        self.addSubview(makeTwoTitleLabel(withText: "Second\nvalues"))
        self.addSubview(makeThreeTitleLabel(withText: "Third"))
    }
    
    //Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = oneLabel.text
            setupView()
            oneLabel.text = tempText
            layoutDone = true
        }
    }
    
}
