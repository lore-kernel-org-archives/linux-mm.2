Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB231C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CDC6B0088; Tue, 29 Sep 2026 03:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C248F6B008A; Tue, 29 Sep 2026 03:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB9A6B0095; Tue, 29 Sep 2026 03:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76FA56B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:24:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF3328042A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:24:14 +0000 (UTC)
X-FDA: 85265961228.08.EACA04A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 280361C0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:24:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibkey2yU;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790666653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvxJPj3k2vjV6D8HUDd8QkKGWeBMIhXhJhVwkCPhP3Q=;
	b=WWUE/F1MQPNmCCHePGo8E1h5PlZv1YTpCwtLbarDysrxmDIXqwPaIxuJvs7tLOHuZXDAm4
	jbabajZWR2sOmltFK+ciO1NadJQsMPGvIiCyYN42ljTV9K7fOt9zTbH4ZY/diryvTlDCtY
	k0bQKPmzIs7/UuZBFd9He1ubDu41Pok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibkey2yU;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790666653;
	b=ZyMfxjt2m7LnEaMBYADZYC7tTiniVA0EF72XbCSrxv/QAdrOgp9lCwnseR1nyG5PKTbvs4
	3iw5ki7tsrNWm4CVnPkTW2bmLlhACFuSyDyc3eSJu5UDyrHRJonrLgNvTgElYqAcVQU0Dc
	iue3rEDOrK/jHOgOfQe36EDUeFT4HxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57E5A41840;
	Tue, 29 Sep 2026 07:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE16C1F000FF;
	Tue, 29 Sep 2026 07:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790666652;
	bh=yvxJPj3k2vjV6D8HUDd8QkKGWeBMIhXhJhVwkCPhP3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ibkey2yUqqbiVM76d/2jZTGyjIdUdz2aZM6YaiTOTz9joywkD+nsB2wdU5GPHSSHW
	 Uxe6UNjvfBnxPaLAJiLIH+gsRzsY2K3p6sj1jwCatttOSR5PmQJWeYyMS7R0gTipDx
	 91toSUwKUs91yGhn4NOpNTCFOAR4QjdipsKpKZKrVdgP4YFHgv2ipVUjpAgmvec1Sg
	 nwUgjtnXkrBuf1mAFgFG+g0dFlvx/XpzAYRP1+O1d6y22DmRT+IkA3jEDVM8r9eqqu
	 gWm26joLY6CvegjTpmEF/XdyrAUPtvOP2B8YcOfRZfiDX7H+Xr/UGrRS9OQkV2HyLu
	 Y9EqZQaCIOopw==
Message-ID: <deecea10-589f-4e2c-9c17-5e5dd4e81250@kernel.org>
Date: Tue, 29 Sep 2026 09:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/12] mm/sparse-vmemmap: prepare DAX vmemmap
 population for compound page orders
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-6-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qsca96ak8w1f1gemds7mkr5ndgfgmznh
X-Rspamd-Queue-Id: 280361C0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790666653-517752
X-HE-Meta: U2FsdGVkX19tWW03Zg14P/lpUajtJEdIvJBo/caAgRO4GsQ5sWW0KCWCAk4t8vmILWzRy0m5XlAp2zodvKq6KIRyRqnVw5j6LcQICB8VGeKBz22AezFcdW0N2UFfY9aoQvnKoKm8YmD95bliH7dJi9Lgvvqqk4JKGeE6VhI1pJVhmv13Lcm1gZRaxFns7zEIM/8lj2d3MgXkD3L3K3Jld95lwB+BZMKSY8jQUSO4KyZwKOACADoEork7Vy28iO2eAJa1hfipcqRcDoM/umtesuhV5PwLVgO/8rvYcrZcrvTnC1k10K4ZZC5o8qCnCJPBnOC+V7NdfIn8XpwrpCFugidZSlAvNFuz7c/+Hp97DrAcey3BFxJDDYICm8HZNAqxDxoaia+57F/gcZ6HZYCJ8FofHPPLgxud+wS+cypm/2y1ejnApk47nn4Y93TGG/k5+EWk5FaRbIu2gtqrgsKxGU+NnvSNN1oMFUvbyaD+4c0Qup+Cylr4dRHCQhKJeMxLjx1eeIVaOFetoYqxp4NMYZ3cm/Klaa9aARHd5XGCNcpeU97keP3dzMqCn0brR258yW7fe8uLlKy86Tzm52Ebndpvru6wvUKMZL1bYL9nTeQ/mVmJsk7V0dDEJUFwCXtghqt52CNy16S0fC6lbU2Occt+ssWTQYY2avj01UfRP9UwVrZwKb+sC4B43FxJXW7vUOp0D2ndI7gR90sghAtZUcyqZlpcXTUNX8ovxLVgwoZ4cQNgv+a+HozBgficzMUkAsqt7mWtu7tmkhX0lgUyCcOs2gBYdHIpnFedELTzs87dVh9sEu9vBio3J+UGxQcwmQsWDT1RbOSrjqbivNPwB9ojNZ/eBSGRQjXp63a5iuS619N09duoR6OHJrN1dPJCm9+P7ayX8EctoqqTYqiCCh4PyaCT8Il8jX9ILoTMxWaFmIrNCZRtvT4cCRmasPbw+gt6HA0O92bpLxqopCf
 Sh4AIRg2
 E4yRvZLeyPcZY2fsDHrF3TV5LtQ/q6tY/VSuFE58PAp7dvf0sHdHFfxqrpGsXe3u1O8mFocMrRdp+q5YfdQqlakBAMm37wCmKlTC/EPVfeuiEXIYhFw7N1tPQtnXh6y18kCtL5KaIPx29UXlWWiS4GXuewpqD2w7Pz8FjlKPaWNhpQDkdF4kkfzDWSgzjR05z3et4mS2MvFfJNtp2TdlP3XV/Ix40tNMKLX+6V8tpYKbNoxTdLENdYzQh7VYJ35Q9QLQ55SCdpaR9GZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> Device DAX still uses vmemmap_populate_compound_pages() to populate its
> compound-page vmemmap mappings. That helper allocates the head and first
> tail vmemmap pages explicitly, then reuses the first tail page for the
> remaining tail page mappings.
> 
> Device DAX is being moved to the section-based vmemmap optimization
> infrastructure, but it cannot switch to the generic section-based
> population path yet. Once a later patch records the DAX compound page
> order in section metadata, DAX head and first-tail PFNs can look
> optimizable to the generic helpers as well.
> 
> Add a DAX-specific population flag for this transition. It keeps DAX

Well, you're not adding flag, your reusing an existing one and renaming it?

And then you're specifying it on more paths.

[...]

>  mm/sparse-vmemmap.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index e4dae98ba7f8..2457ea2c6dca 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -35,8 +35,8 @@
>  /*
>   * Flags for vmemmap_populate_range and friends.
>   */
> -/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
> -#define VMEMMAP_POPULATE_PAGEREF	0x0001
> +/* Vmemmap population for ZONE_DEVICE compound pages */
> +#define VMEMMAP_POPULATE_DAX		0x0001

Cleaner.

>  
>  #include "internal.h"
>  #include "mm_init.h"
> @@ -243,13 +243,17 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
>  #endif
>  
>  static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
> -					 struct vmem_altmap *altmap)
> +		struct vmem_altmap *altmap, unsigned long flags)
>  {
>  	struct zone *zone;
>  	struct page *page;
>  	const unsigned int order = pfn_to_section_compound_order(pfn);
>  
> -	if (!vmemmap_optimizable_pfn(pfn))
> +	/*
> +	 * Device DAX still relies on vmemmap_populate_compound_pages() for
> +	 * head/first-tail allocation and tail-page reuse.
> +	 */
> +	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
>  		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>  
>  	zone = pfn_to_zone(pfn, node);
> @@ -271,7 +275,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>  		pte_t entry;
>  
>  		if (ptpfn == (unsigned long)-1) {
> -			void *p = vmemmap_alloc_pte(pfn, node, altmap);
> +			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
>  
>  			if (!p)
>  				return NULL;
> @@ -286,7 +290,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>  			 * and through vmemmap_populate_compound_pages() when
>  			 * slab is available.
>  			 */
> -			if (flags & VMEMMAP_POPULATE_PAGEREF)
> +			if (flags & VMEMMAP_POPULATE_DAX)
>  				get_page(pfn_to_page(ptpfn));
>  		}
>  		entry = pfn_pte(ptpfn, PAGE_KERNEL);
> @@ -546,6 +550,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>  	unsigned long size, addr;
>  	pte_t *pte;
>  	int rc;
> +	unsigned long flags = VMEMMAP_POPULATE_DAX;

const and at the top?

-- 
Cheers,

David

