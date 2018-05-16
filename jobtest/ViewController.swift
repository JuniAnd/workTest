//
//  ViewController.swift
//  jobtest
//
//  Created by developer on 4/14/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var firstPoint : CGPoint?
    var secondPoint : CGPoint?
    var ghostView = UIView()
    var pointBefor : CGPoint?
    var stepPoint : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecogn = UITapGestureRecognizer(target: self, action: #selector(createRectangular(recog:)))
        self.view.addGestureRecognizer(tapRecogn)
        let dragRecog = UIPanGestureRecognizer(target: self, action: #selector(createRectangularWithPan))
        self.view.addGestureRecognizer(dragRecog)
    }

    //MARK: Create funcs
    
    @objc func createRectangular (recog: UIGestureRecognizer) {
        if firstPoint == nil {
            self.firstPoint = recog.location(ofTouch: 0, in: self.view)
            self.drawCircle(action: true)
        } else if secondPoint == nil {
            self.drawCircle(action: false)
            self.secondPoint = recog.location(ofTouch: 0, in: self.view)
        }
        drawRectangular()
    }
    
    @objc func createRectangularWithPan (recog: UIPanGestureRecognizer) {
        
        if recog.state == UIGestureRecognizerState.began {
            self.firstPoint = recog.location(ofTouch: 0, in: self.view)
            
            self.ghostView.backgroundColor = UIColor.gray
            self.ghostView.alpha = 0.3
            self.ghostView.layer.borderWidth = 2.0
            self.ghostView.layer.borderColor = UIColor.black.cgColor
            
            guard let pnt1 = self.firstPoint else {return}
            self.ghostView.frame = CGRect(x: pnt1.x, y: pnt1.y, width: 1.0, height: 1.0)
            self.view.addSubview(ghostView)
        }
        if recog.state == UIGestureRecognizerState.changed {
            self.secondPoint = recog.location(ofTouch: 0, in: self.view)
            guard let pnt1 = self.firstPoint else {return}
            guard let pnt2 = self.secondPoint else {return}
            
            self.ghostView.frame = CGRect(x: pnt1.x < pnt2.x ? pnt1.x : pnt2.x,
                                          y: pnt1.y < pnt2.y ? pnt1.y : pnt2.y,
                                          width: abs(pnt2.x - pnt1.x),
                                          height: abs(pnt2.y - pnt1.y))
        }
        if recog.state == UIGestureRecognizerState.ended {
            self.ghostView.removeFromSuperview()
            drawRectangular()
        }
    }
    
    func createSpots (view: UIView) {
        
        self.view.viewWithTag(2)?.removeFromSuperview()
        self.view.viewWithTag(3)?.removeFromSuperview()
        self.view.viewWithTag(4)?.removeFromSuperview()
        self.view.viewWithTag(5)?.removeFromSuperview()
        self.view.viewWithTag(6)?.removeFromSuperview()
        
        let leftTop = self.createViewModel()
        leftTop.frame = CGRect(x: 0.0, y: 0.0 , width: 14.0, height: 14.0)
        leftTop.tag = 2
        let resizeLeftTop = UIPanGestureRecognizer(target: self, action: #selector(resizeWithSpots(recog:)))
        leftTop.addGestureRecognizer(resizeLeftTop)
        view.addSubview(leftTop)
        
        let rightTop = self.createViewModel()
        rightTop.frame = CGRect(x: view.frame.width - 14.0, y: 0.0 , width: 14.0, height: 14.0)
        rightTop.tag = 3
        let resizerightTop = UIPanGestureRecognizer(target: self, action: #selector(resizeWithSpots(recog:)))
        rightTop.addGestureRecognizer(resizerightTop)
        view.addSubview(rightTop)
//        print(view.frame)
//        print(rightTop.frame)

        
        let leftBottom = self.createViewModel()
        leftBottom.frame = CGRect(x: 0.0, y: view.frame.height - 14.0 , width: 14.0, height: 14.0)
        leftBottom.tag = 4
        let resizeLeftBottom = UIPanGestureRecognizer(target: self, action: #selector(resizeWithSpots(recog:)))
        leftBottom.addGestureRecognizer(resizeLeftBottom)
        view.addSubview(leftBottom)
        
        let rightBottom = self.createViewModel()
        rightBottom.frame = CGRect(x: view.frame.width - 14.0, y: view.frame.height - 14.0 , width: 14.0, height: 14.0)
        rightBottom.tag = 5
        let resizeRightBottom = UIPanGestureRecognizer(target: self, action: #selector(resizeWithSpots(recog:)))
        rightBottom.addGestureRecognizer(resizeRightBottom)
        view.addSubview(rightBottom)
        
        let middleTop = self.createViewModel()
        middleTop.frame = CGRect(x: view.frame.width / 2 - 7.0, y: 0.0 , width: 14.0, height: 14.0)
        middleTop.tag = 6
        let rotateMiddleTop = UIPanGestureRecognizer(target: self, action: #selector(resizeWithSpots(recog:)))
        middleTop.addGestureRecognizer(rotateMiddleTop)
        view.addSubview(middleTop)
    }
    
    func createViewModel () -> UIView {
        let customView = UIView()
        customView.backgroundColor = UIColor.clear
        customView.layer.borderColor = UIColor.black.cgColor
        customView.layer.borderWidth = 1.3
        customView.tag = 2
        return customView
    }
    
    //MARK: Draw funcs
    
    func drawRectangular () {
        
        guard let fPoint = firstPoint, let sPoint = secondPoint else { return }
        if abs(sPoint.x - fPoint.x) >= 100 && abs(sPoint.y - fPoint.y) >= 100 {
            let newShape = UIView(frame: CGRect(x: fPoint.x < sPoint.x ? fPoint.x : sPoint.x,
                                                y: fPoint.y < sPoint.y ? fPoint.y : sPoint.y,
                                                width: abs(sPoint.x - fPoint.x),
                                                height: abs(sPoint.y - fPoint.y)))
            newShape.backgroundColor = UIColor.red
            newShape.layer.borderColor = UIColor.black.cgColor
            newShape.layer.borderWidth = 3.0
            self.view.addSubview(newShape)
            self.firstPoint = nil
            self.secondPoint = nil
            
            let choiceTapRecog = UITapGestureRecognizer(target: self, action: #selector(moveRectangularToTop(recog:)))
            newShape.addGestureRecognizer(choiceTapRecog)
            let removeRecog = UIPanGestureRecognizer(target: self, action: #selector(moveRectangular(recog:)))
            newShape.addGestureRecognizer(removeRecog)
            let rotationRecog = UIRotationGestureRecognizer(target: self, action: #selector(rotationRectangular(recog:)))
            newShape.addGestureRecognizer(rotationRecog)
            let deleteRecog = UITapGestureRecognizer(target: self, action: #selector(deleteRectangular(recog:)))
            deleteRecog.numberOfTapsRequired = 2
            newShape.addGestureRecognizer(deleteRecog)
            let changeColorRecog = UILongPressGestureRecognizer(target: self, action: #selector(changeColorRectangular(recog:)))
            newShape.addGestureRecognizer(changeColorRecog)
            let resizeRecog = UIPinchGestureRecognizer(target: self, action: #selector(resizeRegtangular(recog:)))
            newShape.addGestureRecognizer(resizeRecog)
        } else {
            self.firstPoint = nil
            self.secondPoint = nil
            let alert = UIAlertController(title: "Rectangular is not create", message: "Shape is to small.", preferredStyle:UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func drawCircle (action: Bool) {
        guard let point = self.firstPoint else {return}
        if action {
            let firstTouchCircle = UIView()
            firstTouchCircle.layer.backgroundColor = UIColor.clear.cgColor
            firstTouchCircle.layer.borderColor = UIColor.black.cgColor
            firstTouchCircle.layer.borderWidth = 1.7
            firstTouchCircle.layer.cornerRadius = 7.0
            firstTouchCircle.tag = 1
            firstTouchCircle.frame = CGRect(x: point.x - 7.0, y: point.y - 7.0, width: 14.0, height: 14.0)
            self.view.addSubview(firstTouchCircle)
        } else {
            if let viewWithTag = self.view.viewWithTag(1) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    //MARK: Action funcs with Rectangular
    
    @objc func resizeRegtangular (recog: UIPinchGestureRecognizer) {
        guard let view = recog.view else { return }
        view.transform = view.transform.scaledBy(x: recog.scale, y: recog.scale)
        recog.scale = 1.0
        changePositionOfSpots(position: view.frame)
    }
    
    @objc func moveRectangularToTop (recog: UITapGestureRecognizer) {
        
        guard let view = recog.view else {return}
        self.view.bringSubview(toFront: view)
        if atan2(Double(view.transform.b), Double(view.transform.a)) == 0 {
            self.createSpots(view: view)
        } else {
            let angle = atan2(CGFloat(view.transform.b), CGFloat(view.transform.a))
            view.transform = CGAffineTransform.init(rotationAngle: 0.0)
            self.createSpots(view: view)
            view.transform = CGAffineTransform.init(rotationAngle: angle)
        }
    }
    
    
    @objc func resizeWithSpots (recog: UIPanGestureRecognizer) {
        
        guard let view = recog.view else {return}
        guard let viewFrame =  view.superview?.frame else {return}
        let touchPoint = recog.location(in: self.view)

        if recog.state == UIGestureRecognizerState.began {
            self.stepPoint = recog.location(in: self.view)
        }
        
        if recog.state == UIGestureRecognizerState.changed {

            switch view.tag {
            case 2: if atan2(Double((view.superview?.transform.b)!), Double((view.superview?.transform.a)!)) == 0 {
                    guard viewFrame.maxX - touchPoint.x < 100 || viewFrame.maxY - touchPoint.y < 100 else {
                        view.superview?.frame = CGRect(x: touchPoint.x, y: touchPoint.y,
                                               width: viewFrame.maxX -  touchPoint.x,
                                               height: viewFrame.maxY - touchPoint.y)
                    guard let superView = view.superview?.frame else {return}
                    self.changePositionOfSpots(position: superView)
                    return
                    }
                } else {
                guard let superView = view.superview else {return}
                changeSizeWithRotation(touch: touchPoint, rectangular: superView, viewTag: view.tag)
                }
            case 3: if atan2(Double((view.superview?.transform.b)!), Double((view.superview?.transform.a)!)) == 0 {
            guard touchPoint.x - viewFrame.minX < 100 || viewFrame.maxY - touchPoint.y < 100 else {
                    view.superview?.frame = CGRect(x: viewFrame.minX, y: touchPoint.y,
                                                   width: touchPoint.x - viewFrame.minX,
                                                   height: viewFrame.maxY - touchPoint.y)
                guard let superView = view.superview?.frame else {return}
                self.changePositionOfSpots(position: superView)
                return
                }} else {
                guard let superView = view.superview else {return}
                changeSizeWithRotation(touch: touchPoint, rectangular: superView, viewTag: view.tag)
                }
            case 4: if atan2(Double((view.superview?.transform.b)!), Double((view.superview?.transform.a)!)) == 0 {
                guard viewFrame.maxX - touchPoint.x < 100 || touchPoint.y - viewFrame.minY < 100 else {
                    view.superview?.frame = CGRect(x: touchPoint.x, y: viewFrame.minY,
                                                   width: viewFrame.maxX -  touchPoint.x,
                                                   height:touchPoint.y - viewFrame.minY)
                    guard let superView = view.superview?.frame else {return}
                    self.changePositionOfSpots(position: superView)
                    return
                    
                }} else {
                guard let superView = view.superview else {return}
                changeSizeWithRotation(touch: touchPoint, rectangular: superView, viewTag: view.tag)
                }
            case 5: if atan2(Double((view.superview?.transform.b)!), Double((view.superview?.transform.a)!)) == 0 {
                guard touchPoint.x - viewFrame.minX < 100 || touchPoint.y - viewFrame.minY < 100 else {
                    view.superview?.frame = CGRect(x: viewFrame.minX, y: viewFrame.minY,
                                                   width: touchPoint.x - viewFrame.minX,
                                                   height:touchPoint.y - viewFrame.minY)
                    guard let superView = view.superview?.frame else {return}
                    self.changePositionOfSpots(position: superView)
                    return
                }} else {
                guard let superView = view.superview else {return}
                changeSizeWithRotation(touch: touchPoint, rectangular: superView, viewTag: view.tag)
                }
            case 6: guard let superView = view.superview else {return}
            let angle = atan2(superView.center.y - recog.location(in: self.view).y,
                              superView.center.x - recog.location(in: self.view).x)
            superView.transform = CGAffineTransform.init(rotationAngle: angle)

            default:
                return
            }
            self.stepPoint = recog.location(in: self.view)
        }
    }
    
    func changeSizeWithRotation (touch: CGPoint, rectangular: UIView, viewTag: Int) {
        var tag = viewTag


        if touch.x <= rectangular.center.x && touch.y <= rectangular.center.y {
            tag = 2
        }
        if touch.x >= rectangular.center.x && touch.y <= rectangular.center.y {
            tag = 3
        }
        if touch.x < rectangular.center.x && touch.y > rectangular.center.y {
            tag = 4
        }
        if touch.x > rectangular.center.x && touch.y > rectangular.center.y {
            tag = 5
        }
        
        let angleView = atan2(CGFloat(rectangular.transform.b), CGFloat(rectangular.transform.a))
        rectangular.transform = CGAffineTransform(rotationAngle: 0.0)

        switch tag {
        case 2: guard rectangular.frame.maxX - touch.x < 100 || rectangular.frame.maxY - touch.y < 100 else {
            guard let point = self.stepPoint else {return}
            let step = CGPoint(x: point.x - touch.x, y: point.y - touch.y)

            rectangular.frame = CGRect(x: touch.x, y : touch.y,
                                       width: rectangular.frame.width + step.x,
                                       height: rectangular.frame.height + step.y)

            changePositionOfSpots(position: rectangular.frame)
            rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            rectangular.center = CGPoint(x: rectangular.center.x - (touch.x - rectangular.frame.origin.x), y: rectangular.center.y + (touch.y - rectangular.frame.minY))
            return
            }
        changePositionOfSpots(position: rectangular.frame)
        rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)

        case 3: guard touch.x - rectangular.frame.minX < 100 || rectangular.frame.maxY - touch.y < 100 else {
            guard let point = self.stepPoint else {return}
            let step = CGPoint(x: point.x - touch.x, y: point.y - touch.y)

            rectangular.frame = CGRect(x: rectangular.frame.minX, y: touch.y,
                                       width: rectangular.frame.width - step.x,
                                       height: rectangular.frame.height + step.y)

            changePositionOfSpots(position: rectangular.frame)
            rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            return
        }
        changePositionOfSpots(position: rectangular.frame)
        rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            
        case 4: guard rectangular.frame.maxX - touch.x < 100 || touch.y - rectangular.frame.minY < 100 else {
            guard let point = self.stepPoint else {return}
            let step = CGPoint(x: point.x - touch.x, y: point.y - touch.y)
            
            rectangular.frame = CGRect(x: touch.x, y: rectangular.frame.minY,
                                       width: rectangular.frame.width + step.x,
                                       height: rectangular.frame.height - step.y)
            
            changePositionOfSpots(position: rectangular.frame)
            rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            return
        }
        changePositionOfSpots(position: rectangular.frame)
        rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            
        case 5: guard touch.x - rectangular.frame.minX < 100 || touch.y - rectangular.frame.minY < 100 else {
            guard let point = self.stepPoint else {return}
            let step = CGPoint(x: point.x - touch.x, y: point.y - touch.y)

            rectangular.frame = CGRect(x: rectangular.frame.minX, y: rectangular.frame.minY,
                                       width: rectangular.frame.width - step.x,
                                       height:rectangular.frame.height - step.y)

            changePositionOfSpots(position: rectangular.frame)
            rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            return
        }
        changePositionOfSpots(position: rectangular.frame)
        rectangular.transform = CGAffineTransform.init(rotationAngle: angleView)
            
        default:
            return
        }
  }
    
    func changePositionOfSpots (position: CGRect) {
        self.view.viewWithTag(2)?.frame = CGRect(x: 0.0, y: 0.0 , width: 14.0, height: 14.0)
        self.view.viewWithTag(3)?.frame = CGRect(x: position.width - 14.0, y: 0.0 , width: 14.0, height: 14.0)
        self.view.viewWithTag(4)?.frame = CGRect(x: 0.0, y: position.height - 14.0 , width: 14.0, height: 14.0)
        self.view.viewWithTag(5)?.frame = CGRect(x: position.width - 14.0, y: position.height - 14.0, width: 14.0, height: 14.0)
        self.view.viewWithTag(6)?.frame = CGRect(x: position.width / 2 - 7.0, y: 0.0 , width: 14.0, height: 14.0)
    }
    
    @objc func changeColorRectangular (recog: UIGestureRecognizer) {
        guard let view = recog.view else {return}
        if recog.state == UIGestureRecognizerState.began {
           view.backgroundColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max), green: CGFloat(arc4random()) / CGFloat(UInt32.max), blue: CGFloat(arc4random()) / CGFloat(UInt32.max), alpha: 1.0)
        }
    }
    
    @objc func deleteRectangular (recog: UITapGestureRecognizer) {
        guard let view = recog.view else {return}
        view.removeFromSuperview()
    }
    
    @objc func rotationRectangular (recog: UIRotationGestureRecognizer) {
        guard let view = recog.view else {return}
        view.transform = view.transform.rotated(by: recog.rotation)
        recog.rotation = 0
    }
    
    @objc func moveRectangular (recog: UIPanGestureRecognizer) {
        guard let view = recog.view else {return}
        self.view.bringSubview(toFront: view)
        
        if recog.state == UIGestureRecognizerState.changed {
            view.center = CGPoint(x: recog.location(in: self.view).x, y: recog.location(in: self.view).y)
        }
    }
    
}

