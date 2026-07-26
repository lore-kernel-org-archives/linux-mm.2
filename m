Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64000C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C914F6B00B1; Sun, 26 Jul 2026 18:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69B36B00B2; Sun, 26 Jul 2026 18:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6866B00B3; Sun, 26 Jul 2026 18:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5BA6B00B1
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:24:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D70561A05C8
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:00 +0000 (UTC)
X-FDA: 85032356640.30.C276A60
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id 336E5A0006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQFUi4mE;
	spf=pass (imf15.hostedemail.com: domain of 3_YhmaggKCAQnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3_YhmaggKCAQnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2xuI/zeM0UttuNeFOz41CO3X9EkXjzbyKL0Tm6Mtd0=;
	b=BGOOBnUP3rjHmwpkS6XYLN9k/ENW+28rcI2PGdbpqm87QVQSppL+DEmKN86KYOj1y+auhi
	ktI0tLFCthUaz3bgFh1y0vRDWU9bXyQLtL2frslJ2cQqytwglDnA6FNCkprj9x4LANZ2U0
	NIf+HXHtuNK/D46Nh9SlwO8Qr9XjV3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104639;
	b=kE92ZG9bKCvApvVYLXDcRonEcK4xv65R7Bt+d5K76R2kpmYhqpkpbRg3AFK26b+XkAR7NB
	vO5QeU2HnFe2Or9ib/1W5l1gti9aDHkEX3l9M8b8yHXhBhB1SfcGWAAvUsfa5veHx4XdNX
	J8Ih78kH/Jyk1Kt2zHgoMH22rTLMN1E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQFUi4mE;
	spf=pass (imf15.hostedemail.com: domain of 3_YhmaggKCAQnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3_YhmaggKCAQnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49544a639e9so10570845e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104638; x=1785709438; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2xuI/zeM0UttuNeFOz41CO3X9EkXjzbyKL0Tm6Mtd0=;
        b=QQFUi4mEPrwkbhLyLblb/OBzoccgPYjMqbACPl+T4iMGryNtFnluDo5lYMu64vGkH3
         F/RiwHrO8buR3vfXup+xmbHcEpz9tRwkYxdi0s0nSrXOe4K7uJljsveUfGsHBHHHdHKI
         WSrvCxNkIL3/JtWTFx97cLj/XKjE30MQeJHFqi71Mwg5SQD27dV/Q+7ZlS9yrAi9Vnay
         OH6X8rkD+ISEbs03/o4W+WjG9XtkmbYRDO/KAgaNzqEMYw9PQnd8Wtz5vHyeZwNrueiS
         wK6ZXfH9KhIoN/XJ1MKlqQadlgfROJGtmnG4MsF43rffo77+9nbEeB1IXBGS+eaTLDdM
         qOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104638; x=1785709438;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m2xuI/zeM0UttuNeFOz41CO3X9EkXjzbyKL0Tm6Mtd0=;
        b=EexoNCFRGW4zX+dfUBkT/WTTr8IL0Y71s+ui0GH0bzGwY5VXi6VgvmuMEkTXC7ryVB
         6NE60QM0VmXRPaPOg/bWt2ZgfyXBQ3Ng9q2pe9bmllWo+cHKEEf7XjHc/lTMZUGeetZj
         2uR7AT6oLB46Oc9M/9bOoZJ6e+Q3s9mMu5B7Nnn0mVTRqfwuBRm+QS1iCNb+kfk672ME
         OohUVwEPmT6Jm9JdxvjWu1RQz62qcWVtezJlXka08b/rAN5W2NS+XlJAGqs38sRJRedm
         cdNl7l/Gy69kPYqNelcyg2z8BAS5s1Vsm2iBK4QTSGfK7ii2ELYuzKAac1fn1IEjtt2M
         C+5g==
X-Gm-Message-State: AOJu0YxxeuqGtdWF7W47PBbbWYAkqRiCJO4H4exvK2EVuRaky4RqhVqR
	T4HuB9G719GSmH/Qn9PUmYJx2Z4huH6WjaWSznf42aOFF2RN1NGwN1LiN3/WMxqex5z4uzI0dEa
	fpM+w6PI7ZNzFgQ==
X-Received: from wmaj2.prod.google.com ([2002:a05:600c:6c02:b0:494:133:ddd3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a102:b0:493:c77c:108a with SMTP id 5b1f17b1804b1-496b575ded2mr61716775e9.36.1785104637810;
 Sun, 26 Jul 2026 15:23:57 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:56 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-23-6f5729aa9832@google.com>
Subject: [PATCH v3 23/26] mm: Split out NR_FREE_PAGES_BLOCKS_[UN]MAPPED
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 336E5A0006
X-Stat-Signature: qx5upoag3n48g4omj889zwiimg1czyy7
X-Rspam-User: 
X-HE-Tag: 1785104639-41409
X-HE-Meta: U2FsdGVkX19zT+lG2YAjeej51t4hIjdJ9pkvRhuD007lJmZ4NktsqPOhC0nekd3Csr0Ljd3BbwhaXDJfG5PXImz1UhrTbaNlq04pOz7bsgiEtrieBFTK6YWGcCEnVBT8t44DScw9B9ECjap08FoyKhik29WRYb1T/ngZOZYKMaxBlRPLneqE3D6W/VqSCEFrnQz/RlGdNPSI87r1Vq639j49+ubM8Wa294hbRMCkuvkyI+FTUEKJbI7FC6R0pEzQYNR/XB8WYjWeovAKk42xAND1zpfbDEoQDQi9Q5Sh0PbEw5rp2FxdjMMiTHmNro6QGbSWLMeIoElbpdPYx/jybEAVOXrtdAdjmyPkvewciP68dvIT8Iag2NVHvE4VY5s/quTiM9gSyGXcNtH2oXHAunei57W8OnooMhCyTuCK1fiIT9S2do+7AoOZx2aTZyY+QiBtkX0KS7lFKO7zYXGnXfpLlep211Y13kc6tZ3KJplBHv0x/ikwx4CwJe73mDwnAnNPzEh7MMtllOU4ZMWyOzmN+fvTkzQ87YX+Rq5dh6s2TzUTrZNo2k0ynVL3vuXn6RuRgnUBfaTzNtEeNcmBKqS4JWKZopCXFk3OB71XlV2ulmJqpHe962miijZa4jCotKg1WGxEDrb+unva1ON/I/PMbVn0fFbgZC5KXpc2Yzf3fpsV13xTxlUOeNceAy83KSuhWor9+Q0Xnruq7NHSwQ8dDX0+ugXPgVngdI48hzgVS8B1eD9DWoNMmHBGkjSxk9AowZRracvw0ls2CBL5URKB7mFQ8ekdhN8NqWbkcOCwtiYzcIYAIwjuU8fOR1rv8eiO8miVT8Z9V+OaktIy6l+JEXXGCRS/DL7m2UqAEG22mlGUN3cta3uhm505p2b+RqDIMcUovjSTICoqcAxY5Am/pBGnlhFyAy6NUo4NAuExJ+2S5SCklUQDD2M9kcnBs++bbvNAbfM8MBPWMe3
 FheWxbZU
 rOTZE53coE6qe5JtLhzoVzNaZ/3KUHvw4VkHxR6wXMRYVvoGC/kULTGB5geqe45449fIDkaCYOj3zX7ktoT4oDNDSE6DZt1z/5042z3Fzylm663WsCBMhRj7oQ1QL2F711Vbhh1ynlXtbkKaq2TJtG45qJ0216xF4ae3PNnO9u2bgmh9Q4vv3DK3o1wGCtLvtuJLHJzlB6EfBLO337FsGzZbt5k7dG72fJxYsvaroIqI//szB2I8UqKhwRf6FQh7exTLP1YOLBtHl226fTS3ue69S1hCjOLh0yq6uXc9MAbk3YmqfVR+MDLDnsgLnH0jJ1PLGBarRik3VEAISHR1c5jLvFgRP7da5CX7NmLjLRFuxbCE3/30hw+9GZO/STAULYlfSrvnHrlcKzgnvhqGSoHU3jO/9nbbuk0anAE9EgwhnWLs8A2pfitqeCpkGETiwdofBo1OTiPenWYTxkhBP2bsjQrH05TcKPWGwvVuBx4KwgBvAZov7OMCvZ9VhHT80G4uH8vK6fMsr2vp3OtywxKesJejc0vNnbvjf6CfRA4A0CWthIFTUFuSyzYDQyR9x7nF4r7U3paOTY7HlmXCQ8IzdrYh6qX0RvsSRdcSUUYtULztv9cwG1DX+oLDXEPZ/BjULLASbsn+r5jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to infer whether compaction is likely to enable an allocation
that maps/unmaps a pageblock, we need to know how many fully-free
pageblocks of each type there are.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h |  5 ++++-
 include/linux/vmstat.h | 10 ++++++++++
 mm/compaction.c        |  5 ++---
 mm/page_alloc.c        | 13 ++++++++++---
 mm/vmscan.c            | 49 ++++++++++++++++++++++++++++---------------------
 mm/vmstat.c            |  3 ++-
 6 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2533a228f71fd..e063a59bbc883 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -181,7 +181,10 @@ enum numa_stat_item {
 
 enum zone_stat_item {
 	NR_FREE_PAGES,
-	NR_FREE_PAGES_BLOCKS,
+	/* Number of free pages in entirely free pageblocks, with direct map */
+	NR_FREE_PAGES_BLOCKS_MAPPED,
+	/* Ditto, without direct map */
+	NR_FREE_PAGES_BLOCKS_UNMAPPED,
 	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
 	NR_ZONE_INACTIVE_ANON = NR_ZONE_LRU_BASE,
 	NR_ZONE_ACTIVE_ANON,
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae405..debd593756149 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -224,6 +224,16 @@ static inline unsigned long zone_page_state(struct zone *zone,
 	return x;
 }
 
+/*
+ * Approx number of pages in entirely free pageblocks. Due to races this could
+ * actually return a value more than the number of pages in the zone.
+ */
+static inline unsigned long zone_free_pages_blocks(struct zone *zone)
+{
+	return  zone_page_state(zone, NR_FREE_PAGES_BLOCKS_MAPPED) +
+		zone_page_state(zone, NR_FREE_PAGES_BLOCKS_UNMAPPED);
+}
+
 /*
  * More accurate version that also considers the currently pending
  * deltas. For that we need to loop over all cpus to find the current
diff --git a/mm/compaction.c b/mm/compaction.c
index c9eb3947ffc79..ed12d2fc6fad3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2353,8 +2353,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 		if (__zone_watermark_ok(cc->zone, cc->order,
 					high_wmark_pages(cc->zone),
 					cc->highest_zoneidx, cc->alloc_flags,
-					zone_page_state(cc->zone,
-							NR_FREE_PAGES_BLOCKS)))
+					zone_free_pages_blocks(cc->zone)))
 			return COMPACT_SUCCESS;
 
 		return COMPACT_CONTINUE;
@@ -2538,7 +2537,7 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 	unsigned long watermark;
 
 	if (kcompactd && defrag_mode)
-		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
+		free_pages = zone_free_pages_blocks(zone);
 	else
 		free_pages = zone_page_state(zone, NR_FREE_PAGES);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ac2f6190117ae..d12ce84662ab7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -866,6 +866,13 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 			   zone->nr_free_highatomic + nr_pages);
 }
 
+static inline enum zone_stat_item free_pages_blocks_stat(freetype_t ft)
+{
+	if (freetype_flags(ft) & FREETYPE_UNMAPPED)
+		return NR_FREE_PAGES_BLOCKS_UNMAPPED;
+	return NR_FREE_PAGES_BLOCKS_MAPPED;
+}
+
 /* Used for pages not on another list */
 static inline void __add_to_free_list(struct page *page, struct zone *zone,
 				      unsigned int order, freetype_t freetype,
@@ -890,7 +897,7 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 	area->nr_free++;
 
 	if (order >= pageblock_order && !is_migrate_isolate(free_to_migratetype(freetype)))
-		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
+		__mod_zone_page_state(zone, free_pages_blocks_stat(freetype), nr_pages);
 }
 
 /*
@@ -926,7 +933,7 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 	    is_migrate_isolate(old_mt) != is_migrate_isolate(new_mt)) {
 		if (!is_migrate_isolate(old_mt))
 			nr_pages = -nr_pages;
-		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
+		__mod_zone_page_state(zone, free_pages_blocks_stat(new_ft), nr_pages);
 	}
 }
 
@@ -954,7 +961,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	zone->free_area[order].nr_free--;
 
 	if (order >= pageblock_order && !is_migrate_isolate(free_to_migratetype(freetype)))
-		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
+		__mod_zone_page_state(zone, free_pages_blocks_stat(freetype), -nr_pages);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 566c4e837c7d5..5789c39a0a729 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6935,6 +6935,28 @@ static bool pgdat_watermark_boosted(pg_data_t *pgdat, int highest_zoneidx)
 	return false;
 }
 
+/*
+ * Helper to get *FREE_PAGES* zone stats with accuracy heuristics.
+ *
+ * When there is a high number of CPUs in the system, the cumulative error from
+ * the vmstat per-cpu cache can blur the line between the watermarks. In that
+ * case, be safe and get an accurate snapshot.
+ *
+ * TODO: NR_FREE_PAGES_BLOCKS_* move in steps of pageblock_nr_pages, while the
+ * vmstat pcp threshold is limited to 125. On many configurations that counter
+ * won't actually be per-cpu cached. But keep things simple for now; revisit
+ * when somebody cares.
+ */
+static inline unsigned long get_free_pages_stat(struct zone *zone,
+						enum zone_stat_item item)
+{
+	unsigned long free_pages = zone_page_state(zone, item);
+
+	if (zone->percpu_drift_mark && free_pages < zone->percpu_drift_mark)
+		return zone_page_state_snapshot(zone, item);
+	return free_pages;
+}
+
 /*
  * Returns true if there is an eligible zone balanced for the request order
  * and highest_zoneidx
@@ -6950,7 +6972,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 	 * meet watermarks.
 	 */
 	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
-		enum zone_stat_item item;
 		unsigned long free_pages;
 
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
@@ -6968,26 +6989,12 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		 * has dropped order, simply ensure there are enough
 		 * base pages for compaction, wake kcompactd & sleep.
 		 */
-		if (defrag_mode && order)
-			item = NR_FREE_PAGES_BLOCKS;
-		else
-			item = NR_FREE_PAGES;
-
-		/*
-		 * When there is a high number of CPUs in the system,
-		 * the cumulative error from the vmstat per-cpu cache
-		 * can blur the line between the watermarks. In that
-		 * case, be safe and get an accurate snapshot.
-		 *
-		 * TODO: NR_FREE_PAGES_BLOCKS moves in steps of
-		 * pageblock_nr_pages, while the vmstat pcp threshold
-		 * is limited to 125. On many configurations that
-		 * counter won't actually be per-cpu cached. But keep
-		 * things simple for now; revisit when somebody cares.
-		 */
-		free_pages = zone_page_state(zone, item);
-		if (zone->percpu_drift_mark && free_pages < zone->percpu_drift_mark)
-			free_pages = zone_page_state_snapshot(zone, item);
+		if (defrag_mode && order) {
+			free_pages = get_free_pages_stat(zone, NR_FREE_PAGES_BLOCKS_UNMAPPED) +
+				get_free_pages_stat(zone, NR_FREE_PAGES_BLOCKS_MAPPED);
+		} else {
+			free_pages = get_free_pages_stat(zone, NR_FREE_PAGES);
+		}
 
 		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
 					0, free_pages))
diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb57714539fb5..f5ab6ab641c6d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1200,7 +1200,8 @@ const char * const vmstat_text[] = {
 	/* enum zone_stat_item counters */
 #define I(x) (x)
 	[I(NR_FREE_PAGES)]			= "nr_free_pages",
-	[I(NR_FREE_PAGES_BLOCKS)]		= "nr_free_pages_blocks",
+	[I(NR_FREE_PAGES_BLOCKS_MAPPED)]	= "nr_free_pages_blocks_mapped",
+	[I(NR_FREE_PAGES_BLOCKS_UNMAPPED)]	= "nr_free_pages_blocks_unmapped",
 	[I(NR_ZONE_INACTIVE_ANON)]		= "nr_zone_inactive_anon",
 	[I(NR_ZONE_ACTIVE_ANON)]		= "nr_zone_active_anon",
 	[I(NR_ZONE_INACTIVE_FILE)]		= "nr_zone_inactive_file",

-- 
2.54.0


