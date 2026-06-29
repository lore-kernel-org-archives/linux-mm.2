Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9ABC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1406B0005; Sun, 28 Jun 2026 23:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80816B0088; Sun, 28 Jun 2026 23:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6AD46B008A; Sun, 28 Jun 2026 23:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9D56B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:32:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCD871A0576
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:32:07 +0000 (UTC)
X-FDA: 84931526694.28.BB518DF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8410E1C0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:32:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GEmekPgR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782703926;
	b=etDroyNfcHFwEsgnASDjBg5gfMWMhDsIQ3rFYFtJJozXvl7yBi6UeUReOCJFAQOloPESwJ
	zmMLUBMGB6JrhnsIX3rUX79vm7ACh+XMV30aMhimNh5+VGqBuY/imBpc5ou7KjXbvpByzi
	PkdByEcqY8+3Ci+YeJmmc8UyPxLevGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782703926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNKmGiCuddpqva0PjrNytIXZttDwC5/AURmvzNbNX1k=;
	b=unEnPQgYXhNT9POSKnQFnHKcT4jX1HGYbXdWV+fiaW/thhPYcegcK7t2D8n0yvHyygh2JL
	mIFlS/oIiHUTsBSt7by9C+i2awVNaL/xtk0Mv4rFoPGh3FDVuC97EwNcV/SR2JUFKWeXXX
	8fFueRwCLH2OJD2BYFihj/sgxuqtTI0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GEmekPgR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782703923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNKmGiCuddpqva0PjrNytIXZttDwC5/AURmvzNbNX1k=;
	b=GEmekPgRPXI1pHvo5Qd0OVY2ZmTtdImYJ7MjdfbjXWj8mYBQtpSZ9tRm+5F+2dKKhsyFMg
	PwxmKU681zwFlKBlWFwtwf61aaB+nc9v4jzHyMcq8iithc6koSqJyLzxKeACPdi6vNUhQX
	Fc9s3rhDLL5VzMjKkRdQkepH3vgpgBM=
Date: Mon, 29 Jun 2026 03:32:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <7561266d0aedbb55f3f67090fb2493f7a899b66e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Leon Hwang"
 <leon.hwang@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <e46ba0c9-6a24-45e5-99f8-b4f454887f50@kernel.org>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
 <925c8686-9ff6-44c1-9780-63bd7cd8a1c3@linux.dev>
 <e46ba0c9-6a24-45e5-99f8-b4f454887f50@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8410E1C0002
X-Rspam-User: 
X-Stat-Signature: 7y4ugizeejwyx5uhzcrrt5m5r51hcohj
X-HE-Tag: 1782703925-67281
X-HE-Meta: U2FsdGVkX19a7ejQx4cYJ/YzIoAlxXLcqYErF7sd3cvae9QZgrx2cE/FAfNqpUp6MQv1UO2wWjnlLJoTrtGZw7gqoVB9Bc4tUJIuJ7KO5uwMYERNyKb9B2tMIX4uSDHmDPJROuqVAHLGFqGSHN9FC6OpN8x+ZUOIfkCqVbXQn6IJHGAZoBiUBGvBkYOvTVPfH5eypxeWUqXEvIC6tXiHcWf1/TdgfactrYNjDG5oj0wrYC5b4anlcgENPkoQFGvi+CmxNSrHl3spKQio9INZvJmvsd6m2dHcUrI+sRB0R06VT/IA3If0SKliiCu6BU7lo4PS3IkUUtINSgoXwoWjktgPkdFrbEuAZjJalNpa85M9r/xn+eDEmkfi60SvdnuEneGaSvblu2duM8B5isNPqJ2Z0vbVg1TWk+XYmCIFzN+5jiC92iEd+Gzb+fXCZ/0yyhlAO/VofDM+E8HIDmzuIYYjTLDeggLVB0fXJQqDJrLUhW3olqMRoL71/UFo7hqTAei0RuDTK69b2PRJ+32N7npRnY5Bdwe6PUKamY5tM3OjeGtIQJpYTPIKmS+niXx9+tRStkPu6QIM47Zah3VxxkF8zamGD+CB+OYOk9iidtzESvkj1caL829/NHQto2lP96g6jLiTi0j7MZu71oNRZKmTV40MBOSQL2L1kQHjcAP59ur/q4OiFhvazmQbnQ/KYpC4prsKgNqr2q6mujtu5bKw4HNg4pwc2NpKu1x2Hp12m3V+kYwie3gIs5JB+gyamYcmPozKAIVm247tC2aj5uN1UWnk2cX4vLmYB2rGxT8sboxNNaEnRtGD38exaDx7cyT537g0r6jyfxmdImNMd4cUv+E0z/aUF8asChWO4xhzl6QjZ177Rjlfuo3o1JPyK5ZJ09iAdIcSUafOIFXJmECmpgHFuKbQv5TYd5LasROe38nvxrQ7o+yjJ/P9xlx8L70hDKCgAqHkiQO/L7X
 K+i7+Kue
 7uasOHSK7QCTQSw7pBBeAB7xoCUiKvWzr1SjIiFGadTzhLcCc+ckKaVeJUXHAkud5Q8/DzljlYhINQbFrAkBFMZfn4SBnDRXB+hOKK/XqahoY/NnSaAIMqi3bPm+FngSfyK079wwadx+hojBpUC2VkoxpJgmrAdUsc2uGzn0nHQYYU2gBg61I8wU2fYMf/uK8XtKywXSrubzuBWB9klZ0TiO5VqbXe93O+FoJrxgtqsKz0sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B46=E6=9C=8826=E6=97=A5 17:09, "David Hildenbrand (Arm)" <davi=
d@kernel.org mailto:david@kernel.org?to=3D%22David%20Hildenbrand%20(Arm)%=
22%20%3Cdavid%40kernel.org%3E > =E5=86=99=E5=88=B0:


>=20
>=20>=20
>=20> >=20
>=20> > static inline enum zone_type folio_zonenum(const struct folio *fo=
lio)
> > >  {
> > >  +#if ZONES_WIDTH !=3D 0
> > >  + ASSERT_EXCLUSIVE_BITS(folio->flags, ZONES_MASK << ZONES_PGSHIFT)=
;
> > >  +#endif
> > >  return memdesc_zonenum(folio->flags);
> > >  }
> > >=20
>=20>=20=20
>=20>  Better to factor out a common macro alongside a comment for these =
two '#if'?
> >=20
>=20Yes.
>=20
>=20And while looking at it, doesn't memdesc_section have similar problem=
s? And
> there are other callers of memdesc_zonenum we wouldn't handle. So the
> macro approach is only partially helpful I thing.
>=20
>=20Maybe we should just pass by reference and fixup all callers? Ends up=
 the cleanest.
>=20

Hi=20David,

I think pass by reference is better than macro.

Would you like to send this out as a formal patch yourself?
Or would you prefer I include it in my next version with your
Signed-off-by?

Best,
Hui

> Untested:
>=20
>=20From fb9b4e8c1d0419b960dc0cd4738d19d80d1fe14f Mon Sep 17 00:00:00 200=
1
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Fri, 26 Jun 2026 11:06:39 +0200
> Subject: [PATCH] mm: fix KASAN memdec_flags checks for zone/node/sectio=
n
>=20
>=20Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/asm-generic/memory_model.h | 2 +-
>  include/linux/mm.h | 23 +++++++++++++++--------
>  include/linux/mm_inline.h | 4 ++--
>  include/linux/mmzone.h | 24 ++++++++++++------------
>  mm/page_alloc.c | 6 +++---
>  mm/slab.h | 2 +-
>  mm/sparse.c | 2 +-
>  7 files changed, 35 insertions(+), 28 deletions(-)
>=20
>=20diff --git a/include/asm-generic/memory_model.h b/include/asm-generic=
/memory_model.h
> index efa6610acbc79..f8404bc7773c2 100644
> --- a/include/asm-generic/memory_model.h
> +++ b/include/asm-generic/memory_model.h
> @@ -53,7 +53,7 @@ static inline int pfn_valid(unsigned long pfn)
>  */
>  #define __page_to_pfn(pg) \
>  ({ const struct page *__pg =3D (pg); \
> - int __sec =3D memdesc_section(__pg->flags); \
> + int __sec =3D memdesc_section(&__pg->flags); \
>  (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)))=
; \
>  })
>=20=20
>=20diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbddb..3111e4a6c9c4c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2286,22 +2286,28 @@ static inline int page_zone_id(struct page *pag=
e)
>  }
>=20=20
>=20 #ifdef NODE_NOT_IN_PAGE_FLAGS
> -int memdesc_nid(memdesc_flags_t mdf);
> +int memdesc_nid(const memdesc_flags_t *mdf);
> +#elif defined(CONFIG_NUMA)
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
> +{
> + ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
> + return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
> +}
>  #else
> -static inline int memdesc_nid(memdesc_flags_t mdf)
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
>  {
> - return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
> + return 0;
>  }
>  #endif
>=20=20
>=20 static inline int page_to_nid(const struct page *page)
>  {
> - return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> + return memdesc_nid(&PF_POISONED_CHECK(page)->flags);
>  }
>=20=20
>=20 static inline int folio_nid(const struct folio *folio)
>  {
> - return memdesc_nid(folio->flags);
> + return memdesc_nid(&folio->flags);
>  }
>=20=20
>=20 #ifdef CONFIG_NUMA_BALANCING
> @@ -2541,12 +2547,13 @@ static inline void set_page_section(struct page=
 *page, unsigned long section)
>  page->flags.f |=3D (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
>  }
>=20=20
>=20-static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> +static inline unsigned long memdesc_section(const memdesc_flags_t *mdf=
)
>  {
> - return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> + ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
> + return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
>  #else /* !SECTION_IN_PAGE_FLAGS */
> -static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> +static inline unsigned long memdesc_section(const memdesc_flags_t *mdf=
)
>  {
>  return 0;
>  }
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a8430a7ae0544..efcddb9925add 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -650,7 +650,7 @@ static inline bool vma_has_recency(const struct vm_=
area_struct *vma)
>  static inline size_t num_pages_contiguous(struct page **pages, size_t =
nr_pages)
>  {
>  struct page *cur_page =3D pages[0];
> - unsigned long section =3D memdesc_section(cur_page->flags);
> + unsigned long section =3D memdesc_section(&cur_page->flags);
>  size_t i;
>=20=20
>=20 for (i =3D 1; i < nr_pages; i++) {
> @@ -660,7 +660,7 @@ static inline size_t num_pages_contiguous(struct pa=
ge **pages, size_t nr_pages)
>  * In unproblematic kernel configs, page_to_section() =3D=3D 0 and
>  * the whole check will get optimized out.
>  */
> - if (memdesc_section(cur_page->flags) !=3D section)
> + if (memdesc_section(&cur_page->flags) !=3D section)
>  break;
>  }
>=20=20
>=20diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca27121871475..19e709d7a13de 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1272,31 +1272,31 @@ static inline bool zone_is_empty(const struct z=
one *zone)
>  #define KASAN_TAG_MASK ((1UL << KASAN_TAG_WIDTH) - 1)
>  #define ZONEID_MASK ((1UL << ZONEID_SHIFT) - 1)
>=20=20
>=20-static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
> +static inline enum zone_type memdesc_zonenum(const memdesc_flags_t *fl=
ags)
>  {
> - ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
> - return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
> + ASSERT_EXCLUSIVE_BITS(flags->f, ZONES_MASK << ZONES_PGSHIFT);
> + return (flags->f >> ZONES_PGSHIFT) & ZONES_MASK;
>  }
>=20=20
>=20 static inline enum zone_type page_zonenum(const struct page *page)
>  {
> - return memdesc_zonenum(page->flags);
> + return memdesc_zonenum(&page->flags);
>  }
>=20=20
>=20 static inline enum zone_type folio_zonenum(const struct folio *folio=
)
>  {
> - return memdesc_zonenum(folio->flags);
> + return memdesc_zonenum(&folio->flags);
>  }
>=20=20
>=20 #ifdef CONFIG_ZONE_DEVICE
> -static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
> +static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
>  {
>  return memdesc_zonenum(mdf) =3D=3D ZONE_DEVICE;
>  }
>=20=20
>=20 static inline struct dev_pagemap *page_pgmap(const struct page *page=
)
>  {
> - VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(page->flags), page);
> + VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(&page->flags), page);
>  return page_folio(page)->pgmap;
>  }
>=20=20
>=20@@ -1311,9 +1311,9 @@ static inline struct dev_pagemap *page_pgmap(co=
nst struct page *page)
>  static inline bool zone_device_pages_have_same_pgmap(const struct page=
 *a,
>  const struct page *b)
>  {
> - if (memdesc_is_zone_device(a->flags) !=3D memdesc_is_zone_device(b->f=
lags))
> + if (memdesc_is_zone_device(&a->flags) !=3D memdesc_is_zone_device(&b-=
>flags))
>  return false;
> - if (!memdesc_is_zone_device(a->flags))
> + if (!memdesc_is_zone_device(&a->flags))
>  return true;
>  return page_pgmap(a) =3D=3D page_pgmap(b);
>  }
> @@ -1321,7 +1321,7 @@ static inline bool zone_device_pages_have_same_pg=
map(const struct page *a,
>  extern void memmap_init_zone_device(struct zone *, unsigned long,
>  unsigned long, struct dev_pagemap *);
>  #else
> -static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
> +static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
>  {
>  return false;
>  }
> @@ -1338,12 +1338,12 @@ static inline struct dev_pagemap *page_pgmap(co=
nst struct page *page)
>=20=20
>=20 static inline bool is_zone_device_page(const struct page *page)
>  {
> - return memdesc_is_zone_device(page->flags);
> + return memdesc_is_zone_device(&page->flags);
>  }
>=20=20
>=20 static inline bool folio_is_zone_device(const struct folio *folio)
>  {
> - return memdesc_is_zone_device(folio->flags);
> + return memdesc_is_zone_device(&folio->flags);
>  }
>=20=20
>=20 static inline bool is_zone_movable_page(const struct page *page)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f5..020a97ca018e9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6904,15 +6904,15 @@ static void __free_contig_range_common(unsigned=
 long pfn, unsigned long nr_pages
>  continue;
>  }
>=20=20
>=20- if (start && memdesc_section(page->flags) !=3D start_sec) {
> + if (start && memdesc_section(&page->flags) !=3D start_sec) {
>  free_prepared_contig_range(start, i - nr_start);
>  start =3D page;
>  nr_start =3D i;
> - start_sec =3D memdesc_section(page->flags);
> + start_sec =3D memdesc_section(&page->flags);
>  } else if (!start) {
>  start =3D page;
>  nr_start =3D i;
> - start_sec =3D memdesc_section(page->flags);
> + start_sec =3D memdesc_section(&page->flags);
>  }
>  }
>=20=20
>=20diff --git a/mm/slab.h b/mm/slab.h
> index bf2f87acf5e3a..1ae8e6084ba32 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -155,7 +155,7 @@ static inline void *slab_address(const struct slab =
*slab)
>=20=20
>=20 static inline int slab_nid(const struct slab *slab)
>  {
> - return memdesc_nid(slab->flags);
> + return memdesc_nid(&slab->flags);
>  }
>=20=20
>=20 static inline pg_data_t *slab_pgdat(const struct slab *slab)
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 16ac6df3c89fa..8e38477645131 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -43,7 +43,7 @@ static u8 section_to_node_table[NR_MEM_SECTIONS] __ca=
cheline_aligned;
>  static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
>  #endif
>=20=20
>=20-int memdesc_nid(memdesc_flags_t mdf)
> +int memdesc_nid(const memdesc_flags_t *mdf)
>  {
>  return section_to_node_table[memdesc_section(mdf)];
>  }
> --=20
>=202.43.0
>=20
>=20--=20
>=20Cheers,
>=20
>=20David
>

