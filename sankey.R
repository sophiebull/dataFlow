
library(plotly)
library(rjson)

pairs <- list(
  
  # First Node
  
    # OCS
    c(from = "OCS", to = "Licensed Dealer Inspections (OCS)", weight = 21),
    c(from = "OCS", to = "Pharmacy Inspections (OCS)", weight = 4),
    
    # CSP
    c(from = "CSP", to = "Destruction Activities (CSP)", weight = 2),
    c(from = "CSP", to = "Licensed Dealer Inspections (CSP)", weight = 5),
    c(from = "CSP", to = "Pharmacy Inspections (CSP)", weight = 2),
    
    # POD
    c(from = "POD", to = "SAP PS Time Tracking", weight = 3),

  # Second Node
  
    # CSP
    c(from = "Licensed Dealer Inspections (CSP)", to = "Class A Precursor Inspection Report", weight = 1),
    c(from = "Licensed Dealer Inspections (CSP)", to = "CDS Inspection Report", weight = 1),
    c(from = "Licensed Dealer Inspections (CSP)", to = "Border Center Database", weight = 1),
  
    c(from ="Pharmacy Inspections (CSP)", to = "Community Pharmacy Internal Inspection Report", weight = 1),
    c(from = "Pharmacy Inspections (CSP)", to = "Community Pharmacy Inspection Report", weight = 1),
  
    c(from = "Destruction Activities (CSP)", to = "Destruction Tracker", weight = 1),
    c(from = "Destruction Activities (CSP)", to = "Destruction Application", weight = 1),
  
  
    # OCS
  c(from = "Licensed Dealer Inspections (OCS)", to = "Site Risk Profile - LD", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "List of Licensees - CDS", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "List of Licensees - Chemical Precursors", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Loss & Theft Report", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Monthly Activity Report - CDS", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Annual Report - CDS", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Ephedrine Monthly Report", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Import Permit Info", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "License Application and Amendment Requests", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Annual Report - Chemical Precursors", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Export Info (Permit & Transactions)", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "List of Designated Personnel - CDS", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Correspondance File from LD", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Notice of Restrictions for Pharmacist and LD", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Compliance Action (Regulatory Letter)", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "LD Profile for Precursor", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "S.56 Exemption Letter", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "S.56 Exemption Holder Dispensing Tracker", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "LD License Including T&C", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "NDS 7", weight = 1),
  c(from = "Licensed Dealer Inspections (OCS)", to = "Observation Tracker", weight = 1),
  
  c(from = "Pharmacy Inspections (OCS)", to = "Site Risk Profile - PI", weight = 1),
  c(from = "Pharmacy Inspections (OCS)", to = "List of Pharmacies", weight = 1),
  c(from = "Pharmacy Inspections (OCS)", to = "Loss & Theft Report / Suspicious Transactions - PI", weight = 1),
  
  # Intermediate steps
  c(from = "Class A Precursor Inspection Report", to = "Manual Data Entry into Excel (OCS)", weight = 1),
  c(from = "CDS Inspection Report", to = "Manual Data Entry into Excel (OCS)", weight = 1),
  c(from = "Community Pharmacy Internal Inspection Report", to = "Manual Data Entry into Excel (OCS)", weight = 1),
  c(from = "Community Pharmacy Inspection Report", to = "Manual Data Entry into Excel (OCS)", weight = 1),
  
  c(from = "Manual Data Entry into Excel (OCS)", to = "LD Inspection Tracker", weight = 2),
  c(from = "Manual Data Entry into Excel (OCS)", to = "Pharmacy Inspection Tracker", weight = 2)
  
  
)

pairs_df <- data.frame(t(as.data.frame(pairs)))
rownames(pairs_df) <- NULL

##############################

# Key
label <- unique(c(pairs_df$from,pairs_df$to))
index <- 1:length(label)
    
    key <- data.frame(
      label = label,
      index = index
    )

pairs_df$from_index <- key$index[match(pairs_df$from, key$label)] 
pairs_df$to_index <- key$index[match(pairs_df$to, key$label)] 

pairs_df$path_name <- paste0("path ", 1:length(pairs_df$from_index))

########################

my_data <- list(
  
  node = list(
    label = key$label,
    color = colorRampPalette(c("red","blue"))(length(key$label))
    ),
  
  link = list(
    source_data = pairs_df$from_index,
    target_data = pairs_df$to_index,
    weight = pairs_df$weight,
    label = pairs_df$path_name
    )
)

p <- plot_ly(
  type = "sankey",
  domain = c(
    x =  c(0,1),
    y =  c(0,1)
  ),
  orientation = "h",
  valueformat = ".0f",
  valuesuffix = "",
  
  node = list(
    label = my_data$node$label,
    color = my_data$node$color,
    pad = 25,
    thickness = 50,
    line = list(
      color = NULL,
      width = 0.5
    )
  ),
  
  link = list(
    source = my_data$link$source_data,
    target = my_data$link$target_data,
    value =  my_data$link$weight,
    label =  my_data$link$path_name
  )
) %>% 
  layout(
    title = "Data Holdings and Flows: Controlled Substances Program",
    font = list(
      size = 12,
      color = 'grey50'
    ),
    xaxis = list(showgrid = F, zeroline = F, showticklabels = F),
    yaxis = list(showgrid = F, zeroline = F, showticklabels = F),
    plot_bgcolor = 'white',
    paper_bgcolor = 'white'
  )

p

