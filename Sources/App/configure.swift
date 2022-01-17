//
//  configure.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) throws {
    let port: Int
    if let environmentPort = Environment.get("PORT") {
        port = Int(environmentPort) ?? 8082
    } else {
        port = 8082
    }
    app.http.server.configuration.port = port

    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tlsConfiguration: .forClient(certificateVerification: .none)
    ), as: .mysql)

    app.migrations.add(CreateSongs())

    // register routes
    try routes(app)

    try app.autoMigrate().wait()
}
