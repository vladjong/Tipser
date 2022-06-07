//
//  ContentView.swift
//  Tipser
//
//  Created by Владислав Гайденко on 07.06.2022.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var percentTip = 0.0
    @State private var bill = 0
    @State private var characterLimit = 7
    @FocusState private var amountIsFocused: Bool

    var totalPercent: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(percentTip)
        let orderAmount = Double(checkAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
        let value = orderAmount * tipSelection / 100
        let grandTotal = orderAmount + value
        let amountPerson = grandTotal / peopleCount
        return amountPerson
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                RiveViewModel(fileName: "RiveAssets/shapes").view()
                    .ignoresSafeArea()
                    .blur(radius: 30)
                    .background(
                        Image("Spline")
                            .blur(radius: 50)
                            .offset(x: 200, y: 100)
                        )
                Form {
                    Section {
                        TextField("Amount",text: $checkAmount)
                            .frame(height: 100, alignment: .center)
                            .multilineTextAlignment(.center)
                            .font(.system(size:54, weight: .semibold, design: .monospaced))
                            .foregroundColor(CustomColor.black)
                            .shadow(color: Color(.systemCyan), radius: 20, x: -20, y: -20)
                            .onChange(of: checkAmount, perform: { _ in
                                if checkAmount.count > characterLimit {
                                    let limitedText = checkAmount.dropLast()
                                    checkAmount = String(limitedText)
                                }
                            })
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                        Picker("Number of people", selection: $numberOfPeople) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                            .font(.system(size:18, weight: .regular, design: .monospaced))
                        }
                        .font(.system(size:18, weight: .light, design: .monospaced))
                        .foregroundColor(CustomColor.black)
                    }
                    .listRowBackground(Color.clear)
                    Section(header: Text("Tip percentage")) {
                        CustomPicker(selected: self.$percentTip)
                    }
                    .font(.system(size:20, weight: .light, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                    Section(header: Text("Total amount")) {
                        Text("\(totalPercent, specifier: "%.2f")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 100, alignment: .center)
                            .font(.system(size:44, weight: .semibold, design: .monospaced))
                            .foregroundColor(CustomColor.black)
                            .shadow(color: .blue, radius: 20, x: -20, y: -20)
                    }
                    .font(.system(size:20, weight: .light, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                }
                .navigationBarItems(leading: Image("tiper_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center))
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Done") {
                            amountIsFocused = false
                        }
                        .font(.system(size:18, weight: .light, design: .monospaced))
                        .foregroundColor(CustomColor.black)
                    }
                }
            }
        }
    }
}

struct CustomColor {
    static let black = Color("MyBlack")
    static let gray = Color("MyGray")
    static let blue = Color("MyBlue")
}

let tipPercent = [0 ,5, 10, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100]

struct CustomPicker: UIViewRepresentable {
    
    @Binding var selected : Double

    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.backgroundColor = .clear
        picker.selectRow(3, inComponent: 0, animated: true)
        return picker
    }
    
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(parent1: self)
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }
    
    class Coordinator : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        
        var parent: CustomPicker
        
        init(parent1 : CustomPicker) {
            parent = parent1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return tipPercent.count
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 60))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = "\(tipPercent[row]) %"
            label.textColor = .white
            label.textAlignment = .center
            label.font = .monospacedSystemFont(ofSize: 22, weight: .bold)
            view.backgroundColor = UIColor(CustomColor.blue)
            view.addSubview(label)
            label.clipsToBounds = true
            view.layer.cornerRadius = 4
            return view
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width - 100
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = Double(tipPercent[row])
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
