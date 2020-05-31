library(plotKML)
library(lubridate)
library(rgdal)

folder_path <- '/Users/polmartisanahuja/Desktop/'

tracks_list <- c("sitges1.gpx","sitges2.gpx")

track <- data.frame()
for (tl in tracks_list){
  print(tl)
  ruta <- readGPX(paste0(folder_path,tl))
  ruta_track <-ruta$tracks[[1]][[1]]
  
  track <- rbind(track, ruta_track)
}

pre <- '<?xml version="1.0" encoding="UTF-8"?>
<gpx creator="Wikiloc - https://www.wikiloc.com" version="1.1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
<metadata>
<name>Wikiloc - Sitges 1</name>
<author>
<name>polmartisanahuja</name>
<link href="https://www.wikiloc.com/wikiloc/user.do?id=53518">
<text>polmartisanahuja on Wikiloc</text>
</link>
</author>
<link href="https://www.wikiloc.com/motorcycling-trails/sitges-1-37350456">
<text>Sitges 1 on Wikiloc</text>
</link>
<time>2019-06-08T14:08:29Z</time>
</metadata>
<trk>
<name>Sitges 1</name>
<cmt>Sitges 1</cmt>
<desc>Sitges 1</desc>
<trkseg>'

post <- '</trkseg>  </trk>  </gpx>'

gpx_out <- paste(
  c(pre,
    mapply(function(lat, lon, ele, time) {
      sprintf('<trkpt lat="%f" lon="%f">
              <ele>%s</ele>
              <time>%s</time>
              </trkpt>', lat, lon, ele, time)
    }, track$lat, track$lon, track$ele, track$time),
    post, "\n"),
  collapse="\n")

write(gpx_out, '/Users/polmartisanahuja/Desktop/garraf_sitges.gpx')


