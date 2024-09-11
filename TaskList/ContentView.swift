//
//  ContentView.swift
//  TaskList
//
//  Created by dtidigital on 11/09/2024.
//

import SwiftUI
import Foundation


// Obtém a data e hora atuais
let hoje = Date()

// Cria uma instância de Calendar para manipulação da data
let calendario = Calendar.current

// Extrai o dia do mês da data atual
let diaAtual = calendario.component(.day, from: hoje)
let meses = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"]
let mesAtual = meses[calendario.component(.month, from:hoje) - 1]

struct Lembrete {
    var title : String
    var data : Date
}



struct ContentView: View {
    // Ao utilizar o State o SwiftUI vai armazenar os valores que estou guardando aqui (O titulo da tarefa do usuário e a data dela) e quando esses valores mudarem o SwiftUI vai saber que precisa renderizar novamente a View.
    // Ao utilizar o $ nas variáveis, criamos uma variável do tipo Bindings para as variáveis States, isso cria uma conexão bidirecional, fornecendo uma maneira de ler e escrever em tempo real o valor original da variável de estado.
    // O private indica que essas variáveis so podem ser acessadas dentro da minha ContentView, é idicado usar para clareza do código.
    @State private var taskText = ""
    @State private var taskDate = Date()
    @State private var isEditing = false
    @State private var lembretes: [Lembrete] = []

    var body: some View {
        VStack {
            VStack{
                Text("Hoje é dia \(diaAtual) de \(mesAtual)")
                    .font(.title).bold()
                
                TextField("Digite sua tarefa", text: $taskText, onEditingChanged: {
                    editing in self.isEditing = editing
                })
                .padding()
                .border(isEditing ? Color.blue : Color.gray, width: 4.5)
                .cornerRadius(10)
                
                HStack{
                    DatePicker(
                        "Selecione a data", // Texto descritivo para acessibilidade
                        selection: $taskDate,
                        displayedComponents: .date
                    )
                    .font(.title)
                    .labelsHidden() // Oculta o texto descritivo
                    .padding()
                    
                    Button(action: {
                        let novaTarefa = Lembrete(title:taskText, data:taskDate )
                        lembretes.append(novaTarefa)
                        
                    }) {
                        Image(systemName: "plus.square.fill")
                            .font(.largeTitle)
                    }
                    .padding()
                }
            }
            Divider().background(Color.blue)
            
            VStack{
                Text("Seus próximos lembretes:")
                    .font(.title2).bold()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
