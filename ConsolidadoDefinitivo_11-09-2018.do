
clear all
set more off
cap log close
macro drop _all
* Insert where you copied data excel file between two quotation marks below 
* cd "D:\users\NRO\DEPE\TURISMO\"
* cd "C:\Users\NRO\DEPE\TURISMO"
* cd "C:\Users\Lenovo Pc\Desktop\Turismo"
* cd "D:\Nicolas_Fajardo\Proyectos\Turismo"
cd "C:\Users\USR_PracticanteGT42\Documents\DSGE_Ferroni\Nicolas Fajardo\Turismo"
* cd "W:\Nicolas Fajardo\Turismo"
import excel using "base_datos_10septiembre2018.xlsx", sheet("base_2000-2017") firstrow clear

drop indicador paisorigen

encode abrev_pais, gen(pais_num)
xtset pais_num year

label data 							"Panel Turismo (20 Paises)"
label variable  year           		"Año"
label variable  dist           		"Distancia desde pais origen"
label variable  sillas         		"Numero de vuelos"
label variable  no_resid_pais       "Numero de turistas no residentes"
label variable  comercio_usd_2010   "Cantidad de comercio en dolares constantes del 2010"
label variable  habs_ph_1	        "Numero habitaciones/100Mhabitantes (t-1)"
label variable  giros_remesas		"Numero de giros por remesas"
label variable  pib	                "PIB Pais"
label variable  turista_col			"Número de turistas no residentes colombianos"
label variable  turista_extr		"Número de turistas no residentes extranjeros"
label variable  espanol				"Habla Español"
label variable  tlc					"Tiene un tlc con Colombia"
label variable  conflicto			"Número de muertos por cada 100M habitantes"
label variable  spex				"Índice de Precios Sustitutos ponderados por Tasa de Cambio Nominal"
label variable  itcrinv				"Índice de Precios Relativos"
label variable  pais_num			"Numero de identificacion"

label define pais_cod 1 "Argentina" 2 "Brasil" 3 "Canada" 4	"Suiza" 5 "Chile" 6 "Cta Rica" 7 "Alemania" 8 "Dominicana" 9 "Ecuador" 10 "Espana" 11 "Francia" 12 "GranBret." 13 "Gtemala" 14 "Italia" 15 "Mexico" 16 "Panama" 17 "Peru" 18 "PtoRico" 19 "USA" 20 "Venez."

generate region =.

label define region 1 "Suramérica y México" 2 "Norteamérica" 3 "Europa" 4 "Caribe", replace

replace region=1 if pais_num<=2 | pais_num==5  | pais_num==9  | pais_num==17 | pais_num==17 | pais_num==20 | pais_num==15
replace region=2 if pais_num==3 | pais_num==19
replace region=3 if pais_num==4 | pais_num==7  | pais_num==10 | pais_num==11 | pais_num==12 | pais_num==14
replace region=4 if pais_num==6 | pais_num==8  | pais_num==13 | pais_num==16 | pais_num==18

label variable  region				"Región a la que pertenece el pais de origen"

replace sillas = sillas + 1 

gen l_dist      			= ln(dist)
gen l_sillas      		 	= ln(sillas)
gen l_no_resid_pais  		= ln(no_resid_pais)
gen l_comercio_usd_2010 	= ln(comercio_usd_2010)
gen l_habs_ph_1      		= ln(habs_ph_1)
gen l_giros_rem	      		= ln(giros_remesas)    
gen l_no_resid      		= ln(no_resid) 
gen l_pib       			= ln(pib)
gen l_turis_col 			= ln(turista_col)
gen l_turis_e 				= ln(turista_extr)
gen l_spex                  = ln(spex)
gen l_itcrbinv      		= ln(itcrinv)

sort pais_num 

by pais_num: gen ll_giro_rem 			= l_giros_rem[_n-1]
by pais_num: gen ll_sillas            	= l_sillas[_n-1]
    
sort year
egen pib_sum  				= total(pib), by(year)
gen  pib_part 				= pib / pib_sum 
gen  dist_w_1   			= pib_part/dist
gen  dist_w 				= 1/dist_w_1
gen  l_dist_w   			= ln(dist_w)

label variable  l_dist           		"ln Distancia pais origen"
label variable  l_dist_w           		"ln Distancia ponderada pais origen"
label variable  l_sillas     	    	"Numero sillas(t-1)"
label variable  ll_sillas     	    	"ln Numero sillas(t-1)"
label variable  l_comercio_usd_2010   	"ln Comercio en dolares ctes de 2010"
label variable  l_habs_ph_1	            "ln Numero de habitaciones(t-1)/100M habitantes"
label variable  l_giros_rem				"ln Numero de remesas"
label variable  l_pib	                "ln PIB Pais"
label variable  ll_giro_rem		        "ln Numero de remesas(t-1)"
label variable  l_spex                  "ln Prec. Sustit."
label variable  l_itcrbinv              "ln Prec. Relativos"

gen y2001=(year==2001)
gen y2002=(year==2002)
gen y2003=(year==2003)
gen y2004=(year==2004)
gen y2005=(year==2005)
gen y2006=(year==2006)
gen y2007=(year==2007)
gen y2008=(year==2008)
gen y2009=(year==2009)
gen y2010=(year==2010)
gen y2011=(year==2011)
gen y2012=(year==2012)
gen y2013=(year==2013)
gen y2014=(year==2014)
gen y2015=(year==2015)
gen y2016=(year==2016)
gen y2017=(year==2017)

tsset pais_num year

gen start_year 				= 2001
gen fcst_year 				= 2017
gen count					= 1
global s_year 				= start_year
global f_year 				= fcst_year
global n_countries			= 20
global cluster_var			= "pais_num"
global date : di %tdCCYY-NN-DD date(c(current_date),"DMY")

global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(l_dist espanol) small vce(cluster ${cluster_var})
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global xtconst  "l_dist"
global counter 	= 1
replace count = 1

global xtmodels ""l_pib l_dist" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol""

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small vce(cluster ${cluster_var})
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small vce(cluster ${cluster_var})
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small vce(cluster ${cluster_var})
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 
*** EXCLUSIÓN DE VENEZUELA

global n_countries			= 19
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(l_dist espanol) vce(cluster ${cluster_var})
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small vce(cluster ${cluster_var})
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol y2002-y2017) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small vce(cluster ${cluster_var})
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol y2002-y2017) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small vce(cluster ${cluster_var})
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol y2002-y2017) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 

/*
*** POR REGIONES 
** (EUROPA Y NORTEAMERICA)

global n_countries			= 20
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 

** (LATINOAMERICA Y EL CARIBE)

global n_countries			= 20
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 
** (LATINOAMERICA Y EL CARIBE) [SIN VENEZUELA]

global n_countries			= 19
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1
replace count = 1

foreach x of global xtmodels{

global xtconst = cond(count==(5), "l_dist espanol", "l_dist")
xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 

/*

***** CON DUMMIES

global n_countries			= 20
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global xtconst  "l_dist espanol"
global counter 	= 1

global xtmodels ""l_pib l_dist espanol" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto espanol" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas espanol" "l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol""

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 
*** EXCLUSIÓN DE VENEZUELA (D)

global n_countries			= 19
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} , endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 
*** POR REGIONES (D)
** (EUROPA Y NORTEAMERICA) (D)

global n_countries			= 20
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==2 | region==3), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 
** (LATINOAMERICA Y EL CARIBE) (D)

global n_countries			= 20
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

drop l_comercio_usd_2010_resid 
** (LATINOAMERICA Y EL CARIBE) [SIN VENEZUELA] (D)

global n_countries			= 19
global xtendog "l_comercio_usd_2010"

xthtaylor ${xtendog} l_pib l_dist l_itcr espanol tlc y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(l_dist espanol) small 
predict ${xtendog}_resid, ue
label variable  ${xtendog}_resid         "ln Comercio en dolares ctes de 2010 (residuos)"
outreg2 using Estimates_small_${xtendog}_${s_year}-${f_year}_${date}.xls, excel append label sortvar(l_pib l_dist l_itcr l_itcrbinv lspex l${xtendog} l_comercio_usd_2010 ll_giro_rem conflicto l_habs_1 ll_sillas tlc espanol y2002-y2017) dec(2) 

global xtendog "l_no_resid_pais"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_Small_2etapas_${s_year}-${f_year}_${date}_total_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_col"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

global xtendog "l_turis_e"
global counter 	= 1

foreach x of global xtmodels{

xthtaylor ${xtendog} `x' y2002-y2017 if ${s_year}<=year & year<=${f_year} & pais_num<=${n_countries} & (region==1 | region==4), endog(${xtendog}) constant(${xtconst})  small 
outreg2 using Estimates_small_2etapas_${s_year}-${f_year}_${date}_col-ext_definitivo_regiones_espanol.xls, excel append label sortvar(l_pib l_dist l_itcrbinv l_spex l_comercio_usd_2010_resid ll_giro_rem conflicto ll_sillas l_habs_ph_1 espanol) dec(2) 
replace count 		= count + 1
global counter 		= count

}

*/
