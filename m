Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607E5606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VZKwDank
Received: by kanga.kvack.org (Postfix)
	id 79BED6B05B2; Fri, 13 Nov 2026 13:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7729B6B05B3; Fri, 13 Nov 2026 13:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1DD6B05B6; Fri, 13 Nov 2026 13:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 444F66B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:53:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE495402B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:53:18 +0000 (UTC)
X-FDA: 85430993676.21.D153E98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 220801C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:53:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZKwDank;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DABqvPmRZQ9oUhOgSWnNOl71UnHng1Nk40a2Wv2ZOk=;
	b=p+AE1E1QtlBiA42R/utx9IgTB4KXinhCytivf9Kvap9AWpIapeNOsPHiLSNRfvJaAuoc5P
	vnuLCNO68MTneaQDfJSYXSl0d6HSViDozQjWmXR9p+2LT5cglcJ5GuUjegyZ4oEz+E5ZAs
	zpIVZcofBQZnTZZSVQzbzNsbmkIxqa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595997;
	b=ucos9v2dhWNjhWqPrkIiWrVp0m2jxL4h++WlbikK1omqJ+8kgJbILd+vi4flLd8/q+JDcx
	ylCv+RGer9xSVFcEdtIebvJhW0zSawNgIBo7uZS/aLOxrfiuz6Txh2PmDdnI3LpMNJffMl
	iIvoe5BZJ0C+frODn7LWHaT2QjsS2po=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZKwDank;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4674140822;
	Fri, 13 Nov 2026 18:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62B11F000C4;
	Fri, 13 Nov 2026 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595996;
	bh=6DABqvPmRZQ9oUhOgSWnNOl71UnHng1Nk40a2Wv2ZOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VZKwDankvfuzex2kRsuuyuqHtFOBDmCaX+0WDxsKL/ouO87kgLIB3xb7y6yOm/l4j
	 S2Hzsy3SFJbSAfPNpN5/WCPjXE7lb2e5myi9k1xiqxrHzc763+i64zEJqAuEDsEm7w
	 uMkCEgAbD+8ekgjG4FklqyNU/1b5rvooVJAA1POv4y6HUtbiYHEgQgYDgPoAc+m9Hh
	 ToYoOlC742wO+lulBmOy7vDZnkmacJKxLOREhis/Tt2axILXyzJPa3zG9ixS/CXFAV
	 XBAzB3tDKbseqSfaR/otntCp+rYZDrvbMx/fIiAxtDqSI8W93FtHmyJCo6VYd9sBQy
	 zC+gw78C8+jvw==
Date: Fri, 13 Nov 2026 18:53:09 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Matthew Wilcox <willy@infradead.org>, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 4/6] mm: drop HIGHPTE support altogether
Message-ID: <avdciuic3FAy6evm@gremlin>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-5-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-5-arnd@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: qire7hxj9rbe9axmysxzau1wwmcjircg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 220801C000A
X-Rspam-User: 
X-HE-Tag: 1794595997-179341
X-HE-Meta: U2FsdGVkX1/PU/HLKJlm9AHx8lF00BXyfSdTGSncLDezepnj/Fh9A5yQy+XSDFcqf7ktFteyLMUQn+ot+sWRFdC/VyQH46RYzswv5po92a4wTmNhc+zo8ujNPJI9sBZ03gf4QsD2rKj8EGeWC8gvvTuzdggIrDVvTOxJP57VYB4JmJhGZbqkbOavimGuRHKXOsP5LFiBGgfsN0HJGbhTBQzAJujaqsD7VjNjG1KODv4L6D+nZIBk4y7D8iGmdnj4p28w3X2+yDXKVw9LtZT7ew9tfIjMT51xp1pU0oKcIP0VpVMT7AiyGJ11y4HstKfl67eqLPBGkCL9uYKxyXAuD/F378R4DOrKkzhe4pyFrom2yW9skIJdCp6283Dg9rF8NagpjvW3VzXxSnpAKTRwqNhB9wgm1nT8+LDnJDsiAozoa89svjHZn4VhyomhEDJQx83Y6a1RMomCM8OnqAKZF0EOSLqFj1k7oxQ/Iq5U+hje/y522rMndkHJErhZeGCFmmYov7YKlqwRt3TLynSbZIlNo6GB62OO9Amc88C8XjyfD22e0tvla5J+B5KdW2tCciMuInDrPZOLkQwUpaZSig/eJLjb8HS881RcgJXjAW4Pk+uboH14OlFYtuLKv6phmjINzGjrhp9fO3gCueQLIE6ulr/WNaKrzrAg/L+EE2llkSJthkVGTc7qhsuVpZXbevCgxAjN2BvOYqBQ96mt+JPEW9oNk1BOt4HLeI3/x3huyatdvOEUOabybSBEPCKd1ry7/Un63+N0BZuwQUud+9Egff6diEzix+InuovP092O35FBI8KhcZ7o3LL/mm1blmGh1aBFExNWfzNR9Qhp1D0qMUf7F+UW2zq7fNJ6hsPRjzth95Jo1OfmjSYmLyn1xOy0DR7P/0BLtVW8ZZqG43Js4Vju2YseTGYK7qO7TrlOnepY66yyinrUS0SRig6fnJcilszxWQcFYE2ecP8
 qGEuOfA6
 m/I9Vxf42FJQPx0mU5sSIxsC6O1NuDTDBT821whRXFdpGbtIvNi/YyKChzPK/oMlksam+QHVzpfO7RZRZuCYb9hxn0GmtfqddYG2nTY6LNfuiR8Lagipv+FV1/VrHlIQIXiOS8cYdrQs/CBvayD6AD+sGsdN1vUB6gRkHMuLzPf/IHX+i7c4NeZxw7EriidYUnNtVYIslPyOsqrgTbEhaSVLDn45f9+tA2rgH1DO6vEJz0dm3fMIG1f5TpTLvIsU6fOQREKaT9HDWkRzYMsPY6HwR4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:26PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> With both x86 and arm having dropped CONFIG_HIGHPTE support, no
> architecture is left using it, so remove the remnants in common code.
>
> It is likely that further cleanups are possible in the page table
> code but those are not obvious from the config options.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

LGTM assuming Mike's changes :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/hugetlb.h | 5 +----
>  include/linux/mm.h      | 1 -
>  include/linux/pgtable.h | 9 ---------
>  3 files changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 58f755e70e96..7c6d191fdf50 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -178,7 +178,6 @@ void hugetlb_bootmem_set_nodes(void);
>
>  /* arch callbacks */
>
> -#ifndef CONFIG_HIGHPTE
>  /*
>   * pte_offset_huge() and pte_alloc_huge() are helpers for those architectures
>   * which may go down to the lowest PTE level in their huge_pte_offset() and
> @@ -193,7 +192,6 @@ static inline pte_t *pte_alloc_huge(struct mm_struct *mm, pmd_t *pmd,
>  {
>  	return pte_alloc(mm, pmd) ? NULL : pte_offset_huge(pmd, address);
>  }
> -#endif
>
>  pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
>  			unsigned long addr, unsigned long sz);
> @@ -1047,9 +1045,8 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
>  	 */
>  	if (size >= PUD_SIZE)
>  		return pud_lockptr(mm, (pud_t *) pte);
> -	else if (size >= PMD_SIZE || IS_ENABLED(CONFIG_HIGHPTE))
> +	else if (size >= PMD_SIZE)
>  		return pmd_lockptr(mm, (pmd_t *) pte);
> -	/* pte_alloc_huge() only applies with !CONFIG_HIGHPTE */
>  	return ptep_lockptr(mm, pte);
>  }
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6af3b7008f1a..019de55bd796 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4025,7 +4025,6 @@ static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
>
>  static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
>  {
> -	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHPTE));
>  	BUILD_BUG_ON(MAX_PTRS_PER_PTE * sizeof(pte_t) > PAGE_SIZE);
>  	return ptlock_ptr(virt_to_ptdesc(pte));
>  }
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b..1352b4cee7ae 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -100,14 +100,6 @@ static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
>  #define pte_offset_kernel pte_offset_kernel
>  #endif
>
> -#ifdef CONFIG_HIGHPTE
> -#define __pte_map(pmd, address) \
> -	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
> -#define pte_unmap(pte)	do {	\
> -	kunmap_local((pte));	\
> -	rcu_read_unlock();	\
> -} while (0)
> -#else
>  static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
>  {
>  	return pte_offset_kernel(pmd, address);
> @@ -116,7 +108,6 @@ static inline void pte_unmap(pte_t *pte)
>  {
>  	rcu_read_unlock();
>  }
> -#endif
>
>  void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

