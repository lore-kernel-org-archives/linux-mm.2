Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D023CCA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67716900124; Thu, 14 Aug 2025 05:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CDA900121; Thu, 14 Aug 2025 05:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589B5900124; Thu, 14 Aug 2025 05:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47945900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:50:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEFE4C0600
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:09 +0000 (UTC)
X-FDA: 83774892138.15.E6C0E46
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf18.hostedemail.com (Postfix) with ESMTP id CE3881C0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755165008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2S1B3uDCP0V6cOw8J5BBf2RKM299o8V1mNT79lVcT6E=;
	b=PYp4gicHtV7h8fMnU2xY3O2b2AY1niIm/oErwl085YO6j4JxwNa/H5HrawDW2OqN4K8Uno
	vYYW7xw7G8QTp1HYj/Ztiv6XO4zRT9ZmbbHtZA2kXzQnogPsi1KOmtdcOVd/Sa83wAnVV6
	f+dqg0s03HmMvzYfUlEgp27BhCSPa0E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755165008; a=rsa-sha256;
	cv=none;
	b=FL7ma6LdMjI1/M79zEyGBKT9oJh10LNn6FUoPDO4O9GYyXlIf+2H15Tq9NSIYMD9H1WcSV
	yf7AvmQVP0XY5lJRq+5t7GW1d9o0WhaTlN6caIfkO6Rr1MTzrDr3q6IUiv2vpqhLl6fP6o
	I/nT0/+mPTEhxWEVGTc3rwMQP7ykyCg=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8022243214;
	Thu, 14 Aug 2025 09:50:03 +0000 (UTC)
Message-ID: <77670b86-1212-4547-a119-a876e4948b33@ghiti.fr>
Date: Thu, 14 Aug 2025 11:50:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/13] mm/page_table_check: Reinstate address
 parameter in [__]page_table_check_pmd[s]_set()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>,
 Ingo Molnar <mingo@kernel.org>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-5-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-5-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtjeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepudegpdhrtghpthhtoheprghjugeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhst
 ghvsehli
 hhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Queue-Id: CE3881C0004
X-Rspam-User: 
X-Stat-Signature: 3ukzjga44mqy13gznugieh6w8qktr95u
X-Rspamd-Server: rspam09
X-HE-Tag: 1755165007-205312
X-HE-Meta: U2FsdGVkX1+aPRXHEXkHSTl6iA/lU/dqL3EpWfvn0/WfFjforOhIhvJ+DrXT19ykGuVonaB01Mpff/dNVOic78WyWTFpeK1LH9AIv69F5xfB7x0gzQLeAUTptf6kfLtqIeTLf+sdldcGVwYwUl3Nb1gO6/eZuSIMtPUhxPoW12nfnLCM39z5/TOo02p7+eUWH4YFd6BwEOLouLTozTS9Ia+tk+fO59mxN2W3qJOjRJo8SCtDFVjuFNLXoh+dq8Y2MvmcAd7qUUeB9R6y6pPuZDNwiHpS1ypeAtAGcaaF1SwOkrwC1DpPuJE262Q0YFKJSsfJb5nzEQwTRnc0NAlc2GUQrQttZiVwArKv0stP8KfiRvq/PxCmFl8NLGKoKwUPZF/HTfrJxCgPcm0GC/Ni3Vh8FygQinF/tVhRHV7REbdE+KGaswd/ji6exJqM4IEXecwGKGGe+Rt+o9Vxf0pJG2N18tCKmcw3GyFp08bZhKM9mo0+OlrhdvO+VUNnEkjoU5CM1Y2VDQ+g1xzcKVEnorz0pJ8sH9jTJz7wbzzimJ454cZe5oAOodC8tcIomwfdGQbugRfNHNtxDx8iMOlRwUt71z6vLOCWgIIgIZYf839YzgOBzgfQfOF7F/ePBLr8wm6GBRrN8Rf+abxECCiSP+duzcCQjMtNsGCAXIccEKiNRuf1PKQjvI5b0UxrujlCR3ZQP13dwgWuFjmLop5ebXW5L4LYhYDoCafIyM1iSwoEAO0y6nMH30tRzA9GKUS/9e3F0KNAL7ACr8V8JLG5wckEd2V+cYtJahEGcA6PQoSbHUEJMZVP1dkQLQl2qbocWuDBAIDvWOMkzSFdi6tSPJtrw+o7tmmRfyxiq2mg1xWEEqppZLYHkDMrY01NO2w0NxNXiauuAmY2Wt+vQ/wjxTiubBl73iYoQ5CDPTg5k1A6QtznOOwZmLUF+MiqvkiSQKnGMA9P3/vpgOTum3M
 Ki1FsCtz
 VE9+rmNMUeGIYt+RJ0YPtbZDSgoHRFzk+Wa30XyN4dKVUvhI3K6yKtuVVU+awy2HmR85qUGCppHmwwx/oW8ouxFZ9HwsBAhJ2FH0zZS967EtHNZXCS5Nmr6vJ/4uzR0nQdf99djeQhN6qXv3PMa/ctJrKlOXyrYfky0OWsKr7uNDjdpJJUhx6R1evg4mC/311+LD4x1Oxs1Ht1bHO0e9MjWiCPVIuelsdVRio2kIHXsruC/YMzKe90ptBUI4dKK1H5g2CCgetI0WT21/qhVSacEpraD5u8spRi/NDCl1rwLinffKJS7Npc9M08A==
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
> This reverts commit a3b837130b58 ("mm/page_table_check: remove unused
> parameter in [__]page_table_check_pmd_set").
>
> Reinstate previously unused parameters for the purpose of supporting
> powerpc platforms, as many do not encode user/kernel ownership of the
> page in the pte, but instead in the address of the access.
>
> Apply this to __page_table_check_pmds_set(), page_table_check_pmd_set(), and
> the page_table_check_pmd_set() wrapper macro.
>
> [ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
> Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
> v13: remove inaccurate comment on riscv in the commit message
> v14: rebase
> v15: rebase, amend commit message
> ---
>   arch/arm64/include/asm/pgtable.h |  5 +++--
>   arch/riscv/include/asm/pgtable.h |  4 ++--
>   arch/x86/include/asm/pgtable.h   |  4 ++--
>   include/linux/page_table_check.h | 12 ++++++------
>   mm/page_table_check.c            |  4 ++--
>   5 files changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 8070b653c409..9fe3af8b4cad 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -709,7 +709,8 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
>   		page_table_check_ptes_set(mm, ptep, pte, nr);
>   		break;
>   	case PMD_SIZE:
> -		page_table_check_pmds_set(mm, (pmd_t *)ptep, pte_pmd(pte), nr);
> +		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
> +					  pte_pmd(pte), nr);
>   		break;
>   #ifndef __PAGETABLE_PMD_FOLDED
>   	case PUD_SIZE:
> @@ -1514,7 +1515,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
>   static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>   		unsigned long address, pmd_t *pmdp, pmd_t pmd)
>   {
> -	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
> +	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
>   	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
>   }
>   #endif
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 3ed0f5e4879d..6e8c3d19f96a 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -805,7 +805,7 @@ static inline pud_t pud_mkspecial(pud_t pud)
>   static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
>   				pmd_t *pmdp, pmd_t pmd)
>   {
> -	page_table_check_pmd_set(mm, pmdp, pmd);
> +	page_table_check_pmd_set(mm, addr, pmdp, pmd);
>   	return __set_pte_at(mm, (pte_t *)pmdp, pmd_pte(pmd));
>   }
>   
> @@ -876,7 +876,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
>   static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>   				unsigned long address, pmd_t *pmdp, pmd_t pmd)
>   {
> -	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
> +	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
>   	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
>   }
>   
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 0603793acb3a..8ee301b16b50 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1213,7 +1213,7 @@ static inline pud_t native_local_pudp_get_and_clear(pud_t *pudp)
>   static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
>   			      pmd_t *pmdp, pmd_t pmd)
>   {
> -	page_table_check_pmd_set(mm, pmdp, pmd);
> +	page_table_check_pmd_set(mm, addr, pmdp, pmd);
>   	set_pmd(pmdp, pmd);
>   }
>   
> @@ -1356,7 +1356,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
>   static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>   		unsigned long address, pmd_t *pmdp, pmd_t pmd)
>   {
> -	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
> +	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
>   	if (IS_ENABLED(CONFIG_SMP)) {
>   		return xchg(pmdp, pmd);
>   	} else {
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index 0bf18b884a12..cf7c28d8d468 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -19,8 +19,8 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
>   void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
>   void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
>   		unsigned int nr);
> -void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
> -		unsigned int nr);
> +void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
> +		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
>   void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
>   		pud_t *pudp, pud_t pud, unsigned int nr);
>   void __page_table_check_pte_clear_range(struct mm_struct *mm,
> @@ -77,12 +77,12 @@ static inline void page_table_check_ptes_set(struct mm_struct *mm,
>   }
>   
>   static inline void page_table_check_pmds_set(struct mm_struct *mm,
> -		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
> +		unsigned long addr, pmd_t *pmdp, pmd_t pmd, unsigned int nr)
>   {
>   	if (static_branch_likely(&page_table_check_disabled))
>   		return;
>   
> -	__page_table_check_pmds_set(mm, pmdp, pmd, nr);
> +	__page_table_check_pmds_set(mm, addr, pmdp, pmd, nr);
>   }
>   
>   static inline void page_table_check_puds_set(struct mm_struct *mm,
> @@ -132,7 +132,7 @@ static inline void page_table_check_ptes_set(struct mm_struct *mm,
>   }
>   
>   static inline void page_table_check_pmds_set(struct mm_struct *mm,
> -		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
> +		unsigned long addr, pmd_t *pmdp, pmd_t pmd, unsigned int nr)
>   {
>   }
>   
> @@ -149,7 +149,7 @@ static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
>   
>   #endif /* CONFIG_PAGE_TABLE_CHECK */
>   
> -#define page_table_check_pmd_set(mm, pmdp, pmd)	page_table_check_pmds_set(mm, pmdp, pmd, 1)
> +#define page_table_check_pmd_set(mm, addr, pmdp, pmd)	page_table_check_pmds_set(mm, addr, pmdp, pmd, 1)
>   #define page_table_check_pud_set(mm, addr, pudp, pud)	page_table_check_puds_set(mm, addr, pudp, pud, 1)
>   
>   #endif /* __LINUX_PAGE_TABLE_CHECK_H */
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 3c39e4375886..09258f2ad93f 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -218,8 +218,8 @@ static inline void page_table_check_pmd_flags(pmd_t pmd)
>   		WARN_ON_ONCE(swap_cached_writable(pmd_to_swp_entry(pmd)));
>   }
>   
> -void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
> -		unsigned int nr)
> +void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
> +		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
>   {
>   	unsigned long stride = PMD_SIZE >> PAGE_SHIFT;
>   	unsigned int i;



Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv

Thanks,

Alex


