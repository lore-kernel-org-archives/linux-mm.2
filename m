Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C1DCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B996B00EE; Wed, 27 May 2026 10:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943B66B00F0; Wed, 27 May 2026 10:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859926B00F1; Wed, 27 May 2026 10:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 742756B00EE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:12:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B796403C6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:12:27 +0000 (UTC)
X-FDA: 84813389934.27.EECCBB7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3AAB980007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:12:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MKSa8BSt;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YtDJ0J10/PCwfS8CI5xlb7xlcrJcx7qk8qyccyyB9k=;
	b=v79l3C3NMhAal6vmr7iR1KGZioFt1usKwzzfpzHB4BeT6LARQGeJlpZTD5ggqJg+b4v6ho
	Lb5dMdqm8gEMKdqZ2mKtk1ebDe8ZKzeORxI8r3vlMu0NcCs4vNle0+f2H1N6FpQbyvfG6k
	LeoovnmgwzSdff9NX0OZZ13dC8yTDhQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MKSa8BSt;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891145; a=rsa-sha256;
	cv=none;
	b=jsFKWo9O6OssUBjfrRB/21Rzg+Ubtomt/KdrfllHOjePRu82LR2l0lIFxXe2YaKLUeEazR
	ziW7Ye077/LuEI3U8/HssKgwx288yv5Z8IyoJcHvq1IWaqsBRbiC5pAKBkz/DIInsVFwMn
	Hn6gbmNFUmsOhOycilNleI/sccP9i54=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E0D927DC;
	Wed, 27 May 2026 07:12:19 -0700 (PDT)
Received: from [10.1.36.149] (XHFQ2J9959.cambridge.arm.com [10.1.36.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 714813F905;
	Wed, 27 May 2026 07:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779891144; bh=u3OCxUvtZcz8HMh6U6iOvnXk3mPDlsgfuMXPwG1nTnM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MKSa8BSt9BSP9qCifI6PxRc6JlT2Rvcm3UBj7hlH3DOwlOqZ9GbA9MJXvTzduITUK
	 cN/VxqCg7WM5rVROAvZB87oajUO9GN3RvAL+HjURwBq+pFlLCnauo53bTJRALtYeAF
	 CU7fyXOpRpolf4zP8xtVI/2LDMhBuehQgWhWCh8s=
Message-ID: <a15c4d95-e277-4caa-9157-8fac37e56641@arm.com>
Date: Wed, 27 May 2026 15:12:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 08/14] arm64/mm: Route all pgtable writes via
 pxxval_set()
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-9-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260513044547.4128549-9-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9otmwaeyeu98p4bu8afkyyzappm96sft
X-Rspamd-Queue-Id: 3AAB980007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779891145-461775
X-HE-Meta: U2FsdGVkX189dbgXZbFHPv+HayiUWklw5k6PKaDWsKh3E18BsMQ3uRbLwDdMnCtfpXPnz5wHN7NgxXN74dzvNdJulgWJmLmcmWrypp22MuWvrPDhDrjpCzz/9H7GHuAsWg6zDQlyecGX7VWTGFm2f3K5W36+o9jTho2koaqlilakZ3MxTGEVImm+0wI/ldxr+9RcgZlUxtHu1AvSn0LtzxewjHeNQqeJ4oyH+k/bfbnzU2TVL5hR3N8qcCHqrBWtmrZ5NwoBYx2bClkqNwF/OmJ5l3/52KW52VRwHqEfrJyPbkwLS03Lf7vi/QJarbA+1X6YruW8juNMKNarKdlVtX+lpJo07xlekhaOCUt8i7DevCy+SM7e9mew5NIRz0DSVSTO/Vv3kp9fQGFUdoNZ3G1WNodZbDe1XxIbrIkwO0tBWrK5grXN/qCDPF+7EMojybNTP3rDytNCEW3On7nHfUZvFbQ3khvrGtYEtT+e0zN5rm47VwQQbY05e4+xMEr8fXUDvEJGKhpTufP9gt8im3+R+eLQVQArVLBccIwDZHcRNyXlFA29W7C7ycVaZJmSFgdee8qRm/Cp/OYTnNnxqLTfekQWdK4uvKyU+zwrBaLwRrpYL9XNF0NKwuQRqRUA0VqH6AXye4XGs0EihE3PiwFowM6N5z+gPKjEY813HIsfyJ4Nhw+RGLHXTbo0DCTZ9Q/m5hbbI6BHD60BhkQ5mB5qnjRDULtl/L0vTIG2rSw+M3hRPGh23Gs/hWiY57L9h9WK/l2bS1+6dfRg9b+qw5SAHPj0lCkUxxiMZACpi0QWUg8VeCTaoa88EBx5Et/1NkdGGkUVYhAU/C45RSSEr/rVFdqcLsTFsFWiSwtrhl7iwDcEr7QWhc43oZM0vRX35N9gOQg+jkkiwbnEjiPLTnyZ04gQJApMEYwYQxkvoVf3mDnK7kDOUWU4cvsIE52CwYJRzCMmgXEJ1A+aFOk
 S8JlFfyK
 M56f8i1vzUqwCQkr1YmyXUj9fPXC7Y+B2N6/mxvy8RmlvNtfSHAqIVLZPyhVhobl8GIx2ADPiX9HwZQfovhA9J6XJ0hecpG25uROXHeUDmEyqS/zWsaxkiZeVnupt8b5t7hEMR7N4KlwevUZGiqiVA/LKfLDZ2RdVmBPdSzCeaUehSAnFly8CUdj47Xd3GKRGXSiuaZqyuYWXMsvAQ9WAGLL5mWF11EBt+5pNX36tQiiBaLc2vXrE1fkdqSrJsv2Z2sYpxUkKJ1FE5xV6bvlBp60MxRf74kLb75wQsRnin5W1Dvs6P3KwV4+tRRTrc5HU9nb9YFp2i1NN61cI5+t8Sq9WagsKgrLLc1RBRG9hbQzNM6acy921SIex1Ophss2Gc3hMgiIWQMiuXzyyAJHyF6VJDkvag+HONsd9ir4zhW2Fca4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/05/2026 05:45, Anshuman Khandual wrote:
> Currently pxxval_set() is defined as WRITE_ONCE() but this will change for
> D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
> copy atomicity.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in RFC V2:
> 
> - Renamed all ptdesc_ instances as pxxval_ instead
> 
>  arch/arm64/include/asm/pgtable.h | 11 ++++++-----
>  arch/arm64/mm/mmu.c              |  4 ++--
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 72da582e8d12..c71bb829e9f1 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  }
>  
>  #define pxxval_get(x)		READ_ONCE(x)
> +#define pxxval_set(x, val)	WRITE_ONCE(x, val)

Same comment as for pxxval_get(): I think it would be clearer if this was an
inline function that took a pointer.

Thanks,
Ryan


>  
>  #define pmdp_get pmdp_get
>  static inline pmd_t pmdp_get(pmd_t *pmdp)
> @@ -385,7 +386,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
>  
>  static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	pxxval_set(*ptep, pte);
>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>  	}
>  #endif /* __PAGETABLE_PMD_FOLDED */
>  
> -	WRITE_ONCE(*pmdp, pmd);
> +	pxxval_set(*pmdp, pmd);
>  
>  	if (pmd_valid(pmd))
>  		queue_pte_barriers();
> @@ -921,7 +922,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*pudp, pud);
> +	pxxval_set(*pudp, pud);
>  
>  	if (pud_valid(pud))
>  		queue_pte_barriers();
> @@ -1003,7 +1004,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*p4dp, p4d);
> +	pxxval_set(*p4dp, p4d);
>  	queue_pte_barriers();
>  }
>  
> @@ -1131,7 +1132,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*pgdp, pgd);
> +	pxxval_set(*pgdp, pgd);
>  	queue_pte_barriers();
>  }
>  
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 7fbb2ef86cfa..6eb92d8f46be 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -76,7 +76,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>  	 * writable in the kernel mapping.
>  	 */
>  	if (rodata_is_rw) {
> -		WRITE_ONCE(*pgdp, pgd);
> +		pxxval_set(*pgdp, pgd);
>  		dsb(ishst);
>  		isb();
>  		return;
> @@ -84,7 +84,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>  
>  	spin_lock(&swapper_pgdir_lock);
>  	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
> -	WRITE_ONCE(*fixmap_pgdp, pgd);
> +	pxxval_set(*fixmap_pgdp, pgd);
>  	/*
>  	 * We need dsb(ishst) here to ensure the page-table-walker sees
>  	 * our new entry before set_p?d() returns. The fixmap's


