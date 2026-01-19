Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3038CA5FEE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AC16B0115; Mon, 19 Jan 2026 01:35:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC446B0117; Mon, 19 Jan 2026 01:35:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB5B6B0118; Mon, 19 Jan 2026 01:35:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBD766B0115
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:35:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F626C2385
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:35:13 +0000 (UTC)
X-FDA: 84347751306.14.896873B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E3DFC0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:35:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aJ4LI/pq";
	spf=pass (imf28.hostedemail.com: domain of zhiguo.zhou@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768804511; a=rsa-sha256;
	cv=none;
	b=Df4OsaE2WQLxKgbxv9QnH0qlIsSKghK0BQKf/1DTY8tBNEpl4vUtAd6JMWycVfRpILBVl+
	nolz1CdlIG+Nd6sP16jgUHya7yVSgr0yo5QoRJieQbCuUw9yRTjcLMf6abwgVdG4DisI+R
	AnqpaqGsUMMXYoiJCxBVLJIJ2vv8Wmk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aJ4LI/pq";
	spf=pass (imf28.hostedemail.com: domain of zhiguo.zhou@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768804511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McbwPExOpQHtg4i1H2rDl+FXyR1tzR46+hRrdPHBXo8=;
	b=b/Rby9aKCMrco5QA8NpvunpoTHR12Q5lfxo7hHgCTMMy1scieU78DKqKTKPiEWIt4trkOU
	mqZSN4KLSuI3y9vAuyhiYhyWQf8v6+MGFqKYLi1FV0H4VsX36uw4YOCjxDFng9VoORWdMU
	sBt68eim/5eaMk1TqR5h7lVIO1qn/ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768804511; x=1800340511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a5abOE0XeFOEyTETIaxGrTOrOdiAfrb8kXNH975hzK0=;
  b=aJ4LI/pqLeDkyHjmuNLmfO/0FUR4gZFUw8pNdkx+ZtxgGbFz0NbrUq6H
   4o29EQfO39fvs1BTnQf+lLvGX6ChcdJFnRlFJkbaDfgclClEK7Mo+0s+G
   tNt7hgY8xigV86j6uFTWwoDnCMWNyPHpGE3YgPD853TbUX3HakyugT//g
   +OhQ/p8uOQsqtFQ5nZuuW0E23tn/0H9asDC071HKrG9pklsVComAKmvMn
   q+OE6cgtfH50HpCfcbjbj93dKsyn7GygYyd7ucy0qOCkGCkla70DqOEBn
   kjEosNvDkf4QcV6YOCa19/F2+cAAHCpSCS3oXSK88vFtXbhsZEVRDLdnh
   w==;
X-CSE-ConnectionGUID: yXxodewtQIeW3d3MmeRB/A==
X-CSE-MsgGUID: HxIMtaqCR+uVgcF3lbN0+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="57565305"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="57565305"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 22:35:10 -0800
X-CSE-ConnectionGUID: qU3Bo5F6QBOFIpmXHdfW8A==
X-CSE-MsgGUID: GaYqelzQQTuu6lB6A6GdfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="205824307"
Received: from linux-pnp-server-15.sh.intel.com ([10.239.177.153])
  by orviesa007.jf.intel.com with ESMTP; 18 Jan 2026 22:35:05 -0800
From: Zhiguo Zhou <zhiguo.zhou@intel.com>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: willy@infradead.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linux-kernel@vger.kernel.org,
	tianyou.li@intel.com,
	tim.c.chen@linux.intel.com,
	gang.deng@intel.com,
	Zhiguo Zhou <zhiguo.zhou@intel.com>
Subject: [PATCH 1/2] mm/filemap: refactor __filemap_add_folio to separate critical section
Date: Mon, 19 Jan 2026 14:50:24 +0800
Message-ID: <20260119065027.918085-2-zhiguo.zhou@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260119065027.918085-1-zhiguo.zhou@intel.com>
References: <20260119065027.918085-1-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5c6zzdgggmoj5jcm319533gt174wr94c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E3DFC0003
X-Rspam-User: 
X-HE-Tag: 1768804511-674683
X-HE-Meta: U2FsdGVkX19PnuWJ+MmSgT+R4sowi8fsDiW2bwF6GQ4BAcbr930MlwO3sfcjw6cjTCN362BczvEjhbXyc1AiaLxZD/iOoTyfwdn08C2wEYkWINQC1l1aDRx1vthJgNhyn15XvCklTnPOuX57K2lzfxq1Qht3YMPXjKOSksPOKAw09hx769LH7KdNLlzizlb06CwvdcFyKiVhHY39PqJtThmaO1rCAgJDLwoSS7hpnQtOwBMQukQ+9nM3C3wXQ9bsp8YcID0WwfH84SyY+ofCwbZYrRKzJJfCntVwxTbiAEePDB4PBrVzXu5wHtXlEX7McZsRuGZtbSkiUwXRIET6fTGDh7AenEMKbnkwDQwNEVZj4ncE3H0VHCE7sgJlTT5k/keV2+QVEIXN99bI5LFGp9nDUCBycs/XU5O62in7V+c/uAO26SdILnU/t9EqA+wpZJ53R3ZxCwJEZlNHaDGhwichkKeJ+Z6pNu9llagni1Fkuz9YhhLgz/3xQLdR5D69CS1TdJYKr8n9CT2far6JXur7jytP1qVQupw1dTTTNNkd/PzqH+MIdC6xLbYmMjGa+XZzLt8C8cueUhaKT9PZjrRktfDrSQnksY0CisMDYLuWO4tcM2VMFKql+kyhCKZCHKZOEDm98/c2BeWsmJksZkd36iuQq1ucF6dlMDR4d7RCr7xOKMdFaJjhnahVXg4/gEaD6uHKImeMzERmflTo5S1SEyVb/ghPCqUUhlz1c/ABjUBCi1kuHqal2wkaWWzL5a7GZd6loPpCHq9CYybG6eTAk9yZQVZBk4/R9KIR3UnH9XxQ6X0PvHLm7Hn1t5tabpau0U3RgYC1SzWEWWtkeNArJLF1U8WWkvgC2cZNKrMiTRMt+YoC/1kn5Xn+JdoNCklzu+2ZV6zVt5ioS9H4qRusg52FBd7iUCr5DDtyNk0KFzQZ+ypkmoIvY6xHOaJy9rXhpA/zlrz+35+38L4
 4V/FAYba
 axPr5PB/WpDSjzM314V3uK9niECItZXVPbUPDM3HjXJ+I2cegGsDHmOPst29Pmo7QWbue2OgvZTzyUtB3u50Uhkh+5JMMz2pxiGiK6crVajvA4irgpuqus19PBNV+CQsxCiOQnjohXiN7mokxOb/0GkgdUji37KA/Q8Ylbye+uSlRi0d9X16BItTEhaiFRZMtyJeOV+TvCtGlqmDp55/OpT5V2LR2Ohv+q+ms
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
index ebd75684cb0a..eb9e28e5cbd7 100644
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
+	lockdep_assert_held(xas->xa->xa_lock);
 
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
+		lockdep_assert_held(xas->xa->xa_lock);
+		__filemap_add_folio_xa_locked(xas, mapping, folio, shadowp);
+	} else {
+		lockdep_assert_not_held(xas->xa->xa_lock);
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


