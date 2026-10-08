Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9F9CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33586B0092; Thu,  8 Oct 2026 04:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3C36B0093; Thu,  8 Oct 2026 04:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2876B0095; Thu,  8 Oct 2026 04:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63A236B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:51:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4F7EC0486
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:51:18 +0000 (UTC)
X-FDA: 85298839836.04.2B898DA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7B5F8100003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:51:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XnYsdjnN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g3Va1iq1;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791449476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/AeD2MF2duASzk4+OjGc0B5KDhiaEJ5Z4p2fwoqWO0=;
	b=lkhB1hJYcET2wq3NeZx0Dyv48wpGwZ1xMmNL+SxulHrABpc/57zNOVeTsg9jkTX3Ad8iIu
	O4hwTqbQiIf9lemN2y7rIu4JBJc1TeArXN4O7QV55WTWs4H0cb0LruBlszkGUjtNkLT6BA
	J4lADN7ua67ZaOIKP4TaBG/5tLVCuFI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791449476;
	b=8m1o3U6NqOnuolkYd1LSWIY3vfAC1HfDM/xRePtewLrP2VSnTKqoDpE4MLf1j2VGfNLt+C
	tcPbBzsrkS6gkKVh9Y6tYO5bIu9MKAE8oYKvbF8pB34EPU7tiXSNTUoDD4eSgHN7KOoS3E
	1WPaXQfyZZL1ZXO4bWFmmo0l8sCbKPo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XnYsdjnN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g3Va1iq1;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 758A021B8A;
	Thu,  8 Oct 2026 08:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791449473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/AeD2MF2duASzk4+OjGc0B5KDhiaEJ5Z4p2fwoqWO0=;
	b=XnYsdjnNpHHUrteojZSJYGhPs7rRcrITORW1dFFG16kBT/rCzANRIAAJUGQNI6tjPB/V7L
	SG7iPfPriMCg7RiNqBtlbQ+esugl2W+m2av1dJi+hdqAGwL8E8XoBZSItCKayhcSPlJBhn
	FVjnz4c3RijiMZj2Zs4sHhhUExanGws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791449473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/AeD2MF2duASzk4+OjGc0B5KDhiaEJ5Z4p2fwoqWO0=;
	b=g3Va1iq1SiddGrJTi41KaC3lC2olPYlQUIwhFo6m8okwOsYISDDdsftVaxxjiSgDJQWE3f
	1U/fd68PBSnbdLBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 498F31339F;
	Thu,  8 Oct 2026 08:51:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m/m0CYFZx2ryVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 08:51:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C325AA13FC; Thu, 08 Oct 2026 10:51:08 +0200 (CEST)
Date: Thu, 8 Oct 2026 10:51:08 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	willy@infradead.org, tj@kernel.org, akpm@linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <dzq3d5yosbsdeml4fdb3rpowxxnjau6edluw4xoewwwbv4hykg@ywkjm3xlbimv>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
 <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
 <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B5F8100003
X-Rspam-User: 
X-Stat-Signature: rdwx7kenxq38jmctrzb15iu9afnoyjob
X-HE-Tag: 1791449476-250169
X-HE-Meta: U2FsdGVkX1/1gQ6iRjR5RZehh6Ot7rcCU7skhpkRwUbNMEi54bJk5O+cpEfoEI+4tkVjThx16HcccyjV4wzJ8AUhEI+sQooVOvwYAba5b6F9hKNY+/L716k/BW/DuaOCuih2QqB5GYLw0lozLno1/zweds9JJmZDcSs+MjntN0JXYxJ9Vl7hGO/k5NbIytPE7yLA5rKTHVs5PRmjVleraKeKVmpXAAS7zWN7X6wZ7S+wQbzG9NXnZ2WDu9yjbKFdeuVOXuvTcsPhoIQknREP/M1EOsd9hL9tNwZ5QQtL/NnjyDA0Mq/D3LX8F7zFRDhjX8wEAZqLp/YyAjLtnzwLe6iu8rrfQ2BfvJdggk88m9B8wVN/2mx91386udnl+V0F7VjZ07uB653vLx297Fq8LCy5MFq55wgoR3YpfaJnOyYXQtAHc5NMWiXjC4SWbKZ43kxZU7qJHk7TFotnUMAAL3pr1j4Ofu/RHuWIZG3G6Lj4A/sBMPuHeej5ETFcrkebAkxGiE+Rsi5EcXqF1hZqhuP+OF2vCNOvH8MMrTTqN5N8L90Y/GGlhDMdePaE9l4fVnTnjRqpcIbp2ztN2VPBmwLxvRe5aNTI4aGkAg0v1+C7lAtppKVENathEKaadTn4B61BXeNhF2yL3RQKuZH6g9k9ryPqmNI952g4TYBrbK8kFybNtAyy1OhjTklTcG++HGKg08wcJRmHswi+9nHAqQoXNDEpz8y8IBbcDMAkiYYUmGKfZ0PXmdO+aKYKGPoVg0/FKbWZ9/evg7ez49XNdjDHCjkoGfExupT9ha9OePzMq9ux5cC2bO12c2uoQFdFzUJ5bapCHmWp0ej+6AWeil0ltnwi+sAFs2+wkuffgAEkXruZmuYvydpUxFJXqbsvT2w3CQzZ82o7Oqn62xSIBTfv3EuzqL3V6CJFg2H1plpdLZzFR7YskNYuf/qbvxEBAiCCHPhU91UOUtPznnW
 fC9/egD2
 kmEu6PSVon7fKS4rI2DBfFZQry+u27vFpd//hPx+abAdD+OGcFaGILcxgAGh34C6upWPmDq73xcRahXxkLTgAPi9VqgM9iH7+iG/lEWV7CCGexfg1fY1wKPar8wMEnR39DihVLFRxt3lMSECkWmqL//aBrPuURz5y8zGyT9N/2kja6oV537ZjeQR8ydnLla5KC6LeHVtQZ3G7nS5z4xX/+2zJ2mrt1NCrSyyh0kWpCIXOypMTmkAAyOf+ixcyT1Gn93xgWE42yhAmjSx9Plxdp/D5TSauVqiGLNjWtdP+GgXSvA3iYVYQE3pSwull/gTpVCJZ71RFN/LaB30NSndpX8YaGxS8cZEksviGDavIi2Q3dukChkpGfpyb8s6Mvl9dIpFW0IdS/e3opf+xY2IT8FGiVGPujz+MPzjW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-10-26 16:00:13, Julian Sun wrote:
> On 10/6/26 12:25 AM, Jan Kara wrote:
> > On Mon 05-10-26 01:26:28, Christoph Hellwig wrote:
> >> On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
> >>> FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
> >>> for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
> >>> for bdev mappings will cause issues because some users may be using bdevs
> >>> directly for their workloads and they could still expect proper memcg
> >>> accounting to work in that case.
> >>
> >> Agreed that it should not set unconditionally.
> >>
> >>> We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
> >>> it when releasing bdev) but that would have to make sure there are no
> >>> folios in the bdev mapping when changing the flag as otherwise the
> >>> accounting would go wrong. Looks it might be doable but getting all the
> >>> cornercases right will be hairy and overall not very appealing to me...
> >>
> >> I'd rather not support special case writeback code just for this legacy
> >> fs abuses bdev buffer cache case.  And we basically need to tear
> >> down pagecache at unmount anyway, as i_blkbits can change, so while
> >> we do need to be careful, I don't think it really is a major issue.
> > 
> > OK, after some more thought yes, I think we can make that work.
> > 
> >> We might be able to restrict to setting it when
> >> CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
> >> shared mmap writers, as anyone using a modern kernel and cgroups really
> >> should have that disabled.
> > 
> > I don't think that's really needed. If such writes are happening, they are
> > *very* limited and done by a system administrator only (as they are very
> > dangerous) so the fact the writes will get charged to the root cgroup is
> > not an issue.
> 
> Hi, Jan, Christoph.
> 
> Thanks for your suggestions.
> 
> One remaining concern: while ext4 is mounted, buffered reads of the raw
> block device would also charge page-cache allocations to the root memcg,
> bypassing the reader's memcg memory limits. Is that acceptable?

Yes. If you have a setup where unprivileged user can read raw block device
with the filesystem mounted, your security model is very doubtful. I don't
think anybody sane can do that. Also setting up of loop devices and
mounting filesystem on top is privileged operation and if a user can do it,
memcg accounting is the least of your troubles. Of course even privileged
process can be constrained in a cgroup and this containment will not
account bdev pages properly in the case you describe but even then I have
hard time coming up with a tool that would read a significant portion of
the device (e.g. udev will be reading mounted bdevs but only small portions
of them) and even if it does, this would be a clean page cache which is
easy to reclaim.

So I cannot think of a practical setup where this charging behavior could be
a problem. Of course I could be proven wrong by some user complaining and
then we'd have to revert and go back to the drawing board.

> I've attached a preliminary diff. Does this approach look reasonable?
> If so, I'll split this into a formal patch series.

In principle, the mechanism looks good to me but I'd place it in
fs_bdev_file_open_by_dev() & fs_bdev_file_release() so that all block
device based filesystems are handled. ext4 is the most used filesystem that
has this problem with bdev memcg accounting but in principle exactly the
same problem happens for other filesystems using buffer heads so I'd prefer
handling it in the generic code instead of fixing them one-by-one as people
complain...

								Honza

> 
> diff --git a/block/bdev.c b/block/bdev.c
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -79,7 +79,7 @@ static void bdev_write_inode(struct bloc
>  }
> 
>  /* Kill _all_ buffers and pagecache , dirty or not.. */
> -static void kill_bdev(struct block_device *bdev)
> +void kill_bdev(struct block_device *bdev)
>  {
>  	struct address_space *mapping = bdev->bd_mapping;
> 
> @@ -89,6 +89,7 @@ static void kill_bdev(struct block_devic
>  	invalidate_bh_lrus();
>  	truncate_inode_pages(mapping, 0);
>  }
> +EXPORT_SYMBOL_GPL(kill_bdev);
> 
>  /* Invalidate clean unused buffers and pagecache. */
>  void invalidate_bdev(struct block_device *bdev)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
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
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1279,6 +1279,56 @@ static void ext4_flex_groups_free(struct
>  	}
>  }
> 
> +/*
> + * Account ext4 metadata cache to the root cgroup. This filesystem-wide
> + * metadata is shared across users, so it is not naturally attributable
> + * to a single user cgroup.
> + *
> + * A bdev inode can contain metadata pages charged to many memory cgroups.
> + * Dirtying these pages can trigger foreign writeback of its entire owner wb,
> + * including unrelated file data. Premature writeback of buffered overwrites
> + * reduces write coalescing, increasing disk traffic and consuming bandwidth
> + * that could serve foreground direct I/O. This can hurt performance,
> + * particularly on bandwidth-limited devices such as HDDs.
> + *
> + * This does not depend on CONFIG_BLK_DEV_WRITE_MOUNTED. Writing directly to
> + * a mounted block device is dangerous and intended for system administration.
> + * Charging the cache from these writes to the root cgroup is acceptable.
> + */
> +static void ext4_bdev_set_kernel_file(struct block_device *bdev, bool enable)
> +{
> +	struct address_space *mapping = bdev->bd_mapping;
> +	struct inode *inode = mapping->host;
> +
> +	inode_lock(inode);
> +	filemap_invalidate_lock(mapping);
> +
> +	if (!!test_bit(AS_KERNEL_FILE, &mapping->flags) == enable)
> +		goto out;
> +
> +	/*
> +	 * Folio removal uses the mapping's current accounting mode. Remove old
> +	 * folios before changing it, excluding new raw-I/O cache allocations.
> +	 */
> +	sync_blockdev(bdev);
> +	kill_bdev(bdev);
> +
> +	if (enable)
> +		set_bit(AS_KERNEL_FILE, &mapping->flags);
> +	else
> +		clear_bit(AS_KERNEL_FILE, &mapping->flags);
> +out:
> +	filemap_invalidate_unlock(mapping);
> +	inode_unlock(inode);
> +}
> +
>  static void ext4_put_super(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -1387,6 +1437,7 @@ static void ext4_put_super(struct super_
>  #if IS_ENABLED(CONFIG_UNICODE)
>  	utf8_unload(sb->s_encoding);
>  #endif
> +	ext4_bdev_set_kernel_file(sb->s_bdev, false);
>  	kfree(sbi);
>  }
> 
> @@ -5852,6 +5903,8 @@ static int ext4_fill_super(struct super_
>  	if (ctx->spec & EXT4_SPEC_s_sb_block)
>  		sbi->s_sb_block = ctx->s_sb_block;
> 
> +	ext4_bdev_set_kernel_file(sb->s_bdev, true);
> +
>  	ret = __ext4_fill_super(fc, sb);
>  	if (ret < 0)
>  		goto free_sbi;
> @@ -5877,6 +5930,7 @@ static int ext4_fill_super(struct super_
>  	return 0;
> 
>  free_sbi:
> +	ext4_bdev_set_kernel_file(sb->s_bdev, false);
>  	ext4_free_sbi(sbi);
>  	fc->s_fs_info = NULL;
>  	return ret;
> 
> 
> > 
> > 								Honza
> 
> Thanks,
> -- 
> Julian Sun <sunjunchao@bytedance.com>
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

