import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var imageAvatar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    var statusLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageAvatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            imageAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageAvatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageAvatar.widthAnchor.constraint(equalToConstant: 60),
            imageAvatar.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageAvatar.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statusLabel.leadingAnchor.constraint(equalTo: imageAvatar.trailingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configureStatus(with status: String) {
        statusLabel.text = status
        
        switch status.lowercased() {
        case "alive":
            statusLabel.textColor = .green
        case "dead":
            statusLabel.textColor = .red
        default:
            statusLabel.textColor = .blue
        }
    }
}
