//
//  ViewController.swift
//  faBR
//
//  Created by Guilherme Sousa Abreu on 13/07/16.
//  Copyright © 2016 gabreuCo. All rights reserved.
//

import UIKit

struct Campeonato {
    let nome:String
    let id:Int
    let imagemCampeonato:String
    let ano:Int
}

class ViewController: UIViewController {
    
    //ibOutlet
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //variaveis
    var campeonato = Array<Campeonato>()
    var contentDictionary = NSMutableDictionary()
    var urlPath = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFirstPage()
        
        //tableview
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //Consumindo o webservice
    func loadFirstPage(){
        let url = NSURL(string: "http://gabreu.com/Fabr/index.php/campeonato")
        
        //carregamos os dados da internet
        if let data = NSData(contentsOfURL: url!){
            do{
                
                
                if let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                    self.urlPath  = jsonDict["urlPath"] as! String
                    if let listaCampeonato = jsonDict["campeonato"] as? NSArray{
                        for contentDictionary in listaCampeonato{
                            
                            
                            
                            self.campeonato.append(
                                
                                Campeonato(nome: contentDictionary["nomeCampeonato"] as! String,
                                    id:Int(contentDictionary["idCampeonato"] as! String)!,
                                    imagemCampeonato: contentDictionary["imagemCampeonato"] as! String,
                                    ano:Int(contentDictionary["Ano"] as! String)! )
                            )
                        }
                        
                    }
                    
                    
                }
                
                
            }catch{
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //preparo para enviar os dados para a proxima tela
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //verificando se estamos na view controller correta
        if let campVC = segue.destinationViewController as? CampeonatoViewController{
            
            //pegamos o indice selecionado na tableView
            if let selectedIndex = self.tableView.indexPathForSelectedRow{
                //pegamos o conteúdo referente ao indice
                let camp = self.campeonato[selectedIndex.row]
                //setamos este conteúdo na viewController
                campVC.camp = camp
            }
        }
        
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campeonato.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

         let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CampeonatoTableViewCell
            let campeonato = self.campeonato[indexPath.row]
            cell.campeonatoLabel.text = campeonato.nome
        
        let queue = dispatch_queue_create("bla", nil)
        
        dispatch_async(queue) {
            let pathCampeonato = "\(self.urlPath)\(campeonato.imagemCampeonato)"
            let imageCampeonato = UIImage(data:
                NSData(contentsOfURL:
                    NSURL(string: pathCampeonato)!)!)
            dispatch_async(dispatch_get_main_queue(), {
                
                
                cell.campeonatoImage.image = imageCampeonato
            })
        }
        
            
            return cell
        
        //}
        //else {
        //    print("Problemas nas celulas")
       // }
       // return (UITableViewCell())
    }
    
}


