Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E77C88E40
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD0A6B0098; Thu, 10 Sep 2026 22:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE176B0099; Thu, 10 Sep 2026 22:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C80D6B009B; Thu, 10 Sep 2026 22:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3BA66B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:29:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FB7D406B3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:29:08 +0000 (UTC)
X-FDA: 85199899176.22.B447DD0
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf20.hostedemail.com (Postfix) with ESMTP id 188D51C0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:29:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2Hvm0k0+;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789093746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKim8kq2UcQv3AdJOy1pzLDJwBHCUlr5VmBNQA75egI=;
	b=aGDRrgkI59VN91i5Yd/LVvFY4YMQmKJnQWH/+ge4hbEbI5hTBD69gYQZESK3CTInieUmMJ
	pdajv9l//PiyLnjC6RWTsPhHYJrVVlx+rac6MPIgmsG6F0eID8J4pPWQdSIDa34hNiuw8i
	cSCeQ3SWC3FEhpt3k5dvNBtlq778PUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789093746;
	b=vfE/wRilB22wutxZD25YlOkyAejfVaNwlw+4nFYlBcfG0lWEInI0V135V+6SBnVhxPRZSW
	V47mt7VvBlLn1lWliHMGaBXg3FFLq2fGDRrmsGJ4ZInf2fQ+PLeZZEVW6YNIp8u2xsJaBX
	3kKbxqMzI9z1J4ncdcWbVyKZFOd4YLE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2Hvm0k0+;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iKim8kq2UcQv3AdJOy1pzLDJwBHCUlr5VmBNQA75egI=;
	b=2Hvm0k0+Seq9+L+MbnBhx642OnRFM63sm2eTVymTB7e/pZzRepOVZG26wJySjv/IjxeLvj40j
	/espzGvsEWLeTqr0HEsiaYsuJmhg0Ygl1G5YVgZXF2Y8KhLV5AUApbHVpXWg8MGL974Y17AdBQo
	BJ6Qa4A9ZXPkGO6bLqotPog=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hgyr16gfqz1prlJ;
	Fri, 11 Sep 2026 10:17:53 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CFE684057A;
	Fri, 11 Sep 2026 10:28:50 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 11 Sep
 2026 10:28:49 +0800
Message-ID: <5cb48654-8d77-4525-9854-5823934ae0e8@huawei.com>
Date: Fri, 11 Sep 2026 10:28:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: define generic pudp_invalidate() implementation
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<mark.rutland@arm.com>, <ryan.roberts@arm.com>, <peterx@redhat.com>,
	<dave.jiang@intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260909090018.1991485-1-tujinjiang@huawei.com>
 <20260909090018.1991485-2-tujinjiang@huawei.com>
 <6fb6b2b8-daae-4707-aa98-c2c447782a44@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <6fb6b2b8-daae-4707-aa98-c2c447782a44@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: rej3o5redacqz46mso7b8hfdetftab44
X-Rspam-User: 
X-Rspamd-Queue-Id: 188D51C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789093743-746892
X-HE-Meta: U2FsdGVkX19CsSUwHHGwa9czt/y26+EluqbdGwwKEwr/y9CEFCaWVQFUK3IJyDvfIYEuO/PjfAmMHAFFxJkZc6gqf/DySyi2cgu9dTpT0s0tuIAKR82/m/pRd7hMLSMh/NRYe8HAo0AEzKJrJ4uAwxdC81mm7W8R/Em60kItP629WLwzjnoHDk6sCkWqH6TwTiVbwMOd61ghgGhy6BSDWiwpmDxJprwUUTf6ZLsHvC606xriRXpUeeb+h00zXpv6cuT86Nv7UbCphBABIqN5nJQ/cNYuFnsP8mLFgASi0MhFIbPYSgjTf6WR3O/isfAeZnHFV+53diX1TbWxrRWqp71jGPxriZlJnAE3gDEXvVsmIUYpOOe8Zmo65pkBg9YwyF3WnttyP3GBXvpwZm/jB93OAYptptvlQUfzol5i6dm9rSXDrX/yO9RgLR3eqeDkbwJwS2aHvU+sniXFkB5BjzmPIx8D7xiY5djv0mqh7iokpDCba3p4bLOQfSY/evo0saCJOYyO0v2LVpCflJVSxjZkkMKqxoc2tc7OZaWHeSbtK1ZOW4+uweYAsv04XTSjl+p+d0AkBBpbpN6rsWat8H0RsN3A62BNSrdS5fAiIfCYyG6Kq95Q3tbHDyGb9gdN0m3950IjIPepJ+voxae0i+Es8gB+zwYhYRttWpyTOrt7LbaenZHa5QOjc7icWC10Pr0A7Hjb2P2Sw154X+ZUjDllyBd5JLxw+6pOVSSGZ5AVubrN6FE+eORtUKDAMKW+8w32cLM83S9+mF+6ZDFbZCpnpKLrRvilIvoAaJvyPrFpI/i/9VfoHaKLGid/zsUfIbvY3TAxiru7v+9q/vIsCRedcBOOqo9CQk0uVS8itZmsVQRi0cf7iTEw40a8Q/fiUq3OiRchNP02od8dVX9T0/yMkDlAIilWkUJglVZQd46S4+zmrEa4Va65gsp6l73m8Orh3w7btlatG8cClYY
 XA2kKtTx
 Pt2sT3I/TTAU1rg5fosjVuc78umBNn4suoPkzYgsRsjFswIiCypDNowfpPdGaQu//Zihdor654Y1ofoXXqqHUxs0tBCf0hgkGM5ll6BNbdvDu7xfLDyM2dtb3rBMOhSr8kjhQwT67B/4tGa3PfnUPNI5vddz8DP8bsPkCk3N2J4INo3aNS0XxSsfmRgMOtuDsewu9iRrySTa7D+F3geRokDBTy6w5y0RnBU1LA2RtRWvLE9gOQp7fi9DWXH6Zxg0xOs1CLXPkOmM+wfUEARrS623gN04KsU2hOsSl9ulKZfdrcdUa5zYIpPJ6klLmO2uQvSPsiQfqgluh1AfYbBcQyeBwO17nRk8T6l7qyp9cBUGgUcpW1K741pPQc/CjKvBTDH9su/UtYRXNOdUrAwRtboQz+Wfgai0jCeuJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/9 18:24, David Hildenbrand (Arm) 写道:
> On 9/9/26 11:00, Jinjiang Tu wrote:
>> x86 and riscv have identical pudp_invalidate() implementations. Move it to
>> mm/pgtable-generic.c with the __HAVE_ARCH_PUDP_INVALIDATE override guard.
>> PowerPC keeps its own implementation. In the later patch, arm64 will use
>> the generic implementation too.
>>
>> No functional change intended.
>>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   arch/powerpc/include/asm/book3s/64/pgtable.h |  1 +
>>   arch/riscv/include/asm/pgtable.h             |  3 ---
>>   arch/riscv/mm/pgtable.c                      |  9 ---------
>>   arch/x86/include/asm/pgtable.h               |  3 ---
>>   arch/x86/mm/pgtable.c                        | 12 ------------
>>   include/linux/pgtable.h                      |  7 +++++++
>>   mm/pgtable-generic.c                         | 14 ++++++++++++++
>>   7 files changed, 22 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> index f4db7d7fbd5c..55d33c5537f1 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -1419,6 +1419,7 @@ static inline pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm,
>>   #define __HAVE_ARCH_PMDP_INVALIDATE
>>   extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
>>   			     pmd_t *pmdp);
>> +#define __HAVE_ARCH_PUDP_INVALIDATE
>>   extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>>   			     pud_t *pudp);
>>   
>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>> index 40b1ed4f3ea8..327fa378032b 100644
>> --- a/arch/riscv/include/asm/pgtable.h
>> +++ b/arch/riscv/include/asm/pgtable.h
>> @@ -1159,9 +1159,6 @@ static inline pud_t pud_mkinvalid(pud_t pud)
>>   	return __pud(pud_val(pud) & ~(_PAGE_PRESENT | _PAGE_PROT_NONE));
>>   }
>>   
>> -extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>> -			     pud_t *pudp);
>> -
>>   static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
>>   {
>>   	return pte_pud(pte_modify(pud_pte(pud), newprot));
>> diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
>> index 9c4427d0b187..156e385e7db4 100644
>> --- a/arch/riscv/mm/pgtable.c
>> +++ b/arch/riscv/mm/pgtable.c
>> @@ -154,15 +154,6 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
>>   	return pmd;
>>   }
>>   
>> -pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>> -		      pud_t *pudp)
>> -{
>> -	VM_WARN_ON_ONCE(!pud_present(*pudp));
>> -	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
>> -
>> -	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
>> -	return old;
>> -}
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>   
>>   pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma)
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index d5f4917c1edc..97051c02385e 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -1387,9 +1387,6 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
>>   extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
>>   				unsigned long address, pmd_t *pmdp);
>>   
>> -pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>> -		      pud_t *pudp);
>> -
>>   /*
>>    * Page table pages are page-aligned.  The lower half of the top
>>    * level is used for userspace and the top half for the kernel.
>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
>> index cb03f5a2b243..0945908631dc 100644
>> --- a/arch/x86/mm/pgtable.c
>> +++ b/arch/x86/mm/pgtable.c
>> @@ -519,18 +519,6 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
>>   }
>>   #endif
>>   
>> -#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
>> -	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
>> -pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>> -		     pud_t *pudp)
>> -{
>> -	VM_WARN_ON_ONCE(!pud_present(*pudp));
>> -	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
>> -	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
>> -	return old;
>> -}
>> -#endif
>> -
>>   /**
>>    * reserve_top_address - Reserve a hole in the top of the kernel address space
>>    * @reserve: Size of hole to reserve
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 8c093c119e5a..32173005b087 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1318,6 +1318,13 @@ extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
>>   				unsigned long address, pmd_t *pmdp);
>>   #endif
>>   
>> +#ifndef __HAVE_ARCH_PUDP_INVALIDATE
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>> +			     pud_t *pudp);
> No "extern" please.

Will update it.

>
> Staring at this file, I do wonder why we are not smarter about combining blocks. E.g., here simply:'

Do you mean merging all #ifdef CONFIG_TRANSPARENT_HUGEPAGE blocks? There are many of them scattered
across include/linux/pgtable.h and arch/arm64/include/asm/pgtable.h. They are intentionally kept
separate to group the PTE, PMD, and PUD level variants of the same operation together. For example,
ptep_set_access_flags, pmdp_set_access_flags, and pudp_set_access_flags are placed adjacently.

>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e3c8ab96941c5..8c9fe3bf580d4 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1229,9 +1229,9 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
>   }
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   #endif
> -#ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
> -#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +#ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
>   static inline void pudp_set_wrprotect(struct mm_struct *mm,
>                                        unsigned long address, pud_t *pudp)
>   {
> @@ -1245,9 +1245,13 @@ static inline void pudp_set_wrprotect(struct mm_struct *mm,
>   {
>          BUILD_BUG();
>   }
> -#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> -#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>   #endif
> +#ifndef __HAVE_ARCH_PUDP_INVALIDATE
> +pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
> +               pud_t *pudp);
> +#endif
> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> +#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
>> +#endif
>> +#endif
>> +
>>   #ifndef __HAVE_ARCH_PTE_SAME
>>   static inline int pte_same(pte_t pte_a, pte_t pte_b)
>>   {
>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index b91b1a98029c..ac1175d9a59a 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -217,6 +217,20 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
>>   }
>>   #endif
>>   
>> +#ifndef __HAVE_ARCH_PUDP_INVALIDATE
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> I'd revert these and similarly see if they can be combined somehow (likely combining with
> pudp_huge_clear_flush is harder as we are quite inconsistent with it, gluing it to
> __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH).
>
> Which raises the question whether we could also piggy-back on __HAVE_ARCH_PMDP_SET_WRPROTECT
> (I suspect no without a closer look.)
>

