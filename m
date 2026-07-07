Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE6EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD4A6B00A3; Tue,  7 Jul 2026 04:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8C76B00A4; Tue,  7 Jul 2026 04:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7CF6B00A6; Tue,  7 Jul 2026 04:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 424FE6B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:26:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1BF6168C56
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:32 +0000 (UTC)
X-FDA: 84961299024.19.536E397
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id 084D480003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AChDQhKH;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412791;
	b=YlRdzEgyO/KZQHJnoKY2vlLKPNskTg9wS0BWlLrqraLpMc4oJyA5dxfxjk3t6aaaMMjCmu
	iEdfCWbsC9aPszgFMArSpYNPOrKVBrbqxHoEgdC+LQg9+7xqdKs0ERsD6cfPZ2M2ElAa9z
	iMAb42yajwvnHTpzO7pqsKsD3E7xXHU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AChDQhKH;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyxySvjj18L1dD5+XqXnwIOa1loelWLA5sngynvJdp0=;
	b=0wW5kSWPy2AuuG361nOo102QbTeTEQg4ehfg0/IjVutjiqGVnnmwojrec3qUHGeCab2IpI
	x84u1t0GEBan4rypk0aBUQaiqRGZe/EFdiGlsk4a184gMyta/iYhdqAXjAwRcRw8kfSrBq
	GvEiPEg7K8GW/9/+VOwu4BPaAedUfnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyxySvjj18L1dD5+XqXnwIOa1loelWLA5sngynvJdp0=;
	b=AChDQhKH1pY5J2CGC0aYXQhPVd/503AA4eCOa6RTfFOxZN9gPw5d1+J3hEI+wKvNGvTEZO
	UiE4DjuKBIzTXr1yi5QGdWYme9R06D6i4bIugODEtn7hfrP+yBAhSDjmuUHy1x3mYuQr5d
	7Bgfg9CKfvq/zqUWgawUsv9pGQu2Jds=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 01/10] mm: ghost swapfile support for zswap
Date: Tue,  7 Jul 2026 16:26:03 +0800
Message-ID: <20260707082614.95030-2-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 084D480003
X-Stat-Signature: wbhubeo3h589zxg8tapi4fhtusimjhy6
X-HE-Tag: 1783412790-40740
X-HE-Meta: U2FsdGVkX19vcXldG5rw1F4Y662kjHkC+KF360tzCaakLY8uPY9D9jWHi2QJWbVgwq7zqu8OVznjopGQaOTRaOY3HryAoH6d8VpCvFm5ACF+yrNh+tcTvoUnnFlDUDyqZEYUN2yzDYDdh/115Ud/hd1NnDlKBPOzUv7zp+LtK61ObB/srCIV3qPJkcPOjOe8qjNtb4+qWCRupl7D/bsyYXkl/NxY70PDF+1yRaSfPDonEES9cthJuqjfMmcilZ3XVxFXE8KOUGqoz8S3tR+mvoVENKpogMPXW6aEC3utuj0MHWQCNncoPh7qU7pjnTcMDXWKoj56hiVyXWhD1wNwDvAs+Y2tMtAp/qL1F2VfBS2ZwzRuYx/93HrgabJPYZ5uUtUknq72SDM203CkcqMZ5oxKIMZK9MEcwC/3wtYOMqWPUXtz2k0HOiTGKgqqQhJsvTHTXX3h/yo/pDwOn3PVsfsLPfoPNNssq5Ftj6TS6e5oMAuJ18if9JGMWkdggUBFBLADwgcP1mf4nmYogGx9pddKqoGAgTYDo4K0BvpDDbeYcIzcMYS958MydNh6X+9yVDYpJGBrBrUy4+zV7VWR3weaR6HtnAIezmR+oKFvp9ygdU9+ElcCZM9Nc0itRxKYYAaw7+1rHCeEA++uUioYT81tRAZI2wU/+HvbHu9hh2cgVEYNPFwqqn6/tb0BSPxP4WpNX8tW796/u5mgq951TxFeE/mmoSdcAHdZIP7DR5YO5Pk6xxg03OFstVKEmQ1CMqdlo7z5GLGfsy2bg+bcRMKh9reD2M1qMTkQuX6T94obpc7FemcF0bTKoKOX1oUBZsFAZgAEseSamXmgu0AiiCuqTIYOCARveznMYWARZ1tgX5mAgFaImcxvlTAUY1+UnAlftu2yUIfTbRX8GIl3UPiZiAlK8zBdlCKt728UpnNas9Df8yId4SZcMptSwh3AcVBrD/cGonNYISFy1yY
 76w5KXqz
 huw6AnVW+G5SWyvJJA0B5XhcIUIyrfxbU1jZK6sUjsZw3w2gIt9dyZc4qOtsNbKNlZUg22T5/X3l3qGKrZCiR4rfDg6La50L5ZaU03kg7u6naPicb3tjlC1AA8DIkcupOP8UnS1zbV/xO2JgkW0Mb2SBgqOt+dSHd8OtO4ltaa4+pagkS9RIdrzyZ09JfnMsgcA9B1JPWmmUh/bj9B3lMtd9YvATxoIroqdlZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Li <chrisl@kernel.org>

The current zswap requires a backing swapfile. The swap slot used
by zswap is not able to be used by the swapfile. That waste swapfile
space.

The ghost swapfile is a swapfile that only contains the swapfile header
for zswap. The swapfile header indicate the size of the swapfile. There
is no swap data section in the ghost swapfile, therefore, no waste of
swapfile space.  As such, any write to a ghost swapfile will fail. To
prevents accidental read or write of ghost swapfile, bdev of
swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
flag because there is no rotation disk access when using zswap.

The zswap write back has been disabled if all swapfiles in the system
are ghost swap files.

Quote Chris's setup steps here:
---------------------------
touch swap.1G
truncate -s 1G swap.1G
mkswap swap.1G
dd if=swap.1G of=ghost.1G bs=4096 count=1
Then you will have one 4K size ghost.1G.

you should be able to do:
swapon ghost.1G
---------------------------

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 18 +++++++++++++++---
 mm/swap.h            |  2 +-
 mm/swap_state.c      |  7 +++++++
 mm/swapfile.c        | 41 +++++++++++++++++++++++++++++++++++++----
 mm/zswap.c           | 12 +++++++++---
 6 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3f31b6a56788..9829a31a541e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -208,6 +208,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_GHOST	= (1 << 14),	/* not backed by anything */
 					/* add others here before... */
 };
 
@@ -412,6 +413,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 1ce8201ed86e..96e776f9a503 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -295,8 +295,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(folio, swap_plug);
-	return 0;
+	return __swap_writepage(folio, swap_plug);
 out_unlock:
 	folio_unlock(folio);
 	return ret;
@@ -463,11 +462,18 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
+int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+
+	if (sis->flags & SWP_GHOST) {
+		/* Prevent the page from getting reclaimed. */
+		folio_set_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	/*
 	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
@@ -484,6 +490,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 		swap_writepage_bdev_sync(folio, sis);
 	else
 		swap_writepage_bdev_async(folio, sis);
+	return 0;
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
@@ -689,6 +696,11 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug, void *zentry)
 	if (zswap_load(folio, zentry) != -ENOENT)
 		goto finish;
 
+	if (unlikely(sis->flags & SWP_GHOST)) {
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index 84e13ba6e605..2d29e41d3323 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -285,7 +285,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
+int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 60d937c6b392..5fb893cc7fce 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -883,6 +883,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct swap_iocb *splug = NULL;
 	swp_entry_t ra_entry;
 
+	/*
+	 * The entry may have been freed by another task. Avoid swap_info_get()
+	 * which will print error message if the race happens.
+	 */
+	if (si->flags & SWP_GHOST)
+		goto skip;
+
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 18925e462571..148ceb2d812b 100644
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
@@ -1218,6 +1219,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
+	if (!(si->flags & SWP_GHOST))
+		atomic_sub(1, &nr_real_swapfiles);
 	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
@@ -1260,6 +1263,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
+	if (!(si->flags & SWP_GHOST))
+		atomic_add(1, &nr_real_swapfiles);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -3006,6 +3011,11 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	if (sis->flags & SWP_GHOST) {
+		*span = 0;
+		return 0;
+	}
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -3213,7 +3223,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_GHOST) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3323,6 +3334,19 @@ static void swap_stop(struct seq_file *swap, void *v)
 	mutex_unlock(&swapon_mutex);
 }
 
+static const char *swap_type_str(struct swap_info_struct *si)
+{
+	struct file *file = si->swap_file;
+
+	if (si->flags & SWP_GHOST)
+		return "ghost\t";
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
@@ -3342,8 +3366,7 @@ static int swap_show(struct seq_file *swap, void *v)
 	len = seq_file_path(swap, file, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
-			S_ISBLK(file_inode(file)->i_mode) ?
-				"partition" : "file\t",
+			swap_type_str(si),
 			bytes, bytes < 10000000 ? "\t" : "",
 			inuse, inuse < 10000000 ? "\t" : "",
 			si->prio);
@@ -3521,6 +3544,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	unsigned long maxpages;
 	unsigned long swapfilepages;
 	unsigned long last_page;
+	loff_t size;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		pr_err("Unable to find swap-space signature\n");
@@ -3563,7 +3587,16 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 	if (!maxpages)
 		return 0;
-	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
+
+	size = i_size_read(inode);
+	if (size == PAGE_SIZE) {
+		/* Ghost swapfile */
+		si->bdev = NULL;
+		si->flags |= SWP_GHOST | SWP_SOLIDSTATE;
+		return maxpages;
+	}
+
+	swapfilepages = size >> PAGE_SHIFT;
 	if (swapfilepages && maxpages > swapfilepages) {
 		pr_warn("Swap area shorter than signature indicates\n");
 		return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index f9762d0a596a..bdf8283fd880 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -992,7 +992,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
-		return -EEXIST;
+		return -ENOENT;
+
+	if (si->flags & SWP_GHOST) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
 
 	/*
 	 * Verify the swap table Pointer entry still references this
@@ -1048,7 +1053,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	ret = __swap_writepage(folio, NULL);
+	WARN_ON_ONCE(ret);
 
 out:
 	if (ret) {
@@ -1538,7 +1544,7 @@ bool zswap_store(struct folio *folio)
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


