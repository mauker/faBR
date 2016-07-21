//
//  CampeonatoViewController.swift
//  faBR
//
//  Created by Guilherme Sousa Abreu on 13/07/16.
//  Copyright © 2016 gabreuCo. All rights reserved.
//

import UIKit
import MBProgressHUD

struct Rodada {
    let rodada:Int
    var pontosVisitante, pontosMandante:Int
    let nomeVisitante, nomeMandante, imagemMandante, imagemVisitante:String
    let data:NSDate
    let week:String
}

class CampeonatoViewController: UIViewController {
    
    //ibOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //VAR
    var camp:Campeonato?
    var rodadas=Array<Rodada>()
    var rodadasByDate = [[Rodada]]()
    var urlPath = "";
    var contentDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = camp?.nome
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadRodadaPage()
    }
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Carregando..."
    }
    
    func hideLoadingHUD() {
        
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
    }
    
    func loadRodadaPage(){
        
        //IF Ternario "Condição" ? "Executa se true" : "Executa se FALSE"
        let url = (camp != nil) ? NSURL(string: "http://gabreu.com/Fabr/index.php/campeonato/\(camp!.id)/rodadas") : NSURL(string: "http://gabreu.com/Fabr/index.php/campeonato/rodadas/")
        
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.showLoadingHUD()
        
        dispatch_async(dispatch_queue_create("loadJSON", nil)) {
            
            //carregamos os dados da internet
            if let data = NSData(contentsOfURL: url!){
                
                do{
                    
                    
                    if let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                        
                        self.urlPath  = jsonDict["urlPath"] as! String
                        
                        if let listaRodada = jsonDict["rodadas"] as? NSArray{
                            
                            for content in listaRodada{
                                
                                var date = NSDate();
                                if let testRodadaData = content["dataPartida"] as? String{
                                    
                                    date = formater.dateFromString(testRodadaData)!
                                }
                                
                                
                                
                                self.rodadas.append(
                                    
                                    Rodada(rodada: Int((content["idRodada"] ?? "") as! String)!,
                                        pontosVisitante: Int((content["pontosVisitante"] ?? "") as! String)!,
                                        pontosMandante: Int((content["pontosMandante"] ?? "") as! String)!,
                                        nomeVisitante: (content["nomeVisitante"] ?? "") as! String,
                                        nomeMandante: (content["nomeMandante"] ?? "") as! String,
                                        imagemMandante: (content["imagemMandante"] ?? "") as! String,
                                        imagemVisitante: (content["imagemVisitante"] ?? "") as! String,
                                        data: date,
                                        week: (content["Week"] ?? "") as! String)
                                )
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    let formater = NSDateFormatter()
                    formater.dateFormat = "dd"
                    
                    var listByDate = [Rodada]()
                    
                    for (index, rodada) in self.rodadas.enumerate(){
                        
                        if index != 0 {
                            
                            if formater.stringFromDate(self.rodadas[index-1].data) != formater.stringFromDate(rodada.data){
                                self.rodadasByDate.append(listByDate)
                                listByDate = [Rodada]()
                            }
                        }
                        
                        listByDate.append(rodada)
                        
                        if index == self.rodadas.count-1 {
                            self.rodadasByDate.append(listByDate)
                        }
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.tableView.reloadData()
                        self.hideLoadingHUD()
                    })
                    
                }catch{
                    print(error)
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension CampeonatoViewController:UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.rodadasByDate.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.rodadasByDate[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let formater = NSDateFormatter()
        formater.dateFormat = "dd/MM/yyyy"
        
        let data = formater.stringFromDate(self.rodadasByDate[section][0].data)
        
        return "Dia \(data)"
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rodadaCell") as! RodadaTableViewCell
        
        let rodada = self.rodadasByDate[indexPath.section][indexPath.row]
        
        cell.nomeMandante.text = rodada.nomeMandante
        cell.nomeVisitante.text = rodada.nomeVisitante
        if rodada.pontosMandante == 0 {
            cell.pontosMandante.text = "00"
        }
        if rodada.pontosMandante < 10 {
            cell.pontosMandante.text = "0\(rodada.pontosMandante)"
            
        }else{
            
            cell.pontosMandante.text = "\(rodada.pontosMandante)"
        }
        if rodada.pontosVisitante == 0 {
            cell.pontosVisitante.text = "00"
        }
        if rodada.pontosVisitante < 10 {
            cell.pontosVisitante.text = "0\(rodada.pontosVisitante)"
            
        }else{
            
            cell.pontosVisitante.text = "\(rodada.pontosVisitante)"
        }
        
        cell.weekLabel.text = "\(rodada.week)"
        
        
        let queue = dispatch_queue_create("bla", nil)
        
        dispatch_async(queue) {
            let pathMandante = "\(self.urlPath)\(rodada.imagemMandante)"
            let imageMandante = UIImage(data:
                NSData(contentsOfURL:
                    NSURL(string: pathMandante)!)!)
            

            dispatch_async(dispatch_get_main_queue(), {
                
                cell.imageMandante.image = imageMandante
            })
            
        }
        
        
        
        dispatch_async(dispatch_queue_create("loadVisitante", nil)) {
        
            let pathVisitante = "\(self.urlPath)\(rodada.imagemVisitante)"
        
            let imageVisitante = UIImage(data:
                NSData(contentsOfURL:
                    NSURL(string: pathVisitante)!)!)
        
            dispatch_async(dispatch_get_main_queue(), {
            
                cell.imageVisitante.image = imageVisitante
            
            })
        
        }
        
        
        return cell
    }
    
    
}
