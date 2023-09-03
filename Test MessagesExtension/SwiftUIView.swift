import SwiftUI
import Messages


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

func sendVote (session: MSConversation?) {
    let alternateMessageLayout = MSMessageTemplateLayout()
    
    let messageLayout = MSMessageLiveLayout(alternateLayout: alternateMessageLayout)

    let message = MSMessage()
    
    if(session != nil){
        print("not nil")
    
    
        guard let components = NSURLComponents(string: "dogwatch.com") else {
            fatalError("Invalid base url")
        }
         
        let size = URLQueryItem(name: "Size", value: "Large")
        let count = URLQueryItem(name: "Topping_Count", value: "2")
        let cheese = URLQueryItem(name: "Topping_0", value: "Cheese")
        let pepperoni = URLQueryItem(name: "Topping_1", value: "Pepperoni")
        components.queryItems = [size, count, cheese, pepperoni]
         
        guard let url = components.url  else {
            fatalError("Invalid URL components.")
        }
        message.url = url

        message.layout = messageLayout
        


        session?.send(message) { (errorOrNil) in
            if let error = errorOrNil {
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
    
    var viewSize: MSMessagesAppPresentationStyle
    var activeSession: MSConversation?
    


   
    var body: some View {
        
    
        
        VStack {
            
            
            if(viewSize == .transcript){
                MultiDatePicker("Dates Available", selection: $dates)

            }
            if(viewSize == .compact){
                VoteResultsView()

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
                        print("Submit button tapped")
                        sendVote(session: activeSession)

                        }) {
                            Text("Submit")
                                           .font(.headline)
                                           .padding()
                                           .background(Color.blue)
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
            Text("Top Free Dates")
                        
            // Display vote results here
            VoteResultRow(candidateName: "Date A", voteCount: 120)
            VoteResultRow(candidateName: "Date B", voteCount: 95)
            VoteResultRow(candidateName: "Date C", voteCount: 78)
            VoteResultRow(candidateName: "Date D", voteCount: 64)
           
        }
    }
}

struct VoteResultRow: View {
    let candidateName: String
    let voteCount: Int
    
    var body: some View {
        HStack {
            Text(candidateName)
                .font(.body)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("\(voteCount) Votes")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
