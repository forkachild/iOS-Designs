import UIKit
import CoreText

let π: CGFloat = CGFloat(M_PI)

@IBDesignable public class ProgressRing: UIControl {
    
    private let startAngle = 3 * π / 4
    private let endAngle = π / 4
    private let animationDuration : CFTimeInterval = 1.0
    
    private let progressLayer = CAShapeLayer()
    private let baseLayer = CAShapeLayer()
    private let textLayer = CATextLayerCentered()
    
    @IBInspectable var thickness: CGFloat = 10.0 {
        didSet {
            updateThickness()
        }
    }
    
    @IBInspectable var rounded : Bool = true {
        didSet {
            updateCapStyle()
        }
    }
    
    @IBInspectable var shadow : Bool = false {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    @IBInspectable var maximum: CGFloat = 5.0 {
        didSet {
            updateMaxValue()
        }
    }
    
    @IBInspectable var baseColor: UIColor = UIColor.clear {
        didSet {
            updateBaseColor()
        }
    }

    @IBInspectable var textColor: UIColor = UIColor.darkGray {
        didSet {
            updateTextColor()
        }
    }
    
    @IBInspectable var minColor: UIColor = UIColor.red {
        didSet {
            updateMinColor()
        }
    }
    
    @IBInspectable var maxColor: UIColor = UIColor.green {
        didSet {
            updateMaxColor()
        }
    }
    
    public override var frame: CGRect {
        didSet {
            createLayers()
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            createLayers()
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
    
    private func createLayersAndAdd() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        createLayers()
        
        self.layer.addSublayer(baseLayer)
        self.layer.addSublayer(progressLayer)
        self.layer.addSublayer(textLayer)
        
    }
    
    private func createLayers() {
        
        let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = (min(bounds.width, bounds.height) - thickness) / 2.0
        
        baseLayer.contentsScale = UIScreen.main.scale
        progressLayer.contentsScale = UIScreen.main.scale
        textLayer.contentsScale = UIScreen.main.scale
        
        baseLayer.fillColor = UIColor.clear.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        
        textLayer.font = "HelveticaNeue-UltraLight" as CFTypeRef?
        
        baseLayer.shadowColor = UIColor.black.cgColor
        baseLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        baseLayer.shadowRadius = 4.0
        
        if shadow {
            baseLayer.shadowOpacity = 0.9
        } else {
            baseLayer.shadowOpacity = 0.0
        }
    
        baseLayer.bounds = bounds
        baseLayer.position = position
        
        progressLayer.bounds = bounds
        progressLayer.position = position
        
        textLayer.bounds = bounds
        textLayer.position = position
        textLayer.fontSize = radius / 1.1
        
        createBaseLayer()
        createProgressLayer()
        createTextLayer()
        
    }
    
    private func createBaseLayer() {
        
        let radius = (min(bounds.width, bounds.height) - thickness) / 2.0
        
        baseLayer.lineWidth = thickness
        updateCapStyle()
        
        baseLayer.path = UIBezierPath(arcCenter: CGPoint(x: baseLayer.bounds.width / 2.0, y: baseLayer.bounds.height / 2.0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        
        baseLayer.strokeEnd = 1.0
    }
    
    private func createProgressLayer() {
        
        let radius = (min(bounds.width, bounds.height) - thickness) / 2.0
        
        progressLayer.lineWidth = thickness
        progressLayer.strokeStart = 0.0
        updateCapStyle()
        
        progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: progressLayer.bounds.width / 2.0, y: progressLayer.bounds.height / 2.0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        
        progressLayer.strokeEnd = normalizedValue()
    }
    
    private func createTextLayer() {
        
        textLayer.string = String(format: "%.01f", cappedValue())
    }
    
    private func updateProgress() {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock { 
            self.progressLayer.strokeEnd = self.normalizedValue()
        }
        
        textLayer.string = String(format: "%.01f", cappedValue())
        progressLayer.strokeColor = color()
        
        CATransaction.setDisableActions(true)
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeAnimation.toValue = normalizedValue()
        strokeAnimation.duration = animationDuration
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokeAnimation.fillMode = kCAFillModeBoth
        strokeAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(strokeAnimation, forKey: "strokeEndAnimation")
        
        CATransaction.commit()
    }
    
    private func updateMaxValue() {
        textLayer.string = String(format: "%.01f", cappedValue())
        progressLayer.strokeEnd = normalizedValue()
        progressLayer.strokeColor = color()
    }
    
    private func updateMinColor() {
        progressLayer.strokeColor = color()
    }
    
    private func updateMaxColor() {
        progressLayer.strokeColor = color()
    }
    
    private func updateThickness() {
        baseLayer.lineWidth = thickness
        progressLayer.lineWidth = thickness
    }
    
    private func updateBaseColor() {
        baseLayer.strokeColor = baseColor.cgColor
    }
    
    private func updateCapStyle() {
        switch(rounded) {
        case true :
            
            baseLayer.lineCap = kCALineCapRound
            progressLayer.lineCap = kCALineCapRound
            break
            
        case false :
            
            baseLayer.lineCap = kCALineCapSquare
            progressLayer.lineCap = kCALineCapSquare
            break
        }
    }
    
    private func updateTextColor() {
        textLayer.foregroundColor = textColor.cgColor
    }
    
    private func updateShadow() {
        if shadow {
            baseLayer.shadowOpacity = 0.9
        } else {
            baseLayer.shadowOpacity = 0.0
        }
    }
    
    private func cappedValue() -> CGFloat {
        return max(min(progress, maximum), 0.00001)
    }
    
    private func normalizedValue() -> CGFloat {
        return cappedValue() / maximum
    }
    
    private func color() -> CGColor {
        return UIColor.interpolate(between: minColor, and: maxColor, by: normalizedValue()).cgColor
    }
    
}

private class CATextLayerCentered : CATextLayer {
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        ctx.translateBy(x: (bounds.size.width-fontSize)/2 - fontSize/5, y: (bounds.size.height-fontSize)/2 - fontSize/10)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
