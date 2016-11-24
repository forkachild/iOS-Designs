import UIKit

@IBDesignable public class RoundImage: UIControl {
    
    private let maskLayer = CAShapeLayer()
    private let imageLayer = CALayer()
    private let mainLayer = CAShapeLayer()
    private let glassLayer = CAGradientLayer()
    
    @IBInspectable var image : UIImage = UIImage() {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 3.0 {
        didSet {
            updateBorder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createLayersAndAdd()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createLayersAndAdd()
    }
    
    public override var frame: CGRect {
        didSet {
            createLayers()
        }
    }
    
    public override var bounds: CGRect{
        didSet {
            createLayers()
        }
    }
    
    private func createLayersAndAdd() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        createLayers()
        
        self.layer.addSublayer(mainLayer)
        
    }
    
    private func createLayers() {
        
        createMaskLayer()
        createGlassLayer()
        createImageLayer()
        createMainLayer()
        
    }

    private func createMainLayer() {
        
        mainLayer.bounds = bounds
        mainLayer.backgroundColor = UIColor.clear.cgColor
        mainLayer.position = CGPoint(x: mainLayer.bounds.width / 2, y: mainLayer.bounds.height / 2)
        mainLayer.fillColor = (backgroundColor ?? UIColor.white).cgColor
        mainLayer.strokeColor = UIColor.clear.cgColor
        mainLayer.fillMode = kCAFillRuleEvenOdd
        mainLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        
        mainLayer.shadowRadius = 4.0
        mainLayer.shadowColor = UIColor.black.cgColor
        mainLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        mainLayer.shadowOpacity = 0.9
        
        mainLayer.addSublayer(imageLayer)
    }
    
    private func createGlassLayer() {
        
        glassLayer.frame = bounds
        glassLayer.backgroundColor = UIColor.clear.cgColor
        glassLayer.position = CGPoint(x: glassLayer.bounds.width / 2, y: glassLayer.bounds.height / 2)
        glassLayer.opacity = 0.15
        glassLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        glassLayer.endPoint = CGPoint(x: 1.0, y: 0.3)
        glassLayer.colors = [UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2).cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        glassLayer.locations = [0.0, 0.6, 0.63]
    }
    
    private func createImageLayer() {
        
        imageLayer.frame = bounds
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.position = CGPoint(x: imageLayer.bounds.width / 2, y: imageLayer.bounds.height / 2)
        imageLayer.mask = maskLayer
        imageLayer.contents = image.cgImage
        imageLayer.addSublayer(glassLayer)
    }
    
    private func createMaskLayer() {
        
        maskLayer.frame = bounds
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.position = CGPoint(x: maskLayer.bounds.width / 2, y: maskLayer.bounds.height / 2)
        maskLayer.strokeColor = UIColor.clear.cgColor
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.path = UIBezierPath(ovalIn: maskLayer.bounds.insetBy(dx: borderWidth, dy: borderWidth)).cgPath
        
    }
    
    private func updateImage() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        imageLayer.contents = image.cgImage
        CATransaction.commit()
    }
    
    private func updateBorder() {
        maskLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: borderWidth, dy: borderWidth)).cgPath
    }

}
