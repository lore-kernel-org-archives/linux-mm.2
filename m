Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D9ED74969
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E786B0088; Fri, 19 Dec 2025 04:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D386C6B0089; Fri, 19 Dec 2025 04:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CF36B008A; Fri, 19 Dec 2025 04:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA5BA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:34:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91D3213B12C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:34:23 +0000 (UTC)
X-FDA: 84235710006.13.1632457
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3036D1A0003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:34:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5KOwCn2;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0F9l6NzUeNsAvS87e9I4hfcnyZJltLYqs3zdZPRgRA=;
	b=5LXOQradz8xmkT81eIl7bc7fECplxzl4mMptd7pOxIIvSbGO5C07emlw9UdzJhGoLWdIQl
	l2k8hZV9uQOJoTlmGJQ14hHo0UXePZsKcENQ90AAkgFKAg4FFS+lOIJ2hHH4HKizuNxSZo
	UFfBLyUNf4YYyB6W6snMDqXkYZT0RRY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5KOwCn2;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766136862; a=rsa-sha256;
	cv=none;
	b=FbUKtNLLyiX/yMkuNFXkbGnIVhBOYdE1tKOXG1IzSeJn8bPDs+SR6eqaV3Mijh7DQh+YQQ
	9bAlVaVAISuqG8e/71zzsTpg/8qd7dyUFWaRIHMZE0yMHdl3TJ52YMUD9a5c0Gh7KLWI8u
	Cy4FvAiqJ0N04DBpCWXVf5iIVfPNKB8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F0286001D;
	Fri, 19 Dec 2025 09:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DF7C116D0;
	Fri, 19 Dec 2025 09:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766136861;
	bh=MHgQTaG61qGMuxEXN5cJbS8M2YCe8RD+w/6EJgGwGbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N5KOwCn2sZfy3p8ScNckzmQBAclcYoqauxSc2WaSf2YFdtM52i2C/pLr+yEycW8N2
	 l81ncubQWmQdQ1Lw0ElF9sFvwXHsQl+A0G/sXlckaAtYApqB6sKQhOx/JUf05x9uPx
	 o5ukTiv/1QzEPsAPdaA1mLmlZ5pl8s4/+Ua8I1hUZFDzQaFYei9FaS0esHDdE0/Nnr
	 uE2KxFSnzs1oRXaBl+RLO92fOMjkp8VXonqriNbEBJs6F5ux+UxRLGjqWGFRdXNspo
	 X+e+b+rmaT7tF5liS1RNgvsxqnHrRAjcf+fewNxVZgVMLWOgb0PIlIOnnhUIgvCFn/
	 xFIJ0SwyJnCbw==
Date: Fri, 19 Dec 2025 11:34:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] mm: Convert vmemmap_p?d_populate() to static
 functions
Message-ID: <aUUcE8esEjyKingC@kernel.org>
References: <20251218174749.45965-1-pilgrimtao@gmail.com>
 <20251218174749.45965-3-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218174749.45965-3-pilgrimtao@gmail.com>
X-Stat-Signature: ijze9wef9aw3npjbkcpe3owu9fbizi18
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3036D1A0003
X-HE-Tag: 1766136861-452553
X-HE-Meta: U2FsdGVkX1/0Ht/AbO6T+/W3SLu0FKBc6BB/NTLgQwdBTKso8aR9C52tWd8wODkNy1/OsMY8djcsMaLbwsKj7RHSQQcAsZ0hMdcrBojXhvK3+BFgM8eabozg0YNTm6elXfdhznV30xHdMC3X8QOtj7Za5a5olDgw4aV8CJN1RrcOh915La4/Ru1UgYu+4jq//hs9xYtG+SQkPaXPta/UIw9gYQP+F+gd0InPXqmM9r6qAICC+WNh8W7Skog4PeqJq80B6je9HsTkVPnpa/9L1RStE4Nh/d1R0tA6Tg+ukW0NTTPWQtOH/bWm4EPaQIuCSlbQWacuDuLlA/fry2YZvuGdUvDJz8m/Z7FUUEZ0gAW9VgEazNuKnwWFyJIcPsE1klFmkM/ziK8lFKsI2gUpDHq3SBISYkjYGUYm4awZJdqiGJCtouUtt+rPE1GJz2qa2wKnAVoNPK+/jpoxBxM+r3fUpfsukaPyCIQOVGbXKiySm8/cTr2P7RxOYcz2FX9o3rz0xKhHRB3ylG/ltVbBIYBL0WW9Jdvz04UWm6l/5UkUPfcngWv5Y9rqMomA/3DI0gLNaMx+RB9iQFvwFGieckhJaAKUcx8y7d4TeehvWaFevd7RVLpkjqfMXcD8uCRmjNRpQBIP5YMMryeIXWV5h30H0CxJvt4KCesEIvOz94+yWGtEKQemiqz4yNL5tUkXyeo2HC7V77c9A3TjEZ0ugYtlJowcsmbCirOgtNrB06vnQ6JKCZ0vd8NUEtpJoGVixBATN7tmzi77gq8f3jsx9uD4YeN5WcDym72WcqLHj6FLajrqapFJ9goF2zPpYzjAkM+aE56mrLzE+mN92IGjGZcHbYEfZTORcmKZ3c6XiipGEOwHrjQ1ntUfhcA8PZijDhtRy7M5aaD97YjcBP/s0wvoMjubChenbC9Ic1SVF/xxfBI8nqvcVmF9BiJyOx7H7C9AQJOy+zqIqVjDwvZ
 E9PIIfbz
 5OqNyB+r1kxDA5hAWaZKFn/qqVK3j1TJ5Tw1gc7QBlDnnS81OfYCSxOlXKVtRLly50YiXmFjfQFVTiYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 01:47:48AM +0800, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> Eliminate the external declarations of vmemmap_p?d_populate functions
> and convert them to static functions.

Please also mention that they are unused outside mm.
With that 

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---
>  include/linux/mm.h  |  7 -------
>  mm/sparse-vmemmap.c | 10 +++++-----
>  2 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..d98a38a6ac0e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4234,13 +4234,6 @@ unsigned long section_map_size(void);
>  struct page * __populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap);
> -pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> -p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
> -pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> -pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
> -pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -			    struct vmem_altmap *altmap, unsigned long ptpfn,
> -			    unsigned long flags);
>  void *vmemmap_alloc_block(unsigned long size, int node);
>  struct vmem_altmap;
>  void *vmemmap_alloc_block_buf(unsigned long size, int node,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 37522d6cb398..67f9a08c2376 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
>  			start, end - 1);
>  }
>  
> -pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> +static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>  				       struct vmem_altmap *altmap,
>  				       unsigned long ptpfn, unsigned long flags)
>  {
> @@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
>  	return p;
>  }
>  
> -pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
> +static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  {
>  	pmd_t *pmd = pmd_offset(pud, addr);
>  	if (pmd_none(*pmd)) {
> @@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  	return pmd;
>  }
>  
> -pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
> +static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  {
>  	pud_t *pud = pud_offset(p4d, addr);
>  	if (pud_none(*pud)) {
> @@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  	return pud;
>  }
>  
> -p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
> +static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  {
>  	p4d_t *p4d = p4d_offset(pgd, addr);
>  	if (p4d_none(*p4d)) {
> @@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  	return p4d;
>  }
>  
> -pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> +static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>  {
>  	pgd_t *pgd = pgd_offset_k(addr);
>  	if (pgd_none(*pgd)) {
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Sincerely yours,
Mike.

