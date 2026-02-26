Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD758FC5908
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261536B0088; Thu, 26 Feb 2026 03:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2395E6B0089; Thu, 26 Feb 2026 03:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F906B008A; Thu, 26 Feb 2026 03:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F40B46B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:00:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B81441B7918
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:00:09 +0000 (UTC)
X-FDA: 84485859738.26.E21F022
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4E9A20016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:00:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/VjVtCh";
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772092807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gCX6CsDfNM3oDfAV1rBaweXqT2lir1CDbcoqn8SMWOg=;
	b=ms+2iXldSK2MvT1WGMI3RlnH2h9VQ8qxDIBDNegORenKP6nCYKCsy3UQxw+mtSM8KPX/TT
	cgJAdFe0ItebaH9Jp0rM/3w00ASQpvUZqc2SowPYlF6tzcm1Q8OutOYYMMdZSrbJmYJPPI
	HFdw04BZmaXT75BHUEDuRMsgUK8jxQA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/VjVtCh";
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772092807; a=rsa-sha256;
	cv=none;
	b=vX0zxEey6ttTk7tmqLdF7VXrSKMZzjnmVLs6E5EbDJzJ2OwGDyc1yoHT4uzwlL4JAQQx9X
	Lm9/PxOlj+SbAa7mBvQIWgUMchujBtEkuwLyVADEOzI5VS29H3+HdmADwc4XfrprIcbmVN
	0wDBAQkUuWM1Hkv5PUQ3j8aCtRlqUUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7CC6416DD;
	Thu, 26 Feb 2026 08:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE9CC19422;
	Thu, 26 Feb 2026 08:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772092806;
	bh=q51EvZLYVH3v7aiWXdLBUUBLmMdEbsHbEaog+fCHYQ0=;
	h=From:To:Subject:Date:From;
	b=f/VjVtChblPTNjIWGwsM6HMZ6YqSWQPgoPYA71Xex7NTgobNhhDr7fCkERNrfCSNh
	 N7wnA0WYrcP6dB8z8iSOO+aaBqp57/8F791OshwMk2W0BuhmRi7vDNNF4rztMcNK+v
	 32imInv5Oxf5zyjxMuzDeJhnks7M0kWdgaJ9uhDE3VegZNF2Csps6rg0TSp5Mag3t3
	 irPLIWXzBNpq14fZXqgBPqu8121Uj/5fC+9A80zemp8A0dOYdytGBNJXjc8Bgzmp5Z
	 7vjGAe44dE0B2EtjnKRo71Tykfpp+dcW2ylCoQjn0dB4ce09WEFDENLIrHhajXWYFo
	 tEsLwMxg2t78g==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org
Subject: [PATCH] block: remove bdev_nonrot()
Date: Thu, 26 Feb 2026 16:54:48 +0900
Message-ID: <20260226075448.2229655-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dner1koceghupxuurq7zqmyysgm751tq
X-Rspam-User: 
X-Rspamd-Queue-Id: C4E9A20016
X-Rspamd-Server: rspam01
X-HE-Tag: 1772092807-414636
X-HE-Meta: U2FsdGVkX184viMuyhLwVVD2OdAVFzeTCUlWr6sDWzvLG42ucxrThbkSVoFicdYFN9rjKIFvea7onmut6Pp/nozq2PPaKuNSMY1bARC4UOFfusdcrouvbp83L12E2M7AeYM6e1JcT5wFbrbhxtxDKoMVlUPVC8eFaS/8/ZOdqhQh2+YfT3oz6hkIZiXiSEJG9hIphAokz3/xUTHC83F28d57aGsZGgvmqKtKV/Xs69uv74Htm/KNWx/XM3JWdZNDYEm47VO3QFiEeXyS2QXMTnZsfV+FnQW0ArAtvHPwZ3wW1eEt6J3Tm2JN8PvhWUMD2wrxPI1VHYtt53gmOcsYKUi76rkmgqY+RL7+zUSp5gKZuGcSZ9cGz+ZXUC0CJsTJRdJViaObGYudFnXFZC+GR4hllYRXC06QRzwMqgtS2b6QFOUBRuLimx65WN4xssgICX33R+DFx9G9LkUrjYdLVLXLSRR3GKthQfU5qmKwiFs3WQ6zFfUZNh06fmMDQUP0uipB06TUAUUHOcSB7nNva1uNdoJ9rLjLofLSevmBXHR1C4td/xZBpSeEyAMhALZItbfZ2qMR89gP5eMkfCcoMhXeBN/3tu0wI2qO/b8LucRoAb3J+aTeYDl5qTLzvVhNiyKmGJNJIq9Tvxa9cdNxmRn+9HxLFaEfrXeQaPgDaqzGqHOWRgMaStrALKap76MMO900DHf31NYw9zRyH7h/yb8U8e+eVVg4+jXqiwc+zS4Ccx5/qS2xYtkYvAipEt3cfh4TlN9ainrBs5CRF9I9vtIXHB+TSVh11J1jK+IFkLx+1dpWL0MLgaryZL1/72n/vem4/TjYZFTK+3/8UvC8xV98/YcRbsnTSdhcxnDA08ReMaqIU+J2nQ8uTuhPtL2YxR3ld0Yx8mgNau73GJeQSg3tjag+/dwAEkGi9kOudNcxWhf+pN35nT3lFsJVYlfEsowAJXE8tHz0oKkETLR
 eNX4i44g
 f65986tp1q7CWSu+YWEF8YmZlDvqUm3l1jbaFGUd3T53tpzcB5+y4xtejmSu2NkNFfa6aMhIkdywHWDanF8h9bZ+dhKgvPotiQKYoE5ZoC0Xeb8r2O/kA3HLZLMTRdSK+qNUc3a3g0DDImWlDKiHJt8WZLlXQISLmZAVDlyJaGQmnvobPEJODqWoj5NGncc2382CFXnNj2ILMJE9QlgMyMxaJzkb3zvH41At9i2sWXB3opSSxJM20JOSq5ILGhbJgWcuT6Rcqkrpy/1vQGetXq68FhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bdev_nonrot() is simply the negative return value of bdev_rot().
So replace all call sites of bdev_nonrot() with calls to bdev_rot()
and remove bdev_nonrot().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/raid1.c                  | 2 +-
 drivers/md/raid10.c                 | 2 +-
 drivers/md/raid5.c                  | 2 +-
 drivers/target/target_core_file.c   | 2 +-
 drivers/target/target_core_iblock.c | 2 +-
 fs/btrfs/volumes.c                  | 4 ++--
 fs/ext4/mballoc-test.c              | 2 +-
 fs/ext4/mballoc.c                   | 2 +-
 include/linux/blkdev.h              | 5 -----
 mm/swapfile.c                       | 2 +-
 10 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 181400e147c0..cda6af0712b9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1878,7 +1878,7 @@ static bool raid1_add_conf(struct r1conf *conf, struct md_rdev *rdev, int disk,
 	if (info->rdev)
 		return false;
 
-	if (bdev_nonrot(rdev->bdev)) {
+	if (!bdev_rot(rdev->bdev)) {
 		set_bit(Nonrot, &rdev->flags);
 		WRITE_ONCE(conf->nonrot_disks, conf->nonrot_disks + 1);
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0653b5d8545a..cfbd345805ca 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -806,7 +806,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 		if (!do_balance)
 			break;
 
-		nonrot = bdev_nonrot(rdev->bdev);
+		nonrot = !bdev_rot(rdev->bdev);
 		has_nonrot_disk |= nonrot;
 		pending = atomic_read(&rdev->nr_pending);
 		if (min_pending > pending && nonrot) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071b..ba9d6d05b089 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7541,7 +7541,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		if (test_bit(Journal, &rdev->flags))
 			continue;
-		if (bdev_nonrot(rdev->bdev)) {
+		if (!bdev_rot(rdev->bdev)) {
 			conf->batch_bio_dispatch = false;
 			break;
 		}
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 3ae1f7137d9d..d6e3e5214652 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -173,7 +173,7 @@ static int fd_configure_device(struct se_device *dev)
 		 */
 		dev->dev_attrib.max_write_same_len = 0xFFFF;
 
-		if (bdev_nonrot(bdev))
+		if (!bdev_rot(bdev))
 			dev->dev_attrib.is_nonrot = 1;
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 3c92f94497b4..1087d1d17c36 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -148,7 +148,7 @@ static int iblock_configure_device(struct se_device *dev)
 	else
 		dev->dev_attrib.max_write_same_len = 0xFFFF;
 
-	if (bdev_nonrot(bd))
+	if (!bdev_rot(bd))
 		dev->dev_attrib.is_nonrot = 1;
 
 	target_configure_write_atomic_from_bdev(&dev->dev_attrib, bd);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fb0c4cd50ff..c6e49eb74f3a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -694,7 +694,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 			set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	}
 
-	if (!bdev_nonrot(file_bdev(bdev_file)))
+	if (bdev_rot(file_bdev(bdev_file)))
 		fs_devices->rotating = true;
 
 	if (bdev_max_discard_sectors(file_bdev(bdev_file)))
@@ -2919,7 +2919,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
 
-	if (!bdev_nonrot(device->bdev))
+	if (bdev_rot(device->bdev))
 		fs_devices->rotating = true;
 
 	orig_super_total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 9fbdf6a09489..b9f22e3a8d5c 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -72,7 +72,7 @@ static int mbt_mb_init(struct super_block *sb)
 	ext4_fsblk_t block;
 	int ret;
 
-	/* needed by ext4_mb_init->bdev_nonrot(sb->s_bdev) */
+	/* needed by ext4_mb_init->bdev_rot(sb->s_bdev) */
 	sb->s_bdev = kzalloc_obj(*sb->s_bdev);
 	if (sb->s_bdev == NULL)
 		return -ENOMEM;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 20e9fdaf4301..8a4dfe19878c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3836,7 +3836,7 @@ int ext4_mb_init(struct super_block *sb)
 		spin_lock_init(&lg->lg_prealloc_lock);
 	}
 
-	if (bdev_nonrot(sb->s_bdev))
+	if (!bdev_rot(sb->s_bdev))
 		sbi->s_mb_max_linear_groups = 0;
 	else
 		sbi->s_mb_max_linear_groups = MB_DEFAULT_LINEAR_LIMIT;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d463b9b5a0a5..e439d6fa8484 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1467,11 +1467,6 @@ static inline bool bdev_rot(struct block_device *bdev)
 	return blk_queue_rot(bdev_get_queue(bdev));
 }
 
-static inline bool bdev_nonrot(struct block_device *bdev)
-{
-	return !bdev_rot(bdev);
-}
-
 static inline bool bdev_synchronous(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..60e21414624b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3460,7 +3460,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (si->bdev && bdev_synchronous(si->bdev))
 		si->flags |= SWP_SYNCHRONOUS_IO;
 
-	if (si->bdev && bdev_nonrot(si->bdev)) {
+	if (si->bdev && !bdev_rot(si->bdev)) {
 		si->flags |= SWP_SOLIDSTATE;
 	} else {
 		atomic_inc(&nr_rotate_swap);
-- 
2.53.0


