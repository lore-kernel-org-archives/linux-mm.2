Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21763CA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401B06B00AB; Fri,  2 Oct 2026 21:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38AE76B00AC; Fri,  2 Oct 2026 21:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279DB6B00AD; Fri,  2 Oct 2026 21:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22AC6B00AB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:00:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E6B04089D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:46 +0000 (UTC)
X-FDA: 85279510092.06.B157875
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf02.hostedemail.com (Postfix) with ESMTP id A16E880008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FAWdZrkkSI2CWut1ddzYSER3F8h2SVPMA6em0ors5DA=;
	b=FYArpTtIYqG7jvXoer8uw+bDe70Fhbgk8oQrTIXx/ufvzfQixThbK69vcx/LIUUr+FfATH
	Qr7iwWpt75zVq+MdNKI1yjgbzsv6dhPRDASEI5Zd3PsHLIkoTeO76zthMLIGzjgKm0r0p4
	fWCalsvJEKFgpb2JUxqZHziTU4YHKDg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989244;
	b=bgajSJXdwkomcLqjBz/mJqyMHyrMFHgs5WWfxoWkqmSfp4Z5MrHu3hCb+gH3l+cyhLSzSx
	TabwwHKkPx+NxHXph9ojIeffcMQ4CxRO1A47AuOLgE7JI9oaUrBw6fP+q/l/HyzRZG5lsJ
	AamNM7vQMbzuZ15fV7OLRf7rsmOnmeo=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a90eb7b5d7ac953e;
	Sat, 03 Oct 2026 01:00:43 +0000
X-Mizu-Trace-ID: a90eb7b5d7ac953e
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
Subject: [PATCH 12/12] mm, swap: skip a NOFS backend when reclaim cannot enter the fs
Date: Sat,  3 Oct 2026 08:59:00 +0800
Message-ID: <20261003005900.909710-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pqh1rermriicmbe7zwro11jno6tpaqkp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A16E880008
X-HE-Tag: 1790989244-843159
X-HE-Meta: U2FsdGVkX19emykeLuu8R2iYwWraq6DuXWiAl2xIt6N6I/0NwtiGljhPDTV+OF//uHtLbA1xIhAJ4/SB2lFkWunUORWzEZcXIZg/nWn1yzIhyi+q2OjyXXd5bpIYed6OLThUmajWPfDdX3TBkAoXIHjR9JxjMXjMwa9MZyi3KFsm50UUCLGcuORClXg/aJzRMRvtvrRQckPlGm7sNrvwYNGlrKwxaJuT/f8GFYStUKw12LkR/WdaT+rZ3d6SlT27fAzEr08+mU0q0m0qbK8aIZy3b+Kx8TvDpdj6fbw8Vaakk/L26le0ixt1iMuihtvcQ2SONbu6ssR857ZbIFsiueU9kAhbhRkHBaB+y0fZxUWcnuwkCJOeJE56Fme6pNKehrkkjK4ikV5cbJJdmuoRs7ByYaLeDkvY5uMya1NmvqGtZtCb/Klnz+GKrBwD6NuJKBMKiouut2byUTTFRmvILmsYkaveDcbUgMrKGnUd+1roRJGHLSbkGbb9wgt4A+2Km1E6su7v30ZyMLR52gdGoSkmx21GurSLY4cHkQybCXuXQu5YQoDzUkx8GbWkXZKtgXcXzxQwfU5/YTSKde/cu8+jAvbqDzHsq7kpllX2awdpXZ3EWIxztcErIti5MrAE/IDsqZB1Dl2qtwnYAU4S1pybLte8jzg5fS7aHWYuGouQ4BCxYIWhXuXT2lnvCBfb/nrNCbtH4iNwPmHMw0qiC67dEOQwclsrTeJMrH2WpF3da5rOlIiZIDhqQAQsJYbtFRJlTvqgLl5ujBU62B+JdJ9hgVMh/iN339LplWa3atAVNDx/i1NTmxr0C8Ed4l4Z5hwAkPiz6agjdq2EqdC7zZ+pawQ3Ru+93P9FFlwvQaVjswsbUa3+dBg3iZs+9JSYw3aDORQmnHz9nDY8C94vKwGgH2peGq6e1IStoV8dEQdcuDc0ZrJ85BbvFuOh3oGF05n00qBHNU4d9dxLUma
 GuN28uc3
 U4xVMH4q+J/6ce8D0gRcE3rJCosTMCgYbVQxjEHKUZyd/8sVck+xhYF3jcDAIjZqnoR8Bq5HxPj5yvA8SoocqIlryPmNHsOxPcHqzc2pSwQfYWaHRWIOMYL9khRfkoeOjthO/tqhq5w+PEcb7pC/cJWnq/U/3XGE+AWpT//8i8Rih4GWmmw1GfEYnawLBtt7To6km1BIxOKtHM4qSqvS+FZpKR7dH4jP2Z8zhp+prjqiUtJx0SyQwZIQoSeyrdHLFvDSYs1rjcu1RlYyn9Y0Yy3zKZKxf3mJDMNu/LbncaiM600k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap folio's swap entry points at the xswap device, but its data may
be written to a real backend. may_enter_fs() reads the device out of that
entry, so it checks the xswap device and not the backend: a context that
cannot enter the fs is still allowed to write, and
xswap_alloc_phys_slot() may pick NFS or SMB. Writing there re-enters the
filesystem.

Marking the xswap device REQUIRE_NOFS would block zswap too, and zswap
needs no filesystem. Pass may_enter_fs down in swap_io_ctx instead, taken
from sc->gfp_mask. xswap_alloc_phys_slot() skips a NOFS backend when it
is false. With none left, AOP_WRITEPAGE_ACTIVATE keeps the folio.

zswap reaches the allocator from two places. Its shrinker runs only when
count_objects() saw __GFP_FS, and zswap_store() on the swapout path
carries the reclaim's mask down through shrink_memcg(). The other
swap_io_ctx users default to false, as shmem_write_folio() does, reached
that way from i915 and TTM.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap_ops.h |  1 +
 include/linux/zswap.h    |  4 ++--
 mm/page_io.c             |  5 +++--
 mm/swap.h                |  6 ++++--
 mm/swapfile.c            | 10 +++++++---
 mm/vmscan.c              |  4 +++-
 mm/zswap.c               | 35 +++++++++++++++++++++++++----------
 7 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 198c5738c3c7..ed0017be12fb 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -18,6 +18,7 @@ struct swap_iocb {
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+	bool			may_enter_fs;	/* this context may enter the fs */
 };
 
 /*
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index df6cafbe95dc..809b8b839f3b 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -25,7 +25,7 @@ struct zswap_lruvec_state {
 };
 
 unsigned long zswap_total_pages(void);
-bool zswap_store(struct folio *folio);
+bool zswap_store(struct folio *folio, bool may_enter_fs);
 int zswap_load(struct folio *folio);
 void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries);
 int zswap_swapon(int type, unsigned long nr_pages);
@@ -39,7 +39,7 @@ bool zswap_never_enabled(void);
 
 struct zswap_lruvec_state {};
 
-static inline bool zswap_store(struct folio *folio)
+static inline bool zswap_store(struct folio *folio, bool may_enter_fs)
 {
 	return false;
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index 7e8e8150bdcf..fb32b9db1df7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -235,7 +235,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 */
 	swap_zeromap_folio_clear(folio);
 
-	if (zswap_store(folio)) {
+	if (zswap_store(folio, ctx->may_enter_fs)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
@@ -257,7 +257,8 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		swp_entry_t phys;
 
 		/* The pool refused it: fall back to a real swap device. */
-		phys = xswap_backend_alloc(entry, folio_order(folio));
+		phys = xswap_backend_alloc(entry, folio_order(folio),
+					   ctx->may_enter_fs);
 		if (!phys.val) {
 			folio_mark_dirty(folio);
 			return AOP_WRITEPAGE_ACTIVATE;
diff --git a/mm/swap.h b/mm/swap.h
index 628395885919..f7c832b7fdc4 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -475,7 +475,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 
 #ifdef CONFIG_XSWAP
 swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot);
-swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order);
+swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
+				bool may_enter_fs);
 void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order);
 int xswap_check_backing(struct swap_cluster_info *ci, unsigned int off,
 			unsigned int nr);
@@ -486,7 +487,8 @@ static inline swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci,
 	return (swp_entry_t){};
 }
 
-static inline swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
+static inline swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
+					      bool may_enter_fs)
 {
 	return (swp_entry_t){};
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c63f1c641035..180cf538f9ab 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4563,7 +4563,7 @@ static unsigned long xswap_alloc_slot_local(struct swap_info_struct *si,
 	return offset;
 }
 
-static swp_entry_t xswap_alloc_phys_slot(unsigned int order)
+static swp_entry_t xswap_alloc_phys_slot(unsigned int order, bool may_enter_fs)
 {
 	struct swap_info_struct *devs[MAX_SWAPFILES], *si;
 	int nr = 0, i;
@@ -4577,6 +4577,9 @@ static swp_entry_t xswap_alloc_phys_slot(unsigned int order)
 	plist_for_each_entry(si, &swap_avail_head, avail_list) {
 		if (si->flags & SWP_XSWAP)
 			continue;
+		/* Writing there would re-enter the fs this context is in. */
+		if (!may_enter_fs && (si->ops->flags & SWAP_OPS_F_REQUIRE_NOFS))
+			continue;
 		if (nr == MAX_SWAPFILES)
 			break;
 		devs[nr++] = si;
@@ -4615,7 +4618,8 @@ static void xswap_install_rmap(swp_entry_t phys, swp_entry_t entry)
 }
 
 /* Back the range of 1 << @order slots at @entry with contiguous physical slots. */
-swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
+swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
+				bool may_enter_fs)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
@@ -4637,7 +4641,7 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 	}
 	swap_cluster_unlock(ci);
 
-	phys = xswap_alloc_phys_slot(order);
+	phys = xswap_alloc_phys_slot(order, may_enter_fs);
 	if (!phys.val)
 		return phys;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..fc4754779d76 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1169,7 +1169,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
-	struct swap_io_ctx ctx = {};
+	struct swap_io_ctx ctx = {
+		.may_enter_fs = !!(sc->gfp_mask & __GFP_FS),
+	};
 
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
diff --git a/mm/zswap.c b/mm/zswap.c
index 03171e4f2852..789730c2294f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1003,7 +1003,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * freed.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
+				 swp_entry_t swpentry, bool may_enter_fs)
 {
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
@@ -1056,7 +1056,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	/* Reserve the destination before dropping the zswap copy. */
 	if (is_xswap) {
-		phys = xswap_backend_alloc(swpentry, 0);
+		phys = xswap_backend_alloc(swpentry, 0, may_enter_fs);
 		if (!phys.val) {
 			ret = -ENOMEM;
 			goto err;
@@ -1134,11 +1134,18 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
  *    can expect from writeback. We scale down the number of objects available
  *    for reclaim by this ratio.
  */
+
+struct zswap_shrink_arg {
+	bool	*swapcache_hit;	/* page was already in the swap cache */
+	bool	may_enter_fs;
+};
+
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
 				       void *arg)
 {
+	struct zswap_shrink_arg *shrinking = arg;
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	bool *encountered_page_in_swapcache = shrinking->swapcache_hit;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1193,7 +1200,8 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry,
+						 shrinking->may_enter_fs);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1220,6 +1228,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 {
 	unsigned long shrink_ret;
 	bool encountered_page_in_swapcache = false;
+	struct zswap_shrink_arg shrinking = {};
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1227,8 +1236,10 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		return SHRINK_STOP;
 	}
 
+	shrinking.swapcache_hit = &encountered_page_in_swapcache;
+	shrinking.may_enter_fs = !!(sc->gfp_mask & __GFP_FS);
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&shrinking);
 
 	if (encountered_page_in_swapcache)
 		return SHRINK_STOP;
@@ -1332,8 +1343,11 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  */
-static int shrink_memcg(struct mem_cgroup *memcg)
+static int shrink_memcg(struct mem_cgroup *memcg, bool may_enter_fs)
 {
+	struct zswap_shrink_arg shrinking = {
+		.may_enter_fs = may_enter_fs,
+	};
 	int nid, shrunk = 0, scanned = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
@@ -1350,7 +1364,8 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
-					    &shrink_memcg_cb, NULL, &nr_to_walk);
+					    &shrink_memcg_cb, &shrinking,
+					    &nr_to_walk);
 		scanned += SWAP_CLUSTER_MAX - nr_to_walk;
 	}
 
@@ -1427,7 +1442,7 @@ static void shrink_worker(struct work_struct *w)
 			goto resched;
 		}
 
-		ret = shrink_memcg(memcg);
+		ret = shrink_memcg(memcg, true);
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
@@ -1544,7 +1559,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	return false;
 }
 
-bool zswap_store(struct folio *folio)
+bool zswap_store(struct folio *folio, bool may_enter_fs)
 {
 	long nr_pages = folio_nr_pages(folio);
 	swp_entry_t swp = folio->swap;
@@ -1563,7 +1578,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg)) {
+		if (shrink_memcg(memcg, may_enter_fs)) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
-- 
2.54.0


