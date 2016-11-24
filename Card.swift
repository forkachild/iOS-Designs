import UIKit

struct CardCellData {
    
    var left : String
    var right : String
}

fileprivate struct CardCell {
    
    weak var leftLabel : UILabel!
    weak var rightLabel : UILabel!
    var constraints : [NSLayoutConstraint]!
}

@IBDesignable class Card: UIView {
    
    @IBInspectable var title : String = "Title" {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                () -> Void in
                
                self.updateTitle()
            })
        }
    }
    
    var data = [CardCellData]() {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                () -> Void in
                
                self.updateData()
            })
            
        }
    }
    
    private var cells = [CardCell]()
    
    private var currentConstraints: [NSLayoutConstraint]!
    
    private var titleLabel : UILabel!
    private var cardView : CardBackground!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViewsAndAdd()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createViewsAndAdd()
    }
    
    private func createViewsAndAdd() {
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView = CardBackground()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "T I T L E"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 183.0/255.0, green: 200.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(titleLabel)
        self.addSubview(cardView)

        createConstraints()
    }
    
    private func createConstraints() {
        
        let views = ["titleLabel" : titleLabel!,
                     "cardView" : cardView!] as [String : UIView]
        
        let constraints = ["H:|[titleLabel]|",
                           "H:|[cardView]|",
                           "V:|[titleLabel(26)]-10-[cardView(>=86)]|"]
        
        currentConstraints = NSLayoutConstraint.activateConstraints(withVisualFormats: constraints, comprisingViews: views)
    }
    
    private func updateTitle() {
        var uTitle = title.uppercased().trimmingCharacters(in: [" "])
        if(uTitle.characters.count > 1) {
            var temp = ""
            for ch in uTitle.characters {
                temp.append("\(ch) ")
            }
            titleLabel.text = temp.trimmingCharacters(in: [" "])
        } else {
            titleLabel.text = uTitle
        }
        
    }
    
    private func updateData() {
        
        for i in 0..<data.count {
        
            if i < cells.count {
                
                cells[i].leftLabel?.text = data[i].left
                cells[i].rightLabel?.text = data[i].right.uppercased()

            } else {
            
                let leftLabel = UILabel()
                leftLabel.translatesAutoresizingMaskIntoConstraints = false
                leftLabel.numberOfLines = 0
                leftLabel.textAlignment = .left
                leftLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)!
                leftLabel.text = data[i].left
            
                let rightLabel = UILabel()
                rightLabel.translatesAutoresizingMaskIntoConstraints = false
                rightLabel.numberOfLines = 0
                rightLabel.textAlignment = .right
                rightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
                rightLabel.text = data[i].right.uppercased()
            
                cells.append(CardCell(leftLabel: leftLabel, rightLabel: rightLabel, constraints: nil))
                
                cardView.addSubview(leftLabel)
                cardView.addSubview(rightLabel)
            }
            
            if let c = cells[i].constraints {
                NSLayoutConstraint.deactivate(c)
            }
            
            if i == 0 {
                
                let views = ["leftLabel" : cells[i].leftLabel!,
                             "rightLabel" : cells[i].rightLabel!]
                
                let constraints = ["H:|-20-[leftLabel(100)][rightLabel]-20-|",
                                   "V:|-30-[leftLabel(>=26)]",
                                   "V:|-30-[rightLabel(>=26)]"]
                
                cells[i].constraints = NSLayoutConstraint.activateConstraints(withVisualFormats: constraints, comprisingViews: views)
                
            } else {
                
                let views = ["aboveLeftLabel" : cells[i - 1].leftLabel!,
                             "aboveRightLabel" : cells[i - 1].rightLabel!,
                             "leftLabel" : cells[i].leftLabel!,
                             "rightLabel" : cells[i].rightLabel!]
                
                var constraints = ["H:|-20-[leftLabel(100)][rightLabel]-20-|"]
                
                if i == data.count - 1 {
                    constraints += ["V:[aboveLeftLabel]-26-[leftLabel(>=26)]-30-|",
                                    "V:[aboveRightLabel]-26-[rightLabel(>=26)]-30-|"]
                } else {
                    constraints += ["V:[aboveLeftLabel]-26-[leftLabel(>=26)]",
                                    "V:[aboveRightLabel]-26-[rightLabel(>=26)]"]
                }
                
                cells[i].constraints = NSLayoutConstraint.activateConstraints(withVisualFormats: constraints, comprisingViews: views)
                
            }
            
        }
    }
    
    
    
}


@IBDesignable class CardBackground: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable var cornerRadius : CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            gradientLayer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadow : Bool = true {
        didSet {
            if shadow {
                layer.shadowOpacity = shadowOpacity
            } else {
                layer.shadowOpacity = 0.0
            }
        }
    }
    
    @IBInspectable var shadowColor : UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0.9 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 4.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    override var frame: CGRect {
        didSet {
            createGradient()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            createGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createCard()
    }
    
    private func createCard() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = cornerRadius
        
        if shadow {
            layer.shadowOpacity = shadowOpacity
        } else {
            layer.shadowOpacity = 0.0
        }
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        createGradientAndAdd()
    }
    
    private func createGradientAndAdd() {
        createGradient()
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func createGradient() {
        gradientLayer.bounds = bounds
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        gradientLayer.position = CGPoint(x: gradientLayer.bounds.width / 2, y: gradientLayer.bounds.height / 2)
        gradientLayer.colors = [UIColor.white.darker(by: 3.0)!.cgColor, UIColor.white.darker(by: 8.0)!.cgColor]
        gradientLayer.locations = [0.0, 1.0]
    }
    
}
































