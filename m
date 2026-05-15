Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C565CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36FB6B0005; Fri, 15 May 2026 08:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EC46B0096; Fri, 15 May 2026 08:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6F96B0098; Fri, 15 May 2026 08:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A02CE6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:01:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C53FA08C2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:01:04 +0000 (UTC)
X-FDA: 84769513248.12.0266FA3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 556B280011
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:01:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2j5wDsxZ;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf30.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=de5dFW85ussEbTibfn3kkHozJ4BEz8EY9P5UjTcccYA=;
	b=5N0IOiprgN0yYEiEcVQxYOpfQ/4Q38CzAt7mqgIY7j9i9ohperCDKpe5D16XnUS8csNNoL
	vbiiC9AjnImjc7XLxoO3dU9RJfw8M/GxkQU9bifOCIL8xd7vRUBiG/toj8iihL8j5PXeXU
	FSeOIm7xYJikYGKjZZh4mnq5j9IOX98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846462; a=rsa-sha256;
	cv=none;
	b=cVtUeZukgM7Wn7HOecl5N/i6yI66oMInsKYQsbQWwfwJFk3fB2JOuWxF5e9lcLjVkTKVw0
	r04BpkONOFIcGNvWE/xU6hOcGGCpowZnP01E47/qKvvsjahxY7xjCD3YN+R4fOh1/6h4xi
	VXq3zQ1qvp6U+SExXVJuerU6IKbs1nA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2j5wDsxZ;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf30.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=de5dFW85ussEbTibfn3kkHozJ4BEz8EY9P5UjTcccYA=; b=2j5wDsxZLe14MHgdwpsB8hag1j
	S7j/0wcjDTMhjTli1CSv89fWR+xEO5iGhllYB6BeExIloo/TFV4xePu78HaonUBB0zYNQnPOzjEvo
	gfnmC3Lka+tPB19bpOecongAgqU9eZufGS30MqC90mHqQeJMJJkequS0pWo02+o1Dr664IlDi7Baj
	/QQ+SIuichob9fGeFq3hIKtqvfXjizulrWs6sb+aJXDIdV35zr6znYfpKHCgzaaodxu+TpZ+ag7dB
	IoSZN2q5ThKMfm19dQJNMRHSam21CPrPegZ68WVSKAazidsYMGs7FxmFrqyvHVDLe+Xsg/pbqbno3
	3jrjxPgg==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDq-00000008GeB-2XHA;
	Fri, 15 May 2026 12:00:55 +0000
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
Subject: [PATCH 6/6] mm/swap: remove SWP_FS_OPS
Date: Fri, 15 May 2026 14:00:11 +0200
Message-ID: <20260515120019.4015143-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 556B280011
X-Rspamd-Server: rspam04
X-Stat-Signature: tiz46k3oo6pt1ztme3o66956g8fatebh
X-HE-Tag: 1778846462-718429
X-HE-Meta: U2FsdGVkX1/5F2UtD1LtfS7uDyq8M9nczWSXQB9onDMLoDpit+4/nHw0o/nNElSPhiNSd6oNw2lTT7rs3rGycRyDh3atdQxtqVROlGTDjXncZw6x7S+/X95BbPOzgINqecvvrYZ0dW9etDyiCd0zLQMjHLHxRszGr5zQk2iOhpb5YckQ55BdHK4qJijxLKTNXfAdoLZ25uf3ESX6T+CI8UrmNzYUNpdly18o6QTkIHFll3CfVBcG8fl8PtBqOE4CMKSAbxwIHAQLeDiUI1A4qY/0BwYvn3mLUPFOTRs15Qm7AKGo8Ir5q4A9Vax+vnQaAQLJ80MAskwLQNp5ZzvyPKBrwDMmoAYs0/acs6/UDadF4c/wKFfWTUOgTAAdknvOorQ96Z/+Xydbry31fc+DBUigjzdgzb5McI675IX+pZkN9YCZ9WgdIiEvVnzwdekwB/QgPevHLkYB2OJ1YKDSOPCnpQA2qt5y4rQjIBM5uF0FqI2dkG+lJSSa1oNm8uodxQqCvDrjjLw3HYd+95bWDH+WL8TmvgzrHUH8Y80+fJCvA9NoVxhC2N+LvWQoNYJx2NkvDFKPQN+TS7fi4HQZauc15Vm2Ay2ZdMTotcZM7yRJaQPSQAIebgfykyH88IZTwY9rAzWgCW/54wAl0XM15EHJ3eoWRkgoAtb/vj9VFx1Etgcbb+AbXt2THC/z0RHiLlDh6zuCfFxslSTjr8rwYMeKwyiFJs36K7iYQgl6AmmWS8Sy9Mw1GQsVKl9emkjwkY82geMcfwMgk8JskuzyA5b74TdLUMLzHJMp3iHogf+uFN8Iw8JzbJCVFo5o1H2rf4EgEdRWCP7AQ0OtLRenwOkjfmm5jQD3jyIW3xPx7U7u5WoCKkozqxMdUKKbyHymUfFzDPvCqpWpo7328zPr5/P3ph626F28m0JvSL4q3wkhim4pXCDv3r5N4BetnKLRb/BtbTyWp3JrPzO/BBw
 6iNXpCMz
 9aP8bS7KWMLm08xKiEH0eACy+OZG+NDSNruV3qlokn95mhVpp94rZvMIY2W8XWpJEd1CZInumlXsWeR0PLNv3gx/u1sllLmUbPFocS8MY3HQS8DPOf+wWIxE4jTlYOrNTBYM/vLy17qWP+7wN/ZaO/nabEVr5YX/CakuBm170UxQNFU+psyFIPdrwCVtPtl4R8jqcmiqJtkbTwkY1mk2MkcpPBjTfAC0RpvucEEVDFrCTNYZDvUAJd4/16/aRAOYIIvhOCYP5UqGt9Y/zX1Pj31FAbG/OFFbhIpkdVq4ztoIGv5/xDW5Qg+Oh5BB5BDHxs/zpeOAghqw4hELmLC02sj5zbbv6WDceV72ZbwtKV+zDImTvAb1FMgk6wiwvEb+NBZ45LAblcpb2G5Q9XyzcCAictIVH6wBIpBRuobFR1+HJQhwRH1sqhPRV00x2sLGbJpxatLhsQDe65b/xz2llRQwOhGr8tVs9BIbQH7ebLrIcfRRvSrWDFnEapUVIepzkH4bOlvcba3NZxyuIHXlYWmJiJEbdKpuzk7A0iDYTus+NMG7uTA6QLBzdtd7izeTPiivswY/OYUkdY7/3s87jfFeD9d+alD9Id2ME
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
 mm/page_io.c                          |  9 ++++++++-
 mm/swap.h                             |  5 ++++-
 mm/swapfile.c                         |  2 --
 mm/vmscan.c                           | 14 ++++++--------
 9 files changed, 30 insertions(+), 23 deletions(-)

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
index 664a2c223089..74c2748484ff 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3327,9 +3327,7 @@ static int cifs_swap_activate(struct swap_info_struct *sis,
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
index 0da33b803348..15790544ca3e 100644
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
@@ -528,6 +528,10 @@ static inline bool folio_free_swap(struct folio *folio)
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
index 4678a8af9f96..46eed28ee261 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -625,12 +625,19 @@ static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
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
+
 void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
diff --git a/mm/swap.h b/mm/swap.h
index aaf774fd03b4..b70dd4178baa 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -58,7 +58,11 @@ struct swap_io_ctx {
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
@@ -503,7 +507,6 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 #endif /* CONFIG_SWAP */
 
 extern const struct swap_ops swap_bdev_ops;
-extern const struct swap_ops swap_fs_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fce69a91e7b4..7b44caf6a0e8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2797,8 +2797,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (ret < 0)
 			return ret;
-		if (sis->flags & SWP_FS_OPS)
-			sis->ops = &swap_fs_ops;
 		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 56cd59e27447..d0bc145098e0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1035,16 +1035,14 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
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


