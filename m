Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EB4C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AE16B00A0; Sun, 20 Sep 2026 03:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50A76B00A1; Sun, 20 Sep 2026 03:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A679C6B00A2; Sun, 20 Sep 2026 03:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75CA56B00A0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A374403BC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:54 +0000 (UTC)
X-FDA: 85233296148.21.23DEF14
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D8CA100002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888912;
	b=Scx+4Db0Rvru3mkSdxKod7vhHXu81Pu0tuGkifNPv1W4ZmoaiL1zKD4azGgdzPQcqXQ7R1
	NRFQZDPjWn583BkvwkhozlOBFTKL+LAOkN9JKMqnlt91SC5p7Qbk5VrIeqI6IwD+aTS4DC
	d0TCbP8NDkTpQtLPScflJrJ3OukTAsA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTDlYUnwN8bbMMIymPR88Yw4oUO5As/QpBxQYiAusQU=;
	b=Ekx7+3pn817S2nOn+wzqiDff9nbLvmmUucGqO2/c+R5TRWCBj29rHrDCKH/ii4guFEyPsA
	O7dAr8c5eF8x5j4HInZlzUV767d1jvC+lhPsWGxvjMTypwnZDeFtEO9ST2eeR34NVRGjTS
	pIDVBy9xeNm1b38BjxhXsl7Tk2vaM3w=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id b616812cf45180e8;
	Sun, 20 Sep 2026 07:21:51 +0000
X-Mizu-Trace-ID: b616812cf45180e8
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
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 09/17] mm, swap: back a large xswap folio with a contiguous physical run
Date: Sun, 20 Sep 2026 15:20:35 +0800
Message-ID: <20260920072043.430390-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D8CA100002
X-Stat-Signature: 5iekikz9f7rywf7ju3s1wna7z8eiqpx5
X-HE-Tag: 1789888912-4904
X-HE-Meta: U2FsdGVkX1/QQD1hPkwHQxG1cj4ac6Mh8uYC4k3Wh0W4Va2c5adtea6rq9skby8bmobNeRyCJr7kFI8IR+uCVhA52mlXH0BAf7ovBZBDSJa7J8OztoKORosbt6BpLeiJLkqO+HnUTS9u7ETfQtQZ9/RzUq3h/Dd9sB+hzROdZyik+SDkobmmu4jvsMK6Ix+xKxQdS1SUQUzLtpQvrh7GSFnRLBih6Y9AUYSbHkbzXvzKgcqV1f/t+DerJHcXz+nJdeLbpnPnK+CGpZq37ynmxdDC4wofOdlUOicQmswYnr8ov8Qki5Fanxr8HZO+OiUjfZ9QZC1YY84qF1J/gIdd/+pTFWqwIkaEMu0MGGGJdDhr7HnHhHcNymP7kBbk3Y6V1jbE3ELSfrl7ZT88nQSC38gkZvV7ldxz0ry4PZCUaEVqeT5VQernZDnmUYytY6OoTOtnDi36gxYkTrpYEEhwLtJgLTdb6ED1iA4osQaxMvqJseq3jhw89+PzzRXJdk/oBqEwF0Gmh0hnfAVkMx84i1jIYecWw7SKtiSd6ahI8WwLZtVysgu2UZhUzfOcsEqdd6uwDl+S386kQCx7Ul+ei1R3FCpF9z9tINq6Bp5WCH0nYLQWt4/OcUT5Pu/Pq687dnxZq47c2RkvRO0ZtmdFHeBTvve6mzPJUpBINPgCHFpICtTQRefA9XcwmRXHyEtAsVXvs7AJOOoQgRDUB0CRXH1kYW7Jj1v3B4IWO3IOUVGLK/XSFx6IcQgAEjqNnNhPamr0aCkiQltBMvrq3cU8EtrjGem7zshO3eKLKsFrOC57pLi9+OEni52GCo9Z2MyAd2JXduJADAlHCWHh37OBvUAF3q8OJB6e5Q87VsIGTc/3bWWOTsqtDieDb1uxhb0z7HUeFNZ2iOmXieHE+RsI6XxX2r1LaxpvsGDaTTTKbTdYn+vIPx2FS9VD6cqK0JGMeeqL1bLGsqjROFtSHB0
 BzYl4kqa
 Q2kQNLTyY4FB4BgAgOGcmN0PCi8Jx4/V/cBuJYRB4hXFxXNyRxTEHNXqj7KUfYqJ7sy/yQHiWrv3hhPSBCSNZeiLeUhWiNJaSPiY56H8NDYQ91dQg0W/kMizrQlPj+dTmh5EqhZvcTh4h0a5N7QcqT5Lz4I8YeWN6eq2LKondhwGxOK9JkOia0TcfiRUdXMspbbvJQUa0VqVgUJrxgXGOBsIp8+e1jIU2GrLT3YuIYbYARQ39maUmRgfoK+MM6JjbnAtJAyEJhgaS14Hb/KD0cVT/dL/9yOaw7CHJwQTyslPtvKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap refuses a folio, the folio goes to a physical swap device.
A small folio takes one slot there. A large folio is different as it must
sit in a contiguous run of slots. This is because swap_read_folio()
reads it back with one IO that starts at its first physical slot.

So the whole run has to be reserved at once. The problem is that the
reservation path has no folio, so it only knows order 0. Pass the order
down through cluster_alloc_swap_entry(), and let it fill a range of
shadow entries.

The xswap device must accept large orders too. Otherwise a large anon
folio cannot be swapped out to it at all.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/page_io.c  |   2 +-
 mm/swap.h     |   8 +--
 mm/swapfile.c | 164 +++++++++++++++++++++++++++-----------------------
 mm/zswap.c    |   4 +-
 4 files changed, 95 insertions(+), 83 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index d521ea335df1..dda68d7e1d94 100644
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
index 30b67915c459..4fcbb21a583d 100644
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
index 875b40f2e362..4d72c854c7b3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1063,10 +1063,10 @@ static bool cluster_scan_range(struct swap_info_struct *si,
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
 
@@ -1075,33 +1075,24 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 
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
@@ -1109,17 +1100,15 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 
 	return true;
 }
-
-/* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    struct folio *folio, unsigned long offset)
+					    struct folio *folio, unsigned long offset,
+					    unsigned int order)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
-	unsigned int nr_pages = 1 << order;
+	unsigned long nr_pages = 1UL << order;
 	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
@@ -1145,7 +1134,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
-		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
+		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER, order))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -1176,7 +1165,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 struct list_head *list,
 					 struct folio *folio,
-					 bool scan_all)
+					 unsigned int order, bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
 
@@ -1187,7 +1176,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, order);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1279,17 +1268,16 @@ static void swap_reclaim_work(struct work_struct *work)
  * cluster for current CPU too.
  */
 static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
-					      struct folio *folio)
+					      struct folio *folio, unsigned int order)
 {
 	struct swap_cluster_info *ci;
-	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
-	 * to allocate large entries.
+	 * to allocate large entries. xswap has no backing file, so it can.
 	 */
-	if (order && !(si->flags & SWP_BLKDEV))
+	if (order && !(si->flags & SWP_BLKDEV) && !(si->flags & SWP_XSWAP))
 		return 0;
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
@@ -1304,7 +1292,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset, order);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1318,7 +1306,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	 * cluster is the only thing a large order can allocate from.
 	 */
 	if (!folio && order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, order, false);
 		if (found)
 			goto done;
 	}
@@ -1328,19 +1316,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1356,7 +1344,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, order, false);
 		if (found)
 			goto done;
 	}
@@ -1370,11 +1358,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1417,7 +1405,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			}
 
 			found = alloc_swap_scan_list(si, &si->free_clusters,
-						    folio, false);
+						    folio, order, false);
 		}
 	}
 #endif
@@ -1630,7 +1618,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
+		alloc_swap_scan_cluster(si, ci, folio, offset, order);
 	} else {
 		swap_cluster_unlock(ci);
 	}
@@ -1652,7 +1640,7 @@ static void swap_alloc_slow(struct folio *folio)
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			cluster_alloc_swap_entry(si, folio);
+			cluster_alloc_swap_entry(si, folio, folio_order(folio));
 			put_swap_device(si);
 			if (folio_test_swapcache(folio))
 				return;
@@ -2443,13 +2431,13 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
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
@@ -4241,32 +4229,33 @@ static void xswap_free_xs_table(struct swap_info_struct *si, unsigned long idx)
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
@@ -4291,7 +4280,7 @@ static swp_entry_t xswap_alloc_phys_slot(void)
 
 		if (!get_swap_device_info(devs[i]))
 			continue;
-		offset = xswap_alloc_slot_local(devs[i]);
+		offset = xswap_alloc_slot_local(devs[i], order);
 		put_swap_device(devs[i]);
 		if (offset && offset != SWAP_ENTRY_INVALID)
 			return swp_entry(devs[i]->type, offset);
@@ -4317,29 +4306,46 @@ static void xswap_install_rmap(swp_entry_t phys, swp_entry_t entry)
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
+	unsigned int i;
 	bool recorded = false;
 
-	phys = xswap_alloc_phys_slot();
+	phys = xswap_alloc_phys_slot(order);
 	if (!phys.val)
 		return phys;
 
-	xswap_install_rmap(phys, entry);
+	/* One IO reads a large folio, so its range has to be contiguous. */
+	VM_WARN_ON_ONCE(swp_offset(phys) % nr);
+	VM_WARN_ON_ONCE(off % SWAPFILE_CLUSTER + nr > SWAPFILE_CLUSTER);
+
+	for (i = 0; i < nr; i++)
+		xswap_install_rmap(swp_entry(swp_type(phys), swp_offset(phys) + i),
+				   swp_entry(si->type, off + i));
 
 	ci = swap_cluster_lock(si, off);
 	if (ci) {
-		recorded = xswap_slot_set_backend(ci, off % SWAPFILE_CLUSTER, phys);
+		recorded = true;
+		for (i = 0; i < nr; i++) {
+			if (!xswap_slot_set_backend(ci, (off + i) % SWAPFILE_CLUSTER,
+						    swp_entry(swp_type(phys),
+							      swp_offset(phys) + i))) {
+				recorded = false;
+				break;
+			}
+		}
 		swap_cluster_unlock(ci);
 	}
 
 	if (!recorded) {
 		/* The backend is unrecorded, so the data would be unreachable. */
-		xswap_backend_free(entry, phys);
+		xswap_backend_free(entry, phys, order);
 		return (swp_entry_t){};
 	}
 
@@ -4347,27 +4353,33 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry)
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
index 24904b4c4dce..c79c527e6345 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1054,7 +1054,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	/* Reserve the destination before dropping the zswap copy. */
 	if (is_xswap) {
-		phys = xswap_backend_alloc(swpentry);
+		phys = xswap_backend_alloc(swpentry, 0);
 		if (!phys.val) {
 			ret = -ENOMEM;
 			goto out;
@@ -1087,7 +1087,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 out:
 	if (ret) {
 		if (is_xswap && phys.val)
-			xswap_backend_free(swpentry, phys);
+			xswap_backend_free(swpentry, phys, 0);
 		swap_cache_del_folio(folio);
 		folio_unlock(folio);
 	}
-- 
2.54.0


