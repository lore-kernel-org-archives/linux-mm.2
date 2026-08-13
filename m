Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9601AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCAA6B0489; Thu, 13 Aug 2026 06:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A40E6B048A; Thu, 13 Aug 2026 06:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA0F6B048B; Thu, 13 Aug 2026 06:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 377176B0489
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABCE0C05F1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:21 +0000 (UTC)
X-FDA: 85095924522.01.009D86B
Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78182120006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kcP5bSfiHuupKn0Vcy09iG2p3e+/ghK4dC5c3Ng4+Bc=;
	b=i7IqpABG3fa8X7MOQ+hMwbn6d7B5AJHDxkvbOeJuF5kb7ByxJ36uitx4Vxoi7EH1PF+7Ic
	VEJ9MylyQrFLFmoTuGb3LaZFl7r+hE+zTheJ8QTwjGJIRpXelI8jvIuhe2PwCePIz8cg3J
	C0A7RxYg92nIoOli8FZerqCf2uxokEw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618160;
	b=v/7WtZTh4OnZSfIy0+z7B3kAmwN3jNM5u2hKtmWDe1g5kN1xkfZhm5BE0++FG9gJyfQ7Yu
	z0OvrOSmtXlpvowxDVTvoOyAXhflPLQ6Wo25da29NndSKAFHFe3fuvB7EeqHifok9xapBN
	v6N3k/5hPwVq9TlU2B47iUNVAp4w5UI=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 2bc8b1507b3315de;
	Thu, 13 Aug 2026 10:49:18 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 02/15] mm: xswap support for zswap
Date: Thu, 13 Aug 2026 18:48:41 +0800
Message-ID: <20260813104857.3450386-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ni7qs81afhucgq693aiu4k7ihbrfwwei
X-Rspamd-Queue-Id: 78182120006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786618159-410551
X-HE-Meta: U2FsdGVkX1/960muk8P7hiMhAT+Q1BDW1oJ3ahgMR1n9wzNfXlwIDNCCJBMdxT+FJY/JSP/sCU/HsAnnarA6MqtRPNsS7SkInAYHl5HKWAC7D9IiHhV2wUhyvLBoM5uch6i5GVOUTAYO9l+lPsJgHGIN1bxfnitWV+2p0hnxs+My6vyeGOcrqoWKzo9j9YfGZQjepgMNUE2ippvS/x8/XaUVb6vob4YO10sj5qhOUxuoJ7RaHGdFr/mC4PoeyjL8keoqpYRQw8D/swHTj0pCFTPhMoWK8ppVli5pLsXASZu6sQSxdpYipgKaSAz2y9xEMFlFZbbNf86Ay/m7EVNNXJdzBpu1vUHCmZ/m3beMoJx9Ikf+LytEwAoW/4KO37bZ0kJZXBwZbqRZyQCLx56UhlFsNGpJY8sDnS/01EF/toeOpn7PXGFNxEXWjGf7ReimKF4GuS4guazwxx6Tx7JfP0OQR28bPnRqQZxoZVooy8ImE6H3Y23803ivr7tUU8BH/WUCCER+z+tQq9YZGSTfO/f59qoZASGUWfpfERgBSqgL1DjgnSgWifd96KqZQx4iP9AbqDxYjPaUQmCpsIvsh2db50bXFvVHIYNwenyhrQMKkiy6qPrRkV+PLRR/PJ1p/igva4je6V+RrFhXXEcCLlK8zCHFZSTmWfB9fpwbvTzAo2WtIOLq3u5EIvmO9EXwuw3ViwTTinU73wqTDDxg+Uyd19yuGbFkQgQSzKyMXKZ2Wut4ajD2l4TLAIstMTgB0ATLs1hfH8JlFt5BAo9XZVbhXMoGPln+iyxzDQfOqhe/J3iLZofvgSwPJgC6caDJuA9WIZHkRVVg3Y2AZjOp2CBrIdZVGxeZXjAdANpwPNnZYVgxwu4sBd+WMfxx4Zq76zC9QLosz3Ji1XMRuOOmKxSt893u0MwHXqgfoknbuLifqjcgt9tQg4YwXP+JRKXxF+C0AI5vzJot+ZbT+77
 P0pA2lKs
 xZgsYsU3IyarPlIVFuKuNH72zl2i3yuP23jYIjdayk8ZeZIFVNY6jLmzwDcsgYR/7Nf3cGt62cE71N097UXlvhWmnE6Gt3Lyj8N+IV2kxw/WIWmqzK44fTFZjj0WV21QLeJfEQ+n19UVyyw1jau9fEv9MI2EzYibZitCV+knnS0f8Zrn7YZ46lDyw7fYvFIi99FTTGu5pUP3iSUaxO9bXD8H1eG8pshDycqy2lUzvc/HWJC3R7LmgqJ4R9kfdXjS0LkaM85ehQNFP+lFRKy0bqlzjme/uelIgO/XG92J8aq0O8VDwQ1/b1aiNl+HbCRIOUwlED2eVk7d66peWE/OUbat5Ui9kHYYL2QhfbTSToKJnCMfK+/xYNzPrJZrLbWJLBgZFDPzehAiQ+6W/8eCTcwXf2X2g6v4GsHwug+z00tNH0bn7XJm6cMlLB1/FEIggS+DJP9gZmiVDhMFLIopL2nenMYFJNC38vSkIPebDRBj9r3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Li <chrisl@kernel.org>

Introduce extendable (virtual) swap device support — xswap.

An xswap device is a virtual swap device with no backing storage and
no swap data section, so it wastes no disk space. Any write to an
xswap device will fail; to prevent accidental read or write, bdev of
swap_info_struct is set to NULL. Xswap devices set the SSD flag
because there is no rotational disk access when using zswap. Creation
is via a sysfs interface added in a later patch.

Zswap writeback is disabled if all swapfiles in the system are
xswap devices (tracked via nr_real_swapfiles).

Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 16 ++++++++++++++++
 mm/swap_state.c      |  7 +++++++
 mm/swapfile.c        | 37 ++++++++++++++++++++++++++++++++++---
 mm/zswap.c           |  7 ++++++-
 5 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8dd68733c955..12f1c63c15c1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,6 +207,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_XSWAP	= (1 << 14),	/* extendable swap device */
 					/* add others here before... */
 };
 
@@ -358,6 +359,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..1f3fa52131ab 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -247,6 +247,17 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
+	/*
+	 * ctx->sis is set by swap_add_folio() which is called from
+	 * __swap_writepage() below.  Since we must avoid the writepage
+	 * path for xswap devices, use the swap_info from the folio's
+	 * swap entry directly instead of going through ctx.
+	 */
+	if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP)) {
+		folio_mark_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	__swap_writepage(ctx, folio);
 	return 0;
 out_unlock:
@@ -479,6 +490,11 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
+	if (unlikely(sis->flags & SWP_XSWAP)) {
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e64..ebb2d2ac356f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -829,6 +829,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct blk_plug plug;
 	swp_entry_t ra_entry;
 
+	/*
+	 * The entry may have been freed by another task. Avoid swap_info_get()
+	 * which will print error message if the race happens.
+	 */
+	if (si->flags & SWP_XSWAP)
+		goto skip;
+
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4d4e3e3059f6..22db5dae3639 100644
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
@@ -1223,6 +1224,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
+	if (!(si->flags & SWP_XSWAP))
+		atomic_sub(1, &nr_real_swapfiles);
 	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
@@ -1265,6 +1268,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
+	if (!(si->flags & SWP_XSWAP))
+		atomic_add(1, &nr_real_swapfiles);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -2952,6 +2957,19 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	if (sis->flags & SWP_XSWAP) {
+		*span = 0;
+		/*
+		 * xswap devices have no backing block device and
+		 * physical writeout is skipped in swap_writeout(),
+		 * but sis->ops must still be set so that callers
+		 * like shrink_folio_list() can safely dereference
+		 * ops->flags.
+		 */
+		sis->ops = &swap_bdev_ops;
+		return 0;
+	}
+
 	ret = sio_pool_init();
 	if (ret)
 		return ret;
@@ -3160,7 +3178,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3270,6 +3289,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3289,8 +3321,7 @@ static int swap_show(struct seq_file *swap, void *v)
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
index 0407a448dd98..53837674d86f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,6 +1000,11 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -ENOENT;
 
+	if (si->flags & SWP_XSWAP) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
+
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1545,7 +1550,7 @@ bool zswap_store(struct folio *folio)
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


