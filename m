Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B88D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D0A6B008A; Fri,  9 Jan 2026 22:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DB06B0092; Fri,  9 Jan 2026 22:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7106B008C; Fri,  9 Jan 2026 22:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 280476B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:56:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A626C8AF3C
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:56:50 +0000 (UTC)
X-FDA: 84314692980.19.335CC72
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C6864000A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:56:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=V6SzP+af;
	dkim=pass header.d=suse.com header.s=susede1 header.b=V6SzP+af;
	spf=pass (imf07.hostedemail.com: domain of wqu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zA1qgtm4aA7baso3OZkf3sKtAKB0Bycvv+SiYEFeRkU=;
	b=Dwm8Z31riFdPZw5qm2hEMVk2IGDtWR5z46HqxixoVZwZQSCnxyb0QEfngcCadRYA9UsbD/
	y/RrQQgkvcgTUP+FcXRkCVLK3HFvkxUMwnBDpzXmfqqaL6F2vXFZZ0ndR9qWQDAnbxz22+
	58uJW60u+ZCxij36Hp1/c/KybvJE/2A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=V6SzP+af;
	dkim=pass header.d=suse.com header.s=susede1 header.b=V6SzP+af;
	spf=pass (imf07.hostedemail.com: domain of wqu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017408; a=rsa-sha256;
	cv=none;
	b=cRY7eA7fbb4t98b3ja3oUtkwvtriXovsI0fS1ycVsprV1fSaaVW5zbCnxY36aU0tlOi/H5
	I5lWs5L6Ne27kjRJrPMxm7tRGHGlafMAhnjdtv3Yt/I8t6ajBcF6VW4MtB0erkrVZm5Dzs
	SG1BhtFC2l00N66BIhh0zVdRMb6lwR4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 080145BCF3;
	Sat, 10 Jan 2026 03:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768017403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zA1qgtm4aA7baso3OZkf3sKtAKB0Bycvv+SiYEFeRkU=;
	b=V6SzP+affpmVFANhTenbqpJTMYcE0cXGBF5hPR56UgKFy67II+DG1iVjnxFDWtSIhV/iiG
	aS1GpUxx9fs/P92Gu/ObZANZr6ZAUTDNqkroiByWr3YTxLhDYsLJ7WTcr97a2lIcL4mOfG
	TX+pGuxNgc4go2LnV9mU3ztx5j4nEo4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768017403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zA1qgtm4aA7baso3OZkf3sKtAKB0Bycvv+SiYEFeRkU=;
	b=V6SzP+affpmVFANhTenbqpJTMYcE0cXGBF5hPR56UgKFy67II+DG1iVjnxFDWtSIhV/iiG
	aS1GpUxx9fs/P92Gu/ObZANZr6ZAUTDNqkroiByWr3YTxLhDYsLJ7WTcr97a2lIcL4mOfG
	TX+pGuxNgc4go2LnV9mU3ztx5j4nEo4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48CD73EA63;
	Sat, 10 Jan 2026 03:56:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aOU7A/nNYWlqLgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Jan 2026 03:56:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 1/3] btrfs: use bdev_rw_virt() to read and scratch the disk super block
Date: Sat, 10 Jan 2026 14:26:19 +1030
Message-ID: <829db7e054cd290b5aed0b337cd219da128ac0e7.1768017091.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768017091.git.wqu@suse.com>
References: <cover.1768017091.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8C6864000A
X-Stat-Signature: mm8yjz9ajqxzgdk713e715b9dbfxr39k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768017408-425487
X-HE-Meta: U2FsdGVkX197nuddyleJPhXXUU31KH5xxQ2Omu+Zol4A7EoWI1jvyQIJzDAFLXZxws8O1cE+/i7o24Xml7wZKtNMmYHFQzhr73eqHz0S6vU+PbpXo69P3abM5NkPk/ZUHPEEOgrqIXh7cm4NY0RW+CyEzddcKfPYO7CkmA6RHyGu9cZK14e3OfPp7/DOHlxmg1FU6JwydwnxepWPesKRBWw6uuTMLPBOE2NMxprH6zKDNIBIJyiM342Yl4wh+8ltVnGsxK5fLD/tbL6YjdM1CgeGorYOxH4KzOE3w7KY2E8xWt+xj64P650PVoPCP4KNJJhLL8EzrdlgZp3skBOryhPNfD6ZjLbhci48g8btyAg0FffgnsQdKx1YkCNHZLzs8fjQwv4ofJ6h1Ho7uOACsS2OKwVhOell9/cIyLnGBtHJcKrAKICbhCXwYq8xWf8TXic/heIXhg5dObKBYgThVijDAGOgH68ShDI2TGm2sYYgeVwkwkEnCIA3hDSZX03sfoAMTvSO0lpYjrt72YMmWQh7EEG02EPFZ4GbRK1h6bkXvgH7YZl27HP1GKy4M3vb1CcPvNE1JZuUPJsqmUj8fXkXUkrcgYlRQz6EaM/H3dvDBGog1hJgSATcidabIlkW5R4hcO82H5RVxJG1kexMog6zDGq7cdTICqhJBTeydrMG0TBfU1+1aOWYtso4Nx+dvCRq59f6nsSKQ8UOb2OAVPho5rdhFRGbGZrDTeh8hJlHInDDAYiAu3o0wx9F8JhpSRo5/KUHaPFWIM8pAf+feWnbZScZJ5q/ydMXVDKxqDQ3+kNvXpeMEd4BOmoi2SqqO1sSKljXc7Tq+NbKfs/aOjO7iF3jq8+dLTmHn/DUFG3rVyRC9ySDPAnB+MZFCeVLToXOkAj/RdMhB+RRVKhkts1LadakcrjkyTbdqDL7Ba94BXPI8rVdzuEpOXd01l6oiWefJDLWmzszFPV/2df
 ydwJk16J
 1ueTZOXnQ+ZzQHmLceDzIMWZAIqe056/ujf75bvMmb09Qk0DzzMq2JbuDnVwOFIOiUuyocvdmq0khl1YLi9ktYZv4f6dIuEvwB5M//FdsXSoxF1OK+6iIneJnqGXlGoBMt4zsvwlxHc0NRt+Q1gEo8REZlJuzvLVKegQc2qDlYT+ZkQOqoHArb4FCuWeGENpmRDkyeIcB1ukyTiHb6Fzgl9j3gD3HM6gUFK/3GAhwvEDjD4077xuRa7vZK5doa4Ogz7wfFCRGFDc1i0bH83yDv8OgQdod7ugVI1LTPlCBgQbcyqrC8m9574ZuQgZdnUt3ocus0mI7Y0onpQ5dzICjYUF07mhhj9873mk4LDVpFYi2q4HPYTHP256jxOdt9czUi0ZSmcbGc3ARmoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we're using the block device page cache to read and scratch
the super block.

But that means we're reading the whole folio to grab just the super
block, this can be unnecessary especially nowadays bdev's page cache
supports large folio, not to mention systems with page size larger than
4K.

Furthermore read_cache_page*() can race with device block size setting,
thus requires extra locking.

Modify the following routines by:

- Use kmalloc() + bdev_rw_virt() for btrfs_read_disk_super()
  This means we can easily replace btrfs_release_disk_super() with a
  simple kfree().

  This also means there will no longer be any cached read for
  btrfs_read_disk_super(), thus we can drop the @drop_cache parameter.

  However this change brings a slightly behavior change for
  btrfs_scan_one_device(), now every time the device is scanned, btrfs
  will submit a read request, no more cached scan.

- Use bdev_rw_virt() for btrfs_scratch_superblock()
  Just use the memory returned by btrfs_read_disk_super() and reset the
  magic number.
  Then use bdev_rw_virt() to do the write.

  And since we're using bio to submit writes directly to the device, not
  using page cache anymore, after scratching the super block we also
  have to invalidate the cache to avoid user space seeing the
  out-of-date cached super block.

- Use kmalloc() and bdev_rw_virt() for sb_writer_pointer()
  In zoned mode we have a corner case that both super block zones are
  full, and we need to determine which zone to reuse.

  In that case we need to read the last super block of both zones and
  compare their generations.

  Here we just use regular kmalloc() + bdev_rw_virt() to do the read.

  And since we're here, simplify the error handling path by always
  calling kfree() on both super blocks.
  Since both super block pointers are initialized to NULL, we're safe to
  call kfree() on them.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c |  8 ++---
 fs/btrfs/super.c   |  4 +--
 fs/btrfs/volumes.c | 74 ++++++++++++++++++----------------------------
 fs/btrfs/volumes.h |  4 +--
 fs/btrfs/zoned.c   | 26 +++++++++-------
 5 files changed, 51 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7ce7afe2bdaf..0dd77b56dfdf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3269,7 +3269,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/*
 	 * Read super block and check the signature bytes only
 	 */
-	disk_super = btrfs_read_disk_super(fs_devices->latest_dev->bdev, 0, false);
+	disk_super = btrfs_read_disk_super(fs_devices->latest_dev->bdev, 0);
 	if (IS_ERR(disk_super)) {
 		ret = PTR_ERR(disk_super);
 		goto fail_alloc;
@@ -3285,7 +3285,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		btrfs_err(fs_info, "unsupported checksum algorithm: %u",
 			  csum_type);
 		ret = -EINVAL;
-		btrfs_release_disk_super(disk_super);
+		kfree(disk_super);
 		goto fail_alloc;
 	}
 
@@ -3301,7 +3301,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (btrfs_check_super_csum(fs_info, disk_super)) {
 		btrfs_err(fs_info, "superblock checksum mismatch");
 		ret = -EINVAL;
-		btrfs_release_disk_super(disk_super);
+		kfree(disk_super);
 		goto fail_alloc;
 	}
 
@@ -3311,7 +3311,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * the whole block of INFO_SIZE
 	 */
 	memcpy(fs_info->super_copy, disk_super, sizeof(*fs_info->super_copy));
-	btrfs_release_disk_super(disk_super);
+	kfree(disk_super);
 
 	disk_super = fs_info->super_copy;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d64d303b6edc..f884260d7233 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2317,7 +2317,7 @@ static int check_dev_super(struct btrfs_device *dev)
 		return 0;
 
 	/* Only need to check the primary super block. */
-	sb = btrfs_read_disk_super(dev->bdev, 0, true);
+	sb = btrfs_read_disk_super(dev->bdev, 0);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 
@@ -2349,7 +2349,7 @@ static int check_dev_super(struct btrfs_device *dev)
 		goto out;
 	}
 out:
-	btrfs_release_disk_super(sb);
+	kfree(sb);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 908a89eaeabf..2969e2b96538 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -495,7 +495,7 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 		}
 	}
 	invalidate_bdev(bdev);
-	*disk_super = btrfs_read_disk_super(bdev, 0, false);
+	*disk_super = btrfs_read_disk_super(bdev, 0);
 	if (IS_ERR(*disk_super)) {
 		ret = PTR_ERR(*disk_super);
 		bdev_fput(*bdev_file);
@@ -716,12 +716,12 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 		fs_devices->rw_devices++;
 		list_add_tail(&device->dev_alloc_list, &fs_devices->alloc_list);
 	}
-	btrfs_release_disk_super(disk_super);
+	kfree(disk_super);
 
 	return 0;
 
 error_free_page:
-	btrfs_release_disk_super(disk_super);
+	kfree(disk_super);
 	bdev_fput(bdev_file);
 
 	return -EINVAL;
@@ -1325,20 +1325,11 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
-void btrfs_release_disk_super(struct btrfs_super_block *super)
-{
-	struct page *page = virt_to_page(super);
-
-	put_page(page);
-}
-
 struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
-						int copy_num, bool drop_cache)
+						int copy_num)
 {
 	struct btrfs_super_block *super;
-	struct page *page;
 	u64 bytenr, bytenr_orig;
-	struct address_space *mapping = bdev->bd_mapping;
 	int ret;
 
 	bytenr_orig = btrfs_sb_offset(copy_num);
@@ -1352,28 +1343,19 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 	if (bytenr + BTRFS_SUPER_INFO_SIZE >= bdev_nr_bytes(bdev))
 		return ERR_PTR(-EINVAL);
 
-	if (drop_cache) {
-		/* This should only be called with the primary sb. */
-		ASSERT(copy_num == 0);
-
-		/*
-		 * Drop the page of the primary superblock, so later read will
-		 * always read from the device.
-		 */
-		invalidate_inode_pages2_range(mapping, bytenr >> PAGE_SHIFT,
-				      (bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
+	super = kmalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
+	if (!super)
+		return ERR_PTR(-ENOMEM);
+	ret = bdev_rw_virt(bdev, bytenr >> SECTOR_SHIFT, super, BTRFS_SUPER_INFO_SIZE,
+			   REQ_OP_READ);
+	if (ret < 0) {
+		kfree(super);
+		return ERR_PTR(ret);
 	}
 
-	filemap_invalidate_lock(mapping);
-	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
-	filemap_invalidate_unlock(mapping);
-	if (IS_ERR(page))
-		return ERR_CAST(page);
-
-	super = page_address(page);
 	if (btrfs_super_magic(super) != BTRFS_MAGIC ||
 	    btrfs_super_bytenr(super) != bytenr_orig) {
-		btrfs_release_disk_super(super);
+		kfree(super);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1474,7 +1456,7 @@ struct btrfs_device *btrfs_scan_one_device(const char *path,
 	if (IS_ERR(bdev_file))
 		return ERR_CAST(bdev_file);
 
-	disk_super = btrfs_read_disk_super(file_bdev(bdev_file), 0, false);
+	disk_super = btrfs_read_disk_super(file_bdev(bdev_file), 0);
 	if (IS_ERR(disk_super)) {
 		device = ERR_CAST(disk_super);
 		goto error_bdev_put;
@@ -1496,7 +1478,7 @@ struct btrfs_device *btrfs_scan_one_device(const char *path,
 		btrfs_free_stale_devices(device->devt, device);
 
 free_disk_super:
-	btrfs_release_disk_super(disk_super);
+	kfree(disk_super);
 
 error_bdev_put:
 	bdev_fput(bdev_file);
@@ -2119,20 +2101,22 @@ static void btrfs_scratch_superblock(struct btrfs_fs_info *fs_info,
 				     struct block_device *bdev, int copy_num)
 {
 	struct btrfs_super_block *disk_super;
-	const size_t len = sizeof(disk_super->magic);
 	const u64 bytenr = btrfs_sb_offset(copy_num);
 	int ret;
 
-	disk_super = btrfs_read_disk_super(bdev, copy_num, false);
-	if (IS_ERR(disk_super))
-		return;
-
-	memset(&disk_super->magic, 0, len);
-	folio_mark_dirty(virt_to_folio(disk_super));
-	btrfs_release_disk_super(disk_super);
-
-	ret = sync_blockdev_range(bdev, bytenr, bytenr + len - 1);
-	if (ret)
+	disk_super = btrfs_read_disk_super(bdev, copy_num);
+	if (IS_ERR(disk_super)) {
+		ret = PTR_ERR(disk_super);
+		goto out;
+	}
+	btrfs_set_super_magic(disk_super, 0);
+	ret = bdev_rw_virt(bdev, bytenr >> SECTOR_SHIFT, disk_super,
+			   BTRFS_SUPER_INFO_SIZE, REQ_OP_WRITE);
+	kfree(disk_super);
+out:
+	/* Make sure userspace won't see some out-of-date cached super block. */
+	invalidate_bdev(bdev);
+	if (ret < 0)
 		btrfs_warn(fs_info, "error clearing superblock number %d (%d)",
 			copy_num, ret);
 }
@@ -2462,7 +2446,7 @@ int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
 		memcpy(args->fsid, disk_super->metadata_uuid, BTRFS_FSID_SIZE);
 	else
 		memcpy(args->fsid, disk_super->fsid, BTRFS_FSID_SIZE);
-	btrfs_release_disk_super(disk_super);
+	kfree(disk_super);
 	bdev_fput(bdev_file);
 	return 0;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 93f45410931e..6381420800fb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -780,9 +780,7 @@ struct btrfs_chunk_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
 					    u64 logical, u64 length);
 void btrfs_remove_chunk_map(struct btrfs_fs_info *fs_info, struct btrfs_chunk_map *map);
 struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
-						int copy_num, bool drop_cache);
-void btrfs_release_disk_super(struct btrfs_super_block *super);
-
+						int copy_num);
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
 {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2e861eef5cd8..301e342776b2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -122,23 +122,27 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 		return -ENOENT;
 	} else if (full[0] && full[1]) {
 		/* Compare two super blocks */
-		struct address_space *mapping = bdev->bd_mapping;
-		struct page *page[BTRFS_NR_SB_LOG_ZONES];
-		struct btrfs_super_block *super[BTRFS_NR_SB_LOG_ZONES];
+		struct btrfs_super_block *super[BTRFS_NR_SB_LOG_ZONES] = { 0 };
 
 		for (int i = 0; i < BTRFS_NR_SB_LOG_ZONES; i++) {
 			u64 zone_end = (zones[i].start + zones[i].capacity) << SECTOR_SHIFT;
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
+			int ret;
 
-			page[i] = read_cache_page_gfp(mapping,
-					bytenr >> PAGE_SHIFT, GFP_NOFS);
-			if (IS_ERR(page[i])) {
-				if (i == 1)
-					btrfs_release_disk_super(super[0]);
-				return PTR_ERR(page[i]);
+			super[i] = kmalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
+			if (!super[i]) {
+				kfree(super[0]);
+				kfree(super[1]);
+				return -ENOMEM;
+			}
+			ret = bdev_rw_virt(bdev, bytenr >> SECTOR_SHIFT, super[i],
+					   BTRFS_SUPER_INFO_SIZE, REQ_OP_READ);
+			if (ret < 0) {
+				kfree(super[0]);
+				kfree(super[1]);
+				return ret;
 			}
-			super[i] = page_address(page[i]);
 		}
 
 		if (btrfs_super_generation(super[0]) >
@@ -148,7 +152,7 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			sector = zones[0].start;
 
 		for (int i = 0; i < BTRFS_NR_SB_LOG_ZONES; i++)
-			btrfs_release_disk_super(super[i]);
+			kfree(super[i]);
 	} else if (!full[0] && (empty[1] || full[1])) {
 		sector = zones[0].wp;
 	} else if (full[0]) {
-- 
2.52.0


