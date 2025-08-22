Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D10ACA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 04:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5158E006E; Fri, 22 Aug 2025 00:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784428E0056; Fri, 22 Aug 2025 00:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C148E006E; Fri, 22 Aug 2025 00:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 504C68E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:09:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA0C71A0666
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:09:28 +0000 (UTC)
X-FDA: 83803064016.17.F3E1DC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DC3B20007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:09:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ekVL8Jce;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755835766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wD6Kie9NmTYlBWSYITqg8VmPWCkzgpHh3Jn6J+e3AEM=;
	b=xec2i7I4SfpuFGUMnaJS7YTaeRhvzGdESTeuckERJ0QBtXSDFM6HLuodjLU2DQUShKiP1K
	ASIM8ecJLlCplQdUm3nI1dGDUq6Njqx/a15sCsjAAuUb9X92FSZcPnXTXtJo2JQi2fKx2X
	zuZxpNanO2TDPYuRYXRJhiX9nKq54P0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ekVL8Jce;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755835766; a=rsa-sha256;
	cv=none;
	b=d5t6QUFlWAWw3EQuSZrBK+E63QcZY7+MK8/PCwqPkXKbdKiIvSDOyoiqdmLTkLx89D1pWA
	MVlH9jAoGVwPXLVb/rj4wqG3DrOGGgz7PktQlj7CMsV0W0hx2zP2c8ZRQvyEVZJsGoSNAS
	qsnrmM5VNBNkdE21h880IpgBRkvAq/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755835765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wD6Kie9NmTYlBWSYITqg8VmPWCkzgpHh3Jn6J+e3AEM=;
	b=ekVL8Jcem6q4cF0HM2y6xOx21D/FJFLgh+Adi11GsoKh93+dTphRUEqvPEAbV1jsnGf0+j
	76vWlhnV/nsaTW5nDgWVAmPnyWUl0TtjWGi7aVu71PRBgkpV7KBux/J7eN3g1ihAEe3TSt
	6lo4Vg1aDMs7A8C7PTZdjARZhrto0Jk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-yOkIJhmpOrKmD7vXab7Neg-1; Fri, 22 Aug 2025 00:09:23 -0400
X-MC-Unique: yOkIJhmpOrKmD7vXab7Neg-1
X-Mimecast-MFC-AGG-ID: yOkIJhmpOrKmD7vXab7Neg_1755835762
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-333f92b401bso6907851fa.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755835762; x=1756440562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wD6Kie9NmTYlBWSYITqg8VmPWCkzgpHh3Jn6J+e3AEM=;
        b=rMhR2cKumTq7PBmUXRtA5aYdixAjolTNWJcwOaGRayu34UGvsqAeniBcdxoQK5XSie
         /7RVQ61ILpEF2C6NCohAh7uARakCVx+dQFlkU+C4sk8GawHmb6uSnZf8Zmu4RhEWQSF6
         omTtX8sxPL3jCHXaT8QZ7gVNAqOiw77jwYZKX7xrli0vh3V1ID/cCbXKp7jmp3JLB14v
         F8kOB/M+uGcUeeiZ7ntnQZWfIkEB3wYqK+u9WfSLlXh3wmTUQa7czevXHg0D49hN7HG/
         pF0Ou6XWKRg5OzG+Sncdnc1uvuUvGlk0zsfUxOYeC/2l855e2Jc/5smc88avcG6+VLqJ
         fX8A==
X-Forwarded-Encrypted: i=1; AJvYcCXKW3HzLkwFOkcmpwKaEkE5womnKhubRWJZE2P3l2HbL1RX+ZwWtily0gqVMb9yvqIlj3q3roZjBg==@kvack.org
X-Gm-Message-State: AOJu0YxZI3n8RdtCaYDVLaUbgOXkt3skYqoqIRkxoktPQc8/p13IkPOT
	rG/mSuXgDo/WY7lKOcciExVKsKZfu4hZSrX8GCTEVqATak3xx6Thl/sLllRqYqlQq0ConYQ8AvU
	cm1qX3NBMAU9aba86tbVGvYd+f9m9L90OpwcwEcobfzLwD4JCRSU=
X-Gm-Gg: ASbGncuWvO21Ixs/ud+t9TZlfpPWmxvSvKXb0RaNRmLyhl6KqsHgqZBaxqFgJ3pxPN4
	YzunJG4Dg4x1z/hh5P2B8O3nKpklWM4ZVJhOoG6ZbQqY+FwEhUJq/hEaSD70MCcpILQUQYdfQ6K
	SxtuvZsab0JxyJtv23sjvaxqmaSQi6kcRHKFESLxeAyPG8h7a/5CFx9GoUSadGOWfcgnfEYq5jf
	AVMa8y1lXdlfbiNDmR/8UX+6ZQGrrym2Fub8FdECLWds6nVOnZlntv+22goTs4vtZewFmHBb1eP
	kFpJ/3dhSuNAPTp79trPkkOqNU0JDSHapf3WvME2mUpnawkLUbGC/R57NbD9xV77pQ==
X-Received: by 2002:a2e:be0c:0:b0:333:b6b0:e665 with SMTP id 38308e7fff4ca-33650fa8605mr4319641fa.30.1755835762132;
        Thu, 21 Aug 2025 21:09:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIfwy5viYQG7CiACnNo0XJ1QLrkAQo6vQi0t/AKYxGuojOFc+bxzH8Oeop0sL+wr/cDEqByA==
X-Received: by 2002:a2e:be0c:0:b0:333:b6b0:e665 with SMTP id 38308e7fff4ca-33650fa8605mr4319091fa.30.1755835761548;
        Thu, 21 Aug 2025 21:09:21 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3340a41e3cfsm35236551fa.6.2025.08.21.21.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 21:09:19 -0700 (PDT)
Message-ID: <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
Date: Fri, 22 Aug 2025 07:09:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250821200701.1329277-11-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FODMh5oL7Q8Ic9-CqyIWQE3xd3bSHilyeZMew5SExVc_1755835762
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DC3B20007
X-Rspam-User: 
X-Stat-Signature: 3jgb9gm46j4nu1bnnsurf8a5pbexuc73
X-Rspamd-Server: rspam09
X-HE-Tag: 1755835766-761917
X-HE-Meta: U2FsdGVkX193LDsj2CnO+72gmb+8AIUEwic4CqR837RxOP7I9v/Ra+V7H3kIbJBWZVeU6iIoyr4eQlkYjCLpkh8KLFwSu75FM8NefQDTTgbKz8GQ3bW0amW7gN+NF/ClYES/zC/Kq87/RQ+eWwC/UsTzStCmkTPhu+UgVjH0PyezJB2xMaKQSfEQEa41JkgxA82xe54zdGnC5FigLuXlBXnl4vllULmwj57mGKd8sP46ZBmdjrgOuzeKOfV8VCcXJGMJPGkRtFl4r8DPngBNy65bGG1gy0tCmiGOtnuZdyJ+y4hQY2jliq0xGJ7b7NWGV2KJviZQj0yVHhkdQj+cHbN6OPnK7RLjHC7U5V15MbrBE4JVRbVhnngdIIEw0+ImX8fgolrNYjp2sZDYM4tQIIvBS0FOuLDllnwjvrzL2B3F2gv0GkrK13055VJZwR6Bdue6V1CpmZxmKU3yeSP5CKsQKTd3FdPrT0M42M1yCdNZZLhr6qSdHtBPJ3F5dsN28DUsuXTOD8C4f/XJjIEz8qQxtn/1e2YR9r3RHZ6057PT1lp/RTJDJpglbCqSYZUf2QZnJIV5x1T1artvhCtLY5PLY3Bo3cq0jt2jhKZh2yLG2A6is/KVU6gghdcax+kjpgIz3/vPhWxqeZec7Bw6DMQoTZsfTr6mO+kGL8UtDS1lyyNfJ5xOXm6xEq8kjLTyHtLSiUAe6kafvP06eilehtl3Rmj1lpsuJB1rLHr8lhFy+SZlg/KOuwAoTqGM8LddgXw7SXdwtEX71J8Ij09TSQVeADMWlnDL5PDMGVK38sQ23Zgvv9OfkC/dxleJI0YKX1LpF0avYZ2XyQLD9ku9VIU469ywMCt7OQUe+DBIPQyvACnxx56U4OH8E2EU6/Lz76k1N0quOWkR/Nmrv1g0Ek1ll/OHKPYilk7nhZTlg5gzEQy6uJbdJqEHD0LQ70gtJTBwKFSb+/dWevLtykS
 J6l1XcL1
 mYnSC1yziTCB1BqLZpU6iyejAKIFP8RjPs6NuzsAtOXCuNeNfC+JLfMSr/HdcGyA7NPP2W6xI+r36NOQkffxl7RWGJSfO4yYscFZqLNYC3PtAP80MZ/olK0n17IeTy3OgnIwra9G6EAE2CwwBwtWIvl1W6/gQUAGHRzd3I6ZRxG+3F+yQTLhHSsCwo8X64ApZlOBl4fd/zA6HrRVEnV5t12Zbm54KUG1gqE7uF3VAXLerg9boVIYUVP85eYL30I8/p1aLaJrq8BrqgW4V3ogA0jQIgToQFTIfMg9jbA1sk6gprAJCW3Kx/MzPmbNrQ2eEg+fsBAG13kJ7purBbYkSr8WMg/o9FyOOvwyEIRwIZ+qc0xWKr47wg9F9FQpirWhvRRAO1PXrBJr1vhiXtoO4x/beUlc32Pb6AfQiGv8MGg769jAyW2BkkwmmIjMn2Kh1s298
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/21/25 23:06, David Hildenbrand wrote:

> All pages were already initialized and set to PageReserved() with a
> refcount of 1 by MM init code.

Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
initialize struct pages?

> In fact, by using __init_single_page(), we will be setting the refcount to
> 1 just to freeze it again immediately afterwards.
>
> So drop the __init_single_page() and use __ClearPageReserved() instead.
> Adjust the comments to highlight that we are dealing with an open-coded
> prep_compound_page() variant.
>
> Further, as we can now safely iterate over all pages in a folio, let's
> avoid the page-pfn dance and just iterate the pages directly.
>
> Note that the current code was likely problematic, but we never ran into
> it: prep_compound_tail() would have been called with an offset that might
> exceed a memory section, and prep_compound_tail() would have simply
> added that offset to the page pointer -- which would not have done the
> right thing on sparsemem without vmemmap.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/hugetlb.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d12a9d5146af4..ae82a845b14ad 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3235,17 +3235,14 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  					unsigned long start_page_number,
>  					unsigned long end_page_number)
>  {
> -	enum zone_type zone = zone_idx(folio_zone(folio));
> -	int nid = folio_nid(folio);
> -	unsigned long head_pfn = folio_pfn(folio);
> -	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> +	struct page *head_page = folio_page(folio, 0);
> +	struct page *page = folio_page(folio, start_page_number);
> +	unsigned long i;
>  	int ret;
>  
> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
> -		struct page *page = pfn_to_page(pfn);
> -
> -		__init_single_page(page, pfn, zone, nid);
> -		prep_compound_tail((struct page *)folio, pfn - head_pfn);
> +	for (i = start_page_number; i < end_page_number; i++, page++) {
> +		__ClearPageReserved(page);
> +		prep_compound_tail(head_page, i);
>  		ret = page_ref_freeze(page, 1);
>  		VM_BUG_ON(!ret);
>  	}
> @@ -3257,12 +3254,14 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>  {
>  	int ret;
>  
> -	/* Prepare folio head */
> +	/*
> +	 * This is an open-coded prep_compound_page() whereby we avoid
> +	 * walking pages twice by preparing+freezing them in the same go.
> +	 */
>  	__folio_clear_reserved(folio);
>  	__folio_set_head(folio);
>  	ret = folio_ref_freeze(folio, 1);
>  	VM_BUG_ON(!ret);
> -	/* Initialize the necessary tail struct pages */
>  	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
>  	prep_compound_head((struct page *)folio, huge_page_order(h));
>  }

--Mika


