Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221CECA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 13:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58526B008C; Thu,  8 Oct 2026 09:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E086A6B0092; Thu,  8 Oct 2026 09:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8296B0093; Thu,  8 Oct 2026 09:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A67DE6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:08:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2915E1C2830
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:08:04 +0000 (UTC)
X-FDA: 85299486888.10.4A9090C
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id C161320005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:08:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aI4M7H49;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791464882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LiXfPAQPFSbSP24ib82bI63pr5adZXqMwD4tgxbX+Go=;
	b=GpJSdnpYKAXDBK9F881KWBw8xC/vZYHPzoMGPI8i6d0/4Dm/4UP81KMMnnYtOwH/16k43p
	0Ks0Lh4G/yGfRHHoccq9G9snnt5wIm19DTgNvCj7YStm6F+3lEFqkCGDjkzSntakKj4Xlf
	SdP8kWkGL3dMI+gnIHH+v86FiXsB73s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791464882;
	b=G7PE4zdxKOEWGYbyHes7d7/2JtKMV2r2Mw/XAcUeFlr7euG0uLsSknqykhHs3zAYnIhk9g
	nF8m9HNUsh6H9B7VujsVu1r6THyrQQr4gOzsDiauZ131aTrDDGbQgTfkRkIc40nMk9BIvK
	XaGes9lFClODMXEteOJqSZ+k9b10Fdk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aI4M7H49;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc1cf287ef8so1822378a12.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 06:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791464879; x=1792069679; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LiXfPAQPFSbSP24ib82bI63pr5adZXqMwD4tgxbX+Go=;
        b=aI4M7H49+pu4S8zExfBIdUVbZ2r3SqELmUALNBRLUvbANOsDmotJBa6I7jcS5dSOV6
         z62Z4k+/13BB3umCVn4XpfmPR5jYvq1VAyhsOzC2BgENt7EyCmmWa/rYTlwjjTTYBdW5
         Nf1aQSAmuuS9bJsBN4qIc+EVHyziSsH/FrXRywg9trQoQD6DM5w6azw0lpwtaSOZ8tNs
         4IHnLOh0xem3QVhxtmKxvjUbd/S9L5wDQccHE6Oor7L/lBWmM6bAmkHk7D7QsQo0206s
         DQBdiEaWhrYFpJYWv6m+FBJ3ScIReWcAGqnKbYTsgB3lp+GeDafstYPYhqppPVuPyDdn
         rJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791464879; x=1792069679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LiXfPAQPFSbSP24ib82bI63pr5adZXqMwD4tgxbX+Go=;
        b=qzt5lPlKs37J5RA3lt6OFB6ME12lHNbM6hvyeeLHLHIoBmY+i6871GfWVK4EnQ0CSs
         I1cY+1deGFY/DZC6TceJ1XlfN0zAn411EeUbvwpS6ExYbskb2JKeKzImh6f11xWKhB8e
         wL/omRgqRQQXxQp3kHZfl7odRNNW5oFDJicBXzgzn2h35GtITj0JC9h7bMClsEimGD2w
         I/NzHB6xRiN0tK2RUAERvp25Lr/+8z2WBXzwGWVf3wf5WYktQVLyRWuznVGpxmEoIBV4
         8aTksTbzCVbA2ENW3owPjum0cJu+W/jo1aZOUS5u/HgMTjt6wGWUPdSjW3UwRvb3Ho7l
         U7xA==
X-Forwarded-Encrypted: i=1; AKwUvBxa6K/bBwNlwDY71Tcq9uqcUSlINlhWLApDFK40uqEzy5MsyWHZeCJV+FJz2TzFSFO7ZlU9vPXDGg==@kvack.org
X-Gm-Message-State: AFq9FYJDUVIL7MbPyyJ9ku07XRs25icgDmpWKyIkjKYN6N/c4ldO1W2X
	tik7dhTI/Xrd9gPZgzfqzbVCFG9Q8izTMAK5f2gHFsWWRFANOy0E7FMTKNpt7q2yv6U=
X-Gm-Gg: AYBFou1Hzm+HTFSoSZ551k75CSMu7LvvyW1yIhsuKO9RsCc0DDa0jvgcC+vXC+4eixH
	Ffc2MHEfIxNyzyziSGsa/u5taXO+j2rf1/d33Yoeoxs8z+oALC0VHsXeVaH9Cesbf1vLuz8Bae/
	wO4wOstZZjHzT43IdzfaeeluyrCBHwT7VhdrAiDSofxVNuFyA/AkZBDijD4cuKbxYC3l2VXEkHb
	z9RJLC1MDONw0Syfgp6jclVqSN/TpykB+GrjdtrSUEwTxIOscAV0eq8g10tfubF2TDBfJCd2fyo
	gObEHgSta0Vfegk+/IVJa2L4b2+Ilp5ayI6mxUX0AwHXRRyYrAp7uyQE3aPjRoIkcAlO8HaDLn1
	1pbPY4WfhgEJHdmK9otfnZe4s6Rtmh0FTqUPGiQVqtvQyZ2GC0Fvr7ArYcgkXuXu8p+YS8YMk5+
	5o3+kHRTkCJdoSQBxaEwX169JvfKMGQEoXwCYLHlbseE7KA4uk0qmwLJ+qxVN/jGGH5lOprwql9
	g==
X-Received: by 2002:a17:90b:5746:b0:3a4:b2e7:f01e with SMTP id 98e67ed59e1d1-3a8a1188428mr4342599a91.52.1791464874824;
        Thu, 08 Oct 2026 06:07:54 -0700 (PDT)
Received: from localhost ([106.38.226.37])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9d94ef876sm4168336a91.0.2026.10.08.06.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:07:54 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	tj@kernel.org
Subject: [PATCH] fs: account filesystem bdev caches as kernel files
Date: Thu,  8 Oct 2026 21:07:47 +0800
Message-Id: <20261008130747.2868338-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C161320005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: t74yix1yo7d8ez855hqt5mnoutqtaejd
X-HE-Tag: 1791464880-843249
X-HE-Meta: U2FsdGVkX19HolBkWWjQsvlrmV2Lp4jut5uzWtUNTVERRhGDlYQs+fDupuwXEeMgJHjyKJ93fn35NrDW2bk6mpXkMVE2X94ZRDs3rYYhO68vjvQnJPmkKgBEHdLtNE9g/R8nOwKfqKIeKFV+7+xild0NMK81fCR6oSr81cFDiM+dhzSntpQ7B0cHv5kLhLfqVb3qton2bxJcVjIYPUjAREdr9o/1tHYhZFcWABkAq/JIXAaZpphG197n0vj5AgD4YX9xY6J38/Ic+O6nt3yQX3EbLEbDJa9KK/1FCyKxf8MzxYjbfMhrn8alFBGnVcyl3olcguHRHYSPdQgNVxisX/5chxWNKo4rLu7yldi91gKPb5oMdW7DoQqAy+JeupfECxu/ZqTjGvO6ai34qBXF4CEuqhT/eOLuhCT6U9lg+jdLfK5ch5bXE/HkS8gG293/9a5nHMY+VpsCzjJb7Cv7oL7+FUbtVsS5YQlviIDAOG7B57nO0ViaERjSX4hm90WO8kZFLMkUEvSMOVZ+rewNLgG9LhavXWnS691DbhT5Y2bng4MXT/cFafRRzkzsKmjnnJZUKxHbV1UwBBmy38Hxknw3i/gYMu49OPpsjwu2ifyx6SPmaiqdpcmgjngG4M/NKp4L2GKrF6H75H25/AcGdZxjapAIFFXSGlEtgPiadTCrgS99H6YOOBPYaWEyh+pKRNOWv+ZQD9mCQ8oIH3oy3DAs6ZndikXzUo74KJeIZuEbiKb0JvFtdaq6RQdrRI0+FlQis3NDHkYUXMN41evre7FGf1iGHVwA8GNCV01JR+/Vohau5jgd8pcccNgOffkXTiPjw7+cCTszDe9ztR/k0HEpJKadCuDcu7lOQLw1V03g42idTisQBK3nSY4rpf7Rx/CVtpcdinMiRXMwbjbYsnGVDELB81U1Bqju317FUbcYWma7CbPw+9c+mY+mn8APZO+SNm55uYh3mcb1og6
 bv2w3BMl
 5m0TMf7LXRW5OQ/bsYCNc6mB8PsDGfRTP5/VTSvHzAkn3d6xE51aIblf+xXK/QHj38V1dxlWotPTXlkyfEsVhYmNLcnN4CZX5/x7KwUMzG6VlKemloWS+zGOEmwfdV/fEN9f/C0A0mjVRCyGoyAd18Llw7h+PRRRHNuaseiNjcwMJA7D9liGuntRmJxFNmUdYJs4+hr3ks0NMAAyjXJe8GPZT9TbQ0TlKxv9lF4iPRgyC0CXaE1NPAm2wSsxkf3hmZXhJtu0YixDIs+zhmD1A+W8t+DPHpvo9wn+njHLyPHK36AYui1Ok6NYdOmDG4NiP2Tj08G8boy068qgbGn8g3fnc4zTWvn4/sR52FqEYmy1JItMlIw6odG9zRNcnnrQsOE+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Filesystems such as ext4 use buffer heads to cache shared metadata in
the bdev mapping. Charging these pages to individual memcgs can trigger
foreign writeback of the bdev inode's entire owner wb, including
unrelated file data.

Following the proposal in the linked discussion, set AS_KERNEL_FILE on
the bdev mapping while it is used by a filesystem, so newly allocated
cache pages are accounted to the root memcg. Empty the mapping before
changing the flag to keep folio insertion and removal accounting
consistent.

Multiple EROFS superblocks can share an extra data device. For example,
two metadata images on /dev/loop0 and /dev/loop1 can reference the same
data blob on /dev/loop2:

  mount -t erofs -o ro,device=/dev/loop2 /dev/loop0 /mnt/a
  mount -t erofs -o ro,device=/dev/loop2 /dev/loop1 /mnt/b

Unmounting /mnt/a must not clear AS_KERNEL_FILE on /dev/loop2 while
/mnt/b still uses it. Keep the flag set until the last filesystem user
releases the device.

bd_openers includes raw-device opens that may outlive filesystem
users, while bd_holders also counts partition claims on the whole
device. Neither counts filesystem users of this mapping, so add
bd_fs_users, protected by the bdev inode's i_rwsem.

Update this count in fs_bdev_register() and fs_bdev_unregister().
These hooks cover both device-open helpers and callers such as btrfs
that unregister a device and close it separately, without calling
fs_bdev_file_release().

Buffered access to the mounted raw device also charges new cache
pages to the root memcg. Such access is normally restricted to
privileged users. Pages cached in ordinary file mappings retain their
existing memcg accounting.

For filesystems that cache metadata in the bdev mapping, the benefit
is expected to be most pronounced when multiple cgroups perform
buffered overwrites alongside direct I/O on the same bandwidth-limited
device, such as an HDD. Frequent foreign writeback
reduces write coalescing, producing additional I/O that can saturate
the device. Direct I/O bypasses the page cache and competes with this
writeback traffic for device bandwidth.

An ext4 test combined repeated buffered overwrites of a 256 MiB file
with foreground direct writes, while four source memcgs generated
metadata and buffered writes. Device write bandwidth was capped at
200 MiB/s. In one baseline/patched pair, background file write I/O,
including final sync, fell from 6.178 GiB to 1.652 GiB (-73.3%).
Foreground bandwidth rose from 149.70 MiB/s to 184.19 MiB/s (+23.0%),
and completion time fell from 109.444 s to 88.951 s (-18.7%).

Link: https://lore.kernel.org/cgroups/20260925064444.3944820-1-sunjunchao@bytedance.com/T/#m55ee048deb0aad4d1f2293978f25ee6904a5725a
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 block/bdev.c              |  2 +-
 fs/super.c                | 59 +++++++++++++++++++++++++++++++++++++--
 include/linux/blk_types.h |  1 +
 include/linux/blkdev.h    |  1 +
 4 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..766e170286ca 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -79,7 +79,7 @@ static void bdev_write_inode(struct block_device *bdev)
 }
 
 /* Kill _all_ buffers and pagecache , dirty or not.. */
-static void kill_bdev(struct block_device *bdev)
+void kill_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;
 
diff --git a/fs/super.c b/fs/super.c
index 9d4025213521..7d271bb4cc6d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/memcontrol.h>
+#include <linux/pagemap.h>
 #include <linux/rhashtable.h>
 #include <linux/mount.h>
 #include <linux/security.h>
@@ -1644,6 +1645,55 @@ static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
 	return NULL;
 }
 
+/*
+ * Filesystem metadata is shared across users and should be accounted to the
+ * root cgroup. Charging it to individual cgroups can trigger foreign writeback
+ * of the bdev inode's entire owner wb, including unrelated file data. For
+ * buffered overwrites, premature writeback reduces write coalescing and
+ * competes with foreground I/O, particularly on bandwidth-limited devices.
+ * This foreign writeback problem primarily affects filesystems such as
+ * ext4 that cache metadata in the bdev mapping using buffer heads.
+ *
+ * Raw buffered I/O also uses kernel-file accounting while a filesystem uses
+ * the device. This is independent of CONFIG_BLK_DEV_WRITE_MOUNTED: writes to
+ * a mounted device are dangerous administrative operations, and charging
+ * their cache to the root cgroup is acceptable.
+ */
+static void fs_bdev_set_kernel_file(struct block_device *bdev, bool enable)
+{
+	struct address_space *mapping = bdev->bd_mapping;
+	struct inode *inode = mapping->host;
+
+	inode_lock(inode);
+	/*
+	 * Multiple superblocks can share an extra device, as in EROFS.
+	 * Switch accounting only for the first user and the last release.
+	 * Raw openers may outlive all filesystem users, so bd_openers cannot
+	 * determine when to restore ordinary page-cache accounting.
+	 * Count at registration/unregistration: btrfs can unregister a device
+	 * and close it separately, bypassing fs_bdev_file_release().
+	 */
+	if (enable) {
+		if (bdev->bd_fs_users++)
+			goto out;
+	} else {
+		if (--bdev->bd_fs_users)
+			goto out;
+	}
+
+	filemap_invalidate_lock(mapping);
+	/* Folio removal must use the same accounting mode as insertion. */
+	sync_blockdev(bdev);
+	kill_bdev(bdev);
+	if (enable)
+		set_bit(AS_KERNEL_FILE, &mapping->flags);
+	else
+		clear_bit(AS_KERNEL_FILE, &mapping->flags);
+	filemap_invalidate_unlock(mapping);
+out:
+	inode_unlock(inode);
+}
+
 static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 {
 	struct super_dev *sb_dev __free(kfree) = NULL;
@@ -1654,7 +1704,7 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 		sb_dev = super_dev_lookup(dev, sb);
 		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
 			retain_and_null_ptr(sb_dev);
-			return 0;
+			goto registered;
 		}
 	}
 
@@ -1674,7 +1724,11 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 	}
 
 	retain_and_null_ptr(sb_dev);
-	return err;
+	if (err)
+		return err;
+registered:
+	fs_bdev_set_kernel_file(file_bdev(bdev_file), true);
+	return 0;
 }
 
 /**
@@ -1765,6 +1819,7 @@ void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
 	sb_dev = super_dev_lookup(dev, sb);
 	rcu_read_unlock();
 	super_dev_put(sb_dev);
+	fs_bdev_set_kernel_file(file_bdev(bdev_file), false);
 }
 EXPORT_SYMBOL_GPL(fs_bdev_unregister);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 98e21b4cbf32..19daea93bdec 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -58,6 +58,7 @@ struct block_device {
 	struct address_space	*bd_mapping;	/* page cache */
 
 	atomic_t		bd_openers;
+	unsigned int		bd_fs_users; /* Protected by bd_mapping->host->i_rwsem. */
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	void *			bd_claiming;
 	void *			bd_holder;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..f84dff95eae7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
 unsigned int block_size(struct block_device *bdev);
 
 #ifdef CONFIG_BLOCK
+void kill_bdev(struct block_device *bdev);
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
-- 
2.39.5


