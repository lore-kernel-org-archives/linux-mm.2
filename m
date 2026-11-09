Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FACB606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOf5Rbeh
Received: by kanga.kvack.org (Postfix)
	id BC1A26B05BB; Mon,  9 Nov 2026 05:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71DB6B05BC; Mon,  9 Nov 2026 05:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13136B05BD; Mon,  9 Nov 2026 05:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 727AB6B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:43:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0EC21C3F57
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:20 +0000 (UTC)
X-FDA: 85415243760.09.305FA95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51F35100003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOf5Rbeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220999;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbA+n67sNYLx4/POP45TPPvM7iW1y0fAPQDGkg2urVA=;
	b=A0sSn3CCycXdUvT8NBkjkZryp6QGaAd3r1oGYdZzwLvoAO3cdhCNRivluAF1CND1LhWASC
	bs9VP2AsZhhMP6BdfSG86zhtiXu4RDybsERlj359/tyGADYv8lPXa1LdiFcCDSRMokPXYt
	VrM41laJXoRGJH80gwmRbM2GIGGofts=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOf5Rbeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220999;
	b=quE41dY61ILlY29M+LGPhqmpmTa0O1gMKsKDR/HNAIFl+JRYit94oqsvVN2j92zYk7UNCi
	o/MSTqnaHd/P0Y3OyLgvKDpQenK3U7LB/9l0gMv3VU8GKYCB7jQp/iOhKjNBJ4ic48fGYr
	xoBOULGXt0iqtDGBWaJyQ+4RPqbWcUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F87B42DA5;
	Mon,  9 Nov 2026 10:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE24C1F0089F;
	Mon,  9 Nov 2026 10:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794220998;
	bh=LbA+n67sNYLx4/POP45TPPvM7iW1y0fAPQDGkg2urVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hOf5RbehPjdRMheTJv3LMFayzLSTTSq7iDkTeZDTc6bXD/kfAXs0wkj9JGCxvVdeJ
	 h+2DQ0LG5TY6awoP15I+cRbaN+/UHHRYZZAPZPlV/dAaq6e9FLKE9YPsM2c60zNqsJ
	 CsYYvAQMoGRBrSrDqrjlKquRmkhdpNn5ubAd0DR5vM8r2o+lgRjcHYOydj8LHZ2e81
	 t6OuIK4Xeg8JfDV16e4v98nR4LHk00FmypGj57+BkVoN6pT5j+P/BzBaFnJvXiWz/A
	 j4Uxn2rOhrXreNA/GtiR9TPuL/QriVMChK/gV1oIYw1KqkiyDdgEBWJvBNGD73T2w9
	 Qk6fe0kRWxGOw==
Message-ID: <sashiko-outbox-204840@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/11] mm/hugetlb: initialize all struct pages for
 bootmem hugepages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "James
 Houghton" <jthoughton@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261109095807.41547-7-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:43:17 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 51F35100003
X-Stat-Signature: jgfowhbg88p1xsxmcjmak5wpkxsbupsq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794220999-517614
X-HE-Meta: U2FsdGVkX18W7RtrWktdChCsFBo27CRTufzCTlDqY7h2vLjJP6Uru9H3+hIZmX4FLpCVIYQG3UkKZqEHYJdKRQSTr4P1saHet3U8w0UJFBe0GywdxbjIKJugCNW66u2QJjnSTbbH2itgSmiRJ97nf7B7mNntpDWk7adjtUlAlivSr11xfj98wn5Q2CgRlIlLbwSMABHL5M8nQ1T6OWfYRWtGKRb4X/a+llYO6F2yqdyQGpW0PAFIRkE9u1Yntnl0vUqr+b2pfg5p+/U6ibL3gjWYdJEQT5SrNU7/kNqy+ySRJBwGqre1iV/mBiTs+hqohYSvkfjq4t+RCvIfJEifhTTMlbf7ipd1KhsQGZFa0LIesRn70G7c4wiCzqv9yRmAyPtFJv9OM6LYKKfWudeNqJkojPFrvzghcHcgFtw5Od/mgVOQCbRtq4zdq9HkqX9x1zX+/TP7T+4pFNHBh68upr/IEbuXSe8kFCQOFa2r8gJJiEIpw4SSE53RxalH7btReigvOP817TGkmuDTPOGUp9Gex5iNIRdl8QY5SdTGAfOg9q6phOJLpCYt77u2lidFPi4HtxJiSGoJv0cSFjWKBIkWzXpGGmDU1GhJ4BBvl3zIf0bIBRZSAVzVohALT9BJlYajJjZarlZVuU2S3wPsommmDM6z9+xj7PqCd7As40B/00wKnyHrP786KQV5yNIsOGep/hGbUs+S+odxoR3ZsCyeZbOl6y2GO3DzerraLJ3i6nsuR9V8usrNCQ1O/dpAq8tOTnCk238lBJzaXqYOUBCEZgLYrCBH2froBRPfsYMas5cNFdCOuvfDtCDdDSizM35BAafxOuzNJ+F3O1nHoVZRTLzrDwf6im1oKXEqCfFwIJl6ePbFOcvCwoz7zo4/Y0O2u5l5fm6m+SVs1I796eAxQO5mQ8/6TThF1piLhqFiGlJ0AjVzD+X/zh0VK2YzF1iGH4sqB0kuqy3sYjz
 Nhlbabdi
 NqYjSAnL0DXKNNzUJkkoYRP2BgfiMJPeYZYs0zKHfn/rKbR4aFHZNJKiGiOddJGN5Dx3PPqIejM1jElMeW0oo4S4f8NzUdix2jAjvEWyKz3e7yk0lhbumQqFimV7yU7ogyTPUTi0sjJ95vAuUO01uDL+i9e51fAqIxeafhx/HAlMCIOJPa2JheZOourOojpzrRFqjnj4Ze3QBLVRnm+/WLJG15NaqGXWVXwxKkeB7rLBMtsg8BP/wRTkig6CMBv2nDhhFrq2M1Ka1RTzv4myOtRQuVL2x4+Fo8F5DYU/RA/gd6cJwuUKuYObYj0ZQWPAZFoR4CMc0Lj94eAfsOPKSxebKDgw7ICH+tBc4dlYJtFv75ZSLOwjVNsm9v283+pnSJyFM2gBVJoScRIZFW84DhF7tRe4Ib0GWyxV8+zWwEcxNbR2f/lCm5G9ai/d1zA6DZPJ+JGTKe8UMeukZsjKzj3hHaJYiKKktCI8sI3oAseM18f0FrTZ0QP4r45pzovoB6PR9mQLtIpRDL7EvOf3DAA4C1v6shQvHXFahOkgkAGcIVEl3yEKa2gUvKClPbGuK5u1m2rc88crVQITispoWIxxIdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/hugetlb: hugetlb_folio_init_vmemmap() wipes KMSAN metadata on
  head page
--

commit e4e80712cfb9bd9a2f1df0a9b2aae1625edb6829
Author: Muchun Song <muchun.song@linux.dev>

mm/hugetlb: initialize all struct pages for bootmem hugepages

This commit marks the entire boot-time gigantic hugepage as noinit in
memblock and initializes the head struct page alongside the tail struct
pages in hugetlb_folio_init_vmemmap().

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ff6f837b6df01..d2aaad235458e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3216,15 +3216,7 @@ static bool __init alloc_bootmem_huge_page(struct =
hstate *h, int nid)
>  		list_add_tail(&m->list, &huge_boot_pages[nid]);
>  		m->flags |=3D HUGE_BOOTMEM_ZONES_VALID;
>  		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
> -		/*
> -		 * Only initialize the head struct page in memmap_init_reserved_pages,
> -		 * rest of the struct pages will be initialized by the HugeTLB
> -		 * subsystem itself.
> -		 * The head struct page is used to get folio information by the HugeTLB
> -		 * subsystem like zone id and node id.
> -		 */
> -		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
> -				huge_page_size(h) - PAGE_SIZE);
> +		memblock_reserved_mark_noinit(__pa(m), huge_page_size(h));
>  	}
> =20
>  	return true;
> @@ -3255,22 +3247,23 @@ static void __init hugetlb_folio_init_tail_vmemma=
p(struct folio *folio,
>  }
> =20
>  static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
> +					      unsigned long pfn,
>  					      struct hstate *h,
> +					      enum zone_type zone, int nid,
>  					      unsigned long nr_pages)
>  {
> -	int ret;
> +	struct page *head =3D &folio->page;
> =20
>  	/*
>  	 * This is an open-coded prep_compound_page() whereby we avoid
>  	 * walking pages twice by initializing/preparing+freezing them in the
>  	 * same go.
>  	 */
> -	__folio_clear_reserved(folio);
> +	__init_single_page(head, pfn, zone, nid);

[Severity: Low]
Under CONFIG_KMSAN=3Dy, does calling __init_single_page() on head here wipe
head->kmsan_shadow and head->kmsan_origin after kmsan_init_shadow() has
already populated them?

During mm_core_init(), kmsan_init_shadow() allocates and installs KMSAN
metadata for all memblock.reserved ranges, including MEMBLOCK_RSRV_NOINIT
regions:

mm/kmsan/init.c:kmsan_init_shadow() {
	...
	for_each_reserved_mem_range(loop, &p_start, &p_end)
		kmsan_record_future_shadow_range(phys_to_virt(p_start),
						 phys_to_virt(p_end));
	...
}

When page_alloc_init_late() later runs gather_bootmem_prealloc_node() ->
hugetlb_folio_init_vmemmap() -> __init_single_page() ->
memmap_init_page_common() -> mm_zero_struct_page(head) (and similarly via
memmap_init_compound_page_frozen() in commit "mm/hugetlb: use common
compound page initialization helper"), the entire struct page is zeroed,
leaking those shadow and origin pages and leaving head->kmsan_shadow and
head->kmsan_origin as NULL (extending the existing tail-page behavior in
hugetlb_folio_init_tail_vmemmap() to the head page).

If the bootmem gigantic folio is later freed to the buddy allocator at
runtime, kmsan_free_page() hits KMSAN_WARN_ON(true) and subsequent
allocations from the first pageblock cause a NULL pointer dereference in
kmsan_alloc_page().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095807.4154=
7-1-songmuchun@bytedance.com?part=3D6

