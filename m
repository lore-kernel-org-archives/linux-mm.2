Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC1BD1680C
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 10:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB816B0088; Fri,  9 Jan 2026 05:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89306B0089; Fri,  9 Jan 2026 05:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3FC6B008A; Fri,  9 Jan 2026 05:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8156B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:52:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2A4C1A0445
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:52:15 +0000 (UTC)
X-FDA: 84312111030.28.EF514EA
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1020B40012
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:52:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eZaCSV4R;
	spf=pass (imf17.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767955934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1TQfjl1Oyg8oTFGlG7k+ntvES7Gvx/vdSZ107UMkTkk=;
	b=HBWeAc9tOQ2NWjfuZ8shbjptORVJaJWCZrXhKGOIuBY8Q+iB3NDvnwCBTA6nkoh8MUwwfV
	Wo0CxRlm0NmEAOFKj9UgXa5CTV2R+hlR4cTkLFNjsUBKd/uLfYJjq1tKOVtCqdkntRbx2T
	/nr1jE3llP8B6UAlyoa8FvN7aWMg8ZM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eZaCSV4R;
	spf=pass (imf17.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767955934; a=rsa-sha256;
	cv=none;
	b=fJ4DFXPAGUwsPtnmFHFcADwLaoYhBdEYc/wr6B7j0bXToj6TWaCoc2uV9YV7FtfUoWbc+j
	yXsi1XUAMZ7NBVMbuW5t1Qp1eDHpaHC3LQ+w9cvFfMlg9ccBPDxgMoCt/2i5yzaRJ7VSF0
	f/U8tUjTbRd6rcs3Gcn46vRcW/H3bC4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767955931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1TQfjl1Oyg8oTFGlG7k+ntvES7Gvx/vdSZ107UMkTkk=;
	b=eZaCSV4R0Xi5F60N89Kd3yCS91+f00jluNA0tHPTGxReDiNpEL4Hm0eVG95mPaEN4TYduJ
	ioG4iPz0nUFlMzoGhxoyKORf6+IkyjCi/j9STFNx6Vx2Pg4Hnqi/PLTDqDvfW87c8hAOps
	e0CtIN2T6e+xF825mbZcFua9+hn/V9E=
From: Yajun Deng <yajun.deng@linux.dev>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in move_to_free_list()
Date: Fri,  9 Jan 2026 18:51:21 +0800
Message-Id: <20260109105121.328780-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hupoew5z5j9sx8q4qp5t1x9fsyaubmg6
X-Rspamd-Queue-Id: 1020B40012
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767955933-119858
X-HE-Meta: U2FsdGVkX19RQPF1uMZTRSdPaOuoOOpPIEkTbvCQrJ5AFR3xA5qyZIV4wlqd6v1s6IKn4z2t5Rz15xi43FlDhla04QPRKvQeiWCCe7Y+7ViHYyG+jXME8u4SvuyYAaDUnn87s60TzihK2hGvc+YtXtdMRe5K/6qLK0mCsFINQ3yhbh/T7nX9zTjMFAbaUwcP628MS86ASRDq1CRMOBcEXiAPaCftaJQoMNIO1m1VrbtVWtfRqRXNVO7u0w7C6jQU4rJ7yGY3nGnFfEJ2nZ9eU8iNHM4PdnJTgrj8NfCx4linuOZLYKv5XAPAtMydfwT8s7z/rRcQ5l/0nz2Z382CBrm+h99gV29VOJpb5XYZTWiqYcyiY/7gSJZD6y+x2zJy+ShMNf0PEuR3jvnYkjOELUNbxVmTiwPP2JeveciEfPmZbXRyvqHfA0tegtr4Jef7BLAzxnf/8fpi9GIefZ1TtDf99ElmKMOlSxHohe13uQDxkTQ8MLjet10RHjs0d5+k0aJi0+lN+yNNhCofW7jX49uIoQAi+nj1C6KAatynwUKI5s3rrdSvJl9OAQfNdtj+8l2i096fG5j4/NaqgH20wrV/4mCQhPlm+RZQ2nVZu9jB3Hvg1JSFjLGxhXOxPYmCUisPjFShALI4N88ejicAHoIA6pqVObqj2K6ZTtLk2VwbdBVWMjmLTkFD7wPfODhCreXYJ+JII4nqHUCsRGVMyUW2GoSP2Oh7FEqdF0v17rySrc4L6N8d8yURXHal5n9+Qp52JW8jNbpZXHsxb4galoPSOSxyTR2e/NbASy1crw76k57vfKq8jgQlNXeMpcecwnpIEGKQDtMwm21HrG5flxBu1hwYo4G3yh+bNerJJkh50ASzoJfuUezjyZfZ6mV1wicjbXFG7Jp3BkfEmzhJiN1QlbdAJ4oxNm4ukT4mmCoHkZSiBexWsin9itFw4XMLObrAPaZZRmDcxCAU6Yz
 gYjuyk2/
 8i3J2DCY4F5LPi3gUyC/tH1l1mMmDLYRf3cZUYOMrAEWbDmy6/KllLHc35LDJfw4SPk7MF0JBQxSyahtIjnB3kTrcIthTMbU5lPOE60rr/cOnIepiBUgHZ5nKgfuh01PXUln0KtDm1Vya4ggJbagOEhvNZmFOsSIpAE5iUE5j2qGL/lc28793EzNd5E0MWlcyZBtCXth5FHu0+SdN6+/jBzCcK3PZZeUxGi4Ovof+xWYVmzG+XPQ6Tqcpe4eINrbizAPJhbyaD5q2foB5tFgRUkwXBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In move_to_free_list(), when a page block changes its migration type,
we need to update free page counts for both the old and new types.
Originally, this was done by two calls to account_freepages(), which
updates NR_FREE_PAGES and also type-specific counters. However, this
causes NR_FREE_PAGES to be updated twice, while the net change is zero
in most cases.

This patch introduces a new function account_freepages_both() that
updates the statistics for both old and new migration types in one go.
It avoids the double update of NR_FREE_PAGES by computing the net change
only when the isolation status changes.

The optimization avoid duplicate NR_FREE_PAGES updates in
move_to_free_list().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 mm/page_alloc.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ebfa07632995..e51d8bd7ab7d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -812,6 +812,16 @@ compaction_capture(struct capture_control *capc, struct page *page,
 }
 #endif /* CONFIG_COMPACTION */
 
+static inline void account_specific_freepages(struct zone *zone, int nr_pages,
+					      int migratetype)
+{
+	if (is_migrate_cma(migratetype))
+		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
+	else if (migratetype == MIGRATE_HIGHATOMIC)
+		WRITE_ONCE(zone->nr_free_highatomic,
+			   zone->nr_free_highatomic + nr_pages);
+}
+
 static inline void account_freepages(struct zone *zone, int nr_pages,
 				     int migratetype)
 {
@@ -822,11 +832,25 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
 
-	if (is_migrate_cma(migratetype))
-		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
-	else if (migratetype == MIGRATE_HIGHATOMIC)
-		WRITE_ONCE(zone->nr_free_highatomic,
-			   zone->nr_free_highatomic + nr_pages);
+	account_specific_freepages(zone, nr_pages, migratetype);
+}
+
+static inline void account_freepages_both(struct zone *zone, int nr_pages,
+					  int old_mt, int new_mt)
+{
+	lockdep_assert_held(&zone->lock);
+
+	bool old_isolated = is_migrate_isolate(old_mt);
+	bool new_isolated = is_migrate_isolate(new_mt);
+
+	if (old_isolated != new_isolated)
+		__mod_zone_page_state(zone, NR_FREE_PAGES,
+				      old_isolated ? nr_pages : -nr_pages);
+
+	if (!old_isolated)
+		account_specific_freepages(zone, -nr_pages, old_mt);
+	if (!new_isolated)
+		account_specific_freepages(zone, nr_pages, new_mt);
 }
 
 /* Used for pages not on another list */
@@ -869,8 +893,7 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 
 	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
 
-	account_freepages(zone, -nr_pages, old_mt);
-	account_freepages(zone, nr_pages, new_mt);
+	account_freepages_both(zone, nr_pages, old_mt, new_mt);
 
 	if (order >= pageblock_order &&
 	    is_migrate_isolate(old_mt) != is_migrate_isolate(new_mt)) {
-- 
2.34.1


