Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBE1CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926126B0156; Mon, 19 Jan 2026 04:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD036B0158; Mon, 19 Jan 2026 04:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB9A6B0159; Mon, 19 Jan 2026 04:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66B476B0156
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:47:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 076D9D2219
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:47:55 +0000 (UTC)
X-FDA: 84348236910.22.15CA681
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id C215B1C0004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:47:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hVR1qlsM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768816073; a=rsa-sha256;
	cv=none;
	b=NvKmZ+Gt+JJhA7Eoi2eVjtmcMuEBHh9fZCZSLYGZX8gDpqO6ZlzcxyEbGtTucGqdKzOFsm
	zgmG6tpYvXFik7HGuoBrr2G6v3N7PpuYGlJtNLelgQCmPq6cDMMqeT15TRsv13yNbuqY5j
	O4TWb9NL0rdN4JUoqvpEXWIMR+wOpCk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hVR1qlsM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768816073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bn9MgIzVMcRdd2+usqCf00V1IH4szaxcWKeVmYy2zsw=;
	b=TBwfgSBae7o1aenr6EnafXNQ4Zd2pVsqfQpxRnNl13wRn8mOHyiP11kxJwpnkVN7puti0i
	F5nJnIL6ufO8hCsVyRkGJdLioKJIqn8r8Pxx4WRSknBZl/kMs1vZap+R+NufeAoZJkS4Rm
	Q4kRuxz5/lbtVEt7ZrcVBMdo7BhIiXY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768816073; x=1800352073;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b3r/id//jk8ltKEIWz6hSP24Dq486+R2QT2UaseG5TI=;
  b=hVR1qlsMQ65woAO48kyjmcWp0rUNhUGTM31G8ckM1Px2eaaA5Ogs4dq3
   HLwyrjZtVm0JFulFXMZGcTlW2WIl/eO6ZpwQpntE9jNUZH9ExyAHvJiTg
   Ho6hn8f5bOKLgefkhUk0+GF0mdPTCugyrwJ4tsGTnoY31OUn6+Gq+2RfE
   iTRrlW6V2pHRkOJE0RIHv/qXq182VQvK3S5F6FWaf4AG0SA5kKbBRJbuN
   P93tsUrZ37Uq22rCl2hbbw/x1K7IEXI2QV1tewoqB6+3VgH1BSGz0bF98
   2ws6d2jtWQnCPiFT30KEHAUq2bPsbon1PQVCUzCeKOolE8FFrzvi9ymes
   A==;
X-CSE-ConnectionGUID: XVSfDpwBSk6oxtKwkENZYA==
X-CSE-MsgGUID: HWvyLie9SRCcCH+rOuBk8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="70072796"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="70072796"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 01:47:52 -0800
X-CSE-ConnectionGUID: 9zqhHE0HQEu1mtMfdLQmLg==
X-CSE-MsgGUID: wcPA6tfrTFuS08VmgJBTug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="204971995"
Received: from linux-pnp-server-15.sh.intel.com ([10.239.177.153])
  by orviesa006.jf.intel.com with ESMTP; 19 Jan 2026 01:47:49 -0800
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
Subject: [PATCH v2 2/2] mm/readahead: batch folio insertion to improve performance
Date: Mon, 19 Jan 2026 18:02:59 +0800
Message-ID: <20260119100301.922922-3-zhiguo.zhou@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260119100301.922922-1-zhiguo.zhou@intel.com>
References: <20260119065027.918085-1-zhiguo.zhou@intel.com>
 <20260119100301.922922-1-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dpinc9dozhs98pxxtj68189yoixiesyp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C215B1C0004
X-HE-Tag: 1768816072-832155
X-HE-Meta: U2FsdGVkX18r4B6dhfxtmAwSBPlwj8AxxTT+PWe/PgxtX9duz79rYzPtF3PR/KFUotlbGCWZmSYsEwRoqjQIiLsRUAyZIXIvvrK6GfcfEQ9n8gtp5Mw7+tQJDLPc7kLJ+CBYuPeo0TzBfDzYA5jyD/8tZauwvrtGnmsihGWWbF9LjhItGtUJ7O8CDlchxBTVA7hf7sjmtjFFIquOWXbFymosN/AXVDdTYuTJQl1ChtUrQkWfQUxMUJPcSDUAZ+KhEM/jCXk81Q1IXfAt0FR6nRZjyaI8rsazC1OZQcFO9BBRfEiKKxDjjv2IvWyL9E0nYyTdYkFFpwzBWr5IJD+I0z29NaV8Q+xHSnkDwxIIrusHQjv0dJoLKKU10G+4GrQCtdd2tMIQ+vK8uiCbXcdkoaEIHfngKDTRmorsXW0g5jDwgV1T3nkzyCNEr7Ps5ScgCu0iMC4r9oXX1obtGsM+odn/A2FifTtmm59VNOFSYCJ+V4OzYdtMe5IGtXUHnsf1xUWWaRCC3Pawiy/gzFm/UhKfSb/WRtxZF5PVXBNd9KrzwXgU3GKE4uODzPj4V0RmosmdRNw75sohrwOvAZqpxIW1V/ce6pS3Z+ae4EVESsmugSl/KEg77JeLgzaW53FpC49PknpRMFQ4JmblO9Wk1+bbp9hDu05P9Cw+M/3KEhbqo6qjxII6+dT93X2ZIKI27+Lk4wbc6DDwtZeBfsr0Sl9MEfZ/Evz3rlltQHhG4PlHLYuLomziuT89LYkPiFTcGVIS+oJBEjXYbF2adZgzWS7LwijeT/gtubyiGPkyX0j63qOaLbvTV2rneWkY0tBGXonHFTg7kA3mEGKRRjUIFP7cZIhvQvIGXKn6e64b3/8XALEnPwYoizqZrkvh9/zAq8Ax5MZL50gOCUuhJtimB4JbpvUZwl0003OHSwm/Ma7OxbkHdIk4GHSfcge8gI0xFdmDyPGUI4QMOhZD8mB
 4v8PMHIz
 ghGCkiamx9cYT0Q/Jz+H0JrUsIk3xg3653/NMTQRU9uCmwkdAPbgM7bysnlFoPf/pwpiGuA+1VyOUhZIbjpJoQt+fIaRNWrYIbjqB40rtbYFtkUzLwv78C6uSuSoZpNCdsZ209PAa6Q8oJCyTG5g6cpENM+TeK0vRimIwyPYF3mTExV98F2V9VE+/oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When `readahead` syscall is invocated, `page_cache_ra_unbounded` would
insert folios into the page cache (`xarray`) individually. The `xa_lock`
protected critical section could be scheduled across different cores,
the cost of cacheline transfer together with lock contention may
contribute significant part of execution time.

To optimize the performance of `readahead`, the folio insertions are
batched into a single critical section. This patch introduces
`filemap_add_folio_range()`, which allows inserting an array of folios
into a contiguous range of `xarray` while holding the lock only once.
`page_cache_ra_unbounded` is updated to pre-allocate folios
and use this new batching interface while keeping the original approach
when memory is under pressure.

The performance of RocksDB's `db_bench` for the `readseq` subcase [1]
was tested on a 32-vCPU instance [2], and the results show:
- Profiling shows the IPC of `page_cache_ra_unbounded` (excluding
  `raw_spin_lock_irq` overhead) improved by 2.18x.
- Throughput (ops/sec) improved by 1.51x.
- Latency reduced significantly: P50 by 63.9%, P75 by 42.1%, P99 by
31.4%.

+------------+------------------+-----------------+-----------+
| Percentile | Latency (before) | Latency (after) | Reduction |
+------------+------------------+-----------------+-----------+
| P50        | 6.15 usec        | 2.22 usec       | 63.92%    |
| P75        | 13.38 usec       | 7.75 usec       | 42.09%    |
| P99        | 507.95 usec      | 348.54 usec     | 31.38%    |
+------------+------------------+-----------------+-----------+

[1] Command to launch the test
./db_bench --benchmarks=readseq,stats --use_existing_db=1
--num_multi_db=32 --threads=32 --num=1600000 --value_size=8192
--cache_size=16GB

[2] Hardware: Intel Ice Lake server
    Kernel  : v6.19-rc5
    Memory  : 256GB

Reported-by: Gang Deng <gang.deng@intel.com>
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Zhiguo Zhou <zhiguo.zhou@intel.com>
---
 include/linux/pagemap.h |   2 +
 mm/filemap.c            |  65 +++++++++++++
 mm/readahead.c          | 196 +++++++++++++++++++++++++++++++---------
 3 files changed, 222 insertions(+), 41 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 59cbf57fb55b..62cb90471372 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1286,6 +1286,8 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		pgoff_t index, gfp_t gfp);
 int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		pgoff_t index, gfp_t gfp);
+long filemap_add_folio_range(struct address_space *mapping, struct folio **folios,
+		pgoff_t start, pgoff_t end, gfp_t gfp);
 void filemap_remove_folio(struct folio *folio);
 void __filemap_remove_folio(struct folio *folio, void *shadow);
 void replace_page_cache_folio(struct folio *old, struct folio *new);
diff --git a/mm/filemap.c b/mm/filemap.c
index c4c6cd428b8d..f8893c31dba1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1016,6 +1016,71 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
+/**
+ * filemap_add_folio_range - add folios to the page range [start, end) of filemap.
+ * @mapping:	The address space structure to add folios to.
+ * @folios:	The array of folios to add to page cache.
+ * @start:	The starting page cache index.
+ * @end:	The ending page cache index (exclusive).
+ * @gfp:	The memory allocator flags to use.
+ *
+ * This function adds folios to mapping->i_pages with contiguous indices.
+ *
+ * If an entry for an index in the range [start, end) already exists, a folio is
+ * invalid, or _filemap_add_folio fails, this function aborts. All folios up
+ * to the point of failure will have been inserted, the rest are left uninserted.
+ *
+ * Return: If the pages are partially or fully added to the page cache, the number
+ * of pages (instead of folios) is returned. Elsewise, if no pages are inserted,
+ * the error number is returned.
+ */
+long filemap_add_folio_range(struct address_space *mapping, struct folio **folios,
+			     pgoff_t start, pgoff_t end, gfp_t gfp)
+{
+	int ret;
+	XA_STATE_ORDER(xas, &mapping->i_pages, start, mapping_min_folio_order(mapping));
+	unsigned long min_nrpages = mapping_min_folio_nrpages(mapping);
+
+	do {
+		xas_lock_irq(&xas);
+
+		while (xas.xa_index < end) {
+			unsigned long index = (xas.xa_index - start) / min_nrpages;
+			struct folio *folio;
+
+			folio = xas_load(&xas);
+			if (folio && !xa_is_value(folio)) {
+				ret = -EEXIST;
+				break;
+			}
+
+			folio = folios[index];
+			if (!folio) {
+				ret = -EINVAL;
+				break;
+			}
+
+			ret = _filemap_add_folio(mapping, folio, &xas, gfp, true);
+
+			if (unlikely(ret))
+				break;
+
+			/*
+			 * On successful insertion, the folio's array entry is set to NULL.
+			 * The caller is responsible for reclaiming any uninserted folios.
+			 */
+			folios[index] = NULL;
+			for (unsigned int i = 0; i < min_nrpages; i++)
+				xas_next(&xas);
+		}
+
+		xas_unlock_irq(&xas);
+	} while (xas_nomem(&xas, gfp & GFP_RECLAIM_MASK));
+
+	return xas.xa_index > start ? (long) xas.xa_index - start : ret;
+}
+EXPORT_SYMBOL_GPL(filemap_add_folio_range);
+
 #ifdef CONFIG_NUMA
 struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *policy)
diff --git a/mm/readahead.c b/mm/readahead.c
index b415c9969176..4fe87b467d61 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -193,6 +193,149 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 	return folio;
 }
 
+static void ractl_free_folios(struct folio **folios, unsigned long folio_count)
+{
+	unsigned long i;
+
+	if (!folios)
+		return;
+
+	for (i = 0; i < folio_count; ++i) {
+		if (folios[i])
+			folio_put(folios[i]);
+	}
+	kvfree(folios);
+}
+
+static struct folio **ractl_alloc_folios(struct readahead_control *ractl,
+					 gfp_t gfp_mask, unsigned int order,
+					 unsigned long folio_count)
+{
+	struct folio **folios;
+	unsigned long i;
+
+	folios = kvcalloc(folio_count, sizeof(struct folio *), GFP_KERNEL);
+
+	if (!folios)
+		return NULL;
+
+	for (i = 0; i < folio_count; ++i) {
+		struct folio *folio = ractl_alloc_folio(ractl, gfp_mask, order);
+
+		if (!folio)
+			break;
+		folios[i] = folio;
+	}
+
+	if (i != folio_count) {
+		ractl_free_folios(folios, i);
+		i = 0;
+		folios = NULL;
+	}
+
+	return folios;
+}
+
+static void ra_fill_folios_batched(struct readahead_control *ractl,
+				   struct folio **folios, unsigned long nr_to_read,
+				   unsigned long start_index, unsigned long mark,
+				   gfp_t gfp_mask)
+{
+	struct address_space *mapping = ractl->mapping;
+	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
+	unsigned long added_folios = 0;
+	unsigned long i = 0;
+
+	while (i < nr_to_read) {
+		long ret;
+		unsigned long added_nrpages;
+
+		ret = filemap_add_folio_range(mapping, folios + added_folios,
+					      start_index + i,
+					      start_index + nr_to_read,
+					      gfp_mask);
+
+		if (unlikely(ret < 0)) {
+			if (ret == -ENOMEM)
+				break;
+			read_pages(ractl);
+			ractl->_index += min_nrpages;
+			i = ractl->_index + ractl->_nr_pages - start_index;
+			continue;
+		}
+
+		if (unlikely(ret == 0))
+			break;
+
+		added_nrpages = ret;
+		/*
+		 * `added_nrpages` is multiple of min_nrpages.
+		 */
+		added_folios += added_nrpages / min_nrpages;
+
+		if (i <= mark && mark < i + added_nrpages)
+			folio_set_readahead(xa_load(&mapping->i_pages,
+						    start_index + mark));
+		for (unsigned long j = i; j < i + added_nrpages; j += min_nrpages)
+			ractl->_workingset |= folio_test_workingset(xa_load(&mapping->i_pages,
+									    start_index + j));
+		ractl->_nr_pages += added_nrpages;
+
+		i += added_nrpages;
+	}
+}
+
+static void ra_fill_folios_single(struct readahead_control *ractl,
+				  unsigned long nr_to_read,
+				  unsigned long start_index, unsigned long mark,
+				  gfp_t gfp_mask)
+{
+	struct address_space *mapping = ractl->mapping;
+	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
+	unsigned long i = 0;
+
+	while (i < nr_to_read) {
+		struct folio *folio = xa_load(&mapping->i_pages, start_index + i);
+		int ret;
+
+		if (folio && !xa_is_value(folio)) {
+			/*
+			 * Page already present?  Kick off the current batch
+			 * of contiguous pages before continuing with the
+			 * next batch.  This page may be the one we would
+			 * have intended to mark as Readahead, but we don't
+			 * have a stable reference to this page, and it's
+			 * not worth getting one just for that.
+			 */
+			read_pages(ractl);
+			ractl->_index += min_nrpages;
+			i = ractl->_index + ractl->_nr_pages - start_index;
+			continue;
+		}
+
+		folio = ractl_alloc_folio(ractl, gfp_mask,
+					  mapping_min_folio_order(mapping));
+		if (!folio)
+			break;
+
+		ret = filemap_add_folio(mapping, folio, start_index + i, gfp_mask);
+		if (ret < 0) {
+			folio_put(folio);
+			if (ret == -ENOMEM)
+				break;
+			read_pages(ractl);
+			ractl->_index += min_nrpages;
+			i = ractl->_index + ractl->_nr_pages - start_index;
+			continue;
+		}
+		if (i == mark)
+			folio_set_readahead(folio);
+		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_nr_pages += min_nrpages;
+		i += min_nrpages;
+	}
+}
+
 /**
  * page_cache_ra_unbounded - Start unchecked readahead.
  * @ractl: Readahead control.
@@ -213,8 +356,10 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	struct address_space *mapping = ractl->mapping;
 	unsigned long index = readahead_index(ractl);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
-	unsigned long mark = ULONG_MAX, i = 0;
+	unsigned long mark = ULONG_MAX;
 	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
+	struct folio **folios = NULL;
+	unsigned long alloc_folios = 0;
 
 	/*
 	 * Partway through the readahead operation, we will have added
@@ -249,49 +394,18 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	}
 	nr_to_read += readahead_index(ractl) - index;
 	ractl->_index = index;
-
+	alloc_folios = DIV_ROUND_UP(nr_to_read, min_nrpages);
 	/*
 	 * Preallocate as many pages as we will need.
 	 */
-	while (i < nr_to_read) {
-		struct folio *folio = xa_load(&mapping->i_pages, index + i);
-		int ret;
-
-		if (folio && !xa_is_value(folio)) {
-			/*
-			 * Page already present?  Kick off the current batch
-			 * of contiguous pages before continuing with the
-			 * next batch.  This page may be the one we would
-			 * have intended to mark as Readahead, but we don't
-			 * have a stable reference to this page, and it's
-			 * not worth getting one just for that.
-			 */
-			read_pages(ractl);
-			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
-			continue;
-		}
-
-		folio = ractl_alloc_folio(ractl, gfp_mask,
-					mapping_min_folio_order(mapping));
-		if (!folio)
-			break;
-
-		ret = filemap_add_folio(mapping, folio, index + i, gfp_mask);
-		if (ret < 0) {
-			folio_put(folio);
-			if (ret == -ENOMEM)
-				break;
-			read_pages(ractl);
-			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
-			continue;
-		}
-		if (i == mark)
-			folio_set_readahead(folio);
-		ractl->_workingset |= folio_test_workingset(folio);
-		ractl->_nr_pages += min_nrpages;
-		i += min_nrpages;
+	folios = ractl_alloc_folios(ractl, gfp_mask,
+				    mapping_min_folio_order(mapping),
+				    alloc_folios);
+	if (folios) {
+		ra_fill_folios_batched(ractl, folios, nr_to_read, index, mark, gfp_mask);
+		ractl_free_folios(folios, alloc_folios);
+	} else {
+		ra_fill_folios_single(ractl, nr_to_read, index, mark, gfp_mask);
 	}
 
 	/*
-- 
2.43.0


