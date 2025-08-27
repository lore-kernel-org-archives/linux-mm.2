Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB59C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 03:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C496B02F0; Tue, 26 Aug 2025 23:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04196B02F2; Tue, 26 Aug 2025 23:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19BB6B02F4; Tue, 26 Aug 2025 23:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB0696B02F0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:50:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4274BC0453
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:50:52 +0000 (UTC)
X-FDA: 83821161144.27.7CBFD97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 33F91A0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:50:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZX1lKdvR;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756266650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfoCqWVeCD3Wz/nIA9spyb00FTZICHwedEpajKvdF6M=;
	b=iXvxKJTtFH9m/otOwnhl+RUs7VJ5WOvY3ljykTygcwghVT6ZlVPMFV9NjdGE3vwn0Gvvvv
	WTsNSF+BoDriHNgh8g9df7lV5BHN0keoM98MFy9WU2Ri/UTT+LMIvAMd3nFCPiwncqXgKV
	M8ts8dz6hPuqqsMVgTuA3dkTvcHS4G8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756266650; a=rsa-sha256;
	cv=none;
	b=cGZJU0lEn8ajUqa+R/P0O5IXmriL4Hoj2q9+XVobvd0ZfmVgEFQ7P6Eo9XLbpllPckaFlB
	jD0N6e4gpOKJ3G5u9PSUX2aF325Iy6W20TeG3LOlaH32ADlStonq8CP2ImlONI37T3o5AR
	eDxu3lzkY4eFyD4sHA/3H7LV/kEb04Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZX1lKdvR;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1039C44626
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5536C2BCAF
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756266648;
	bh=E3Z7J9idfsAWjv/swJTHoLXqmJzKGmN2Jg6yWdDlulY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZX1lKdvRaqWTgeMSfVbrch4LH9fxg8/Lr0SyDTWFWBiXQyE7Tu/bpDJEhWjKJyLzH
	 yXeObZN4va9snT6z8PN0VUcesOfLU1sXN61yFrhf8ALawvHCcIGqp7GNzJefnPpe60
	 q9oQwDxdtDo1/5WNp9VEBoB8a0aEb+ZO6EzKxwWF4735RuhyRwG2/xdUdo62b0gmEV
	 JIN123shy2XWEDws8auHdQHYIHYbzaOgd39LBZZLrbR21I33Q6JDz6MuMGPzLb6vyV
	 Zd/qDHx0zve1L+Tu5d0WK5a0nPjWUb6M9ebH5mipht9g+TvsZymW6gkaZroBdj+kpP
	 Zztj4P+ngrnug==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d5fb5e34cso5615067b3.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:50:48 -0700 (PDT)
X-Gm-Message-State: AOJu0YwOhvG44kVUQXbTl+bbW/ZcUsrpZkXMkZbXdJLwa2GKY3Hq2Tyo
	yUuNbaSiOUCJ0D4TvV8edPVmrLh+THkbk07r++B2j/jxSeGn2r8MnFrtiPIXHo2h7JNvtpM06X6
	8UI8QvoIyMQlY5Rka9fNUvGdZ40HgQLxuiI6KjybZ1g==
X-Google-Smtp-Source: AGHT+IGWxkcciI9nM9vjxFdi8pR7+C7jLTTjciW0pv10KK5SGYQhrq13zWxUjRVoYAfVCK/9B2kIc3PNtTlpqvpQLbA=
X-Received: by 2002:a05:690c:a048:b0:720:950:1559 with SMTP id
 00721157ae682-72132cd8466mr37371417b3.17.1756266647834; Tue, 26 Aug 2025
 20:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <CACePvbW_tkBAhj6-kQzyU2Jh-1dDy63Qc4K3RFyyA4=yt-_D5Q@mail.gmail.com>
In-Reply-To: <CACePvbW_tkBAhj6-kQzyU2Jh-1dDy63Qc4K3RFyyA4=yt-_D5Q@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 20:50:36 -0700
X-Gmail-Original-Message-ID: <CACePvbX0ng5Q+OpwNwB--dB=25oDb6tqcW+OJgWm=5LJeQVG2A@mail.gmail.com>
X-Gm-Features: Ac12FXy5_bcc7g562iUt1Bnbhi46w7DdDtsYyeZa_oUMtWkmfzc6bFU8h7Eza64
Message-ID: <CACePvbX0ng5Q+OpwNwB--dB=25oDb6tqcW+OJgWm=5LJeQVG2A@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33F91A0008
X-Stat-Signature: 5m6fn3j4gd9aq5sxiqcjmoiy4utsh5eo
X-Rspam-User: 
X-HE-Tag: 1756266650-158115
X-HE-Meta: U2FsdGVkX19a8c7XTuDZgFp41b6hof1X4gL3vG+1S7gI+y8XkzowLdrIJX4uAN5wWrLG4n+O3t/AsZe3uEL2smLRCCEWLXeJrlqhzy2mvmJXRZ3OZApBPWrQFQhG+IVgF/GdyhNzYchvWnZ111lHKN7FRrWkgt++RCoSGJHyVCLeR/Dpfk9L18kTSOBlItvFL1hIGdBCY615cHgl9A6hZ47muWeH57utZSTyj0Fn46CdFOoOAcrgW0GGmTvGDCOi8LDksvgNcWXovP9vk7kPLCyKF+/SXJ6/ymEzf1TajPjkyR8CEoOvFpGwDhMzNjh26NkklnlYNjhqAva9znLFUHeiXl+MYlv6okaxSlPB4nkeMyBUJdzGyQ6o8dGZ7Dq6LAMa/GnEP/ScmbmnbQEz3wRudDC1b3yFYnuROfIsUEopqYoY4bsXO7E0rQlui8v7FwZUa69NFphRsijID+aY9kOPo52cckbL8mB0tuxWLbUKPVjdyWb9iOV086hG7a7MzgfikpI+vUbMgimjHMuSf1aUu0R7z/CFiz61QncTCGC3gJM32Gc5if7J9Cv3YL/MMU+nbsE0VRBskfi1yWoQFJ7JdbR6ItGmHeoopMjoGoFrI4ANtVmgEC63KWHYlOIOlzWREtQL8SPGIv1ff2rcaix7Pw5ZfRk3mi7UNKOOquvJSLkMjXTNK6UjumBQUtXguFFsvrSBEKBFNwZwBMQfu9xehuQV+jh80QuYevxAm2jp+EQkxRC3YNUZWRMQz3yV65AmkWpcjES1/7mvvMKQbtPOETMmSlwRxNha5dbemsKbYK1lbEUZgAbHx0sFJN6kjM9rlQT/SRnpcHemDRBFhCO6PXGyc+fpGmso2aoTNfA00J1TJsP/jYK6W5KZUyBMsNKWomCFkzUVWN2FVY505q+LE1mhiPNHf7houFgvG7rXcOicRSIajhVdgm0ukZATuMfsGntkE5kAaSqWTN6
 GK0MPrgx
 1FszYfGVZ53YWJMdrMVTlE3TCC7QSlav251HCuLioCVIcgxRwukUMrTcsgfxDw0xMCzhLMbEAG9JB3SROEcJebvdXzxi7qdXw367qw5nSYyCmpSs42bVLCZoYhrx8ah4wBBrIse9Oqb+3XP0C4S6E2i5izEnDNjTwEwZv+JvblvhYgG7c0lu5bOmYZqR+bhKokZmC2FDnAdR/EhKrtFIwOEa/ZM65grSnzdiGq0l+HvVRyEkUhFr5iHMgSaejbvm8jR81YdMjKiHulARK5Nm4Czmi120qGvRhQ44kcnGNwE7GgpUD0gvuTK4b9k/dgFUBaGABs6C8FUl9T7TzAdOzLqqk4ejLHehdL8z3+YZJbFUy/9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BTW, I think this patch can add no functional change as expected.

Chris

On Tue, Aug 26, 2025 at 7:47=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Kairui,
>
> This commit message can use some improvement, I feel the part I am
> interested in, what changed is buried in a lot of detail.
>
> The background is that swap_cache_get_folio() used to do readahead
> update as well. It has VMA as part of the argument. However, the
> hibernation usage does not map swap entry to VMA. It was forced to
> call filemap_get_entry() on swap cache instead, due to no VMA.
>
> So the TL; DR; of what this patch does:
>
> Split the swap readahead outside of swap_cache_get_folio(), so that
> the hibernation non VMA usage can reuse swap_cache_get_folio()  as
> well. No more  calling filemap_get_entry() on swap cache due to lack
> of VMA.
>
> The code itself looks fine. It has gone through some rounds of
> feedback from me already. We can always update the commit message on
> the next iteration.
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
> Chris
>
>
> On Fri, Aug 22, 2025 at 12:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Always use swap_cache_get_folio for swap cache folio look up. The reaso=
n
> > we are not using it in all places is that it also updates the readahead
> > info, and some callsites want to avoid that.
> >
> > So decouple readahead update with swap cache lookup into a standalone
> > helper, let the caller call the readahead update helper if that's
> > needed. And convert all swap cache lookups to use swap_cache_get_folio.
> >
> > After this commit, there are only three special cases for accessing swa=
p
> > cache space now: huge memory splitting, migration and shmem replacing,
> > because they need to lock the Xarray. Following commits will wrap their
> I commonly saw using xarray or XArray.
> > accesses to the swap cache too with special helpers.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c      |  6 ++-
> >  mm/mincore.c     |  3 +-
> >  mm/shmem.c       |  4 +-
> >  mm/swap.h        | 13 +++++--
> >  mm/swap_state.c  | 99 +++++++++++++++++++++++-------------------------
> >  mm/swapfile.c    | 11 +++---
> >  mm/userfaultfd.c |  5 +--
> >  7 files changed, 72 insertions(+), 69 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d9de6c056179..10ef528a5f44 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         if (unlikely(!si))
> >                 goto out;
> >
> > -       folio =3D swap_cache_get_folio(entry, vma, vmf->address);
> > -       if (folio)
> > +       folio =3D swap_cache_get_folio(entry);
> > +       if (folio) {
> > +               swap_update_readahead(folio, vma, vmf->address);
> >                 page =3D folio_file_page(folio, swp_offset(entry));
> > +       }
> >         swapcache =3D folio;
> >
> >         if (!folio) {
> > diff --git a/mm/mincore.c b/mm/mincore.c
> > index 2f3e1816a30d..8ec4719370e1 100644
> > --- a/mm/mincore.c
> > +++ b/mm/mincore.c
> > @@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, =
bool shmem)
> >                 if (!si)
> >                         return 0;
> >         }
> > -       folio =3D filemap_get_entry(swap_address_space(entry),
> > -                                 swap_cache_index(entry));
> > +       folio =3D swap_cache_get_folio(entry);
> >         if (shmem)
> >                 put_swap_device(si);
> >         /* The swap cache space contains either folio, shadow or NULL *=
/
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 13cc51df3893..e9d0d2784cd5 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >         }
> >
> >         /* Look it up and read it in.. */
> > -       folio =3D swap_cache_get_folio(swap, NULL, 0);
> > +       folio =3D swap_cache_get_folio(swap);
> >         if (!folio) {
> >                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> >                         /* Direct swapin skipping swap cache & readahea=
d */
> > @@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                         count_vm_event(PGMAJFAULT);
> >                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
> >                 }
> > +       } else {
> > +               swap_update_readahead(folio, NULL, 0);
> >         }
> >
> >         if (order > folio_order(folio)) {
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 1ae44d4193b1..efb6d7ff9f30 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
> >  void clear_shadow_from_swap_cache(int type, unsigned long begin,
> >                                   unsigned long end);
> >  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, i=
nt nr);
> > -struct folio *swap_cache_get_folio(swp_entry_t entry,
> > -               struct vm_area_struct *vma, unsigned long addr);
> > +struct folio *swap_cache_get_folio(swp_entry_t entry);
> >  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> >                 struct vm_area_struct *vma, unsigned long addr,
> >                 struct swap_iocb **plug);
> > @@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t flag,
> >                 struct mempolicy *mpol, pgoff_t ilx);
> >  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> >                 struct vm_fault *vmf);
> > +void swap_update_readahead(struct folio *folio, struct vm_area_struct =
*vma,
> > +                          unsigned long addr);
> >
> >  static inline unsigned int folio_swap_flags(struct folio *folio)
> >  {
> > @@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_e=
ntry_t swp, gfp_t gfp_mask,
> >         return NULL;
> >  }
> >
> > +static inline void swap_update_readahead(struct folio *folio,
> > +               struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +}
> > +
> >  static inline int swap_writeout(struct folio *folio,
> >                 struct swap_iocb **swap_plug)
> >  {
> > @@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info=
_struct *si, swp_entry_t entr
> >  {
> >  }
> >
> > -static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
> > -               struct vm_area_struct *vma, unsigned long addr)
> > +static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
> >  {
> >         return NULL;
> >  }
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 99513b74b5d8..ff9eb761a103 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
> >         printk("Total swap =3D %lukB\n", K(total_swap_pages));
> >  }
> >
> > +/*
> > + * Lookup a swap entry in the swap cache. A found folio will be return=
ed
> > + * unlocked and with its refcount incremented.
> > + *
> > + * Caller must lock the swap device or hold a reference to keep it val=
id.
> > + */
> > +struct folio *swap_cache_get_folio(swp_entry_t entry)
> > +{
> > +       struct folio *folio =3D filemap_get_folio(swap_address_space(en=
try),
> > +                                               swap_cache_index(entry)=
);
> > +       if (!IS_ERR(folio))
> > +               return folio;
> > +       return NULL;
> > +}
> > +
> >  void *get_shadow_from_swap_cache(swp_entry_t entry)
> >  {
> >         struct address_space *address_space =3D swap_address_space(entr=
y);
> > @@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
> >  }
> >
> >  /*
> > - * Lookup a swap entry in the swap cache. A found folio will be return=
ed
> > - * unlocked and with its refcount incremented - we rely on the kernel
> > - * lock getting page table operations atomic even if we drop the folio
> > - * lock before returning.
> > - *
> > - * Caller must lock the swap device or hold a reference to keep it val=
id.
> > + * Update the readahead statistics of a vma or globally.
> >   */
> > -struct folio *swap_cache_get_folio(swp_entry_t entry,
> > -               struct vm_area_struct *vma, unsigned long addr)
> > +void swap_update_readahead(struct folio *folio,
> > +                          struct vm_area_struct *vma,
> > +                          unsigned long addr)
> >  {
> > -       struct folio *folio;
> > -
> > -       folio =3D filemap_get_folio(swap_address_space(entry), swap_cac=
he_index(entry));
> > -       if (!IS_ERR(folio)) {
> > -               bool vma_ra =3D swap_use_vma_readahead();
> > -               bool readahead;
> > +       bool readahead, vma_ra =3D swap_use_vma_readahead();
> >
> > -               /*
> > -                * At the moment, we don't support PG_readahead for ano=
n THP
> > -                * so let's bail out rather than confusing the readahea=
d stat.
> > -                */
> > -               if (unlikely(folio_test_large(folio)))
> > -                       return folio;
> > -
> > -               readahead =3D folio_test_clear_readahead(folio);
> > -               if (vma && vma_ra) {
> > -                       unsigned long ra_val;
> > -                       int win, hits;
> > -
> > -                       ra_val =3D GET_SWAP_RA_VAL(vma);
> > -                       win =3D SWAP_RA_WIN(ra_val);
> > -                       hits =3D SWAP_RA_HITS(ra_val);
> > -                       if (readahead)
> > -                               hits =3D min_t(int, hits + 1, SWAP_RA_H=
ITS_MAX);
> > -                       atomic_long_set(&vma->swap_readahead_info,
> > -                                       SWAP_RA_VAL(addr, win, hits));
> > -               }
> > -
> > -               if (readahead) {
> > -                       count_vm_event(SWAP_RA_HIT);
> > -                       if (!vma || !vma_ra)
> > -                               atomic_inc(&swapin_readahead_hits);
> > -               }
> > -       } else {
> > -               folio =3D NULL;
> > +       /*
> > +        * At the moment, we don't support PG_readahead for anon THP
> > +        * so let's bail out rather than confusing the readahead stat.
> > +        */
> > +       if (unlikely(folio_test_large(folio)))
> > +               return;
> > +
> > +       readahead =3D folio_test_clear_readahead(folio);
> > +       if (vma && vma_ra) {
> > +               unsigned long ra_val;
> > +               int win, hits;
> > +
> > +               ra_val =3D GET_SWAP_RA_VAL(vma);
> > +               win =3D SWAP_RA_WIN(ra_val);
> > +               hits =3D SWAP_RA_HITS(ra_val);
> > +               if (readahead)
> > +                       hits =3D min_t(int, hits + 1, SWAP_RA_HITS_MAX)=
;
> > +               atomic_long_set(&vma->swap_readahead_info,
> > +                               SWAP_RA_VAL(addr, win, hits));
> >         }
> >
> > -       return folio;
> > +       if (readahead) {
> > +               count_vm_event(SWAP_RA_HIT);
> > +               if (!vma || !vma_ra)
> > +                       atomic_inc(&swapin_readahead_hits);
> > +       }
> >  }
> >
> >  struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mas=
k,
> > @@ -336,14 +337,10 @@ struct folio *__read_swap_cache_async(swp_entry_t=
 entry, gfp_t gfp_mask,
> >         *new_page_allocated =3D false;
> >         for (;;) {
> >                 int err;
> > -               /*
> > -                * First check the swap cache.  Since this is normally
> > -                * called after swap_cache_get_folio() failed, re-calli=
ng
> > -                * that would confuse statistics.
> > -                */
> > -               folio =3D filemap_get_folio(swap_address_space(entry),
> > -                                         swap_cache_index(entry));
> > -               if (!IS_ERR(folio))
> > +
> > +               /* Check the swap cache in case the folio is already th=
ere */
> > +               folio =3D swap_cache_get_folio(entry);
> > +               if (folio)
> >                         goto got_folio;
> >
> >                 /*
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index a7ffabbe65ef..4b8ab2cb49ca 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -213,15 +213,14 @@ static int __try_to_reclaim_swap(struct swap_info=
_struct *si,
> >                                  unsigned long offset, unsigned long fl=
ags)
> >  {
> >         swp_entry_t entry =3D swp_entry(si->type, offset);
> > -       struct address_space *address_space =3D swap_address_space(entr=
y);
> >         struct swap_cluster_info *ci;
> >         struct folio *folio;
> >         int ret, nr_pages;
> >         bool need_reclaim;
> >
> >  again:
> > -       folio =3D filemap_get_folio(address_space, swap_cache_index(ent=
ry));
> > -       if (IS_ERR(folio))
> > +       folio =3D swap_cache_get_folio(entry);
> > +       if (!folio)
> >                 return 0;
> >
> >         nr_pages =3D folio_nr_pages(folio);
> > @@ -2131,7 +2130,7 @@ static int unuse_pte_range(struct vm_area_struct =
*vma, pmd_t *pmd,
> >                 pte_unmap(pte);
> >                 pte =3D NULL;
> >
> > -               folio =3D swap_cache_get_folio(entry, vma, addr);
> > +               folio =3D swap_cache_get_folio(entry);
> >                 if (!folio) {
> >                         struct vm_fault vmf =3D {
> >                                 .vma =3D vma,
> > @@ -2357,8 +2356,8 @@ static int try_to_unuse(unsigned int type)
> >                (i =3D find_next_to_unuse(si, i)) !=3D 0) {
> >
> >                 entry =3D swp_entry(type, i);
> > -               folio =3D filemap_get_folio(swap_address_space(entry), =
swap_cache_index(entry));
> > -               if (IS_ERR(folio))
> > +               folio =3D swap_cache_get_folio(entry);
> > +               if (!folio)
> >                         continue;
> >
> >                 /*
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 50aaa8dcd24c..af61b95c89e4 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1489,9 +1489,8 @@ static long move_pages_ptes(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd
> >                  * separately to allow proper handling.
> >                  */
> >                 if (!src_folio)
> > -                       folio =3D filemap_get_folio(swap_address_space(=
entry),
> > -                                       swap_cache_index(entry));
> > -               if (!IS_ERR_OR_NULL(folio)) {
> > +                       folio =3D swap_cache_get_folio(entry);
> > +               if (folio) {
> >                         if (folio_test_large(folio)) {
> >                                 ret =3D -EBUSY;
> >                                 folio_put(folio);
> > --
> > 2.51.0
> >

