Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD48C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF196B0099; Wed, 29 Jul 2026 10:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFA86B009D; Wed, 29 Jul 2026 10:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC976B009E; Wed, 29 Jul 2026 10:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDA76B0099
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:14:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8CA31C0FE5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:14:08 +0000 (UTC)
X-FDA: 85042008576.23.7E9A342
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37A114000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:14:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TFN9Qiak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785334447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1S6/CzOMnNlnmutzVvvJHpOovw2TlW70jeCaiYJeN3w=;
	b=2KlVonLf7dnL4CCRFWbbWXokL0t9NOEGpnlr0KkyYhmlukjcDMQ0IuUyXuRsTvo1sjcJ+7
	vdxcLDqmKSyaitbC2CYGU/zP858gRk6h62ITgaR6+1ecP8tRZAtysJykPf6h4bwa+QtlKV
	1dUiXYoGOOKy39NN9/A3gjD0aoD6uuM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TFN9Qiak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785334447;
	b=W92LpdOPZdM2KjAP7ZOktXcIo4Ot8JwDLIUukCtDuwDrDYpecqsu6hv+tjb8dONKL8SEXz
	88O7REqkherYCE6tVVsTfDZTg84w2lNzva2i0QcvzhXhprgTNTrWxk+Wx3s7DbFc54r9UR
	ZfhBedkxJSiw3hjaePWQW7Vzj1TIFvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57B3D4010F;
	Wed, 29 Jul 2026 14:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB011F000E9;
	Wed, 29 Jul 2026 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785334446;
	bh=1S6/CzOMnNlnmutzVvvJHpOovw2TlW70jeCaiYJeN3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFN9QiakNYMFhzGLwDJxsm/HLxZnGEl7qMcgqyKLaRbgD05yigUzTEmydkRB8Y7/a
	 ExO6Eq7ijak8TXrN1eSFdHlyPsmOuKcXkpcJm9vj64UY9Lkxp1k62npkUOcw5xGTI+
	 q8bHkZwSEpxppi2ooWuWB0ucfjuvUNDtSAtxPDD6XvqQUCn2GfOo97/CY+/C5WEMwY
	 aHulRIisdd2uJ5wStNzj2J/SZ2WbBvEPq3mYFSjiXl3dXUv5d1ANKuQC0M8NeVfoMm
	 Zi+MT7NgiUsX31HPK0V19Vd/IcTYaDBIb1GGrIGp/getp2jGtgSQ13ny0TFY7vA2GY
	 N+Z/x+46hJISw==
Date: Wed, 29 Jul 2026 17:13:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 3/3] x86/mm: Fix and document DEBUG_PAGEALLOC
Message-ID: <amoKo2LoJvfndqHn@kernel.org>
References: <20260729110807.797920433@infradead.org>
 <20260729111119.604452135@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729111119.604452135@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37A114000D
X-Rspam-User: 
X-Stat-Signature: knefcrha8nhjenzy7mjyea5m8ax75m46
X-HE-Tag: 1785334447-592242
X-HE-Meta: U2FsdGVkX19gBn0pqZr56NTcBgSgzuWFT4WZUvYiq31ut5DB/1PGqxixgi+ZgaNsHIKn/7d0jwvQMt8LPgdee6NUaIqCbvwXtlXlEtMywIKghM4hZ1wE9QFG+8J5okf64St/Wz76BRisXZbsO/9TXJNNQT5T4K4LTSyjpnuQAwIzaAuQ/p0HhNf3AGgEEbdMB/wxdxmIW1MFxnU2l0MZAlovg3M8AyQb6vPZB1U36CtiQ2z6hnBRejnjlyzgrEYL5tCam7+unfUnhax+DxI+HkOxLxwBg7gU7oQMn/DG4eskxxPD+rEXyh7dz+x02FPu5pQ03re+dAipveWzyDJpO2LTeWSIgGQSo2czf8J+bWsMcucGuR/XSEe/qAW8i6cCLgsNjbK1hNIrx/J/FPh6MJHX+AsaeeembXKRoB4c9lGqMaqQl6tGkK7yNZdNb8WMewJ29PbUpuJsjhzmjsI+CcFF0Ag5yLGU4miVGeDWH+p1M2EnoGvjvyMS8EIDC31Yi50GseTF+Duj/cN2W0YOw16uLpbj19Ev8o7VddYdbkF2+K8tFCnctL8eMzlAjUHXcF11Z6VCJS128yFp1eJVcfHkwGwNebduNmy86o4UQsSWUYZep4J6s/W2Mji5h8+Vj0NAeI5OoATI7dnsoN3bzw2l8kWlDzfMBEbVoHZvsvj9Pj2jO9gNsYtZLBBwWepotGcrh3JjyRN32cijIorVg3wI9t02rE4pKGmlC53+3345f8luXJGKP8kMFuiVhbusW5+UHRFuFlhb2Lbqsd326R3CzQ9EhH/54bt6V/gNGjJWmYXlHCdQgRPMN+XLvM8zkLIKaTu+xz5lWgis4onMpxekcg0UeAj/BR86/HiwJ3i1YIFaYqVIugB/lLmjggLQ4sTUSx3PFxTXlLtRKU51+YnZSODjOIzXuk11q2CC0Ap1T4E5y8bcZJfpcb7iLrT0hhq8abbv9FHyjhnwPrt
 UPabjc5I
 XBJYmXtbOjNrOBGTdwy+12xorG3W9tdPVm/2DwRUmzpvorEFRF3+9mvPxtSIFsJ/leGFRMWGsqLvR3RVi+ROFH4xe/wrxafISzmlAMxCQZPhTl66a1MlwWdCahJAGO9EQaurVywOW5Tf6qvbI+c9nB8t2EwFQfJ5pp4LuujIq2gedz4Qr6OwDW1ARtFBIF5szJ4fCplm09WrLyHC9wAw7vu/IzROCu1CujV1N7V6l52CR2a7ube/qmbgAeElUhI1mjb9BMhUmzJ5udmhR4JEZYSgh23BFe9xq076fw0qjzbrZ9JkeOeUBDMlS6JjA0C2mFul5sibhdZ7cUk30+MYHU5UG4L8rRAWvYuBXI3Dokr2Esro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 01:08:10PM +0200, Peter Zijlstra wrote:
> It turns out that commit 5fce67641a3e ("x86/mm/pat: Don't gate
> cpa_lock on debug_pagealloc_enabled()") was a little too quick to
> remove the debug_pagealloc exception for cpa_lock.
> 
> Notably __kernel_map_pages() is used by the page-allocator from any
> context the page-allocator itself is used, which violates the cpa_lock
> rules.
> 
> Re-instate the exception, except make it specific to the
> __kernel_map_pages() such that any other cpa() usage is still fully
> serialized by cpa_lock. Also note that since cpa() should not be used
> on memory that isn't allocated, the page-allocator locking and cpa are
> infact mutually exclusive and all cpa usage in fully serialized.
> 
> Add a comment explaining this and other 'funnies' surrounding
> DEBUG_PAGEALLOC, including how pgd_lock is not affected and the TLB
> trickery.
> 
> Fixes: 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>
> +	/*
> +	 * DEBUG_PAGEALLOC is special; it is called from any context the
> +	 * page-allocator is, which violates the normal cpa_lock locking
> +	 * rules.
> +	 *
> +	 * However, since it is part of the page-allocator, things are still
> +	 * properly serialized by the page-allocator locking and the fact that
> +	 * when a page is owned by the page-allocator, it isn't owned by
> +	 * anybody else. That is, you *SHOULD* not be calling cpa() on memory

                                     *SHOULD NOT* ?

> +	 * that isn't allocated.
> +	 *
> +	 * Additionally, DEBUG_PAGEALLOC ensures (per probe_page_size_mask())
> +	 * that the kernel mapping is 4k pages, therefore there are no large
> +	 * pages to split/collapse.
> +	 *
> +	 * Furthermore, the page-allocator strictly manages pages that
> +	 * *exist*, avoiding pgd_lock.
> +	 *
> +	 * Therefore, it is safe to not take cpa_lock.
> +	 */
> +	if (debug_pagealloc_enabled() && (cpa->flags & CPA_DEBUG_PAGEALLOC))
> +		lock = false;
> +
>  	while (rempages) {
>  		/*
>  		 * Store the remaining nr of pages for the large page
> @@ -2008,9 +2033,12 @@ static int __change_page_attr_set_clr(st
>  		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
>  			cpa->numpages = 1;
>  
> -		spin_lock(&cpa_lock);
> -		ret = __change_page_attr(cpa, primary);
> -		spin_unlock(&cpa_lock);
> +		if (lock) {
> +			guard(spinlock)(&cpa_lock);
> +			ret = __change_page_attr(cpa, primary);
> +		} else {
> +			ret = __change_page_attr(cpa, primary);
> +		}

This does make DEBUG_PAGEALLOC exception more explicit *here*, but OTOH the
spin_(un)lock(&cpa_lock) in split_large_page() becomes confusing.

I like my version with your comments added there more as it localizes the
DEBUG_PAGEALLOC exception in the lock wrappers.

>  		if (ret)
>  			goto out;
>  
> @@ -2661,15 +2689,23 @@ void __kernel_map_pages(struct page *pag
>  	 * and hence no memory allocations during large page split.
>  	 */

I'd also return early and maybe even WARN if !debug_pagealloc_enabled(). 

>  	if (enable)
> -		__set_pages_p(page, numpages);
> +		__set_pages_p(page, numpages, CPA_DEBUG_PAGEALLOC);
>  	else
> -		__set_pages_np(page, numpages);
> +		__set_pages_np(page, numpages, CPA_DEBUG_PAGEALLOC);

-- 
Sincerely yours,
Mike.

