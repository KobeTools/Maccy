import KeyboardShortcuts

extension KeyboardShortcuts.Name {
  static let popup = Self("popup", default: Shortcut(.c, modifiers: [.command, .shift]))
  static let pin = Self("pin", default: Shortcut(.p, modifiers: [.option]))
  static let delete = Self("delete", default: Shortcut(.delete, modifiers: [.option]))
  static let togglePreview = Self("togglePreview", default: Shortcut(.space, modifiers: [.control]))

  // Secure-paste slots (passwords stored in Keychain, never recorded in history)
  static let securePaste0 = Self("securePaste0")
  static let securePaste1 = Self("securePaste1")
  static let securePaste2 = Self("securePaste2")
  static let securePaste3 = Self("securePaste3")
  static let securePaste4 = Self("securePaste4")

  static func securePaste(index: Int) -> Self {
    switch index {
    case 1: return .securePaste1
    case 2: return .securePaste2
    case 3: return .securePaste3
    case 4: return .securePaste4
    default: return .securePaste0
    }
  }
}
