//
//  DelayedUserAgentSoundIOSelector.swift
//  Telephone
//
//  Copyright (c) 2008-2016 Alexey Kuznetsov
//  Copyright (c) 2016 64 Characters
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

public class DelayedUserAgentSoundIOSelector {
    public let factory: InteractorFactory

    private var selection: ThrowingInteractor = NullThrowingInteractor()

    public init(factory: InteractorFactory) {
        self.factory = factory
    }

    public func selectSoundIOWhenNeeded(userAgent: UserAgent) {
        selection = factory.createUserAgentSoundIOSelectionInteractor(userAgent: userAgent)
    }

    private func selectSoundIO(userAgent: UserAgent) throws {
        try selection.execute()
        selection = NullThrowingInteractor()
    }

    private func selectSoundIOOrLogError(userAgent: UserAgent) {
        do {
            try selectSoundIO(userAgent)
        } catch {
            print("Could not automatically select user agent audio devices: \(error)")
        }
    }
}

extension DelayedUserAgentSoundIOSelector: UserAgentEventTarget {
    public func userAgentDidFinishStarting(userAgent: UserAgent) {
        selectSoundIOWhenNeeded(userAgent)
    }

    public func userAgentDidFinishStopping(userAgent: UserAgent) {
        selection = NullThrowingInteractor()
    }

    public func userAgentDidMakeCall(userAgent: UserAgent) {
        selectSoundIOOrLogError(userAgent)
    }

    public func userAgentDidReceiveCall(userAgent: UserAgent) {
        selectSoundIOOrLogError(userAgent)
    }

    public func userAgentDidDetectNAT(userAgent: UserAgent) {}
}
