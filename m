Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49806CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D156B0092; Tue, 12 May 2026 13:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926DD6B0096; Tue, 12 May 2026 13:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D036B0098; Tue, 12 May 2026 13:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71B3A6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:10:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CA878C0CF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:10:32 +0000 (UTC)
X-FDA: 84759406704.15.7B9CEE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B598180004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:10:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwQyUKQ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605830; a=rsa-sha256;
	cv=none;
	b=2OxsjZRVuzhSVllScnmONSFiS7uqoZqQqQjD11dhfXYxuHE+dOJKepP13jH8Hy1VeblNTn
	r7788BXu4+1G4hf0GkN8kiiS5otpZw398pcBahSzNRwSZhMV+mHktCX+Cd8/GtYZiDnI8q
	F+VQhvYbaPfXYLDWKR+myGFCQkMAXUM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwQyUKQ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dn/UrQGwZJz6vHIUSDxlVTi6FsHF4b+UsK/Rmus24Sc=;
	b=VeWktVLrsv7XumYcxI7TS1LRbCRNUI33C4L7ltaJtgIgtGQv2SQoEFnzZ45BMvzMarlQdh
	mV2yMogGPNYToOFC3dmbAR6e8WMgwzi7ZmI+OXcVbmaKkRmuyRfT46VYd//CKDXLd2afg5
	sylYhVihVDIBBkfkg+pDloYDLsUd4nY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B6444170F;
	Tue, 12 May 2026 17:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEBEC2BCB0;
	Tue, 12 May 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605829;
	bh=UIMc6Epq1jKVpYoN8NQkrsbH35Z/rxkSt0+cjObPXEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cwQyUKQ7/ehswE6htqBY9YS5WZtrPNKyBqWQCvZt3MGoMAZl38WrdS4VCCUoTtce5
	 3HXiMl5gnt6E8BE0Wlgn1JAAx+a721k2CiMTFjCC1q/33PgDsydSqQVOEZ0c/aEcPh
	 qqMPItxUFu2pzF96J9wTatigpI1eNoG4appb93SUembefpNXfS+dQ3jx5Zjo7T9pg+
	 Mru+31A2ZvAy//NyZ0pamvIuUJ6MRZj/QrOw+oPtdc5YksLDWF2zrWsZK+3k4Y36/N
	 kUKgR6D21j3nHYHX3zYVq674GjpOqIAusFNnu8t7U2Rep60jDIv6s7wrNPKcxawCYO
	 7JJLf2m6C5FqQ==
Date: Tue, 12 May 2026 10:10:28 -0700
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
Subject: Re: [PATCH 12/12] swap: move swap_info_struct to mm/swap.h
Message-ID: <20260512171028.GM9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-13-hch@lst.de>
X-Stat-Signature: beofgoedq66hxe4rptwztm5emysc3uhc
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B598180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778605830-553560
X-HE-Meta: U2FsdGVkX1+yNMQ2aOzjyWtYzrdQ+/IeopxDnvAZmqM2agS/501LIIHv5OHPcSb936TW+++9ydlh6pAdM3mV0Jyh8V2VM7MP0qyTk93cM6/N36hFOKkctMbutr0y22ki473iHeN+qEZGYD2yOZ9dKCwigxb0UPyjHXEXh/DDD96Fcx20e4hLZfBjruyaAm63V+GVEdDv8oPct9BQ/IGJj7p7A41u0EiGjk78eHL8sHTboJPwntvap67JyyZ9Zetjh9bIvtxI1/lA3s2btPqGjAeT3tnei9v/asa2zYHIpwzCoKLN6ycOHB0xjn4md8G/kSiaPYRaxJ0Zfmko5QQ5/lUcZfjQMboYAky/QXAizWTP02IFupNqhBXyMLDcsKmVGFSbZkEjmEnuvMALA6ruJcpq/Ohin0k6tYmVA54ZW/m/cKOF0ihN9opkDSSnA/JP4UFzjPiI4O7UQk2E70wMy2QJUdIzUN0bVdDbfMZv87x2t59ilJj/gZIrAI5gROGKvy/gGKWOqOhNfGifoQ5POeza3o4aGTgOA+uVIOdf8iVcWYmP2xiZWnS4liqzcXI6FLpxTju1sPivLs4Dq4P9vlLUv+It5YSQz1K8FvSL9s5hMQL/X3s/jkX+gZ22MuXvZr3j0rAiW8m9MedBdH8ZYi8X81oagvKfzd4Hj8OmMWB2xAY4tmeSt1YpzQl82vQ5KI8AnUZTzrMdP4a+BwIk21GWX2HEdEeUaIh2DvV1+2dsPmDPoeRoFh8Hy3AaMWcqOM1cb212M5xGKP2Cop5Lzqa62HoDmMzcorHauquXFiQNK/LYe15EoQr3NdUePyXjizqv7XQ+wd0MSPoGnq8MAXNJb3PPMdilpGouhamECSAVpIIo8xjbXYajgZZlugSMrNNabJK8wt8cxGEhKH8hjrIFE1GG7N6Sd5Ou3pIkP9Y7xajZ/EktbsP/87vi1zGeTqa/fpiBcCWKhccrlAk
 zRYNsvSj
 IMXRdLbuX4iOXbHsLmrCkIge6h2CtebIIwN6qRC+1wOMkDNJE87AX+EnlHhi7op8avwCB/X6gGahgGDqngfN40Yc/15lLvMLkbyglTCkonTa4IPmkunmnq6oT4cEQXWqxpOw8GorCQzRqoZ1pYDh0gaH8ymrkg15R4G8GZChwj39OuA5yhqqQ6LYr5WRi2q+sE4wgMnz53IYbkPP22NgT1edGBZdyu7YAZQQN5xcv5M6RFEAn3q3ws2Hwhe4zydNdNEziiHel3Vd46SfPTUljvBZgCVcEM+iktzkn8Xs1VfLyKz+K4/yTEZLzwA1Rhpm70/Hncs0lZ5nQZ/G63FkMK1NY2gCsf30jHLQa1TFJBne1NtAVnsJ2V7B0/SOlKk8BDVnAPXzglnxhk1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:28AM +0200, Christoph Hellwig wrote:
> swap_info_struct is now internal to the MM subsystem, so remove it from
> the public header.
> 

Even more cleaning out of swap.h is nice, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/swap.h | 98 +-------------------------------------------
>  mm/swap.h            | 92 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+), 96 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 95237ee065c2..31eef9b74949 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -16,9 +16,9 @@
>  #include <uapi/linux/mempolicy.h>
>  #include <asm/page.h>
>  
> -struct notifier_block;
> -
>  struct bio;
> +struct notifier_block;
> +struct swap_info_struct;
>  
>  #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
>  #define SWAP_FLAG_PRIO_MASK	0x7fff
> @@ -178,29 +178,6 @@ struct sysinfo;
>  struct writeback_control;
>  struct zone;
>  
> -/*
> - * Max bad pages in the new format..
> - */
> -#define MAX_SWAP_BADPAGES \
> -	((offsetof(union swap_header, magic.magic) - \
> -	  offsetof(union swap_header, info.badpages)) / sizeof(int))
> -
> -enum {
> -	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
> -	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
> -	SWP_DISCARDABLE = (1 << 2),	/* blkdev support discard */
> -	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
> -	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
> -	SWP_BLKDEV	= (1 << 6),	/* its a block device */
> -	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
> -	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
> -	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
> -	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
> -	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
> -	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
> -					/* add others here before... */
> -};
> -
>  #define SWAP_CLUSTER_MAX 32UL
>  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
>  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
> @@ -219,56 +196,6 @@ enum {
>  #define SWAP_NR_ORDERS		1
>  #endif
>  
> -/*
> - * We keep using same cluster for rotational device so IO will be sequential.
> - * The purpose is to optimize SWAP throughput on these device.
> - */
> -struct swap_sequential_cluster {
> -	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
> -};
> -
> -/*
> - * The in-memory structure used to track swap areas.
> - */
> -struct swap_info_struct {
> -	struct percpu_ref users;	/* indicate and keep swap device valid. */
> -	unsigned long	flags;		/* SWP_USED etc: see above */
> -	signed short	prio;		/* swap priority of this type */
> -	struct plist_node list;		/* entry in swap_active_head */
> -	signed char	type;		/* strange name for an index */
> -	unsigned int	max;		/* size of this swap device */
> -	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
> -	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
> -	struct list_head free_clusters; /* free clusters list */
> -	struct list_head full_clusters; /* full clusters list */
> -	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
> -					/* list of cluster that contains at least one free slot */
> -	struct list_head frag_clusters[SWAP_NR_ORDERS];
> -					/* list of cluster that are fragmented or contented */
> -	unsigned int pages;		/* total of usable pages of swap */
> -	atomic_long_t inuse_pages;	/* number of those currently in use */
> -	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
> -	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
> -	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
> -	struct block_device *bdev;	/* swap device or bdev of swap file */
> -	struct file *swap_file;		/* seldom referenced */
> -	struct completion comp;		/* seldom referenced */
> -	spinlock_t lock;		/*
> -					 * protect map scan related fields like
> -					 * inuse_pages and all cluster lists.
> -					 * Other fields are only changed
> -					 * at swapon/swapoff, so are protected
> -					 * by swap_lock. changing flags need
> -					 * hold this lock and swap_lock. If
> -					 * both locks need hold, hold swap_lock
> -					 * first.
> -					 */
> -	struct work_struct discard_work; /* discard worker */
> -	struct work_struct reclaim_work; /* reclaim worker */
> -	struct list_head discard_clusters; /* discard clusters list */
> -	struct plist_node avail_list;   /* entry in swap_avail_head */
> -};
> -
>  static inline swp_entry_t page_swap_entry(struct page *page)
>  {
>  	struct folio *folio = page_folio(page);
> @@ -423,10 +350,7 @@ int find_first_swap(dev_t *device);
>  extern unsigned int count_swap_pages(int, int);
>  extern sector_t swapdev_block(int, pgoff_t);
>  extern int __swap_count(swp_entry_t entry);
> -extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
>  extern int swp_swapcount(swp_entry_t entry);
> -struct backing_dev_info;
> -extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
>  sector_t swap_folio_sector(struct folio *folio);
>  
>  /*
> @@ -452,20 +376,7 @@ bool folio_free_swap(struct folio *folio);
>  swp_entry_t swap_alloc_hibernation_slot(int type);
>  void swap_free_hibernation_slot(swp_entry_t entry);
>  
> -static inline void put_swap_device(struct swap_info_struct *si)
> -{
> -	percpu_ref_put(&si->users);
> -}
> -
>  #else /* CONFIG_SWAP */
> -static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
> -{
> -	return NULL;
> -}
> -
> -static inline void put_swap_device(struct swap_info_struct *si)
> -{
> -}
>  
>  #define get_nr_swap_pages()			0L
>  #define total_swap_pages			0L
> @@ -497,11 +408,6 @@ static inline int __swap_count(swp_entry_t entry)
>  	return 0;
>  }
>  
> -static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
> -{
> -	return false;
> -}
> -
>  static inline int swp_swapcount(swp_entry_t entry)
>  {
>  	return 0;
> diff --git a/mm/swap.h b/mm/swap.h
> index a77016f2423b..70974495bf15 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -8,6 +8,79 @@ struct swap_iocb;
>  
>  extern int page_cluster;
>  
> +/*
> + * We keep using same cluster for rotational device so IO will be sequential.
> + * The purpose is to optimize SWAP throughput on these device.
> + */
> +struct swap_sequential_cluster {
> +	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
> +};
> +
> +/*
> + * The in-memory structure used to track swap areas.
> + */
> +struct swap_info_struct {
> +	struct percpu_ref users;	/* indicate and keep swap device valid. */
> +	unsigned long	flags;		/* SWP_USED etc: see above */
> +	signed short	prio;		/* swap priority of this type */
> +	struct plist_node list;		/* entry in swap_active_head */
> +	signed char	type;		/* strange name for an index */
> +	unsigned int	max;		/* size of this swap device */
> +	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
> +	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
> +	struct list_head free_clusters; /* free clusters list */
> +	struct list_head full_clusters; /* full clusters list */
> +	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
> +					/* list of cluster that contains at least one free slot */
> +	struct list_head frag_clusters[SWAP_NR_ORDERS];
> +					/* list of cluster that are fragmented or contented */
> +	unsigned int pages;		/* total of usable pages of swap */
> +	atomic_long_t inuse_pages;	/* number of those currently in use */
> +	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
> +	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
> +	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
> +	struct block_device *bdev;	/* swap device or bdev of swap file */
> +	struct file *swap_file;		/* seldom referenced */
> +	struct completion comp;		/* seldom referenced */
> +	spinlock_t lock;		/*
> +					 * protect map scan related fields like
> +					 * inuse_pages and all cluster lists.
> +					 * Other fields are only changed
> +					 * at swapon/swapoff, so are protected
> +					 * by swap_lock. changing flags need
> +					 * hold this lock and swap_lock. If
> +					 * both locks need hold, hold swap_lock
> +					 * first.
> +					 */
> +	struct work_struct discard_work; /* discard worker */
> +	struct work_struct reclaim_work; /* reclaim worker */
> +	struct list_head discard_clusters; /* discard clusters list */
> +	struct plist_node avail_list;   /* entry in swap_avail_head */
> +};
> +
> +/*
> + * Max bad pages in the new format..
> + */
> +#define MAX_SWAP_BADPAGES \
> +	((offsetof(union swap_header, magic.magic) - \
> +	  offsetof(union swap_header, info.badpages)) / sizeof(int))
> +
> +enum {
> +	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
> +	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
> +	SWP_DISCARDABLE = (1 << 2),	/* blkdev support discard */
> +	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
> +	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
> +	SWP_BLKDEV	= (1 << 6),	/* its a block device */
> +	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
> +	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
> +	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
> +	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
> +	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
> +	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
> +					/* add others here before... */
> +};
> +
>  #ifdef CONFIG_THP_SWAP
>  #define SWAPFILE_CLUSTER	HPAGE_PMD_NR
>  #define swap_entry_order(order)	(order)
> @@ -352,6 +425,13 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  	return i;
>  }
>  
> +bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
> +struct swap_info_struct *get_swap_device(swp_entry_t entry);
> +static inline void put_swap_device(struct swap_info_struct *si)
> +{
> +	percpu_ref_put(&si->users);
> +}
> +
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
>  static inline struct swap_cluster_info *swap_cluster_lock(
> @@ -498,5 +578,17 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  {
>  	return 0;
>  }
> +static inline bool swap_entry_swapped(struct swap_info_struct *si,
> +		swp_entry_t entry)
> +{
> +	return false;
> +}
> +static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
> +{
> +	return NULL;
> +}
> +static inline void put_swap_device(struct swap_info_struct *si)
> +{
> +}
>  #endif /* CONFIG_SWAP */
>  #endif /* _MM_SWAP_H */
> -- 
> 2.53.0
> 
> 

