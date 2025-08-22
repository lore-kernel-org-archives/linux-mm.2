Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACC9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07626B0006; Fri, 22 Aug 2025 11:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF028E009D; Fri, 22 Aug 2025 11:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8396B0006; Fri, 22 Aug 2025 11:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB4D8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:27:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5436A82D4C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:27:43 +0000 (UTC)
X-FDA: 83804773206.21.B78BAB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F2F3A40014
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:27:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CMSA8/iN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755876462; a=rsa-sha256;
	cv=none;
	b=lAUaBoCySM2BfeACHncfZimFZ9slP070xsDUf4ch/VXvMq06hmnzAA83VkDr760xhHuaRg
	+WlNR1RWn5brjids1T153WMi4T7KZ6QpFG9G5/XjWF4G9HOxTdJkMXpNZzboLJi5Zw5Uqo
	AT4PM7Yegpj1lZgPruoH3goV77XeQyM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CMSA8/iN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755876462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1I8u9xZyArfke8NFAOrJRZCKODw+0YzgRZABhPnQa4=;
	b=ThMLYwV3oLiHlWmLtq5cWew8zvXfVZQuslts9gQk4ilGdG7Ivdxx0QhvFvSmShfsyuSkpY
	pA1vpGvyJo1tXnPK+v5IVD6zmATB1+l6ZS2Z5BZOA74gO9QmiJTL8VzYqW4Zfycm7wc6wG
	EYEqblChQLFCFr5lilTmDLcW0fTteH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FD7B601E7;
	Fri, 22 Aug 2025 15:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AB4C4CEF4;
	Fri, 22 Aug 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755876460;
	bh=0qR8BCWLBcRlRrpkcs+atUvi5PdtJ50YHK9esf5ZAKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMSA8/iNRQzGZkbIDx5A4cJNOwmFhybJqReMu4HdwOVn3PNotQlsB8AgT+yFZA8Y8
	 tXDvC072J+TRehmdgF6MQY8T9LhOc8Vm8r28olhGEPc9En2no+wNDu0dVCg2CmWd50
	 VDF4ewu4MW0eWpp/VV3ju+VCox+NXDJKc5r3/Tt5bBkHB/AdI2MAkYGs2yDcmuxBr5
	 hcRW5ZzeP6W5XkLDFTOtzNceF2yrK9Br6VLgJmKNP6QZnYnlUbDho/SCHAoD5sdcAx
	 wQt2gTTeyRZX4my8A32bD2sZ4a3Ym/R4GffRVx6rLGX5yIxOwM3XEG7ZllyzhSW098
	 +DeEOtb4E7cHQ==
Date: Fri, 22 Aug 2025 18:27:22 +0300
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
Subject: Re: [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
Message-ID: <aKiMWoZMyXYTAPJj@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-10-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-10-david@redhat.com>
X-Rspamd-Queue-Id: F2F3A40014
X-Stat-Signature: 6u1j1xjcqwmsk3ejq9yf1it35qdi6rtj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755876461-185796
X-HE-Meta: U2FsdGVkX19s1RIGKMpJz1CZRksbMk0aLiz++ZNmvLy8xVy0ligpd75lKkREEgYyW0xZ7x7D8Y0Zm3UCNCa0dF9fd6b9x4/M4ZnML5AIW5EUvwu2uP6KrWq7ir8SYG1uVhE6DKy5Bd3JYqmHrHhlGw+9BYzoxUTPQiPNUIxFoS6cUvqFmV8PngK3BDAMYUx6iQXfvRi5R58ZGP+pv/GLJXCbrCGIvGl59DISGizPWzhcis2eGLKrb7zoPX8vQsbKVz/0VqXYQwkWPbWhn88uebs59uPpkJ3+7tk1YWdNl3DXYxsJkyFGhmOpU6Na35byJH5xEvy/HX6z66RjgiMX+QIVtuYGGQMCrUe+4H0oD5yWusz82kzROQr+x/KQGTC96DmIJ7JpfOCEZUi/Q8nzQBCydwtjJfJg6l28TY09zj044uJgnO0zjWwJNeQbmZtm/rg2ck/2XtcnRjOIivSBfw4wIuPuc6ZXPe4sO0BIXG80Fmm0D4aVKV1kROPLeIdXhBTevBYncfjd1oHzJUsrSKkT0ExJfkeMhGznhrlYtopw5es4ffKrLKIbvnyXOgkk+BuCFtXyRUidyuwg4Bsa+vQ/yknJqAhxZWFn9SuBXXm56h1iwZDVlFZqMEf1xNaxGn5Gr7RSN4VsK6aKfMuuw5OUoCRf3lDuulUpjjpWXOqiKdcWzIPURccZBc5+UpfDy7I7YlczuiapxdCrKrFMBNR5r+NJpeQEylT24TVBNTnRxi7lnTSsz8N0R/8BIRy6LyzQN89azD2wEbtiuaK2vjozASbpM/Dpt+uGusM2CyywMzPrcUDgGWIalftLENkk0fTtv9W5aXH2o6Xulw5HHROZL2wKWUhVtXQXDbDXWzVYEyzoCG/T4xtt0xvxYthDPFHyoSdq2/zB/nJ5KTzqshInQ3xbjmEPJ2yXYlbBZ8t6b7hGfxdAu2KbowMdZD1c1e/lZViNuRcO/Pw3Bzq
 W59rjgPR
 l58w2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:35PM +0200, David Hildenbrand wrote:
> Grepping for "prep_compound_page" leaves on clueless how devdax gets its
> compound pages initialized.
> 
> Let's add a comment that might help finding this open-coded
> prep_compound_page() initialization more easily.
> 
> Further, let's be less smart about the ordering of initialization and just
> perform the prep_compound_head() call after all tail pages were
> initialized: just like prep_compound_page() does.
> 
> No need for a lengthy comment then: again, just like prep_compound_page().
> 
> Note that prep_compound_head() already does initialize stuff in page[2]
> through prep_compound_head() that successive tail page initialization
> will overwrite: _deferred_list, and on 32bit _entire_mapcount and
> _pincount. Very likely 32bit does not apply, and likely nobody ever ends
> up testing whether the _deferred_list is empty.
> 
> So it shouldn't be a fix at this point, but certainly something to clean
> up.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/mm_init.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5c21b3af216b2..708466c5b2cc9 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1091,6 +1091,10 @@ static void __ref memmap_init_compound(struct page *head,
>  	unsigned long pfn, end_pfn = head_pfn + nr_pages;
>  	unsigned int order = pgmap->vmemmap_shift;
>  
> +	/*
> +	 * This is an open-coded prep_compound_page() whereby we avoid
> +	 * walking pages twice by initializing them in the same go.
> +	 */

While on it, can you also mention that prep_compound_page() is not used to
properly set page zone link?

With this

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  	__SetPageHead(head);
>  	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
> @@ -1098,15 +1102,8 @@ static void __ref memmap_init_compound(struct page *head,
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(head, pfn - head_pfn);
>  		set_page_count(page, 0);
> -
> -		/*
> -		 * The first tail page stores important compound page info.
> -		 * Call prep_compound_head() after the first tail page has
> -		 * been initialized, to not have the data overwritten.
> -		 */
> -		if (pfn == head_pfn + 1)
> -			prep_compound_head(head, order);
>  	}
> +	prep_compound_head(head, order);
>  }
>  
>  void __ref memmap_init_zone_device(struct zone *zone,
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

