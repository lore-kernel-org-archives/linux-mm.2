Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B3ACD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E91F6B00A2; Thu, 28 May 2026 08:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372026B00A3; Thu, 28 May 2026 08:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AF86B00A4; Thu, 28 May 2026 08:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 138AE6B00A2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D04DC161EFE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:53 +0000 (UTC)
X-FDA: 84816803106.02.CB0B5AC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D3014000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UiDyRUPW;
	spf=none (imf07.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWIbWPfyHKxJS2WvruGmdYQMLTfXYXxGG5VnslWOLO4=;
	b=LTd2113oDu1jAOQDVLA7yBSSI2hzBZHEWwinH5R+nuCsEGDP5QMmvgfxtlV32AY0V3vIjZ
	hoP2HZvgFHuz6IFOL0b3LRFB1lZz9ykwW4isWZq1OfLKzZLg+4wA5ME2/mQXPcB3f7ZzIn
	dXb+mdnNjZDJcJLULfogqGFXBXbYGjA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UiDyRUPW;
	spf=none (imf07.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972412; a=rsa-sha256;
	cv=none;
	b=tZXyuQWfaPCFeh6N/WqX5cktRaHJD2AdffcxQVcckgH/gVSKC97x47VdJYSC0cVgi+nau3
	LWzRdwV3dHiSYNyskIvrnAbtFsLt3xvFDnBc3DhE3lVpeWmVdt0cl+ctdBhBb2rLDxXL6y
	E79bjvJFd0xc7OcXUHqS49OgBDSztjc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hWIbWPfyHKxJS2WvruGmdYQMLTfXYXxGG5VnslWOLO4=; b=UiDyRUPWtgCYQFBmAzbDjeQFFS
	Qh6uZmEFtA57rwA9yGjMG2+aWG7EpkD04INs6By7O4gBTe8gpk917GZ9shQqvbGrpA2uMYAu+MRLG
	556hYyU5IEPjcgfdLgSAxi4vp49vJ1Hm7RhH7M2Nf7miEQ5J2AQhjncCHa4fwdWNeG3s7raR/Y6MC
	CwhcQMp4ElsdMiWjRNsel3ZTXnP0NAE9TdbTMGvtHj/CB1PBFdaXoyiCgglcIu//JNuEVe4lD+6+T
	Yy0K62KFMUnt72hsS8Cl5tAzIW7Jqaq5Uk8xtAcM5mcgisWk/6bpeVKJWSjVemOZ+Ao535nQE8ySy
	Ak8ttasA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa8O-00000005jip-0125;
	Thu, 28 May 2026 12:46:48 +0000
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
Subject: [PATCH 09/10] mm/swap: remove SWP_FS_OPS
Date: Thu, 28 May 2026 14:45:25 +0200
Message-ID: <20260528124559.2566481-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: z7hqzud3zyqke5gc7r6puoqsrjxrh7jw
X-Rspamd-Queue-Id: 2D3014000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779972412-406404
X-HE-Meta: U2FsdGVkX1+5yxV6x0uylQqT0JsLASOUyEC5y86rMmiA6tNxXAz7rAHWu4uBQCBtz5FboOnK1b4YpOzvCq8Mq7V4MYgA1XWVjvK/sMDoyc+0SR4PF4CMNB7Evx6JPAvldaZC+vSI9rwtt4ondE0K+T0UKKiLYxC57qoDOalZPZcVmStjySX0+aUX+OCaAHjmycQdCBCAny/6CVhRR5ZFZNUMo7EKlmGRfyeyviHQNeKqQF03XKgXFEYM+Zqy1u4UHhk029OiHpeANsKkccCO01m+NVJYVMafVFymbubc+xJRjEGMHp5f6AU0Qm/BBjjzmfxk4ta4rP8BZBV87PObGX2sB31R+iJCe21+C89i/7mkEPCpBnflh8UJuPRc5wuzFVijD0mrX0FWvzIDAXtZB9E9bKl4YTUKAsMl311l7TcNDwedQj/4x14t0cHI73dufzLZWOMGgky82JLw3OMa8VEC6C6eHyN0Yiktx6nnfoLuphugP8+LkgMcZMf6DpcYajVUUQ+ixObZKzl0/0RXn1usxmpKBhjpYV1d+7YztTOsBBmyyh9uAB7PPVFmxbwcKgnCg0Pc4jReNpvwxN0Pk6o8sT+x8GzyPy2t93JLBc+gnCF+lQMJW4+JyuRfLOBBXJ9/yIEnWAChtjuvyccjn56xrRCxiUpu+aGVYK1M3qeWgXvuT9BSLzGjY1Bv5/zF9ECUfh+sYr1yCwzvkzW6XPUSMLSj30IJ9kD2DWBXScEOyNCFihnx8Z94FDWzhhWlGOxezT9roAE3SHQ9DKbYnTPdmhlEan8ywRhxUK/nQlssbatblijrWIGgCgQG+bVD5e+0xFUA3dUTbfMXX/IDFM0cuT7ikKXsiQEFRzHqwi7/5QdNUoIj/vX2yDRdw31JHzD2Ydm5EDrnZjW4WJ3191jhgpSR7vD5s6kw/5kyb2IZg9ooMBeb0t7eB9bRdOWYjMlPDQ8EodTGae6YtvW
 rjnh/CnQ
 m+IuaFjzXj4ch+vf6eFXfvCnu0+ROIfNX8rTY0O9CXo7HEKirwlNhB3Pb8RRMLnIEwSN3grOffSWwg1jKQFuBuPBxyW8oIQtYVetK8+uy/VqjtMV14at8HdnIpq3SNOOkzKgHqNBgIr4q/5GsYqvNKWLX3jvk7bxmw1fXsnclNMC3rqM5uYmP35m8lZVzUh7390DL4T+Ye3+fz+TEs160CSS4dj7jQYVb+yRScN5cg6cePWR+Z8ErM1zD2H4DnuoxZkYmPpoPIBsSfGg5EZg6W4x7Yr3gS7WE6RGf+d5l3GmnLRzjedTlbYoFJ9O7yzhtjCKu7miq9oWjEFnirY5oaRDmw1W9ajBUYyPnX/LPQqC+2wTG5kAAJiWqrMtHB2y6k4FNNV9OZCduRW0CS1/PoCSvF727PxkL81KjvZxRXIe+6lhmV2KfNtqs1f6jQxMVfTmfPu6D+1ayihN31pg8cqLe6FQsSDFVrL0qWVgaepxKDao9WZeFoYxPLVeTTF6wgbniNUYMrKoLufNfpFhhDjV0tt7D+9lnijJCBho8UVu5WL5P8ejL4emJoOjcSgV+SXZxKbMi5gGd4naogpPgZmWpVkw7m+J4a5Si
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
 mm/swap.h                             |  5 ++++-
 mm/swapfile.c                         |  2 --
 mm/vmscan.c                           | 14 ++++++--------
 9 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 8421ea21bd35..70481bdc031d 100644
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
index 25048a3c2364..8172c9972b46 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -589,7 +589,7 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = add_swap_extent(sis, 0, sis->max, 0);
+	ret = swap_fs_activate(sis);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
@@ -599,8 +599,6 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 
 	if (cl->rpc_ops->enable_swap)
 		cl->rpc_ops->enable_swap(inode);
-
-	sis->flags |= SWP_FS_OPS;
 	return ret;
 }
 
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b60344125f27..3e775c5bdcb9 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3332,9 +3332,7 @@ static int cifs_swap_activate(struct swap_info_struct *sis,
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
index 2d6fe268c82a..636d94108166 100644
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
@@ -403,6 +402,7 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
+int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -527,6 +527,10 @@ static inline bool folio_free_swap(struct folio *folio)
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
index 1d5b891dee97..3947607f919d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -661,12 +661,20 @@ static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
 		swap_dev_pos(prev_folio->swap) + prev_folio_size;
 }
 
-const struct swap_ops swap_fs_ops = {
+static const struct swap_ops swap_fs_ops = {
+	.flags			= SWAP_OPS_F_NOFS,
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
index 908ac0e0d021..57dbb7201498 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -84,7 +84,11 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+#define SWAP_OPS_F_NOFS		(1U << 0)
+
 struct swap_ops {
+	unsigned int		flags;
+
 	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
 			size_t prev_folio_size);
 	void (*submit_write)(struct swap_io_ctx *ctx);
@@ -484,7 +488,6 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
 #endif /* CONFIG_SWAP */
 
 extern const struct swap_ops swap_bdev_ops;
-extern const struct swap_ops swap_fs_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a670635e0fbe..284eebc40a70 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2858,8 +2858,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
-		if (sis->flags & SWP_FS_OPS)
-			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c43177a8e4dd..2d44ebfebdea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1037,16 +1037,14 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
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
+	    !(__swap_entry_to_info(folio->swap)->ops->flags & SWAP_OPS_F_NOFS))
+		return true;
+	return false;
 }
 
 /*
-- 
2.53.0


