//
//  GameScene.swift
//  GameTest
//
//  Created by Anderson Santos Gusmão on 30/08/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import SpriteKit
import GameplayKit
import Combine
import ControlGameKit

final class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
	private var joystick = Joystick()
	private var cancellableDpad: AnyCancellable?
	private var cancellableAButton: AnyCancellable?
	private var player = Player()
	private var ground = Ground()

    override func didMove(to view: SKView) {
		physicsWorld.gravity = CGVector(dx: 0, dy: -2)
		addChild(player)
		addChild(ground)
		cancellableDpad = joystick.dpad.onChange.sink(receiveValue: { [weak self] direction in
			guard let self = self else { return }
			switch direction {
			case .left(_, _):
				self.player.moveToLeft()
			case .right(_, _):
				self.player.moveToRight()
			case .center(_, _):
				self.player.stop()
			default:
				break
			}
		})

		cancellableAButton = joystick.buttons.onActionA.sink(receiveValue: { [weak self] action in
			guard let self = self, case .pressed(_, _) = action else { return }
			self.player.jump()

		})
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
