Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8A8C44506
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B7D6B009F; Mon, 13 Jul 2026 05:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6266B00A0; Mon, 13 Jul 2026 05:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3E56B00A1; Mon, 13 Jul 2026 05:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A65426B009F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3058FC4918
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:45 +0000 (UTC)
X-FDA: 84983243730.12.7FAB95D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94FC81C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JKfTWGnK;
	spf=none (imf21.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JB5KZgBNO/5Khqiuu5pThQuWfcjym5y13IxBuLw1t+8=;
	b=iWpGV+cB/f5ce3pIcskz1ifxTNm9HOXr2y7weyGG243/ZPYlWkWwLGMpBFSrcU2ZDnRJya
	pok2QRn34ka4mh84uExAbHd0MtrajG8S20fOjZ5Pnh4To/pNppoo20WOV+vqnTKCVSsAEk
	ethw9tpXUm0fW/4ggBujLk3ooRb1dCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935283;
	b=IMlexJItpmFqalvf9HMZ8+oL+ZtejX8Z0fdAPSQtVFhZdWtdHeVjZ036YYDitFWRl2AFzS
	KwYsVb6Itui6UmYz0hJoNbOV//w3qw8UHAxKVYspqgP/7RKsaTomz+YsNPn3V5Y/0gxnSi
	RnE6hPvxdY95t6uX7VRyNzLWSFGNVjA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JKfTWGnK;
	spf=none (imf21.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JB5KZgBNO/5Khqiuu5pThQuWfcjym5y13IxBuLw1t+8=; b=JKfTWGnK5N+xqOz1PvURoYuVF6
	K1E52w2leCrASnlH1sKwxqHq2NLpwB8cXftpfddEUamz77UCum2Q1CjU8l7e+uV+rhUUjSk0jssh5
	+KiBp4GHdTS2ky1ub1j9Ff3QwMJM6XNPfUT8jGxVWRss9okHrILcMuf1v+Ya04sMeT7lnkE3nxMJr
	dV7LB3WPs3NDqpCuq99U6L+s6JZY5igO4xGOq1C6be4qWQFj9UO0/SBQR/B1mwr7c9B3QgT7QewXz
	S+JE/WxQkXS7Qidls++S6Dm5Dzq4yLnNSeCO3U1ujZpqIFYZpYUO9lVJN4jZZuG7OiRX7pufOgWFB
	aPX83dSA==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD3c-00000008knB-3oaB;
	Mon, 13 Jul 2026 09:34:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 6/7] mm/swap: remove SWP_FS_OPS
Date: Mon, 13 Jul 2026 11:33:43 +0200
Message-ID: <20260713093350.2154226-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94FC81C0002
X-Stat-Signature: zz6zobyis6fjbe5ydfrq31n8nm5otabd
X-HE-Tag: 1783935283-556667
X-HE-Meta: U2FsdGVkX19sfoPV5YCD23x2b00H6Usd0iUl2o43V2OtoLrzsFNCWI28gGOZdlezI2PNykHEw2HDxjjR95RIZ02MDjPhTnF7g+FXx3NNHdtFmhp0M6W604jByhTmiJ9eulPASz5jFGkqJvJe2+bHIl9oRYwsLhkKEwVHsFOLQG0gHrvOrPmrXwOwYofDb7UFUnHmnDCcho0LIORrOmI4yPSmNIdwro9JpNWkFdBo56wg4XhaEP+joO2CMF9Cm/mPwV5kjrKpwGGlObUNxazCNTB7MBfZCYQHPMkmv7G9FKfo5p9f6tQaOiFuTQjwn1k9jgOVmVvU33Qh+OGF4Ck7YSDIk1cSPu+knlF2mnGBNovGaRJYGCxXazC6hXgVxTJN8w3JquGa0CjyzL3MECNK+J5cztskJ6Wjyg9ZVLEZjyNjKJpOhKBRWeMvkREo39o/7WrxS6NZaC0eCP0oJlsAH89UWyoXicnr+2gqgGImOzPH1wJorimQnrtBtJhWvubXcVjjPUAWqcUbOnI8DOowfLrBTb1u1PwfphhOefi8k91A6oiy1P+WP5vAU3HSFunetuewHJRv3TJtWYhWAOSRKJKeCUCPuXgKktsNmwRir8Pp31Q1f7X8/2mM1Rma5kMkv4h7hukKAwXJaeDiVDvhDhwrcN1yMV45OrJWD6ZpWSp939e3MdbHjprhjnZVW/taHSuq2UBMgka90+J++6kVTyYLiJ4bbMsNYe5LPtgbXOwxJYD6S8x+wt5IW/IKpv76/GFNGRmDAWOzQYWJ7jf/12QBLvv/muYaIeEC6SwRDsxij8ZIFQKp78HEGfAsYOGUgxchpeC745PlD2BBj++SxkUvmO/6N/4XVM3WUYK/onEThbwVHX4y+81oFUAX66F16JAZdY5QGiGgOPWZlR7x1hAGLGJSPAB694ndB6ryKq8EuRqlMH88tDyQmB5vZMXsMKS580zPwfaSPlSMUGV
 xSPs7o8G
 v3Uo3rbZgeu8mds2ltKuGQSr3UlcNnlSuFRT3B3hwUS3g3lhNsetJvykRiGQCIdaLj/iDnHbhw6a1A5ugJIxGzSDlkBopefsSnOMxP5kLo74jYhbvb17vfZGVr1Q/o6uEERGDd8vaoCRfpaZQHHB7Vyv18jQodzIM8qnR4CYgpdYtVl4anadi784D/Zj3smUmS5+axjBIltbqcVMT1l9HiBgJaSR9zn66Uq4s+LtJ7dF51F63Nq+8uOLqgZuVojs1PX/OaRiAXmS12qBI/w/D7GSEr9vV2xPcfmmYHRLj2Y/7YISzz7wXc67XwBH2ctUYWYuxssKxPvsGlz25WSEkM1YigWcbu2Dn6YepYLfowZuihXAOwHfLMqcTNT+u5Ht+zL2CRrQOIVTMFi44yIhO2aStAkgiBBfxdybZMUyEcH+LQ/PiIAaGy8I84uzx9EggWyWaAfPOBrbXOQPY3NkO/+jqD7/eAHUHNKiH0+T6Btxj0pOlqvmfNAbC++O8q4OLqKEdn/8KoBkjt4z76QZ1piUBEuy8sf/+bdBAfuSZd6PoIZjzaR+07W3WCD4zAmMnNmSwxZTH9fXhHqvXvdVpP1Yd/z8UH0jxuMfnsaYG8blrXIlHJc6snYmc3UhgHtspbwvy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a swap_fs_activate helper that directly sets up swap_fs_ops,
and a flag in struct swap_ops to indicate of NOFS swapping is allowed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/locking.rst |  5 +++--
 Documentation/filesystems/vfs.rst     |  4 ++--
 fs/nfs/file.c                         |  4 +---
 fs/smb/client/file.c                  |  4 +---
 include/linux/swap.h                  |  6 +++++-
 mm/page_io.c                          | 10 +++++++++-
 mm/swap.h                             | 22 ++++++++++------------
 mm/swapfile.c                         |  2 --
 mm/vmscan.c                           | 15 +++++++--------
 9 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 08d01bc62c31..1a50d41a39a1 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -355,13 +355,14 @@ should perform any validation and preparation necessary to ensure that
 writes can be performed with minimal memory allocation.  It should call
 add_swap_extent(), or the helper iomap_swapfile_activate(), and return
 the number of extents added.  If IO should be submitted through
-->swap_rw(), it should set SWP_FS_OPS, otherwise IO will be submitted
+->swap_rw(), it should call swap_fs_activate, otherwise IO will be submitted
 directly to the block device ``sis->bdev``.
 
 ->swap_deactivate() will be called in the sys_swapoff()
 path after ->swap_activate() returned success.
 
-->swap_rw will be called for swap IO if SWP_FS_OPS was set by ->swap_activate().
+->swap_rw will be called for swap IO if swap_fs_activate was called by
+->swap_activate().
 
 file_lock_operations
 ====================
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 7c753148af88..e7677423a20f 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -977,7 +977,7 @@ cache in your filesystem.  The following members are defined:
 	can be performed with minimal memory allocation.  It should call
 	add_swap_extent(), or the helper iomap_swapfile_activate(), and
 	return the number of extents added.  If IO should be submitted
-	through ->swap_rw(), it should set SWP_FS_OPS, otherwise IO will
+	through ->swap_rw(), it should call swap_fs_activate, otherwise IO will
 	be submitted directly to the block device ``sis->bdev``.
 
 ``swap_deactivate``
@@ -985,7 +985,7 @@ cache in your filesystem.  The following members are defined:
 	successful.
 
 ``swap_rw``
-	Called to read or write swap pages when SWP_FS_OPS is set.
+	Called to read or write swap pages when swap_fs_activate was called.
 
 The File Object
 ===============
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index a0d8f1c1cf10..851d93a09988 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -597,7 +597,7 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = add_swap_extent(sis, 0, sis->max, 0);
+	ret = swap_fs_activate(sis);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
@@ -607,8 +607,6 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 
 	if (cl->rpc_ops->enable_swap)
 		cl->rpc_ops->enable_swap(inode);
-
-	sis->flags |= SWP_FS_OPS;
 	return ret;
 }
 
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 5a25635bc62a..4b1bc16b8f3f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3387,9 +3387,7 @@ static int cifs_swap_activate(struct swap_info_struct *sis,
 	 * but we could add call to grab a byte range lock to prevent others
 	 * from reading or writing the file
 	 */
-
-	sis->flags |= SWP_FS_OPS;
-	return add_swap_extent(sis, 0, sis->max, 0);
+	return swap_fs_activate(sis);
 }
 
 static void cifs_swap_deactivate(struct file *file)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index ee84d4cc8457..0544b2ec4c56 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -202,7 +202,6 @@ enum {
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
 	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
-	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
 	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
@@ -336,6 +335,7 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
+int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -461,6 +461,10 @@ static inline bool folio_free_swap(struct folio *folio)
 	return false;
 }
 
+static inline int swap_fs_activate(struct swap_info_struct *sis)
+{
+	return -EINVAL;
+}
 static inline int add_swap_extent(struct swap_info_struct *sis,
 				  unsigned long start_page,
 				  unsigned long nr_pages, sector_t start_block)
diff --git a/mm/page_io.c b/mm/page_io.c
index c36b44ffe947..cea438b66bce 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -686,12 +686,20 @@ static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
 		swap_dev_pos(prev_folio->swap) + prev_folio_size;
 }
 
-const struct swap_ops swap_fs_ops = {
+static const struct swap_ops swap_fs_ops = {
+	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
 	.submit_write		= swap_fs_submit_write,
 	.submit_read		= swap_fs_submit_read,
 	.can_merge		= swap_fs_can_merge,
 };
 
+int swap_fs_activate(struct swap_info_struct *sis)
+{
+	sis->ops = &swap_fs_ops;
+	return add_swap_extent(sis, 0, sis->max, 0);
+}
+EXPORT_SYMBOL_GPL(swap_fs_activate);
+
 void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
diff --git a/mm/swap.h b/mm/swap.h
index 33a258c77064..8fb32bf15739 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -82,7 +82,17 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+/*
+ * SWAP_OPS_F_REQUIRE_NOFS:
+ *	When set, all reclaim operations must operated as GFS_NOFS and not
+ *	just GFP_NOIO, as GFP_NOIO allocations could recourse into the
+ *	file system backing this swap file.
+ */
+#define SWAP_OPS_F_REQUIRE_NOFS		(1U << 0)
+
 struct swap_ops {
+	unsigned int		flags;
+
 	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
 			size_t prev_folio_size, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
@@ -333,11 +343,6 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
-static inline unsigned int folio_swap_flags(struct folio *folio)
-{
-	return __swap_entry_to_info(folio->swap)->flags;
-}
-
 #else /* CONFIG_SWAP */
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
@@ -468,16 +473,9 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 		struct folio *old, struct folio *new)
 {
 }
-
-static inline unsigned int folio_swap_flags(struct folio *folio)
-{
-	return 0;
-}
-
 #endif /* CONFIG_SWAP */
 
 extern const struct swap_ops swap_bdev_ops;
-extern const struct swap_ops swap_fs_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c6b3e4278045..1333def0870c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2962,8 +2962,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
-		if (sis->flags & SWP_FS_OPS)
-			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1c42c925add2..4357a44ee876 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1033,16 +1033,15 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 {
 	if (gfp_mask & __GFP_FS)
 		return true;
-	if (!folio_test_swapcache(folio) || !(gfp_mask & __GFP_IO))
-		return false;
 	/*
-	 * We can "enter_fs" for swap-cache with only __GFP_IO
-	 * providing this isn't SWP_FS_OPS.
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
+	 * We can "enter_fs" for swap-cache with only __GFP_IO unless backed by
+	 * a swapfile that requires GFP_NOFS I/O.
 	 */
-	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
+	if (folio_test_swapcache(folio) && (gfp_mask & __GFP_IO) &&
+	    !(__swap_entry_to_info(folio->swap)->ops->flags &
+			SWAP_OPS_F_REQUIRE_NOFS))
+		return true;
+	return false;
 }
 
 /*
-- 
2.53.0


