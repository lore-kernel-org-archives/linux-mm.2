Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F287CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8BA8E013C; Tue,  4 Nov 2025 08:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B690B8E0124; Tue,  4 Nov 2025 08:21:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57898E013C; Tue,  4 Nov 2025 08:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 929128E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:21:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52FD7C0518
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:21:19 +0000 (UTC)
X-FDA: 84072985878.27.10C9E78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 32B2C40014
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:21:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762262477; a=rsa-sha256;
	cv=none;
	b=8RCQqbYUcLMkPZ8YjK4Vd3Q03ynV3Be7vL/KswJ0vsapLZulNkm+9gaPFQMWevuPV1xGGv
	KkwnUkcwp96aw3isLehtJ7eJ2A3EzMOp4YO+YcqHWKh4Y/HWlHF+AApS6sUniWKtI5VIRF
	9e8zUEqT/oyIHYkcPkSYjaei/0wQm8E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762262477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xtcF3lGaa8N2N2K4KUl4lTF49+O8kNeOdJScmNjjIs=;
	b=uz1bEYtO2ORgGE0p6wt3CRgbKlgG1cXsupfM7h3wlXmEbKCPhOjKfx51rOyXNcQUn78bfC
	6AcsIuvy/2uAgwNSloGdAyvtw4oS+/OHRdYFLPIyFKEC9YgQ6bjfe+F3AH07wWOcXov7L/
	PC80f3jGZsETMw6FxRsbiGtxTF4zBsY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BE1D1CE0;
	Tue,  4 Nov 2025 05:21:08 -0800 (PST)
Received: from [10.164.18.64] (unknown [10.164.18.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2E9C3F66E;
	Tue,  4 Nov 2025 05:21:08 -0800 (PST)
Message-ID: <d51ecac7-d67b-4da0-babe-a65aaf9293d0@arm.com>
Date: Tue, 4 Nov 2025 18:51:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
To: Lance Yang <ioworker0@gmail.com>, zhengqi.arch@bytedance.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de,
 catalin.marinas@arm.com, dave.hansen@linux.intel.com, david@redhat.com,
 hannes@cmpxchg.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 mingo@redhat.com, ppt@kernel.org, ryan.roberts@arm.com,
 shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
 vbabka@suse.cz, will@kernel.org, x86@kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <827b647d-798f-4775-bb31-ef735485c6bb@bytedance.com>
 <20251104131348.32332-1-ioworker0@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251104131348.32332-1-ioworker0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32B2C40014
X-Stat-Signature: f8j1r4hybuucuwghtb9dgy6e15fkfuk3
X-HE-Tag: 1762262477-525160
X-HE-Meta: U2FsdGVkX1/jGzn4xyNAfPNpz4avu0bpj8FjlcyZVvVnbeH0c7H7UwL+35pyuFlSg7mEq56Sp/JFG0+vak2u9iTwx4GZdAdG68IStA22RZaMCK9ZfI6VlQUyJyja1j423fXC3ImAAfO+hm/fxH6sTJ6TE8Sw8LzEsMv1bVPTdhzv/s4nVDl774m6THMSfkOX4f8OzY48Cd1hzX+XM5Me0SuzReeOrv8IKTI7daWyYmFzTCuJsY6lPXDXnxTbC1HgOScNSceDQ3VbnNyOg5i/cmQevXn1gCSW2wqcOLFJ357xstPZcuHQwq/xzuoblYMACax+pXFVCVBVD7z0xPCmWvhvxTeb7Ezupcj9Wz/RtQJasvvDA0njLxEk5OVngCu7FQm6Y769Ac7DVQIMAn3pFSXJ0DBBHVK3DQUzF2tm+tv0O5VtDKhmo0d5OAZXz7yDM1NqAyhfaRutDh17n6P6gIT5jQ+h3kL1NMsnA43xV4pTRs5Og4zdQO8J0BGQTUrRrUe4UyHmbW44yzBOp2oH7UM/wQTqmrW5V52jctq/l3IwFttBVG3plTQmbq1sAt+vb/G2rS+6t/Yw3xuVh8Iy/pfYhvg8cJaLVpb4+TwFT8OvRBHBRta6IqJXbctEWfXbckQs0sqLNWQSLS/kO1s7G6PHor9Cjb+Rw1joI6ogVXsKy2Xll1BA4p6sEKMj3B1MmyMdjDOX4DuWVmNLCEAsA5YrHkyw+pB9JmJew5pPIugf0gXXZ5QvmOipjuuTszoO0pd741aqW02r0UxLKNpaB8wwbR9Xde9LqGTYOBYmncFDkl47GXBlQklt6X943HfPUzOTyxUf/qR7itG5REjXS/K91HgYv4w3VQAcRBDEW9FPBcyiZas/07LV9NJwrN0xeIpdb1byCOobsxgLrzhCt3SjjLSCgf97UW02a+8EFBBRtRRXYy55dkYBI0dUizoZRbZWXIw+pnFm00L7FSm
 2XRVoEDV
 id/9IXja3Ewtkn4x6q/LPtw1cxai1YPY5GibGNAbpIM7gShtUIag6GUC7eSQVwCYwCKJBVQ9H7+aJBFkBgG+cdBH2exCTo1/P6VuFZlCdgWL/uR6vE//tvLgplgynqQ2mY5v0CEvW1WNY/XBApzYuDGPyol5NJmo/ist3fp50smOzzIAEdv5rOfpJZjECZgHoOfjc18uz2OuEaCqo6jHLPXJuU0b7qm3aHsAp+RjwfKCrgpFyBuLAmx0ekQ9RPlIyJLB4GDvN/YHz4aDBayWHui71GCbDgZsjM2OuM/MXdredY87CC4KhKdtAQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/11/25 6:43 pm, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
>
> On Tue, 4 Nov 2025 14:33:00 +0800, Qi Zheng wrote:
>>
>> On 11/4/25 12:02 PM, Dev Jain wrote:
>>> On 03/11/25 2:37 pm, Qi Zheng wrote:
>>>> Hi Dev,
>>>>
>>>> On 11/3/25 4:43 PM, Dev Jain wrote:
>>>>> On 03/11/25 12:33 pm, Qi Zheng wrote:
>>>>>> Hi Dev,
>>>>>>
>>>>>> On 11/3/25 2:37 PM, Dev Jain wrote:
>>>>>>> The implementation of CONFIG_PT_RECLAIM is completely contained in
>>>>>>> generic
>>>>>>> mm code. It depends on the RCU callback which will reclaim the
>>>>>>> pagetables -
>>>>>>> there is nothing arch-specific about that. So, enable this config for
>>>>>>> all architectures.
>>>>>> Thanks for doing this!
>>>>>>
>>>>>> But unfortunately, not all architectures call tlb_remove_ptdesc() in
>>>>>> __pte_free_tlb(). Some architectures directly call pte_free() to
>>>>>> free PTE pages (without RCU).
>>>>> Thanks! This was not obvious to figure out.
>>>>>
>>>>> Is there an arch bottleneck because of which they do this? I mean to
>>>>> say,
>>>>>
>>>>> is something stopping us from simply redirecting __pte_free_tlb to
>>>>> tlb_remove_ptdesc
>>>> Some architectures have special handling in __pte_free_tlb(), and cannot
>>>> simple redirect __pte_free_tlb() to tlb_remove_ptdesc(), such as m68k,
>>>> powerpc, etc.
>>>>
>>>> For those architectures that call pte_free() in __pte_free_tlb(), it
>>>> should be easy to modify them.
>>>>
>>>> If you're not in a rush, I can take the time to finish the above tasks.
>>> Right then, I'll leave that up to you!
>> OK, I will do it ASAP.
> Cool! Looking forward to seeing that land ;p
>
> Cheers,
> Lance
>
>>>
>>>>> or pte_free_defer?
>>>>>
>>>>>
>>>>> I am looking to enable this config at least on arm64 by default, I
>>>>> believe it will be legal
> Great proposal, Dev! That looks like a very useful feature. Let's make it
> happen on arm64 ;)

Yup, but not sure whether an arm64 enabling patch, only for that to go away
when Qi implements the feature generically, is worth the trouble!

>
>>>>> to do this at least here.
>>>> IIRC, arm64 can directly enable CONFIG_PT_RECLAIM, as it is supported
>>>> at the architecture level.
>>>>
>>>> Thanks,
>>>> Qi
>>>>
>>>>>
>>>>>> We need to modify these architectures first, otherwise it will
>>>>>> lead to UAF. This approach is feasible because Hugh provides similar
>>>>>> support in pte_free_defer().
>>>>>>
>>>>>> Enabling PT_RECLAIM on all architecture has always been on my
>>>>>> TODO list, but it's been blocked by other things. :(
>>>>>>
>>>>>> Thanks,
>>>>>> Qi
>>>>>>
>>>>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>>>>> ---
>>>>>>>    arch/x86/Kconfig | 1 -
>>>>>>>    mm/Kconfig       | 5 +----
>>>>>>>    mm/pt_reclaim.c  | 2 +-
>>>>>>>    3 files changed, 2 insertions(+), 6 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>>>> index fa3b616af03a..5681308a5650 100644
>>>>>>> --- a/arch/x86/Kconfig
>>>>>>> +++ b/arch/x86/Kconfig
>>>>>>> @@ -327,7 +327,6 @@ config X86
>>>>>>>        select FUNCTION_ALIGNMENT_4B
>>>>>>>        imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>>>>        select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>>>>        select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>>>>        select SCHED_SMT            if SMP
>>>>>>>        select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>>>>> index 0e26f4fc8717..903c37d02555 100644
>>>>>>> --- a/mm/Kconfig
>>>>>>> +++ b/mm/Kconfig
>>>>>>> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>>>>          The architecture has hardware support for userspace shadow
>>>>>>> call
>>>>>>>              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>>>>    -config ARCH_SUPPORTS_PT_RECLAIM
>>>>>>> -    def_bool n
>>>>>>> -
>>>>>>>    config PT_RECLAIM
>>>>>>>        bool "reclaim empty user page table pages"
>>>>>>>        default y
>>>>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>>>>> +    depends on MMU && SMP
>>>>>>>        select MMU_GATHER_RCU_TABLE_FREE
>>>>>>>        help
>>>>>>>          Try to reclaim empty user page table pages in paths other
>>>>>>> than munmap
>>>>>>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
>>>>>>> index 7e9455a18aae..049e17f08c6a 100644
>>>>>>> --- a/mm/pt_reclaim.c
>>>>>>> +++ b/mm/pt_reclaim.c
>>>>>>> @@ -1,6 +1,6 @@
>>>>>>>    // SPDX-License-Identifier: GPL-2.0
>>>>>>>    #include <linux/hugetlb.h>
>>>>>>> -#include <asm-generic/tlb.h>
>>>>>>> +#include <asm/tlb.h>
>>>>>>>    #include <asm/pgalloc.h>
>>>>>>>      #include "internal.h"
>>

