import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var audio = WaveformAudio(audioFile: try! AVAudioFile(forReading: AudioResources.aberration))!
    
    @State var start: Double = 0
    @State var end: Double = 1
    
    @State var isShowingDebug = true
    
    var body: some View {
        VStack {
            Waveform(audio: audio)
                .environmentObject(audio)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                .cornerRadius(15)
            
            HStack {
                Text("Debug:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                Spacer()
                Button { withAnimation { isShowingDebug.toggle() } } label: {
                    Image(systemName: isShowingDebug ? "chevron.down.circle" : "chevron.up.circle" )
                }
            }
            if isShowingDebug {
                VStack {
                    Slider(value: $start, in: 0...1)
                    Slider(value: $end, in: 0...1)
                }
                .transition(.offset(x: 0, y: 100))
            }
        }
        .padding()
        .onChange(of: start) {
            let sample = Int($0 * Double(audio.audioFile.length))
            let startSample = sample < audio.renderSamples.upperBound ? sample : audio.renderSamples.upperBound - 1
            audio.renderSamples = startSample...audio.renderSamples.upperBound
        }
        .onChange(of: end) {
            let sample = Int($0 * Double(audio.audioFile.length))
            let endSample = sample > audio.renderSamples.lowerBound ? sample : audio.renderSamples.lowerBound + 1
            audio.renderSamples = audio.renderSamples.lowerBound...endSample
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
