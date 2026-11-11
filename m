Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB58B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AWKcGXoq
Received: by kanga.kvack.org (Postfix)
	id 097B06B05B3; Wed, 11 Nov 2026 03:14:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049646B05B5; Wed, 11 Nov 2026 03:14:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0976B05B6; Wed, 11 Nov 2026 03:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9AA36B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:14:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60871A022D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:14:45 +0000 (UTC)
X-FDA: 85422126930.02.D140E6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFF6CC0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:14:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWKcGXoq;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uY7NltkZRK4c61bzzoP5vXdUizlOC9r8M6o8Y/d5dgc=;
	b=1E9+Hoxn/rC2jiwsnN76WmrrBnMAUhLMJB/ZeM8pmJ6ElT/MDntA6Lgyxtge7sSmYkz/C5
	Xe4WtRCOqYsAumBxcJRHW3FS0Kym75/epxO4ZYD3xi3EfxfAp3S5htxXyWI1Ufx7j2sZQK
	R+pIX77O9t56o+TDcapoF5Csrcxw1Ws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384883;
	b=fJVOkh38enNLSV6iFxJKI0nxJpR/a9uJT87WAGhiZApmb+a3vU/I2WwxM6Q582wzdzQs3n
	7nK1DejJKJ0SK4jh3gbbjeH7fM3RTWt//Bf4Dm+bN8eeahETPmlizEjWXYbdG/ElRHE2C4
	qdvH22Vxo+5/SpZhYl++PN3IgzqNS70=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWKcGXoq;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4496463B7E;
	Wed, 11 Nov 2026 08:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4C21F00A0A;
	Wed, 11 Nov 2026 08:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384883;
	bh=uY7NltkZRK4c61bzzoP5vXdUizlOC9r8M6o8Y/d5dgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AWKcGXoq/6ETAORp2VtMh0VkhKs303MJjyjXA6xxBTHx10MNbZiTaI+w6sHzhYVg+
	 EAbQ7bQo0ttfQk7mxclnl/0MtESsare84d6DvssA1JURCT4y7vmCnFUcGCDlj9a7lr
	 Ar3aN5Q0fvY0uIYXUNXkRCujH/zLmTbPK+wDgmiuoano934Lp14zr3qxmsHsyTExHs
	 +9rWmjXu5gAqZP9ONqsXjspCW9ojQ9e57MnoWV4dWAkLCvey/EVhGWs+NTwzjGex/v
	 A2RxvKL8pEhuCGIBEO8xcx7weTKesAriU0zFWprdZ4NyaVp1R7vtNzgOGR3yWpT4j1
	 shQEUth5IOZBw==
Date: Wed, 11 Nov 2026 10:14:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
	apopple@nvidia.com, balbirs@nvidia.com, david@kernel.org,
	muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail
 vmemmap init
Message-ID: <avQj7BnvB5K7vZe5@kernel.org>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <20261110114859.76343-3-lizhe.67@bytedance.com>
 <sashiko-outbox-207133@kernel.org>
 <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
X-Stat-Signature: ewhupsi4kacs9da57uxxs8tqmz6edp6m
X-Rspamd-Queue-Id: BFF6CC0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794384883-353806
X-HE-Meta: U2FsdGVkX18GxcJPJfFiT19PV1q/kteCBbbgTa9JIc4LJS9QKEEtD7FWygyNeAY8QeWqhwuXdw22KOz6v7gkUfajtlFzfUzwvaTbm4jnfLrVKQo0h77f0b51uSA1BxOfoAz33ONqHXMYcjmxTSCSVmfWHXbwl8apZAfasb5hTbDidn06lcgB+7VKKanR0r3JD0U8mgL6R8xK4kdyGSmpycLKRI7nJVZ1J1zjgPY0RIVT7sATVggbosU03Ib2XmG46k1+INIA330/U6nTfVeO6UjAag+8qzwFBuzu3/gZPFBA4rTOO2xF6tAQkxBQWnLpcgOfLPXmPldMKShsNo1CWQkHP1r7N3MOlddwEJlXcaismrWgL5ynmN38YUmS1ro9LBk6xYrS7wOzdx76hP7akre6h0j5P+dwGothxV8FMdSVIs3k1Cga0oyuBGlcRMI+zEwJssrdsd23VDuX/H9tH5mjmAHUDjphIb0wJHtXfvS63ehCJnZMMbn7ai4V6RdL+hQOg5iQJGZfD87m+ut+kTsIRRzR8bE6oZyHES0+yahXMNr7IYrEbt7azhLZS/jOUSQwMFV9CxPTalOeNKnrWT4nRJ3RcIioJfKoW4UzdukWGE9I95KdndottSPd7JoXttOFCykP8AP1ntbeHM3foZPgeNoJavc/x69Nb/glajAyRL/PsWJWiyo7ouJ1elGjLM/ajjnI76yriGeTvUG3vjWPG+ZEX5uboa342A6pDvogt7VVJy/utDposXAJyf+qHWk1Rjhu2afMbc9QYh5ZLYKYkC7uFjr3m1wFi8ktro+YodNWHHYvQvpgUUhPw0+fzvVkh4XJe2r++6RK7fxHXHiNMDk2haw6Ct4djeO41iAhK5VuAlfSpKwUfPrr/S35kDlN/izUaVOUn7A/LC6/aKkn6RN1lutDdOxH2gyQ8SCoxzCL99e5Pv+MNDMrj6b4kGSxuSfTEes+C810XqD
 82V7Miet
 EE2P+iCJBk8LhNvWiu73Qx5AciS7H57AOW5hpgUfi8uCASCFOFM+ydnWGDDNa2sB/ZpSrP5nLgUw/i9qSbQ2hS+NMBZyILNC1mrALtxs5R4c1BYpW48aqD8RnIp4XzEdywhWfH35KQmcdqkY93FsPYqDc1Wb06GjIl9Ngi9BVOQMX49FHTeXHjzBoXNeq7HcUBdGSauO85tLPZAn3TLZJRbr36GkmpyKf1YQOqGOJksLxLtx5vF2qCuJr+/mlNAHScMxJb83bFuXNginoef7Bp82sQ6xgmMVJkMfcGv/MAtK76yI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:14:46AM +0800, Li Zhe wrote:
> On 11/10/26 9:35 PM, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [High] mm/hugetlb: out-of-bounds write in
> >    hugetlb_folio_init_tail_vmemmap()
> > --
> >
> > commit 5be89b38412d58045fd600596787f54c7559d32c
> > Author: Li Zhe <lizhe.67@bytedance.com>
> >
> > mm/hugetlb: optimize bootmem hugepage tail vmemmap init
> >
> > This commit optimizes bootmem hugepage tail struct page initialization by
> > seeding a template from the first tail page and initializing the remaining
> > tail pages via memmap_init_page_from_template().
> >
> >> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >> index cb2de24affdc4..6ae5d2679e3aa 100644
> >> --- a/mm/hugetlb.c
> >> +++ b/mm/hugetlb.c
> >> @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> >>   	enum zone_type zone = folio_zonenum(folio);
> >>   	int nid = folio_nid(folio);
> >>   	struct page *page = folio_page(folio, start_page_number);
> >> +	struct page template;
> >>   	unsigned long head_pfn = folio_pfn(folio);
> >>   	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> >>   	unsigned int order = huge_page_order(h);
> >> @@ -3247,11 +3248,20 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> >>   	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
> >>   	 * we must initialize them ourselves here.
> >>   	 */
> >> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
> >> -		__init_single_page(page, pfn, zone, nid);
> >> -		prep_compound_tail(page, &folio->page, order);
> >> -		set_page_count(page, 0);
> >> -	}
> >> +	pfn = head_pfn + start_page_number;
> >> +
> >> +	/*
> >> +	 * Seed a template from the first real tail page and refresh only
> >> +	 * PFN-dependent fields before copying it.
> >> +	 */
> >> +	__init_single_page(page, pfn, zone, nid);
> >> +	prep_compound_tail(page, &folio->page, order);
> >> +	set_page_count(page, 0);
> >> +	memcpy(&template, page, sizeof(template));
> >> +
> >> +	for (pfn++; pfn < end_pfn; pfn++)
> >> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
> >> +					       &template);
> > [Severity: High]
> > Can peeling the first iteration out of the loop overwrite the struct page
> > past the end of folio when start_page_number >= end_page_number?
> >
> > Previously, the loop was a no-op when pfn >= end_pfn.  Now, when HVO does
> > not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
> > hugetlb_folio_init_tail_vmemmap(folio, h,
> > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
> > gather_bootmem_prealloc_node() has already initialized the first
> > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.
> >
> > On configurations where a gigantic page has pages_per_huge_page(h) <=
> > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
> > mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER == 8, and 8 MiB
> > gigantic hugepages of order 9, where both values are 512), this
> > unconditionally initializes folio_page(folio, start_page_number) and marks
> > the adjacent physical page's struct page as a compound tail of folio,
> > corrupting mem_map.
> 
> Thanks for the report. This looks valid.

I love how sashiko finds issue on very niche systems.

But yeah, ppc8xx actually uses hugetlb :(

> I will restore the empty-range check before seeding the template in v3.
> 
> Thanks,
> Zhe
> 

-- 
Sincerely yours,
Mike.

