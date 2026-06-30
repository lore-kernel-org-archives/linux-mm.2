Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896F4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8946B00AB; Tue, 30 Jun 2026 02:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0266B00AD; Tue, 30 Jun 2026 02:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D336B00AE; Tue, 30 Jun 2026 02:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41DF66B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:42:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD08AA03EC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:42:46 +0000 (UTC)
X-FDA: 84935635932.12.2AF7FDF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1DD41C000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:42:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=InGYtMgT;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782801765;
	b=4vmHdgPQzw9xMHrqnXvVlTPrT3v+WnCLVt5Mj4OE1TQf+udMHqC1m2VhvW/+JGRDCnp0lR
	93oQQUhiGfFpiE0WBXXuL1JI6epY3pMMd0fUnHIRKwtTh9i4AD4EtnyUtXm6yXw7WLS9pV
	p9n0w13UvM0XTbVHqNumpefjpAuUO5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782801765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tarce59fGC5j/stSUG0V3ACzUSnfP6AaIjAAmW7DrDQ=;
	b=KTAZdYHJyuSPr7V/otJK4kilndcvTecMmw6C+ttbmF1W/JFfgk+JGGDE5oQAycXrqvM9b4
	yXUPUs0IBngh4Er0YdQ8Rh9/b4a+3fJc1+xCYPUbb5lsf+bSJJxug3i3/7MGx29JhUNzpa
	Ep7MaqY9Ja4FyC1dO3NGraUdYwzh1iw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=InGYtMgT;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782801762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tarce59fGC5j/stSUG0V3ACzUSnfP6AaIjAAmW7DrDQ=;
	b=InGYtMgTyMUVQkPBQDQTLfs4raXM9/PoMZG5V7Az5EGgyg0eOsIBeIirDw2JiWvfuRafwb
	BvjqEVYC/YcTmlFM/2KrvifjObaLX8pKH+16BTdLnwn8toSO1ZvjY6eMkNlT7B6hbN7jMs
	oSwhhH1PGwhpuKBahSIyfYLJOMIovto=
Date: Tue, 30 Jun 2026 06:42:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <e8aaf66f00c2c54832df11fc183fd29ae7f63716@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v8] mm: fix ASSERT_EXCLUSIVE_BITS by passing
 memdesc_flags_t by pointer
To: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <20260630063216.417897-1-hui.zhu@linux.dev>
References: <20260630063216.417897-1-hui.zhu@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1DD41C000A
X-Stat-Signature: 9cs9sxzarchueo7oxcqaqhjqasgxccmy
X-HE-Tag: 1782801764-870851
X-HE-Meta: U2FsdGVkX19M+cJg/Vd8D54yROSF5S92272JRQNo+C51PjGag2Cth2fsbZm9DT6Vu2YkiFUi9FNeltWs8xt7zMCc+6yqXkJCntbs/k5IyzL57HtqjyhmECLovIB4bRUysvwfxpV1D7kgUGvwqLq0KiEyGUWsqbq5Jq9oi+HDQPp/IY0VcmY+9GNMMb/aGvgLSEvZvZaY6WFDYBmszZ+LNGHo996DJD0o8r3AhV2hkxpaCtgJBlq3laXT7efaRk6bSBL+TRanY2ZsXxyPSzl570W1R5dQUQw+VJf/gYKQZEUMg7UJj5HkMu7ioPXsRMX0JwH6xdr64UX4615+L18btCZFuIyCeKYXNECZdRezN0E7y/w2lwnsMAGMYDdBtDks55tk9AJgCdANe3eZciXc3kaWE1IUPXKFdrVzz684+2UF+mfrnyg0lkIagOAVqlIPvCUb4+AQaKixIimzxwTS76djkdajn7M0EY5SUC2gOzGDNn1yHenNHBU30/cwpJAa6V86JfXzSkPZWPZWeAT0aTod/gjLUq8oX48y6sYE9H8JQ4qzhTALLlSyyEsZ74tunFTiYluHXY7l/jFK6YGTlNEkoq35n7HEfKY+QcU077lsiNbtxDFVPBoWbS4rF/AWw//S1BVjo6xCCDRdSSZ3WucWsy3wyzp0mVVcowMGKItZI6I1LdxAbzsNJfnViZzvZPZEJKGeiA+lnj9hUcDmW9J/D9qlLa8TcKkIKhCXAlhwQ2i6tJkOSiJdyZdRIZELJc1eOZOdBy22kBIZyNpS4TIyYkp0aVF4UW8b9f8p1cE75C6kkk4wkj8+VQemEXnHMxULvvS7zi2QNJsIxKIc6uAZrW3qDoZoFVA80z/S3DU81oCOvP9MTSYgZZsd2EEnOEOAmZSJ4Fg58v7Ko2cYd7UTm4K0XRdMlS22PEu3sfFBxk5zinrKNb1ImL6Wxd6l9j3Eb2BxS635tI6OSEm
 DdugoBe1
 tV5I1vnDzN2JwNZTF+iuT8fX2U1RszSp/iL6EnYmEcm+5MdVoNqzzFDtmn9Y9PVRZWoXBWJHjuJdxKSOPeQlXV50pkGLR7NhRLtEGRK8LKdSqeSfGLu+9UFwRWbGEa6YZEFgnz30HMhgb6EfuZFbNNBUqNHVSXwwNDnRzwnOUV2ZDPY6Admlk3jVTKm6ErKCRY2Ipnw4p2vgYcIGUDOE/L42bLb0KJ8rqZ3o++adtAPG7lALeR4B3zswLO4XQbWLuWO+MZHMG26+xjtDrH58sLDDK095YqEhFUzLR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20From: Hui Zhu <zhuhui@kylinos.cn>
>=20
>=20KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
>=20
>=20 BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_g=
fp
>=20
>=20The race is benign: nid/zone bits are set once at page init and never
> overlap with PG_locked. However, ASSERT_EXCLUSIVE_BITS() inside
> memdesc_nid/zonenum() was checking a by-value copy of the flags word,
> not the live page->flags, so it failed to annotate the real access.
>=20
>=20Change memdesc_nid(), memdesc_zonenum(), memdesc_section(), and
> memdesc_is_zone_device() to take a const memdesc_flags_t * and update
> all callers to pass &page->flags / &folio->flags, so
> ASSERT_EXCLUSIVE_BITS() operates on the actual shared word.
>=20
>=20Guard the ASSERT_EXCLUSIVE_BITS() calls in memdesc_zonenum() and
> memdesc_section() under ZONES_WIDTH !=3D 0 / SECTIONS_WIDTH !=3D 0 to a=
void
> a zero-mask check on configs where the corresponding field is absent.
> Under CONFIG_NUMA=3Dn, stub out page_to_nid() and folio_nid() as plain
> "return 0" instead of reading page->flags when NODES_MASK is 0 and the
> check can never fire.

Please disregard this patch as I forgot to update the code for
SECTIONS_WIDTH to the git commit. I'm sorry.

Best,
Hui

>=20
>=20Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>=20
>=20Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v8:
> According to the comments of Andrew, include kcsan-checks.h in mm.h.
> Incorporate David's patch that switch memdesc_nid(), memdesc_zonenum(),
> memdesc_section() and memdesc_is_zone_device() to take a const
> memdesc_flags_t * instead of using a per-accessor macro/call-site hack.
> Update all callers accordingly and extend the same exclusive-bits check
> to memdesc_section() and memdesc_is_zone_device(), guarded by
> SECTIONS_WIDTH !=3D 0 / reusing ZONES_WIDTH !=3D 0 to avoid zero-mask c=
hecks
> on configs without the corresponding field.
> v7:
> According to the comments of Sashiko, restrict the memdesc_nid() macro
> to CONFIG_NUMA, keeping a plain "return 0" static inline stub otherwise=
,
> and re-add a local page pointer in page_to_nid() to avoid evaluating
> PF_POISONED_CHECK(page) twice.
> v6:
> According to the comments of David, turn memdesc_nid() from a static
> inline function into a macro so ASSERT_EXCLUSIVE_BITS() can check the
> caller's page->flags/folio->flags directly.
> v5:
> According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
> calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
> ZONES_WIDTH !=3D 0 (for zonenum).
> According to the comments of David, avoid calling
> PF_POISONED_CHECK(page) twice in page_to_nid().
> According to the warning of lkp, switch the CONFIG_NUMA=3Dn
> page_to_nid()/folio_nid() stubs from macros to static inline functions.
> v4:
> According to the comments of Andrew and Sashiko, set
> page_to_nid()/folio_nid() as static inline stubs returning 0
> under CONFIG_NUMA=3Dn.
> v3:
> According to the comments of Andrew and Sashiko, move
> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> into the page/folio call sites.
> v2:
> According to the comments of David, remove useless comments and use
> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> page_to_nid().
>=20
>=20 include/asm-generic/memory_model.h | 2 +-
>  include/linux/mm.h | 40 ++++++++++++++++++++++++------
>  include/linux/mm_inline.h | 4 +--
>  include/linux/mmzone.h | 26 ++++++++++---------
>  mm/page_alloc.c | 6 ++---
>  mm/slab.h | 2 +-
>  mm/sparse.c | 2 +-
>  7 files changed, 54 insertions(+), 28 deletions(-)
>=20
>=20diff --git a/include/asm-generic/memory_model.h b/include/asm-generic=
/memory_model.h
> index efa6610acbc7..f8404bc7773c 100644
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
> index 485df9c2dbdd..315d8917f8e7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -37,6 +37,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> +#include <linux/kcsan-checks.h>
>=20=20
>=20 struct mempolicy;
>  struct anon_vma;
> @@ -2286,23 +2287,45 @@ static inline int page_zone_id(struct page *pag=
e)
>  }
>=20=20
>=20 #ifdef NODE_NOT_IN_PAGE_FLAGS
> -int memdesc_nid(memdesc_flags_t mdf);
> +int memdesc_nid(const memdesc_flags_t *mdf);
>  #else
> -static inline int memdesc_nid(memdesc_flags_t mdf)
> +#ifdef CONFIG_NUMA
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
>  {
> - return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
> + ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
> + return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
> +}
> +#else
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
> +{
> + return 0;
>  }
>  #endif
> +#endif
>=20=20
>=20+#ifdef CONFIG_NUMA
>  static inline int page_to_nid(const struct page *page)
>  {
> - return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> + const struct page *p =3D PF_POISONED_CHECK(page);
> +
> + return memdesc_nid(&p->flags);
>  }
>=20=20
>=20 static inline int folio_nid(const struct folio *folio)
>  {
> - return memdesc_nid(folio->flags);
> + return memdesc_nid(&folio->flags);
>  }
> +#else
> +static inline int page_to_nid(const struct page *page)
> +{
> + return 0;
> +}
> +
> +static inline int folio_nid(const struct folio *folio)
> +{
> + return 0;
> +}
> +#endif
>=20=20
>=20 #ifdef CONFIG_NUMA_BALANCING
>  /* page access time bits needs to hold at least 4 seconds */
> @@ -2541,12 +2564,13 @@ static inline void set_page_section(struct page=
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
> index a8430a7ae054..efcddb9925ad 100644
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
> index ca2712187147..e60dad546ca6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1272,31 +1272,33 @@ static inline bool zone_is_empty(const struct z=
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
> +#if ZONES_WIDTH !=3D 0
> + ASSERT_EXCLUSIVE_BITS(flags->f, ZONES_MASK << ZONES_PGSHIFT);
> +#endif
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
>=20@@ -1311,9 +1313,9 @@ static inline struct dev_pagemap *page_pgmap(co=
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
> @@ -1321,7 +1323,7 @@ static inline bool zone_device_pages_have_same_pg=
map(const struct page *a,
>  extern void memmap_init_zone_device(struct zone *, unsigned long,
>  unsigned long, struct dev_pagemap *);
>  #else
> -static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
> +static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
>  {
>  return false;
>  }
> @@ -1338,12 +1340,12 @@ static inline struct dev_pagemap *page_pgmap(co=
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
> index ee902a468c2f..020a97ca018e 100644
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
> index 281a65233795..9ded319495a0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -179,7 +179,7 @@ static inline void *slab_address(const struct slab =
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
> index 16ac6df3c89f..8e3847764513 100644
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
>

