//
//  MainView.swift
//  Caché
//
//  Created by Hariz Shirazi on 2023-03-02.
//

import SwiftUI

struct AppListView: View {
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    @State var allApps = [SBApp(bundleIdentifier: "", name: "", bundleURL: URL(string: "/")!, pngIconPaths: ["this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao"], hiddenFromSpringboard: false)]
    @State var apps = [SBApp(bundleIdentifier: "", name: "", bundleURL: URL(string: "/")!, pngIconPaths: ["this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao"], hiddenFromSpringboard: false)]
    var body: some View {
        NavigationView {
            List {
                Section {
                    if apps == [SBApp(bundleIdentifier: "", name: "", bundleURL: URL(string: "/")!, pngIconPaths: ["this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao"], hiddenFromSpringboard: false)] {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else {
                        // TODO: icons!
                        ForEach(apps) { app in
                            AppCell(imagePath: app.bundleURL.appendingPathComponent(app.pngIconPaths.first ?? "this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao").path, bundleid: app.bundleIdentifier, name: app.name)
                                .onAppear {
                                    print("===")
                                    print((app.bundleURL.appendingPathComponent(app.pngIconPaths.first ?? "this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao")).path)
                                    print(((app.bundleURL.appendingPathComponent(app.pngIconPaths.first ?? "this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao")).path).contains("this-app-does-not-have-an-icon-i-mean-how-could-anything-have-this-string-lmao"))
                                    print("=====")
                                    print(app.bundleURL)
                                    print("=======")
                                    print(app.pngIconPaths)
                                    print("=========")
                                }
                        }
                    }
                } header: {
                    Label("Apps", systemImage: "square.grid.2x2")
                } footer: {
                    // haha take that suslocation!
                    Text("You've come a long way, traveler. Have a :lungs:.\n🫁")
                }
            }
            .navigationTitle("Pick app")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Label("Close", systemImage: "xmark")
                    })
                }
            }.navigationBarTitleDisplayMode(.inline)
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { searchText in

                if !searchText.isEmpty {
                    apps = allApps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                } else {
                    apps = allApps
                }
            }
        }
        .onAppear {
            allApps = try! ApplicationManager.getApps()
            apps = allApps
        }
        .refreshable {
            allApps = try! ApplicationManager.getApps()
            apps = allApps
        }
    }
}

struct AppListView_Previews: PreviewProvider {
    static var previews: some View {
        AppListView()
    }
}
