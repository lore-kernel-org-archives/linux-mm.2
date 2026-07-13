Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD2DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62596B00EA; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B886B011A; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9841F6B0124; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4228E6B011A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDA4540129
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:57 +0000 (UTC)
X-FDA: 84984433674.10.71B3446
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D058340004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eF/xggNo";
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963615;
	b=yDOoxtVhzyN+EpfVdJeiQlPgWCsgTxzlBUwoD+PZ2Setl2S/yTT9PfJbptnZ/Xy37wYiA1
	P+WxgMZcqhw2wVqBVqivLdqf+/DmWcc3pA4MXq6w34HbU2WYiuXW2XKN0BoFGuhY8P3AVV
	0EfqCj2GKlGb6WLYtEAR/pGvGRn5+5w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eF/xggNo";
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963615;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpSh2Tg7mz8G30dVbtbKzWNwhEpOM6uFinjiY13RwHE=;
	b=cSVwFD1txWQgGjCsS52L+08ylsM40xxSHVEr3IXg/l1ZURHinjEWirgJEQP91ToO3z+KJ3
	zrgE3Rkk5HYY6Pef1lGMxajI4u0dR+EsNCPB2zt4oLf/hWHsc4P/GGHSJKjOeEP28T1Pth
	8zvFberIP36/GZvpHzG+bpqapx/iXgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0961D4393F;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFEDDC2BCFA;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963614;
	bh=PTUIwiXZC2UgMIw6+Z902E3vukWmaqBtCnBDKNTP2uM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eF/xggNoKGV851h6xMXRWFTZ2RxaMeVjvra2QZDhlR4sqB1HIDN86IJeryCTX5CSK
	 XUSsavUU8qN8QZ+ggkdmHpf71WQTxOpjiiTnGdHz44W5mBW/3+WU+Elz1/TFZwmRRw
	 /hykEsk9lFOyVAvxNubg/YWOAJ8GndIjr3JrprxcER19eeFzsV+Ci8VdOzUKoIq9tQ
	 1aLfzk4rOlVqBr/46xGe8BQrgnxBZx6H37os8/5U1MXNCa6lKZIgR28b/oulHQFxar
	 emZZAhGebLO8+12vSh2y+NGyw+EGpUmvHxTqy3F4MXlJmncqHhK5UfraNQEJxuQjFf
	 W++NDtXmOG+OA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CFCC44508;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:41 +0800
Subject: [PATCH RFC 03/13] mm/swap: cleanup and document swap device
 availability flag usage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-3-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=12401;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZELEcS43EUtrQZh/ZUjmqEURIG5xrZ5nw0j/vyLi2T0=;
 b=zV6MMRuZ0Hv3afqz6vL3J1WG1Y1E+dTwNo0mf/LJDx3BlpNvFTaECmW7AEXMUhkJ3GlVP5Y1c
 epTJ6zz3e+fAsUyjphZZzeeEu1Kj0sbIy3X1js03PcYKZczLpP857LR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D058340004
X-Stat-Signature: s3irznw859qt4scm6yjbaf8u47hus7yw
X-HE-Tag: 1783963615-476304
X-HE-Meta: U2FsdGVkX1/L03eo2lBf0aIaV3zcC52K559VCvT8KkovblE0EbQ8wk6Ik4EM4HnMudIVnnXYztUZZgVp79J3stLqmhfb5OjxJjb03/RUnxMHnAA6Q4y32HM3zp0qv5akhRprkDbqFu9ytdiHV2l5zPCjjR54fHtoEQWmT71gKZDszLY/fNPbKLK1A1JQodsW9N66rv1Rbivr/ejpdpHUQzxhZ/CMQ9loR2Hqp2b27GYjvntoNfugP1gh6XXre4fSV1QaQFznzDtBYjxadgnm2jn7b6M4tlYzeEcb8xf1xgfzie9PN8MUr0BNggZ+EaX9QvD99/plysfHVxzuK7QbTchsEmS/+3EyF6j494Pvgzs4HV7pK5CVY2v5M8QFn/mrmhLKdB55dB/X9W4PLWlM0oX5JmJseMGR+z1FnGWomxh60Y5PTFg9f9voE3JjOvGwYKUWsX0GtgxN6mX6KcNMKFayhrHcaIiVgRQwkmrj7OhmNqEls7DrD7ZwA+RiOZIYOZQOnWQ1R7PnOiVHrvh4o67J15YPZRol+I4s+7Q7JAoVWEw0s38Qz1EtsbOQMUDUIO+Or9x4ki4o7VvKWUztMhgfHQ+cHKifJzOsmk28rjIRE2nH4iKsvAvgbLW3OYqaVvZOJ7jyI44OzNBPLXpJqomq4QP02UJ8DhiYOIcexwNUh1zvnynFDV7z2+BIaQF1GY9OJl/QeeFkTT8R/CDzmhMTnw2ok4MGa9g4rQRtkaB/+mAh8hUHBuqrF3bXWvZS9f8ZTlyD13Tgn7KIgV1OMaUcVYTMwQVtk684kCkUT2hr4URVhF/19GpowuHuj/oJitTmoKuxT+WsO892ltx/dk6FdiYE+bubIinCbM87ZGCaG1okJasVlTj8gSDTFZ7LhSpsKe8E1MiWLxqWTU2RLCQ6LrFtZ/rsVrfbbAu/fFMzE8DuoyoANCPWYEEvF1WSU1NgPHDSbANyEAnO7Oe
 d4wnOBtN
 EwRXlBy4uKk+PRB1/yFhM3UcCqSFb6GqImwAtOoq/QPdrs+x0ulEUYqk7jXq9m05glrXQqHcxiLiCueH65COZO1Kw/F4WOMTSpjsKtvhjeIqwQHv1G1n/8Vzc9UgLx2/029COsTsvB0Cfh+BsVUHVAzwNmSBWw+zFN0Wclvc8HhoRc7kU5EjLFQwUVZfrIvAsvBJboF1G55aEofIaYpwZn2pQAj3F988nVEUYl2oEJgTsT8iJvHeOTNHQ2ZxkRT7q1a3penvnIwwPC2EoRdGeY05PKDcfz56+EuFtHMOKVSdoQzF3VQtkumcChvdhSi4XiLZiUtiL36vvGGdNRfpW2HnljIPG806dDzOA++syHMCUu1BeXszUii0w98RW48Fa028AAhh6+UTFePBVDnej0FUaZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Rework swap device flag and metedata handling and swapon/swapoff to
be cleaner and better documented, in preparation for locking cleanup.

Consolidate existing routines and introduce swap_device_enable and
swap_device_disable as the clean boundary of exposing or isolating
a swap device. swap_device_enable sets the proper flags and exposes
the device as an allocation candidate, while swap_device_disable
clears related flags and ensures no more allocations will happen.

And add comment blocks documenting the lifetime and locking rules for
swap device flags and their locking conventions.

No feature change, only code rearrangement and documentation.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  27 +++++---
 mm/swapfile.c        | 189 +++++++++++++++++++++++----------------------------
 2 files changed, 104 insertions(+), 112 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 696ed01709c2..a8ce05024cfe 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -194,6 +194,22 @@ struct swap_extent {
 	((offsetof(union swap_header, magic.magic) - \
 	  offsetof(union swap_header, info.badpages)) / sizeof(int))
 
+/*
+ * Swap device flags, except the ones documented below, all are immutable
+ * after exposed by swap_device_enable, and until the device is freed again
+ * (SWP_USED unset). The exceptions:
+ * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. Once
+ *   set, won't be cleared unless all reference to this device is freed and
+ *   swapoff finished.
+ * - SWP_WRITEOK: Protected by both swap_lock and swap_avail_lock, clearing
+ *   this flag also waits for all current cluster lock users to exit so
+ *   checking this flag while holding any of these locks ensures the device
+ *   is safe to use at the moment. Note: clearing this flag doesn't affect
+ *   pending IO or async requests, it only prevents further entry allocation
+ *   or new async request (e.g. discard) from initiating.
+ * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
+ *   is pinned for hibernation.
+ */
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
@@ -263,14 +279,9 @@ struct swap_info_struct {
 	struct file *swap_file;		/* seldom referenced */
 	struct completion comp;		/* seldom referenced */
 	spinlock_t lock;		/*
-					 * protect map scan related fields like
-					 * inuse_pages and all cluster lists.
-					 * Other fields are only changed
-					 * at swapon/swapoff, so are protected
-					 * by swap_lock. changing flags need
-					 * hold this lock and swap_lock. If
-					 * both locks need hold, hold swap_lock
-					 * first.
+					 * Protect cluster lists. Other fields
+					 * are only changed at swapon/swapoff,
+					 * so are protected by swap_lock.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 30ee75bdec40..a4701692d330 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1193,28 +1193,20 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 
 	spin_lock(&swap_avail_lock);
 
-	if (swapoff) {
-		/*
-		 * Forcefully remove it. Clear the SWP_WRITEOK flags for
-		 * swapoff here so it's synchronized by both si->lock and
-		 * swap_avail_lock, to ensure the result can be seen by
-		 * add_to_avail_list.
-		 */
-		lockdep_assert_held(&si->lock);
-		si->flags &= ~SWP_WRITEOK;
-		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
-	} else {
-		/*
-		 * If not called by swapoff, take it off-list only if it's
-		 * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
-		 * si->inuse_pages == pages), any concurrent slot freeing,
-		 * or device already removed from plist by someone else
-		 * will make this return false.
-		 */
+	/*
+	 * Force remove it only for swapoff. Else, take it off-list only if
+	 * it's full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
+	 * si->inuse_pages == pages), so concurrent slot freeing, or
+	 * concurrent list removal will make the cmpxchg fail and skip
+	 * the removal.
+	 */
+	if (!swapoff) {
 		pages = si->pages;
 		if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
 					     pages | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
+	} else {
+		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	}
 
 	plist_del(&si->avail_list, &swap_avail_head);
@@ -1224,21 +1216,21 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
-static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
+static void add_to_avail_list(struct swap_info_struct *si)
 {
 	long val;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
 
-	/* Corresponding to SWP_WRITEOK clearing in del_from_avail_list */
-	if (swapon) {
-		lockdep_assert_held(&si->lock);
-		si->flags |= SWP_WRITEOK;
-	} else {
-		if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
-			goto skip;
-	}
+	/*
+	 * Add the device to the avail list if SWP_WRITEOK is set and
+	 * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
+	 * SWP_WRITEOK first, so the device won't be re-added after
+	 * swapoff starts unless swap_device_enable resurrects it.
+	 */
+	if (!(si->flags & SWP_WRITEOK))
+		goto skip;
 
 	if (!(atomic_long_read(&si->inuse_pages) & SWAP_USAGE_OFFLIST_BIT))
 		goto skip;
@@ -1294,7 +1286,7 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si, false);
+		add_to_avail_list(si);
 }
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -1348,7 +1340,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	 * up to dated.
 	 *
 	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * enable_swap_info(), and smp_wmb() in swapoff.
+	 * swap_device_enable(), and smp_wmb() in swapoff.
 	 */
 	smp_rmb();
 	return true;
@@ -2963,58 +2955,71 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void _enable_swap_info(struct swap_info_struct *si)
-{
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
-
-	assert_spin_locked(&swap_lock);
-
-	plist_add(&si->list, &swap_active_head);
-
-	/* Add back to available list */
-	add_to_avail_list(si, true);
-}
-
 /*
- * Called after the swap device is ready, resurrect its percpu ref, it's now
- * safe to reference it. Add it to the list to expose it to the allocator.
+ * Called after the swap device is ready to be used. Marking it writable and
+ * exposing it to the allocator. Resurrect its percpu ref if it was dead before.
  */
-static void enable_swap_info(struct swap_info_struct *si)
+static void swap_device_enable(struct swap_info_struct *si)
 {
-	percpu_ref_resurrect(&si->users);
 	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	_enable_swap_info(si);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
 
-static void reinsert_swap_info(struct swap_info_struct *si)
-{
-	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	_enable_swap_info(si);
-	spin_unlock(&si->lock);
+	spin_lock(&swap_avail_lock);
+	si->flags |= SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
+
+	atomic_long_add(si->pages, &nr_swap_pages);
+	total_swap_pages += si->pages;
+	plist_add(&si->list, &swap_active_head);
 	spin_unlock(&swap_lock);
+
+	add_to_avail_list(si);
 }
 
-/*
- * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
- * see the updated flags, so there will be no more allocations.
- */
-static void wait_for_allocation(struct swap_info_struct *si)
+static int swap_device_disable(struct swap_info_struct *si)
 {
 	unsigned long offset;
 	unsigned long end = ALIGN(si->max, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *ci;
 
-	BUG_ON(si->flags & SWP_WRITEOK);
+	/*
+	 * If SWP_WRITEOK is not set: another process already disabling it.
+	 * If SWP_HIBERNATION is set: the device is pinned for hibernation.
+	 */
+	spin_lock(&swap_lock);
+	if (!(si->flags & SWP_WRITEOK) ||
+	    si->flags & SWP_HIBERNATION) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
 
+	if (security_vm_enough_memory_mm(current->mm, si->pages)) {
+		spin_unlock(&swap_lock);
+		return -ENOMEM;
+	}
+	vm_unacct_memory(si->pages);
+
+	spin_lock(&swap_avail_lock);
+	si->flags &= ~SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
+
+	plist_del(&si->list, &swap_active_head);
+	total_swap_pages -= si->pages;
+	atomic_long_sub(si->pages, &nr_swap_pages);
+	spin_unlock(&swap_lock);
+
+	del_from_avail_list(si, true);
+
+	/*
+	 * Swap allocator doesn't touch si lock, so looping through all
+	 * ci locks ensures __swap_cluster_alloc_entries sees the
+	 * updated flags, and no more allocations will occur.
+	 */
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
 	}
+
+	return 0;
 }
 
 static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
@@ -3059,7 +3064,6 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	}
 }
 
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3083,42 +3087,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mapping = victim->f_mapping;
 	spin_lock(&swap_lock);
 	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
-				found = 1;
-				break;
-			}
+		if (p->flags & SWP_WRITEOK &&
+		    p->swap_file->f_mapping == mapping) {
+			found = 1;
+			break;
 		}
 	}
-	if (!found) {
-		err = -EINVAL;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	/* Refuse swapoff while the device is pinned for hibernation */
-	if (p->flags & SWP_HIBERNATION) {
-		err = -EBUSY;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else {
-		err = -ENOMEM;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-	spin_lock(&p->lock);
-	del_from_avail_list(p, true);
-	plist_del(&p->list, &swap_active_head);
-	atomic_long_sub(p->pages, &nr_swap_pages);
-	total_swap_pages -= p->pages;
-	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
+	filp_close(victim, NULL);
+
+	if (!found)
+		return -EINVAL;
 
-	wait_for_allocation(p);
+	err = swap_device_disable(p);
+	if (err)
+		return err;
 
 	set_current_oom_origin();
 	err = try_to_unuse(p->type);
@@ -3126,8 +3109,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
-		reinsert_swap_info(p);
-		goto out_dput;
+		swap_device_enable(p);
+		return err;
 	}
 
 	/*
@@ -3187,13 +3170,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 
-	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-out_dput:
-	filp_close(victim, NULL);
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -3615,7 +3595,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/*
 	 * Allocate or reuse existing !SWP_USED swap_info. The returned
 	 * si will stay in a dying status, so nothing will access its content
-	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 * until swap_device_enable resurrects its percpu ref and expose it.
 	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
@@ -3773,7 +3753,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si);
+	percpu_ref_resurrect(&si->users);
+	swap_device_enable(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,

-- 
2.55.0



