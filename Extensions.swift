import Foundation
import UIKit

extension UIColor {
    
    class func interpolate(between start: UIColor, and end: UIColor, by prog: CGFloat) -> UIColor {
        
        var startRed: CGFloat = 0
        var startGreen: CGFloat = 0
        var startBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        
        start.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        end.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let adjustedProgress = max(min(1.0, prog), 0.0)
        
        let finalRed = startRed + (adjustedProgress * (endRed - startRed))
        let finalGreen = startGreen + (adjustedProgress * (endGreen - startGreen))
        let finalBlue = startBlue + (adjustedProgress * (endBlue - startBlue))
        let finalAlpha = startAlpha + (adjustedProgress * (endAlpha - startAlpha))
        
        return UIColor(red: finalRed, green: finalGreen, blue: finalBlue, alpha: finalAlpha)
        
    }
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
}

extension String {
    
    func attributedString(joinedWith firstString: String) -> NSAttributedString {
        
        let wholeString = "\(self) \(firstString)"
        
        let firstAttrs = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!
        ]
        
        let secondAttrs = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20.0)!
        ]
        
        let attrStr = NSMutableAttributedString(string: wholeString, attributes: secondAttrs)
        attrStr.setAttributes(firstAttrs, range: NSMakeRange(0, self.characters.count))
        return attrStr
        
    }
    
}

extension NSLayoutConstraint {
    
    class func activateConstraints(withVisualFormats formats: [String], comprisingViews views: [String : UIView]) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        for format in formats {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: views)
        }
        
        NSLayoutConstraint.activate(constraints)
        
        return constraints
    }
    
}







































