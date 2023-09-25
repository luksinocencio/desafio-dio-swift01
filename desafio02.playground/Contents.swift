import UIKit

var numeros = [2, 1, 5, 6, 8, 7, 9, 0, 3, 4]
var numerosPares = [Int]()

for numero in numeros {
    if numero % 2 == 0 {
        numerosPares.append(numero)
    }
}

var numerosPares01 = numeros.filter({ (valor) in valor % 2 == 0 })

print(numerosPares)
print(numerosPares01)

enum TipoVeiculo {
    case carro
    case moto
    case caminhao
    case aviao
    case barco
}

struct Veiculo {
    var tipo: TipoVeiculo
    var marca: String
    var preco: Double
    
    func meusDados() -> String {
        return """
            Tipo: \(tipo)
            Marca: \(marca)
            Preco: \(String().toCurrency(Amount: preco as NSNumber))
        """
    }
    
    func tipoVeiculo() -> String {
        switch tipo {
        case .carro, .moto, .caminhao:
            return "é terrestre"
        case .aviao:
            return "é aerio"
        case .barco:
            return "é maritimo"
        }
    }
}

extension String {
    func toCurrency(Amount: NSNumber) -> String {
        var currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = .current
        return currencyFormatter.string(from: Amount)!
    }
}

let veiculo01 = Veiculo(tipo: .aviao, marca: "Boing", preco: 1_500_000.00)
print(veiculo01.meusDados())
print(veiculo01.tipoVeiculo())

struct Person: Codable {
    var name: String
    var height: String
    var mass: String
    var hairColor: String
    var skinColor: String
    var eyeColor: String
    var birthYear: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
    }
}

enum APError: String, Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    static let baseURL = "https://swapi.dev/api/people/1"
    
    private init() { }
    
    func getPerson(completed: @escaping (Result<Person, APError>) -> Void) {
        guard let url = URL(string: NetworkManager.baseURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodeResponse = try decoder.decode(Person.self, from: data)
                completed(.success(decodeResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}


class StarWarsChar {
    var person: Person? = nil
    
    func callApi() {
        NetworkManager.shared.getPerson { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let personValue):
                    print(personValue.name)
                    self.person = Person(name: personValue.name, height: personValue.height, mass: personValue.mass, hairColor: personValue.hairColor, skinColor: personValue.skinColor, eyeColor: personValue.eyeColor, birthYear: personValue.birthYear)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}

