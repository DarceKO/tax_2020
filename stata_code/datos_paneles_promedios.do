
// preeliminar: aproximado a panel balanceado
// ajustes en numero de ciudades
// ajustes en total de marcas
// para algunas especificaciones se considerarian solo ciudades principales

capture log close
log using resultados/paneles_promedio.log, replace

use datos\tpCiudad2.dta, clear 
* dos variables para marca2 y marca

*gen ciudades_18 = cve_ciudad > 46
drop if cve_ciudad > 46

*gen marca_3 = marca == 3
*drop if marca == 3

collapse (mean) m1 m1_20 INPPsec_nopetro INPCgen m_df_p ppu pp /// 
	pp_lt_cerveza m_otro_, by(ym marca2)
xtset marca2 ym 

*collapse (mean) m1 m1_20 INPPsec_nopetro INPCgen m_df_p ppu pp /// 
*	pp_lt_cerveza m_otro_, by(ym marca2)
*xtset marca ym 
decode marca2, gen(marca2_str)
do stata_code/marca_marca2.do

save datos\xt_marca.dta, replace

* xtline ppu // promedios por ciudad

use datos\tpCiudad2.dta, clear

*gen ciudades_18 = cve_ciudad > 46
drop if cve_ciudad > 46

*gen marca_3 = marca == 3
*drop if marca == 3

collapse (mean) m1 m1_20 INPPsec_nopetro INPCgen m_df_p ppu pp pp_lt_cerveza ///
	m_otro_, by(ym cve_ciudad)

xtset cve_ciudad ym 

/*relación de ciudades*/

save datos\xt_ciudad.dta, replace

xtline ppu

use datos\tpCiudad2.dta, clear

drop if cve_ciudad > 46
*drop if marca == 3

*gen l_ppu = log(ppu)
egen gr_marca2_ciudad = group(marca2 cve_ciudad)
xtset gr_marca2_ciudad ym 

gen dppu = d.ppu

save datos\panel_marca2_ciudad.dta, replace
export excel using "datos\panel_marca2_ciudad.xlsx", replace

use datos\panel_marca2_ciudad.dta, clear

egen gr_marca_ciudad = group(marca cve_ciudad)
duplicates report gr_marca_ciudad ym

collapse (mean) m1 m1_20 INPPsec_nopetro INPCgen m_df_p ppu pp pp_lt_cerveza ///
	m_otro_, by(ym marca cve_ciudad gr_marca_ciudad)

xtset gr_marca_ciudad ym 

save datos\panel_marca_ciudad.dta, replace
export excel using "datos\panel_marca_ciudad.xlsx", replace

use datos\panel_marca_ciudad.dta, clear

* promedio  elimina year, month, Periodo, tipo, marca_str, marca2_str, dppu
drop  INP* pp_lt_cerveza m_df_p m_otro_precio 
 

* solo ciudades con 118 observaciones (panel completo)
*egen s_gr_m_ciudad= total(1), by(gr_)
*keep if s_ == 118

gen d_ppu = d.ppu
gen lag_ppu = L.ppu
gen lagd_ppu = L.d.ppu

drop gr_

* promedio elimina: l_*, pzas, sd_*
reshape wide d_ lag_ lagd_  pp ppu  , i(ym cve_ciudad) j(marca) 
* cómo se podría elegir solo las ciudades con mayor número de marcas?
* egen s_gr_m_ciudad= total(1), by(gr_)
* reshape wide l_ pp ppu pzas sd_* cve_ciudad marca, i(ym) j(gr_)

xtset cve_ciudad ym

/* claves de ciudad */

save datos/wide_complete_panel.dta, replace
* inicial: febrero 2021 tiene 5 marcas 1,2,5,6,7
