//
//  TaskListTests.swift
//  TaskListTests
//
//  Created by dtidigital on 20/09/2024.
//

import XCTest // aqui eu importo o framework de testes
@testable import TaskList // importa o modulo para testar classes e métodos da minha aplicação diretamente

class TaskListViewModelTests: XCTestCase {

    var viewModel: TaskListViewModel!
    // Declaro uma variável opcional que irá armazenar uma instância da TaskListViewModel. O ! faz com que a variável seja inicializada posteriormente, antes de cada teste pelo metodo setUp. Assim eu nao me preocupo se ela estara nula

    override func setUp() {
        super.setUp()
        viewModel = TaskListViewModel() // Inicializa a ViewModel antes de cada teste
    }

    override func tearDown() {
        viewModel = nil // Libera a ViewModel após cada teste
        super.tearDown()
    }
    //setUp e tearDown são métodos predefinidos fornecidos pela classe base XCTestCase. Eles têm esses nomes específicos e são usados para preparar o ambiente de teste antes de cada teste e para limpar após cada teste, respectivamente.
    //deve sobrescrever (override) esses métodos para adicionar minha própria lógica.

    func testAdicionarTarefa() {
        // Configuração inicial
        viewModel.taskText = "Estudar Swift"
        viewModel.taskDate = Date()

        // Ação
        viewModel.adicionarTarefa()

        // Verificação
        XCTAssertEqual(viewModel.lembretes.count, 1)
        XCTAssertEqual(viewModel.lembretes[0].title, "Estudar Swift")
    }

    func testAdicionarTarefaCampoVazio() {
        viewModel.adicionarTarefa()


        XCTAssertTrue(viewModel.mostrarAlerta)
        XCTAssertEqual(viewModel.lembretes.count, 0)
    }

    func testDeleteLembrete() {

        viewModel.taskText = "Estudar Swift"
        viewModel.taskDate = Date()
        viewModel.adicionarTarefa()

        viewModel.taskText = "Praticar Testes"
        viewModel.adicionarTarefa()


        viewModel.deleteLembrete(at: IndexSet(integer: 0))
   
        XCTAssertEqual(viewModel.lembretes.count, 1)
        XCTAssertEqual(viewModel.lembretes[0].title, "Praticar Testes")
    }
}

