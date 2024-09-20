//
//  ContentView.swift
//  TaskList
//
//  Created by dtidigital on 11/09/2024.
//

import SwiftUI

// Esse aqruivo serve como a interface do usuario da minha aplicacao e ele se comunica com o TaskListViewModel para obter e modificar dados

struct ContentView: View {
    // obtem a data e hora atuais
    let hoje = Date()

    // Cria uma instância de Calendar para manipulação da data
    let calendario = Calendar.current

    // Extrai o dia do mes da data atual
    let diaAtual: Int
    let meses = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    // O uso de @StateObject permite que a View mantenha uma instancia do ViewModel e atualize automaticamente a interface quando os dados "publicados" mudam.
    @StateObject private var viewModel = TaskListViewModel()
    
    //Calcula o dia atual e atribui à variavel
    init() {
            diaAtual = calendario.component(.day, from: hoje)
        }

    var body: some View {
        VStack {
                    Header(diaAtual: diaAtual, meses: meses)
                    Divider().background(Color.blue)
                    Inputs(viewModel: viewModel)//aqui passo a viewModel como parametro pra struct
                    Divider().background(Color.blue)
                    TaskList(viewModel: viewModel)
                    Spacer()
                }
                .padding()
            }
        }

#Preview {
    ContentView()
}

struct Header: View {
    let diaAtual: Int
    let meses: [String]
    
    var body: some View {
        VStack {
            Text("Hoje é dia \(diaAtual) de \(meses[Calendar.current.component(.month, from: Date()) - 1])")
                            .font(.title).bold()
            Text("Cadastre uma Tarefa:")
                            .font(.title2).bold()
        }
    }
}

struct Inputs: View { 
    // Utilizei struct para que utilize o @ObservedObject para acessar o viewModel, pois como variavel nao teria acesso a viewmodel
    @ObservedObject var viewModel: TaskListViewModel
    // recebe o viewModel como parametro e o uso de @ObservedObject é ideal quando você deseja que a view observe mudanças em um objeto que é criado fora dela

    var body: some View {
        VStack {
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
    }
}

struct TaskList: View {
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View{
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

    }
}
