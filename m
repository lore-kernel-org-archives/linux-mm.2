Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2466BCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D91E6B03EF; Mon,  1 Jun 2026 10:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0A36B03F1; Mon,  1 Jun 2026 10:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7B86B03F2; Mon,  1 Jun 2026 10:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49F336B03EF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:56:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D993914071C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:56:38 +0000 (UTC)
X-FDA: 84831645276.12.E3DEC46
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9B86160005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:56:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gSRfDwFu;
	spf=none (imf08.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eI2NvjtHCrBKQGdm31jdm4QdZoILUr8jht32b51owfs=;
	b=esaYaemDzVp0uv0sCcXM2kzRxhoZjSIWehoQWbN/jKpwCrRuqjOaq8uoljKvRC4f0pG0Kg
	Qh268Z/KU17eQpzcRRJ2MSDFpYSDQI3Va/63RGpabE3n+AyOW0ujn5IoqjCOdCAb50PZUW
	Q7kNYVU86TtdixIAapHF4ZEZ8UeBF3U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gSRfDwFu;
	spf=none (imf08.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780325797; a=rsa-sha256;
	cv=none;
	b=VxLEe3NVU5eOLyyRKPsvi3blrhCNghMBwNMZSYk1noMAho4KWbaDlphOXB95rfRtLHv3tv
	QkorIJmntSSSoUYCa212uxtgnapSb59hTe4axVQSeJB7vKYckIKpH5IZFLc85/vJ720IBz
	cE4ZKI7Iuq7uPUAjyBHE62HrPDo/V7s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eI2NvjtHCrBKQGdm31jdm4QdZoILUr8jht32b51owfs=; b=gSRfDwFur+M4R5V5v09l32m1Lp
	m8M77YLLoHNADXpiMowoOmmyp7zBoEv16vxpuaAIN7HKbAPc5uklouRp763Le8m2WU8nM5+6xMXnV
	w+dzB5T31Uw8gR2IcaGGUhWUHDnR/XnuueIIbn8fX4M9LxC7mBOcQfSyc1FlzOoZa6Xp4GZt5YUDl
	LSVdutOZOav4VibqmBH+6P82G2rZLB6WPoqqI7eRcpjTu7HDW4TGxHEu1lc0X3zznJYacLbKHl6IU
	0dSc6SfNkh1ooqQ71lU1ybl2uIOm71D/f4Z50tuoBe+9VT1JrICIY2w++kO4GiMR7FZ/HRurMCMEC
	iV3tRU1g==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0vR-0000000AkdW-21Is;
	Mon, 01 Jun 2026 11:35:21 +0000
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
Subject: [PATCH 7/8] mm/swap: remove SWP_FS_OPS
Date: Mon,  1 Jun 2026 13:34:33 +0200
Message-ID: <20260601113449.3464734-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: c4o336mgtgmiiwcn314igr1ayiofax31
X-Rspamd-Queue-Id: D9B86160005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780325796-863632
X-HE-Meta: U2FsdGVkX19rsvE1LVrQ2tbZWcaRYCKEHX/IOO6ivvNgNFNiL9VUkDK1ppvBRRITdb/gpCe61oXY5roXtJ33j5i8kPISUco5DjXYHodHty56hFJ8Cs8xAvln4WqIBdYnW8XZV/gik6a/kanb8HsJLN4aXTY4AwTeVJJ22A3NF+DbB1wn1OzCvSOgvpSDzXMgz62zGO5N3yTZOTB6A81V1NJazY+cCUt2AoGgmKG5VZNQbPKptJGsqaA/S1vyxlSZKDfpVFt2Aek3471VKYkdWm5LxQ+oNEjLS8zkjCbNsrHziTlq37NOw7PKpDynLlcMYZS2d9v6P9Bg8f/65+eBpPP4v6oJrLzeZG7uBAY0hrGmV4v88Vxhw4m5l+GRxyq0pdVrG1aWS3tmjcFzCHuTtazXheErbNTxyu7wEr4kjj9NuSFyvPdBVCTzNBq1FZ6pwjzYhJ9WKpZnPdNrbd7bOWxZT0eJEIFSGFyBkbkU7PMqeUVJQTBqhotIuhUppTGr0QcaKHYEZ8zRAuCflbLaWWy4pPAz8jljq7FNgAQEqCseNy9iw8hqNtp7gowWvzECgDFFF6YTzbDl8LQPNw/JBZhmGO6bLQQJ+cnlW1tACxTDEmdn33B3JfsUMVZJtajIrybaOgHWrC1llWcVeInwVqaOCOC7/JwlK2mpk5qB5rnnQWZA9XlV1lBb7niHPlm0uBmF8ESGq2gXgQLfBB0EJTelRKRsAxS3BEmr6QhSv4VLLTa1djkP9NFhUDl6EtKnS6ot04CxiBWSibKamAcrVc9fuXw/matzqFRIg5goiIMeXwJs05vTAu2bU7O1pY0OhbIZOBPbQ9Q6LUg6PpioAwAQvRY6z1z/sd2q81Z30zzm6MPSjfZB+qlTSF+HQFJRZ+olgijBH2N6UhWbCmi61FW8L+NKEQb6dt5T7KzsYJfdJfygtMmsy9TF4ts8+lXtej88LYzWK2kQCa/4Ddw
 YhAo6pVK
 xiL0t+PR8tmkDXG4yADHI8L9vkuprsz2QEDu1/nMDMlFBTca+JmutXU60/fz9N9kVGmYu8uDscd18us1pLNawCsw8TKvaOZY7ZJCCwMaDqYEQ+i4i94V3GK8xJmpXrZpv+EiAIXZn+FfLxQoiVGW2pmp/fPCv9mIdpozUAki/2za98wd4QYJ1aXNxMswVlx/tVtRSZIzZd9uovxRRJVonVwSv25oWzDJQJGfGrQ7G8iDNrC/CIpfALBJRV1XnZIB+cJM9rkDCK2E3O5758mlDVIMMWrRwxDVAGPrRiO5Mi6FLQF0xW2Z3FTlVhVlVJ8fqdO4QQd4Hq1cPFDuriGCm5KhOGScMm9A7R2yRD8PqBmQrv62zi2pFhnvnMDwQDLQaW8Srq5Zt4R95IWXPaNWNSAMFZ7UMgMaYwv80E1jWr7+a0ix1EsOr3iYH8upv8UQTsmEReLq9HtGPmQ+xdPDJmoljtqO9uoKauk8gCXLzCG9Ll2949wQhK75EG2nmLRjcMrA4PB7HtgSeFb2kPTM9Zbalw66FBZDlH5cVm1Id5fB6Zc3zc/OmlenaGlNRD4vY8G3Q0GUM4bZGSMP+4ivjfuqG1Wz1lkvh+/Jt
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
 mm/swap.h                             | 16 ++++------------
 mm/swapfile.c                         |  2 --
 mm/vmscan.c                           | 14 ++++++--------
 9 files changed, 31 insertions(+), 34 deletions(-)

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
index 218d8fd23dda..cdac55d0a2e9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -677,12 +677,20 @@ static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
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
index 5119feff0e93..edb512e619ee 100644
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
 			size_t prev_folio_size, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
@@ -335,11 +339,6 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
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
@@ -470,16 +469,9 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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


