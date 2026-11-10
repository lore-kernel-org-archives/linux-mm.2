Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59961606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fer0wfte
Received: by kanga.kvack.org (Postfix)
	id 70F346B00EF; Tue, 10 Nov 2026 08:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0646B05B5; Tue, 10 Nov 2026 08:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6836B05B7; Tue, 10 Nov 2026 08:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD596B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:35:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9343A08F5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:35:40 +0000 (UTC)
X-FDA: 85419306840.24.3648806
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 329B34000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:35:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fer0wfte;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4ESPDJdrgBgcp+gpUd/piYwjuXvI0MjBHYFD6vGX5w=;
	b=KDg/udSc5cJXJDEC3ZHNcllmuS9AtFVMZ7+qXILpu55+Y8IzaxJX6wYKpclyFUNjaoytlW
	FkSofUikLrAGmWjyAT+s+MRwqTgHFrQiPSqt7XqZHxmLxOOujIaNyTqtdWULhs8EVXh2p5
	rxt6pOBlWabW3UCb8QHnakh2AgL3uMA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fer0wfte;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317739;
	b=piT97a7Bf48gEa1pYmglOBMIO05qFPTBB73n0wPW8ZcOhO3HWySdoFxrZRKPRM2afHgO+5
	7LgVS4X8JTBJr/TaVJihZJidIOdyB/u35zve5WIHEPJ9g4yhKWhW2FZZHy0eEawbJadNyc
	uUQ93HOTAr9qmKNtB+Hjmd2KutXGOCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBC4561147;
	Tue, 10 Nov 2026 13:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305101F0089F;
	Tue, 10 Nov 2026 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317737;
	bh=v4ESPDJdrgBgcp+gpUd/piYwjuXvI0MjBHYFD6vGX5w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fer0wfteEYjcxo7hQaLIxSVq0hZuGyKdnDqnkmEagX6n1SjCh7CTZYsRoKmvUE//R
	 D2jrqGr4ucz18d4vCBYp8hLVyh64ReaP/A6kdQ51ruhhIn14agdoFSGbq30SQVikAf
	 zKSQ1jTBKU4t7Zp1t0PpmDBO8TrcggUZdJpi4oJvCfaCOhMnNomyCuUsKve2vBSiOS
	 nY9WpGnkOw36wzDwbi96s8btEgb/PatZm0p5fZKuFHhiiuMa1TVDStHtBzYnm8gBDv
	 xVdSQoMlUIeq22dPIUQLPdc+XOtn5TJJSxOqmVKf4QdhygUhsPYJOB9O9Hecy7Cpat
	 IexS0soRmVjNg==
Message-ID: <sashiko-outbox-207133@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail
 vmemmap init
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Zhe" <lizhe.67@bytedance.com>, akpm@linux-foundation.org, apopple@nvidia.com, balbirs@nvidia.com, david@kernel.org, muchun.song@linux.dev, osalvador@suse.de, rppt@kernel.org
Cc: linux-mm@kvack.org
In-Reply-To: <20261110114859.76343-3-lizhe.67@bytedance.com>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <20261110114859.76343-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:35:36 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 329B34000A
X-Stat-Signature: hg64khtkckggkjmc71dozswmc4ewpt64
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794317739-282592
X-HE-Meta: U2FsdGVkX18FUj/20IBK1PU9kB/7vhkHiXAJhQBh963cKfLmR/CNOeBBVJsw3jtHclCvsLM/bOBNJKscwXLKEoGu+traD1+NFDrX3ksSSKvfbKRC8McfjkpaQpAEpzzbjDCv1Xk/mnkeiEZ6ainTXBQy7LkeZadlwAa2H5y0EUBu92dxWbCpUZJDGNctmY2dXHr7vm2U0uoYtOhh/58vfgSuXEUQb2/RJX79kXL6cOih/8UgPTVTTYuVorBmVqNAYYp9J/KtFULRjytwxbctOg/tR+c1LSCYluDJ99my4/juYZTm2hR0bMkRVFXO8JNSOHfray9tw1wKhDbepYAHcxDefHFO8wReTssn4LEsQkq6Oy/Yq7SxGQo8ddrRO1Um5HS5NOG9Wk0UdiTPapVMLC8DXQ4VRUMyDl0lnYXyMjkf73bXL5/ulOkqNv1EnXtZT+eQn9rGzrl4lxG2SkehIbm8wJb3JOB7WYTPoR3L4/xnGDz2Pkj2DjX3Gr0Yy851QMXyOfmUGGU5eN1N3sixEFnrOliNvgnkC6b32zRTlUJ8/WaqgbNOnBjiILAGaiOZ7SPx28fm/hUHED+j0qrqx8WUeXCVQupFOdSfcovKSnS2G3e1gsdwl5F4aFcDp3qtTLJ2ghrAU9U6sZULx1KNFXzL/JbAEI6b4Tib9HmMjI30sbWMuEvl2yrzzh3N8c02qVeGl7BZCPjYhGo2f5R1ERQ7vsLArFBil73WoLpgG0T9l0VGAPBOUJ1VynHCWjwL6ZnJ9uEGZwffyhH+3zgDIWN6C6IC9WZaMkkoM0xCY+zyBpiZgQdAHK9nFDF4/i/vtG1iGoXDe4G54zPl+PKpaQ6ogIhZT5qmtp328tBErmr7rlGRKcLzfn/pODDKE5t+8luydnbPX/RTxNDeV0NLtMI5uyVKjRVvSOdtOgsRjoWiPcZIFb3rvga3ORC5BU9SwxmOEr/7HMC8/cd9iUW
 zAYLq8Gx
 MZnLpHSF9BtM6KluwH43iuCGsZyJB/m6X+Y88Tjp/4Y5m2AIcEx/HP0CAETkHn1S7nTK2vk8rsDDGC7nlerxmE1mu1Tkxh4YGuws38AvGqEAf7YuX8nCy5zWKyr5ef4tmAL39j7XbcDPc81tkfdEfov7nLDiY6uyqJG7C7iLS7Re2jrJUaLs+r26f3XoMVD9O5+mIfmfF4O04qZhKJEpfYNpRlbGPrYWuE+x5sxfLMHgcjlVoVMvT34J+u0Jay6deQX4wbuMoSiNEVifcAIM/+AvoIF9CFUEuG24nfGo2ED7E9RfLFa/SGJy/XvZfxYYihCEduHRTsAI7bZKX5GtyqhZW7v4P16mg4vV0tJInXNUBXYQXXPQ3BKWB8GEaN91mEilGu8qBgF669HZAOl3bOcjjKaYod49Yn7jeKV/v1DUOjjHQI0hODsuol6f5SCIQ+L98p0rojXYI8e1MvPUFAIsV5USFrsvCkjIpqhg/vlWCTjdxCfsu8SvP1xY9G7hpGwac0pkQtT43mXlFNqWWPZc4QIoWabXb1dEKn+lsCFzmsbaUrqr+ol3JdlgmSq5MsdbUMxklgwOCchNpnk5klrgYhQ==
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
- [High] mm/hugetlb: out-of-bounds write in
  hugetlb_folio_init_tail_vmemmap()
--

commit 5be89b38412d58045fd600596787f54c7559d32c
Author: Li Zhe <lizhe.67@bytedance.com>

mm/hugetlb: optimize bootmem hugepage tail vmemmap init

This commit optimizes bootmem hugepage tail struct page initialization by
seeding a template from the first tail page and initializing the remaining
tail pages via memmap_init_page_from_template().

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb2de24affdc4..6ae5d2679e3aa 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(=
struct folio *folio,
>  	enum zone_type zone =3D folio_zonenum(folio);
>  	int nid =3D folio_nid(folio);
>  	struct page *page =3D folio_page(folio, start_page_number);
> +	struct page template;
>  	unsigned long head_pfn =3D folio_pfn(folio);
>  	unsigned long pfn, end_pfn =3D head_pfn + end_page_number;
>  	unsigned int order =3D huge_page_order(h);
> @@ -3247,11 +3248,20 @@ static void __init hugetlb_folio_init_tail_vmemma=
p(struct folio *folio,
>  	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>  	 * we must initialize them ourselves here.
>  	 */
> -	for (pfn =3D head_pfn + start_page_number; pfn < end_pfn; page++, pfn++=
) {
> -		__init_single_page(page, pfn, zone, nid);
> -		prep_compound_tail(page, &folio->page, order);
> -		set_page_count(page, 0);
> -	}
> +	pfn =3D head_pfn + start_page_number;
> +
> +	/*
> +	 * Seed a template from the first real tail page and refresh only
> +	 * PFN-dependent fields before copying it.
> +	 */
> +	__init_single_page(page, pfn, zone, nid);
> +	prep_compound_tail(page, &folio->page, order);
> +	set_page_count(page, 0);
> +	memcpy(&template, page, sizeof(template));
> +
> +	for (pfn++; pfn < end_pfn; pfn++)
> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
> +					       &template);

[Severity: High]
Can peeling the first iteration out of the loop overwrite the struct page
past the end of folio when start_page_number >=3D end_page_number?

Previously, the loop was a no-op when pfn >=3D end_pfn.  Now, when HVO does
not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
hugetlb_folio_init_tail_vmemmap(folio, h,
VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
gather_bootmem_prealloc_node() has already initialized the first
VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.

On configurations where a gigantic page has pages_per_huge_page(h) <=3D
VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER =3D=3D 8, and 8 MiB
gigantic hugepages of order 9, where both values are 512), this
unconditionally initializes folio_page(folio, start_page_number) and marks
the adjacent physical page's struct page as a compound tail of folio,
corrupting mem_map.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110114859.7634=
3-1-lizhe.67@bytedance.com?part=3D2

