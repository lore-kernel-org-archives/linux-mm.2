Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F316ECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6901C6B0092; Tue, 12 May 2026 07:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640A06B0093; Tue, 12 May 2026 07:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530A66B0095; Tue, 12 May 2026 07:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 444A86B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:04:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8C571C0335
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:04:19 +0000 (UTC)
X-FDA: 84758483838.20.DD7255B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id 887E4A000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:04:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SMi1J4y1;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778583857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aNLO07OH3qq3826GhTBt8FT5GfCYcnDsVzmqQQG698=;
	b=nRVEf5pBAd3wYGe5vQil2QryKUVniiguffke8n3BONM8qB5n8JDCHr3YD0DOF6SJY6Q4to
	+r0+pHAMWBbs2wShoUMLDF+rPDEbdt2Fo7X726kC8x5c7+7+F3r6zaawDIGzsMTh9p4HFg
	x554sdeLGjsi/xInk2NmgCZSK0HK9uA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SMi1J4y1;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778583857; a=rsa-sha256;
	cv=none;
	b=8SU2ELUxBLxdQ1w8661Lr7baP8tGkCoy8ogdXCZpIopkH51M5105eaeHnq3vvXPE8q9UVP
	CHFgmGHBLtXlYTrdhQLdq7EE5d+OAYHqiktPXAHKTiUnaQb3pHNHcukLtJaNmVLOtJR6Pc
	kItqoYOTxoMxnK6/l/38+vr8V8iCTng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778583857; x=1810119857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MSH2boMJr1nmtEanV/SvdOBNmmUx2sB8SsWmTowAyfM=;
  b=SMi1J4y1bRSHS6gRY0kBMUABfrIeX408nQZaHnNJ1t+5iU1NnEzWVon5
   QAsf4J+1MLkMavkN2JAy25KEk5yN5SqAh7gnSj20Qvl6o2L7099BEzfEE
   aoBtve+0pkw3XZ/V1DaOpZK8UJUCcTpWtnjaWGWDyhkn7e807C+s0g0Nf
   UwnhDeUEZFI4uESd/i+pCOouoTSWQquYj26T0EPYJNUMCghlyNE2S2OFU
   IiE2qkh2AJRD4hBp4w/03nP1ELlUJ1UTIeNc6SgAFu4u0wcZB4Jr2gVTV
   B/HPrnPDDZ5BPLpncwNbw+soGK9zSOOwDnvzQySgxbCpNQqMWIxZNxeKp
   w==;
X-CSE-ConnectionGUID: 74F7OJwUSHKGFes2UA+H3g==
X-CSE-MsgGUID: L9YpMu8sQ0ucrfBMN7tkVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="104944482"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="104944482"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:04:17 -0700
X-CSE-ConnectionGUID: Qs88e5KCQ2eVbu9ppWPW6g==
X-CSE-MsgGUID: cHhEi+iXQ46g602I48OnPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="231339495"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.172])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:04:11 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm/ttm: Use ttm_backup_insert_folio() for zero-copy swapout
Date: Tue, 12 May 2026 13:03:39 +0200
Message-ID: <20260512110339.6244-3-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 887E4A000A
X-Rspamd-Server: rspam06
X-Stat-Signature: p5bjicyqfbaykzz45gq4ez7diqxo8i5d
X-HE-Tag: 1778583857-177572
X-HE-Meta: U2FsdGVkX18voVdtkw0Ct1nC6Cp2HNSYn8ZD7luLtg1V2BB1RCNKXatY08/aPxBbhSCkc4HZOX62J9Clh+ox7LA0MhC0BcaD3w8eGTuP+LE4WWoV7dBc9gCGvGfKjqp0X5LXFaKV+MCQxQY6vvzo8RExrFZuE9Gs2rAjNTkUm7ZTWTZweqYg2oDxIDOc7c7AGquDhvvQrLFAAPMIV+zPiSm9UVIKuTKaHa0mjcJ07d1eEqpTMvwL3X3xaNoIH0/+w8F1QvG/eRkrnbgEvGvtuJtyfs+MOeJQPAfoUtBA2R20SMLlkecVfJUAkDd0chT47jPwaQgPNmsyzzxBnOwjmaXbjFGSDpjU3ghHlQst82Jf/mVun2YgOqPTsF0SHZxISYC5f6LfEoQFWFrWAZ/dUixmYL12JzwPOLrp/mS4c9K9PfPkAE8WmmMDj+TcnwgZFX8MB57vKFCw+iff415nxyCWEV3EdnTx2sOa1XZRurPOREfkiLKy5YBf1UuG2B1xKfPpEI5CPZcj6WYdxhd4iNNeSAQRyU1bN/O6HI/s3lLIx0g8tm/YpLLcpWflMiym6pORKZv0Kp9rs1Pc/YLR1Dz112aG2l6ULqo3BlIk8zH+XYhuOK2T6sxhhu87F+OPbSOnVmgX4/RpvZmxHs6eM4g+h0/arfUKqNILA+ttJ51hod0unP/RlrjGM/kc7YrWZ+PhJuXzZMcxYfUPVlM0nZRKPwVMTGDV8syRguDhCpACL8rtRlyWqT09l0Szbp77z0pplC3Ds5KtyuHlGScT+eFNrPZirT3jK1S1bCxhLYm7eymOer3tzvJNnlMNz2/XJ+GCM8T9tvwaajpot0vd9tJwJroGgGWhYF2QrWYkW9Pc+awsFEYCCIPJw4y6jRxcJc64AyjrO4yn/eLmxUT8K3eTkTZtPTxEQfwc2PKVQk2v9gPHSNE67aZZ89KwJE11KX+B57qYds3YdSoTj3j
 DMoodTiR
 aQfQjn7dXFbnHmMdtmvj8ob2UmCt+FGv4cFjI2JKhGbn/fQ/embTxQgpBZ4LDg09xdJRPCff5m45nm/vEwHA2TkAG58wNB0pUQkX/jYCALuqbW5tT6S5voH+OZ8MQbZfx9m4Nza1FQ+dHl1bP+j/DdgffpwveUy0zVj+fJCThS2Twqtc8ETN2ptvQvMcFyZ/ABWx24tQO7ghBrLJzEOyVaoXvXILCgNoOb2KZq9gXOtEGyPdxB6pFTDzt8d1xeRzOpOUyhGh4NDZ8ME1Mu+kFz/6yFP9szoVvmTDrsfnJkoQqfrAVqBaOqI0jdTwiBUkh/cE9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ttm_backup_insert_folio(), a thin wrapper around shmem_insert_folio()
that returns a handle, for use by drivers with large isolated folios.

Replace the alloc+copy ttm_backup_backup_page() path in ttm_pool_backup()
with the zero-copy ttm_backup_insert_folio() path.

On success NR_GPU_ACTIVE is decremented and the caller's reference is
released; shmem takes ownership.  The alloc_gfp argument used for
allocating shmem backing pages is no longer needed.

If insertion fails for a higher-order page, it is split into order-0
pages with ttm_pool_split_for_swap() and the loop retries each page
individually.

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/ttm/ttm_backup.c | 92 ++++++++++++--------------------
 drivers/gpu/drm/ttm/ttm_pool.c   | 67 ++++++++++++++++-------
 include/drm/ttm/ttm_backup.h     | 11 ++--
 3 files changed, 87 insertions(+), 83 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 81df4cb5606b..a37e9404b895 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -6,7 +6,6 @@
 #include <drm/ttm/ttm_backup.h>
 
 #include <linux/export.h>
-#include <linux/page-flags.h>
 #include <linux/swap.h>
 
 /*
@@ -68,73 +67,50 @@ int ttm_backup_copy_page(struct file *backup, struct page *dst,
 }
 
 /**
- * ttm_backup_backup_page() - Backup a page
+ * ttm_backup_insert_folio() - Zero-copy insert of an isolated folio into backup.
  * @backup: The struct backup pointer to use.
- * @page: The page to back up.
- * @writeback: Whether to perform immediate writeback of the page.
- * This may have performance implications.
- * @idx: A unique integer for each page and each struct backup.
- * This allows the backup implementation to avoid managing
- * its address space separately.
- * @page_gfp: The gfp value used when the page was allocated.
- * This is used for accounting purposes.
- * @alloc_gfp: The gfp to be used when allocating memory.
+ * @folio: The folio to insert. Must be isolated (not on LRU), unlocked,
+ *         have exactly one reference (the caller's), and have no page-table
+ *         mappings.  The folio must not be swapbacked or in the swapcache,
+ *         and folio->private must have been cleared by the caller.
+ * @order: The allocation order of @folio.  If @order > 0 and @folio is not
+ *         already a large folio, it is promoted to a compound folio of this
+ *         order (see shmem_insert_folio()).  split_page() must NOT have been
+ *         called; tail-page refcounts must be 0.
+ * @writeback: Whether to attempt immediate writeback to swap after insertion.
+ *             Best-effort; failure is silently ignored.
+ * @idx: Page-cache index within @backup.  Must be aligned to (1 << @order).
+ * @folio_gfp: The gfp value used when the folio was allocated.
+ *             Used for memory-cgroup charging.
  *
- * Context: If called from reclaim context, the caller needs to
- * assert that the shrinker gfp has __GFP_FS set, to avoid
- * deadlocking on lock_page(). If @writeback is set to true and
- * called from reclaim context, the caller also needs to assert
- * that the shrinker gfp has __GFP_IO set, since without it,
- * we're not allowed to start backup IO.
+ * Context: May be called from reclaim context.  If @writeback is true, the
+ * caller must assert that the shrinker gfp has __GFP_IO set.
  *
- * Return: A handle on success. Negative error code on failure.
+ * The folio is transferred zero-copy into the shmem page cache.  On success
+ * the caller should release their reference with folio_put() and track the
+ * handle for later recovery via ttm_backup_copy_page() and release via
+ * ttm_backup_drop().  Handles for sub-pages of a compound folio follow
+ * sequentially: handle + j addresses sub-page j.
  *
- * Note: This function could be extended to back up a folio and
- * implementations would then split the folio internally if needed.
- * Drawback is that the caller would then have to keep track of
- * the folio size- and usage.
+ * Return: A positive handle on success. Negative error code on failure;
+ *         the folio is returned to its original non-compound state and the
+ *         caller retains ownership.
  */
 s64
-ttm_backup_backup_page(struct file *backup, struct page *page,
-		       bool writeback, pgoff_t idx, gfp_t page_gfp,
-		       gfp_t alloc_gfp)
+ttm_backup_insert_folio(struct file *backup, struct folio *folio,
+			unsigned int order, bool writeback, pgoff_t idx,
+			gfp_t folio_gfp)
 {
-	struct address_space *mapping = backup->f_mapping;
-	unsigned long handle = 0;
-	struct folio *to_folio;
 	int ret;
 
-	to_folio = shmem_read_folio_gfp(mapping, idx, alloc_gfp);
-	if (IS_ERR(to_folio))
-		return PTR_ERR(to_folio);
-
-	folio_mark_accessed(to_folio);
-	folio_lock(to_folio);
-	folio_mark_dirty(to_folio);
-	copy_highpage(folio_file_page(to_folio, idx), page);
-	handle = ttm_backup_shmem_idx_to_handle(idx);
-
-	if (writeback && !folio_mapped(to_folio) &&
-	    folio_clear_dirty_for_io(to_folio)) {
-		folio_set_reclaim(to_folio);
-		ret = shmem_writeout(to_folio, NULL, NULL);
-		if (!folio_test_writeback(to_folio))
-			folio_clear_reclaim(to_folio);
-		/*
-		 * If writeout succeeds, it unlocks the folio.	errors
-		 * are otherwise dropped, since writeout is only best
-		 * effort here.
-		 */
-		if (ret)
-			folio_unlock(to_folio);
-	} else {
-		folio_unlock(to_folio);
-	}
-
-	folio_put(to_folio);
-
-	return handle;
+	WARN_ON_ONCE(folio_get_private(folio));
+	ret = shmem_insert_folio(backup, folio, order, idx, writeback, folio_gfp);
+	if (ret)
+		return ret;
+
+	return ttm_backup_shmem_idx_to_handle(idx);
 }
+EXPORT_SYMBOL_GPL(ttm_backup_insert_folio);
 
 /**
  * ttm_backup_fini() - Free the struct backup resources after last use.
diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index d380a3c7fe40..8ea3a125c465 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -487,7 +487,7 @@ static void ttm_pool_split_for_swap(struct ttm_pool *pool, struct page *p)
 /**
  * DOC: Partial backup and restoration of a struct ttm_tt.
  *
- * Swapout using ttm_backup_backup_page() and swapin using
+ * Swapout using ttm_backup_insert_folio() and swapin using
  * ttm_backup_copy_page() may fail.
  * The former most likely due to lack of swap-space or memory, the latter due
  * to lack of memory or because of signal interruption during waits.
@@ -1045,12 +1045,11 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
 {
 	struct file *backup = tt->backup;
 	struct page *page;
-	unsigned long handle;
-	gfp_t alloc_gfp;
 	gfp_t gfp;
 	int ret = 0;
 	pgoff_t shrunken = 0;
-	pgoff_t i, num_pages;
+	pgoff_t i, num_pages, npages;
+	unsigned long j;
 
 	if (WARN_ON(ttm_tt_is_backed_up(tt)))
 		return -EINVAL;
@@ -1070,7 +1069,8 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
 			unsigned int order;
 
 			page = tt->pages[i];
-			if (unlikely(!page)) {
+			if (unlikely(!page ||
+				     ttm_backup_page_ptr_is_handle(page))) {
 				num_pages = 1;
 				continue;
 			}
@@ -1098,34 +1098,63 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
 	else
 		gfp = GFP_HIGHUSER;
 
-	alloc_gfp = GFP_KERNEL | __GFP_HIGH | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
-
 	num_pages = tt->num_pages;
 
 	/* Pretend doing fault injection by shrinking only half of the pages. */
 	if (IS_ENABLED(CONFIG_FAULT_INJECTION) && should_fail(&backup_fault_inject, 1))
 		num_pages = DIV_ROUND_UP(num_pages, 2);
 
-	for (i = 0; i < num_pages; ++i) {
-		s64 shandle;
+	for (i = 0; i < num_pages; i += npages) {
+		unsigned int order;
+		s64 handle;
 
+		npages = 1;
 		page = tt->pages[i];
 		if (unlikely(!page))
 			continue;
 
-		ttm_pool_split_for_swap(pool, page);
+		/* Already-handled entry from a previous attempt. */
+		if (unlikely(ttm_backup_page_ptr_is_handle(page)))
+			continue;
+
+		order = ttm_pool_page_order(pool, page);
+		npages = 1UL << order;
 
-		shandle = ttm_backup_backup_page(backup, page, flags->writeback, i,
-						 gfp, alloc_gfp);
-		if (shandle < 0) {
-			/* We allow partially shrunken tts */
-			ret = shandle;
+		/*
+		 * If fault injection truncated num_pages mid-compound, skip
+		 * the partial tail rather than inserting it.
+		 */
+		if (unlikely(i + npages > num_pages))
+			break;
+
+		/*
+		 * Transfer this page zero-copy into shmem.  page->private
+		 * stores the TTM order; clear it before inserting.
+		 */
+		page->private = 0;
+		handle = ttm_backup_insert_folio(backup, page_folio(page),
+						 order, flags->writeback,
+						 i, gfp);
+		if (unlikely(handle < 0)) {
+			if (order) {
+				page->private = order;
+				ttm_pool_split_for_swap(pool, page);
+				npages = 0;
+				continue;
+			}
+			ret = (int)handle;
 			break;
 		}
-		handle = shandle;
-		tt->pages[i] = ttm_backup_handle_to_page_ptr(handle);
-		__free_pages_gpu_account(page, 0, false);
-		shrunken++;
+
+		/*
+		 * NR_GPU_ACTIVE is node-only; use mod_node_page_state()
+		 * directly after the folio becomes memcg-charged.
+		 */
+		mod_node_page_state(page_pgdat(page), NR_GPU_ACTIVE, -(1 << order));
+		folio_put(page_folio(page));
+		for (j = 0; j < npages; j++)
+			tt->pages[i + j] = ttm_backup_handle_to_page_ptr(handle + j);
+		shrunken += npages;
 	}
 
 	return shrunken ? shrunken : ret;
diff --git a/include/drm/ttm/ttm_backup.h b/include/drm/ttm/ttm_backup.h
index 29b9c855af77..0c2feed0bffb 100644
--- a/include/drm/ttm/ttm_backup.h
+++ b/include/drm/ttm/ttm_backup.h
@@ -13,9 +13,8 @@
  * ttm_backup_handle_to_page_ptr() - Convert handle to struct page pointer
  * @handle: The handle to convert.
  *
- * Converts an opaque handle received from the
- * ttm_backup_backup_page() function to an (invalid)
- * struct page pointer suitable for a struct page array.
+ * Converts an opaque handle received from ttm_backup_insert_folio()
+ * function to an (invalid) struct page pointer suitable for a struct page array.
  *
  * Return: An (invalid) struct page pointer.
  */
@@ -59,9 +58,9 @@ int ttm_backup_copy_page(struct file *backup, struct page *dst,
 			 pgoff_t handle, bool intr, gfp_t additional_gfp);
 
 s64
-ttm_backup_backup_page(struct file *backup, struct page *page,
-		       bool writeback, pgoff_t idx, gfp_t page_gfp,
-		       gfp_t alloc_gfp);
+ttm_backup_insert_folio(struct file *backup, struct folio *folio,
+			unsigned int order, bool writeback, pgoff_t idx,
+			gfp_t folio_gfp);
 
 void ttm_backup_fini(struct file *backup);
 
-- 
2.54.0


