gen r = 0.03
gen gamma = 1.25
gen alpha = -16.16
	gen w1990 = [[[[rgdptt1990^(1-(1/gamma))]*(1-exp(-r*life1990))/(1-exp(-r*life1960))]+[alpha*(1-(1/gamma))*((exp(-r*life1960)-exp(-r*life1990))/(1-exp(-r*life1960)))]]^(gamma/(gamma-1))]-rgdptt1990
		gen full1990 = rgdptt1990+w1990
		gen lnfull1990 = ln(full1990) 
		gen dlnfull90_60 = lnfull1990 - lngdp1960
	gen w2000_90 = [[[[rgdptt2000^(1-(1/gamma))]*(1-exp(-r*life2000))/(1-exp(-r*life1990))]+[alpha*(1-(1/gamma))*((exp(-r*life1990)-exp(-r*life2000))/(1-exp(-r*life1990)))]]^(gamma/(gamma-1))]-rgdptt2000
		gen full2000_90 = rgdptt2000+w2000_90
		gen lnfull2000_90 = ln(full2000_90) 
		gen dlnfull00_90 = lnfull2000_90 - lngdp1990
	gen w2000_60 = [[[[rgdptt2000^(1-(1/gamma))]*(1-exp(-r*life2000))/(1-exp(-r*life1960))]+[alpha*(1-(1/gamma))*((exp(-r*life1960)-exp(-r*life2000))/(1-exp(-r*life1960)))]]^(gamma/(gamma-1))]-rgdptt2000
		gen full2000_60 = rgdptt2000+w2000_60
		gen lnfull2000_60 = ln(full2000_60) 
		gen dlnfull00_60 = lnfull2000_60 - lngdp1960
drop r
drop gamma
drop alpha

log using d:\projects\bps\wdi_life\results.log, replace
inequal rgdptt1960 [fweight = pop1960]
inequal rgdptt1990 [fweight = pop1990]
inequal rgdptt2000 [fweight = pop2000]
inequal life1960 [fweight = pop1960]
inequal life1990 [fweight = pop1990]
inequal life2000 [fweight = pop2000]
reg dlngdp90_60 lngdp1960 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. [aweight = pop1960]
reg dlife90_60 life1960 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. [aweight = pop1960]
reg dlnfull90_60 lngdp1960 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. [aweight = pop1960]
reg dlngdp00_90 lngdp1990 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. [aweight = pop1990]
reg dlife00_90 life1990 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. [aweight = pop1990]
reg dlnfull00_60 lngdp1960 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. [aweight = pop1960]
inequal full1990 [fweight = pop1990]
inequal full2000_60 [fweight = pop2000]
log close

gen NPV_w2000_60 =  w2000_60*(1-exp(-0.03* life1960))/0.03
gen growth_full_00_60 =  ((full2000_60/ rgdptt1960)^(1/40))-1

sum rgdptt, 1960
means   rgdptt1960 drgdptt00_60 w2000_60 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. & rgdptt1960<2349 [fweight = pop1960]
means   rgdptt1960 drgdptt00_60 w2000_60 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=. & rgdptt1960>2349 [fweight = pop1960]

log using d:\projects\bps\wdi_life\regions.log, replace
by region: summarize life1960 rgdptt1960 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=.  [fweight= pop1960]
by region: summarize life2000 rgdptt2000 w2000_60 NPV_w2000_60 if  dlngdp90_60~=. &  dlngdp00_90~=. & dlife90_60~=. &  dlife00_90~=.  [fweight= pop2000]
log close

