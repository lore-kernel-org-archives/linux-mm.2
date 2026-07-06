Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C77C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1ECA6B00C9; Mon,  6 Jul 2026 09:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF67E6B00CA; Mon,  6 Jul 2026 09:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6176B00CB; Mon,  6 Jul 2026 09:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 770876B00C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:23:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9212C21CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:23:09 +0000 (UTC)
X-FDA: 84958417698.24.684C077
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF5A6100011
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:23:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jNT0r6mB;
	spf=none (imf05.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZuRFJ+x2f2nVGQKnM9AcdfKVrr2qaUmEKs934dTzrY=;
	b=soByudYI4B2igizjGHBuBHatpAqcyJDIl72gdtfRVBY2rN+e8bkV2CqK0zymn4TsK6cVy9
	5ZoenoFk76LUsz0aXBJhVSKidkNeqEw7iGCqrRc3N+kCWCtUqrnYcvRdWtwKOKCITYOXeG
	c9aL6nFGSIce/oHAwu693hUG58JQqWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344187;
	b=ro5eF9pI9pmDKjgMc9yDAnL80PyeoC8D02eFm87Y/HFsEbfUUu0XiMabH1iJqd9H6zeML6
	LS6G0pkWvEZTUiac4T/4BxR8TdqOd9j8U2xonG0DaetXUMDU8V0SkeiqJ8jkrHifbx41CT
	pEcGCwA4y01G8UabN+s0CtariZxvGsI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jNT0r6mB;
	spf=none (imf05.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VZuRFJ+x2f2nVGQKnM9AcdfKVrr2qaUmEKs934dTzrY=; b=jNT0r6mBCS803En2i8jFoI1umW
	pZb4mw1erRvvAFh411HPoLW8jB+jnn4doyHwZ9od9Lvg5lKm0+Pa1mTnNQ2+WbBJXCcCXFxIDxPJP
	dMGo3VpDIrT/dVmYOMPmgtGl8ZakLF/P2TgU2v3TU2wr4tM6/B58LlRUVeS9PjoYtBh7HBAUikLUl
	qR7QueyPWCpA8m5SSIzk40S6hglF1j9GFrLfI/TrOo01jQnPhGKVmxLo3HoX8J9xM6iN1Hm0VKbWB
	djtgTad1unQzWI5PBH2rJdKH1rJPIvvPhJL0GQjuPDoO4UVT/vRQWjFKIItmxq3aYrt4i2dP2Zwxi
	h/ZlhTeQ==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjHp-0000000Cae1-2LAK;
	Mon, 06 Jul 2026 13:23:02 +0000
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
Date: Mon,  6 Jul 2026 15:21:58 +0200
Message-ID: <20260706132206.935272-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF5A6100011
X-Stat-Signature: 1o993nfwgbhtfxibcz9g7dg7k1nepum9
X-HE-Tag: 1783344187-86935
X-HE-Meta: U2FsdGVkX19QSvxnmu5RT0ZSEWKPOxqBoOFVG0MNnfRHT4PpmG2Xny5r7EkgALr0fYYEuSkqfWCRCgLGaQsQDPaAxsnP2ovZM/GS2hyNo37hPSp+RDztBgYSKCmIRC3ORvT+XQN8UYa0Pd5xKfM0dD2cAMRp1SMdJWxrw2wxWfbgI4G5/u+4XHD1tEoBJn8wQ54qRXNmPBR7bdVdE1gmRTh0gYPKLjREnImOHJ27IB8EG7w6fo4nGZ4fkDS+hm3f5n3GD9c8PeqXZtXzUJ+kepngnAGiS9pKy7SGAI0Mc+Y1Sg8uBDFCEn417oZlq+MUI0XyGyss5jTnN0XiN2agDWdV+RTashwx2bFQmTh3OTCF1GsEpoMMdo06IMpBSFDCwuw5ZcOTgDbCe/gY9zRYNZjM3ZkMj9gf5wV8OhHdIxKgH9D896qdqLROeIDW/eGkNvsJ1sMf/GWoplqXIdGxdfvTUSbXv3dS0MnBvKHdF5HwnxwBQ7RQlwjH+1HMhjRhuIK1HqgCHr5wQmTigdez7oAq35GOxR5mDzgh++hJ5tS/siC5dqua1x6sQU29R34Q/P33FH5+n2NAM28g/FPQtGL4L1eH6BcslfB0OoplSjRm6vrxoHoqXrcu3B80M+oLRiCoIssR1uFcuS+gHOYjVbiOcmHjbB1LPhZesIfPeysWCsBQen+lQTr8czlwVyjZ02euxnKH9MYT0LWiNYSWmD1TrYM8iW3cgYnNSGvU9qm/9zkJX/gVxucQNL48nKyKR53DfVrFp+rJC0AD8m7o3Xp84VSoK9ftqUJJ2o60kKDxfsvRrA39vT5ILxSJTdGmTCnucftvbUCohJ5+CA1bL7fJ2d/C/7HZQrSGDEcuT0cUADY3ZYQmBpy0tY2a5GqjKlfSt2N9tigBouxn8aAYU5OEg5h0EvmSkiCzZ8dxR/hVcWjHQ0SkZ8c1yhmEfoM0oGgaOYCY/89dEleVHdF
 gJaOC0Mr
 RrOWcKK93jEP4tmfS7OlvmZYRAeRkIUIbccE2r04UfVW/rjPjGHL7y7HGCti5FdhIOhauHT6hJqh6xmXIOLItryfoPILQqL7m94mBROpU7wTXCUzZduRRvkUmXjwDS/7SRH1MRmaJmZn+TLTA3JVP7Tc+pv/e7hwLyshrjyItWsZpQY92ft1EdZ1Y9EB6xsRf4OBQzPUgca5v6axyX8n8QgUYHwgc5ZuxX3wuvAWCaZD/fH51rN+hJpjYCEhC7dSJxeeAtlHUSy/JW7WbzR7+etaqRjhW32Nb3SZK45lfgIPSjRrsiPYUNOD0Hfkl3O/e7ttriO3ARAVfSLPqWRTi5Xkzviria4REBW5LBeMl0QC4Zgqiyn97mokP1gUzHZK8F/74vEjEMwOkIA7rXoR9WKs9VV2JK5aCnnU6EoTZPGTXNx5LnejYA4rMMaSAIrhSn0L0PbmGPNoDA4viaS7+M9366wqKkfIBYyU0CIYZMb/5PVpilIXUb9/5b6kaz09GHPiglJiutzu9OHVFQo3ZHopJou7ec3ffNQs4ZOX+cGhgvJhmROD18nGwT4kBlieQW5fn6bfWWj9eH7qpFNvBUDLnefQN/Z1Qv4tnB0bpbyrXaKw=
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
index 74ceb7a88fd5..bb53601e05b3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -208,7 +208,6 @@ enum {
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
 	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
-	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
 	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
@@ -404,6 +403,7 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
+int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -530,6 +530,10 @@ static inline bool folio_free_swap(struct folio *folio)
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
index d2b11db1a57f..1e29b36cec07 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -685,12 +685,20 @@ static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
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
index 5119feff0e93..0ff2f82eced3 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -84,7 +84,17 @@ struct swap_io_ctx {
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
@@ -335,11 +345,6 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
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
@@ -470,16 +475,9 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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
index b291510813a6..b0b843372f67 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2957,8 +2957,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
-		if (sis->flags & SWP_FS_OPS)
-			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2747ee68d327..ef280a24454f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1037,16 +1037,15 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
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


