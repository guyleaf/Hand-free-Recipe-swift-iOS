//
//  ImageLoader.swift
//  Hand-free-Recipe
//
//  Created by Guyleaf on 2021/6/20.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var dataIsFetched: Bool {
        get {
            return self.image != nil
        }
    }

    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }
    
    func load() {
        if self.dataIsFetched {
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .retry(10)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        self.cancel()
    }
}
