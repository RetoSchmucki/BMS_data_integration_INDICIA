-- LIST ALL OCCURRENCE ATTRIBUTES WITH POSSIBLE TERMS (compact ouput)

SELECT DISTINCT
   oa.caption,			-- name of the attribute
   oa.description,      -- description of attribute
   oa.id,				-- id to link attribute value to location
   oa.data_type,		-- format of the attribute (T:text, I:integer, float:numeric, L:termlist, B:boolean)
   oa.termlist_id,		-- id in the term list (termlist)
   STRING_AGG(ctt.term, ', ' ORDER BY ctt.sort_order), -- list of terms
   oa.created_on
FROM
   occurrence_attributes AS oa		                                                    -- the reference table for location attributes
    JOIN occurrence_attributes_websites AS oaw ON oaw.occurrence_attribute_id = oa.id		-- define the key to JOIN the tables
          AND oaw.website_id = 118													    -- filter for the EBMS project
		  AND oaw.restrict_to_survey_id = 562
    LEFT JOIN cache_termlists_terms AS ctt ON ctt.termlist_id = oa.termlist_id
GROUP BY oa.caption, oa.description, oa.id, oa.data_type, oa.termlist_id, oa.created_on
ORDER BY oa.id;

/*
OCCURRENCE AND OCCURRENCE ATTRIBUTES
OPTIMISED SUBSET
*/
SELECT 
tltbls.term as "Butterfly life stage",
oav_abc.int_value as "Abundance count",
tltotc.term as "Outside Transect Count",
tltdrs.term as "Dragonfly Stage",
cttl.preferred_taxon as species_name_prefered,
taxlat.taxon as species_name,
occ.*
FROM
   (SELECT oc.*
    FROM
    occurrences as oc
    WHERE oc.id IN 
        (SELECT
                cof.id 
            FROM 
                cache_occurrences_functional as cof
            WHERE 
                cof.website_id = 118 AND 
                cof.survey_id = 562 AND 
                cof.training = FALSE AND
                cof.location_id IN (SELECT id FROM locations WHERE id = 370832 OR parent_id = 370832)) 
    LIMIT 100) as occ
    LEFT JOIN occurrence_attribute_values AS oav_bls ON oav_bls.occurrence_id = occ.id AND oav_bls.occurrence_attribute_id = 293
    LEFT JOIN cache_termlists_terms tltbls on tltbls.id = oav_bls.int_value
    LEFT JOIN occurrence_attribute_values AS oav_abc ON oav_abc.occurrence_id = occ.id AND oav_abc.occurrence_attribute_id = 780
    LEFT JOIN occurrence_attribute_values AS oav_otc ON oav_otc.occurrence_id = occ.id AND oav_otc.occurrence_attribute_id = 911
    LEFT JOIN cache_termlists_terms tltotc on tltotc.id = oav_otc.int_value
    LEFT JOIN occurrence_attribute_values AS oav_drs ON oav_drs.occurrence_id = occ.id AND oav_drs.occurrence_attribute_id = 988
    LEFT JOIN cache_termlists_terms tltdrs on tltdrs.id = oav_drs.int_value
    LEFT JOIN cache_taxa_taxon_lists as cttl on cttl.id = occ.taxa_taxon_list_id
    LEFT JOIN taxa_taxon_lists as ttl on ttl.taxon_meaning_id = cttl.taxon_meaning_id
	LEFT JOIN taxa as taxlat on taxlat.id = ttl.taxon_id
LIMIT 10
;



