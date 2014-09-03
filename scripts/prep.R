
# this is going to be the output file
# going to add the adjusted series to it
out_m_xts <- m_input

# not totally clear why this was needed
# lodusm_df <- as.data.frame(lodus_m)
# lodusq_df <- as.data.frame(lodus_q)
# 
# tempdate_q <- index(lodus_q)
# tempdate_q <- as.Date(tempdate_q, "%Y-%m-%d")
# 
# tempdate_m <- index(lodus_m)
# tempdate_m <- as.Date(tempdate_m, "%Y-%m-%d")

# list for seasonal adjustment
seriesl <- c("employed_nsa", "not_at_work_vac", "fewer_than_35_vac")


# monthly
print("monthly")
for(s in seriesl){
  print(s)
  
  # so this is evaluating what's in the seriesn variable
  # puts the series into a variable called tempdata
  tempdata <- out_m_xts[,s]
  
  # trims the NAs from the series
  tempdata <- na.trim(tempdata)
  
  # http://stackoverflow.com/questions/15393749/get-frequency-for-ts-from-and-xts-for-x12
  freq <- switch(periodicity(tempdata)$scale,
                 daily=365,
                 weekly=52,
                 monthly=12,
                 quarterly=4,
                 yearly=1)
  plt_start <- as.POSIXlt(start(tempdata))
  start <- c(plt_start$year+1900,plt_start$mon+1)
  print(start)
  
  # creates a time series object using start date and frequency
  tempdata_ts <- ts(as.numeric(tempdata), start=start, frequency=freq)  
  
  mp <- seas(tempdata_ts,
             transform.function = "log",
             regression.aictest = NULL,
             # for monthly
             regression.variables = c("const"),
             # regression.variables = c("const", "easter[8]", "thank[3]"),
             # for quarterly
             #regression.variables = c("const", "easter[8]"),
             identify.diff = c(0, 1),
             identify.sdiff = c(0, 1),
             forecast.maxlead = 24, # extends 24 months ahead
             x11.appendfcst = "yes", # appends the forecast of the seasonal factors
             dir = "output_data/"           
  )

  # grabs the seasonally adjusted series
  tempdata_sa <- series(mp, c("d11"))
  tempdata_sf <- series(mp, c("d16")) # seasonal factors
  tempdata_fct <- series(mp, c("fct")) # forecast of nonseasonally adjusted series
  
  # not sure what these did
  #trim <- (length(tempdata_sa))
  #trimdate <- tempdate[1:trim]
  #tempdata_sa <- xts(tempdata_sa, trimdate)
  
  # creates an xts object
  tempdata_sa <- as.xts(tempdata_sa)
  tempdata_sf <- as.xts(tempdata_sf)
  # in the following, we just want the forecast series, not the ci bounds
  # I had to do in two steps, I'm not sure why
  tempdata_fct <- as.xts(tempdata_fct) 
  tempdata_fct <- as.xts(tempdata_fct$forecast) 
  
  # names the object
  names(tempdata_sa) <- paste(s,"_sa",sep="")
  names(tempdata_sf) <- paste(s,"_sf",sep="") 
  names(tempdata_fct) <- paste(s,"_fct",sep="") 
  
  # merges the adjusted series onto the existing xts object with the unadjusted
  # series
  out_m_xts <- merge(out_m_xts, tempdata_sa, tempdata_sf, tempdata_fct)
}




