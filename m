Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A39ECD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DF66B00A2; Tue, 12 May 2026 01:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35BD6B00A5; Tue, 12 May 2026 01:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B9A6B00A6; Tue, 12 May 2026 01:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94D976B00A2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67AA91403C8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:52 +0000 (UTC)
X-FDA: 84757661184.13.725A060
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98E1EA0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=U3yVR38y;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564270; a=rsa-sha256;
	cv=none;
	b=4abhFRMySXWRWMGWi85WtI162O5AuJ8/7HRHE3EXOwY97fZQjcqFpgNm5s3nrMCuxyKvnS
	lirOoVguskDFrzhihEcRjzAnpEugoGCcnm/prV2Ji087l42KFgaj+wig3L0zS2Y/Nh6MNC
	f4k4GKEhgG/3vN4sAX+Ihx4oG/IIHhg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=U3yVR38y;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRHWR+K+rwN4V/M9eakcsPNW+L+2qccDSG2y2mqtyrE=;
	b=0rt0RXMOMnnctaxH4EQeMq6BMTNNf+06BW2cW9+hSVgsvtYYf4LgaeJpa0T5wZmgbaWMPg
	Z1Urgggwqluz/pEohlno+IsR12SAYD7FYdx6Y1neau3Pz5XR/uhko1F6YEiyYU4A9JEfg9
	eKxUE/X+ssBNAe7ODgMqGb5OzIzpEEU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eRHWR+K+rwN4V/M9eakcsPNW+L+2qccDSG2y2mqtyrE=; b=U3yVR38y20oSPNvU/6cEBkABNB
	wdZkG15EogD5OQ4H+wpPaAyqYsbYjSVEBbzMXdavthfcH44BYKxDetZp1Lul2LwEeaTPGkQNIWAhz
	NBcdFUD8ehpNAhIdSczIhrprRMY3jf02fFJabXW6s/JHKLCHMGKbVvbMxBBFnhWoS9n8rORJ4iRzQ
	+lsR26GKXcZJifHIZ6NvbOeReOe6U8/+9c25F4A2drxqL2IENmV6QvGTi9fd1EeJxfsFO6iHzd7SV
	eBRSw4EY0CkD4sBuF7Z07bLDqQbpHYiIU1Do/2mfGJNgXA7NSS2spLMbPIbCcXddV1mzgteZfAkFy
	zL77KOgw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfoL-0000000FfRP-2kNh;
	Tue, 12 May 2026 05:37:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 09/12] swap: push down setting sis->bdev into ->swap_activate
Date: Tue, 12 May 2026 07:35:25 +0200
Message-ID: <20260512053625.2950900-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: px8dr9mopz5z1aybo8j4ys7ptoh4x4q1
X-Rspam-User: 
X-Rspamd-Queue-Id: 98E1EA0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778564270-67831
X-HE-Meta: U2FsdGVkX19t/n7ATWFPi4itkLo47R+3NCKVNrqWQSuG/lHcgzX/qKFSl65yTW+poXWqyziXn8Xxoft3yErmXVdjX+1Y82ddoNWHZYz6fso9XS8Voc2YbibDsN6Fo0ncbFoSjumzMhj+EJP8/AAxiCS2gG6xhTru53CLAmmxcjxKlr8KfOtre1FNf2ASL1x25ebminrZ7fBLkANtTA0mSN+Er4RlR6AdA33rN0XeHXrgeGtmV0uFo63Et4gHa3+rF/fRQV6XyBjo3KEh5Q+u9Ifa3LxEca7Ok/HP+S9zjaLJfIV3+UipkqwwW/e5vPMTGiAAfA3iEYh6S8giglfbSH5rrf6tc+ZcxMD0ufMDWzZ2kixx4dgyh2FogOeyJeux+Oftsu6fWhZhU5/+woMfCbXRzUHz0FaGAuTCzJg7PFDbMvpt4KaNSL2e5P3y9mTpayhbNoQQtBdGGaS5jZZhCQqobbKuwdf4DMHBNuLc99G08+PBUlkNtm9V6W7x3OSRsCjdfj6+SyNT5bH1AZMxMAoz4KYvwWVBDqy7fLe858AHXhRgKRMp0ZHd2eLrt4hwRqqIj6D522qmbpnAvph08ZOJ8XX9TfcRFCNpON01Mb8ZaNIoV6qnea5ZZGsI7J5y2hafh9ZE9QtJQ3bHQNeQD4hXdq4h/ovLRUWJG3qMOfRfqLnFRe8dr007fD8sOFEPEm36UaVBneWoxWMuIexgJMRveevlristp/Nty/s/yzcoIOsglpQ4mqGGkqArWzhPKbzzAYmlR3+Tay8IUPdFRgHHr/YyHMBtyOh94Rgb4pc3ixhBICfLaQxpTBRKhUyLUBJuoB3r6f+zlNVfcMONFX4FAibXxu5Yh1mmzYMEY3gbHKWU2KYzskPginbdXlsqAcd70HLa7JuCXcZHJqvE4+RXeBDgdOCXbbkWmVFg+ufKOTBn0CUmvxfCAE8oAnM6Bn0yzs7XWoR8QqnQBH9
 2PZnOLHk
 UUvAt02ixVHg9b4B+EcRJcUthkZyuKWz6dXvf6HaeaVny9jJfYZ1XPsfRcXEfrNpwaYuV3ikfOcGukY4g4wnZGRyZkhcSItd0EYAZqcn0+jXDXilUYtgwVYgyk5Uh8SsdG2SQu+AjU5OA5Sm1rCf9I7T5AfYDnG+Qsuxroxl7Macomx2yo/Yu2u9zIn89PwCzHMs13P+Pj7ftticcLxgw/94kbiq0+A4TeNrGZbQbqJAnI1nNbatLHbqLPFxQ8SprUVYm7OzHuUlv1j5hE+c3Op098OrFL5O+lo3YOhDKPGJE52tnivuPxCVeQUEik2WP0CXI0v1Oh634nPWc/bAiMSJWzTfEssTO+1UP7CzqhDzy8phv0m25qYHclk4jhQnY9igaQu7tHcnK/yXHkceRIqNdDBRHNGEiTx4gshJe1Du94z7wx2dDG50yz0ruTcQpg9CsD6qvcO1Q9uE2qRTgNPzGfvAKXFlj6cCIYbdfGNbA2ox5TIqP1C6Xs4plYPafqUZEQII4psbpdqtHt4nkpYjMSOjDDuF6TMIje/3o+Y8pqAgP/tpU/eh3iaxq25d91IDigf3jqhXWNObXFO+Ky9Rgyxkl/kW+XCA1HLPgmwbID2PtDKCwwIHOGgHJe3PxL544PRnKDLIOTHacD22dunxO7+Y63cP+FKh+3Qj8LDIdXfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only the file operation method knows what block device we'll swap
to.  So move down setting sis->bdev and the special blockdev flag
into ->swap_activate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c         |  9 ++++++++-
 fs/btrfs/inode.c     |  7 ++++---
 fs/f2fs/data.c       |  3 ++-
 fs/iomap/swapfile.c  |  7 ++-----
 fs/nfs/file.c        |  2 +-
 fs/smb/client/file.c |  2 +-
 fs/xfs/xfs_file.c    |  6 ------
 include/linux/swap.h |  4 ++--
 mm/page_io.c         |  3 +--
 mm/swapfile.c        | 38 ++++++++++++--------------------------
 10 files changed, 33 insertions(+), 48 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 067e46299666..da09ce3f072f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -951,9 +951,16 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
 
 static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
 {
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	loff_t isize = i_size_read(bdev_file_inode(file));
 
-	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), 0);
+	/*
+	 * The swap code performs arbitrary overwrites, which are not supported
+	 * on zones with sequential write constraints.
+	 */
+	if (bdev_is_zoned(bdev))
+		return -EINVAL;
+	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), bdev, 0);
 }
 
 const struct file_operations def_blk_fops = {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ee0a7947706a..84003c520530 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10201,6 +10201,7 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
 }
 
 struct btrfs_swap_info {
+	struct btrfs_device *device;
 	u64 start;
 	u64 block_start;
 	u64 block_len;
@@ -10214,7 +10215,8 @@ static int btrfs_add_swap_extent(struct swap_info_struct *sis,
 	first_ppage = PAGE_ALIGN(bsi->block_start) >> PAGE_SHIFT;
 	next_ppage = PAGE_ALIGN_DOWN(bsi->block_start + bsi->block_len) >> PAGE_SHIFT;
 
-	return add_swap_extent(sis, next_ppage - first_ppage, first_ppage);
+	return add_swap_extent(sis, next_ppage - first_ppage, bsi->device->bdev,
+			first_ppage);
 }
 
 void btrfs_swap_deactivate(struct file *file)
@@ -10503,6 +10505,7 @@ int btrfs_swap_activate(struct file *file, struct swap_info_struct *sis)
 			bsi.start = key.offset;
 			bsi.block_start = physical_block_start;
 			bsi.block_len = len;
+			bsi.device = device;
 		}
 
 		if (fatal_signal_pending(current)) {
@@ -10533,8 +10536,6 @@ int btrfs_swap_activate(struct file *file, struct swap_info_struct *sis)
 	up_write(&BTRFS_I(inode)->i_mmap_lock);
 	btrfs_free_backref_share_ctx(backref_ctx);
 	btrfs_free_path(path);
-	if (!ret && device)
-		sis->bdev = device->bdev;
 	return ret;
 }
 #endif
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8bcf630df557..8d116ff517c9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4326,7 +4326,8 @@ static int check_swap_activate(struct swap_info_struct *sis,
 		/*
 		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
 		 */
-		ret = add_swap_extent(sis, nr_pblocks, pblock);
+		ret = add_swap_extent(sis, nr_pblocks, inode->i_sb->s_bdev,
+				pblock);
 		if (ret < 0)
 			goto out;
 		cur_lblock += nr_pblocks;
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index a4e0ca462cc4..862b4c02a8bd 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -50,10 +50,6 @@ static int iomap_swapfile_iter(struct iomap_iter *iter, struct file *file,
 	if (iomap->flags & IOMAP_F_SHARED)
 		return iomap_swapfile_fail(file, "has shared extents");
 
-	/* Only one bdev per swap file. */
-	if (iomap->bdev != sis->bdev)
-		return iomap_swapfile_fail(file, "outside the main device");
-
 	/*
 	 * Round the start up and the end down so that the physical extent
 	 * aligns to a page boundary.
@@ -61,7 +57,8 @@ static int iomap_swapfile_iter(struct iomap_iter *iter, struct file *file,
 	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
 	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
 			PAGE_SHIFT;
-	error = add_swap_extent(sis, next_ppage - first_ppage, first_ppage);
+	error = add_swap_extent(sis, next_ppage - first_ppage, iomap->bdev,
+			first_ppage);
 	if (error)
 		return error;
 	return iomap_iter_advance_full(iter);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 2bc55d9d71e1..10ab2a923835 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -588,7 +588,7 @@ int nfs_swap_activate(struct file *file, struct swap_info_struct *sis)
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = add_swap_extent(sis, sis->max, 0);
+	ret = add_swap_extent(sis, sis->max, NULL, 0);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 84459f87907e..e1bbc65ce7f3 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3327,7 +3327,7 @@ int cifs_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
 	 */
 
 	sis->flags |= SWP_FS_OPS;
-	return add_swap_extent(sis, sis->max, 0);
+	return add_swap_extent(sis, sis->max, NULL, 0);
 }
 
 void cifs_swap_deactivate(struct file *file)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 41f7e19bd31f..74128ebf7161 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -2116,12 +2116,6 @@ xfs_file_swap_activate(
 	 */
 	xfs_inodegc_flush(ip->i_mount);
 
-	/*
-	 * Direct the swap code to the correct block device when this file
-	 * sits on the RT device.
-	 */
-	sis->bdev = xfs_inode_buftarg(ip)->bt_bdev;
-
 	return iomap_swap_activate(file, sis, &xfs_read_iomap_ops);
 }
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 657779485ae4..b1cbb67ddd8e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -404,7 +404,7 @@ extern void __meminit kswapd_stop(int nid);
 #ifdef CONFIG_SWAP
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
-		sector_t start_block);
+		struct block_device *bdev, sector_t start_block);
 int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis);
 
 static inline unsigned long total_swapcache_pages(void)
@@ -528,7 +528,7 @@ static inline bool folio_free_swap(struct folio *folio)
 
 static inline int add_swap_extent(struct swap_info_struct *sis,
 		unsigned long start_page, unsigned long nr_pages,
-		sector_t start_block)
+		struct block_device *bdev, sector_t start_block)
 {
 	return -EINVAL;
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index 3e1c12649448..2ab8994ed1c2 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -132,7 +132,7 @@ int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
 		/*
 		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
 		 */
-		ret = add_swap_extent(sis, 1,
+		ret = add_swap_extent(sis, 1, inode->i_sb->s_bdev,
 				first_block >> (PAGE_SHIFT - blkbits));
 		if (ret < 0)
 			return ret;
@@ -141,7 +141,6 @@ int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
 		continue;
 	}
 	return 0;
-
 bad_bmap:
 	pr_err("swapon: swapfile has holes\n");
 	return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fbf11c8c5c69..2c9d2af736c4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2707,7 +2707,7 @@ static void destroy_swap_extents(struct swap_info_struct *sis,
  */
 int
 add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
-		sector_t start_block)
+		struct block_device *bdev, sector_t start_block)
 {
 	struct rb_node **link = &sis->swap_extent_root.rb_node, *parent = NULL;
 	struct swap_extent *se;
@@ -2718,6 +2718,12 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
 		return 0;
 	nr_pages = min(nr_pages, sis->max - sis->pages);
 
+	/* Only one bdev per swap file for now. */
+	if (!sis->bdev)
+		sis->bdev = bdev;
+	else if (bdev != sis->bdev)
+		return -EINVAL;
+
 	/*
 	 * place the new node at the right most since the
 	 * function is called in ascending page order.
@@ -2793,6 +2799,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	sis->flags |= SWP_ACTIVATED;
 	if (sis->flags & SWP_FS_OPS)
 		error = sio_pool_init();
+	else if (WARN_ON_ONCE(!sis->bdev))
+		error = -EINVAL;
 	if (error)
 		destroy_swap_extents(sis, swap_file);
 	return error;
@@ -3224,26 +3232,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	return p;
 }
 
-static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
-{
-	if (S_ISBLK(inode->i_mode)) {
-		si->bdev = I_BDEV(inode);
-		/*
-		 * Zoned block devices contain zones that have a sequential
-		 * write only restriction.  Hence zoned block devices are not
-		 * suitable for swapping.  Disallow them here.
-		 */
-		if (bdev_is_zoned(si->bdev))
-			return -EINVAL;
-		si->flags |= SWP_BLKDEV;
-	} else if (S_ISREG(inode->i_mode)) {
-		si->bdev = inode->i_sb->s_bdev;
-	}
-
-	return 0;
-}
-
-
 /*
  * Find out how many pages are allowed for a single swap device. There
  * are two limiting factors:
@@ -3500,16 +3488,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
 
-	error = claim_swapfile(si, inode);
-	if (unlikely(error))
-		goto bad_swap;
-
 	inode_lock(inode);
 	if (d_unlinked(dentry) || cant_mount(dentry)) {
 		error = -ENOENT;
 		goto bad_swap_unlock_inode;
 	}
-	if (!S_ISBLK(inode->i_mode) && !S_ISREG(inode->i_mode)) {
+	if (S_ISBLK(inode->i_mode)) {
+		si->flags |= SWP_BLKDEV;
+	} else if (!S_ISREG(inode->i_mode)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
-- 
2.53.0


