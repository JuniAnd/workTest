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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecogn = UITapGestureRecognizer(target: self, action: #selector(createRectangular(recog:)))
        self.view.addGestureRecognizer(tapRecogn)
        let dragRecog = UIPanGestureRecognizer(target: self, action: #selector(createRectangularWithPan))
        self.view.addGestureRecognizer(dragRecog)
    }

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
            print("Shape is smaller then 100x100")
            let alert = UIAlertController(title: "Rectangular is not create", message: "Shape is to small.", preferredStyle:UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func resizeRegtangular (recog: UIPinchGestureRecognizer) {
        print("start resize")
        recog.view?.transform = (recog.view?.transform.scaledBy(x: recog.scale, y: recog.scale))!
        recog.scale = 1.0
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
    
    @objc func moveRectangularToTop (recog: UITapGestureRecognizer) {
        
        guard let view = recog.view else {return}
        self.view.bringSubview(toFront: view)
        self.createSpots(view: view)
        print("go view to top")
    }
    
    func createViewModel () -> UIView {
        let customView = UIView()
        customView.backgroundColor = UIColor.clear
        customView.layer.borderColor = UIColor.black.cgColor
        customView.layer.borderWidth = 1.3
        customView.tag = 2
        return customView
    }
    
    @objc func resizeWithSpots (recog: UIPanGestureRecognizer) {
        
        guard let view = recog.view else {return}
        guard let viewFrame =  view.superview?.frame else {return}
        let touchPoint = recog.location(in: self.view)

        if recog.state == UIGestureRecognizerState.changed {

            switch view.tag {
            case 2: guard viewFrame.maxX - touchPoint.x < 100 || viewFrame.maxY - touchPoint.y < 100 else {
                view.superview?.frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: viewFrame.maxX -  touchPoint.x, height: viewFrame.maxY - touchPoint.y)
                guard let superView = view.superview?.frame else {return}
                self.changePositionOfSpots(position: superView)
                return
                }
            case 3:
            guard touchPoint.x - viewFrame.minX < 100 || viewFrame.maxY - touchPoint.y < 100 else {
                view.superview?.frame = CGRect(x: viewFrame.minX, y: touchPoint.y, width: touchPoint.x - viewFrame.minX, height: viewFrame.maxY - touchPoint.y)
                guard let superView = view.superview?.frame else {return}
                self.changePositionOfSpots(position: superView)
                return
                }
            case 4:
                guard viewFrame.maxX - touchPoint.x < 100 || touchPoint.y - viewFrame.minY < 100 else {
                view.superview?.frame = CGRect(x: touchPoint.x, y: viewFrame.minY, width: viewFrame.maxX -  touchPoint.x, height:touchPoint.y - viewFrame.minY)
                    guard let superView = view.superview?.frame else {return}
                    self.changePositionOfSpots(position: superView)
                    return
                }
            case 5:
                guard touchPoint.x - viewFrame.minX < 100 || touchPoint.y - viewFrame.minY < 100 else {
                    view.superview?.frame = CGRect(x: viewFrame.minX, y: viewFrame.minY, width: touchPoint.x - viewFrame.minX, height:touchPoint.y - viewFrame.minY)
                    guard let superView = view.superview?.frame else {return}
                    self.changePositionOfSpots(position: superView)
                    return
                }
            case 6: guard let superView = view.superview else {return}

            let angle = atan2(superView.center.y - recog.location(in: self.view).y, superView.center.x - recog.location(ofTouch: 0, in: self.view).x)
            superView.transform = CGAffineTransform.init(rotationAngle: angle)
            //self.changePositionOfSpots(position: superView.frame)
            default:
                return
            }
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
        print("delete rectangular")
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

