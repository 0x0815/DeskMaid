//
//  AppDelegate.swift
//  DeskMaid
//
//  Created by Tobi on 04.12.16.
//  Copyright © 2016 A Crowd Apart. All rights reserved.
//

import Cocoa
let DEBUG = true

@NSApplicationMain


class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var statusBarMenu: NSMenu!
    @IBOutlet weak var destinationPathControl: NSPathControl!
    @IBOutlet weak var dateFormatPopUpButton: NSPopUpButton!
    @IBOutlet weak var shortCutTextField: NSTextField!
    @IBOutlet weak var setShortCutButton: NSButton!
    @IBOutlet weak var showOptionToClearDownloadsCheckbox: NSButton!
    @IBOutlet weak var launchAtLoginCheckbox: NSButton!
    @IBOutlet weak var sendAnonymousUsageStatisticsCheckbox: NSButton!
    @IBOutlet weak var automatecallyCheckForUpdates: NSButton!
    @IBOutlet weak var generalTabViewItem: NSTabViewItem!
    @IBOutlet weak var exclusionsTabViewItem: NSTabViewItem!
    
    let statusBarItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let defaults = UserDefaults.standard
    let fm = FileManager.default

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Set Statusbar Menuitem and Menu
        let icon = NSImage(named: "icon_dark.png")
        icon?.isTemplate = true //includes Darkmode
        statusBarItem.menu = statusBarMenu
        statusBarItem.image = icon
        
        //removes blue frame
        destinationPathControl.focusRingType = NSFocusRingType.none
        
        //creates default Desk Maid folder
        if !FileManager.SearchPathDirectory.documentDirectory.createSubFolder(named: "DeskMaid Folder") {
            if DEBUG { print("Error while creating default DeskMaid folder") }
        }

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func destinationPathControll(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a destination Folder"
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false
        dialog.runModal()
        destinationPathControl.url = dialog.url
        if DEBUG { print(destinationPathControl.url ?? "err0r") }
    }

    
    @IBAction func closePreferenceWindow(_ sender: Any) {
        if DEBUG {
            print(destinationPathControl.url ?? "Dingensbums")
            print(dateFormatPopUpButton.state)
            print(showOptionToClearDownloadsCheckbox.state)
            print(launchAtLoginCheckbox.state)
            print(sendAnonymousUsageStatisticsCheckbox.state)
            print(automatecallyCheckForUpdates.state)
        }
        
        defaults.set(destinationPathControl.url, forKey: "destinationPathURL")
        defaults.set(dateFormatPopUpButton.state, forKey: "dateFormatStringValue")
        defaults.set(showOptionToClearDownloadsCheckbox.state, forKey: "optionToClearDownloads")
        defaults.set(launchAtLoginCheckbox.state, forKey: "launchAtLogin")
        defaults.set(sendAnonymousUsageStatisticsCheckbox.state, forKey: "anonymousUsageStatistics")
        defaults.set(automatecallyCheckForUpdates.state, forKey: "checkForUpdates")
        
        window.close()
    }

    @IBAction func resetToDefaults(_ sender: Any) {
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        print(defaults.url(forKey: "destinationPathURL"))
        
        destinationPathControl.url = defaults.url(forKey: "destinationPathURL")
        dateFormatPopUpButton.state = defaults.integer(forKey: "dateFormatStringValue")
        showOptionToClearDownloadsCheckbox.state = defaults.integer(forKey: "optionToClearDownloads")
        launchAtLoginCheckbox.state = defaults.integer(forKey: "launchAtLogin")
        sendAnonymousUsageStatisticsCheckbox.state = defaults.integer(forKey: "anonymousUsageStatistics")
        automatecallyCheckForUpdates.state = defaults.integer(forKey: "checkForUpdates")
        
        
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(self)
    }

}

extension FileManager.SearchPathDirectory {
    func createSubFolder(named: String, withIntermediateDirectories: Bool = false) -> Bool {
        guard let url = FileManager.default.urls(for: self, in: .userDomainMask).first else { return false }
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent(named), withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
            return true
        } catch let error as NSError {
            if DEBUG { print(error.description) }
            return false
        }
    }
}
