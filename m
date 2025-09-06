Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051E3CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 05:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59EC38E0003; Sat,  6 Sep 2025 01:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550048E0001; Sat,  6 Sep 2025 01:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465AB8E0003; Sat,  6 Sep 2025 01:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 341B28E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:45:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9A3C16032B
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 05:45:29 +0000 (UTC)
X-FDA: 83857737978.18.E029D45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 01FD1140004
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 05:45:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNCX+awG;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757137528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJ4BZQUmXB126Ugxpyn3967ivyN11eI8lmFvMWEMOgw=;
	b=WaetbO+DjRkLjJs4uVBU4PG0AXKQKl1+LiWKEu9MtTbH4Pd35vZKK26A/tpLoLZNQytguH
	5p4PiYQYAKh13L9gQCqBsECax8DTc//VoTGnnWwawxGm8aM5jkVJ8T0s2YlSiHTb0gQqkB
	9GhT8qtKYqHyFfaRPghY0wZ/L3g3Z2M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNCX+awG;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757137528; a=rsa-sha256;
	cv=none;
	b=089Mv8C65Ijf1jgFBz1jsFQNJu7cY2kQ9lXMMLApUetgUlV9Zt7zhUVoCqaBYZaoGp2vGT
	Oi8mnJ+OB9I2oIYyUDV4P0GoxTQd+nyrfXiZB68q4/7n/y5JzzMsmaPWcF+P/3K+cITg3g
	XfPg7/2WeT2DPdSWeHR6cAw9gz0QDU4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F03B560297
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 05:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A34C113CF
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 05:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757137526;
	bh=Y2H2ghaUA6BwKtBztuwLUDtij2lov+amvzwUCBE/+b0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FNCX+awGSm3x5khTRhUWEl9sv2XI4bwE+CjTYQlDnhjHRPHpOZ2tKmrMRmG6Rbz4E
	 tofE5T2dZO8UB1eLOrud/BDWHHmJNah0LO6nuq6QoinfsWilO3pMP9ekZQwgtTccMm
	 EW9zSX0R1uIao9QK1ewuiiovmWDsEp0wuJ/cAtOTCIiZJj/9PoghU6y0uJkoLrV53f
	 D+Obhsj3SQwxGz3sWUK+QvNMtRvBHvtbUL91luo5bDzRydUCKOufFR93rbLH2mSOEk
	 7og0krODKiEjFB5bBSdgV4I6EWiN4O02oixkdJenLjqzHNou/Ouc2h2LD7HuHQ/DTO
	 Kn4roOe4AC/Xw==
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so38365e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 22:45:26 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw77KOEv1anjwo9JPK08x4rxQnMl0cW8Txy87rQ8aJF37MaG8lF
	PgZXcVsAGic2f9NRTJOl/rcHqHxX9W8ZLMsNCsOKoy2bNmGeShv7xU+rF8UZR0pNQgLwz//HBw/
	dRgPraNFJ6DGraAlMH+Tg8v/q3zN0RVtJep6HZcJl
X-Google-Smtp-Source: AGHT+IFHl8FEjWMumhaltqQyu6gYBf9y4IR3uR2BERFsortiYCZosuzmTajMi+ll2FqM4abJGpY9uFGn2AWSCgd3ilY=
X-Received: by 2002:a05:600c:a408:b0:45b:7d8f:4bd4 with SMTP id
 5b1f17b1804b1-45dddad7944mr712595e9.4.1757137524818; Fri, 05 Sep 2025
 22:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-10-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-10-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 22:45:12 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPkipwbjiKNe_xSyDJwPxUvNuaqO94EqXyeUadUcPb06A@mail.gmail.com>
X-Gm-Features: Ac12FXzS1p3-svG_Q6inF4tvEzx7nIONHK1_zcHzJlaaeUw6eR-u7nLtk6PfPFE
Message-ID: <CAF8kJuPkipwbjiKNe_xSyDJwPxUvNuaqO94EqXyeUadUcPb06A@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] mm, swap: cleanup swap cache API and add kerneldoc
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 01FD1140004
X-Stat-Signature: 89ah98k5omca4qz37a3q7kat8xqqyrqa
X-Rspam-User: 
X-HE-Tag: 1757137527-274343
X-HE-Meta: U2FsdGVkX1+8LC9FOoRYkLY10AgOFd6M83sbQH5opksTDK5Q/PvZZa3O9n9jgmEdu+KTj+fEwhp4DySGKmSMW7WbESNHjq/tKFuLcgYI9wiDhYINDyGUyR70MpYNJmbEUdivLZvZbx/Zdi108z6LoTgiosmAdGHyRyby4fPEievjKL7hTU3jIQBME3qPnHLKoSM1BA+78/1ITcnzz3RHN//3nmNz0R6Tsg7rHevVNJd1i4gElfGyPv3ICyb+j9XdOBmV4jYGaW6+8iGy6rOd4l6EtxlA5iYRh60biE3PyZ1Ezsb1b0ZWvNR6jjQXAC56rOXQKIXIBbcD8UbZKQa2tv2aTI88yM2ktGciFba4gXRDYFeo6cMQivK9DV2VMDTq2xzuqCW5dNtFPB0HFAlyyvY1YZyjz60N2sdsW585Jf8KBcbypYvqxy8jCGh6+TmVhGI+nHBgxWvt43J8eMIBpfHy7c1r/LEQmX0nkUs4oDjIBLCE4Fn0V7oL4m1ho38qcJsoTA1O+Dfm3G4CSxNVqwkUWpbXjGCOZqjwzwO50YIjzSaOGHIqLF22K0bHDvYqt0jnhlLmPblgERYqKgOl4J28bTuKJ5q93C9aFw6mOPnpaPN10yzfGnOHOxQIzEn1x0cJUr5edD4SMgrZX/rJCaEGBjikD1puN2tIpxjHu3nyhy58/L7wX9rDXH/TnHwvJxfIe0nGhQgNJI/3+m1KKojouh6DDEoc0Lp8YNFMmH9wYU6JN2Xqk4VhMvnxT+0veD2Ij1BYayUu5Y7Ken1lsZY0G54DNsMBgL4cEUFSz3pEe3/hU6K3Qj9iMKhBqshC/lfSJyJKP7vql1f3aoF17NiBH7jUngbjAV7jZARA7R1u7GrZ9y6kQvkj08GnKHxcB+t9frndPPqN9nRkqvqy4vSrjnoyewcyMD62e5A5bOmjIqi2eiErAUks2koBc7rk+gWNhb/wN+WFDSVH/Pc
 al/99F3w
 CPIzMhfRhuDxCRW9EG3YMiT3eXHbcbemyptc9kNfxlRz3+1DlKqGu3a4xDs2LbpjaByXRyCrQX881X4s48oEILpJ85ZXP+mtMbgbdsPQ/T4OZyMDWvdZtRnJg7dDAVHqsYHidnjYp8d4oXyUcAbaHGxWgVaPIHBNu+TqSDV092RYXett8AUBuAydKoVVRD7PjLzz9BNpqSK7tcZnI7X4uy0qfIgSpH68JWIRBkASolf9+NiQ57mRbbHbAdb3zkwwXm+CPUk/PAvGvrSyRcyV1O4y3Rctb/l+bLsnUpCYivYrnIE5mdpkrMLXJSV18WYLXvhENzprrKIt42nJ+HoQ1ELCs0T+ek3DePSkS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> In preparation for replacing the swap cache backend with the swap table,
> clean up and add proper kernel doc for all swap cache APIs. Now all swap
> cache APIs are well-defined with consistent names.
>
> No feature change, only renaming and documenting.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/filemap.c        |  2 +-
>  mm/memory-failure.c |  2 +-
>  mm/memory.c         |  2 +-
>  mm/swap.h           | 48 ++++++++++++++-----------
>  mm/swap_state.c     | 86 ++++++++++++++++++++++++++++++++-------------
>  mm/swapfile.c       |  8 ++---
>  mm/vmscan.c         |  2 +-
>  mm/zswap.c          |  2 +-
>  8 files changed, 98 insertions(+), 54 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 344ab106c21c..29ea56999a16 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4517,7 +4517,7 @@ static void filemap_cachestat(struct address_space =
*mapping,
>                                  * invalidation, so there might not be
>                                  * a shadow in the swapcache (yet).
>                                  */
> -                               shadow =3D get_shadow_from_swap_cache(swp=
);
> +                               shadow =3D swap_cache_get_shadow(swp);
>                                 if (!shadow)
>                                         goto resched;
>                         }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b93ab99ad3ef..922526533cd9 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1199,7 +1199,7 @@ static int me_swapcache_clean(struct page_state *ps=
, struct page *p)
>         struct folio *folio =3D page_folio(p);
>         int ret;
>
> -       delete_from_swap_cache(folio);
> +       swap_cache_del_folio(folio);
>
>         ret =3D delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
>         folio_unlock(folio);
> diff --git a/mm/memory.c b/mm/memory.c
> index 5808c4ef21b3..41e641823558 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4699,7 +4699,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>                                 memcg1_swapin(entry, nr_pages);
>
> -                               shadow =3D get_shadow_from_swap_cache(ent=
ry);
> +                               shadow =3D swap_cache_get_shadow(entry);
>                                 if (shadow)
>                                         workingset_refault(folio, shadow)=
;
>
> diff --git a/mm/swap.h b/mm/swap.h
> index a65e72edb087..8b38577a4e04 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -164,17 +164,29 @@ static inline bool folio_matches_swap_entry(const s=
truct folio *folio,
>         return folio->swap.val =3D=3D round_down(entry.val, folio_nr_page=
s(folio));
>  }
>
> +/*
> + * All swap cache helpers below require the caller to ensure the swap en=
tries
> + * used are valid and stablize the device by any of the following ways:
> + * - Hold a reference by get_swap_device(): this ensures a single entry =
is
> + *   valid and increases the swap device's refcount.
> + * - Locking a folio in the swap cache: this ensures the folio's swap en=
tries
> + *   are valid and pinned, also implies reference to the device.
> + * - Locking anything referencing the swap entry: e.g. PTL that protects
> + *   swap entries in the page table, similar to locking swap cache folio=
.
> + * - See the comment of get_swap_device() for more complex usage.
> + */
> +struct folio *swap_cache_get_folio(swp_entry_t entry);
> +void *swap_cache_get_shadow(swp_entry_t entry);
> +int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> +                        gfp_t gfp, void **shadow);
> +void swap_cache_del_folio(struct folio *folio);
> +void __swap_cache_del_folio(struct folio *folio,
> +                           swp_entry_t entry, void *shadow);
> +void swap_cache_clear_shadow(int type, unsigned long begin,
> +                            unsigned long end);
> +
>  void show_swap_cache_info(void);
> -void *get_shadow_from_swap_cache(swp_entry_t entry);
> -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -                     gfp_t gfp, void **shadowp);
> -void __delete_from_swap_cache(struct folio *folio,
> -                             swp_entry_t entry, void *shadow);
> -void delete_from_swap_cache(struct folio *folio);
> -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -                                 unsigned long end);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);
> -struct folio *swap_cache_get_folio(swp_entry_t entry);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>                 struct vm_area_struct *vma, unsigned long addr,
>                 struct swap_iocb **plug);
> @@ -302,28 +314,22 @@ static inline struct folio *swap_cache_get_folio(sw=
p_entry_t entry)
>         return NULL;
>  }
>
> -static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
> +static inline void *swap_cache_get_shadow(swp_entry_t entry)
>  {
>         return NULL;
>  }
>
> -static inline int add_to_swap_cache(struct folio *folio, swp_entry_t ent=
ry,
> -                                       gfp_t gfp_mask, void **shadowp)
> -{
> -       return -1;
> -}
> -
> -static inline void __delete_from_swap_cache(struct folio *folio,
> -                                       swp_entry_t entry, void *shadow)
> +static inline int swap_cache_add_folio(swp_entry_t entry, struct folio *=
folio,
> +                                      gfp_t gfp, void **shadow)
>  {
> +       return -EINVAL;
>  }
>
> -static inline void delete_from_swap_cache(struct folio *folio)
> +static inline void swap_cache_del_folio(struct folio *folio)
>  {
>  }
>
> -static inline void clear_shadow_from_swap_cache(int type, unsigned long =
begin,
> -                               unsigned long end)
> +static inline void __swap_cache_del_folio(swp_entry_t entry, struct foli=
o *folio, void *shadow)
>  {
>  }
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 0ad4f3b41f1b..f3a32a06a950 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -78,8 +78,8 @@ void show_swap_cache_info(void)
>   * Context: Caller must ensure @entry is valid and protect the swap devi=
ce
>   * with reference count or locks.
>   * Return: Returns the found folio on success, NULL otherwise. The calle=
r
> - * must lock and check if the folio still matches the swap entry before
> - * use (e.g. with folio_matches_swap_entry).
> + * must lock nd check if the folio still matches the swap entry before
> + * use (e.g., folio_matches_swap_entry).
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> @@ -90,7 +90,15 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
>         return folio;
>  }
>
> -void *get_shadow_from_swap_cache(swp_entry_t entry)
> +/**
> + * swap_cache_get_shadow - Looks up a shadow in the swap cache.
> + * @entry: swap entry used for the lookup.
> + *
> + * Context: Caller must ensure @entry is valid and protect the swap devi=
ce
> + * with reference count or locks.
> + * Return: Returns either NULL or an XA_VALUE (shadow).
> + */
> +void *swap_cache_get_shadow(swp_entry_t entry)
>  {
>         struct address_space *address_space =3D swap_address_space(entry)=
;
>         pgoff_t idx =3D swap_cache_index(entry);
> @@ -102,12 +110,21 @@ void *get_shadow_from_swap_cache(swp_entry_t entry)
>         return NULL;
>  }
>
> -/*
> - * add_to_swap_cache resembles filemap_add_folio on swapper_space,
> - * but sets SwapCache flag and 'swap' instead of mapping and index.
> +/**
> + * swap_cache_add_folio - Add a folio into the swap cache.
> + * @folio: The folio to be added.
> + * @entry: The swap entry corresponding to the folio.
> + * @gfp: gfp_mask for XArray node allocation.
> + * @shadowp: If a shadow is found, return the shadow.
> + *
> + * Context: Caller must ensure @entry is valid and protect the swap devi=
ce
> + * with reference count or locks.
> + * The caller also needs to mark the corresponding swap_map slots with
> + * SWAP_HAS_CACHE to avoid race or conflict.
> + * Return: Returns 0 on success, error code otherwise.
>   */
> -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -                       gfp_t gfp, void **shadowp)
> +int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> +                        gfp_t gfp, void **shadowp)
>  {
>         struct address_space *address_space =3D swap_address_space(entry)=
;
>         pgoff_t idx =3D swap_cache_index(entry);
> @@ -155,12 +172,20 @@ int add_to_swap_cache(struct folio *folio, swp_entr=
y_t entry,
>         return xas_error(&xas);
>  }
>
> -/*
> - * This must be called only on folios that have
> - * been verified to be in the swap cache.
> +/**
> + * __swap_cache_del_folio - Removes a folio from the swap cache.
> + * @folio: The folio.
> + * @entry: The first swap entry that the folio corresponds to.
> + * @shadow: shadow value to be filled in the swap cache.
> + *
> + * Removes a folio from the swap cache and fills a shadow in place.
> + * This won't put the folio's refcount. The caller has to do that.
> + *
> + * Context: Caller must hold the xa_lock, ensure the folio is
> + * locked and in the swap cache, using the index of @entry.
>   */
> -void __delete_from_swap_cache(struct folio *folio,
> -                       swp_entry_t entry, void *shadow)
> +void __swap_cache_del_folio(struct folio *folio,
> +                           swp_entry_t entry, void *shadow)
>  {
>         struct address_space *address_space =3D swap_address_space(entry)=
;
>         int i;
> @@ -186,27 +211,40 @@ void __delete_from_swap_cache(struct folio *folio,
>         __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
>  }
>
> -/*
> - * This must be called only on folios that have
> - * been verified to be in the swap cache and locked.
> - * It will never put the folio into the free list,
> - * the caller has a reference on the folio.
> +/**
> + * swap_cache_del_folio - Removes a folio from the swap cache.
> + * @folio: The folio.
> + *
> + * Same as __swap_cache_del_folio, but handles lock and refcount. The
> + * caller must ensure the folio is either clean or has a swap count
> + * equal to zero, or it may cause data loss.
> + *
> + * Context: Caller must ensure the folio is locked and in the swap cache=
.
>   */
> -void delete_from_swap_cache(struct folio *folio)
> +void swap_cache_del_folio(struct folio *folio)
>  {
>         swp_entry_t entry =3D folio->swap;
>         struct address_space *address_space =3D swap_address_space(entry)=
;
>
>         xa_lock_irq(&address_space->i_pages);
> -       __delete_from_swap_cache(folio, entry, NULL);
> +       __swap_cache_del_folio(folio, entry, NULL);
>         xa_unlock_irq(&address_space->i_pages);
>
>         put_swap_folio(folio, entry);
>         folio_ref_sub(folio, folio_nr_pages(folio));
>  }
>
> -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -                               unsigned long end)
> +/**
> + * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
> + * @type: Indicates the swap device.
> + * @begin: Beginning offset of the range.
> + * @end: Ending offset of the range.
> + *
> + * Context: Caller must ensure the range is valid and hold a reference t=
o
> + * the swap device.
> + */
> +void swap_cache_clear_shadow(int type, unsigned long begin,
> +                            unsigned long end)
>  {
>         unsigned long curr =3D begin;
>         void *old;
> @@ -393,7 +431,7 @@ struct folio *__read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>                         goto put_and_return;
>
>                 /*
> -                * We might race against __delete_from_swap_cache(), and
> +                * We might race against __swap_cache_del_folio(), and
>                  * stumble across a swap_map entry whose SWAP_HAS_CACHE
>                  * has not yet been cleared.  Or race against another
>                  * __read_swap_cache_async(), which has set SWAP_HAS_CACH=
E
> @@ -412,7 +450,7 @@ struct folio *__read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>                 goto fail_unlock;
>
>         /* May fail (-ENOMEM) if XArray node allocation failed. */
> -       if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MA=
SK, &shadow))
> +       if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM=
_MASK, &shadow))
>                 goto fail_unlock;
>
>         memcg1_swapin(entry, 1);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 367481d319cd..731b541b1d33 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -266,7 +266,7 @@ static int __try_to_reclaim_swap(struct swap_info_str=
uct *si,
>         if (!need_reclaim)
>                 goto out_unlock;
>
> -       delete_from_swap_cache(folio);
> +       swap_cache_del_folio(folio);
>         folio_set_dirty(folio);
>         ret =3D nr_pages;
>  out_unlock:
> @@ -1123,7 +1123,7 @@ static void swap_range_free(struct swap_info_struct=
 *si, unsigned long offset,
>                         swap_slot_free_notify(si->bdev, offset);
>                 offset++;
>         }
> -       clear_shadow_from_swap_cache(si->type, begin, end);
> +       swap_cache_clear_shadow(si->type, begin, end);
>
>         /*
>          * Make sure that try_to_unuse() observes si->inuse_pages reachin=
g 0
> @@ -1288,7 +1288,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp=
)
>          * TODO: this could cause a theoretical memory reclaim
>          * deadlock in the swap out path.
>          */
> -       if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL)=
)
> +       if (swap_cache_add_folio(folio, entry, gfp | __GFP_NOMEMALLOC, NU=
LL))
>                 goto out_free;
>
>         return 0;
> @@ -1758,7 +1758,7 @@ bool folio_free_swap(struct folio *folio)
>         if (folio_swapped(folio))
>                 return false;
>
> -       delete_from_swap_cache(folio);
> +       swap_cache_del_folio(folio);
>         folio_set_dirty(folio);
>         return true;
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ca9e1cd3cd68..c79c6806560b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -776,7 +776,7 @@ static int __remove_mapping(struct address_space *map=
ping, struct folio *folio,
>
>                 if (reclaimed && !mapping_exiting(mapping))
>                         shadow =3D workingset_eviction(folio, target_memc=
g);
> -               __delete_from_swap_cache(folio, swap, shadow);
> +               __swap_cache_del_folio(folio, swap, shadow);
>                 memcg1_swapout(folio, swap);
>                 xa_unlock_irq(&mapping->i_pages);
>                 put_swap_folio(folio, swap);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c88ad61b232c..3dda4310099e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1069,7 +1069,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>
>  out:
>         if (ret && ret !=3D -EEXIST) {
> -               delete_from_swap_cache(folio);
> +               swap_cache_del_folio(folio);
>                 folio_unlock(folio);
>         }
>         folio_put(folio);
> --
> 2.51.0
>
>

