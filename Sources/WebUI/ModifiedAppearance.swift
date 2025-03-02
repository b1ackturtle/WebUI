import SwiftUI
import WebKit

public struct ModifiedAppearance<Content, Value> {
    var content: Content
    var keyPath: ReferenceWritableKeyPath<OSView, Value>
    var value: Value

    #if canImport(UIKit)
    public func appearance<T>(
        _ keyPath: ReferenceWritableKeyPath<UIView, T>,
        _ value: T
    ) -> ModifiedAppearance<Self, T> {
        .init(content: self, keyPath: keyPath, value: value)
    }
    #elseif canImport(AppKit)
    public func appearance<T>(
        _ keyPath: ReferenceWritableKeyPath<NSView, T>,
        _ value: T
    ) -> ModifiedAppearance<Self, T> {
        .init(content: self, keyPath: keyPath, value: value)
    }
    #endif
}

extension ModifiedAppearance: WebViewRepresentable, View where Content: WebViewRepresentable {
    var configuration: WKWebViewConfiguration {
        content.configuration
    }

    func applyModifiers(to webView: EnhancedWKWebView) {
        content.applyModifiers(to: webView)
        webView[keyPath: keyPath] = value
    }

    func loadInitialRequest(in webView: EnhancedWKWebView) {
        content.loadInitialRequest(in: webView)
    }
}
