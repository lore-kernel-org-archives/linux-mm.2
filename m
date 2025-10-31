Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6249CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 07:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081378E00C3; Fri, 31 Oct 2025 03:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052628E00A9; Fri, 31 Oct 2025 03:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9888E00C3; Fri, 31 Oct 2025 03:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6D8D8E00A9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:02:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A3F2497A0
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:02:45 +0000 (UTC)
X-FDA: 84057516690.24.89C4256
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9819A8000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:02:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C8roaXyX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761894163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhAeKXrpaYinKlRLqV0x2Ic6a8e7XLvoSE3cJgvPELQ=;
	b=x3mCWIyPyC7Cj8fTrPHj1C02e13MNijgTird1YRptkN0oy1um4Jg0EmXYCUsB9FYVKutnG
	Xf+x6ggWgnXi4UJhQ3pSrXJF8h1srFJKuQjjHCa0R3KM4vBuOalDhnQjGmCD76KScDubhe
	YDqtdi9wU72sO6aIkoJ8BydZObhbMQk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C8roaXyX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761894163; a=rsa-sha256;
	cv=none;
	b=muRDeE1wpJtRk/6EqCRF8u1JI3l5vkbXf01XeUpvW9C9QcT9dhx5DfSwTdqrc1Hs53DtNk
	nR9q6Uw7jpUA6KNuf49V9ctGkNtQjS5CoxbaWlUxuocCQ2927kQyJjTd0GqvijlpSmi+Go
	D0qTH8x7aR5eSjKUu3IylmWKpHA8bgU=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b5b823b4f3dso331759966b.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761894162; x=1762498962; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WhAeKXrpaYinKlRLqV0x2Ic6a8e7XLvoSE3cJgvPELQ=;
        b=C8roaXyX3dT+MfomkA1P1Dd7M8ciXcZdBaJxrNKggGFQvW+lPh3QUuCrOV9gN5NXpy
         /XL/BXSGIwQcFi/o9WBHkFVLfzWbSTSU/Lk3sMMDQDHibsrLpSSz+MM9QUHnXIcgRuNG
         ZGe2jRVJceKSNdeZFug04II/VGCc/uNDJcxmybTruPSyJdTj+uzf4+Dae6bgyHnaiWjP
         GZdmj2LS6BFejkLW0y6lbQplapra+cMc4m8N8aIz4bi4VqGP15nQrwz7VMqq1ZFfMVEo
         sDujO58ESIv99kKT0M03u3VB7h4Z5DxKSxkl0AlB8l5mRXpV8AJIyD8hFQOFGBPssC0l
         UMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761894162; x=1762498962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WhAeKXrpaYinKlRLqV0x2Ic6a8e7XLvoSE3cJgvPELQ=;
        b=ZCzUHARsmiEIozPkCVn8+VQBOhN823/JogTkX6dwJRKiYQWgvLaJ2uIvJ9Nd/Sl7Qk
         ImiwgESMWLPHACgyb8E1I4W8zOFeeswbfUkRwcm5w0AHxThoAIojXiFGQIjija2VoMTH
         UFcQLbgQwuazXg+EyUbMIyPJiUFLgPIqlTZoMGzYbQJmSWUXou7Y1BdIEkTzkgm/q1in
         6AVVF+vmnKz6Xn6lTEEE0RHNQLIUQWNwZZD4iIZcAc+XyXFYl57Xq3QvwMrHO4Ji4aTT
         d6TEQ5sFO0t4vNs3Bl75ThG+PIKHod+mOk6OE1VJ4knkKNXGoeZPt1vROCqlTWOhKaOj
         x+3Q==
X-Gm-Message-State: AOJu0Yy3lsFwYnrsLpFX4krF67LKSBA4F7IO1WbFGW07Z7HPiBU0FyI6
	qf9u10t6bZGYblwp9LzPsRV0V8wSKHy4W2ce/cNEGq5xYa5yzlqHbzyVUFwfuiySl4HY9tHcuMm
	XRm/1YYh2IAMEnqj+geBwMDU+EaT8Ax8=
X-Gm-Gg: ASbGnctosG+hjfmytxMIVvJGTR5AX0DDlYcV0zwmJavZYtn+eSjUqBbRGenCCMOJ2w0
	EyitAdi00BNa4uctD3ycL/Lk3OhgGcmivfUW01nJ/tmlMcb9D4uiMHDZOqKqlAODQnbmvTnr4/1
	mSyLePOMVoiKMl+jrFWonxIEa5ZysLJimxATI8G5+0BI7C003LndgG0s5JG8wa2OGcHHGJTdJk3
	jC4Qg8qJVnE8r8CyKdetyrkFjNDUBgGy7XhLCJhTsVKrrVtizpzOufL+6WV
X-Google-Smtp-Source: AGHT+IFZjqoXBFAlCskVhv74Qiczd37Jbq68RIzzKDrsnIw2gYEJV4GzWhwphPsEr9Q6jQ41UmUSm4dBiWwOuSzsAr4=
X-Received: by 2002:a17:907:60cd:b0:b3f:1028:a86a with SMTP id
 a640c23a62f3a-b70700d39cbmr242298666b.3.1761894161735; Fri, 31 Oct 2025
 00:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-15-3d43f3b6ec32@tencent.com> <aQRPfIqCcMLyf6oX@yjaykim-PowerEdge-T330>
In-Reply-To: <aQRPfIqCcMLyf6oX@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 31 Oct 2025 15:02:04 +0800
X-Gm-Features: AWmQ_bnqHJRBw5VgM4IaGt3qE5NKaN--3DSsoGj--BQ80I3X1ms69ibY_wiId_Y
Message-ID: <CAMgjq7A405kAAY80xzLxFHuKOcGt7iSYeYYv9G0iZaMHcwrWyA@mail.gmail.com>
Subject: Re: [PATCH 15/19] mm, swap: add folio to swap cache directly on allocation
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9819A8000C
X-Rspamd-Server: rspam03
X-Stat-Signature: mrag6rxffgnfwzfw5pgsm9kxi5d338yq
X-HE-Tag: 1761894163-359461
X-HE-Meta: U2FsdGVkX19eL+gyHj17aHYq8ceNTp/bpmNaFBMVQJ29gZ/m6QNCrARs/QrztcwSfWEtd65ETssR/TPG09/q3UTYpX96kvBzT0hTf6ZMd6jBEnamNX0cfYks4B6rXPgorDjEsYvXAX53sVDxPQcEXCp0UtssE4d6FGZoV/Zh/qK2YwQ2XMkh3jPFFk9MXhnG182zfG6nqU6YfujlfThcinFtd4eUXrerrqydX/sVjx7Y7eVNO+BMkAXg7y1FiDQIvewMzW7UdwhDw27CWnCMvsePWvDsfeeAxQrI/YI31fhB2Uzwmp8PtRjLEllMvF+62x6SsaYMdiFJVAvIpHYqF1id5fgAX0XKs10/jpfLyon5jcg3hRFhnzVBMb4/yvxT4znB272Z4rF4UgOTDE32B2QYEKyu8XbJExWDvwpEDCIUt1Vwv/YOZjjaaCfjYHIUtyYdKv6Xtv2Wj9cOFZblP3uWgcZie//VeDdt6u9hvdcHC1zKOrfdTEq+Q8MuFLnV4uUWeTV07Rbi5Tn6lrfvLJ6wJ7cKgKsulVgcXOWLD98Yw7t6HkppExc9fwcPzkW9axxW+TjLXDyeXIMQ0qzuXFwQ2xO3+ZX7YGyU5szVrEuIwa7u6X9nAbF9fgVoV1wOe8JCbXNergV7+9YugTuI5hjKUTxilQNmDz2OsZ/YokE/EJx7wmcLv8DBFAHFsUHQ8uSB3t/ZIppDu2Bsg+AtsrPG3JKQpPb1aaUzoZw7tiBwA9E4uDRqHRiWYs2B5LCtmAairOol0zusByf86aqd1tNdp6hp4TNu8+u4WXE4ipvUP5ZOLG5vMFGCzLTLFOBvKJbP9OOO0F5PZ2zllWJ3yoQGu+UKu3OkFQMoWKHfcli9xGrXBX5K2dgsLnt5GSGWZXqOq9rf3g3cSJq7B2ovgdg72LZZp0vQLbHvLsX3MsdX4YK9ilpkqt0JKqGa/TyG3HzWIQoB0uwdy5SLuMx
 vZ8cZkaj
 qbUn/VvlxdtiVZg08NKTimwcsPzhvhyeEhs07TdU8nReqgde/6VI/HObzUDb19LbsjEz0r0HCMW0ZcPyUlvtofY4/fKk6mel0JV+J4VplNfWWgpZFpAL3j89NXl4OrvcyaumV1yyD4LzzlMzFR0YxWBawlEka3zswBZaczKR52PeSHLfKPryITd7vYV5JChk72JELnGILRXee51va6wOI7Zgpvg5g3o57Pi+apdLQwFYvVYNji+pmQjzfOfFQPRThwRA6ZlyIzyNSvga4mEb8lFNgOm/lSRfzPV7mEhFRCCuf8yKmSGXZGRhIYXPGQD8rBOxRXP+5dHsREcNZR6tfSblwtmeoRXyxDZWhj7Za5owQTAR/mUOz43LuVUjRfR4B3Sbrjum/c7e/qxRt7Wt++VYOYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 1:56=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Oct 29, 2025 at 11:58:41PM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
>
> Hello Kairui
>
> > The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
> > SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
> > This pinning usage here can be dropped by adding the folio to swap
> > cache directly on allocation.
> >
> > All swap allocations are folio-based now (except for hibernation), so
> > the swap allocator can always take the folio as the parameter. And now
> > both swap cache (swap table) and swap map are protected by the cluster
> > lock, scanning the map and inserting the folio can be done in the same
> > critical section. This eliminates the time window that a slot is pinned
> > by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
> > multiple times.
> >
> > This is both a cleanup and an optimization.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/swap.h |   5 --
> >  mm/swap.h            |   8 +--
> >  mm/swap_state.c      |  56 +++++++++++-------
> >  mm/swapfile.c        | 161 +++++++++++++++++++++----------------------=
--------
> >  4 files changed, 105 insertions(+), 125 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index ac3caa4c6999..4b4b81fbc6a3 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
> >  }
> >
> >  extern void si_swapinfo(struct sysinfo *);
> > -void put_swap_folio(struct folio *folio, swp_entry_t entry);
> >  extern int add_swap_count_continuation(swp_entry_t, gfp_t);
> >  int swap_type_of(dev_t device, sector_t offset);
> >  int find_first_swap(dev_t *device);
> > @@ -534,10 +533,6 @@ static inline void swap_put_entries_direct(swp_ent=
ry_t ent, int nr)
> >  {
> >  }
> >
> > -static inline void put_swap_folio(struct folio *folio, swp_entry_t swp=
)
> > -{
> > -}
> > -
> >  static inline int __swap_count(swp_entry_t entry)
> >  {
> >       return 0;
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 74c61129d7b7..03694ffa662f 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_st=
ruct *si,
> >   */
> >  struct folio *swap_cache_get_folio(swp_entry_t entry);
> >  void *swap_cache_get_shadow(swp_entry_t entry);
> > -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> > -                      void **shadow, bool alloc);
> >  void swap_cache_del_folio(struct folio *folio);
> >  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flag=
s,
> >                                    struct mempolicy *mpol, pgoff_t ilx,
> >                                    bool *alloced);
> >  /* Below helpers require the caller to lock and pass in the swap clust=
er. */
> > +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> > +                         struct folio *folio, swp_entry_t entry);
> >  void __swap_cache_del_folio(struct swap_cluster_info *ci,
> >                           struct folio *folio, swp_entry_t entry, void =
*shadow);
> >  void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> > @@ -459,8 +459,8 @@ static inline void *swap_cache_get_shadow(swp_entry=
_t entry)
> >       return NULL;
> >  }
> >
> > -static inline int swap_cache_add_folio(struct folio *folio, swp_entry_=
t entry,
> > -                                    void **shadow, bool alloc)
> > +static inline void *__swap_cache_add_folio(struct swap_cluster_info *c=
i,
> > +             struct folio *folio, swp_entry_t entry)
> >  {
> >  }
>
> Just a nit,
> void* return nothing.
>
> changed to void (original function prototype is return void)
> or how about just remove If this is not used on !CONFIG_SWAP

Thanks! Yeah it can be just removed, no one is using it when
!CONFIG_SWAP after this commit. Will clean it up.

>
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index d2bcca92b6e0..85d9f99c384f 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -122,6 +122,34 @@ void *swap_cache_get_shadow(swp_entry_t entry)
> >       return NULL;
> >  }
> >
> > +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> > +                         struct folio *folio, swp_entry_t entry)
> > +{
> > +     unsigned long new_tb;
> > +     unsigned int ci_start, ci_off, ci_end;
> > +     unsigned long nr_pages =3D folio_nr_pages(folio);
> > +
> > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +     VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> > +
> > +     new_tb =3D folio_to_swp_tb(folio);
> > +     ci_start =3D swp_cluster_offset(entry);
> > +     ci_off =3D ci_start;
> > +     ci_end =3D ci_start + nr_pages;
> > +     do {
> > +             VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_o=
ff)));
> > +             __swap_table_set(ci, ci_off, new_tb);
> > +     } while (++ci_off < ci_end);
> > +
> > +     folio_ref_add(folio, nr_pages);
> > +     folio_set_swapcache(folio);
> > +     folio->swap =3D entry;
> > +
> > +     node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> > +     lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> > +}
> > +
> >  /**
> >   * swap_cache_add_folio - Add a folio into the swap cache.
> >   * @folio: The folio to be added.
> > @@ -136,23 +164,18 @@ void *swap_cache_get_shadow(swp_entry_t entry)
> >   * The caller also needs to update the corresponding swap_map slots wi=
th
> >   * SWAP_HAS_CACHE bit to avoid race or conflict.
> >   */
> > -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> > -                      void **shadowp, bool alloc)
> > +static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry=
,
> > +                             void **shadowp)
>
> It is also a small thing.
> "alloc" parameter removed then the comment might be updated.

Nice suggestion, will cleanup the comment too.

>
> Thanks,
> Youngjun Park
>

