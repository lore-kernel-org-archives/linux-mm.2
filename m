Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 424ABFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B076B0088; Mon, 27 Apr 2026 06:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BBC6B008A; Mon, 27 Apr 2026 06:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A886B008C; Mon, 27 Apr 2026 06:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDF86B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:18:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0836B12013C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:18:10 +0000 (UTC)
X-FDA: 84703935582.10.8929AFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10F4C180004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:18:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QM1aJHxz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777285089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKk2ll1D3ZJ6s4IP6sE45BcGF90ItdkcTm+IkNnd13k=;
	b=5PD6qxundS/3WNotA3ESNN3JJNMLHIou5YTOorpOupkRniIWpIxaLRc6G5vdI5DPCoyYr4
	KzttudwahNodUVKt+2NH7OXbn37UAeZ8Gfz57LpsOdMxYM8Vq8Ab2evqget7KRLYrmQl+a
	2pd5VGCE9c7QeczLm1BdcyWjftKfaTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777285089; a=rsa-sha256;
	cv=none;
	b=eF6V8NDCmTOtWrT5oQOhaZU/dByugkBQKLUdFrIJTwgVTEaKy+XDqt0XC/maTNqs6qR1Hb
	Wl7n4PO95I8R/YPUy8tAlhFZCiJg7DH/OF3JF6rqTdFoHKpM9zoAb9ROhOQtOs7ANu9pyy
	a23CbIl2dru1vJ8x0KhGT38VPegl6FY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QM1aJHxz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0C63441E7;
	Mon, 27 Apr 2026 10:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A365C19425;
	Mon, 27 Apr 2026 10:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285087;
	bh=vA1+mJeHSLbEw9npbrF1VPrAm7bpS8jJonX0Sr709CA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QM1aJHxz3I2TspVV/exFtiRcUTjqKti6h/o6CHk6fa7ZyK8bGGqvct7rd2MsGDN+F
	 EP9LaRlTpYVPKw4D9ygb1icNmMC7arKZVGGR9rdESvLqByR0hDMB8aW6AQhRK5LFvJ
	 5PbZJago1asJ5kOUOiwYO+W8BqXlAh16tNBBZrzgwsmvgbV1OlGHJKP48xdzQHzfpE
	 45v4uAVV22E6fZuwbiNXUEnWFHFXv3fLPiax9M9lZaz8Fq9q8+trTOtMAfFAm3x+Sc
	 C98xM1Gt5JUyS+4wSUKjC4GPR0pRv8tC9FtRNpo/G3E8wAE215HYzzwdmchHG5pYua
	 IoI6GLfMAhrmA==
Message-ID: <09298afa-9a36-4f29-a8e1-d4750c338df2@kernel.org>
Date: Mon, 27 Apr 2026 12:17:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260426092640.375967-1-songmuchun@bytedance.com>
 <20260426092640.375967-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260426092640.375967-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 10F4C180004
X-Rspamd-Server: rspam04
X-Stat-Signature: hqo3npq7ahdpn8i4wtm7oc9q5qpurhhy
X-HE-Tag: 1777285088-556461
X-HE-Meta: U2FsdGVkX1+gtBhUSn1j8ZZE+KISCYf6oaFumeXrkaCcFoz9TMqh0MRoX3krp344GRveV0WPey5jSJajLUJmiAY0mk7dVYubNrf5IRy5yrPWigqkA2Vp5J57l3OHiV9oRLVSjmolG8O5VTyTM7A2mQ3XS9I7yr2/hu/uEMqGzGzn7bKJ5AbakRV2IFgZm3Mmn05epNX8la17K/kosP84JXc9hX7yUEGDOHuI5Vk5X2vpT+23pjhTDk737Ep1k/bkRcZYoaK2DzHlIv+2qRAhCsSKjAZusc3HPG/i2MgGQ+BD1QlWxwgdYzLKBjAQ8GBGT4kAhoN0JNz6j6mZR2WafkxtmiGrS0Qy/U8lQYWa0i9gB1b7NwJdVSNsm//seJ3x66TUnSrx62cUxV6NhJv0Fg+zWgClZDdF4jLZvAKyO8DkBIu1Iik5gIqE0BOCYJaL8vBptAuSRLn1yDllZwah4UW5KHccA3SI5IvAOMOZ74YkyHvcqHYdtINjfgkfngz6Pfe+gkUmREYQfSASLquOIfDAOsHFdiu8UEenNTjXVq5o+ztBrxOhKZhGYSjy/RSL8HP/3EcWx/l85c6wOUwZ6uZbzzZOifNSpnCF3I2OXfSmWiBao+00P9pwcDF6hccnopSYSgPP6ndNhNjb+AF25JtCItwjf/eKycuxlgsnJOdXOP7UJU4fR8OhV0vDSGzeK7Xwv9P71gTLCzGI8NWYzD9IfB/LUN9d22r5J8SwLaZPCjXqs0mKi+5XucAuKg7eWr3BDf3OP9UF8rvyg7Q/sXPWFARV/xCwvizq3paQbsydMwn3uaAAVPcnzgSwGsJF+P/4Yg/gxW1UsE04N2yONB8OF0Tc9h3wXXaPI+bQxGqRZzHDDGVSwRbfYX9plCtxqtWAZktLXytPhwU6e+f6D0THvbN8VooDb3mFiNNevoaA9mECWGvMkaIc5J3p6sPRxdtP0nEME3HuocOLVJc
 J23plDFs
 qJkXMGzZQs7ZFgnP12pbcNTbUO84AYLEhxrOR7FescKVOKxepHc62Tb52sAcDNTWgmi5nC7F5Ukth1+1wsW3O6dnRiLYzU4EkRrScB30NBQdQlHIuVui7aWTkKOIOn6UlfvLhAQ39Jz9inSMTZuYgGSYVxzc8YZa7GY3TifPoHomojU8ENxpRkWwORDRqlItm7FjSnwKSLH205Stc3opE/1sHo/7gbdWU1z8gWF2XIvr2X8w1819z2tzMiIGmleSEzO/ko3yfUYrQqgyi36h/nbX0pP6XzyKzfkTfLohteEfEaYzXxzuaBT9oGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/26/26 11:26, Muchun Song wrote:
> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
> counter in /proc/vmstat is incorrect. The current code always accounts
> for the full, non-optimized vmemmap size, but vmemmap optimization
> reduces the actual number of vmemmap pages by reusing tail pages. This
> causes the system to overcount vmemmap usage, leading to inaccurate
> page statistics in /proc/vmstat.
> 
> Fix this by introducing section_nr_vmemmap_pages(), which returns the exact
> vmemmap page count for a given pfn range based on whether optimization
> is in effect.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---
> v6 -> v7:
> - Refine the alignment assertions in section_nr_vmemmap_pages().
> ---
>  mm/sparse-vmemmap.c | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 3340f6d30b01..01f448607bad 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -652,6 +652,31 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>  
> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{
> +	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	const unsigned long pages_per_compound = 1UL << order;
> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
> +
> +	if (!vmemmap_can_optimize(altmap, pgmap))
> +		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> +
> +	if (order < PFN_SECTION_SHIFT) {
> +		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
> +		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
> +	}
> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
> +	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);

I would just have done that at the very top, as this check applies to all cases.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

