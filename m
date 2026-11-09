Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34DC606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FsLVeNhK
Received: by kanga.kvack.org (Postfix)
	id DC7FF6B05BA; Mon,  9 Nov 2026 00:55:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F7C6B05BB; Mon,  9 Nov 2026 00:55:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EA26B05BC; Mon,  9 Nov 2026 00:55:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A40806B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:55:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A3501405B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:55:16 +0000 (UTC)
X-FDA: 85414517832.29.FF73BAE
Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	by imf12.hostedemail.com (Postfix) with ESMTP id 50A8140005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:55:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FsLVeNhK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203714;
	b=1QsHN67zA3GxlibhVNG8gf685rPZPl+NdoWfTRk7QCuD3fZdYZ5ZSR55axtqvXcl5LMzoI
	dL5TaFi3GRKPf/98pOn4Ey+u/S9pM6mF8ulDvUo/YjxMgqzOtIbtmWNAJF5pCo9Bdvm6AZ
	f/HqSIzjbYAQ3Sg500ltNaWshYqOC/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgWCQWEjlKpefS1gCz5VRixmL/45vbZ8jqDfCMPKzeU=;
	b=lInUgjgr/UWSxx4twFD5dba94H8XVrl+AHBusXMJ1goFCx3W70nTRbs0VyD79RvLspxT/+
	HxFIf9H6rDP80V5/QtAzWlBjoopQ6laRByssgNc3DzOMnhJqbBR7CMgHI/+XEWOou98WnE
	M1kraOAFOZp+Gm1/XLILPr84QSlNCmU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FsLVeNhK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LIIX9oWLaqumHSHHiuBxv2+h/DOSLalAfUaDyeTWWbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203711; v=1; x=1794808511;
 b=FsLVeNhKg8ktmMC63rTwKaXqwcHGDmCRoHXjvqINJwaCmOILdbGRdiAsaU3r9nDSWLEQGed/
 a/e5FTLQM6QDj7GaJJjaA+lBExneDAq+4e6tHy9ucQRN4keD2hsuWoBqOZX+ezBIPOaxIJxNA1i
 HwFydiizDzLqYJtbrPFIU330=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 38166b020c202b3d;
	Mon, 09 Nov 2026 05:55:11 +0000
X-Mizu-Trace-ID: 38166b020c202b3d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 01/19] mm: xswap support for zswap
Date: Mon,  9 Nov 2026 13:54:37 +0800
Message-ID: <20261109055455.536925-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50A8140005
X-Rspamd-Server: rspam12
X-Stat-Signature: 8tcwhbqjsw75xfbe1hpqfbxmbah1fskf
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203714-731736
X-HE-Meta: U2FsdGVkX1+uZGShTqaAfNrEa/x+F7aVMJO6UiJBKbA3IirYUBcYVzrqOmi/XBnGUBBwKIi8gjmFKc/15NyWcMxbWCCiXqgs0gGy1H+fs3+loymX5dSMrlW9jys6I8huxrLtyIayy70pRPEnzW5H8qA096adR7d+t5/sVyEemhRxQGgK3bdwC2P3Ny3RsFOkpw2R1Wx/XD+vHwRNHKrKUbFjMre+UVEyXA3Sn0Ght+At1eFfK9MEDv4v3uiRNMeJTtrtI7fgubs9tmI7vQW4jSoHcBcBt4MBfrB+WJcV49GykZzmK27+wBvUPg4H/pecjf+Yr5qRF6tp9CFd5V5knXViW/z916s0kbbf9++Z/M2ImXPaIov4a6Nxy6ordflvjqIn1634f5K9o7VBQdiTbIp+jAw2nxZmM3NM3hUsh94Hu+juwIdXN9h4gMkXk/oTRm0eleQ6EPdwMumjExfBiN06N2cTY7epNMV/2JzKGtmeCyqbWQgFKPODPkv4LVlh9X2W1o1R0t+qg159TsjxAAuvaS8DUlvBWX6ssM9haYrHaTwGZ5alMB4kNwoQ0dQMho7BxiQQKEqQX6442nJuQ7Qvb2ukYYr+EXAL8VP5RdgCqH7hdZ9mrD6O7cW+unrXkhjiJOmeSjhn2JXnCFp+Ob93+V4bDqoKgGM5AINlIA5TInJLGpCVGyY2A6mj9JrUDDpokwUczuJUxo+ZPCU1fGZEQSwY6f0v3W8r/ZfK+ADU1fow8jza6bpi22ho1YTDaE787HDyVn9yW+4sbfFyhiagoDVuQF0PEWDP2UgASe827W7ssUkj4R6X6fLDxHEhYr+Rm/tOuxLDqCZ0I0G1N15p4rYcuLYQvvJBD0itNoVYtJD9/jRU5Pgkt6q3PVO6uxVVIRrjVqoOJf+c0weT09s660vi89FwubVeOvTMbpzTErEfmuac1TvFZhPrlW8MBAnomt3e/QCIbW1bA2m
 IOQfc+Ry
 n8Y/aHXTFla9MpVC7jMghB6h+seHuZbBOsNtGcxQcQgTSwmWDwj6Oj8QMSk6XbksKeDw6o8ey6ws2ShS5IHrtUr56a0yCcxX4ZvHusAO7D27jMS1gNLjQyQxJnLbtTo6Tw45orHD0/s0So4sTgsyIdPPgswkH5mL4E2C5TY1ym3d1Lbr9a2cuEEW8TYLSueezJL2E4/P1QEyogxgr2L36znipVbVV1Oq3yhhRO9prCHgCpkGlkFONXPgBD/bRdSdcGfvW9/E2aLgPIu5d6KOGLoBMAPN1dL56zzwQctMknC6T0hw5s4NUZXqLVrZpiL0nMrBLLn1gBJhEmmYrsgAru6q7z0CHtTeuJmzNtZ1Lb0BzmbFKyTmFLoJjxc34D3L+Zfx2NUA3ebOz7tqDz20eE2DJdVbsFit24SPI1UI1NXikMkve9GyIIvSYCYm2K3FUy5/489lx/80p6v5wEwR94EcHTtpueedXQssGIQt6+NxtnHalpcx2Otq17w==
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

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 19 +++++++++++++++++++
 mm/swap_state.c      |  9 +++++++++
 mm/swapfile.c        | 37 +++++++++++++++++++++++++++++++------
 mm/zswap.c           | 11 +++++++++--
 5 files changed, 70 insertions(+), 8 deletions(-)

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
index a57cdcf2892d..2285fb1735b3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -258,6 +258,15 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
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
@@ -515,6 +524,16 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		return;
 
+	if (unlikely(sis->flags & SWP_XSWAP)) {
+		/*
+		 * An xswap entry only ever lives in zswap, so zswap_load()
+		 * must have found it.  Unlock and let the caller retry.
+		 */
+		WARN_ON_ONCE(1);
+		folio_unlock(folio);
+		return;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index da65d75ceead..4c965cf99809 100644
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
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 038d2efe26ad..0b1fef65b6a0 100644
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
@@ -738,7 +739,8 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
 	/*
 	 * If the swap is discardable, prepare discard the cluster
 	 * instead of free it immediately. The cluster will be freed
-	 * after discard.
+	 * after discard.  xswap has no bdev and never sets
+	 * SWP_PAGE_DISCARD, so it always takes the free path below.
 	 */
 	if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) ==
 	    (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
@@ -1221,6 +1223,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		 */
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
+		/* Count active devices, not merely those on the avail list. */
+		if (!(si->flags & SWP_XSWAP))
+			atomic_sub(1, &nr_real_swapfiles);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
 		/*
@@ -1254,6 +1259,12 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	if (swapon) {
 		lockdep_assert_held(&si->lock);
 		si->flags |= SWP_WRITEOK;
+		/*
+		 * Count the device here, not after adding it to the list: a
+		 * full device is still active and skips the add below.
+		 */
+		if (!(si->flags & SWP_XSWAP))
+			atomic_add(1, &nr_real_swapfiles);
 	} else {
 		if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
 			goto skip;
@@ -1267,10 +1278,11 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
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
@@ -3274,7 +3286,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3384,6 +3397,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3403,8 +3429,7 @@ static int swap_show(struct seq_file *swap, void *v)
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
index 37d217860a6b..cef142d2ff85 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1095,6 +1095,11 @@ static int zswap_writeback_entry(struct swap_io_ctx *ctx,
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
@@ -1601,7 +1606,9 @@ static bool zswap_store_page(struct folio *folio, long index,
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
+		/* No backing store: nothing to write these back to. */
+		if (!(__swap_entry_to_info(page_swpentry)->flags & SWP_XSWAP))
+			zswap_lru_add(entry);
 	}
 
 	return true;
@@ -1671,7 +1678,7 @@ bool zswap_store(struct folio *folio)
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


