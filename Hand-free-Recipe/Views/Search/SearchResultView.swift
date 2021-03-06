//
//  SearchResultView.swift
//  Hand-free-Recipe
//
//  Created by Guyleaf on 2021/6/3.
//

import SwiftUI

struct SearchResultView: View {
    @StateObject var resultLoader: SearchResultLoader
    @State var page: Int = 0
    let size: Int
    let keyword: String
    
    @State var loadOnce = false
    
    init(keyword: String, size: Int) {
        self.keyword = keyword
        self.size = size
        self._resultLoader = StateObject(wrappedValue: SearchResultLoader(keyword: keyword, size: size))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(resultLoader.results, id: \.self) { recipe in
                SearchResultCardView(recipe: recipe)
            }

            if !resultLoader.isLastPage {
                if resultLoader.results.count == (page+1) * size {
                    Button(action: {
                        page += 1
                        resultLoader.next()
                    }, label: {
                        Text("More...?")
                            .foregroundColor(.primary)
                            
                            .font(.title2)
                            .frame(width: 200, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                            .padding()
                    })
                }
                else {
                    ActivityIndicator(style: .circle(width: 3, duration: 0.8, size: 40))
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                        .frame(width: 45)
                }
            }
        }
        .onAppear {
            if !loadOnce {
                self.resultLoader.load()
                DispatchQueue.main.async {
                    self.loadOnce = false
                }
            }
        }
        .navigationBarHidden(false)
        .navigationTitle(self.keyword)
    }
}

// Crash
//struct SearchResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultView(keyword: "lunch", size: 10)
//            .preferredColorScheme(.dark)
//    }
//}
