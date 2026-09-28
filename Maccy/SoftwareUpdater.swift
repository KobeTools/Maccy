import Sparkle

@Observable
class SoftwareUpdater {
  var automaticallyChecksForUpdates = false {
    didSet {
      updater.automaticallyChecksForUpdates = automaticallyChecksForUpdates
    }
  }

  private var updater: SPUUpdater

  private let updaterController = SPUStandardUpdaterController(
    startingUpdater: false,
    updaterDelegate: nil,
    userDriverDelegate: nil
  )

  init() {
    updater = updaterController.updater
    // Fork builds from source: never start Sparkle or pull upstream binaries.
    updater.automaticallyChecksForUpdates = false
  }

  func checkForUpdates() {
    updater.checkForUpdates()
  }
}
