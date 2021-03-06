// AiryLayout
// Created by Maxim Kabyshev on 23.07.2017. All rights reserved.
//

import UIKit

public enum LayoutPinnedSide: Hashable {
    case top(CGFloat)
    case left(CGFloat)
    case right(CGFloat)
    case bottom(CGFloat)
}

public enum LayoutSideDirection {
    case top
    case left
    case right
    case bottom
}

private var isSafeAreaEnabled: Bool = false

extension UIView {

    /// Installing constraints by all methods in this extension with no safeArea logic
    /// - parameter closure: returns current UIView for manipulations.
    ///
    /// Using third-party methods (not from this extension) in the closure will not lead to any effect or, conversely,
    /// to undefined behavior.
    @discardableResult
    public func safeArea(_ closure: (UIView) -> Void) -> Self {
        isSafeAreaEnabled = true
        closure(self)
        isSafeAreaEnabled = false
        return self
    }

    // MARK: - Pin -

    /// All methods reverse inset's sign for .right and .bottom sides and directions
    ///
    /// - parameter view: nil will be interpreted as the command to use view's superview
    @discardableResult
    public func pin(insets: UIEdgeInsets = .zero, to toView: UIView? = nil) -> UIView {

        let view = check(toView)

        safeTopAnchor ~ view.safeTopAnchor + insets.top
        safeTrailingAnchor ~ view.safeTrailingAnchor - insets.right
        safeLeadingAnchor ~ view.safeLeadingAnchor + insets.left
        safeBottomAnchor ~ view.safeBottomAnchor - insets.bottom

        return self
    }

    /// Create constraints with inset from each side.
    @discardableResult
    public func pin(_ inset: CGFloat = 0.0) -> UIView {
        return pin(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    /// Create constraints with certain logic.
    /// - parameter excluding: side that is not handled
    /// - parameter insets: UIEdgeInsets struct with insets for each side. Default is .zero
    /// - parameter to: UIView instance which the constraints are attached. Default is nil (superview will be used).
    @discardableResult
    public func pin(excluding side: LayoutSideDirection, insets: UIEdgeInsets = .zero, to toView: UIView? = nil) -> UIView {
        switch side {
        case .top:
            pin([.left(insets.left), .right(insets.right), .bottom(insets.bottom)], to: toView)
        case .left:
            pin([.top(insets.top), .right(insets.right), .bottom(insets.bottom)], to: toView)
        case .right:
            pin([.top(insets.top), .left(insets.left), .bottom(insets.bottom)], to: toView)
        case .bottom:
            pin([.top(insets.top), .left(insets.left), .right(insets.right)], to: toView)
        }
        return self
    }

    @discardableResult
    public func pin(_ direction: LayoutSideDirection, inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        return pin([side(for: direction, inset: inset)], to: toView)
    }

    @discardableResult
    public func pin(_ directions: [LayoutSideDirection], inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        return pin(directions.map { side(for: $0, inset: inset) }, to: toView)
    }

    @discardableResult
    public func pin(_ sides: [LayoutPinnedSide], to toView: UIView? = nil) -> UIView {

        let view = check(toView)

        sides.forEach { side in
            switch side {
            case let .top(inset):
                safeTopAnchor ~ view.safeTopAnchor + inset
            case let .right(inset):
                safeTrailingAnchor ~ view.safeTrailingAnchor - inset
            case let .left(inset):
                safeLeadingAnchor ~ view.safeLeadingAnchor + inset
            case let .bottom(inset):
                safeBottomAnchor ~ view.safeBottomAnchor - inset
            }
        }

        return self
    }

    @discardableResult
    public func pin(_ side: LayoutPinnedSide, to toView: UIView? = nil) -> UIView {
        return pin([side], to: toView)
    }

    /*
     Example usage:

     label.pin([.top(7): .top, .left(15): .left, .right(4): .right], to: customView)

     * equally *

     label.topAnchor ~ customView.bottomAnchor + 7.0
     label.leftAnchor ~ customView.leftAnchor + 15.0
     label.rightAnchor ~ customView.rightAnchor - 4.0

     */

    @discardableResult
    public func pin(_ data: [LayoutPinnedSide: LayoutSideDirection], to toView: UIView? = nil) -> UIView {

        let view = check(toView)
        let sides = Array(data.keys)
        let directions = Array(data.values)

        for (index, element) in sides.enumerated() {
            let fromSide = sides[index]
            let toSide = side(for: directions[index])
            switch element {
            case let .top(inset):
                anchorY(for: fromSide) ~ view.anchorY(for: toSide) + inset
            case let .bottom(inset):
                anchorY(for: fromSide) ~ view.anchorY(for: toSide) - inset
            case let .left(inset):
                anchorX(for: fromSide) ~ view.anchorX(for: toSide) + inset
            case let .right(inset):
                anchorX(for: fromSide) ~ view.anchorX(for: toSide) - inset
            }
        }
        return self
    }

    // MARK: - Sides, Sizes and Centering -

    /*
     Example usage:

     view.top().bottom(12).right(to: view2).left(to: .right(15), of: view3)

     * equally *

     view.topAnchor ~ superview.topAnchor
     view.bottomAnchor ~ superview.bottomAnchor - 12
     view.rightAnchor ~ view2.rightAnchor
     view.leftAnchor ~ view3.rightAnchor - 15
     */

    @discardableResult
    public func centerY(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeCenterYAnchor ~ view.safeCenterYAnchor + inset
        return self
    }

    @discardableResult
    public func centerX(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeCenterXAnchor ~ view.safeCenterXAnchor + inset
        return self
    }

    @discardableResult
    public func centerWithInsets(x: CGFloat = 0.0, y: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeCenterYAnchor ~ view.safeCenterYAnchor + y
        safeCenterXAnchor ~ view.safeCenterXAnchor + x
        return self
    }

    @discardableResult
    public func height(_ value: CGFloat = 0.0) -> UIView {
        heightAnchor ~ value
        return self
    }

    @discardableResult
    public func height(value: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        heightAnchor ~ view.heightAnchor + value
        return self
    }

    @discardableResult
    public func width(_ value: CGFloat = 0.0) -> UIView {
        widthAnchor ~ value
        return self
    }

    @discardableResult
    public func width(value: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        widthAnchor ~ view.widthAnchor + value
        return self
    }

    @discardableResult
    public func left(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeLeadingAnchor ~ view.safeLeadingAnchor + inset
        return self
    }

    @discardableResult
    public func left(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeLeadingAnchor ~ view.anchorX(for: side) + inset
        return self
    }

    @discardableResult
    public func right(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeTrailingAnchor ~ view.safeTrailingAnchor - inset
        return self
    }

    @discardableResult
    public func right(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeTrailingAnchor ~ view.anchorX(for: side) - inset
        return self
    }

    @discardableResult
    public func top(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeTopAnchor ~ view.safeTopAnchor + inset
        return self
    }

    @discardableResult
    public func top(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeTopAnchor ~ view.anchorY(for: side) + inset
        return self
    }

    @discardableResult
    public func bottom(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeBottomAnchor ~ view.safeBottomAnchor - inset
        return self
    }

    @discardableResult
    public func bottom(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeBottomAnchor ~ view.anchorY(for: side) - inset
        return self
    }
}

// MARK: - Private Methods

private extension UIView {

    private func check(_ view: UIView?) -> UIView {
        guard view == nil else {
            return view! // swiftlint:disable:this force_unwrapping
        }
        guard let superview = superview else {
            fatalError("No superview for your view and also parameter `view` is nil")
        }
        return superview
    }

    @inline(__always)
    private func side(for direction: LayoutSideDirection, inset: CGFloat = 0.0) -> LayoutPinnedSide {
        switch direction {
        case .top:
            return LayoutPinnedSide.top(inset)
        case .left:
            return LayoutPinnedSide.left(inset)
        case .right:
            return LayoutPinnedSide.right(inset)
        case .bottom:
            return LayoutPinnedSide.bottom(inset)
        }
    }

    @inline(__always)
    private func direction(from side: LayoutPinnedSide) -> (LayoutSideDirection, CGFloat) {
        switch side {
        case let .top(inset):
            return (.top, inset)
        case let .left(inset):
            return (.left, inset)
        case let .right(inset):
            return (.right, inset)
        case let .bottom(inset):
            return (.bottom, inset)
        }
    }

    private func anchorX(for side: LayoutPinnedSide) -> NSLayoutXAxisAnchor {
        switch side {
        case .right:
            return safeTrailingAnchor
        case .left:
            return safeLeadingAnchor
        default:
            fatalError("Incorrect LayoutPinnedSide")
        }
    }

    private func anchorY(for side: LayoutPinnedSide) -> NSLayoutYAxisAnchor {
        switch side {
        case .top:
            return safeTopAnchor
        case .bottom:
            return safeBottomAnchor
        default:
            fatalError("Incorrect LayoutPinnedSide")
        }
    }
}

extension NSLayoutDimension {

    public func aspectFit(to: NSLayoutDimension, as aspectCoefficient: CGFloat) {
        constraint(equalTo: to, multiplier: aspectCoefficient).isActive = true
    }
}

extension UIView {

    public var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    public var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }

    public var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.leftAnchor
        } else {
            return leftAnchor
        }
    }

    public var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }

    public var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }

    public var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.centerXAnchor
        } else {
            return centerXAnchor
        }
    }

    public var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            return safeAreaLayoutGuide.centerYAnchor
        } else {
            return centerYAnchor
        }
    }
}
