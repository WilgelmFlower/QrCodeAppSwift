import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var urlText: String = ""
    
    private var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private var actiIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(actiIndicator)
        self.sendRequest(urlString: urlText)
        view.addSubview(webView)
        view?.backgroundColor = .white
        toolBar()
        
        webView.addSubview(actiIndicator)
        actiIndicator.startAnimating()
        webView.navigationDelegate = self
        actiIndicator.hidesWhenStopped = true
        
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    private func toolBar() {
        let pdfSaveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),style: .plain,target: self, action: #selector(shareTapped))
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [flexibleSpacer, pdfSaveButton]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc func shareTapped() {
        if let url = URL(string: urlText) {
            shareController(pdf: url)
        }
    }
    
    private func shareController(pdf: URL) {
        DispatchQueue.global(qos: .background).async {
            let pdfData = NSData(contentsOf: pdf)
            
            let avc = UIActivityViewController(activityItems: [pdfData as Any], applicationActivities: nil)
            avc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
                                                    Bool, arrayReturnedItems: [Any]?, error: Error?) in
                
                let alert = UIAlertController(title: completed ? "File Saved" : "File wasn't saved", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Continue", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            DispatchQueue.main.async {
                self.present(avc, animated: true)
            }
        }
    }
    
    private func sendRequest(urlString: String) {
        guard let myURL = URL(string: urlString) else { return }
        let myRequest = URLRequest(url: myURL)
        DispatchQueue.main.async {
            self.webView.load(myRequest)
        }
    }
    
    private func setupHierarchy() {
        view.addSubview(webView)
    }
    
    private func setupLayout() {
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            actiIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            actiIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor)
        ])
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        actiIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        actiIndicator.stopAnimating()
    }
}
