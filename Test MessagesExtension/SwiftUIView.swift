import SwiftUI
import Messages
import Charts

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}

@MainActor func sendVote (session: MSConversation?, name: String) {
    let message = MSMessage()
    
       
    


    let layout = MSMessageTemplateLayout()
    
    layout.caption = name
    layout.subcaption = "0 / \(((session?.remoteParticipantIdentifiers.count ?? 1) + 1)) Votes"

    

    let renderer = ImageRenderer(content: VoteResultsView())


    if let uiImage = renderer.uiImage {
        // use the rendered image somehow
        layout.image = uiImage
        
    }
    
    
    if(session != nil){
        print("not nil")
        message.layout = layout
        session?.send(message) { (errorOrNil) in
            if errorOrNil != nil {
                // Handle the error here...
            }
        }
        
    }
    else{
        print("nillll")
        print(session.hashValue)
    }
    
    
}


struct ContentView: View {
    @State private var dates: Set<DateComponents> = []
    @State var eventName: String = ""
    
    var viewSize: MSMessagesAppPresentationStyle
    var activeSession: MSConversation?
    


   
    var body: some View {
        
    
        
        VStack {
            
            if(viewSize == .transcript){
                MultiDatePicker("Dates Available", selection: $dates)

            }
            if(viewSize == .compact){
                EventCreationView()

            }
            if(viewSize == .expanded){
                    VoteResultsView()

                    MultiDatePicker("Dates Available", selection: $dates)
                    
                    Spacer()
                               
                    HStack{
                        Button(action: {
                        // Add your submit button action here
                        print("Submit button tapped")

                        }) {
                            Text("Reset")
                                           .font(.headline)
                                           .padding()
                                           .background(Color.orange)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                        }
                        
                        Button(action: {
                        // Add your submit button action here
                        print("Vote count")
                        print(String(dates.count))

                        sendVote(session: activeSession, name: eventName)

                        }) {
                            Text("Submit")
                                           .font(.headline)
                                           .padding()
                                           .background(Color(#colorLiteral(red: 0.3333333433, green: 0.7568627596, blue: 0.7686274648, alpha: 1)))
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                        }
                        
                    
                }

            }
            
           
          
        }
    }
    
    private func formatDateComponent(_ dateComponent: DateComponents) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd--YY"
        
        if let date = Calendar.current.date(from: dateComponent) {
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}


struct VoteResultsView: View {
    var body: some View {
        VStack {
            Text("-").padding(.top, 10)
            // Display vote results here
            Chart(data) {
                    BarMark(
                        xStart: .value("Start Time", 0),
                        xEnd: .value("End Time", $0.count),
                        y: .value("Job", $0.date)
                    ).opacity(0.7)
                    .foregroundStyle(Color(#colorLiteral(red: 0.3333333433, green: 0.7568627596, blue: 0.7686274648, alpha: 1)))
            }.padding(10)
        }.frame(minWidth: 400)

    }
}

struct Vote : Identifiable {
    let id: UUID
    let date: String
    let count: Int
}

let data: [Vote] = [
    Vote(id: UUID(), date: "January 16", count: 5),
    Vote(id: UUID(), date: "January 13", count: 3),
    Vote(id: UUID(), date: "January 12", count: 2)
]


struct EventCreationView: View {
    @State var eventName: String = ""
    @State private var selectedDay = 1 // Default selection
    @State private var selectedTab = 1
    
    var body: some View {
        VStack {
            TextField("Create New Event", text: $eventName)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
            
            TabView(selection: $selectedTab) {
                Text("1 Day").padding(.bottom, 60)
                    .tabItem {
                        Image(systemName: "1.circle").foregroundColor(.red)
                    }
                    .tag(1)
                
                Text("2 Day").padding(.bottom, 60)
                    .tabItem {
                        Image(systemName: "2.circle").foregroundColor(.red)
                    }
                    .tag(2)
                Text("3 Day").padding(.bottom, 60)
                    .tabItem {
                        Image(systemName: "3.circle").foregroundColor(.red)
                    }
                    .tag(3)
                
                Text("4 Day").padding(.bottom, 60)
                    .tabItem {
                        Image(systemName: "4.circle").foregroundColor(.red)
                    }
                    .tag(4)
                
                Text("5 Day").padding(.bottom, 60)
                    .tabItem {
                        Image(systemName: "5.circle").foregroundColor(.red)
                    }
                    .tag(5)
                
            }.accentColor(Color(#colorLiteral(red: 0.3333333433, green: 0.7568627596, blue: 0.7686274648, alpha: 1)))
            
            Spacer()
            
            Button(action: {
                // Handle the submission of the event name and selected day here
                print("Event Name: \(eventName)")
                print("Selected Day: \(selectedDay)")
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Make the button full width
                    .padding()
                    .background(Color(#colorLiteral(red: 0.3333333433, green: 0.7568627596, blue: 0.7686274648, alpha: 1)))
                    .cornerRadius(0) // Remove corner radius to make it thinner
            }
            .background(Color.blue) // Add background color to fill full width
            .padding(0) // Remove padding to make it thinner
            
            Spacer()
        }.padding(.horizontal, 10)
            .navigationBarTitle("Create Event")
    }
}
