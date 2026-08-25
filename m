Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E6CC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 04:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF976B0095; Tue, 25 Aug 2026 00:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088CB6B0096; Tue, 25 Aug 2026 00:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0376B0099; Tue, 25 Aug 2026 00:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6E2E6B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:39:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5930E1C16F3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:12 +0000 (UTC)
X-FDA: 85138537344.14.AEFED3F
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9930140002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ezx7Ogw8;
	spf=pass (imf11.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787632750;
	b=Jminv6ty5vuMRohrEjxaYJMc+dLfwOCiS2dmo89MztBOyNbxie4MKXdly9P7HVC7gAgP2Y
	vq2Y8v37SNBiJSeTf1zS9bSFVhKju27QFOucF6uTX0ClLObe4534ANR0eYiL23cMqLSvIQ
	VIdykR96Qj7oXhgO65drBD8600+B8CU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ezx7Ogw8;
	spf=pass (imf11.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787632750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ6nX8pkGtbAXbIikOXYsenna9XbdloYL6dA4yPYQqw=;
	b=zLL6YaWsOXHnFOrZuQ0DIV3hSG0zT7Z6GF1BfsbqMM4fv2Ln0me/YaRXxa5knIJiSKaMv5
	jZqgIm+K7mn+z0fH10jalXZrUANuQMf218vtX3rYxUgS3AJnFQQG7b8D4hjcOsT0OWUxcT
	u3AdBq26WCsoIvD4ePAT3NF7EEVlsHo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ced3386430so43761295ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787632749; x=1788237549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NZ6nX8pkGtbAXbIikOXYsenna9XbdloYL6dA4yPYQqw=;
        b=Ezx7Ogw8lMkRSZ5RsByhFd4zZBiZeMxZSOAermCp3jk4jV2YobwPxP+Mm3YC+Pe8DO
         b5WDNzMS6a7DoSkbtx+hNMsnQF7ZpQVk5bzQKaOudIVdFdURMzZOLqhRV4svCvX4VT33
         oaR5ZcUU9zytXfLWC0IY+vC/oWoBMbyr+ymP7lz3Tspe+jWSXMJ1Y0H8M1EG6pTf0NTR
         vh24cHBEn4V/4Fa8B2UizRihfvU3UXmD11TBY4y3aikLLTmlZ3bSFnASeVWtSZ9I7IYo
         78hRpsjqFBskmd+vUBfXoMViup9mjjjl8VLQhZhzohvczywYTu/fQfOW3PU88jDohYPl
         J3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787632749; x=1788237549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NZ6nX8pkGtbAXbIikOXYsenna9XbdloYL6dA4yPYQqw=;
        b=pzZHqVu1MKzQX7OnISBIZMwDdK7Cm8+8fPgufJj09oceDP1xkySFjkmsOxOnTiAI71
         h9qUaqHdX0pvko42wbCumEtUUGTy2JXUi6WF327h8gJhh6qaSNeCGMivpuvVCHRiwHqr
         4F/dZufFKqlH/KsnbcNt+L755fPzow4hlaSh3wR3C6asVcU/mZaxYVBKIsiPdpVXdBlQ
         y0vNby6AuzyOlcjUPrj0uih+2uXuOaaPGzDdVFYxASxSMBLazqLxpwVsJ4yELjivwxqb
         OMI6LzGfTvKfNWuODZTfUmgKbTmotX2x4W/cUJUbrYcjjEEx84VAd0tdzIS/scxhUi0w
         5c6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrl3KFm3STIW1mvUMXSXFPeCpz6ook1VUxi8XPGtRZ6lfMHWie1zimbvFS0SAuEsGQHUh8zExq7Wg==@kvack.org
X-Gm-Message-State: AFuF++n7x6gs+aKHu+duuOoQ3wrUkw6vka8gH7Kt0g8kBP9sZ7ln2Nwg
	2emIKbi8BHEWF93hB6SfMDBEGgCLcNk+NAdS1BoglckPQbmBttoYODIY
X-Gm-Gg: AR+sD10Mrm60i+HnU+48PipUtyWN2cYHuQQwOsx1pjTUk27krA6Fw9G8LcjrmmV5HZN
	/9FifVmM+ztnmr3wVfS2z0XF/sSh54q0HBl741QsMjECh0Nm/H/4EX2zRWRBqIl+Sj1zjGVDTo2
	WT01a6JQ6gufZ4MACFDX+ILZfvf/w5VIyQVj+Lkmqtxo1bWarnsJMaObtmFumEMoMI3hL28eAiz
	tnCIejKXg1ElmlbkwgB7k57ZadfLqPp7D/cqelgE0wAo9iEp7YFS12igBSoowDM12EYVtEHbAHA
	DzNJUXYXXq7VceKXWcsc6iEEMXGbxuy0wB2yaxUxbIELb37O3IwwTEe6wsjBKvw8vKIKnScVdSO
	Cuz4tYQKNa1CozsuDJrZfuHW94gS855Z9SNrC36NlvSZ25M2WUN1Sq6gGZlPIubyPVvx1PfQyIV
	7SXo4PrF7/3DHssSVpHYE+v4JSBMsomdDcneuFPmyA8b92H8AFJ4LgyOYUsHW12xkUZw9ePHQEm
	GxKUA==
X-Received: by 2002:a17:902:f683:b0:2d6:3c1a:85e0 with SMTP id d9443c01a7336-2d6dccfb542mr67347255ad.14.1787632749539;
        Mon, 24 Aug 2026 21:39:09 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d6f726e222sm502155ad.19.2026.08.24.21.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 21:39:09 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH 1/4] mm: compaction: make proactive compaction mTHP-aware
Date: Tue, 25 Aug 2026 12:38:30 +0800
Message-Id: <20260825043833.2659350-2-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9930140002
X-Stat-Signature: ebgf1mu6md3qqswdp1aen43npy8spar5
X-HE-Tag: 1787632750-684708
X-HE-Meta: U2FsdGVkX18LKYJoUsAuFbTfEcDWNAwmeB7xOz+j76FJTC2SHxgOieRrkO8Wk8T+SM6gey6GmnsIdpNnrg3Xh4EmtdFvRnc2lK/CxexjUQNYzXxY1hg3WXKWaNCI5L1PlrVVclUnWRvGtJ84SQKNKHEpwIoJbF9oNh2dLD7ShR0oafuWeBDMizKN/Tr6lamGB8+A4uUxkZnUwEUKBaWjW5vj41D4ZbdpP3Y4ITXC9+VcmpTKTKbFcAuFh7VO67dRt4Fl063gn60HgLOVhJ29m4eRmzIdZcO03B2Yt7WFBoWpN7G+PrPugDsFlwAzmsFbwbx6mJ6mairULh7vBsDNFP7o1/609RWBubA1lBUQiMDO7NNMwhn6AH0H7n2d2Ta5wlFsyegUtZI6G7gMtdggBgGNj7Y77RryLvC4i9+BySrvTXHb0Htq0QsZbU/eyyHJ3hPpb0lJgFCgQuxyJQzjICMHqA9Gx0meUEKg3PWUVg7dppll4w792hjfT2xhZ5H/wgpt4I6M1xjVI8Irp9zApps1F7CAIrHTPU7Dl7A9Fk9ipHVCJ4C3Ny7yNogWL9rOBuNrSqDDRVuc6t519/p6Jh04lEPG+D1jQoPygP2O6PzEnkEO/mWaF4BCR2QpW01zkXZ5Z9jrM6jEQE69ZQOlUc0GJCLfVS5XVFb8oQR8H0iScB8cEnQgYUyN7KTBbonZEC2hPhauYVcj5UcBp6OlpJikoav0vL2WjunzSm3V6XchvR2l7C1mnbG2a3H2jql1a+3csHJB+59oeLOoJCvr1L/kifCptO7qB+bepqDAVTO0TieYxC9lZUADzue2GSVnshBgR6xiD5XaLZeAsXcK59sZOdTIztKD4qXH4kpU9PvkmIAKM5o+GDDFMyFV6OaNQFrhyBeOXZ2gYW33Qz0OTBy3cIS08XFaalGpU0M83Goz9Cf95WEoTXOSE0C4KKAHZsDNOUDGnSoueAwonc/
 aWHzU4pw
 yhuPa5T5/bqyEmS+maEcX4N1Equ0+GQHhCOdJ1fduybKoPpg4sNB4KP9WnoYt1+3TlU0ZWY0Hy0a6A3lJKkkns5aOxfPraWUN8xWuspovqSC+FGSbxkk70/m2Yq4Auzao2uVSm214xd65EUL1DLCG1yGwugXqUtc0FlOZwijcl5GANf+6g5lpov5FIqjIWLf/7fMfjqtz8TZ+dgEhrGL8gxUUrmZtAq+POywyVgbNm6d/hFWcW6pQjxmgNH0buVTD2H0EWnaWshmp+1PNiJ7z0MMn3GwHOVUZ3HAOinFuBcB1iuOFOS+xG9SuEFpga+huuhD5M7qRMo28C1VQTPIeIAMvAY7X59j/8ePRDpBAf7QbwNP5RUsxZaNeWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, proactive compaction only evaluates fragmentation relative
to COMPACTION_HPAGE_ORDER (typically order-9 for 2MB THP). This makes
it unsuitable for systems that primarily need smaller high-order pages,
such as order-2 (16KB) for mTHP.

Generalize the fragmentation score functions to accept an order parameter:
  - fragmentation_score_zone(zone, order)
  - fragmentation_score_zone_weighted(zone, order)
  - fragmentation_score_node(pgdat, order)

Calculate the min order in huge_anon_orders_always to configure the target
order for proactive compaction.

This enables proactive compaction to maintain free page availability
at any order, which is particularly useful for mTHP-enabled systems
where order-n (n < 9) allocation pressure is high.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..a4f87232ad80 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/huge_mm.h>
 #include "page_alloc.h"
 #include "internal.h"
 
@@ -81,6 +82,15 @@ static inline bool is_via_compact_memory(int order) { return false; }
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #endif
 
+static inline int compact_hpage_order(void)
+{
+	unsigned long orders = READ_ONCE(huge_anon_orders_always);
+
+	if (orders)
+		return __ffs(orders);
+	return COMPACTION_HPAGE_ORDER;
+}
+
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
 	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
@@ -2208,16 +2218,16 @@ static bool kswapd_is_running(pg_data_t *pgdat)
 
 /*
  * A zone's fragmentation score is the external fragmentation wrt to the
- * COMPACTION_HPAGE_ORDER. It returns a value in the range [0, 100].
+ * compact_hpage_order(). It returns a value in the range [0, 100].
  */
-static unsigned int fragmentation_score_zone(struct zone *zone)
+static unsigned int fragmentation_score_zone(struct zone *zone, unsigned int order)
 {
-	return extfrag_for_order(zone, COMPACTION_HPAGE_ORDER);
+	return extfrag_for_order(zone, order);
 }
 
 /*
  * A weighted zone's fragmentation score is the external fragmentation
- * wrt to the COMPACTION_HPAGE_ORDER scaled by the zone's size. It
+ * wrt to the compact_hpage_order() scaled by the zone's size. It
  * returns a value in the range [0, 100].
  *
  * The scaling factor ensures that proactive compaction focuses on larger
@@ -2225,11 +2235,11 @@ static unsigned int fragmentation_score_zone(struct zone *zone)
  * ZONE_DMA32. For smaller zones, the score value remains close to zero,
  * and thus never exceeds the high threshold for proactive compaction.
  */
-static unsigned int fragmentation_score_zone_weighted(struct zone *zone)
+static unsigned int fragmentation_score_zone_weighted(struct zone *zone, unsigned int order)
 {
 	unsigned long score;
 
-	score = zone->present_pages * fragmentation_score_zone(zone);
+	score = zone->present_pages * fragmentation_score_zone(zone, order);
 	return div64_ul(score, zone->zone_pgdat->node_present_pages + 1);
 }
 
@@ -2240,7 +2250,7 @@ static unsigned int fragmentation_score_zone_weighted(struct zone *zone)
  * the node's score falls below the low threshold, or one of the back-off
  * conditions is met.
  */
-static unsigned int fragmentation_score_node(pg_data_t *pgdat)
+static unsigned int fragmentation_score_node(pg_data_t *pgdat, unsigned int order)
 {
 	unsigned int score = 0;
 	int zoneid;
@@ -2251,7 +2261,7 @@ static unsigned int fragmentation_score_node(pg_data_t *pgdat)
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
 			continue;
-		score += fragmentation_score_zone_weighted(zone);
+		score += fragmentation_score_zone_weighted(zone, order);
 	}
 
 	return score;
@@ -2269,12 +2279,13 @@ static unsigned int fragmentation_score_wmark(bool low)
 static bool should_proactive_compact_node(pg_data_t *pgdat)
 {
 	int wmark_high;
+	unsigned int order = compact_hpage_order();
 
 	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
 		return false;
 
 	wmark_high = fragmentation_score_wmark(false);
-	return fragmentation_score_node(pgdat) > wmark_high;
+	return fragmentation_score_node(pgdat, order) > wmark_high;
 }
 
 static enum compact_result __compact_finished(struct compact_control *cc)
@@ -2311,7 +2322,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 		if (kswapd_is_running(pgdat))
 			return COMPACT_PARTIAL_SKIPPED;
 
-		score = fragmentation_score_zone(cc->zone);
+		score = fragmentation_score_zone(cc->zone, compact_hpage_order());
 		wmark_low = fragmentation_score_wmark(true);
 
 		if (score > wmark_low)
@@ -3238,10 +3249,11 @@ static int kcompactd(void *p)
 		timeout = default_timeout;
 		if (should_proactive_compact_node(pgdat)) {
 			unsigned int prev_score, score;
+			unsigned int order = compact_hpage_order();
 
-			prev_score = fragmentation_score_node(pgdat);
+			prev_score = fragmentation_score_node(pgdat, order);
 			compact_node(pgdat, true);
-			score = fragmentation_score_node(pgdat);
+			score = fragmentation_score_node(pgdat, order);
 			/*
 			 * Defer proactive compaction if the fragmentation
 			 * score did not go down i.e. no progress made.
-- 
2.34.1


