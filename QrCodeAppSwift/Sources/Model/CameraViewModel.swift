import AVFoundation

protocol cameraDelegate: AnyObject {
    func cameraFoundCode(cameraPath: CameraViewModel, code: String)
    func cameraDismiss(cameraPath: CameraViewModel)
}

class CameraViewModel: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: cameraDelegate?
    
    private var videoPreview = AVCaptureVideoPreviewLayer()
    var session = AVCaptureSession()
    
    func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if session.inputs.isEmpty {
                self.session.addInput(input)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        if (session.canAddOutput(output)) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]
        } else { return }
        
        videoPreview = AVCaptureVideoPreviewLayer(session: session)
        videoPreview.videoGravity = .resizeAspectFill
    }
    
    func layerCamera() -> AVCaptureVideoPreviewLayer? {
        let layer = videoPreview
        return layer
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            session.stopRunning()
        }
        delegate?.cameraDismiss(cameraPath: self)
    }
    
    private func found(code: String) {
        DispatchQueue.main.async {
            self.delegate?.cameraFoundCode(cameraPath: self, code: code)
        }
    }
}
