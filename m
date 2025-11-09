Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEB2CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 07:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021958E0013; Sun,  9 Nov 2025 02:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14B08E0003; Sun,  9 Nov 2025 02:44:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB888E0013; Sun,  9 Nov 2025 02:44:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA1958E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:44:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93D514C203
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:44:50 +0000 (UTC)
X-FDA: 84090281940.02.A5682F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EAE2840005
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:44:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEaGkOX+;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762674289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udvzOrraQgowhCoArG7WHsaCJlrFQxUUjzXVeqvlkaE=;
	b=wHuJJRofHn6f95GD68dO5wwus9n8oamLtD7moPhUqvGVb9Njl34QGb91t/8qgQKvaHZbRZ
	P7Jm2NnaGJvIH500MYjd7NxGiAAsm17s5xt7NJsfRJhxcZFhPtIktRUef2QrKOuiCn14c7
	IcPx4ikFWKkms1B1eYTuLU819K5gIBY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEaGkOX+;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762674289; a=rsa-sha256;
	cv=none;
	b=EyD2bM76T9hZLAVsHiVkYnC2LLkCMeHGLlibPIQjZnjqdP3NRInxQiFRjzM8M6RSsuTrLR
	osCvugG+oBREsNLP8gPBKKpWfbax0VieMLskvgPvUx7vakQKdwEBdbhP+wokMlnwEnammK
	YKKvWnlfpu0Lz/Cy05TDcXW+QHgXih8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFC41438A0;
	Sun,  9 Nov 2025 07:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AA7C4CEF7;
	Sun,  9 Nov 2025 07:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762674287;
	bh=SXM1RJK4Y1aQhRPlTIZtM6v4fO/FHLamLP4CHn5W4Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nEaGkOX+750ge1zsRExJBdxcZCWiyCN2X9rbocTZpOwQ/utvZ7cEBIhPmySBA22IK
	 jq+1DNA9z7vEPGCw6sQV+usYTJ7BaRuYpGVcKtz6D6b/ivwhSPSUuHrNDxLkrv0E6w
	 u7Uh8KG+K568UPZVpF5pwihAMcy3558XoDn9BWZuWQclBN9BJlo0w/TT/4xZPC4jbA
	 NXwBrsta1LFyzniQty1sMyWCVuKCprOolZhqNpOUR1YagOFumcwq4hq67NJYzkzAcs
	 QSt5xqbAnZgjImnfftJvLkdpNeJizJCtNVCmTpQlEevZf2WjQIbVZd/BDn2yyU01w1
	 Fy4UefJ9vd0Og==
Date: Sun, 9 Nov 2025 09:44:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Vishal Moola <vishal.moola@gmail.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Message-ID: <aRBGaAd_AvSvtzU6@kernel.org>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107095922.3106390-1-chenhuacai@loongson.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EAE2840005
X-Stat-Signature: wuzhrihebdtckhetp9xszd1dhu4uyt58
X-Rspam-User: 
X-HE-Tag: 1762674288-50877
X-HE-Meta: U2FsdGVkX1/w4Iu9/NE1cnapSKk/Sz5ldJ0on9HxWv7dzV5i9e47uWiYlGJi8OVVA92MND4jSqlcUUdOIqD6tznnNzVdJdjGFUJeU4gCU39N1iJJ35unWTXkq9VQvYmSgPGKXUg+yIBwiWyq7tlHIsi+BMwMbYuHqSw1/Z+Ll2KNBbVql1upBP0LBwZCmxmy4DNZJKtSd+KUGnDCqnytq5PRxBTpf/7P2gh2IELq3MTXZLmy7XvXFODxJnseFmvKUd+QxveoICMIYB7SY90GqKgRa5BZ4RT/zKeOHUoOaaNj4q2mrzlOXVjnpPzFIpwW3S+0i7CwimATQr4Ru1ZDoUC66krnjXLNBaDPFLrFQxoVAvsq3P0bd6JaLaxRrYWid8nP3jG+6Y/og8oNyDkJlmZkLd7chhXURV4tfzZ4bm9u8RgjRPmRGBpFdoyA+x4MwE0ZwWcm3npD8jGIqAesX3sVr4djBRoja44/zhMroDKxmjF+irYsHoH84naAwnZ39ieItO1thvM1MX8sGkbvOhk/vNdOQJyvtjM4y1uprg/YuJllqkk20ifydYFvpGilF4lU6KbDxNjDySQi8im4zqINckkqpplP52EtVTOJb/OBtKc1KCocAX9ayYL7KSC7jT/v/rMTG8xxE3b7o/BntRHPalpw/vk1NFjbTCj6cxi4ct0D6OXYcvrc5OR4b7A1udXioA47rzvQ3Hv6bjvKWgVDr2zx60KMf6/ZAagSi3WDGzGxRBLofgiO0y2jUN1aEzUwF34G4sn3jxc1BG4Zqj8RNqisrXyIsMlpNcMwFQADW7gE4envZnr+aC6Or8tM2fM4RlV70DTO3lAzc9EmnvAMllzyXogKJTf4/lSwslbnOzsP5rrr750A0jMyPX9klrmUjsb9PqUMC/I+iSew8nUIvu5llGttfFWtM9i8NIXO09P4jfnDMXd5TL3suJPv93+u55apzabbonGVMVS
 wf4GlM9n
 nbic+eLmSyrrjjwP8+LJJgGi9wnKYnZNoBzxrLorv6qgrcOXHdKvyO956A5Wt4vC2qdDRDUuvMVjvZdpo2phf3mN/oC2zRdIqCr/rrqxgoxxlEH6yV/nEQkOJcICP0MgULYJG1tzVhbws7E7/GpwZjVpB4OwOJ0y1+aWY6s4v5X7pR+poG8mcWCMAJk56BZW/1eGEgAYi9f3gbrEdL9XkWVaBSgWaeZNxhgW3YSLqu058BFXgxVR88y0BygqUgVe0UdA/CyxC7da0b7BXJNSLwDki3aUhHGw8D4iHN4CaNo2XR/QzpcF3FeyV7EnDtL89hu/zCzsallWr3xP19ltutQuY3aS9u89PHSkVFFUo3iSWa3WMdJTy8wxo6jP0nvXepEccKj6/3kyNhkc+iTVavoOTsCtcrC0efBTXaIY4ES7hSZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 05:59:22PM +0800, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
> 
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> 
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> explicitly.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Resend because the lines begin with # was eaten by git.
> 
>  include/asm-generic/pgalloc.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 3c8ec3bfea44..706e87b43b19 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -18,8 +18,7 @@
>   */
>  static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
>  {
> -	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
> -			~__GFP_HIGHMEM, 0);
> +	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
>  
>  	if (!ptdesc)
>  		return NULL;
> @@ -172,7 +171,6 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, 0);
>  	if (!ptdesc)
> @@ -226,7 +224,6 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, 0);
>  	if (!ptdesc)
> @@ -270,7 +267,6 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, order);
>  	if (!ptdesc)
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

