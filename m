Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E525C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918FD6B0098; Thu, 27 Aug 2026 05:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0BD6B0099; Thu, 27 Aug 2026 05:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D4C6B009B; Thu, 27 Aug 2026 05:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8026B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DABBD14037C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:29 +0000 (UTC)
X-FDA: 85146566778.13.DE11F1B
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id ECEDD40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823928;
	b=dBHxUk8OOZNAWdfJ0OBP/KrFIrX2E8CrDwJRR3YIlG6OBemHcGqi0lX0waZ4UBHBQE+UvL
	OALRsdGVTAWSypcmatbSnQX4ciyxzJxALkEeY8zPNxdD3zqgX3WkVBLYzgdjzNByR56kpY
	PulNQoBtZ2zXIt3ctij61wXyppTNdLQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwfwXJ8I7AGOMssDwXYUAmTfkg9nuGUYorcEoUef4yg=;
	b=6S49+8AgCg5fAs36+1x08mZTsHULE+ZFNEWl7Ek9Q+iz/mwJHIM4erXKV65i5d9T+xxar3
	gHL9Eny3aQcjISaTqwfORl+3lPkuI8lYX3DLvLraENunjvbGXADBeitEtHDse22Q3x+aMK
	qV/J4/OAQ3lAYbYXQHiwBuDTSh1t20Q=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9b7578548605922a;
	Thu, 27 Aug 2026 09:45:26 +0000
X-Mizu-Trace-ID: 9b7578548605922a
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
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 02/16] mm: xswap support for zswap
Date: Thu, 27 Aug 2026 17:44:52 +0800
Message-ID: <20260827094509.1016740-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECEDD40003
X-Stat-Signature: cq1o89i4nxxsdyin9emfp69k67s9cmio
X-HE-Tag: 1787823927-48496
X-HE-Meta: U2FsdGVkX1/7aNtx+gtflQMxiAVHqcLcJJsEnejRkhK8NBbUpsWyJVkLdr3xbr/rpM+XWtAyYu3c1N1wLoQYUOYOOWYFgLmJVq+NrP477jnP8YP+7RSunMg0lYVds9wTPURNd99gW1A4Cac0MOesadJ+IMwoXpwCLIle/t8YEyPDdbzWe8LR69bA/u+SmiM6O9PPelhdkua1izjf5fSX8DuNN11wakM6Pv4RboFWMCkbix91/2BQkZ1Lr5rZPZ0p1WIHQzKqfbuWfU1oWt2eCcvp8/fABL0Khi3QbicmNT7PTJ2IEOI8mwFeWxEBBhNFAaN9ye5X9u+ZCd5YNbZ894B08VPM8PZGpKeT+v9bINSqyi3W8a+dmQMWo1mpDnyeQvgN2g6xxvyLPhTd3ROsm/aiKyp7FYwFDiPgDLNaa6ILFgRRHgdy5hTwm+SVG37nTT8whgI4O8cvUJsN3XnJjJgjPD9/H67b2IpljOKY9bcpKU+xG34/D70Ifzd0LBNwO0XyJbjfJfG7RRHnFZNdaS2wH+gZ254sPMkkqJnqYPC+rHTl2tET7bHe7ofvW108VGb/xhsTDIyS4EG4OpVTqZ3EmC+AQe97+rTM6S/IL23xrACsXk0PMATzpU6CS9xhl0H9XhO9wJu7EXfex9hNs1cSD/KjcJ7qz7UOu2xqmWsNEPp2No04JDdNtTixXZBpLEQXLHUJdLjXhgT3yJgEJKsFFwc3aoo0HuW16GpPDB4247PVWPC4kRDC6SkTNQsUHecSiTwoWbg+a3rr+PPdiUomdj4mr7wBA5KQiZrAqEIB31dAW1c4OpDLYU0EMoewPp8uuJ4BsYgdYHUc/NN4vf5L9N0a1YTRuPWheMdSL59wBHBDf3/0AOZxV5SU7IiQ6BnY9zktazLK58QsFkRPFJbC6fHwJizw02UenPdzVWIsQU44Z4dCH1dTq09GtAXzpr2n9zlAFlebWcdzrJC
 Qdxk0vXs
 CsID1chsVbPnvHpAAw8hG05xPS7amLcRaBvwnWRvLuXR2XNcllZcnGRi8CZ/HA1EuUA4tnZMWGbPXej6CarC2ZPoxvhaNPDgIPez1yuv8CEK+/xV2JsdDSAtkOqiekv06C8PhCmu1/s9vpJGU2Gx3pkfy6iX4pSJChZ6fbAXSZhibd1FSdA43ZKFYVhB8uO+Ec0Q+hda1AIroi2nj2SSUSW9jCuJXn28HnX+/9ME9pMqtQmngXDVAGUjHLsw3aUS5L74zVPCuX5uP5Waq+oj0x4N1VxlZAracjHhjxSoRTTXYU9ZhMfVEQbPAmnca+vNl6zucMOVdKrY6FKQFoasgD47A2jHRg24wLRlI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Li <chrisl@kernel.org>

Introduce extendable swap device support — xswap.

An xswap device is a swap device with no backing storage and
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
index 5658a1634b85..787fe463dcbb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,6 +207,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_XSWAP	= (1 << 14),	/* extendable swap device */
 					/* add others here before... */
 };
 
@@ -356,6 +357,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 88962571cb93..5483c943e3e3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -248,6 +248,17 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
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
@@ -480,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
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
index b76eb3d876fd..2eedb7a3d7bb 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -830,6 +830,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
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
index 53bf01d5f7f1..5aa1ffb97df8 100644
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
@@ -2959,6 +2964,19 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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
@@ -3167,7 +3185,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3277,6 +3296,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3296,8 +3328,7 @@ static int swap_show(struct seq_file *swap, void *v)
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
index b9948d4657d2..064970a4393f 100644
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


