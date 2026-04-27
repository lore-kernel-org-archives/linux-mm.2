Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C854FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 22:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D4C6B0092; Mon, 27 Apr 2026 18:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14966B0095; Mon, 27 Apr 2026 18:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51406B0096; Mon, 27 Apr 2026 18:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7C2B6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:04:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 625A612022A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:04:27 +0000 (UTC)
X-FDA: 84705715374.02.0A277B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F1AD18000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:04:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nVPtCIXX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777327465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpNjmRQHMS8qbNRCbuXNHFVy1F4w7rOgpMOJAS43n2w=;
	b=7VL2ubNuXQK1ZePFVGraxmZbEBAUadVj3VIIpk4LbLgtzUNG8DF+Z5elvOt15gwF+TO9mf
	gpoo6gmWBWzhOgOrTQyvlKLspHgZ1sRPj0ubQ4iWYbwB26sMmv63vKT2+xQQsOEIkWwq6p
	Q23wdXMWAuuPvmxTRYF8k/wRPe/15Tk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777327465; a=rsa-sha256;
	cv=none;
	b=4mnk8MSQk+l3rQxZwqDKBlPokMqTNEgh8Lf6goEk8hj3A9mNbwd1RQugxI6Qin0nO2p5J4
	2/y8rJLK/0Op9EXML5Ir/9/GA04psHGWVWoSTnhSxz5owEJoqjJnzO8CevMHAVufAWcrVG
	mwY+bNWRhpkxIQuEEU/BgYrA5uBUbx4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nVPtCIXX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87D72406B3;
	Mon, 27 Apr 2026 22:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17312C19425;
	Mon, 27 Apr 2026 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777327464;
	bh=CbQVsmFQ8QTq1K5jO6jOHis8MRWAaygMvSzvZhWZWYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nVPtCIXX7qOBaSvM5QmkXUn3tYNPLBMCpG2MdFx9idi80eVvMbSGJwS+UcF+fnTT8
	 PWvGguUwpRyAiw9KBWeSbcf0EQhIWGQ2b0csXb2BhGk5UitWzfro1R3yhQ1b2tjzjM
	 /V8gWATJuUNsIdMf9NXU8SeyuklajXCemBls29wmHZNfqyqcAn0nA1zJIJYsNWDKtC
	 h2yOKy0XqPXCwRv5Zq/eP970iLQQHGaV+4bUE6fz17zx3FbtmbIraHOjaq4TEDuaXO
	 nrimnLhiOVYJf9AGFMQWc8ksSieAtHpmTQ+4JufIOjoRXsXlBxLdE61+7vp4gWCbZw
	 fA3ykw/jMytIg==
Date: Mon, 27 Apr 2026 15:04:22 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, mhocko@suse.com, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <ae_dZp4bkDf6zeFQ@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <7b4bf980-4ff3-4f53-8c64-1ba2d85cf1b8@kernel.org>
 <aevfhYW0K3y9jTjI@google.com>
 <f484b864-aa7f-4612-8bf8-5f6bd041ddc2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f484b864-aa7f-4612-8bf8-5f6bd041ddc2@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F1AD18000F
X-Rspamd-Server: rspam04
X-Stat-Signature: zpbyyrt1aotse93dfzuc413s3q13czm5
X-HE-Tag: 1777327465-890140
X-HE-Meta: U2FsdGVkX1/lzHvanxvfhwGGw+LJ1Cw2W+GB4Qcz4RKQR7Px+w/3iSN7GaRHIvjzcJ1jCrwsnlUyuSdeMmgPyteyjmomT4N3pt9gC1lNgOdg3xu7SgOp7SkgVAFn05FjYTJ/tlfAw9rA068+te/4TmqesOsiIlkBtZUqAys/ehfTYbznvP+O5e0mOGhhKZDAOnHScOUuYqShPWjwEEhZ9d+4yGBJU2GASPtpHiNbFxu4eV/v9fweXleOmzMloyxmiS5TSCbzQlk7Nqh56RLpdLNd+E+D9OT6WQR5DK7H/OoM8B7DZGjuNT/XdfJlfu2/L+iPv7V8rda0lS1f5PNympR/rxBdJzZ/UjHqe5TweLs+oXfes+rRIuCLXRu8k9vXZjLkY/rCWKuyCkPrnQ6mHjn1nHPvjTZMy3kuUTuynVytnf3AX3TUYfZOpiFBdZposmESwm5NZB4S8ARu4LtlWgLtG73Y4PYL7cBaDgutJaGVMC5OSp02GtyRiAnSUSlIrDOvSP5uD4Kx/F63ho/boDcy6xT9WPp30EAIZJXWkdpjBttMsPiBxnBaMBCwOa5MQhLQtOOCxEV2qQ9YqFkb/hEjzYDT8fuRljpGdlHbc7UQnl9U+MrsCfzpZ9A8uBjxPEOQg8/jcrg3t32UsesDMK5Dq/UeGthiNfyes9t0ZHXENKp9YBBDc4uD+lqWa/D/dVTIsdmgsI/7yOzpGTL11jiWWyN5wcpyJDcWjMZvcFblOeNgdAoD1O7r3NR/baZX9H2n3jI7rCyRJQxQhdL4YZDAXtXrU8CMhr3F8IU/87Of5HFHQeUZ0P7STzp2JojnH6xpLt3InDFq7TXoYMRVTE3JrKkMpXv+uHz4oJteaaOKNwd5JxG/ou+Q6zh1v1XtG3F6E7rSuT3UUobNeE9kNKwcw2pIU/W5mSeoO5/XVdRhiUu2HkeWX+bBkMJYBdUhCkVcPaQyDi1MJ/xjLCz
 ib9i9wwg
 JL2SEq3x9AEhGUUTQq398e76p7ICui/z0/lct4sBDvqWf3mqJRuZ2WoywmmksaS6C5FWoO+lARg1ojbfoVp2QXODd4QnE7kp8Z2bK3uYE8ClEdd01xrOKJyaSAkoTVkBnywtKZLK53QI+k87SPbZfklXShXJaISmif9Sv8IbdSk5txQwCaUGetR8pjFz1qWAOzVzfBjZ8EglAwNG/saxIs5XiK1vN4AtsgF2f7hQJ2+eEkXsYh7fG0po3FtDSZ7KT8M7FFXKrFkZF1YsygAGgUN9bfYV5qctoUOsHCc4S7x7mFWztXuJhuIwY4IKYSBgyBEH75MLIF23AfEn9crrXA+No1o2uCNqSk9Mx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 11:29:14AM +0200, David Hildenbrand (Arm) wrote:
> On 4/24/26 23:24, Minchan Kim wrote:
> > On Fri, Apr 24, 2026 at 09:56:01AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/22/26 01:02, Minchan Kim wrote:
> >>
> >> Can we make the subject easier to understand?
> >>
> >> "mm: process_mrelease: evict clean file folios when reaping a process"
> >>
> >>> Currently, process_mrelease() unmaps pages but file-backed pages are
> >>> not evicted and stay in the pagecache, relying on standard memory reclaim
> >>> (kswapd or direct reclaim) to eventually free them. This delays the
> >>> immediate recovery of system memory under Android's LMKD scenarios,
> >>> leading to redundant background apps kills.
> >>>
> >>> This patch implements an expedited eviction mechanism for clean pagecache
> >>> folios in the mmu_gather code, similar to how swapcache folios are handled.
> >>> It drops them from the pagecache (i.e., evicting them) if they are completely
> >>> unmapped during reaping.
> >>>
> >>> Within this single unified loop, anonymous pages are released via
> >>> free_swap_cache(), and file-backed folios are symmetrically released via
> >>> free_file_cache().
> >>>
> >>> Signed-off-by: Minchan Kim <minchan@kernel.org>
> >>> ---
> >>>  arch/s390/include/asm/tlb.h |  2 +-
> >>>  include/linux/swap.h        |  5 ++---
> >>>  mm/mmu_gather.c             |  7 ++++---
> >>>  mm/swap.c                   | 42 +++++++++++++++++++++++++++++++++++++
> >>>  mm/swap_state.c             | 26 -----------------------
> >>>  5 files changed, 49 insertions(+), 33 deletions(-)
> >>>
> >>> diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> >>> index 619fd41e710e..2736dbb571a8 100644
> >>> --- a/arch/s390/include/asm/tlb.h
> >>> +++ b/arch/s390/include/asm/tlb.h
> >>> @@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
> >>>  	VM_WARN_ON_ONCE(delay_rmap);
> >>>  	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
> >>>  
> >>> -	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
> >>> +	free_pages_and_caches(tlb->mm, encoded_pages, ARRAY_SIZE(encoded_pages));
> >>>  	return false;
> >>>  }
> >>>  
> >>> diff --git a/include/linux/swap.h b/include/linux/swap.h
> >>> index 62fc7499b408..bdb784966343 100644
> >>> --- a/include/linux/swap.h
> >>> +++ b/include/linux/swap.h
> >>> @@ -414,7 +414,9 @@ extern int sysctl_min_unmapped_ratio;
> >>>  extern int sysctl_min_slab_ratio;
> >>>  #endif
> >>>  
> >>> +struct mm_struct;
> >>>  void check_move_unevictable_folios(struct folio_batch *fbatch);
> >>> +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr);
> >>>  
> >>>  extern void __meminit kswapd_run(int nid);
> >>>  extern void __meminit kswapd_stop(int nid);
> >>> @@ -433,7 +435,6 @@ static inline unsigned long total_swapcache_pages(void)
> >>>  
> >>>  void free_swap_cache(struct folio *folio);
> >>>  void free_folio_and_swap_cache(struct folio *folio);
> >>> -void free_pages_and_swap_cache(struct encoded_page **, int);
> >>>  /* linux/mm/swapfile.c */
> >>>  extern atomic_long_t nr_swap_pages;
> >>>  extern long total_swap_pages;
> >>> @@ -510,8 +511,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
> >>>  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
> >>>  #define free_folio_and_swap_cache(folio) \
> >>>  	folio_put(folio)
> >>> -#define free_pages_and_swap_cache(pages, nr) \
> >>> -	release_pages((pages), (nr));
> >>>  
> >>>  static inline void free_swap_cache(struct folio *folio)
> >>>  {
> >>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> >>> index fe5b6a031717..3c6c315d3c48 100644
> >>> --- a/mm/mmu_gather.c
> >>> +++ b/mm/mmu_gather.c
> >>> @@ -100,7 +100,8 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
> >>>   */
> >>>  #define MAX_NR_FOLIOS_PER_FREE		512
> >>>  
> >>> -static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> >>> +static void __tlb_batch_free_encoded_pages(struct mm_struct *mm,
> >>> +		struct mmu_gather_batch *batch)
> >>>  {
> >>>  	struct encoded_page **pages = batch->encoded_pages;
> >>>  	unsigned int nr, nr_pages;
> >>> @@ -135,7 +136,7 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> >>>  			}
> >>>  		}
> >>>  
> >>> -		free_pages_and_swap_cache(pages, nr);
> >>> +		free_pages_and_caches(mm, pages, nr);
> >>>  		pages += nr;
> >>>  		batch->nr -= nr;
> >>>  
> >>> @@ -148,7 +149,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
> >>>  	struct mmu_gather_batch *batch;
> >>>  
> >>>  	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
> >>> -		__tlb_batch_free_encoded_pages(batch);
> >>> +		__tlb_batch_free_encoded_pages(tlb->mm, batch);
> >>>  	tlb->active = &tlb->local;
> >>>  }
> >>>  
> >>> diff --git a/mm/swap.c b/mm/swap.c
> >>> index bb19ccbece46..e44bc8cefceb 100644
> >>> --- a/mm/swap.c
> >>> +++ b/mm/swap.c
> >>> @@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
> >>>  }
> >>>  EXPORT_SYMBOL(release_pages);
> >>>  
> >>> +static inline void free_file_cache(struct folio *folio)
> >>> +{
> >>> +	if (folio_trylock(folio)) {
> >>> +		mapping_evict_folio(folio_mapping(folio), folio);
> >>> +		folio_unlock(folio);
> >>> +	}
> >>> +}
> >>> +
> >>> +/*
> >>> + * Passed an array of pages, drop them all from swapcache and then release
> >>> + * them.  They are removed from the LRU and freed if this is their last use.
> >>> + *
> >>> + * If @try_evict_file_folios is true, this function will proactively evict clean
> >>> + * file-backed folios if they are no longer mapped.
> >>
> >> There is no such parameter.
> >>
> >> But I do wonder if such a parameter would be better than passing in the MM here.
> > 
> > Makes sense.
> > 
> >>
> >> Also, is there a way to avoid moving the function?
> > 
> > I guess you are talking about "free_pages_and_swap_cache".
> > 
> > The problem is mm/swap_state.c is conditionally compiled only when CONFIG_SWAP
> > is enabled.
> > 
> > Since the expedited clean file cache eviction should be available
> > even on !CONFIG_SWAP, we need this function to be compiled unconditionally.
> > That is why I moved it to swap.c, which is always compiled.
> 
> Ah, right. Please spell that out in the patch description!

Acked.

