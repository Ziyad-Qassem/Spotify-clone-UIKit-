//
//  WelcomeVC.swift
//  Spotify_Clone
//
//  Created by Ziyad Qassem on 15/09/2024.
//

import UIKit

class WelcomeVC: UIViewController {

    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle( "Sign In With Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .green
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(x: 20, y: view.height-50-view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignIn(){
        let vc = AuthenticationVC()
        vc.completionHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success : success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func handleSignIn(success : Bool) {
        // check user login process
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(action)
          present(alert , animated: true)
            return
        }
        
        let mainApptabBarVC = TabBarVC()
        mainApptabBarVC.modalPresentationStyle = .fullScreen
        present(mainApptabBarVC , animated:  true)
    }
}
