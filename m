Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D15DCF6487
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 22:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C1E6B00AC; Wed, 19 Nov 2025 17:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CD26B00AD; Wed, 19 Nov 2025 17:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB9C6B00AF; Wed, 19 Nov 2025 17:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 673B66B00AC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:42:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FD39160673
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:42:49 +0000 (UTC)
X-FDA: 84128832858.14.A965AED
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	by imf02.hostedemail.com (Postfix) with ESMTP id E017680012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:42:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b=zAjm3AIV;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux_spam@runbox.com designates 185.226.149.37 as permitted sender) smtp.mailfrom=david.laight.linux_spam@runbox.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763592167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO7m5qP2A9vVNTA8gRtFqJvwI1Y/pavLSEelmj0I3GM=;
	b=pwaSDsSPZOy14VB/DYkw3ABJJzpscYEvq9CFssORHzXZoFF+kl/4iUHeT84k8QibQCxMwg
	RVI+nV+kB9HkaGoEL97bYSR1XqfagxPaCfaWDXktMEVDob0zATofvaI9JEyvfRuI2V3slw
	icd9Vc756P4XOcc7kJouhwONkiBbvhE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b=zAjm3AIV;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux_spam@runbox.com designates 185.226.149.37 as permitted sender) smtp.mailfrom=david.laight.linux_spam@runbox.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763592167; a=rsa-sha256;
	cv=none;
	b=qBEYmqRK0TXYyr3MR/1l27uQ2GXPaS33gqdRW39GFJlV9c4RzKD3sVxWFUm0GOinzOun4Z
	ghimYFVEQpA42NXIvx1HfxFaKqj0LHsRXG8rAr9s3E9V8PqeG91vN//zt9rREnMwK3UjUz
	SW/1SKoYoRQL5z+4OD9OTwPPSKvDbBc=
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqst-006yqT-V1; Wed, 19 Nov 2025 23:42:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=vO7m5qP2A9vVNTA8gRtFqJvwI1Y/pavLSEelmj0I3GM=; b=zAjm3AIVhb5JXtwqa2DXJ3XcjP
	NRHRr2fM2TOD1SDfChTuYTNW6Xw2SqIbJFjG/OWGO8y4iW7cKtluhdsFRF0JLpm9xJpD1t05rLP16
	dYHKZ9/5NlKar3NX7NN3Aw/Xh902jfi6XdGEWcb+4BSjxJsOGIijJNy/xSHfTuqKkjY4NXgQjW1Mn
	V8wzx3P8ulJpjvIyvLv1Stl/Lxb0T3Kf+FlOCeMbGvAUwZzaaXwkDel56c/Wl4Ggs1qtmHedINWr8
	iXQVLFtPr6RKgEr19snAdxhuDWgV1SFWopndEL7GjrTCQQnEh5nzTPrSU5sxT4Xl4TxR/FE9bIVT1
	r49qx26g==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqst-0000Ch-EE; Wed, 19 Nov 2025 23:42:43 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsj-00Fos6-5A; Wed, 19 Nov 2025 23:42:33 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	"Theodore Ts'o" <tytso@mit.edu>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:26 +0000
Message-Id: <20251119224140.8616-31-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E017680012
X-Stat-Signature: w765ohwneizthjz7mnqyk7xfqu4rkmu1
X-Rspam-User: 
X-HE-Tag: 1763592166-84069
X-HE-Meta: U2FsdGVkX1/4hL9OUVy5lQzui+Ok9hH++xWZCmeM3HDptxF28pn0dIktU6S3SzaKdg7aQBvZ/x/WBXjbg7VIx8ym/VDOG6WM4dgRMhg5N/XPrYnemTQEPuUnRiPigsX0GXbTdbfXSitiLUaZeJyUZvp5/5r3nPT0NzpYbKaRboqkbCjq7JqzfhmrMJtJ9vtAcEuKf8xzNH2FeyxwFqIbnQLHbciCr+y2F+xUr2BhZ/oUVemvOnyyfSJnnwA7pNQIXErLPQiLPTVVWGc40EIG0+R7IJDZTsUqqWr2aIqVOyJnNEx8vp+zhKpzrnarWMxUMauqiXeEcjqr/aLxFl/+5SIGWxXqnU0sryyPp3rgSTEJ+1fyeWxOPmNCdmSDsg6xXUkK5SHAcIrJkX/ezodcxK63EjH+3x24vAeHWupuoVBo12MLG/8Hw+5L6x9oupgDZUGuwB41CvPqumSwndy9FXr0wxmtxmYyNlo4bbVzPMV6jKduHcmFJZPZh77P/JiGJOf0ryRDI5MNITiqHKQ5/1jv00EuJjoFaVtCWDhwJixt71L6evuELJ0LNofkohThvJQvwjaoW9+JnSssXspDtm1B7seLkWIBSMS/MyZ57XPd+MHFJRypEkaUOXGmBebwwTa3H2B8xeIj3CKHRty2oxqsKIWGn76fAuBu9ZkpG4v/u0M4N2TrUYD6b2sP7Tsb44/rXcU30Nb+gIXTEmQ30hvstDuvihW9y2++IB7wliZfxUyoMNP6mab33drBEXu4zpul6T0YkKr6r8/z5WclyG3f8UBG8KvC73dv/u8Wxg8NT0w1VInFzNR42THtnELWQISl9DKlSSvsFdzwB3jP6Y8qjKNSF9rVx9s1RStlxggASeUCeMGKXC5kUguTiGo8bGJ74k5q8WtCSrWY/Jw606QxzOCoH8BP0qNx9pJmI4ZCDFoPNTWG0n2/S5/283Nx1dlySKIupCFxJHSLGbO
 0wxhrApE
 XNeQFCgrLXz66tEdS+OWAP0kgaoAKKVNDXM3zJ2K6PlPYncIkHGZHUdOxzWuyjmeTzP8zJ3MV45XZXG7+Vd4uUY4vARMSrudcAovB/hIFpfKNQoCsP6DCWVA4Cdh8PVB78OcQhWfl8wrUwjvNyU0YQukvVKz3/kSt8bYbYqiJf80HX81XmEKlVTWDJVIIhSxfKavhO1mHmRHirQREmR8Hppmi7zI/6HPKTMG6IjEnCs75M+vmTYC9TXgcE3KzOaOLMwaYnEz1L5ZTJ0vW6thX92k+Vr0QHFOlfLZtK/y6j3v7u8IM3kdhyZywj07erFAGHSEOFQ/mOFJ2s7Yn/OMGEKfdUpzmo/lT2Qc6wGKc185dxWICviR0PpcmVqqIxgQ/Wi0hVHAV3k9TKsQMatJEQp8s3meQyjZb5Ru7zEJRS/kOI7JXM5dPg7GffRjDildkJ0zDhz/VceYCFeq0xOUXPDyiPfce8NeUtN67LsklhOhQwSc0YdBLTVtiTFq0gPQWxU07VUHd2BCofAYgftD2zwWGRG6Tfyi+rG0ai4pgs7XdJDhvkRg8xkP+yYOCaGdldn/gNMHdVecREr19BXfvzr88pNdWN5/CGFBi2V9KjJS/2eqkJA/Y7lhUMi5Pq3rk5M0nC46zed625MTQ/p3fXEy9zvRLwPDTlc9Y1rfOt67iVxeqgFDH3GVoY2pxcqAp1agoBooIABWU4aG7wMBFjMujLLjFe7rUNxiSAD946xtvgpBoomnmEB1UxMs+NFfcSrX8Td6WSvllVY1yA4DadS2D0HrDAzMQWLwmZmSJMvLS9lM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <david.laight.linux@gmail.com>

min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
and so cannot discard significant bits.

A couple of places need umin() because of loops like:
	nfolios = DIV_ROUND_UP(ret + start, PAGE_SIZE);

	for (i = 0; i < nfolios; i++) {
		struct folio *folio = page_folio(pages[i]);
		...
		unsigned int len = umin(ret, PAGE_SIZE - start);
		...
		ret -= len;
		...
	}
where the compiler doesn't track things well enough to know that
'ret' is never negative.

The alternate loop:
        for (i = 0; ret > 0; i++) {
                struct folio *folio = page_folio(pages[i]);
                ...
                unsigned int len = min(ret, PAGE_SIZE - start);
                ...
                ret -= len;
                ...
        }
would be equivalent and doesn't need 'nfolios'.

Most of the 'unsigned long' actually come from PAGE_SIZE.

Detected by an extra check added to min_t().

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 fs/buffer.c       | 2 +-
 fs/exec.c         | 2 +-
 fs/ext4/mballoc.c | 3 +--
 fs/ext4/resize.c  | 2 +-
 fs/ext4/super.c   | 2 +-
 fs/fat/dir.c      | 4 ++--
 fs/fat/file.c     | 3 +--
 fs/fuse/dev.c     | 2 +-
 fs/fuse/file.c    | 8 +++-----
 fs/splice.c       | 2 +-
 10 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6a8752f7bbed..26c4c760b6c6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2354,7 +2354,7 @@ bool block_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
 	if (!head)
 		return false;
 	blocksize = head->b_size;
-	to = min_t(unsigned, folio_size(folio) - from, count);
+	to = min(folio_size(folio) - from, count);
 	to = from + to;
 	if (from < blocksize && to > folio_size(folio) - blocksize)
 		return false;
diff --git a/fs/exec.c b/fs/exec.c
index 4298e7e08d5d..6d699e48df82 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -555,7 +555,7 @@ int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
 		return -E2BIG;
 
 	while (len > 0) {
-		unsigned int bytes_to_copy = min_t(unsigned int, len,
+		unsigned int bytes_to_copy = min(len,
 				min_not_zero(offset_in_page(pos), PAGE_SIZE));
 		struct page *page;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9087183602e4..cb68ea974de6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4254,8 +4254,7 @@ void ext4_mb_mark_bb(struct super_block *sb, ext4_fsblk_t block,
 		 * get the corresponding group metadata to work with.
 		 * For this we have goto again loop.
 		 */
-		thisgrp_len = min_t(unsigned int, (unsigned int)len,
-			EXT4_BLOCKS_PER_GROUP(sb) - EXT4_C2B(sbi, blkoff));
+		thisgrp_len = min(len, EXT4_BLOCKS_PER_GROUP(sb) - EXT4_C2B(sbi, blkoff));
 		clen = EXT4_NUM_B2C(sbi, thisgrp_len);
 
 		if (!ext4_sb_block_valid(sb, NULL, block, thisgrp_len)) {
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 050f26168d97..76842f0957b5 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1479,7 +1479,7 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
-	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+	sbi->s_blockfile_groups = min(sbi->s_groups_count,
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 33e7c08c9529..e116fe48ff43 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4830,7 +4830,7 @@ static int ext4_check_geometry(struct super_block *sb,
 		return -EINVAL;
 	}
 	sbi->s_groups_count = blocks_count;
-	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+	sbi->s_blockfile_groups = min(sbi->s_groups_count,
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 	if (((u64)sbi->s_groups_count * sbi->s_inodes_per_group) !=
 	    le32_to_cpu(es->s_inodes_count)) {
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 92b091783966..8375e7fbc1a5 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1353,7 +1353,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 
 		/* Fill the long name slots. */
 		for (i = 0; i < long_bhs; i++) {
-			int copy = min_t(int, sb->s_blocksize - offset, size);
+			int copy = umin(sb->s_blocksize - offset, size);
 			memcpy(bhs[i]->b_data + offset, slots, copy);
 			mark_buffer_dirty_inode(bhs[i], dir);
 			offset = 0;
@@ -1364,7 +1364,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			err = fat_sync_bhs(bhs, long_bhs);
 		if (!err && i < nr_bhs) {
 			/* Fill the short name slot. */
-			int copy = min_t(int, sb->s_blocksize - offset, size);
+			int copy = umin(sb->s_blocksize - offset, size);
 			memcpy(bhs[i]->b_data + offset, slots, copy);
 			mark_buffer_dirty_inode(bhs[i], dir);
 			if (IS_DIRSYNC(dir))
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 4fc49a614fb8..f48435e586c7 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -140,8 +140,7 @@ static int fat_ioctl_fitrim(struct inode *inode, unsigned long arg)
 	if (copy_from_user(&range, user_range, sizeof(range)))
 		return -EFAULT;
 
-	range.minlen = max_t(unsigned int, range.minlen,
-			     bdev_discard_granularity(sb->s_bdev));
+	range.minlen = max(range.minlen, bdev_discard_granularity(sb->s_bdev));
 
 	err = fat_trim_fs(inode, &range);
 	if (err < 0)
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 132f38619d70..0c9fb0db1de1 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1813,7 +1813,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 			goto out_iput;
 
 		folio_offset = ((index - folio->index) << PAGE_SHIFT) + offset;
-		nr_bytes = min_t(unsigned, num, folio_size(folio) - folio_offset);
+		nr_bytes = min(num, folio_size(folio) - folio_offset);
 		nr_pages = (offset + nr_bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes, 0);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f1ef77a0be05..f4ffa559ad26 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1252,10 +1252,8 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 static inline unsigned int fuse_wr_pages(loff_t pos, size_t len,
 				     unsigned int max_pages)
 {
-	return min_t(unsigned int,
-		     ((pos + len - 1) >> PAGE_SHIFT) -
-		     (pos >> PAGE_SHIFT) + 1,
-		     max_pages);
+	return min(((pos + len - 1) >> PAGE_SHIFT) - (pos >> PAGE_SHIFT) + 1,
+		   max_pages);
 }
 
 static ssize_t fuse_perform_write(struct kiocb *iocb, struct iov_iter *ii)
@@ -1550,7 +1548,7 @@ static int fuse_get_user_pages(struct fuse_args_pages *ap, struct iov_iter *ii,
 			struct folio *folio = page_folio(pages[i]);
 			unsigned int offset = start +
 				(folio_page_idx(folio, pages[i]) << PAGE_SHIFT);
-			unsigned int len = min_t(unsigned int, ret, PAGE_SIZE - start);
+			unsigned int len = umin(ret, PAGE_SIZE - start);
 
 			ap->descs[ap->num_folios].offset = offset;
 			ap->descs[ap->num_folios].length = len;
diff --git a/fs/splice.c b/fs/splice.c
index f5094b6d00a0..41ce3a4ef74f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1467,7 +1467,7 @@ static ssize_t iter_to_pipe(struct iov_iter *from,
 
 		n = DIV_ROUND_UP(left + start, PAGE_SIZE);
 		for (i = 0; i < n; i++) {
-			int size = min_t(int, left, PAGE_SIZE - start);
+			int size = umin(left, PAGE_SIZE - start);
 
 			buf.page = pages[i];
 			buf.offset = start;
-- 
2.39.5


