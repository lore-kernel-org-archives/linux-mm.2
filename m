Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FE3CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757FE6B0096; Wed, 14 Oct 2026 05:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F826B009B; Wed, 14 Oct 2026 05:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E066B009D; Wed, 14 Oct 2026 05:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3395A6B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:01:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE54C14042A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:01:13 +0000 (UTC)
X-FDA: 85320637626.10.8A39D02
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id D792A10000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:01:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pQFtufiM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791968472;
	b=gZKOb86/bGNg3ahv4D0LCV74gegd1vbUoU915eNTSDTnvSzHex48NhsoO/DPi2WVuQVY3m
	Yxo9k+DI9drFMA+CFT3WfM1fMwO1uNfflRodtVM3S0Mz1MMvbRyrNTHcsoai0nTpE9Swhq
	JELHCaedV6zvrNXMC9SPxhKaSHnhp8g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pQFtufiM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791968472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6d1ZGliYPhieSuvjGZO3kxTg3x67TSdLveb34MEzAE=;
	b=R3XffFEKlPOF+dxekCa65u0p4uMstKALv2fLcKJdeLN+50h+CfqqX/nIDh2rEUaHGtOJ1w
	WiTDfTwmrUgYJiNR59zJ0GlWYLu+6QaIs2yexQkWXHAh9BxjYmd33SuyI+jwo02Kz2gQdd
	9OMQ6Xhv3dEb8Tw4fAEGhvftQEnq9ns=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 865661596;
	Wed, 14 Oct 2026 02:01:07 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9B7A3F7B4;
	Wed, 14 Oct 2026 02:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791968470; bh=rara4mkQth8pYyWlFJvWmDaJu5z0cXsBOp7HoWDPrJE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pQFtufiMGehtJM9AcAsnwXLGqTJECDqjyuBHqaMUB/gJ0L3WUOI5EUTEsk2dHjdsf
	 R99tb64LVgVWafMjWaPf3mdnd4dVDS58qabNcRdPk/FvmuqeNwUiGSRcWLC3RtnKhS
	 UFcMMAZVO7L2zOSVKereOgmlQX/zL1pbdiQBv3Ng=
Message-ID: <e0354457-8ca4-474d-b8cc-0ba843be8897@arm.com>
Date: Wed, 14 Oct 2026 14:31:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/10] arm64/mm: add pte_set_huge() and
 pte_clear_huge()
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
 chleroy@kernel.org, david@kernel.org, jiangwen6@xiaomi.com, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-2-jiangwen6@xiaomi.com>
 <7b3c3a39-4cf3-430d-9fd3-ba83e5175e72@arm.com>
 <CAHKocdFOoDhjcuWXJatQ-AbSXyXuV+Q=sA1-iGiGrp7vhHZMBQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAHKocdFOoDhjcuWXJatQ-AbSXyXuV+Q=sA1-iGiGrp7vhHZMBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hod5m81g1d1a8efskgn4osjb65jwoo8a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D792A10000A
X-HE-Tag: 1791968471-196398
X-HE-Meta: U2FsdGVkX19Jkr17Y8d5tbIe0TjrPR404Ft/fmIFPWgFpbYu8UYjoSiYrcy8CUWrYeOgaJlxVL9v8YkWrx2RlBOv66TE6j28YUg6W/SCjJuglRgffDmuvZRoo4KAYg8p6IozaG/+IWVQ6pTBpANBdURSl33zxpqt6XMeAMkcVT2FJ21qUAOiZ5LSAARuB4DPuSyUGPi6x5PlXa7vN5DdblEd4B3pQoIORvuwNlLN6JafWGGsXQFvQRWT3EIaUGZGzqUoqLK08ZS51J4CAurssUBrCnHIdswVeAnGflM3Si1mFFlawGHNCpn7m9WfzUB4JrIiMvIL9q1bdrLb3xS7WtlGsi0w8XYApNQTn7JzIrRnEh4VZhfwhcGt8AcDmpU36iT4gl+57vusUKi3zcPTq5Zfw+X8l0CDTt4wMvvdrpomHCngdjrpgxpm2fdMDRF0peLS0WOXT9Mcr9AgGyXQPfw00DCv71e7JpeMd9j/ekWSGDhoOMpaoBWxU9lNS5Ku+M60DO77PLhB3qDcHsrDAJjc18JoF1WHj009l6EAePXMnV8CUSG056SqUWpB84KpAXL9DPjmn2QbxykynEGPguUk/tr3e3FDlxmZA/v8EcWjJF0rg/sJpQ3trXtBxqomToMXb18+J2djq9qsM176W4Zp3vsqibpIUEjHgB6QrppVjq2clKC43e9IaZYTgCVkuqTAu3rlqnWSwRq0K2qI6ulxtA3Lxlsa8BfGSGi5VC3IrLKlPjdp5/SJ6R0+kjqSh/18EocAURXNV/zwbihTvaE/QDxee32m2YFJouTG1484JsJz+o28A00hbyWwbIlIQwcKzY3XSkx3689svFG7qZfcF6YNC+F2kcGBnt3rD2WOymBRdA7o1cg+zjHYdo9XrjrS3cOypg6EUd6mRLWvHTVbpNIL33rmCSPHe8W6ET1QC5n4glrMiVfstomyDxgKyw18i+PDQarPW/nWqK1
 wKqTddSh
 ZsGVJvorvSOhSYUXmqXOF6Hoy+H8OfpPBDZitx1t9oeBeDUGiE3xN0T3n0Ua4K0PKWyO5pawhwuohv2AsYjUgey7iFNoW5CzkAETmDbRPaSeOhYrHvHXrZ0T/KAxW6USJRmXF2Arspt6NSourFPBxnLUncH52QXWItkgtstflmVio0L6s5QyBCTuBFBtGGghyUdOBs3bB9G1hpxBJdoK2MGzSHDK8VO/SmjOUNqqBIFMv12R5Qp9sFLphq2xAhgkvfO3izPb4HHGDlbBrblwBPpY7d350RTJeGZik+tPpAKMVewkUv38UGypWuCkm4gEHctR7eIiAnr6wgZDzh+UOvsIqViPpf0Un1lPn4ZX/InguPBJahqXcCuyGPkUsox93Ibc0W0qyznHxf4QaSbizZIh2eLbw8ZQvrfShV9NvNcLjdQbAc7Nssca7u44mrbNS4XE/FAox7VFFJMew6H0i5VOMWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/10/26 2:16 pm, Wen Jiang wrote:
> On Wed, 14 Oct 2026 at 14:03, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 02/10/26 2:39 pm, Wen Jiang wrote:
>>> vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
>>> set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
>>> helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
>>> unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
>>> HugeTLB internals it does not otherwise need.
>>>
>>> Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
>>> pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
>>> __set_ptes() and __get_and_clear_full_ptes() directly, so they do not
>>> depend on CONFIG_HUGETLB_PAGE.
>>>
>>> There is no caller yet: mm/vmalloc.c is converted later in this series,
>>> once the generic fallbacks are in place.
>>>
>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>> Reviewed-by: Barry Song <baohua@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h |  6 ++++++
>>>  arch/arm64/mm/mmu.c              | 23 +++++++++++++++++++++++
>>>  2 files changed, 29 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 6000905a2e865..9b762eb68cff0 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -1978,6 +1978,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
>>>
>>>  #endif /* CONFIG_ARM64_CONTPTE */
>>>
>>> +#define __HAVE_ARCH_PTE_SET_HUGE
>>> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
>>> +               pgprot_t prot, unsigned long size);
>>> +#define __HAVE_ARCH_PTE_CLEAR_HUGE
>>> +pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
>>> +
>>>  #endif /* !__ASSEMBLER__ */
>>>
>>>  #endif /* __ASM_PGTABLE_H */
>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index 79d90226fd5dc..ae2f15618c97d 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -1912,6 +1912,29 @@ int pmd_clear_huge(pmd_t *pmdp)
>>>       return 1;
>>>  }
>>>
>>> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
>>> +               pgprot_t prot, unsigned long size)
>>> +{
>>> +     unsigned long pfn = __phys_to_pfn(phys);
>>> +     pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
>>> +     unsigned int nr = size >> PAGE_SHIFT;
>>> +
>>> +     VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
>>> +     VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
>>> +     VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
>>> +
>>> +     /* For vmap, there is no valid -> valid transition */
>>> +     VM_WARN_ON(pte_valid(__ptep_get(ptep)));
>>> +
>>> +     __set_ptes(&init_mm, addr, ptep, pte, nr);
>>> +}
>>> +
>>> +pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
>>> +{
>>> +     return __get_and_clear_full_ptes(&init_mm, addr, ptep,
>>> +                                      size >> PAGE_SHIFT, 0);
>>> +}
>>
>> I think we should have the same VM_WARN_ON() checks here, as for
>> pte_clear_huge(), in addition to also warning for
>> current->mm != &init_mm.
>>
>> We should make it clear that pte_clear_huge() gets called only for
>> kernel mappings, and the range we operate on is definitely an aligned
>> CONT range - which is why we do not go through get_and_clear_full_ptes ->
>> contpte_get_and_clear_full_ptes, and possibly contpte_try_unfold(), but
>> directly use __get_and_clear_full_ptes.
>>
> 
> Hi Dev,
> 
> I'll add the alignment VM_WARN_ON() checks to pte_clear_huge() to
> match pte_set_huge().
> 
> Regarding the current->mm != &init_mm check: these functions don't take
> an mm parameter -- &init_mm is hardcoded in the function body.
> current->mm would never equal &init_mm in practice: for user processes it
> points to the process's own mm, and for kernel threads it is NULL.
> So VM_WARN_ON(current->mm != &init_mm) would always fire.

Right.


> 
> The existing hugetlb helpers that vmalloc used before this decoupling
> (huge_ptep_get_and_clear -> get_clear_contig) also take mm as a
> parameter
> and don't check current->mm either -- the caller simply passes &init_mm.
> 
> How about adding a comment to make the "kernel mapping only" intent
> more explicit?
> Something like:

I think then we should just call the functions vmap_pte_set_huge and
vmap_pte_clear_huge. In arm64 we have init_pte() which sets the cont bit
at init time for kernel mappings. So to differentiate I think we should
prefix the function name by vmap.


> 
>  pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
>  {
> +       /* Kernel mappings only */
> +
> +       VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
> +       VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
> +
>         return __get_and_clear_full_ptes(&init_mm, addr, ptep,
>                                          size >> PAGE_SHIFT, 0);
>  }
> 
> Thanks,
> Wen


