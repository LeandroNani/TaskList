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
let meses = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let mesAtual = meses[calendario.component(.month, from:hoje) - 1]

struct Lembrete {
    let id = UUID()
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
    @State private var mostrarAlerta = false

    var body: some View {
        VStack {
            VStack{
                Text("Hoje é dia \(diaAtual) de \(mesAtual)")
                    .font(.title).bold()
                
                Text("Cadastre uma Tarefa:")
                    .font(.title2).bold()
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
                        if taskText != "" {
                            let novaTarefa = Lembrete(title:taskText, data:taskDate )
                            lembretes.append(novaTarefa)
                            
                            // Limpa o TextField
                            taskText = ""
                        } else {
                            // exibir um alerta para preencher a tarefa
                            mostrarAlerta = true
                        }
                        
                    }) {
                        Image(systemName: "plus.square.fill")
                            .font(.largeTitle)
                    }.alert(isPresented: $mostrarAlerta) {
                        Alert(title: Text("Campo Vazio"),
                              message: Text("Por favor, digite uma tarefa."))
                    }
                    .padding()
                }
            }
            Divider().background(Color.blue)
            
            VStack{
                Text("Suas próximas tarefas:")
                    .font(.title2).bold()
                
                List {
                    ForEach(agruparLembretesPorMes(lembretes: lembretes).sorted(by: { $0.key < $1.key }), id: \.key) { mesAno, lembretesDoMes in
                        Section(header: Text(mesAno)) {
                            ForEach(lembretesDoMes, id: \.title) { lembrete in
                                HStack {
                                    Text(lembrete.title)
                                    Spacer()
                                    Text(lembrete.data, style: .date)
                                }
                            }
                            .onDelete(perform: deleteLembrete)
                        }
                    }
                }.cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func deleteLembrete(at offsets: IndexSet) {
        // Iterar sobre os offsets para remover os lembretes correspondentes
        for offset in offsets {
            // Encontrar o lembrete a ser excluído com base no seu ID
            if let lembreteIndex = lembretes.firstIndex(where: { $0.id == lembretes[offset].id }) {
                // Remover o lembrete encontrado do array lembretes
                lembretes.remove(at: lembreteIndex)
            }
        }
    }
}

#Preview {
    ContentView()
}

func agruparLembretesPorMes(lembretes: [Lembrete]) -> [String: [Lembrete]] {
    var lembretesAgrupados: [String: [Lembrete]] = [:]

    for lembrete in lembretes {
        let componentesData = Calendar.current.dateComponents([.month, .year], from: lembrete.data)
        let mesAno = "\(meses[componentesData.month! - 1]) \(componentesData.year!)" // Criar chave "Mês de Ano"

        if var lembretesDoMes = lembretesAgrupados[mesAno] {
            lembretesDoMes.append(lembrete)
            lembretesDoMes.sort(by: { $0.data < $1.data }) // aqui eu ordeno os lembretes dentro daqueles meses/anos
            lembretesAgrupados[mesAno] = lembretesDoMes
        } else {
            lembretesAgrupados[mesAno] = [lembrete]
        }
    }
    
    //aqui eu ordeno os arrays de meses/ano
    //utilizei o metodo do Dictionary para converter um valor de tuplas de volta para um dicionario
    let lembretesAgrupadosOrdenados = Dictionary(uniqueKeysWithValues: lembretesAgrupados.sorted { (mesAno1, mesAno2) -> Bool in
        
        let date1 = (convert(mesAno1.key, from: "MMMM yyyy", to: "MM-yyyy"))
        let date2 = (convert(mesAno2.key, from: "MMMM yyyy", to: "MM-yyyy"))
        
        
           return date1! < date2!
       })
        return lembretesAgrupadosOrdenados
}

//funcao do stackoverflow para converter string em data
func convert(_ dateString: String, from initialFormat: String, to targetFormat: String? = nil, _ locale: Locale? = nil) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = initialFormat
    guard let date = formatter.date(from: dateString) else { return nil }
    
    if let newFormat = targetFormat {
        formatter.dateFormat = targetFormat
    }
    formatter.locale = locale
    return formatter.string(from: date)
}
