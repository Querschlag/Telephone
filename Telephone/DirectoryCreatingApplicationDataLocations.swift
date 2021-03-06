//
//  DirectoryCreatingApplicationDataLocations.swift
//  Telephone
//
//  Copyright © 2008-2016 Alexey Kuznetsov
//  Copyright © 2016-2017 64 Characters
//
//  Telephone is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Telephone is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import Foundation

final class DirectoryCreatingApplicationDataLocations {
    fileprivate let origin: ApplicationDataLocations
    fileprivate let manager: FileManager

    init(origin: ApplicationDataLocations, manager: FileManager) {
        self.origin = origin
        self.manager = manager
    }
}

extension DirectoryCreatingApplicationDataLocations: ApplicationDataLocations {
    func logs() -> URL {
        return createDirectory(at: origin.logs())
    }

    func callHistories() -> URL {
        return createDirectory(at: origin.callHistories())
    }

    private func createDirectory(at url: URL) -> URL {
        do {
            try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Could not create directory at \(url): \(error)")
        }
        return url
    }
}
