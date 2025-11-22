Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F06CFC51E
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 08:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D7F6B0008; Sat, 22 Nov 2025 03:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5436B000E; Sat, 22 Nov 2025 03:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA8C6B0011; Sat, 22 Nov 2025 03:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8856B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 03:39:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7D995733E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:39:32 +0000 (UTC)
X-FDA: 84137594184.25.B7C67A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD23E100004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:39:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hn3xKEfg;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763800770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJKLCh7cpr5AtHzzXLaFNWbIv71GEiwpjh2QbJvz0Cc=;
	b=tzT6lSM+XkOHd5uJ7lAO2cTGmU9fH/XC+O+OH1/538kqk5grVkFYGyL6OTSGih0hFlsEB9
	IXimdZImwwrSLe1TWTvk9wbBoZhoDbc2v4JjffUQzr2P78ev0g7UqgVT8InrWEulDpdA9j
	dchV7p6dEplKsUqmHu7XfsXz6Lsahuo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hn3xKEfg;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763800770; a=rsa-sha256;
	cv=none;
	b=79olbL3drXo/I/KT9bjszpHtJwBcpEbZ028LkI2ZweQp04djQ0ibfD5LrBAM8OvITlJf4K
	+rdZpJT8dT5w9qS1Gv6EzjeyT6Ru4x8edDO9nh0QtyYiSt8/tY3KlNGSC7PTX2aoI8CDD8
	7nsjxyQYgpLqI31JQq1JIm9rF436Ve8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2552F600AE
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E08C19424
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763800769;
	bh=eIrHWW5A6lKD0/BrIVHqggfOPIkJw2CT4IrFB4RUFy0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Hn3xKEfgIi8NR0urX40/DdFKtC5sT96BQrFiZlwzTE4gT5B9MEHpk4HJWmytCgvCY
	 GYpScu8PDronCIcXkRfk6k5ejhz4eatn90/Z2xlx0aLadobLadUYEW2jXPcMpYWFbY
	 xTv1fY1L0BybkTgQSj7BmnzUailkJCKe98LG0zMr4rU4WqY3aioXHsuXZP5WsfwQdj
	 tcxSvuNHT/72FDPR4KlO9oOLIMsPSEsmeCCyGZ6awcqyG3339ORrQISawbU12EmRuA
	 NiSsNzloq6E28jlLxHDfAqrvTlJa4K+15YiaXbE92dfPQ0AO7iQhPFQdbClfJ5FDDC
	 hAb/eLKRFrjaw==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78a6c7ac38fso31231437b3.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:39:29 -0800 (PST)
X-Gm-Message-State: AOJu0YxIS1+xtXuQNGrNmSMZxg4Zl6cLOAKnJhgCD4CKZxKSdz5Fospv
	sIyCfXqCptZN7+0geN6sIDO5qAsL9Rj1MooIgd11iDhQPLVEJuNU8798ur2VmoH8yI0wSwx/1rS
	OG8uyNRYAGGmOp3wzGwyiAQ0d0R0FD1zhiHDMPwMeeg==
X-Google-Smtp-Source: AGHT+IFfJxdmZNjSNnf0AHrqAcz6LumoNxr8cDdmoD2LZf0UfxJPkMXAl+gXo6XEPz/lRicT/7V9koWN2DqgnBWr9Ac=
X-Received: by 2002:a05:690c:6605:b0:786:5620:faf8 with SMTP id
 00721157ae682-78a8b54b2ecmr43342727b3.47.1763800769029; Sat, 22 Nov 2025
 00:39:29 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com> <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 22 Nov 2025 00:39:18 -0800
X-Gmail-Original-Message-ID: <CACePvbUjanBSkLZ-sM+kWo60dyHHoaH3S3S=T8UWNdDw5BOtmA@mail.gmail.com>
X-Gm-Features: AWmQ_bn5ZBNFjYSrcpOep7HISFbP9Rm9TpfICk7TPeaTbzIbUFC3nGDc14h_lJk
Message-ID: <CACePvbUjanBSkLZ-sM+kWo60dyHHoaH3S3S=T8UWNdDw5BOtmA@mail.gmail.com>
Subject: Re: [PATCH v2 01/19] mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DD23E100004
X-Stat-Signature: xsrm58c6eqfb7yut717stfmpe87u3uzk
X-Rspam-User: 
X-HE-Tag: 1763800770-378469
X-HE-Meta: U2FsdGVkX18Wo03JHi6GsjqR8gWMY6tWoLOQNRM3H1YAURVyeThr0jFnKPgrBLjZ2zBTj5VG9V0cPOTnvDxGBx+l62me4DuyJtwYLkZ28pjC4RN3Alehrr02hcdONkTVdT3ULwIVz7zPdxvLjzGsq1KBtvBwkPgWuc6Bz5DYDFqfWuE4Wbq4b47bKODQr+ku6Ftb9WguhcBuDNyGTuOixYAA28vWyALkjDnb2bMYMEwhwgiz3xcXrKUf6pGTKg7YKueixFo51MiBWrZO4zblOT5bOaxN00vGk3xAZZSG7KADSB6MFS6MVoX0oi+AepccY/MA9J2cxYuC14QivFDQ0b5jpSftl5FgPPSZU0Ead6MODV428qmjvPmS40IAuybh3a8N3Q4/7FdnYXKSM/Ke5RRtzrawWqxJEzBoD1W6p9YWUYtctJOy2MV6m3v1bdoAtnXf/81kQvqpT3gJHlLNc/jfzu7JmdmaTTswfhT49mTyr7ahqyf5p4MIt0Mzn6TscEfiSt04lFN9MNJmPkzTEgLWOYvffp1nxy/xIo8KIbgLEu573BZuJ3etBFhNJ70EGwdv+7JA0sKktQkhX8RWJHFqP1E9M84HPjjMJOzKSt7K5GiJiUgJJyR8e9oBPryg70csH1qflNCDmSL4FwI8HZ5Z3qhKwt8LYCKjzp0qhKAR9Mk/Me8Jswhnyw3J/Q4J7qUZ+HFZLcsmVAS5snYLVd/ZQC7QEqwZkwTFHoVcmErXkBUNaVpYE7gLDSYGF+E0FbPFPwZcme+MvKgzz3zEcJ5oXcUdhrGDO30R1gRS//w/2Sqrf/bIrtnlGYFCgCZBkpv9NHlXaeqU1lzOFZmMKGMgRyimEQ4eOX9sEuh5LKeE1xQVcHyP0GMJcYoIHGd87WPAgga8ePO69GxgIrbFa0FUS5OfTZpR+H/fMoZqGcEoSFZ4P2Sk8lvg0IYNtJ+DOdYEQ6UwD3yPh01LjTx
 rJF+mHE/
 aQrG3YkLrWQkN6zE78V8lvSevHXvTMz7JYTjnA5d/KdJuZT9One5qK5Bs48FtzyWTKAZATStN38DRyt7PootcdBpLefxjErAFKnAykbT/DHfJaM8NPqVr0AGRFiH0AB826TGHIoPFa1EMrJ8roim0PBqqfQze+c8CeNrFAxAuzswOgkIkHmNRIAdnv6N2yZBu0onpQQ4ROq8c65hej8IFwPiFVIDQG6+kwCG4nGorDpaZzNQQuoIQPM2e5V+7niDxPkaRZ7PTVJoTK7VpRFUbxh2FNi5rd6b4Xxo6BDxWinmm8dBL6NEHHk+vHS5Mx1ZsME7cEXDMTH2a8yRrYHFKRXHNpL5WRzaUvjZuQE+7gBKcdbwfVSzxX5UkYMbTPesWyDE9EnZiYdXmKivS/+K28KTu7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Sun, Nov 16, 2025 at 10:12=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> __read_swap_cache_async is widely used to allocate and ensure a folio is
> in swapcache, or get the folio if a folio is already there.
>
> It's not async, and it's not doing any read. Rename it to better present
> its usage, and prepare to be reworked as part of new swap cache APIs.
>
> Also, add some comments for the function. Worth noting that the
> skip_if_exists argument is an long existing workaround that will be
> dropped soon.
>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |  6 +++---
>  mm/swap_state.c | 50 +++++++++++++++++++++++++++++++++-----------------
>  mm/swapfile.c   |  2 +-
>  mm/zswap.c      |  4 ++--
>  4 files changed, 39 insertions(+), 23 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index d034c13d8dd2..0fff92e42cfe 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -249,6 +249,9 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)=
;
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void *=
*shadow);
>  void swap_cache_del_folio(struct folio *folio);
> +struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
> +                                    struct mempolicy *mpol, pgoff_t ilx,
> +                                    bool *alloced, bool skip_if_exists);
>  /* Below helpers require the caller to lock and pass in the swap cluster=
. */
>  void __swap_cache_del_folio(struct swap_cluster_info *ci,
>                             struct folio *folio, swp_entry_t entry, void =
*shadow);
> @@ -261,9 +264,6 @@ void swapcache_clear(struct swap_info_struct *si, swp=
_entry_t entry, int nr);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>                 struct vm_area_struct *vma, unsigned long addr,
>                 struct swap_iocb **plug);
> -struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags=
,
> -               struct mempolicy *mpol, pgoff_t ilx, bool *new_page_alloc=
ated,
> -               bool skip_if_exists);
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>                 struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b2230f8a48fc..08252eaef32f 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -402,9 +402,29 @@ void swap_update_readahead(struct folio *folio, stru=
ct vm_area_struct *vma,
>         }
>  }
>
> -struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> -               struct mempolicy *mpol, pgoff_t ilx, bool *new_page_alloc=
ated,
> -               bool skip_if_exists)
> +/**
> + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap =
cache.
> + * @entry: the swapped out swap entry to be binded to the folio.
> + * @gfp_mask: memory allocation flags
> + * @mpol: NUMA memory allocation policy to be applied
> + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> + * @new_page_allocated: sets true if allocation happened, false otherwis=
e
> + * @skip_if_exists: if the slot is a partially cached state, return NULL=
.
> + *                  This is a workaround that would be removed shortly.
> + *
> + * Allocate a folio in the swap cache for one swap slot, typically befor=
e
> + * doing IO (e.g. swap in or zswap writeback). The swap slot indicated b=
y
> + * @entry must have a non-zero swap count (swapped out).
> + * Currently only supports order 0.
> + *
> + * Context: Caller must protect the swap device with reference count or =
locks.
> + * Return: Returns the existing folio if @entry is cached already. Retur=
ns
> + * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
> + */
> +struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
> +                                    struct mempolicy *mpol, pgoff_t ilx,
> +                                    bool *new_page_allocated,
> +                                    bool skip_if_exists)
>  {
>         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct folio *folio;
> @@ -452,12 +472,12 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
>                         goto put_and_return;
>
>                 /*
> -                * Protect against a recursive call to __read_swap_cache_=
async()
> +                * Protect against a recursive call to swap_cache_alloc_f=
olio()
>                  * on the same entry waiting forever here because SWAP_HA=
S_CACHE
>                  * is set but the folio is not the swap cache yet. This c=
an
>                  * happen today if mem_cgroup_swapin_charge_folio() below
>                  * triggers reclaim through zswap, which may call
> -                * __read_swap_cache_async() in the writeback path.
> +                * swap_cache_alloc_folio() in the writeback path.
>                  */
>                 if (skip_if_exists)
>                         goto put_and_return;
> @@ -466,7 +486,7 @@ struct folio *__read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>                  * We might race against __swap_cache_del_folio(), and
>                  * stumble across a swap_map entry whose SWAP_HAS_CACHE
>                  * has not yet been cleared.  Or race against another
> -                * __read_swap_cache_async(), which has set SWAP_HAS_CACH=
E
> +                * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
>                  * in swap_map, but not yet added its folio to swap cache=
.
>                  */
>                 schedule_timeout_uninterruptible(1);
> @@ -509,10 +529,6 @@ struct folio *__read_swap_cache_async(swp_entry_t en=
try, gfp_t gfp_mask,
>   * and reading the disk if it is not already cached.
>   * A failure return means that either the page allocation failed or that
>   * the swap entry is no longer in use.
> - *
> - * get/put_swap_device() aren't needed to call this function, because
> - * __read_swap_cache_async() call them and swap_read_folio() holds the
> - * swap cache folio lock.
>   */
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>                 struct vm_area_struct *vma, unsigned long addr,
> @@ -529,7 +545,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry=
, gfp_t gfp_mask,
>                 return NULL;
>
>         mpol =3D get_vma_policy(vma, addr, 0, &ilx);
> -       folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +       folio =3D swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>                                         &page_allocated, false);
>         mpol_cond_put(mpol);
>
> @@ -647,9 +663,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t gfp_mask,
>         blk_start_plug(&plug);
>         for (offset =3D start_offset; offset <=3D end_offset ; offset++) =
{
>                 /* Ok, do the async read-ahead now */
> -               folio =3D __read_swap_cache_async(
> -                               swp_entry(swp_type(entry), offset),
> -                               gfp_mask, mpol, ilx, &page_allocated, fal=
se);
> +               folio =3D swap_cache_alloc_folio(
> +                       swp_entry(swp_type(entry), offset), gfp_mask, mpo=
l, ilx,
> +                       &page_allocated, false);
>                 if (!folio)
>                         continue;
>                 if (page_allocated) {
> @@ -666,7 +682,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t gfp_mask,
>         lru_add_drain();        /* Push any new pages onto the LRU now */
>  skip:
>         /* The page was likely read above, so no need for plugging here *=
/
> -       folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +       folio =3D swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>                                         &page_allocated, false);
>         if (unlikely(page_allocated))
>                 swap_read_folio(folio, NULL);
> @@ -771,7 +787,7 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>                         if (!si)
>                                 continue;
>                 }
> -               folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, =
ilx,
> +               folio =3D swap_cache_alloc_folio(entry, gfp_mask, mpol, i=
lx,
>                                                 &page_allocated, false);
>                 if (si)
>                         put_swap_device(si);
> @@ -793,7 +809,7 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>         lru_add_drain();
>  skip:
>         /* The folio was likely read above, so no need for plugging here =
*/
> -       folio =3D __read_swap_cache_async(targ_entry, gfp_mask, mpol, tar=
g_ilx,
> +       folio =3D swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ=
_ilx,
>                                         &page_allocated, false);
>         if (unlikely(page_allocated))
>                 swap_read_folio(folio, NULL);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94e0f0c54168..a2bb09867f1e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1573,7 +1573,7 @@ static unsigned char swap_entry_put_locked(struct s=
wap_info_struct *si,
>   *   CPU1                              CPU2
>   *   do_swap_page()
>   *     ...                             swapoff+swapon
> - *     __read_swap_cache_async()
> + *     swap_cache_alloc_folio()
>   *       swapcache_prepare()
>   *         __swap_duplicate()
>   *           // check swap_map
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..a7a2443912f4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1014,8 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>                 return -EEXIST;
>
>         mpol =3D get_task_policy(current);
> -       folio =3D __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
> -                       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> +       folio =3D swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
> +                                      NO_INTERLEAVE_INDEX, &folio_was_al=
located, true);
>         put_swap_device(si);
>         if (!folio)
>                 return -ENOMEM;
>
> --
> 2.51.2
>

