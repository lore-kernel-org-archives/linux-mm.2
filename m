Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B22C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D8A6B0093; Sun, 13 Sep 2026 03:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164766B0095; Sun, 13 Sep 2026 03:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1876B0096; Sun, 13 Sep 2026 03:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFF6D6B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:50:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14DDDA0647
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:32 +0000 (UTC)
X-FDA: 85207966704.08.ECBB8CE
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf07.hostedemail.com (Postfix) with ESMTP id D075540002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oA1tP1X0R2e0rR+b2T2G2virHDWJXVhQDfWGWv0OQ+4=;
	b=gAK3zpYoggHRvvVwK0TMNkN6TrV59ZTKz/UsLabu2MLoj6u1sJqtrlwr/sTOn/jlPi3i0M
	zVApNzKZOQRo7ozKFBIwvof51rylGQpTKPDesWhZUYTGMwUtDCo6YEaGFi86ZQve/V56Kn
	3Xis6U9nB5fZo4ERaECQYF4ikf69hZs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285830;
	b=Ae7VT0UGfUStW0VPcs6JzhxTaoayZ6j4bKYSJTB2spEcKas1igjLFsZy4ccS8oxt9Wh0MS
	NI97Cv7ZvUjk2BZSe1nT119f+S0coBzgzQYZ6HhvdJBSXLmZwBXvRAoKYyajBDjEZuNvJ1
	z9Cy96Kp0TpPKaEs0XwmpXeCnB/IHfw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4b6b428f292db963;
	Sun, 13 Sep 2026 07:50:28 +0000
X-Mizu-Trace-ID: 4b6b428f292db963
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
Subject: [PATCH v2 01/12] mm: xswap support for zswap
Date: Sun, 13 Sep 2026 15:50:03 +0800
Message-ID: <20260913075014.1732524-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D075540002
X-Stat-Signature: i9g3ajbe84ofdc53oqj1dzjsky5ra8y8
X-Rspam-User: 
X-HE-Tag: 1789285829-914278
X-HE-Meta: U2FsdGVkX195lm5ibZg5E8ZM3z15+eLUlj3Kik4O8yvBOMRtVERkmoK9Vdn0PF5QJMrLqUSj3rw8Yjfy40V3oF5yIzHfMDVa90YFLNZjtT8hB7BiRZmqBaeZLPotm7wiYvS/+IGeTfnJSJsRT6FBM3cX1zIUOMnsxwcD2JRY1tp++DZeR5bRQ43ZJ3vt/sy8MOD4ZJ7SuE/0CtxxP0123WXYn/sFUoYd2dQhf4bxe9BpUt3O7WJmyMNn7JVazum/Bs3/hD7JQN9izZj8jSYYSBnqro3XlypKEXPhKyo1pQoj0kgpfOuM8i9sv5AsUZO2ItyAk7jPnpv9GVoFbkqtoSKT9eMI3AVethEQL/px+e+yP2f2kUJ7hDPM59N0Z0/9n2XLSEpG1igjomOkd/+MXFI1M6HLJcFRTf3Eojjzt5QFRdt9pdvpNMBFLcx0ux4WdKHW6GqZqs9HnuOpR+FZ7fExMcbsDB4ZPTtQh1GOVn2oSdb6a5oxt2dhLlZDRtn09o4qndvYWkMscWXwACfANp/tCUQ8ZhQyxTu0mXgsZ3x3e7SROQXWC+fu+jOBoWqxRbyDNrAuZ+VoBkg8jcSSFvtVlW+GOLbhtTRo4efd0vJyAruv5ETcHpYtAZGi1eDKNq5qUNw4XYeNIeTSsD7ypBOk1x/DycKhNn6IO3z3ujjPNCmYcRpJOdYo+6MJz1I/4CUXtgjj/ZlrwWLY7ADE04MWNf68q/s5nvOV46CF0VsWvnIrIMzIJaX/ARxLDA4ygIuDX+id4fMTPhxa+AIjPn5WueLNVg4Zjb3hPAWzNOZGC5lSDn2t79Px5spijqwyBU7SXFYGdFbblvAYdku/0AbD7SoA5XK7g7izYvQfjVm6i2Mzs4nS9/eaquWVNUGjHOS2BtLKBUje/pxD1iQ5VAWZ4/zy4nE9K3x3B73FCkGhBiIJmUJdU68mxpe26750qFaX+hHx8vV788/msU6
 qFkFukyI
 PmaQnhs4lKleQb7de835tG0W7JzGA3PbbtW6atrm+TZqw3K35OKBsDyC68AxopMt+exhE1XcLIILl3TizsaKEtTZ6mPcijC4rJU6tSKlldvahx6TL6q1dIReIaML29CXOdTOMJrDDJkOWKFd4kMq5LIxflyUAuVCZP4Uqj70NDhUyGqWOG56UeeTJN2HH44o2fv9EayUlsFHDAsaZmMzWabCkLnZg9sZr3xj6wvKFcLU8UfDngCF5J6w9sg==
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
 mm/page_io.c         | 16 ++++++++++++++++
 mm/swap_state.c      |  7 +++++++
 mm/swapfile.c        | 38 +++++++++++++++++++++++++++++++++++---
 mm/zswap.c           |  7 ++++++-
 5 files changed, 66 insertions(+), 4 deletions(-)

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
index 53bf01d5f7f1..193b08a54908 100644
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
@@ -1208,6 +1209,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		 */
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
+		/* Count active devices, not merely those on the avail list. */
+		if (!(si->flags & SWP_XSWAP))
+			atomic_sub(1, &nr_real_swapfiles);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
 		/*
@@ -1265,6 +1269,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
+	if (swapon && !(si->flags & SWP_XSWAP))
+		atomic_add(1, &nr_real_swapfiles);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -2959,6 +2965,19 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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
@@ -3167,7 +3186,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_XSWAP) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3277,6 +3297,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3296,8 +3329,7 @@ static int swap_show(struct seq_file *swap, void *v)
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


