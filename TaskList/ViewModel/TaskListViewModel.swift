//
//  TaskListViewModel.swift
//  TaskList
//
//  Created by dtidigital on 20/09/2024.
//

import Foundation
import SwiftUI

// Esse arquivo possui toda a logica da aplicacao e atua como um intermediario entre a model e a view

class TaskListViewModel: ObservableObject {

    // esses atributos marcados como publicados sao observadas pela view, e assim que mudam, a view se atualiza
    @Published var taskText: String = ""
    @Published var taskDate: Date = Date()
    @Published var lembretes: [Lembrete] = []
    @Published var mostrarAlerta: Bool = false

    // adiciona uma nova tarefa
    func adicionarTarefa() {
        guard !taskText.isEmpty else {
            mostrarAlerta = true
            return
        }
        let novaTarefa = Lembrete(title: taskText, data: taskDate)
        lembretes.append(novaTarefa)
        taskText = "" // Limpa o TextField
    }
    
    // Funcao para deletar um lembrete diretamente arrastando pra esquerda
    func deleteLembrete(at offsets: IndexSet) {
        lembretes.remove(atOffsets: offsets)
    }
    
    // Funcao para agrupar lembretes de um mesmo mes
    func agruparLembretesPorMes() -> [(key: String, value: [Lembrete])] {
        var lembretesAgrupados: [String: [Lembrete]] = [:]

        for lembrete in lembretes {
            let componentesData = Calendar.current.dateComponents([.month, .year], from: lembrete.data)
            let mesAno = "\(meses[componentesData.month! - 1]) \(componentesData.year!)" // Criar chave "Mês de Ano"
            lembretesAgrupados[mesAno, default: []].append(lembrete) // Adiciona o lembrete ao mês correspondente
        }

        // Ordena os lembretes dentro de cada mes-ano
        for mesAno in lembretesAgrupados.keys {
            lembretesAgrupados[mesAno]?.sort(by: { $0.data < $1.data })
        }
        // o ? funciona como um opcional que so tenta ordenar o array caso ele nao seja vazio

        // Ordena o array de meses-ano corretamente
        let lembretesAgrupadosOrdenados = lembretesAgrupados.keys.sorted {
            convertToDate(monthYear: $0) < convertToDate(monthYear: $1)
        }

        return lembretesAgrupadosOrdenados.compactMap { key in
            guard let lembretesDoMes = lembretesAgrupados[key] else { return nil }
            return (key, lembretesDoMes)
        }
        // aqui me retorna um array de tuplas, com a chave sendo string de meses anos, e a lista de lembretes
    }
    
    // Funcao REFATORADA para converter a string "mes ano" em uma data para ordenação
    private func convertToDate(monthYear: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.date(from: monthYear) ?? Date() // em caso de falha retorna a data atual
    }
}
