import Defaults
import KeyboardShortcuts
import SwiftUI

struct SecurePasteSettingsPane: View {
  private var manager: SecurePasteManager { AppState.shared.securePaste }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Assign keyboard shortcuts that paste a saved password directly, without recording it in clipboard history.")
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(.gray)
        .controlSize(.small)

      Divider()

      ForEach(Array(manager.shortcuts.enumerated()), id: \.element.id) { index, shortcut in
        SecurePasteShortcutRow(
          shortcut: Binding(
            get: { manager.shortcuts[index] },
            set: { manager.shortcuts[index] = $0 }
          ),
          onDelete: { manager.remove(shortcut) }
        )
      }

      if manager.shortcuts.count < SecurePasteManager.maxShortcuts {
        Button("Add Secure Shortcut") {
          manager.add()
        }
      }
    }
    .frame(minWidth: 350, maxWidth: 500)
    .padding()
  }
}

private struct SecurePasteShortcutRow: View {
  @Binding var shortcut: SecurePasteShortcut
  var onDelete: () -> Void

  @State private var password: String = ""
  @State private var showPassword = false

  var body: some View {
    HStack(spacing: 8) {
      TextField("Label", text: $shortcut.label)
        .textFieldStyle(.roundedBorder)
        .frame(width: 110)

      KeyboardShortcuts.Recorder(for: .securePaste(index: shortcut.shortcutIndex))

      Spacer()

      Group {
        if showPassword {
          TextField("Password", text: $password)
        } else {
          SecureField("Password", text: $password)
        }
      }
      .textFieldStyle(.roundedBorder)
      .frame(width: 130)
      .onChange(of: password) { _, new in
        KeychainHelper.save(new, key: shortcut.keychainKey)
      }

      Button {
        showPassword.toggle()
      } label: {
        Image(systemName: showPassword ? "eye.slash" : "eye")
      }
      .buttonStyle(.plain)
      .help(showPassword ? "Hide password" : "Show password")

      Button(role: .destructive, action: onDelete) {
        Image(systemName: "minus.circle.fill")
          .foregroundStyle(.red)
      }
      .buttonStyle(.plain)
      .help("Delete this shortcut")
    }
    .onAppear {
      password = KeychainHelper.load(key: shortcut.keychainKey) ?? ""
    }
  }
}

#Preview {
  SecurePasteSettingsPane()
    .environment(\.locale, .init(identifier: "en"))
}
