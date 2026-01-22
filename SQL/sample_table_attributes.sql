-- LIST ALL SAMPLE ATTRIBUTES WITH POSSIBLE TERMS (compact ouput)

SELECT DISTINCT
   sa.caption,			-- name of the attribute
   sa.description,      -- description of attribute
   sa.id,				-- id to link attribute value to location
   sa.data_type,		-- format of the attribute (T:text, I:integer, float:numeric, L:termlist, B:boolean)
   sa.termlist_id,		-- id in the term list (termlist)
   STRING_AGG(ctt.term, ', ' ORDER BY ctt.sort_order), -- list of terms 
   sa.created_on
FROM
   sample_attributes AS sa		                                                    -- the reference table for location attributes
    JOIN sample_attributes_websites AS saw ON saw.sample_attribute_id = sa.id		-- define the key to JOIN the tables
          AND saw.website_id = 118													    -- filter for the EBMS project
		  AND saw.restrict_to_survey_id = 562
    LEFT JOIN cache_termlists_terms AS ctt ON ctt.termlist_id = sa.termlist_id
GROUP BY sa.caption, sa.description, sa.id, sa.data_type, sa.termlist_id, sa.created_on
ORDER BY sa.id;



/*
SAMPLE AND SAMPLE ATTRIBUTES
Ten example visits from random locations in 2024
*/
SELECT 
'Lastname, Firstname' as "Recorder Name", -- anonymise
sav_st.text_value as "Start Time",
sav_et.text_value as "End Time",
tltw.term as "Wind Direction",
tltws.term as "Wind Speed",
tlttc.term as "Temp (Deg C)",
tltr.term as "Reliability",
sav_sun.int_value as "Sun (%)",
sav_cloud.int_value as "Cloud (%)",
sav_but.int_value as "anyButterflies?",
sav_mot.int_value as "anyMoths?",
sav_bum.int_value as "anyBumblebees?",
sav_dra.int_value as "anyDragonflies?",
samp.*
FROM
    (SELECT sam.*
    FROM
    samples as sam
    WHERE sam.id IN 
        (SELECT
                sa.id 
            FROM 
                cache_samples_functional as sa
            WHERE 
                sa.survey_id = 562 AND 					-- EBMS Transect survey
                sa.parent_sample_id IS NULL AND			-- Parent (Visit) samples
                sa.training = FALSE AND					-- Not training
                extract(year FROM sa.date_start) = 2024)-- Visits from 2024
    LIMIT 10) as samp
    -- recorder name
    LEFT JOIN sample_attribute_values AS sav_rn ON sav_rn.sample_id = samp.id AND sav_rn.sample_attribute_id = 1384
    -- start time
    LEFT JOIN sample_attribute_values AS sav_st ON sav_st.sample_id = samp.id AND sav_st.sample_attribute_id = 1385
    -- end time
    LEFT JOIN sample_attribute_values AS sav_et ON sav_et.sample_id = samp.id AND sav_et.sample_attribute_id = 1386
    -- temperature
    LEFT JOIN sample_attribute_values as sav_temp on sav_temp.sample_id = samp.id and sav_temp.sample_attribute_id = 1660
    LEFT JOIN cache_termlists_terms tlttc on tlttc.id = sav_temp.int_value
    -- wind direction
    LEFT JOIN sample_attribute_values as sav_wind on sav_wind.sample_id = samp.id and sav_wind.sample_attribute_id = 1389
    LEFT JOIN cache_termlists_terms tltw on tltw.id = sav_wind.int_value
    -- wind speed
    LEFT JOIN sample_attribute_values as sav_wind_speed on sav_wind_speed.sample_id = samp.id and sav_wind_speed.sample_attribute_id = 1390
    LEFT JOIN cache_termlists_terms tltws on tltws.id = sav_wind_speed.int_value
    -- % sun
    LEFT JOIN sample_attribute_values as sav_sun on sav_sun.sample_id = samp.id and sav_sun.sample_attribute_id = 1387
    -- % cloud
	LEFT JOIN sample_attribute_values as sav_cloud on sav_cloud.sample_id = samp.id and sav_cloud.sample_attribute_id = 1457
    -- reliability
    LEFT JOIN sample_attribute_values as sav_re on sav_re.sample_id = samp.id and sav_re.sample_attribute_id = 1393
    LEFT JOIN cache_termlists_terms tltr on tltr.id = sav_re.int_value
    -- butterflies
    LEFT JOIN sample_attribute_values as sav_but on sav_but.sample_id = samp.id and sav_but.sample_attribute_id = 1658
    -- moths
    LEFT JOIN sample_attribute_values as sav_mot on sav_mot.sample_id = samp.id and sav_mot.sample_attribute_id = 1659
    -- bumblebees
    LEFT JOIN sample_attribute_values as sav_bum on sav_bum.sample_id = samp.id and sav_bum.sample_attribute_id = 1921
    -- dragonflies
    LEFT JOIN sample_attribute_values as sav_dra on sav_dra.sample_id = samp.id and sav_dra.sample_attribute_id = 1921
;



