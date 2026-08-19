WITH facebook_data AS (

    SELECT
        f.ad_date,
        c.campaign_name,
        a.adset_name,
        f.spend,
        f.impressions,
        f.reach,
        f.clicks,
        f.leads,
        f.value
    FROM facebook_ads_basic_daily AS f

    LEFT JOIN facebook_adset AS a
        ON f.adset_id = a.adset_id

    LEFT JOIN facebook_campaign AS c
        ON f.campaign_id = c.campaign_id
),

combined_data AS (

    SELECT
        ad_date,
        'Facebook Ads' AS media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM facebook_data

    UNION ALL

    SELECT
        ad_date,
        'Google Ads' AS media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM google_ads_basic_daily
)

SELECT
    ad_date,
    media_source,
    campaign_name,
    adset_name,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_conversion_value
FROM combined_data
GROUP BY
    ad_date,
    media_source,
    campaign_name,
    adset_name
ORDER BY
    ad_date,
    media_source,
    campaign_name,
    adset_name;
