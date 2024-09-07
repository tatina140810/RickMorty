//
//  Model.swift
//  RickMortyProject
//
//  Created by Tatina Dzhakypbekova on 7/9/24.
//

import Foundation

// Модель для основного ответа от API
struct UsersQuery: Decodable {
    let results: [Character]  // Обратите внимание на правильное именование ключа results
}

// Модель персонажа, соответствующая полям id, name, status, image
struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let image: String
}
