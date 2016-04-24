//
//  SPLight.swift
//  SPLight
//
//  Created by hyde on 2016/04/24.
//  Copyright © 2016年 r-plus. All rights reserved.
//

import UIKit

public enum SpotStyle {
    case Rect
    case Oval
}

public class SPLight: UIView {
    // MARK: Class property
    public private(set) static var light: SPLight?
    
    // MARK: Class func
    public class func showInView(view: UIView, spotlightRect: CGRect, style: SpotStyle = .Rect, duration: NSTimeInterval = 0.2) {
        guard light == nil else {
            return
        }
        light = SPLight.init(frame: view.bounds, spotlightRect: spotlightRect, style: style, duration: duration)
        light!.alpha = 0.0
        light!.duration = duration
        view.addSubview(light!)
        UIView.animateWithDuration(duration,
                                   delay: 0,
                                   options: [.CurveEaseOut, .BeginFromCurrentState],
                                   animations: {
                                    light!.alpha = 0.5
            }, completion: nil)
    }
    
    public class func dismiss() {
        guard let light = light else {
            return
        }
        UIView.animateWithDuration(light.duration,
                                   delay: 0,
                                   options: [.CurveEaseOut, .BeginFromCurrentState],
                                   animations: {
                                    light.alpha = 0.0
            }, completion: { (completed: Bool) in
                light.removeFromSuperview()
                self.light = nil
        })
    }
    
    // MARK: Instance property
    public private(set) var spotlightRect: CGRect
    public private(set) var style: SpotStyle
    public private(set) var duration: NSTimeInterval
    
    // MARK: Instance func
    public init(frame: CGRect, spotlightRect: CGRect, style: SpotStyle, duration: NSTimeInterval) {
        self.spotlightRect = spotlightRect
        self.style = style
        self.duration = duration
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        contentMode = .Redraw
        userInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        let bezierPathRect = UIBezierPath.init(rect: rect)
        let spotlightPath: UIBezierPath = {
            switch self.style {
            case .Rect:
                return UIBezierPath.init(rect: CGRectInset(spotlightRect, -5.0, -5.0))
            case .Oval:
                return UIBezierPath.init(ovalInRect: spotlightRect)
            }
        }()
        bezierPathRect.appendPath(spotlightPath)
        bezierPathRect.usesEvenOddFillRule = true
        UIColor.grayColor().setFill()
        bezierPathRect.fill()
        
        // edge blur
        layer.shouldRasterize = true
        layer.rasterizationScale = 0.2
        layer.minificationFilter = kCAFilterTrilinear
        layer.magnificationFilter = kCAFilterTrilinear
        layer.contentsGravity = kCAGravityCenter
    }
    
}