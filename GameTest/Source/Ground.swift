//
//  Ground.swift
//  GameTest
//
//  Created by Anderson Santos Gusmão on 31/08/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import SpriteKit

final class Ground: SKSpriteNode {

	private let objectSize = CGSize(width: 1024, height: 210)

	init() {
		super.init(texture: SKTexture(imageNamed: "Ground"),
				   color: NSColor.clear,
				   size: objectSize)
		position.y -= 300
		physicsBody = SKPhysicsBody(rectangleOf: objectSize)
		physicsBody?.isDynamic = false
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
