import UIKit

class ModuleBuilder {
    
    static func qrCodeModule() -> UIViewController {
        let view = CaptureViewController()
        let presenter = Presenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func webModule(code: String) -> UIViewController {
        let view = WebViewController()
        view.urlText = code
        return view
    }
}
