Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B3EC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3796B00AE; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21636B00B1; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61C56B00AE; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDA66B00AF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56AEE814EE
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:04 +0000 (UTC)
X-FDA: 83726928768.08.663A8C0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EE9040002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CjSa06df;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dntq5hnKrcwKoEEqzgfW4mDCqgXDmrLYVyWhWvyT4sM=;
	b=mdsEvqQD2JTCE1SNAD4wU7F0kw5kCnviWdxyeChm/4nZhtKrG248aVwrCcGzbPTzWBycJc
	XUjtk/IMs+dycaR9Cq67stx9/mxpABvCveIvBd5lhwGt2ZvTiPfaaNm1B87FP7XXnztET+
	l8hCqaNsUhA6hCleMEZlRfc00n16hBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023022; a=rsa-sha256;
	cv=none;
	b=wCCS3dzfqyp3IYGvr1rpos7ZSOtLihFENjFQdooEJ9lxrckaRd+m7kwO8WKP+4CAp3dTgz
	JJbjKLXJqS+M9uj+trvVf7a8ZrySn8ufewpEfUNEU4iHv1RYRsE57rXTFPmC3l77UfWGjg
	u7I1VA1Teuv+9Z2FOqq8a5QR4tTxRYY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CjSa06df;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023022; x=1785559022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4O1PtJOxHU0uFj7Qwb/its0w8B+AFIicISATmM2iugY=;
  b=CjSa06dfDcaKm9AjWvQiaQERsenK2h5WTRpqg1cjNGTbtKZLpYgenUnL
   JvPvu9n1g8YGxrVv5vm1mvn8cWpwGiDbJSOm5t30ilW3OF8GSCVGzJe1Y
   cWYVGstAqSkhg/2gmrFPeNLj81C/a7zCqwFdAaUW9G5DQCzJPFXGVrqea
   2qRZ+UNoRJ0NwMmYbwx+xDRkqyXoZOoBXrZCtjpnXVfUAIq+oPvANHNTf
   HgXGPLEni8yb65xlzPw978GlAVFpTJk0mhDrSxY8+PWojlY+RhQ08PkbI
   T+EZG1yVTKrA2+GUgUMwLYX+MiHKPZeN3+O+YQG8wMZk0Nwv2Fxq/VAWS
   g==;
X-CSE-ConnectionGUID: sgcjKtkpSI+Qlu8sQ6Pd9g==
X-CSE-MsgGUID: JQ8yCPtVQlmDe0FMGLjhtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820447"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820447"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: gYq1lz4uSNWPP+XWvg6arw==
X-CSE-MsgGUID: CAvFKNwkTtOIVy7Zd+ADnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796317"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:47 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large folio in batches.
Date: Thu, 31 Jul 2025 21:36:41 -0700
Message-Id: <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EE9040002
X-Stat-Signature: 5ymsqg1y78md5a5df63aw9hk35dhh8wi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754023022-460811
X-HE-Meta: U2FsdGVkX1/LdIJd+1ShqtiEBBqpL6dy5prl54qXw4B2g8IHoAejn+TItUBRmWPFyx0SEEC/IAkR5+cxVnkEHcsu1miLKuE1WxoaUZbbhQ5FEs/2J+YWGGtBgGZz6qxaM4fSwxPZ4gm30u5Q3HP8ckpvKnVL5nvGsqGUlhhvaevVC/43JF8h9vx8D+Ri9o5r2vA58ef8C0yA5hP5LveUOv01Niq/2e2zd18Ac1qrYIbCtU15lfY9pIOQQ75/AZxcXDrYHUhVN2MTz4MiJ145R54/+rO6zG1Tm2dTYgi2fVVMBE+4KLf8ViDepZHRtmjot52YKS+KKL/N7TZS+tcwY+HXEEhgfzZLKvodT2AdyaeRO/Umom+uNVqxth1gVXSKphHbYt35kUHhsS6SZKWruBSVOxaX/h4GNlqP89YE0sMd1GS+na0o/aRjZCiLp858vZenkxTd+CobHHxcRrejjP4W/vEUDYsQZvLBTa2f6eLy2FTUUWdRMk0AFGKHQml/AuiZhi533Ho3lCFtMp59qRZvP3Ahea10PHI+syrOboo8nQK5nhQmD/82BVSpNeQ707yy3XwoQOBxeCLvJPXl+FXlxnOAdHnSdPM+d1wC+ByjnioIwjlAj9eJFUzqB2t2hAO7UOSZuolpYzpyOpZpAPKzKUu2kMU0MZpA6rAlHMkfBro6U/m4zEgEOTRTzST/uorvvcRwZWmC38/jZQw1PbGhqQU5pSq+R4tTlA1KR+ppPaEttIsDUTlLCg2hrhqhNueSd5llKrWSmI0jfbpQZeu7yPqKsjFOl2a32cTt2lu58E0fhuGR10jkJJpwfUTOx/k/FKz3RjkNyUagSDkAaNpUmzazAk85FIxOB79howMHoCPpvvLlkK3p13TTc76ia92UffDLvYXZv/DKX22w+Wft78WRrumB3wkrzwESbMu/CTwfnsB5DHuth81HjgFHTrveZCswR1eoD7HdUks
 fEUh4ZxW
 xknzniUA2uu+XZonwn3YOZfpeBsqSIfG8SsbAls4b3/O0adoSbybwaq+7CnawRzoyKmO73rQjvEP+77futHnwGfk9oeGroInxjaOURWkf+BltVVRqaqLpowqPFLgNaau0ybjjgA9KQcC2bnMMD5KMYBNJrm96q/WgFad5SqYgUsRcXXv6LanWD4NfGPCVUGjfdcb6tqLXnEXyJa+WcNwy/rzXGopAnWcz2KHh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch modifies zswap_store() to store a batch of pages in large
folios at a time, instead of storing one page at a time. It does this by
calling a new procedure zswap_store_pages() with a range of
"pool->batch_size" indices in the folio.

zswap_store_pages() implements all the computes done earlier in
zswap_store_page() for a single-page, for multiple pages in a folio,
namely the "batch":

1) It starts by allocating all zswap entries required to store the
   batch. New procedures, zswap_entries_cache_alloc_batch() and
   zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
   to optimize the performance of this step.

2) Next, the entries fields are written, computes that need to be happen
   anyway, without modifying the zswap xarray/LRU publishing order. This
   improves latency by avoiding having the bring the entries into the
   cache for writing in different code blocks within this procedure.

3) Next, it calls zswap_compress() to sequentially compress each page in
   the batch.

4) Finally, it adds the batch's zswap entries to the xarray and LRU,
   charges zswap memory and increments zswap stats.

5) The error handling and cleanup required for all failure scenarios
   that can occur while storing a batch in zswap are consolidated to a
   single "store_pages_failed" label in zswap_store_pages(). Here again,
   we optimize performance by calling kmem_cache_free_bulk().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 218 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 149 insertions(+), 69 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 63a997b999537..8ca69c3f30df2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -879,6 +879,24 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+/*
+ * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number otherwise.
+ * The code for __kmem_cache_alloc_bulk() indicates that this positive number
+ * will be the @size requested, i.e., @nr_entries.
+ */
+static __always_inline int zswap_entries_cache_alloc_batch(void **entries,
+							   unsigned int nr_entries,
+							   gfp_t gfp)
+{
+	return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries, entries);
+}
+
+static __always_inline void zswap_entries_cache_free_batch(void **entries,
+							   unsigned int nr_entries)
+{
+	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
+}
+
 /*
  * Carries out the common pattern of freeing and entry's zpool allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -1512,93 +1530,154 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct folio *folio,
+			      long start,
+			      long end,
+			      struct obj_cgroup *objcg,
+			      struct zswap_pool *pool,
+			      int node_id)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
-	struct zswap_entry *entry, *old;
-
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+	u8 i, store_fail_idx = 0, nr_pages = end - start;
+
+	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
+						      nr_pages, GFP_KERNEL))) {
+		for (i = 0; i < nr_pages; ++i) {
+			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, node_id);
+
+			if (unlikely(!entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				/*
+				 * While handling this error, we only need to
+				 * call zswap_entries_cache_free_batch() for
+				 * entries[0 .. i-1].
+				 */
+				nr_pages = i;
+				goto store_pages_failed;
+			}
+		}
 	}
 
-	if (!zswap_compress(page, entry, pool))
-		goto compress_failed;
+	/*
+	 * Three sets of initializations are done to minimize bringing
+	 * @entries into the cache for writing at different parts of this
+	 * procedure, since doing so regresses performance:
+	 *
+	 * 1) Do all the writes to each entry in one code block. These
+	 *    writes need to be done anyway upon success which is more likely
+	 *    than not.
+	 *
+	 * 2) Initialize the handle to an error value. This facilitates
+	 *    having a consolidated failure handling
+	 *    'goto store_pages_failed' that can inspect the value of the
+	 *    handle to determine whether zpool memory needs to be
+	 *    de-allocated.
+	 *
+	 * 3) The page_swap_entry() is obtained once and stored in the entry.
+	 *    Subsequent store in xarray gets the entry->swpentry instead of
+	 *    calling page_swap_entry(), minimizing computes.
+	 */
+	for (i = 0; i < nr_pages; ++i) {
+		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		entries[i]->pool = pool;
+		entries[i]->swpentry = page_swap_entry(folio_page(folio, start + i));
+		entries[i]->objcg = objcg;
+		entries[i]->referenced = true;
+		INIT_LIST_HEAD(&entries[i]->lru);
+	}
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct page *page = folio_page(folio, start + i);
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+		if (!zswap_compress(page, entries[i], pool))
+			goto store_pages_failed;
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct zswap_entry *old, *entry = entries[i];
 
-	/*
-	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg,
-	 * charge zswap memory, and increment zswap_stored_pages.
-	 * The opposite actions will be performed by zswap_entry_free()
-	 * when the entry is removed from the tree.
-	 */
-	zswap_pool_get(pool);
-	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
-	}
-	atomic_long_inc(&zswap_stored_pages);
+		old = xa_store(swap_zswap_tree(entry->swpentry),
+			       swp_offset(entry->swpentry),
+			       entry, GFP_KERNEL);
+		if (unlikely(xa_is_err(old))) {
+			int err = xa_err(old);
 
-	/*
-	 * We finish initializing the entry while it's already in xarray.
-	 * This is safe because:
-	 *
-	 * 1. Concurrent stores and invalidations are excluded by folio lock.
-	 *
-	 * 2. Writeback is excluded by the entry not being on the LRU yet.
-	 *    The publishing order matters to prevent writeback from seeing
-	 *    an incoherent entry.
-	 */
-	entry->pool = pool;
-	entry->swpentry = page_swpentry;
-	entry->objcg = objcg;
-	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+			zswap_reject_alloc_fail++;
+			/*
+			 * Entries up to this point have been stored in the
+			 * xarray. zswap_store() will erase them from the xarray
+			 * and call zswap_entry_free(). Local cleanup in
+			 * 'store_pages_failed' only needs to happen for
+			 * entries from [@i to @nr_pages).
+			 */
+			store_fail_idx = i;
+			goto store_pages_failed;
+		}
+
+		/*
+		 * We may have had an existing entry that became stale when
+		 * the folio was redirtied and now the new version is being
+		 * swapped out. Get rid of the old.
+		 */
+		if (unlikely(old))
+			zswap_entry_free(old);
+
+		/*
+		 * The entry is successfully compressed and stored in the tree, there is
+		 * no further possibility of failure. Grab refs to the pool and objcg,
+		 * charge zswap memory, and increment zswap_stored_pages.
+		 * The opposite actions will be performed by zswap_entry_free()
+		 * when the entry is removed from the tree.
+		 */
+		zswap_pool_get(pool);
+		if (objcg) {
+			obj_cgroup_get(objcg);
+			obj_cgroup_charge_zswap(objcg, entry->length);
+		}
+		atomic_long_inc(&zswap_stored_pages);
+
+		/*
+		 * We finish by adding the entry to the LRU while it's already
+		 * in xarray. This is safe because:
+		 *
+		 * 1. Concurrent stores and invalidations are excluded by folio lock.
+		 *
+		 * 2. Writeback is excluded by the entry not being on the LRU yet.
+		 *    The publishing order matters to prevent writeback from seeing
+		 *    an incoherent entry.
+		 */
+		if (likely(entry->length))
+			zswap_lru_add(&zswap_list_lru, entry);
 	}
 
 	return true;
 
-store_failed:
-	zpool_free(pool->zpool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < nr_pages; ++i) {
+		if (!IS_ERR_VALUE(entries[i]->handle))
+			zpool_free(pool->zpool, entries[i]->handle);
+	}
+	zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
+				       nr_pages - store_fail_idx);
+
 	return false;
 }
 
 bool zswap_store(struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
+	int node_id = folio_nid(folio);
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
 	bool ret = false;
-	long index;
+	long start, end;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1632,10 +1711,11 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
+	/* Store the folio in batches of @pool->batch_size pages. */
+	for (start = 0; start < nr_pages; start += pool->batch_size) {
+		end = min(start + pool->batch_size, nr_pages);
 
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_pages(folio, start, end, objcg, pool, node_id))
 			goto put_pool;
 	}
 
@@ -1665,9 +1745,9 @@ bool zswap_store(struct folio *folio)
 		struct zswap_entry *entry;
 		struct xarray *tree;
 
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
+		for (start = 0; start < nr_pages; ++start) {
+			tree = swap_zswap_tree(swp_entry(type, offset + start));
+			entry = xa_erase(tree, offset + start);
 			if (entry)
 				zswap_entry_free(entry);
 		}
-- 
2.27.0


