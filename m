Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBE0C44503
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677C36B00BD; Tue,  7 Jul 2026 03:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628566B00BF; Tue,  7 Jul 2026 03:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516576B00C0; Tue,  7 Jul 2026 03:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 143F06B00BD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:33:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 940F38D4D4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:56 +0000 (UTC)
X-FDA: 84961166472.01.00F74EF
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id C460EA0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dJxYlq3b;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409635;
	b=gk/0bn5devR50P2n/o8HBdzAr+EnuDNGLyzNZxv3Rf0A8kVg0H2XMT/3uIL/n8jSV8hCV8
	H4jCHlNcxzZ3TolxUddtmdnaRy+hp8yXKqZ1wG9zkws2ouy2fwsb30plNnqWtxbzZEp6E+
	5B6HWM8iV+oZBdsdyIOERaUwELxi/uQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dJxYlq3b;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pzLUlfsewHH3Bdoiku7PnoSHu6lZY2jU5cTHlSp4bs=;
	b=HpcBg7X8xN2rpZzTeJtT2rNCIRUpPIxYAOJrlyqgalLD3zKPxGB1is+1yaNXlyCpXdo03z
	eJI9nS44eJJmeYWr0nN9ETyugHAzuDMm2SUFCM8XIgCwUrCKB+E6JPPNDz2h22BsQfNS4T
	37io8AxAMk2FeBVLVLwV4CIQBcBgg2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1pzLUlfsewHH3Bdoiku7PnoSHu6lZY2jU5cTHlSp4bs=;
	b=dJxYlq3bXnaHPwb7OKEuZc58mom3xATZlqsGPmVnpxaHd9wx+dhsbTXpkbsDy4d5IVQoNC
	qPXbafdqP/uBHVE7K0Zy1k0Ka/cKFc47Y2RTbwbqZkUrNEO/w2CUDpDGx5OD63wA/uW/vE
	gzR0O1xJM1izLGJ/4kypjUihdi0/hzM=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 6/7] mm/zswap, mm/swap_state: migrate zswap to use swap_table for entry indexing
Date: Tue,  7 Jul 2026 15:32:03 +0800
Message-ID: <20260707073215.72183-7-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C460EA0002
X-Rspam-User: 
X-Stat-Signature: nssuhmjfjsjkk8w86ck9jkxrijdi8bkx
X-Rspamd-Server: rspam03
X-HE-Tag: 1783409634-978268
X-HE-Meta: U2FsdGVkX1/oVppGVxVUaKOImsJAfECEklw390xZRCs7K6DDpn2fzjf9WDFdjJdnPERn55NbqzzuGeSpL7yeSv6DUCo+Aeru+I/5y/Xtz1bn81IRqNN09FuGRdrTy7Tf5fjxENaplDYvQq5G9B0ZXDHD1iTeeNKrr3gnyrVD0ZGsBpRRZsWxZ5NweLavXoZ0zccFwqW543aMKlyKIU9/eD8OYsRRnnETPqZ0pHSGjckBYdz2OWga5FmY/3WxSpYfgzzxVzZKavoI4WHo/75xV5j1uH9wc2ANZML/oC31/hudTNqeAv9IbBE/c75wBaE/qksjTlr5WSZC3pMACd/EMkj4pHAgLzbLO+7/Elv+CErhUcNZ++XDpjvbtzywStJi7kEFqAWirenPuFL2FfL3nmuhBbJGKuBHYM6E5LRg5B7ibPWEND9GWE6qaFkqLSGlbaLOcIeiI7FZJutGu6RdvrmwI0lvMS/pTMgg9tMbkYqbBhjfibYEXC513PGjtovT0iu9/zD/tmSQIQrfkwNe5uFovmhgbbM2HsVH4bsAqmeh5qBs7Fg4sUAQH7BcQan2cchUTwbRu+RV51isWtmCRiCFNPEC3PdV+CxftTk04aVN3RDo7nNMj7Z6OzD90BlJ8d6QmX4/B1ry97nLaphOBbcT3qgYEu8s/bqzzf7I+D4hoF/t9+VNjY2DCQ2776yGB77V1JTPsI/ckMf2H9s8oS7MQoCwdSvaDE7xUHsRSwsee6Dj3D8d1H1WvZaxSncPABSBbO165vmPGHeMkpeJzl7LM8EyOIQo+yu3tmx3hXTCCu/2KgHsBZbvotid/qTbor0PGuKamZTtpWIttp/QiX0GJxzI3hH/3/zgRDFz05/6pqb0o1VHk4JxIRTogS1JFNdFA0cRZXFE366S+tzTndwUrfCsjTOTc5WjkZZKEbMkR4I0jAS6fR1rPTnMG9tKiTT0MGZWfD89ZFm3dz4
 bJYzmTKo
 ldch2GdZbCvYJ4Jadw4jMjulA9LtDunXG+2NoCy5kftH9O5ApUyQ5rvPI93xG0kiUATs4OwMp70VvOLwQ6+vruggNaeNqYbnBHvJut4DTVveAwzFyKgDmz/M0YEMRwLW8yqujROYW+4cnqUGh/W8dOXKYpgKT1O8BaO/i9tqB3FbZThMh0COk66BE/InPEZVUQ1MBRfAb6yOXCXJ8UvVVFg6GXbZB7aOuj3pgLzz2SwECn5od74oCT5D13g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transition zswap to use swap table entries as the primary index for
locating compressed data. Key changes:

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_state.c | 62 ++++++++++++++---------------------
 mm/zswap.c      | 87 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 97 insertions(+), 52 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 620dc763eb3b..b3d5bedfaf07 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -214,8 +214,7 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 }
 
 static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
-				      struct folio *folio, swp_entry_t entry,
-				      void **zentry)
+				      struct folio *folio, swp_entry_t entry)
 {
 	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -232,24 +231,15 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
 		VM_WARN_ON_ONCE(swp_tb_is_folio(old_tb));
 		/*
 		 * If the old entry is a Pointer (zswap compressed data),
-		 * extract the zswap_entry for the caller and preserve
-		 * its flags. The Pointer entry has no inline flags.
+		 * extract the flags from the zswap_entry. The Pointer
+		 * entry has no inline flags.
 		 */
-		if (swp_tb_is_pointer(old_tb)) {
-			unsigned char cur_count, cur_flags;
-			unsigned long new_tb;
-
-			cur_count = zswap_swp_tb_get_count(old_tb);
-			cur_flags = zswap_swp_tb_get_flags(old_tb);
-			if (zentry && !*zentry)
-				*zentry = swp_tb_to_pointer(old_tb);
-			new_tb = pfn_to_swp_tb(pfn, cur_flags);
-			new_tb = __swp_tb_mk_count(new_tb, cur_count);
-			__swap_table_set(ci, ci_off, new_tb);
-		} else {
+		if (swp_tb_is_pointer(old_tb))
+			__swap_table_set(ci, ci_off,
+				pfn_to_swp_tb(pfn, zswap_swp_tb_get_flags(old_tb)));
+		else
 			__swap_table_set(ci, ci_off,
 				pfn_to_swp_tb(pfn, __swp_tb_get_flags(old_tb)));
-		}
 	} while (++ci_off < ci_end);
 
 	folio_ref_add(folio, nr_pages);
@@ -272,12 +262,11 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
  * that holds the entries.
  */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry,
-			    void **zentry)
+			    struct folio *folio, swp_entry_t entry)
 {
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	__swap_cache_do_add_folio(ci, folio, entry, zentry);
+	__swap_cache_do_add_folio(ci, folio, entry);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
@@ -324,6 +313,14 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 			/* If shadow is NULL, we set an empty shadow. */
 			__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
 					 __swp_tb_get_flags(old_tb)));
+			/*
+			 * If zswap has a compressed copy of this slot,
+			 * convert the just-written Shadow to a Pointer
+			 * entry referencing the zswap_entry.
+			 */
+			zswap_try_convert_to_pointer(ci, ci_off, si->type,
+						     swp_offset(entry) +
+						     ci_off - ci_start);
 		}
 	} while (++ci_off < ci_end);
 
@@ -457,8 +454,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 					swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
-					struct mempolicy *mpol, pgoff_t ilx,
-					void **zentry)
+					struct mempolicy *mpol, pgoff_t ilx)
 {
 	int err;
 	swp_entry_t entry;
@@ -505,7 +501,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
-	__swap_cache_do_add_folio(ci, folio, entry, zentry);
+	__swap_cache_do_add_folio(ci, folio, entry);
 	spin_unlock(&ci->lock);
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
@@ -562,8 +558,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx,
-				     void **zentry)
+				     struct mempolicy *mpol, pgoff_t ilx)
 {
 	int order, err;
 	struct folio *ret;
@@ -576,12 +571,9 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 	if (WARN_ON_ONCE(!orders || (1UL << order) > SWAPFILE_CLUSTER))
 		return ERR_PTR(-EINVAL);
 
-	if (zentry)
-		*zentry = NULL;
-
 	do {
 		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
-					 vmf, mpol, ilx, zentry);
+					 vmf, mpol, ilx);
 		if (!IS_ERR(ret))
 			break;
 		err = PTR_ERR(ret);
@@ -697,20 +689,18 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct swap_iocb **plug, bool readahead)
 {
 	struct folio *folio;
-	void *zentry;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx,
-					       &zentry);
+		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
-	swap_read_folio(folio, plug, zentry);
+	swap_read_folio(folio, plug);
 	if (readahead) {
 		folio_set_readahead(folio);
 		count_vm_event(SWAP_RA);
@@ -739,20 +729,18 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
-	void *zentry;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx,
-					       &zentry);
+		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
-	swap_read_folio(folio, NULL, zentry);
+	swap_read_folio(folio, NULL);
 	return folio;
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 58259673ce2b..f5f4756c9ce6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1404,7 +1404,11 @@ static bool zswap_store_page(struct page *page,
 			     struct zswap_pool *pool)
 {
 	swp_entry_t page_swpentry = page_swap_entry(page);
-	struct zswap_entry *entry, *old;
+	struct zswap_entry *entry, *old = NULL;
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *si;
+	pgoff_t offset = swp_offset(page_swpentry);
+	unsigned long swp_tb;
 
 	/* allocate entry */
 	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
@@ -1427,20 +1431,42 @@ static bool zswap_store_page(struct page *page,
 		goto store_failed;
 	}
 
+	si = __swap_entry_to_info(page_swpentry);
+	ci = __swap_offset_to_cluster(si, offset);
+	spin_lock(&ci->lock);
+	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	if (swp_tb_is_countable(swp_tb)) {
+		/*
+		 * Save the complete original swap table entry value
+		 * (Shadow or PFN), preserving swap count, zero flag,
+		 * and working set shadow information.
+		 */
+		entry->swp_tb_val = swp_tb;
+	} else if (swp_tb_is_pointer(swp_tb)) {
+		/*
+		 * Replacing an existing Pointer entry (e.g. from a
+		 * redirtied folio). Inherit the saved swap table value.
+		 */
+		old = swp_tb_to_pointer(swp_tb);
+		entry->swp_tb_val = old->swp_tb_val;
+	}
+	__swap_table_set(ci, offset % SWAPFILE_CLUSTER,
+			 pointer_to_swp_tb(entry));
+	spin_unlock(&ci->lock);
 	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
+	 * If we had an existing zswap entry from the swap table
+	 * (e.g. from a previous redirtied folio), get rid of it
+	 * outside the lock.
 	 */
 	if (old)
 		zswap_entry_free(old);
 
 	/*
-	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg,
-	 * charge zswap memory, and increment zswap_stored_pages.
-	 * The opposite actions will be performed by zswap_entry_free()
-	 * when the entry is removed from the tree.
+	 * The entry is successfully compressed and stored in the swap table,
+	 * there is no further possibility of failure. Grab refs to the pool
+	 * and objcg, charge zswap memory, and increment zswap_stored_pages.
+	 * The opposite actions will be performed by zswap_entry_put()
+	 * when the entry is removed from the swap table.
 	 */
 	zswap_pool_get(pool);
 	if (objcg) {
@@ -1452,8 +1478,8 @@ static bool zswap_store_page(struct page *page,
 		atomic_long_inc(&zswap_stored_incompressible_pages);
 
 	/*
-	 * We finish initializing the entry while it's already in xarray.
-	 * This is safe because:
+	 * We finish initializing the entry while it's already in the
+	 * swap table. This is safe because:
 	 *
 	 * 1. Concurrent stores and invalidations are excluded by folio lock.
 	 *
@@ -1553,12 +1579,25 @@ bool zswap_store(struct folio *folio)
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
 		struct xarray *tree;
+		struct swap_cluster_info *ci;
+		struct swap_info_struct *sis;
+		unsigned long swp_tb;
 
+		sis = __swap_type_to_info(type);
 		for (index = 0; index < nr_pages; ++index) {
 			tree = swap_zswap_tree(swp_entry(type, offset + index));
 			entry = xa_erase(tree, offset + index);
-			if (entry)
-				zswap_entry_free(entry);
+			if (!entry)
+				continue;
+			ci = __swap_offset_to_cluster(sis, offset + index);
+			spin_lock(&ci->lock);
+			swp_tb = __swap_table_get(ci, (offset + index) % SWAPFILE_CLUSTER);
+			if (swp_tb_is_pointer(swp_tb) &&
+			    swp_tb_to_pointer(swp_tb) == entry)
+				__swap_table_set(ci, (offset + index) % SWAPFILE_CLUSTER,
+						 entry->swp_tb_val);
+			spin_unlock(&ci->lock);
+			zswap_entry_free(entry);
 		}
 	}
 
@@ -1642,14 +1681,32 @@ void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
 	struct xarray *tree = swap_zswap_tree(swp);
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *si;
+	unsigned long swp_tb;
 	struct zswap_entry *entry;
 
 	if (xa_empty(tree))
 		return;
 
 	entry = xa_erase(tree, offset);
-	if (entry)
-		zswap_entry_free(entry);
+	if (!entry)
+		return;
+
+	/*
+	 * Also clear the swap table Pointer entry if present.
+	 * This is needed because zswap_store now writes Pointer
+	 * entries to both the xarray and the swap table.
+	 */
+	si = __swap_type_to_info(swp_type(swp));
+	ci = __swap_offset_to_cluster(si, offset);
+	spin_lock(&ci->lock);
+	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	if (swp_tb_is_pointer(swp_tb) && swp_tb_to_pointer(swp_tb) == entry)
+		__swap_table_set(ci, offset % SWAPFILE_CLUSTER, entry->swp_tb_val);
+	spin_unlock(&ci->lock);
+
+	zswap_entry_free(entry);
 }
 
 /*
-- 
2.54.0


