Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B4CCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6206B00AF; Wed,  3 Jun 2026 14:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96496B00B0; Wed,  3 Jun 2026 14:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E506B00B1; Wed,  3 Jun 2026 14:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A209E6B00B0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:03:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38C1D8EEF5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:03:17 +0000 (UTC)
X-FDA: 84839373234.12.04EE6AE
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5088D20015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:03:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DRZje96D;
	spf=pass (imf03.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780509795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrbiXUlsk45eySsbtONrBewq/djyZBhyYFXfnKgyx7M=;
	b=EnHU9bqRwT5OtQSevzVj/dcA9d3+W5F0jv31u/yIqLs6lj3v0efJCGcBecRlxiANheAv14
	LPnmZPD+XdjRFEGh5jmMw/1Wv/CpjqB1ILd86+zDsVLc8/+vj1gwob28PadTz5zYHTQ3UJ
	9NScWsEu6xTc1HIdXLoCuf4UIdPKVuk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DRZje96D;
	spf=pass (imf03.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780509795;
	b=coP2QtGSlcoQZcrzhEYn8irLACAa/2W+b2hLULJsS+387Cy5JyLChvFKhz/v0qlNIcTv6b
	2uYQRK3vCfMip3BXhzKOWF2Ug3YpbM13PtkekhJz04vMeinyfHV/QjJFHywCsVyRhF61i3
	v/ieg1Cs09wYws8n+zED5Ealpwu+8mM=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36da8439078so3462931a91.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780509794; x=1781114594; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrbiXUlsk45eySsbtONrBewq/djyZBhyYFXfnKgyx7M=;
        b=DRZje96D8m87kJTbK5YGNIZEdNGT9lWO/DthY5l1xkWdM3yik7Co+d8824LGhWHVY8
         Sd9Od7xJ23rhrgVQxgq6vpA5VTRN2/SYLVGHy6f1zZJsxN1uvBC758yZwpbEg+nn3kvC
         2NUlO3JE+ToR5xC/uCcrG7II/5E0Rn5JbIujlIpZRwGZKhKJDXJQzjuz1h/O8kHNA/rF
         JB9xeyZTaxWLSUnv/sSGUuzgoPQfZFUIqm1/VMb0pPeVPIXYO6k2w9PF4wDSErABHBge
         H/OT9p5kq8hDK+LIsK4n35BEzYmtPm6qiMDzTzSazEWg3uHQtOu8mnCHKeNZAPlLOXwO
         Hi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780509794; x=1781114594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrbiXUlsk45eySsbtONrBewq/djyZBhyYFXfnKgyx7M=;
        b=fQzQsKzCrdG18HQZIi+QSHLGfJeklxEmtn0UII124gurh4sEyNn7sAaYn3mHSzQQXQ
         NjFir3qmSUPNJWRdMYYAV22reo/VdzTl/kcXVWIGHqFObArskpVNF70rBhQOdDS/o2a7
         ZdvHJlqgJMNQZhUPNdoVNrvhSGOvL2JXEkwBz0nsByBQZW7xXN/BOEb5G06JiiWfNo8x
         OKeKI1sjwOQh3WJTCb5sU3y9/FlPrnWOR65hEjOlcz9bhwC7gb5xKn7gnvETEjxGQ/li
         /k9O0yXStG9kH7efq4EfL9RTpKj/Okgk4YuQh/VGdFDdaqnCZPkhK9Dkx8ruqlAwde6D
         0a9g==
X-Forwarded-Encrypted: i=1; AFNElJ8TBQJtbSOFch18uPPr1ikVPe2lnmh5wei7v5LLI/X62a3z4hC1seXvlbeDx2lRQwPF3VuZMnlosA==@kvack.org
X-Gm-Message-State: AOJu0YyM/wuy6KtFBtdC5bq66ex4H9XRIp3MGO7TBKX+EIwZKSlp9F54
	QZkagyyG7Eip1i7Z4a8NXcV7wjsQkyc0bhvB+TQpEXVjMYqICIyXfPZC
X-Gm-Gg: Acq92OHrW85z68WYKkk4v0zr2lR2S/A0fgbzsea0ZTDOwQ2wj0F4BAZ0nSYm83hsvdK
	bZOWJ1pbEx+ya5F3tLpKTGCNvHQuUyPLA1kIXrNB3UbzYbMTY7BYENXYcb62UiQP/gRWhj4junx
	5u70IcemFneSMQNa+aaOJ9JMn6ri7ec0t1a+TkRUFBGuwzC7/3QBdTi843S2DA9FzuEtBKGIj9P
	IsSP6dEVIFxG++WDRpEkSoHrXWcZnpxfT+5VnWGjfNTyCs90NB5yA9UNPDF+NhSCP4OHfECwagz
	X+5j2Yl4yi+ETCyVyGGF9LFZ8PaZ7tn+u+ZErWzvqQw0zh1ulf4KO0VClXVkTTWQOZJAP+he3dq
	iBf31mDao25UF9DO0aKzcmAVKZlZDFOtsy1/3xrGA9Z3y6XI/C50jmPjXslQ1f2+DVJPlToHtJl
	wFS/h4CjjgBpd2JYE2rdIe+FtkIpa+5h4oeKVdxcCZOtt3iQOaVK67NFfPCrjnVfo81nw2X0wIA
	vybUobLQg==
X-Received: by 2002:a17:90b:3f90:b0:367:db13:aca6 with SMTP id 98e67ed59e1d1-36e319bff94mr4221552a91.26.1780509794151;
        Wed, 03 Jun 2026 11:03:14 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([106.51.160.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6d1fec5asm331867a91.10.2026.06.03.11.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 11:03:13 -0700 (PDT)
Date: Wed, 3 Jun 2026 23:33:03 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: Re: [PATCH v7 11/15] powerpc/code-patching: Avoid r/w mapping of the
 zero page
Message-ID: <aiBsMg9WdDy-dRk_@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-28-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529150150.1670604-28-ardb+git@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5088D20015
X-Stat-Signature: jp4gjpi45xbgsynk9nrm3pxjyccodn5k
X-Rspam-User: 
X-HE-Tag: 1780509795-494449
X-HE-Meta: U2FsdGVkX19RtzBh+4fuwpQj98rDYQw3TAzmEL8ng1BRJpCLK3A7V1YDcvJsPa6xQ5mJbt0WaIZAevLCB2VhZ3F19A++MJtKITyjlMvnBnIDtZKSUsOY0ACN0ARB+4ZjNumwDMXs002+xA0x/hwWcYVcMWPicqyBF2nONreAcMbANMoN1l6cU1zZS77EQQKXPv6UyWFbhd+D7cl7ZNL65T63CNd/okzMlYZanOJ/1ztAvx8th0fhIWb+tCK55OXHLsy/1agY6FKtODIpzA8S5pAXSJsv6CK/Nfn0DGXL1Md2oid0KEKKhc+uopo2dj4rKdkEa3Iv5ayF5oBxVDBlFns4h09zuJo7iitJunMIdpj6CaCs1kKJ3ImtJdJWWISMjM2LstyKLZUUd9wgh99rnT4pEeP5ughnwwpOwykY+rMyn58p8uQmAV4fa0xiNumUyTP8iMWsT5eh4c43R7AewQRmNQgZthGXjoRNcCYhn8ECeXgJOK/2vXxuZV4ws+cyjkEP7M57O1X54iuSKryqhUOtCsG44qKL7d2zaS5s9lxRcg+us7MxscIKh5Ix3ZLt2vw+h3+EXD3kBDhi7d1roM00ikICi1/dKSHF0pPIISp2y+haUnpJwHOudq0xytDIY02t7wGTwtuh8PcRS8gSbo+LRJZ75RsV/ywGia+yJoVOEJpFLFtP3GfE5xsy6R5nxURwwLb6tL3/YdNFGuGAJddYI3ncFS7Jj7UjSwAeiOtOpMk4X3sl+HnqENKmKZsVGIrKJWdqoPpoo4t6azoskKl1LMD9lvqFKuC/WMQKAM8r6i5Nbuw2t92Xy2Tq6SsOFLAZHkMY1f0RL6YUqz9A/WqhJQY7K/eRjvj9uob2TSTLYCn/v55OlA9r2noCs/xEa32EyOhoVIn4KNAT45tzqqhRviy79hczE5acRsAiUL9WxniMh+rBTrwOfUDd6M4zBh2VNfoLejMWoL7YmBR
 vHwMzMEh
 ibZrqxRaTrZgvE53tPKx/g4yQWdYltgepbmj5w5u/yOQrT7Obc5zqlhPfEs+/3YiBf3ufQGsV/c1ELACxi2mpH1hLthtKcR/uXzG021KwbPPGWXHh/CAuSMLFHioTLt504GUu9yDCqVVo80TByGd7n6b0QPIRp6LWcty4dkzqGK+ocmrRvQwCWxuNIqitICNnQq960OR7gUaRUif7rkXVCMi2mtZCVtfYxXc0LBqsTJzQZa9vYNpvNr7SeTiqi+v8ikf8vyQnDHu06UVU0yqB15nTx0PwjBrmUQERZydjgnbFW1m5c+QC/rCZCXrAdGfRYS494ydImfHpJkxhRLs6CN8IvbgfVJZlLpY2pl0wE7iS1T1ET254BQ6KwbBsGwp7Pw/wxtY12TNtWIrCdnKVMy3+xuDfYHt0Ct0vQOyHx/6WfuNCZ+kgWRA2POE2wzP8q+sREbnCeMUslZsT9MNDBeTAj6Zq6P91a8joqmPPZO0bhqREOGBlGJpTrTtIylxFG81aG/940r7LK7drky6+XXiydS1Rks+LBNF3XEO85k9p9a0tRmfeb+OMz/B1TPcyIqnJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 05:02:02PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The only remaining use of map_patch_area() is mapping the zero page, and
> immediately unmapping it again so that the intermediate page table
> levels are all guaranteed to be populated.
> 
> The use of the zero page here is completely arbitrary, and not harmful
> per se, but currently, it creates a writable mapping, and does so in a
> manner that requires that the empty_zero_page[] symbol is not
> const-qualified.
> 
> Given that this is about to change, and that map_patch_area() now never
> maps anything other than the zero page, let's simplify the code and
> - remove the helpers and call [un]map_kernel_page() directly
> - take the PA of empty_zero_page directly
> - create a read-only temporary mapping.
> 
> This allows empty_zero_page[] to be repainted as const u8[] in a
> subsequent patch, without making substantial changes to this code
> patching logic.
> 
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Link: https://lore.kernel.org/all/20260520085423.485402-1-ardb@kernel.org/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/powerpc/lib/code-patching.c | 52 +-------------------
>  1 file changed, 2 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index f84e0337cc02..44ff9f684bef 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -60,9 +60,6 @@ struct patch_context {
>  
>  static DEFINE_PER_CPU(struct patch_context, cpu_patching_context);
>  
> -static int map_patch_area(void *addr, unsigned long text_poke_addr);
> -static void unmap_patch_area(unsigned long addr);
> -
>  static bool mm_patch_enabled(void)
>  {
>  	return IS_ENABLED(CONFIG_SMP) && radix_enabled();
> @@ -117,11 +114,11 @@ static int text_area_cpu_up(unsigned int cpu)
>  
>  	// Map/unmap the area to ensure all page tables are pre-allocated
>  	addr = (unsigned long)area->addr;
> -	err = map_patch_area(empty_zero_page, addr);
> +	err = map_kernel_page(addr, __pa_symbol(empty_zero_page), PAGE_KERNEL_RO);
>  	if (err)
>  		return err;
>  
> -	unmap_patch_area(addr);
> +	unmap_kernel_page(addr);
>  
>  	this_cpu_write(cpu_patching_context.area, area);
>  	this_cpu_write(cpu_patching_context.addr, addr);
> @@ -233,51 +230,6 @@ static unsigned long get_patch_pfn(void *addr)
>  		return __pa_symbol(addr) >> PAGE_SHIFT;
>  }
>  
> -/*
> - * This can be called for kernel text or a module.
> - */
> -static int map_patch_area(void *addr, unsigned long text_poke_addr)
> -{
> -	unsigned long pfn = get_patch_pfn(addr);
> -
> -	return map_kernel_page(text_poke_addr, (pfn << PAGE_SHIFT), PAGE_KERNEL);
> -}
> -
> -static void unmap_patch_area(unsigned long addr)
> -{
> -	pte_t *ptep;
> -	pmd_t *pmdp;
> -	pud_t *pudp;
> -	p4d_t *p4dp;
> -	pgd_t *pgdp;
> -
> -	pgdp = pgd_offset_k(addr);
> -	if (WARN_ON(pgd_none(*pgdp)))
> -		return;
> -
> -	p4dp = p4d_offset(pgdp, addr);
> -	if (WARN_ON(p4d_none(*p4dp)))
> -		return;
> -
> -	pudp = pud_offset(p4dp, addr);
> -	if (WARN_ON(pud_none(*pudp)))
> -		return;
> -
> -	pmdp = pmd_offset(pudp, addr);
> -	if (WARN_ON(pmd_none(*pmdp)))
> -		return;
> -
> -	ptep = pte_offset_kernel(pmdp, addr);
> -	if (WARN_ON(pte_none(*ptep)))
> -		return;
> -
> -	/*
> -	 * In hash, pte_clear flushes the tlb, in radix, we have to
> -	 */
> -	pte_clear(&init_mm, addr, ptep);
> -	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> -}
> -
>  static int __do_patch_mem_mm(void *addr, unsigned long val, bool is_dword)
>  {
>  	int err;
> -- 
> 2.54.0.823.g6e5bcc1fc9-goog
> 
I don't see any functional change.

Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

