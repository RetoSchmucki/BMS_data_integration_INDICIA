-- LIST ALL LOCATION ATTRIBUTES WITH POSSIBLE TERMS (compact ouput)

SELECT
   la.caption,			-- name of the attribute
   la.description,      -- description of attribute
   la.id,				-- id to link attribute value to location
   la.data_type,		-- format of the attribute (T:text, I:integer, float:numeric, L:termlist, B:boolean)
   la.termlist_id,		-- id in the term list (termlist)
   STRING_AGG(ctt.term, ', ' ORDER BY ctt.sort_order), -- list of terms
   la.created_on
FROM
   location_attributes AS la		                                                    -- the reference table for location attributes
    JOIN location_attributes_websites AS law ON law.location_attribute_id = la.id		-- define the key to JOIN the tables
          AND law.website_id = 118													    -- filter for the EBMS project
		  AND law.restrict_to_survey_id = 562
    LEFT JOIN cache_termlists_terms AS ctt ON ctt.termlist_id = la.termlist_id
GROUP BY la.caption, la.description, la.id, la.data_type, la.termlist_id, la.created_on
ORDER BY la.id;


/*
LOCATION AND LOCATION ATTRIBUTES
for a specific transect
*/
SELECT 
loc.*,
ST_AsEWKT(loc.centroid_geom) as WKT_centroid_geom,
ST_AsEWKT(loc.boundary_geom) as WKT_boundary_goem,
ctt.term as location_type_term,
lav_se.int_value as "Sensitive",
lav_sl.int_value as "Section length (m)", 
lav_ns.int_value as "Number of sections", 
ctt_trw.term as "Transect Width (m)",
ctt_prhab.term as "Principal Habitat",
ctt_pr_hab.term as "Primary Habitat Present",
ctt_sechab.term as "2nd Habitat",
ctt_se_hab.term as "2nd Habitat Present",
ctt_prlt.term as "Principal Land Tenure",
ctt_seclt.term as "2nd Land Tenure",
ctt_prlmngt.term as "Principal Land Management",
ctt_seclmngt.term as "2nd Land Management",
lav_notelu.text_value as "Note on landuse",
lav_notehab.text_value as "Notes on habitat, land management and tenure",
lav_cn.int_value as "Country location_id",
loc_cn.name as "Country name",
loc_cn_sct.name as "Transect Country name"
FROM locations as loc
-- number of sections         
LEFT JOIN location_attribute_values AS lav_ns ON lav_ns.location_id = loc.id AND lav_ns.location_attribute_id = 216
-- transect_width(m)
LEFT JOIN location_attribute_values AS lav_trw ON lav_trw.location_id = loc.id AND lav_trw.location_attribute_id = 218
LEFT JOIN cache_termlists_terms AS ctt_trw ON ctt_trw.id = lav_trw.int_value
-- sensitive(b)
LEFT JOIN location_attribute_values AS lav_se ON lav_se.location_id = loc.id AND lav_se.location_attribute_id = 219
-- section_length(m)
LEFT JOIN location_attribute_values AS lav_sl ON lav_sl.location_id = loc.id AND lav_sl.location_attribute_id = 220
-- principal habitat
LEFT JOIN location_attribute_values AS lav_prhab ON lav_prhab.location_id = loc.id AND lav_prhab.location_attribute_id = 221
LEFT JOIN cache_termlists_terms AS ctt_prhab ON ctt_prhab.id = lav_prhab.int_value
-- 2nd habitat
LEFT JOIN location_attribute_values AS lav_sechab ON lav_sechab.location_id = loc.id AND lav_sechab.location_attribute_id = 222
LEFT JOIN cache_termlists_terms AS ctt_sechab ON ctt_sechab.id = lav_sechab.int_value
-- principal land tenure
LEFT JOIN location_attribute_values AS lav_prlt ON lav_prlt.location_id = loc.id AND lav_prlt.location_attribute_id = 223
LEFT JOIN cache_termlists_terms AS ctt_prlt ON ctt_prlt.id = lav_prlt.int_value
-- second land tenure
LEFT JOIN location_attribute_values AS lav_seclt ON lav_seclt.location_id = loc.id AND lav_seclt.location_attribute_id = 224
LEFT JOIN cache_termlists_terms AS ctt_seclt ON ctt_seclt.id = lav_seclt.int_value
-- principal land management
LEFT JOIN location_attribute_values AS lav_prlmngt ON lav_prlmngt.location_id = loc.id AND lav_prlmngt.location_attribute_id = 225
LEFT JOIN cache_termlists_terms AS ctt_prlmngt ON ctt_prlmngt.id = lav_prlmngt.int_value
-- second land management
LEFT JOIN location_attribute_values AS lav_seclmngt ON lav_seclmngt.location_id = loc.id AND lav_seclmngt.location_attribute_id = 226
LEFT JOIN cache_termlists_terms AS ctt_seclmngt ON ctt_seclmngt.id = lav_seclmngt.int_value
-- Notes on Land use and management
LEFT JOIN location_attribute_values AS lav_notelu ON lav_notelu.location_id = loc.id AND lav_notelu.location_attribute_id = 232
-- Notes on habitat
LEFT JOIN location_attribute_values AS lav_notehab ON lav_notehab.location_id = loc.id AND lav_notehab.location_attribute_id = 227
-- primary habitat present
LEFT JOIN location_attribute_values AS lav_pr_hab ON lav_pr_hab.location_id = loc.id AND lav_pr_hab.location_attribute_id = 228
LEFT JOIN cache_termlists_terms AS ctt_pr_hab ON ctt_pr_hab.id = lav_pr_hab.int_value
-- secondary habitat_present
LEFT JOIN location_attribute_values AS lav_se_hab ON lav_se_hab.location_id = loc.id AND lav_se_hab.location_attribute_id = 229
LEFT JOIN cache_termlists_terms AS ctt_se_hab ON ctt_se_hab.id = lav_se_hab.int_value
-- country
LEFT JOIN location_attribute_values AS lav_cn ON lav_cn.location_id = loc.id AND lav_cn.location_attribute_id = 233 
LEFT JOIN locations AS loc_cn ON loc_cn.id = lav_cn.int_value
-- parent country
LEFT JOIN location_attribute_values AS lav_cn_sct ON lav_cn_sct.location_id = loc.parent_id AND lav_cn_sct.location_attribute_id = 233 
LEFT JOIN locations AS loc_cn_sct ON loc_cn_sct.id = lav_cn_sct.int_value
-- location type term
LEFT JOIN cache_termlists_terms AS ctt ON ctt.id = loc.location_type_id 
WHERE loc.id = 370832 OR loc.parent_id = 370832
ORDER BY
	CASE
		WHEN loc.code ~ '^S\d' THEN substring(loc.code FROM 2)::integer
		ELSE 0 
	END;
