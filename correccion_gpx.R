library(plotKML)
library(lubridate)
#library(pgirmess)
library(rgdal)

ruta_a <- readGPX('Desktop/track1.gpx')
ruta_a_track <-ruta_a$tracks[[1]]$track1

ruta_b <- readGPX('Desktop/track2.gpx')
ruta_b_track <- ruta_b$tracks[[1]]$`Sant Cugat del Vallès`
date_final <- ymd_hms(ruta_b_track$time[1])
date_inicial <- ymd_hms("2019-06-02 08:25:00UTC")

seq_dates <- seq(date_inicial, date_final, length.out = nrow(ruta_a_track))

ruta_a_track$time <- paste0(substr(seq_dates,1,10), 'T', substr(seq_dates,12,19), 'Z')

#writeGPX(ruta_a_track, 'Documents/historic/Viatges/moto_Roma_Barcelona_2018/Maps3D 2018-08-04 05-15pm_a_elev_time.gpx' ,type = 't')

# writeOGR(ruta_a_track, 
#          dsn="Documents/historic/Viatges/moto_Roma_Barcelona_2018/Maps3D 2018-08-04 05-15pm_a_elev_time.gpx", 
#          layer="track_points", 
#          driver = "GPX") 



pre <- '<?xml version="1.0" encoding="UTF-8"?>
<gpx creator="Wikiloc - https://www.wikiloc.com" version="1.1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
<metadata>
<name>Wikiloc - track1</name>
<author>
<name>polmartisanahuja</name>
<link href="https://www.wikiloc.com/wikiloc/user.do?id=53518">
<text>polmartisanahuja on Wikiloc</text>
</link>
</author>
<link href="https://www.wikiloc.com/mountain-biking-trails/track1-37151373">
<text>track1 on Wikiloc</text>
</link>
<time>2019-06-02T14:35:05Z</time>
</metadata>
<trk>
<name>track1</name>
<cmt></cmt>
<desc></desc>
<trkseg>
'
post <- '</trkseg>  </trk>  </gpx>'

# dat$dt <- format(as.POSIXct(paste(dat$DATE, dat$TIME), format="%m-%d-%y %H:%M:%S"),
#                  format="%Y-%m-%dT%H:%M:%SZ", tz="UTC")


gpx_out <- paste(
  c(pre,
    mapply(function(lat, lon, ele, time) {
      sprintf('<trkpt lat="%f" lon="%f">
              <ele>%s</ele>
              <time>%s</time>
              </trkpt>', lat, lon, ele, time)
    }, ruta_a_track$lat, ruta_a_track$lon, ruta_a_track$ele, ruta_a_track$time),
    post, "\n"),
  collapse="\n")

write(gpx_out, 'Desktop/track1_corrected.gpx')


ruta_a <- readGPX('Desktop/track1_corrected.gpx')
ruta_a_track <-ruta_a$tracks[[1]]$track1

ymd_hms(ruta_b_track$time)[2:nrow(ruta_b_track)] - ymd_hms(ruta_b_track$time)[1:(nrow(ruta_b_track)-1)]
ymd_hms(ruta_a_track$time)[2:nrow(ruta_a_track)] - ymd_hms(ruta_a_track$time)[1:(nrow(ruta_a_track)-1)]
ruta_a_track_small <- ruta_a_track[seq(1,nrow(ruta_a_track),1),]
ruta_a_track_small <- ruta_a_track
ymd_hms(ruta_a_track_small$time)[2:nrow(ruta_a_track_small)] - ymd_hms(ruta_a_track_small$time)[1:(nrow(ruta_a_track_small)-1)]

ruta_track <- rbind(ruta_a_track_small, ruta_b_track)


pre <- '<?xml version="1.0" encoding="UTF-8"?>
<gpx creator="Wikiloc - https://www.wikiloc.com" version="1.1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
<metadata>
<name>Wikiloc - Sant Cugat del Vallès</name>
<author>
<name>polmartisanahuja</name>
<link href="https://www.wikiloc.com/wikiloc/user.do?id=53518">
<text>polmartisanahuja on Wikiloc</text>
</link>
</author>
<link href="https://www.wikiloc.com/mountain-biking-trails/sant-cugat-del-valles-37145581">
<text>Sant Cugat del Vallès on Wikiloc</text>
</link>
<time>2019-06-02T13:30:49Z</time>
</metadata>
<trk>
<name>Sant Cugat del Vallès</name>
<cmt>Sant Cugat del Vallès</cmt>
<desc>Sant Cugat del Vallès</desc>
<trkseg>
'
post <- '</trkseg>  </trk>  </gpx>'


gpx_out <- paste(
  c(pre,
    mapply(function(lat, lon, ele, time) {
      sprintf('<trkpt lat="%f" lon="%f">
              <ele>%s</ele>
              <time>%s</time>
              </trkpt>', lat, lon, ele, time)
    }, ruta_track$lat, ruta_track$lon, ruta_track$ele, ruta_track$time),
    post, "\n"),
  collapse="\n")

write(gpx_out, 'Desktop/sant_cugat_serra_marina.gpx')


