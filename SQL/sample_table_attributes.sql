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
OPTIMISED SUBSET
*/
SELECT 
'Lastname, Firstname' as "Recorder Name",
sav_st.text_value as "Start Time",
sav_et.text_value as "End Time",
sav_sun.int_value as "perct_Sun",
tltw.term as "Wind Direction",
tltws.term as "Wind Speed",
tlttc.term as "Temp (Deg C)",
tltr.term as "Reliability",
sav_cloud.int_value as "perct_Cloud",
sav_but.int_value as "anyButterflies?",
sav_bum.int_value as "anyBumblebees?",
sav_dra.int_value as "anyDragonflies?",
sav_mot.int_value as "anyMoths?",
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
                sa.website_id = 118 AND 
                sa.survey_id = 562 AND 
                sa.training = FALSE AND
                extract(year FROM sa.date_start) = 2024)
    LIMIT 100) as samp
    LEFT JOIN sample_attribute_values AS sav_rn ON sav_rn.sample_id = samp.id AND sav_rn.sample_attribute_id = 1384
    LEFT JOIN sample_attribute_values AS sav_st ON sav_st.sample_id = samp.id AND sav_st.sample_attribute_id = 1385
    LEFT JOIN sample_attribute_values AS sav_et ON sav_et.sample_id = samp.id AND sav_et.sample_attribute_id = 1386
    LEFT JOIN sample_attribute_values as sav_temp on sav_temp.sample_id = samp.id and sav_temp.sample_attribute_id = 1660
    LEFT JOIN cache_termlists_terms tlttc on tlttc.id = sav_temp.int_value
    LEFT JOIN sample_attribute_values as sav_wind on sav_wind.sample_id = samp.id and sav_wind.sample_attribute_id = 1389
    LEFT JOIN cache_termlists_terms tltw on tltw.id = sav_wind.int_value
    LEFT JOIN sample_attribute_values as sav_wind_speed on sav_wind_speed.sample_id = samp.id and sav_wind_speed.sample_attribute_id = 1390
    LEFT JOIN cache_termlists_terms tltws on tltws.id = sav_wind_speed.int_value
    LEFT JOIN sample_attribute_values as sav_sun on sav_sun.sample_id = samp.id and sav_sun.sample_attribute_id = 1387
	LEFT JOIN sample_attribute_values as sav_cloud on sav_cloud.sample_id = samp.id and sav_cloud.sample_attribute_id = 1457
    LEFT JOIN sample_attribute_values as sav_re on sav_re.sample_id = samp.id and sav_re.sample_attribute_id = 1393
    LEFT JOIN cache_termlists_terms tltr on tltr.id = sav_re.int_value
    LEFT JOIN sample_attribute_values as sav_but on sav_but.sample_id = samp.id and sav_but.sample_attribute_id = 1658
    LEFT JOIN sample_attribute_values as sav_bum on sav_bum.sample_id = samp.id and sav_bum.sample_attribute_id = 1921
    LEFT JOIN sample_attribute_values as sav_mot on sav_mot.sample_id = samp.id and sav_mot.sample_attribute_id = 1659
    LEFT JOIN sample_attribute_values as sav_dra on sav_dra.sample_id = samp.id and sav_dra.sample_attribute_id = 1921
WHERE
sav_st.text_value IS NOT NULL
LIMIT 10
;



