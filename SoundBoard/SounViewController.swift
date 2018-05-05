//
//  SounViewController.swift
//  SoundBoard
//
//  Created by Mac Tecsup on 2/05/18.
//  Copyright © 2018 Mac Tecsup. All rights reserved.
//

import UIKit
import AVFoundation

class SounViewController: UIViewController {
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder(){
        
        do{
           // creando una sesion de audio
           let session = AVAudioSession.sharedInstance()
           try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
           try session.overrideOutputAudioPort(.speaker)
           try session.setActive(true)
            
           // creando una direccion para el archivo de audio
           let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                       .userDomainMask, true).first!
           let pathComponents = [basePath, "audio.m4a"]
           audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
           print("********************")
           print(audioURL)
           print("********************")
            
           // crear opciones para el grabador de audio 
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
           // crear el objeto de grabaciones de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
                print(error)
            }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording{
        
        //detener la grabacion 
            audioRecorder?.stop()
        //cambia el texto del boton grabar
            recordButton.setTitle("Recor", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
        //empezar a grabar
            audioRecorder?.record()
        //cambiar
            recordButton.setTitle("Stop", for: .normal)
        
        }
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOf:audioURL!)
            audioPlayer!.play()
            
        }
        catch{}
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context:context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
