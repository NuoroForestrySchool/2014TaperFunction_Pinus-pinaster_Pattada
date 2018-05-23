#: Title    : taper models calibration
#: Affiliation    : "NFS" <Nuoro.Forestry.School@gmail.com>
#: Author    : "Sergio Campus" <sfcampus@uniss.it>, Roberto Scotti <scotti@uniss.it>
#: Date    : 05/11/2014
#: Version    : -1
#: Description    : calibrazione di diversi modelli di funzione di profilo considerando:
                  # tutti i profili, i profili raggruppati per indici sangp e per località

setwd("~/Documenti/02-RICERCA/Fragiacomo/EDENSO/TapeR")
setwd("../From_NFSonUniSS_site")
rm(list=ls(all=TRUE))
require(RSQLite)
require(TapeR)

# path_rs <- "/home/rs/Documenti/00-DropBox/scotti_uniss"
# path_sc <- "/home/sergio/DropboxUniss"
# source(paste(path_sc, "/Dropbox/Fragiacomo_Pattada/martellata/Map.R", sep=''))
dsn <- "~/Dropbox/Fragiacomo_Pattada/mappe/DB/edenso.sqlite"
dsn <- "edenso.sqlite"
con <- dbConnect(SQLite(), dbname=dsn)
dbListTables(con)
pf <- dbReadTable(con,"ProfiliFustiTerra")
pf$area <- ifelse(substr(pf$id_fusto, 1, 5)=="IOSSO", "IOSSO", "SUPRA")

# ==== using all the stems
ht <- data.frame(h_tot=tapply(pf$h_sez, pf$id_fusto, max))
pf1 <- merge(pf, ht, by.x=2, by.y=0)

# prepare the data (could be defined in the function directly)
Id = pf1[,"id_fusto"]
x = pf1[,"h_sez"]/pf1[,"h_tot"] # calculate relative heights
y = pf1[,"d_sez"]

# define the relative knot positions and order of splines
knt_x = c(0.0, 0.1, 0.75, 1.0); ord_x = 4 # B-Spline knots: fix effects; order (cubic = 4)
knt_z = c(0.0, 0.1, 1.0); ord_z = 4 # B-Spline knots: rnd effects

# fit the model
tpm_tot <- TapeR_FIT_LME.f(Id, x, y, knt_x, ord_x, knt_z, ord_z, IdKOVb = "pdSymm")

Pinus_pinaster_Pattada_all.taper.pars <- tpm_tot$par.lme
#save(Pinus_pinaster_Pattada_all.taper.pars, file="Pinus_pinaster_Pattada_all.taper.pars.rdata")##uncomment to save

