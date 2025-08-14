Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A68CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D36900123; Thu, 14 Aug 2025 05:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3171C900121; Thu, 14 Aug 2025 05:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D43900123; Thu, 14 Aug 2025 05:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B09D900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:49:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF5921DDA87
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:49:27 +0000 (UTC)
X-FDA: 83774890374.18.3FF96BA
Received: from relay16.mail.gandi.net (relay16.mail.gandi.net [217.70.178.236])
	by imf07.hostedemail.com (Postfix) with ESMTP id D719740002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:49:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of alex@ghiti.fr designates 217.70.178.236 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755164966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=frhBgKzGaeGY6bSaVivBjRAP80vw7xY6RF99St5utxI=;
	b=x/Leyv/bncaDmoucx3MJM/1bAwCsQPt00aOm7YSiuOd+eoyNyKSdK4LJuqFWmBPLcztXZA
	rQDXx3gp1TJDTYaWViw81Ei+4u64gObIY8yrMhwSIY4I2e3jA54OVbLAZD5J+Z4Usa6isu
	4n8nGcp0UbJ+bc6b5H/7M4HYhvRwHKs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of alex@ghiti.fr designates 217.70.178.236 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755164966; a=rsa-sha256;
	cv=none;
	b=PY6i7k0LiKkPKax2EKGU6ovS3u1S1O7IgrXWVHYE614y+Cm5QHLNGAgAF2FyTbkoIdfsdL
	/55+f2FuvZxYQombGE/hu1rAIkuKmMDXJuxot8AXWmc4qQrdDmgg0t6jjyE89HK4Koz2T9
	i+Cuh9xG1JPsBdIOgxVHU+YzixxadFQ=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4AD454495A;
	Thu, 14 Aug 2025 09:49:20 +0000 (UTC)
Message-ID: <debb39ce-5d6d-447e-9b03-62c3c951292e@ghiti.fr>
Date: Thu, 14 Aug 2025 11:49:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 03/13] mm/page_table_check: Reinstate address
 parameter in [__]page_table_check_pud[s]_set()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>,
 Ingo Molnar <mingo@kernel.org>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-4-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-4-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtjeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepudegpdhrtghpthhtoheprghjugeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhst
 ghvsehli
 hhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-Rspam-User: 
X-Rspamd-Queue-Id: D719740002
X-Rspamd-Server: rspam06
X-Stat-Signature: dp7byqb83pbni8jc1kkx6yx14tpnewby
X-HE-Tag: 1755164965-262570
X-HE-Meta: U2FsdGVkX1/ml9yxpvCF+bML57l+L7zlAAXY7QffHCKUP6fK3BiAXUHejV3kN75l2c4tJ0Z53zQrKvPJKFpxVp7A6pviRSlV6+dA7xFX8p53JkZCxVwX3bHYzFXvS4FN2ccpcg6yKSRe/Uq2OwaMFsPTwoSlntiFeVHDS2T/UQmZJ00qwqMO/VtwsO4GVipuv0R514QMWRdJhqUp4nL3L7p1MSQQvRRnroAV9poTcxA2SMPSZxKU6e4smKNR9cpBXIBtfMgIpsJyGQZwoU5X3iLY1KTqJGmTvMkdJbh649NcJF3cgdCsAB2Micz8H7OtJMX0IeAxexVUUZDqxFYuOb1JtEIyUCxbhyZgy5zU4SXAKsjolqmYg7oZ96mAlfjGR23Id1Q1Rz4LCPRgT4L3OcZlVZ4RqUsJ228g60zhKOlBM6fU+OAie0M3z1XLdvnbmHVFMOlbZT6lynxCRDWaNviC8m1UHkksWDbVWAvMtiv4AMeLZ01CbCghH1tVMYtrhpX5JF1+mCSvxREfUx4MtAmVgDjjTX3pni1T9BVNEZa8K5VQurmWMIUm1WcCRml5ubduKsQV/zDDdEX8OtYacLLkXAWqaGFWHooDtUbTzKW3RZeYE1CQqHrYh+ICjuKLf5uXZOtS5JzKV3KNfYyLbzw5csUJlbzz3NisDLIfybcMPD4ger5gIm7Gg4SkRLUKrqKuXpJelk0M3rH91JB/IGBXlW9lfBDEBe9AB9ellYC31LPDZ2TEcZXlw2eiMn2MiXtlajkWnikAEMK/iBOLB8JhYyMwtlLujxBQ0ZyGeenBwq1Enmlt/rcHBQ5eHefIbhdJBu7UTWHkgJXAxNW8CK47C+NxwrzWc1lRxgjoGa5QcZrPaL1tAf7C77bQm3Ng
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 8/13/25 08:26, Andrew Donnellan wrote:
> From: Rohan McLure <rmclure@linux.ibm.com>
>
> This reverts commit 6d144436d954 ("mm/page_table_check: remove unused
> parameter in [__]page_table_check_pud_set").
>
> Reinstate previously unused parameters for the purpose of supporting
> powerpc platforms, as many do not encode user/kernel ownership of the
> page in the pte, but instead in the address of the access.
>
> Apply this to __page_table_check_puds_set(), page_table_check_puds_set() and
> the page_table_check_pud_set() wrapper macro.
>
> [ajd@linux.ibm.com: rebase on riscv + arm64 changes, update commit message]
> Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
> v13: remove inaccurate comment on riscv in the commit message
> v14: fix an x86 usage I missed (found by akpm)
> v15: rebase, amend commit message
> ---
>   arch/arm64/include/asm/pgtable.h |  3 ++-
>   arch/riscv/include/asm/pgtable.h |  4 ++--
>   arch/x86/include/asm/pgtable.h   |  4 ++--
>   include/linux/page_table_check.h | 12 ++++++------
>   mm/page_table_check.c            |  4 ++--
>   5 files changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 66b5309fcad8..8070b653c409 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -713,7 +713,8 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
>   		break;
>   #ifndef __PAGETABLE_PMD_FOLDED
>   	case PUD_SIZE:
> -		page_table_check_puds_set(mm, (pud_t *)ptep, pte_pud(pte), nr);
> +		page_table_check_puds_set(mm, addr, (pud_t *)ptep,
> +					  pte_pud(pte), nr);
>   		break;
>   #endif
>   	default:
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 91697fbf1f90..3ed0f5e4879d 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -812,7 +812,7 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
>   static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
>   				pud_t *pudp, pud_t pud)
>   {
> -	page_table_check_pud_set(mm, pudp, pud);
> +	page_table_check_pud_set(mm, addr, pudp, pud);
>   	return __set_pte_at(mm, (pte_t *)pudp, pud_pte(pud));
>   }
>   
> @@ -958,7 +958,7 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
>   static inline pud_t pudp_establish(struct vm_area_struct *vma,
>   				   unsigned long address, pud_t *pudp, pud_t pud)
>   {
> -	page_table_check_pud_set(vma->vm_mm, pudp, pud);
> +	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
>   	return __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
>   }
>   
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index e33df3da6980..0603793acb3a 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1220,7 +1220,7 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
>   static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
>   			      pud_t *pudp, pud_t pud)
>   {
> -	page_table_check_pud_set(mm, pudp, pud);
> +	page_table_check_pud_set(mm, addr, pudp, pud);
>   	native_set_pud(pudp, pud);
>   }
>   
> @@ -1371,7 +1371,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>   static inline pud_t pudp_establish(struct vm_area_struct *vma,
>   		unsigned long address, pud_t *pudp, pud_t pud)
>   {
> -	page_table_check_pud_set(vma->vm_mm, pudp, pud);
> +	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
>   	if (IS_ENABLED(CONFIG_SMP)) {
>   		return xchg(pudp, pud);
>   	} else {
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index 289620d4aad3..0bf18b884a12 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -21,8 +21,8 @@ void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
>   		unsigned int nr);
>   void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
>   		unsigned int nr);
> -void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
> -		unsigned int nr);
> +void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
> +		pud_t *pudp, pud_t pud, unsigned int nr);
>   void __page_table_check_pte_clear_range(struct mm_struct *mm,
>   					unsigned long addr,
>   					pmd_t pmd);
> @@ -86,12 +86,12 @@ static inline void page_table_check_pmds_set(struct mm_struct *mm,
>   }
>   
>   static inline void page_table_check_puds_set(struct mm_struct *mm,
> -		pud_t *pudp, pud_t pud, unsigned int nr)
> +		unsigned long addr, pud_t *pudp, pud_t pud, unsigned int nr)
>   {
>   	if (static_branch_likely(&page_table_check_disabled))
>   		return;
>   
> -	__page_table_check_puds_set(mm, pudp, pud, nr);
> +	__page_table_check_puds_set(mm, addr, pudp, pud, nr);
>   }
>   
>   static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
> @@ -137,7 +137,7 @@ static inline void page_table_check_pmds_set(struct mm_struct *mm,
>   }
>   
>   static inline void page_table_check_puds_set(struct mm_struct *mm,
> -		pud_t *pudp, pud_t pud, unsigned int nr)
> +		unsigned long addr, pud_t *pudp, pud_t pud, unsigned int nr)
>   {
>   }
>   
> @@ -150,6 +150,6 @@ static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
>   #endif /* CONFIG_PAGE_TABLE_CHECK */
>   
>   #define page_table_check_pmd_set(mm, pmdp, pmd)	page_table_check_pmds_set(mm, pmdp, pmd, 1)
> -#define page_table_check_pud_set(mm, pudp, pud)	page_table_check_puds_set(mm, pudp, pud, 1)
> +#define page_table_check_pud_set(mm, addr, pudp, pud)	page_table_check_puds_set(mm, addr, pudp, pud, 1)
>   
>   #endif /* __LINUX_PAGE_TABLE_CHECK_H */
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 4eeca782b888..3c39e4375886 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -236,8 +236,8 @@ void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
>   }
>   EXPORT_SYMBOL(__page_table_check_pmds_set);
>   
> -void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
> -		unsigned int nr)
> +void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
> +		pud_t *pudp, pud_t pud,	unsigned int nr)
>   {
>   	unsigned long stride = PUD_SIZE >> PAGE_SHIFT;
>   	unsigned int i;


Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv

Thanks,

Alex


