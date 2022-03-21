clear all
set more off
cap log close
* Insert where you copied data excel file between two quotation marks below 
cd "D:\users\NRO\DEPE\TURISMO\"
* cd "C:\Users\Lenovo Pc\Desktop\Turismo"
* cd "D:\Nicolas_Fajardo\Proyectos\Turismo"
import excel using "base_datos_27Abril2018.xlsx", sheet("base_2000-2017") firstrow clear

drop indicador paisorigen

encode abrev_pais, gen(pais_num)
xtset pais_num year

label data 							"Panel Turismo (20 Paises)"
label variable  year           		"A駉"
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
label variable  clima				"Indice de Clima por Poblaci贸n"
label variable  pais_num			"Numero de identificacion"

label define PAIS_cod 1 "Argentina" 2 "Brasil" 3 "Canada" 4	"Suiza" 5 "Chile" 6 "Cta Rica" 7 "Alemania" 8 "Dominicana" 9 "Ecuador" 10 "Espana" 11 "Francia" 12 "GranBret." 13 "Gtemala" 14 "Italia" 15 "Mexico" 16 "Panama" 17 "Peru" 18 "PtoRico" 19 "USA" 20 "Venez."

generate region =.
label define region 1 "Suram茅rica" 2 "Norteam茅rica" 3 "Europa" 4 "Caribe", replace
replace region=1 if pais_num<=2 | pais_num==5  | pais_num==9  | pais_num==17 | pais_num==17 | pais_num==20
replace region=2 if pais_num==3 | pais_num==15 | pais_num==19
replace region=3 if pais_num==4 | pais_num==7  | pais_num==10 | pais_num==11 | pais_num==12 | pais_num==14
replace region=4 if pais_num==6 | pais_num==8  | pais_num==13 | pais_num==16 | pais_num==18

label variable  region				"Region a la que pertenece el pais de origen"

gen l_no_resid_pais  	= ln(no_resid_pais)
gen ll_no_resid_pais   	= l_no_resid_pais[_n-1]
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
gen ll_giro_rem 			= l_giro_rem[_n-1]
gen l_no_resid      		= ln(no_resid) 
gen l_calc_grow_pib      	= ln(calc_grow_pib)
gen l_grow_pib      		= ln(grow_pib)
gen l_diff      			= ln(diff)
gen l_clima      			= ln(clima)
gen l_turis_e 			= ln(turista_extr)
gen l_turis_col 			= ln(turista_col)
gen ll_turis_col 			= l_turis_col[_n-1]
gen ll_turis_e 	   		    = l_turis_e[_n-1]
gen lsp                  = ln(sp) 
gen lspex                  = ln(spex) 

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
label variable  l_clima				"Indice de Clima por Poblaci贸n"
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

gen fcst_year 				= 2017
gen count					= 1
global f_year 				= fcst_year

global xtendog "l_no_resid_pais"
*global xtendog 	"l_turis_col"
*global xtendog "l_turis_e"
* /* sin logs */ global xtmodels	""l_pib l_dist" "l_pib l_dist l_itcr" "l_pib l_dist l_itcrbinv  lspex" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto habs_1"  "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_sillas habs_1" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto habs_1 l_sillas" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto habs_1 l_sillas" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_sillas""
* /* sin log (sillas) */ global xtmodels	""l_pib l_dist" "l_pib l_dist l_itcr" "l_pib l_dist l_itcrbinv  lspex" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1"  "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_sillas l_habs_1" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 l_sillas" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_sillas""
* /* sin logs (habs) */ global xtmodels	""l_pib l_dist" "l_pib l_dist l_itcr" "l_pib l_dist l_itcrbinv  lspex" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto habs_1"  "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas habs_1" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto habs_1 ll_sillas" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto habs_1 ll_sillas" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas""
* LA LISTA FINAL P腞A VIERNES !! de Mayto de 2018
*global xtmodels	""l_pib l_dist" "l_pib l_dist l_itcr" "l_pib l_dist l_itcrbinv  lspex" "l_pib l_dist l_itcrbinv lspex l${xtendog} l_comercio_usd_2010" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1"  "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas l_habs_1" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas" "l_pib l_dist l_itcr l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas" "l_pib l_dist l_itcrbinv lspex l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas" "l_pib l_dist l_itcrbinv l${xtendog} lspex l_comercio_usd_2010 ll_giro_rem conflicto""
global xtmodels	""l_pib l_dist l_itcrbinv  lspex" "l_pib l_dist l_itcrbinv l${xtendog} lspex l_comercio_usd_2010 ll_giro_rem conflicto""
* LA LISTA FINAL P腞A VIERNES !! de Mayto de 2018
*global xtmodels	""l_pib l_dist" "l_pib l_dist l_itcrbinv lspex" "l_pib l_dist l_itcr l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas" "l_pib l_dist l_itcrbinv l${xtendog} lspex l_comercio_usd_2010 ll_giro_rem conflicto ll_sillas""
global xtconst  "l_dist"
global counter 	= 1

*** BUCLE ***
set matsize 600

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' if 2000<=year & year<=${f_year} /*& pais_num < 20*/ i.year , endog(${xtendog}) constant(${xtconst})  small  /*vce(boots)*/
outreg2 using Estimates_small_20paises_${xtendog}_${f_year}_10-05-2018_03.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv l${xtendog} lspex l_comercio_usd_2010 ll_giro_rem conflicto l_sillas l_habs_1) dec(2) 
* outreg2 using Estimates_${f_year}.doc, word append ctitle(Especificaci贸n ${counter}) label sortvar(l_pib l_dist l_itcrt lcamas_1 ll_sillas l_giro_rem_1)
/* if fcst_year < 2017 {
predict ${xtendog}_u_${counter}, ue
estimates store model_${xtendog}_${counter}
forecast create forecast_${xtendog}_${counter}, replace
forecast estimates model_${xtendog}_${counter}
forecast exogenous `x'
by pais_num: egen ${xtendog}_uhat_${counter} = mean(${xtendog}_u_${counter})
forecast adjust ${xtendog} = ${xtendog} + ${xtendog}_uhat_${counter}
forecast solve, prefix(s_${counter}_) begin(fcst_year + 1)
forecast describe
gen forecast_error_${counter} = ${xtendog} - s_${counter}_${xtendog}
sum forecast_error_${counter} if year > fcst_year
outreg2 using Forecast_${xtendog}_${f_year}.doc if year > fcst_year, word replace sum(log) keep(forecast_error_*) dec(3)
    forvalues i = ${f_year}(1)2017 {
	    gen forecast_error_${counter}_`i' = forecast_error_${counter} if year == `i'
		sum forecast_error_${counter}_`i'
		outreg2 if year == `i' using Forecast_${xtendog}_${f_year}.doc, word replace sum(log) keep(forecast_error_*)
		} 
	forvalues n = 1(1)20 {
	    gen forecast_error_${counter}_`n' = forecast_error_${counter} if year >= fcst_year & pais_num == `n'
		sum forecast_error_${counter}_`n'
		outreg2 using Forecast_${xtendog}_${f_year}.doc, word replace sum(log) keep(forecast_error_*)
		}   */
replace count 		= count + 1
global counter 		= count
*}
}







xthtaylor ${xtendog} l_pib l_dist if 2000<=year & year<=${f_year}, endog(${xtendog}) constant(${xtconst}) small  
vce(boots)

xtreg ${xtendog} l_pib l_dist i.year , re

forvalues i = 2000(1)2017 {
gen y_`i' = 0
replace y_`i' = 1 if year == `i'
}

gen ipib = 1/pib
egen sum_pib = total(pib), by(year)
egen sum_ipib = total(ipib), by(year)
gen w_dist = ipib/sum_ipib
gen w_0_dist = pib/sum_pib
egen sum_w_dist = total(w_dist), by(year)
gen dist_w_0 = dist*pib/sum_pib
gen dist_w = dist*ipib/sum_ipib
gen l_dist_w_0 = ln(dist_w_0)
gen l_dist_w = ln(dist_w)
gen l_dist_alt = ln(dist_alt)

gen dist_alt = w_0_dist/dist
replace dist_ialt = (dist_alt)^-1

xtreg ${xtendog} l_pib l_dist_alt y_2001 y_2002 y_2003 y_2004 y_2005 y_2006 y_2007 y_2008 y_2009 y_2010 y_2011 y_2012 y_2013 y_2014 y_2015 y_2016 , fe 

xthtaylor  ${xtendog} l_pib l_dist ${years} , endog(${xtendog}) constant(l_dist )

xthtaylor  ${xtendog} l_pib l_dist ${years} y_2001 y_2002 y_2003 y_2004 y_2005 y_2006 y_2007 y_2008 y_2009 y_2010 y_2011 y_2012 y_2013 y_2014 y_2015 y_2016 y_2017, endog(${xtendog}) constant(l_dist )

*** Generando Distancia Ponderada por PIB como en Culiuc (2014) pag 11 ponderando por inverss de PIB pais Origen

replace pib_sum = sum(pib),  by year
egen dis_w = dist * pib / 

**** TURISTAS NO RESIDENTES (COLOMBIANOS)****
*** DEFINICION DE LAS VARIABLES ***

replace fcst_year 			= 2015
replace count				= 1

global f_year 				= fcst_year
global xtendog 				"l_turista_col"
global xtmodels 			""l_pib  l_dist" "l_pib l_dist l_itcr l_comercio_usd_2010 l.l_giro_rem conflicto" "l_pib ll_sillas l_dist l_itcr l_comercio_usd_2010 l.l_giro_rem conflicto" "l_pib  l_dist l_itcr l_habs_1 l_comercio_usd_2010 l.l_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 l.l_giro_rem conflicto""
global xtconst 				"l_dist"
global counter 				= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' if 2000<=year & year<=${f_year}, endog(${xtendog}) constant(${xtconst})
outreg2 using Estimates_${f_year}.doc, word append ctitle(Especificaci贸n ${counter}) label sortvar(l_pib l_dist l_itcrt lcamas_1 ll_sillas l_giro_rem_1)
if fcst_year < 2017 {
predict ${xtendog}_u_${counter}, ue
estimates store model_${xtendog}_${counter}
forecast create forecast_${xtendog}_${counter}, replace
forecast estimates model_${xtendog}_${counter}
forecast exogenous `x'
by pais_num: egen ${xtendog}_uhat_${counter} = mean(${xtendog}_u_${counter})
forecast adjust ${xtendog} = ${xtendog} + ${xtendog}_uhat_${counter}
forecast solve, prefix(s_${counter}_) begin(fcst_year)
forecast describe
gen forecast_error_${counter} = ${xtendog} - s_${counter}_${xtendog}
sum forecast_error_${counter} if year >= fcst_year
outreg2 using Forecast_${xtendog}_${f_year}.doc if year >= fcst_year, word replace sum(log) keep(forecast_error_*)
	forvalues i = ${f_year}(1)2017 {
	    gen forecast_error_${counter}_`i' = forecast_error_${counter} if year == `i'
		sum forecast_error_${counter}_`i'
		outreg2 if year == `i' using Forecast_${xtendog}_${f_year}.doc, word replace sum(log) keep(forecast_error_*)
		} 
	forvalues n = 1(1)20 {
	    gen forecast_error_${counter}_`n' = forecast_error_${counter} if year >= fcst_year & pais_num == `n'
		sum forecast_error_${counter}_`n'
		outreg2 using Forecast_${xtendog}_${f_year}.doc, word replace sum(log) keep(forecast_error_*)
		}
replace count 		= count + 1
global counter 		= count
}
}

**** BUCLE TURISTAS NO RESIDENTES (EXTRANJEROS)****
*** DEFINICION DE LAS VARIABLES ***

replace fcst_year 			= 2015
replace count				= 1

global f_year 				= fcst_year
global xtendog 				"l_turista_e"
global xtmodels 			""l_pib  l_dist" "l_pib l_dist l_itcr l_comercio_usd_2010 l.l_giro_rem conflicto" "l_pib ll_sillas l_dist l_itcr l_comercio_usd_2010 l.l_giro_rem conflicto" "l_pib  l_dist l_itcr l_habs_1 l_comercio_usd_2010 l.l_giro_rem conflicto" "l_pib l_dist l_itcr l_comercio_usd_2010 l.l_giro_rem conflicto""
global xtconst 				"l_dist"
global counter 				= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' if 2000<=year & year<=${f_year}, endog(${xtendog}) constant(${xtconst})
outreg2 using Estimates_${f_year}.doc, word append ctitle(Especificaci贸n ${counter}) label sortvar(l_pib l_dist l_itcrt lcamas_1 ll_sillas l_giro_rem_1)
if fcst_year < 2017 {
predict ${xtendog}_u_${counter}, ue
estimates store model_${xtendog}_${counter}
forecast create forecast_${xtendog}_${counter}, replace
forecast estimates model_${xtendog}_${counter}
forecast exogenous `x'
by pais_num: egen ${xtendog}_uhat_${counter} = mean(${xtendog}_u_${counter})
forecast adjust ${xtendog} = ${xtendog} + ${xtendog}_uhat_${counter}
forecast solve, prefix(s_${counter}_) begin(fcst_year)
forecast describe
gen forecast_error_${counter} = ${xtendog} - s_${counter}_${xtendog}
sum forecast_error_${counter} if year >= fcst_year
outreg2 using Forecast_${xtendog}_${f_year}.doc if year >= fcst_year, word replace sum(log) keep(forecast_error_*)
	forvalues i = ${f_year}(1)2017 {
	    gen forecast_error_${counter}_`i' = forecast_error_${counter} if year == `i'
		sum forecast_error_${counter}_`i'
		outreg2 if year == `i' using Forecast_${xtendog}_${f_year}.doc, word replace sum(log) keep(forecast_error_*)
		} 
	forvalues n = 1(1)20 {
	    gen forecast_error_${counter}_`n' = forecast_error_${counter} if year >= fcst_year & pais_num == `n'
		sum forecast_error_${counter}_`n'
		outreg2 using Forecast_${xtendog}_${f_year}.doc, word replace sum(log) keep(forecast_error_*)
		}
replace count 		= count + 1
global counter 		= count
}
}

* Turistas Extranjeros
xthtaylor l_turista_e l_pib  l_dist if pais_num!=20 , endog(l_turista_e) constant(l_dist)
outreg2 using Turimo_EAHT_Niveles_ext_26Abr2018.doc, word replace  dec(2)   label  sortvar(l_pib l_dist l_itcr l_acc_farc conflicto lcamas_1 lcomer_kg ll_sillas l_giro_rem_1 clima_pob)

* Turistas Colombianos
xthtaylor l_turis_col l_pib  l_dist if 2005<year & year<2017 & pais_num!=20 , endog(l_turis_col) constant(l_dist)
outreg2 using Turimo_EAHT_Niveles_col_26Abr2018.doc, word replace  dec(2)   label  sortvar(l_pib l_dist l_itcr l_acc_farc conflicto lcamas_1 lcomer_kg ll_sillas l_giro_rem_1 clima_pob)

xtline dist_w_0,  byopts(yrescale style(mlabsize(small) lwidth(1)) graphregion(fcolor(white)) plotregion(lcolor(white) fcolor(white) margin(r=10)) ///
title("Factor de conversi贸n de PPA") subtitle("Suram茅rica (2005 - 2016)") note("*Unidad de Moneda Local por 1000 COP")) i(pais_num) t(year) xlabel(2005(5)2016, labcolor(gs8) ///
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

