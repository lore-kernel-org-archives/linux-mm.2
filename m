Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E58CCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 23:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD816B0005; Fri,  5 Sep 2025 19:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B956B8E0007; Fri,  5 Sep 2025 19:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABE18E0001; Fri,  5 Sep 2025 19:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 975476B0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:59:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E23C85D69
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:59:45 +0000 (UTC)
X-FDA: 83856866730.23.8E89D71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 465DD40005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:59:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmpDwfbr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757116783; a=rsa-sha256;
	cv=none;
	b=R3/zbalkHUdgpnE9mTgtPaD7cjwExscdBFEqeVOLe7ODN2c68fx5mb6rc3psUndpIjisS4
	15Aw1ZCWAdtC4lkbi9TA5M9ANyMXXus+PFsuqMiA0OtWcUZTo9SMmhrX5Uy/RhByOwGE4R
	dXd/wKrHaDR8z2KPQSbHtI8TcnEtLAI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmpDwfbr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757116783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4hPAkPCz+M6YoWLVVBm11xFdNgXSZVF2RsS6Y1cVv8=;
	b=iwwD4QcBc9CwmeepDnw8WUy4EGjcRdVlwgih3VCbgkbaJpjK+DcKG279g2aHq0BNvgreHL
	iH3L9wew/1lRhg1Xiyvq6WQ2dEwOPKgpPsbzG/iG8MiNlp7mfg1qKkUFLtulJ6yNDOz6qL
	9IBM2zmksDLpIjkuYXzcB95b0ktD4r0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0C1144F99
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8238C4CEF8
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757116781;
	bh=prHCxbT/FKtcefzvbDhaSmgNNkguHFw4eGJyO0KdfRQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SmpDwfbrED7Ni+w3AVNeL6q9DVVBWikM4nb7Js4t7wgpDeKxXKuSBik/+/ygBTIE8
	 dcE91xuEKdv3WT+lN/X68ufH+x+xaHQSjZbt7h+JDYX66dgjd5M0WjPBVAFiZjjVlT
	 e4MYwEpXX77Oc2udy1tmHVrY1wRP2h5f2W+44zInQmA9unJMPD4EZsFU3TnQYw1ggB
	 ZhmMoPk/VkkoH9N4MNv3J2J6TRzf9KsdR0rtvYuKin++p9We7fIO3vKrD3t9DZRlZ2
	 8U1StK5bcirvcKyHNX+KdgTj+7NZsz99cHL7eqP7jARGpWS31m1dgZ0aXcQDXiinGe
	 y4I9aGQ3kCJZw==
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b886f92ccso32975e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 16:59:41 -0700 (PDT)
X-Gm-Message-State: AOJu0YyGNBi9IWSVSSzIY3nk/bzRZOrGc0dfFO5aNXNICfuxCHjPagBz
	moJ0C3Fc8O2FA8CAhxgSOdxbaHGO40r+okwQJGZ+F+m/0+Oklij3iQTbV5vognr1l6jETW0WfmT
	K7C4uYSjbMR5NNylUaNYs4BiyAYdGB5VGdiorJRvO
X-Google-Smtp-Source: AGHT+IEmNVdm/ZNO2xj7Acuf0/0sMnvEPvL2QiE++x0zfKILopxcWbw9wOaJ79Q+cHCzvynH0RqPluUDHwM3LCki7ro=
X-Received: by 2002:a05:600c:3ba3:b0:45d:cfca:a92d with SMTP id
 5b1f17b1804b1-45ddda4e7e5mr480365e9.2.1757116780368; Fri, 05 Sep 2025
 16:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-3-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-3-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 16:59:29 -0700
X-Gmail-Original-Message-ID: <CAF8kJuP3TePwm-Yv9k=8caDN_OHsEXLjkQyqzX8Zi5rByAxRzw@mail.gmail.com>
X-Gm-Features: Ac12FXwQoJgVKBu9ZgwBfG40kCMz84rUJdGEibuR9rX3WbxfQjIbxFt_Dtiuufs
Message-ID: <CAF8kJuP3TePwm-Yv9k=8caDN_OHsEXLjkQyqzX8Zi5rByAxRzw@mail.gmail.com>
Subject: Re: [PATCH v2 02/15] mm, swap: use unified helper for swap cache look up
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 465DD40005
X-Stat-Signature: 1q74zighft45i6oi6nc9shi5o8w9qo3t
X-HE-Tag: 1757116783-440627
X-HE-Meta: U2FsdGVkX18+E2/gXhBBIvzPLORlp1CHdaZw/pmJTSD4M6SpDZPmu/sbLlvu7U/Ivrt+WjpnXROUOv/mulp7j+7m4yM849cPPJaMBTiO0tSDg1Nkby2AxX6m/MX1WwcVsS2UxVzDN22iGlvZS+++OfzPt+whitx5ZWMMrL+jXunFhAuSI8y8NRkQlnw15A3/Vm1IUzrr8v/J/sSvOWQTzCFKw/2eFQS4GpaW76BJwTf2b0Tq+/fcHq2PABXRMXOAKmdJSMA7R9L3R8b2Iq/4WdLEud5sy0amVlHxNi3erRUnjIVUG1wOP7PMsGkI7sVoRNqzf71LaD1OBTKaqikW+4xfbS62Wzl0pMxGUhhUh6P3xdZPDs5WCGC4QHTOcIE72Qdbqzt+vMr0l9coavC1YDyzsaZCeeUpa6ixzOViOG7ydpA7Nbw7e9zkcZNFxamar6xbn3oJyQQ3FGbqwqUOIG91WUa1wOc1ejutBiDCr9Qd/1Wtd7DnAtbJiNvKezv3C6P3Q5722ZlMr0o29TAxfnetK+7jxRRFgYlwd/0CH2S34xJCf6V6SJyF6q+NA4bM4ad6IZWmLW1mIrx0dSUSn3ZPmxF0SDG2VPzIdxo+gFKUw1Y8WpA6lwDmD12zGWokbeQabgZOi230BZVvajx4al6DXPF2BzmxMHQ65MrBC5JZ7cWWTvadILlR7ydS5oUiThT/eRJmUFO9JT9TSBgeOn/VRMDzhzmTgpRMz1M2NC3w9W9PmtvEt7P+i4JCe7DmX7HWV3crZ1bjsf/y/0yrT6mq9tXcCWGWlR/FTwjPsx3lE3wBU6iuICrGieIkICVGso7oRWcyM/I3xjrSXN/t9fpL6zycf0chC/4oO3LDWMts93sOZp/ZVqSqdMf6I8Dg2W8xZTcXIo5XzClB3XfxvH/+b7swc0oqJRx9GI62FfKPYpi59VHkJ4i/CG/T1DVeFhAJSUDDXrtkCryU87a
 sDsQ/48c
 W9hKqRBM3QNH3j0W2Gmbl6kSGLBIxTekYtEV8JbbJF9BbG9Z8eUonpSJMM8+h8vW930+tDaLfY5bAIAmQAu+VmbCMzrODWV7QMrt5IWfu9etYeT3Y06nbLWEYhw5MfbDBNtsIXy3OfGg4ek7t8eEK7qODpMvuNxD9T9Udc+gJcDdEYnpJorzMINsq7Fej5lHxLrGYL+MYppm9TJ+cVNsq5GiK360+3Fbg6n/iQRv+Cr4/qy5GQYHv3ehLk5LfaQG3ptfOwpVoVP/E+J0GgiHYCxpTrx3E1Ti2of1c/5dq1u1iBPPzM88w2FfQVwDULoc3wZQzVeOSLtLgVtsOnhV149grXgVmSqWmkmhvcbMpJMq0ZlDpluHbKFZljpYyiUzInskg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The swap cache lookup helper swap_cache_get_folio currently does
> readahead updates as well, so callers that are not doing swapin from any
> VMA or mapping are forced to reuse filemap helpers instead, and have to
> access the swap cache space directly.
>
> So decouple readahead update with swap cache lookup. Move the readahead
> update part into a standalone helper. Let the caller call the readahead
> update helper if they do readahead. And convert all swap cache lookups
> to use swap_cache_get_folio.
>
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration, and shmem replacing,
> because they need to lock the XArray. The following commits will wrap
> their accesses to the swap cache too, with special helpers.
>
> And worth noting, currently dropbehind is not supported for anon folio,
> and we will never see a dropbehind folio in swap cache. The unified
> helper can be updated later to handle that.
>
> While at it, add proper kernedoc for touched helpers.
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  mm/memory.c      |   6 ++-
>  mm/mincore.c     |   3 +-
>  mm/shmem.c       |   4 +-
>  mm/swap.h        |  13 ++++--
>  mm/swap_state.c  | 109 +++++++++++++++++++++++++----------------------
>  mm/swapfile.c    |  11 +++--
>  mm/userfaultfd.c |   5 +--
>  7 files changed, 81 insertions(+), 70 deletions(-)
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
> index 2df26f4d6e60..4e27e8e5da3b 100644
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
> index 99513b74b5d8..68ec531d0f2b 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -69,6 +69,27 @@ void show_swap_cache_info(void)
>         printk("Total swap =3D %lukB\n", K(total_swap_pages));
>  }
>
> +/**
> + * swap_cache_get_folio - Looks up a folio in the swap cache.
> + * @entry: swap entry used for the lookup.
> + *
> + * A found folio will be returned unlocked and with its refcount increas=
ed.
> + *
> + * Context: Caller must ensure @entry is valid and protect the swap devi=
ce
> + * with reference count or locks.
> + * Return: Returns the found folio on success, NULL otherwise. The calle=
r
> + * must lock and check if the folio still matches the swap entry before
> + * use.
> + */
> +struct folio *swap_cache_get_folio(swp_entry_t entry)
> +{
> +       struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> +                                               swap_cache_index(entry));
> +       if (IS_ERR(folio))
> +               return NULL;
> +       return folio;
> +}
> +
>  void *get_shadow_from_swap_cache(swp_entry_t entry)
>  {
>         struct address_space *address_space =3D swap_address_space(entry)=
;
> @@ -272,55 +293,43 @@ static inline bool swap_use_vma_readahead(void)
>         return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate=
_swap);
>  }
>
> -/*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented - we rely on the kernel
> - * lock getting page table operations atomic even if we drop the folio
> - * lock before returning.
> - *
> - * Caller must lock the swap device or hold a reference to keep it valid=
.
> +/**
> + * swap_update_readahead - Update the readahead statistics of VMA or glo=
bally.
> + * @folio: the swap cache folio that just got hit.
> + * @vma: the VMA that should be updated, could be NULL for global update=
.
> + * @addr: the addr that triggered the swapin, ignored if @vma is NULL.
>   */
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr)
> +void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
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
> @@ -336,14 +345,10 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
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
>

