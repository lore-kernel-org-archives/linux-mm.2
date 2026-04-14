Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A8AF9D0F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AC56B0088; Tue, 14 Apr 2026 16:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BB86B0089; Tue, 14 Apr 2026 16:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83636B0092; Tue, 14 Apr 2026 16:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA1DC6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:21:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CB89160254
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:21:09 +0000 (UTC)
X-FDA: 84658280658.10.E8AE91C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8DEA68000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:21:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udZ3hLJU;
	spf=pass (imf02.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776198067; a=rsa-sha256;
	cv=none;
	b=uclBsLBw53HgA4QXkqlCKyaeNKw1j61Wl8ikjesOPXBmNgWmbS9rY3sKMGUC2Z88DaxLmM
	6t6ogsYcvdnCQC2TdDc58Qj3+dYK/gMvLifZvloLgSrflSJdYPUnMBUeISVBkN7tqGt85t
	iriizfPDF+xgGeQ9+0mSGPCguO3a4Yc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776198067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQwDjtvBrC+Y+6sGwuAKejL0ZCqTaU4/Kz9cBhkLKFM=;
	b=YE7dvsuEl75eVjyYvalXmpH1LCrRdXy6b9MDP8WwsCIbBQfeMov912yO/gv7n4Nw9GfV2h
	m6mkFfkfdPKkCP9/PETDSeuF8XkqViny+NGLsI9G8j/H7p89aXFyRLJS4Vpt0XHSyqujBb
	u3QpAuWYbxE9NOGILKrIvtNfe5CzFt4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udZ3hLJU;
	spf=pass (imf02.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECE9C41B28;
	Tue, 14 Apr 2026 20:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A472C19425;
	Tue, 14 Apr 2026 20:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776198065;
	bh=g13EA5K/HxcGjvT7jbTNvEhcFAop8Twl9vthntu/Dwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=udZ3hLJUlncMxx/jaWfMd7QcZPT2gLMafqbEk6mhHfamWaP3+GZ9FHwAMEuhZRkdp
	 rw+bpxzpbYCh3lXCaEFYgiFSPBWkYhsyLAxsavA7sCCH5G4CC5Knt5zwjQI4rfy1iR
	 cxbH4H+TWazb127m0AkfJfSdoTBwZDYu97HnoYQKa/iyYzRGuv9PK+hR4XzC7IxD0l
	 3pp6MqXs+MVnjkVcKCeeC6M2rUVuFOEXfpWZMuE+oJuyAQRhAlY0MpZwvAzB8Km+5v
	 hO5fi5wV0eHW/GEsBm7zV3PIHZ7dPKBkxxZ9aWhRC0FxwVWDCvKIYMVQ++jFcC9FN+
	 xSZj3Ied8T4KA==
Date: Tue, 14 Apr 2026 13:21:04 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, mhocko@suse.com, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <ad6hsAPPCVlc2fsg@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-2-minchan@kernel.org>
 <48cd6ee2-d650-4731-a40b-832a17b07237@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48cd6ee2-d650-4731-a40b-832a17b07237@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8DEA68000B
X-Stat-Signature: 83ndtd6i9gw5k6gj9uwxzx8d7epqpf4f
X-HE-Tag: 1776198067-204882
X-HE-Meta: U2FsdGVkX1/zlzTDALIk/YbeD7Bd8EXpEKJ969KtpHTRiadp/SdgVLZ25Iu28vXYBdWrAMhTlLxM2c1GL77p0FVEq6i5f5cfkcnEEjJzrf7z2tMADlL4k695jRlthZ/ZQJd93as2/J9n6fUtrneRfXrt8ZKu/BHRrVEefAka0rPjS08fFkdD2mkFgzjwkFh5E16p9PcO6tJU7fd0o/HVohLQbOsh1f/k0CjECJThYp7ww3xwLMo51WRZPIderyPy4SGIMOH0fnIO+C2vTGuEUtwB6/wT1rylNVR3G5ecoKXlfwQwD2XGEoZ4ULYYQf56A8MCXkd7nsU7M2HkhxK2je/r2MXpKx9GwFjRsIzdP7Uo62N0Ye6WoGE9sLocRqNIUO2VrClrA5C5eTMXZ3kDS8Fbm8vSu/oJymm6DcMGPD6b/yFFhKxniM88UE7S7STe0Pgoe8rs7aUCVoDc/pjI9IOJ8ISjuL7XghuOyyBVuAXrrAXfJ+e8y30OyKo0SVlTR26iAUSnp1GxfJtpyoRIZjO2B9Wy/QALn7WRroDr1r2mgZwxJ6ye1C+CVufI/degdoDqJxIZQV9f+XnXNGgm68OYZ4mbIHbezXJDW945y3evH+kodMjQgtC8ogUFMfWfWO4qCRy+cnYujbt+56Gaz+eqBCf4/kcdqKCdajpRh/ciyHaIbcJQaUg50tIMdQSavw82xbmngEAqneSruw3oHu3RYxGTAbZ8mH46ke82LjxHWER6pFls6TNjIMqt93fY5tX4nhRFBvmUGKB+hpc1gVAN6A4HflvE7194OJNmR6uhs5rkOo5PiKNK6yK/dqnFxufNbcU3n1mWuLAeYRcgocGQjQVAtznok2vb+vWf8FDhiApRU1W2mkxur3V2tKEFcWSOncegz4mdVg5rHMTccSU5TeMrwBQ5fP+NuwRwnhEy/yPCQbOjY8jZrI0vr2Usm9CR9a2Wlr11Rzqjsar
 W3Dex+DK
 gd2WQxHJxKncIZP1NMcOpFX2SbCxFOLEQWAwM5kZX6CQOGAfIDYWRAkvlU3bni6egIWAcvHU2P4O+0O0t/oMdBg1blDS5dTgFthyxt1h8v9eDD6u0PYEPTYUc6zoz/2JVa9CeDpsH9Na/0Td04GuSczIR4wMTI2pvJsH6EBRcD8WsylzkUEGzyuhW/NdlsiIFp1hf1f2qMicA4vX6/WQemZJjboja8soeNKsI4E7NC2kGUwgAXSYIzKDhJ+WgN/dOhi+H25MH23A/vMPS4knMiE7waQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 09:45:42AM +0200, David Hildenbrand (Arm) wrote:
> On 4/14/26 00:39, Minchan Kim wrote:
> > Currently, process_mrelease() unmaps the pages but leaves clean file
> > folios on the LRU list, relying on standard memory reclaim to eventually
> > free them. This delays the immediate recovery of system memory under OOM
> > or container shutdown scenarios.
> 
> process_mrelease() calls __oom_reap_task_mm().
> 
> There, we skip any MAP_SHARED file mappings.
> 
> So I assume what you describe only applies to MAP_PRIVATE file mappings?
> What about MAP_SHARED?

That's true. My primary target was MAP_PRIVATE because MAP_SHARED pages
are often not exclusive to the target process.

> 
> Also "leaves ... on the LRU list" is rather confusing. They are not
> evicted and stay in the pagecache?

Yes, they are not evicted and remain in the pagecache, which is the
problem this patch addresses.

> 
> > 
> > This patch implements an expedited eviction mechanism for clean file
> > folios by integrating directly into the low-level TLB batching
> > infrastructure (mmu_gather).
> 
> Is this a complicated way of saying "Handle clean pagecache folios
> similar to swapcache folios in mmu_gather code, dropping them from the
> swapcache (i.e., evicting them) if they are completely unmapped during
> reaping"?

Much better description. Thanks.

> 
> > 
> > Instead of repeatedly locking and evicting folios one by one inside the
> > unmap loop (zap_present_folio_ptes), we pass the MMF_UNSTABLE flag
> > status down to free_pages_and_swap_cache(). Within this single unified
> > loop, anonymous pages are released via free_swap_cache(), and
> > file-backed folios are symmetrically truncated via mapping_evict_folio().
> 
> ... where you still evict them one-by-one. Rather confusing.

I initially considered implementing this within zap_present_folio_ptes,
but concluded that mmu_gather is the appropriate place.  To avoid
confusion, I will remove the "Instead of...unmap_loop" line in the next
revision.

> 
> > 
> > This avoids introducing unnecessary data structures, preserves TLB flush
> > safety, and removes duplicate tree traversals, resulting in an extremely
> > lean and highly responsive process_mrelease() implementation.
> 
> I don't think this paragraph adds a lot of value, really.
> 
> Which "duplicate tree traversal"? Which unnecessary data structures?

I had considered gathering these folios into a separate data structure
for cleanup, but realized mmu_gather is the best place to avoid
duplicate traversals for both anon and file folios.

> 
> Is that AI generated text? A lot of the stuff here reads AI generated. I
> yet have to meet a developer (not a sales person) that would just say
> "extremely lean and highly responsive process_mrelease() implementation"

That's too business words, I agree. Let me removing them.

> 
> If it is AI generated, throw it away and write it yourself from scratch.
> Use AI only to polish your English.
> 
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  arch/s390/include/asm/tlb.h |  2 +-
> >  include/linux/swap.h        |  9 ++++++---
> >  mm/mmu_gather.c             |  8 +++++---
> >  mm/swap_state.c             | 19 +++++++++++++++++--
> >  4 files changed, 29 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> > index 619fd41e710e..554842345ccd 100644
> > --- a/arch/s390/include/asm/tlb.h
> > +++ b/arch/s390/include/asm/tlb.h
> > @@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
> >  	VM_WARN_ON_ONCE(delay_rmap);
> >  	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
> >  
> > -	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
> > +	free_pages_and_caches(encoded_pages, ARRAY_SIZE(encoded_pages), false);
> 
> As we dislike boolean parameters, we either try to avoid them (e.g., use
> flags) or document the parameters using something like

I like your suggestion "try_evict_file_folios"

> 
> "/* parameter_name= */false"
> 
> >  	return false;
> >  }
> >  
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 62fc7499b408..e7b929b062f8 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -433,7 +433,7 @@ static inline unsigned long total_swapcache_pages(void)
> >  
> >  void free_swap_cache(struct folio *folio);
> >  void free_folio_and_swap_cache(struct folio *folio);
> > -void free_pages_and_swap_cache(struct encoded_page **, int);
> > +void free_pages_and_caches(struct encoded_page **pages, int nr, bool free_unmapped_file);
> >  /* linux/mm/swapfile.c */
> >  extern atomic_long_t nr_swap_pages;
> >  extern long total_swap_pages;
> > @@ -510,8 +510,11 @@ static inline void put_swap_device(struct swap_info_struct *si)
> >  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
> >  #define free_folio_and_swap_cache(folio) \
> >  	folio_put(folio)
> > -#define free_pages_and_swap_cache(pages, nr) \
> > -	release_pages((pages), (nr));
> > +static inline void free_pages_and_caches(struct encoded_page **pages,
> > +		int nr, bool free_unmapped_file)
> > +{
> > +	release_pages(pages, nr);
> > +}
> 
> Why should !CONFIG_SWAP not take care of free_unmapped_file?

There is no reason to exclude it bust just missed this one.
I will make sure to address this in the next respin.

> 
> 
> >  
> >  static inline void free_swap_cache(struct folio *folio)
> >  {
> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index fe5b6a031717..5ce5824db07f 100644
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
> > @@ -135,7 +136,8 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> >  			}
> >  		}
> >  
> > -		free_pages_and_swap_cache(pages, nr);
> > +		free_pages_and_caches(pages, nr,
> > +				      mm_flags_test(MMF_UNSTABLE, mm));
> >  		pages += nr;
> >  		batch->nr -= nr;
> >  
> > @@ -148,7 +150,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
> >  	struct mmu_gather_batch *batch;
> >  
> >  	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
> > -		__tlb_batch_free_encoded_pages(batch);
> > +		__tlb_batch_free_encoded_pages(tlb->mm, batch);
> >  	tlb->active = &tlb->local;
> >  }
> >  
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 6d0eef7470be..e70a52ead6d3 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -400,11 +400,22 @@ void free_folio_and_swap_cache(struct folio *folio)
> >  		folio_put(folio);
> >  }
> >  
> > +static inline void free_file_cache(struct folio *folio)
> > +{
> > +	if (folio_trylock(folio)) {
> > +		mapping_evict_folio(folio_mapping(folio), folio);
> > +		folio_unlock(folio);
> > +	}
> > +}
> > +
> >  /*
> >   * Passed an array of pages, drop them all from swapcache and then release
> >   * them.  They are removed from the LRU and freed if this is their last use.
> > + *
> > + * If @free_unmapped_file is true, this function will proactively evict clean
> > + * file-backed folios if they are no longer mapped.
> 
> The parameter name is not really expressive.
> 
> You are not freeing unmapped files.
> 
> "try_evict_file_folios" maybe?

+1

Thanks.

