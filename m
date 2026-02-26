Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49F5FC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7C26B0088; Thu, 26 Feb 2026 05:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95436B0089; Thu, 26 Feb 2026 05:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D945F6B008A; Thu, 26 Feb 2026 05:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C34776B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:05:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DC035C3BF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:05:01 +0000 (UTC)
X-FDA: 84486174402.06.F0A838F
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4798420008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:04:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100299; a=rsa-sha256;
	cv=none;
	b=2x70KFuxV8zevMRUytOGXq1+dTjlg/w8Lr+HVkthPCaeZwTR8GYU0D3zdO6PdG3XHW9mde
	QAXQem/laVIyyVRZWsf+OBfDNN2VGxpyJLM009nayfkUH6+CawPFKqsVHPUOty1hisp5Zh
	syftZFOqDE6VTOaE1nJIH2h29Uro/hw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Lf5IZoMgp2m/i70iKYKC3yuPdqrFPWP9u0BkL4lOUo=;
	b=fCvLPoNIuMcQTh0gTHeRUE60qPsxs6cZbmo8FEM/nAvjanss1HZH+qeV3f3QCQsjRV1a2n
	JZgD0N/IXDZmAiaeF5WPfv4e9Sdfo1xaEcLcEDP8wctlcZtJVMjOBDSEY9u5zHdyHpQID0
	MxiNKq1PqJBjcGiHlcwSFcBFomhbwcw=
Received: from [10.108.10.175] (unknown [194.94.98.184])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 95D5A4C4430406;
	Thu, 26 Feb 2026 11:04:24 +0100 (CET)
Message-ID: <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
Date: Thu, 26 Feb 2026 11:04:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Content-Language: en-US
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 linux-raid@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4798420008
X-Stat-Signature: o7miqzpftdftd84gzf9d3w5tpk587s3z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772100299-374084
X-HE-Meta: U2FsdGVkX1/ICs09dEpf0g76dQMib9zklVcl03J9ximdZ2qUmA+t131o3+tvB9HrtEgoL3Pl4+5evMTyfSE0I7KMTzpGVEMvJqp5UkZXgnF1AERmS6SiO73GSAuMTG7/XjVDVj2iN1wBemfgDkFrAFOz2HCdglkZ16SzRX6CMNInqMSaZkOZN1jhtXouLMvELoxi+RPiMcPDoKBzKD/4dvy6Kq3BI8t90OoSC3B6SGNiqz1ppjH0G+sdRnYglHL92Po4bfEMqYiA9ldQiL7VebrDY7XapCuD2O5yvK8Lh/dYaU8f85jEm0XOJUR/6seq5HD3o5fy0DyxXLuD0NZR7UskvOh7jNLqRlyUtrLK6NHyqRVpeD/7WKFNl72DdqBge58Pe87FXJQ1gtdOOFjxcE/WDXd8UBaXfUHY565oLe0HLcuNeXkMxKcsIpam5KurrNJZXf1fFBN5R/l/kIpqpzCCGxjdJCOdR8zjH4caCVaNEEEULhfuo948JjVfluXiQRfuHst70abPJ/PDIdu1ZxxZZRzReAP4emR6yWC3sNAT0qrcNSZa1VjDlJOe2/+G33KdmI2n1VV1WTLIYEyCIZ6IMb5KhwXnweI9QPILGX9FSNurkXCCc+A4H/6nqqdf9vEs0YN2PhYg7WP/SQu3TZF7RLNwcHjD7gBJRUMyznQVVDOBakSwdHk25j6O3cLxiprU4ZpG7QEh0WbsVOAk7xFsvvp6nGvmahcPmyzMEGgb9j5+Ib902KTzjL1YHJ5tfuJDrmA2liDyaIah3hxLHCRUlgD6m9Psqa52QaxSdtgmH/+kIXtRLD5GUCRwgkukG+JFeBAuHRrqiJb+RO8FrPXxadXBinfcT/46JOCh0dyu7uRFqJ3IhfLYV0VOxHtd4h54jCDOhi+QD833to6D1oJEt4IZIEXQTUBExZQllRb4mTNT6edxJ00BogKrlbmSXPZUmujepQTL4ataFiR
 54pOfpIO
 gvFJji1Fdjb8VIw+eIvKBIFHKXgmJcJRc2bjSYy6na1it/xfAHT9BaoCB+OmSlQtVYIZPouFE4JSzNm9WvG+ZT4M1+IrhUh+66K1AK+r/a8oRuRa3VL/WlyLMxCwow1aLySnZe6KTO/WY9GYbi7YrFC1qBlZlFQAlkG/X7xDo2UEWjH77ZkDkr/GH/uP3DmtHCzpK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Damien,


Thank you for your patch.


Am 26.02.26 um 08:54 schrieb Damien Le Moal:
> bdev_nonrot() is simply the negative return value of bdev_rot().
> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
> and remove bdev_nonrot().

Is the generated code different now?

Is it worth the change, as it looks quite subjective if you prefer the 
one or the other way?

> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/md/raid1.c                  | 2 +-
>   drivers/md/raid10.c                 | 2 +-
>   drivers/md/raid5.c                  | 2 +-
>   drivers/target/target_core_file.c   | 2 +-
>   drivers/target/target_core_iblock.c | 2 +-
>   fs/btrfs/volumes.c                  | 4 ++--
>   fs/ext4/mballoc-test.c              | 2 +-
>   fs/ext4/mballoc.c                   | 2 +-
>   include/linux/blkdev.h              | 5 -----
>   mm/swapfile.c                       | 2 +-
>   10 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 181400e147c0..cda6af0712b9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1878,7 +1878,7 @@ static bool raid1_add_conf(struct r1conf *conf, struct md_rdev *rdev, int disk,
>   	if (info->rdev)
>   		return false;
>   
> -	if (bdev_nonrot(rdev->bdev)) {
> +	if (!bdev_rot(rdev->bdev)) {
>   		set_bit(Nonrot, &rdev->flags);
>   		WRITE_ONCE(conf->nonrot_disks, conf->nonrot_disks + 1);
>   	}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0653b5d8545a..cfbd345805ca 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -806,7 +806,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
>   		if (!do_balance)
>   			break;
>   
> -		nonrot = bdev_nonrot(rdev->bdev);
> +		nonrot = !bdev_rot(rdev->bdev);
>   		has_nonrot_disk |= nonrot;
>   		pending = atomic_read(&rdev->nr_pending);
>   		if (min_pending > pending && nonrot) {
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..ba9d6d05b089 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7541,7 +7541,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>   	rdev_for_each(rdev, mddev) {
>   		if (test_bit(Journal, &rdev->flags))
>   			continue;
> -		if (bdev_nonrot(rdev->bdev)) {
> +		if (!bdev_rot(rdev->bdev)) {
>   			conf->batch_bio_dispatch = false;
>   			break;
>   		}
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 3ae1f7137d9d..d6e3e5214652 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -173,7 +173,7 @@ static int fd_configure_device(struct se_device *dev)
>   		 */
>   		dev->dev_attrib.max_write_same_len = 0xFFFF;
>   
> -		if (bdev_nonrot(bdev))
> +		if (!bdev_rot(bdev))
>   			dev->dev_attrib.is_nonrot = 1;
>   	} else {
>   		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 3c92f94497b4..1087d1d17c36 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -148,7 +148,7 @@ static int iblock_configure_device(struct se_device *dev)
>   	else
>   		dev->dev_attrib.max_write_same_len = 0xFFFF;
>   
> -	if (bdev_nonrot(bd))
> +	if (!bdev_rot(bd))
>   		dev->dev_attrib.is_nonrot = 1;
>   
>   	target_configure_write_atomic_from_bdev(&dev->dev_attrib, bd);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6fb0c4cd50ff..c6e49eb74f3a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -694,7 +694,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>   			set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>   	}
>   
> -	if (!bdev_nonrot(file_bdev(bdev_file)))
> +	if (bdev_rot(file_bdev(bdev_file)))
>   		fs_devices->rotating = true;
>   
>   	if (bdev_max_discard_sectors(file_bdev(bdev_file)))
> @@ -2919,7 +2919,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   
>   	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
>   
> -	if (!bdev_nonrot(device->bdev))
> +	if (bdev_rot(device->bdev))
>   		fs_devices->rotating = true;
>   
>   	orig_super_total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index 9fbdf6a09489..b9f22e3a8d5c 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -72,7 +72,7 @@ static int mbt_mb_init(struct super_block *sb)
>   	ext4_fsblk_t block;
>   	int ret;
>   
> -	/* needed by ext4_mb_init->bdev_nonrot(sb->s_bdev) */
> +	/* needed by ext4_mb_init->bdev_rot(sb->s_bdev) */
>   	sb->s_bdev = kzalloc_obj(*sb->s_bdev);
>   	if (sb->s_bdev == NULL)
>   		return -ENOMEM;
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..8a4dfe19878c 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3836,7 +3836,7 @@ int ext4_mb_init(struct super_block *sb)
>   		spin_lock_init(&lg->lg_prealloc_lock);
>   	}
>   
> -	if (bdev_nonrot(sb->s_bdev))
> +	if (!bdev_rot(sb->s_bdev))
>   		sbi->s_mb_max_linear_groups = 0;
>   	else
>   		sbi->s_mb_max_linear_groups = MB_DEFAULT_LINEAR_LIMIT;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index d463b9b5a0a5..e439d6fa8484 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1467,11 +1467,6 @@ static inline bool bdev_rot(struct block_device *bdev)
>   	return blk_queue_rot(bdev_get_queue(bdev));
>   }
>   
> -static inline bool bdev_nonrot(struct block_device *bdev)
> -{
> -	return !bdev_rot(bdev);
> -}
> -
>   static inline bool bdev_synchronous(struct block_device *bdev)
>   {
>   	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94af29d1de88..60e21414624b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3460,7 +3460,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>   	if (si->bdev && bdev_synchronous(si->bdev))
>   		si->flags |= SWP_SYNCHRONOUS_IO;
>   
> -	if (si->bdev && bdev_nonrot(si->bdev)) {
> +	if (si->bdev && !bdev_rot(si->bdev)) {
>   		si->flags |= SWP_SOLIDSTATE;
>   	} else {
>   		atomic_inc(&nr_rotate_swap);

My point above aside, the diff looks good.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul

