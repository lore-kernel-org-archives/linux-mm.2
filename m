Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4934BCA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2835900150; Thu, 14 Aug 2025 08:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD295900023; Thu, 14 Aug 2025 08:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FCF900150; Thu, 14 Aug 2025 08:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7E6900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:11:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CA30140633
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:11:52 +0000 (UTC)
X-FDA: 83775249264.09.8DBB0EC
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE570140005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:11:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755173510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7HALERGN5G1JxCktbFRVEITsXgQmzqpouuUe3GDuCw=;
	b=tJNRrfhOBAnkRag+KCiPEJG1UnMJCT3wtNhlW33/F66/ERpTRCY3CTgt6B8gqUulrhapFp
	K2l4jJS2jaOxb7lMbs7vrycQIupp01a9Kjuf7+WOQ9H5azgv8wBWZ1yTiiAbFrNc46NvoF
	8ZmorwUT7grDuPjUjEjFiRX+WAs7t4s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755173510; a=rsa-sha256;
	cv=none;
	b=5F/cTS/IZh0hTlCpCOean3lalFkAB1m7Rn6Jo5XvCR1zc2F30ZzHQBPnIoY17LZAr/8TlH
	lN2r224x0teyjqGP5rTN6AXpzNux+gCF6X7nc8KEuxzEFoUJfRnSJ07cNnI0IVPa1y+L+n
	TaAbsHci3y5pRbnYQjiO9wy7RFXdXWI=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0E68F2059F;
	Thu, 14 Aug 2025 12:11:45 +0000 (UTC)
Message-ID: <5aa057d0-dc76-4723-80d1-82065320a428@ghiti.fr>
Date: Thu, 14 Aug 2025 14:11:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 06/13] mm/page_table_check: Reinstate address
 parameter in [__]page_table_check_pud_clear()
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, Rohan McLure <rmclure@linux.ibm.com>,
 Ingo Molnar <mingo@kernel.org>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
 <20250813062614.51759-7-ajd@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250813062614.51759-7-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedutdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpefhhfdutdevgeelgeegfeeltdduhfduledvteduhfegffffiefggfektefhjedujeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeduleefrdeffedrheejrdduleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepudelfedrfeefrdehjedrudelledphhgvlhhopegludelvddrudeikedrvddvrddutddungdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopedugedprhgtphhtthhopegrjhgusehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheplhhinhhugihpphgtqdguvghvsehlihhsthhsrdhoiihlrggsshdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhor
 hhgpdhrt
 ghpthhtoheplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE570140005
X-Stat-Signature: 8uqjwpuhmyyn7z99ypaf6o99okbqp7zr
X-Rspam-User: 
X-HE-Tag: 1755173509-314490
X-HE-Meta: U2FsdGVkX18r9YGto480qp556S2bavNyWtIzmX531WLRfAaOUIx5fjDY3jkbUD5t3PaAGD4bLXij02/75Xg/R+3k2uWJF+HgkLdOJqSZwXDHntx+ITfKnyfIkVCcXjS6w3sA6ETRtOaCAPChQpcXA2zd+eg80B0bKdF/tzuWBi/wj4sWXPadan+IWvM6nmcTw/yO762IrYarpKruTpEK0ZU+IsgK+tP6v6CyHENZw86k4kRjarKzLHNe2TALvmaF2Mmf5A3dZnRIJxrOs6Bt4YsEXur9btrWMMtqk1eFano5tEOplC74txZ2lqPXsxqwjNuEeUyd/rUPOCfs8YCC7y1v0/WbJYWjEbZkOLQ0Os5y9zNgAyd3QfqAkNAr3Zfv4vAiwnuKKmZigIrs9EAIz3nceRnrq3QxZWNpRKxfMKpNgLlnJ7AAQW84msl9pzER28514rUO/8/xcpXn2GzaHZC3yGNcTP1MQrk/iwaSIi2zc+6XtBvqhLD1el9LPMilwNwfJoJYK2g5wmWCAGzes1XUJkxs1YwouD7DLMKb6IulOZiL/JQ/RCh/dqgL7mPEuar1oRUbE35ueJNZBeV0dqLulwG47TGtnYrXBPP+blGMloeZWFGi34E4qD2ovli+bgBDfXXwi1Vn48K9JJsUcTTCQJgJEWowaTEXN+SXlxV4GNx/KqZjcEh9aT3R7W78edIWD4AQH3u3MFG3am83OQR9Iv+IhJsnNwgD8wI6Qj1POsHkkI24nuILWnnVGbYCDsNdiCmzVs6emXr4WZ1opfEpztsETJZIDyL0HpFbzs2OnzBxOqsTaYS9wY3Sf55BRSt4+km1J+KSwKOxEDZyqCshiv8S3Vq/rtHxSQqzjDhahxJzRHfj2fXswoNc8Dy3CJfpgWngfIKh2tWKIrx3wYO3aVb2ykl628FjOkrmvkwGtB46+hhJiavvqb4udpi3ddLxIBetNFPh0fyDPz0
 mfiyoNAR
 QKa3Muv2LP2qggQI3f1szkuoiMU+Osi8qPvcINRUC/kD2xRR9clf9b+8wCx6ZZsdOg+XmbDotrCpNfCREU8Xd58Z6yjjWwE6Tl7SJcCxM3G4NmmXMCWtYvAZyLlogR9+9R3zPdu+fpivLlkx6FTsonOkGZR0wZ5yzo3l71vl0ZZ1iRmg2nO9358iU6nZmOocfljGofnCyZgdU0ZZ9pTialNZ7TzX1nVd4jOy2pbN9Cs++fWZpApBI5o4Ck0BlzTGZVpiAYMzH1/rsyOyDw59yAKQuWMxQdCyfw0VRgQs435huguEatH1BeiIeBA==
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
> This reverts commit 931c38e16499 ("mm/page_table_check: remove unused
> parameter in [__]page_table_check_pud_clear").
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
>   arch/x86/include/asm/pgtable.h   |  2 +-
>   include/linux/page_table_check.h | 11 +++++++----
>   include/linux/pgtable.h          |  2 +-
>   mm/page_table_check.c            |  5 +++--
>   5 files changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 06ea6a4f300b..81f06e5e32b2 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1374,7 +1374,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>   		break;
>   #ifndef __PAGETABLE_PMD_FOLDED
>   	case PUD_SIZE:
> -		page_table_check_pud_clear(mm, pte_pud(pte));
> +		page_table_check_pud_clear(mm, address, pte_pud(pte));
>   		break;
>   #endif
>   	default:
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 8ee301b16b50..8b45e0c41923 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1329,7 +1329,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
>   {
>   	pud_t pud = native_pudp_get_and_clear(pudp);
>   
> -	page_table_check_pud_clear(mm, pud);
> +	page_table_check_pud_clear(mm, addr, pud);
>   
>   	return pud;
>   }
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index 66e109238416..808cc3a48c28 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -16,7 +16,8 @@ extern struct page_ext_operations page_table_check_ops;
>   void __page_table_check_zero(struct page *page, unsigned int order);
>   void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
>   void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
> -void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
> +void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
> +				  pud_t pud);
>   void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
>   		pte_t *ptep, pte_t pte, unsigned int nr);
>   void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
> @@ -59,12 +60,13 @@ static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
>   	__page_table_check_pmd_clear(mm, pmd);
>   }
>   
> -static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
> +static inline void page_table_check_pud_clear(struct mm_struct *mm,
> +					      unsigned long addr, pud_t pud)
>   {
>   	if (static_branch_likely(&page_table_check_disabled))
>   		return;
>   
> -	__page_table_check_pud_clear(mm, pud);
> +	__page_table_check_pud_clear(mm, addr, pud);
>   }
>   
>   static inline void page_table_check_ptes_set(struct mm_struct *mm,
> @@ -123,7 +125,8 @@ static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
>   {
>   }
>   
> -static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
> +static inline void page_table_check_pud_clear(struct mm_struct *mm,
> +					      unsigned long addr, pud_t pud)
>   {
>   }
>   
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8aab3fa19c85..28fcff844b63 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -661,7 +661,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
>   	pud_t pud = *pudp;
>   
>   	pud_clear(pudp);
> -	page_table_check_pud_clear(mm, pud);
> +	page_table_check_pud_clear(mm, address, pud);
>   
>   	return pud;
>   }
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 0957767a2940..bd1242087a35 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -167,7 +167,8 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
>   }
>   EXPORT_SYMBOL(__page_table_check_pmd_clear);
>   
> -void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
> +void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
> +				  pud_t pud)
>   {
>   	if (&init_mm == mm)
>   		return;
> @@ -246,7 +247,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
>   		return;
>   
>   	for (i = 0; i < nr; i++)
> -		__page_table_check_pud_clear(mm, *(pudp + i));
> +		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
>   	if (pud_user_accessible_page(pud))
>   		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
>   }


So this made me realize we (riscv) did not implement 
pudp_huge_get_and_clear(), which was a mistake since we support THP PUD. 
I have implemented this function in this patch 
https://lore.kernel.org/all/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com/T/#u

That's a fix so I'll merge it in 6.17 (at least I'll try) so your 
patchset will break the build on riscv, I'll keep you posted when it 
gets merged!

Thanks,

Alex


