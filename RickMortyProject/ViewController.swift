import UIKit

class ViewController: UIViewController {
    
    let networkManager = NetworkManager.shared
    private var users = [Character]()
    private var spinnerView = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchUsers()
        showSpinner(in: tableView)
    }
    
    // MARK: - Navigation
    func navigateToUserViewController(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userVC = UserViewController()
        userVC.user = user
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    // MARK: - Private methods
    private func showAlert(withError networkError: NetworkManager.NetworkError) {
        let alert = UIAlertController(title: networkError.title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showSpinner(in view: UIView) {
        spinnerView.style = .large
        spinnerView.startAnimating()
        spinnerView.hidesWhenStopped = true
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "userCell") // Регистрируем ячейку
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Networking
extension ViewController {
    private func fetchUsers() {
        networkManager.fetchUsers { [weak self] result in
            guard let self = self else { return }
            self.spinnerView.stopAnimating()
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.showAlert(withError: error)
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToUserViewController(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
       
        cell.nameLabel.text = user.name
        cell.statusLabel.text = user.status
        cell.configureStatus(with: user.status)
        cell.imageAvatar.image = UIImage(systemName: "face.smiling")
        
        if let url = URL(string: user.image) {
            networkManager.fetchAvatar(from: url) { imageData in
                DispatchQueue.main.async {
                    guard let data = imageData, let image = UIImage(data: data) else { return }
                    cell.imageAvatar.image = image
                    cell.imageAvatar.layer.cornerRadius = tableView.rowHeight / 2
                    cell.imageAvatar.clipsToBounds = true
                }
            }
        } else {
            print("Invalid URL: \(user.image)")
        }
        
        return cell
    }
}

