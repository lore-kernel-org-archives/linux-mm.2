Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E348CF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38C56B0005; Mon, 12 Jan 2026 13:34:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18DC6B0088; Mon, 12 Jan 2026 13:34:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EDF06B0089; Mon, 12 Jan 2026 13:34:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7721C6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:34:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15EBCD1897
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:34:17 +0000 (UTC)
X-FDA: 84324161754.17.81018B0
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 245501C000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:34:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TnOg6u8N;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768242855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALzQEag/3IkdP26veAzm4gdmUokDavOHiGzMlC+FJ+4=;
	b=c7PLjBy+k3OBC+AnOBvYwcCIwaTNP5XCQKqpuV4GFisN6Ajh3+gZEj7mqKn6s+doALGYGK
	GnrZxfXgLPoGCh2p4vd4TaSPaO9Is0lqzjVwN1994MDN8EE5277pn78gbiNUYcsaji8EZ3
	LUuj3pyPG9jDVNgceilcjJOOIi/TEao=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TnOg6u8N;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768242855; a=rsa-sha256;
	cv=none;
	b=EhMDef69elyfiDGsOL2+xUnEE1wJfIU3ZUol5cJEavsJLnhulIG9NZeBQZggdEoCLQZE+0
	RRCYe/V1VUamgsspQpsfQ/7iaUaLIfsbcKnyAn1Aife3DBGfxyZoeK6xcw+p9zu9jbEFFX
	2CURXFjBqRXMXAsuhkfk//tqpVFadAc=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b87108066c3so217998866b.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768242853; x=1768847653; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALzQEag/3IkdP26veAzm4gdmUokDavOHiGzMlC+FJ+4=;
        b=TnOg6u8Nh7uVOF9K8mDTsfIg6UIpHUKdA7Sh7uABYvKed68drH8Cz2kjoOags0pk5e
         cpU3CqH2DXjK2JL3up0NLCRT5EmXYNkco+Q6hVjsoYyHXedceTlhnPhrl3ZSiKnDyUun
         thhlYk0PRbdlwqA/XlEvM+o4uBOb9yCV2p12nVJfA+Hx5Mc6xsnoSSxn4+tYIqHWMlMH
         Rixnm/15DaEZ8IgrgAwL33H8t/nTPv8Aqvf3u1tIFiCU0FjPEXoZ4zeHo6EADssBGOm2
         Zz10pjCkFpLA2tlV1E/CF6EoA9rVzRNx0/dqVTRvpQtva7llxa4uIImarPw9q0fnjJ5h
         SUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242853; x=1768847653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ALzQEag/3IkdP26veAzm4gdmUokDavOHiGzMlC+FJ+4=;
        b=iUMfP/wyYO58HQoE/acf2BnYFk5HcEOwC2BjMXFNKQSD7aH6kYnOMMyK+AdVlv4UY0
         6zFVCX3ulDVCgd+slXAHENJt++mqBstbSW4pDqDFceBysQhWRU8lzG99hNIZXAGDgyWv
         09jCqVnSxU+Ixydr4FB9UOBuCITONtlBt0hU5SJpgP3I175UAFdRKFU4StOAvtcZGc7i
         Dzm5yNWIlJTXAn7nthGUqJVRcR8dtOCzqFYcmAwlQpkF9bLFp2oCM5C1AP7VcVACFQpJ
         dNTSOlWKOY6SPRP2PJVOAhdmJM8s3cvik5UQp78tYNTjQ4/QR0tZf6OJpAzy98WujMrT
         jL4A==
X-Gm-Message-State: AOJu0Yxcc+l242yJpUn6nGiFXMN2ODeEigw42Feq7tkClXrxOiv0RHqK
	RruWuRSLabwXPzXVL4wwaLAtawSVRWE/c31bIKaSjcBr4PyeQZLVVZnFu1RvAOgpeUcIHLDcTdJ
	fde/jampHqYuQyRFQd2E0wDUrY/18IZI=
X-Gm-Gg: AY/fxX6/8T4jK8B5o6vk22Y+4f+DtUxtpn11/lOzwWDt+yzFtTI9lPdbkEKkeqS2RfE
	D9evWlOaomEyDNW0tswSFrlqkUBj31AB00F3fNMFNp5Se8x8KixvJLJiwmEfLu5jruJDIBZmNpb
	2DJDI5KZIJNxpXtES5qT6+AGuqNFHUsD9JY3rvS3tmKK5QnWln+pHkv4WLxX0EQakMyShmPavvY
	4Ms5xpalOyRtk5J7Zcet1XjM8FlzNxThX3yr4TaUDc110yAvUoZOzat0xOq9L32xK/lykqaKx3R
	HlESHzSPuxxVRxSUyNpd1zOYDgs5
X-Google-Smtp-Source: AGHT+IEqLDJpQQ+3NWQ/66fLKJAgWkkt4DAUP/NpEfuwi6UfrMbmWJethD3Ycm9mZv3/k5TEd0//DCqaFKK52lP5HDs=
X-Received: by 2002:a17:907:60d3:b0:b87:1b62:13bf with SMTP id
 a640c23a62f3a-b871b621507mr356026766b.55.1768242853239; Mon, 12 Jan 2026
 10:34:13 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com> <20251220-swap-table-p2-v5-12-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-12-8862a265a033@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 13 Jan 2026 02:33:36 +0800
X-Gm-Features: AZwV_Qiwb8h5yPjtK1J1Dy332N1X89eEQc5v5SSFyaJymaU8OdYLJIv2wLLVkHw
Message-ID: <CAMgjq7CGUnzOVG7uSaYjzw9wD7w2dSKOHprJfaEp4CcGLgE3iw@mail.gmail.com>
Subject: Re: [PATCH v5 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Deepanshu Kartikey <kartikey406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 245501C000E
X-Stat-Signature: msksc338d7qq5o4mte5ikscz1yt78cwi
X-HE-Tag: 1768242854-116799
X-HE-Meta: U2FsdGVkX19pZn+pM1STKB84Pme/LfSzPufhn8fYVevvEJttBp/WS4hyGOVaAtBLoANlABcZivGbrwncRL3FKyW5OTQNxfRkNUc+hrqKPV/g5j1JM01EQpEPfFG8N33akAjAxOn7AUQbF0wIvx/brk5tP+i96ml7xj4GbCQV6JUSu5/Gw8ukWNdbJFaPia3N9Zurym0O9nzzH+MDxYd27dtv/Jlnu9CTLcYK0/hG7wwW9q2WhrSAv5FNsCb5R9QuTt/BUUX5suo6u69fSai2bYUXDdhwiiEFlDLu9ltRYxGI+IcR/+KFyjVmv7F2AF7WgULHOvgdhRR8HBy203UdMy4Ttmg+WlBxeqcJ4x+zpti9pf98mPM035EH+9XoyXag9yPLh80EKN1U4784XsCcO8dzMI7eQtiyWgwDMooGoHHj9inpyiahKq9V1Yo00yag++KYIqLWdRt4/ciTkDD6AZ3gl+twgFQeSI+/nrWmi9AuVDBkMBAleG2OWASoseYvkzhORv7egGZzzOx3vgEfltz+MTGhRFxMKXGc4yEgaCaQxh2Cblrzk/zgL9ZFFtOF6p2rtlMJMD2cynelnrzKcO6MQbqR8r3/Eoh/2oXNM9U/EafJ60K+d5N+3OLTnHgNJzxxiPmx3SwDLoTQArtYEfFvLoNF6MPUC+3sSPYIDbgF5HmNm1wVqa82BfnqL6byDdsSdQ7vxpvEyhYP7pZodRrZF2PzuckSNpthLy8rHd5rFUb2jmzp8lsoaAp44RcLMJviIPA7Efcbk1REqg72HDdH8U5C5fC5kRqfRaPwnx5ZMroa2ohOgqAiVhP2XIcOtqNc7nrYFy4mMRvAIrWZAXG7nX3ghIxSksMnitt8RCvXUsl5eh88rC7wuYe2bwVl1wOqw+mtWqF9RXUvo79+Brc+AVxMHHfRDhi4G/4VQTASYUeUmZmuStJvT0u6o8Z1JKrOqqOsE8FeYZPVLMP
 BuaR4hAY
 lk1cvO+KdRWW1JTscbg8PTMUkj1sAh+p4sBetL3nNAO3if08USliCGJlJyFf1tr5DCNHe3VUbB+sB85Wrk/Ei4PtIB5o2uHSYLeI7e+hWjxVcDqAJKLnbz/gOQ3pW2u0kWBhWwIfqJTVBPtnuhH4qZ7aqo1Wvmtys7x6RytZZIDyHTpvAVr+/t2qarFn1t7/vT6SKby94xed0Dz8wj/18ubt2RolRh13Cf4IHfFNv+eaRoXmAHqSi/58qYl9uBl6OhnhuWz+R1I6rQAivODmypHyEgJDzgAxqPUJU6HLRklAFmAx2e9p6goiSsKi4HuUdvA1WIpF/wJ53EYNlSjlF2bEy5EOR7UBmhtXWd992TapPnIcSFM7/MeBRKX61o1ZIIHK/JUtDv2ITNS+LbHlOrt4xANDuy3Wjk3oOMpbLZlQPzVISQ86ArhKt9gbx3t/TlA4lVAq2TQhesPFr9mw4Pv8Cn4DkHfdfziE3JJfVe5FRUPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 3:45=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Current swap in synchronization mostly uses the swap_map's
> SWAP_HAS_CACHE bit. Whoever sets the bit first does the actual
> work to swap in a folio.
>
> This has been causing many issues as it's just a poor implementation
> of a bit lock. Raced users have no idea what is pinning a slot, so
> it has to loop with a schedule_timeout_uninterruptible(1), which is
> ugly and causes long-tailing or other performance issues. Besides,
> the abuse of SWAP_HAS_CACHE has been causing many other troubles for
> synchronization or maintenance.
>
> This is the first step to remove this bit completely.
>
> Now all swap in paths are using the swap cache, and both the swap cache
> and swap map are protected by the cluster lock. So we can just resolve
> the swap synchronization with the swap cache layer directly using the
> cluster lock and folio lock. Whoever inserts a folio in the swap cache
> first does the swap in work. And because folios are locked during swap
> operations, other raced swap operations will just wait on the folio
> lock.
>
> The SWAP_HAS_CACHE will be removed in later commit. For now, we still set
> it for some remaining users. But now we do the bit setting and swap cache
> folio adding in the same critical section, after swap cache is ready.
> No one will have to spin on the SWAP_HAS_CACHE bit anymore.
>
> This both simplifies the logic and should improve the performance,
> eliminating issues like the one solved in commit 01626a1823024
> ("mm: avoid unconditional one-tick sleep when swapcache_prepare fails"),
> or the "skip_if_exists" from commit a65b0e7607ccb
> ("zswap: make shrinking memcg-aware"), which will be removed very soon.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h |   6 ---
>  mm/swap.h            |  15 +++++++-
>  mm/swap_state.c      | 105 ++++++++++++++++++++++++++++-----------------=
------
>  mm/swapfile.c        |  39 ++++++++++++-------
>  mm/vmscan.c          |   1 -
>  5 files changed, 96 insertions(+), 70 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index bf72b548a96d..74df3004c850 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -458,7 +458,6 @@ void put_swap_folio(struct folio *folio, swp_entry_t =
entry);
>  extern swp_entry_t get_swap_page_of_type(int);
>  extern int add_swap_count_continuation(swp_entry_t, gfp_t);
>  extern int swap_duplicate_nr(swp_entry_t entry, int nr);
> -extern int swapcache_prepare(swp_entry_t entry, int nr);
>  extern void swap_free_nr(swp_entry_t entry, int nr_pages);
>  extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
>  int swap_type_of(dev_t device, sector_t offset);
> @@ -517,11 +516,6 @@ static inline int swap_duplicate_nr(swp_entry_t swp,=
 int nr_pages)
>         return 0;
>  }
>
> -static inline int swapcache_prepare(swp_entry_t swp, int nr)
> -{
> -       return 0;
> -}
> -
>  static inline void swap_free_nr(swp_entry_t entry, int nr_pages)
>  {
>  }
> diff --git a/mm/swap.h b/mm/swap.h
> index e0f05babe13a..b5075a1aee04 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -234,6 +234,14 @@ static inline bool folio_matches_swap_entry(const st=
ruct folio *folio,
>         return folio_entry.val =3D=3D round_down(entry.val, nr_pages);
>  }
>
> +/* Temporary internal helpers */
> +void __swapcache_set_cached(struct swap_info_struct *si,
> +                           struct swap_cluster_info *ci,
> +                           swp_entry_t entry);
> +void __swapcache_clear_cached(struct swap_info_struct *si,
> +                             struct swap_cluster_info *ci,
> +                             swp_entry_t entry, unsigned int nr);
> +
>  /*
>   * All swap cache helpers below require the caller to ensure the swap en=
tries
>   * used are valid and stablize the device by any of the following ways:
> @@ -247,7 +255,8 @@ static inline bool folio_matches_swap_entry(const str=
uct folio *folio,
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
> -void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void *=
*shadow);
> +int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> +                        void **shadow, bool alloc);
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
>                                      struct mempolicy *mpol, pgoff_t ilx,
> @@ -413,8 +422,10 @@ static inline void *swap_cache_get_shadow(swp_entry_=
t entry)
>         return NULL;
>  }
>
> -static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t=
 entry, void **shadow)
> +static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t =
entry,
> +                                      void **shadow, bool alloc)
>  {
> +       return -ENOENT;
>  }
>
>  static inline void swap_cache_del_folio(struct folio *folio)
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b7a36c18082f..57311e63efa5 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -128,34 +128,64 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>   * @entry: The swap entry corresponding to the folio.
>   * @gfp: gfp_mask for XArray node allocation.
>   * @shadowp: If a shadow is found, return the shadow.
> + * @alloc: If it's the allocator that is trying to insert a folio. Alloc=
ator
> + *         sets SWAP_HAS_CACHE to pin slots before insert so skip map up=
date.
>   *
>   * Context: Caller must ensure @entry is valid and protect the swap devi=
ce
>   * with reference count or locks.
> - * The caller also needs to update the corresponding swap_map slots with
> - * SWAP_HAS_CACHE bit to avoid race or conflict.
>   */
> -void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void *=
*shadowp)
> +int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> +                        void **shadowp, bool alloc)
>  {
> +       int err;
>         void *shadow =3D NULL;
> +       struct swap_info_struct *si;
>         unsigned long old_tb, new_tb;
>         struct swap_cluster_info *ci;
> -       unsigned int ci_start, ci_off, ci_end;
> +       unsigned int ci_start, ci_off, ci_end, offset;
>         unsigned long nr_pages =3D folio_nr_pages(folio);
>
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
>
> +       si =3D __swap_entry_to_info(entry);
>         new_tb =3D folio_to_swp_tb(folio);
>         ci_start =3D swp_cluster_offset(entry);
>         ci_end =3D ci_start + nr_pages;
>         ci_off =3D ci_start;
> -       ci =3D swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(=
entry));
> +       offset =3D swp_offset(entry);
> +       ci =3D swap_cluster_lock(si, swp_offset(entry));
> +       if (unlikely(!ci->table)) {
> +               err =3D -ENOENT;
> +               goto failed;
> +       }
>         do {
> -               old_tb =3D __swap_table_xchg(ci, ci_off, new_tb);
> -               WARN_ON_ONCE(swp_tb_is_folio(old_tb));
> +               old_tb =3D __swap_table_get(ci, ci_off);
> +               if (unlikely(swp_tb_is_folio(old_tb))) {
> +                       err =3D -EEXIST;
> +                       goto failed;
> +               }
> +               if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(e=
ntry), offset)))) {
> +                       err =3D -ENOENT;
> +                       goto failed;
> +               }
>                 if (swp_tb_is_shadow(old_tb))
>                         shadow =3D swp_tb_to_shadow(old_tb);
> +               offset++;
> +       } while (++ci_off < ci_end);
> +
> +       ci_off =3D ci_start;
> +       offset =3D swp_offset(entry);
> +       do {
> +               /*
> +                * Still need to pin the slots with SWAP_HAS_CACHE since
> +                * swap allocator depends on that.
> +                */
> +               if (!alloc)
> +                       __swapcache_set_cached(si, ci, swp_entry(swp_type=
(entry), offset));
> +               __swap_table_set(ci, ci_off, new_tb);
> +               offset++;
>         } while (++ci_off < ci_end);
>
>         folio_ref_add(folio, nr_pages);
> @@ -168,6 +198,11 @@ void swap_cache_add_folio(struct folio *folio, swp_e=
ntry_t entry, void **shadowp
>
>         if (shadowp)
>                 *shadowp =3D shadow;
> +       return 0;
> +
> +failed:
> +       swap_cluster_unlock(ci);
> +       return err;
>  }
>
>  /**
> @@ -186,6 +221,7 @@ void swap_cache_add_folio(struct folio *folio, swp_en=
try_t entry, void **shadowp
>  void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *=
folio,
>                             swp_entry_t entry, void *shadow)
>  {
> +       struct swap_info_struct *si;
>         unsigned long old_tb, new_tb;
>         unsigned int ci_start, ci_off, ci_end;
>         unsigned long nr_pages =3D folio_nr_pages(folio);
> @@ -195,6 +231,7 @@ void __swap_cache_del_folio(struct swap_cluster_info =
*ci, struct folio *folio,
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
>
> +       si =3D __swap_entry_to_info(entry);
>         new_tb =3D shadow_swp_to_tb(shadow);
>         ci_start =3D swp_cluster_offset(entry);
>         ci_end =3D ci_start + nr_pages;
> @@ -210,6 +247,7 @@ void __swap_cache_del_folio(struct swap_cluster_info =
*ci, struct folio *folio,
>         folio_clear_swapcache(folio);
>         node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
>         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
> +       __swapcache_clear_cached(si, ci, entry, nr_pages);
>  }
>
>  /**
> @@ -231,7 +269,6 @@ void swap_cache_del_folio(struct folio *folio)
>         __swap_cache_del_folio(ci, folio, entry, NULL);
>         swap_cluster_unlock(ci);
>
> -       put_swap_folio(folio, entry);
>         folio_ref_sub(folio, folio_nr_pages(folio));
>  }
>
> @@ -423,67 +460,37 @@ static struct folio *__swap_cache_prepare_and_add(s=
wp_entry_t entry,
>                                                   gfp_t gfp, bool charged=
,
>                                                   bool skip_if_exists)
>  {
> -       struct folio *swapcache;
> +       struct folio *swapcache =3D NULL;
>         void *shadow;
>         int ret;
>
> -       /*
> -        * Check and pin the swap map with SWAP_HAS_CACHE, then add the f=
olio
> -        * into the swap cache. Loop with a schedule delay if raced with
> -        * another process setting SWAP_HAS_CACHE. This hackish loop will
> -        * be fixed very soon.
> -        */
> +       __folio_set_locked(folio);
> +       __folio_set_swapbacked(folio);
>         for (;;) {
> -               ret =3D swapcache_prepare(entry, folio_nr_pages(folio));
> +               ret =3D swap_cache_add_folio(folio, entry, &shadow, false=
);
>                 if (!ret)
>                         break;
>
>                 /*
> -                * The skip_if_exists is for protecting against a recursi=
ve
> -                * call to this helper on the same entry waiting forever
> -                * here because SWAP_HAS_CACHE is set but the folio is no=
t
> -                * in the swap cache yet. This can happen today if
> -                * mem_cgroup_swapin_charge_folio() below triggers reclai=
m
> -                * through zswap, which may call this helper again in the
> -                * writeback path.
> -                *
> -                * Large order allocation also needs special handling on
> +                * Large order allocation needs special handling on
>                  * race: if a smaller folio exists in cache, swapin needs
>                  * to fallback to order 0, and doing a swap cache lookup
>                  * might return a folio that is irrelevant to the faultin=
g
>                  * entry because @entry is aligned down. Just return NULL=
.
>                  */
>                 if (ret !=3D -EEXIST || skip_if_exists || folio_test_larg=
e(folio))
> -                       return NULL;
> +                       goto failed;
>
> -               /*
> -                * Check the swap cache again, we can only arrive
> -                * here because swapcache_prepare returns -EEXIST.
> -                */
>                 swapcache =3D swap_cache_get_folio(entry);
>                 if (swapcache)
> -                       return swapcache;
> -
> -               /*
> -                * We might race against __swap_cache_del_folio(), and
> -                * stumble across a swap_map entry whose SWAP_HAS_CACHE
> -                * has not yet been cleared.  Or race against another
> -                * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
> -                * in swap_map, but not yet added its folio to swap cache=
.
> -                */
> -               schedule_timeout_uninterruptible(1);
> +                       goto failed;
>         }
>
> -       __folio_set_locked(folio);
> -       __folio_set_swapbacked(folio);
> -
>         if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, =
entry)) {
> -               put_swap_folio(folio, entry);
> -               folio_unlock(folio);
> -               return NULL;
> +               swap_cache_del_folio(folio);
> +               goto failed;
>         }
>
> -       swap_cache_add_folio(folio, entry, &shadow);
>         memcg1_swapin(entry, folio_nr_pages(folio));
>         if (shadow)
>                 workingset_refault(folio, shadow);
> @@ -491,6 +498,10 @@ static struct folio *__swap_cache_prepare_and_add(sw=
p_entry_t entry,
>         /* Caller will initiate read into locked folio */
>         folio_add_lru(folio);
>         return folio;
> +
> +failed:
> +       folio_unlock(folio);
> +       return swapcache;
>  }
>
>  /**
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c878c4115d00..38f3c369df72 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1476,7 +1476,11 @@ int folio_alloc_swap(struct folio *folio)
>         if (!entry.val)
>                 return -ENOMEM;
>
> -       swap_cache_add_folio(folio, entry, NULL);
> +       /*
> +        * Allocator has pinned the slots with SWAP_HAS_CACHE
> +        * so it should never fail
> +        */
> +       WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
>
>         return 0;
>
> @@ -1582,9 +1586,8 @@ static unsigned char swap_entry_put_locked(struct s=
wap_info_struct *si,
>   *   do_swap_page()
>   *     ...                             swapoff+swapon
>   *     swap_cache_alloc_folio()
> - *       swapcache_prepare()
> - *         __swap_duplicate()
> - *           // check swap_map
> + *       swap_cache_add_folio()
> + *         // check swap_map
>   *     // verify PTE not changed
>   *
>   * In __swap_duplicate(), the swap_map need to be checked before
> @@ -3769,17 +3772,25 @@ int swap_duplicate_nr(swp_entry_t entry, int nr)
>         return err;
>  }
>
> -/*
> - * @entry: first swap entry from which we allocate nr swap cache.
> - *
> - * Called when allocating swap cache for existing swap entries,
> - * This can return error codes. Returns 0 at success.
> - * -EEXIST means there is a swap cache.
> - * Note: return code is different from swap_duplicate().
> - */
> -int swapcache_prepare(swp_entry_t entry, int nr)
> +/* Mark the swap map as HAS_CACHE, caller need to hold the cluster lock =
*/
> +void __swapcache_set_cached(struct swap_info_struct *si,
> +                           struct swap_cluster_info *ci,
> +                           swp_entry_t entry)
> +{
> +       WARN_ON(swap_dup_entries(si, ci, swp_offset(entry), SWAP_HAS_CACH=
E, 1));
> +}
> +
> +/* Clear the swap map as !HAS_CACHE, caller need to hold the cluster loc=
k */
> +void __swapcache_clear_cached(struct swap_info_struct *si,
> +                             struct swap_cluster_info *ci,
> +                             swp_entry_t entry, unsigned int nr)
>  {
> -       return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
> +       if (swap_only_has_cache(si, swp_offset(entry), nr)) {
> +               swap_entries_free(si, ci, entry, nr);
> +       } else {
> +               for (int i =3D 0; i < nr; i++, entry.val++)
> +                       swap_entry_put_locked(si, ci, entry, SWAP_HAS_CAC=
HE);
> +       }
>  }
>
>  /*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 76e9864447cc..d4b08478d03d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -761,7 +761,6 @@ static int __remove_mapping(struct address_space *map=
ping, struct folio *folio,
>                 __swap_cache_del_folio(ci, folio, swap, shadow);
>                 memcg1_swapout(folio, swap);
>                 swap_cluster_unlock_irq(ci);
> -               put_swap_folio(folio, swap);
>         } else {
>                 void (*free_folio)(struct folio *);
>
>
> --
> 2.52.0
>

Hi Andrew,

Syzbot, Deepanshu and Johannes helped found there is a problem with
Cgroup V1 accounting here:
https://lore.kernel.org/linux-mm/CAMgjq7CMsAMZZJL1=3Da=3DEtfWCOuDFE62RKR_0h=
UdPC4H+QF5GfQ@mail.gmail.com/

Syzbot have verified this fix:
https://lore.kernel.org/all/69653d31.050a0220.eaf7.00ca.GAE@google.com/

Can you help squash this fix into this patch?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 453d654727c1..e8b5b8f514ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -758,8 +758,8 @@ static int __remove_mapping(struct address_space
*mapping, struct folio *folio,

                if (reclaimed && !mapping_exiting(mapping))
                        shadow =3D workingset_eviction(folio, target_memcg)=
;
-               __swap_cache_del_folio(ci, folio, swap, shadow);
                memcg1_swapout(folio, swap);
+               __swap_cache_del_folio(ci, folio, swap, shadow);
                swap_cluster_unlock_irq(ci);



        } else {
                void (*free_folio)(struct folio *);

