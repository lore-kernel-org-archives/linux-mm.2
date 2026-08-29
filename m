Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC15C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8016B009B; Sat, 29 Aug 2026 03:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E986B009D; Sat, 29 Aug 2026 03:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D396B009E; Sat, 29 Aug 2026 03:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8056B009B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B67428067E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:19 +0000 (UTC)
X-FDA: 85153526598.02.C17967B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC61140002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HsQbwpYD;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989637;
	b=Oz0cdfahGIR/4+whnn2HPYkPLj3K0w3kdXSXLpt70a8jeLl3yibm5Y06VN45xBrwRiZyaj
	csaEIbf7UpXlgtFOMQ/q3zdiOkJQyU/9Wp1OqTfjXIc5OUZafj+/L00N3l7hKpyGC50H9J
	BxWyGQZGgFa4dNDqHhyEl3fzQinHA1I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HsQbwpYD;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wi+OGZ51DE6sVJ1HATvP7JiivAEZJcFvS/FmT0stnCw=;
	b=z1nHyE2S+rE2+RG4k2nIayZmCzOBQFJBW3FdNGi9yoAWsuBtlYZ2Zl3fCQP/OHHWzm2G29
	07tSg/t7Jlo5mxmNCjXo+r2Pva7NVxsQmAM+Ivw1mmMKR8uFX+jYB6dUVBmH0jojQLVB+F
	5K4Hze7hsTn5GrdZBzGyGwlL0tRkjcE=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1767652a91.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989637; x=1788594437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wi+OGZ51DE6sVJ1HATvP7JiivAEZJcFvS/FmT0stnCw=;
        b=HsQbwpYDzUAhmXVBzff6HIzeA4nGY3B8zgQbbVutN3F7wOJhsJETQohLaPMt3UvNoR
         rMHISHadmcEeHyoN2Tkaytad7L3IaHosgBtj1vwVE/o86rXHfdmQLhkzv9leX0qVsb/U
         pousp2BADdIXNv7w38tTi1Gx5PG2aw/St1sc8Jaw0CjOepLNGnSuFrquOoSnsrxrfrzD
         BwtbPwcJ+2jx/dpSilrT25cUeg6j70ChzVZbgJjtlL8ifSpXfSFoQAbsmhynefQ4FhXH
         RfKsnxFfU2P2oK54pGGMY37n60pKdpRhZLfCgNerce6lfPGjYS54vjWua9TNvEJrpfcf
         mqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989637; x=1788594437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wi+OGZ51DE6sVJ1HATvP7JiivAEZJcFvS/FmT0stnCw=;
        b=B77DDzbgUNdSKibqi9tAhbLt/T9uVyhxxysBG5Biv+jFuIiGmbzUAVusyoQh4s//Tl
         f4henlodNc6GVTPsXQV5oARlWi28fOQdJJhfBCJE481mv3t+dVmW2o/DJeDyWbXzqu+L
         3DgwaTZBY9Gn21X0/JFJ58zg67ZsJWMxPPLu3ywiVWeoReF7fj3CuHTsC1v97811K9n1
         nnGTCM8BbT+/C7DA/JEgJSP+dsHnSd9jUvxBit0UjwyvtRkB+5m6SbQ6ek4otxdkHnrY
         +Cpw6E/+EwuT8/ZHAURhDesbQ8QW4WaWg8oQ7rZHwkxX3oLw2Hr3LUnbrs7t7cMJoc7s
         /+NQ==
X-Gm-Message-State: AFuF++k8QWzKVTpoBDBzjq2x755AP9rxbhpRp9+ggnV3vzLkZsHV866M
	1BGes+yh5bOSpwpEl2aiJ+W201aynWinYbF0q5s8uvT3FUvxRZILPg6WgMTqrA==
X-Gm-Gg: AYBFou1wNWPZaXVx4JGvl9vKKiI+qayhZnP4l9EMtSZopAW7uXaNs3javQ4lVmK0SEl
	aaBYlWuZnpGtU8FmzdswnEc30oJW5AMfsR7L06L8HwASE9R2Y6c/YmV47AGuCHEn65GC9b/k5eT
	1NgJGrKKIQ+WtIAri3KFNpaCDTjNHbG5V0zMRl/qzEJfPPr2wfHFKVrhmwlDd6FwiLrLsRGn+D1
	MbYLLurfnvJpr2hwZ1gtEUjYfWZlxXV28YRz+QGFfJikyKnMiTie/O2AdoLcVlpFjfBBqg8KFin
	4ZzQQwAKP0fIhuyfjizbwEHtQiIxw3y4mu0MWCV6QFSFuY2muVgp4I9SnHO9di0hb6ErFC+Wih6
	V+Rw72FWZySpPAY3lslyQFDzRcxc3C6bLfdiXTsq5WNORtB2vAeihyVMbIPa9v2WNMte+tmwBmh
	24hqRh4/kEb7i8zmM3WOxV5WsTgbqsNFqNpRzE4ZaeQ6S74ZF4l6geBN2gV/JaxbNY0RLDjlM65
	J84a8Z5Tux53yEaZ55tRC7FBriowOqxAukYRNc=
X-Received: by 2002:a17:90b:50c6:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-396d1017316mr23143867a91.13.1787989636494;
        Sat, 29 Aug 2026 00:47:16 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b186803asm10574548a91.11.2026.08.29.00.47.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:47:16 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 03/13] mm/swap: cleanup and document swap device availability flag usage
Date: Sat, 29 Aug 2026 15:47:08 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-3-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k3gnm7gut7g7j4q9dmk7nmssz9oyireo
X-Rspamd-Queue-Id: EC61140002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787989637-88417
X-HE-Meta: U2FsdGVkX1/C2QGS/MV9D2BRGy1esw+zstD2w/wW5s2A6Kh2WH6yT048QZT9zT0ENldnQ4jsOHN7TcCOD+gi8IBDpyHi1G+NcMufLX5fHtXVhFV1vUFHKa3ZminSwAf1h0+CzWj4IIPuSI2IORk4Gn6TnHTTmJw1cGLdzSXymyho8V/yp1UIsH2+FcbvxTQo9udmVnnOSmeGYojTjLj1Fw934dSSMersoYWBJ9GvO/vw1FeVy8OuDBFzU16HtwWE6gSeri+GiBjDjF0xGhfFnoq8zaUZosOkBoK2pBrdtPKg3/glbnHSovnUEub/87QyEIgEYb5v7gLgZdQ9PMqfJgpW2xeNF0KbV4JvBFfLSjU4vL1pLqrapVAiUia22EKAkNfYvCBUW7oeZaZJYwBQ0SIp+xMfgeaEcRdSh2gH4cF5dXF6opZa4TaS4pvfKI/0SBmZsLOa/NW3ylmS5za2T+osV3RACwO0nzUzYYeoLUE7i+qXvKGnWtYu7cp30GwLLSgk69oTD9fA1kYuJXguUdlWD4wazoGJAtXO8SgNOn84qc8EvuWKqXLL9/DFOAHGWVZN3AwTsUutDQ0nvQMdivRcUGtA1dYI6rJePWtBRLCAqPWLuTVsoL0aHwRi+ZwLPIoWjlW4hBjACeN1yaIWrrLSv+IWuFFLfI3ADiYvtfZWO6cU6oTFoJccY1BQNpIl42kr0HALe/vbacId+4+nVsf2u/65URmITMKnXnxAlvQW2n86XWHNR+bIBsmpnHTVHaDvUC/nOkOQHaEPxVa7obNzsQ5K8vCco7qw0eoBDuJT75K83ERLqmYqsrWVRSPZ/V1dEhc5hG7WDqJN3AIAAbpprkeC0XHd0lOVxTIgf5i+N0mMCFFNoFWRiqyn1d7RbBMTjl+1p0sqSxzvVNedh9WJlOfFsCNjgN6MzTUsaBDp2BaUi4MIt6Wg/d3HTPWXA/yw302AfEc1TNxKJRn
 hZd196El
 hdKorBBETRyLKIT2aNH2TCXn/b7ukACSI/Sd2LV4/zI+hgO+GsDunwEGhbcdTGGpuRgmMrV80vFarlFC2zBAawAgWJ21hBqkr6amZM27dSm2PFN49vo8CMdKD3AYHQFMqDgdgMzFYFt608iBpnEBkHWbBUjLUDN/tK0KjVamPceYbARXv8MU6WbWFViDF2lXLHvlP5xJtxzKhT8xIb3meA3qTbK8/ldvWY+/Gwtykg3s4vOpn3lqrQQjc8yGXpNIxQGc/seydApxG7TXWDK/N00AocuszGvahTc+/J4bkcCA0KcQCHMaXpQkJVTd1LwTgvkZvJisLK8HNiVVBR4yqVIZ0dOZbIsuOQjx4t2tX2zuJoheZ4H8981WHUok/derEUayzYOqjo5TsV5YuOounLpXAbWMREtV7YEZS+ipJKfMq7Dlb4DDAekZedTLLt/llIuGo78k3gmTycdw72f+42sq5Hk5bIX+Jkbhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Rework swap device flag and metadata handling and swapon/swapoff to
be cleaner and better documented, in preparation for locking cleanup.

Consolidate existing routines and introduce swap_device_enable() and
swap_device_disable() as the clean boundary of exposing or isolating a
swap device. swap_device_enable() sets the proper flags and exposes the
device as an allocation candidate, while swap_device_disable() clears
related flags and ensures no more allocations will happen.

Keep the mapping lookup and disable transition in the same swap_lock
critical section. Otherwise, a concurrent swapoff can release the
selected slot and swapon can reuse it for a different device before the
first syscall disables the swap_info_struct it found. Drain the cluster
allocators in the same helper after dropping swap_lock, so the identity
transition remains atomic without holding the lock over all cluster
locks.

Add comment blocks documenting the lifetime and locking rules for swap
device flags and their locking conventions.

Apart from closing that lifecycle race, the remaining changes are code
rearrangement and documentation.

Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/swap.h |  27 ++++--
 mm/swapfile.c        | 207 ++++++++++++++++++++-----------------------
 2 files changed, 115 insertions(+), 119 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5658a1634b85..d9e535cd07c5 100644
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
@@ -262,14 +278,9 @@ struct swap_info_struct {
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
index 46772d0e3e68..d7115b9195a6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1199,28 +1199,20 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 
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
@@ -1230,21 +1222,21 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
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
@@ -1300,7 +1292,7 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si, false);
+		add_to_avail_list(si);
 }
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -1354,7 +1346,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	 * up to dated.
 	 *
 	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * enable_swap_info(), and smp_wmb() in swapoff.
+	 * swap_device_enable(), and smp_wmb() in swapoff.
 	 */
 	smp_rmb();
 	return true;
@@ -2977,58 +2969,87 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void _enable_swap_info(struct swap_info_struct *si)
+/*
+ * Mark a fully initialized swap device writable and expose it to the
+ * allocator. The caller must have resurrected its percpu ref first.
+ */
+static void swap_device_enable(struct swap_info_struct *si)
 {
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
+	spin_lock(&swap_lock);
 
-	assert_spin_locked(&swap_lock);
+	spin_lock(&swap_avail_lock);
+	si->flags |= SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
 
+	atomic_long_add(si->pages, &nr_swap_pages);
+	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
+	spin_unlock(&swap_lock);
 
-	/* Add back to available list */
-	add_to_avail_list(si, true);
+	add_to_avail_list(si);
 }
 
-/*
- * Called after the swap device is ready, resurrect its percpu ref, it's now
- * safe to reference it. Add it to the list to expose it to the allocator.
- */
-static void enable_swap_info(struct swap_info_struct *si)
+static int swap_device_disable(struct address_space *mapping,
+			       struct swap_info_struct **swap_info)
 {
-	percpu_ref_resurrect(&si->users);
-	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	_enable_swap_info(si);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset, end;
+	int err = -EINVAL;
 
-static void reinsert_swap_info(struct swap_info_struct *si)
-{
 	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	_enable_swap_info(si);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    si->swap_file->f_mapping == mapping) {
+			err = 0;
+			break;
+		}
+	}
+	if (err)
+		goto unlock;
 
-/*
- * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
- * see the updated flags, so there will be no more allocations.
- */
-static void wait_for_allocation(struct swap_info_struct *si)
-{
-	unsigned long offset;
-	unsigned long end = ALIGN(si->max, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *ci;
+	/*
+	 * Refuse swapoff while the device is pinned for hibernation.
+	 */
+	if (si->flags & SWP_HIBERNATION) {
+		err = -EBUSY;
+		goto unlock;
+	}
 
-	BUG_ON(si->flags & SWP_WRITEOK);
+	if (security_vm_enough_memory_mm(current->mm, si->pages)) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+	vm_unacct_memory(si->pages);
 
+	spin_lock(&swap_avail_lock);
+	si->flags &= ~SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
+
+	plist_del(&si->list, &swap_active_head);
+	total_swap_pages -= si->pages;
+	atomic_long_sub(si->pages, &nr_swap_pages);
+
+	end = ALIGN(si->max, SWAPFILE_CLUSTER);
+unlock:
+	spin_unlock(&swap_lock);
+	if (err)
+		return err;
+
+	del_from_avail_list(si, true);
+
+	/*
+	 * The swap allocator doesn't take swap_lock. Looping through every
+	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
+	 * the updated flag and that no allocation remains in flight.
+	 */
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
 	}
+
+	*swap_info = si;
+	return 0;
 }
 
 static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
@@ -3073,7 +3094,6 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	}
 }
 
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3082,7 +3102,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	unsigned int maxpages;
-	int err, found = 0;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3095,44 +3115,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		return PTR_ERR(victim);
 
 	mapping = victim->f_mapping;
-	spin_lock(&swap_lock);
-	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
-				found = 1;
-				break;
-			}
-		}
-	}
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
-	spin_unlock(&swap_lock);
+	err = swap_device_disable(mapping, &p);
+	filp_close(victim, NULL);
 
-	wait_for_allocation(p);
+	if (err)
+		return err;
 
 	set_current_oom_origin();
 	err = try_to_unuse(p->type);
@@ -3140,8 +3127,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
-		reinsert_swap_info(p);
-		goto out_dput;
+		swap_device_enable(p);
+		return err;
 	}
 
 	/*
@@ -3201,13 +3188,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3629,7 +3613,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/*
 	 * Allocate or reuse existing !SWP_USED swap_info. The returned
 	 * si will stay in a dying status, so nothing will access its content
-	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 * until swap_device_enable resurrects its percpu ref and expose it.
 	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
@@ -3794,7 +3778,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si);
+	percpu_ref_resurrect(&si->users);
+	swap_device_enable(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
-- 
2.55.0


