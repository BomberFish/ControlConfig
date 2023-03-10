//
//  MainModuleView.swift
//  ControlConfig
//
//  Created by f1shy-dev on 14/02/2023
//

import Foundation
import SwiftUI

struct MainModuleView: View {
    @State private var showingAddNewSheet = false
    @State private var showingSettingsSheet = false
    @ObservedObject var customisations = CustomisationList.loadFromUserDefaults()
    @ObservedObject var appState = AppState.shared

    var body: some View {
        NavigationView {
            VStack {
                List {
//                    Section(header: Label("General Customisations", systemImage: "paintbrush.pointed")) {
                    Section(footer: Text("Re-ordering the fixed modules requires you click apply first, to make them 'movable.' Note that you have to re-order them like the other modules, in the control center section in Settings.")) {
                        NavigationLink {
                            EditCCColorsView(state: customisations.otherCustomisations, saveOCToUserDefaults: customisations.saveToUserDefaults)
                        } label: {
                            Label("Edit CC Colours", systemImage: "paintbrush")
                        }

                        Button {
                            if let url = URL(string: "App-Prefs:root=CONTROL_CENTER") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        } label: {
                            Label("Reorder modules", systemImage: "arrow.up.right.square")
                        }
                    }

                    if customisations.list.isEmpty {
                        Section(header: Label("Module Customisations", systemImage: "app.dashed"), footer: Text("You don't have any customisations, Press the \(Image(systemName: "plus.app")) button below to add one!")) {}
                    } else {
                        Section(header: Label("Module Customisations", systemImage: "app.dashed")) {
                            ForEach(customisations.list, id: \.module.bundleID) { item in

                                CustomisationCard(customisation: item, appState: appState, deleteCustomisation: customisations.deleteCustomisation, saveToUserDefaults: customisations.saveToUserDefaults) {
                                    customisations.objectWillChange.send()
                                }
                            }
                        }
                    }
                }
                .listRowInsets(.none)
            }
//            }
            .frame(maxWidth: .infinity)
            .navigationTitle("ControlConfig")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettingsSheet.toggle()
                    }, label: {
                        Label("Settings", systemImage: "gear")
                    }).sheet(isPresented: $showingSettingsSheet, onDismiss: {
                        appState.saveToUserDefaults()
                    }) {
                        SettingsView(appState: appState, customisations: customisations)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        print(customisations)
                        let success = applyChanges(customisations: customisations)
                        if success {
                            Haptic.shared.notify(.success)
                            UIApplication.shared.confirmAlert(title: "Applied!", body: "Please respring to see any changes.", onOK: {}, noCancel: true)
                        } else {
                            Haptic.shared.notify(.error)
                            UIApplication.shared.alert(body: "An error occurred when writing to the file(s). This might be due to custom width/heights, which might have made the file too large. Please try and re-arrange your custom width/heights first, and then try again, and if not, please report this to the developer.")
                        }
                    }, label: {
                        Label("Apply", systemImage: "seal")
                        Text("Apply")

                    })
//                    .disabled(
//                        customisations.list.filter { c in c.isEnabled }.isEmpty &&
//                            [customisations.otherCustomisations.moduleBlur, customisations.otherCustomisations.moduleBGBlur].allSatisfy { ($0 as Int?) == nil } &&
//                            [customisations.otherCustomisations.moduleColor, customisations.otherCustomisations.moduleBGColor].allSatisfy { ($0 as Color?) == nil }
//                    )

                    Spacer()

                    Button(action: {
                        Haptic.shared.play(.light)
                        showingAddNewSheet.toggle()
                    }, label: {
                        Label("Add Module", systemImage: "plus.app")

                    }).sheet(isPresented: $showingAddNewSheet) {
                        AddModuleView(customisations: customisations)
                    }

                    Spacer()

                    Button(action: {
                        MDC.respring(method: appState.useLegacyRespring ? .legacy : .frontboard)

                    }, label: {
                        Label("Respring", systemImage: "arrow.counterclockwise.circle")
                        Text("Respring")
                    })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainModule_Previews: PreviewProvider {
    static var previews: some View {
        MainModuleView()
    }
}
