Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF030CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140488E0033; Mon, 10 Nov 2025 10:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F11F8E0003; Mon, 10 Nov 2025 10:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E228E0033; Mon, 10 Nov 2025 10:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5E9E8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:55:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85CF11DF49C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:55:34 +0000 (UTC)
X-FDA: 84095147388.22.13C62C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 042E3C0010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:55:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790133; a=rsa-sha256;
	cv=none;
	b=uWOqfRAOqSgR4ORVXNex+XhFhmYa0dawXZq75+MuUEBpLbWhRS/hXtDIkVB+L0IjRc17tU
	/OYhI2jTLT8etVrt3lNemPGwfsyZS2LegQ+c3iTN6v9mm8HvxNHamYvKDIGWFpyivi8iDC
	HjD0jvWJvM/jwexa/WoowG1JOGsohj0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RC3lGrqJPe/0O/QOdN48fZmETIJoBwsQwRZlNimQeZU=;
	b=z3+h3IZMjpBNAIcnT3l1b85IybaMOEAnZcLAp98wdMcmAzaKkCa2oVeLEkD0YYDJUd1E9g
	oGXO+jxDvl79VCHuQaxVVQINNWBVozq24Ms8W3+S5UdvnzicXQwgeZ0+19Q1l5AfGAr4G8
	0czWl4iAv/m6EBZMOX2eDClbjKS1Oyw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BE7E601E6;
	Mon, 10 Nov 2025 15:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DD4C19422;
	Mon, 10 Nov 2025 15:55:30 +0000 (UTC)
Date: Mon, 10 Nov 2025 15:55:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Cc: Jan Polensky <japo@linux.ibm.com>, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	will@kernel.org
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
Message-ID: <aRIK79pCWNZS1Yr1@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
 <aRIEkLw7BofLjOWs@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRIEkLw7BofLjOWs@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 042E3C0010
X-Stat-Signature: c33uywrjktiymyfqfyyg8hy6ouduppa6
X-HE-Tag: 1762790132-541700
X-HE-Meta: U2FsdGVkX18l3UisAfL0KR6OUAyW/4o5a0LCpW5no89TKYoQ7+oI89KpsNQbUAyqyi8zOqbzSeDoebN5wWZ8Lrgshty/IrfTpe87EvgeVI9AnCMfCCNkkuu5YlvZaVA/oK/E+HXZnnlm8Hb5dbwagyTyVFwPr6abr8rDbPCez1lclx9UIqck2BLTjP5HpNcTT9VBosqOd7hqdfzRKKc8UvE8JKezsP1N0Mt9aqowCNnhdryAUIUA/906Y6yWEb6Uxx0NqsvNiHrIhphZWMMoTgTAikSFoTnPXKmuyevNgnsGivHwmtRFj1593wnA7cIm1yUVn883OU30dATOXTBpbR4JxNy5gY4xy3iDBHKHd5gkMKfIQG1bePPSXe3+5wUrtQSGYmfqDwuk6MPrQ5X2XZPdGuv5X4nzDEO+YIGEBs0r9mp1DUxROWrMagXCmWLlQLO3Bp6ZcXGASXO5f4Z1p0jrufeQ+6trcJmGyv50u7oDpVwaN10b/8iI/sYfGghl54NwYM8lk1JjK22qrAFeLADKxJBH6XZCPLJIxEZHghk9nZWUYA2ahKniValjvHGjKSzJRR+wDTnp03xiiafSDH3ymRtCVYF42Lzbnq7RBMghGJvacOn0WPTBZiRNClT0N4G3ks53j0HL/R7IltpM/ImADbps+zXtQpBTrl+a1lpBc4Lu6mT0HpsrbfqptblrlW/zYTTaI7ozjvXbb0PGrc63UfVdsG8v2fczuZeiBuGTO4WBQk7hXbOmoOEo8Pd+PCQioUOhYBEu2H4U+SO472N+Z8nNkMYD2rRtEtth575NlRYfQpd4HltFje9vhSNGg5L6MzmHj4accqS0txGWGOY/d20ic8qaaXwdRtiQnXP9PfmD80yPclzL1yBIxtlnwC30QGXIhhIoItWa4qiNx5EZ5oTSfIGyOciAHEMLengGnzgukB5/qQusUJBXGClWxoNTRe3eQJ0pAOH5gu+
 4lUOgeGf
 q3B8aGZ65tYUqGEl8wFomzdb0Idu5KNarg2m+AhprRWGrjfoR29pw3guy6ITPCKj0Xxdc4JJ6EWa77S9kQYZc02IKPag5V4qx72NieYJMhlnfIVPUGNby61Xa2USX7oBvxZl9Db+zrozCQc03D1QyJVMddUWBAkIYheK+Sht1sP6v5WoJvnpTwctE7PTWKMMga6zmVan8F1ausya6pzJ+3eVZjjSZx4mhrWVN5wxZtK6Z6zub9ojUpFs0sMceIMXZ/IF3n5oO8rI1F4Ua1gGWOne6NrN1LxRnF+DL0pbaBrKjNrjYcgNZ8oxq+1FQP6z4kX185+pjp5jdb5qyx8Kd/Q9rhyCvmZlDq9rdYNHbOZCNr8idXTIkFqLUA/eIyJvIIjxu4y1UvwTU86M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 03:28:16PM +0000, Catalin Marinas wrote:
> On Mon, Nov 10, 2025 at 10:53:33AM +0100, David Hildenbrand (Red Hat) wrote:
> > On 10.11.25 10:48, Jan Polensky wrote:
> > > On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > On 09.11.25 01:36, Jan Polensky wrote:
> > > > > The previous change added __GFP_ZEROTAGS when allocating the huge zero
> > > > > folio to ensure tag initialization for arm64 with MTE enabled. However,
> > > > > on s390 this flag is unnecessary and triggers a regression
> > > > > (observed as a crash during repeated 'dnf makecache').
> [...]
> > > > I think the problem is that post_alloc_hook() does
> > > > 
> > > > if (zero_tags) {
> > > > 	/* Initialize both memory and memory tags. */
> > > > 	for (i = 0; i != 1 << order; ++i)
> > > > 		tag_clear_highpage(page + i);
> > > > 
> > > > 	/* Take note that memory was initialized by the loop above. */
> > > > 	init = false;
> > > > }
> > > > 
> > > > And tag_clear_highpage() is a NOP on other architectures.
[...]
> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> index 2312e6ee595f..dcff91533590 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -33,6 +33,7 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  						unsigned long vaddr);
>  #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
>  
> +bool arch_has_tag_clear_highpage(void);
>  void tag_clear_highpage(struct page *to);
>  #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>  
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 125dfa6c613b..318d091db843 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -967,18 +967,13 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  	return vma_alloc_folio(flags, 0, vma, vaddr);
>  }
>  
> +bool arch_has_tag_clear_highpage(void)
> +{
> +	return system_supports_mte();
> +}
> +
>  void tag_clear_highpage(struct page *page)
>  {
> -	/*
> -	 * Check if MTE is supported and fall back to clear_highpage().
> -	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
> -	 * post_alloc_hook() will invoke tag_clear_highpage().
> -	 */
> -	if (!system_supports_mte()) {
> -		clear_highpage(page);
> -		return;
> -	}
> -
>  	/* Newly allocated page, shouldn't have been tagged yet */
>  	WARN_ON_ONCE(!try_page_mte_tagging(page));
>  	mte_zero_clear_page_tags(page_address(page));
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 105cc4c00cc3..7aa56179ccef 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -251,6 +251,11 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>  
>  #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>  
> +static inline bool arch_has_tag_clear_highpage(void)
> +{
> +	return false;
> +}
> +
>  static inline void tag_clear_highpage(struct page *page)
>  {
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e4efda1158b2..5ab15431bc06 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1798,7 +1798,8 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  {
>  	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
>  			!should_skip_init(gfp_flags);
> -	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
> +	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS) &&
> +		arch_has_tag_clear_highpage();
>  	int i;
>  
>  	set_page_private(page, 0);
> --------------------8<--------------------------------
> 
> Reasoning: with MTE on arm64, you can't have kasan-tagged pages in the
> kernel which are also exposed to user because the tags are shared (same
> physical location). The 'zero_tags' initialisation in post_alloc_hook()
> makes sense for this behaviour. With virtual tagging (briefly announced
> in [1], full specs not public yet), both the user and the kernel can
> have their own tags - more like KASAN_SW_TAGS but without the compiler
> instrumentation. The kernel won't be able to zero the tags for the user
> since they are in virtual space. It can, however, continue to use Kasan
> tags even if the pages are mapped in user space. In this case, I'd
> rather use the kernel_init_pages() call further down in
> post_alloc_hook() than replicating it in tag_clear_highpage(). When we
> get to upstreaming virtual tagging (informally vMTE, sometime next
> year), I'd like to have a kernel image that supports both, so the
> decision on whether to call tag_clear_highpage() will need to be
> dynamic.

Actually, there's not much to kernel_init_pages() other than disabling
kasan temporarily since the unpoisoning already took place a few lines
up. The arm64 tag_clear_highpage() calling clear_highpage() directly is
fine before unpoisoning. So we can cope with this even in the vMTE case.

A simple patch hiding the enum is fine by me.

-- 
Catalin

