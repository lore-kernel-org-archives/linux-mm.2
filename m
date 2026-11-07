Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998C1606A33C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=laaaeGzM
Received: by kanga.kvack.org (Postfix)
	id C3A9D6B05B3; Sat,  7 Nov 2026 02:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDB26B05B4; Sat,  7 Nov 2026 02:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B015D6B05B5; Sat,  7 Nov 2026 02:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 894E36B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:06:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 177F21402B9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:06:59 +0000 (UTC)
X-FDA: 85407440958.07.F2D703C
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5C9F1C0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:06:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=laaaeGzM;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794035217;
	b=4C3yn6DLDP5q9tMP2JDnlteJcVslw9xXvgOcK/PbPoWnYczF0suOrzTp/A1Q4cct/szvAg
	iZ2UcHEG/KBY4ex9lAmgdkSQoucEmVaV/V+oM+kctoQ9Pf+uHB+pVJskpGTKMUTRpmpd5M
	+oTPGbq8pNEGC59AvcLvjzeUSYtuz0U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=laaaeGzM;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794035217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQGgtDwWrS+TOjm+NTam7HXH9x/oZ1flKgXBC0MLbs8=;
	b=B2AiEIg7Jgd0SEhwsTyktt84c+t9VVME6Z1Z573g2XjWkcUMyU+T7yCVnBaHTOBtDP1lTL
	q0rHQUpLO+H3L8AEsyQcyRmLAePmorTkbz+++gShmIi7MsHa3nYKHwR7ghQSpvYFjifG0c
	ItbZOIJ07y/AtuTcMD4WPTNJZJjxnWw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WA6DBOazilQWA0YBctLuPJvG7AIFId4vVmL0J8Gvwrs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794035215; v=1; x=1794640015;
 b=laaaeGzMGg4t+lecIujlnzQeisTE9nvbBDsCu1Bil5VTtbW36bfPUrnWhXHZFfEszpdp+CJW
 0aQ6ai2SyU4aMbwRCGD9pVbvG5evkYMwIO2BisdMx11yiEVQ/JqzOfspen8u75vuF93hCFEHE4A
 +xCCq96iQjLMHM9W9vC9cm5Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id edb96401be2ea3ce;
	Sat, 07 Nov 2026 07:06:55 +0000
X-Mizu-Trace-ID: edb96401be2ea3ce
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 08/20] hugetlb: Fully initialize tail struct pages of
 non-pre-HVOed bootmem folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-9-jthoughton@google.com>
Date: Sat, 7 Nov 2026 15:06:31 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <30822F0C-88B8-4ACD-A0CD-F889F438EDB4@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-9-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: udopwf3rfgnuzd9y3fhmhhkiu584w1p9
X-Rspamd-Queue-Id: E5C9F1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794035216-133941
X-HE-Meta: U2FsdGVkX197e2/6mo/ivrJ/tmwWlRXskZ/h45+s4kkovM4wad2cyJvunnabRjqHdFSFrgQJU67SuTrLIg7kPVDGMWLzn1vmRhC2Gc3ObQ/UCouHToxKZcvl4LKKwmYLWI2661aGoXiDRCWWTpedsGqDxRBzzfqtaWbNLUuywgEym+ysa8NNH4VsRgTHVEkaNwZTxbTqWjHBfz1aNqB5wmv22BCeUkM9jsy8RflDUbJJS814yzQQVk4T18GrbHxsqiJ/PLShsn65M9MZFfxgszjTrczECY0PHUrKlQzJwgT8pd5EUPvs8VI3qtwMuYRYEGpLqorI62TrR6gtgsbjrkYUxXBS4tLaGNdOXLGXApmVKtxP1v1gCtXY4MNpZ3hNI2w9dg+XWAJxpF6CTe6rzHCQ5y0F3KhCB4ars0wh0r5COikCqqRupMWUoUhbR6WYLS0AnhSIFCT29VfY1OQhfWfp5ZrRShw86zvHC6WDSyAUfRzTrX9B5oCFIBhmX5kLFOySWgnQdsngRekX/H713WNNru1lrGK1IMpmOTIBBPYLNGiexoIHOnt151KkoQ8zRrC+wm0GtmbwoL1K+iRBA7VedhXKanHSi5SNFBHHkvMtc82mGt/EOaWMB1iFfPEC1GjpVIryge6EJnSNjGiHROLg9bO2eU421cStqxd5YpRxf8qxrlGaQeUkJTwJTmLYmtHLWmLG7Np4E1AIh1eTtkWTmZMLaQLZC969wy8YrNkcP/G7mE8n3uzK9qglzqMOErgJFHX7Q2B7XkHGYGLwUU6tRgjl0ard3ekM9nJWzxjuI1Gs557BS0WqHPDZy6F6EoQb6CT3ubg9LZso4QF6qs8zGB7IHT5m7JPU9k4SxlYXJFsoLuH/eA4lNv5zAjxBY/kxcm9FUbzTkSaHfyx8e0Q1F6HoZeQJIl4DIyoow71Prl5bFLQ7Mr6BDZAH1nn/TUm4IovT2t8YJGe2iTt
 pUBgyMHz
 WQUb5a+Q1H8fDWZnugqIRciGPAT8zVyefYlYSqA8D45zbRVLKm4NC3Vq5z42Tx4ijZZ1YYVafvVWq/zYtUXGVktshOwhdG/egqnUHBA1O3HGKXDDi6ej1XZKL4b9VYrQjNq7CbMxQsW7SO3OXM++QGDn9H0NCBS9MRWjQPjBzrB0T9mHYEe7fKZBDTETEITohOe7X6SmOoj069R1yZIuW9VbEkYaJwvxGFz/oSsjk/iJ0JgT7RfKHSOdgMWmBQ/AdRyP9dq+vB69HcNRWtJE+qxvZbvUgdi9BECrbxFTb/WAc25wjveF9wdjSrd89CtGjD4Pka3fIc7mHylctd7evj6JueQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> alloc_bootmem() marks all but the head struct page of a bootmem =
gigantic
> folio as noinit, and gather_bootmem_prealloc_node() then only
> initializes the first HUGETLB_VMEMMAP_RESERVE_PAGES struct pages. The
> remaining tail struct pages are initialized only if the folio ends up
> not being HVOed.
>=20
> This assumes that a bootmem folio is either pre-HVOed, or will not be
> HVOed at all. However, hugetlb_vmemmap_optimize_bootmem_page() may =
skip
> pre-HVO because arch_hugetlb_vmemmap_optimization_supported() does not
> yet return true that early in boot (e.g. on arm64, where support =
depends
> on a system-wide CPU capability), while it does return true by the =
time
> hugetlb_vmemmap_optimize_bootmem_folios() runs. Such folios are then
> HVOed through the regular remap path with uninitialized tail struct
> pages, which trips the PageTail() WARN in vmemmap_remap_pte().
>=20
> Avoid this by initializing all tail struct pages up front in
> gather_bootmem_prealloc_node() for folios that were not pre-HVOed. =
This
> makes the HVO-failure fallback in prep_and_add_bootmem_folios()
> unnecessary, as pre-HVOed folios are never passed through the regular
> remap path, and all other folios now already have initialized tail
> struct pages. A failed optimization either leaves the original vmemmap
> in place or restores the tail struct pages from the shared tail page.
> Remove the fallback.
>=20
> For folios that are not HVOed at all, this does not change the amount
> of initialization work, only where it is done.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> mm/hugetlb.c | 28 +++++++++++++++-------------
> 1 file changed, 15 insertions(+), 13 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4dac7ed1df57..e971e2362412 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3303,17 +3303,6 @@ static void __init =
prep_and_add_bootmem_folios(struct hstate *h,
> 	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
>=20
> 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> -		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
> -			/*
> -			 * If HVO fails, initialize all tail struct =
pages
> -			 * We do not worry about potential long lock =
hold
> -			 * time as this is early in boot and there =
should
> -			 * be no contention.
> -			 */
> -			hugetlb_folio_init_tail_vmemmap(folio, h,
> -					HUGETLB_VMEMMAP_RESERVE_PAGES,
> -					pages_per_huge_page(h));
> -		}

Just for your information, I also plan to remove those code, see here =
[1].
I need to push this patch along quickly. I'm confident it won't take =
long.

[1] =
https://lore.kernel.org/all/20260513132044.41690-15-songmuchun@bytedance.c=
om/

Thanks,
Muchun

> 		hugetlb_bootmem_init_migratetype(folio, h);
> 		/* Subdivide locks to achieve better parallel =
performance */
> 		spin_lock_irqsave(&hugetlb_lock, flags);
> @@ -3337,6 +3326,7 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
> 		struct page *page =3D virt_to_page(m);
> 		struct folio *folio =3D (void *)page;
> 		const unsigned long pfn =3D folio_pfn(folio);
> +		bool pre_hvo;
>=20
> 		h =3D m->hstate;
> 		/*
> @@ -3350,11 +3340,23 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
> 		VM_BUG_ON(!hstate_is_gigantic(h));
> 		WARN_ON(folio_ref_count(folio) !=3D 1);
>=20
> +		pre_hvo =3D =
vmemmap_optimizable_order(pfn_to_section_compound_order(pfn));
> +
> +		/*
> +		 * Pre-HVOed folios have their tail struct pages =
mirrored from
> +		 * the shared tail page, so only the first vmemmap page =
needs
> +		 * initializing. Otherwise, the tail struct pages =
(marked noinit
> +		 * in alloc_bootmem()) must all be initialized now: the =
folio
> +		 * may still be HVOed via the regular remap path (e.g. =
if the
> +		 * architecture could not determine HVO support at =
bootmem
> +		 * allocation time), which expects valid tail pages.
> +		 */
> 		hugetlb_folio_init_vmemmap(folio, h,
> -					   =
HUGETLB_VMEMMAP_RESERVE_PAGES);
> +					   pre_hvo ? =
HUGETLB_VMEMMAP_RESERVE_PAGES :
> +						     =
pages_per_huge_page(h));
> 		init_new_hugetlb_folio(folio);
>=20
> -		if =
(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
> +		if (pre_hvo)
> 			folio_set_hugetlb_vmemmap_optimized(folio);
> 		section_set_compound_order_range(pfn, =
folio_nr_pages(folio), 0);
>=20
> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20


