import AppKit
import Defaults
import KeyboardShortcuts

@Observable
class SecurePasteManager {
  static let maxShortcuts = 5

  var shortcuts: [SecurePasteShortcut] {
    didSet { Defaults[.securePasteShortcuts] = shortcuts }
  }

  init() {
    shortcuts = Defaults[.securePasteShortcuts]
    for i in 0..<SecurePasteManager.maxShortcuts {
      KeyboardShortcuts.onKeyDown(for: .securePaste(index: i)) { [weak self] in
        self?.paste(shortcutIndex: i)
      }
    }
  }

  func add() {
    let used = Set(shortcuts.map(\.shortcutIndex))
    guard let next = (0..<SecurePasteManager.maxShortcuts).first(where: { !used.contains($0) }) else { return }
    shortcuts.append(SecurePasteShortcut(label: "Shortcut \(next + 1)", shortcutIndex: next))
  }

  func remove(_ shortcut: SecurePasteShortcut) {
    KeychainHelper.delete(key: shortcut.keychainKey)
    shortcuts.removeAll { $0.id == shortcut.id }
  }

  private func paste(shortcutIndex: Int) {
    guard let shortcut = shortcuts.first(where: { $0.shortcutIndex == shortcutIndex }),
          let password = KeychainHelper.load(key: shortcut.keychainKey),
          !password.isEmpty else { return }

    let pasteboard = NSPasteboard.general

    // Arm Maccy's existing "ignore next clipboard event" mechanism so the
    // password is never recorded in history.
    Defaults[.ignoreEvents] = true
    Defaults[.ignoreOnlyNextEvent] = true
    pasteboard.clearContents()
    pasteboard.setString(password, forType: .string)

    Clipboard.shared.paste()

    // Clear the pasteboard shortly after the paste completes so the password
    // doesn't linger there.  Arm the ignore flag again so the clear itself
    // isn't recorded either (an empty pasteboard would be filtered anyway,
    // but this is belt-and-suspenders).
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      Defaults[.ignoreEvents] = true
      Defaults[.ignoreOnlyNextEvent] = true
      pasteboard.clearContents()
    }
  }
}
