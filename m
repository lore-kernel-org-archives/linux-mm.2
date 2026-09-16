Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93076C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBFA6B008C; Wed, 16 Sep 2026 06:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625E66B0092; Wed, 16 Sep 2026 06:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497436B0093; Wed, 16 Sep 2026 06:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 192D46B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:19:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9ACBB120679
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:46 +0000 (UTC)
X-FDA: 85219229172.15.98A4063
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8E5CB180003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789553984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bQWLwqXOI0bmBcK5RhQh1o8Fzk/Jhl1Y0El6oIoNUuU=;
	b=auopAl9lInSkv6QjMeOAPoJpGRk9Dn5udkCisV8/6zO/DTxNOhvkW+zHgtriTegNCyOGxb
	09TJWrcNHoWHm8seCzPLEMUl4xrnkmeSloagcK/9VZoFiPsV/TU9H9AXVAmLpto12edxNv
	hwnBFYVq63RvdbyJ4WEEgWi8SiKPx8Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789553984;
	b=wAAcOv4TqIt45q/zDwdo478tDE32X6zZ3dmG9q3ve0niTv0O26TOdOFOWolwwmjbnFLtoY
	ctWHOJ0lFRx4lTuhS6Go7W4SlcwKKBjlk2jY8C92iFkuoj9z+DwKgvpy8/4Dgqtr6FIgO4
	yxWABEAX8sGYF5DGEiIfCjhDccfHbe4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dbbdf434853dd29a;
	Wed, 16 Sep 2026 10:19:43 +0000
X-Mizu-Trace-ID: dbbdf434853dd29a
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 01/14] mm: xswap support for zswap
Date: Wed, 16 Sep 2026 18:19:08 +0800
Message-ID: <20260916101929.149106-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hogng6acspqx8bnuc7zip3hijifri3bu
X-Rspamd-Queue-Id: 8E5CB180003
X-HE-Tag: 1789553984-565709
X-HE-Meta: U2FsdGVkX1/+K7QIaWKh2a59suSWaZdj3cJGvmRtamOzJ4oteStUI6i8iCEKOyX7Al0cneX8IRivtcf+05VSXQafMIfJZT7C31oqBoMwfsy7wFkmrMNUZCn0N4Ic0GWDu+Uy+0+9IKVgKOLOIiTdy4sGkmusl7Ym/KROYoZeDUT0QNGPWftSb+wEtmJeQIdKf1pRvHRHfa1yoXqY2VGvkQpAvFhnjLavbgRWP5OtpJWoDqbiXzqKlnql45mY0yCNQznm5ll4yRGJfxhEg3kREPtvPWJFpPAsLbxxZfN0SZzEX70r2dtJOJ7u/HM+aObobKWX9QtsAjJ9PwJTODHMCcaEJezHE/7T27p9K2kRr4oMYyM0BIgVzrCbRZJo4dHK24dSwNoJ5CEN+r6IB0xR8hLRB0b1Wt+367ZV/jXPARGGFr/1xiOaXA9w0N61zwAZKK9b3b2rgdZp9zE7pk17lqZVUOQARhPMGmsEIaP2I4tNoGJtyGZpeNcFmsk45RDEM5FrV5DIG4gjUGPSfLdRRmhLVyfwTKt98H76L2xIvNDf24CzSL2pxIQMWV/y9LAUSFuS+zf2tljBBpO2UgRQubr/c71XXT5dChNKJRcfrf59e3dXfKxKsvgtGDROO9lZxiZLLwAjwQWYQ4QYaay1F8PvUlPq2sCbVJkQHmjTlEK/o1Fg9DDgq8+aO+A1geaPab3vSyz1GcNSZRIPxUaVdV08zJk29vJwNsOP6hFEJRL1lsCx4zqDe5cqCm/z2QT5K0clb2lOUP+h6SKzWvczN8cLuk2wp6drWNuU9cbya+StZUAeE1AdDVFvZu3Y31hG8zMCIhsTav1ylvQXxeIsojDg0MThyPURGXAHEdxY0vNDs+2cf+r99g91dtqrTJcjQZgXoO9rvJdA5zruD+MUS+eKXlTJI564P2z/SsG4S3rMKqauvvK0eFRgHMlt/xow9wMK28Kvob1pYBfHE36
 m8UyNugk
 JvnU79hpfk8zGjfg5QfT9OXxMgifEdiealjkTsA4wQA0ZaNMbcBYg3kTcMqaevl9xe8jIa8CtOnI+ipYpkux7wETViayp2aqwVKFe2VFknuXjHEnmBsWDi3VKirmmDjSRBPIhpKtUUTwhquWqmstHVTxl7xFn4dfyCWgKUlf6KJnGd00/QbQl2mAv3UBJep1UKafB43O3ePadXPEUB0Kw3zL2W84DhDQl6B7JS1ZuoKQlXJstxdXCqFRIAmBkVkxAvEYvJk9/Xruw9ZnqhFdd6LR+rLQWGg/G8FL2SaocyTmqrlQq0M+brACURlyx2XCa9+3h
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

Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 19 +++++++++++++++++++
 mm/swap_state.c      |  4 ++++
 mm/swapfile.c        | 28 ++++++++++++++++++++++++----
 mm/zswap.c           |  7 ++++++-
 5 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 43155e122b5c..b4331ca4759a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -201,6 +201,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_XSWAP	= (1 << 14),	/* extendable swap device */
 					/* add others here before... */
 };
 
@@ -375,6 +376,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..d685c2e2429a 100644
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
@@ -482,6 +491,16 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
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
index 625c185a1ca4..8bba3e533b28 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -837,6 +837,10 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct blk_plug plug;
 	swp_entry_t ra_entry;
 
+	/* xswap entries live only in zswap; readahead does not help. */
+	if (si->flags & SWP_XSWAP)
+		goto skip;
+
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 280dd906eb18..13ae681acf07 100644
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
@@ -3266,7 +3273,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3376,6 +3384,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3395,8 +3416,7 @@ static int swap_show(struct seq_file *swap, void *v)
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
index 507f2d19fd2a..96fb993d18cb 100644
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
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1567,7 +1572,7 @@ bool zswap_store(struct folio *folio)
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


