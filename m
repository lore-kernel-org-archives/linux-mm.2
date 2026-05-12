Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C98ACD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973AB6B0005; Tue, 12 May 2026 13:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923FD6B0092; Tue, 12 May 2026 13:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8187D6B0093; Tue, 12 May 2026 13:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 688D36B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:08:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D43CA8C502
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:08:49 +0000 (UTC)
X-FDA: 84759402378.08.1F56B75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 214DA8000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:08:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJflnRm6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdIwxhE44Yq4qV2SnYLz6hAb1N+IgVV4bJ/hIou1Jp4=;
	b=cfLmfxNgU7jalUel5eBajpQ7op4L7IvlGyGunqyKNNPXy1Wxw80+3dKVQYRytdQiK/gsYR
	pkrA0v23J6WiUTLofVYK9tASuvqYIswz3D0pswAUPfWgC++3RJwS3tHlV4ykFKeDHthvam
	3a7i9yWs+8flOKTgFwQ9TF8WEz/XELE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605728; a=rsa-sha256;
	cv=none;
	b=KbQ5AGhpts1gd91b9Ms1WrSNZGBXpRJ6X+W2rWg/ATwJ9Gvc6tLLchK4QryE6wE2c7CPwA
	wLuBgT3Y4nItjAtKobFwqCd3GFwsSsj2W54oO9Q03SYDfJk0nyXxjcoUnyCKNEvoyKS4ab
	iHjCol6aelRCWDa9p6bU5LgW/ZP5DMY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJflnRm6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EA4960120;
	Tue, 12 May 2026 17:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0488AC2BCB0;
	Tue, 12 May 2026 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605727;
	bh=sVVODp3FlRWZt0085AhF6/0c9Y54VioUFXOyMcpSdl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UJflnRm6SyyebasilDKjjTMaTpzMjJu1nDkjFBw12Q8ys93lS4T5SkwVsmql5u44E
	 9COiwostSmZp93nnSioVTeUSZy1eDPwytqhDSbQrtz+KgPT9bD7YFnS+McUwXeV1h8
	 LgzDS7wt9P4VVHHXphzL/JOZ+tuiP5KIbfbPapYnHT62iaaCCTD455/6iIs8kZi83N
	 GJ2sLX5BXvjivClIj4FM/J5OxJ75G9ZqWZ6HC+NlCyEGiL0kJvSMH9znL+vWnh7oAu
	 Rw2xMqdTg1sKp20gQW6iHYZGVSH1uI8KL+IWc0hoZUOeogME2oEp9O9rCZkTKCKG5j
	 OrtX03iel0R+w==
Date: Tue, 12 May 2026 10:08:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
Message-ID: <20260512170846.GJ9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260512053625.2950900-10-hch@lst.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 214DA8000B
X-Stat-Signature: j36nboaqwt41ar7t7zrjf1xh6ons47qp
X-Rspam-User: 
X-HE-Tag: 1778605727-427650
X-HE-Meta: U2FsdGVkX1/PAFZCu6ImhoDBbiWFzHb3O1I+4VVebNykPsgbjbO7jLUzKGkS0FnI4GS4Ay1Mcy9i3CD10FlgXflkBpDbzpOsvILrCe7ISGgIfhsoWPeddEyzVygOte3aTrcFP5sjjcA+T2AFq9F787azdz2I62q7tN0M0tzPpfsqRXbz+fAKTCn7fEwcuOmUCDO0oH1fEbyJAyU8FKsLifOju6yc8THBcVMA70uXsyd1ZJDan/TVNR1Zj0zsffhf/2NEKvzuqdF9LbwnMuqY6mAwcZTj7p7GkKGVSejHokc5nsT1KWuZskxPzHQcavAz739r//bmL6oU2txeg9TAGT5xC7c4+ml8r1MrGEoobHWu4SFXViie0E/5xdAYWP33TUg/cHLT0HjOGAafLjh+LU6YlbM69F4aqc6AqvgWQWDzEXaxrfd4MpvoccST6xLlXMfN1RnASIe1SBA2OCi/hqiMCaxH3qDL4Mg2711qZr0O3rydyWWK0CAnYESfxjzELzGynxZXcX6/72DVEPv2gDXJppo5yEqol1xq/zfIZ6xs4iStNTXNvC0WD+AkiQzSBg4hzWkJ7L5hUOhHNX8Ud9DaiamQs36vOV12HKXzelJGKWo9niUwz+3PiypLOYwiX1jczARYcfsWw0O97moZ8RtA7pjaUpn715uYUIWq3PHkeHNukVcL83ywzFZV5CWRkO4IH2AcK9shO2hBrkUKgcUifAP2JLnNq+lVx+pcs7fUVvb3eB2k1n2dOq+kcL1sFeXfDng4nJ2CBTJqRB715QDi0QchhSvedTheL56q4k1+2jFMoWodoM9n+a9vkU/YXHCmj2reNqrcLDBbJcW1hqx9a2mw/NHV3eqlPB7qRI8Kzy6GWfleUt6zjqZOZfn0MSbEF27MXsHMHCYJYn351Zk6L/FjCfRTsD1YvBaIlWw/W5ZlfErQ4nZMrfatgAtJIfOfpB2ZVyxLo7IKaGW
 ImqL2Oq5
 L3GjM+AcLlL17v+uoe7H1jCUgqQUZZr+0orRfTBAl8pSSpV5+m6OFXzlbwLJw+sbV7NpYR5bbwpMTnURpMkwl7jI5LpMGKesp+34yt4MKihIW1bxvs+yU6XgYluhNT/Y6utUMsXtI6t2wIWoX25QAxpB71SxandE0PTsrosglmUusEA8X8nqukN3xZtm/ofwga9i/xI4Ckbs9Pp0jZ61armwqIj7KfPKem2JNHRGNX/vpw7LmJy/WSGFoRb0xEOwz9ziSh73Xfr3RJS2R0/TbC5DpFTQpWPU3yqhUSGndo9qUB0rmWz2OKa1kAejmNYHiCSq3qjSFT+0T/rzGMTeX3Mdf0RNCaynKcyoopmU7rGkgbSPSQIq0fI/D0TY/qLf44DxZRNpvxFhdYJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:25AM +0200, Christoph Hellwig wrote:
> Only the file operation method knows what block device we'll swap
> to.  So move down setting sis->bdev and the special blockdev flag
> into ->swap_activate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/fops.c         |  9 ++++++++-
>  fs/btrfs/inode.c     |  7 ++++---
>  fs/f2fs/data.c       |  3 ++-
>  fs/iomap/swapfile.c  |  7 ++-----
>  fs/nfs/file.c        |  2 +-
>  fs/smb/client/file.c |  2 +-
>  fs/xfs/xfs_file.c    |  6 ------
>  include/linux/swap.h |  4 ++--
>  mm/page_io.c         |  3 +--
>  mm/swapfile.c        | 38 ++++++++++++--------------------------
>  10 files changed, 33 insertions(+), 48 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 067e46299666..da09ce3f072f 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -951,9 +951,16 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
>  
>  static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
>  {
> +	struct block_device *bdev = I_BDEV(file->f_mapping->host);
>  	loff_t isize = i_size_read(bdev_file_inode(file));
>  
> -	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), 0);
> +	/*
> +	 * The swap code performs arbitrary overwrites, which are not supported
> +	 * on zones with sequential write constraints.
> +	 */
> +	if (bdev_is_zoned(bdev))
> +		return -EINVAL;
> +	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), bdev, 0);
>  }
>  
>  const struct file_operations def_blk_fops = {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ee0a7947706a..84003c520530 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10201,6 +10201,7 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
>  }
>  
>  struct btrfs_swap_info {
> +	struct btrfs_device *device;
>  	u64 start;
>  	u64 block_start;
>  	u64 block_len;
> @@ -10214,7 +10215,8 @@ static int btrfs_add_swap_extent(struct swap_info_struct *sis,
>  	first_ppage = PAGE_ALIGN(bsi->block_start) >> PAGE_SHIFT;
>  	next_ppage = PAGE_ALIGN_DOWN(bsi->block_start + bsi->block_len) >> PAGE_SHIFT;
>  
> -	return add_swap_extent(sis, next_ppage - first_ppage, first_ppage);
> +	return add_swap_extent(sis, next_ppage - first_ppage, bsi->device->bdev,
> +			first_ppage);
>  }
>  
>  void btrfs_swap_deactivate(struct file *file)
> @@ -10503,6 +10505,7 @@ int btrfs_swap_activate(struct file *file, struct swap_info_struct *sis)
>  			bsi.start = key.offset;
>  			bsi.block_start = physical_block_start;
>  			bsi.block_len = len;
> +			bsi.device = device;
>  		}
>  
>  		if (fatal_signal_pending(current)) {
> @@ -10533,8 +10536,6 @@ int btrfs_swap_activate(struct file *file, struct swap_info_struct *sis)
>  	up_write(&BTRFS_I(inode)->i_mmap_lock);
>  	btrfs_free_backref_share_ctx(backref_ctx);
>  	btrfs_free_path(path);
> -	if (!ret && device)
> -		sis->bdev = device->bdev;
>  	return ret;
>  }
>  #endif
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 8bcf630df557..8d116ff517c9 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -4326,7 +4326,8 @@ static int check_swap_activate(struct swap_info_struct *sis,
>  		/*
>  		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
>  		 */
> -		ret = add_swap_extent(sis, nr_pblocks, pblock);
> +		ret = add_swap_extent(sis, nr_pblocks, inode->i_sb->s_bdev,
> +				pblock);
>  		if (ret < 0)
>  			goto out;
>  		cur_lblock += nr_pblocks;
> diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
> index a4e0ca462cc4..862b4c02a8bd 100644
> --- a/fs/iomap/swapfile.c
> +++ b/fs/iomap/swapfile.c
> @@ -50,10 +50,6 @@ static int iomap_swapfile_iter(struct iomap_iter *iter, struct file *file,
>  	if (iomap->flags & IOMAP_F_SHARED)
>  		return iomap_swapfile_fail(file, "has shared extents");
>  
> -	/* Only one bdev per swap file. */
> -	if (iomap->bdev != sis->bdev)
> -		return iomap_swapfile_fail(file, "outside the main device");
> -
>  	/*
>  	 * Round the start up and the end down so that the physical extent
>  	 * aligns to a page boundary.
> @@ -61,7 +57,8 @@ static int iomap_swapfile_iter(struct iomap_iter *iter, struct file *file,
>  	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
>  	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
>  			PAGE_SHIFT;
> -	error = add_swap_extent(sis, next_ppage - first_ppage, first_ppage);
> +	error = add_swap_extent(sis, next_ppage - first_ppage, iomap->bdev,
> +			first_ppage);
>  	if (error)
>  		return error;
>  	return iomap_iter_advance_full(iter);
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 2bc55d9d71e1..10ab2a923835 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -588,7 +588,7 @@ int nfs_swap_activate(struct file *file, struct swap_info_struct *sis)
>  	ret = rpc_clnt_swap_activate(clnt);
>  	if (ret)
>  		return ret;
> -	ret = add_swap_extent(sis, sis->max, 0);
> +	ret = add_swap_extent(sis, sis->max, NULL, 0);
>  	if (ret < 0) {
>  		rpc_clnt_swap_deactivate(clnt);
>  		return ret;
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 84459f87907e..e1bbc65ce7f3 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3327,7 +3327,7 @@ int cifs_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
>  	 */
>  
>  	sis->flags |= SWP_FS_OPS;
> -	return add_swap_extent(sis, sis->max, 0);
> +	return add_swap_extent(sis, sis->max, NULL, 0);
>  }
>  
>  void cifs_swap_deactivate(struct file *file)
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 41f7e19bd31f..74128ebf7161 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -2116,12 +2116,6 @@ xfs_file_swap_activate(
>  	 */
>  	xfs_inodegc_flush(ip->i_mount);
>  
> -	/*
> -	 * Direct the swap code to the correct block device when this file
> -	 * sits on the RT device.
> -	 */
> -	sis->bdev = xfs_inode_buftarg(ip)->bt_bdev;
> -
>  	return iomap_swap_activate(file, sis, &xfs_read_iomap_ops);
>  }
>  
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 657779485ae4..b1cbb67ddd8e 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -404,7 +404,7 @@ extern void __meminit kswapd_stop(int nid);
>  #ifdef CONFIG_SWAP
>  
>  int add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
> -		sector_t start_block);
> +		struct block_device *bdev, sector_t start_block);
>  int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis);
>  
>  static inline unsigned long total_swapcache_pages(void)
> @@ -528,7 +528,7 @@ static inline bool folio_free_swap(struct folio *folio)
>  
>  static inline int add_swap_extent(struct swap_info_struct *sis,
>  		unsigned long start_page, unsigned long nr_pages,
> -		sector_t start_block)
> +		struct block_device *bdev, sector_t start_block)
>  {
>  	return -EINVAL;
>  }
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3e1c12649448..2ab8994ed1c2 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -132,7 +132,7 @@ int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
>  		/*
>  		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
>  		 */
> -		ret = add_swap_extent(sis, 1,
> +		ret = add_swap_extent(sis, 1, inode->i_sb->s_bdev,
>  				first_block >> (PAGE_SHIFT - blkbits));
>  		if (ret < 0)
>  			return ret;
> @@ -141,7 +141,6 @@ int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
>  		continue;
>  	}
>  	return 0;
> -
>  bad_bmap:
>  	pr_err("swapon: swapfile has holes\n");
>  	return -EINVAL;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index fbf11c8c5c69..2c9d2af736c4 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2707,7 +2707,7 @@ static void destroy_swap_extents(struct swap_info_struct *sis,
>   */
>  int
>  add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
> -		sector_t start_block)
> +		struct block_device *bdev, sector_t start_block)
>  {
>  	struct rb_node **link = &sis->swap_extent_root.rb_node, *parent = NULL;
>  	struct swap_extent *se;
> @@ -2718,6 +2718,12 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
>  		return 0;
>  	nr_pages = min(nr_pages, sis->max - sis->pages);
>  
> +	/* Only one bdev per swap file for now. */
> +	if (!sis->bdev)
> +		sis->bdev = bdev;
> +	else if (bdev != sis->bdev)
> +		return -EINVAL;

Should this return error if the bdev is zoned?  AFAICT XFS and zonefs
already guard against this, but other fses might be more naïve.

--D

> +
>  	/*
>  	 * place the new node at the right most since the
>  	 * function is called in ascending page order.
> @@ -2793,6 +2799,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  	sis->flags |= SWP_ACTIVATED;
>  	if (sis->flags & SWP_FS_OPS)
>  		error = sio_pool_init();
> +	else if (WARN_ON_ONCE(!sis->bdev))
> +		error = -EINVAL;
>  	if (error)
>  		destroy_swap_extents(sis, swap_file);
>  	return error;
> @@ -3224,26 +3232,6 @@ static struct swap_info_struct *alloc_swap_info(void)
>  	return p;
>  }
>  
> -static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
> -{
> -	if (S_ISBLK(inode->i_mode)) {
> -		si->bdev = I_BDEV(inode);
> -		/*
> -		 * Zoned block devices contain zones that have a sequential
> -		 * write only restriction.  Hence zoned block devices are not
> -		 * suitable for swapping.  Disallow them here.
> -		 */
> -		if (bdev_is_zoned(si->bdev))
> -			return -EINVAL;
> -		si->flags |= SWP_BLKDEV;
> -	} else if (S_ISREG(inode->i_mode)) {
> -		si->bdev = inode->i_sb->s_bdev;
> -	}
> -
> -	return 0;
> -}
> -
> -
>  /*
>   * Find out how many pages are allowed for a single swap device. There
>   * are two limiting factors:
> @@ -3500,16 +3488,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	dentry = swap_file->f_path.dentry;
>  	inode = mapping->host;
>  
> -	error = claim_swapfile(si, inode);
> -	if (unlikely(error))
> -		goto bad_swap;
> -
>  	inode_lock(inode);
>  	if (d_unlinked(dentry) || cant_mount(dentry)) {
>  		error = -ENOENT;
>  		goto bad_swap_unlock_inode;
>  	}
> -	if (!S_ISBLK(inode->i_mode) && !S_ISREG(inode->i_mode)) {
> +	if (S_ISBLK(inode->i_mode)) {
> +		si->flags |= SWP_BLKDEV;
> +	} else if (!S_ISREG(inode->i_mode)) {
>  		error = -EINVAL;
>  		goto bad_swap_unlock_inode;
>  	}
> -- 
> 2.53.0
> 
> 

