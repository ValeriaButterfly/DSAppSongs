//
//  CreateSongs.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Fluent

struct CreateSongs: Migration {

    // MARK: - Lifecycle
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs")
            .id()
            .field("title", .string, .required)
            .field("genre", .string, .required)
            .field("year", .int, .required)
            .field("timing", .float, .required)
            .field("userID", .uuid, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
}
