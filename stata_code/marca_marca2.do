// gen marca desde marca2

gen marca = marca2_str

replace marca = "PALL MALL" if marca2_ == "xBOOTS" 
replace marca = "CHESTERFIELD" if marca2_ == "yDELICADOS" 
replace marca = "LUCKY STRIKE" if marca2_ == "wRALEIGH" 
replace marca = "MONTANA" if marca2_ == "zSHOTS" 

rename marca marca_str
encode marca_str, gen(marca)
