//
//  User.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Foundation
import Vapor

struct User: Content {

    // MARK: - Public Properties

    let id: UUID
    let name: String
    let username: String

    // MARK: - Initializers

    init(id: UUID, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}
