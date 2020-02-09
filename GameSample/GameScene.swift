//
//  GameScene.swift
//  GameSample
//
//  Created by rogerio on 01/02/20.
//  Copyright © 2020 rogerio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private let constSize:CGFloat = 50.0
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var labelBy : SKLabelNode?
    private var sliderButton : SKShapeNode?
    private var sliderButtonSize: CGFloat?
    private var initialPosition: CGFloat?
    private var nameTop: CGFloat?
    private var xPosBegin: CGFloat = 0.0
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//simpleFractal") as? SKLabelNode
        self.labelBy = self.childNode(withName: "//by") as? SKLabelNode
        
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        if let by = self.labelBy {
            by.alpha = 0.0
            by.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            nameTop = by.position.y + (by.attributedText?.size().height ?? 0)
        }
        
        sliderButtonSize = (self.size.width + self.size.height) * 0.05
        self.sliderButton = SKShapeNode.init(rectOf: CGSize.init(width: sliderButtonSize!, height: sliderButtonSize!), cornerRadius: sliderButtonSize! * 0.3)
        
        if let slider = self.sliderButton {
            initialPosition = -(self.size.width/2)+sliderButtonSize!
            slider.position = CGPoint(x: initialPosition!, y: sliderButtonSize! + (nameTop ?? 0))
            slider.fillColor = .white
            self.addChild(slider)
        }
        //        if let spinnyNode = self.spinnyNode {
        //            spinnyNode.lineWidth = 2.5
        //
        ////            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        ////            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
        ////                                              SKAction.fadeOut(withDuration: 0.5),
        ////                                              SKAction.removeFromParent()]))
        //
        //            spinnyNode.strokeColor = SKColor.green
        //            self.addChild(spinnyNode)
        //        }
       // fractal(size: constSize)
    }
    
    func fractal(x: CGFloat, y: CGFloat, w: CGFloat) {
        for child in self.children {
            if child is SKShapeNode && child != self.sliderButton {
                child.removeFromParent()
            }
        }
        recursiveFractal(x: x, y: y, w: w)
    }
    
    func recursiveFractal(x: CGFloat, y: CGFloat, w: CGFloat) {
        var fr = w
        while(fr>2) {
            let fractalSize = fr
            self.drawCube(x:x, y:y, w: fractalSize)
            var tr = fractalSize/2
            while (tr > 2 ) {
                self.drawCube(x:x-tr, y:y-tr, w: tr)
                self.drawCube(x:x+tr, y:y-tr, w: tr)
                self.drawCube(x:x-tr, y:y+tr, w: tr)
                self.drawCube(x:x+tr, y:y+tr, w: tr)
                tr /= 2
            }
            fr /= 2
        }
        
    }
    
    func drawCube(x: CGFloat, y: CGFloat, w: CGFloat) {
        let pos: CGPoint = CGPoint(x: x, y: y)
        drawCube(pos: pos, w: w)
    }
    
    func drawCube(pos: CGPoint, w: CGFloat) {
        let square = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: 1)
        square.position = pos
        square.lineWidth = 2.5
        square.strokeColor = SKColor.green
        self.addChild(square)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let touchNodes = nodes(at: pos)
        for node in touchNodes {
            if node == self.sliderButton {
                xPosBegin = pos.x
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let touchNodes = nodes(at: pos)
        for node in touchNodes {
            if node == self.sliderButton {
                if let slider = self.sliderButton {
                    var calc = pos.x
                    calc = calc > self.size.width/2 ? (self.size.width/2 - sliderButtonSize!): calc
                    calc = calc <= -(self.size.width/2) ? -(self.size.width/2 - sliderButtonSize!): calc
                    slider.position = CGPoint(x: calc, y: slider.position.y)
                    let newSize = ((calc - initialPosition!)/sliderButtonSize!) * constSize
                    fractal(x:0, y:0 ,w: newSize)
                }
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.red
        //            self.addChild(n)
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
