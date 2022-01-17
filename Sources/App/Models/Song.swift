//
//  Song.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor
import Fluent
import Foundation

final class Song: Model, Content {

    // MARK: - Public Properties

    static let schema = "songs"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "genre")
    var genre: String

    @Field(key: "year")
    var year: Int

    @Field(key: "timing")
    var timing: Float

    @Field(key: "userID")
    var userID: UUID

    // MARK: - Initializers

    init() { }

    init(id: UUID? = nil,
         title: String,
         genre: String,
         year: Int,
         timing: Float,
         userID: UUID) {
        self.id = id
        self.title = title
        self.genre = genre
        self.year = year
        self.timing = timing
        self.userID = userID
    }
}
