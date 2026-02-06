Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8E4EE2092
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFA96B0089; Fri,  6 Feb 2026 06:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D5F6B0092; Fri,  6 Feb 2026 06:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F456B0093; Fri,  6 Feb 2026 06:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8B3C6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:59:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6245514012D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:59:15 +0000 (UTC)
X-FDA: 84413886270.15.2948243
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9787180015
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:59:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aalvtl60;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770379153; a=rsa-sha256;
	cv=none;
	b=1ECw+YaWYyWzooSwCsKwAzYpWDh7ZIHmodRKCPNWq08FWdFAloHSApNk5bxIHq6q1kRXyW
	VodkSlVLFt78wIkCfc4rHra/oeVMSuh0EHGjFDWwgle7l3Ocfycl8mqBmpDFTtsYYQInhX
	m9NzcEXfuWfltjzENp0tzPBIm/v32oo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aalvtl60;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770379153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dYqXq1NRIfJySgnYSgnc1Tt2EdVmznlx20DFcIB6kE=;
	b=p45aewZcHE2cQ8WNBwDaBY+NUCX8LpMDenfptnNTXguQnyfl5HVKaRPpgTbKLV+N97iLrn
	KJ9ewqYapZF1oPyOsKlcgfPdNLzVzbkXqqYacuBR71srmReJldSlcNUkwDZhsqm7Yv/8ss
	DWR0ixj22KluFcdJcZ0wK1u20hkWax4=
Message-ID: <53a1bbdd-26d1-454d-af06-169172278718@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770379151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dYqXq1NRIfJySgnYSgnc1Tt2EdVmznlx20DFcIB6kE=;
	b=Aalvtl60ATdjvtCv049X0heOLjC3Ne6UC4Jnw9CBdMvR2rHyEUK1QbvxylKB+AHtJsEUAU
	qvz+5iU0N8RA5zOq5wxvvGIq8Nn3kg8PMVar5v/lHabP5zzzP0j4LoFOtXGenQaBOxygN1
	8rGXHcgmdNLdrCK3y2uriNFt0zpk2rs=
Date: Fri, 6 Feb 2026 19:58:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 7/8] mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to
 CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
To: "David Hildenbrand (Arm)" <david@kernel.org>, andreas@gaisler.com,
 richard.weiyang@gmail.com, will@kernel.org, peterz@infradead.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, dev.jain@arm.com,
 ioworker0@gmail.com, linmag7@gmail.com, akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
 <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
 <a404e9ec-35ff-44b1-b321-9cc4fbf72060@kernel.org>
 <1663ae90-3247-4e12-a25a-049fc3281e19@linux.dev>
 <538fef61-3903-407e-8486-538a28b99e9d@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <538fef61-3903-407e-8486-538a28b99e9d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9787180015
X-Stat-Signature: 9jqie9e4spubhp6fpznt7fdxpwhq89du
X-HE-Tag: 1770379153-226334
X-HE-Meta: U2FsdGVkX19vny26CAlgPzXJ7FKfE3BYT00oMCv8H9cbFxU4BT7dSAKROmtZoW3Ex+s9wkrrleOdzSWAiCQ0wcESWPWEHfYfcm87i/9KtGeI4exvyINCLhxssyD8LChy3cMLJ05CBnZEjVAW+qL1XjGQzCoOHrkSbKulrnSKmYI0OhUMiKbITEIKDQJwFDAJF3jNOraIrduEJxfSAWx81RohdeCoFvEQ3jd/3wxRXiaG/J9UpzRFrQzsvcxWUkwR2xHYwhBMJjQZyqqZbr88cvCAonX4S+t1PkGuE0f8MK2HrFYJ/Q4ioVS4N4sYa39Jakxkf9hQucp8ZBwbTIDQ4N/73pcyvhxGPfAjJ8wnQ/A24gWovslrrm8vCNh5HKOAAu9Bq/xQJyxNykY2BUEg7cRwsxpws56j39emeITBo64YEhqRpEU6QAXSTHtctM8M5GcETBIUX0n2+TX6RpE59YikMQ/dEi8u4hYmYXg+Zx6ma+o3FoECZMhRTEQCz1wJIn/6RJ8NnjGe5iErxvuJF0h1mB5UMSZ/athq64T5YILE8axUfmPUbhJB1+0ZUuA1FUZ7XxuTJDLCO+tBtGXNfHBqp4FetaEpdvZw0B0Bipw09cgl1zpLZ20hj3Wq6FWA0Pyc57jkDgsc+41i9MsRa+wNAlg4+AKwC7vN80Ez3OdZdd4f9BNoJDGCVAO5nAvQ/CsnNRqAtZf6xbz+TuMNNqrso/PtLBak28jiRJwk4Demkye40pMog0/XzKMHoATeC1EWnX4miifuPMpH0hk4n0me2Sqw0S68zV42urPm4249EmEj/SNyrIRBCYhqEmbGUJvdmV0enwCUimWQvnH3BzY2CSyDAipx/9SC7aPKwJDFcyd3jGRBjfRCkjVZZNqJtNG5lNdYhtdbVs8/5xvNWspXKbKNErkcQcttfPB7dPMhmsc+EBAgqP1woxpA2XyoN/3SNldFj4pFO+ZaVN8
 2hD+k7ym
 jxTbFnRWq/tshZvi75BN3xAKGrUl2pSOVeWHpugjHiO4mDiZNxX9wrDnaEfHp/X2lNS5ScVjpp/8sKJoorAGPAQ31XC4HFdLDxhQXhMXL3vdB9yxptkCORDwrYpQs2PngqTiO51iQD7jN/0UkaFwo0pO0PwPYmsvr/Pgvvwq8Qru901uBiyBCq/ibuRxbpJwwXs4nkbErQmWwqHXOzc7sRsAlqOa/Jpsa+Ex+yJ2w4TLC+BB8UX9A+feldEvc6QxkqM8iq+cR4kkC47Rsnpw8xfzwmPPXvteGw8e6KzPy30REiDgBWkXn21mdNTGeH15We9OGIPHMTtjQ7KTiyi0bU5cMqWvurjR1wkk7C4FiYCFWQh+S3NSuMCMv9eSrVY+XIupI95baZBe68XV1Tuaj9iQnOGjf3KLNSI6L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/6/26 7:45 PM, David Hildenbrand (Arm) wrote:
> On 2/6/26 12:13, Qi Zheng wrote:
>>
>>
>> On 2/6/26 7:06 PM, David Hildenbrand (Arm) wrote:
>>> On 1/27/26 13:13, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> For architectures that define __HAVE_ARCH_TLB_REMOVE_TABLE, the page
>>>> tables at the pmd/pud level are generally not of struct ptdesc type, 
>>>> and
>>>> do not have pt_rcu_head member, thus these architectures cannot support
>>>> PT_RECLAIM.
>>>>
>>>> In preparation for enabling PT_RECLAIM on more architectures, convert
>>>> __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE 
>>>> config,
>>>> so that we can make conditional judgments in Kconfig.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>>   arch/powerpc/Kconfig            | 1 +
>>>>   arch/powerpc/include/asm/tlb.h  | 1 -
>>>>   arch/sparc/Kconfig              | 1 +
>>>>   arch/sparc/include/asm/tlb_64.h | 1 -
>>>>   include/asm-generic/tlb.h       | 2 +-
>>>>   mm/Kconfig                      | 3 +++
>>>>   6 files changed, 6 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>>>> index 9537a61ebae02..b47aa8fd62742 100644
>>>> --- a/arch/powerpc/Kconfig
>>>> +++ b/arch/powerpc/Kconfig
>>>> @@ -304,6 +304,7 @@ config PPC
>>>>       select LOCK_MM_AND_FIND_VMA
>>>>       select MMU_GATHER_PAGE_SIZE
>>>>       select MMU_GATHER_RCU_TABLE_FREE
>>>> +    select HAVE_ARCH_TLB_REMOVE_TABLE
>>>>       select MMU_GATHER_MERGE_VMAS
>>>>       select MMU_LAZY_TLB_SHOOTDOWN        if PPC_BOOK3S_64
>>>>       select MODULES_USE_ELF_RELA
>>>> diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/ 
>>>> asm/tlb.h
>>>> index 2058e8d3e0138..1ca7d4c4b90db 100644
>>>> --- a/arch/powerpc/include/asm/tlb.h
>>>> +++ b/arch/powerpc/include/asm/tlb.h
>>>> @@ -37,7 +37,6 @@ extern void tlb_flush(struct mmu_gather *tlb);
>>>>    */
>>>>   #define tlb_needs_table_invalidate()    radix_enabled()
>>>> -#define __HAVE_ARCH_TLB_REMOVE_TABLE
>>>>   /* Get the generic bits... */
>>>>   #include <asm-generic/tlb.h>
>>>> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
>>>> index a630d373e6453..25fa2908d6152 100644
>>>> --- a/arch/sparc/Kconfig
>>>> +++ b/arch/sparc/Kconfig
>>>> @@ -74,6 +74,7 @@ config SPARC64
>>>>       select HAVE_KRETPROBES
>>>>       select HAVE_KPROBES
>>>>       select MMU_GATHER_RCU_TABLE_FREE if SMP
>>>> +    select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
>>>
>>> Why the SMP? At least in tlb_64.h, it was not protected by SMP IIUC.
>>
>> Ah, It's just simply aligned with the MMU_GATHER_RCU_TABLE_FREE above.
> 
> But does that work as expected for !SMP?

In the case of !SMP, tlb_remove_table() will not be called:

static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, 
bool is_page)
{
	pgtable_free(table, is_page);
}


so I think it's okay to only select it in case of SMP.

> 


