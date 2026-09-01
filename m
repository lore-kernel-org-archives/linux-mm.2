Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 042E8C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4626B020D; Tue,  1 Sep 2026 10:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4F56B020E; Tue,  1 Sep 2026 10:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA706B020F; Tue,  1 Sep 2026 10:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBA406B020D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:15:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F6FBC041D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:15:18 +0000 (UTC)
X-FDA: 85165390716.07.3D694E8
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id B75CE40014
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:15:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FfTZtopt;
	spf=pass (imf11.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WLQD5GRtLcBENC91U/en+E67ds0eDp4Ln87ubW+kt04=;
	b=RUuxgpQllzr7C3hRMKIoDP9MVqF5gGcbG4i1eLq/Vnn0EY2Xw66TDsYNyemqyCw2gfqLFB
	Bl0wBeP6Wu5lFOm/0NRKkc2/eQX/0/g5JeRVtsDO82+IKUbEru7Cb1JsOSwiswZsst4VgE
	tEFJGa7HuOSbfCvQhhZdwFIZanBZNq8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FfTZtopt;
	spf=pass (imf11.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272116;
	b=XlMYhxV7/oSYEDTI2Ricp7v/2BbZIujK6qvudHwdMfDoTysiRtyZPt0NurqOeInu2AtQR9
	uY+xChQK5rV+ySGEu0XL1Lwr+q+Iw4X8pB/oSlpJNjoPSYaKQ3bR9NWLQj1WSGyMOgZV5b
	VM09V/BH78/w13mOS+Wa3BypOGLEpeE=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so57268045e9.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788272115; x=1788876915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WLQD5GRtLcBENC91U/en+E67ds0eDp4Ln87ubW+kt04=;
        b=FfTZtoptnatk3u8Ku+X/ph0qgZHsihQVCd2D8lp5EXFvyrOYs7/ZddjFvKralpI7J0
         Hn9z1nn6bsZ9X7ChYx4bJ7CuthWQiuKBBVWy91iYMkkyGbV8P++VfAF/jY/YWA6NPffW
         gx4agXRb2Em1t0OayT2K/+dAB1B4UNoHaSN00MZNLwDB0+Q4QxHC+uKJBRS+pPA4Gjgu
         2+fhVQ2pgRLtTPibg5R4nvjC8UKDIhD7RV0sjZLybDqVgGuDlgrbAjknvnb5DHCCKq3X
         FiKEqDAU0WH3HfKUH3V3iO7YdMCjl5KRKuAbv6cEbTWd7qMzRkfNUS+1rcMnk9NT13MC
         efrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788272115; x=1788876915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WLQD5GRtLcBENC91U/en+E67ds0eDp4Ln87ubW+kt04=;
        b=YI4QY5PFaeLdmF7tAmvRRYJZ3Luli/gXBc4I36GDQEzRDpjp6Qb8tqBy2XRVi97Kwi
         I7FK1l8Ha4fKgKgZNJqmrZmzYTig5odTSmQlYZanb0MQxc7WvKAA2vw4iIib2uhtPiMS
         WhrGHCswsklyVqsqOLQkr78mm87ouD7XJ3xXrnXKNa4FV1Fd8jc2rY+8aOZJjMT8o5sE
         idMOnZma7mvSd2OlfvDvhUGCfAijIgXEvvzDUVEt+0Q6m7vJVPvFFYkqpgmQv3UjnIYD
         eEQYZpvWTjH76PhpqJeSqnZ54kpBQ7S17jeNoC5xkXnTxvlKy1iwSfQ99n1c4PZ8eD23
         i6ww==
X-Gm-Message-State: AFuF++nrRJHqAz889dGTvgjHzAwNvgjpxyxGdAQVpWOYV1HKP2Ql8H8T
	KGFZa8cTY5RmjQ8T+naq/YMCR6W+AeieLyF3WcKu2wrx9ZNFRc0AQRti
X-Gm-Gg: AR+sD116+L/ryxZlS4x0M0otoNbiVCRz/h90tTTHrpl/fQH+HoXK9wqzrsoPaREUGJu
	GssPT50MBSRTuoekBBDfR4DNvEGN6Y8md0doxUuk9uuipvynTmssL5dbu9elraS5fHG7iBN3pHc
	YjiqKiWQBbwNcZ6M8NE4na+Y1ZRquzsGezlkrKcCyP0qFIIq5OSLA4ibyCUGhxuLZVcwW5RcXru
	vZR0MyKkb3M5m9ywvO+I4A8Xey24s5/Lji4TJUNEKCoVkRfqJyzueUn7i9hmtVQHC6Mb+HgzU7p
	tg18PBoKbO3Ipg0mmWbj0dlL/4AU/iXheLbYLImJCvMINeemP9BVo0DvYrRkWox8rY59jp4FYuS
	4y/OvwXJR1SvQa4H+yp+SMefObS8DX9HVvwv4jo7sZEybm6m0tz64l2HFocmtne/0Xgvbocvlo/
	SZGT5K97Hdf2Q04gUM6S5MDRLGfWQU9HCt6o2pqqWDbC4NLzRHvB7vd+5SxILK8DY9nZPx7nRQp
	hZE6yLxMw5ISQ==
X-Received: by 2002:a05:600c:8411:b0:499:4892:d022 with SMTP id 5b1f17b1804b1-49b91c279e1mr626555745e9.8.1788272114769;
        Tue, 01 Sep 2026 07:15:14 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:1b6:8132:8387:474d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce10153sm77227925e9.4.2026.09.01.07.15.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 07:15:13 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH] mm/page_alloc: fix various coding style warnings
Date: Tue,  1 Sep 2026 17:15:04 +0300
Message-ID: <20260901141504.1518-1-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f8fzwqperqfof3kgp8c1t1y1gyj146ks
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B75CE40014
X-Rspam-User: 
X-HE-Tag: 1788272116-24084
X-HE-Meta: U2FsdGVkX1+hJIsA4XWCnaRhbrfFvImIQSTuzMg2EwoY/LSanKdvpgRaChDYM/IQpL1GV6y+tsOr963tbgsi5uwwEacoykemSiEerX51030cY1sZjpgL16gtSGJuONkReJaafzfHCF795jzfhMUDDoAqpIsF6fk08rhI4k8avKS0/TrvJiv61f3aaH3hIh6uNW2MOo8f4t+1CEXqhQtsgEEqy/lC1XjYs4lkPIe8pm4/yvqhNe8pS87ZZ8OKnSeAvYRyINXmS0Ih6hEywiIvLcvZcH9o/rWxajMHUZyzKLVn+WV0wKhl4c9XI0tVtoKYLgYUYRhrMMdFrKFi1KNwJ3arFzgGCVOtl3j88zU/y/ryB7BaBSgpYVPHmPUmcvi8ABouj9rxTavqI7tTvvT7DQg3CKHX/KMsmWEHb7qrQmWHetFopPh4cB0kRackPcKvD1b9eGHJR2fuAG8K7wfxAsEQfzUIy19+C+96x7odVSiG77P4fKL8vNDhYa68qIpDc5uGUmEu71ziaErG9wmw+Cvze/pD40DdHztRZu9KrCu1oLfryvlY8piFT/KPzY5Jjvl2PnwgE0kQc1E3zcWb+4OUYzv5NkdSYsE5flt8ep3IjT/jiq8dXH4wjcAu4yxmz44LveVyMCjJXy+i6+kDHlrKxqnTTfCP7Xl5nuvwLqJLk9GVO6bvC3Am+HDWhjKFm5jKan5DU/8LbsS3zjq2bpTMsQqyOSI4GORZi7svEK9g1hC252OK5PnVRyqXYIGz2hNxt0rMUoBDsWSddoxJPwxywZSlPzZ8ZAOleI+2kKc26LyhFppRDGtg9cpXPeBoGwgg5zc+5xZBGaDKAAmJJJE7hegQW56rs92cLqWGdKXwKlPIhMqOOrC8zFN8QWqsVVMuByUWPLktDlA/rOOT6tbmIDGJzP3YAKLoaKaAT5qjZmtOPF+tQRQHQkhPtLgzo0uS9mveP9XVcIxFPvu
 NLfY7odK
 1DgqszLtyrCFhpySV0Pia6YwnrGkto0XvbL5QdquVG7hCJvHmVIwxySvHW89MMcrKG8Mep7T8dvohJD+Qs6rdTcMOC/+QJTy2CUI/crvnH/EP/r+IbRc8giCwuLpeefMhrQZcL9XaZ2kj5Grk4sCUG1p61cTQVS1WPve5sjHuqpgLxStYbtiPTAex5Jc49GzePpeQR1/t1BIUkncUmonIGfUYHfhl+Z7SZ48GmAGJq6o9gYJFHNDFepfP1uAXweLxUBvD5x07YE4Sw0ddNITCmixTTNqKzF+j7nMbK8e/r2Mf+0oHUMD0QQbA2QwuAhAHgsUPGOcKeeFqNlbSceRIHRkMIQ8f9/JzU47XqhwKHu2YlqkiQ+HypQCLPMp4ey5021jCW4bO2iTCb8xdXlxkKlVpqM5TXx/HFmS/NQa1eECxHWr8ofMYla6ortmSIy51cEfN+dZ0JHMuwEnnT2Cf4i0ClT3F2/TKnRVwKTVTcZclODBpIZ2G9eFBl4s173Mo8DUxW1Y7y/0oh/YyfEasVzZ0EUjRpfANkam0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve several coding style issues flagged by checkpatch.pl:
- Replace spaces with tabs for proper code indentation.
- Add missing blank lines after variable declarations.
- Replace bare 'unsigned' with 'unsigned int'.
- Fix suspect code indentation in conditional statements.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/page_alloc.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..7c9152c58084 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -575,7 +575,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
 	int ret;
-	unsigned seq;
+	unsigned int seq;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long sp, start_pfn;
 
@@ -846,7 +846,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 {
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -2927,6 +2927,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 			      ZONE_MOVABLE, 0)) {
 		struct pglist_data *pgdat = zone->zone_pgdat;
+
 		clear_bit(ZONE_BELOW_HIGH, &zone->flags);
 
 		/*
@@ -3155,6 +3156,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	 */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
+
 		for (; page < endpage; page += pageblock_nr_pages) {
 			int mt = get_pageblock_migratetype(page);
 			/*
@@ -3821,9 +3823,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		unsigned long mark;
 
 		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		    (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
@@ -3943,16 +3945,16 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			prep_new_page(page, order, gfp_mask, alloc_flags);
 
 			return page;
-		} else {
-			if (cond_accept_memory(zone, order, alloc_flags))
-				goto try_this_zone;
+		}
+		if (cond_accept_memory(zone, order, alloc_flags))
+			goto try_this_zone;
 
-			/* Try again if zone has deferred pages */
-			if (deferred_pages_enabled()) {
-				if (_deferred_grow_zone(zone, order))
-					goto try_this_zone;
+		/* Try again if zone has deferred pages */
+		if (deferred_pages_enabled()) {
+			if (_deferred_grow_zone(zone, order))
+				goto try_this_zone;
 			}
-		}
+
 	}
 
 	/*
@@ -4637,7 +4639,7 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
  * Returns true if a retry is viable or false to enter the oom path.
  */
 static inline bool
-should_reclaim_retry(gfp_t gfp_mask, unsigned order,
+should_reclaim_retry(gfp_t gfp_mask, unsigned int order,
 		     struct alloc_context *ac, int alloc_flags,
 		     bool did_some_progress, int *no_progress_loops)
 {
@@ -4673,9 +4675,9 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		bool wmark;
 
 		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		    (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -5713,6 +5715,7 @@ static unsigned long nr_free_zone_pages(int offset)
 	for_each_zone_zonelist(zone, z, zonelist, offset) {
 		unsigned long size = zone_managed_pages(zone);
 		unsigned long high = high_wmark_pages(zone);
+
 		if (size > high)
 			sum += size - high;
 	}
@@ -5865,7 +5868,7 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
  * DMA zone, if any--but risks exhausting DMA zone.
  */
 static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
-		unsigned nr_nodes)
+		unsigned int nr_nodes)
 {
 	struct zoneref *zonerefs;
 	int i;
@@ -6393,6 +6396,7 @@ void __init setup_per_cpu_pageset(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_zonestat *pzstats = &per_cpu(boot_zonestats, cpu);
+
 		memset(pzstats->vm_numa_event, 0,
 		       sizeof(pzstats->vm_numa_event));
 	}
@@ -6803,7 +6807,7 @@ static void setup_min_unmapped_ratio(void)
 
 	for_each_zone(zone)
 		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
-						         sysctl_min_unmapped_ratio) / 100;
+							 sysctl_min_unmapped_ratio) / 100;
 }
 
 
-- 
2.50.1 (Apple Git-155)


