//
//  SongsController.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor
import Fluent
import Foundation

struct SongData: Content {
    let title: String
    let genre: String
    let year: Int
    let timing: Float
}

// MARK: -

struct SongsController: RouteCollection {

    // MARK: - Lifecycle

    func boot(routes: RoutesBuilder) throws {
        routes.get(use: getAllHandler)
        routes.get(":songID", use: getHandler)
        routes.get("user", ":userID", use: getUsersAcronyms)

        routes.post(":userID", use: createHandler)

        routes.delete(":songID", use: deleteHandler)

        routes.put(":songID", use: updateHandler)
    }

    // MARK: - Public Methods

    func getAllHandler(_ req: Request) -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }

    func getHandler(_ req: Request) -> EventLoopFuture<Song> {
        return Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Song> {
        let data = try req.content.decode(SongData.self)
        let userID = try req.parameters.require("userID", as: UUID.self)
        let song = Song(title: data.title,
                        genre: data.genre,
                        year: data.year,
                        timing: data.timing,
                        userID: userID)
        return song.save(on: req.db).map { song }
    }

    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        return Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .noContent)
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Song> {
        let updateData = try req.content.decode(SongData.self)
        return Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { song in
                song.title = updateData.title
                song.genre = updateData.genre
                song.year = updateData.year
                song.timing = updateData.timing
                return song.save(on: req.db).map { song }
            }
    }

    func getUsersAcronyms(_ req: Request) throws -> EventLoopFuture<[Song]> {
        let userID = try req.parameters.require("userID", as: UUID.self)
        return Song.query(on: req.db).filter(\.$userID == userID).all()
    }
}
