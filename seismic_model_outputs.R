
#run a mixed model wtih all main effects only, term as a random effect, for each course
  #controlling for GPAO 
  #race/ethnicity defined as ethnicode_cat

main_fx_all <-
dat_new %>%
  nest(-crs_name) %>%
  mutate(fit = map(data, ~lmer(numgrade ~ gpao + female + as.factor(ethnicode_cat) + firstgen + transfer + lowincomeflag + international
                               + (1|crs_term), data = .)), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit) %>%
  mutate(p.value = round(p.value, digits = 4)) 

#nixed model with main effects, controlling for GPAO
  #race/ethnicity defined as urm

main_fx_urm <-
dat_new %>% 
  nest(-crs_name) %>%
  mutate(fit = map(data, ~lmer(numgrade ~ gpao + female + urm + firstgen + transfer + lowincomeflag + international
                               + (1|crs_term), data = .)), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit) %>%
  mutate(p.value = round(p.value, digits = 4)) 

#export model outputs from each course
write.csv(main_fx_all, paste0("mixed_model_outputs_main_effects_",current_date,".csv"))
write.csv(main_fx_urm, paste0("mixed_model_outputs_main_effects_urm_",current_date,".csv"))


