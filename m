Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59660C531EB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533926B009E; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B9E6B009F; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F16F6B00A1; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C27696B00A2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EB071B3C30
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:13 +0000 (UTC)
X-FDA: 84462832146.25.B20D632
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 65E2F1C000F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P73uNUnN;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544531;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYU91KABfERXdaSKMNbEIKkca2Q6Bmtxd91qOt66T/Q=;
	b=beQWhthCHgBXHly1hRIKKmryuJjCZqFn1Nti/aoOtsNIwLWsiGFYD43waK+8+6LIpOnHhG
	rpDdPWxVynnLJQPO3Gh3BVsYznuV/xmb4R7t1h05Y9zQwyg6ZEp/XLdYO3hZPfhavpGnKH
	IQOjHfbh+uCFgxX3vktYzPcoBhYEz+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544531; a=rsa-sha256;
	cv=none;
	b=sA+5e/DiYFt8y3EErWd06f2Zk56LDPLSu+3b/vjXpXIkeAoE6MJ5ejHpfw5QjIdtzlwqPO
	Z4toTg+Z4NmqgPtNpnuUvP1Glpyhct2JWCQ6LGUcQdga4MvTsdaYf9wN9b9IH5zQiHrdSv
	tLHOIy9twvO4GzkWkdEWKLIcLpkfvoY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P73uNUnN;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6286544561;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41142C4CEF7;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544528;
	bh=o5/yQb2bx9F4jYBwj0NlqpQdPtP0c9FDJlMawMBLCJU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=P73uNUnNnqdZK6PtkKON1gQbC8woiJYlIrHCDBHaRPw7fKvDTBnfkv0LCwkl253Zl
	 ZR19/O64c0CD61Td5oVNAJOsnRJwjTqEyACSraTPc/3vmwI5wlj+uwNvVmtB2y0dV0
	 7dDjfikhnsui9/b5/7WAAg1s+WKliUBlxsWwwy7hGJFen9ZdRYsfHNTnzLks9li2YX
	 r0vaN11/FoCGlWEbnIiVX3SXjRrnmxTMhJ9P8oXRBeNtdKD5OtpIEVl1siEEHxnWnD
	 w5zBpbO9soIGtxw5A85v/rUIY03p38UKIDtzrBjtvdcHyLbsZw+tlBM8cTXNqsjCLG
	 X/EqSLldo13SA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A5CC531E3;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:14 +0800
Subject: [PATCH RFC 13/15] mm: ghost swapfile support for zswap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-13-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=8943;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZmZgtJsn2gR54J687nHVHnXVV/ak1x2+yjhOddj8Wcg=;
 b=+pDVNWFeDBYtwUhtCIlBKrjwyp+Hgt8lbQaWIkI+yYC0tSduQHgFYrWs+EWMDZrAaio7Sx4J4
 r0uPcr3fuRyA3iOVaI3ZiAkumw8RoaZuW1gzuWdKuH6iy+YyoAAo28I
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: t6jrdbgp64zzgp4hjerf53sqw7k986ri
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 65E2F1C000F
X-HE-Tag: 1771544531-539529
X-HE-Meta: U2FsdGVkX19LNpuNqpnwmcKo41kQy+Jr+wV+iObXQ0XSDgb8zQc2VTFpCppcA+M0GQCmiN8f2b55PPamXkJcOjIcuquZXlpalBf7d07ChhQVAUJvadqTAUdaUFUsAMwaibzYMbGqdJAQJn/lzYo4EVLc9/BJecy900NojDGEcyNZSwl+uxFlSnd+5pNb/zxerHpKH4SxTFqtt343Up49L5UKzPYcgLlsaTt0GgrYmE6+lj8aMm/9VTBcCGfEJxSQHia4jSjuDEIgVPPidSrCvxxgREpTLtlM7P5j2rHk/c0SNp//rdOd5J7Ah0dtqi859CdXT3X8xplZ5d7DMth5gU8059FIeZeqrTzNo5RMp3w1UpNHGF/0UsV80OHKJiOOyeleJTD0Q4UpcXIW9vxIRL75CaFGw+etg0RssCoD1Cy1j+yxsEbFsRu1pqZuQLU3+omhoTtDt5GtHchLgX8Ls3f4RU9cj7sCYEsDKytOrzNMFjUkDBzBPr6Ih9LvxDk41mzSpgYZ1pI6efiEa7cREmCiYl26AaomQ012Te8LFmkyNbglKOB893WmC3HpbyFaRHmKM3ePvvIYQV5ftplJC5BJK4O+b1RpXsxs7xptqkkKaLgi14wXQMKGGaEAjaeBS4H1S1A7ewmypxFXh77vfTVg1QtWARdolOdl9OsokTVLJuzTgMzrgCKIMvQhUXmBUwwfu7GcA3lExodi5VsjsPG3d70/hXvWTf22dBLbOT+8/VTOB7ThNXfjzNBDC7blNjCkTXzMQbTAUehzNMv9f3lzykyKdwobD2LNKL6kIttRhSdkRB6I20sPgGZHyrldMBtmhHL4daynocaVqEfmRrnit8FtdcvXQTzPhmL3lDUag7+Bv1a6d7lwO5rsIWWL5fycfOkY75mJl5tR8TSKQaeWsLNdXDHCXGMQKBblXj1Obc1DXW7uALhoCG0kqI6FY3ciaLpu6fmuK4pZN7Z
 pELAQx79
 tDHirAqF5IjGNsTQuEDpnQFTlI4PR0TPSeaezMhni1XuzWRb/Df1YafA+5od3Mmx64UIyPkExeCI76xtTaP8ts0nsthsuFCzK01zG30dlsY9BGM0hKEvhjAz/T4W5472N/kF/PbCcgphfNJKbutBh5bTtL+btvqFQwswxigI2X0LaL2dI61gMTDodHqnqnMiuSa/T8cZ+nkD8sA4u1xmc61GHVjW/FZ19qZGjCeI9Vy1l3hMgae6e06cdUVOI8T1Zm2kKSKcdPbCewEIjIUUtq+Ygp7i4ZD9gC3qImR+iFyjzLRlJk4W4MSgUDEMkYWVCYO+k85BO8swsj2+ZAiYfO1+nzH6nqmSEQ/MRRu8dM2AyX/+Y1HL+wlF6/VR6WttA49z/6+xYz+cqU0HjfJIPKZjMx/6zxjmm9Tx/tQDBSzDQJ74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  2 ++
 mm/page_io.c         | 18 +++++++++++++++---
 mm/swap.h            |  2 +-
 mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
 mm/zswap.c           | 12 +++++++++---
 5 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index bc871d8a1e99..3b2efd319f44 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -215,6 +215,7 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
+	SWP_GHOST	= (1 << 13),	/* not backed by anything */
 					/* add others here before... */
 };
 
@@ -419,6 +420,7 @@ void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
+extern atomic_t nr_real_swapfiles;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 5a0b5034489b..f4a5fc0863f5 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -291,8 +291,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, swap_plug);
-	return 0;
+	return __swap_writepage(folio, swap_plug);
 out_unlock:
 	folio_unlock(folio);
 	return ret;
@@ -454,11 +453,18 @@ static void swap_writepage_bdev_async(struct folio *folio,
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
 	 * ->flags can be updated non-atomically (scan_swap_map_slots),
 	 * but that will never affect SWP_FS_OPS, so the data_race
@@ -475,6 +481,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 		swap_writepage_bdev_sync(folio, sis);
 	else
 		swap_writepage_bdev_async(folio, sis);
+	return 0;
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
@@ -649,6 +656,11 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
+	if (unlikely(sis->flags & SWP_GHOST)) {
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index cb1ab20d83d5..55aa6d904afd 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -226,7 +226,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
+int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4018e8694b72..65666c43cbd5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -67,6 +67,7 @@ static void move_cluster(struct swap_info_struct *si,
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
+atomic_t nr_real_swapfiles;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
@@ -1211,6 +1212,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
+	if (!(si->flags & SWP_GHOST))
+		atomic_sub(1, &nr_real_swapfiles);
 	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
@@ -1253,6 +1256,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
+	if (!(si->flags & SWP_GHOST))
+		atomic_add(1, &nr_real_swapfiles);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -2793,6 +2798,11 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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
@@ -2992,7 +3002,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	destroy_swap_extents(p, p->swap_file);
 
-	if (!(p->flags & SWP_SOLIDSTATE))
+	if (!(p->flags & SWP_GHOST) &&
+	    !(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3102,6 +3113,19 @@ static void swap_stop(struct seq_file *swap, void *v)
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
@@ -3121,8 +3145,7 @@ static int swap_show(struct seq_file *swap, void *v)
 	len = seq_file_path(swap, file, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
-			S_ISBLK(file_inode(file)->i_mode) ?
-				"partition" : "file\t",
+			swap_type_str(si),
 			bytes, bytes < 10000000 ? "\t" : "",
 			inuse, inuse < 10000000 ? "\t" : "",
 			si->prio);
@@ -3254,7 +3277,6 @@ static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
 	return 0;
 }
 
-
 /*
  * Find out how many pages are allowed for a single swap device. There
  * are two limiting factors:
@@ -3300,6 +3322,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 	unsigned long maxpages;
 	unsigned long swapfilepages;
 	unsigned long last_page;
+	loff_t size;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		pr_err("Unable to find swap-space signature\n");
@@ -3342,7 +3365,16 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
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
index 5d83539a8bba..e470f697e770 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -995,11 +995,16 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct swap_info_struct *si;
 	int ret = 0;
 
-	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
 		return -EEXIST;
 
+	if (si->flags & SWP_GHOST) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
+
+	/* try to allocate swap cache folio */
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, 0, NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1052,7 +1057,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	ret = __swap_writepage(folio, NULL);
+	WARN_ON_ONCE(ret);
 
 out:
 	if (ret) {
@@ -1536,7 +1542,7 @@ bool zswap_store(struct folio *folio)
 	zswap_pool_put(pool);
 put_objcg:
 	obj_cgroup_put(objcg);
-	if (!ret && zswap_pool_reached_full)
+	if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapfiles))
 		queue_work(shrink_wq, &zswap_shrink_work);
 check_old:
 	/*

-- 
2.53.0



