Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A10FF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D36E6B008C; Fri, 24 Apr 2026 17:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB016B0092; Fri, 24 Apr 2026 17:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3936B0093; Fri, 24 Apr 2026 17:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 078BC6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:24:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE65DA00FF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:24:25 +0000 (UTC)
X-FDA: 84694728090.19.B7F9F05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 117E84000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:24:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBJOzKCn;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivZTf5bwNyOeE8UoDKR128vG3ND9T+qekl1XQ1dQZNA=;
	b=L8e4SbPUnUW8UP8r9bdmhPRiE3/oEjCnlSAO2P6XWyF3Dlul8ylKKW6uMzyg6JElIuerDX
	S1XMZkXR6mEvHkT/6sTJ8aAlXaQguZtjNYKDuHhMNlaYcRxJMsemClzUH76olTN0zmAiiJ
	Zm/czYKuzb1JgCng22UzXX+MDJx+xYo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBJOzKCn;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065864; a=rsa-sha256;
	cv=none;
	b=h0VxfnpUQH6vksfGEGLcpNWHwfT0iRFVB2tgP/mtgAMbaD22XEMNPzUOj+ziLlaojaVpQt
	SpOUEih2Y550zCIkGGwmhVf22a0XwjkK+GK1zi3+FPbZZBKUAbdFTsJLW4+50JtuB+5x+O
	7i+hJzp4l/OCzfBeky01n6TCXf6N9Lo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30D46600AE;
	Fri, 24 Apr 2026 21:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8242CC19425;
	Fri, 24 Apr 2026 21:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777065862;
	bh=59p9R4tUG6NFn05rj3yz4ykiis61uI2XT3LSk12LyDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DBJOzKCn9I73w007YObJ66qbwPLT8wzG1UZngVZyWhS/ouKeGExHLS7UIsFYL1Kt2
	 q8U67hseLfoAyonQ7hivSRSwkLTyeQj/UFtIbM59n3ooDmzEBAFWRlGmTxYyfS/Kjk
	 mkjphZQ1Ddae3fDtXSHZgGTwYPmpfkHjlWrnGY+TpwCyk2h3otZFOldLHHgwLfvZt6
	 W42fuLnW3zT57Z+4dd8c+b+jaLVBgJHDcjoo2GL3CJ4BE/97AqbYwFe9LBMlKFAxAX
	 WgXs+/YcmiuMTIVdNq510NL/KHk6d/5y2fTPVEVp/CNzo0DjETh19ZU/aW4JS+EQjw
	 jrqDVEEZydRbg==
Date: Fri, 24 Apr 2026 14:24:21 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, mhocko@suse.com, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <aevfhYW0K3y9jTjI@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <7b4bf980-4ff3-4f53-8c64-1ba2d85cf1b8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b4bf980-4ff3-4f53-8c64-1ba2d85cf1b8@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 117E84000C
X-Stat-Signature: epxwo3ab51tmxfoofg1wac7q9wu7yi8f
X-HE-Tag: 1777065863-190865
X-HE-Meta: U2FsdGVkX190z0A7+h+up6nChS4THt5vfI4hM7fMqwz8i05I90WUkSAmirKkwnAQS/2VlvpeGJpK8eS5y3rO3vc8nu/smt7XPMRat6U5TqrfI560HAyNhR7RU5Ojj9JXvuTt09b3d/P1UyrP+xsfm3i5IdFjJLoQtoGGLa3/Nc4SVGyoQWC2v9+wXi8/j1nYX5fSezh0uVFscljDuR2irnqnNpWCSWGpww9HuSrWa4vq4k1ie9OdB2BxgElKCciS9Yf/Qv8aLbCJwaPAEjbQnvXBTo5oLW6USxMRzyM2dsVEBlzQm4YxcV6MdYuk/OMZv3IOUiSgvCmPACW0UOp3MPbjz+EvjBx52TUGSnpOIQ8lSlDwVDYSAHkjBap+aDjBauGLlxp638WHbVwlzQ8DsJ6OKe63IiS3aTs1pRfvTN45ECTb41HSRd7ggF/dtwTr+JKrieC+p4pDe9u4SGFLzuFf0s2moq4eVqz4N7AZp2JZTfvxMKXQDsP66AYLj5VZ79ENTKneDLQTE2VkxwuWXciQpAWVCAQoEsiYHY8gTFOvNFtKgtiMN7norJqToA9Xr7aFzqm1ly4SXeo8jnj5gjbCDJGbHaP0yfYZ69Twk+pArQECcRuRKLJ+htrlH1kRk9Y5ONskNDL+xhlnrT6xkiJ5lIIMzxF0KpM42fVb3JhlSlOBsoxbCjtGMg3AQ1bRZqyAJRq8DWnGzwwge+5zB0hd1oztIrzIkfbNFRRVl+sFG++hQbddwQJutbm7Lzn7MomK1zHBMMfpDfGpjaLvhQcW7GkzcEDbYL+XRkXInZDtd+o+anYr93iHdri5afm4dndU90elvlzVz0+jKHXy4eXZ3pNaFsq2hmTVr8xT6xY747v0xgH+2dqBiHz29YUC8z22BjyDZrFLq6dILfAmsTnAo+Q3Eu23lT+72llFxLgYVxTKWpLERT1PXIOKFko4JM3iX/+Lv9a9n0ABHeM
 k02UavZk
 1KOOCBplkPBu95bxT+nLUyS9CIhMgXxd2/4K1koKix6gC4LSufjQ1up1oF/eAMlLFQ4D+KA62jrA8dH0ceHy23p/WzIdCdg8tZu8vx48CcI+N1DQwR36nF2nAUSSMlC4jj8BE57BGGIhGz+2HGwQtFPuRcdB46GUIVl4orGJyRcqBQzj3jTTlnAHSiXFYd96pDsNwqBhUqdkJZuiIyAMW5kMvtsJW+4ye9jDeGVBwi6GnvqPoxLLxqIgyL3CsBVmF2I5WWWLgI2VAsW/rZY+w+bHOLl7VnximeJLqMT6fE+9dMr5iuDEG4Kww/fbDtoZs6U0VfMPXkgIufMEcX6XZ2BVZqMTftEJRGkQU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:56:01AM +0200, David Hildenbrand (Arm) wrote:
> On 4/22/26 01:02, Minchan Kim wrote:
> 
> Can we make the subject easier to understand?
> 
> "mm: process_mrelease: evict clean file folios when reaping a process"
> 
> > Currently, process_mrelease() unmaps pages but file-backed pages are
> > not evicted and stay in the pagecache, relying on standard memory reclaim
> > (kswapd or direct reclaim) to eventually free them. This delays the
> > immediate recovery of system memory under Android's LMKD scenarios,
> > leading to redundant background apps kills.
> > 
> > This patch implements an expedited eviction mechanism for clean pagecache
> > folios in the mmu_gather code, similar to how swapcache folios are handled.
> > It drops them from the pagecache (i.e., evicting them) if they are completely
> > unmapped during reaping.
> > 
> > Within this single unified loop, anonymous pages are released via
> > free_swap_cache(), and file-backed folios are symmetrically released via
> > free_file_cache().
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  arch/s390/include/asm/tlb.h |  2 +-
> >  include/linux/swap.h        |  5 ++---
> >  mm/mmu_gather.c             |  7 ++++---
> >  mm/swap.c                   | 42 +++++++++++++++++++++++++++++++++++++
> >  mm/swap_state.c             | 26 -----------------------
> >  5 files changed, 49 insertions(+), 33 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> > index 619fd41e710e..2736dbb571a8 100644
> > --- a/arch/s390/include/asm/tlb.h
> > +++ b/arch/s390/include/asm/tlb.h
> > @@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
> >  	VM_WARN_ON_ONCE(delay_rmap);
> >  	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
> >  
> > -	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
> > +	free_pages_and_caches(tlb->mm, encoded_pages, ARRAY_SIZE(encoded_pages));
> >  	return false;
> >  }
> >  
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 62fc7499b408..bdb784966343 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -414,7 +414,9 @@ extern int sysctl_min_unmapped_ratio;
> >  extern int sysctl_min_slab_ratio;
> >  #endif
> >  
> > +struct mm_struct;
> >  void check_move_unevictable_folios(struct folio_batch *fbatch);
> > +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr);
> >  
> >  extern void __meminit kswapd_run(int nid);
> >  extern void __meminit kswapd_stop(int nid);
> > @@ -433,7 +435,6 @@ static inline unsigned long total_swapcache_pages(void)
> >  
> >  void free_swap_cache(struct folio *folio);
> >  void free_folio_and_swap_cache(struct folio *folio);
> > -void free_pages_and_swap_cache(struct encoded_page **, int);
> >  /* linux/mm/swapfile.c */
> >  extern atomic_long_t nr_swap_pages;
> >  extern long total_swap_pages;
> > @@ -510,8 +511,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
> >  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
> >  #define free_folio_and_swap_cache(folio) \
> >  	folio_put(folio)
> > -#define free_pages_and_swap_cache(pages, nr) \
> > -	release_pages((pages), (nr));
> >  
> >  static inline void free_swap_cache(struct folio *folio)
> >  {
> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index fe5b6a031717..3c6c315d3c48 100644
> > --- a/mm/mmu_gather.c
> > +++ b/mm/mmu_gather.c
> > @@ -100,7 +100,8 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
> >   */
> >  #define MAX_NR_FOLIOS_PER_FREE		512
> >  
> > -static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> > +static void __tlb_batch_free_encoded_pages(struct mm_struct *mm,
> > +		struct mmu_gather_batch *batch)
> >  {
> >  	struct encoded_page **pages = batch->encoded_pages;
> >  	unsigned int nr, nr_pages;
> > @@ -135,7 +136,7 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> >  			}
> >  		}
> >  
> > -		free_pages_and_swap_cache(pages, nr);
> > +		free_pages_and_caches(mm, pages, nr);
> >  		pages += nr;
> >  		batch->nr -= nr;
> >  
> > @@ -148,7 +149,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
> >  	struct mmu_gather_batch *batch;
> >  
> >  	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
> > -		__tlb_batch_free_encoded_pages(batch);
> > +		__tlb_batch_free_encoded_pages(tlb->mm, batch);
> >  	tlb->active = &tlb->local;
> >  }
> >  
> > diff --git a/mm/swap.c b/mm/swap.c
> > index bb19ccbece46..e44bc8cefceb 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
> >  }
> >  EXPORT_SYMBOL(release_pages);
> >  
> > +static inline void free_file_cache(struct folio *folio)
> > +{
> > +	if (folio_trylock(folio)) {
> > +		mapping_evict_folio(folio_mapping(folio), folio);
> > +		folio_unlock(folio);
> > +	}
> > +}
> > +
> > +/*
> > + * Passed an array of pages, drop them all from swapcache and then release
> > + * them.  They are removed from the LRU and freed if this is their last use.
> > + *
> > + * If @try_evict_file_folios is true, this function will proactively evict clean
> > + * file-backed folios if they are no longer mapped.
> 
> There is no such parameter.
> 
> But I do wonder if such a parameter would be better than passing in the MM here.

Makes sense.

> 
> Also, is there a way to avoid moving the function?

I guess you are talking about "free_pages_and_swap_cache".

The problem is mm/swap_state.c is conditionally compiled only when CONFIG_SWAP
is enabled.

Since the expedited clean file cache eviction should be available
even on !CONFIG_SWAP, we need this function to be compiled unconditionally.
That is why I moved it to swap.c, which is always compiled.

I am open for any suggestion.

