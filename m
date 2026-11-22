Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB81606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pXI8xod8
Received: by kanga.kvack.org (Postfix)
	id E5BDB6B05B2; Sun, 22 Nov 2026 07:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E331E6B05B3; Sun, 22 Nov 2026 07:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBC86B05B4; Sun, 22 Nov 2026 07:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD656B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21824A8346
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:00 +0000 (UTC)
X-FDA: 85462712160.02.F8623DE
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECB94180002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:39:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pXI8xod8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351198;
	b=4eMwFvTR/QJ9ngLjowPXJPfZLNrCJOgNgVFFGMjaTluk98813u/pO4GBql1uVR/aJHBvE9
	sZHg9/sp6g+8FANeg5gL8Q/hfQVEnKuJ7Kgamb5BLj1mMHoG7iWQJxZEKMnVzmlvj4t8va
	qx+J2y8Gd+s7z0OkWZ4DbCb3iiLk50A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCZF6OmeVklLKYcvPIClDGROMArFcAN0OhdMvwFNeeA=;
	b=TIQt7eLEY032O6aPD8gTiIwHOLr0uULFaKBAuZ30Vn9nTyVwS2rNFXgVO3Ax4ZOMDGmFsa
	HsrLyWCIdliyvKgohv19ZSVMcC+AQAnluNN1jCbEUF3fsLZlrZBIGtQemFp5TpwAkvjDn0
	SBI1mFg2LEtvG0aPpVhGUL0pa9kSXGQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pXI8xod8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OZlZmc+pbmmv6qej6a4VynTyQxaxQU2NqMJ7qoRIScY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351196; v=1; x=1795955996;
 b=pXI8xod8+ELzMBy1FzW8j1IH13p7bSkiQGVxjAT9/t1DNIrVaUP0AbSZ9FkIzQt/3ptQGnD0
 dtiM3Y1tHKfYQB5k2ofPI2vYyu3NuEwrDugYPY6fkug+csRXlwD95uhYAcyfPbYSWSh/BqZHDbg
 1IDaIdLt/K2d7UetJTtyxSig=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 96e17b3c4c7b5547;
	Sun, 22 Nov 2026 12:39:56 +0000
X-Mizu-Trace-ID: 96e17b3c4c7b5547
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 02/14] mm: xswap support for zswap
Date: Sun, 22 Nov 2026 20:39:06 +0800
Message-ID: <20261122123918.3486916-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECB94180002
X-Rspam-User:
X-Stat-Signature: 3xricpkox5se78o3nuntwdc6n7qoesrt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795351197-197800
X-HE-Meta: U2FsdGVkX1/dWdn6gzgN4Dea6kiXuv7PXqM5wGX++ipwaj1V58nyB8X4I4pCTMTab990pWJ2grxzRvZp0WpcVkonLDboOhCDg+zXNFw95kj1OsRFd12slAuEMz/7Eapkgp0wigZAUB9DgeB2RABKFci8nzY9W1PSxOKGIeKgfNjmF4RGHyR866POjZMZpnk5Zi47jOziCVeOqQwvxrNt66f+AxmmCdd8uJOoOSyxcKJOgKLv1yBrztLqLohddPyvbHA3ZoK2v3PCkjLgxunXRzzbgdb1YJs5435/Eb3bPJjOoafzP2NHwZtiamPQKdwXmRAOmGJPkk8r7qv/tso/eajhXdwEro8NhSLgKdMCqEWpp9NFzqrAbktkD5W23cjhkVoCC5crxpuEP5RWnX5VN8ZKmD1ZsfkSWOYoAoooOQxkccUW0imNx0vV2zng6qXwL0uOgR9hMU1PRTSdxOyouTLMXBBl1jm74Vw2HjKz3XFQmhuIqqi1xOjDqDRyzUPG7ax6vZkF5qhs7PCTEC+jzW1WSfWJ6VcJVFGd4Xyt9nAFnjIcV+wGZKm3xP8DdurcMnwt/8fieD4COE0qCnlV4OgTN4IgnbJ8NZGuAaVbV5Ut2MmcgwujTTi4VbUgiJ/z4sYExmwZuKmTgYfQNPZSfKGLBDAqCgqL+2RBe/Gm2+nz4RRrJWRMVB65diruGni1q9YSF0neACSn5+d1AXpSmXxu9uyKsLU1yFzmGQWlo3whXrl9yaCrXDxL9R8eibY05vCsoWCx5F/By9VJVLiQTLMkC/luibmW9uIF6rmS0oIfZ38tKtlXaK+/VlrcVXJb0I4iQ5AFvLhUYcESYSxiK/9xXOU+tVoTycFXQlLxS8R6Aii3G4MTMgf02eC4YOPCL+eG4XO2X1zKhGwcjNskvzueezEUwqfbOEWPTc80lLZmtVYd4JJqJ5ZGT0f/LWNGfK29GnK4mx1Ga1OPrc6
 LxzIlttm
 UfLKKti8FTVjQj6pgLTPhwMrJbzOQXR3m8my2eRVPYq/W5wIZvIc/nCdf3vbgHSyveidAHF3AcrJ9Mx/czKjB7pTaU4VNOPhsIvKWo/rMsR41iWSIOAzySi42GcawHPj8AzpOrqwkDMJ01YU3xiyKADxMnFKGepou5TVg2jdXGFTzkMqRTXgNxypUWghgW2SxYP+pJMTynp9vxjIW0Hz7Gsa7TWYa0W/xl0E/rSLb8c8YXuSKPgp8254Wf2aPM26yHCGKU92bluEIyK9t3uargUO9ajKiPZPluZHHa2i3AH1VewUvvEDXDLWLLB5JwSHOSB9Bl7U4X+rAPyF92KieuXPN5RQKlIuEL4vk1uxnbo7zP71SapBfjckexK3TK71rjjm5b2F+fjrwUUdDyngwbth0NOMt6TQnUL2NBGbotcC8BWfec5dd9ljpFtF64ziIPsIw4RGJpytOwgUnxrIeEOtFRb4AMkiFGG5rEJP7BIZwevdRAoeXNE+7xISwBP+Z5p90DgeW2fKUmMIWsJmsgAn6NLxryZOAuLRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Li <chrisl@kernel.org>

Introduce extendable swap device support - xswap.

An xswap device has no backing storage and no swap data section, so
it wastes no disk space. Creation is via swapon(2) with the name
"xswap", added in a later patch.

Zswap writeback is gated on whether a real (non-xswap) swap device is
active. nr_real_swapfiles counts such devices and is maintained at
swapon/swapoff only, so the gate reflects "a device exists to write
back to" rather than "a device currently has free slots". This keeps
writeback working even when the real swap device is full, and avoids
a double decrement when a full device is swapped off.

An xswap entry is not added to the zswap writeback LRU: with no backing
store there is nothing to write it back to. zswap_lru_del() tolerates
that, since an entry that was never added is on no list.

An incompressible page is stored uncompressed only because it can be
written back later, in LRU order. In this phase an xswap entry has no
writeback target and never reaches the LRU, so such a page would be
pinned in the pool for the lifetime of the entry. Reject it instead,
the same way a writeback-disabled memcg is handled. A later phase gives
xswap a physical backend, and the test becomes "this device has a
writeback target".

A VMA readahead walks the page table and can reach an entry on another
device. Skip an xswap device there: its entries live only in zswap, so
there is no IO to read ahead and a speculative read would take the entry
out of zswap.

An xswap entry is kept out of the zswap writeback LRU but still counts
towards the pool size. With memcg disabled the shrinker walks the root
LRU, finds no entry it can write back and is told -ENOENT without
counting a failure, so the accept-threshold loop would spin. Count that
as a failure; the worker then stops after its retry budget.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 13 +++++++++++++
 mm/swap_state.c      | 24 +++++++++++++++++++-----
 mm/swapfile.c        | 34 ++++++++++++++++++++++++++++------
 mm/zswap.c           | 34 +++++++++++++++++++++++++++-------
 5 files changed, 89 insertions(+), 18 deletions(-)

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
index a57cdcf2892d..4b541c50cd59 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -258,6 +258,12 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
+	/* No backing store: keep the folio; ctx->sis is not set yet. */
+	if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP)) {
+		folio_mark_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
@@ -515,6 +521,13 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		return;
 
+	if (unlikely(sis->flags & SWP_XSWAP)) {
+		/* An xswap entry only lives in zswap: zswap_load() must hit. */
+		WARN_ON_ONCE(1);
+		folio_unlock(folio);
+		return;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index da65d75ceead..90cd99c25dfe 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -899,6 +899,10 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct blk_plug plug;
 	swp_entry_t ra_entry;
 
+	/* xswap entries live only in zswap; readahead does not help. */
+	if (si->flags & SWP_XSWAP)
+		goto skip;
+
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
@@ -984,6 +988,7 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
 static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
 {
+	struct swap_info_struct *si = __swap_entry_to_info(targ_entry);
 	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
 	struct folio *folio;
@@ -992,6 +997,10 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	unsigned long start, end, addr;
 	pgoff_t ilx = targ_ilx;
 
+	/* xswap entries live only in zswap; readahead does not help. */
+	if (si->flags & SWP_XSWAP)
+		goto skip;
+
 	win = swap_vma_ra_win(vmf, &start, &end);
 	if (win == 1)
 		goto skip;
@@ -1000,7 +1009,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
-		struct swap_info_struct *si = NULL;
+		struct swap_info_struct *entry_si = NULL;
 		softleaf_t entry;
 
 		if (!pte++) {
@@ -1020,14 +1029,19 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		 * holding a reference to, try to grab a reference, or skip.
 		 */
 		if (swp_type(entry) != swp_type(targ_entry)) {
-			si = get_swap_device(entry);
-			if (IS_ERR_OR_NULL(si))
+			entry_si = get_swap_device(entry);
+			if (IS_ERR_OR_NULL(entry_si))
+				continue;
+			/* An xswap entry lives only in zswap; there is no IO. */
+			if (entry_si->flags & SWP_XSWAP) {
+				put_swap_device(entry_si);
 				continue;
+			}
 		}
 		folio = swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
 					      addr != vmf->address);
-		if (si)
-			put_swap_device(si);
+		if (entry_si)
+			put_swap_device(entry_si);
 		if (!folio)
 			continue;
 		folio_put(folio);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d59fa8220862..558c4b75bf92 100644
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
@@ -775,7 +776,8 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
 	/*
 	 * If the swap is discardable, prepare discard the cluster
 	 * instead of free it immediately. The cluster will be freed
-	 * after discard.
+	 * after discard.  xswap has no bdev and never sets
+	 * SWP_PAGE_DISCARD, so it always takes the free path below.
 	 */
 	if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) ==
 	    (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
@@ -1277,6 +1279,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		 */
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
+		/* Count active devices, not merely those on the avail list. */
+		if (!(si->flags & SWP_XSWAP))
+			atomic_sub(1, &nr_real_swapfiles);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
 		/*
@@ -1310,6 +1315,9 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	if (swapon) {
 		lockdep_assert_held(&si->lock);
 		si->flags |= SWP_WRITEOK;
+		/* A full device is still active and skips the add below. */
+		if (!(si->flags & SWP_XSWAP))
+			atomic_add(1, &nr_real_swapfiles);
 	} else {
 		if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
 			goto skip;
@@ -1323,10 +1331,11 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	/*
 	 * When device is full and device is on the plist, only one updater will
 	 * see (inuse_pages == si->pages) and will call del_from_avail_list. If
-	 * that updater happen to be here, just skip adding.
+	 * that updater happen to be here, just skip adding.  @val still has
+	 * the off-list bit, so compare its counter part.
 	 */
 	pages = si->pages;
-	if (val == pages) {
+	if ((val & SWAP_USAGE_COUNTER_MASK) == pages) {
 		/* Just like the cmpxchg in del_from_avail_list */
 		if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
 					    pages | SWAP_USAGE_OFFLIST_BIT))
@@ -3330,7 +3339,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3440,6 +3450,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3459,8 +3482,7 @@ static int swap_show(struct seq_file *swap, void *v)
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
index a2e0314db1cf..5603d283f9b5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -885,7 +885,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 }
 
 static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool)
+			   struct zswap_entry *entry, struct zswap_pool *pool,
+			   bool can_writeback)
 {
 	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
@@ -934,9 +935,13 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * save the content as is without a compression, to keep the LRU order
 	 * of writebacks.  If writeback is disabled, reject the page since it
 	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * to the active LRU list in the case.  An xswap entry in this phase
+	 * is never put on the LRU, so an incompressible page stored for it
+	 * could never be reclaimed: reject it the same way.
 	 */
 	if (comp_ret) {
+		if (!can_writeback)
+			goto unlock;
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 			rcu_read_unlock();
@@ -1093,6 +1098,11 @@ static int zswap_writeback_entry(struct swap_io_ctx *ctx,
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
@@ -1508,10 +1518,15 @@ static void shrink_worker(struct work_struct *w)
 		 * There are no writeback-candidate pages in the memcg.
 		 * This is not an issue as long as we can find another memcg
 		 * with pages in zswap. Skip this without incrementing attempts
-		 * and failures.
+		 * and failures.  With memcg disabled there is no other memcg,
+		 * so an empty walk is the last one and has to count.
 		 */
-		if (ret == -ENOENT)
+		if (ret == -ENOENT) {
+			if (mem_cgroup_disabled() &&
+			    ++failures == MAX_RECLAIM_RETRIES)
+				break;
 			goto resched;
+		}
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
@@ -1531,6 +1546,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 {
 	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
+	bool can_writeback;
 
 	/* allocate entry */
 	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
@@ -1539,7 +1555,10 @@ static bool zswap_store_page(struct folio *folio, long index,
 		return false;
 	}
 
-	if (!zswap_compress(folio, index, entry, pool))
+	/* In this phase xswap has no device to write the page back to. */
+	can_writeback = !(__swap_entry_to_info(page_swpentry)->flags & SWP_XSWAP);
+
+	if (!zswap_compress(folio, index, entry, pool, can_writeback))
 		goto compress_failed;
 
 	/*
@@ -1599,7 +1618,8 @@ static bool zswap_store_page(struct folio *folio, long index,
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
+		if (can_writeback)
+			zswap_lru_add(entry);
 	}
 
 	return true;
@@ -1669,7 +1689,7 @@ bool zswap_store(struct folio *folio)
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


