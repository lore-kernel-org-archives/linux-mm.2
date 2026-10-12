Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96436CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899FD6B0088; Mon, 12 Oct 2026 04:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823D36B008A; Mon, 12 Oct 2026 04:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EF76B008C; Mon, 12 Oct 2026 04:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 381796B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:58:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97F9BA09D7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:58:57 +0000 (UTC)
X-FDA: 85313374314.28.20A4EE7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E097C0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:58:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quXQbn7F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5u1SfEg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quXQbn7F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5u1SfEg;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791795535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=3aEYwptk0RM8zdYM+1HnmYvNWn8v1J8SPghtvbxTp4dJoTD5e2cFX/ZfvJ5Spo6QxtPFC8
	tEaeMt8oD700zVFih9zTioJoVq3NcOKXwoJsUNnn0CBqk+nTII/KVEOZ+nQ1JZOyD53l1N
	kXJRDk1vX67BHIUYplRaLRV+5+fiQvg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quXQbn7F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5u1SfEg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quXQbn7F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5u1SfEg;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791795535;
	b=N09e4ltR9XmXMZJF1n3NTKYR/vJTkt8CR8h+ZUXj7x9hJWYjNzk2wLZufkG0e0FHC8+Cr4
	OQWUGPYOASlrX8JRYwBaBguxbVrxvMlbcdtpMDtJaBv8MRQz6zeW3tpY121gDLWoVcK6BX
	JIwMUo8Yxh1dm7RJWBno2KG6j/jzaT4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9DF521F45A;
	Mon, 12 Oct 2026 08:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791795533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=quXQbn7FS7aeOplubr1TdQtxrb9w4EtRkM3EV3r+7E1ZHJTaBg9TMZoNw514/VzCYSPh3f
	8PZWlxnNpjRF0qDDiXtr5/tv25y0+mp0fKsJ7JnEz7B5ZsAbBgx4+BNl8+0aE7fxkr0daj
	emEqcpywDI9zsy93gwuW2g78NyYDzIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791795533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=s5u1SfEg+uoFRyCwiqJBGIDvVpHYnnByY92dZOZqkz9HcojMTkVH+vKBYg6rAqG54mJIH5
	lOarb7PjyZRNzbCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791795533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=quXQbn7FS7aeOplubr1TdQtxrb9w4EtRkM3EV3r+7E1ZHJTaBg9TMZoNw514/VzCYSPh3f
	8PZWlxnNpjRF0qDDiXtr5/tv25y0+mp0fKsJ7JnEz7B5ZsAbBgx4+BNl8+0aE7fxkr0daj
	emEqcpywDI9zsy93gwuW2g78NyYDzIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791795533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=s5u1SfEg+uoFRyCwiqJBGIDvVpHYnnByY92dZOZqkz9HcojMTkVH+vKBYg6rAqG54mJIH5
	lOarb7PjyZRNzbCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7609C13408;
	Mon, 12 Oct 2026 08:58:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tMM7FE2hzGruRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:58:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 04553A1403; Mon, 12 Oct 2026 10:58:48 +0200 (CEST)
Date: Mon, 12 Oct 2026 10:58:48 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, akpm@linux-foundation.org, tj@kernel.org
Subject: Re: [PATCH] fs: account filesystem bdev caches as kernel files
Message-ID: <3xivdukdcs45x2lql3fh3pogrkeb3piiexo2np4xscmz5yk4ot@jqvlshpakn4c>
References: <20261008130747.2868338-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008130747.2868338-1-sunjunchao@bytedance.com>
X-Rspamd-Action: no action
X-Stat-Signature: nbnzzqn54ic7df4ehqn7wa48jzze5xq8
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E097C0006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791795535-214017
X-HE-Meta: U2FsdGVkX19kYCFW9o60mFdAQoDXnHlfwOzBQcsDtPBUH4QMlmm7W9wH+y0ESdxvytmIIKROL6cYxvPGcPDpj5lKrLENboDruji930qmluWYuc4k4z7Eef1rf1yR6mGhBE2Rn+q0peWVR5vNnXOQRmv+IJD1DHcSOdYJx17bDXN+IDTEI9c5XQhQib5WB8KUksIfPBQoy1cQ9ciTsZbxj4NNLnwZsscn4hzClyY5xn418E4zrYLLrqf/UF04Jx9JGXKhBaLIljUfyB/65lEsDJ0JcsjnvrfcwpmT8pxgoHyQmexH7Tihqa2fbnB0K1RHQ/339gH+NFxrjRfAwCVo0frX0sTyZu5RUChyiNKbYfOcRnRCQzWneMKw278K2SOpDWurLZpWM7TIk/N0dnSpFCSt6dCS/w5arNEQYjQXBXhAsVnao0WX8oHqFwbnvj8ShwOuvYqoepdR3axl4NUMjMwcFWF2XArw/uGVYOsF2PK/ENGbeBp6lfDP5Hy1cfl5Y2QvA28NONVqQlIU3pDAcPwhSjywFCNoidG0EeR1Jeo/E4AACkeJIhEj+THiUV0OiEN1I703rjAm/P/rPU01Xgnba2yczcIncIr4DrMdwVeDRXVr3RNnUwv8IEwjszRT/t11Ddxd7Ij49d2hGPUl5DmIgp23Iw5PbfbPeavJ2Ur9B5XW2dQ3f3NByFkEvm2f8TJKjT0EOFcrs7TxhNnvMKEKJvaIh1wFTWpPVCEWHIbAxwljGRUe6/wdcUYAY/K6de5XGdWppIyXaqtKa3V1BvxRBMkUdtViEIfbjQcilvFN83hAPvzLCA6lLj8aEm9XxcQ60JkvVdgW+iVlFpc9Mk0ieaplAUxhNGRcdI2BoJUk87adGmM6Miix9SZtdQqOa+SE3yQedSC+E/mJR+Gn188WoFkQUi0iWHOQtWX8a9/3+VkIz2oe5x6dk1qVxpgeHGkHT/ioKi/Y76IlAyF
 AQb81UbC
 Ajt2RYEkIRlAtZp4SEZGNPVyzAEkK1bfzA08to7qk3WdfOQBqIjayF9bdYkZi4csiF32itDEHzVdKOGJ9MauxjrrTZ6Ozmr6ElzdEo/cjKm04Vx9SW1OEGGejnnzz0KQNldnSPoKu7btKr+hutwp7DhSbYXMfjEYL7wep7G8CKpJPfIjXLuK78Lq5/7sKnFmSQPKsoptZJ+F2RH25LYI1aN/OisvqQxhgP4ULSv+QsHnG0YsRwH1YkmVp3f0aE32wi8roL9ifRs9ppxi2rmJXegYGG2LNmt9Uy8cY79S0aug+VzG0qkGuXk1LRrTJmbeFvvH9AtVtSedvCV0QQWHFq1OqU6osKdEluetBWJcniVX/0/cm1M5hCvm4oCmZ3b09/C6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-10-26 21:07:47, Julian Sun wrote:
> Filesystems such as ext4 use buffer heads to cache shared metadata in
> the bdev mapping. Charging these pages to individual memcgs can trigger
> foreign writeback of the bdev inode's entire owner wb, including
> unrelated file data.
> 
> Following the proposal in the linked discussion, set AS_KERNEL_FILE on
> the bdev mapping while it is used by a filesystem, so newly allocated
> cache pages are accounted to the root memcg. Empty the mapping before
> changing the flag to keep folio insertion and removal accounting
> consistent.
> 
> Multiple EROFS superblocks can share an extra data device. For example,
> two metadata images on /dev/loop0 and /dev/loop1 can reference the same
> data blob on /dev/loop2:
> 
>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop0 /mnt/a
>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop1 /mnt/b
> 
> Unmounting /mnt/a must not clear AS_KERNEL_FILE on /dev/loop2 while
> /mnt/b still uses it. Keep the flag set until the last filesystem user
> releases the device.
> 
> bd_openers includes raw-device opens that may outlive filesystem
> users, while bd_holders also counts partition claims on the whole
> device. Neither counts filesystem users of this mapping, so add
> bd_fs_users, protected by the bdev inode's i_rwsem.
> 
> Update this count in fs_bdev_register() and fs_bdev_unregister().
> These hooks cover both device-open helpers and callers such as btrfs
> that unregister a device and close it separately, without calling
> fs_bdev_file_release().
> 
> Buffered access to the mounted raw device also charges new cache
> pages to the root memcg. Such access is normally restricted to
> privileged users. Pages cached in ordinary file mappings retain their
> existing memcg accounting.
> 
> For filesystems that cache metadata in the bdev mapping, the benefit
> is expected to be most pronounced when multiple cgroups perform
> buffered overwrites alongside direct I/O on the same bandwidth-limited
> device, such as an HDD. Frequent foreign writeback
> reduces write coalescing, producing additional I/O that can saturate
> the device. Direct I/O bypasses the page cache and competes with this
> writeback traffic for device bandwidth.
> 
> An ext4 test combined repeated buffered overwrites of a 256 MiB file
> with foreground direct writes, while four source memcgs generated
> metadata and buffered writes. Device write bandwidth was capped at
> 200 MiB/s. In one baseline/patched pair, background file write I/O,
> including final sync, fell from 6.178 GiB to 1.652 GiB (-73.3%).
> Foreground bandwidth rose from 149.70 MiB/s to 184.19 MiB/s (+23.0%),
> and completion time fell from 109.444 s to 88.951 s (-18.7%).
> 
> Link: https://lore.kernel.org/cgroups/20260925064444.3944820-1-sunjunchao@bytedance.com/T/#m55ee048deb0aad4d1f2293978f25ee6904a5725a
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Good catch with EROFS. The patch looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

FWIW the problem pointed by Sashiko looks real but it's a preexisting issue
with broken bdev write locking when falling back to buffered IO. So it
isn't much related to your patch.

								Honza

> ---
>  block/bdev.c              |  2 +-
>  fs/super.c                | 59 +++++++++++++++++++++++++++++++++++++--
>  include/linux/blk_types.h |  1 +
>  include/linux/blkdev.h    |  1 +
>  4 files changed, 60 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index cd8323083740..766e170286ca 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -79,7 +79,7 @@ static void bdev_write_inode(struct block_device *bdev)
>  }
>  
>  /* Kill _all_ buffers and pagecache , dirty or not.. */
> -static void kill_bdev(struct block_device *bdev)
> +void kill_bdev(struct block_device *bdev)
>  {
>  	struct address_space *mapping = bdev->bd_mapping;
>  
> diff --git a/fs/super.c b/fs/super.c
> index 9d4025213521..7d271bb4cc6d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -25,6 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
>  #include <linux/memcontrol.h>
> +#include <linux/pagemap.h>
>  #include <linux/rhashtable.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
> @@ -1644,6 +1645,55 @@ static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
>  	return NULL;
>  }
>  
> +/*
> + * Filesystem metadata is shared across users and should be accounted to the
> + * root cgroup. Charging it to individual cgroups can trigger foreign writeback
> + * of the bdev inode's entire owner wb, including unrelated file data. For
> + * buffered overwrites, premature writeback reduces write coalescing and
> + * competes with foreground I/O, particularly on bandwidth-limited devices.
> + * This foreign writeback problem primarily affects filesystems such as
> + * ext4 that cache metadata in the bdev mapping using buffer heads.
> + *
> + * Raw buffered I/O also uses kernel-file accounting while a filesystem uses
> + * the device. This is independent of CONFIG_BLK_DEV_WRITE_MOUNTED: writes to
> + * a mounted device are dangerous administrative operations, and charging
> + * their cache to the root cgroup is acceptable.
> + */
> +static void fs_bdev_set_kernel_file(struct block_device *bdev, bool enable)
> +{
> +	struct address_space *mapping = bdev->bd_mapping;
> +	struct inode *inode = mapping->host;
> +
> +	inode_lock(inode);
> +	/*
> +	 * Multiple superblocks can share an extra device, as in EROFS.
> +	 * Switch accounting only for the first user and the last release.
> +	 * Raw openers may outlive all filesystem users, so bd_openers cannot
> +	 * determine when to restore ordinary page-cache accounting.
> +	 * Count at registration/unregistration: btrfs can unregister a device
> +	 * and close it separately, bypassing fs_bdev_file_release().
> +	 */
> +	if (enable) {
> +		if (bdev->bd_fs_users++)
> +			goto out;
> +	} else {
> +		if (--bdev->bd_fs_users)
> +			goto out;
> +	}
> +
> +	filemap_invalidate_lock(mapping);
> +	/* Folio removal must use the same accounting mode as insertion. */
> +	sync_blockdev(bdev);
> +	kill_bdev(bdev);
> +	if (enable)
> +		set_bit(AS_KERNEL_FILE, &mapping->flags);
> +	else
> +		clear_bit(AS_KERNEL_FILE, &mapping->flags);
> +	filemap_invalidate_unlock(mapping);
> +out:
> +	inode_unlock(inode);
> +}
> +
>  static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  {
>  	struct super_dev *sb_dev __free(kfree) = NULL;
> @@ -1654,7 +1704,7 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  		sb_dev = super_dev_lookup(dev, sb);
>  		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
>  			retain_and_null_ptr(sb_dev);
> -			return 0;
> +			goto registered;
>  		}
>  	}
>  
> @@ -1674,7 +1724,11 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  	}
>  
>  	retain_and_null_ptr(sb_dev);
> -	return err;
> +	if (err)
> +		return err;
> +registered:
> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), true);
> +	return 0;
>  }
>  
>  /**
> @@ -1765,6 +1819,7 @@ void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
>  	sb_dev = super_dev_lookup(dev, sb);
>  	rcu_read_unlock();
>  	super_dev_put(sb_dev);
> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), false);
>  }
>  EXPORT_SYMBOL_GPL(fs_bdev_unregister);
>  
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 98e21b4cbf32..19daea93bdec 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -58,6 +58,7 @@ struct block_device {
>  	struct address_space	*bd_mapping;	/* page cache */
>  
>  	atomic_t		bd_openers;
> +	unsigned int		bd_fs_users; /* Protected by bd_mapping->host->i_rwsem. */
>  	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
>  	void *			bd_claiming;
>  	void *			bd_holder;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 4f7905c3412b..f84dff95eae7 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
>  unsigned int block_size(struct block_device *bdev);
>  
>  #ifdef CONFIG_BLOCK
> +void kill_bdev(struct block_device *bdev);
>  void invalidate_bdev(struct block_device *bdev);
>  int sync_blockdev(struct block_device *bdev);
>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

