//
//  GameScene.swift
//  SpriteRadar
//
//  Created by Kimberly on 3/18/18.
//  Copyright © 2018 Kimberly. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let radarColor = SKColor(red: 0/255.0, green: 60/255.0, blue: 4/255.0, alpha: 1.0)
    let contourColor = SKColor(red: 168/255.0, green: 248/255.0, blue: 46/255.0, alpha: 1.0)
    var handNode = SKSpriteNode()
    var targetPoints = [CGPoint]()
    var canRunRadar = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = radarColor
        
        //let buttonSize = CGSize(width: 100.0, height: 32.0)
        //let buttonRect = CGRect(x: (320 - buttonSize.width)/2.0, y: 400.0, width: buttonSize.width, height: buttonSize.height)
        //let buttonShapeNode = SKShapeNode.init(rect: buttonRect, cornerRadius: 8.0)
        //buttonShapeNode.strokeColor = SKColor.black
        //buttonShapeNode.fillColor = SKColor.white
        
        //let buttonSize = CGSize(width: 100.0, height: 32.0)
        //let buttonNode = SKSpriteNode(color: SKColor.clear, size: buttonSize)
        //buttonNode.position = CGPoint(x: (320 - buttonSize.width)/2.0, y: 400.0)
        
        if let sceneSize = self.scene?.size {
            let path = UIBezierPath()
            let size: CGFloat = 32.0
            /* vertical lines */
            let maxWidth = Int(ceil(sceneSize.width/size))
            for i in 0..<maxWidth {
                path.move(to: CGPoint(x: CGFloat(i) * size, y: 0.0))
                path.addLine(to: CGPoint(x: CGFloat(i) * size, y: sceneSize.height))
                path.move(to: CGPoint(x: CGFloat(i) * -size, y: 0.0))
                path.addLine(to: CGPoint(x: CGFloat(i) * -size, y: sceneSize.height))
                
                path.move(to: CGPoint(x: CGFloat(i) * size, y: 0.0))
                path.addLine(to: CGPoint(x: CGFloat(i) * size, y: -sceneSize.height))
                path.move(to: CGPoint(x: CGFloat(i) * -size, y: 0.0))
                path.addLine(to: CGPoint(x: CGFloat(i) * -size, y: -sceneSize.height))
            }
            /* horizontal lines */
            let maxHeight = Int(ceil(sceneSize.height/size))
            for i in 0..<maxHeight {
                path.move(to: CGPoint(x: 0.0, y: CGFloat(i) * size))
                path.addLine(to: CGPoint(x: sceneSize.width, y: CGFloat(i) * size))
                path.move(to: CGPoint(x: 0.0, y: CGFloat(i) * -size))
                path.addLine(to: CGPoint(x: sceneSize.width, y: CGFloat(i) * -size))
                
                path.move(to: CGPoint(x: 0.0, y: CGFloat(i) * size))
                path.addLine(to: CGPoint(x: -sceneSize.width, y: CGFloat(i) * size))
                path.move(to: CGPoint(x: 0.0, y: CGFloat(i) * -size))
                path.addLine(to: CGPoint(x: -sceneSize.width, y: CGFloat(i) * -size))
            }
            let lineShapeNode = SKShapeNode()
            lineShapeNode.path = path.cgPath
            lineShapeNode.strokeColor = SKColor.green.withAlphaComponent(0.2)
            self.addChild(lineShapeNode)
            
            
            let buttonSize = CGSize(width: 180.0, height: 48.0)
            let buttonPoint = CGPoint(x: -buttonSize.width/2.0, y: -sceneSize.height/2.0 + buttonSize.height)
            let buttonRect = CGRect(origin: buttonPoint, size: buttonSize)
            let shapeNode = SKShapeNode(rect: buttonRect, cornerRadius: 10)
            shapeNode.zPosition = 40
            shapeNode.fillColor = SKColor.white
            shapeNode.strokeColor = SKColor.blue
            shapeNode.lineWidth = 3.0
            self.addChild(shapeNode)
            
            let labelNode = SKLabelNode(fontNamed: "Helvetica")
            labelNode.text = "Close"
            labelNode.fontSize = 32.0
            labelNode.position = CGPoint(x: 0, y: buttonPoint.y + 12.0)
            labelNode.fontColor = SKColor.black
            shapeNode.addChild(labelNode)
        }
        
        
        // targets //
        targetPoints = [CGPoint(x: 100.0, y: 100.0), CGPoint(x: 46.0, y: 80.0), CGPoint(x: -88.0, y: 180.0), CGPoint(x: -140.0, y: -140.0)]
        
        if let selfBounds = self.view?.bounds {
            let radius = selfBounds.size.width/2.0
            
            // 3 circles //
            let circle0 = SKShapeNode(circleOfRadius: radius)
            circle0.fillColor = SKColor.clear
            circle0.lineWidth = 2.0
            circle0.strokeColor = contourColor
            circle0.position = CGPoint.zero
            circle0.name = "Circle"
            self.addChild(circle0)
            
            let circle1 = SKShapeNode(circleOfRadius: selfBounds.size.width/6.0 * 2.0)
            circle1.fillColor = SKColor.clear
            circle1.lineWidth = 2.0
            circle1.strokeColor = contourColor
            circle1.position = CGPoint.zero
            self.addChild(circle1)
            
            let circle2 = SKShapeNode(circleOfRadius: selfBounds.size.width/6.0 * 1.0)
            circle2.fillColor = SKColor.clear
            circle2.lineWidth = 2.0
            circle2.strokeColor = contourColor
            circle2.position = CGPoint.zero
            self.addChild(circle2)
            
            // hand //
            handNode = SKSpriteNode(color: contourColor, size: CGSize(width: 5.0, height: radius))
            handNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            handNode.zPosition = 31
            handNode.name = "Hand"
            circle0.addChild(handNode)
            
            // running radar //
            canRunRadar = true
        }
    }
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if canRunRadar {
            handNode.zRotation -= 0.03
            let fadeNode = SKSpriteNode(color: contourColor, size: handNode.size)
            fadeNode.position = handNode.position
            fadeNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            fadeNode.zPosition = 31
            fadeNode.zRotation = handNode.zRotation
            handNode.parent?.addChild(fadeNode)
            fadeNode.run(SKAction.fadeOut(withDuration: 1.0)) {
                fadeNode.removeFromParent()
            }
            for target in targetPoints {
                if handNode.contains(target) {
                    if let circleNode = self.childNode(withName: "Circle") {
                        let mark = SKShapeNode(circleOfRadius: 4.0)
                        mark.fillColor = SKColor.red
                        mark.strokeColor = SKColor.red
                        mark.lineWidth = 0.1
                        mark.position = CGPoint(x: target.x - 2.0, y: target.y - 2.0)
                        mark.zPosition = 30
                        mark.alpha = 0.0
                        circleNode.addChild(mark)
                        mark.run(SKAction.fadeIn(withDuration: 0.5), completion: {
                            mark.run(SKAction.fadeOut(withDuration: 2.0)) {
                                mark.removeFromParent()
                            }
                        })
                    }
                }
            }
        }
    }
}

