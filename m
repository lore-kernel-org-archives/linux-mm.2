Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5A8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8145E6B009D; Fri, 10 Jul 2026 02:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECB76B009E; Fri, 10 Jul 2026 02:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702136B009F; Fri, 10 Jul 2026 02:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDE36B009D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:40:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6F2F167B96
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:13 +0000 (UTC)
X-FDA: 84971917506.03.72184B1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A96540007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R03rBRml;
	spf=none (imf07.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783665612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XFOg/ieHYCFj5t25qzjASnZX0m0U1/4ytvInIE9lhI=;
	b=DXxCxWenfIbSvtzaCpoNv9KtuxV4b2P/Up3AKsfG4Ox4tXumasvuDpLqB1Vufc6QELucNM
	3NRFaIN+WhNTW9iNSnybU+cv3CCRFygJ8Wz+z7S34CmLwqzeC1eHGnVLzBpJx8XL27bK4r
	AEDaMNoFUHS63tuoQK+uksTGElkUWkA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R03rBRml;
	spf=none (imf07.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783665612;
	b=Hy9+bVdgX5dyeGkU8NDht4/SirJR6hCpXAWfiaSrgBvD54HFF2yy3in0HCXG87FY61Pw+u
	QZ3ITVlHZxl6m2QWfKK4zujmO6g7izvvUtdSpwJbT28bpE66mWtEDn8DIoifIxhz5ykMLP
	lQ8R3zK7n9toJ+toa/C+mDmdrPQWVO0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9XFOg/ieHYCFj5t25qzjASnZX0m0U1/4ytvInIE9lhI=; b=R03rBRmlgRw6AgQ2ooSZY9fEtl
	fQOge3gSgZyPYU/DZ28Cc4WoweEdjc5OENmudkR9e6SO6xsKPKeM8Tkt3w+C5b61mS8KAynCxLgZp
	riG/NHVVNFDvmpjFGeBIrAist4ZRzpEd1ZbfGvJ+DWSl57JySdKRwb/O3iYbitUGvdXZarA2n4KhY
	o/e8eBAHN1nTRsz7LkFRQHkwn6Hnn10kKgH9DQNcxzrYG2EImZ0bkBhmXQ9cmOHXiGg4JB3HrgOIv
	65ak0pstQsy9LXnjgZIZ7C+8bQrIZkoO+JfZ7vnnDZ1OKv29wwxuoUT1pklBtY29CmfkFxG9oR1aP
	ormCgsgA==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi4u3-00000004HU5-3Pi2;
	Fri, 10 Jul 2026 06:40:04 +0000
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
Date: Fri, 10 Jul 2026 08:39:17 +0200
Message-ID: <20260710063927.1891452-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710063927.1891452-1-hch@lst.de>
References: <20260710063927.1891452-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A96540007
X-Stat-Signature: zo8isp1kdwoip9kbpuno57mombwrofeh
X-HE-Tag: 1783665612-396664
X-HE-Meta: U2FsdGVkX1/9y7X7hzBxLqqkUA8aekPnHtShvkMrIgMnbwaEnfmFWR3DhY+3LXnDFYvRVPU/JrAhUFM7z6RTOBJsjCcNvFtQcFgnxQYrprsyKl8BkUHjr3oTeFqTwinHT9zBthqS0jTDIlUrKoFlNtzoeSMAbSaw86D7rwzCeYxlNi9ALPyQ+Ub/xCa4kdCXJzwg4BzT+Kv6PhrGsmz6yC4+uy9J/Ab0w4spKAJKeKyg/H4TRw0W3IkdXsEb64CJx60P3Wr4qxrWK1Txp9MJ082dwC+jCy0dZvVkU3+g84PTyqcW0oPOWBOAiLKw8VPD44U3RYXVaaXDxNnRCCaffoJ/s2WWknxVadQ6rzv/w+9Q9KQ1qjVdPpqFvokKqUmnmZ69nj69QE/kpEWCD8vcKbiYqDBCLbjLQBXtLO8rsoHAdumAUHYEDLEzOfsSv2yFnfJyD9SQVuZI6loA0OcNKNv21zcAia1CucWRNowkJOBiQ1uxHiNSrF6fnLGvlO5fY/NxAoymgTDTxc4N5HpvRWyVvnQoFPPfS3m27QEJO4tsDoKdjPexgrfM32197rBQMfma1dbJ7TWyFhUKSv8a6/xaKnn7b7+hMboSv5jO7yLZla9Vwsiy/mGzTBD4wX3AI+6bZJbNj5ArzZd+sjPBt2gE7aqRrguztPciJGJo6yKbNjtJj/CeKvC6a5ijunozGvdJ66KlPg5eiOeXAMwmuyjqFvebJd9wf0E2zvAQ6t7zqtv4/ylg+sjsrm9esvetbDJBIoXVTrUTslfuc4u2wqk0X4MpSOWs9JV1gt19fPeydPGPaTtnRWQp3yDfBAKGypDS3gVeDC0RjUstUTWm5/Y4KnAAJbLSiTm73LOHg/roRDiFxfloYrIzxMB1vv+39WKhpkoumKj2A83gVzhWmSs3HpctI0s5qTC2ZGQSnWmHqG1ziUuuSPiHrttxHwMCbfkKJSvlx/RN62j6uWF
 f4Vq+dZs
 RTJjXbJ6P2B+7VTrr4wLXgHUCfZNDn9ru2aQHh5Vr6+k8/gty4Cd0OL42LqoLRwedbY04F31BJ+z3jwySkFjbd9lUWkFfV5p19j9LuH+Q/HblsiD47kTFLslIXe0elcl7avD2W0rAspO4seRixDT194KiRKO8Gkal+mMIIHEt/aFEIpE0qYnoNgn5NSdCJ3XDCKh7891kv+wk5Xi6RMxltDcw1rP/mrhu7bSMXov7jgz9BJsz38oub7bR6Jlm1kShIVZied+INfT8OZCl1dzicoEtm5IQ2k4onEmKKQGYUxGlKfJIQIw5CxXzlJ5+LN2RghZPpoDuQtqW+XB3KfQbarn8PeaIMBPWCVpYBVtQuULBtjNs1tBz758554poW1xYME5+DRVP+scCc8SOpvcm6tfOC15ETVmceKf+a7Zs46pEehqo2rBNKbOPuY4cVP7ER9FBQftCAJds3dUrHQSGY6mk3wvROguaI63NhCYbd92yXom/bbbV2nj4IBXO8TnENdQiW/Ln2THuPntI6sHbcDHdjFiLBHsfxznRWjnioO3cukzmLQCwSHwwDg7wcnXjloixLQpZHDxbO0L78QLhThR4IaL1JXmGitSpx9FAG9e9uzb0cL9Chsh6tZUlJ1G2npE+
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
index 449207b2b9b3..9b981270d45e 100644
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
index f9799782f9e9..1152e0319e49 100644
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


