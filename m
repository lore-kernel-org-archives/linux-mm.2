Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1909C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BF86B00A4; Fri, 10 Jul 2026 11:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643276B00A6; Fri, 10 Jul 2026 11:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5814D6B00A7; Fri, 10 Jul 2026 11:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3359E6B00A4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:23:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A28A4C1125
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:23:28 +0000 (UTC)
X-FDA: 84973236096.01.6E4E0E9
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A34D40012
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:23:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Zu/ldDhz";
	spf=pass (imf07.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783697005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QWE7xPSwPltB6r6UMmtvXNm8Cw2p/v8eUDinWtX74Ps=;
	b=U6ophurf8FOqIZD1//My+t44Emo8jnSYP37poUjC0ks3zollJkd7BcUlzeS7AOdjoB087O
	l87/reQzmy3AvYJwHk9qQhnNlpWqM51CywFJm7n73GBTko3l6iXS0WZOZ9WDPcu1FGMxlX
	+JfRh3ZirQ4jvnh/xreOUBN2aIf5zFY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Zu/ldDhz";
	spf=pass (imf07.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783697005;
	b=copw4U5U1OeqC6CLYx3KnRKUMJVxNXoPlQDGgmClnjhxjV05DRAjD/xqmAijQ/KLO4Wean
	lxeFNSxRNRVTh66GvWvy9zpTMjI+FNd6yaspmn5mVydY8ID0kVskACDiJrO9jmW9oUcpAE
	A/umqCRjoVzAci/gR01fXLXdsiBIC4M=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493c1efb503so1164195e9.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783697004; x=1784301804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QWE7xPSwPltB6r6UMmtvXNm8Cw2p/v8eUDinWtX74Ps=;
        b=Zu/ldDhzjqtGvlnT6aSEVKHQQNuTdZdF+VCtJXKzJh0FqVzGjJcz/S9fqlZxQUxpDl
         hRM/PXogHqDu/dzzkbibXb1T+nbLSG/X5BcggqctIe/CEXdfbLsdiI82CQ9hCob0TeLN
         pHucDXHaMhqvG+T52HI8aQfP1igjuCRY5JI1csmadmLMHiqPZGkGFjrX2YfvP5Fe5BOw
         A+mVm1LdWPJx6dQlBnfOghILA1fGAFBXN+8q131iUWjU2T74nw/aujDK+y98vmwoSTgx
         bpg4v1Vw71tsMtBLGO2NsukSGRIwAonvhP4biHdM29jsG0MT2mWy++rs55JXSQiEsf4k
         Ep7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783697004; x=1784301804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QWE7xPSwPltB6r6UMmtvXNm8Cw2p/v8eUDinWtX74Ps=;
        b=jVKOGnWHTRluZWATH0ApDCRBEDHV5Fu1L4f7FaOvzHkHx1P0cJ1aC9mKKV0juT7689
         XVqYMLu/FmGNAMs+0u+WK05HtrP9YLDEKJ2k2EoJib7SQG/bNhXyia+DDMa78aFJ0EJi
         o/YCp1+EBuWAmgxI4O2VSTLn5zSRlnaRoLDxbRYsd7wo6aZUoTo7IDefM3kKAWl64OQO
         9R1I9YOLdHxJeVbk+kwLJzyn3YQ57WVDlhIrrFaRMPoGX8hG5VSjwI6mtb0SHKDA+U64
         bNztaukEJqhXusJiMmxy/V96tMtSgR3ywsPrApuWN0oOSqXF971TGWV3ISFw7av+jS/L
         B6kw==
X-Forwarded-Encrypted: i=1; AHgh+RpHVsF46WDHlBtBC75yr9O423V8+vsQancROEVEvQtV4gvgWpXVxp9SIfokF/bT7Xp1lQaxKDbfeQ==@kvack.org
X-Gm-Message-State: AOJu0YzjdFWEgKlkXs1iQkNvqyCeb84K7qZTWQKYFMRrAnTr6eFh4y5K
	GVIh1933Eyz3XT32njiMEPa+moCQ96P8E4cPQcSu4Zzzis5v56JhO+lX6yaVzA7WuM8=
X-Gm-Gg: AfdE7cmeuHAjDdYs7OEj6z/mdnxBB2roePdCY/SBxADwvSHTM+hDNJKXvvP8GZE0BA/
	FiIvWBQMv50TzCr3/a7Ha/OMwgC2v1uMiQyK0W0GWhmfxQxGlUTQWOnOSguoJJXOdGtwqoq1JLB
	acrvWbCa/VQKfHAiGd0pKINR6IzRSfJAHd3dMeJOQ9kxLiERyKxEaIqPWf8fXlfCdKNITds9pw2
	N76Sg3bz7UNXegL7wpoh73rEEHwKRV8TYPB6JtmrvbY2Qo+2LRu2lGxdJvKRzkmMCNpYmrrDJvW
	jlZP+YnLpKhuyQeKKGrpt713KiFqE6jeEq2xgFlFKUi96No0hpaVBhqwOmaBmvFfjTEfjyIHuxC
	vHEEnPae0U+ruEeNabjQWXyoxFY1xN/VxAkXNukcrabQZ6xethwcNAA2NCT2cGKIkn7r8HLZhxm
	7sed3xZPVxF3RbqIOcaCWd8dv3ukvHZAWg7WBD9WyFW+wxyxhDaR08kFD9/KOpvJssl233+JiiV
	76x0NI=
X-Received: by 2002:a05:600c:828c:b0:490:b227:da9b with SMTP id 5b1f17b1804b1-493e6820934mr72249405e9.1.1783697003790;
        Fri, 10 Jul 2026 08:23:23 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2dd8376sm41088125e9.2.2026.07.10.08.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 08:23:23 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Cc: Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v3 1/1] mm: let node_reclaim() return the number of pages reclaimed
Date: Fri, 10 Jul 2026 17:23:20 +0200
Message-ID: <20260710152320.2024283-1-ptesarik@suse.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A34D40012
X-Stat-Signature: bijhnya84hygcwfu4qp9tkrimn6pw489
X-HE-Tag: 1783697005-253408
X-HE-Meta: U2FsdGVkX18SCJC0BCRmm6TKcfcwSoOq78g8dW1XYigNDGmTuUCSFdXiny3ALA0S3OusSxmOrrC9CB5DuInenwoenEWo8FS7jsEIz2zxMNXXF5MQaaUKB7aybA1opq11n3zuL0++azOEh4xInnnjKoETTSlnTDzryqb35Opi4kDPcWBW0GK8y/DBALx1FcuWBnARHYnr+ixA4Uj/y9R/fIi4EVnU6GzV/4yMtCtOJSh3JUWV99pd8iX8OQqpsu8Pox9SiBssZwzeMznuAiukWsGZrba8r1oNbZPn6NHfjJ4CMy6A8wjbyY/8+HlCprXZR9RK5UKZgWfFuAhtGnETe9miYr9Ndw6TjiDP3as+9eNa4ZIBDH+31Pyt0dWbF0wK6go0grt8fw9KA41e8TVcFDgWpPDo7QwXA7IYsjlNApf4e6RTh7riWPzhX4WYmluasliPuk0/EjA84/ksfv3sDmXMV0R2kR0pxvMiC8a/vZjrut6In3V51ff4b5gNNAA3/OY8dXDMW/UqpHfaXQvQ8WteN6kksWaViaTLGT88U/i1M0HT6Zd0TGlkLNnOkGz7xdSdHAHOgNL2DK1gznGtmcMPObWMQDsEq+gyjAGBCQtD6PVgW4yBYa74RMuWMgw++bBfAgB8Qp3mcTx77y/TtQLHaJq+DVblr98rzlcSlSv60y1GObSeHmlfcIHd8Puz2i+qBdXmiKB+HrpKbgCue8SzdURXENafWnFs6VZHMhm0xrgJMI5ZiNEQ8jqESJd2EZnoNy93ZcRRCc/im/RAn5V6b9OWu8VBDRpm8WPVWgkGxtShAF7Y+RbXa/WmAqEN5eRqLSSqlafba3F+Eh+uuX5iWu1/Njdg7BMfByxsmLysAJQin1UhHXwM2pipSA49SX3vndX7I4J180PYbQLBz4L04ENj42XBWgBTP/Gk4VaU66loWGcmy9oUjhidpXjcpIWnynFGFjhVHVwkukY
 QV3CGSst
 p0jYjMCyYlTzVXFzTcwLk7HkI0Z2Tdl/hKb3Z04B7e88kVr8dFHLwjDHTf7870aoEPEWDtNZSkGGSCC95GlkMlXYoPIdzQxQ+oGcvQBdL0pXhs92L5Mqk4rynCXYjcsE/IAMZPLzjh/MC80IRQhGZfPHKbjZt5mTGqYc+YyW2KlcIQiO8aOinNG71BSMJyRw1nKLxt5WmsYzHc4YCp2a3FpMDYVVvA4j1Uac1+TgOfT3ss0i4Z9q7g0fwePcnegM4cNhjP5EfbD721s3B2A93sgOGtSzShBsHkJockJWO66lq0KXPNF0jv1M0QDugigBenBy6Fzonr/1Hf3dQ4VlJIcMo0aNT8eyLUqySsPa47w4dPxX6KFxA+pYYhUzI+T9MGEb6bxpgzaRHGz4323HIrHe3CSRAR2Nowvr1btq+m59asmSLof95Q0q3Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is only one caller, get_page_from_freelist(), and it does not make
any use of the reason for skipping the reclaim, nor does it make any
distinction between a full and partially successful reclaim.

Therefore, node_reclaim() can simply return the number of pages that have
been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macros
can be removed.

There is one small change of behavior when __node_reclaim() was attempted
but returned zero. The allocation now skips the zone immediately; before
this patch, the zone watermarks were checked first. I believe it was an
oversight rather than intention, because the chances that zone watermark is
OK after __node_reclaim() did not reclaim any pages are very close to zero.

Originally, I was looking for occurences of NODE_RECLAIM_SOME and
NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because they are
typecast from the result of a relational operator. This seemed a bit
fragile, so I dug a bit deeper and came up with this proposed cleanup.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>

--

Changes from v2:
- remove the enum and return the number of pages reclaimed

Changes from v1:
- use an enum instead of a bool
---
 mm/internal.h   |  9 +++++----
 mm/page_alloc.c | 19 ++++---------------
 mm/vmscan.c     | 16 ++++++++--------
 3 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e5dcab69eb4f6..585705daad1a5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1102,15 +1102,16 @@ static inline void mlock_drain_remote(int cpu) { }
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+extern unsigned long node_reclaim(struct pglist_data *pgdat,
+				  gfp_t gfp_mask, unsigned int order);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
+static inline unsigned long node_reclaim(struct pglist_data *pgdat,
+					 gfp_t mask, unsigned int order)
 {
-	return NODE_RECLAIM_NOSCAN;
+	return 0;
 }
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c97a86da2b9f..af63558391345 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3908,8 +3908,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			int ret;
-
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -3930,22 +3928,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
-			switch (ret) {
-			case NODE_RECLAIM_NOSCAN:
-				/* did not scan */
-				continue;
-			case NODE_RECLAIM_FULL:
-				/* scanned but unreclaimable */
+			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
 				continue;
-			default:
-				/* did we reclaim enough */
-				if (zone_watermark_ok(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags))
-					goto try_this_zone;
 
+			/* did we reclaim enough */
+			if (!zone_watermark_ok(zone, order, mark,
+					       ac->highest_zoneidx, alloc_flags))
 				continue;
-			}
 		}
 
 try_this_zone:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f8faa7d06329b..639ea6175c98d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7800,9 +7800,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
-	int ret;
+	unsigned long ret;
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -7829,13 +7829,13 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
 	    pgdat->min_slab_pages)
-		return NODE_RECLAIM_FULL;
+		return 0;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
 	/*
 	 * Only run node reclaim on the local node or on nodes that do not
@@ -7844,15 +7844,15 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	 * as wide as possible.
 	 */
 	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-	if (ret)
+	if (ret >= nr_pages)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
 	else
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
-- 
2.54.0


