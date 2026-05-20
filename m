Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB01CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5DA6B00A6; Wed, 20 May 2026 11:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E677E6B00A7; Wed, 20 May 2026 11:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D336B00A8; Wed, 20 May 2026 11:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF3EB6B00A6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51D3AC1851
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:49 +0000 (UTC)
X-FDA: 84788110218.17.207B696
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A45412000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YrDS4Miz;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m2f0p/Td6puNx2BkVZxtqaOk4oJNa3hM0pY4XXb+2M=;
	b=dkCqqGBj1JEJS6NMdJabbaX6V6DCiuatdTpI1HCmezWZp2OuGfpj50EGOSVN5VIXl2PmpF
	4PV153jc88pDZXjkd/iBhUFDD7JTRaTpSrEON/RePQRu31kYM62xA18oSjA6N7jdI8tNZn
	URLZSbF+mQERBlKh/YMd+zLer7JjHJs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YrDS4Miz;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289247; a=rsa-sha256;
	cv=none;
	b=QebqMlIzk+0gRixhhGM7g9IQRr0LHmYxGb1x/ts9fWXChxwN6fyccUc0qL8bVcvoaNmLSC
	lxLlFvh4fI+LvbnF4Z5/Tn7NETpIuufbk3xEbDSo3f3Z039AL6bY+Cm1NjI7wBFx4fFrHp
	efpHkOZ+XveOmTpWSgXaq9eKYOqtBSU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5m2f0p/Td6puNx2BkVZxtqaOk4oJNa3hM0pY4XXb+2M=; b=YrDS4MizLcd1AKObSmKUj0wIZV
	Mt0diwbj8g69QzTInSn+7MDeGnvJrjwlAfhjfF4HWIMJRI//rXLT9pZvL+e/BrUWxvOfhXOKfakfC
	V07TdjA7chkY4auPgDRDi7E4R1eSpfMKuYUg6HMyLvaT4pHH/7TLjqZecABoLVkmqCSuiY26AP7zh
	2WFbHY7MUpUnYKmGtELAi4rJD6eAVu4/6apJ0giuG36/8TViX6nKvwyTCumFAum0Eh218AO0rw3/c
	Fftvu15rP5YcP6chsgnexWn+GFvMuoHsmGUg62TSPs61DIux1CrtsxXqoj/Qnm/wXchpyrCTIKPDC
	ovIqHNxA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1BZs;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 10/40] mm: page_alloc: add superpageblock fullness lists for allocation steering
Date: Wed, 20 May 2026 10:59:16 -0400
Message-ID: <20260520150018.2491267-11-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h1yc4ir9okh1iuj7fpog5fgutdzmwxqt
X-Rspamd-Queue-Id: 2A45412000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779289247-890421
X-HE-Meta: U2FsdGVkX1/PPaPBQKjDbkiT1c/Z6E6ciSoGoECQJWnLeb4N5Zyyzd0yrkqGwB41/WlCsiB6em2nhH+98sbeYipKUOJ+X0PHDcFHPSH+9nRH4mLml95E9Sg6bGe46prl253/K5qYfAVWOkIJ3cuR4G8z8glaI7ZzpHpXtPyKrGS3k06i2so3hMu+3uGtAUX6vv64oX7ZP2Lj9uAaXJo/JW+Z2HB8GI90nUAo4RC0krW9xn9EafAQx+I5pNl5HFEGS7rlhxsuWddRjcFPw3OW9f8f7ob/RNe+3EmeZ+3U9GPCG9ErlfsvE6FcoIUl3DmEFylkyERz9H993fQd+OKO4Q08g4dxWiOPoUDua6MJG7Zbgv6CPJa6M60kBEWR9gDzAySc8kuJ3TdHFmZVGWsM7aS+DhnzSWnWgWxE9+VF8rjYp3wkHZCimALHoCfChbY7jfxlcrNv2S7fG5lOcuukbAAjHnVV2KIHUlv71ylXwitb1utJzjNfAhyurIvrYK/niq5TNIDZSGAU/lnfu3v6wI4NVAunFx4rjYBN6SdiQcmZVjqmB2ReY47kXntVFpoG4No6yH0wVBa6X+PHpbe8k0Hme4Vok6Zcx0A99Su6HrIsdqaCgiihoxyHbYCXjCkhST0TGmOC8B4Q3BidrnZsXlg1f7GmBEG9KIz46ejVbHHFtcPr0v3FKOWQklfbiFAYCjZg1hy5YcRM45N/mGLYGGoLvAEgyyyZrRmx1qxqV1SBn0U4rlm8R5RDjJhB5jw8FUpmqGB57ma7/kComzB3cXGnduMw4pku0hg6f9sujYXDWuvtx7t+9WOHF+ZGhiV0+41YEgwHZFSOSOBLZtO77oLAwDP3Br3mKzRo1kQ/iEk396Co2afnrCG6P0pmyx62k2YyJvpNdXQ8CcDYXuIXjXc7D0Ty1hP7ngomb8dqcfjo4HCuCMVsGNcmuDL/6mAIkLjZVIBiz3nnhmlpKu8
 PU3U1yq4
 JA6zmdoViw6O00cC00I43AoQ3SJEe55EuK4DXnmDH7hhSzNZ9qtrvgO9JbbC/to4C6s0InhMyuPDqzVuacZM4IEH9Yrm8QLSUGKk9mBb1mILl39SQPVELD6tcJhYz4d5OV4V0XwSrIXhQHSolydH6aA5m4CJ6samxloyCm43Ri/gYU6+WsacJE+T9LjsJLic8oDKhsOpodDoWq9fVPcTEwB+O8Q4TW+OVVcjWg8Qtitpkon10ME3ED8zXMI1GQwUnw5JQXNVm/lALf8Vbi1i5C0uE07YXpeRDqFkRrFzfb1zghBcClERC1kqEIUY8FJG4u8+Yvqq4mIw9bNDJ/AVxsXdKnRIWE5ooU+Ye
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Organize superpageblocks into bucketed lists by fullness level and taint
status to enable efficient allocation steering without sorting.

Five fullness buckets (FULL, 75%, 50%, 25%, ALMOST_EMPTY) track what
fraction of a superpageblock's pageblocks are in use. Two categories (CLEAN
vs TAINTED) distinguish superpageblocks that contain only free and movable
pageblocks from those contaminated with unmovable, reclaimable, or reserved
pageblocks. A separate sb_empty list tracks completely free
superpageblocks.

Track fully-free pageblocks with a PB_all_free pageblock flag. When buddy
coalescing reconstructs a full pageblock, increment nr_free. Type counters
are driven by PB_has_* bit transitions, not by migratetype label changes.

For tainted superpageblocks, fullness is based on unmovable + reclaimable
pageblock counts rather than total usage, correctly reflecting how full
they are with the content types we're trying to concentrate.

Add a debugfs interface at /sys/kernel/debug/superpageblocks.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h          |  22 +++
 include/linux/pageblock-flags.h |   1 +
 mm/mm_init.c                    |  26 ++-
 mm/page_alloc.c                 | 295 +++++++++++++++++++++++++++++++-
 4 files changed, 339 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 19190328e0c7..b8ada3d13a34 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -995,6 +995,23 @@ enum zone_type {
  */
 #define SUPERPAGEBLOCK_NR_PAGEBLOCKS (1UL << (SUPERPAGEBLOCK_ORDER - pageblock_order))
 
+/* Superpageblock fullness buckets (by % of pageblocks in use) */
+enum sb_fullness {
+	SB_FULL,		/* 100% full, 0 free pageblocks */
+	SB_FULL_75,		/* 75-99% full */
+	SB_FULL_50,		/* 50-74% full */
+	SB_FULL_25,		/* 25-49% full */
+	SB_ALMOST_EMPTY,	/* 1-24% full */
+	__NR_SB_FULLNESS,
+};
+
+/* Superpageblock taint categories */
+enum sb_category {
+	SB_CLEAN,		/* only free + movable pageblocks */
+	SB_TAINTED,		/* has unmovable/reclaimable/reserved */
+	__NR_SB_CATEGORIES,
+};
+
 struct superpageblock {
 	/* Pageblock counts by current migratetype */
 	u16			nr_free;
@@ -1002,6 +1019,7 @@ struct superpageblock {
 	u16			nr_reclaimable;
 	u16			nr_movable;
 	u16			nr_reserved;	/* holes, firmware, etc. */
+	u16			total_pageblocks; /* zone-clipped total */
 
 	/* For organizing superpageblocks by fullness category */
 	struct list_head	list;
@@ -1059,6 +1077,10 @@ struct zone {
 	unsigned long		superpageblock_base_pfn; /* 1GB-aligned base */
 	bool			spb_kvmalloced; /* true if from kvmalloc (hotplug) */
 
+	/* Superpageblock fullness lists for allocation steering */
+	struct list_head	spb_empty;	/* completely free superpageblocks */
+	struct list_head	spb_lists[__NR_SB_CATEGORIES][__NR_SB_FULLNESS];
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 21bfcdf80b2e..4dce39d054a9 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -28,6 +28,7 @@ enum pageblock_bits {
 	PB_has_unmovable,
 	PB_has_reclaimable,
 	PB_has_movable,
+	PB_all_free,	/* All pages in pageblock are free in buddy */
 
 #ifdef CONFIG_MEMORY_ISOLATION
 	/*
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ad1cbc2b4498..2dc73d8a8d6c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1548,7 +1548,17 @@ static void __meminit init_one_superpageblock(struct superpageblock *sb,
 	actual_pbs = (pb_end > pb_start) ?
 		     ((pb_end - pb_start + pageblock_nr_pages - 1) >>
 		      pageblock_order) : 0;
+	sb->total_pageblocks = actual_pbs;
 	sb->nr_reserved = actual_pbs;
+	if (actual_pbs) {
+		/*
+		 * All superpageblocks start as reserved (tainted+full).
+		 * They move to the correct category when the pages
+		 * inside are freed during boot.
+		 */
+		list_add_tail(&sb->list,
+			      &zone->spb_lists[SB_TAINTED][SB_FULL]);
+	}
 }
 
 static void __init setup_superpageblocks(struct zone *zone)
@@ -1558,11 +1568,18 @@ static void __init setup_superpageblocks(struct zone *zone)
 	unsigned long sb_base, nr_superpageblocks;
 	size_t alloc_size;
 	unsigned long i;
+	int cat, full;
 
 	zone->superpageblocks = NULL;
 	zone->nr_superpageblocks = 0;
 	zone->superpageblock_base_pfn = 0;
 
+	/* Fullness lists steer allocations to preferred superpageblocks */
+	INIT_LIST_HEAD(&zone->spb_empty);
+	for (cat = 0; cat < __NR_SB_CATEGORIES; cat++)
+		for (full = 0; full < __NR_SB_FULLNESS; full++)
+			INIT_LIST_HEAD(&zone->spb_lists[cat][full]);
+
 	if (!zone->spanned_pages)
 		return;
 
@@ -1688,8 +1705,9 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 	}
 
 	/*
-	 * Update existing superpageblocks whose nr_reserved may have
-	 * increased due to the zone span growing into them.
+	 * Update existing superpageblocks whose nr_reserved and
+	 * total_pageblocks may have increased due to the zone
+	 * span growing into them.
 	 */
 	if (zone->superpageblocks) {
 		old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
@@ -1707,8 +1725,10 @@ void __meminit resize_zone_superpageblocks(struct zone *zone)
 				sb->nr_reclaimable + sb->nr_movable +
 				sb->nr_reserved;
 
-			if (new_pbs > old_pbs)
+			if (new_pbs > old_pbs) {
 				sb->nr_reserved += new_pbs - old_pbs;
+				sb->total_pageblocks = new_pbs;
+			}
 		}
 	}
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b9b7d54a869c..c0f86a30b5c7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -56,6 +56,8 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -514,7 +516,157 @@ static void __spb_set_has_type(struct page *page, int migratetype)
 }
 
 /**
- * set_pageblock_migratetype - Set the migratetype of a pageblock
+ * spb_get_category - Determine if a superpageblock is clean or tainted
+ * @sb: superpageblock to classify
+ *
+ * A superpageblock is clean if it contains only free and movable pageblocks.
+ * Any unmovable, reclaimable, or reserved pageblocks make it tainted.
+ * Reserved pageblocks (memory holes) taint the superpageblock because it
+ * can never be used for 1GB hugepages, making it a better home for
+ * unmovable/reclaimable allocations.
+ */
+static inline enum sb_category spb_get_category(struct superpageblock *sb)
+{
+	if (sb->nr_unmovable || sb->nr_reclaimable || sb->nr_reserved)
+		return SB_TAINTED;
+	return SB_CLEAN;
+}
+
+/**
+ * sb_get_fullness - Determine the fullness bucket for a superpageblock
+ * @sb: superpageblock to classify
+ * @cat: the category (CLEAN or TAINTED) of this superpageblock
+ *
+ * For clean SPBs, fullness is based on total usage (total - nr_free).
+ * For tainted SPBs, fullness is based only on unmovable + reclaimable
+ * pageblocks, since those are what we're trying to concentrate.
+ * Uses SUPERPAGEBLOCK_NR_PAGEBLOCKS as divisor so that partial
+ * superpageblocks at zone boundaries are preferred over whole ones.
+ */
+static inline enum sb_fullness sb_get_fullness(struct superpageblock *sb,
+					       enum sb_category cat)
+{
+	unsigned int used, total = sb->total_pageblocks;
+	unsigned int quarter = SUPERPAGEBLOCK_NR_PAGEBLOCKS / 4;
+
+	if (!total)
+		return SB_FULL;
+
+	if (cat == SB_TAINTED)
+		used = sb->nr_unmovable + sb->nr_reclaimable;
+	else
+		used = total - sb->nr_free;
+
+	if (used >= total)
+		return SB_FULL;
+
+	if (used >= 3 * quarter)
+		return SB_FULL_75;
+	if (used >= 2 * quarter)
+		return SB_FULL_50;
+	if (used >= quarter)
+		return SB_FULL_25;
+	return SB_ALMOST_EMPTY;
+}
+
+/**
+ * spb_update_list - Move a superpageblock to the correct fullness list
+ * @sb: superpageblock to reclassify
+ *
+ * Called after counters change. Removes from current list (if any)
+ * and adds to the appropriate list based on current fullness and
+ * taint status.
+ */
+static void spb_update_list(struct superpageblock *sb)
+{
+	struct zone *zone = sb->zone;
+	enum sb_category cat;
+	enum sb_fullness full;
+
+	list_del_init(&sb->list);
+
+	if (sb->nr_free == SUPERPAGEBLOCK_NR_PAGEBLOCKS) {
+		list_add_tail(&sb->list, &zone->spb_empty);
+		return;
+	}
+
+	cat = spb_get_category(sb);
+	full = sb_get_fullness(sb, cat);
+	list_add_tail(&sb->list, &zone->spb_lists[cat][full]);
+}
+
+/**
+ * superpageblock_pb_now_free - A pageblock just became fully free in buddy
+ * @page: page in the pageblock
+ *
+ * When buddy coalescing reconstructs a complete pageblock-order page,
+ * increment nr_free. Type counters are handled separately in
+ * mark_pageblock_free().
+ */
+static void superpageblock_pb_now_free(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb = pfn_to_superpageblock(page_zone(page), pfn);
+
+	if (!sb)
+		return;
+
+	sb->nr_free++;
+
+	spb_update_list(sb);
+}
+
+/**
+ * superpageblock_pb_now_used - A fully-free pageblock just got its first allocation
+ * @page: page in the pageblock
+ *
+ * When allocating from an order >= pageblock_order free page, decrement
+ * nr_free. Type counters are handled separately by __spb_set_has_type()
+ * at allocation time.
+ */
+static void superpageblock_pb_now_used(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct superpageblock *sb = pfn_to_superpageblock(page_zone(page), pfn);
+
+	if (!sb)
+		return;
+
+	if (sb->nr_free)
+		sb->nr_free--;
+
+	spb_update_list(sb);
+}
+
+/**
+ * superpageblock_range_now_used - Mark a multi-pageblock free range as no longer free
+ * @page: first page of the range (must be pageblock-aligned)
+ * @order: order of the range (must be >= pageblock_order)
+ *
+ * When a free page of order >= pageblock_order is removed from buddy outside
+ * the normal allocation path (e.g. __isolate_free_page, memory hotplug,
+ * HW poison takeoff), every constituent pageblock leaves its PB_all_free
+ * state. Walk the range, clear PB_all_free, and decrement nr_free for each
+ * affected pageblock. PB_has_* bits are not touched: the pages are not being
+ * allocated to a specific migratetype here. They will be re-established by
+ * mark_pageblock_free() if the pages later return to buddy and coalesce.
+ */
+static void superpageblock_range_now_used(struct page *page, unsigned int order)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long end_pfn = pfn + (1UL << order);
+
+	for (; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *pb_page = pfn_to_page(pfn);
+
+		if (get_pfnblock_bit(pb_page, pfn, PB_all_free)) {
+			clear_pfnblock_bit(pb_page, pfn, PB_all_free);
+			superpageblock_pb_now_used(pb_page);
+		}
+	}
+}
+
+/** set_pageblock_migratetype - Set the migratetype of a pageblock
  * @page: The page within the block of interest
  * @migratetype: migratetype to set
  */
@@ -577,6 +729,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		if (sb->nr_reserved)
 			sb->nr_reserved--;
 		__spb_set_has_type(page, migratetype);
+		spb_update_list(sb);
 	}
 }
 
@@ -1015,6 +1168,11 @@ static void mark_pageblock_free(struct page *page, unsigned long pfn)
 	clear_pfnblock_bit(page, pfn, PB_has_unmovable);
 	clear_pfnblock_bit(page, pfn, PB_has_reclaimable);
 	clear_pfnblock_bit(page, pfn, PB_has_movable);
+
+	if (!get_pfnblock_bit(page, pfn, PB_all_free)) {
+		set_pfnblock_bit(page, pfn, PB_all_free);
+		superpageblock_pb_now_free(page);
+	}
 }
 
 /*
@@ -1063,7 +1221,8 @@ static inline void __free_one_page(struct page *page,
 
 	/*
 	 * When freeing a whole pageblock, clear stale PCP ownership
-	 * and actual-contents tracking flags up front.  The in-loop
+	 * and actual-contents tracking flags up front, and mark it
+	 * as fully free for superpageblock accounting.  The in-loop
 	 * check only fires when sub-pageblock pages merge *up to*
 	 * pageblock_order, not when entering at pageblock_order
 	 * directly.
@@ -2006,6 +2165,20 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 {
 	int nr_pages = 1 << high;
 
+	/*
+	 * If we're splitting a page that spans at least a full pageblock,
+	 * the allocated pageblock transitions from fully-free to in-use.
+	 * Clear PB_all_free and update superpageblock accounting.
+	 */
+	if (high >= pageblock_order) {
+		unsigned long pfn = page_to_pfn(page);
+
+		if (get_pfnblock_bit(page, pfn, PB_all_free)) {
+			clear_pfnblock_bit(page, pfn, PB_all_free);
+			superpageblock_pb_now_used(page);
+		}
+	}
+
 	__del_page_from_free_list(page, zone, high, migratetype);
 	nr_pages -= expand(zone, page, low, high, migratetype);
 	account_freepages(zone, -nr_pages, migratetype);
@@ -2535,6 +2708,25 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		unsigned long pb_pfn;
+
+		/*
+		 * Clear PB_all_free for pageblocks being claimed.
+		 * This path bypasses page_del_and_expand(), so we
+		 * must handle the free→used transition here.
+		 * Use block_type (the original migratetype) because
+		 * that's what was decremented when PB_all_free was set.
+		 */
+		for (pb_pfn = page_to_pfn(page);
+		     pb_pfn < page_to_pfn(page) + (1 << current_order);
+		     pb_pfn += pageblock_nr_pages) {
+			struct page *pb_page = pfn_to_page(pb_pfn);
+
+			if (get_pfnblock_bit(pb_page, pb_pfn, PB_all_free)) {
+				clear_pfnblock_bit(pb_page, pb_pfn, PB_all_free);
+				superpageblock_pb_now_used(pb_page);
+			}
+		}
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
@@ -3651,6 +3843,14 @@ int __isolate_free_page(struct page *page, unsigned int order)
 
 	del_page_from_free_list(page, zone, order, mt);
 
+	/*
+	 * The free page is leaving buddy. For order >= pageblock_order, every
+	 * constituent pageblock had PB_all_free set; clear those bits and
+	 * decrement nr_free so the SPB pageblock-level counter stays in sync.
+	 */
+	if (order >= pageblock_order)
+		superpageblock_range_now_used(page, order);
+
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
 	 * pageblock
@@ -8163,6 +8363,8 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		BUG_ON(!PageBuddy(page));
 		VM_WARN_ON(get_pageblock_migratetype(page) != MIGRATE_ISOLATE);
 		order = buddy_order(page);
+		if (order >= pageblock_order)
+			superpageblock_range_now_used(page, order);
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
@@ -8254,6 +8456,25 @@ bool take_page_off_buddy(struct page *page)
 
 			del_page_from_free_list(page_head, zone, page_order,
 						migratetype);
+			/*
+			 * break_down_buddy_pages() re-adds every non-target
+			 * pageblock to buddy at order >= pageblock_order, so
+			 * those keep their PB_all_free state. Only the target's
+			 * pageblock loses its fully-free status -- clear that
+			 * one bit and decrement the SPB nr_free counter.
+			 */
+			if (page_order >= pageblock_order) {
+				unsigned long pfn_pb = ALIGN_DOWN(pfn,
+							pageblock_nr_pages);
+				struct page *pb_page = pfn_to_page(pfn_pb);
+
+				if (get_pfnblock_bit(pb_page, pfn_pb,
+						     PB_all_free)) {
+					clear_pfnblock_bit(pb_page, pfn_pb,
+							   PB_all_free);
+					superpageblock_pb_now_used(pb_page);
+				}
+			}
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
 			SetPageHWPoisonTakenOff(page);
@@ -8558,3 +8779,73 @@ struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int or
 	return page;
 }
 EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
+
+#ifdef CONFIG_DEBUG_FS
+static const char * const sb_fullness_names[] = {
+	"full", "75pct", "50pct", "25pct", "almost_empty"
+};
+
+static const char * const sb_category_names[] = {
+	"clean", "tainted"
+};
+
+static int superpageblock_debugfs_show(struct seq_file *m, void *v)
+{
+	struct zone *zone;
+	int cat, full;
+
+	for_each_populated_zone(zone) {
+		unsigned long i;
+		int empty_count = 0;
+		struct superpageblock *sb;
+
+		if (!zone->superpageblocks)
+			continue;
+
+		seq_printf(m, "Node %d, zone %8s: %lu superpageblocks, base_pfn=0x%lx\n",
+			   zone->zone_pgdat->node_id, zone->name,
+			   zone->nr_superpageblocks, zone->superpageblock_base_pfn);
+
+		list_for_each_entry(sb, &zone->spb_empty, list)
+			empty_count++;
+		if (empty_count)
+			seq_printf(m, "  empty: %d\n", empty_count);
+
+		for (cat = 0; cat < __NR_SB_CATEGORIES; cat++) {
+			for (full = 0; full < __NR_SB_FULLNESS; full++) {
+				int count = 0;
+
+				list_for_each_entry(sb,
+					&zone->spb_lists[cat][full], list)
+					count++;
+				if (count)
+					seq_printf(m, "  %s/%s: %d\n",
+						   sb_category_names[cat],
+						   sb_fullness_names[full],
+						   count);
+			}
+		}
+
+		/* Per-superpageblock detail */
+		for (i = 0; i < zone->nr_superpageblocks; i++) {
+			sb = &zone->superpageblocks[i];
+			seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u\n",
+				   i, sb->start_pfn,
+				   sb->nr_unmovable, sb->nr_reclaimable,
+				   sb->nr_movable, sb->nr_reserved,
+				   sb->nr_free, sb->total_pageblocks);
+		}
+	}
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(superpageblock_debugfs);
+
+static int __init superpageblock_debugfs_init(void)
+{
+	debugfs_create_file("superpageblocks", 0444, NULL, NULL,
+			    &superpageblock_debugfs_fops);
+	return 0;
+}
+late_initcall(superpageblock_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
-- 
2.54.0


