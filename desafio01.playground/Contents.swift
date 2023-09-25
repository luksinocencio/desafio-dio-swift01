import Foundation

class Animal {
    var nome: String
    private var idade: Int = 2
    
    init(nome: String) {
        self.nome = nome
    }
    
    func som() {}
    
    func meuNome() {
        print("meu nome é \(nome)")
        minhaIdade()
    }
    
    
    /// ENCAPSULAMENTO
    private func minhaIdade() {
        print("meu nome é \(nome)")
    }
}

/// Herança
class Gato: Animal {
    // Polimorfismo
    override func som() {
        print("miau!")
    }
}

class Cachorro: Animal {
    override func som() {
        print("auau!")
    }
}


let animal = Animal(nome: "Sem nome")
let gato = Gato(nome: "Xanin")
let cachorro = Cachorro(nome: "Toto")

// print(animal.minhaIdade()) -> não será permitido
print(animal.meuNome())
print(gato.meuNome())
print(cachorro.meuNome())
