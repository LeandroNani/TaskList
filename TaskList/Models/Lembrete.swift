//
//  Lembrete.swift
//  TaskList
//
//  Created by dtidigital on 20/09/2024.
//

import Foundation

// Esse arquivo serve como um modelo pra armazenar os dados que utilizo na minha aplicacao, que no caso sao lembretes
struct Lembrete: Identifiable {
    let id = UUID()
    var title: String
    var data: Date
}
