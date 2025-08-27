Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC53DC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 06:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2E58E0122; Wed, 27 Aug 2025 02:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AA68E0105; Wed, 27 Aug 2025 02:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1A28E0122; Wed, 27 Aug 2025 02:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCECD8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:13:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95723B9B5C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:13:44 +0000 (UTC)
X-FDA: 83821521168.03.2830A93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9E501100010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:13:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GNyIBn/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756275222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yKonsBvVaDfndHNz+uuZHiBd8qaUWz52QSO3kv0A/0=;
	b=vn4a9KXWcza8IiMaAzuhD7s2pjFBVHyFHoJlOesU9wjZPmiFOAuUilcR9RU9O5L7WeOI6w
	fiijHldre+3DI9dDSM9E49CZhmYjZv3x6SgBKavS6zKxlnKA5BFAhgyFxnK6mfGugPhGAD
	OhKC5/BuVct4i1sR2QmcNgmPJa+TTGI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GNyIBn/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756275222; a=rsa-sha256;
	cv=none;
	b=YDs5rgRvpjKJEtDqoSdTGatpo7YXT4uGfZx4G+4262jCvFS/Bpk1qhZQocJJoLfXCeVOLr
	D9zUeObr02WTW17cIgy7rrOQjLVmtc8WVY+M6+JTU+WrOHtJmcEpsKaz3PMx9uZsGGarpD
	a+rGGY8OOE6M831LNkfNFAjPKB9Ev90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91C4F44761
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0BEC2BC86
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756275221;
	bh=58IM4CO3GzYGElXulUjCsmon9Noi6X7JoteWvqArny4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GNyIBn/KRQ/og/VQKH755dpknO2+GXDkzJLCpL3KoWXhhz2LhLZM29MshWyG4D8K8
	 Uevl4ItL+8+BE6QtpgplXL50evCZHc6gjeKzfOFRAFAleB1Zs45a+LlYtAMbP4L8Mf
	 K2fGeCQHiRA/Z8ecdQfPk/fzSMTae0hVHk1Dc4aBCZnCskgQInO0CqBgISJGGNLyIw
	 0+aNpmagrg+ktCWLxrFmJeDHfdCblb00Dc5QP+hpzM8kTFRgvqVu1S3E5gxnbEQU+j
	 pkqcopQ3CQ4IeDnYwVA6qAguoSiXehOKIrqPeZl7kFIFebAR582mFWAA3zBjXh06IK
	 MIBFvLyHt2akQ==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459fbc92e69so43055e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:13:41 -0700 (PDT)
X-Gm-Message-State: AOJu0YxlSgnVMifCw8CVM8af0iwZxAfypvqN8a9l1oHzNGGu9dgaeAhm
	oQFBGxTibvztvaBlsxBo/isu0XDO7bAkFeMf8kDTbtKllpXPtZz9xLOEsULX17oWwMD9gWU+5he
	A4JfRjmfxts4EWHj3w66FWtxliYVHLypdHfmHC8yG
X-Google-Smtp-Source: AGHT+IF/M5nnBkFj8JCQ/wd31/i7BTMrdvdLwr55gMNN7OSMKTtQEybe9ApR8eFYMcDo9u87NtRAOyds2X9C13tVmGA=
X-Received: by 2002:a05:600c:8219:b0:45a:2861:3625 with SMTP id
 5b1f17b1804b1-45b65ee0f36mr3307965e9.4.1756275219801; Tue, 26 Aug 2025
 23:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-3-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 23:13:28 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMX_WTg7vyACBxskNmDHB4C-ZkowuKYP71gQ8qyKuwAaA@mail.gmail.com>
X-Gm-Features: Ac12FXx6j9Ld3lDohs75YQOI64HdH5xtgDz7f-SuJOL8YjcKUe9IiesbxU2NYqw
Message-ID: <CAF8kJuMX_WTg7vyACBxskNmDHB4C-ZkowuKYP71gQ8qyKuwAaA@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E501100010
X-Stat-Signature: yhowurtpi5zf5ufcnpwezxr9wka5sk57
X-Rspam-User: 
X-HE-Tag: 1756275222-725447
X-HE-Meta: U2FsdGVkX1+kXbfMJa4GKLH5clhix4jbDQRdc1PnM0EudVJaFtEM/8eu/mW4Rr1Rf04IwD5oHY/6TNwE/CrnsLQ2dq9vNLYUETySjh7jgsQLUyRdpRCOVhWkwbMSvlEhWNGwoDNvZQkRoqZEKSDRYPX0GrpA0hp6peLwxJMh5pQPJc2z0lH5LqfQGVvf/Q3FtDRPWJ6eS/siNmayYhNgRu/8pXpAVnYMHagsHZV2GNYnYSqCJ9CQYnQt9djqPWBQvxzz0EZ59K1hJxsKpFAptc/w6q+5hCK1lyflrtXVSr/mvMzqtphlghkSnjM9/tQ61XOtQ6NZB5NDSiUpcsPgglD0DGglL23zGFCKOlAZb1uIxruIt/7KRHw8ODLNnqdbf6Qnp6agHIgGyP6eTeaFkS4y+GwIdAktdHxEcyfTkPxdySBTf6Bi1pfoem0LTo1X8F+hPQ8epnY7aySHEcNG8xP49TfD+xSVkynxuNFAwon/jF5cBBGPPgr9EBcn/sF2mGVXnLMbaKZBLiYMCVVqGd5s0YnUozv6QaP9D1osckypPjko3YrK6GYRK8+u6X7e1sFtYsiUAFEb/VKE7xPVFEmIIkV7eurCMg4Pnqw0KQiI9odAomJZ9aczrgzOjFL+6/f4rxB3dHPMa5PSFGfGrGn3HHIiBX/DnhdeBCleZ6blsy2LFivjk5qVFNc/aEAfRskCilKU9UHOiIFrv9HU4GjHiXt0XOr/mMXs40VUh/m+M6V5U+yKE5UiCES+wW2hpXUVUyvbW3AcX42LK7VuYpgTU0SY2FaNIzd7mvUD+hnICCxkbLd/Yg0z3XEua6XCt+Zm6uxM4ma+9S1W1qZ2o8A0Ob8xsUqNc12kV+Bgss+C0TsU1/LKC7YlCYnwewYLWE48ipxjFr93M/jgIOGPubuu9FmNjliV9i2yM1+kr/wEo0Lh5uL8cixqdIyG6We9MyAeo2th0bK4u6YzPw/
 Yj5iX0zt
 V+xd6gGuHtESPL0kMnSfyVXSQxK1QPeRuQk27N2kbzoBnVnfoFo54F3p0g7apx9vGK/SkmqEgNZRg5t+EmmtY6a+vY2LEYyLEMeKu6n81iQky/w+z+9hdfdW2Vv6XkKAvpMXRS0L7m/tNOhlP/cFBSKhuy5D+3usC396ucVZWh1b2YKXhFF1NYH3bZ5ilVOLFj24ywvKj5LDXSdo1yT72W2x0RItcbiXsTRZN8giGeGrWx4kfOxlwZ80oRH5Hox0Fx3zU6deIFIyeZ4CPee6FAMvdPuHtMwQY12B3sLuJxTQFHbi0yAudOcsIgqJGibOBmHgDwdnyLE071SQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cache lookup is lockless, it only increases the reference count
> of the returned folio. That's not enough to ensure a folio is stable in
> the swap cache, so the folio could be removed from the swap cache at any
> time. The caller always has to lock and check the folio before use.
>
> Document this as a comment, and introduce a helper for swap cache folio
> verification with proper sanity checks.
>
> Also, sanitize all current users to use this convention, and use the new
> helper when possible for easier debugging. Some existing callers won't
> cause any major problem right now, only trivial issues like incorrect
> readahead statistic (swapin) or wasted loop (swapoff). It's better to
> always follow this convention to make things robust.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c     | 28 +++++++++++++---------------
>  mm/shmem.c      |  4 ++--
>  mm/swap.h       | 28 ++++++++++++++++++++++++++++
>  mm/swap_state.c | 13 +++++++++----
>  mm/swapfile.c   | 10 ++++++++--
>  5 files changed, 60 insertions(+), 23 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 10ef528a5f44..9ca8e1873c6e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4661,12 +4661,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 goto out;
>
>         folio =3D swap_cache_get_folio(entry);
> -       if (folio) {
> -               swap_update_readahead(folio, vma, vmf->address);
> -               page =3D folio_file_page(folio, swp_offset(entry));
> -       }
>         swapcache =3D folio;
> -

Can simplify as:
           folio =3D swapcache =3D swap_cache_get_folio(entry);

>         if (!folio) {
>                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
>                     __swap_count(entry) =3D=3D 1) {
> @@ -4735,20 +4730,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 ret =3D VM_FAULT_MAJOR;
>                 count_vm_event(PGMAJFAULT);
>                 count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> -               page =3D folio_file_page(folio, swp_offset(entry));
> -       } else if (PageHWPoison(page)) {
> -               /*
> -                * hwpoisoned dirty swapcache pages are kept for killing
> -                * owner processes (which may be unknown at hwpoison time=
)
> -                */
> -               ret =3D VM_FAULT_HWPOISON;
> -               goto out_release;

Here you move the HWPosion(page) bail out from before taking the page
lock to after the page lock. The HWPosion page should be able to bail
out without taking the lock.

>         }
>
>         ret |=3D folio_lock_or_retry(folio, vmf);
>         if (ret & VM_FAULT_RETRY)
>                 goto out_release;
>
> +       page =3D folio_file_page(folio, swp_offset(entry));
>         if (swapcache) {
>                 /*
>                  * Make sure folio_free_swap() or swapoff did not release=
 the
> @@ -4757,10 +4745,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                  * swapcache, we need to check that the page's swap has n=
ot
>                  * changed.
>                  */
> -               if (unlikely(!folio_test_swapcache(folio) ||
> -                            page_swap_entry(page).val !=3D entry.val))
> +               if (!folio_contains_swap(folio, entry))
>                         goto out_page;
>
> +               if (PageHWPoison(page)) {
> +                       /*
> +                        * hwpoisoned dirty swapcache pages are kept for =
killing
> +                        * owner processes (which may be unknown at hwpoi=
son time)
> +                        */
> +                       ret =3D VM_FAULT_HWPOISON;
> +                       goto out_page;

It seems you bail out with the page still locked, that seems like a bug to =
me.

I think this HWPoision() check move order with the page lock is problematic=
.

Can you double check?

To be continued.

Chris

> +               }
> +
> +               swap_update_readahead(folio, vma, vmf->address);
> +
>                 /*
>                  * KSM sometimes has to copy on read faults, for example,=
 if
>                  * folio->index of non-ksm folios would be nonlinear insi=
de the
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e9d0d2784cd5..b4d39f2a1e0a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                         count_vm_event(PGMAJFAULT);
>                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
>                 }
> -       } else {
> -               swap_update_readahead(folio, NULL, 0);
>         }
>
>         if (order > folio_order(folio)) {
> @@ -2431,6 +2429,8 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                 error =3D -EIO;
>                 goto failed;
>         }
> +       if (!skip_swapcache)
> +               swap_update_readahead(folio, NULL, 0);
>         folio_wait_writeback(folio);
>         nr_pages =3D folio_nr_pages(folio);
>
> diff --git a/mm/swap.h b/mm/swap.h
> index efb6d7ff9f30..bb2adbfd64a9 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -52,6 +52,29 @@ static inline pgoff_t swap_cache_index(swp_entry_t ent=
ry)
>         return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
>  }
>
> +/**
> + * folio_contains_swap - Does this folio contain this swap entry?
> + * @folio: The folio.
> + * @entry: The swap entry to check against.
> + *
> + * Swap version of folio_contains()
> + *
> + * Context: The caller should have the folio locked to ensure
> + * nothing will move it out of the swap cache.
> + * Return: true or false.
> + */
> +static inline bool folio_contains_swap(struct folio *folio, swp_entry_t =
entry)
> +{
> +       pgoff_t offset =3D swp_offset(entry);
> +
> +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +       if (unlikely(!folio_test_swapcache(folio)))
> +               return false;
> +       if (unlikely(swp_type(entry) !=3D swp_type(folio->swap)))
> +               return false;
> +       return offset - swp_offset(folio->swap) < folio_nr_pages(folio);
> +}
> +
>  void show_swap_cache_info(void);
>  void *get_shadow_from_swap_cache(swp_entry_t entry);
>  int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> @@ -144,6 +167,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t e=
ntry)
>         return 0;
>  }
>
> +static inline bool folio_contains_swap(struct folio *folio, swp_entry_t =
entry)
> +{
> +       return false;
> +}
> +
>  static inline void show_swap_cache_info(void)
>  {
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ff9eb761a103..be0d96494dc1 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -70,10 +70,12 @@ void show_swap_cache_info(void)
>  }
>
>  /*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented.
> + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
>   *
> - * Caller must lock the swap device or hold a reference to keep it valid=
.
> + * A found folio will be returned unlocked and with its refcount increas=
ed.
> + *
> + * Context: Caller must ensure @entry is valid and pin the swap device, =
also
> + * check the returned folio after locking it (e.g. folio_swap_contains).
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entry_t en=
try, gfp_t gfp_mask,
>         for (;;) {
>                 int err;
>
> -               /* Check the swap cache in case the folio is already ther=
e */
> +               /*
> +                * Check the swap cache first, if a cached folio is found=
,
> +                * return it unlocked. The caller will lock and check it.
> +                */
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         goto got_folio;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4b8ab2cb49ca..12f2580ebe8d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>          * Offset could point to the middle of a large folio, or folio
>          * may no longer point to the expected offset before it's locked.
>          */
> -       entry =3D folio->swap;
> -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entry) +=
 nr_pages) {
> +       if (!folio_contains_swap(folio, entry)) {
>                 folio_unlock(folio);
>                 folio_put(folio);
>                 goto again;
>         }
> +       entry =3D folio->swap;
>         offset =3D swp_offset(entry);
>
>         need_reclaim =3D ((flags & TTRS_ANYWAY) ||
> @@ -2150,6 +2150,12 @@ static int unuse_pte_range(struct vm_area_struct *=
vma, pmd_t *pmd,
>                 }
>
>                 folio_lock(folio);
> +               if (!folio_contains_swap(folio, entry)) {
> +                       folio_unlock(folio);
> +                       folio_put(folio);
> +                       continue;
> +               }
> +
>                 folio_wait_writeback(folio);
>                 ret =3D unuse_pte(vma, pmd, addr, entry, folio);
>                 if (ret < 0) {
> --
> 2.51.0
>
>

