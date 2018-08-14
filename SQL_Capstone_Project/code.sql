/* Get familiar with CoolTShirts */
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
ORDER BY 2;

/* What pages are on the CoolTShirts website */
SELECT DISTINCT page_name
FROM page_visits;

/* What is the user journey? */
/* First-Touch by campaign */
WITH first_touch AS (
 SELECT user_id, MIN(timestamp) as 'first_touch_at'
 FROM page_visits
 GROUP BY user_id),
ft_camp AS(
SELECT ft.user_id, ft.first_touch_at, pv.utm_source, pv.utm_campaign
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
 ON ft.user_id = pv.user_id
 AND ft.first_touch_at = pv.timestamp
)
SELECT ft_camp.utm_source AS 'First-Touch Source', ft_camp.utm_campaign AS 'First-Touch Campaign', COUNT(*) AS 'Count'
FROM ft_camp
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Last-Touch by campaign */
WITH last_touch AS (
 SELECT user_id, MAX(timestamp) as 'last_touch_at'
 FROM page_visits
 GROUP BY user_id),
lt_camp AS(
SELECT lt.user_id, lt.last_touch_at, pv.utm_source, pv.utm_campaign, pv.page_name
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
 ON lt.user_id = pv.user_id
 AND lt.last_touch_at = pv.timestamp
)
SELECT lt_camp.utm_source AS 'Last-Touch Source', lt_camp.utm_campaign AS 'Last_Touch Campaign', COUNT(*) AS 'Count'
FROM lt_camp
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Count where visitors = purchase > 2 options */
SELECT COUNT(DISTINCT user_id) AS 'Purchase Count'
FROM page_visits
WHERE page_name = '4 - purchase';

SELECT page_name AS 'Page Name', COUNT(DISTINCT user_id) AS 'Count'
FROM page_visits
GROUP BY page_name;

/* Last-Touch by campaign */
WITH last_touch AS (
 SELECT user_id, MAX(timestamp) as 'last_touch_at'
 FROM page_visits
  WHERE page_name = '4 - purchase'
 GROUP BY user_id),
lt_camp AS(
SELECT lt.user_id, lt.last_touch_at, pv.utm_source, pv.utm_campaign, pv.page_name
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
 ON lt.user_id = pv.user_id
 AND lt.last_touch_at = pv.timestamp
)
SELECT lt_camp.utm_source AS 'Last-Touch Purchase Source', lt_camp.utm_campaign AS 'Last-Touch Purchase Campaign', COUNT(*) AS 'Purchase Count'
FROM lt_camp

GROUP BY 1, 2
ORDER BY 3 DESC;

/* First-Touch total count */
WITH first_touch AS (
 SELECT user_id, MIN(timestamp) as 'first_touch_at'
 FROM page_visits
 GROUP BY user_id),
ft_camp AS(
SELECT ft.user_id, ft.first_touch_at, pv.utm_source, pv.utm_campaign
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
 ON ft.user_id = pv.user_id
 AND ft.first_touch_at = pv.timestamp
)
SELECT COUNT(*) AS 'Count'
FROM ft_camp;
