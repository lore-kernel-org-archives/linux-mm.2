Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DFFCA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 03:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA096B0023; Fri, 29 Aug 2025 23:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF448E0001; Fri, 29 Aug 2025 23:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073076B0026; Fri, 29 Aug 2025 23:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFC926B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F9F95C10D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:40:39 +0000 (UTC)
X-FDA: 83832021798.25.C74681F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5ED58C0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:40:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HG64VpkT;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756525237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kJy9d5DkrPB9ZAWOFbYDjwWnke9wFFUQHTb9V6Yajs=;
	b=AZXCvecvPYvxRcjyr+jZGMJa6jJalJFBOjs7nz8lVPHZjfMlOAnke5/gUonTv9HSXOG4L4
	gfHQ4BknL8F9ZLQubfu+WaXPnmWlxMD5LJEt+XTb8bwXXkltLTspUw/n+H2Vx7UOhx0kVM
	9Ha1Q05vOr6RrvoB17A5r4K8pJc1c3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756525237; a=rsa-sha256;
	cv=none;
	b=LKjiTeCa4opHwoHKDKBNMMwJ8QRuVBnZ7wtO5YPgmP7GTKr0ZiDpH1JlKAagkHlkn6/K7e
	yHykIqdvXsfab+/gMRUCPN2QjAVL6fqCwMqNml9NA66TfMhiO5cSeolcRVnPhcZlKxtVyT
	28xgboiB5hPTVnlj+ruOypF65w8BYb0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HG64VpkT;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44658418E8
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E145C4CEF0
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756525236;
	bh=ekMU67eCfaYCsKS3Sk584P72AKjoZ+uz+A+2bljOxxY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HG64VpkTS74YjTC/p7OSSiE9omz68pqrmmYOuhDk5zghjHG2O0Vs6i28CkeBe1co2
	 gvUqrIeT61DFuieRlOo8Ei0P1qIywuWnNzP9gC2wDAPPt+EOyLvRAP4dioH3MTfq4U
	 rmXU7DSrLOpPU10wn5uDaqrYEDY7mZIIjck1tys2mqZS2DDD4ql29slsgJF5O6570S
	 6eaVxA+sjFhBUChzQVSEmg5jVuWOMfAs/UYGU+FPALFp0WTbnDNozb/lWq9I7QeI4B
	 5zAmZzt7abD88ppMczI84In4iUJKG3HfelvI9tWZNLDzxodbLf37Hp4hGTgwHwl/0v
	 h3xRqmKsgHXxg==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-72267c0505fso9175867b3.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:40:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXaQke95FBLV7YgurWz6qv5AcSBCWF0PC68oebuUvkWEendPPT9590zmu59duQmWVg//nJ6WWyVng==@kvack.org
X-Gm-Message-State: AOJu0YySPpk7owjPxPiwmv52wYYiAQaybNU+79tVDsJMU/F9jnlQZb/X
	vvd0iEwj/enT+8l/48QOtzjocimjLQm7Im3dMkdEjUr3cp8acws1Rks4S/8RgiGQpK/MRqWjMlV
	vyYlrZjk7j/9BJHplihRu1yUwYivW/V/XHxUC7hlOvA==
X-Google-Smtp-Source: AGHT+IH42Ye7IGAbsXoXHM5U3bT0haWXsJwkSruyhimViUJmDF4T2gvIwCJWIHZE7LXn0frKTfI2pZM+Mnq+jIOZDWo=
X-Received: by 2002:a05:690c:640a:b0:721:aca:b1e3 with SMTP id
 00721157ae682-722763ba27bmr10392517b3.24.1756525235122; Fri, 29 Aug 2025
 20:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <aLJZ4Q1ioAiUsWv2@MiWiFi-R3L-srv>
In-Reply-To: <aLJZ4Q1ioAiUsWv2@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 20:40:24 -0700
X-Gmail-Original-Message-ID: <CACePvbV9Zg5EzeXRee0bS2FooKmbNp=k5-=pZHq9YFRGH3mePg@mail.gmail.com>
X-Gm-Features: Ac12FXzthyTDFWKlnrM5vBek9ik89WrKj38TUIh6ufqa6oyNR7ZQoLtvnIvv89s
Message-ID: <CACePvbV9Zg5EzeXRee0bS2FooKmbNp=k5-=pZHq9YFRGH3mePg@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5ED58C0005
X-Stat-Signature: uc7sqhhkrauox7w49yhbq6n4jc9t1fsn
X-Rspam-User: 
X-HE-Tag: 1756525237-587050
X-HE-Meta: U2FsdGVkX19WFmatpTPzDCKgnvsz9akVsjL8VLFBd8sOi6FZ3ZCI13bzTVUGw2HJl5hxrlukErNHuZEkLM8lC/0jrFZ2boLm9ng7jjgkBz5HIQhHNzorZWZR96aY3BRnavDEBWhAoFMgsIjgKuJSTbSr1xrAJSCdW5UHIv8MtzXM7lhfk25OyWl535TrOE7cBh3TRrGaULMNnt6RwQj8MlgVCSPOcYyU+LJAHGYfVw1IaRAmQ+70ipkKvEEYW1TqQJUDP6lBzR5XiyHu/goh4CwntZ+PkHGHCsCR29lCNTOvPq/XLY+AicHmEjxFVg2qbBUHKW5TAMn8JdE8FtWDJu36W6JjDmzZib6CLRwl0tyP+clqVxjb9OCC+faAY7v8k72nsFmRR9c5UFKqFAVoC1Y0lvZ9zWRnqkwDrgbGltnsMssxp0o9qBODCN3jX4fZ9R95/1kDLsEG9nxDTAlr9LEDiBJ1Dy4WcL2H4c5p1oZxJZXURJ1OG9XyKlCzMj2MenpMd2dLurgSbUwUDLBiJi/L7dFgfRa5QUadAPSSZF//pvHFOS75nyf8djCH6BlNGDTf9CBFlquBzblJ5s+EUZId/CNAzJFXF7GPDKHU9sXKE+L9X0EiSVCZXYeAc/etRHvZSllotlmy3m48bkuoWetHbv2Lm+xPmHoJsnTdk1JU2GEzsmJ7I4uoR4cKhFoP/t87s3n92mNnNBEwRl61Ghja82EOGp/pT6AvXUrNs2iujiKo507lWwPAkpuIBIQ6NGHIH7QKhkNN4rz/GKiyXBOyK0JWkG/BJIRom4CbTVlo9vryg4FGAGpywlJ21fVNGZGr2y2BJMAG61+EUsUWS6ON7AEQ12NJo/82W+1mBXilxARRPDFNpMsdlGa7KhZYjjTSI5xc9ksaqVgHVP4dVu9J9cW4+aK8YwzJ6DlBJSTq64J1BGOObLv7+44MflYzX64RjpfAwRWsjpUvDxU
 Crunmp6D
 pM1xaBx6UKA4CfSO5N+tBee0nx2dOifM5B1PhH/qpBfLtASjVdzNjZCsTKQC6IRlrOoNZGGCLFvDf9J1HWjqbtYOZCuC9vD7y/qg1di0lVzTbV1asbknvW7JD3FyUE825sNQQQ6/V1TfcOjVMdxXwvJqyt9akOPP0YqpIuuyrH4EmTFh9UQojReWBhASOQmDSjLkX2h9b3EOmBB+ZNFoH9i2Ofz9/ff+1O6OjXug9EYkYFVplFV/WIQemHFDkJ5hk4/G1qc/LY27vu5uiaWMXD0tpU3cIgQbO89z3+JU0Elckv4aBWml4Piv/mr8n1iBI7hV34dKZky889lPgiYZAPlIAgTJGf3eHXuyE+fi5sBhhJ2Y8fd28O6Ss5rig5yneq8JKZmM6MTcnQbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 6:55=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 08/23/25 at 03:20am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> ......snip...
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 7b3efaa51624..4af42bc2cd72 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> ......snip...
> > +/*
> > + * All swap cache helpers below require the caller to ensure the swap =
entries
> > + * are valid and pin the device. This can be guaranteed by:
> > + * - get_swap_device: this ensures a single entry is valid and increas=
es the
> > + *   swap device's refcount.
> > + * - Locking a folio in the swap cache: this ensures the folio won't b=
e freed
> > + *   from the swap cache, stabilizes its entries, and the swap device.
> > + * - Locking anything referencing the swap entry: e.g. locking the PTL=
 that
> > + *   protects swap entries in the page table, so they won't be freed.
> > + */
> > +extern struct folio *swap_cache_get_folio(swp_entry_t entry);
> > +extern void *swap_cache_get_shadow(swp_entry_t entry);
> > +extern int swap_cache_add_folio(swp_entry_t entry,
> > +                             struct folio *folio, void **shadow);
> > +extern void swap_cache_del_folio(struct folio *folio);
> > +/* Below helpers also require the caller to lock the swap cluster. */
> > +extern void __swap_cache_del_folio(swp_entry_t entry,
> > +                                struct folio *folio, void *shadow);
> > +extern void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> > +                                   swp_entry_t entry, struct folio *ol=
d,
> > +                                   struct folio *new);
> > +extern void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
> > +
> >  void show_swap_cache_info(void);
> > -void *get_shadow_from_swap_cache(swp_entry_t entry);
> > -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> > -                   gfp_t gfp, void **shadowp);
> > -void __delete_from_swap_cache(struct folio *folio,
> > -                           swp_entry_t entry, void *shadow);
> > -void delete_from_swap_cache(struct folio *folio);
> > -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> > -                               unsigned long end);
> >  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, i=
nt nr);
> > -struct folio *swap_cache_get_folio(swp_entry_t entry);
> >  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> >               struct vm_area_struct *vma, unsigned long addr,
> >               struct swap_iocb **plug);
>
> I would put this function renaming change to another standalone patch,
> then let this key patch focus on swap table introducing.
>
> > @@ -235,6 +283,33 @@ static inline int non_swapcache_batch(swp_entry_t =
entry, int max_nr)
> >
> >  #else /* CONFIG_SWAP */
> >  struct swap_iocb;
> > +
> > +static inline struct swap_cluster_info *swap_cluster_lock(
> > +     struct swap_info_struct *si, pgoff_t offset, bool irq)
> > +{
> > +     return NULL;
> > +}
> > +
> > +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> > +             struct folio *folio)
> > +{
> > +     return NULL;
> > +}
> > +
> > +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq=
(
> > +             struct folio *folio)
> > +{
> > +     return NULL;
> > +}
> > +
> > +static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> > +{
> > +}
> > +
> > +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *c=
i)
> > +{
> > +}
> > +
> >  static inline struct swap_info_struct *swp_info(swp_entry_t entry)
> >  {
> >       return NULL;
> > @@ -252,11 +327,6 @@ static inline struct address_space *swap_address_s=
pace(swp_entry_t entry)
> >       return NULL;
> >  }
> >
> > -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> > -{
> > -     return 0;
> > -}
> > -
> >  static inline bool folio_contains_swap(struct folio *folio, swp_entry_=
t entry)
> >  {
> >       return false;
> > @@ -298,28 +368,27 @@ static inline struct folio *swap_cache_get_folio(=
swp_entry_t entry)
> >       return NULL;
> >  }
> >
> > -static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
> > +static inline void *swap_cache_get_shadow(swp_entry_t end)
> >  {
> >       return NULL;
> >  }
> >
> > -static inline int add_to_swap_cache(struct folio *folio, swp_entry_t e=
ntry,
> > -                                     gfp_t gfp_mask, void **shadowp)
> > +static inline int swap_cache_add_folio(swp_entry_t end, struct folio *=
folio, void **shadow)
> >  {
> > -     return -1;
> > +     return -EINVAL;
> >  }
> >
> > -static inline void __delete_from_swap_cache(struct folio *folio,
> > -                                     swp_entry_t entry, void *shadow)
> > +static inline void swap_cache_del_folio(struct folio *folio)
> >  {
> >  }
> >
> > -static inline void delete_from_swap_cache(struct folio *folio)
> > +static inline void __swap_cache_del_folio(swp_entry_t entry, struct fo=
lio *folio, void *shadow)
> >  {
> >  }
> >
> > -static inline void clear_shadow_from_swap_cache(int type, unsigned lon=
g begin,
> > -                             unsigned long end)
> > +static inline void __swap_cache_replace_folio(
> > +             struct swap_cluster_info *ci, swp_entry_t entry,
> > +             struct folio *old, struct folio *new)
> >  {
> >  }
> >
> > @@ -354,7 +423,7 @@ static inline int non_swapcache_batch(swp_entry_t e=
ntry, int max_nr)
> >  static inline pgoff_t folio_index(struct folio *folio)
> >  {
> >       if (unlikely(folio_test_swapcache(folio)))
> > -             return swap_cache_index(folio->swap);
> > +             return swp_offset(folio->swap);
> >       return folio->index;
> >  }
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 721ff1a5e73a..c0342024b4a8 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/huge_mm.h>
> >  #include <linux/shmem_fs.h>
> >  #include "internal.h"
> > +#include "swap_table.h"
> >  #include "swap.h"
> >
> >  /*
> > @@ -36,8 +37,11 @@ static const struct address_space_operations swap_ao=
ps =3D {
> >  #endif
> >  };
> >
> > -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > +/* Set swap_space is read only as swap cache is handled by swap table =
*/
> > +struct address_space swap_space __ro_after_init =3D {
> > +     .a_ops =3D &swap_aops,
> > +};
> > +
> >  static bool enable_vma_readahead __read_mostly =3D true;
> >
> >  #define SWAP_RA_ORDER_CEILING        5
> > @@ -69,7 +73,7 @@ void show_swap_cache_info(void)
> >       printk("Total swap =3D %lukB\n", K(total_swap_pages));
> >  }
> >
> > -/*
> > +/**
> >   * swap_cache_get_folio - Lookup a swap entry in the swap cache.
> >   *
> >   * A found folio will be returned unlocked and with its refcount incre=
ased.
> > @@ -79,155 +83,179 @@ void show_swap_cache_info(void)
> >   */
> >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> >  {
> > -     struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> > -                                             swap_cache_index(entry));
> > -     if (!IS_ERR(folio))
> > -             return folio;
> > +     unsigned long swp_tb;
> > +     struct folio *folio;
> > +
> > +     for (;;) {
> > +             swp_tb =3D __swap_table_get(swp_cluster(entry), swp_clust=
er_offset(entry));
> > +             if (!swp_tb_is_folio(swp_tb))
> > +                     return NULL;
> > +             folio =3D swp_tb_to_folio(swp_tb);
> > +             if (folio_try_get(folio))
> > +                     return folio;
> > +     }
> > +
> >       return NULL;
> >  }
> >
> > -void *get_shadow_from_swap_cache(swp_entry_t entry)
> > +/**
> > + * swap_cache_get_shadow - Lookup a shadow in the swap cache.
> > + *
> > + * Context: Caller must ensure @entry is valid and pin the swap device=
.
> > + */
> > +void *swap_cache_get_shadow(swp_entry_t entry)
> >  {
> > -     struct address_space *address_space =3D swap_address_space(entry)=
;
> > -     pgoff_t idx =3D swap_cache_index(entry);
> > -     void *shadow;
> > +     unsigned long swp_tb;
> > +
> > +     swp_tb =3D __swap_table_get(swp_cluster(entry), swp_cluster_offse=
t(entry));
> > +     if (swp_tb_is_shadow(swp_tb))
> > +             return swp_tb_to_shadow(swp_tb);
> >
> > -     shadow =3D xa_load(&address_space->i_pages, idx);
> > -     if (xa_is_value(shadow))
> > -             return shadow;
> >       return NULL;
> >  }
> >
> > -/*
> > - * add_to_swap_cache resembles filemap_add_folio on swapper_space,
> > - * but sets SwapCache flag and 'swap' instead of mapping and index.
> > +/**
> > + * swap_cache_add_folio -  add a folio into the swap cache.
> > + *
> > + * The folio will be used for swapin or swapout of swap entries
> > + * starting with @entry. May fail due to race.
> > + *
> > + * Context: Caller must ensure @entry is valid and pin the swap device=
.
> >   */
> > -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> > -                     gfp_t gfp, void **shadowp)
> > +int swap_cache_add_folio(swp_entry_t entry, struct folio *folio, void =
**shadowp)
> >  {
> > -     struct address_space *address_space =3D swap_address_space(entry)=
;
> > -     pgoff_t idx =3D swap_cache_index(entry);
> > -     XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(fol=
io));
> > -     unsigned long i, nr =3D folio_nr_pages(folio);
> > -     void *old;
> > -
> > -     xas_set_update(&xas, workingset_update_node);
> > -
> > -     VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > -     VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> > -     VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
> > +     unsigned long exist;
> > +     void *shadow =3D NULL;
> > +     struct swap_cluster_info *ci;
> > +     unsigned int ci_start, ci_off, ci_end;
> > +     unsigned long nr_pages =3D folio_nr_pages(folio);
> > +
> > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +     VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> > +
> > +     ci =3D swap_cluster_lock(swp_info(entry), swp_offset(entry));
> > +     ci_start =3D swp_cluster_offset(entry);
> > +     ci_end =3D ci_start + nr_pages;
> > +     ci_off =3D ci_start;
> > +     do {
> > +             exist =3D __swap_table_get(ci, ci_off);
> > +             if (unlikely(swp_tb_is_folio(exist)))
> > +                     goto fail;
> > +             if (swp_tb_is_shadow(exist))
> > +                     shadow =3D swp_tb_to_shadow(exist);
> > +     } while (++ci_off < ci_end);
> > +
> > +     ci_off =3D ci_start;
> > +     do {
> > +             __swap_table_set_folio(ci, ci_off, folio);
> > +     } while (++ci_off < ci_end);
> >
> > -     folio_ref_add(folio, nr);
> > +     folio_ref_add(folio, nr_pages);
> >       folio_set_swapcache(folio);
> >       folio->swap =3D entry;
> > +     swap_cluster_unlock(ci);
> >
> > -     do {
> > -             xas_lock_irq(&xas);
> > -             xas_create_range(&xas);
> > -             if (xas_error(&xas))
> > -                     goto unlock;
> > -             for (i =3D 0; i < nr; i++) {
> > -                     VM_BUG_ON_FOLIO(xas.xa_index !=3D idx + i, folio)=
;
> > -                     if (shadowp) {
> > -                             old =3D xas_load(&xas);
> > -                             if (xa_is_value(old))
> > -                                     *shadowp =3D old;
> > -                     }
> > -                     xas_store(&xas, folio);
> > -                     xas_next(&xas);
> > -             }
> > -             address_space->nrpages +=3D nr;
> > -             __node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
> > -             __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
> > -unlock:
> > -             xas_unlock_irq(&xas);
> > -     } while (xas_nomem(&xas, gfp));
> > -
> > -     if (!xas_error(&xas))
> > -             return 0;
> > +     node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> > +     lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> >
> > -     folio_clear_swapcache(folio);
> > -     folio_ref_sub(folio, nr);
> > -     return xas_error(&xas);
> > +     if (shadowp)
> > +             *shadowp =3D shadow;
> > +     return 0;
> > +fail:
> > +     swap_cluster_unlock(ci);
> > +     return -EEXIST;
> >  }
> >
> >  /*
> > - * This must be called only on folios that have
> > - * been verified to be in the swap cache.
> > + * Caller must ensure the folio is in the swap cache and locked,
> > + * also lock the swap cluster.
> >   */
> > -void __delete_from_swap_cache(struct folio *folio,
> > -                     swp_entry_t entry, void *shadow)
> > +void __swap_cache_del_folio(swp_entry_t entry, struct folio *folio,
> > +                         void *shadow)
> >  {
> > -     struct address_space *address_space =3D swap_address_space(entry)=
;
> > -     int i;
> > -     long nr =3D folio_nr_pages(folio);
> > -     pgoff_t idx =3D swap_cache_index(entry);
> > -     XA_STATE(xas, &address_space->i_pages, idx);
> > -
> > -     xas_set_update(&xas, workingset_update_node);
> > -
> > -     VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > -     VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > -     VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
> > -
> > -     for (i =3D 0; i < nr; i++) {
> > -             void *entry =3D xas_store(&xas, shadow);
> > -             VM_BUG_ON_PAGE(entry !=3D folio, entry);
> > -             xas_next(&xas);
> > -     }
> > +     unsigned long exist;
> > +     struct swap_cluster_info *ci;
> > +     unsigned int ci_start, ci_off, ci_end;
> > +     unsigned long nr_pages =3D folio_nr_pages(folio);
> > +
> > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> > +     VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
> > +
> > +     ci =3D swp_offset_cluster(swp_info(entry), swp_offset(entry));
> > +     ci_start =3D swp_cluster_offset(entry);
> > +     ci_end =3D ci_start + nr_pages;
> > +     ci_off =3D ci_start;
> > +     do {
> > +             exist =3D __swap_table_get(ci, ci_off);
> > +             VM_WARN_ON_ONCE(swp_tb_to_folio(exist) !=3D folio);
> > +             /* If shadow is NULL, we sets an empty shadow */
> > +             __swap_table_set_shadow(ci, ci_off, shadow);
> > +     } while (++ci_off < ci_end);
> > +
> >       folio->swap.val =3D 0;
> >       folio_clear_swapcache(folio);
> > -     address_space->nrpages -=3D nr;
> > -     __node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
> > -     __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
> > +     node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
> > +     lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
> >  }
> >
> >  /*
> > - * This must be called only on folios that have
> > - * been verified to be in the swap cache and locked.
> > - * It will never put the folio into the free list,
> > - * the caller has a reference on the folio.
> > + * Replace an old folio in the swap cache with a new one. The caller m=
ust
> > + * hold the cluster lock and set the new folio's entry and flags.
> >   */
> > -void delete_from_swap_cache(struct folio *folio)
> > +void __swap_cache_replace_folio(struct swap_cluster_info *ci, swp_entr=
y_t entry,
> > +                             struct folio *old, struct folio *new)
> > +{
> > +     unsigned int ci_off =3D swp_cluster_offset(entry);
> > +     unsigned long nr_pages =3D folio_nr_pages(new);
> > +     unsigned int ci_end =3D ci_off + nr_pages;
> > +
> > +     VM_WARN_ON_ONCE(entry.val !=3D new->swap.val);
> > +     VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new=
));
> > +     VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcac=
he(new));
> > +     do {
> > +             WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)=
) !=3D old);
> > +             __swap_table_set_folio(ci, ci_off, new);
> > +     } while (++ci_off < ci_end);
> > +
> > +     /*
> > +      * If the old folio is partially replaced (e.g., splitting a larg=
e
> > +      * folio, the old folio is shrunk in place, and new split sub fol=
ios
> > +      * are added to cache), ensure the new folio doesn't overlap it.
> > +      */
> > +     if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> > +         folio_order(old) !=3D folio_order(new)) {
> > +             ci_off =3D swp_cluster_offset(old->swap);
> > +             ci_end =3D ci_off + folio_nr_pages(old);
> > +             while (ci_off++ < ci_end)
> > +                     WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci,=
 ci_off)) !=3D old);
> > +     }
> > +}
> > +
> > +void swap_cache_del_folio(struct folio *folio)
> >  {
> > +     struct swap_cluster_info *ci;
> >       swp_entry_t entry =3D folio->swap;
> > -     struct address_space *address_space =3D swap_address_space(entry)=
;
> >
> > -     xa_lock_irq(&address_space->i_pages);
> > -     __delete_from_swap_cache(folio, entry, NULL);
> > -     xa_unlock_irq(&address_space->i_pages);
> > +     ci =3D swap_cluster_lock(swp_info(entry), swp_offset(entry));
> > +     __swap_cache_del_folio(entry, folio, NULL);
> > +     swap_cluster_unlock(ci);
> >
> >       put_swap_folio(folio, entry);
> >       folio_ref_sub(folio, folio_nr_pages(folio));
> >  }
> >
> > -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> > -                             unsigned long end)
> > +void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
> >  {
> > -     unsigned long curr =3D begin;
> > -     void *old;
> > -
> > -     for (;;) {
> > -             swp_entry_t entry =3D swp_entry(type, curr);
> > -             unsigned long index =3D curr & SWAP_ADDRESS_SPACE_MASK;
> > -             struct address_space *address_space =3D swap_address_spac=
e(entry);
> > -             XA_STATE(xas, &address_space->i_pages, index);
> > -
> > -             xas_set_update(&xas, workingset_update_node);
> > -
> > -             xa_lock_irq(&address_space->i_pages);
> > -             xas_for_each(&xas, old, min(index + (end - curr), SWAP_AD=
DRESS_SPACE_PAGES)) {
> > -                     if (!xa_is_value(old))
> > -                             continue;
> > -                     xas_store(&xas, NULL);
> > -             }
> > -             xa_unlock_irq(&address_space->i_pages);
> > +     struct swap_cluster_info *ci =3D swp_cluster(entry);
> > +     unsigned int ci_off =3D swp_cluster_offset(entry), ci_end;
> >
> > -             /* search the next swapcache until we meet end */
> > -             curr =3D ALIGN((curr + 1), SWAP_ADDRESS_SPACE_PAGES);
> > -             if (curr > end)
> > -                     break;
> > -     }
> > +     ci_end =3D ci_off + nr_ents;
> > +     do {
> > +             WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)=
));
> > +             __swap_table_init_null(ci, ci_off);
> > +     } while (++ci_off < ci_end);
> >  }
> >
> >  /*
> > @@ -292,8 +320,7 @@ static inline bool swap_use_vma_readahead(void)
> >  /*
> >   * Update the readahead statistics of a vma or globally.
> >   */
> > -void swap_update_readahead(struct folio *folio,
> > -                        struct vm_area_struct *vma,
> > +void swap_update_readahead(struct folio *folio, struct vm_area_struct =
*vma,
> >                          unsigned long addr)
> >  {
> >       bool readahead, vma_ra =3D swap_use_vma_readahead();
> > @@ -387,7 +414,7 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >                       goto put_and_return;
> >
> >               /*
> > -              * We might race against __delete_from_swap_cache(), and
> > +              * We might race against __swap_cache_del_folio(), and
> >                * stumble across a swap_map entry whose SWAP_HAS_CACHE
> >                * has not yet been cleared.  Or race against another
> >                * __read_swap_cache_async(), which has set SWAP_HAS_CACH=
E
> > @@ -405,8 +432,7 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >       if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, ent=
ry))
> >               goto fail_unlock;
> >
> > -     /* May fail (-ENOMEM) if XArray node allocation failed. */
> > -     if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MA=
SK, &shadow))
> > +     if (swap_cache_add_folio(entry, new_folio, &shadow))
> >               goto fail_unlock;
> >
> >       memcg1_swapin(entry, 1);
> > @@ -572,11 +598,11 @@ struct folio *swap_cluster_readahead(swp_entry_t =
entry, gfp_t gfp_mask,
> >               end_offset =3D si->max - 1;
> >
> >       blk_start_plug(&plug);
> > -     for (offset =3D start_offset; offset <=3D end_offset ; offset++) =
{
> > +     for (offset =3D start_offset; offset <=3D end_offset; offset++) {
> >               /* Ok, do the async read-ahead now */
> >               folio =3D __read_swap_cache_async(
> > -                             swp_entry(swp_type(entry), offset),
> > -                             gfp_mask, mpol, ilx, &page_allocated, fal=
se);
> > +                             swp_entry(swp_type(entry), offset), gfp_m=
ask, mpol, ilx,
> > +                             &page_allocated, false);
> >               if (!folio)
> >                       continue;
> >               if (page_allocated) {
> > @@ -600,41 +626,6 @@ struct folio *swap_cluster_readahead(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >       return folio;
> >  }
> >
> > -int init_swap_address_space(unsigned int type, unsigned long nr_pages)
> > -{
> > -     struct address_space *spaces, *space;
> > -     unsigned int i, nr;
> > -
> > -     nr =3D DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
> > -     spaces =3D kvcalloc(nr, sizeof(struct address_space), GFP_KERNEL)=
;
> > -     if (!spaces)
> > -             return -ENOMEM;
> > -     for (i =3D 0; i < nr; i++) {
> > -             space =3D spaces + i;
> > -             xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
> > -             atomic_set(&space->i_mmap_writable, 0);
> > -             space->a_ops =3D &swap_aops;
> > -             /* swap cache doesn't use writeback related tags */
> > -             mapping_set_no_writeback_tags(space);
> > -     }
> > -     nr_swapper_spaces[type] =3D nr;
> > -     swapper_spaces[type] =3D spaces;
> > -
> > -     return 0;
> > -}
> > -
> > -void exit_swap_address_space(unsigned int type)
> > -{
> > -     int i;
> > -     struct address_space *spaces =3D swapper_spaces[type];
> > -
> > -     for (i =3D 0; i < nr_swapper_spaces[type]; i++)
> > -             VM_WARN_ON_ONCE(!mapping_empty(&spaces[i]));
> > -     kvfree(spaces);
> > -     nr_swapper_spaces[type] =3D 0;
> > -     swapper_spaces[type] =3D NULL;
> > -}
> > -
> >  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
> >                          unsigned long *end)
> >  {
> > @@ -807,7 +798,7 @@ static const struct attribute_group swap_attr_group=
 =3D {
> >       .attrs =3D swap_attrs,
> >  };
> >
> > -static int __init swap_init_sysfs(void)
> > +static int __init swap_init(void)
> >  {
> >       int err;
> >       struct kobject *swap_kobj;
> > @@ -822,11 +813,13 @@ static int __init swap_init_sysfs(void)
> >               pr_err("failed to register swap group\n");
> >               goto delete_obj;
> >       }
> > +     /* swap_space is set RO after init, so do it here before init end=
s. */
> > +     mapping_set_no_writeback_tags(&swap_space);
> >       return 0;
> >
> >  delete_obj:
> >       kobject_put(swap_kobj);
> >       return err;
> >  }
> > -subsys_initcall(swap_init_sysfs);
> > +subsys_initcall(swap_init);
> >  #endif
> > diff --git a/mm/swap_table.h b/mm/swap_table.h
> > new file mode 100644
> > index 000000000000..ed9676547071
> > --- /dev/null
> > +++ b/mm/swap_table.h
> > @@ -0,0 +1,106 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _MM_SWAP_TABLE_H
> > +#define _MM_SWAP_TABLE_H
> > +
> > +#include "swap.h"
> > +
> > +/*
> > + * A swap table entry represents the status of a swap slot on a swap
> > + * (physical or virtual) device. The swap table in each cluster is a
> > + * 1:1 map of the swap slots in this cluster.
> > + *
> > + * Each swap table entry could be a pointer (folio), a XA_VALUE
> > + * (shadow), or NULL.
> > + */
> > +
> > +/*
> > + * Helpers for casting one type of info into a swap table entry.
> > + */
> > +static inline unsigned long null_to_swp_tb(void)
> > +{
> > +     BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(atomic_long_t));
> > +     return 0;
> > +}
> > +
> > +static inline unsigned long folio_to_swp_tb(struct folio *folio)
> > +{
> > +     BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(void *));
> > +     return (unsigned long)folio;
> > +}
> > +
> > +static inline unsigned long shadow_swp_to_tb(void *shadow)
> > +{
> > +     BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=3D
> > +                  BITS_PER_BYTE * sizeof(unsigned long));
> > +     VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
> > +     return (unsigned long)shadow;
> > +}
> > +
> > +/*
> > + * Helpers for swap table entry type checking.
> > + */
> > +static inline bool swp_tb_is_null(unsigned long swp_tb)
> > +{
> > +     return !swp_tb;
> > +}
> > +
> > +static inline bool swp_tb_is_folio(unsigned long swp_tb)
> > +{
> > +     return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
> > +}
> > +
> > +static inline bool swp_tb_is_shadow(unsigned long swp_tb)
> > +{
> > +     return xa_is_value((void *)swp_tb);
> > +}
> > +
> > +/*
> > + * Helpers for retrieving info from swap table.
> > + */
> > +static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
> > +{
> > +     VM_WARN_ON(!swp_tb_is_folio(swp_tb));
> > +     return (void *)swp_tb;
> > +}
> > +
> > +static inline void *swp_tb_to_shadow(unsigned long swp_tb)
> > +{
> > +     VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
> > +     return (void *)swp_tb;
> > +}
> > +
> > +/*
> > + * Helpers for accessing or modifying the swap table of a cluster,
> > + * the swap cluster must be locked.
> > + */
> > +static inline void __swap_table_set(struct swap_cluster_info *ci,
> > +                                 unsigned int off, unsigned long swp_t=
b)
> > +{
> > +     VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +     atomic_long_set(&ci->table[off], swp_tb);
> > +}
> > +
> > +static inline unsigned long __swap_table_get(struct swap_cluster_info =
*ci,
> > +                                          unsigned int off)
> > +{
> > +     VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +     return atomic_long_read(&ci->table[off]);
> > +}
> > +
> > +static inline void __swap_table_set_folio(struct swap_cluster_info *ci=
,
> > +                                       unsigned int off, struct folio =
*folio)
> > +{
> > +     __swap_table_set(ci, off, folio_to_swp_tb(folio));
> > +}
> > +
> > +static inline void __swap_table_set_shadow(struct swap_cluster_info *c=
i,
> > +                                        unsigned int off, void *shadow=
)
> > +{
> > +     __swap_table_set(ci, off, shadow_swp_to_tb(shadow));
> > +}
> > +
> > +static inline void __swap_table_init_null(struct swap_cluster_info *ci=
, unsigned int off)
> > +{
> > +     __swap_table_set(ci, off, null_to_swp_tb());
> > +}
> > +#endif
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 85606fbebf0f..df68b5e242a6 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -46,6 +46,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <linux/swapops.h>
> >  #include <linux/swap_cgroup.h>
> > +#include "swap_table.h"
> >  #include "internal.h"
> >  #include "swap.h"
> >
> > @@ -268,7 +269,7 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
> >       if (!need_reclaim)
> >               goto out_unlock;
> >
> > -     delete_from_swap_cache(folio);
> > +     swap_cache_del_folio(folio);
> >       folio_set_dirty(folio);
> >       ret =3D nr_pages;
> >  out_unlock:
> > @@ -422,6 +423,34 @@ static inline unsigned int cluster_offset(struct s=
wap_info_struct *si,
> >       return cluster_index(si, ci) * SWAPFILE_CLUSTER;
> >  }
> >
> > +static int swap_table_alloc_table(struct swap_cluster_info *ci)
> > +{
> > +     WARN_ON(ci->table);
> > +     ci->table =3D kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, G=
FP_KERNEL);
> > +     if (!ci->table)
> > +             return -ENOMEM;
> > +     return 0;
> > +}
> > +
> > +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> > +{
> > +     unsigned int ci_off;
> > +     unsigned long swp_tb;
> > +
> > +     if (!ci->table)
> > +             return;
> > +
> > +     for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> > +             swp_tb =3D __swap_table_get(ci, ci_off);
> > +             if (!swp_tb_is_null(swp_tb))
> > +                     pr_err_once("swap: unclean swap space on swapoff:=
 0x%lx",
> > +                                 swp_tb);
> > +     }
> > +
> > +     kfree(ci->table);
> > +     ci->table =3D NULL;
> > +}
> > +
> >  static void move_cluster(struct swap_info_struct *si,
> >                        struct swap_cluster_info *ci, struct list_head *=
list,
> >                        enum swap_cluster_flags new_flags)
> > @@ -704,6 +733,25 @@ static bool cluster_scan_range(struct swap_info_st=
ruct *si,
> >       return true;
> >  }
> >
> > +/*
> > + * Currently, the swap table is not used for count tracking,
> > + * just do a sanity check to ensure nothing went wrong.
> > + */
> > +static void cluster_table_check(struct swap_cluster_info *ci,
> > +                             unsigned int start, unsigned int nr)
> > +{
> > +     unsigned int ci_off =3D start % SWAPFILE_CLUSTER;
> > +     unsigned int ci_end =3D ci_off + nr;
> > +     unsigned long swp_tb;
> > +
> > +     if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> > +             do {
> > +                     swp_tb =3D __swap_table_get(ci, ci_off);
> > +                     VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
> > +             } while (++ci_off < ci_end);
> > +     }
> > +}
> > +
> >  static bool cluster_alloc_range(struct swap_info_struct *si, struct sw=
ap_cluster_info *ci,
> >                               unsigned int start, unsigned char usage,
> >                               unsigned int order)
> > @@ -723,6 +771,7 @@ static bool cluster_alloc_range(struct swap_info_st=
ruct *si, struct swap_cluster
> >               ci->order =3D order;
> >
> >       memset(si->swap_map + start, usage, nr_pages);
> > +     cluster_table_check(ci, start, nr_pages);
> >       swap_range_alloc(si, nr_pages);
> >       ci->count +=3D nr_pages;
> >
> > @@ -1100,8 +1149,7 @@ static void swap_range_alloc(struct swap_info_str=
uct *si,
> >  static void swap_range_free(struct swap_info_struct *si, unsigned long=
 offset,
> >                           unsigned int nr_entries)
> >  {
> > -     unsigned long begin =3D offset;
> > -     unsigned long end =3D offset + nr_entries - 1;
> > +     unsigned long start =3D offset, end =3D offset + nr_entries - 1;
>
> And this kind of clean up or code style adjustment, adding them here will
> distract people from focusing on swap table introducing.

+1. The "begin" to "start" change is not necessary. The other reason
to nitpick is that I might be the one writing the original "begin". It
sounds like a word I would use to pair with "end". I do recall I wrote
"begin" and "end" somewhere before, I forget if this function or not.
Pure nitpick anyway. Renaming itself is trivial. Just try to not do
unnecessary rename.

> >       void (*swap_slot_free_notify)(struct block_device *, unsigned lon=
g);
> >       unsigned int i;
> >
> > @@ -1125,7 +1173,7 @@ static void swap_range_free(struct swap_info_stru=
ct *si, unsigned long offset,
> >                       swap_slot_free_notify(si->bdev, offset);
> >               offset++;
> >       }
> > -     clear_shadow_from_swap_cache(si->type, begin, end);
> > +     __swap_cache_clear_shadow(swp_entry(si->type, start), nr_entries)=
;
> >
> >       /*
> >        * Make sure that try_to_unuse() observes si->inuse_pages reachin=
g 0
> > @@ -1282,15 +1330,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t =
gfp)
> >       if (!entry.val)
> >               return -ENOMEM;
> >
> > -     /*
> > -      * XArray node allocations from PF_MEMALLOC contexts could
> > -      * completely exhaust the page allocator. __GFP_NOMEMALLOC
> > -      * stops emergency reserves from being allocated.
> > -      *
> > -      * TODO: this could cause a theoretical memory reclaim
> > -      * deadlock in the swap out path.
> > -      */
> > -     if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL)=
)
> > +     if (swap_cache_add_folio(entry, folio, NULL))
> >               goto out_free;
> >
> >       return 0;
> > @@ -1557,6 +1597,7 @@ static void swap_entries_free(struct swap_info_st=
ruct *si,
> >
> >       mem_cgroup_uncharge_swap(entry, nr_pages);
> >       swap_range_free(si, offset, nr_pages);
> > +     cluster_table_check(ci, offset, nr_pages);
> >
> >       if (!ci->count)
> >               free_cluster(si, ci);
> > @@ -1760,7 +1801,7 @@ bool folio_free_swap(struct folio *folio)
> >       if (folio_swapped(folio))
> >               return false;
> >
> > -     delete_from_swap_cache(folio);
> > +     swap_cache_del_folio(folio);
> >       folio_set_dirty(folio);
> >       return true;
> >  }
> > @@ -2634,6 +2675,18 @@ static void wait_for_allocation(struct swap_info=
_struct *si)
> >       }
> >  }
> >
> > +static void free_cluster_info(struct swap_cluster_info *cluster_info,
> > +                           unsigned long maxpages)
> > +{
> > +     int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> > +
> > +     if (!cluster_info)
> > +             return;
> > +     for (i =3D 0; i < nr_clusters; i++)
> > +             swap_cluster_free_table(&cluster_info[i]);
> > +     kvfree(cluster_info);
> > +}
> > +
> >  /*
> >   * Called after swap device's reference count is dead, so
> >   * neither scan nor allocation will use it.
> > @@ -2768,12 +2821,13 @@ SYSCALL_DEFINE1(swapoff, const char __user *, s=
pecialfile)
> >
> >       swap_file =3D p->swap_file;
> >       p->swap_file =3D NULL;
> > -     p->max =3D 0;
> >       swap_map =3D p->swap_map;
> >       p->swap_map =3D NULL;
> >       zeromap =3D p->zeromap;
> >       p->zeromap =3D NULL;
> >       cluster_info =3D p->cluster_info;
> > +     free_cluster_info(cluster_info, p->max);
> > +     p->max =3D 0;
> >       p->cluster_info =3D NULL;
> >       spin_unlock(&p->lock);
> >       spin_unlock(&swap_lock);
> > @@ -2784,10 +2838,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, sp=
ecialfile)
> >       p->global_cluster =3D NULL;
> >       vfree(swap_map);
> >       kvfree(zeromap);
> > -     kvfree(cluster_info);
> >       /* Destroy swap account information */
> >       swap_cgroup_swapoff(p->type);
> > -     exit_swap_address_space(p->type);
> >
> >       inode =3D mapping->host;
> >
> > @@ -3171,8 +3223,11 @@ static struct swap_cluster_info *setup_clusters(=
struct swap_info_struct *si,
> >       if (!cluster_info)
> >               goto err;
> >
> > -     for (i =3D 0; i < nr_clusters; i++)
> > +     for (i =3D 0; i < nr_clusters; i++) {
> >               spin_lock_init(&cluster_info[i].lock);
> > +             if (swap_table_alloc_table(&cluster_info[i]))
> > +                     goto err_free;
> > +     }
> >
> >       if (!(si->flags & SWP_SOLIDSTATE)) {
> >               si->global_cluster =3D kmalloc(sizeof(*si->global_cluster=
),
> > @@ -3233,9 +3288,8 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
> >       }
> >
> >       return cluster_info;
> > -
> >  err_free:
> > -     kvfree(cluster_info);
> > +     free_cluster_info(cluster_info, maxpages);
> >  err:
> >       return ERR_PTR(err);
> >  }
> > @@ -3429,13 +3483,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, spe=
cialfile, int, swap_flags)
> >               }
> >       }
> >
> > -     error =3D init_swap_address_space(si->type, maxpages);
> > -     if (error)
> > -             goto bad_swap_unlock_inode;
> > -
> >       error =3D zswap_swapon(si->type, maxpages);
> >       if (error)
> > -             goto free_swap_address_space;
> > +             goto bad_swap_unlock_inode;
> >
> >       /*
> >        * Flush any pending IO and dirty mappings before we start using =
this
> > @@ -3470,8 +3520,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
> >       goto out;
> >  free_swap_zswap:
> >       zswap_swapoff(si->type);
> > -free_swap_address_space:
> > -     exit_swap_address_space(si->type);
> >  bad_swap_unlock_inode:
> >       inode_unlock(inode);
> >  bad_swap:
> > @@ -3486,7 +3534,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
> >       spin_unlock(&swap_lock);
> >       vfree(swap_map);
> >       kvfree(zeromap);
> > -     kvfree(cluster_info);
> > +     if (cluster_info)
> > +             free_cluster_info(cluster_info, maxpages);
> >       if (inced_nr_rotate_swap)
> >               atomic_dec(&nr_rotate_swap);
> >       if (swap_file)
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index b0afd7f41a22..1ed3cf9dac4e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -730,13 +730,18 @@ static int __remove_mapping(struct address_space =
*mapping, struct folio *folio,
> >  {
> >       int refcount;
> >       void *shadow =3D NULL;
> > +     struct swap_cluster_info *ci;
> >
> >       BUG_ON(!folio_test_locked(folio));
> >       BUG_ON(mapping !=3D folio_mapping(folio));
> >
> > -     if (!folio_test_swapcache(folio))
> > +     if (folio_test_swapcache(folio)) {
> > +             ci =3D swap_cluster_lock_by_folio_irq(folio);
> > +     } else {
> >               spin_lock(&mapping->host->i_lock);
> > -     xa_lock_irq(&mapping->i_pages);
> > +             xa_lock_irq(&mapping->i_pages);
> > +     }
> > +
> >       /*
> >        * The non racy check for a busy folio.
> >        *
> > @@ -776,9 +781,9 @@ static int __remove_mapping(struct address_space *m=
apping, struct folio *folio,
> >
> >               if (reclaimed && !mapping_exiting(mapping))
> >                       shadow =3D workingset_eviction(folio, target_memc=
g);
> > -             __delete_from_swap_cache(folio, swap, shadow);
> > +             __swap_cache_del_folio(swap, folio, shadow);
> >               memcg1_swapout(folio, swap);
> > -             xa_unlock_irq(&mapping->i_pages);
> > +             swap_cluster_unlock_irq(ci);
> >               put_swap_folio(folio, swap);
> >       } else {
> >               void (*free_folio)(struct folio *);
> > @@ -816,9 +821,12 @@ static int __remove_mapping(struct address_space *=
mapping, struct folio *folio,
> >       return 1;
> >
> >  cannot_free:
> > -     xa_unlock_irq(&mapping->i_pages);
> > -     if (!folio_test_swapcache(folio))
> > +     if (folio_test_swapcache(folio)) {
> > +             swap_cluster_unlock_irq(ci);
> > +     } else {
> > +             xa_unlock_irq(&mapping->i_pages);
> >               spin_unlock(&mapping->host->i_lock);
> > +     }
> >       return 0;
> >  }
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index ee443b317ac7..c869859eec77 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1166,7 +1166,7 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
> >
> >  out:
> >       if (ret && ret !=3D -EEXIST) {
> > -             delete_from_swap_cache(folio);
> > +             swap_cache_del_folio(folio);
> >               folio_unlock(folio);
> >       }
> >       folio_put(folio);
> > --
> > 2.51.0
> >
>

