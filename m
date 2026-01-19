Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B996CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024EF6B0153; Mon, 19 Jan 2026 04:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27A76B0155; Mon, 19 Jan 2026 04:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2AEA6B0156; Mon, 19 Jan 2026 04:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC316B0153
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:47:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FB011406C1
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:47:49 +0000 (UTC)
X-FDA: 84348236658.16.484300F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7ECEB1C0007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:47:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IABjzrfW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768816067; a=rsa-sha256;
	cv=none;
	b=sg3DeR9a8WQVtNvcf4F/yV3gpjos1ty/sZ7+Nr+TpYOuKgX7E5OKq98NCx79Iq8akXepAC
	llsEdks4qA7H0W5Mjmi4B3KicHdE5yL9zJ2fnr4VcODNzHi3ri+PLB8GR/l+RIDfaSoNUh
	/oLhc71qORfTpGCQz1BwWf+eDPHYxR0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IABjzrfW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768816067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UN1rg494mI45c6kQQcj9UleLakcWwMl6yCXelDwaAdU=;
	b=Deed2YlU+e/XP/jSpbawtFvstqdkEprUpoi14o8uiYfpRzwx+4c1Bx48g6HJTf9xyKbpuo
	236lzkp3Pt+ReUDZpAbnNmqJVyJP/XlgDYv5Xf8SGjDDCTfpqMw80CrYgwVPr36DknshbY
	N+orDNBNZcDr+cOGuqHqmOGYj6VDgOI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768816067; x=1800352067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a0Al5CERHesex5OnDU/mFgjB0imIpfWAbjXXoirBqMA=;
  b=IABjzrfW6kvYg6ku1IJB03G+1sHCoRZGa3ts8uocA1WGEazCO0j5Gf3H
   PMbgUSeuObu6ITuWwjBytDaNqwpnKNBeQRM0JvnVkon8CSZSaN/uy64iW
   EMZ+htHQorws2h+wjX3ubxIrbEPjallteT3Y+a/7ejW36/h35pBYonWMG
   YP61WUbaKSEawsbKp6vJJzq2JeIKQLS5NMWsREmXLEKAm7ePatEc3ibc9
   W+5020108PvTfZ8dbRZxgLpWZ9XCpu0v+7bCcPP6CHBo2jTZ3ZCo4c/GO
   W99c7LvIRpvDAK4F4T3W8wQQKlLhX7HUAfytKyoliPax5ZktPO/26Ejp8
   Q==;
X-CSE-ConnectionGUID: lWYNbFC8Sxa00ZjJa3PB2g==
X-CSE-MsgGUID: 32RmfQbVSW6Hg/4xl6uVuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="70072781"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="70072781"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 01:47:46 -0800
X-CSE-ConnectionGUID: 6aXQEcGhRmy+JbFXrx8nhw==
X-CSE-MsgGUID: nymuz5LfRnqIFB/O46hTdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="204971983"
Received: from linux-pnp-server-15.sh.intel.com ([10.239.177.153])
  by orviesa006.jf.intel.com with ESMTP; 19 Jan 2026 01:47:42 -0800
From: Zhiguo Zhou <zhiguo.zhou@intel.com>
To: zhiguo.zhou@intel.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gang.deng@intel.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	tianyou.li@intel.com,
	tim.c.chen@linux.intel.com,
	vbabka@suse.cz,
	willy@infradead.org
Subject: [PATCH v2 1/2] mm/filemap: refactor __filemap_add_folio to separate critical section
Date: Mon, 19 Jan 2026 18:02:58 +0800
Message-ID: <20260119100301.922922-2-zhiguo.zhou@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260119100301.922922-1-zhiguo.zhou@intel.com>
References: <20260119065027.918085-1-zhiguo.zhou@intel.com>
 <20260119100301.922922-1-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: it1hesg1h4dqbrsryufkx8jf4aqtyw3s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7ECEB1C0007
X-HE-Tag: 1768816067-303490
X-HE-Meta: U2FsdGVkX19QF0eY8kpKNI9mxi4JB7+oi3OtOL2CBFpgK0wZz4U5D44bPD1y+Pyq1igg24isTUXLSxMtMjcx6BCMZXgqVjltk26y1mbcdcrtHUAggzO3rN1wi7VkIzE+Od/O7TuS53nwVs2hFx/Iams8HDua/NUJWGShj7RUQ5Jby6TnqynbRFr8cQdaO0xwJLPh0URQm8c1EtjyRforT89NCjP16Vy/tDVbQwnFawMKp0rB721+Bk9F4xvcJYV6zTH4ISnP6FQYJifbFppqO2AMFypRlWCXOPhksSwGN3o5kcR1NT8uHyzy+oUOJeKX+O6Stdk3ORPAVcyXJtjFRecqbQApnEyE3c/qasFpfwfZGaU+EbEuwqgVtE/t7qqL7uw8cgjksu6a29SYAzx+oKZKiYXUy/EuvJq/iccYKYgV5T3qlXdVM3Wnvkg2hC/YCVg28m01R2vWC1Udf9S2oCNsFlI/XtR/PNd7G7A0dHEMA1y772tJWRZiVY13EVUus0zQLMVu5mbDgHHDaxnsd1ubAGnvdGdsgsugwcwE7kBsDMDLH05bJj0iQTM+F76QYAIIWT/zvknGXfpUF/WMVMF74M1KmsJzA/NPA+smstbEwnSBsnvWavPLhSd2bH7bG33vp3Utm4KzDXCjkl5xAnPWhP0Uq5K+B4hV/BuTleUz8NjD0lVVHDcW6kkqylGTG7MDQaAXUb3dLpL+pwB6c7Dref54BIkAapDDcwq9lauiTuR6pafAhG7ZacYxu9MMmpw3gEDbKBpFfuIvwB/wjLc46ldMSnS+s0EbU7QFp9xqEXsJ0OhSVPHa4fj4QE1PXIKFrvg9fl1eOjSPJMrSTZfaWgBmC5iI2O1QwsXcIV8ttpvmoa3VlB+JGr9KYJEqbuDCEJzI8O08SfZd6J7JnLTZR8fa0wXJw0PZhgBkLnEv7NSRpXcwDgi07LoyZZGLWc83Z99HsgzQq1qmxbK
 w9EiYg1y
 N/q6HH3MKvCKAvxva2Ybxcwmjd1lR+8N4lV27UiAL7voFvHNWyzQGu0vv2YRPDOp7gbXbUpuYXTH/Glq/PVdoc0VoFN2KR9DGDpUB/7bNrMM6UOJ6T1W/iG+7rrnONWz/fiRghOvWSs6Npnt+SLuOkUY4M5E9VB1fYjIaQa2iz3scP4Qcy8YxPQuDr3HGseFyPe6cFwTwJEnUJ6hP0wgMRJ/s6lAfhqwacFWt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch refactors __filemap_add_folio() to extract its core
critical section logic into a new helper function,
__filemap_add_folio_xa_locked(). The refactoring maintains the
existing functionality while enabling finer control over locking
granularity for callers.

Key changes:
- Move the xarray insertion logic from __filemap_add_folio() into
  __filemap_add_folio_xa_locked()
- Modify __filemap_add_folio() to accept a pre-initialized xa_state
  and a 'xa_locked' parameter
- Update the function signature in the header file accordingly
- Adjust existing callers (filemap_add_folio() and
  hugetlb_add_to_page_cache()) to use the new interface

The refactoring is functionally equivalent to the previous code:
- When 'xa_locked' is false, __filemap_add_folio() acquires the xarray
  lock internally (existing behavior)
- When 'xa_locked' is true, the caller is responsible for holding the
  xarray lock, and __filemap_add_folio() only executes the critical
  section

This separation prepares for the subsequent patch that introduces
batch folio insertion, where multiple folios can be added to the
page cache within a single lock hold.

No performance changes are expected from this patch alone, as it
only reorganizes code without altering the execution flow.

Reported-by: Gang Deng <gang.deng@intel.com>
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Zhiguo Zhou <zhiguo.zhou@intel.com>
---
 include/linux/pagemap.h |   2 +-
 mm/filemap.c            | 173 +++++++++++++++++++++++-----------------
 mm/hugetlb.c            |   3 +-
 3 files changed, 103 insertions(+), 75 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..59cbf57fb55b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1297,7 +1297,7 @@ loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
 
 /* Must be non-static for BPF error injection */
 int __filemap_add_folio(struct address_space *mapping, struct folio *folio,
-		pgoff_t index, gfp_t gfp, void **shadowp);
+		struct xa_state *xas, gfp_t gfp, void **shadowp, bool xa_locked);
 
 bool filemap_range_has_writeback(struct address_space *mapping,
 				 loff_t start_byte, loff_t end_byte);
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..c4c6cd428b8d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -845,95 +845,114 @@ void replace_page_cache_folio(struct folio *old, struct folio *new)
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_folio);
 
-noinline int __filemap_add_folio(struct address_space *mapping,
-		struct folio *folio, pgoff_t index, gfp_t gfp, void **shadowp)
+/*
+ * The critical section for storing a folio in an XArray.
+ * Context: Expects xas->xa->xa_lock to be held.
+ */
+static void __filemap_add_folio_xa_locked(struct xa_state *xas,
+		struct address_space *mapping, struct folio *folio, void **shadowp)
 {
-	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	bool huge;
 	long nr;
 	unsigned int forder = folio_order(folio);
+	int order = -1;
+	void *entry, *old = NULL;
 
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(folio_test_swapbacked(folio), folio);
-	VM_BUG_ON_FOLIO(folio_order(folio) < mapping_min_folio_order(mapping),
-			folio);
-	mapping_set_update(&xas, mapping);
+	lockdep_assert_held(&xas->xa->xa_lock);
 
-	VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);
 	huge = folio_test_hugetlb(folio);
 	nr = folio_nr_pages(folio);
 
-	gfp &= GFP_RECLAIM_MASK;
-	folio_ref_add(folio, nr);
-	folio->mapping = mapping;
-	folio->index = xas.xa_index;
-
-	for (;;) {
-		int order = -1;
-		void *entry, *old = NULL;
-
-		xas_lock_irq(&xas);
-		xas_for_each_conflict(&xas, entry) {
-			old = entry;
-			if (!xa_is_value(entry)) {
-				xas_set_err(&xas, -EEXIST);
-				goto unlock;
-			}
-			/*
-			 * If a larger entry exists,
-			 * it will be the first and only entry iterated.
-			 */
-			if (order == -1)
-				order = xas_get_order(&xas);
+	xas_for_each_conflict(xas, entry) {
+		old = entry;
+		if (!xa_is_value(entry)) {
+			xas_set_err(xas, -EEXIST);
+			return;
 		}
+		/*
+		 * If a larger entry exists,
+		 * it will be the first and only entry iterated.
+		 */
+		if (order == -1)
+			order = xas_get_order(xas);
+	}
 
-		if (old) {
-			if (order > 0 && order > forder) {
-				unsigned int split_order = max(forder,
-						xas_try_split_min_order(order));
-
-				/* How to handle large swap entries? */
-				BUG_ON(shmem_mapping(mapping));
-
-				while (order > forder) {
-					xas_set_order(&xas, index, split_order);
-					xas_try_split(&xas, old, order);
-					if (xas_error(&xas))
-						goto unlock;
-					order = split_order;
-					split_order =
-						max(xas_try_split_min_order(
-							    split_order),
-						    forder);
-				}
-				xas_reset(&xas);
+	if (old) {
+		if (order > 0 && order > forder) {
+			unsigned int split_order = max(forder,
+					xas_try_split_min_order(order));
+
+			/* How to handle large swap entries? */
+			BUG_ON(shmem_mapping(mapping));
+
+			while (order > forder) {
+				xas_set_order(xas, xas->xa_index, split_order);
+				xas_try_split(xas, old, order);
+				if (xas_error(xas))
+					return;
+				order = split_order;
+				split_order =
+					max(xas_try_split_min_order(
+						    split_order),
+					    forder);
 			}
-			if (shadowp)
-				*shadowp = old;
+			xas_reset(xas);
 		}
+		if (shadowp)
+			*shadowp = old;
+	}
 
-		xas_store(&xas, folio);
-		if (xas_error(&xas))
-			goto unlock;
+	xas_store(xas, folio);
+	if (xas_error(xas))
+		return;
 
-		mapping->nrpages += nr;
+	mapping->nrpages += nr;
 
-		/* hugetlb pages do not participate in page cache accounting */
-		if (!huge) {
-			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
-			if (folio_test_pmd_mappable(folio))
-				lruvec_stat_mod_folio(folio,
-						NR_FILE_THPS, nr);
-		}
+	/* hugetlb pages do not participate in page cache accounting */
+	if (!huge) {
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		if (folio_test_pmd_mappable(folio))
+			lruvec_stat_mod_folio(folio,
+					NR_FILE_THPS, nr);
+	}
+}
 
-unlock:
-		xas_unlock_irq(&xas);
+noinline int __filemap_add_folio(struct address_space *mapping,
+				 struct folio *folio, struct xa_state *xas,
+				 gfp_t gfp, void **shadowp, bool xa_locked)
+{
+	long nr;
 
-		if (!xas_nomem(&xas, gfp))
-			break;
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_swapbacked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_order(folio) < mapping_min_folio_order(mapping),
+			folio);
+	mapping_set_update(xas, mapping);
+
+	VM_BUG_ON_FOLIO(xas->xa_index & (folio_nr_pages(folio) - 1), folio);
+	nr = folio_nr_pages(folio);
+
+	gfp &= GFP_RECLAIM_MASK;
+	folio_ref_add(folio, nr);
+	folio->mapping = mapping;
+	folio->index = xas->xa_index;
+
+	if (xa_locked) {
+		lockdep_assert_held(&xas->xa->xa_lock);
+		__filemap_add_folio_xa_locked(xas, mapping, folio, shadowp);
+	} else {
+		lockdep_assert_not_held(&xas->xa->xa_lock);
+		for (;;) {
+			xas_lock_irq(xas);
+			__filemap_add_folio_xa_locked(xas, mapping, folio, shadowp);
+			xas_unlock_irq(xas);
+
+			if (!xas_nomem(xas, gfp))
+				break;
+		}
 	}
 
-	if (xas_error(&xas))
+	if (xas_error(xas))
 		goto error;
 
 	trace_mm_filemap_add_to_page_cache(folio);
@@ -942,12 +961,12 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation relies upon it */
 	folio_put_refs(folio, nr);
-	return xas_error(&xas);
+	return xas_error(xas);
 }
 ALLOW_ERROR_INJECTION(__filemap_add_folio, ERRNO);
 
-int filemap_add_folio(struct address_space *mapping, struct folio *folio,
-				pgoff_t index, gfp_t gfp)
+static int _filemap_add_folio(struct address_space *mapping, struct folio *folio,
+				struct xa_state *xas, gfp_t gfp, bool xa_locked)
 {
 	void *shadow = NULL;
 	int ret;
@@ -963,7 +982,7 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		return ret;
 
 	__folio_set_locked(folio);
-	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
+	ret = __filemap_add_folio(mapping, folio, xas, gfp, &shadow, xa_locked);
 	if (unlikely(ret)) {
 		mem_cgroup_uncharge(folio);
 		__folio_clear_locked(folio);
@@ -987,6 +1006,14 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 	}
 	return ret;
 }
+
+int filemap_add_folio(struct address_space *mapping, struct folio *folio,
+				pgoff_t index, gfp_t gfp)
+{
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
+
+	return _filemap_add_folio(mapping, folio, &xas, gfp, false);
+}
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..5c6c6b9e463f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5657,10 +5657,11 @@ int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping
 	struct inode *inode = mapping->host;
 	struct hstate *h = hstate_inode(inode);
 	int err;
+	XA_STATE_ORDER(xas, &mapping->i_pages, idx, folio_order(folio));
 
 	idx <<= huge_page_order(h);
 	__folio_set_locked(folio);
-	err = __filemap_add_folio(mapping, folio, idx, GFP_KERNEL, NULL);
+	err = __filemap_add_folio(mapping, folio, &xas, GFP_KERNEL, NULL, false);
 
 	if (unlikely(err)) {
 		__folio_clear_locked(folio);
-- 
2.43.0


