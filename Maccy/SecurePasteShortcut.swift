import Defaults
import Foundation

struct SecurePasteShortcut: Codable, Identifiable, Equatable, Defaults.Serializable {
  var id: UUID
  var label: String
  var shortcutIndex: Int

  // Key used to look up this entry in the Keychain
  var keychainKey: String { "maccy-secure-paste-\(id.uuidString)" }

  init(label: String, shortcutIndex: Int) {
    self.id = UUID()
    self.label = label
    self.shortcutIndex = shortcutIndex
  }
}
