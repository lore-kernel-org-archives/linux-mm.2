Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37347D2F003
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 11:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324DE6B0088; Tue, 27 Jan 2026 06:47:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5986B0089; Tue, 27 Jan 2026 06:47:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2228C6B008A; Tue, 27 Jan 2026 06:47:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 107216B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:47:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A03CDBCF43
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:47:44 +0000 (UTC)
X-FDA: 84377569248.30.161E5E3
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id A4A8220002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:47:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=geIbgcmQ;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769514463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pWWrBw/g6wBSDR+KZLdDDHjBjIgHxTRlg2xMP60T9Q=;
	b=ljZ8RwSqjjfQxvo2VWhMMax8kd50zdzGslWG3cXtBHxf1715xClScZeNQPgRejq5xqE8m4
	eJ0v/z5frFzbqz+bnS8Hf5P8puOXmIwDO3YU00GiseieSyr1FZpJpNt8/Iwvor0jk68oTB
	9KTWL87Mjw+sdQFU4n2Lb6capZ3DF+o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=geIbgcmQ;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769514463; a=rsa-sha256;
	cv=none;
	b=xBfoXCugT33YX74RgHoTbTL7zQPX7zEpfaCXMDw90bkYXZIrx5A2lwE0wzGajUItVSFSTv
	X1ELp5aCpJumpEDUalUB1P3LI5UxHlKj/TnhKx8uo91UjGv1+/lt7dhirOGcHaidp/8eQe
	98TqX/A8Z3FsvWnH80aVzd2tJXArRdA=
Message-ID: <d0ebcc3d-ba81-49ca-899a-34206f8dd71f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769514460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7pWWrBw/g6wBSDR+KZLdDDHjBjIgHxTRlg2xMP60T9Q=;
	b=geIbgcmQzqM7jMAtwh7suxlzdM+imDNke2ssJ2XrenGeaGRiSbpGgfg4Kt8aZ9muFstd3u
	ZvqUATxGyeqBX9IfOacg4mCXYEHURuT2xaf3eXzxzb4SfsxTDp5Z490BRVAd6RxrlSxsuK
	aZEhRTgen2VeL1mG/aI5EuEO2ei/aIQ=
Date: Tue, 27 Jan 2026 19:47:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Andreas Larsson <andreas@gaisler.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 sparclinux <sparclinux@vger.kernel.org>, will@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, dev.jain@arm.com, ioworker0@gmail.com, linmag7@gmail.com
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <9199f28e-e2b7-48c8-b61f-0b787e322443@gaisler.com>
 <646d9b5c-453c-4db8-b578-0f343e170379@linux.dev>
 <b95f042f-8fc8-4b6c-b9db-b198efdd0973@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <b95f042f-8fc8-4b6c-b9db-b198efdd0973@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4A8220002
X-Stat-Signature: ndxpzbj3ithg1e5pyf96d8dq1yu5u6xr
X-Rspam-User: 
X-HE-Tag: 1769514462-652524
X-HE-Meta: U2FsdGVkX18QZonImT9eW2MnIl6jUPPfmx8t393J3cAklZ/E0PuOSTHVahVOQ6q5AYbbEAu49U7s9uxTiPxgoywb+TwhWP+2atfCDaH9aT2+h4Sx8n8p1DGrD8DSfn2XvHXL0dRgbs7BI675rcDMDF3agwMs/R0uTarYYkJAMWFiBI30/rX+re8JCLeQPHSWhygAmkJtLwQVty83r6EHVuZDn5Zz+dzw5XPhuJTR+Xv2Mu+UALzD0ygnKZJkVO7oUooS4nUBl3HcAoZdgcszsYejSU+CaGa5Lzt1yZLEfgygJ9NHMIImw+55OPZ00klYckFBU6nI1PV4BPaREwMqJinJjtnYRoQuvIZhjjJQPwcawnhIoX2Fzf4Xu64YAVaSBaVFM4OFXkXOH3Mo/V1zNnH61ATNV4m9RQazSzKBviY8UBzR6MVCpac6OOyzBhxPOWkr8+3NMgSTWP0xaO9Vf3dzTlHQEdqkerDaNQOWA+3aqVctVz8HDIIX4RrSvluX9eeYnlnStlv5lE49XN+eyhGusEnGZbv2gn9EMQK5VdcW5b2FLehfcL5A9D6zcAheD2K/rnIwVwO5OL1Ycfyz6k9F/USxj/+P/CogFN38PU1gCtLKuw7rK9CPm9jep7t56n4LLnuugd4mLKpKz6Zny5H9OA46itbhNihp9BNn5Um9yinWmide+J7d1cm2hIfu5TvdVc9xPWPSISBblagGUmCUrb0wnKb44vQHsqPx5C/DTLWHCDg/arxHRN7XUkodsUchN/h9mWY8JPBZJu4sAPCWaThPa0CH+rYuztFvPMtM2gKLk9c/PJ4vnm7mRLARXB71Rt1ds+Fgp++IrXpyrz+3uR15o2ZAwvGgYHZQL3qmviYj45ik9SfkW2yBeap8DEtYWX8lZESa4c4qOv5grGbHKkkBgi8bbcxzj7HBc5oQQLNaHAlgEv269vOMEeqPAx54c+/K0mYZ/7FYSLw
 x92go3+v
 zUFw1dIODhNEHX97vUrVu2xJdnT+rHvNjfAXO+PQqUxq1wdFDFk3myzFLMUnqyoSO14nYgl1lNW+N96clqwYziO6aJiHVpvOqoSC9vGvUPmrulbYMQ1kYlcM3eMqF8k+QwJcH/qua+/XpCcNxCI64nf1jxTJc+xAvSIDKapbgIFhi0YbBtAPvhQDZeAQma3OvpeSTiAMDkMKXa1YD+rwKuASbaSneefF/SMiEsCpzqQHCr9NtD17Z6zq3/yoTrBAz5gXAl1yrn5xIH/XOF//zfhxDOHX03TFBGsqzlpnCWSP+YGD/aUIyxzOR4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/27/26 7:29 PM, David Hildenbrand (Red Hat) wrote:
> On 1/26/26 07:59, Qi Zheng wrote:
>>
>>
>> On 1/23/26 11:15 PM, Andreas Larsson wrote:
>>> On 2025-12-17 10:45, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The PT_RECLAIM can work on all architectures that support
>>>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>>
>>>> BTW, change PT_RECLAIM to be enabled by default, since nobody should 
>>>> want
>>>> to turn it off.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>>    arch/x86/Kconfig | 1 -
>>>>    mm/Kconfig       | 9 ++-------
>>>>    2 files changed, 2 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>> index 80527299f859a..0d22da56a71b0 100644
>>>> --- a/arch/x86/Kconfig
>>>> +++ b/arch/x86/Kconfig
>>>> @@ -331,7 +331,6 @@ config X86
>>>>        select FUNCTION_ALIGNMENT_4B
>>>>        imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>        select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>        select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>        select SCHED_SMT            if SMP
>>>>        select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>> index bd0ea5454af82..fc00b429b7129 100644
>>>> --- a/mm/Kconfig
>>>> +++ b/mm/Kconfig
>>>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>          The architecture has hardware support for userspace shadow 
>>>> call
>>>>              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>>> -    def_bool n
>>>> -
>>>>    config PT_RECLAIM
>>>> -    bool "reclaim empty user page table pages"
>>>> -    default y
>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>> -    select MMU_GATHER_RCU_TABLE_FREE
>>>> +    def_bool y
>>>> +    depends on MMU_GATHER_RCU_TABLE_FREE
>>>>        help
>>>>          Try to reclaim empty user page table pages in paths other 
>>>> than munmap
>>>>          and exit_mmap path.
>>>
>>> Hi,
>>>
>>> This patch unfortunately results in a WARN_ON_ONCE and unaligned
>>> accesses on sparc64:
>>>
>>> $ stress-ng --mmaphuge 20 -t 60
>>> stress-ng: info:  [559] setting to a 1 min run per stressor
>>> stress-ng: info:  [559] dispatching hogs: 20 mmaphuge
>>> [  560.592569] ------------[ cut here ]------------
>>> [  560.592663] WARNING: kernel/rcu/tree.c:3098 at 
>>> __call_rcu_common.constprop.0+0x200/0x760, CPU#4: stress-ng-mmaph/568
>>> [  560.592777] CPU: 4 UID: 1000 PID: 568 Comm: stress-ng-mmaph Not 
>>> tainted 6.19.0-rc5-00127-g62fc9f6ccb97 #8 VOLUNTARY
>>> [  560.592805] Call Trace:
>>> [  560.592812] [<00000000004368b8>] dump_stack+0x8/0x60
>>> [  560.592844] [<0000000000482a60>] __warn+0xe0/0x140
>>> [  560.592878] [<0000000000482b64>] warn_slowpath_fmt+0xa4/0x120
>>> [  560.592901] [<0000000000526a40>] 
>>> __call_rcu_common.constprop.0+0x200/0x760
>>> [  560.592931] [<0000000000526fd0>] call_rcu+0x10/0x20
>>> [  560.592954] [<0000000000730838>] tlb_remove_table+0x98/0xc0
>>> [  560.592986] [<000000000071bec4>] free_pgd_range+0x224/0x4c0
>>> [  560.593021] [<000000000071c35c>] free_pgtables+0x1fc/0x240
>>> [  560.593042] [<000000000074a6f0>] vms_clear_ptes+0x110/0x140
>>> [  560.593068] [<000000000074c3dc>] vms_complete_munmap_vmas+0x5c/0x280
>>> [  560.593094] [<000000000074de5c>] do_vmi_align_munmap+0x1dc/0x260
>>> [  560.593117] [<000000000074df80>] do_vmi_munmap+0xa0/0x140
>>> [  560.593142] [<000000000074fb2c>] __vm_munmap+0x8c/0x160
>>> [  560.593168] [<000000000072cfd4>] vm_munmap+0x14/0x40
>>> [  560.593190] [<00000000004402a8>] sys_64_munmap+0x88/0xa0
>>> [  560.593221] [<0000000000406274>] linux_sparc_syscall+0x34/0x44
>>> [  560.593274] ---[ end trace 0000000000000000 ]---
>>> [  560.593960] log_unaligned: 209 callbacks suppressed
>>> [  560.593979] Kernel unaligned access at TPC[526a4c] 
>>> __call_rcu_common.constprop.0+0x20c/0x760
>>> [  560.594121] Kernel unaligned access at TPC[526864] 
>>> __call_rcu_common.constprop.0+0x24/0x760
>>> [  560.594198] Kernel unaligned access at TPC[52b3c4] 
>>> rcu_segcblist_enqueue+0x24/0x40
>>> [  560.594275] Kernel unaligned access at TPC[526860] 
>>> __call_rcu_common.constprop.0+0x20/0x760
>>> [  560.594360] Kernel unaligned access at TPC[526864] 
>>> __call_rcu_common.constprop.0+0x24/0x760
>>> [  567.054127] log_unaligned: 1105 callbacks suppressed
>>> [  567.054167] Kernel unaligned access at TPC[526860] 
>>> __call_rcu_common.constprop.0+0x20/0x760
>>> [  567.054331] Kernel unaligned access at TPC[526864] 
>>> __call_rcu_common.constprop.0+0x24/0x760
>>> [  567.054410] Kernel unaligned access at TPC[52b3c4] 
>>> rcu_segcblist_enqueue+0x24/0x40
>>
>> Thanks for your report!
>>
>> On sparc64, pmd and pud levels are not of struct page:
> 
> Can you elaborate, I don't understand what you mean :)

On sparc64:

static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, 
bool is_page)
{
	unsigned long pgf = (unsigned long)table;
	if (is_page)
		pgf |= 0x1UL;
	tlb_remove_table(tlb, (void *)pgf);
}

static inline void __tlb_remove_table(void *_table)
{
	void *table = (void *)((unsigned long)_table & ~0x1UL);
	bool is_page = false;

	if ((unsigned long)_table & 0x1UL)
		is_page = true;
	pgtable_free(table, is_page);
}

void pgtable_free(void *table, bool is_page)
{
	if (is_page)
		__pte_free(table);
	else
		kmem_cache_free(pgtable_cache, table);
}

For pmd and pud levels, is_page is false, so we can not do the
following in __tlb_remove_table_one().

```
	ptdesc = table;
	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
```

> 
> Is it also a problem on architectures like s390x and ppc, where we 
> squeeze multiple page tables into a physical pages?

For ppc, it's the same as for sparc64.

For s390x, it supports MMU_GATHER_RCU_TABLE_FREE and define its own
pxx_free_tlb(), but these all call tlb_remove_ptdesc(), so there is no
problem.

> 
>>
>> __pmd_free_tlb/__pud_free_tlb
>> --> pgtable_free_tlb(tlb, pud/pmd, false). <=== is_page == false
>>       --> tlb_remove_table
>>
>> So in __tlb_remove_table_one(), the table cannot be treated as
>> ptdesc because it does not have an pt_rcu_head member.
>>
>> Hi David, it seems we still need to keep ARCH_SUPPORTS_PT_RECLAIM?
> 
> Or we invert it and only disable it for the known-problematic 
> architectures?

Yes, the problem lies with those architectures that support
MMU_GATHER_RCU_TABLE_FREE and define their own _tlb_remove_table().

So my plan is as follows:

1. convert __HAVE_ARCH_TLB_REMOVE_TABLE to 
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
2. make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE && 
!HAVE_ARCH_TLB_REMOVE_TABLE

I'll send v4 soon.

Thanks,
Qi

> 


