import AVFoundation

protocol PresenterProtocol {
    func viewAppear()
    func viewDissapear()
    func openCamera()
}

class Presenter: PresenterProtocol {
    
    private weak var view: ViewProtocol?
    let cameraModel = CameraViewModel()
    
    init(view: ViewProtocol) {
        self.view = view
        cameraModel.delegate = self
    }
    
    func openCamera() {
        cameraModel.setupCamera()
        let layer = cameraModel.layerCamera()
        view?.addLayer(layer: layer)
        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraModel.session.startRunning()
        }
    }
    
    func viewAppear() {
        if (cameraModel.session.isRunning == false) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.cameraModel.session.startRunning()
            }
        }
    }
    
    func viewDissapear() {
        if (cameraModel.session.isRunning == false) {
            cameraModel.session.stopRunning()
        }
    }
}

extension Presenter: cameraDelegate {
    func cameraDismiss(cameraPath: CameraViewModel) {
        view?.backToCamera()
    }
    
    func cameraFoundCode(cameraPath: CameraViewModel, code: String) {
        view?.pushTo(controller: ModuleBuilder.webModule(code: code))
    }
}
