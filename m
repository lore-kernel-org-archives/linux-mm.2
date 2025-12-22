Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E50D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 02:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6024C6B0088; Sun, 21 Dec 2025 21:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0716B0089; Sun, 21 Dec 2025 21:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC516B008A; Sun, 21 Dec 2025 21:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1C66B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:42:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FA0F13BF73
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:42:53 +0000 (UTC)
X-FDA: 84245559426.24.40E0FCF
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28F372000E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:42:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m0MOqj6x;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766371371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfwmyAVdiSKntYdpO/93AmMAaEy5zREOFeXFiXCUiFg=;
	b=W9gEQMKlLU8fFfxdXFQpKgdjFXyzVJIftzquEu9hMJxeKZ3yYAgYsfcbpm25Pvmz7NE9q2
	qHg+g4Gtt6+59jKMnnGFBAh10f+RunThRyAEBZ+Ih2577c3izJ1TNz7s91MjiLS/eJuvsG
	tvXGI84o9/CBZlzVTN4A+jzwvX5PIpU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m0MOqj6x;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766371371; a=rsa-sha256;
	cv=none;
	b=N39TlOtOHq/GIj6bLKvcADuCecnSjCjk7xDOoNHHdFRXSGnXfXQm/sLR4GblYW3fFPJcG0
	/JncP1MiTePo5IU2IKWkHXbGSzNVr/Gugoje/xQX5lXM4RPdX8TUQdYa4MsodmVwMSatLx
	vXsJz5vFXfG5yUb/GVtikqZqrQra8MI=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b79f98adea4so517188266b.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766371369; x=1766976169; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfwmyAVdiSKntYdpO/93AmMAaEy5zREOFeXFiXCUiFg=;
        b=m0MOqj6xXv9j5WVc029GWps449b0x0Ya/lASBBfFwtXpK774M21MYNpncmDAS1J1mN
         KZLHqYEPsAcfX2MJl4L6g794fBzADVBxLqg/HyqAlWBwP/NAIAM3cLGiA5bMnWELcy5j
         6z28ESdiBfC2L1HkKBD6AOVsvjYDBTu9A7abw5BOM27nk8gAVPUpJz9gX7Z/7eM9b5Gy
         /VFGdw0T5wAL5wvCnNWZJQreEIuj5qmUz+TenipdlAfrdlhQoyrJPhzIug6c/H6kp/aY
         h7XaF/UKpeyhdWmOE1bElG2dylI/RtoM13p4RvQnID4lroCuZFdLKq4vpWaqIq9fYbqH
         4fLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766371369; x=1766976169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dfwmyAVdiSKntYdpO/93AmMAaEy5zREOFeXFiXCUiFg=;
        b=tw6FEJgTP9snFZPgJHAaoDFqntnA09At9YlC5FTed3slAsZqQ8Y+QEhkoz+L7M2FWC
         2j5u1oxgfiT2Fvp8k2KKptOGOxa9zGB5mL/86SjCcIsttj+KzpMUzwuJNDCtPVScnAhw
         O6tom2gh6tZCoc8aQ4SzEu/xT1IqlPaVS4xl7skX+sscd3VCuc6P5DKyGfZtpKSobeC1
         myFkKRM1VG6Y1I7cBNli+n4feGmB8kSTHi+W6dnhv20FcwP4rzUoXEf2YStDywhHVZXU
         JUhDT0ktVaIDO94NDMnP9i+fdM/o8biT0fKivtjUphgKUhGdphP4ap4gwsBEFHUT+rN2
         Y5Ng==
X-Gm-Message-State: AOJu0Yz2NqOkIU4D3MSe7nXR+LQDEJ8FkWKubN3AtgSN7S8o6XDC3SMJ
	Ybgi50DZNaN51pw+cDSRnHTKqNCMy2CUpatUJXzdJNfhAURBOTZ1rQ1xH1os/oM+bvnzn8r8Rhg
	4gG22OLLOhbVniWsnIUuyJqFzh2sL4NU=
X-Gm-Gg: AY/fxX6w/O8cx+P6wxIcB8beZWaKEmcFIdX7wSpwJmXs+yA8hsPFECp1JuXszHWXxNV
	wxqcl594VxkRmvpbxIrRu+U0B7F/BcHUyXur+OcQSG5YzJdu+/li10P2ORCsDkY6cf88PiDWaPw
	DeciShVVnpAab4d3nopw9nJGgAXv/auwvhKnzlCyY50OcuBSKz7kcnuZqdOciPBJp0b3rvu151K
	xjy2UcwBspQey7NLB+ji6Ro1lzY4oxfVI2F/UP6YJpEbYVGzpYy4dNnm/hy/PkZwok77gYbe9p1
	pQRLAyXbJOrTIml2KO3ZERpfA4U=
X-Google-Smtp-Source: AGHT+IEAxY8wVy1yrxBiCHGd4nWUxieiwJZcY5RfOHF+OsR+rtDDts6bkXHZzIfZE7Nq+IytI60gZTT86/ht1+GpCoQ=
X-Received: by 2002:a17:907:72cd:b0:b76:791d:1c5c with SMTP id
 a640c23a62f3a-b8036eba988mr875528566b.9.1766371369286; Sun, 21 Dec 2025
 18:42:49 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-15-8862a265a033@tencent.com> <aUYiLiGJPt/kAy3I@MiWiFi-R3L-srv>
In-Reply-To: <aUYiLiGJPt/kAy3I@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 22 Dec 2025 10:42:12 +0800
X-Gm-Features: AQt7F2odRUizLXQ-8CWSeJ2W6U0x57t2xWWa00_OxG9MbLoYEl-QZq8Xp_E0Oas
Message-ID: <CAMgjq7DG-LghGSs_jANXbFqqRFEt_BeCv5gJV7wcTzVEy+N5yQ@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] mm, swap: add folio to swap cache directly on allocation
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: i4xbnxk1o6pgawi3sj74mx67dzp4xzob
X-Rspam-User: 
X-Rspamd-Queue-Id: 28F372000E
X-HE-Tag: 1766371370-244242
X-HE-Meta: U2FsdGVkX18qIJiizmk417zsT9O36GZpAosvGlJspbnTu3YQC80J4mDrBNrqxoiBF8YNkoNEimAQW2ls7JUTUJnZxVRLw6H4tOFz34XVk64WxzRILu4cpsTqSYFino8fKKza3Sc/70X4lV/joAawwT4sKNAHYMaBQBQ5XCG49xvouXVeH88sEc097xsErBNO13EmkdxL/sPuqCgP6F5Go7psfcTVsNNhETwNFjHUc/LTW4vMZEgm1xMVhWW3l/F9nauv8Pz6+8aSj7gyYIoKthhYHqHq1Pg/cOVqDFrrrRdtvTCWrq9RDV99ACJQoRfILjrlxwsXKR8EMDiplRRp+fMVUCzYAQdfK3jOAUbVtOGGx0Sl6PkJNf/8p/XQ1asRSsJtgQ2Quw5ugy4jtXwwDXdftleX+7r7p86JIrCcE41+tnKUocejTiq4knXKAYTl2NTFZWvwvf35Qot6mlyHsyrx5yEFKcS8RneltVylDMelj/8Ml0LjcZQEuxInJIcyuqpDNGHBLPl7/++mCzcyXHj98HGxSHoTAJu8mnf3ukpIrPWTzcihWUGUzFBdJALslzuC5B6Rv1rbg6mIbPLdzJFbRbJ0ji3ab1Ca3i+1jAPz116fowuELup1Vt9LkDGKlkfTV1BN5wOfJEh2iOzmQ/sOqcGyBLLkqROAPzn+YJ6ED3IyeJIjwaoi9kWQjCRqQhpN7TNn1RMNlFM5baW02Tv9joX5+7CByJk9JjocayTNgYtu1NczMoGRozyYtX+/uYmnVP75vixGwd6URFDiqt6s7IUrZIZxkXqHwMK9A9Pv8XRyvWzc0yPjJ5BV/UYN08Uj3ctkANx1+Ple3qYa2jNFpmwbtPO+NyQtb5SzI3G+iY757tjgJRkKmT7Vp9d8cwkThJfKok07HcTTxe/hiFgRtXf8Pzf2gkgxInRlO3KbzFHnje8VaiPh5U6JfomZuZo1LSDCT0VfZlC7Sih
 thMzGk7m
 GdaN50rlVHle14RjsxJHMryYdAgoxK32xS/W2u5K8YaqC3fxmUMtIQiObqLmn/kfT6Lt3X73IL/wSDigo5AT93yfc1ljXwxZ9giKv2IAYbWD7WtuEfi1qBh95gMobLvS3xxsbn9jPuxaHXws8ozrXjt9vbK+tRudPhdPDFX2BDjEXBi9Y8tXkkFQFXIm4pHxwgNcpExCFzo0lrRS4Q+YOYdTia7Da/4RQ/RxkWo7pJPCDDZpZW38LMbeYHaU3hdpNOvcr5bbIxCdzn8AQBS4vk75egeEbKtMo3ZjtzVqxWivIh42JO+ThZXm8Osdw9+2yPJfrhlRTtllGGifp37wYCz09wtQXFNeDOQ0fdcObrIlA6zGKoUnNyG5iDpiKEwVN0vpa+JELt3Wzd0JhTRm0t5UlWeI41efQYjNldXn9tupB2d+k0243i2DnUZO1KZsmyhBQPuGGXdibu5VYgRiHKrBxD2n3nmhT4y5OiCu/zD3D/ug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 12:12=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/20/25 at 03:43am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
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
> >  mm/swap.h            |  10 +---
> >  mm/swap_state.c      |  58 +++++++++++--------
> >  mm/swapfile.c        | 161 ++++++++++++++++++++++---------------------=
--------
> >  4 files changed, 105 insertions(+), 129 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index aaa868f60b9c..517d24e96d8c 100644
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
> > @@ -533,10 +532,6 @@ static inline void swap_put_entries_direct(swp_ent=
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
> > index 9ed12936b889..ec1ef7d0c35b 100644
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
> > @@ -459,12 +459,6 @@ static inline void *swap_cache_get_shadow(swp_entr=
y_t entry)
> >       return NULL;
> >  }
> >
> > -static inline int swap_cache_add_folio(struct folio *folio, swp_entry_=
t entry,
> > -                                    void **shadow, bool alloc)
> > -{
> > -     return -ENOENT;
> > -}
> > -
> >  static inline void swap_cache_del_folio(struct folio *folio)
> >  {
> >  }
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 327c051d7cd0..29fa8d313a79 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -122,35 +122,56 @@ void *swap_cache_get_shadow(swp_entry_t entry)
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
>
> With my understanding, __swap_cache_add_folio() is the pure
> functionality of adding a folio into swap cache. While

Hi Baoquan, thanks for the review and suggestion!

> swap_cache_add_folio() is specifically adding a folio into swap cache
> during swap in path. Not sure if we can rename them to reflect this
> clearer. At least from the functiona name and below kernel doc we can't
> feel that. Maybe:
> __swap_cache_add_folio() -> swap_cache_add_folio()

The `__` prefix should stay, I think. This function requires the
caller to lock the swap cluster.

> swap_cache_add_folio() -> swap_cache_add_swapin_folio()

Indeed, my plan is that `swap_cache_add_folio` will be gone soon, we
should always call `swap_cache_alloc_folio` instead to do the swap
folio allocation in a unified way, and just remove this.

Currently we can't do that because shmem and anon have different
routines for swapin folio allocation. Having a unified
`swap_cache_alloc_folio` will provide better swapin fallout control
and cleaner cgroup charging to avoid thrashing, etc.

Also this helper is currently inexplicitly used by zswap writeback
too, so adding the swapin keyword seems not accurate.

