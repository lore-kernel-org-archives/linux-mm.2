Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12539CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4783900125; Thu, 14 Aug 2025 05:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F1B900121; Thu, 14 Aug 2025 05:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C26900125; Thu, 14 Aug 2025 05:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84A70900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:50:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34250138298
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:44 +0000 (UTC)
X-FDA: 83774893608.21.FAFF609
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3637340004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755165042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIlwYQni2qIIwnM0SIVj/CB1fG/A16BlOaqLFYL53f8=;
	b=WA3gyGBbVtFU4kiHUaskrIFy0GHZOSyYAQBcrnSfEorD++P0h11C3iYqXQah0PhRHhJick
	SJodte7nyKHP5/t+gXU483QZZvKbxHn8xj85gDroi0OZT1fVEoRQ6jaSc2+yMLB2QRTGNI
	lBFoGV3hLETcEmK2LYQmFfqmtOTMCik=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755165042; a=rsa-sha256;
	cv=none;
	b=Ua5M3KNX1hb0frUKOCPkcvggWaRSqBtSaWtqcltzDRpV7DRdmXvczA7KYOoO2HtOGREQyQ
	Vrwi/4594O0HwIMAKtCMUC6mUj8B+iMHZvmGhVmHw5RAB9e8VcNig/18YSPJXKhGdcQeI0
	nzh1+KwqHXfpW4OcTucQyiJi1bmwbZE=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8036443391;
	Thu, 14 Aug 2025 09:50:37 +0000 (UTC)
Message-ID: <1a7d8550-127a-4f72-8b20-5d5898d0a5ef@ghiti.fr>
Date: Thu, 14 Aug 2025 11:50:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/13] mm/page_table_check: Provide addr parameter to
 page_table_check_ptes_set()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-6-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-6-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtjeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepudefpdhrtghpthhtoheprghjugeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhst
 ghvsehli
 hhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr
X-Stat-Signature: qcimwdnn8chtqw8hghitjjtsyrbw3czh
X-Rspam-User: 
X-Rspamd-Queue-Id: 3637340004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755165042-863567
X-HE-Meta: U2FsdGVkX19P5g8cWR+UsES4oTAL7Rb2jXItyaznmQeK0Jc07IBbxP4RPnm2o5103KV8mmxxX/jEGVgxcwWu2c1sRbRSgHNDdv0qm+QH65HtCDn78c5UHvryU27C8QZubhj3w6d0iPhLL+KzMpa0OOSjfE4WkpGeldyZrhkNeT3wnv2IS9zwWu7cfyujwexpyCeovhyAfNHBwAy54ZL2LVhLhrCt383PlGzVbddc7HgUgCwTVRt8DQDvqt5mDs/vhoDMZFucu7ipltfySd18LPkYtr+1IDHIJaU8rc9o/6s7h7utk4jY7bujjW6xuEgm0lMlxAyDQw5cusZf00e46dCHzpztFJwUiYMHEy7jyDuZQmZAdenfQFPLBXJebL9fxsLsnC0Ut02Y4BdLMPB1/3FzfdJjRUjFe2sZWiBIAJRliXCulv+w/DZ3EL/jjs1rzAGVzGZdo5H987CN5rIQe5PsmiyecjIsp8naRY5lI4xgT8VwRpfc31kKAbTV+EkIpzbkzBaISpOXLr5LLNMDY2JZszqWwpp+TLf33cwfoLkVqKW88fB/8vJjheO8O082HS+G7MG8jGiuBOLoBj6w6B26mBQpGS2D4P/c2CCWyL9l0qtf6JCYyPB35QFoBnVTfrUi95mPPyR3sjp8Xl/nVrZma2D7qDh8LHSku5VrtXcvYweelShgow8hhWTJl7H8smHmGmh0QCA9RAqgI8UIgrEqDvGSRSZ/RZSR2DUZ6hg3UWuMlIUUOf9NYh+fzVICCRyDr6ZajKkm38p5cBZ8xyAhVLOL6SMylxEHYsAdQIxWNj9lz2mIIMS5HJdEbEi6oDtAq4sHYoET7q67jwnStqQ+9dZS9xsPLuaRi5Izn6b0h3GclxZvbQRo41FcnKS6qI3GAOE0NiQq6/l8c7VhSxFiBp4nRrAk5V/6FJsUOrUldVcmRH1snOYQuXLsF1ya/WduyjwHE1+e/0ZOGxn
 XICyNeZ7
 DhooflzMJ6GP5XalpFUkhXmzimjov6hdlDZdLCpJuX0JZAKGHqOD3icxujaa51+4C0c4anfo7AsxZUinTMKqhSLRh2Lw0h1uycHZ9j48t3OOXyayhmU95KfGDfx4qsv7T93bPaJKuwQL7vo5d+E935rPi5Qe79Lr/+3C59Ru0Doj6bUscd94kLjUzjbvBvy0zr/y9JM3iBfPC3yilVzgQk3a2EF9rvnKHPdzgsxkTJgxzDm3zGsrllgnZukjQAtughtlI1NAgibiq/GJZMLcLH45gwQ==
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
> To provide support for powerpc platforms, provide an addr parameter to
> the __page_table_check_ptes_set() and page_table_check_ptes_set() routines.
> This parameter is needed on some powerpc platforms which do not encode whether
> a mapping is for user or kernel in the pte. On such platforms, this can be
> inferred from the addr parameter.
>
> [ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
> Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
> v15: rebase, amend commit message
> ---
>   arch/arm64/include/asm/pgtable.h |  2 +-
>   arch/riscv/include/asm/pgtable.h |  2 +-
>   include/linux/page_table_check.h | 12 +++++++-----
>   include/linux/pgtable.h          |  2 +-
>   mm/page_table_check.c            |  4 ++--
>   5 files changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 9fe3af8b4cad..06ea6a4f300b 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -706,7 +706,7 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
>   
>   	switch (pgsize) {
>   	case PAGE_SIZE:
> -		page_table_check_ptes_set(mm, ptep, pte, nr);
> +		page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>   		break;
>   	case PMD_SIZE:
>   		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 6e8c3d19f96a..2484c0788012 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -560,7 +560,7 @@ static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
>   static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>   		pte_t *ptep, pte_t pteval, unsigned int nr)
>   {
> -	page_table_check_ptes_set(mm, ptep, pteval, nr);
> +	page_table_check_ptes_set(mm, addr, ptep, pteval, nr);
>   
>   	for (;;) {
>   		__set_pte_at(mm, ptep, pteval);
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index cf7c28d8d468..66e109238416 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -17,8 +17,8 @@ void __page_table_check_zero(struct page *page, unsigned int order);
>   void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
>   void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
>   void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
> -void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
> -		unsigned int nr);
> +void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
> +		pte_t *ptep, pte_t pte, unsigned int nr);
>   void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
>   		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
>   void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
> @@ -68,12 +68,13 @@ static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
>   }
>   
>   static inline void page_table_check_ptes_set(struct mm_struct *mm,
> -		pte_t *ptep, pte_t pte, unsigned int nr)
> +					     unsigned long addr, pte_t *ptep,
> +					     pte_t pte, unsigned int nr)
>   {
>   	if (static_branch_likely(&page_table_check_disabled))
>   		return;
>   
> -	__page_table_check_ptes_set(mm, ptep, pte, nr);
> +	__page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>   }
>   
>   static inline void page_table_check_pmds_set(struct mm_struct *mm,
> @@ -127,7 +128,8 @@ static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
>   }
>   
>   static inline void page_table_check_ptes_set(struct mm_struct *mm,
> -		pte_t *ptep, pte_t pte, unsigned int nr)
> +					     unsigned long addr, pte_t *ptep,
> +					     pte_t pte, unsigned int nr)
>   {
>   }
>   
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 4c035637eeb7..8aab3fa19c85 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -289,7 +289,7 @@ static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
>   static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>   		pte_t *ptep, pte_t pte, unsigned int nr)
>   {
> -	page_table_check_ptes_set(mm, ptep, pte, nr);
> +	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>   
>   	for (;;) {
>   		set_pte(ptep, pte);
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 09258f2ad93f..0957767a2940 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -193,8 +193,8 @@ static inline void page_table_check_pte_flags(pte_t pte)
>   		WARN_ON_ONCE(swap_cached_writable(pte_to_swp_entry(pte)));
>   }
>   
> -void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
> -		unsigned int nr)
> +void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
> +				 pte_t *ptep, pte_t pte, unsigned int nr)
>   {
>   	unsigned int i;
>   

Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv

Thanks,

Alex


