Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55C5606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Gv0tPwNP
Received: by kanga.kvack.org (Postfix)
	id E76A06B0341; Fri, 23 Oct 2026 06:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C406B0B2F; Fri, 23 Oct 2026 06:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62E76B0B30; Fri, 23 Oct 2026 06:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4E7B6B0341
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:18:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42EC012037D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:18:33 +0000 (UTC)
X-FDA: 85353491706.27.0BDDF9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 81F35140007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:18:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Gv0tPwNP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792750711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48rUw1Z2YCN0d1r+igM4P0aPkMs18zYpkWGEVt5x0Lg=;
	b=VlGaBMpwXAy7IGVtEWaosag8JETKOuXs7KTgqDk52a8HkJFYpI0e6stvRNfzMBD0iaJXJ7
	jx8FoXXgA/MAyt3pV1b1FbbBqq/vqOS4J3STk7z6rvk+ItTiDDAlgxynY5ElbhAuQr5hL3
	7NmNZrKsu3aM8WkFAxOVq6dokLETgkE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Gv0tPwNP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792750711;
	b=cqmBO5BbCMAkdphAZPI4oFmOuuWeOb90BNnXlghAx6PNbgoF8inNhW9mrd7JjmgzHxLV27
	Sdq+qdK7pEh0389gcxEwRPUChsS7Kzvjzqu4fX6vV81EnEHG1lfKN5M8emerc2PWrxsImb
	17R2zvmGqId6RmGug8n57uuPxY1Ki7I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49A5A1650;
	Fri, 23 Oct 2026 03:18:27 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA9CC3F7B4;
	Fri, 23 Oct 2026 03:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792750710; bh=rDCKGdRiz166rbp3L1GqdW0EbXoka1CMQiZb1poZNJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gv0tPwNP8G2Bw0xRprgdfHjdFBGNFMpk/hG8nosXDB1w7Glh9RBzUtz+iqZOceuqt
	 mV0LBePmBjv5oLWjuqGK9bhC+ApU8fxvizU/c3YNVk8ks5ke0P3dwGpCmBZ76NwIbf
	 fVBicOBhEo6p+0BCv8JfVzLhwHxKLSqtRnu3CS3g=
Date: Fri, 23 Oct 2026 15:48:27 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v3 1/4] mm: fix missing page-table destructor in
 pagetable_free()
Message-ID: <s5wpe6iiidy6eo5lqs5zqut3d2of3erbxz6xofah4i4n56qxdn@r7vjivchqfil>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
 <20261023063428.3658761-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023063428.3658761-2-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 81F35140007
X-Stat-Signature: 6pgfm9xas7zxjf3t9zw7amkyt5cj43tb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792750711-72801
X-HE-Meta: U2FsdGVkX19tf8/aYOw+WXXjjxTc/MAffUhiYjej8rwmhWelGarpL1hs4x6CiWeBSKUQi8iVjMzIklruK/mdBazVmz5vF+YPVz8+RyG89LxKYnGkKrGbg+NtQhgcLaHnvfMSOvsj9Z/6eJ7XYHwFdvBUpAudgqGZVxqWq8FbINUCfWpNXD7HMp4ehEKA5JwSNeeFDgx+j7U0c1MXu0hHvM25GSbLQHL40trz4gecmlFStsuaA9Oc0JSsn3wP3OmI1jE1rmYRW5NWkQtjHCUZ8INQAm7trgjI2e0AIiA0GvQ/rRPIvqVfj6p/2vp5xSGQBUaFO7a90B7hc4NVEk8JR21qBSBqsYoVQJSdJKY+6sAnEdWlVOnSAmbBNGtRgChVdL2zYVSBWD4zauDoFlo2/kji0pnDTub9Y0XzZBUCErbupgZfNhEj0sLtxuj0fAbia1EZobzCD01duszV9mU61SCG0e3bjG2zMNJ6YCDqTIrti7+4Q6Hc9blSMX1ErF1otmJPQ8pQ7kTCGW8cIWl8q2Mao6KPasrOJXqtDNH8D/e7l+xO3LJ2BfnPdzTG8pbwsl2g1K4+ZTn92GScagEVj8HJSeoAAKNmB0IrJlWQVsObe0fzEpA9BnoXPBNf8EfgvJs8GACtawaFjHpJwLW8zGcjIemvMvIzZ1dd7LKpyJFDM3CeLDJezbBmoRtEgr5xZkWfHV3mTxALKuVY31CwhxpOhxl95rEgqNZHeMHpj2W4ADqX5o9LlZaDesUeC2abD3j5RnVY+rUNVhibFpGq97w9pdG1ouJnaXS8yzriva2t46H1ctobUnn85/8tBmO3aH/dM+0gBsi0T2lSsDVZ8mSBtynFE1L1zfQTj/RdDsITIvt73NxjsfihQvJ57xcHHtNksWbF3lqb/v1nIlthvBRLo7YwhA4rQkhqGRwTfJgvfvOJ+xmLawLgfruqzPJoOXngEd4oAJf+QsHz1gJ
 Rr8lsHT4
 lhnH8HMLLicqyriuq3i051G8q/9JQEpUd0LqeBcLF3CRmi6PtvSBjbLzFIdDwWnmHTwqf1RlPj6lPa1X10sPmNL+N+UTisn2KmAV/Sva7N5ZAc5jUi7T361AV8venVdoMp/i5zb1sBTQ6mPwJJ+TtmyCiytTvH38ACS332aFoV393s0hjzIuwiC+eEhWkkM+FACCgc9pcBJDeBVquR82GLL4PKa2C4LhzUvVAuNYiWcOf29EqWA7tHr0a19ioA2SMvQ/IBXqy88vhMbTQP1oeONFxhTQYPOUAX2JlNvqr+BDLrNcnFepDQeytIuqo1w+fXruzpLCsYCfs5twUCi2KOQYY0WmE8AHel8sOcNtbrTmiXf7GVfmxHcbdCdqSiogR4K6iRmiU8t0rkM9PrVk4krBEFKjXdYlLFO3yDzLdaG13CZ+LJAym4wf1RHRhmdUlNTBs1A9HEFo0SwmOmtCXvq8Eg45g2P3ZUpZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:34:25PM +0800, Muchun Song wrote:
> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
> tables.
> 
> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
> splitting a PMD. Restoring the vmemmap backing pages does not collapse
> the PTE table, so a later memory hot-remove eventually frees it through
> pagetable_free() on x86-64. That releases the page without running the
> matching destructor and leaves NR_PAGETABLE elevated.
> 
> Make pagetable_free() the common free-side primitive for page-table
> pages. It checks PageTable() and runs the destructor only when the
> constructor state is still present. Callers that explicitly ran
> pagetable_dtor() have already cleared PageTable(), so they are not
> destructed twice; pages that never ran a constructor are freed directly.
> 
> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
> Cc: stable@vger.kernel.org # bf9e4e30f353: x86/mm: use pagetable_free()
> Cc: stable@vger.kernel.org # 39406c05f8f1: x86/mm: Fix freeing of PMD-sized vmemmap pages
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> v3:
> - Explain why pagetable_free() does not run the destructor twice
>   (requested by Kevin Brodsky)
> - Add x86 stable prerequisites (suggested by
>   Jose A. Perez de Azpillaga)
> - Collect Acked-by from Dave Hansen and David Hildenbrand
> - Collect Reviewed-by from Jose A. Perez de Azpillaga and Kevin
>   Brodsky
> 
> v2:
> - Move destructor handling from x86 into pagetable_free() (suggested by
>   David Hildenbrand)
> - Trim and update the commit message (requested by Dave Hansen)
> ---
>  include/linux/mm.h | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..466875c5908b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3812,23 +3812,6 @@ static inline void pagetable_free_kernel(struct ptdesc *pt)
>  	__pagetable_free(pt);
>  }
>  #endif
> -/**
> - * pagetable_free - Free pagetables
> - * @pt:	The page table descriptor
> - *
> - * pagetable_free frees the memory of all page tables described by a page
> - * table descriptor and the memory for the descriptor itself.
> - */
> -static inline void pagetable_free(struct ptdesc *pt)
> -{
> -	if (ptdesc_test_kernel(pt)) {
> -		ptdesc_clear_kernel(pt);
> -		pagetable_free_kernel(pt);
> -	} else {
> -		__pagetable_free(pt);
> -	}
> -}
> -
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
>  #if ALLOC_SPLIT_PTLOCKS
>  void __init ptlock_cache_init(void);
> @@ -3921,6 +3904,26 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
>  }
>  
> +/**
> + * pagetable_free - Free pagetables
> + * @pt:	The page table descriptor
> + *
> + * pagetable_free frees the memory of all page tables described by a page
> + * table descriptor and the memory for the descriptor itself.
> + */
> +static inline void pagetable_free(struct ptdesc *pt)
> +{
> +	if (PageTable(ptdesc_page(pt)))
> +		pagetable_dtor(pt);
> +
> +	if (ptdesc_test_kernel(pt)) {
> +		ptdesc_clear_kernel(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}
> +}
> +
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
>  {
>  	pagetable_dtor(ptdesc);
> -- 
> 2.54.0
> 

