//
//  LogInVC.swift
//  Spotify_Clone
//
//  Created by Ziyad Qassem on 15/09/2024.
//

import UIKit
import WebKit
class AuthenticationVC: UIViewController, WKNavigationDelegate {
    
    private let webView : WKWebView =  {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
      
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    public var completionHandler : ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthenticationManager.shared.signInURl else {
            return
        }
        
        webView.load(URLRequest(url: url))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       
        guard let url = webView.url else {
             return
        }
        
        // take the User's access token as the response value from the Url
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        webView.isHidden = true
        print("************************")
        print("Code :  \(code)")
        print("************************")
        AuthenticationManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
            
        }
    }

}
