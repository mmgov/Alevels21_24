library("DT")
library("tidyverse")
library("cpp11")
library("devtools")
library("PostcodesioR")
library("leaflet")

# lookup_result <- postcode_lookup("EH75ND")
# 
# #overview
# str(lookup_result)


alc2324<-read_csv("./england_ks5final2324.csv", na = c('*','','na')) %>% 
  select('URN','REGION','ESTAB','SCHNAME','TALLPPE_ALEV_1618','TALLPUP_ALEV_1618','TALLPPEGRD_ALEV_1618','NFTYPE/FESITYPE','TOWN','PCON_NAME','PCODE')%>%
  rename(SCHOOLTYPE = 'NFTYPE/FESITYPE')%>% 
  filter (
    !TALLPPE_ALEV_1618 %in% c('NE','SUPP',NA)
    ,ESTAB != 'NA'
    ,!SCHOOLTYPE %in% c('SS','3066905','3104027','AC1619','Agriculture and Horticulture College'
                        ,'Art, Design and Performing Arts College','CTC','MODFC',NA))%>%
  mutate_at(c('TALLPPE_ALEV_1618', 'TALLPUP_ALEV_1618'), as.numeric)%>% 
  rename('23/24' = 'TALLPPE_ALEV_1618') %>% 
  rename('23/24 Grade' = 'TALLPPEGRD_ALEV_1618')



alc2223<-read_csv("./england_ks5final2223.csv", na = c('*','','na')) %>% 
  select('URN','REGION','ESTAB','SCHNAME','TALLPPE_ALEV_1618','TALLPUP_ALEV_1618','TALLPPEGRD_ALEV_1618','NFTYPE/FESITYPE','TOWN','PCON_NAME')%>%
  rename(SCHOOLTYPE = 'NFTYPE/FESITYPE')%>% 
  filter (
    !TALLPPE_ALEV_1618 %in% c('NE','SUPP',NA)
    ,ESTAB != 'NA'
    ,!SCHOOLTYPE %in% c('SS','3066905','3104027','AC1619','Agriculture and Horticulture College'
                        ,'Art, Design and Performing Arts College','CTC','MODFC',NA))%>%
  mutate_at(c('TALLPPE_ALEV_1618', 'TALLPUP_ALEV_1618'), as.numeric) %>% 
  rename('22/23' = 'TALLPPE_ALEV_1618') %>% 
  rename('22/23 Grade' = 'TALLPPEGRD_ALEV_1618')


alc2122<-read_csv("./england_ks5final2122.csv", na = c('*','','na')) %>% 
  select('URN','REGION','ESTAB','SCHNAME','TALLPPE_ALEV_1618','TALLPUP_ALEV_1618','TALLPPEGRD_ALEV_1618','NFTYPE/FESITYPE','TOWN','PCON_NAME')%>%
  rename(SCHOOLTYPE = 'NFTYPE/FESITYPE')%>% 
  filter (
    !TALLPPE_ALEV_1618 %in% c('NE','SUPP',NA)
    ,ESTAB != 'NA'
    ,!SCHOOLTYPE %in% c('SS','3066905','3104027','AC1619','Agriculture and Horticulture College'
                        ,'Art, Design and Performing Arts College','CTC','MODFC',NA))%>%
  mutate_at(c('TALLPPE_ALEV_1618', 'TALLPUP_ALEV_1618'), as.numeric) %>% 
  rename('21/22' = 'TALLPPE_ALEV_1618') %>% 
  rename( '21/22 Grade'= 'TALLPPEGRD_ALEV_1618')

SCHOOLTYPE<- c('Academy Converter','Independent School','Academy Sponsor Led','Community School','Voluntary Aided School','Foundation School','University Technical College','Free School – Mainstream', 'Academy 16-19 Converter','Voluntary Controlled School','Free School - 16-19')
ACRONYM<-c('ACC','IND','AC','CY','VA','FD','UTC','F','ACC1619','VC','F1619')



final<-left_join(alc2324,(alc2223 %>% select(URN,'22/23','22/23 Grade')), by = "URN") %>% 
  left_join(.,(alc2122 %>% select(URN,'21/22','21/22 Grade')), by = "URN") %>% 
  select(URN,SCHNAME,SCHOOLTYPE,TOWN,PCON_NAME,PCODE,'21/22','21/22 Grade','22/23',
                        '22/23 Grade','23/24','23/24 Grade')

# Define a vector of postcodes
# postcodes <- c("M1 1AE", "SW1A 1AA", "EH1 1BB")  # Replace with your postcodes

summarise(final)

final$postcodet<-str_replace_all(final$PCODE,fixed(" "),"")

postcodes <- unique(final$postcodet)



geo_data <- lapply(pc_nog, function(pc) {
  res <- tryCatch(postcode_lookup(pc), error = function(e) NULL)
  if (!is.null(res)) {
    data.frame(postcodet = pc, lat = res$latitude, lon = res$longitude)
  } else {
    data.frame(postcodet = pc, lat = NA, lon = NA)
  }
})

geo_df <- do.call(rbind, geo_data)

final_geo <- left_join(final, geo_df, by = "postcodet", relationship = "many-to-many")



lookup_result <- postcode_lookup("KT35PE")


library(leaflet)

leaflet() %>%
  addTiles() %>%
  setView(lng = -3.7, lat = 40.4, zoom = 5) 






uk_map <- renderLeaflet({
  leaflet(final_geo) %>%
    addTiles() %>%
    setView(lng = -2.03, lat = 55.8, zoom = 5) %>% 
    addCircleMarkers(
      lng = ~lon,
      lat = ~lat,
      popup = ~paste(SCHNAME,"<br>", "21/22 Grade", "<br>", PCODE),
      radius = 4,
      color = "blue"
    )
})
