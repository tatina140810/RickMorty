//
//  PersonViewController.swift
//  RickMortyProject
//
//  Created by Tatina Dzhakypbekova on 7/9/24.
//

//
//  UserViewController.swift
//  APILesson
//
//  Created by Tatina Dzhakypbekova on 6/9/24.
//

import UIKit

final class UserViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    private let networkManager = NetworkManager.shared
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
composeUser(_user: user)
       
    }
    private func composeUser(_user: User) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        networkManager.fetchAvatar(from: user.avatar) { [weak self] imageData in
            self?.avatarImage.image = UIImage(data: imageData!)
        }
        
        
    }
    
}
