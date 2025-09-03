Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB2ACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 17:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BE78E0006; Wed,  3 Sep 2025 13:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B3F8E0002; Wed,  3 Sep 2025 13:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4888E0006; Wed,  3 Sep 2025 13:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 452EA8E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:41:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDCB9C07F4
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:41:53 +0000 (UTC)
X-FDA: 83848656906.06.8F3C871
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id E977540006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:41:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TiujgoqW;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756921312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2rifCSawIzOi8vgwTJd+B+H/b1XHeNN66Su7lbem9s=;
	b=oTnnOrrJJ6/c7PEJaR0Xpk1x+dkYSjQDfmUh2iCL3iaIGyZzNFF9nrtlNXYyonZKmz0SLV
	e1PYg3rfQsX8YEIvpuFKCgSURmO6O6Yz6UAdq4/h7wTat/cusZM7/IrOolqCIUS4pARHi9
	PMYusvBIZBs9AoeOGkyaIL+JHVLWOZ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TiujgoqW;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756921312; a=rsa-sha256;
	cv=none;
	b=qex4JxufzG4+X+FsEEJT0afVzY+VKvZwhV+iZzVYiyCO9uU7mLoLuu6KecN19wKHiX9ElP
	SBCYbwR9+RLR72eSD4rQwwjsjIUUHhgO1j/luf0O6EFFoTC0I0/JKRcOHYeitQk1P60Vut
	NWsm1dEgz8x8zXJP9OtGEX5k9oLX8KU=
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-88470af157aso2816139f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 10:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756921311; x=1757526111; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2rifCSawIzOi8vgwTJd+B+H/b1XHeNN66Su7lbem9s=;
        b=TiujgoqWDFuKL7tp/Fqhxp528h+dupGfPIiCfbaRA5rkD0wXBq7VIMDI1mg1nCmqBm
         SngWepGuqGvAmVAFIK6rwObvo164QdyXH8GBZr7IzH8dH7NkzBudhNP22NexKj4A3vXF
         KFys8pRMd63ghWQIVD+H1KW9jg+OVsgfYOefkaBH/60VauNzJJ79/SvD7cBlOQOLthot
         1YEzx6hBXEvIsxr4dCXDgn80HkvWf//w0sLu9Ko8Fdsql3f5wUEYE2BbEQt8hs36MHoi
         h8Hk0Wyo7JZ3ApQZvyop3Ni+tZPNsGX6fuioOneOYtdVagTZW2qhYCD+2xl5dnHkn/X1
         C56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756921311; x=1757526111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2rifCSawIzOi8vgwTJd+B+H/b1XHeNN66Su7lbem9s=;
        b=BQ5PxDQ8658rsPl67pVG7G49AUYfMSwQQSGg8JGqnDR2QrpAWMhg//0zdYHGaHR846
         NRx1LGDCxuJpr78nk9RFWgjGOwbrQnBNegPPGg7O1tG5bex48J2e4/jX8KgnlYAsDjDL
         gazUPK7ZdPlEon7gx5f1yD9kkKSu95qo7wv1wEhsAuP4nhJerfYi2c48/nG+apNgjKsM
         q2GIkHXMhoKy8f2O5eouSnlyBycw44v6L2QDNoLViwkucZ5VpatvyuRNM1hCLlA2FzLO
         rt1XLk+CpcQGP328cwwWaxg67kbLIZv4rIcL3PjbR+2kdZ4wH5nCKgMeDPRWrmSNwhOC
         UGMg==
X-Gm-Message-State: AOJu0YxcqKhu36BDkgzq2A6J4mGrbkeMfWlLNkIG/weFcVMteEyH0v+c
	/hbUakVDLpQIS7NaLfpHWZzJoxa2DBFqI+YnaQEoUPSvcJ+kpMi270rStEOCKaZthmHenxUG7Cz
	tgdvOrd6AYPoGYC3b/bV3HkjJHgdtt3E=
X-Gm-Gg: ASbGncsJkL48LUkC+eEoh7Y0mEB/s0yFYWrZ/pokL9EvMlKHGTeAH0/gHjUGQ0ceoCR
	hYfb1PJmX3H2ucEm5Zq7GOCe7J6E+N7DwQS/raN9n6neSQhfrwovknT8lsOFRhoL2jhJZCJG6eq
	MLRulgiPzHwJ3S0c81z3AzM7/nWWK/ZqYskpSSIghfe2xq2I2z6LUNi8a2TtbEZDdFNRnVd1O2y
	nQ0
X-Google-Smtp-Source: AGHT+IHRGYBhaH4a2/1W+w1i/hfdfD3R60H2jo1GjazUpX0ccoDYHvvujlerUh1Hpa+v0V24YT26tm/4gh7VTgYta3A=
X-Received: by 2002:a05:6602:3e85:b0:887:5dc8:fc0b with SMTP id
 ca18e2360f4ac-8875dc8fea9mr75929239f.13.1756921310773; Wed, 03 Sep 2025
 10:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Sep 2025 10:41:38 -0700
X-Gm-Features: Ac12FXyYuQbDS5o--UYof7pVJ2z63Kz4KMhiTlOVGRty2sX47XKdTjHqmQ4FgWk
Message-ID: <CAKEwX=O-_khBw0h3F+Uqx-8joMPHb-aOBuODx6LVO3vEZ38tpw@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E977540006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3uugzm7e5h38qmz48swrk8zykc6ucoy9
X-HE-Tag: 1756921311-6915
X-HE-Meta: U2FsdGVkX1/zpddp42XK924pu5I2SdUxYSSz5PbpJcqdV74oXedl/MJWzl4YokR9BUPVZsRKSkJ9i9SI5yyIL1bmn4Nfg5+kSzC02pZPzmJR0xr0VvotvRVuwamOXTHShprd0IJQGRd7IPlV7Sqa3IQm9Jzc2SZTCgJ8jdcgoY8k1VQSKxYSzWVL7v/iscPmVyF6GKpam4Am29PREPFgHv4feqqeK1y64LlZhKfJD10WHGYtX0jHyRepoCj9vR6V3R6hdfdunDStog8O/FNiHW1XCvv3PXGiAbgRddC3g26fzPSMtPsWLLyZDjeiyzMvpM0AiEFsR9iUnOJ47SkaqYbkxDYP5ZoEnn5ZW9O+n6Sw/xElEh9DUl5T/uc3oe3yiT4rELmPTvBvC3BT2Rb6N8Prq2SBXrxPU6vSjVsyzfPRRnQ2OTGpFTLucnBR7cebWCJZp91/03M4JYa1y/FSKJjRIecoRiMpS7pHaA+DErTKJIct6XReswf3Tq3JQ4Wj1pVLnLeGOZOdQn4OoGc51pIo2vNwTvk5S8luJlmqCFDkGlFl7lJBCpndx671X0IC6rwDJU5JjfAGJ+OmhxnDWnUMYUJ/hLda7gEbYzd8SPCMTahnS9nJnSNV6lzL8kwlSx8X/UJuA3lzBJFP9oCL6xImae2baMw3XMiCKcyg89lcH1Unt+2G5+zVTOii8rch/CADZ6dDX5yqNuT4RtkHWCmf4qgns6gdsZBTKdcEMFnkyFzn4jrP7oLZv3qDw1IVBt21HXD2Oh+FbESoozK2Vm5VMekvnbduzpeSUVxb823Vnrk9NcsEF+llj3mHYN/YUCYBF6KxO7HDX/6Ex01Doq6/eNChjCEjlgAzjjt3faIsuNEEReX7CnOPVOdTo2uR971KWGjgEfY8K5iiUQcdhler/SkpDB5KaZTzpU58MPuY3pmWfEb7TtPe2l1O912NSF60sx6C4DTJqVNURvB
 AWYv5dLv
 dpBmcUigtBFT2uz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Always use swap_cache_get_folio for swap cache folio look up. The reason
> we are not using it in all places is that it also updates the readahead
> info, and some callsites want to avoid that.
>
> So decouple readahead update with swap cache lookup into a standalone
> helper, let the caller call the readahead update helper if that's
> needed. And convert all swap cache lookups to use swap_cache_get_folio.
>
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration and shmem replacing,
> because they need to lock the Xarray. Following commits will wrap their
> accesses to the swap cache too with special helpers.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

My personal taste is we should have one patch to do the decoupling of
readahead update and the swapcache lookup, then another patch to use
the swapcache lookup helper in places that previously cannot be used
(due to the coupling of swapcache and readahead).

But, this looks good to me :) Feel free to add:

Acked-by: Nhat Pham <nphamcs@gmail.com>

> ---
>  mm/memory.c      |  6 ++-
>  mm/mincore.c     |  3 +-
>  mm/shmem.c       |  4 +-
>  mm/swap.h        | 13 +++++--
>  mm/swap_state.c  | 99 +++++++++++++++++++++++-------------------------
>  mm/swapfile.c    | 11 +++---
>  mm/userfaultfd.c |  5 +--
>  7 files changed, 72 insertions(+), 69 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d9de6c056179..10ef528a5f44 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(!si))
>                 goto out;
>
> -       folio =3D swap_cache_get_folio(entry, vma, vmf->address);
> -       if (folio)
> +       folio =3D swap_cache_get_folio(entry);
> +       if (folio) {
> +               swap_update_readahead(folio, vma, vmf->address);
>                 page =3D folio_file_page(folio, swp_offset(entry));
> +       }
>         swapcache =3D folio;
>
>         if (!folio) {
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 2f3e1816a30d..8ec4719370e1 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bo=
ol shmem)
>                 if (!si)
>                         return 0;
>         }
> -       folio =3D filemap_get_entry(swap_address_space(entry),
> -                                 swap_cache_index(entry));
> +       folio =3D swap_cache_get_folio(entry);
>         if (shmem)
>                 put_swap_device(si);
>         /* The swap cache space contains either folio, shadow or NULL */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 13cc51df3893..e9d0d2784cd5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>         }
>
>         /* Look it up and read it in.. */
> -       folio =3D swap_cache_get_folio(swap, NULL, 0);
> +       folio =3D swap_cache_get_folio(swap);
>         if (!folio) {
>                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
>                         /* Direct swapin skipping swap cache & readahead =
*/
> @@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                         count_vm_event(PGMAJFAULT);
>                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
>                 }
> +       } else {
> +               swap_update_readahead(folio, NULL, 0);
>         }
>
>         if (order > folio_order(folio)) {
> diff --git a/mm/swap.h b/mm/swap.h
> index 1ae44d4193b1..efb6d7ff9f30 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
>  void clear_shadow_from_swap_cache(int type, unsigned long begin,
>                                   unsigned long end);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr);
> +struct folio *swap_cache_get_folio(swp_entry_t entry);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>                 struct vm_area_struct *vma, unsigned long addr,
>                 struct swap_iocb **plug);
> @@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry,=
 gfp_t flag,
>                 struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
>                 struct vm_fault *vmf);
> +void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
> +                          unsigned long addr);
>
>  static inline unsigned int folio_swap_flags(struct folio *folio)
>  {
> @@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_ent=
ry_t swp, gfp_t gfp_mask,
>         return NULL;
>  }
>
> +static inline void swap_update_readahead(struct folio *folio,
> +               struct vm_area_struct *vma, unsigned long addr)
> +{
> +}
> +
>  static inline int swap_writeout(struct folio *folio,
>                 struct swap_iocb **swap_plug)
>  {
> @@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info_s=
truct *si, swp_entry_t entr
>  {
>  }
>
> -static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr)
> +static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
>         return NULL;
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 99513b74b5d8..ff9eb761a103 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
>         printk("Total swap =3D %lukB\n", K(total_swap_pages));
>  }
>
> +/*
> + * Lookup a swap entry in the swap cache. A found folio will be returned
> + * unlocked and with its refcount incremented.
> + *
> + * Caller must lock the swap device or hold a reference to keep it valid=
.
> + */
> +struct folio *swap_cache_get_folio(swp_entry_t entry)
> +{
> +       struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> +                                               swap_cache_index(entry));
> +       if (!IS_ERR(folio))
> +               return folio;
> +       return NULL;
> +}
> +
>  void *get_shadow_from_swap_cache(swp_entry_t entry)
>  {
>         struct address_space *address_space =3D swap_address_space(entry)=
;
> @@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
>  }
>
>  /*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented - we rely on the kernel
> - * lock getting page table operations atomic even if we drop the folio
> - * lock before returning.
> - *
> - * Caller must lock the swap device or hold a reference to keep it valid=
.
> + * Update the readahead statistics of a vma or globally.
>   */
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr)
> +void swap_update_readahead(struct folio *folio,
> +                          struct vm_area_struct *vma,
> +                          unsigned long addr)
>  {
> -       struct folio *folio;
> -
> -       folio =3D filemap_get_folio(swap_address_space(entry), swap_cache=
_index(entry));
> -       if (!IS_ERR(folio)) {
> -               bool vma_ra =3D swap_use_vma_readahead();
> -               bool readahead;
> +       bool readahead, vma_ra =3D swap_use_vma_readahead();
>
> -               /*
> -                * At the moment, we don't support PG_readahead for anon =
THP
> -                * so let's bail out rather than confusing the readahead =
stat.
> -                */
> -               if (unlikely(folio_test_large(folio)))
> -                       return folio;
> -
> -               readahead =3D folio_test_clear_readahead(folio);
> -               if (vma && vma_ra) {
> -                       unsigned long ra_val;
> -                       int win, hits;
> -
> -                       ra_val =3D GET_SWAP_RA_VAL(vma);
> -                       win =3D SWAP_RA_WIN(ra_val);
> -                       hits =3D SWAP_RA_HITS(ra_val);
> -                       if (readahead)
> -                               hits =3D min_t(int, hits + 1, SWAP_RA_HIT=
S_MAX);
> -                       atomic_long_set(&vma->swap_readahead_info,
> -                                       SWAP_RA_VAL(addr, win, hits));
> -               }
> -
> -               if (readahead) {
> -                       count_vm_event(SWAP_RA_HIT);
> -                       if (!vma || !vma_ra)
> -                               atomic_inc(&swapin_readahead_hits);
> -               }
> -       } else {
> -               folio =3D NULL;
> +       /*
> +        * At the moment, we don't support PG_readahead for anon THP
> +        * so let's bail out rather than confusing the readahead stat.
> +        */
> +       if (unlikely(folio_test_large(folio)))
> +               return;
> +
> +       readahead =3D folio_test_clear_readahead(folio);
> +       if (vma && vma_ra) {
> +               unsigned long ra_val;
> +               int win, hits;
> +
> +               ra_val =3D GET_SWAP_RA_VAL(vma);
> +               win =3D SWAP_RA_WIN(ra_val);
> +               hits =3D SWAP_RA_HITS(ra_val);
> +               if (readahead)
> +                       hits =3D min_t(int, hits + 1, SWAP_RA_HITS_MAX);
> +               atomic_long_set(&vma->swap_readahead_info,
> +                               SWAP_RA_VAL(addr, win, hits));
>         }
>
> -       return folio;
> +       if (readahead) {
> +               count_vm_event(SWAP_RA_HIT);
> +               if (!vma || !vma_ra)
> +                       atomic_inc(&swapin_readahead_hits);
> +       }
>  }
>
>  struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> @@ -336,14 +337,10 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
>         *new_page_allocated =3D false;
>         for (;;) {
>                 int err;
> -               /*
> -                * First check the swap cache.  Since this is normally
> -                * called after swap_cache_get_folio() failed, re-calling
> -                * that would confuse statistics.
> -                */
> -               folio =3D filemap_get_folio(swap_address_space(entry),
> -                                         swap_cache_index(entry));
> -               if (!IS_ERR(folio))
> +
> +               /* Check the swap cache in case the folio is already ther=
e */
> +               folio =3D swap_cache_get_folio(entry);
> +               if (folio)
>                         goto got_folio;
>
>                 /*
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a7ffabbe65ef..4b8ab2cb49ca 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -213,15 +213,14 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>                                  unsigned long offset, unsigned long flag=
s)
>  {
>         swp_entry_t entry =3D swp_entry(si->type, offset);
> -       struct address_space *address_space =3D swap_address_space(entry)=
;
>         struct swap_cluster_info *ci;
>         struct folio *folio;
>         int ret, nr_pages;
>         bool need_reclaim;
>
>  again:
> -       folio =3D filemap_get_folio(address_space, swap_cache_index(entry=
));
> -       if (IS_ERR(folio))
> +       folio =3D swap_cache_get_folio(entry);
> +       if (!folio)
>                 return 0;
>
>         nr_pages =3D folio_nr_pages(folio);
> @@ -2131,7 +2130,7 @@ static int unuse_pte_range(struct vm_area_struct *v=
ma, pmd_t *pmd,
>                 pte_unmap(pte);
>                 pte =3D NULL;
>
> -               folio =3D swap_cache_get_folio(entry, vma, addr);
> +               folio =3D swap_cache_get_folio(entry);
>                 if (!folio) {
>                         struct vm_fault vmf =3D {
>                                 .vma =3D vma,
> @@ -2357,8 +2356,8 @@ static int try_to_unuse(unsigned int type)
>                (i =3D find_next_to_unuse(si, i)) !=3D 0) {
>
>                 entry =3D swp_entry(type, i);
> -               folio =3D filemap_get_folio(swap_address_space(entry), sw=
ap_cache_index(entry));
> -               if (IS_ERR(folio))
> +               folio =3D swap_cache_get_folio(entry);
> +               if (!folio)
>                         continue;
>
>                 /*
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 50aaa8dcd24c..af61b95c89e4 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1489,9 +1489,8 @@ static long move_pages_ptes(struct mm_struct *mm, p=
md_t *dst_pmd, pmd_t *src_pmd
>                  * separately to allow proper handling.
>                  */
>                 if (!src_folio)
> -                       folio =3D filemap_get_folio(swap_address_space(en=
try),
> -                                       swap_cache_index(entry));
> -               if (!IS_ERR_OR_NULL(folio)) {
> +                       folio =3D swap_cache_get_folio(entry);
> +               if (folio) {
>                         if (folio_test_large(folio)) {
>                                 ret =3D -EBUSY;
>                                 folio_put(folio);
> --
> 2.51.0
>

