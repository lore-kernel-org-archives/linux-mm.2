Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45E6DCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1816B008A; Fri,  2 Oct 2026 20:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292116B0093; Fri,  2 Oct 2026 20:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE9B6B008A; Fri,  2 Oct 2026 20:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9946B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:31:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 398041A0883
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:31:55 +0000 (UTC)
X-FDA: 85279437390.12.C6377D0
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA34C180009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:31:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cImYYuDyYFDyOYkxx5AwUFnyOeRKTqi93TSAsfZfQPs=;
	b=quRK5amth1AbwK7CJ8yatoMdr+wKMwNmQM77dh+P/vfAxchLMBhtgVPOXsCGQvf5mEpfvY
	6pmYHQwUbDdmJy41mP/JsBp4vYpnVEN+xdQ4nR5hRgrilBgD8cf8CV0tP+DTb82hZ0XCwF
	W1F31lcahhsJeP3gmiWlCj28vj1exXQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987513;
	b=JaPw0UibGVvupHPJd1x1gDMkysDgUSaKkSmgWSx35Om3twT7KwJQkQ46eXUSc97rcU2FZe
	12rU3Go8VHMflgvPbrvfQEoY+F/9Gn4x/wEdSAR/mGS3WmOBR4uPMhc8dxaoYHHVulFHRJ
	gL9LBqgx+c1HcNjom7P/aaPDhHgnsNs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 7fdc9e65592ceeca;
	Sat, 03 Oct 2026 00:31:51 +0000
X-Mizu-Trace-ID: 7fdc9e65592ceeca
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
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 01/14] mm: xswap support for zswap
Date: Sat,  3 Oct 2026 08:31:23 +0800
Message-ID: <20261003003136.750633-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dtk8it1jp3ygishojw45ss3bw8459rbd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA34C180009
X-HE-Tag: 1790987512-330629
X-HE-Meta: U2FsdGVkX19ON9jXpJ6lpXGu3zq+cHedyTPvW6qCk9q6ZqiqAYxLJoLSwk8oNJ18XHRff6TfpumoO/mDCkjEaMvw6ugdJrzMZ7h0eJ7LOvA0iaaiDE/iiEpjB4RN4LSArODkhPd6+hMMUv35jnKJUeXA54uqKXKEvg5+E1Eea1YJToHW52I3V6N8R+xm6vQF80OCo2z9HRcjXEDti9Zh2ejaqGzMqMXZS8zpuBC0EWVVsoVD69i8LseFfL0PikN3tkjrRkh6RHHrh089cLFWlHSo0X2RkLIbs9bzcWDFeSJvIycyD/eLIyMjIIzPEvGnfbgP+B2srDieLJhKH+dzVDdjygJoOqQEn5HRAKLKh54mZC1BrUC+nKv0REVJjBtLjYSjxmiU6s9/4R2ubvNN7cDWIM2f9cI9qp6iLLGGNGMr0DwDn65oNzN/5ppTZzURtbjzaYjDQqx9oPE/SglFo+DCYwfnH+4fN8aWWWRTo5oIAxzYq6JqoBIEYqOvTztZ4WKYYy49Dxul20kDzveuF0tDCwtH58uEvkj83q/1DB/XWPjMvV2sdsxnnExxaPPBfsTKnPeoahHKq60PwIB3e397P7jbAQL/aQvLIObouy5gh6ZlaZsNK+pakiHuEsqa0qQzzVjMdKXTOdR/mpqPoA4IdFm4XX6UH8tWYqa8EoMOl0mEBDINkWw6Kgv6IUfI8bqEDFd9ktp7knsDL67feeuoY4PmyP7A5H9byZOIEiEay6WCoE4t1gmofUgMT6hvrQAsxBzq/FjY6rpNruJl72MVkDcgckBFzmK4PCuHocyXathmF8w528WfpeisWHXuNZXa0JZ+2KxdLsptKgI6V3/coHVoTzFu6DHZhChx/zm/xEq8SdtunJ9PqG/aaSvHcxyIMDrFZA5j1iUQRvlYXfbq4zMSra0M7+w7/pJX6Ihn4M/iMTFNE1T1j+z2a2N1SvyoYzinQecSXoUaRxw
 GZcyrXGa
 WHYpAiUdsafLGrkLjaIdhf92lu1LIo4gvQPzi/eHxqt/+z9iOg9h3ZSbW2LiFbX5qcZfgoX6YnDdfc4uLpsn6Cm3azsSGOxR4CbKO6VmP5AEbG/81BFmsNV3zUT+khkDjRXSlpJ/X7fkp7virlsJerrhDBWE8m1YznUMYE9gqjXPWRATMsM+YsPFnz9UwxFDWJAeZK7r2wrV8C9OGgRYfCF5Y+rBtQK3kMqrOV2WLx8V2h87ICV7CxcpAA6TuG9ObUgiuKwRtQ0wdG7dpX12zOfvThPSPIf0t0c8c/O2rF7916G9Y/bhlBy66o7nby+JQ8xbc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Li <chrisl@kernel.org>

Introduce extendable swap device support - xswap.

An xswap device has no backing storage and no swap data section, so
it wastes no disk space. Creation is via a sysfs interface added in a
later patch.

Zswap writeback is gated on whether a real (non-xswap) swap device is
active. nr_real_swapfiles counts such devices and is maintained at
swapon/swapoff only, so the gate reflects "a device exists to write
back to" rather than "a device currently has free slots". This keeps
writeback working even when the real swap device is full, and avoids
a double decrement when a full device is swapped off.

An xswap entry is not added to the zswap writeback LRU: with no backing
store there is nothing to write it back to. zswap_lru_del() tolerates
that, since an entry that was never added is on no list.

Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 19 +++++++++++++++++++
 mm/swap_state.c      |  9 +++++++++
 mm/swapfile.c        | 28 ++++++++++++++++++++++++----
 mm/zswap.c           | 11 +++++++++--
 5 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f..9073d29377d8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -201,6 +201,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_XSWAP	= (1 << 14),	/* extendable swap device */
 					/* add others here before... */
 };
 
@@ -378,6 +379,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index c6824fcd483e..25fa9b82ed46 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -248,6 +248,15 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
+	/*
+	 * xswap has no backing store: keep the folio.  ctx->sis is not set
+	 * yet, so look the device up from the entry.
+	 */
+	if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP)) {
+		folio_mark_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
@@ -486,6 +495,16 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
+	if (unlikely(sis->flags & SWP_XSWAP)) {
+		/*
+		 * An xswap entry only ever lives in zswap, so zswap_load()
+		 * must have found it.  Unlock and let the caller retry.
+		 */
+		WARN_ON_ONCE(1);
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ebef568cd62e..3a4e9e447b0b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -884,6 +884,10 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct blk_plug plug;
 	swp_entry_t ra_entry;
 
+	/* xswap entries live only in zswap; readahead does not help. */
+	if (si->flags & SWP_XSWAP)
+		goto skip;
+
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
@@ -969,6 +973,7 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
 static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
 {
+	struct swap_info_struct *si = __swap_entry_to_info(targ_entry);
 	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
 	struct folio *folio;
@@ -977,6 +982,10 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	unsigned long start, end, addr;
 	pgoff_t ilx = targ_ilx;
 
+	/* xswap entries live only in zswap; readahead does not help. */
+	if (si->flags & SWP_XSWAP)
+		goto skip;
+
 	win = swap_vma_ra_win(vmf, &start, &end);
 	if (win == 1)
 		goto skip;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c3288910b3e3..32c3133e1211 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
+atomic_t nr_real_swapfiles;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
@@ -733,7 +734,8 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
 	/*
 	 * If the swap is discardable, prepare discard the cluster
 	 * instead of free it immediately. The cluster will be freed
-	 * after discard.
+	 * after discard.  xswap has no bdev and never sets
+	 * SWP_PAGE_DISCARD, so it always takes the free path below.
 	 */
 	if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) ==
 	    (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
@@ -1216,6 +1218,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		 */
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
+		/* Count active devices, not merely those on the avail list. */
+		if (!(si->flags & SWP_XSWAP))
+			atomic_sub(1, &nr_real_swapfiles);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
 		/*
@@ -1273,6 +1278,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
+	if (swapon && !(si->flags & SWP_XSWAP))
+		atomic_add(1, &nr_real_swapfiles);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -3268,7 +3275,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3378,6 +3386,19 @@ static void swap_stop(struct seq_file *swap, void *v)
 	mutex_unlock(&swapon_mutex);
 }
 
+static const char *swap_type_str(struct swap_info_struct *si)
+{
+	struct file *file = si->swap_file;
+
+	if (si->flags & SWP_XSWAP)
+		return "xswap\t";
+
+	if (S_ISBLK(file_inode(file)->i_mode))
+		return "partition";
+
+	return "file\t";
+}
+
 static int swap_show(struct seq_file *swap, void *v)
 {
 	struct swap_info_struct *si = v;
@@ -3397,8 +3418,7 @@ static int swap_show(struct seq_file *swap, void *v)
 	len = seq_file_path(swap, file, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
-			S_ISBLK(file_inode(file)->i_mode) ?
-				"partition" : "file\t",
+			swap_type_str(si),
 			bytes, bytes < 10000000 ? "\t" : "",
 			inuse, inuse < 10000000 ? "\t" : "",
 			si->prio);
diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced..7fe25f0b157c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1018,6 +1018,11 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
+	if (si->flags & SWP_XSWAP) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
+
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 					 NO_INTERLEAVE_INDEX);
@@ -1511,7 +1516,9 @@ static bool zswap_store_page(struct folio *folio, long index,
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
+		/* No backing store: nothing to write these back to. */
+		if (!(__swap_entry_to_info(page_swpentry)->flags & SWP_XSWAP))
+			zswap_lru_add(entry);
 	}
 
 	return true;
@@ -1581,7 +1588,7 @@ bool zswap_store(struct folio *folio)
 	zswap_pool_put(pool);
 put_objcg:
 	obj_cgroup_put(objcg);
-	if (!ret && zswap_pool_reached_full)
+	if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapfiles))
 		queue_work(shrink_wq, &zswap_shrink_work);
 check_old:
 	/*
-- 
2.54.0


