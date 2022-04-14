//
//  GameScene.swift
//  HalconAsteroid
//
//  Created by Misael Landero on 16/03/22.
//

import SpriteKit
 

class GameScene: SKScene, SKPhysicsContactDelegate {
     
    var starfiel: SKEmitterNode!
    var player : SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    
    var posibleEnemies = ["asteroid", "r2", "r4"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        starfiel = SKEmitterNode(fileNamed: "starfield")!
        starfiel.position = CGPoint(x: 1024, y: 384)
        starfiel.advanceSimulationTime(10)
        addChild(starfiel)
        starfiel.zPosition = -1
        
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 50)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
      
    @objc func createEnemy(){
        guard let enemy = posibleEnemies.randomElement() else {return}
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
    }
    override func update(_ currentTime: TimeInterval) {
     
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 688
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        gameTimer?.invalidate()
        
       
        
        gameOverLabel = SKLabelNode(fontNamed: "chalkduster")
        gameOverLabel.position = CGPoint(x: 512, y: 512)
        gameOverLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
        
        gameOverLabel.text = "Game Over"
        
    }
}
