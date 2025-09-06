Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A55CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 07:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2518E0009; Sat,  6 Sep 2025 03:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D625D8E0005; Sat,  6 Sep 2025 03:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50A38E0009; Sat,  6 Sep 2025 03:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE3328E0005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:10:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 103C3140241
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:10:01 +0000 (UTC)
X-FDA: 83857951002.15.07FB522
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A1BD40005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:09:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kvjfXusF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757142599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtzsQqvuUp+QFCjvV0N1l65gDfr+o1tKqFkXFloN05U=;
	b=d5ziMS0HyhKxfuGQIgADvj3UuDxMo6H0midfHXMrLscS6ZvPvFjerGtFGNaJkKAPo5pMeC
	AeNIicOhwCp9OoPPtwWkmhj+e3yyL5Yyz6F6L3HZPPxotfDXGrLQu50M4/Tn1PaayVGqvZ
	+Wym1GXjgPq0fCKgFcS+6JivH2htDkU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kvjfXusF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757142599; a=rsa-sha256;
	cv=none;
	b=d5oissPBC8T7dlWfZDqxuzTUD6Ij5pY7+nat30J/hYomX3REaxdsRaesPB4jxsG3EOZDZZ
	99QI4+ucq6JEM9uwbBbxJxsX9LijUMg4Q/N0h+0CP8flBy7V+Dnd7PfGxftQGbiO/ndRGi
	MHc9A+taBaoBl62nioxVS5CZQs0XIcM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B374A43870
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92516C4CEE7
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757142597;
	bh=Tf/k29nvO+fQos5qe0jaYD2C57//qJ4JQBIphFK/8ek=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kvjfXusFfRhlYDigzMKHMbrSg/UyP7ldtBb0MrUgkIhkrj6fcpyRXy/MXnwaY0mmg
	 YazE8Qgcgid0qwS0KBtYLm7v1oxwRhyQCXHTvcAs1Om7c1wEq7iy8PDDAZ212Ekef1
	 o+qjAUiDqmzqKsyPFJDmpO3PxtvNQsUevzNGoHwPCEyQ0xhfib3cRWQYKUmnadBR+M
	 7xaR2WDRY393l6LamMhl/w4hFhjoIZjJfGZnm6G+0hEg1GG5tYF4rAWeh+9BXWLdQU
	 rA69LpzYrp7yNxmEpgm4dXx5L/quhALlWXrUZznkgbAAbq9XR8dmE+enTEFNvdPrwG
	 IL10l4pZzzJBg==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b886f92ccso45675e9.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 00:09:57 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz5BgH6uGBC+yFoEC81tQ7+My/B4gRRz5zDg5RlQQpK9+MWjkJJ
	3EOkk/duiOYx2gHOyiQ39hEk6+czAtCVVISqf2gCLstL42m/s2dhirsF8eVg4DBG84mcu2ka7f5
	tG+PAsSsBoWsOX9qUNzfUHIL0tT6pfHZT9bbftjN2
X-Google-Smtp-Source: AGHT+IEk3pcPP/qsOuyioVB9KutzSfd7D5HDiSrX+WPJAuZhb1y0hTN/+e6dNsHQV1/ajSG51pgGUmwdRXH6nvz0198=
X-Received: by 2002:a05:600c:8a0c:20b0:43d:409c:6142 with SMTP id
 5b1f17b1804b1-45ddd9f1833mr796345e9.0.1757142596305; Sat, 06 Sep 2025
 00:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-11-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-11-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 6 Sep 2025 00:09:44 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPOTm8e-GLQ=SuQo_CWqjNy05CWFO0nG5OsMbhjjJfXqA@mail.gmail.com>
X-Gm-Features: Ac12FXzj4LpxyTh54HO3g2hi0SCO66oy7pinB7gE8honvJ1AVinfu5BU57zJIPo
Message-ID: <CAF8kJuPOTm8e-GLQ=SuQo_CWqjNy05CWFO0nG5OsMbhjjJfXqA@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a helper
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A1BD40005
X-Stat-Signature: e3mgqutwypu6sp9d9idnopunq97qrteo
X-Rspam-User: 
X-HE-Tag: 1757142598-320309
X-HE-Meta: U2FsdGVkX1+nAtTEHi1a6cvH3hEFAnxmLmPbErzSURQqf42MExCCe2VHP2MVbltqKfOmjpp7xUqyNFRTyx8r8xM7i0bOoPbd2Hq3R9iwewsGmHAk+VgvgrXT/zfhVbzgDhLSF033oOrypE5OoJDmDnkaGadakjJlZsl5GxMpq18XyD+/UeuTl2eAmCLBaD/feKqWovLJTezUd031u3d1m9mYUddWto+EPXjiPowutDBLKGXKeGdxUnivnis9TakYSCX7hYzh9C4G6B17VYvXVtJte5tRfgYyTSZY1wmGVxOEQGjIgC0lcWWePbs6bK9Fm7F6f0x8hIqtwXUlqWZrYiE3RjaTP9nyG3f4Cd0X1+6VnEK+2gznG0mjct+kqP1xeWU1/919KpMKJejVdvUos4mTBUA9hlBFt5hptwIISsh4OrFB5KG5ITq3t3w1Y7gxfGVPLwZm+R8w2VcgZV6AhUzplcrrbnZuua3bUgXhDF3QlyHGssBLCwv3cOXIuHsTDOUlUF2byfHLFFy3fIQ5hQkuBAHRHTBF7AbSNfwOGM51R5BVQF5dF/PED9eYhjFDKGmaE4qfWtl4j0N+L7q7fjzNPhOjSkQsRWck15OH2BtVT0eMZ62LH808sGfRntP9sNidi+FJ8MVWx/fEPtm0LatV/aGVGpX0V1SL8zxZvrenfEjYRr/9Ug97XJUK8YoVinfbiCyR2yuPt59g0AndaXpiE7rdOqYrr/OB9SWKKjKCLKaT3DwqvSZXOFsuM8Xks3P2+A3FgLR3d5QDMbGPTyt96Z/fKpA85+z1elyLsc1vNMl9aZoYgONeMV4E7otm9aYA+Q9ZFoX02Kdbv1C2pT05f7tgYX7h6/jyuFpfF5nINlaRySDJN+VboiZjheqvJma3/ofsXz6v4yPzuwBz9J6VFgn3SnrVaysx5rPzVBZR6ZfH5Q8kycoZ6llwx9rRBnU/xVd4mGId1nIaMDT
 EpB+RNci
 +0QJJ4Sv0YRaS2QQLATOMtsiavQKaWX9z1U5aT9iD5k+gprsYoU4fpiHfsJ75OA4bIC6XQckB6ENeXwMsbjHSEpqsyP7quucA9DHGEK1PxMF9Q3EwPhtVk04gRGzY0stuVoEdxN/1ryX0vSmmv2JkuJSl1gXVcyuLqwImf3XBRjasld17Qmh5vHran2NNjhbPxM3S2GLDYBPLn+0A7vQx8K7HVWyo7+Y9Yqynpvf3Qtjfkuj8jxha55K+OuTC0sW7BcJBEg9K5sBb0/fWCUHis9ue7DOxwEdj5eSKGUtXIGivgwsWvWgg3lkK1qhgkIEBAF9a9473H78HaVe06E15hrpxtznSo5bBhZq9LwdDEvDLZKE=
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
> There are currently three swap cache users that are trying to replace an
> existing folio with a new one: huge memory splitting, migration, and
> shmem replacement. What they are doing is quite similar.
>
> Introduce a common helper for this. In later commits, they can be easily
> switched to use the swap table by updating this helper.
>
> The newly added helper also makes the swap cache API better defined, and
> debugging is easier.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c |  5 ++---
>  mm/migrate.c     | 11 +++--------
>  mm/shmem.c       | 10 ++--------
>  mm/swap.h        |  3 +++
>  mm/swap_state.c  | 32 ++++++++++++++++++++++++++++++++
>  5 files changed, 42 insertions(+), 19 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd7418..a4d192c8d794 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3798,9 +3798,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>                          * NOTE: shmem in swap cache is not supported yet=
.
>                          */
>                         if (swap_cache) {
> -                               __xa_store(&swap_cache->i_pages,
> -                                          swap_cache_index(new_folio->sw=
ap),
> -                                          new_folio, 0);
> +                               __swap_cache_replace_folio(swap_cache, ne=
w_folio->swap,
> +                                                          folio, new_fol=
io);
>                                 continue;
>                         }
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8e435a078fc3..7e1d01aa8c85 100644
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
> +               __swap_cache_replace_folio(mapping, folio->swap, folio, n=
ewfolio);
> +       else
>                 xas_store(&xas, newfolio);
> -               xas_next(&xas);
> -       }
>
>         /*
>          * Drop cache reference from old folio by unfreezing
> diff --git a/mm/shmem.c b/mm/shmem.c
> index cc6a0007c7a6..823ceae9dff8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2123,10 +2123,8 @@ static int shmem_replace_folio(struct folio **foli=
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
> @@ -2155,12 +2153,8 @@ static int shmem_replace_folio(struct folio **foli=
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
> +       __swap_cache_replace_folio(swap_mapping, entry, old, new);
>         xa_unlock_irq(&swap_mapping->i_pages);
>
>         mem_cgroup_replace_folio(old, new);
> diff --git a/mm/swap.h b/mm/swap.h
> index 8b38577a4e04..a139c9131244 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -182,6 +182,9 @@ int swap_cache_add_folio(struct folio *folio, swp_ent=
ry_t entry,
>  void swap_cache_del_folio(struct folio *folio);
>  void __swap_cache_del_folio(struct folio *folio,
>                             swp_entry_t entry, void *shadow);
> +void __swap_cache_replace_folio(struct address_space *address_space,
> +                               swp_entry_t entry,
> +                               struct folio *old, struct folio *new);
>  void swap_cache_clear_shadow(int type, unsigned long begin,
>                              unsigned long end);
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index f3a32a06a950..38f5f4cf565d 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -234,6 +234,38 @@ void swap_cache_del_folio(struct folio *folio)
>         folio_ref_sub(folio, folio_nr_pages(folio));
>  }
>
> +/**
> + * __swap_cache_replace_folio - Replace a folio in the swap cache.
> + * @mapping: Swap mapping address space.
> + * @entry: The first swap entry that the new folio corresponds to.
> + * @old: The old folio to be replaced.
> + * @new: The new folio.
> + *
> + * Replace a existing folio in the swap cache with a new folio.
> + *
> + * Context: Caller must ensure both folios are locked, and lock the
> + * swap address_space that holds the entries to be replaced.
> + */
> +void __swap_cache_replace_folio(struct address_space *mapping,
> +                               swp_entry_t entry,
> +                               struct folio *old, struct folio *new)
> +{
> +       unsigned long nr_pages =3D folio_nr_pages(new);
> +       unsigned long offset =3D swap_cache_index(entry);
> +       unsigned long end =3D offset + nr_pages;
> +       XA_STATE(xas, &mapping->i_pages, offset);
> +
> +       VM_WARN_ON_ONCE(entry.val !=3D new->swap.val);
> +       VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new=
));
> +       VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcac=
he(new));
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
>

