Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF9B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXSfiJSW
Received: by kanga.kvack.org (Postfix)
	id 517846B05B9; Thu, 12 Nov 2026 06:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE7F6B05BF; Thu, 12 Nov 2026 06:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BA66B05CD; Thu, 12 Nov 2026 06:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0246B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:47:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A721380526
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:47:34 +0000 (UTC)
X-FDA: 85426292028.15.D333A61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02B271C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:47:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QXSfiJSW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484053;
	b=g11/2RMqxevsbsrX92w6qvK8OuZi4BC4JGsuYWmizETNIrrO6EcAgEL+ESclm/W9B+2J2l
	iN8/AJZ4Zq+5eYyLvWu40+DBqkp712MFsx6sYwp3at4Yc1IR3kg3WFG9Da0CG5jVuykbqH
	+rx92OLsZkD0tTPRKoiC9hxG3/8orqw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM+TmZTTVlgAseJteA04V2b5gZJJ/nPwoEE1QOkg22k=;
	b=sTnS44CmglCXN3cIG8oxKFFKQCN14R5f9aHo4jPlTjnRH9z8+cqmIFZYitvZvorvpb69Z4
	umnVSVo8uihqomlSYEVx3VxROCTLe/hH2S9w7+5s3GmCQANJHMR0vnlMxa9weSQtKwUMH7
	1F3L3GCJ+B742CEGIkAVfUVL3oW3cQc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QXSfiJSW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80E236121E;
	Thu, 12 Nov 2026 11:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D011A1F00A05;
	Thu, 12 Nov 2026 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484052;
	bh=vM+TmZTTVlgAseJteA04V2b5gZJJ/nPwoEE1QOkg22k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QXSfiJSWVRJXBEP0SekW5iZErSus3IhESAmYYSoJ6gFHXzQa0SEJVUdZvq5ukRZDB
	 zIPjxW4etzEDjGqnuJfKbNVNZxoFMvzhZDS9m81YSp76lOMl2N4adQE3QXfqhBMfvA
	 9l5NsWktPRODSt3io3E2kVXyTOFCfLLIH6vAn1opAIncFXGuHBQ6cxmjLB2/4yrd/K
	 8UPGjOH77gUkh2AZC4I0bJ+fOkkAs2wHOmfKqa1zHKPt6SB7Ec0zuKXHtEtOnpQS1O
	 7Akv52un3uHhlY5kipQTVVs4WyWo7GPo7w0EOGpELT6Sn1Y9ieNLHwwZ5DbqObaFtC
	 55nWb1rCIF09g==
Date: Thu, 12 Nov 2026 13:47:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 3/6] ARM: drop CONFIG_HIGHPTE support
Message-ID: <avWnS7MLyPaJLaLR@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-4-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-4-arnd@kernel.org>
X-Rspamd-Queue-Id: 02B271C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: 6qzfzk9c4unu1h8agdmy3jduje9wgzn1
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794484052-372856
X-HE-Meta: U2FsdGVkX1+hw4lJpVvsnNexW+unx+19a/xGRtNKHbdyB9WMCSI/w5K6qTxF8MP8jgvdReDLymGuHWfUbTisi/Ug8CN0EzclYiZoa/5xPm8MYRcPRxJcFtp3Nhq5qKbBk8T8svcgfNqwS7mvE9jNZ09+mjUtAuM2uTokx6ryOMK53vHii8HTJ1/6QXiVI3TIZObhCIWtg+CgYE3m+fCfH/VCdo82QVVtech21HVqzt0++/6TTwo99cHC50CDkSt8IMQcNKXIi9rBMo6WQbGm0akYHkkUEOzEeUAJrkV8BkBuG3M+4qxkKI33ox91gn3z4CVkyly5bYIApFgY/4H79HsEuch0dKI5M6kLQ4fPpGcv5SQJApWiihYSgQhfuxyWpa8KIjX7Sg3oRMrSKD1Ll0LiFcCvgf1LkANsb4kwMkPvZB97zRWYCS/2O7+IKByP6hpPkcnxFLczTnk3UOZO1qeqKmCzGhdteEx1IzWdN1NNFcn/aQVgeoj1YThUAfB1kcf9uLD29PuLdNwxuKq/i4t0vKHchaZ65gZCLax8vTUbGgZ/vpBfXeyrmab6Hvk7/tj4NoENZfZt/qSRVJfNdVZnfxUB+dF35D3HMPGKO/HPC90Wboi4dR40ZWBP8ykfouQk4EBlzgqwLBpEzkiD6bVnpXd5KzB5jwarnFvwBjzF03OiBjS9l3ZesTIgyVnf0+eXtsDo0ithcxXOB31Qojxlb9ColjpTmQyAwdcwQGzeC2lzm7G47+Qliq1DoccrFEpDAAc4l+ft7+31z9YRgeVtuHDN6kThQymu1X6unhMB43WFgUZOwYJYZvtlQu4yVNqpOy5Hr9by1f4GeWqoGy4yrCKYrChP7CX+YIHteiYAqy0qlSOTiJswWUkeFZV6Y4nXqLvbM7HYFbR6ZYToliQ393g9NlVbkPKo+CevvxxDWLwFOUVw32jaOiFW8W7SebFf3FcHgTZyJr11+1s
 pOzWIMnX
 xsmlstgG6YwS+TJf0yhcIp/Jn2aFLC4hWUx+RjoslhzGeEKpm70ICVqMR8tBeyOHaPPH1zbrRbAZ1gxyK5hBIh/V8gcXMWwdtNsbPlD4IdCmNGcngl2UfzXK9IcDSD8iNDWTbafh1pdmKMHfmq+7ksQGi1DRd76q1E4Acc7kDR8M2JIoAiKYBzMZT3W9Y5/L/jttkPGjzMRLASQKtLIAkzW8Ys5pWlft/DeZbYxW2hetTFktVmkNSCna0OkTJomKQN75O2+XZUGbP4eYKlapeQcTZzD97X3ZFJOcx+JHm18saSNcn9mu3lgS2j2VWbEIzMe9B7TKLMYPRmd9DOKiTcgQ4x/0ToTWJG8HAMbTNBYs1Fmb4IH/VcW4Y8JgRhhGnLxbXg5/+Sy0iRLI9rvyTBbh2C1dSFORj8hit1/+bxWIuoPM2cfC6ZZ+0iLVGErpYPoyUI3kLG75zbeIZxg3mi/r80W0jVt6Yus3T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:25PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> CONFIG_HIGHPTE was added in linux-2.6.32, a few years before 64-bit
> support. At the time it made sense, as the CONFIG_ARM_LPAE option allowed
> systems with 16GB of memory that made lowmem a particularly scarce
> resource, and the HIGHPTE implementation gave feature parity with 32-bit
> x86 and frv machines.
> 
> Since Arm is the last architecture remaining that uses this, and almost
> no 32-bit machines support more than 4GB of RAM, the cost of continuing
> to maintain HIGHPTE seems unjustified, so remove it here to allow
> simplifying the generic page table handling.
> 
> Link: https://lore.kernel.org/lkml/20241204103042.1904639-8-arnd@kernel.org/T/#u
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I sent a patch to drop HIGHPTE support on x86 today, see
> https://lore.kernel.org/lkml/20241210144945.2325330-9-arnd@kernel.org/T/#u
> 
> If that one gets merged, we can merge this one instead of the one
> that makes HIGHPTE depend on !PREEMPT_RT, but if we decide against
> the x86 change, then we probably don't want this one either.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/Kconfig               | 11 -----------
>  arch/arm/include/asm/pgalloc.h |  8 +-------
>  2 files changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fd01ccab9c12..fc66d52d847e 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1225,17 +1225,6 @@ config HIGHMEM
>  
>  	  If unsure, say n.
>  
> -config HIGHPTE
> -	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
> -	depends on HIGHMEM && !PREEMPT_RT
> -	default y
> -	help
> -	  The VM uses one page of physical memory for each page table.
> -	  For systems with a lot of processes, this can use a lot of
> -	  precious low memory, eventually leading to low memory being
> -	  consumed by page tables.  Setting this option will allow
> -	  user-space 2nd level page tables to reside in high memory.
> -
>  config ARM_PAN
>  	bool "Enable privileged no-access"
>  	depends on MMU
> diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
> index a17f01235c29..ef6cb3e6d179 100644
> --- a/arch/arm/include/asm/pgalloc.h
> +++ b/arch/arm/include/asm/pgalloc.h
> @@ -85,18 +85,12 @@ pte_alloc_one_kernel(struct mm_struct *mm)
>  	return pte;
>  }
>  
> -#ifdef CONFIG_HIGHPTE
> -#define PGTABLE_HIGHMEM __GFP_HIGHMEM
> -#else
> -#define PGTABLE_HIGHMEM 0
> -#endif
> -
>  static inline pgtable_t
>  pte_alloc_one(struct mm_struct *mm)
>  {
>  	struct page *pte;
>  
> -	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
> +	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER);
>  	if (!pte)
>  		return NULL;
>  	if (!PageHighMem(pte))

With HIGHPTE out this can be 

	if (pte)
		clean_pte_table(pte);

	return pte;

Otherwise

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

