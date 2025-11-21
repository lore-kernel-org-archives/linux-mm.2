Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E5FCFC283
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1DE6B0005; Fri, 21 Nov 2025 10:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251D36B008A; Fri, 21 Nov 2025 10:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140F56B008C; Fri, 21 Nov 2025 10:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F13F56B0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:14:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0555B3DC4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:14:18 +0000 (UTC)
X-FDA: 84134960196.06.2D69520
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85E0C1C0007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:14:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HEpwXLy6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763738057; a=rsa-sha256;
	cv=none;
	b=UyNSmyyUq3rMJOpjj+9yshMCc8kNJGvHCVv2jDNdlbeSZ5JDXDIpJmN+62z/bXvTDPLMJI
	Ae7bPMqouNCvlcffUvIYOIdUu0J1t87q9zI/XCwAvfFZpS7lfj8F8S8FFD363RUGa/5b2c
	P2ztLpD/Y9qmDV9im8bcyZlp6+rQLHI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HEpwXLy6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763738057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhi3gRCsUEigZ28WoqnsDUgxO6MSVas+rV611N6S3Dk=;
	b=qcgwaMdTqHioZjIhD6zxgwhiilSCk0RuEQ+bIXbuHVB51Wj/GD1MCqIsHXvS60tWwkeD/p
	UlXzRKgKHd5oa03/eZBJFoySSYxhYU+McYU2L+U5ELfCAedsdPDxeSlMTDkujwp448rvEP
	pLXzk3T8+Jwz0asmh/V9gg/58hoC9Q0=
Date: Fri, 21 Nov 2025 15:14:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763738054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uhi3gRCsUEigZ28WoqnsDUgxO6MSVas+rV611N6S3Dk=;
	b=HEpwXLy6j7got7C8bEQ9whTKxtLyXcTNe05wBWn3ObhjI7WVVBTf5Dfr/retq08TRTRLTY
	pPedNOxN+IokgW17WJh+lxKMQz3TknqRHDhpSnbl9GhcYoeasdiE48GXjMLHnarfHNRdWH
	De0osH79xzYn0yKUUuMfjl9JQOls3EM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <454ejfdrzcdo5a4fmqeaf4nwhxwqnvgmcj7ussl7ws3lpdc7zg@67yqrig42erd>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85E0C1C0007
X-Stat-Signature: qafz46zwx1wxuzkxkk4mrho1fgdt4dqo
X-HE-Tag: 1763738056-55348
X-HE-Meta: U2FsdGVkX1/If0yS4adwmFOWFxqyWt2Bvq+2jvRjsSf95kFTZfASMobBrpamMifiow1y0Yxlxlc8WU0cJpWACEsn39rCPisIWdA1TdC3j6yliskfeOmWi4NO0QR9Og+Chr/WWA04Ymo/JGgYX0YhQs4p6avunOkCUVNC5OD/81DlkkeQvf4BcLixev0HExl2RBHxo+0uCiWHwgo08yBNtBR0G1OyutDPe8fWdyBWlbl8ItpsH2DpePKLAaELYTdP0tDjLuTCYaBJsnGNUn4k2lf7fAoS4YdDfOY1WmA0brwxzmZdtwzZ6RTO7xCi9r1xxHlNKWXrlqjrc40+9GZ0Ax7ZFvWolO0Egi/sNWQFm7RaqmZPiUZR7mKCtUPlNMB3sprPt1HWe5Kv+P7l3gfkMhJ6+RLm18b0cAuEtfEiyXOYSMeuhbJu+Bv6yQrbBBNGEb2O9vLQyS099NwW0VBurW/xC4IQYTMCuuXECx+bY0V3b6jLcQOCSKiynPTr2zh4cO4i1UUpkHN8JKbLr6+4x/vSVtF4w7LfhJMnP5tYKn802gSAscOVl4HwbMGs4iiYTKsTKTnhHkrWJQFbWfd9BSyrissYx9ldlu6uEdBreCTldXh73p2wVHlsqMrAIEYgoDqaM7DTTHI3OEEQxBViwN1cf9ekyZ4WS5wEVYMQLUf3MsZZsUVFvPl+xXLB31uvuye+fHrvvLdcy2MxVPQlTqQJePGR2LhQG0qEBAnWLGcsam60Q3WEmQ5YYWroPbdwQnC87+cz33moh3JyxrKcsqorMN3gsYS9gExysADChzXk/lUlMa3RCxjPOd79EV1Oa3CpvLQHzZrt3M4z+Wt8OCNVnaD7Zvfl4sxtaNqAoBl90YiSxp/qV59sq9hhQNoqo25cmFTCntJVFUceLRfpPSdnY26Mvpz5A7fik4wY+/C0qxkbhTyUzvSXs/acy3vfjGLF/h7pp2WiBxhaRED
 xLhRNPln
 CcJnwPx+5od4lwr30dBGXLBXXHhi/U0JR4NcRSFBF46P/vywtUPb6kvq7AUadQsgeQ4jiYC2rBbmFsQ6ZPM6RnE/fyrm1+LLsZXQ8GP4dT/rQ9HmjR+uCzgmKKsa/g0ZU2plkIeB5OuiVQ7xA8R6l6iWFns1jAVcBHwG+XX+1jcAKGvrGrOX2GqMB333cqcgdTVn4vwxi15lVa19+HZWVFyOLviVaAReH9A+BT02FsXj+MtObQrto7V1+/6e63Ujifvmt/dBSQClwlnA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> The current zswap requires a backing swapfile. The swap slot used
> by zswap is not able to be used by the swapfile. That waste swapfile
> space.
> 
> The ghost swapfile is a swapfile that only contains the swapfile header
> for zswap. The swapfile header indicate the size of the swapfile. There
> is no swap data section in the ghost swapfile, therefore, no waste of
> swapfile space.  As such, any write to a ghost swapfile will fail. To
> prevents accidental read or write of ghost swapfile, bdev of
> swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> flag because there is no rotation disk access when using zswap.
> 
> The zswap write back has been disabled if all swapfiles in the system
> are ghost swap files.
> 
> Signed-off-by: Chris Li <chrisl@kernel.org>

This was brought up before, I think it's not the right way to go
upstream. Even if it's good for the short-term, it's a behavior exposed
to userspace that we'll have to maintain. With the ongoing work to
decouple zswap and swap backends, this will end up being something we
have to workaround indefinitely to keep the same userspace semantics.

> ---
>  include/linux/swap.h |  2 ++
>  mm/page_io.c         | 18 +++++++++++++++---
>  mm/swap.h            |  2 +-
>  mm/swap_state.c      |  7 +++++++
>  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
>  mm/zswap.c           | 17 +++++++++++------
>  6 files changed, 73 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 38ca3df68716042946274c18a3a6695dda3b7b65..af9b789c9ef9c0e5cf98887ab2bccd469c833c6b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -216,6 +216,7 @@ enum {
>  	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
>  	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
>  	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
> +	SWP_GHOST	= (1 << 13),	/* not backed by anything */
>  					/* add others here before... */
>  };
>  
> @@ -438,6 +439,7 @@ void free_folio_and_swap_cache(struct folio *folio);
>  void free_pages_and_swap_cache(struct encoded_page **, int);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
> +extern atomic_t nr_real_swapfiles;
>  extern long total_swap_pages;
>  extern atomic_t nr_rotate_swap;
>  
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3c342db77ce38ed26bc7aec68651270bbe0e2564..cc1eb4a068c10840bae0288e8005665c342fdc53 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -281,8 +281,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  		return AOP_WRITEPAGE_ACTIVATE;
>  	}
>  
> -	__swap_writepage(folio, swap_plug);
> -	return 0;
> +	return __swap_writepage(folio, swap_plug);
>  out_unlock:
>  	folio_unlock(folio);
>  	return ret;
> @@ -444,11 +443,18 @@ static void swap_writepage_bdev_async(struct folio *folio,
>  	submit_bio(bio);
>  }
>  
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  
>  	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> +
> +	if (sis->flags & SWP_GHOST) {
> +		/* Prevent the page from getting reclaimed. */
> +		folio_set_dirty(folio);
> +		return AOP_WRITEPAGE_ACTIVATE;
> +	}
> +
>  	/*
>  	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
>  	 * but that will never affect SWP_FS_OPS, so the data_race
> @@ -465,6 +471,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>  		swap_writepage_bdev_sync(folio, sis);
>  	else
>  		swap_writepage_bdev_async(folio, sis);
> +	return 0;
>  }
>  
>  void swap_write_unplug(struct swap_iocb *sio)
> @@ -637,6 +644,11 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  	if (zswap_load(folio) != -ENOENT)
>  		goto finish;
>  
> +	if (unlikely(sis->flags & SWP_GHOST)) {
> +		folio_unlock(folio);
> +		goto finish;
> +	}
> +
>  	/* We have to read from slower devices. Increase zswap protection. */
>  	zswap_folio_swapin(folio);
>  
> diff --git a/mm/swap.h b/mm/swap.h
> index d034c13d8dd260cea2a1e95010a9df1e3011bfe4..bd60bf2c5dc9218069be0ada5d2d843399894439 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -195,7 +195,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
>  }
>  void swap_write_unplug(struct swap_iocb *sio);
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
> +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
>  
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __ro_after_init;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b2230f8a48fc2c97d61d4bfb2c25e9d1e2508805..f01a8d8f32deb956e25c3c24897b0e3f6c5a735c 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -632,6 +632,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	struct swap_iocb *splug = NULL;
>  	bool page_allocated;
>  
> +	/*
> +	 * The entry may have been freed by another task. Avoid swap_info_get()
> +	 * which will print error message if the race happens.
> +	 */
> +	if (si->flags & SWP_GHOST)
> +		goto skip;
> +
>  	mask = swapin_nr_pages(offset) - 1;
>  	if (!mask)
>  		goto skip;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94e0f0c54168759d75bc2756e7c09f35413e6c78..a34d1eb6908ea144fd8fab1224f1520054a94992 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
> +atomic_t nr_real_swapfiles;
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>   * memory pressure (via the shrinker). Before doing so, they may wish to
> @@ -1158,6 +1159,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
>  			goto skip;
>  	}
>  
> +	if (!(si->flags & SWP_GHOST))
> +		atomic_sub(1, &nr_real_swapfiles);
>  	plist_del(&si->avail_list, &swap_avail_head);
>  
>  skip:
> @@ -1200,6 +1203,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
>  	}
>  
>  	plist_add(&si->avail_list, &swap_avail_head);
> +	if (!(si->flags & SWP_GHOST))
> +		atomic_add(1, &nr_real_swapfiles);
>  
>  skip:
>  	spin_unlock(&swap_avail_lock);
> @@ -2677,6 +2682,11 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
>  	struct inode *inode = mapping->host;
>  	int ret;
>  
> +	if (sis->flags & SWP_GHOST) {
> +		*span = 0;
> +		return 0;
> +	}
> +
>  	if (S_ISBLK(inode->i_mode)) {
>  		ret = add_swap_extent(sis, 0, sis->max, 0);
>  		*span = sis->pages;
> @@ -2910,7 +2920,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	if (p->flags & SWP_CONTINUED)
>  		free_swap_count_continuations(p);
>  
> -	if (!p->bdev || !bdev_nonrot(p->bdev))
> +	if (!(p->flags & SWP_GHOST) &&
> +	    (!p->bdev || !bdev_nonrot(p->bdev)))
>  		atomic_dec(&nr_rotate_swap);
>  
>  	mutex_lock(&swapon_mutex);
> @@ -3030,6 +3041,19 @@ static void swap_stop(struct seq_file *swap, void *v)
>  	mutex_unlock(&swapon_mutex);
>  }
>  
> +static const char *swap_type_str(struct swap_info_struct *si)
> +{
> +	struct file *file = si->swap_file;
> +
> +	if (si->flags & SWP_GHOST)
> +		return "ghost\t";
> +
> +	if (S_ISBLK(file_inode(file)->i_mode))
> +		return "partition";
> +
> +	return "file\t";
> +}
> +
>  static int swap_show(struct seq_file *swap, void *v)
>  {
>  	struct swap_info_struct *si = v;
> @@ -3049,8 +3073,7 @@ static int swap_show(struct seq_file *swap, void *v)
>  	len = seq_file_path(swap, file, " \t\n\\");
>  	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
>  			len < 40 ? 40 - len : 1, " ",
> -			S_ISBLK(file_inode(file)->i_mode) ?
> -				"partition" : "file\t",
> +			swap_type_str(si),
>  			bytes, bytes < 10000000 ? "\t" : "",
>  			inuse, inuse < 10000000 ? "\t" : "",
>  			si->prio);
> @@ -3183,7 +3206,6 @@ static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
>  	return 0;
>  }
>  
> -
>  /*
>   * Find out how many pages are allowed for a single swap device. There
>   * are two limiting factors:
> @@ -3229,6 +3251,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
>  	unsigned long maxpages;
>  	unsigned long swapfilepages;
>  	unsigned long last_page;
> +	loff_t size;
>  
>  	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
>  		pr_err("Unable to find swap-space signature\n");
> @@ -3271,7 +3294,16 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
>  
>  	if (!maxpages)
>  		return 0;
> -	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
> +
> +	size = i_size_read(inode);
> +	if (size == PAGE_SIZE) {
> +		/* Ghost swapfile */
> +		si->bdev = NULL;
> +		si->flags |= SWP_GHOST | SWP_SOLIDSTATE;
> +		return maxpages;
> +	}
> +
> +	swapfilepages = size >> PAGE_SHIFT;
>  	if (swapfilepages && maxpages > swapfilepages) {
>  		pr_warn("Swap area shorter than signature indicates\n");
>  		return 0;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958da3b5e74b63217b06e58ba2d3c26..29dfcc94b13eb72b1dbd100ded6e50620299e6e1 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1005,14 +1005,18 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	struct folio *folio;
>  	struct mempolicy *mpol;
>  	bool folio_was_allocated;
> -	struct swap_info_struct *si;
> +	struct swap_info_struct *si = get_swap_device(swpentry);
>  	int ret = 0;
>  
> -	/* try to allocate swap cache folio */
> -	si = get_swap_device(swpentry);
>  	if (!si)
> -		return -EEXIST;
> +		return -ENOENT;
> +
> +	if (si->flags & SWP_GHOST) {
> +		put_swap_device(si);
> +		return -EINVAL;
> +	}
>  
> +	/* try to allocate swap cache folio */
>  	mpol = get_task_policy(current);
>  	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
>  			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> @@ -1067,7 +1071,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	folio_set_reclaim(folio);
>  
>  	/* start writeback */
> -	__swap_writepage(folio, NULL);
> +	ret = __swap_writepage(folio, NULL);
> +	WARN_ON_ONCE(ret);
>  
>  out:
>  	if (ret && ret != -EEXIST) {
> @@ -1551,7 +1556,7 @@ bool zswap_store(struct folio *folio)
>  	zswap_pool_put(pool);
>  put_objcg:
>  	obj_cgroup_put(objcg);
> -	if (!ret && zswap_pool_reached_full)
> +	if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapfiles))
>  		queue_work(shrink_wq, &zswap_shrink_work);
>  check_old:
>  	/*
> 
> ---
> base-commit: 9835506e139732fa1b55aea3ed4e3ec3dd499f30
> change-id: 20251121-ghost-56e3948a7a17
> 
> Best regards,
> -- 
> Chris Li <chrisl@kernel.org>
> 

