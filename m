Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BAE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/SpYXbE
Received: by kanga.kvack.org (Postfix)
	id 46C286B05B2; Wed, 11 Nov 2026 03:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C7A6B05B6; Wed, 11 Nov 2026 03:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A116B05B7; Wed, 11 Nov 2026 03:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE226B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:16:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 852AF1C2843
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:16:09 +0000 (UTC)
X-FDA: 85422130458.16.87ADC53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC3F0C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:16:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/SpYXbE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384968;
	b=WjfaLVMzyE1vUYxEtQWmG9HykCnZjiZRb7NiZaySX2k+rHeyqabUf7lxjnLoronFnGEd3w
	xqNLdSx5yjK723hz2irYNCJUMK/qACr7otewCkHimpLbODVl+H2JfMYteOWB1A7+Ih7yJQ
	p6hTk6a5cMN56q8Sk0Or6WuVIOtPu5U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vig0zooMPJUlYt2Ok7NwulSRX4Gi1J5EAQpfybMME0=;
	b=vTzlPJ0EpG03yu3LqVg1s5sN2Z0Vu+n02dIeAzM3MEBNdX7+x3AugeNfv+bcG5jcgaanxY
	G95nCCxa5wAZ/HdhHyLC72L4p7q8YFGbsSvMbcZEYYVH+mVFYvwjztowQa+a5F4WxfpZ7Y
	orXMWs6YlJZaLFJKK8Ex+svJU4J2nl0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/SpYXbE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FD384341D;
	Wed, 11 Nov 2026 08:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1C81F00A05;
	Wed, 11 Nov 2026 08:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384966;
	bh=7Vig0zooMPJUlYt2Ok7NwulSRX4Gi1J5EAQpfybMME0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W/SpYXbEL2cpxSVTse+uNK7NSNDO9im2+XzlZC183XpcRSN2XowUT8ze3QqtIi0gb
	 09KjPcZ1cpFSUKZqeL2DXSLudv/zkcGvhuwVwNFcWdpJqFWlZShgSWNENIxXUjMWZq
	 G9CtwRqQuh3DAymkOGDr2YgML8x4jpA694ZAphT0WaPCHbLeIGIN7RFaXXehAE9xyv
	 l1ySeLi13pZj5Iw5g+tXVqq63XcdGkAD63uotxoJqgL52CXfouUFI2j1Li3aPQvz9n
	 k3+kLFgLgGCvNEC5Xg+Gan0XhHWn7BL2bvqpF/NTeYPO/02UzlbdBO7pfglFiIALOP
	 IOxaWVTz200eA==
Date: Wed, 11 Nov 2026 10:16:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Li Zhe <lizhe.67@bytedance.com>, linux-mm@kvack.org,
	sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
	apopple@nvidia.com, balbirs@nvidia.com, david@kernel.org,
	osalvador@suse.de
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail
 vmemmap init
Message-ID: <avQkQKRkYV32Qkxp@kernel.org>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <20261110114859.76343-3-lizhe.67@bytedance.com>
 <sashiko-outbox-207133@kernel.org>
 <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
 <000a2613-6643-4ac1-8378-a3e7df0b211a@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a2613-6643-4ac1-8378-a3e7df0b211a@linux.dev>
X-Rspamd-Queue-Id: CC3F0C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: 5wr4xkm1dncu4s5gkx9tsana6jh3uz8y
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794384967-618121
X-HE-Meta: U2FsdGVkX18kLHnD3LeuUkIYniKhazW279rBTnydyAFs9qzANdIcToulLKMspTVwKErJf3EInZKW39gXr42yHg0/m0gCBCeT0Nh/XV7tJJOqa6x0GUEHMleACgTgAmzW26SvNatJoMwB8XxKYMCS9zCiHadCc2Z8coR6h1HQVn6jRujfxVlzeLLA98JMmVcftw3A42MiVhRRwVOSKto66WsmuAzzx22DVCIjmbCTgFe9SagvB7Hj5UItjqYU3F6Xm/+W5GFjfdkiRrOAVt2C+7vwmiVM/er6KeCe/2KGRJewNF2TaA/y0uwAEC4koagY2MMjrz89UuuSIzgne4UC68Nm16ZiDhNlDcw4DKnX0QaOix1/WtsXAxM1hFmOlxxptIig76Rj/e70kK+LEVeWyYPlmlDreQ2rgBOwsv8toSNx1eJ5ZsUqnWf/KAzQbyKXuZYfBGUc7MCT3dAb1xmynDt4yHuVHvDDOEESuXJw8eZygssBSw8kJS5unx59BMeHs6+TgBaImwpqWLwccnvFiFhFGz08bPpXkih3uLicEAKyt33+qCjJjQwUkzJlAYnDOsr6Ex/dUzBTv9hZMNYJR2L1lYD78z0lGallDDe8jE4hDdBKXqbrGhjfkjK7hi9NvsVJnOwhOY53PITjLVcKyd0+lfD88zmkVBa126gV3hHSEgqPLfIqpckjjiSC//+dhGqUD91kmp8OEdGNHhTmyr3X2lF2hREtvLwtc3MqX9NScnCRWEZEmA0oWZCj7fdIjQLRtIkXycCKT4NJCWC+c6SGdTpU3jvnUtEaZUx7EInXOX6y/3FKEJpknihY18qF829ZJOdsO6StQyvvARNNnCnSxZ6lHEXo7KElzI6K02RByrApIbEtP43nYt4eBQkiKx/nbuZi2kfjLGxMG40KV4tkM3lVEglzfAo6VKpMfXSJNMb+O67Xt4Ld5fdxD5HBw/+8g7KFHkQ7IV1jUyR
 gYkYZzJc
 xfuIrgl7HSWuFY3BhDmEAc/L49aq0Vd2JCIzw3QWFIM3YezH6dT/8dL1ofYe/zA9KvzhiGfzjoAfQZ7pq1olS1Rr8BzAR4nn0LBsUkhl+EW5cVWWH9dE0tiPfLk1b7vGPCxUZocL91niIFfFDRxMve3HJqPUdINHiCr2/sgviZkhy1GKwod3R0J/+dQYCJlXEHfmJRWag9+vmVrnSwtq4sEAkvgdL02aM+ON0YG8XHtJeYMbRujw8fLGw0jTmyRlKZ2hXEulrBP4DxbTEAcycNSuRnaivksqa//kuggRmNmYHvqKzU97euvYK0D69B+BoWfPlpS+oISHVLMuGZl6lrTLpJc8z+75J4OU+FlP39vpCUyi/eeqOMFOzQRLVS6o8hP/SxgBUxKp64WiEdZ3ABk8rccO5VIpm36jlNVrED/95zTR9ChjXL997QlA5pHCwt5/pwjPkk1EIocU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,
On Wed, Nov 11, 2026 at 01:28:50PM +0800, Muchun Song wrote:
> 
> On 2026/11/11 11:14, Li Zhe wrote:
> > On 11/10/26 9:35 PM, sashiko-bot@kernel.org wrote:
> > > Thank you for your contribution! Sashiko AI review found 1 potential
> > > issue to consider:
> > > - [High] mm/hugetlb: out-of-bounds write in
> > >     hugetlb_folio_init_tail_vmemmap()
> > > --
> > > 
> > > commit 5be89b38412d58045fd600596787f54c7559d32c
> > > Author: Li Zhe <lizhe.67@bytedance.com>
> > > 
> > > mm/hugetlb: optimize bootmem hugepage tail vmemmap init
> > > 
> > > This commit optimizes bootmem hugepage tail struct page initialization by
> > > seeding a template from the first tail page and initializing the remaining
> > > tail pages via memmap_init_page_from_template().
> > > 
> > > > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > > > index cb2de24affdc4..6ae5d2679e3aa 100644
> > > > --- a/mm/hugetlb.c
> > > > +++ b/mm/hugetlb.c
> > > > @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> > > >    	enum zone_type zone = folio_zonenum(folio);
> > > >    	int nid = folio_nid(folio);
> > > >    	struct page *page = folio_page(folio, start_page_number);
> > > > +	struct page template;
> > > >    	unsigned long head_pfn = folio_pfn(folio);
> > > >    	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> > > >    	unsigned int order = huge_page_order(h);
> > > > @@ -3247,11 +3248,20 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> > > >    	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
> > > >    	 * we must initialize them ourselves here.
> > > >    	 */
> > > > -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
> > > > -		__init_single_page(page, pfn, zone, nid);
> > > > -		prep_compound_tail(page, &folio->page, order);
> > > > -		set_page_count(page, 0);
> > > > -	}
> > > > +	pfn = head_pfn + start_page_number;
> > > > +
> > > > +	/*
> > > > +	 * Seed a template from the first real tail page and refresh only
> > > > +	 * PFN-dependent fields before copying it.
> > > > +	 */
> > > > +	__init_single_page(page, pfn, zone, nid);
> > > > +	prep_compound_tail(page, &folio->page, order);
> > > > +	set_page_count(page, 0);
> > > > +	memcpy(&template, page, sizeof(template));
> > > > +
> > > > +	for (pfn++; pfn < end_pfn; pfn++)
> > > > +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
> > > > +					       &template);
> > > [Severity: High]
> > > Can peeling the first iteration out of the loop overwrite the struct page
> > > past the end of folio when start_page_number >= end_page_number?
> > > 
> > > Previously, the loop was a no-op when pfn >= end_pfn.  Now, when HVO does
> > > not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
> > > hugetlb_folio_init_tail_vmemmap(folio, h,
> > > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
> > > gather_bootmem_prealloc_node() has already initialized the first
> > > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.
> > > 
> > > On configurations where a gigantic page has pages_per_huge_page(h) <=
> > > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
> > > mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER == 8, and 8 MiB
> > > gigantic hugepages of order 9, where both values are 512), this
> > > unconditionally initializes folio_page(folio, start_page_number) and marks
> > > the adjacent physical page's struct page as a compound tail of folio,
> > > corrupting mem_map.
> > 
> > Thanks for the report. This looks valid.
> > 
> > I will restore the empty-range check before seeding the template in v3.
> 
> Go ahead. I will end up removing this empty-range check here [1].
> 
> [1]
> https://lore.kernel.org/all/20261109095807.41547-8-songmuchun@bytedance.com/
 
Maybe you'll pick these two patches into your series since you anyway
change the same areas?

> > Thanks,
> > Zhe
> 

-- 
Sincerely yours,
Mike.

