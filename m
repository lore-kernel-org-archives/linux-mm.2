Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2ADCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D6B8E0023; Mon, 15 Sep 2025 11:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06C68E0001; Mon, 15 Sep 2025 11:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7818E0023; Mon, 15 Sep 2025 11:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9426F8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:09:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AF83C06C8
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:09:43 +0000 (UTC)
X-FDA: 83891819046.14.3F78930
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21FD4180002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:09:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MnOB47F2;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+KzLcfyJT+GLzwBTtuIjKD4F5pNqAdImurMkZObDEc=;
	b=t1KS3XgKgJhq+AUugrvmeFF3XdZESJrd+xYfcmtjdFVhDCPBed7gyAuUmPgKbnO0pB8Vx/
	+in6UGaqGAlW/1YuQ13oG6BoFPSros5MLsst/X6d/JKt7eyymMc+3HwwnWVpkATxt/HH/K
	6u4LnK2rG6NPyH70S61RsLbFZQDp504=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MnOB47F2;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948981; a=rsa-sha256;
	cv=none;
	b=NfUr6cR2xMbI/JiFXvlzwzyUrwB5Dz8w6nSMK3/DcZ0a4a0RrPgidYhVB4SgFt9lIbqjFY
	0kd0Kq1UnQfVrLj4bELkWY/iSHmujmROov/+OD0lzOVYRsk8euywfJNoxTpoSyk9qSdcRJ
	pqKPQfeqnRwnTuirYsGG78oPAyQxoaY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1121A43A81
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E73C4CEF9
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757948979;
	bh=sAILtEQ6hGjB1SZc5TaU5PYDq7RHDNmXbwdIprhruRw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MnOB47F25pAVMRV7B7hOz+/+mz8iKxW4EC1uh2wRJouQGxZ8db9vC80o7Mj0Bcpzc
	 78sBKRFywdV0HEO5N0KRUHTEeidc2pFutLjUOqTRlnJh3a5e6OLve0pQbYvPEKcNk+
	 jr/cJzlITPy3WMtZ0BPLskDEXI0ndTO0/ZhyDln/opdykVUfOtRbuMOaXZLPnflZUQ
	 dsKY0Ytk5+RszljahsY2Bcu0juZU/ngjxGIjupJDtMdOnLtlmdvxOcGvPobcOiRzsT
	 cPep2YVYK/TETJYRHh306VuADIXZjwjkJwykO/7+6U25dnrm+OcL4lpJXFOX+Q+uhq
	 MypiuGG5z/9BA==
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso20877275e9.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:09:39 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy+F67cG0vPdcYIgT7/TrdgwpP+gpndfGBX6QOoGpVrrEGtQXEw
	caVuVhjHdgPm2XDD5bWCWpPlDYeDCLpzg6TvY+/zvWvAT2pBLGQBwgVlUlXJcV6F6Zmm3yTkR0S
	ckabk7dIaHnw9L3I0axq+IgDyWsMRoQAtQVxJekQOQg==
X-Google-Smtp-Source: AGHT+IFZcDUDotIs1MFDsw2dmuzKjvdCb4zDoIEg+yTNJzNFpyVIBaetpEjE4dOCgEJV2HI6RJBat69v2VCnXmjopK4=
X-Received: by 2002:a5d:55c6:0:b0:3e7:d909:4c1c with SMTP id
 ffacd0b85a97d-3e7d9094ccemr8362992f8f.11.1757948978654; Mon, 15 Sep 2025
 08:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-11-ryncsn@gmail.com>
In-Reply-To: <20250910160833.3464-11-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 15 Sep 2025 08:09:26 -0700
X-Gmail-Original-Message-ID: <CACePvbUM1-xmgttL5R06qrULDq_eiHT0jPRpcfrZJX2ch6tZSg@mail.gmail.com>
X-Gm-Features: AS18NWBTpBv2ceo-93-keDns1VW92yPyG7W7vfAHNpWFmTjFfAIjeCnq2vHXyIM
Message-ID: <CACePvbUM1-xmgttL5R06qrULDq_eiHT0jPRpcfrZJX2ch6tZSg@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] mm, swap: wrap swap cache replacement with a helper
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 21FD4180002
X-Stat-Signature: kqkxi4ziowi6szu49kssiws1qm4fp8z1
X-HE-Tag: 1757948980-437781
X-HE-Meta: U2FsdGVkX19UGjC3q3WBGIZA3jR9vUZAta53DcDzFczFAQMccqOgcBjPa9DozvULXXwnkLOy7+9P0WSJHWS4iSmOICUIMlv8PCQ7fzF5siaXh2sBFgSgdVZys9GQIWBaTvm0MvLQjj4aYUs458qxZaozeSzEsxYhh5RtqxcfAIqrl5Er5LxddtqoZvOfPah6LJ+XgeGHIEHX1V4tt9qqx1zTopK7yukyZvC2VE4bsDCsaCCDrhOR+ZP0LNME2Dt6WuhQKexCzBkau4Qsjco9gBhP38AJuomOrYiD7ULIJdZUgqbXvkrfvLZKKH2Rjse+HCFg9f96RY8irAUN3LNIC9Ys5XwAbCE46IW8WL3M2l95WZhIf39OVmNpFyC6NIcOwtipLjjdMn2VFa/Wgt17PJVsTNhx3RhrJJFCGY257kpSAT+kcJABvFBKyPBjtWWc3jwq6u44ddj9Kq2p+3K7Y9+ouKHwGmliq1mxErZmug9L/3tR3vCiEjh2JsOTF/pz73r7Ji11rE/+xDMArMvbe97toAQgU9LrO2ZxqRpteJ8Pb5h3AnDZC0FkR/IwJTkTzdBuVT+l+4rVqacpDZwgYlf5trm/ZZXbIOqMtgfzg1fNPEjW61nWsJcTzcNcMhRm3/z6PXE5IO7qI5JVYlYZI0ixSg/w+FSR/fYQxiIXEeYvNoAdP0tOLrBfIYLBOdaTGzFJkkA96kkmYe9I+kfgCEYdsmfKIF1C+zbutvPEaimPZZrV4AtNByxIv2C8A/Yo0aDTMAonvO2GCM0iwv8I+/gTCTpmV8qrc9NbRMnudSO5shkDvpQRGP7ZEZhPpNo2l417BNfAdVNHmXbmDYudhsueuxvvnM9i0XYwbadgNNrRp1MupinD/zCUW6Pco5ox11QdWKWNnYpyYfVjTf1IB3g7rDLF326/kpph3JIJ5BJChtUY8EvjR0l/m3D0Pbopw1OJYEplEKgQbJ3Ckop
 UYrF8W+O
 TTrzvdoHK9u6E5buXFteeiGhDgD5rtmJeqIppxkTuUPjwu3MkSoVJgFOSLka+FVEGXPVBjVeEkWbVB6d2QJtkG8W7WPmAHu1zm8tJ8yOZF0p1qtkG07A8tAtSjnhrR5wh6tnxNqLA82pKxnZQ+NMxIiwQQjuc6oIHeQiR8eF+VUPO3j2Kgf3BkQoHX5svVZAPBDhVO97UmEWfNYZD/q7fxM+ZjITlBqk+sohhUV8+4qonL6xy5tuMCuDIIqhsBwtP9gi60n6Jhily3uzXUuwMG2D1TzKNkwfXCWmKPojpZkqDTU88TF+Krk5C8dH+YWrEmulIWohsoBzJs2y6VWS90AC7EZN9CVjeP47RK5oFCnKT01GHDYmJKpebCtgSSZ1Iu06F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Wed, Sep 10, 2025 at 9:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> There are currently three swap cache users that are trying to replace an
> existing folio with a new one: huge memory splitting, migration, and
> shmem replacement. What they are doing is quite similar.
>
> Introduce a common helper for this. In later commits, this can be easily
> switched to use the swap table by updating this helper.
>
> The newly added helper also makes the swap cache API better defined, and
> make debugging easier by adding a few more debug checks.
>
> Migration and shmem replace are meant to clone the folio, including
> content, swap entry value, and flags. And splitting will adjust each
> sub folio's swap entry according to order, which could be non-uniform in
> the future. So document it clearly that it's the caller's responsibility
> to set up the new folio's swap entries and flags before calling the helpe=
r.
> The helper will just follow the new folio's entry value.
>
> This also prepares for replacing high-order folios in the swap cache.
> Currently, only splitting to order 0 is allowed for swap cache folios.
> Using the new helper, we can handle high-order folio splitting better.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/huge_memory.c |  4 +---
>  mm/migrate.c     | 11 +++--------
>  mm/shmem.c       | 10 ++--------
>  mm/swap.h        |  5 +++++
>  mm/swap_state.c  | 33 +++++++++++++++++++++++++++++++++
>  5 files changed, 44 insertions(+), 19 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd7418..4c66e358685b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3798,9 +3798,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>                          * NOTE: shmem in swap cache is not supported yet=
.
>                          */
>                         if (swap_cache) {
> -                               __xa_store(&swap_cache->i_pages,
> -                                          swap_cache_index(new_folio->sw=
ap),
> -                                          new_folio, 0);
> +                               __swap_cache_replace_folio(folio, new_fol=
io);
>                                 continue;
>                         }
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8e435a078fc3..c69cc13db692 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -566,7 +566,6 @@ static int __folio_migrate_mapping(struct address_spa=
ce *mapping,
>         struct zone *oldzone, *newzone;
>         int dirty;
>         long nr =3D folio_nr_pages(folio);
> -       long entries, i;
>
>         if (!mapping) {
>                 /* Take off deferred split queue while frozen and memcg s=
et */
> @@ -615,9 +614,6 @@ static int __folio_migrate_mapping(struct address_spa=
ce *mapping,
>         if (folio_test_swapcache(folio)) {
>                 folio_set_swapcache(newfolio);
>                 newfolio->private =3D folio_get_private(folio);
> -               entries =3D nr;
> -       } else {
> -               entries =3D 1;
>         }
>
>         /* Move dirty while folio refs frozen and newfolio not yet expose=
d */
> @@ -627,11 +623,10 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
>                 folio_set_dirty(newfolio);
>         }
>
> -       /* Swap cache still stores N entries instead of a high-order entr=
y */
> -       for (i =3D 0; i < entries; i++) {
> +       if (folio_test_swapcache(folio))
> +               __swap_cache_replace_folio(folio, newfolio);
> +       else
>                 xas_store(&xas, newfolio);
> -               xas_next(&xas);
> -       }
>
>         /*
>          * Drop cache reference from old folio by unfreezing
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5f395fab489c..8930780325da 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2086,10 +2086,8 @@ static int shmem_replace_folio(struct folio **foli=
op, gfp_t gfp,
>         struct folio *new, *old =3D *foliop;
>         swp_entry_t entry =3D old->swap;
>         struct address_space *swap_mapping =3D swap_address_space(entry);
> -       pgoff_t swap_index =3D swap_cache_index(entry);
> -       XA_STATE(xas, &swap_mapping->i_pages, swap_index);
>         int nr_pages =3D folio_nr_pages(old);
> -       int error =3D 0, i;
> +       int error =3D 0;
>
>         /*
>          * We have arrived here because our zones are constrained, so don=
't
> @@ -2118,12 +2116,8 @@ static int shmem_replace_folio(struct folio **foli=
op, gfp_t gfp,
>         new->swap =3D entry;
>         folio_set_swapcache(new);
>
> -       /* Swap cache still stores N entries instead of a high-order entr=
y */
>         xa_lock_irq(&swap_mapping->i_pages);
> -       for (i =3D 0; i < nr_pages; i++) {
> -               WARN_ON_ONCE(xas_store(&xas, new));
> -               xas_next(&xas);
> -       }
> +       __swap_cache_replace_folio(old, new);
>         xa_unlock_irq(&swap_mapping->i_pages);
>
>         mem_cgroup_replace_folio(old, new);
> diff --git a/mm/swap.h b/mm/swap.h
> index 6c4acb549bec..fe579c81c6c4 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -185,6 +185,7 @@ int swap_cache_add_folio(struct folio *folio, swp_ent=
ry_t entry,
>  void swap_cache_del_folio(struct folio *folio);
>  void __swap_cache_del_folio(struct folio *folio,
>                             swp_entry_t entry, void *shadow);
> +void __swap_cache_replace_folio(struct folio *old, struct folio *new);
>  void swap_cache_clear_shadow(int type, unsigned long begin,
>                              unsigned long end);
>
> @@ -336,6 +337,10 @@ static inline void __swap_cache_del_folio(struct fol=
io *folio, swp_entry_t entry
>  {
>  }
>
> +static inline void __swap_cache_replace_folio(struct folio *old, struct =
folio *new)
> +{
> +}
> +
>  static inline unsigned int folio_swap_flags(struct folio *folio)
>  {
>         return 0;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index f3a32a06a950..d1f5b8fa52fc 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -234,6 +234,39 @@ void swap_cache_del_folio(struct folio *folio)
>         folio_ref_sub(folio, folio_nr_pages(folio));
>  }
>
> +/**
> + * __swap_cache_replace_folio - Replace a folio in the swap cache.
> + * @old: The old folio to be replaced.
> + * @new: The new folio.
> + *
> + * Replace an existing folio in the swap cache with a new folio. The
> + * caller is responsible for setting up the new folio's flag and swap
> + * entries. Replacement will take the new folio's swap entry value as
> + * the starting offset to override all slots covered by the new folio.
> + *
> + * Context: Caller must ensure both folios are locked, also lock the
> + * swap address_space that holds the old folio to avoid races.
> + */
> +void __swap_cache_replace_folio(struct folio *old, struct folio *new)
> +{
> +       swp_entry_t entry =3D new->swap;
> +       unsigned long nr_pages =3D folio_nr_pages(new);
> +       unsigned long offset =3D swap_cache_index(entry);
> +       unsigned long end =3D offset + nr_pages;
> +
> +       XA_STATE(xas, &swap_address_space(entry)->i_pages, offset);
> +
> +       VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcac=
he(new));
> +       VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new=
));
> +       VM_WARN_ON_ONCE(!entry.val);
> +
> +       /* Swap cache still stores N entries instead of a high-order entr=
y */
> +       do {
> +               WARN_ON_ONCE(xas_store(&xas, new) !=3D old);
> +               xas_next(&xas);
> +       } while (++offset < end);
> +}
> +
>  /**
>   * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
>   * @type: Indicates the swap device.
> --
> 2.51.0
>

