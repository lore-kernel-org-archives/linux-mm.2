Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1420C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA5D6B008A; Sun,  2 Aug 2026 12:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674A56B0092; Sun,  2 Aug 2026 12:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5171D6B0093; Sun,  2 Aug 2026 12:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0866B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:10:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71151C0515
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:10:21 +0000 (UTC)
X-FDA: 85056816642.30.B96FA44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C900F40004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:10:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCjHLJsC;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785687019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UiUtk8mYd6dVW+H2bsjpuN7YlklJl1Nd89zFSg72gE=;
	b=XIldpherJSOXR/q04xcE1sK/A8qhAQ8Ea8uIX2yX1UtcdYzqZKcxYPc99mOh9boctipIl2
	Ie3tm8kBGs9UpJYN6jOyEvu8VVxNavjdboku7WBug4YX7/ARReuwV2lk0sWL6MMSZpGijd
	9PBz5RI3tglv63yiOeTwldBb1ju8i34=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCjHLJsC;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785687019;
	b=IhqI0J3RB1xjI8sukLxcCijSJe3vuuKUYqEU0qHmHbJhMToNw8sW275t4l6SImNP+M57GF
	YuBk6I56sP4EtkPtJHFI+ijHiT6zeAUW6GKaA+uW+U9plF3pkc0hYXSYN/KlXsr/51B4Hg
	TOTRUj1uns9qoTsSkFo1dEDpGtlh5kE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EAE060AA3;
	Sun,  2 Aug 2026 16:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B9D1F000E9;
	Sun,  2 Aug 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785687018;
	bh=4UiUtk8mYd6dVW+H2bsjpuN7YlklJl1Nd89zFSg72gE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SCjHLJsCHOkzsb/sh+/2f2cbgdmYzXwBRjx+yaRvSBi6iVrSvyPdXynMwbkfQZQFM
	 i7Z7p2d3kuNnDnQiJdn54xbZVuoLOYoaEmwUgdTdJ24a7IJG7pa5qrVQVaiivj+rQs
	 9gqj8Elx8j+ub3Muw2P13O5bWrcn4HFE9119e+Vuk1aXW+zNta9Xo4BUOxByu9jDQi
	 wgS5bp3vzp5gu0NqevcL1TYxe25wbx3FSnMltW5M/WcJpnMsh7F0/ntsmT8C4Antl6
	 8+cDwHhV2dB82x6d8amsE2fY/esZpPqAZJaaas7FzEDE0p0mhj+SFpzZ+U3hHFRN/J
	 95+ZwaneG3q/Q==
Date: Sun, 2 Aug 2026 19:10:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>, rientjes@google.com,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Patrick Bellasi <derkling@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <am9r4I3Myr6m3Oq4@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C900F40004
X-Rspamd-Server: rspam01
X-Stat-Signature: q4uboznohhejpfqex8mm99yiaox6uqba
X-HE-Tag: 1785687019-197689
X-HE-Meta: U2FsdGVkX18UJkSM4U0rFD3UI/1v37PwHBhWKgws77knQ2cbZ+7K+YwAKwNwgNqNMoSmYtjUnVl5c+eNcOzk3G9xWyjcJH2oz8iWQgqGaReuBwOli9wu65Pa/abTvu+VqgeNrPaZl8yEukxJePDg8TsSMukNLMNT7SXbwaq2V+EPr6MGXgz1QtgRgL0nnMvrIBeNMqmLl31dz9K7T26isJ3bbFRDLWsqVOMHOwzJin8ioigfFSuuLFVJ86oo2q8io67tPN8X3zQ6DFHe9LCGWySsFuImO87nX9hmZNxWJQND80EkMmoqzF4BAAzA/jJc/aWMLdJCVR5S0feq8ktVQahI6pbFyMJTiL9Gk9Lse41DR7DWG+DVRRhFyYm3QwGEkX3Rd0YevYjOw9eVqXF1+1UFOfoMfWbYgselWMecTccN5phZdXmgmwpOMQ5m7aqNdP+xuCOFLsgtzVqlqrIkzHz8Pdd385WeIAQKLwpn1XtA8LnS8amCy8as3DVY2QKQvbg5CWWc31xmzso9VMmY69bGQrkpmjJplAZRM+AL23/BhgT2mUHmO5NVXwWYL7b3veVAV1a0+DGVaVYsAqASwAX29sfwpbSzS6ZSZvi6RWHbBBk/NJAwuFf4nQ0Lzknk+NsQtu8m/tHFF25T5IzuHhTr98RArqiHBWgmran9tpzk3MK1iunbWhjtNEmJpxheXOpkTZ3oOAzD6yjlrnHlukSYB7RYbR7tM7Zj5nyUtmM6jRI4XrgnBGRberOIY/aNmAJvVlqHc/uNLG8ZSgrA26vy4pk2D5Gs16t5HTCByUuBKNvOv42JCsmKXFlrLMtVQhi73W7ZBwOdf+Os6Jr08P1OqZojecwON7AoTug2zTOAn07BY+h30ZBr6sAW2whfyPH08a24K/LEYFS258ucTrruoaK7DH5NauNDwrFj6qs6gxzNQ9b+OxYNE5ec4vi7UrjgufnmnMb6GFR0fZv
 dF6BBTj6
 Kd7ue98Rn/RTEy2k98o562YP4nbFbSF5bu8M4wiRAgt243/UKGw2h8smup6EQ+P1UD27S8QYLcjI63UE+4urVNTyVWrXRk1ecVQ2azUb48GMs/3WVwwEusms1B+QUyqce7aollojSMKH/xfreXL+hw+gNud5RkvbUz0rQYV4FaO7dt4ZZGRw1Df88G6h1sjZ149KIaG3kCd4xNEwWNh1jZaDsuY7/WSmTwpVEzbEeIc6tEnic4TBHC4J+5CtwRw7Juj+2YCh75uRYvbDBd0sC4lWLxPst7fbXSLvle5IMHvlL9ejbqc1fCCKi9TyJVB56Ku5TfpVE/6Qno2/3XNz4/s9fTx0cgjcKmXaj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:36PM +0000, Brendan Jackman wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present. Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> [Moved zapping to page cache; removed review tags]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/secretmem.h  |  18 --------
>  mm/secretmem.c             |  46 +++-----------------

Lovely :)
For the secretmem bits

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  8 files changed, 128 insertions(+), 87 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 4e8b2b29f6d3e..011f6e34859cc 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -15,6 +15,7 @@
>  #include <linux/bitops.h>
>  #include <linux/hardirq.h> /* for in_interrupt() */
>  #include <linux/hugetlb_inline.h>
> +#include <linux/set_memory.h>
>  
>  struct folio_batch;
>  
> @@ -210,6 +211,7 @@ enum mapping_flags {
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>  				   account usage to user cgroups */
> +	AS_NO_DIRECT_MAP = 11,	/* Folios in the mapping are not in the direct map */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS = 5,
>  	AS_FOLIO_ORDER_MIN = 16,
> @@ -345,6 +347,9 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>  
> +static inline unsigned int
> +mapping_max_folio_order(const struct address_space *mapping);
> +
>  static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>  {
>  	return mapping->gfp_mask;
> @@ -366,6 +371,24 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
>  	m->gfp_mask = mask;
>  }
>  
> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> +{
> +	WARN_ON(!can_set_direct_map());
> +	/* folio_zap_direct_map() doesn't support large folios. */
> +	WARN_ON(mapping_max_folio_order(mapping));

Can't we use VM_WARN_ON() here?

> +	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}

...

> +#else
> +static inline int prep_add_unmapped_folio(struct address_space *mapping, struct folio *folio)
> +{
> +	VM_WARN_ON(mapping_no_direct_map(mapping));
> +	return 0;
> +}
> +
> +static inline void prep_remove_unmapped_folio(struct address_space *mapping,
> +					      struct folio *folio)
> +{
> +	VM_WARN_ON(mapping_no_direct_map(mapping));
> +}
> +
> +static inline void prep_remove_unmapped_batch(struct address_space *mapping,
> +					      struct folio_batch *fbatch)
> +{
> +	VM_WARN_ON(mapping_no_direct_map(mapping));
> +}

Heh, that's a lot of WARNings :)
But I can see why you want them :)

> +#endif

-- 
Sincerely yours,
Mike.

