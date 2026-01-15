-- SURVEY and WEBSITE ID

SELECT
surveys.*
FROM surveys
WHERE 
website_id = 118 AND    -- filter for the EBMS project
id = 562;               -- filter for EBMS Transects