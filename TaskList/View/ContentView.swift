//
//  ContentView.swift
//  TaskList
//
//  Created by dtidigital on 11/09/2024.
//

import SwiftUI

// Esse aqruivo serve como a interface do usuario da minha aplicacao e ele se comunica com o TaskListViewModel para obter e modificar dados

// obtem a data e hora atuais
let hoje = Date()

// Cria uma instância de Calendar para manipulação da data
let calendario = Calendar.current

// Extrai o dia do mes da data atual
let diaAtual = calendario.component(.day, from: hoje)
let meses = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

struct ContentView: View {
    // O uso de @StateObject permite que a View mantenha uma instancia do ViewModel e atualize automaticamente a interface quando os dados "publicados" mudam.
    @StateObject private var viewModel = TaskListViewModel()

    var body: some View {
        VStack {
            VStack {
                Text("Hoje é dia \(diaAtual) de \(meses[calendario.component(.month, from: hoje) - 1])")
                    .font(.title).bold()
                
                Text("Cadastre uma Tarefa:")
                    .font(.title2).bold()
                
                TextField("Digite sua tarefa", text: $viewModel.taskText)
                    .padding()
                    .border(Color.gray, width: 4.5)
                    .cornerRadius(10)
                
                HStack {
                    DatePicker(
                        "Selecione a data",
                        selection: $viewModel.taskDate,
                        displayedComponents: .date
                    )
                    .font(.title)
                    .labelsHidden()
                    .padding()
                    
                    Button(action: {
                        viewModel.adicionarTarefa()
                    }) {
                        Image(systemName: "plus.square.fill")
                            .font(.largeTitle)
                    }
                    .alert(isPresented: $viewModel.mostrarAlerta) {
                        Alert(title: Text("Campo Vazio"),
                              message: Text("Por favor, digite uma tarefa."))
                    }
                    .padding()
                }
            }
            Divider().background(Color.blue)
            
            VStack {
                Text("Suas próximas tarefas:")
                    .font(.title2).bold()
                
                List {
                    ForEach(viewModel.agruparLembretesPorMes(), id: \.key) { mesAno, lembretesDoMes in
                        Section(header: Text(mesAno)) {
                            ForEach(lembretesDoMes, id: \.id) { lembrete in
                                HStack {
                                    Text(lembrete.title)
                                    Spacer()
                                    Text(lembrete.data, style: .date)
                                }
                            }
                            .onDelete(perform: viewModel.deleteLembrete)
                        }
                    }
                }
                .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
