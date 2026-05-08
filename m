Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F3BCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF07F6B02A4; Fri,  8 May 2026 17:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7B76B02A5; Fri,  8 May 2026 17:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEB26B02A6; Fri,  8 May 2026 17:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABA406B02A4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:56:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42F14402EC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:56:39 +0000 (UTC)
X-FDA: 84745612518.10.0DB7A6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7659C0003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:56:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gjLk8Q+i;
	spf=pass (imf28.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778277397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woVbdnRPgZjpYSNJVHTslOII1T+wkbCupSxsBDwJgOw=;
	b=Przm8SEbQ3tob9v4wTIq8CIEB4lLNFAODmkS2ZJ6OPWsyu7R0ssavWW223ZcZ4sS4V+DKf
	noQvzSXXkIvIf889pql7zRHjYZbJCuh8cvzUInwu6F/5vB4O7bhe0Hqsyfp8VotRTAyTDg
	SLPesiLg2SSGix9SkLc/mP/laWVQWK4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gjLk8Q+i;
	spf=pass (imf28.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778277397; a=rsa-sha256;
	cv=none;
	b=3fFf7o/ZgmsE8No3nLAGS+Q9M6rdfbs3MpNkLnuctmfa1CDgn6OI7KHOUqkkYJ1Y1FRFYm
	foGkcV1NdMBFsUJdrH21zri7lA47kHoNkOCeDLadYidTKJiactsuNpTIGO/ymU9mwr6lxT
	AKW26AOxiqCG1pWfo3fGmb3B2rJuoMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DBBD60181;
	Fri,  8 May 2026 21:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1BDC2BCB0;
	Fri,  8 May 2026 21:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778277396;
	bh=E4/S7h7x9+VkHjz+trqpUCCjAbfa/5Fb4fkF5zP2WWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gjLk8Q+iHwQyjywvpCvrlThddaPjfA0/KW7CRqpZtRFNbAGzgwUw/Tn732VkbmWeF
	 JZgyUs6HKHSY6uy8MeTO51AZ+LiqFjo3qnmlggQLR1PqYvMSTjVEAGrpaJjf1VY6g3
	 VRAG2yKL93gQiRku2ORPFgMG/QupHaHQUeNB4xlxQ5kom9kRfpvyq30QyzQD5kxrHI
	 D+uFnS/Ys0/RglApXgB67b0ip6zGJoWuJVlpMxJTZ6U7NKjtZvb4s8kob30r7ip6zM
	 aJ7Xsq34gCpUimFZK1VY97zJUmyGJPKXgaXkXtXfsZPbdHHOjaVyJ0BmJa3S2L5F2X
	 5CGXGLyS1Oiqw==
Date: Fri, 8 May 2026 14:56:35 -0700
From: Minchan Kim <minchan@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <af5cEycgIu2GUicn@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <20260505145318.97692A14-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505145318.97692A14-agordeev@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7659C0003
X-Stat-Signature: b4edkcwwcz1pupsus1uym3nhyu98zdcz
X-HE-Tag: 1778277397-536595
X-HE-Meta: U2FsdGVkX19JeIuwWMbb5q1wNcEERahekSe886N6/2cTl9h2UMrpPHH52kJ5q8mTXFucqW+TgYKkSCSu33TQCsOBsJB68O6VvpqiwIVvbI9eJ6USLSkEZrXemWOyHLRaKqtsHHL5sucW3/av0QRmKF0akgSmVQ0FNuaQMf68scFiA4l0ryck8sKA6z/Krsm+zNhpIAFiYVdCkxtiNE4nLeG1KpqgjhFcjNWSRagUMr1cyCoJDXyByJjh94gSkUKmW7vB7wowUhhP3TEHsckWe8wzS8f6pgDIFAJnsEKjKF6eHNoJ6Z1Y2KV4RVM+ChghT62ff1tspHI8yfTNUR/5z/hz0WJmO4Ao4kQgyxqEAt2j9WYFJ1MPq00kAZ/s2SWAd6k9DjZ0t2QXNT2FlPdkvkHb3knt27XGLK8atRkzN03qmbVNPXgWr/9mecF+DJ+L+lDFa0BMytTgZasg9fUwdXptL8Qoa3MlB3+w7wOZqQFQY9DV2ILLLcnDn+anZNAWJ746ttqVzx4ANJmJiEWJXwpiP8WolH1a1WsbW3y6La4qDMnwI+BT23pYHP2HSfKO9uGZ4jxYQHFZ8kKcNkFH9RugmKaHG+4QEXPNKyETJONQgfYGzLpGc3czGq7FPD6s8cyitizHi6/LMwP41czyQlLn4Zpbf2WTpB/VNWhpi6yIxeHKOwZGng5S8zwTWJ2hZu8nzAkfbQ5HjoO9dm3v9YMu+6PjHWzFgfnq+odVtCq4gdJnQMKViPRiTGA7gJ6DGDq9OqjlbpCyJ0/sHx/LUYhm5XVKDFLjMFmljYliQHRvlzPFJvAoRKvPhVx4KV2H7X5i3Rq5GppbZaV970MVsQi80tHRxc2btp1eLY2tfWud3sI3krWmBQA+OITvUGw+3hOLStNWpyrQp33oe6evif/Uoa+PHRSGZXsO8YGPo3JgAsJ/WgTUB91abLl8w0LgogrZVaG9PYN1uf5mcE6
 Ek1Iigrv
 TgjqG4fsgi91Ys4plqQRT5tZGC34ZyDtNc+21OdIh8T+tgvaovtRsn3XrnUQTbGcadCHULnDK7HX3Oyhx+DXhkO6lFlP9Vz1Jga6A9UQTrmAq3vAYEYxIDIryZxvFg2PAr3IIaW5AEGRujL1SeyyXlaql4Ig5gYgsSaPt75pxAm/dtzzWacBB/LpFsGDx112qWR4ZXGUftyH/We+HkZj+B7/+ONcDbVwgmIpFjWlcXX2UeVzeeqrvrlAnzbdxHb0r9mBP4PnmgbGTJL+yuMJxObstk8NZmbQKbLanEpKUVqx7yFwD+v97K8QlxhBBxjrdtTdyIQ75vBYcwznTb/ojVmfS3fHjf9NRd1eC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

Sorry for late reply.

On Tue, May 05, 2026 at 04:53:18PM +0200, Alexander Gordeev wrote:
> On Tue, Apr 21, 2026 at 04:02:37PM -0700, Minchan Kim wrote:
> 
> Hi Minchan,
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
> > + */
> > +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr)
> > +{
> > +	bool try_evict_file_folios = mm_flags_test(MMF_UNSTABLE, mm);
> > +	struct folio_batch folios;
> > +	unsigned int refs[PAGEVEC_SIZE];
> > +
> > +	folio_batch_init(&folios);
> > +	for (int i = 0; i < nr; i++) {
> > +		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
> > +
> > +		if (folio_test_anon(folio))
> > +			free_swap_cache(folio);
> > +		else if (unlikely(try_evict_file_folios))
> > +			free_file_cache(folio);
> 
> This condition is absent in free_pages_and_swap_cache().
> What would happen with non-anon and non-evict folio?

Are you asking about mlocked pages for file?

During unmapping, munlock_vma_folio() inside __folio_remove_rmap() clears
the PG_mlocked flag and moves the folio back to the evictable LRU list.

By the time the folios reach free_pages_and_caches(), if the folio is
exclusive, it will be successfully evicted. However, if the folio is shared,
mapping_evict_folio() detects it via the refcount check and skips the
eviction.

However, I realized we miss shmem folios in the swap cache due to the new
folio_test_anon() check we introduced. I will update the check to something
like this:

if (folio_test_swapcache(folio))
    free_swap_cache(folio);
else if (unlikely(try_evict_file_folios))
    free_file_cache(folio);

Let me know if I missed something from your point.

Thank you.

