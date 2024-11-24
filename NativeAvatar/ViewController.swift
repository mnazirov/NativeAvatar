//
//  Created by Marat Nazirov on 24.11.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var avatarView: UIImageView = {
        let contentView = UIImageView()
        contentView.backgroundColor = .clear
        contentView.image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
        contentView.tintColor = .systemGray
        contentView.contentMode = .scaleAspectFit
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else { return }
        let progress = calculateProgress(currentHeight: navigationBar.frame.height)
        updateAvatar(for: progress)
    }
}

// MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let progress = calculateProgress(currentHeight: navigationBar.frame.height)
        updateAvatar(for: progress)
    }
}

// MARK: - Private methods

private extension ViewController {
    func commonInit() {
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
    }
    
    func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        navigationController?.navigationBar.addSubview(avatarView)

    }
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 2),
        ])
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        NSLayoutConstraint.activate([
            avatarView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
            avatarView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
            avatarView.heightAnchor.constraint(equalToConstant: 32),
            avatarView.widthAnchor.constraint(equalToConstant: 32)
            
        ])
    }
    
    func setupNavigationBar() {
        title = "Avatar"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func calculateProgress(currentHeight: CGFloat) -> CGFloat {
        let largeTitleHeight: CGFloat = 96.0
        let collapsedTitleHeight: CGFloat = 44.0
        return max(0, min(1, (largeTitleHeight - currentHeight) / (largeTitleHeight - collapsedTitleHeight)))
    }
    
    func updateAvatar(for progress: CGFloat) {
        let height = avatarView.bounds.height * (1 - progress)
        let rect = CGRect(x: 0, y: avatarView.bounds.height - height, width: avatarView.bounds.width, height: height)
        avatarView.layer.mask = {
            let mask = CAShapeLayer()
            mask.path = UIBezierPath(rect: rect).cgPath
            return mask
        }()
    }
}

