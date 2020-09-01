//
//  Player.swift
//  GameTest
//
//  Created by Anderson Santos Gusmão on 31/08/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import SpriteKit

final class Player: SKSpriteNode {

	typealias CompletionHandler = () -> Void
	private class AnimationBlock {
		var atlas: SKTextureAtlas
		var textures = [SKTexture]()
		var action = SKAction()

		init(atlasName: String) {
			atlas = SKTextureAtlas(named: "\(atlasName).spriteatlas")
		}
	}

	private var idleAnimationBlock = AnimationBlock(atlasName: "player-idle")
	private var runAnimationBlock = AnimationBlock(atlasName: "player-run")
	private var jumpAnimationBlock = AnimationBlock(atlasName: "player-jump")
	private var walkAnimationBlock = AnimationBlock(atlasName: "player-walk")
	private var deadAnimationBlock = AnimationBlock(atlasName: "player-dead")
	private let playerSize = CGSize(width: 416, height: 454)
	private var xMovementAction = SKAction()
	private var isMovingOnAxisX = false

	init() {
		guard let firstIdleTexture = idleAnimationBlock.atlas.textureNames.first else { fatalError() }
		super.init(texture:  SKTexture(imageNamed: firstIdleTexture),
				   color: NSColor.clear,
				   size: playerSize)
		loadAnimationBlocks([idleAnimationBlock,
							 runAnimationBlock,
							 walkAnimationBlock,
							 jumpAnimationBlock,
							 deadAnimationBlock])
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func moveToLeft() {
		isMovingOnAxisX = true
		changeDirection(isMovingRight: false)
		setAnimation(walkAnimationBlock.action)
		xMovementAction = SKAction.moveTo(x: -400, duration: calculateSpeed(isMovingRight: false))
		run(xMovementAction, withKey: "xMovementAction")
	}

	func moveToRight() {
		isMovingOnAxisX = true
		changeDirection()
		setAnimation(walkAnimationBlock.action)
		xMovementAction = SKAction.moveTo(x: 400, duration: calculateSpeed())
		run(xMovementAction, withKey: "xMovementAction")
	}

	func stop() {
		isMovingOnAxisX = false
		setAnimation(idleAnimationBlock.action)
		removeAction(forKey: "xMovementAction")
	}

	func jump() {
		setAnimation(jumpAnimationBlock.action, isForever: false) { [weak self] in
			guard let self = self else { return }
			let action = self.isMovingOnAxisX ? self.walkAnimationBlock.action : self.idleAnimationBlock.action
			self.setAnimation(action)
		}

		physicsBody?.velocity = CGVector(dx: 0, dy: 0)
		physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600))
	}

	private func setup() {
		physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2.75)
		physicsBody?.isDynamic = true
		setScale(0.3)
		stop()
	}

	private func calculateSpeed(isMovingRight: Bool = true) -> TimeInterval {
		let distance = isMovingRight ? CGFloat(400 - position.x) : CGFloat(-400) - position.x
		let absoluteDistance = abs(distance)
		return TimeInterval(absoluteDistance / CGFloat(200))
	}

	private func changeDirection(isMovingRight: Bool = true) {
		guard isMovingRight && xScale < 0 || !isMovingRight && xScale > 0 else { return }
		xScale *= -1
	}

	private func setAnimation(_ animation: SKAction, isForever: Bool = true, completion: CompletionHandler? = nil) {
		removeAction(forKey: "stateAnimate")
		let action = isForever ? SKAction.repeatForever(animation) : animation
		if let completion = completion {
			run(action, completion: completion)
		} else {
			run(action, withKey: "stateAnimate")
		}
	}

	private func loadAnimationBlocks(_ blocks: [AnimationBlock]) {
		blocks.forEach { block in
			block.textures = block.atlas.textureNames.sorted().map { SKTexture(imageNamed: $0) }
			block.action = SKAction.animate(with: block.textures,
														 timePerFrame: 0.04,
														 resize: true,
														 restore: false)
		}
	}
}
