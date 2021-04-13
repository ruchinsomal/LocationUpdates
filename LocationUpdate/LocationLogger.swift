//
//  LocationLogger.swift
//  LocationUpdate
//
//  Created by Ruchin Somal on 2021-04-13.
//

import Foundation
import CoreLocation

struct LocationLogger {
    
    private static var fileUrl = { () -> URL in
        let dir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        return dir.appendingPathComponent("location.log")
    }()
    
    func removeLogFile() {
        try? FileManager.default.removeItem(at: LocationLogger.fileUrl)
    }
    
    func writeLocationToFile(location: CLLocation) {
        
        let string = "\(NSDate())&\(location.coordinate.latitude)&\(location.coordinate.longitude)\n"
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        if FileManager.default.fileExists(atPath: LocationLogger.fileUrl.path) {
            let fileHandle = try! FileHandle(forWritingTo: LocationLogger.fileUrl)
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
            NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
        } else {
            try! data.write(to: LocationLogger.fileUrl)
        }
    }
    
    func clear() {
        try? FileManager.default.removeItem(at: LocationLogger.fileUrl)
    }
    
    func readLocation() -> [CLLocation]? {
        do {
            let data = try String(contentsOf: LocationLogger.fileUrl)
            let locationStrings = data.components(separatedBy: .newlines)
            
            var locations:[CLLocation] = []
            
            locationStrings.forEach({ locString in
                let coordinateString = locString.split(separator: "&")
                if coordinateString.count > 2 {
                    let lat = Double(coordinateString[1])
                    let long = Double(coordinateString[2])
                    
                    locations.append(CLLocation(latitude: lat!, longitude: long!))
                }
                
            })
            
            return locations
        }
        catch {
            return nil
            
        }
    }
}
