Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE5ACD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C916B0005; Wed,  3 Jun 2026 22:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D2E6B0088; Wed,  3 Jun 2026 22:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222B36B008A; Wed,  3 Jun 2026 22:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 109596B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:04:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96F1E120463
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:04:52 +0000 (UTC)
X-FDA: 84840586824.23.08628D0
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id DEBF6140009
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:04:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvHYfi0Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780538690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXRcOFASlBgpHHUVWdbAPeNZ/dLtG8AjFSQfXCxwvmI=;
	b=wjHdU9oz5As4ptsWZNv03VyiLpbz+kw/TcZNyEUDVz4R5SkZEHDiZNtydDmuIGWt+MMnQF
	BjGZONf9q6S8hVXjXn6Wsh4d9J2x45Nk1l8Gf7tIbMI3LzwKVzzPHqUTC0+p/lPp4m65AG
	b5zprRHjdoOwVKWXbB02IGTApMjQ/Oo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvHYfi0Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780538690;
	b=lFgtPuZ1zdeJz7u5pHbv3b4jNsGHKL/V9z+AYw6aYb0Pkje84uPwddh+doCTiyGHe5q/Vv
	ak4PHhqgjuqlvuncZQD8HcG7Z3kF3et3h7+kp9Peb7b+b2Y+dSMExAlCYFHNaQ1+XCVeLP
	2cl3yp1cO21jtqJur8QuqKZlJ6O2hzU=
Message-ID: <d1cbf717-887c-4f58-a3a2-8d2b918df100@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780538686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EXRcOFASlBgpHHUVWdbAPeNZ/dLtG8AjFSQfXCxwvmI=;
	b=pvHYfi0QlnC1XF8xzxauyx9BvSGGVXEobFJilJt3YeUfOcAnwOBNNRUDfCKGdBuWFB+SQE
	2DdH3o13DP240xm65Pq8Qs7Anrxseux+S6uLk0EGY7oMJTKx3l+5M/+Y8FKD11Cvy76t1Y
	1D/+res3j7HMMjQT0zdgr8riRT5KjgM=
Date: Thu, 4 Jun 2026 10:04:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
Content-Language: en-US
To: Luiz Capitulino <luizcap@redhat.com>, Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, corbet@lwn.net,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
 <20260603081207.1375-1-lance.yang@linux.dev>
 <710692d6-27e7-434e-a308-e717793d4fce@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <710692d6-27e7-434e-a308-e717793d4fce@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEBF6140009
X-Stat-Signature: is16ns5zx3jyttzmthmi7o1x33mrxa78
X-HE-Tag: 1780538688-145682
X-HE-Meta: U2FsdGVkX198QTmRFYiqZfOOkf+eMLgwVAjZI8J1XBIiY+30SyVCU+1ae4LY90I9NudQdzdws9XGUF4Rr7etB8fcZXyJJRRZGJ8DbNAqgyq/d1dQCxW34M87gY9sPDcYoTNRq+IkBb+jZ2C3wPGD8aHf3GP3zbtBqiFtRXB9BKHvO8oDssoxHpQ2J60tpPZbBstE3zB7OzUvfxm4/yXJ0BCR746dnhjuSPcqKrE3dPry9cyM5oklsPB9UErfGnQEOq7wOUph62CN5VqliirZoShrq+DtlXj/Dej/8Y9c33GhSFZx+5fLp+9n90hHmkVBsZ8asFeoMkM2uW3j4gSPBESntWyrGuEo5BXqO4EjHGjGwiExNV+UkHkFY1qtUr5n3e5K93KuvjxXXspErMWyfLDScP9rtV5C+48ASnu1nxnypys/rl9y+ODRBaPWRrlE2o75Bu0iuQ4Y72IIWgDgcO3s9NnO0QVOI9isdBn6p6qPWLAlJ0+jthRgOS8WciC3HMPBqYP/woNcySKojHtEEIAkpGt5AiMGfBEuFRd65W0aBLBLq82Mmtluss3XTJ5LkjTA4Pj1p5SzT8My87lQM4GPSReZKgNS2tSfgq+sQ6aDnfp+hYNcSbFa7b2mBY+li3FCp6YaPlPHFWiFU5aa7Gm9tHjzmq9rMgxfUN7ENXm7BaRE7EAyqmfgqZFTzcgkOihA3TYsN802OOomvkHztHneOAEZry9OIkY9LL4mFidF0gnUfFdJVeInIqahn/xV5BZPBlm+ExqFlFqV7MYOKQLZveslquKc+I+6xb2OF1R97mazihuBenurL+e4MNQ7/gDZpUrmAsjYRDoy4EeEIYcyRJ0+VDZiCntGfc66RUXPesd/SNW5WXEWdfbF50Ie3BWjtuKm87k3rTtk0X5vP9oQxIixKIEAs6LHjwLJAtAoUkJRDgkRP+UFHJo5XFeLvJVoHDMninLyEOOvv1N
 svi0Hf2H
 bYjGJAerfvog2fuXm+znmzpwGa5VGfcpdRMYP/mxlHefqdTUTASPZD6vKTE6yljOCSqTTzH3L7E+UCdQx6ILWfYGmXtV1j3VkEL4N7JGPh8fHwlnGdIW7dPOuA3jNFV2DHL9WJVypIEM/AcpS29fq9GRLaEX5hKJbS+EtjiXGoNBZdpO3F7DHU0pDRSe4FTkDRx4wJMg4L3vAbwBMAhUu7ZWoPpMfKcyZuzNxflk9ULkjSIVn2/7OHQU7y+WhDgEv8izCsGyLkpPqsLt+HhEYCjitNeppSNEWs+kI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/4 01:40, Luiz Capitulino wrote:
> On 2026-06-03 04:12, Lance Yang wrote:
>> Would it makes sense to call khugepaged_enter_vma() for anon mTHP faults
>> as well?
>>
>> vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>> {
>> [...]
>>     if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>>         return VM_FAULT_FALLBACK;
>> [...]
>>     khugepaged_enter_vma(vma, vma->vm_flags);
>> [...]
>> }
>>
>> Without PMD leaves, do_huge_pmd_anonymous_page() is not reached. Apart
>> from MADV_HUGEPAGE, AFAIK, the mm has no chance to enter khugepaged
>> from the fault side :)
> 
> Hey Lance,

Hey

> Wouldn't we also skip do_huge_pmd_anonymous_page() page today if
> PMD-sized THPs are disabled in sysfs but mTHP is enabled?

Right. I got mixed up here :P

> In any case, by reading through khugepaged_enter_vma() I see that
> khugepaged only supports PMD-size for now. So, shouldn't this case be
> addressed in Nico's series [1] ?

Yep. Anyway, not a big deal. No need to pile more onto Nico's series
(enough rounds already ... ). Best left as a follow-up after it lands :)

> [1] https://lore.kernel.org/linux-mm/20260522150009.121603-1- 
> npache@redhat.com/

Cheers, Lance

>>
>> Cheers, Lance
>>
>> On Fri, May 29, 2026 at 10:55:32AM -0400, Luiz Capitulino wrote:
>>> If PMD-sized pages are not supported on an architecture (ie. the
>>> arch implements arch_has_pmd_leaves() and it returns false) then the
>>> current code disables all THP, including mTHP.
>>>
>>> This commit fixes this by allowing mTHP to be always enabled for all
>>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>>> created and their mapping will be disallowed at page-fault time.
>>>
>>> Similarly, this commit implements the following changes for shmem in
>>> shmem_allowable_huge_orders():
>>>
>>> - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>>    considered
>>> - Filter out PMD and PUD orders from allowable orders when
>>>    PMD-sized pages are not supported by the CPU
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>> mm/huge_memory.c | 25 ++++++++++++++++++++-----
>>> mm/shmem.c       | 14 +++++++++-----
>>> 2 files changed, 29 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 32254febe097..059901a8c6cb 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -126,6 +126,15 @@ unsigned long __thp_vma_allowable_orders(struct 
>>> vm_area_struct *vma,
>>>     else
>>>         supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>>
>>> +    if (!pgtable_has_pmd_leaves()) {
>>> +        /*
>>> +         * If the CPU does not support PMD leaves, assume for
>>> +         * now that it does not support PUD leaves and disable
>>> +         * both folio orders.
>>> +         */
>>> +        supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>>> +    }
>>> +
>>>     orders &= supported_orders;
>>>     if (!orders)
>>>         return 0;
>>> @@ -133,7 +142,7 @@ unsigned long __thp_vma_allowable_orders(struct 
>>> vm_area_struct *vma,
>>>     if (!vma->vm_mm)        /* vdso */
>>>         return 0;
>>>
>>> -    if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, 
>>> forced_collapse))
>>> +    if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>>         return 0;
>>>
>>>     /* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>>> @@ -848,7 +857,7 @@ static int __init hugepage_init_sysfs(struct 
>>> kobject **hugepage_kobj)
>>>      * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>>>      * constant so we have to do this here.
>>>      */
>>> -    if (!anon_orders_configured)
>>> +    if (!anon_orders_configured && pgtable_has_pmd_leaves())
>>>         huge_anon_orders_inherit = BIT(PMD_ORDER);
>>>
>>>     *hugepage_kobj = kobject_create_and_add("transparent_hugepage", 
>>> mm_kobj);
>>> @@ -870,6 +879,15 @@ static int __init hugepage_init_sysfs(struct 
>>> kobject **hugepage_kobj)
>>>     }
>>>
>>>     orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>>> +    if (!pgtable_has_pmd_leaves()) {
>>> +        /*
>>> +         * If the CPU does not support PMD leaves, assume for
>>> +         * now that it does not support PUD leaves and disable
>>> +         * both folio orders.
>>> +         */
>>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>>> +    }
>>> +
>>>     order = highest_order(orders);
>>>     while (orders) {
>>>         thpsize = thpsize_create(order, *hugepage_kobj);
>>> @@ -969,9 +987,6 @@ static int __init hugepage_init(void)
>>>     int err;
>>>     struct kobject *hugepage_kobj;
>>>
>>> -    if (!pgtable_has_pmd_leaves())
>>> -        return -EINVAL;
>>> -
>>>     /*
>>>      * hugepages can't be allocated by the buddy allocator
>>>      */
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 079e299ea789..c15dffd0eb41 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1844,16 +1844,19 @@ unsigned long 
>>> shmem_allowable_huge_orders(struct inode *inode,
>>>     unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>>>     unsigned long within_size_orders = 
>>> READ_ONCE(huge_shmem_orders_within_size);
>>>     vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>>> -    unsigned int global_orders;
>>> +    unsigned int global_orders, disabled_orders = 0;
>>>
>>> -    if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, 
>>> vm_flags, shmem_huge_force)))
>>> +    if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>>         return 0;
>>>
>>> +    if (!pgtable_has_pmd_leaves())
>>> +        disabled_orders = BIT(PMD_ORDER);
>>> +
>>>     global_orders = shmem_huge_global_enabled(inode, index, write_end,
>>>                           shmem_huge_force, vma, vm_flags);
>>>     /* Tmpfs huge pages allocation */
>>>     if (!vma || !vma_is_anon_shmem(vma))
>>> -        return global_orders;
>>> +        return global_orders & ~disabled_orders;
>>>
>>>     /*
>>>      * Following the 'deny' semantics of the top level, force the huge
>>> @@ -1867,7 +1870,7 @@ unsigned long 
>>> shmem_allowable_huge_orders(struct inode *inode,
>>>      * means non-PMD sized THP can not override 'huge' mount option now.
>>>      */
>>>     if (shmem_huge == SHMEM_HUGE_FORCE)
>>> -        return READ_ONCE(huge_shmem_orders_inherit);
>>> +        return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>>>
>>>     /* Allow mTHP that will be fully within i_size. */
>>>     mask |= shmem_get_orders_within_size(inode, within_size_orders, 
>>> index, 0);
>>> @@ -1878,6 +1881,7 @@ unsigned long 
>>> shmem_allowable_huge_orders(struct inode *inode,
>>>     if (global_orders > 0)
>>>         mask |= READ_ONCE(huge_shmem_orders_inherit);
>>>
>>> +    mask &= ~disabled_orders;
>>>     return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>>> }
>>>
>>> @@ -5461,7 +5465,7 @@ void __init shmem_init(void)
>>>      * Default to setting PMD-sized THP to inherit the global setting 
>>> and
>>>      * disable all other multi-size THPs.
>>>      */
>>> -    if (!shmem_orders_configured)
>>> +    if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>>>         huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>> #endif
>>>     return;
>>> -- 
>>> 2.54.0
>>>
>>>
>>
> 


