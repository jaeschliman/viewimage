//
//  main.swift
//  viewimage
//
//  Created by Jason Aeschliman on 2/21/16.
//  Copyright © 2016 Jason Aeschliman. All rights reserved.
//

import Cocoa
import Foundation


class ImageView : NSView {
    
    let image : NSImage
    
    init(frame: NSRect, image: NSImage) {
        self.image = image
        super.init(frame:frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let maxRect = self.bounds.insetBy(dx: 100, dy: 100)
         
        var size = image.size
        
        if size.width > maxRect.width || size.height > maxRect.height {
            let xscale = maxRect.width / size.width
            let yscale = maxRect.height / size.height
            let scale = min(xscale, yscale)
            size = NSSize(width: scale * size.width, height: scale * size.height)
        }
        
        let x = self.bounds.midX - (size.width  / 2)
        let y = self.bounds.midY - (size.height / 2)
        let rect = NSRect(origin: CGPoint(x: x, y: y), size: size)
        
        image.drawInRect(rect)
    }
    override var acceptsFirstResponder : Bool {
        return true
    }
    override func mouseDown(theEvent: NSEvent) {
        exit(0)
    }
}

class Delegate : NSObject, NSApplicationDelegate {
    
    var window : NSWindow!
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        let args = NSProcessInfo.processInfo().arguments
        
        guard args.count >= 2 else {
            print("usage: viewimage path-to-image")
            exit(1)
        }
        
        let arg : NSString = args[1]
        let path = arg.stringByExpandingTildeInPath
        
        guard let image = NSImage(contentsOfFile: path) else {
            print("unable to load image: \(path)")
            exit(1)
        }
        
        let screenRect = NSScreen.mainScreen()!.frame
        
        window = NSWindow(contentRect: screenRect,
            styleMask: NSBorderlessWindowMask,
            backing: .Retained,
            `defer`: false)
        
        let level = Int(CGWindowLevelForKey(.ScreenSaverWindowLevelKey))
        
        window.level = level
        window.opaque = false
        window.backgroundColor = NSColor.clearColor()
        window.contentView = ImageView(frame:screenRect, image:image)
        window.makeKeyAndOrderFront(nil)
    }
}

let app = NSApplication.sharedApplication()
let delegate = Delegate()
app.delegate = delegate
app.run()
print("bye app: \(app), \(delegate)")