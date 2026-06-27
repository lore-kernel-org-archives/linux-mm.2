Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 881CCC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7656B00A9; Sat, 27 Jun 2026 03:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8573A6B00AA; Sat, 27 Jun 2026 03:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EC56B00AB; Sat, 27 Jun 2026 03:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40F256B00A9
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:24:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C30C01C3640
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:24:54 +0000 (UTC)
X-FDA: 84924855708.09.EA095FF
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id E281E80003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:24:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCIb3mp0;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545093;
	b=liQmLcrNiFTakBd3OdacDygxVB3Hrk3RZk9904CAWxM4rZlX5UO3dt5A+gdWYt7gXztSnb
	ZPwJe8V3qOfbXwihQG7mxUGKkA+zOYmmo3KrxE03KSmBsJHX+Vj0l30ROpBaPxkVK36XB+
	QSl4+AlIfGzLr7GSRA2dO+d7KXfPQ60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4u1YvE27DIPqxm33/Bz1MhOCM+vYtEIVT75XOUQWk8=;
	b=7jvKvRvYhyUgGyljZ5UMtf6RRY6xQVWBYrs4CXIwZyEvzPObfgb726A/n5QipFlNoVIzP9
	EjXQQ9pn/KpWKfDTsFL+OtoKpum7fQ9LZTjSP+Zqxph/Awt+MfaGmrmQFuGtCHtMltjMyi
	QltLTL937CHknru0ywb23K45JUdsPRQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCIb3mp0;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d4u1YvE27DIPqxm33/Bz1MhOCM+vYtEIVT75XOUQWk8=;
	b=JCIb3mp0O8738F8sYWb25cENyYo3AY1DFvtLoP7uQ6JaeQ/ByoXWN3ahuhV7XaAa5w2eLC
	h8RrMY8VmdKb+uYbcqCkGezC7IqnQS95cBBwjLLQBuIwusxIopl+ZLgmBLY4tMoEGLNanw
	9T4184xOCCRBeDvZUnUjuoFeNVDOCJA=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 1/8] mm: page_alloc: add reserved THP pageblock type
Date: Sat, 27 Jun 2026 15:21:49 +0800
Message-ID: <68d1db4c8b291ba0b1312abe0ebb83628c5de51e.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ad97h1hs3zfd73eqiq886yah58oyqzbi
X-Rspam-User: 
X-Rspamd-Queue-Id: E281E80003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782545092-639178
X-HE-Meta: U2FsdGVkX1+D66kKCyg3sgQXVw0w1Xsz4/TVsenkTVDKn5mkqMjxgC9MgM4fcZwmYjcptONFI5jZHmANRKHvyIQXxztJvWlCdocIkHx83qM4/QtyKIkdbAQw5ndlcdABtrTiyKAWeIL/qsSIGOtg9CeG4nj7vSkDCUojSbq/JBOvHxNQSUiVnEBA2eQoph18Airk4a9NL/AyH5gVLQ0BbDnp2N8m5PxMmP+unB7gLuOtzNORKnM4rqHBx1OW8YFpw/5lmaKxjbWanSe2j3nNp3Y4UGWEASj8hHKVkCvOH3mTQkg/LBZ5Ux3YsUvy/ioRu2010n5SJd/lT6vVWY2nWGahYeG1IOiour3X3R8yMuBvkEVqS4C1wX0MO9xGOOw0+8VHMXwQNPCBUZX62PLYRLiRkKtBpcW68JFtEj8VgNX6jN82d65SRQHS54+TaOd3by7xA+KwqPth6AD9HBEpaPQFOkbjH/z+hArXgWQ8NtY1kyUKjfV9A0x5W2Hl0hscy7uIK2jbOoWy7IG8a+jBdyW4eKqkltDWVkPPYuOtvWI1XKK5+XozuhTkN4Ce5OVfFZ1afJbuhkwXhBnCPhCImpVwn4mH7n44PUG8ebYLYXePK1JeypxWGnA2IuocXr3QoIcjSRBnYPgrzGAPQF15WXwNRG8ymf5VIh9Ybm8AzNaFVkjEcEAJeFFrYdnpFaVxDdexO4UrJdrk7eWfpDiB4IIKadv1dZkeUKyVRzhEnNJ65Kvca7CkqBFgAM7eVg7dMpeaFHpU0SPEJBudvp9BBKJTQyj5+oVidaeu5MAwpj+zqwh6CoF0+AT69fO7r2WVw7uQptShGg318BEFGDuphCnQoZJTU2vBzU94/a1uxBs+2vyqJyqagGckkKny+h2W6mHvbmg8Dyw62g8KIgtOjWHWtWf61B4w60cnLYpVNKFuVsRIHCaDBx+iucYo9aTPgd7X1NIBQRH5+SDWoRD
 afSm8ldh
 LJeA42EcESjpwdr/uMZt3/MNCskbOZ2/bGsymO43bFo3CRl9iyamOilD3ymbeL0rEfZ57sAeV9omPHPh2bYp1ccLjdUreDpRNZtpYr5R50hSvpgaUJBEb/ubS1rYiE6eGZCVISu6fvNmlBe9ThrM6rnA0WQ0KsVLQ3IkiYZ0kCFElzPUDwWK9PH7o7KdliQ4ebxNY4CiiU65ouZDumYIZTsrQqwTZhctVKxLc0aGf7qUACpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Introduce a new migratetype MIGRATE_RESERVED_THP in preparation for the
upcoming Reserved THP feature.

Add specific handling in the page allocation and freeing paths (e.g.,
free_unref_folios() and __free_frozen_pages()) to prevent these reserved
pageblocks from being freed to the per-CPU (PCP) lists or being used by
other allocation contexts. Also, add statistical counters in the zone
structure and expose them in /proc/zoneinfo.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/mmzone.h | 11 ++++++++---
 mm/page_alloc.c        | 16 +++++++++++++++-
 mm/show_mem.c          |  5 +++++
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca27121871475..4418d0c9accdc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -133,10 +133,9 @@ enum migratetype {
 	 * __free_pageblock_cma() function.
 	 */
 	MIGRATE_CMA,
-	__MIGRATE_TYPE_END = MIGRATE_CMA,
-#else
-	__MIGRATE_TYPE_END = MIGRATE_HIGHATOMIC,
 #endif
+	MIGRATE_RESERVED_THP,
+	__MIGRATE_TYPE_END = MIGRATE_RESERVED_THP,
 #ifdef CONFIG_MEMORY_ISOLATION
 	MIGRATE_ISOLATE,	/* can't allocate from here */
 #endif
@@ -161,6 +160,9 @@ extern const char * const migratetype_names[MIGRATE_TYPES];
 #  define is_migrate_cma_folio(folio, pfn) false
 #endif
 
+#define is_migrate_reserved_thp(migratetype) \
+	unlikely((migratetype) == MIGRATE_RESERVED_THP)
+
 static inline bool is_migrate_movable(int mt)
 {
 	return is_migrate_cma(mt) || mt == MIGRATE_MOVABLE;
@@ -975,6 +977,9 @@ struct zone {
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
 
+	unsigned long nr_reserved_thp;
+	unsigned long nr_free_reserved_thp;
+
 	/*
 	 * We don't know if the memory that we're going to allocate will be
 	 * freeable or/and it will be released eventually, so to avoid totally
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f5..613a711305072 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -263,6 +263,7 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 #ifdef CONFIG_CMA
 	"CMA",
 #endif
+	"ReserveTHP",
 #ifdef CONFIG_MEMORY_ISOLATION
 	"Isolate",
 #endif
@@ -784,6 +785,9 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 	else if (migratetype == MIGRATE_HIGHATOMIC)
 		WRITE_ONCE(zone->nr_free_highatomic,
 			   zone->nr_free_highatomic + nr_pages);
+	else if (migratetype == MIGRATE_RESERVED_THP)
+		WRITE_ONCE(zone->nr_free_reserved_thp,
+			   zone->nr_free_reserved_thp + nr_pages);
 }
 
 /* Used for pages not on another list */
@@ -2960,7 +2964,8 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	zone = page_zone(page);
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
-		if (unlikely(is_migrate_isolate(migratetype))) {
+		if (unlikely(is_migrate_reserved_thp(migratetype) ||
+			     is_migrate_isolate(migratetype))) {
 			free_one_page(zone, page, pfn, order, fpi_flags);
 			return;
 		}
@@ -3038,6 +3043,7 @@ void free_unref_folios(struct folio_batch *folios)
 
 		/* Different zone requires a different pcp lock */
 		if (zone != locked_zone ||
+		    is_migrate_reserved_thp(migratetype) ||
 		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
 				pcp_spin_unlock(pcp);
@@ -3045,6 +3051,12 @@ void free_unref_folios(struct folio_batch *folios)
 				pcp = NULL;
 			}
 
+			if (is_migrate_reserved_thp(migratetype)) {
+				free_one_page(zone, &folio->page, pfn,
+					      order, FPI_NONE);
+				continue;
+			}
+
 			/*
 			 * Free isolated pages directly to the
 			 * allocator, see comment in free_frozen_pages.
@@ -3568,6 +3580,8 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
 	if (likely(!(alloc_flags & ALLOC_RESERVES)))
 		unusable_free += READ_ONCE(z->nr_free_highatomic);
 
+	unusable_free += READ_ONCE(z->nr_free_reserved_thp);
+
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 43aca5a2ac990..e9381afca4aca 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -142,6 +142,7 @@ static void show_migration_types(unsigned char type)
 #ifdef CONFIG_CMA
 		[MIGRATE_CMA]		= 'C',
 #endif
+		[MIGRATE_RESERVED_THP]	= 'T',
 #ifdef CONFIG_MEMORY_ISOLATION
 		[MIGRATE_ISOLATE]	= 'I',
 #endif
@@ -308,6 +309,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			" high:%lukB"
 			" reserved_highatomic:%luKB"
 			" free_highatomic:%luKB"
+			" reserved_thp:%luKB"
+			" free_reserved_thp:%luKB"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
@@ -331,6 +334,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			K(high_wmark_pages(zone)),
 			K(zone->nr_reserved_highatomic),
 			K(zone->nr_free_highatomic),
+			K(zone->nr_reserved_thp),
+			K(zone->nr_free_reserved_thp),
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_FILE)),
-- 
2.54.0


