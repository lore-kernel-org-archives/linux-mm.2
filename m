Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42B1606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQZ9yaxV
Received: by kanga.kvack.org (Postfix)
	id 786A16B05B4; Tue, 10 Nov 2026 22:52:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A0E6B05B5; Tue, 10 Nov 2026 22:52:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9256B05B6; Tue, 10 Nov 2026 22:52:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22CD76B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:52:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 794011A01FA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:52:33 +0000 (UTC)
X-FDA: 85421466186.29.C2006AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C38D3140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:52:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQZ9yaxV;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794369152;
	b=IGSgNcVYd3qV3rvJEThXVQDQJKQ04KUSrzjzlQhZu/DzNJ40oViVOze9nor4AqaIEA2hqv
	XHUVCjDDO7+VftMW4AlJp0HYREm5Eohsa4fUjGHZf+Y894XgEMRtcb0mMEwEQcyxFWQpFM
	WKkuwsVLGeRpSb6CZu5vZ8VlALXSWr8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQZ9yaxV;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794369152;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCA4lVRwhEIsdu+0oYpfIPzauvwmKP4p1xEn9giGvwg=;
	b=nObZidnnXl60EP8E3L4FzerQzuUbvGX0SOPyRg7TMcjLPyF+adgEQXGCsiPH5C8QIztPLs
	uMuqpuJylHq8Bn0WOUO2HgzxvYzEvAS1sIxQuefQLBm5k7O56VCYYBnCdXCKhxDX7lARlr
	iYN2/pBJhzmZl5ivtblz+CWrVAbnyqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B2FC4590F;
	Wed, 11 Nov 2026 03:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98111F0089F;
	Wed, 11 Nov 2026 03:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794369151;
	bh=PCA4lVRwhEIsdu+0oYpfIPzauvwmKP4p1xEn9giGvwg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BQZ9yaxVXpnLAOPMHGgEL+3Wa0NjNQsATdFfrV1HeHXR6vaNQP5Pz+O4pV/0B/t+6
	 GzCu1UEte2D5+B0Sbard+OyvWwkvefqIXKchyEXoHrqzXACHIsq8iodInvUoDbeY5X
	 d6bCqPV9zZdVFJPDJa6Oby9278ZBbk93edpKQlwr5CEfHMql/gYAwjHRsQ9qcdlIMV
	 VDwzfGlwaiDO82GOIEBC7IkL4fImnX3VvCbjxpzNEl/pRnQCFTAJ+YWNRxkMLHptlF
	 +RMQb2XllIcBKjKyrNZPkovXhCiZVlvadrItg+osSSw0ulN81kSN4YbUD2iGn7WqTt
	 wJ8rkk5fXf+xA==
Message-ID: <sashiko-outbox-208242@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/3] mm: enable filesystem page-cache large folios
 without THP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fang Xieyan" <fangxy@xiaopeng.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew Wilcox" <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Hugh Dickins" <hughd@google.com>, "Carlos Maiolino" <cem@kernel.org>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, linux-mm@kvack.org, "Liu Chao" <liuc63@xiaopeng.com>
In-Reply-To: <20261110035205.3036-4-fangxy@xiaopeng.com>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
 <20261110035205.3036-4-fangxy@xiaopeng.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:52:29 +0000
X-Stat-Signature: 9kara7m4bpzbaz4yc5eota4d4npfyt6y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C38D3140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794369151-711751
X-HE-Meta: U2FsdGVkX19wkay5ZM458JR7VzI1e43CQJKrlZ+GRKWzg0VXzjkG98ZwGBEy3ir7EUnwRksez2/EJ5F5RiDD7sr+Zi8kQsDlHg2oMq6+oMSx+ZtDFqoP+2GzwxNbKxNN6Ollv5tlp2JRNDHsCwWodnWgCrbUQTa3HAbs6iAV+6sbkv8yA9eCJ04f9yL/fRCP3xGbOnc6sN462dGCEsaQA8Eh/xr4Qdz1I681fPnO3o82o82v9P2Fb3GBaOHzunDBrhViSfyHyU2/ZC7KKgDCvdmjAAZPFyUm61inMPk3lurOQt2nWvgVYTWYDPiYjE/dmfnRSOzSS8BhwZdo8odlZA7y/0sOir6kTsOi8P+PhZGOJG9fQyzvf2Cm1sN56S2d44KddlS1tm7SPOH7H8ffLYA79LUVL0m7riruxR5PYyXLggs+s/2Z4tyo7Os5aluiayV8cjRMdx1GOltRzCLsY+uKtBFciuMDQr64pDLHVAaJ5/xGEJKIo1QSj6Jo2MEKDy3/JgzZjQIdoCO9HU14FNToXX1xdj9VKlUrDlWtVdOYpA+5Jusv8ZXGC4IMVvacqnv+t+ZyOUV6C0OwI4ORB+Af4UmhQi09j4mV4uUVwXUZWbDN+uQzleug0xh/fpJVETCaN8+hsmOHXH2ohbpGCVXWO+u/GJ9XwhUVAoG7LctvNqfqOvHyZkkXyO46OVN8mkLWpHH1hR8wO0iQ26Ikl1suiGZZcfTlrUVeNebAr19spfMTWf4bzDMwnhU4aNU7PI5hGhBQwSOOmbjLWhPMUemiKP51t4GDs7K4m/aKzXsxnrc5vQc/VZp806DHtvo9/EOWAIjJvDM0JPH5DdotUJRUYbVbPIp8sVu/u55e7TAYdTBVEAvw6eT+jREnKNNie4vigN2Tcnid8hj/aZl0dRke4pGex+SC508HM3F5iUBOMTPBFrf34yp+yctoK/9XzXvQO42CvI/rwhjtJu0
 M3thM5yO
 NIw9OGcDa2NagQ0QYz9naLcJT0wpx25BgaJMdTuKHN4uJbHypokRjhkY03BOfH/j26U4XPMCDT3QEYkadpnVuRHz1wV1Y5XXZXIyz7DkgnxtP/H7P4fqH9My5cxPdtjAEi37QA0X4KpnqP19bu2k++zF3oUOzZ4gZi9Djl/k1UJpTIl35jTXUJ0w0rrd2ZFRBmxCVAVfhb1sNcCDOjQQMIwaYRqvWai5G1mGfJuAAHxR3C8yeYDZxy8sNZ+29c/Lq3AjtGMJ1Dyr4QWhXTeH/ipVPPEKhNksWsrU0CqdIz+vv6VI2xyDsPY9iJzAwgCjEx9VCFendwUPwzkDnr/5FOnwBtP77np0jtC1v2675XBOYv1OmA2AE38qQyors8MP+K4Gx+1RxhvkdyIE+keSd+eo3JGGnkqewxbMUqfsJjrUoTEyLTSiBTMatolSSAXEBB8bDGyMP0wNudQsVA4T3dnxAaZ7D09M5A3SAKzUA1taJ1eROMWXWLn1gJMJU+O9x4RD98NoMGQtQPkfNwelvgultdI4/7HCMNtwxOR1Nh9k8ZI+j6T45uqqnYKG2Qh6wQS4AkOiD/hyVbaxX4MOdxmyFvF+Ixs60jpJ7bqEz3bkNItBi31dx06h0tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: PG_has_hwpoisoned stays gated on THP when
  CONFIG_LARGE_FOLIO=3Dy
- [Medium] mm: MAX_PAGECACHE_ORDER is not clamped to MAX_PAGE_ORDER
  without THP
- [Medium] mm: LARGE_FOLIO does not select MM_ID for
  folio_maybe_mapped_shared()
--

commit f8230ba10447d9debf48d1c6aebdac69481344a4
Author: Fang Xieyan <fangxy@xiaopeng.com>

mm: enable filesystem page-cache large folios without THP

This commit gates the page-cache folio order accessors on CONFIG_LARGE_FOLIO
in addition to CONFIG_TRANSPARENT_HUGEPAGE so filesystems that opt in to
large folios can use them without THP enabled, while keeping shmem gated on
CONFIG_TRANSPARENT_HUGEPAGE.

> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 73af18a373670..2102733c109c3 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -393,7 +393,8 @@ static inline void mapping_set_gfp_mask(struct addres=
s_space *m, gfp_t mask)
>   */
>  static inline size_t mapping_max_folio_size_supported(void)
>  {
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
> +	    IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
>  	return PAGE_SIZE;
>  }

[Severity: Medium]
Can MAX_PAGECACHE_ORDER exceed MAX_PAGE_ORDER when CONFIG_LARGE_FOLIO is
enabled without CONFIG_TRANSPARENT_HUGEPAGE?

Without THP, PREFERRED_MAX_PAGECACHE_ORDER is 8 and MAX_PAGECACHE_ORDER is
only clamped to MAX_XAS_ORDER.  On configurations where MAX_PAGE_ORDER < 8
(such as powerpc or sh with 64K pages and a smaller ARCH_FORCE_MAX_ORDER),
mapping_set_large_folios() sets mapping_max_folio_order() to 8.  Once
sequential readahead in page_cache_ra_order() scales ra->order above
MAX_PAGE_ORDER, ra_alloc_folio() -> filemap_alloc_folio() is rejected by
alloc_order_allowed() without retrying smaller orders, aborting large-folio
readahead and falling back to order-0 allocations in do_page_cache_ra().

> @@ -418,7 +419,8 @@ static inline void mapping_set_folio_order_range(stru=
ct address_space *mapping,
>  						 unsigned int min,
>  						 unsigned int max)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return;
> =20
>  	if (min > MAX_PAGECACHE_ORDER)
> @@ -459,7 +461,8 @@ static inline void mapping_set_large_folios(struct ad=
dress_space *mapping)
>  static inline unsigned int
>  mapping_max_folio_order(const struct address_space *mapping)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 0;
>  	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
>  }
> @@ -467,7 +470,8 @@ mapping_max_folio_order(const struct address_space *m=
apping)
>  static inline unsigned int
>  mapping_min_folio_order(const struct address_space *mapping)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 0;
>  	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
>  }
> @@ -500,8 +504,9 @@ static inline pgoff_t mapping_align_index(const struc=
t address_space *mapping,
>  }
> =20
>  /*
> - * Large folio support currently depends on THP.  These dependencies are
> - * being worked on but are not yet fixed.
> + * Large folio support is opt-in per mapping and requires CONFIG_LARGE_F=
OLIO.
> + * It does not depend on THP; CONFIG_LARGE_FOLIO defaults to y when
> + * CONFIG_TRANSPARENT_HUGEPAGE is enabled.
>   */
>  static inline bool mapping_large_folio_support(const struct address_spac=
e *mapping)
>  {

[Severity: High]
Should FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE) in
include/linux/page-flags.h also be enabled for CONFIG_LARGE_FOLIO?

include/linux/page-flags.h:
    #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPA=
GE)
    FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
    #else
    FOLIO_FLAG_FALSE(has_hwpoisoned)
    #endif

With CONFIG_LARGE_FOLIO=3Dy, CONFIG_TRANSPARENT_HUGEPAGE=3Dn, and
CONFIG_MEMORY_FAILURE=3Dy, folio_set_has_hwpoisoned() is a no-op and
folio_test_has_hwpoisoned() always returns false.  When memory_failure()
poisons a tail page of a large page-cache folio and the folio remains large
after split_huge_page_to_order(p, min_order_for_split(folio)) (for example
when mapping_min_folio_order() > 0 or splitting fails),
folio_contain_hwpoisoned_page() returns false.  shrink_folio_list() then
reclaims and frees the poisoned large folio instead of skipping it, and
__free_pages_prepare() (which only intercepts order-0 PageHWPoison pages)
either triggers bad_page() or returns the poisoned tail page to the buddy
allocator.

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9f97ad6982bc8..7bbed71af85b4 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -831,13 +831,20 @@ config LARGE_FOLIO
>  	bool "Large folio support for the page cache (without THP)" if !TRANSPA=
RENT_HUGEPAGE
>  	depends on MMU
>  	select XARRAY_MULTI
> +	# Keep LARGE_FOLIO enabled whenever THP is enabled:
> +	# huge_memory.o is built for TRANSPARENT_HUGEPAGE and calls into
> +	# folio_split.o, which is built for LARGE_FOLIO.
>  	default y if TRANSPARENT_HUGEPAGE
>  	default n

[Severity: Medium]
Should LARGE_FOLIO also select MM_ID (or MM_ID if !PREEMPT_RT) like
TRANSPARENT_HUGEPAGE does?

include/linux/mm.h:folio_maybe_mapped_shared() {
    ...
	if (!IS_ENABLED(CONFIG_MM_ID))
		return true;

	if (mapcount <=3D 1)
		return false;
    ...
}

When CONFIG_LARGE_FOLIO=3Dy and CONFIG_TRANSPARENT_HUGEPAGE=3Dn, CONFIG_MM_=
ID is
not selected, so folio_maybe_mapped_shared() unconditionally returns true f=
or
every large page-cache folio even when mapped by a single process with
mapcount <=3D 1.  As a result, unprivileged move_pages() fails with -EACCES=
 in
__add_folio_for_migration(), mbind(MPOL_MF_MOVE) and migrate_pages() skip
those folios in migrate_folio_add(), and MADV_COLD / MADV_PAGEOUT refuse to
split sub-ranges in madvise_cold_or_pageout_pte_range().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110035205.3036=
-1-fangxy@xiaopeng.com?part=3D3

