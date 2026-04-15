Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 413A9F43848
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45D66B0005; Wed, 15 Apr 2026 11:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6096B0092; Wed, 15 Apr 2026 11:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4956B0093; Wed, 15 Apr 2026 11:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE816B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:59:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 015A28BB5D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:58:59 +0000 (UTC)
X-FDA: 84661248840.28.19CD004
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37280C000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:58:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0i33bJZ;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776268738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7rgm7cxZaadd6+va1WKqLPVDJoEG/g/j6EWoeXD+ew=;
	b=y/AUDPiCNqxnE2xhloVpZP4eEfvT05z0mKjt/CeUbXHA1WN27qzeh3rEsjfS4HENk3VCbe
	kscFiQUDLszZaoy/Unj8k6MpWkQ0SpEXzAmj3vWrL/oGzI5lZug04zgllszXLL1gA+X7PS
	XQBj7v93+NOuxLtOZ8bh4Dltvnn/ldA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0i33bJZ;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776268738; a=rsa-sha256;
	cv=none;
	b=PonsbXYp6VM3EPqRV6/482ncmXqngRo5XgpyaoUWFEAKOhFcwGH+kZIVd4Cozfu2nS4Kuy
	vJH5uRZEGF64wNiQ9BbkklrRpcsTESKVl4HkxCjB1o3IsV/KmRGxxzisCAuiFANqV0kLux
	RB1WrwPYDSjpW2Pt4cWk/yRcXove4iY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B94F404B4;
	Wed, 15 Apr 2026 15:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6368DC19424;
	Wed, 15 Apr 2026 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776268737;
	bh=y+oq4INIxgbLQllztrJYjafmJkeuG9Q8awCwafdTv18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H0i33bJZOnaxzNBKISduWbARJbUIWH5tRHgMmNW9tGUDA65uuEWbQytdZpKAwleUm
	 2R/5Xj3BYQt06J9Pt8r1Umg7yauBzgLvmDnjAGySIE0ayUcHQHxeky8KavBuS9QUcs
	 ZF0KFAz/6OUD0nQ+T+f1dJDvWHdhhTq8+PDYVBnlLr4nuTkaADeTEMzJXYlVO7s3AX
	 o6fAv2+7lLuamfYG62wd2tnlRZNPn97bj0RSkuegYp/wVfhHKD0B1KQpV14gm4I9da
	 BQ9hZk46xrvcn+0wl4O3LCZCwKYjlZ/63x5kdPTeA9qbpk182SsVzVmouMLLhLdgnI
	 itjpqaY6gD1Cg==
Date: Wed, 15 Apr 2026 18:58:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
Message-ID: <ad-1t9sMWBqmgJ3g@kernel.org>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415111412.1003526-4-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37280C000B
X-Stat-Signature: g778nuqstwkpsqno5k1o7pzcw6exioi5
X-Rspam-User: 
X-HE-Tag: 1776268738-918629
X-HE-Meta: U2FsdGVkX1+U0slhgAYt3RwDEpv4G3HwQ130aSwI1hLVdpAPO+kBv+gX5cxZG6PjUHFd/9EJL/YEc1ExL/lO2DmsooZCPNNLdN7GQKZ77gGZjyxEZBNBbYbpqBsDDyEDGM3JvyXYhL/AnRtZNYPfm6PhHvbdItUNzoDIgLYoNYL2YAZcHlZaBopwTt3Z9f9C0gI+PWjIIbSJLkxC7MsBPjlU/ybtpeMM9/C2zsS5Xc0Io5p0UC5rbc2cCZMXYk0k6oSEDrya7ijN23rdFcaROSGjxKWsPL6INbQ1NxsQSMAKA2Ur1eEVSneU8Cre3Jzgk3OSxBNPu7+r5jaBIKBqTGWP7HHyzYVIS43cD72GaiVgj2JVjjV4FLE9A98diVxjdDqJw9Mb126MVNTpAYPyPSJDDPCSZ/49PnaRKQlsVH/eIzcR3S6EdusLPWhbsPercgCdyJuvlwftrltGjJAt/sLotDN78Ql/j5ncMDrtsMwXmycsVtue7Q6cNmw9hoxR3CV6PH31ivtG8/sRaOY1v4h/5tPlbu4gdPjmpP2tZAr038RN9EILpaVlRWdW20YiRnr6IPPBXFl4jRVrY3PJxhjIezC7+nKLhwLJs3rYr0fkbP3fAdF5XR5WLSMOKJvlh+oPbc6/hWuGYDF5zDE5S03x1PlxJ6BwKDTj1zazwdzkuDyRi8+HuKVEvfbpD6cyeRjEj78es+kV+oo/s4iHGsCFfhSrOCOgkdlC23zV26TfxSysXy1nDOp3shSzCTuRpfwlgFn7dLmwtNl84YS26ltHbEgyjZACutAtYAM3GXVq+JJz0zH8h/+Enqbw42FP2YwbiW35HTjX/mr64g0rsHY7Fm1xXU47c/a1mpszPwvTuGxN36bAUUBDO97UruzvyfzLEaOgx6VJQPyZ/7PEF/Zo6sVDFq7j4i+rnc4Ohd60ypiSDu5JKjaTw8fVbnC716FAGDUvoQqcM8wDOMZ
 I45tbk9I
 ieca2RoqtJlZum/8xxY7eMAwXgjNKNKWV18gwVCi4DABBOji5meY2ttLJKqnZGbCcQvXl/I/FL1TLJ2DeLD0eI3IVB4DpepAdPAPtfcq0qACMSAvEhQki8+podV8h1Ui6enrpMM5QR5hDGxhmxj8tD46SpfJv98vzysc5FhG76Zaa6p9Cx+0euhfgh3VziZ/5A18t1XfVEoqoVzG9dvyt7i4pMo/jm5C1GtGMOlJJAkbPuOTiVnXFsIAdVRb8y/fpuinr8/C0FqJxKssoAadXriUttJ2tPIolFLJxZaqr6GDhxpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:14:09PM +0800, Muchun Song wrote:
> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
> counter in /proc/vmstat is incorrect. The current code always accounts
> for the full, non-optimized vmemmap size, but vmemmap optimization
> reduces the actual number of vmemmap pages by reusing tail pages. This
> causes the system to overcount vmemmap usage, leading to inaccurate
> page statistics in /proc/vmstat.
> 
> Fix this by introducing section_vmemmap_pages(), which returns the exact
> vmemmap page count for a given pfn range based on whether optimization
> is in effect.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse-vmemmap.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 40290fbc1db4..05e3e2b94e32 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -652,6 +652,29 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>  
> +static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +					   struct vmem_altmap *altmap,
> +					   struct dev_pagemap *pgmap)
> +{
> +	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	unsigned long pages_per_compound = 1L << order;
> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound,
> +							PAGES_PER_SECTION)));
> +	VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
> +
> +	if (!vmemmap_can_optimize(altmap, pgmap))
> +		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> +
> +	if (order < PFN_SECTION_SHIFT)
> +		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
> +
> +	if (IS_ALIGNED(pfn, pages_per_compound))
> +		return VMEMMAP_RESERVE_NR;
> +
> +	return 0;
> +}
> +
>  static struct page * __meminit populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap)
> @@ -659,7 +682,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
>  	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
>  						      pgmap);
>  
> -	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> +	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
>  
>  	return page;
>  }
> @@ -670,7 +693,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
>  	unsigned long start = (unsigned long) pfn_to_page(pfn);
>  	unsigned long end = start + nr_pages * sizeof(struct page);
>  
> -	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
> +	memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
>  	vmemmap_free(start, end, altmap);
>  }
>  
> @@ -679,9 +702,10 @@ static void free_map_bootmem(struct page *memmap, struct vmem_altmap *altmap,
>  {
>  	unsigned long start = (unsigned long)memmap;
>  	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
> +	unsigned long pfn = page_to_pfn(memmap);
>  
> -	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
> -						  PAGE_SIZE)));
> +	memmap_boot_pages_add(-section_vmemmap_pages(pfn, PAGES_PER_SECTION,
> +						     altmap, pgmap));
>  	vmemmap_free(start, end, NULL);
>  }
>  
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

