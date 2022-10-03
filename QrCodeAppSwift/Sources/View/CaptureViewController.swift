import UIKit
import AVFoundation

protocol ViewProtocol: AnyObject {
    func pushTo(controller: UIViewController)
    func addLayer(layer: AVCaptureVideoPreviewLayer?)
    func backToCamera()
}

class CaptureViewController: UIViewController {
    
    var presenter: PresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewDissapear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.openCamera()
    }
}

extension CaptureViewController: ViewProtocol {
    func addLayer(layer: AVCaptureVideoPreviewLayer?) {
        guard let layer = layer else { return }
        view.layer.addSublayer(layer)
        layer.frame = view.layer.bounds
    }
    
    func backToCamera() {
        dismiss(animated: true, completion: nil)
    }
    
    func pushTo(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}
