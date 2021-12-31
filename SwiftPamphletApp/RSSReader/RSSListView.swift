//
//  RSSListView.swift
//  SwiftPamphletApp
//
//  Created by Ming Dai on 2021/12/31.
//

import SwiftUI

struct RSSListView: View {
    @StateObject var vm: RSSVM
    
    var body: some View {
        List {
            ForEach(vm.rssFeeds) { rss in
                NavigationLink {
                    RSSItemsView()
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(rss.title)
                            .bold()
                        Text(rss.des)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }

            }
        }
    }
}

