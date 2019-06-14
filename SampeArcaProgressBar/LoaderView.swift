//
//  SpinLoader.swift
//  SampeArcaProgressBar
//
//  Created by Anton Umnitsyn on 5/29/19.
//  Copyright © 2019 Anton Umnitsyn. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    private var titleString: String!
    private var titleFont: UIFont!
    private var titleColor: UIColor!
    private var spinnerColor: UIColor!
    
    init(frame: CGRect, title: String, font: UIFont, titleColor:UIColor, spinnerColor: UIColor) {
        self.titleString = title
        self.titleFont = font
        self.titleColor = titleColor
        self.spinnerColor = spinnerColor
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        
        let titleView = UIView(frame: CGRect(x: 40, y: frame.height/2 - 30, width: frame.width - 80, height: 60))
        titleView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 10, width: titleView.frame.width - 80, height: 40))
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        titleLabel.text = titleString
        titleView.addSubview(titleLabel)
        
        let spinnerView = SpinLoader(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        titleView.addSubview(spinnerView)
        
        self.addSubview(titleView)
    }
}


class SpinLoader: UIView, CAAnimationDelegate {

    public var lineWidth:CGFloat = 4.0
    public var fillColor: UIColor = .red
    
    let circularLayer = CAShapeLayer()
    
    let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        return animation
    }()
    
    let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 1
        animation.fromValue = 0.0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        return animation
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * CGFloat.pi
        animation.duration = 2.0
        animation.repeatCount = MAXFLOAT
        
        return animation
    }()
    
    var colorIndex : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circularLayer.lineWidth = lineWidth
        circularLayer.fillColor = nil
        layer.addSublayer(circularLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circularLayer.lineWidth / 2
        
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat(CGFloat.pi/2 + (2 * CGFloat.pi)), clockwise: true)
        
        circularLayer.position = center
        circularLayer.path = arcPath.cgPath
        
        animateProgressView()
        circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(flag) {
            animateProgressView()
        }
    }
    
    func animateProgressView() {
        circularLayer.removeAnimation(forKey: "strokeAnimation")
        
        circularLayer.strokeColor = fillColor.cgColor
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.0 + outAnimation.beginTime
        strokeAnimationGroup.repeatCount = 1
        strokeAnimationGroup.animations = [inAnimation, outAnimation]
        strokeAnimationGroup.delegate = self
        
        circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
    }
}
