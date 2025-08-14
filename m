Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9716CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B39900126; Thu, 14 Aug 2025 06:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BF5900121; Thu, 14 Aug 2025 06:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B49900126; Thu, 14 Aug 2025 06:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBF99900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:00:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C3DE1DDA71
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:00:02 +0000 (UTC)
X-FDA: 83774917044.08.5CF3726
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 53C7F1A0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:00:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755165600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=msNKhqRDNixJEW/TpRAVdXqVOCSP+2XJ8j2lE8vxwtc=;
	b=o8658B0PAgUTFnzqyMWZ9gpa2wXZssDStvN7j0t2mYoAMzRf7xoj+DFLK/I94mJNUBeXIz
	ZRr46S9zkYgYWVLfxiw/0JsAV+nIYraws2zNIdPROMyAVvvt3Cdkt1bWmU4m4Sv6dhfyyt
	CCWKeBU5tlBPQyPSamnVbUChNTrWjug=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755165600; a=rsa-sha256;
	cv=none;
	b=pREJuhHhZaB6hvda9ZlIYPEu3EhDoIuKheJTt0r10bdk9awu29nafpfUHCCCMNUesyJ4xo
	GOP3zPezl6ZigSIYJx0JEfWFYwdqRChNRpmwBSkb74XZxFtmn86UF98I05wZQlwfK0T26h
	7iEAXsXb4xN6RC7wewnMm2K+heV2MTw=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A12FF43379;
	Thu, 14 Aug 2025 09:59:57 +0000 (UTC)
Message-ID: <d021125f-49b0-43d3-ab7a-4eef1836aeeb@ghiti.fr>
Date: Thu, 14 Aug 2025 11:59:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 07/13] mm/page_table_check: Reinstate address
 parameter in [__]page_table_check_pmd_clear()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>,
 Ingo Molnar <mingo@kernel.org>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-8-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-8-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepudegpdhrtghpthhtoheprghjugeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhst
 ghvsehli
 hhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Queue-Id: 53C7F1A0004
X-Rspam-User: 
X-Stat-Signature: cd3zmah6jzn1o9sxhc8qz63dazdwmbs3
X-Rspamd-Server: rspam09
X-HE-Tag: 1755165600-533102
X-HE-Meta: U2FsdGVkX1+v02o3noGoTwpKScMOZIeeeTZqufZzO9fSzUvKwtalJNcB3AkmSCr/zh9IQvvrvPcifaTF28rAn7dVoid+HWy+tLBzhDFn0UXLTb8/QG0C4qg1eFS1IsZaKaVTO7m0QJFBHlRcmMpdjpRAyl68eFt70ku/g17Zu4RRmO5q9Wwcjf77ZdnRkS48wP8ksGzcFAwEtmnFiCpbByzGWXQID0Ii+tSs2g2BVx8nw2unbvxRx76d/m3rm7S7KkaA1GY104yuPgjR/q6nqPj7OzdCKO83PaAb+CTtj/JMDJNAiP7K3eJ7O6N/FZZApUrvjzWfUX3N+oC/zLJo0bc0xfS4xzW4y/nTMBE/dwjvOnqE5G0ZixvOUSXB8uHOAIi5gp4XXgKQqftTM4vsBNHgNcOFtlSGQUfpTKY9Vt0AgM/Zg25pX5G85EdEeHhgzotr7FbnA/H8H/nqHHRxtq3e1XTLkr2O+zyMZGR/IVS7pW5yIV31q8cNwkE35E7nf8Uv7iVWqwCcFC0Uz5YsIRgvB3oINfGsMgqkMER2S3fIo5PJGFPBTqvwR0Bt0XQJz2dEm3fe1UfOKA/NaJepHQU/WJLYdFyWTmLLGVauhK5DINTbWO59httNGBY6S03Lzny3Za2hKPvMA/BRAJRezZvdjcmkfm1IOzDh2XYRAU4CfxbvlvHR985FgT8Sh4cuv1HLRCPnYkBdEaEhYeVrFuSOym5QxXX32XKbmzfxqP06lJM0ckDkzngvDYo8xEhOZdO8eOmjXXmFuY06nR1oeS12QewZSG0QhY2lfjC4rKjPfJO+YUyxRASZnZVazjlnh+KOkv6F3DAz01OQPIgAC+UtFNT5lV6na8EM7iEeTNbj432je3lBotQ1jQW5sZcfGZCcxQfpELVffW2gE/9adsB2h6Do5xVrvdUtDgzqxlckImU4/rkN4yCS56vKSjtvc/33sN5GrRRHykfZxP3
 DGegvsSb
 8r+KLmV1zcQeTSTaPhurEfpj1tUks0Zw808oBNJcDjHvH1Vf0GK6DbvaRd6CzWbmq+9lerpPI32N99Mj6fC3Ih+Oku+MSUY64oBkkMeZxzxyXBaM/mH263tT3Y14h2ZnSxiYQaXY2NCtiEWHD3832x/ckwQXwdoU9U+kZGloEIpzhsVObOorBS8Ll7KfOkherbBLpQLl4/IWzSZpiBLHaOpdd4i5YyVWE/PpATAsoC/hbBkeAf32T1LxjmN2Dk3LYNcpa6lD+9o+vCeW+MIk/nWmE45tfHk4F7g7VODiITnIUJdLuXe9BI0kSTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/13/25 08:26, Andrew Donnellan wrote:
> From: Rohan McLure <rmclure@linux.ibm.com>
>
> This reverts commit 1831414cd729 ("mm/page_table_check: remove unused
> parameter in [__]page_table_check_pmd_clear").
>
> Reinstate previously unused parameters for the purpose of supporting
> powerpc platforms, as many do not encode user/kernel ownership of the
> page in the pte, but instead in the address of the access.
>
> [ajd@linux.ibm.com: rebase on arm64 changes]
> Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
> v15: rebase
> ---
>   arch/arm64/include/asm/pgtable.h |  2 +-
>   arch/riscv/include/asm/pgtable.h |  2 +-
>   arch/x86/include/asm/pgtable.h   |  2 +-
>   include/linux/page_table_check.h | 11 +++++++----
>   include/linux/pgtable.h          |  2 +-
>   mm/page_table_check.c            |  5 +++--
>   6 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 81f06e5e32b2..dfcdf051b114 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1370,7 +1370,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>   		page_table_check_pte_clear(mm, pte);
>   		break;
>   	case PMD_SIZE:
> -		page_table_check_pmd_clear(mm, pte_pmd(pte));
> +		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
>   		break;
>   #ifndef __PAGETABLE_PMD_FOLDED
>   	case PUD_SIZE:
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 2484c0788012..d11fc6333606 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -860,7 +860,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
>   {
>   	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
>   
> -	page_table_check_pmd_clear(mm, pmd);
> +	page_table_check_pmd_clear(mm, address, pmd);
>   
>   	return pmd;
>   }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 8b45e0c41923..b68bea15f32d 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1318,7 +1318,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long
>   {
>   	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
>   
> -	page_table_check_pmd_clear(mm, pmd);
> +	page_table_check_pmd_clear(mm, addr, pmd);
>   
>   	return pmd;
>   }
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index 808cc3a48c28..3973b69ae294 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -15,7 +15,8 @@ extern struct page_ext_operations page_table_check_ops;
>   
>   void __page_table_check_zero(struct page *page, unsigned int order);
>   void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
> -void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
> +void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
> +				  pmd_t pmd);
>   void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
>   				  pud_t pud);
>   void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
> @@ -52,12 +53,13 @@ static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
>   	__page_table_check_pte_clear(mm, pte);
>   }
>   
> -static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
> +static inline void page_table_check_pmd_clear(struct mm_struct *mm,
> +					      unsigned long addr, pmd_t pmd)
>   {
>   	if (static_branch_likely(&page_table_check_disabled))
>   		return;
>   
> -	__page_table_check_pmd_clear(mm, pmd);
> +	__page_table_check_pmd_clear(mm, addr, pmd);
>   }
>   
>   static inline void page_table_check_pud_clear(struct mm_struct *mm,
> @@ -121,7 +123,8 @@ static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
>   {
>   }
>   
> -static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
> +static inline void page_table_check_pmd_clear(struct mm_struct *mm,
> +					      unsigned long addr, pmd_t pmd)
>   {
>   }
>   
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 28fcff844b63..d97f40f1365d 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -648,7 +648,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
>   	pmd_t pmd = *pmdp;
>   
>   	pmd_clear(pmdp);
> -	page_table_check_pmd_clear(mm, pmd);
> +	page_table_check_pmd_clear(mm, address, pmd);
>   
>   	return pmd;
>   }
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index bd1242087a35..e8c26b616aed 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -156,7 +156,8 @@ void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
>   }
>   EXPORT_SYMBOL(__page_table_check_pte_clear);
>   
> -void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
> +void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
> +				  pmd_t pmd)
>   {
>   	if (&init_mm == mm)
>   		return;
> @@ -231,7 +232,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
>   	page_table_check_pmd_flags(pmd);
>   
>   	for (i = 0; i < nr; i++)
> -		__page_table_check_pmd_clear(mm, *(pmdp + i));
> +		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
>   	if (pmd_user_accessible_page(pmd))
>   		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
>   }


Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv

Thanks,

Alex


