Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83267C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900486B00A0; Wed,  5 Aug 2026 03:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B18D6B00A4; Wed,  5 Aug 2026 03:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1466B00A5; Wed,  5 Aug 2026 03:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E14C6B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:54:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2248A0E72
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:13 +0000 (UTC)
X-FDA: 85066452786.18.19AE953
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0A101C0009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QWiaLdA6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uz9E19ZcjXqKY3kPMLAOLyjnTdmqsl8/hR42BfB8vtA=;
	b=HrEBSEMu5UmTRGFch3M70oOsy8cPOwPuCNPN2VY5UB+k767YUR/XxhlKtsw4dPEuQDOOEf
	FrmbzOuJh2GdkwZotbSsBhYrA2iJMEkbd387NIZKVVhH0Et33anAHoljZr+lq9okQ/6S9E
	PilHFFSXlz6pM6NxaFrkogWcGoxV0Yg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QWiaLdA6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916452;
	b=S13f5eFz9zxE1Vdw/knY/eB2xkCg8SyTvfIeIocCFUVgZLEnk+8q2V8n1EgcUs5gEzkHPg
	JzocQpeIdDXi344RBKLkJjX5aQzwD9tMpMz6l/3n6j9o/zS3N7VpdT0YeXI1eSmd3wbZmv
	Xh5bOZ3voPn45G2Dlu+8PqDuwNcy2LU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uz9E19ZcjXqKY3kPMLAOLyjnTdmqsl8/hR42BfB8vtA=;
	b=QWiaLdA6YkLRcMr8zbXYeEKDYhkzprRdyodqBuEmPCAtX+mzD2p+a1SQJLaj9X9K3/iY5m
	9BZzFhJ4hpWNRH+zYX4qNoFuqVqQ+ltdwBUWTF/QoEcds3iZ4S6QHgp9EJKLf7vwzdgEge
	qotuMxWFp8impk1IVlzNc3PhPh4OQQQ=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 01/10] mm: xswap support for zswap
Date: Wed,  5 Aug 2026 15:53:24 +0800
Message-ID: <20260805075336.3579395-2-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0A101C0009
X-Stat-Signature: ff7zhb1ixn4q63p36p7y9y4kqwrt93um
X-Rspam-User: 
X-HE-Tag: 1785916451-673429
X-HE-Meta: U2FsdGVkX1+xXkrmOjy+PUNKNOYs4I158L+JOANg0Nib/MkPu9+exiYbKwCrtz27K1KIEuuwy05pzMFswUu7cXfk0oosItw87XhxxqTNqiV6SGLasjoQ5+loFrNUKL6FmjwG3eSzcj1bAU+ibax65BIT8oqg1onmiAgxkU7s1ja34Nc4xR3f2yixHe38O/wsxTwuSs3HliiudKgF1+GBFP27K0Kz73SGv9V9+JWHB9WZBzCshOFR/Cm3yBMs+fhydvovF0U8zR93Uymn1w1k3IE1Ud8IildnqsGLs6+JKVrPyzYghBWAV4rl69HJur5i5aftJ7BTO/ZLS1w7g+5BA008LXf2UPN5T43cKA1nQeZTJHb9+/S470/gpioFb75fAlg0N059ecX7ypPCMJDBhGBpSBOdFgavl99BT6DPh1Ot7sy1flOcR4M/TivESaLHWEwrD++6mFeJ1eXMb/z3iwdfi4Ul03c0ZoheNnz4JD5sBH+XdXk9VsvA/lI+SIa8EX/FI1jugJZKayduXG69zgLyFyMyOYLF4ruEPsV436YCOsVq23qstL0Y1ZL2i8nB6dNX85JOpbVKnyqpH6WEW8Jcuf4w3O0iJTJIaJ1oSrEp/VBMV0sAu99OiAaQWNs1nzCgc24LcvxAsHYS/Hs99Mp35+S6VgCPiyZgTMm/WZrxBhaeyd3veaye/YfXOAe7lsHrT2kl8CKdTiastgKe8wGtYQ54MqbDFj9mQiSQKOA4WXT1ozHK1SmadxLmwlISPQay+RNbUC+R4PKC7Q3ZcgDS4yJwxXMIZ9MoTbZxKfUQmGaGS/nMiL8ag3XBsN0kw2aVlWZ1hVHlLJ644IGxTQ9gL0RtroHXs8FBnBSQGh/wOnCgToHucL08zHabg3hGSubGf0YGaIkjZwhqwL6A4QKHioUG3hbC4FGXBkaD+O4eEqyAfYW6WsI5VNHjBhGn/J4YwcjgrIlCJTk5o1s
 oD8klV8c
 J0uGwLiBIDQcEYGxrDX8W26u4J7l4nOTZceGQkuRXgFQnnUH9dyxJv8D3KswfAj05UwVjOC24UZmsXxp3t6HH7jyYmb+2NabR4Dv0dt7RNde2zSY0zUvP8W1+mQ0KAfG4B95UCDLAKKA0fuV4eNWzkQ4+fbLJ4QcVpYlD328HOY4oVWm3DMsTc1UBwZICpJjM4MKliXrlomURsz92vl7MGlXchvN3GHdoULSiqIw5HuVUcz9g55lbb2ukQMv4/ZqQ9AmoYoheSajviGmHsiEdhC1VjaVgdy0Ty0WLNybVMq0cNv/0m54OXBHMFm4phFjSUEVt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Li <chrisl@kernel.org>

Introduce extendable (virtual) swap device support — xswap.

The current zswap requires a backing swapfile. The swap slot used
by zswap is not able to be used by the swapfile, wasting swapfile
space.

An xswap device is a swapfile that only contains the swap header,
with the header indicating the size of the virtual swap space. There
is no swap data section, therefore no waste of swapfile space. Any
write to an xswap device will fail. To prevent accidental read or
write, bdev of swap_info_struct is set to NULL. Xswap devices set
the SSD flag because there is no rotational disk access when using
zswap.

Zswap writeback is disabled if all swapfiles in the system are
xswap devices (tracked via nr_real_swapfiles).

How to create an xswap device:
  touch swap.1G
  truncate -s 1G swap.1G
  mkswap swap.1G
  dd if=swap.1G of=xswap.1G bs=4096 count=1
  # xswap.1G is 4K on disk but reports 1G capacity
  swapon xswap.1G

Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 16 +++++++++++++++
 mm/swap_state.c      |  7 +++++++
 mm/swapfile.c        | 49 ++++++++++++++++++++++++++++++++++++++++----
 mm/zswap.c           |  9 ++++++--
 5 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 45f301d73e2a..78f4302b92e1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,6 +207,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_XSWAP	= (1 << 14),	/* extendable swap device */
 					/* add others here before... */
 };
 
@@ -350,6 +351,7 @@ void free_folio_and_swap_cache(struct folio *folio);
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
index 4d4e3e3059f6..08c49d5bea84 100644
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
@@ -3468,6 +3499,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	unsigned long maxpages;
 	unsigned long swapfilepages;
 	unsigned long last_page;
+	loff_t size;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		pr_err("Unable to find swap-space signature\n");
@@ -3510,7 +3542,16 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 	if (!maxpages)
 		return 0;
-	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
+
+	size = i_size_read(inode);
+	if (size == PAGE_SIZE) {
+		/* xswap: a swap device with no backing storage */
+		si->bdev = NULL;
+		si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
+		return maxpages;
+	}
+
+	swapfilepages = size >> PAGE_SHIFT;
 	if (swapfilepages && maxpages > swapfilepages) {
 		pr_warn("Swap area shorter than signature indicates\n");
 		return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index f7c9c89f6449..6178465d0583 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -998,7 +998,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
-		return -EEXIST;
+		return -ENOENT;
+
+	if (si->flags & SWP_XSWAP) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
@@ -1535,7 +1540,7 @@ bool zswap_store(struct folio *folio)
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


