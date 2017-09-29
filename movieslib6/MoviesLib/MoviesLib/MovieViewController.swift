//
//  ViewController.swift
//  MoviesLib
//
//  Created by Eric.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MovieViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var tvSinopsis: UITextView!
    @IBOutlet weak var lcButtonX: NSLayoutConstraint!
    @IBOutlet weak var viTrailer: UIView!
    
    //Variável que receberá o filme selecionado na tabela
    var movie: Movie!
    
    //o carinha q vai receber o filme q vai ser tocado
    var moviePlayer: AVPlayer!
    
    var moviePlayerController: AVPlayerViewController!
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVideo()
        
        //toda vez q carregar a tela, se estiver como autoplay ja carrega direto
        if UserDefaults.standard.bool(forKey: "autoplay") {
            changeMovieStatus(play: true)
        } else {
            
            //salvo a altura atual do poster
            let oldHeight = ivPoster.frame.size.height
            ivPoster.frame.size.height = 0
            
            //animacao
            //options = curvas de animacao
            UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
                
                self.ivPoster.frame.size.height = oldHeight
                
            }, completion: { (sucess) in
                print("Fim da animação: \(sucess)")
            })
        }
    }
    
    func prepareVideo() {
        let url = Bundle.main.url(forResource: "spiderman-trailer.mp4", withExtension: nil)!
        moviePlayer = AVPlayer(url: url)
        
        //essa classe eh um container, pegando os dados de uma classe e apresenta pra vc
        moviePlayerController = AVPlayerViewController()
        
        //passo o vide para esse controller
        moviePlayerController.player = moviePlayer
        
        //exibe os controler do video
        moviePlayerController.showsPlaybackControls = true
        
        //preencho a view com o conteudo desse video
        //bounds da a larg/altura e o x e y como 0, eh o frame interno
        moviePlayerController.view.frame = viTrailer.bounds
        
        //tirei a area da memoria e joguei na tela
        viTrailer.addSubview(moviePlayerController.view)
        
    }
    
    func changeMovieStatus(play: Bool) {
        viTrailer.isHidden = false
        
        if(play) {
            moviePlayer.play()
        } else {
            moviePlayer.pause()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTitle.text = movie.title
        lbDuration.text = movie.duration
        lbScore.text = "⭐️ \(movie.rating)/10"
        tvSinopsis.text = movie.summary
        if let categories = movie.categories {
            lbGenre.text = categories.map({($0 as! Category).name!}).joined(separator: " | ")
        }
        if let image = movie.poster as? UIImage {
            ivPoster.image = image
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieRegisterViewController {
            vc.movie = movie
        }
    }
    
    //Dessa forma, podemos voltar à tela anterior
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Super Methods
    @IBAction func playVideo(_ sender: UIButton) {
        
        sender.isHidden = true
        
        changeMovieStatus(play:true)
    }
    
}
