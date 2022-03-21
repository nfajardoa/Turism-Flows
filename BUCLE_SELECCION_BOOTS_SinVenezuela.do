clear all
set more off
cap log close
* Insert where you copied data excel file between two quotation marks below 
* cd "D:\users\NRO\DEPE\TURISMO\"
* cd "C:\Users\Lenovo Pc\Desktop\Turismo"
* cd "D:\Nicolas_Fajardo\Proyectos\Turismo"
cd "C:\Users\USR_PracticanteGT42\Documents\DSGE_Ferroni\Nicolas Fajardo\Turismo"
* cd "W:\Nicolas Fajardo\Turismo"
import excel using "base_datos_27Abril2018.xlsx", sheet("base_2000-2017") firstrow clear

drop indicador paisorigen

encode abrev_pais, gen(pais_num)
xtset pais_num year

label data 							"Panel Turismo (20 Paises)"
label variable  year           		"A�o"
label variable  dist           		"Distancia desde pais origen"
label variable  vuelo          		"Numero de vuelos"
label variable  itcr         		"Indice de Tasa de Cambio Real (Banrep)"
label variable  comercio_usd_2010   "Cantidad de comercio en dolares constantes del 2010"
label variable  comercio_kg         "Cantidad de comercio en kg"
label variable  no_resid_pais       "Numero de turistas no residentes"
label variable  habs	            "Numero habitaciones"
label variable  habs_1	            "Numero habitaciones (t-1)"
label variable  Part_col			"Porcentaje de turistas colombianos"
label variable  giros_remesas		"Numero de giros por remesas"
label variable  no_resid           	"Numero total de turistas no residentes"
label variable  itcrt 				"ITCR ponderado por Turismo (Nicolas)"
label variable  pib	                "PIB Pais"
label variable  calc_grow_pib		"Creci. PIB (Calculado)"
label variable  grow_pib			"Creci. PIB (WEO)"
label variable  diff				"Diferencia Creci. PIB (Calculado - WEO)"
label variable  clima				"Indice de Clima por Población"
label variable  pais_num			"Numero de identificacion"

label define PAIS_cod 1 "Argentina" 2 "Brasil" 3 "Canada" 4	"Suiza" 5 "Chile" 6 "Cta Rica" 7 "Alemania" 8 "Dominicana" 9 "Ecuador" 10 "Espana" 11 "Francia" 12 "GranBret." 13 "Gtemala" 14 "Italia" 15 "Mexico" 16 "Panama" 17 "Peru" 18 "PtoRico" 19 "USA" 20 "Venez."

generate region =.
label define region 1 "Suramérica" 2 "Norteamérica" 3 "Europa" 4 "Caribe", replace
replace region=1 if pais_num<=2 | pais_num==5  | pais_num==9  | pais_num==17 | pais_num==17 | pais_num==20
replace region=2 if pais_num==3 | pais_num==15 | pais_num==19
replace region=3 if pais_num==4 | pais_num==7  | pais_num==10 | pais_num==11 | pais_num==12 | pais_num==14
replace region=4 if pais_num==6 | pais_num==8  | pais_num==13 | pais_num==16 | pais_num==18

label variable  region				"Region a la que pertenece el pais de origen"

gen l_no_resid_pais  	= ln(no_resid_pais)
* gen dl_no_resid 		= l_no_resid_pais - l_no_resid_pais[_n-1]  
gen l_dist      		= ln(dist)
gen l_pib       		= ln(pib)
gen l_pib_col      		= ln(pib_col)
gen l_itcrt      		= ln(itcrt) 
gen l_itcrbinv      	= ln(ITCRBinv) 

gen l_itcr      		= ln(itcr) 
gen l_comer_kg     		= ln(comercio_kg) 
gen l_giro_rem          = ln(giros_remesas)
gen l_comercio_usd_2010 = ln(comercio_usd_2010)
gen l_sillas            = sillas[_n-1]
gen ll_sillas            = ln(l_sillas)
gen l_vuelo       			= ln(vuelo)
*gen ln_sillas      		 = ln(sillas)
gen l_comercio_kg      		= ln(comercio_kg) 
gen l_habs       			= ln(habs)
gen l_habs_1      			= ln(habs_1) 
gen l_Part_col      		= ln(Part_col)
gen l_giros_remesas       	= ln(giros_remesas)
gen l_no_resid      		= ln(no_resid) 
gen l_calc_grow_pib      	= ln(calc_grow_pib)
gen l_grow_pib      		= ln(grow_pib)
gen l_diff      			= ln(diff)
gen l_clima      			= ln(clima)
gen l_turis_e 			= ln(turista_extr)
gen l_turis_col 			= ln(turista_col)
gen lsp                  = ln(sp) 
gen lspex                  = ln(spex)
sort pais_num 
by pais_num: gen ll_no_resid_pais   	= l_no_resid_pais[_n-1]
by pais_num: gen ll_turis_col 			= l_turis_col[_n-1]
by pais_num: gen ll_turis_e 	   		= l_turis_e[_n-1]
by pais_num: gen ll_giro_rem 			= l_giro_rem[_n-1]

label variable  l_dist           		"ln Distancia pais origen"
label variable  l_vuelo          		"Numero de vuelos"
label variable  l_sillas     		"Numero sillas(t-1)"
label variable  ll_sillas     		"ln Numero sillas(t-1)"
label variable  l_itcr         			"ln Ind. Tasa Cambio Real(BR)"
label variable  l_comercio_usd_2010   	"ln Comercio en dolares ctes de 2010"
label variable  l_comercio_kg         	"ln Comercio en kg"
label variable  l_no_resid_pais       	"ln Numero de turistas no residentes"
label variable  l_habs	            	"ln Numero de habitaciones"
label variable  l_habs_1	            "ln Numero de habitaciones(t-1)"
label variable  l_Part_col				"Porcentaje de turistas colombianos"
label variable  l_giros_remesas			"Numero de remesas"
label variable  l_no_resid          	"Distancia entre el pais de origen y Colombia"
label variable  l_itcrt 			"ITCR ponderado por Turismo (Nicolas)"
label variable  l_pib	            "ln PIB Pais"
label variable  l_calc_grow_pib		"Creci. PIB (Calculado)"
label variable  l_grow_pib			"Creci. PIB (WEO)"
label variable  l_diff				"Diferencia Creci. PIB (Calculado - WEO)"
label variable  l_clima				"Indice de Clima por Población"
label variable  ll_no_resid_pais		"ln(turistas(t-1))"	
label variable  l_turis_e  			"ln(turistas extr.)"
label variable  ll_turis_e  			"ln(turistas extr.(t-1))"
label variable  l_turis_col 			"ln(turistas colom.)"	
label variable  ll_turis_col 			"ln(turistas colom.(t-1))"	
label variable  ll_giro_rem		"Numero de remesas(t-1)"
label variable  lspex     "ln Prec. Sustit."
label variable  l_itcrbinv  " ln ITCR bil. iniv."

tsset pais_num year

**** TURISTAS NO RESIDENTES ****
*** DEFINICION DE LAS VARIABLES ***

gen start_year 				= 2000
gen fcst_year 				= 2017
gen count					= 1
global s_year 				= start_year
global f_year 				= fcst_year

*global xtendog "l_no_resid_pais"
*global xtendog "l_turis_col"
global xtendog "l_turis_e"

global xtmodels ""l_pib l_dist" "l_pib l_dist l_itcr" "l_pib l_dist l_itcrbinv lspex""
global xtmodels1 ""l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010""
global xtmodels2 ""l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 conflicto" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 conflicto""
global xtmodels3 ""l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 conflicto l_habs_1" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 conflicto l_habs_1""
global xtmodels4 ""l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_sillas" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_sillas" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_sillas" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 conflicto l_sillas" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 conflicto l_sillas""
global xtmodels5 ""l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 conflicto l_habs_1 l_sillas""

global xtconst  "l_dist"
global counter 	= 1

*** BUCLE ***
set matsize 600

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' if ${s_year}<=year & year<=${f_year} & pais_num < 20, endog(${xtendog}) constant(${xtconst})  small  vce(boots, reps(1000))
outreg2 using Estimates_small_19paises_bootstrap_${xtendog}_${s_year}_${f_year}_07-06-2018.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas) dec(2) 
replace count 		= count + 1
global counter 		= count
}

foreach x of global xtmodels1{

xthtaylor ${xtendog} `x' if ${s_year}<=year & year<=${f_year} & pais_num < 20, endog(${xtendog}) constant(${xtconst})  small  vce(boots, reps(1000))
outreg2 using Estimates_small_19paises_bootstrap_${xtendog}_${s_year}_${f_year}_07-06-2018.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas) dec(2) 
replace count 		= count + 1
global counter 		= count
}

foreach x of global xtmodels2{

xthtaylor ${xtendog} `x' if ${s_year}<=year & year<=${f_year} & pais_num < 20, endog(${xtendog}) constant(${xtconst})  small  vce(boots, reps(1000))
outreg2 using Estimates_small_19paises_bootstrap_${xtendog}_${s_year}_${f_year}_07-06-2018.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas) dec(2) 
replace count 		= count + 1
global counter 		= count
}

foreach x of global xtmodels3{

xthtaylor ${xtendog} `x' if ${s_year}<=year & year<=${f_year} & pais_num < 20, endog(${xtendog}) constant(${xtconst})  small  vce(boots, reps(1000))
outreg2 using Estimates_small_19paises_bootstrap_${xtendog}_${s_year}_${f_year}_07-06-2018.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas) dec(2) 
replace count 		= count + 1
global counter 		= count
}

foreach x of global xtmodels4{

xthtaylor ${xtendog} `x' if ${s_year}<=year & year<=${f_year} & pais_num < 20, endog(${xtendog}) constant(${xtconst})  small  vce(boots, reps(1000))
outreg2 using Estimates_small_19paises_bootstrap_${xtendog}_${s_year}_${f_year}_07-06-2018.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas) dec(2) 
replace count 		= count + 1
global counter 		= count
}

foreach x of global xtmodels5{

xthtaylor ${xtendog} `x' if ${s_year}<=year & year<=${f_year} & pais_num < 20, endog(${xtendog}) constant(${xtconst})  small  vce(boots, reps(1000))
outreg2 using Estimates_small_19paises_bootstrap_${xtendog}_${s_year}_${f_year}_07-06-2018.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas) dec(2) 
replace count 		= count + 1
global counter 		= count
}

xtline dist_w_0,  byopts(yrescale style(mlabsize(small) lwidth(1)) graphregion(fcolor(white)) plotregion(lcolor(white) fcolor(white) margin(r=10)) ///
title("Factor de conversión de PPA") subtitle("Suramérica (2005 - 2016)") note("*Unidad de Moneda Local por 1000 COP")) i(pais_num) t(year) xlabel(2005(5)2016, labcolor(gs8) ///
tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15)) graphregion(margin(r=6 l=2 t=2 b=2)) xtitle("", size(vsmall)) ytitle("" , size(vsmall)) ///
ylabel(#10, labcolor(gs8) tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15) labsize(small) angle(horizontal))

xtline w_0_dist,  byopts(yrescale style(mlabsize(small) lwidth(1)) graphregion(fcolor(white)) plotregion(lcolor(white) fcolor(white) margin(r=10)) ///
title("Distancia ponderada por PIB")) i(pais_num) t(year) xlabel(2005(5)2016, labcolor(gs8) ///
tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15)) graphregion(margin(r=6 l=2 t=2 b=2)) xtitle("", size(vsmall)) ytitle("" , size(vsmall)) ///
ylabel(#10, labcolor(gs8) tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15) labsize(small) angle(horizontal))
graph export w_0_dist.png


xtline w_dist,  byopts(yrescale style(mlabsize(small) lwidth(1)) graphregion(fcolor(white)) plotregion(lcolor(white) fcolor(white) margin(r=10)) ///
title("Distancia ponderada por PIB inverso")) i(pais_num) t(year) xlabel(2005(5)2016, labcolor(gs8) ///
tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15)) graphregion(margin(r=6 l=2 t=2 b=2)) xtitle("", size(vsmall)) ytitle("" , size(vsmall)) ///
ylabel(#10, labcolor(gs8) tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15) labsize(small) angle(horizontal))
graph export w_dist.png

xtline dist_alt,  byopts(yrescale style(mlabsize(small) lwidth(1)) graphregion(fcolor(white)) plotregion(lcolor(white) fcolor(white) margin(r=10)) ///
title("Distancia ponderada alternativa")) i(pais_num) t(year) xlabel(2005(5)2016, labcolor(gs8) ///
tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15)) graphregion(margin(r=6 l=2 t=2 b=2)) xtitle("", size(vsmall)) ytitle("" , size(vsmall)) ///
ylabel(#10, labcolor(gs8) tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15) labsize(small) angle(horizontal))
graph export dist_alt.png

xtline dist_w, i(pais_num) t(year) 
xtline dist_w_0, i(pais_num) t(year)  ///
xlabel(2005(5)2017, labcolor(gs8) tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15)) graphregion(margin(r=6 l=2 t=2 b=2)) xtitle("", size(vsmall)) ytitle("Millones" , size(vsmall)) ///
ylabel(#10, labcolor(gs8) tlcolor(gs5) grid glwidth(0.0001) glcolor(gs15) labsize(small) angle(horizontal))  graphregion(fcolor(white)) plotregion(fcolor(white) margin(r=10)) legend(on  region(lcolor(white)) rows(2))

