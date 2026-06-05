Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D421CD6E77
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C323A6B0088; Fri,  5 Jun 2026 01:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2C66B008A; Fri,  5 Jun 2026 01:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9706B008C; Fri,  5 Jun 2026 01:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1E916B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:21:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25FAC8CF32
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:21:53 +0000 (UTC)
X-FDA: 84844712106.11.9D6F6C3
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0282F140006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:21:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fxGOVn2K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780636911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrXkC9XXR2POzj4kvHLlIqIaRywcfo8fMhrttPgMuF4=;
	b=Jxk/IxCkDLgF32wwvwdE6kI3bCZzaVOBzuD2e3O11jZe1iu9whqyBwPgSofNxp533Spzi0
	42DMOvrVmFTVbe+i4oDb6NtzdzYuTOTMi7UEfrRlQc/eefR0zl1e33fmTpwCsi9OGl4gSQ
	pAjPHttAugqxfvQkWd5VMeRT7/VsFq4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fxGOVn2K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780636911;
	b=HXEBOYeAiRU2y6A2KK+UiAQWmrAMjKlBEDXEhIlHiPh9ZgBOKG1PQbjs9SKTM3C7BHlLx/
	5yzKgKbQuzQOO3x+JEn0Meoq9Ly6pXUCwSZjNSDAaVNxwJqwA2uq2PEHOXTCSWMpvdCl5I
	p5BsNibbp8GdSSFUtSZKd6zzW/NSQWM=
Date: Fri, 5 Jun 2026 13:21:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780636908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrXkC9XXR2POzj4kvHLlIqIaRywcfo8fMhrttPgMuF4=;
	b=fxGOVn2KSKL7J6dhCPQOxp4tYY8sqZUMbM75aaqWi76FRORjgHlvyHnqCA4cl+wN/lKRhH
	l2tWiRWFq4VCXeduyVE3ZTJDFyg5V3QvNEOjpQyeHan55O3nSLGXzxlCx109TLumTjctK4
	IDXjgrp18JPzpDBpAGktCrA0ZWSbN9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 7/8] mm/swap: remove SWP_FS_OPS
Message-ID: <aiJc5pPU_kvxs0a7@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-8-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0282F140006
X-Stat-Signature: ga9enjnjspix9dkzi6ytari81bxwqez7
X-HE-Tag: 1780636910-453602
X-HE-Meta: U2FsdGVkX1/KPuGBwiG2MgCAsmHRnCGYmodkgovVr7pPcAO8Rqx45QYB4NOcsRbDrkhmODM1rtnv0N3RIDOh6KzoVfKndqt4yeIySLdwwYITYmJ0LZwiz+1i9YfHUVVawfu6mve92mt3jPV8DW+FN+Y0PQqjiNGDjG1DSXjkPsGNduJZ2GXe+fpSiVs2V3VUHk/tvhaz0OZAdkuhb+CYYO8C813Dl1bNYpZUBhq4KcWJeKxzNA5bRwPdPK9W/S//DRfvvY9n3qTEui0DvswyN/SjSNAAuJECfi8SjwowNNJZHw86KcGbwxCoVtTYyIl1xI5iowPBIkDsofEYXxHoUMMitMBQ2zIkcZqDDUCW5HUlhK6sMdfMHNjuPzIUsRYpZNeB7ZM0oBDqp9uCmTDkTNU0TERxjgpg6AkJUFhutSum29pV6iLqFTkwKjrwA1sHL8ZBThrcGaSfoC1ns+gGlYrwqZyRlp0Ey61DT2jMWd8OiK1u5AUaEFW8EoNN/U46OWqLcGKavh7yzlhbwIy1//YGW9ccd9gG6Hgy0VKjxWE2JDYzsbNg3qQjyVeg2AABDw6AySj4uRKgGHR7ovu9eHGLYE6XW09ZuzRpO8fGdvpk3Z4pqhzwDAf4X/9MgS3NTZhzbEhP0yUYMkW6qP0oKbUBHheBI1DTQHyUVLoT6N+/4Yj3eicUfT+QpbJj9xalGDwv4x415Xs2LVt3jBoUbv/nlf/fIyyagIBhbIu929TNp5jKeZ47I4dxLF6rAttuuRVZiVB9AtcVD94jTuE57FcBH2FVUsDdaECEV3FNntKHh0pHvUBeH5eaHpBMgWN3kPmV9m6iPKKxYgc+dM72boJ6m0hAbNT31bw10iN95+2G7sLK27JztflyRj+YuACNYE74ws+Aiwvt0yQjGXuQK6LDWa6vt0f8O8Ho3FwTQRQDU2MPB3GFYZTou6MEzw2ZkWgiKebj71z0sqMPCNM
 UA0HRFDX
 T7QM8B9ztB2ppVHBcOoSCyHHxEJEbAb5SM3TTwji+WflwhgV+mD/5FcPjh9qJvw8Qzrh2oQOi8U9t0WNQwoovNaow6z7YB+CtNXc8FwKjzWCVyIvFpa9TqTnjXqMXthVNELR+ySZxqR0mMzJTPwgEp66V05BdjRWTY7AVW3IDBDj5c2e8WQMxKUQlGrgfU+Bxz6dI9XzhaaatV9lGIaERaFh1p6e/5g05VagZwDfbT4A7B5GEoOcjQVFVEpVkvNpA18kaDmS1zLOu7eZyuBXQ7dYCYwwDa3Xd0iR7MWDzxuWNJic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
...snip...
> diff --git a/mm/swap.h b/mm/swap.h
> index 5119feff0e93..edb512e619ee 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -84,7 +84,11 @@ struct swap_io_ctx {
>  	struct swap_info_struct	*sis;
>  };
>  
> +#define SWAP_OPS_F_NOFS		(1U << 0)
> +

The name of this flag and its usage are a little weird, surely the old
one SWP_FS_OPS is similar. Do you think if we need add some document
as below to make it clearer? Personal opinion and just for reference.

diff --git a/mm/swap.h b/mm/swap.h
index edb512e619ee..3d978382a7d5 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -84,6 +84,18 @@ struct swap_io_ctx {
 	struct swap_info_struct	*sis;
 };
 
+/*
+ * SWAP_OPS_F_NOFS: swap operations that may recurse into the filesystem
+ * (e.g. NFS, CIFS).  When set, callers (specifically reclaim) must operate
+ * under GFP_NOFS / !__GFP_FS to avoid deadlock.  When clear (block-device
+ * swap), the swap I/O path does not touch the filesystem, so reclaim may
+ * safely enter the filesystem even with only __GFP_IO.
+ *
+ * In may_enter_fs() this appears as a double negative (!SWAP_OPS_F_NOFS)
+ * which reads as "not a nofs swap => may enter fs".  This is intentional:
+ * it is bdev swap (the common case) that allows filesystem re-entry, while
+ * filesystem-based swap explicitly forbids it.
+ */
 #define SWAP_OPS_F_NOFS		(1U << 0)
 
 struct swap_ops {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2d44ebfebdea..a92956de5e10 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1039,7 +1039,9 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 		return true;
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO unless backed by
-	 * a swapfile that requires GFP_NOFS I/O.
+	 * a swapfile that requires GFP_NOFS I/O (i.e. filesystem-based swap
+	 * like NFS/CIFS, which sets SWAP_OPS_F_NOFS).  Block-device swap
+	 * never touches the filesystem, so it is safe to enter fs here.
 	 */
 	if (folio_test_swapcache(folio) && (gfp_mask & __GFP_IO) &&
 	    !(__swap_entry_to_info(folio->swap)->ops->flags & SWAP_OPS_F_NOFS))

>  struct swap_ops {
> +	unsigned int		flags;
> +
>  	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
>  			size_t prev_folio_size, int rw);
>  	void (*submit_write)(struct swap_io_ctx *ctx);
> @@ -335,11 +339,6 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
>  void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>  			   unsigned long addr);
>  
> -static inline unsigned int folio_swap_flags(struct folio *folio)
> -{
> -	return __swap_entry_to_info(folio->swap)->flags;
> -}
> -
>  #else /* CONFIG_SWAP */
>  static inline struct swap_cluster_info *swap_cluster_lock(
>  	struct swap_info_struct *si, pgoff_t offset, bool irq)
> @@ -470,16 +469,9 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  		struct folio *old, struct folio *new)
>  {
>  }
> -
> -static inline unsigned int folio_swap_flags(struct folio *folio)
> -{
> -	return 0;
> -}
> -
>  #endif /* CONFIG_SWAP */
>  
>  extern const struct swap_ops swap_bdev_ops;
> -extern const struct swap_ops swap_fs_ops;
>  
>  int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>  		struct list_head *folio_list);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a670635e0fbe..284eebc40a70 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2858,8 +2858,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
>  		if (ret < 0)
>  			return ret;
> -		if (sis->flags & SWP_FS_OPS)
> -			sis->ops = &swap_fs_ops;
>  		sis->flags |= SWP_ACTIVATED;
>  		return ret;
>  	}
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c43177a8e4dd..2d44ebfebdea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1037,16 +1037,14 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
>  {
>  	if (gfp_mask & __GFP_FS)
>  		return true;
> -	if (!folio_test_swapcache(folio) || !(gfp_mask & __GFP_IO))
> -		return false;
>  	/*
> -	 * We can "enter_fs" for swap-cache with only __GFP_IO
> -	 * providing this isn't SWP_FS_OPS.
> -	 * ->flags can be updated non-atomically,
> -	 * but that will never affect SWP_FS_OPS, so the data_race
> -	 * is safe.
> +	 * We can "enter_fs" for swap-cache with only __GFP_IO unless backed by
> +	 * a swapfile that requires GFP_NOFS I/O.
>  	 */
> -	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
> +	if (folio_test_swapcache(folio) && (gfp_mask & __GFP_IO) &&
> +	    !(__swap_entry_to_info(folio->swap)->ops->flags & SWAP_OPS_F_NOFS))
> +		return true;
> +	return false;
>  }
>  
>  /*
> -- 
> 2.53.0
> 

