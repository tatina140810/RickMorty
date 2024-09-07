import Foundation

// Объявление NetworkManager с обработкой возможных ошибок
final class NetworkManager {
    enum NetworkError: Error, LocalizedError {
        case decodingError
        case noData
        case noUser
        
        var title: String {
            switch self {
            case .decodingError:
                return "Can't decode received data."
            case .noData:
                return "Can't fetch data at all."
            case .noUser:
                return "No user received from API."
            }
        }
        
        var errorDescription: String? {
            return title
        }
    }
    
    static let shared = NetworkManager()
    private init() {}
    
    // Метод для загрузки аватара
    func fetchAvatar(from url: URL, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    // Метод для получения списка пользователей
    func fetchUsers(completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: Link.allUsers.url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse else {
                print(error?.localizedDescription ?? "No error description")
                sendFailure(with: .noData)
                return
            }
            
            // Проверяем статус код ответа
            if (200...299).contains(response.statusCode) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    // Попытка декодирования UsersQuery, которая содержит массив Character
                    let usersQuery = try decoder.decode(UsersQuery.self, from: data)
                    DispatchQueue.main.async {
                        if usersQuery.results.isEmpty {
                            sendFailure(with: .noUser)
                        } else {
                            completion(.success(usersQuery.results))
                        }
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)") // Вывод ошибки для отладки
                    sendFailure(with: .decodingError)
                }
            } else {
                sendFailure(with: .noData)
            }
            
            // Внутренняя функция для обработки ошибок
            func sendFailure(with error: NetworkError) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

// Mark: - Link
extension NetworkManager {
    enum Link {
        case allUsers
        case withNoData
        case withDecodingError
        case withNoUsers
        
        var url: URL {
            switch self {
            case .allUsers:
                return URL(string: "https://rickandmortyapi.com/api/character")!
            case .withNoData:
                return URL(string: "https://rickandmortyapi.com/api")!
            case .withDecodingError:
                return URL(string: "https://rickandmortyapi.com/api/character/3?delay=2")!
            case .withNoUsers:
                return URL(string: "https://rickandmortyapi.com/api/character/?delay=2&page=3")!
            }
        }
    }
}
