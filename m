Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F99CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0566B00A5; Fri,  2 Oct 2026 21:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EF96B00A6; Fri,  2 Oct 2026 21:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44ECD6B00A7; Fri,  2 Oct 2026 21:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 176466B00A5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:00:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2B1C160568
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:23 +0000 (UTC)
X-FDA: 85279509126.08.F8D45FC
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD1B51C0005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6CnTkNf4pF+7lVGZO0T8rz7cpx1vS4V/OtOdgJKt5E=;
	b=FB4URQFivBKJaD0i2M3mgD0/fvvINP6WiCId9lgqQy5wKQDQ5SqSYOywK1jymfOHIQIZdu
	02vPIvK4UvBn+Dlkej6/WQIPY36YSa+F66XEw9kbl2IF+s21I46uJn7I2ZMBezrvT1pmya
	cfO0CNF7b2d69XBjouVsrX74zRshXdg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989222;
	b=0zmRVpW+V4CjtEJoZWlpMzDMKEBoelh8U0APKEw8+D43wQhnX0YTCjdTfSJuYjbr9G+R73
	2r6XZ5Ca7wuchIoun8kM6c1z0emVLHOoQCIGB6XIMmIEaPnuw68CFe2BYek0NvQ+FmKrD3
	KliLaqlQHzIs2q/9ku2eFt2/7TBnbBU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a953de96ec39a165;
	Sat, 03 Oct 2026 01:00:19 +0000
X-Mizu-Trace-ID: a953de96ec39a165
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 09/12] mm, swap: back a large xswap folio with a contiguous physical run
Date: Sat,  3 Oct 2026 08:58:57 +0800
Message-ID: <20261003005900.909710-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: eyjkwadmumm46kr8bnphdwsfo7nnydrs
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD1B51C0005
X-HE-Tag: 1790989221-100259
X-HE-Meta: U2FsdGVkX1+nh14hJT6N6tyGhgZLFf+6KHRb21w4+ze33w55bTOh94XUgnm7Eja3N3azz/8JAnEn4l5rGcXb4KR5n6m8fHeXrOh7t8VOQaF+cFVP4r+H5/WxkqafNRF6EPi86f/+HPWqeMDpX12dBuSxZUbSmMnGE/lhs1rLEGGUpBv9x6/JHEBhaiCV3+QTsXMVF2/T9V4mwHAHNMPlRL8ZEExzamgGIJvkuq5xhkjWEqkNHUgXs1Jfu+OlHiYxL3wxJiAvw9PEB6v9kXFnBfTUdvxW719ghR/pCbGkUZCrEOG0j4dIXuq8GB3njnDm226CTwNAC5zveBQE5l8hUb6+s+IJjQnpCkQOw4HAAHuSEGon9Y86vJO2CbltME4Uw8PsDi0IuYbv7OATOzXpZcvxpqJOR/OR4P6j9aYwzoN78qr0fVIU1lYwwdtPnj+51Vuo4uMj6ZMqmTd9PHuewW/6+Y+tGZ9pfGPHfS6l18xc3nBNzLetNTkJnrSuBfIKBIb0eeDbRyuq/On9Jl/GBtSis2RWCp1m+JbqCt6AR77byq9yvuap9htS+QKvOSuStbepilKMhxm/dsSWvqLL9U/uBuL/GOoIWoY02lAAleKgVw/A48RLg7scMlq+NyaY1vYGpgLeGySwQJjGszQ/b7ouhgJez4RMvKmnyyo2vJ3XiOr7UcO5dd8YfNG9Qo+EN89YyjgVHNRtecdYorIVe79iKuDTcTwsnNF6PJTbI68xOKfJYkQgXEh/qAZbWnj471F1yyeYrev8slJ5fhmxGLNLbntnURMrRchZCvwaXEiCvySxdBpYm0YAq4Dm1jNYcagAbeZX9QRj+a7z4Lv2wHk0CoTb6fpyfsdCoL+Feq2A+Ix8Ubzh36dubmKNGOXA3ehO/ze5BVTQo+z9VwrzbHsiI4gh/Yedgi6nYCgGYWEdxuaP6LdNb7uLfgvBXpLPU1fcbUDGe5/yr0rwLyo
 OpIEV0yu
 yxK+THOoBkeiThAnZEDmJsNdS/A6dbxpY4H8rDHNw/4+AcsXbEas5tBgq21Uk43izaGr3QGHqR9CNRy/caUou6wn4+ufjrfk1J7nNhMQlcsjHs/qXrF/xJNbpZHdmGQ+zAkEYAREZ21oP6uJRJUaMYulPk0ZHHSAtETFqVH7YydXJfdniJg+fTnU8E9ghpCl1BALDxw0IBsR07w/isxC7aiTawuiUUPO8ge0Yut18iNUf8r/CI3PCcA25b2FpMbOkt6ME1OGCmb6Y1UboNaLUouBjpKpcS95Hjk1DUY5Nd684D2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A folio that zswap refuses goes to a physical swap device, one slot per
entry. A large folio is read back with a single IO from its first physical
slot, so its slots must be contiguous. Reserve the whole range at once by
passing the order down the allocation path.

The contiguous range must come from a block device backend: if a real
device exists but none is a block device, refuse the large order, so the
folio is split and swapped one page at a time. Record the backend in
xs_table before the reverse map that swapoff uses, so a slot is never
visible without its owner.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/page_io.c  |   2 +-
 mm/swap.h     |   8 +-
 mm/swapfile.c | 199 ++++++++++++++++++++++++++++++--------------------
 mm/zswap.c    |   4 +-
 4 files changed, 125 insertions(+), 88 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 7a7b7eecb2a8..7e8e8150bdcf 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -257,7 +257,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		swp_entry_t phys;
 
 		/* The pool refused it: fall back to a real swap device. */
-		phys = xswap_backend_alloc(entry);
+		phys = xswap_backend_alloc(entry, folio_order(folio));
 		if (!phys.val) {
 			folio_mark_dirty(folio);
 			return AOP_WRITEPAGE_ACTIVATE;
diff --git a/mm/swap.h b/mm/swap.h
index 838dac4282f6..9f04c8486b98 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -475,8 +475,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 
 #ifdef CONFIG_XSWAP
 swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot);
-swp_entry_t xswap_backend_alloc(swp_entry_t entry);
-void xswap_backend_free(swp_entry_t entry, swp_entry_t phys);
+swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order);
+void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order);
 #else
 static inline swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci,
 					     unsigned int slot)
@@ -484,12 +484,12 @@ static inline swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci,
 	return (swp_entry_t){};
 }
 
-static inline swp_entry_t xswap_backend_alloc(swp_entry_t entry)
+static inline swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 {
 	return (swp_entry_t){};
 }
 
-static inline void xswap_backend_free(swp_entry_t entry, swp_entry_t phys)
+static inline void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
 {
 }
 #endif /* CONFIG_XSWAP */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5b33b2c78ee4..8e005e8d2250 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1168,10 +1168,10 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci,
 					 struct folio *folio,
-					 unsigned int ci_off)
+					 unsigned int ci_off, unsigned int order)
 {
-	unsigned int order;
-	unsigned long nr_pages;
+	unsigned long nr_pages = 1UL << order;
+	unsigned long i;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -1180,33 +1180,24 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 
 	/*
 	 * All mm swap allocation starts with a folio (folio_alloc_swap),
-	 * it's also the only allocation path for large orders allocation.
-	 * Such swap slots starts with count == 0 and will be increased
-	 * upon folio unmap.
+	 * it's also the allocation path for large orders. Such swap slots
+	 * starts with count == 0 and will be increased upon folio unmap.
 	 *
-	 * Else, it's an exclusive order 0 allocation for a slot that has
-	 * no folio of its own: hibernation, and the physical slot that
-	 * backs an xswap entry. The slot starts with count == 1 and
-	 * never increases.
+	 * Else, it's an exclusive allocation for a range of slots that has no
+	 * folio of its own: hibernation, and the range that backs an xswap
+	 * folio. Each slot starts with count == 1 and never increases.
 	 */
+	swap_cluster_assert_empty(ci, ci_off, nr_pages, false);
 	if (likely(folio)) {
-		order = folio_order(folio);
-		nr_pages = 1 << order;
-		swap_cluster_assert_empty(ci, ci_off, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type,
 							    ci_off + cluster_offset(si, ci)));
 	} else {
-		order = 0;
-		nr_pages = 1;
-		swap_cluster_assert_empty(ci, ci_off, 1, false);
-		/* Fake shadow placeholder with no flag; no zeromap is used. */
-		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
+		/* Fake shadow placeholders with no flag; no zeromap is used. */
+		for (i = 0; i < nr_pages; i++)
+			__swap_table_set(ci, ci_off + i,
+					 __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
 	}
 
-	/*
-	 * The first allocation in a cluster makes the
-	 * cluster exclusive to this order
-	 */
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
@@ -1219,13 +1210,13 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
 					     struct swap_cluster_info *ci,
 					     struct folio *folio,
-					     unsigned long offset)
+					     unsigned long offset,
+					     unsigned int order)
 {
 	unsigned long next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
-	unsigned int nr_pages = 1 << order;
+	unsigned long nr_pages = 1UL << order;
 	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
@@ -1251,7 +1242,7 @@ static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
-		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
+		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER, order))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -1282,7 +1273,7 @@ static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
 static unsigned long alloc_swap_scan_list(struct swap_info_struct *si,
 					  struct list_head *list,
 					  struct folio *folio,
-					  bool scan_all)
+					  unsigned int order, bool scan_all)
 {
 	unsigned long found = SWAP_ENTRY_INVALID;
 
@@ -1293,7 +1284,7 @@ static unsigned long alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, order);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1374,25 +1365,49 @@ static void swap_reclaim_work(struct work_struct *work)
 	swap_reclaim_full_clusters(si, true);
 }
 
+#ifdef CONFIG_XSWAP
+/* Whether a block device that can back a large xswap folio is available. */
+static bool xswap_has_large_backend(void)
+{
+	struct swap_info_struct *si;
+	bool found = false;
+
+	spin_lock(&swap_avail_lock);
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
+		if (!(si->flags & SWP_XSWAP) && (si->flags & SWP_BLKDEV)) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&swap_avail_lock);
+
+	return found;
+}
+#endif /* CONFIG_XSWAP */
+
 /*
  * Try to allocate swap entries with specified order and try set a new
  * cluster for current CPU too.
  */
 static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
-					      struct folio *folio)
+					      struct folio *folio, unsigned int order)
 {
 	struct swap_cluster_info *ci;
-	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
-	 * to allocate large entries.
+	 * to allocate large entries. xswap has no backing file, so it can.
 	 */
-	if (order && !(si->flags & SWP_BLKDEV))
+	if (order && !(si->flags & SWP_BLKDEV) && !(si->flags & SWP_XSWAP))
 		return 0;
 
 #ifdef CONFIG_XSWAP
+	/* A large xswap folio needs a contiguous block device run behind it. */
+	if (order && (si->flags & SWP_XSWAP) &&
+	    atomic_read(&nr_real_swapfiles) && !xswap_has_large_backend())
+		return 0;
+
 	/*
 	 * Top the range up early.  Every path below leaves through `done`,
 	 * so this has to come first; mapping pages can sleep, and doing it
@@ -1415,7 +1430,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset, order);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1429,7 +1444,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	 * cluster is the only thing a large order can allocate from.
 	 */
 	if (!folio && order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, order, false);
 		if (found)
 			goto done;
 	}
@@ -1439,19 +1454,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, order, false);
 		if (found)
 			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, order, true);
 		if (found)
 			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, order, false);
 		if (found)
 			goto done;
 	}
@@ -1467,7 +1482,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, order, false);
 		if (found)
 			goto done;
 	}
@@ -1481,11 +1496,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, order, true);
 		if (found)
 			goto done;
 
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, order, true);
 		if (found)
 			goto done;
 	}
@@ -1493,7 +1508,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 #ifdef CONFIG_XSWAP
 	/* A concurrent free or grow may have added clusters; retry once. */
 	if (!found && (si->flags & SWP_XSWAP))
-		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, order, false);
 #endif
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
@@ -1714,7 +1729,7 @@ static bool swap_alloc_fast(struct folio *folio, bool may_zswap)
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
+		alloc_swap_scan_cluster(si, ci, folio, offset, order);
 	} else {
 		swap_cluster_unlock(ci);
 	}
@@ -1742,7 +1757,7 @@ static void swap_alloc_slow(struct folio *folio, bool may_zswap)
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			cluster_alloc_swap_entry(si, folio);
+			cluster_alloc_swap_entry(si, folio, folio_order(folio));
 			put_swap_device(si);
 			if (folio_test_swapcache(folio))
 				return;
@@ -2562,13 +2577,13 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (pcp_si == si && pcp_offset) {
 		ci = swap_cluster_lock(si, pcp_offset);
 		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset, 0);
 		else
 			swap_cluster_unlock(ci);
 	}
 	rcu_read_unlock();
 	if (!offset)
-		offset = cluster_alloc_swap_entry(si, NULL);
+		offset = cluster_alloc_swap_entry(si, NULL, 0);
 	local_unlock(&percpu_swap_cluster.lock);
 	if (offset)
 		entry = swp_entry(si->type, offset);
@@ -4505,32 +4520,33 @@ static void xswap_free_xs_table(struct swap_info_struct *si,
 	ci->xs_table = NULL;
 }
 
-/* Order-0 slot from @si, no folio attached; goes through the per-CPU cache. */
-static unsigned long xswap_alloc_slot_local(struct swap_info_struct *si)
+/* A range of 1 << @order slots, no folio attached. */
+static unsigned long xswap_alloc_slot_local(struct swap_info_struct *si,
+					    unsigned int order)
 {
 	struct swap_cluster_info *ci;
 	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
 
 	local_lock(&percpu_swap_cluster.lock);
-	if (this_cpu_read(percpu_swap_cluster.si[0]) == si) {
-		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+	if (this_cpu_read(percpu_swap_cluster.si[order]) == si) {
+		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[order]);
 		if (pcp_offset) {
 			ci = swap_cluster_lock(si, pcp_offset);
-			if (cluster_is_usable(ci, 0))
+			if (cluster_is_usable(ci, order))
 				offset = alloc_swap_scan_cluster(si, ci, NULL,
-								 pcp_offset);
+								 pcp_offset, order);
 			else
 				swap_cluster_unlock(ci);
 		}
 	}
 	if (offset == SWAP_ENTRY_INVALID)
-		offset = cluster_alloc_swap_entry(si, NULL);
+		offset = cluster_alloc_swap_entry(si, NULL, order);
 	local_unlock(&percpu_swap_cluster.lock);
 
 	return offset;
 }
 
-static swp_entry_t xswap_alloc_phys_slot(void)
+static swp_entry_t xswap_alloc_phys_slot(unsigned int order)
 {
 	struct swap_info_struct *devs[MAX_SWAPFILES], *si;
 	int nr = 0, i;
@@ -4555,7 +4571,7 @@ static swp_entry_t xswap_alloc_phys_slot(void)
 
 		if (!get_swap_device_info(devs[i]))
 			continue;
-		offset = xswap_alloc_slot_local(devs[i]);
+		offset = xswap_alloc_slot_local(devs[i], order);
 		put_swap_device(devs[i]);
 		if (offset && offset != SWAP_ENTRY_INVALID)
 			return swp_entry(devs[i]->type, offset);
@@ -4581,57 +4597,78 @@ static void xswap_install_rmap(swp_entry_t phys, swp_entry_t entry)
 	}
 }
 
-swp_entry_t xswap_backend_alloc(swp_entry_t entry)
+/* Back the range of 1 << @order slots at @entry with contiguous physical slots. */
+swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
+	unsigned long nr = 1UL << order;
 	unsigned long off = swp_offset(entry);
 	swp_entry_t phys;
-	bool recorded = false;
+	unsigned int i;
+
+	/*
+	 * Get the xswap side ready before a physical slot exists, so the
+	 * reverse map installed below cannot expose a slot with no owner.
+	 */
+	ci = swap_cluster_lock(si, off);
+	if (!ci)
+		return (swp_entry_t){};
+	if (!xswap_xs_table_locked(ci, GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC)) {
+		swap_cluster_unlock(ci);
+		return (swp_entry_t){};
+	}
+	swap_cluster_unlock(ci);
 
-	phys = xswap_alloc_phys_slot();
+	phys = xswap_alloc_phys_slot(order);
 	if (!phys.val)
 		return phys;
 
-	xswap_install_rmap(phys, entry);
+	/* One IO reads a large folio, so its range has to be contiguous. */
+	VM_WARN_ON_ONCE(swp_offset(phys) % nr);
+	VM_WARN_ON_ONCE(off % SWAPFILE_CLUSTER + nr > SWAPFILE_CLUSTER);
 
+	/* Owner first, then the reverse map, under one hold of the lock. */
 	ci = swap_cluster_lock(si, off);
-	if (ci) {
-		recorded = xswap_slot_set_backend(ci, off % SWAPFILE_CLUSTER, phys);
-		swap_cluster_unlock(ci);
-	}
+	for (i = 0; i < nr; i++) {
+		swp_entry_t cur = swp_entry(swp_type(phys), swp_offset(phys) + i);
 
-	if (!recorded) {
-		/* The backend is unrecorded, so the data would be unreachable. */
-		xswap_backend_free(entry, phys);
-		return (swp_entry_t){};
+		xswap_slot_set_backend(ci, (off + i) % SWAPFILE_CLUSTER, cur);
+		xswap_install_rmap(cur, swp_entry(si->type, off + i));
 	}
+	swap_cluster_unlock(ci);
 
 	return phys;
 }
 
 /* Undo xswap_backend_alloc(): the zswap copy is still in place. */
-void xswap_backend_free(swp_entry_t entry, swp_entry_t phys)
+void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
-	struct swap_info_struct *psi;
-	struct swap_cluster_info *ci;
+	struct swap_info_struct *psi = swap_type_to_info(swp_type(phys));
+	unsigned long nr = 1UL << order;
 	unsigned long off = swp_offset(entry);
+	unsigned long poff = swp_offset(phys);
+	unsigned int i;
 
-	ci = swap_cluster_lock(si, off);
-	if (ci) {
-		unsigned int slot = off % SWAPFILE_CLUSTER;
-		unsigned long *xs = ci->xs_table;
+	for (i = 0; i < nr; i++) {
+		struct swap_cluster_info *ci;
 
-		if (xs && xs[slot] == phys.val)
-			WRITE_ONCE(xs[slot], 0);
-		swap_cluster_unlock(ci);
-	}
+		ci = swap_cluster_lock(si, off + i);
+		if (ci) {
+			unsigned int slot = (off + i) % SWAPFILE_CLUSTER;
+			unsigned long *xs = ci->xs_table;
 
-	/* xswap_free_phys_slot() clears the reverse mapping. */
-	psi = swap_type_to_info(swp_type(phys));
-	if (psi)
-		xswap_free_phys_slot(psi, entry, phys);
+			if (xs && xs[slot] == phys.val + i)
+				WRITE_ONCE(xs[slot], 0);
+			swap_cluster_unlock(ci);
+		}
+
+		/* xswap_free_phys_slot() clears the reverse mapping. */
+		if (psi)
+			xswap_free_phys_slot(psi, swp_entry(si->type, off + i),
+					     swp_entry(swp_type(phys), poff + i));
+	}
 }
 
 static int xswap_map_clusters(struct swap_info_struct *si,
diff --git a/mm/zswap.c b/mm/zswap.c
index e614c04697f2..03171e4f2852 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1056,7 +1056,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	/* Reserve the destination before dropping the zswap copy. */
 	if (is_xswap) {
-		phys = xswap_backend_alloc(swpentry);
+		phys = xswap_backend_alloc(swpentry, 0);
 		if (!phys.val) {
 			ret = -ENOMEM;
 			goto err;
@@ -1102,7 +1102,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 err:
 	if (is_xswap && phys.val)
-		xswap_backend_free(swpentry, phys);
+		xswap_backend_free(swpentry, phys, 0);
 	swap_cache_del_folio(folio);
 	folio_unlock(folio);
 	folio_put(folio);
-- 
2.54.0


