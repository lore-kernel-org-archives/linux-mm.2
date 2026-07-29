Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2167AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62476B00D8; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3176B00DC; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF3D6B00DD; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 935996B00D9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDAB8A0661
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:32:37 +0000 (UTC)
X-FDA: 85041299154.16.A0C68B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CB35140008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:32:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agYaSvIW;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZ63+ClY6OcJWX9ysYXFzf2rcrSbVsiqouN4m3wIEQQ=;
	b=Gu3/kEZuuKE/MUiArblVTu3TLS10zIsU/lBVPN8/2IkDrNZ56Ojh5Tz7Q/v3QsZW6Gm+hp
	inYWQIMm8V/QYH5bJ0G+z8xT2EuAUOdu5lehutB2ix489A20ywGMuNyDTktQzeECBjLsdd
	PK+YqyDvJEg1Zj+6k9E0KJeOYIjaACk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785317556;
	b=Gfgp6lRFgLjonTYi2UbeW5h0saA0vNvE0MHewAGGSg+iX4I311fWFHS30LZ8stvRYIqONS
	adPnDcWeGSd8tbUir/Zh5DMHen00M21JTZVx8XWfDKBcb7mn8mawo6AIsXPVUKgRJwHnNA
	UmO+vy6JdO0NKlgNg6T3Vs/mpLCcLiE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agYaSvIW;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D6C3600B1;
	Wed, 29 Jul 2026 09:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE951F000E9;
	Wed, 29 Jul 2026 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785317555;
	bh=OZ63+ClY6OcJWX9ysYXFzf2rcrSbVsiqouN4m3wIEQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=agYaSvIWAVylVBpeUol1lRZvfzrti5o8WbDuWlKrrwbYdr0dwifXMsGrmIlyHePPP
	 YyUYx7bvkZkm3NTlCUatW5WC8//OOLmb1h4P0nJAivd0tC01YefT5+jBuSmxUBbIqx
	 lZCAaSWFrJ0fDvQkeGy2oejHCSYrIfEcv0GdeWWvoahKvvdNSjO6ZPsRa/dzfDWMOU
	 R4sKlrkEC1w/6ufKoK+qGN9pNIfWgnXU58YOp+kjC4eKv+SyXrav4Yupo1+/PZbdeE
	 VCMOd+o3/AAkdy7vS8nsd9eHZR4xSq5YCOvLBnDvReNoEPVVnTWTUi+ghyJAG0Ew3f
	 0tqmc4P7eAPSA==
Date: Wed, 29 Jul 2026 10:32:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: cl@gentwo.org, dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com, david@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/16] vmalloc: pass in pgd pointer for
 vmap{__vunmap}_range_noflush()
Message-ID: <amnIBsFnkt5Q2UUw@lucifer>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <20260715180455.515692-5-yang@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715180455.515692-5-yang@os.amperecomputing.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CB35140008
X-Stat-Signature: axhmej7omxjqf4q4pexiu3oj3p3ww6ap
X-Rspam-User: 
X-HE-Tag: 1785317556-143696
X-HE-Meta: U2FsdGVkX18orPe1AvJsI3bEJs08YGKSc7i5p+wkaoKDqouMyLkImymCA/bjo/bW9SPn3sfOko1a9LOpvb4Q6M0bVS6bxOfchQUv+hoVJPKw/n+rmRaVFRXW9BIbIO6Vo630zWkig7toFgpj6o3s0USEUNcbmV9/KlcDS5XTzPlgBdt+EIk1m1UrtDbN8ZezAiIEbKTkj0+HQWiMW1mNXQEpDcMAw1tSW7qwFIsJjw/tTMlCb6/hrCAVszvahMCUX6aMkQBz4ACFCAD2ixebJm44dIEy1REHdulQHPKNzLgQnOsuCAQcNcACo0sYXOG602EjcuQ/a1jqoC9m4pnBHt8JVhQf5B3tLatLR0JY3JRjtRDeIjLQ5sDDq1u877e67IzINZYr/lz5Ta2VG7SEcIbV7hk6WvK9Hszxugk7H/WkIjakYVpZ1T1FQDooAxcAa4buToWTnzsdNjSfycCknLs0Xa7pTyz84H8UmshNJEJs9AvKJ23qLt1uFZXLE9WzccEOAaxtx18yIrjniQUcSEMBncEejGIbgMk6DDIwHUGjP7CCHOzPAGjSd5fgaA2oFVeu3jarRURruatGVj+XmjHC06evwKtCnr0u4PAuO1OYdUXZi4uvQz3TO1RYIUAdXn39dG8CNXYV+JQonpbjVXOUxehFUEKgmbMD7MUeNwWmATJHuby6MG8cXSBaz6iJzqUcyCaqXaRRza+F5AcIOA6h0O7aqlrHeenhYO1RjkRfQL0zigQfsUMujiog8W8JE+erjvGJ1Wp3UkV2nwA2gaQ8i6Ur75YDDmwqkLt4Y9+wOOPTC5Os4GNty9lo2ZIZVnBohNF4ll+I894vFnoigz3FKVXtlUOF/qnVKEqis7GRk4voe0kpiCSWSzT8fskXhx3wqXTlPv4Y0T1rAYhXRC1LiqgNlmVdS5Nszv7j737+vqnawizNRLauSJ4kLfg3AHiHHo0voKCp0wPQa9J
 uramKTR2
 3aWNTkk896Eovc7BO6g6SUbY9/Rm41J6m9n50GC4rhgxMfZTB5954kONfIaZ4oHiK8WV8QcYH/NwhZbJE38IvKmqjLk/GAa/gJO7C4s7G+FgvJw0BY1leTIJbpiqG7YUZ4GmqNsSN/fhpoqWjgPX0Cc6uLG/1LL1ao2V7OWTVk+ppU6xH3BvavwBye8F8+sZpBOsf3+Bq9BeftuWzbP1IR01GMs+ZANa4RzNNHruXwyjtGwrdgGuYuJ3DJ356wFp5O9rgssA0Kztgr3ScoijaviQeMVLSOi20Ii6o9e3nRCjEjKYrdcwBDNEDastTptfCjI1zKCdyDJa5hV99Yw+IWtWFnYxGy+ovBllFejsn641VAto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 11:04:06AM -0700, Yang Shi wrote:
> vmap{__vunmap}_range_noflush() assume manipulate init_mm pgd.  The

It's not an assumption, it's a requirement.

There is now (and really should have always been) strictly a locking requirement
that the mm being manipulated is init_mm.

> following patch will map percpu local mapping into percpu page table by
> calling them, so the assumption will no longer stand.  Make them take
> pgd pointer as an parameter.

No, this isn't OK.

vmalloc is expressly for manipulating kernel mappings in init_mm.

>
> Also make vmap_range_noflush() non static, it will be called outside
> vmalloc in the following patch.

Hmm not loving the exposure of an internal function ehre.

>
> There is no functional change.
>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>

You're fundamentally changing something here, conceptually. I'm not sure why you
specifically need vmalloc to do it but it doesn't strike me as worthwhile for
what you're doing.

> ---
>  mm/internal.h    |  5 ++++-
>  mm/kmsan/hooks.c | 14 +++++++-------
>  mm/vmalloc.c     | 25 +++++++++++++------------
>  3 files changed, 24 insertions(+), 20 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..9d9f08cb26a1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1552,10 +1552,13 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
>  int __must_check __vmap_pages_range_noflush(unsigned long addr,
>  			       unsigned long end, pgprot_t prot,
>  			       struct page **pages, unsigned int page_shift);
> +int __must_check vmap_range_noflush(pgd_t *pgdir, unsigned long addr,
> +			unsigned long end, phys_addr_t phys_addr,
> +			pgprot_t prot, unsigned int max_page_shift);
>
>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>
> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
> +void __vunmap_range_noflush(pgd_t *pgdir, unsigned long start, unsigned long end);
>
>  static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
>  {
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index 8f22d1f22981..e2a0faf344b9 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -135,8 +135,8 @@ static unsigned long vmalloc_origin(unsigned long addr)
>
>  void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
> -	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
> -	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
> +	__vunmap_range_noflush(init_mm.pgd, vmalloc_shadow(start), vmalloc_shadow(end));
> +	__vunmap_range_noflush(init_mm.pgd, vmalloc_origin(start), vmalloc_origin(end));
>  	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>  	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>  }
> @@ -181,7 +181,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>  			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
>  			PAGE_SHIFT);
>  		if (mapped) {
> -			__vunmap_range_noflush(
> +			__vunmap_range_noflush(init_mm.pgd,
>  				vmalloc_shadow(start + off),
>  				vmalloc_shadow(start + off + PAGE_SIZE));
>  			err = mapped;
> @@ -203,10 +203,10 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>  			__free_pages(shadow, 1);
>  		if (origin)
>  			__free_pages(origin, 1);
> -		__vunmap_range_noflush(
> +		__vunmap_range_noflush(init_mm.pgd,
>  			vmalloc_shadow(start),
>  			vmalloc_shadow(start + clean * PAGE_SIZE));
> -		__vunmap_range_noflush(
> +		__vunmap_range_noflush(init_mm.pgd,
>  			vmalloc_origin(start),
>  			vmalloc_origin(start + clean * PAGE_SIZE));
>  	}
> @@ -233,8 +233,8 @@ void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
>  	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
>  		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
>  		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
> -		__vunmap_range_noflush(v_shadow, vmalloc_shadow(end));
> -		__vunmap_range_noflush(v_origin, vmalloc_origin(end));
> +		__vunmap_range_noflush(init_mm.pgd, v_shadow, vmalloc_shadow(end));
> +		__vunmap_range_noflush(init_mm.pgd, v_origin, vmalloc_origin(end));
>  		if (shadow)
>  			__free_pages(shadow, 1);
>  		if (origin)
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1afca3568b9b..17c26e9796b2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -295,9 +295,9 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  	return err;
>  }
>
> -static int vmap_range_noflush(unsigned long addr, unsigned long end,
> -			phys_addr_t phys_addr, pgprot_t prot,
> -			unsigned int max_page_shift)
> +int vmap_range_noflush(pgd_t *pgdir, unsigned long addr, unsigned long end,
> +		       phys_addr_t phys_addr, pgprot_t prot,
> +		       unsigned int max_page_shift)
>  {
>  	pgd_t *pgd;
>  	unsigned long start;
> @@ -314,7 +314,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	BUG_ON(addr >= end);
>
>  	start = addr;
> -	pgd = pgd_offset_k(addr);
> +	pgd = pgd_offset_pgd(pgdir, addr);
>  	do {
>  		next = pgd_addr_end(addr, end);
>  		err = vmap_p4d_range(pgd, addr, next, phys_addr, prot,
> @@ -334,8 +334,8 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  {
>  	int err;
>
> -	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> -				 ioremap_max_page_shift);
> +	err = vmap_range_noflush(init_mm.pgd, addr, end, phys_addr,
> +				 pgprot_nx(prot), ioremap_max_page_shift);
>  	flush_cache_vmap(addr, end);
>  	if (!err)
>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> @@ -478,7 +478,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>   *
>   * This is an internal function only. Do not use outside mm/.
>   */
> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
> +void __vunmap_range_noflush(pgd_t *pgdir, unsigned long start, unsigned long end)
>  {
>  	unsigned long next;
>  	pgd_t *pgd;
> @@ -486,7 +486,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>  	pgtbl_mod_mask mask = 0;
>
>  	BUG_ON(addr >= end);
> -	pgd = pgd_offset_k(addr);
> +	pgd = pgd_offset_pgd(pgdir, addr);
>  	do {
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_bad(*pgd))
> @@ -503,7 +503,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>  void vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
>  	kmsan_vunmap_range_noflush(start, end);
> -	__vunmap_range_noflush(start, end);
> +	__vunmap_range_noflush(init_mm.pgd, start, end);
>  }
>
>  /**
> @@ -670,9 +670,10 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>  		int err;
>
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> -					page_to_phys(pages[i]), prot,
> -					page_shift);
> +		err = vmap_range_noflush(init_mm.pgd, addr,
> +					 addr + (1UL << page_shift),
> +					 page_to_phys(pages[i]), prot,
> +					 page_shift);
>  		if (err)
>  			return err;
>
> --
> 2.47.0
>
>
>

Cheers, Lorenzo

