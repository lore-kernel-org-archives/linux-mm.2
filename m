Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C50C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447B46B009D; Mon, 24 Aug 2026 04:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7056B009F; Mon, 24 Aug 2026 04:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30CB16B00A0; Mon, 24 Aug 2026 04:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03D4D6B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:59:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78C03A04B5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:47 +0000 (UTC)
X-FDA: 85135565214.18.E52DAE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF7ABC0002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJv4dgyO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfsCD+lbgUkwgJSKcFe2vk6P9Ho2NTqpBJU649PuAp0=;
	b=A4L8FxDnxTP52omhNwCjRLT9y5RhFQj3LJXlB3xBHEp6Zp3JEsK99LnNPLkqqvHBrasiJ6
	S7WcpuNd4UIcf9NNBRaYrztuMeChtVxH3ZtBKUD58zFUuFoqnUWzdZBfBfglzCwErin4Nz
	557+GSjVQ3T9DaOHyHZyZ1/wa2XiU4Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJv4dgyO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787561985;
	b=YVfKd+gt15XqoyKb9fpT36KLhOBTdhR2zGTHUI6zxwjgbkEHqTTCqJST/+kVMkXToNmREa
	2uCmMfX/cKeQkajSfvonGuun/nzPP/uLe7MPf+C7cpexC0bF3x6l37mFWQa1r7/u7EDZOu
	VPeYXjnBUhyFj/Qv76WTGpxLd/OXIAo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7251960A63;
	Mon, 24 Aug 2026 08:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193F81F000E9;
	Mon, 24 Aug 2026 08:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787561985;
	bh=UfsCD+lbgUkwgJSKcFe2vk6P9Ho2NTqpBJU649PuAp0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=HJv4dgyOgT5ZRlVGjCC83if2DRxlVK2C8W9BOQge6N/Rn0TIjXQusymQj3BKUGzkD
	 +azg+6xDsCS8Lxpmg9MMyqsFDm+IHnaKmFckVOC1WE381+feEUfh8D3pip++pWhQNf
	 Qz1VSscF8wq6anl8Ke/dnfW/k0BcrpNXhQGBH22dH+m090HBhcPqUsx79LjUVd44U3
	 oDsvelQGxDnEXzuwkTJ4aUS1XCxmU1/6VD6rqESacYUzBBcS1yGCKI0zVo0/0q+yxr
	 DlzFlX/GmHWtKxlbS09Hl4tENi3ondeBBrg+M1dhcwJJnEEKOF6J6bfx3USRpBK8mr
	 QYi6sM71RW5gg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 08/17] mm/sparse-vmemmap: support section-based
 vmemmap optimization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260819095140.17252-9-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-9-songmuchun@bytedance.com>
Date: Mon, 24 Aug 2026 11:59:27 +0300
Message-Id: <178756196750.3606540.8562704442052486227.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: CF7ABC0002
X-Stat-Signature: ks8ykqnuyh7usbrpa79gscwzb6xq53mj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787561985-793213
X-HE-Meta: U2FsdGVkX1+Ipmz1vlAMzsG49MksxkT1feGx/Tz3JIiL+pWYYbAOjnKCk2vwLmoCemDwrNTTbD8bnTt884ICc7O9h8u9Xi9zD3m1mjGsxbIisakUOTkWC9b7PqIzHT2BC9jd4gUQ2p5Zl6vG25HCUwmW0679fCQLVZdm5djS29F1oopdWRtZBlQyL44qLZsdYNhVwRBNvmMxKMUoez6pqVbWuVTCFPr9xirQZerxNCpkYd0zILaNHvpydd+Xc1x1GZeeiytp6jJMwcxaarLfp2y9D7kHtGOuF9PitDWS2TlHIU+7gQycHbf4iRSqKKIagYmiaW19ADIg5u0tmqhdkz//MP3Te+/iTUY7YOALM6YpUQ425gZBTyWedLhb3YKKQb7luSjR1/OiiF1jQWqw/dHDs03zVK29KNQUpUzKZ3gVEoRDHoM4IWm49rrllQVTZ5zgjbp43HxrYmv/HsVi9ITfNFcEJMXOHUMjkafZy/p/6uY/uNmuwAF+aD//Qa3esrhGUSKBg0nv93h9RMncUPZo0XC6vowrgGrgVZixSuiujRvhgHZb2H5it8pfAmXfd5okMdA5dVCrA/Iqh8JuSo+XgJ74YzGEiD5l69iidxckBWXJBYZej3DtNR97QJlQLngrDNGjLS5RuGi5E65zQdojIpKrQIhVLH8P2ziH1lj/fgvkXR2OzqeCCO0SBN68xEnfOnJDS8BAtrD32+Eg9JT6p4KaDL8rapZOGBJeTBQ8he5vozHQu3TrtpQzvoPkRXgIvlo9PmMM7A0oL6Ew4rrF/f1JBl03ASTB17U98YwIRC1ah/+koDDmg+WHUNGQtFA28uhL3EmjKPM6D8fAQCBgRK1bEOv7RDY1oqzTHztQcdeIn8cYSIlreDQ8owhtaald4S9bp5WogMGL6EZfmbTC269tGncETWmLKF3pRaMxcDVc+WrLMbXkVwGnVPIJZ4ZxaHHclKicRoaLtcz
 IZkGt8M6
 +ihkX+gamn3xfyWK3gl0gC5SZDY/wVsRQbbb9t/Y5YpW9lalQadqJEwm847F+d6hKfIwO92XPaOZMFL98FH70XSNW8rsQl9N3Cvjnrdq3l2hU5gaafN8YgrO7geinDKNBapegMICglRU/j4PihdaiC0iBvXxIhsugubB52/dPg1Qsscy1RbYOHFmVP5mEPqqQoleHzO1lx4vTh5ybrXJ6ItJatuydU2pY7RddoVgbsYvAKZNZeUeU4iF9Ow+y799jNwOmr5bSatT7bFByB5AlK+0B03fepcbo4te1eBmnnbQJs42nOj/tBnOC5SraGatNoEdD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Teach sparse-vmemmap population code to use the compound page order
> when deciding whether a vmemmap page can be optimized.
> 
> With this information, the common sparse-vmemmap population path can
> allocate or reuse shared tail vmemmap pages directly instead of relying
> on HugeTLB-specific handling.
> 
> This centralizes vmemmap optimization logic in the sparse-vmemmap code,
> based on section metadata, and prepares for sharing the same mechanism
> across different users of vmemmap optimization, including HugeTLB and
> DAX.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index b770fe2428fd..737d50bdd3ef 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -186,6 +186,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
>  
>  	return tail;
>  }
> +#else
> +static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> @@ -193,12 +198,24 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>  				       unsigned long ptpfn, unsigned long flags)
>  {
>  	pte_t *pte = pte_offset_kernel(pmd, addr);
> +	unsigned long pfn = page_to_pfn((struct page *)addr);
> +
>  	if (pte_none(ptep_get(pte))) {
>  		pte_t entry;
> -		void *p;
> +
> +		if (vmemmap_optimizable_pfn(pfn) && ptpfn == (unsigned long)-1) {
> +			unsigned int order = pfn_to_section_order(pfn);
> +			struct zone *zone = pfn_to_zone(pfn, node);
> +			struct page *page = vmemmap_get_tail(order, zone);
> +
> +			if (!page)
> +				return NULL;
> +			ptpfn = page_to_pfn(page);
> +		}
>  
>  		if (ptpfn == (unsigned long)-1) {
> -			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +

What do you think about adding a helper function here, e.g something
like

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 0aa0ab4f8b11..933b122f9937 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -191,6 +191,23 @@ static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zon
 }
 #endif
 
+static void * __meminit vmemmap_alloc_pte(unsigned long pfn, int node,
+					  struct vmem_altmap *altmap)
+{
+	unsigned int order = pfn_to_section_order(pfn);
+	struct zone *zone = pfn_to_zone(pfn, node);
+	struct page *page;
+
+	if (!vmemmap_optimizable_pfn(pfn))
+		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
+	page = vmemmap_get_tail(order, zone);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -201,19 +218,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
 
-		if (vmemmap_optimizable_pfn(pfn) && ptpfn == (unsigned long)-1) {
-			unsigned int order = pfn_to_section_order(pfn);
-			struct zone *zone = pfn_to_zone(pfn, node);
-			struct page *page = vmemmap_get_tail(order, zone);
-
-			if (!page)
-				return NULL;
-			ptpfn = page_to_pfn(page);
-		}
-
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
 			if (!p)
 				return NULL;
 			ptpfn = PHYS_PFN(__pa(p));

>  			if (!p)
>  				return NULL;
>  			ptpfn = PHYS_PFN(__pa(p));
> @@ -217,7 +234,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>  		}
>  		entry = pfn_pte(ptpfn, PAGE_KERNEL);
>  		set_pte_at(&init_mm, addr, pte, entry);
> -	}
> +	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
> +		return NULL;
>  	return pte;
>  }
>  
> @@ -406,6 +424,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  	pmd_t *pmd;
>  
>  	for (addr = start; addr < end; addr = next) {
> +		unsigned long pfn = page_to_pfn((struct page *)addr);
> +		const struct mem_section *ms = __pfn_to_section(pfn);
> +
>  		next = pmd_addr_end(addr, end);
>  
>  		pgd = vmemmap_pgd_populate(addr, node);
> @@ -421,7 +442,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  			return -ENOMEM;
>  
>  		pmd = pmd_offset(pud, addr);
> -		if (pmd_none(pmdp_get(pmd))) {
> +		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
>  			void *p;
>  
>  			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
> @@ -439,8 +460,11 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  				 */
>  				return -ENOMEM;
>  			}
> -		} else if (vmemmap_check_pmd(pmd, node, addr, next))
> +		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
> +			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
> +				return -EOPNOTSUPP;
>  			continue;
> +		}
>  		if (vmemmap_populate_basepages(addr, next, node, altmap))
>  			return -ENOMEM;
>  	}
> @@ -620,6 +644,33 @@ void __init sparse_init_subsection_map(void)
>  		sparse_init_subsection_map_range(start, end - start);
>  }
>  
> +int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{

Can we do all code movements in separate patches?

Maybe even move this to the previous patch and update the changelog to
say "move code around in preparation ..."

-- 
Sincerely yours,
Mike.


