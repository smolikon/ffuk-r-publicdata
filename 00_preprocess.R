library(statnipokladna)
library(readr)
library(nanoparquet)
library(dplyr)

options(statnipokladna.dest_dir = "data-input/sp")

orgs <- sp_get_codelist("ucjed")
write_parquet(orgs, "data-processed/orgs_raw.parquet")

orgs <- read_parquet("data-processed/orgs_raw.parquet")

orgs_proc <- orgs |>
  filter(start_date <= "2023-01-01", end_date >= "2023-12-31") |>
  sp_add_codelist("druhuj") |>
  sp_add_codelist("poddruhuj") |>
  filter(druhuj_nazev %in% c("Obce", "Dobrovolné svazky obcí", "Krajské úřady"))

write_parquet(orgs_proc, "data-processed/orgs_proc.parquet")

rozp_mist <- sp_get_table("budget-local", year = 2015:2023, month = c(3, 6, 9, 12))
colnames(rozp_mist)
skimr::skim(rozp_mist)

write_parquet(rozp_mist, "data-processed/ucjed_mist.parquet")
write_parquet(rozp_mist, "data-processed/ucjed_mist.parquet")
write_rds(rozp_mist, "data-processed/ucjed_mist.rds")

