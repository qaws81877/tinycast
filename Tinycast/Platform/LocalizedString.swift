import Foundation

extension String {
    /// Catalog lookup. Unknown keys, including user content, come back unchanged.
    var localized: String {
        Bundle.main.localizedString(forKey: self, value: self, table: nil)
    }

    func localized(_ arguments: CVarArg...) -> String {
        String(format: localized, locale: .current, arguments: arguments)
    }
}
