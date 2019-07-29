//
//  InfinityHud.swift
//  InfinityHud
//
//  Created by Vladimir on 7/25/19.
//  Copyright © 2019 BVV. All rights reserved.
//

import UIKit

class InfinityHud: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var centerView: UIView!
    
    private var bottomLayer: CAShapeLayer!
    private var topLayer: CAShapeLayer!
    
    private var colors: [UIColor] = [.red, .blue] 
    private var isFirstColor: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(in view: UIView) {
        super.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        commonInit()
        show(in: view)
    }
    
    func show(in view: UIView) {
        self.alpha = 0.0
        view.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }) { (finish) in
            self.startAnimation()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { (finish) in
            self.stopAnimation()
            self.removeFromSuperview()
        }
    }
    
    func startAnimation() {
        self.bottomLayer.strokeColor = self.colors[0].cgColor
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.0
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.delegate = self
        
        if bottomLayer.zPosition == 1 {
            bottomLayer.add(pathAnimation, forKey: "bottomLayerAnimation")
        } else if topLayer.zPosition == 1 {
            topLayer.add(pathAnimation, forKey: "topLayerAnimation")
        }
    }
    
    func stopAnimation() {
        if bottomLayer != nil {
            bottomLayer.removeAllAnimations()
        }
        if topLayer != nil {
            topLayer.removeAllAnimations()
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("InfinityHud", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(content)
        setupUI()
        setupShapeLayers()
    }
    
    private func setupUI() {
        centerView.layer.cornerRadius = 10
    }
    
    private func setupShapeLayers() {
        self.layoutIfNeeded()
        
        bottomLayer = createLineShapeLayer(zPos: 1)
        topLayer = createLineShapeLayer(zPos: 0)
        
        centerView.layer.addSublayer(bottomLayer)
        centerView.layer.addSublayer(topLayer)
    }
    
    private func createLineShapeLayer(zPos: CGFloat) -> CAShapeLayer {
        let angleCurve: CGFloat = 10.0
        
        let startPoint: CGPoint = CGPoint(x: angleCurve, y: centerView.frame.width / 2.0);
        let finishPoint: CGPoint = CGPoint(x: centerView.frame.width - angleCurve, y: centerView.frame.width / 2.0);
        
        let dx: CGFloat = angleCurve / 5.0
        let dy: CGFloat = (centerView.frame.width - angleCurve) / 3.0
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: finishPoint, controlPoint1: CGPoint(x: startPoint.x + dx, y: startPoint.y - dy), controlPoint2: CGPoint(x: finishPoint.x - dx, y: finishPoint.y + dy))
        path.addCurve(to: startPoint, controlPoint1: CGPoint(x: finishPoint.x - dx, y: finishPoint.y - dy), controlPoint2: CGPoint(x: startPoint.x + dx, y: startPoint.y + dy))
        
        let layer = CAShapeLayer()
        layer.frame = centerView.bounds
        layer.path = path.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3.0
        layer.zPosition = zPos
        
        return layer
    }

}

extension InfinityHud: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            self.bottomLayer.zPosition = (self.bottomLayer.zPosition == 1) ? 0 : 1
            self.topLayer.zPosition = (self.topLayer.zPosition == 1) ? 0 : 1
            if self.isFirstColor == true {
                self.isFirstColor = false
                self.topLayer.strokeColor = self.colors[1].cgColor
            }
            self.startAnimation()
        } else {
            stopAnimation()
        }
    }
}
