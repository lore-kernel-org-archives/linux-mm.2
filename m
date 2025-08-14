Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B220DCA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2F0900127; Thu, 14 Aug 2025 06:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB14900121; Thu, 14 Aug 2025 06:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30820900127; Thu, 14 Aug 2025 06:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4F6900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:00:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99324117947
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:00:23 +0000 (UTC)
X-FDA: 83774917926.24.8FD27E6
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC2178001B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:00:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.199 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755165622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AFXCAHPRQumX4StFM3HBjOpTzzyNsm4CK0xTxitAPM=;
	b=uwqgnOQ+iqcocjA7zE/gFdvoga9lm1tPKSFT2OpTY+C0Izv8kTCMI4noG0Yk+TTWDMz/rZ
	Pkq/y0KU6ykGwJGB8J+n1By5Pz85eyNYohHhU+786QOLG0UPoK6z2O3MBFW5o1TqsA+b3f
	PnaV0gGEpmZMUzDOUJGghtxI8OtRbTY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.199 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755165622; a=rsa-sha256;
	cv=none;
	b=0L24HsOHN16AkiJbIUGvuNmnRpeyQlqBoZ0tr2vTbHikhjVNd3ltWHvcjkM2DEIDcjhqf/
	Mo2njeykpWKzPNYLck9gqLFfaTafb8Ia3hYTU7kMpjF3gVbey7kvf5DBJmSJtAGRYSUbW4
	D/tJeUniTPm1BcJcc57tvyXbbcljnh4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1C73B432BC;
	Thu, 14 Aug 2025 10:00:16 +0000 (UTC)
Message-ID: <10fd7e8b-90ae-40e7-836a-23aedcafc822@ghiti.fr>
Date: Thu, 14 Aug 2025 12:00:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 08/13] mm/page_table_check: Reinstate address
 parameter in [__]page_table_check_pte_clear()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>,
 Ingo Molnar <mingo@kernel.org>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-9-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-9-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepudegpdhrtghpthhtoheprghjugeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhst
 ghvsehli
 hhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr
X-Rspam-User: 
X-Rspamd-Queue-Id: BC2178001B
X-Rspamd-Server: rspam06
X-Stat-Signature: g385yshz9c7yfzi9r6bdrsq43tcanjks
X-HE-Tag: 1755165621-128470
X-HE-Meta: U2FsdGVkX1/hIGorH73yUeJ+SupFK8kzaAY8Dow8Q72WKus/h4BRtfYsUlrRfW2Ajm864V9qoORBMIEJrScwJd5OJNM2il892f3a+4urxM8mmjKsQ2BGjl+/JJtlLEZm4ahajECougHl2vIye8Gi37j6Jj2VsHFcET41ol09E+AmRso1asMbLPt5sUwdvYpRtJF2ZMWjv25wu8Iyl2a9kOza7m0cpvHo5l1ePJDHWrMdXxVpO3AA2H2kOzQ7CM3kmm91jFS/wBCS7IgHREqRnALlKspN704Y9FaE6ZC4S3e4K+B9b31sYmU+2J7wqKTrGUf/6g9dy77RDpVmUzEfnR+aIbSELjilBjHtEsQb6e6Eimf3Jn4dmWRebhVyMSlOLAalCreccOQVXrujBwSVnz4Hc5IwpL8sMxvBi07TjG/UjaX7hTBXIemLLR4LUH+gSGoAyqkSMwtfEvC0JFGYok2CBlvIhKRxB52X6bkRula2gVQxxEMQ9+KNiOrowzU82wogJNlp9z7Q2q9uja+BpHRM4Jj1UzvHjA4QvlsEAmSySUkjdXuluPZvvAGkn/Gf2xtpHIu1bCviV5m4g8uVTvtS/7XXYEWHpo9mlwxlGSdpre4DZ3e+ujDg/lqPqBcch7cAhcgNbLQDF+U+z6phc5dr+ZqBOuqTtxUeCOTjH+9F4Pp03Nbs6CrSI2925gG5Z4G5djPv+a/4Ya7+NYx/EOQBWzG+ePZ/DfO4Bjvphw0XEDXA6IBrqpqa4VfhhPDRBjXwl+W/BDv7r/s6dyvpAYpK11r9Wet71nNZPI5RKFF7gxWYz8gBUJ1LQXHIqOWGlLGIvOIzaSqOif8o3I9s1V+YrzF6Hu9lQ78giiJZKb/kZRaPvg19JueRswHf9SErabjgWt3S5SA=
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
> This reverts commit aa232204c468 ("mm/page_table_check: remove unused
> parameter in [__]page_table_check_pte_clear").
>
> Reinstate previously unused parameters for the purpose of supporting
> powerpc platforms, as many do not encode user/kernel ownership of the
> page in the pte, but instead in the address of the access.
>
> [ajd@linux.ibm.com: rebase, fix additional occurrence and loop handling]
> Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
> v13: fix an additional occurrence
> v15: rebase, fix loop handling
> ---
>   arch/arm64/include/asm/pgtable.h |  2 +-
>   arch/riscv/include/asm/pgtable.h |  2 +-
>   arch/x86/include/asm/pgtable.h   |  4 ++--
>   include/linux/page_table_check.h | 11 +++++++----
>   include/linux/pgtable.h          |  4 ++--
>   mm/page_table_check.c            |  7 ++++---
>   6 files changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index dfcdf051b114..2203ebac81d9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1367,7 +1367,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>   
>   	switch (pgsize) {
>   	case PAGE_SIZE:
> -		page_table_check_pte_clear(mm, pte);
> +		page_table_check_pte_clear(mm, address, pte);
>   		break;
>   	case PMD_SIZE:
>   		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index d11fc6333606..d60e1604852d 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -591,7 +591,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>   {
>   	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
>   
> -	page_table_check_pte_clear(mm, pte);
> +	page_table_check_pte_clear(mm, address, pte);
>   
>   	return pte;
>   }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index b68bea15f32d..63350b76c0c6 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1251,7 +1251,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
>   				       pte_t *ptep)
>   {
>   	pte_t pte = native_ptep_get_and_clear(ptep);
> -	page_table_check_pte_clear(mm, pte);
> +	page_table_check_pte_clear(mm, addr, pte);
>   	return pte;
>   }
>   
> @@ -1267,7 +1267,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>   		 * care about updates and native needs no locking
>   		 */
>   		pte = native_local_ptep_get_and_clear(ptep);
> -		page_table_check_pte_clear(mm, pte);
> +		page_table_check_pte_clear(mm, addr, pte);
>   	} else {
>   		pte = ptep_get_and_clear(mm, addr, ptep);
>   	}
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index 3973b69ae294..12268a32e8be 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -14,7 +14,8 @@ extern struct static_key_true page_table_check_disabled;
>   extern struct page_ext_operations page_table_check_ops;
>   
>   void __page_table_check_zero(struct page *page, unsigned int order);
> -void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
> +void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
> +				  pte_t pte);
>   void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
>   				  pmd_t pmd);
>   void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
> @@ -45,12 +46,13 @@ static inline void page_table_check_free(struct page *page, unsigned int order)
>   	__page_table_check_zero(page, order);
>   }
>   
> -static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
> +static inline void page_table_check_pte_clear(struct mm_struct *mm,
> +					      unsigned long addr, pte_t pte)
>   {
>   	if (static_branch_likely(&page_table_check_disabled))
>   		return;
>   
> -	__page_table_check_pte_clear(mm, pte);
> +	__page_table_check_pte_clear(mm, addr, pte);
>   }
>   
>   static inline void page_table_check_pmd_clear(struct mm_struct *mm,
> @@ -119,7 +121,8 @@ static inline void page_table_check_free(struct page *page, unsigned int order)
>   {
>   }
>   
> -static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
> +static inline void page_table_check_pte_clear(struct mm_struct *mm,
> +					      unsigned long addr, pte_t pte)
>   {
>   }
>   
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index d97f40f1365d..c85e0e1c1f97 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -494,7 +494,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>   {
>   	pte_t pte = ptep_get(ptep);
>   	pte_clear(mm, address, ptep);
> -	page_table_check_pte_clear(mm, pte);
> +	page_table_check_pte_clear(mm, address, pte);
>   	return pte;
>   }
>   #endif
> @@ -553,7 +553,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
>   	 * No need for ptep_get_and_clear(): page table check doesn't care about
>   	 * any bits that could have been set by HW concurrently.
>   	 */
> -	page_table_check_pte_clear(mm, pte);
> +	page_table_check_pte_clear(mm, addr, pte);
>   }
>   
>   #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index e8c26b616aed..1c33439b9c0b 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -145,7 +145,8 @@ void __page_table_check_zero(struct page *page, unsigned int order)
>   	rcu_read_unlock();
>   }
>   
> -void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
> +void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
> +				  pte_t pte)
>   {
>   	if (&init_mm == mm)
>   		return;
> @@ -206,7 +207,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
>   	page_table_check_pte_flags(pte);
>   
>   	for (i = 0; i < nr; i++)
> -		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
> +		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
>   	if (pte_user_accessible_page(pte))
>   		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
>   }
> @@ -268,7 +269,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
>   		if (WARN_ON(!ptep))
>   			return;
>   		for (i = 0; i < PTRS_PER_PTE; i++) {
> -			__page_table_check_pte_clear(mm, ptep_get(ptep));
> +			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
>   			addr += PAGE_SIZE;
>   			ptep++;
>   		}


Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv

Thanks,

Alex


