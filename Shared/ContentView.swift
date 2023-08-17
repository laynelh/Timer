//
//  ContentView.swift
//  Shared
//
//  Created by Layne Hunt on 2/23/21.
//

import SwiftUI

struct ContentView: View {
    //I found an explaination for this .onRecieve code, as well as the ClockView code from the website: https://marcgg.com/blog/2020/05/06/circular-progressbar-clock-swiftui/
    
    @State var timerOn: Bool = false
    @State var showAlert = false
    @State var counter: Int = 0
    @State var alertTitle = "TWENTY MINUTES LEFT"
    var countTo: Int = 1500
    var fiveMinuteWarning: Int = 300
        
        var body: some View {
            VStack{
                VStack {
                    
                    
                    //I thought this would be a good opportunity to add to my previous timer app with a circular progress bar that is animated! I found the code for specific circle functions like fill(color.clear), the .trim code and the .overlay code from this website:https://marcgg.com/blog/2020/05/06/circular-progressbar-clock-swiftui/
                    
                    
                    
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 250, height: 250)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 5)
                                    .opacity(0.6)
                            )
                        Circle()
                                    .fill(Color.clear)
                            .frame(width: 250, height: 250)
                            .overlay(
                                Circle().trim(from:0, to: (CGFloat(counter) / CGFloat(countTo)))
                                    .stroke(
                                        style: StrokeStyle(
                                            lineWidth: 15,
                                            lineCap: .round,
                                            lineJoin:.round
                                        )
                                    )
                                    .foregroundColor(Color.purple)
                            )
                            .animation(.easeInOut(duration: 0.8))
                        
                        
                        
                        
                        
                        ClockView(counter: counter, countTo: countTo)
                    }
                    Button(action: {
                        timerOn.toggle()
                    }) {
                        StartButtonView()
                    }
                }
                //this onRecieve code basically allows for the app to update the time accurately each second. This is thanks to the timer code I placed outside of this struct.
            }.onReceive(timer) { time in
                if (self.counter < self.countTo) && self.timerOn {
                    self.counter += 1
                }
                if counter == 1200 {
                    self.alertTitle = "FIVE MINUTES REMAINING"
                    self.showAlert.toggle()
                }
                if counter == 900 {
                    self.alertTitle = "TEN MINUTES REMAINING"
                    self.showAlert.toggle()
                }
                if counter == 300 {
                    self.alertTitle = "TWENTY MINUTES REMAINING"
                    self.showAlert.toggle()
                }
                if counter == 1500 {
                    self.alertTitle = "TIMER COMPLETED"
                    self.showAlert.toggle()
                }
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text(alertTitle).font(Font.title.weight(.light)))
            }
        }
}

//I want to save this code and incorperate it into the project later on
//struct PointsView: View {
//    var points: Int = 0
//    var body: some View {
//        VStack {
//        Text("Points: \(points)")
//        }
//    }
//}

//this code ensures that each second the code has updated itself (establishes the metronome effect)
let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct ClockView: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        VStack {
            Spacer()
            if counter == 0 {
                Text(counterToMinutes())
                    .font(.system(size: 60))
                    .fontWeight(.black)
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("25 Minutes"))
                Spacer()
            } else {
                Text(counterToMinutes())
                    .font(.system(size: 60))
                    .fontWeight(.black)
                    .accessibilityElement(children: .ignore)
                Spacer()
            }
        }
    }
    
    //this function shifts the number of seconds inputed in the content view (which for this MVP(7) app will always be 1500 or 25 minutes) into the correct format of minutes and seconds remaining in the timer
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
}

struct StartButtonView: View {
    var body: some View {
        Text("START TIMER")
            .background(
                Capsule()
                    .foregroundColor(.black)
                    .frame(width: 300, height: 100, alignment: .center)
            )
            .foregroundColor(.white)
            .font(.system(size: 40, weight: .black))
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
