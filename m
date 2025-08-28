Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F38B4CA0FF9
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F298E0006; Thu, 28 Aug 2025 03:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF298E0001; Thu, 28 Aug 2025 03:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE3C8E0006; Thu, 28 Aug 2025 03:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1879A8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:21:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B24E4C0A0E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:21:21 +0000 (UTC)
X-FDA: 83825320362.28.A20DE74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C1EE100007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:21:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3P6rik2;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756365680; a=rsa-sha256;
	cv=none;
	b=Ft/zDEViOqWRPEPft9jERtDYSSNVZcrtyKLsWsImlI3IBukEtyMWgI684SL+HgiHHFO6i7
	zUr16WA3/i4pZb1xZcGnjG/dDgIRYHAASYfQXCLm1U6L2fxrHup8d8dwYuAOKXomgCNqid
	6nn6H1b/BajYxV9PBNIZ1QInYr5f/C0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3P6rik2;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756365680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=py4avZkKZs9gMtxyD4o7g7fY03HHmjmGgT6Iq9b3bsc=;
	b=R/Cz5YJAzM0O8gTXrDZa11y4RXWOa5+rtQcGHuML0EOoWtUcj/NrT1PALZCr5ty4ZnSDau
	MXEOOTozTeNusJdnEXKGry5P0TaPPyW5BsW58djYUMreNRPUSRUIQvoru1QNi5QsEpUsOe
	eQNbP3HhwJChQy8nndc2SJndwlg2NFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4394B601D3;
	Thu, 28 Aug 2025 07:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A4FC4CEF5;
	Thu, 28 Aug 2025 07:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756365679;
	bh=C7/duUHB1jzTe2zoRwJGPq9tnOYsk04M/lnKM6Lw4jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3P6rik2V+dAnat9eWuSvAQFs7ROQol0qfl7mXX/2cUYI+C7QRP3XNCAjTFTXOboX
	 PnGh4LwLXGdtC/lBzkP3HHTgLg4rsEUWyyc9GJT6llTjHe+2h8KOlurSZnUiJw3NW7
	 qKwPWdsXnTrtZmXRScitgLnU7lvFVln3pfXq+R+VNtWe5rSbPPMi2iORZuC/qKAp5S
	 3fe04bSwMQR8OaSYcElHlHSfQVwB6Zb3HSUqkl5IfcwdDCl1ZwfSrzEWyOB1KGcrlw
	 JUhlVcCM4Av5WDpYuP6k5h/vdvl0/1bLz8dvd0y2eUBSbWa12OIyuKGJ2VR5zTU1an
	 L77vfQGsfA4Og==
Date: Thu, 28 Aug 2025 10:21:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aLADXP89cp6hAq0q@kernel.org>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-14-david@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C1EE100007
X-Stat-Signature: h77wr8s6mpyfmwj8z15rk1h7atspesk1
X-Rspam-User: 
X-HE-Tag: 1756365680-905513
X-HE-Meta: U2FsdGVkX18OMaCnZYfyvj4qeveJeSs2b8rlK6NOAokvStARXhqgn4pb8zrAzsreS6VbIWSyo/5mfH4ei333PHw0CAqqah21o8vLVOaM8TG8as0WlWE1J5UVxSupIOJ4lQdtjXzHtopDx8TTMEhG9qD7Osw6cULAToRn/IY90CW3bxEPgvs6CV+Sasc9eiGPe/H52DVfND7NGKmiAnS3FHSKc9ZD6cavxBxCX5Hg3oqGwLTHYLNfeg+/LiG9c7GTNdpmy3SC10cp/bA+LkgBJO16mA7Q9nMdyMy2adQ9t4yviAypD4nKRQGp8LdmUZjCw87hSRsd4rw4Dfd+IihZRCa1fbFaToB2N8DYPjAeeOkquliwwp/X2s0pHqr23V64LlFeHo8gGEIprdW6NZ10Go4xsN7xNCIsqdEpDdEk6/2qjpiPOGXoFT4X6xwzt+YZ4E5//KT893zstGgH9Tcpt0P7QMS3WpaHB5Nv3nP076111gaWL5OeSMmOHG2TvaCiJr18LHnCrrZhcWPk3jJATfsELTI8RI8fC5bGooe53xTna1GaLxq4uQq92UiBGKinUBTCH61GsarxMjFCDzdxE79QqsgSgt8CyhlwBBUVA2t9nAxwEFAszoa6GZiA7D8vuHNVEdT18/gUJbwJPMkNZSxqSc2gg7wOAmrYzKphF+mEH1RXMOgKpYMy0XmJLiWBWElHQef2h0OICeshfC+7hl0YjRobi01OuTC16GLySOEb8Y0cLYWFwsYTp8FDasrdziz2FQV9e8uhuxaByLRMxosnYXQ7wg1EIxp3XJX3j1rMh5HukvSwqRrdWokZ9pd+hKXi1YkAQV7e8CWXH8gbxM9GUZdgaPGPvqNN1f5Tbq9fEOOmv08JE2f3SoaE8R8Dig8mj89edgaPIeY6mnQkhTZnMqnxJyfFq6kf2G3UxPsv9FoFpl7caKhfixeSc36hnj0u5QRR5ySSPAWyna9
 8zMafuck
 viZ7eY7RnCuKZODU+zM12r0EiGBuzbENxuIdlk2Jsq4KXzSstogCDQAjglcyRpD2D4c65/sVFZrVrUDVD7sF7VRnUDiYPU6n9l+CG4VskhvAcpWcQ65ff8w7Eg3ykDz+PxIIHluo852lL+BtoUPn3JLEfpFnndowR2rr7+xL9rOhdwOuTXt6BQmAo8Kigr6CGyGQHinw2xGYb/wr6f38qRresihy32UCEL5hWgPLiyTnOAum28u2LVwpVY6nHKEcJYDkuMuwXQARK6F8FaVwtWZgu8kxW2NFAlWdiAd/GfNb4Y1tvmHSkyxh6kovzrbGFDFkt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
> We can now safely iterate over all pages in a folio, so no need for the
> pfn_to_page().
> 
> Also, as we already force the refcount in __init_single_page() to 1,
> we can just set the refcount to 0 and avoid page_ref_freeze() +
> VM_BUG_ON. Likely, in the future, we would just want to tell
> __init_single_page() to which value to initialize the refcount.
> 
> Further, adjust the comments to highlight that we are dealing with an
> open-coded prep_compound_page() variant, and add another comment explaining
> why we really need the __init_single_page() only on the tail pages.
> 
> Note that the current code was likely problematic, but we never ran into
> it: prep_compound_tail() would have been called with an offset that might
> exceed a memory section, and prep_compound_tail() would have simply
> added that offset to the page pointer -- which would not have done the
> right thing on sparsemem without vmemmap.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/hugetlb.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a97e4f14c0dc..1f42186a85ea4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  {
>  	enum zone_type zone = zone_idx(folio_zone(folio));
>  	int nid = folio_nid(folio);
> +	struct page *page = folio_page(folio, start_page_number);
>  	unsigned long head_pfn = folio_pfn(folio);
>  	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> -	int ret;
> -
> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
> -		struct page *page = pfn_to_page(pfn);
>  
> +	/*
> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
> +	 * so these pages are completely uninitialized.

                             ^ not? ;-)

> +	 */
> +	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>  		__init_single_page(page, pfn, zone, nid);
>  		prep_compound_tail((struct page *)folio, pfn - head_pfn);
> -		ret = page_ref_freeze(page, 1);
> -		VM_BUG_ON(!ret);
> +		set_page_count(page, 0);
>  	}
>  }
>  
> @@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>  {
>  	int ret;
>  
> -	/* Prepare folio head */
> +	/*
> +	 * This is an open-coded prep_compound_page() whereby we avoid
> +	 * walking pages twice by initializing/preparing+freezing them in the
> +	 * same go.
> +	 */
>  	__folio_clear_reserved(folio);
>  	__folio_set_head(folio);
>  	ret = folio_ref_freeze(folio, 1);
>  	VM_BUG_ON(!ret);
> -	/* Initialize the necessary tail struct pages */
>  	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
>  	prep_compound_head((struct page *)folio, huge_page_order(h));
>  }
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

