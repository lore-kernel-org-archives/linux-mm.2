Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CF2D33995
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874EC6B0323; Fri,  5 Dec 2025 18:32:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7446B0325; Fri,  5 Dec 2025 18:32:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58DEB6B0326; Fri,  5 Dec 2025 18:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 482CE6B0323
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:32:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04C94160365
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:23 +0000 (UTC)
X-FDA: 84187018608.03.1760869
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 148581C0013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uv652qC4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764977542; a=rsa-sha256;
	cv=none;
	b=k/3Ken7n2qc0NMcKhus5hieadyKlL0hU+n/K0wXLUXVHm0GrwUM7ORvsaGQsaolSylMOgu
	9k/cuG3sCESFYCcwtHzI55ESIT1f9WbSLDHRzs51onsGU9ez3tz2/wyKH5V9p8PkQcAC1U
	NEAn7FuL2k/Wx3xd/AchhpHTSr3GKGo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uv652qC4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764977542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3N6g0zC5PiFKht2Nr2Q2t2kJmA7KR7Ut4l5xQUtIjXQ=;
	b=Bwqv0E3ARwepwsIqBNVbyYQLqWkVV5KqHpRDSkJAHE6HKMJS8dZiEIqUo/nbq/W5k0Y/+V
	JNw4TObB7Jcvee8al9yuqiPjhzdLlb5oSJekQtCyeb7TUgGR7gMGo0jhVKzyaLxAB2hSnW
	csCwV5RNMwIgmbjcyNQUIx+SFJ/adm8=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-63fc6d9fde5so2660971d50.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 15:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764977541; x=1765582341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3N6g0zC5PiFKht2Nr2Q2t2kJmA7KR7Ut4l5xQUtIjXQ=;
        b=Uv652qC4F4RMymkqx9F+LE4nTsIlUHyEA60C6aU6nb2rKrIgZTfh4XanTo1A5Yloi/
         X7DTLCNjH9QsSiFSJteS9jUWbaV+2ylMCOTEbItFh4P5w8fv/Li1jIXuWclkyFPEFC1Y
         sKR2NUQGg3UEbWu3HD7F/cb3dGBSEDbMho/wxR/a4aI/oRJMLz/F4tKSQTsy88u4kKug
         2Zp7Rgm726IOZetKfk72v4MU+Egk+IIX7+gYZ1gONe9bND86clKMY6jqQJjnc7WACoyw
         TzSgtwNvwodIX7fUb+7udVBracwOajZAoMuYgNyNMsJ3mNxQBa+kGXoRlzOXf7hVYDZk
         3XHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977541; x=1765582341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3N6g0zC5PiFKht2Nr2Q2t2kJmA7KR7Ut4l5xQUtIjXQ=;
        b=ecMz3vJsia5BgKFjg0z4kucfSUgr4/4g1HJtcF3T9fnLZ+ymHE/eIP0KVueDKB7tXW
         ehE+gx21pN8EvXSabECO/xpVgRkUnnHXl2dMQTR3jYrwUoKjHbpqJYKpZVrdu23O6btf
         hpetzthaqM47wr9ImDlLBWPeHKCUAHCBabebpiPnIRcKZI50a2RLx27dwHP4VpJJhhwx
         8ml/9lTtDNkPGAC0TP+Wg5dw5qFODZ24oYvdokatV+rbG6Clpa4KJEEb//HxfT/m27Qs
         KvIaB1REg2bD5VnELgwDu9XuMXq20x2NW7hxvjAtv1QKKBt1sqLE6wjpKPGKoxu8dG84
         rixg==
X-Forwarded-Encrypted: i=1; AJvYcCWx0kQHYMHn+hBB8/kcwAyXGagGyolh88m+b+4jCeX5TRb4YUTIh9wa3/ae8Zt6lsvOkx4mp+AFHA==@kvack.org
X-Gm-Message-State: AOJu0YzQcXDPm9l0rA2HKREjoNmakIhvjOkFoPnZ3AKcrQZnAyNVfw2+
	BkmhTcA7pSxbq49hH9z2sZZnqw3ytdMARCzRvCE8ICUZ7fNgXvdDSIvC
X-Gm-Gg: ASbGncsjCWyy/04s3U7zzlVJ+Jn82J7ICRb7a3uPlDtnmE5NayFPN7vGvvfbh/WZ3d4
	jTCz30/eF3XQyR6FRme+5p0o0VftyU5BEJaonmvFnShd9GdgJppttQDBY8+yiShX9JBqVWjAqgR
	yZw4tP3lSYmy9AUhhQy7IvMd+lT3m7PA+b2bJlPpBJnyPzBEzNLsHO12WTycKa1kL1n85kDAg15
	NRJ6orAcVdq71fY2j1O6AsvCkX/VF8U+RoXSLXRlQ0v88EUhvxQ300y5sIkFqPRQxpqrq+jyNKC
	6hAx6C7jQEwCGnBhy/sGq4d3HXddEE91DSIZtt6ifkXf4FSWLKEpxkoKs5MWAfID+smwWajS/lW
	Ghw10jCKLEqknT8W4swX8iecwAPeSllXQZfdH9m1DzVwbSArZDh0Y15/my+YsWakUpvWq8PJJMp
	GFTCa+nd9ESVKK7YIp+ACwZg==
X-Google-Smtp-Source: AGHT+IFmgCP1RSAK298BihptrWQmwFYdSfIHOvG0eN4y9QhPWKLGCFw1/fHkvkeHjYBbQ3rzbZ6AkA==
X-Received: by 2002:a05:690c:c91:b0:788:bda:47ea with SMTP id 00721157ae682-78c33afae87mr8349447b3.5.1764977541051;
        Fri, 05 Dec 2025 15:32:21 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b790577sm21692767b3.47.2025.12.05.15.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:32:20 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: 
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC LPC2025 PATCH 2/4] mm/vmscan/page_alloc: Remove node_reclaim
Date: Fri,  5 Dec 2025 15:32:13 -0800
Message-ID: <20251205233217.3344186-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
References: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 148581C0013
X-Stat-Signature: w1z419bxdmrdo6454u494kfyj8i3th8a
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764977541-779834
X-HE-Meta: U2FsdGVkX1+cOlTFLteC9qb9TOWhfkyxe84TjQsnQslcw1gZHc5MMlBYHIh63f8rXJI/lVEpzw9BUQjxkiRWnZ4rQqvzQboy/7BuyS8JSOCNH6eetxX14tFegtsz1zExuGbi9LMclcYsqBNlLN8aGE3hsPyHrlJzdbIkC5NscmiuqYUrdg6MmX1A9yeVvoc9BjKVUqCE3ROcvBQgayX9a2RcIautEphlKBSE8ftYNdfTgv4N/RSrkO/xNPWUgQ7oOi8CQRKcrVVJ1Gu94Bz+8b+SQZCMyS7RRAzz2gDDVfaBEc87YK+cfx7gnBiFvalAsgNi8pb7NRiUZEbTUCjshvczZvVg6CjlUFTXxsjfBXD+yCdS3Phn1XPLoZdzP6x0pqHtW2BRyH2y+19T7NYikyDQQhRWk0RXST1xujNUEBnnvTPktv6Pn0ZCx7qbvkZRzMYq3rNLASR/RqBPhK79TORvQ2/phdgtBGYqgJdlJBBDL0l7D5FVQq03nEBaGvKOf50i5zdkvSV6OdvbXKdm/WyV6Cnd6noP0wdVUmkndTUVzzdkqAh0b1uYm7WbaJzByZpvbYm9BXoNczrqhtz1QiP4gIawSFo6trI6FYRnEU2syhwJVtGn8FgwCeP//lEJtClmPJiW+yKQsFDnFCwxNTAeLJH86lkd4a38JE1e6vtMNEwklIUOR5yUO+r7wsHJDtIrvP2mTPGCCbUG8l2boFSOwocS56qLT/LEX6BD8AV+xxXnbPJBQri2cElE49vqLb30NUor9jYM0sZSJ2ScXRqytW5rUiTEnFVf5fgv5by6plFjQLyAavI1AJDt8xh4k1eT0gQCJeq+mlYK73FTBoZirkjg55xIkwIvoqNx1IC0k3YbvE1lEHlZ8DqOUU/xNPGw8uoq+xmF8YDNqWShj4M3UsRu9NiJWy+vOGK9fZNhlfnXqujOIJTXcSNOgHGJ+gxNyveDlaCLo9FWjXy
 EMeiupn9
 +GmY33jh59cMopVC0zkNUtWNaZEx6GznwRqKitecPGAMtWLqtvb3cDF0MIC52uPpjWvItMxNotK5z5JMAgeB25cpRyPWjiGoAw/3AuBWwUkCybrCTWHhapaHCGqL82bo72OXjxZF0dbBG/v9rZRf+m2qIXCeRT1yffG6TUi4FtdMh3W+hS5AelCl51kUU9AdCNftYHsDjtv/7DiDtVtkiy/DZQKqxLdm6Cyd5iGIkH2pRJp/jVLIOUiadE3IsazHNrixyNohj8sOIUIQN2WujHQkUM4ojk9EHsk+oEIH+4D3h9a1KixIfRnk2kwprDjLAoAxKQNwCTcoa5cr7KzNrUF0h5ut02kL+XQ7d98qIxlqRdt4TRTNG8CXJ8TQ3BRkt7mXnJpZQaQUrKH8alU7aMeUzutOSMvE/JB36EzpdV60RT9FWrPNY922fvdTgKX2bHq5myR0cNin3Hq4CZtbfieiS2963pcQj8pgzWbptSWIznQlDOgBXvOf3gVMsy9hdWZ4Nmnpsffjxu7qfSP3mSKpH187lOIK3JXkEd68Newl/CjY9GIa58ICQURPPq2hGa+0qcL8zs+ovCYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

node_reclaim() is currently only called when the zone_reclaim_mode
sysctl is set, during get_page_from_freelist if the current node is
full.

With the zone_reclaim_mode sysctl being deprecated later in the series,
there are no more callsites for node_reclaim. Remove node_reclaim and
its associated return values NODE_RECLAIM_{NOSCAN, FULL, SOME, SUCCESS},
as well as the zone_reclaim_{success, failed} vmstat items.

We can also remove zone_allows_reclaim, since with node_reclaim_enabled
always returning false, it will never get evaluated.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/vm_event_item.h |  4 ---
 mm/internal.h                 | 11 ------
 mm/page_alloc.c               | 34 ------------------
 mm/vmscan.c                   | 67 -----------------------------------
 mm/vmstat.c                   |  4 ---
 5 files changed, 120 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 92f80b4d69a6..2520200b65f0 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -53,10 +53,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGSCAN_FILE,
 		PGSTEAL_ANON,
 		PGSTEAL_FILE,
-#ifdef CONFIG_NUMA
-		PGSCAN_ZONE_RECLAIM_SUCCESS,
-		PGSCAN_ZONE_RECLAIM_FAILED,
-#endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_INODESTEAL,
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		PAGEOUTRUN, PGROTATED,
diff --git a/mm/internal.h b/mm/internal.h
index 04c307ee33ae..743fcebe53a8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1196,24 +1196,13 @@ static inline void mminit_verify_zonelist(void)
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-#define NODE_RECLAIM_NOSCAN	-2
-#define NODE_RECLAIM_FULL	-1
-#define NODE_RECLAIM_SOME	0
-#define NODE_RECLAIM_SUCCESS	1
-
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
-{
-	return NODE_RECLAIM_NOSCAN;
-}
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
 	return NUMA_NO_NODE;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0f026ec10b6..010a035e81bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3684,17 +3684,6 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 
 #ifdef CONFIG_NUMA
 int __read_mostly node_reclaim_distance = RECLAIM_DISTANCE;
-
-static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
-{
-	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <=
-				node_reclaim_distance;
-}
-#else	/* CONFIG_NUMA */
-static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
-{
-	return true;
-}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -3868,8 +3857,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			int ret;
-
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -3885,27 +3872,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 			if (alloc_flags & ALLOC_NO_WATERMARKS)
 				goto try_this_zone;
-
-			if (!node_reclaim_enabled() ||
-			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
-				continue;
-
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
-			switch (ret) {
-			case NODE_RECLAIM_NOSCAN:
-				/* did not scan */
-				continue;
-			case NODE_RECLAIM_FULL:
-				/* scanned but unreclaimable */
-				continue;
-			default:
-				/* did we reclaim enough */
-				if (zone_watermark_ok(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags))
-					goto try_this_zone;
-
-				continue;
-			}
 		}
 
 try_this_zone:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3b85652a42b9..d07acd76fdea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7537,13 +7537,6 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-/*
- * Priority for NODE_RECLAIM. This determines the fraction of pages
- * of a node considered for each zone_reclaim. 4 scans 1/16th of
- * a zone.
- */
-#define NODE_RECLAIM_PRIORITY 4
-
 /*
  * Percentage of pages in a zone that must be unmapped for node_reclaim to
  * occur.
@@ -7646,66 +7639,6 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
-{
-	int ret;
-	/* Minimum pages needed in order to stay on node */
-	const unsigned long nr_pages = 1 << order;
-	struct scan_control sc = {
-		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = current_gfp_context(gfp_mask),
-		.order = order,
-		.priority = NODE_RECLAIM_PRIORITY,
-		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
-		.may_swap = 1,
-		.reclaim_idx = gfp_zone(gfp_mask),
-	};
-
-	/*
-	 * Node reclaim reclaims unmapped file backed pages and
-	 * slab pages if we are over the defined limits.
-	 *
-	 * A small portion of unmapped file backed pages is needed for
-	 * file I/O otherwise pages read by file I/O will be immediately
-	 * thrown out if the node is overallocated. So we do not reclaim
-	 * if less than a specified percentage of the node is used by
-	 * unmapped file backed pages.
-	 */
-	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
-	    pgdat->min_slab_pages)
-		return NODE_RECLAIM_FULL;
-
-	/*
-	 * Do not scan if the allocation should not be delayed.
-	 */
-	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return NODE_RECLAIM_NOSCAN;
-
-	/*
-	 * Only run node reclaim on the local node or on nodes that do not
-	 * have associated processors. This will favor the local processor
-	 * over remote processors and spread off node memory allocations
-	 * as wide as possible.
-	 */
-	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
-		return NODE_RECLAIM_NOSCAN;
-
-	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
-		return NODE_RECLAIM_NOSCAN;
-
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
-	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
-
-	if (ret)
-		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
-	else
-		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
-
-	return ret;
-}
-
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..3564bc62325a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1349,10 +1349,6 @@ const char * const vmstat_text[] = {
 	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
 	[I(PGSTEAL_FILE)]			= "pgsteal_file",
 
-#ifdef CONFIG_NUMA
-	[I(PGSCAN_ZONE_RECLAIM_SUCCESS)]	= "zone_reclaim_success",
-	[I(PGSCAN_ZONE_RECLAIM_FAILED)]		= "zone_reclaim_failed",
-#endif
 	[I(PGINODESTEAL)]			= "pginodesteal",
 	[I(SLABS_SCANNED)]			= "slabs_scanned",
 	[I(KSWAPD_INODESTEAL)]			= "kswapd_inodesteal",
-- 
2.47.3

