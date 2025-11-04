Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27048CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 04:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB378E00E5; Mon,  3 Nov 2025 23:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59ADB8E00DC; Mon,  3 Nov 2025 23:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7818E00E5; Mon,  3 Nov 2025 23:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3AF8E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:02:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8AA1B9097
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:02:38 +0000 (UTC)
X-FDA: 84071577996.09.23CAEAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDC114000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:02:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762228957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/QE7pAvMdiyVS73dSCBBcSZ2/zYxlgloHbOBsUxC/NI=;
	b=k6BHIr/t4CCmfXDTvtdYDV6In54cjFHwsB+aKBKtgSJC3bNbZGSB5NNq9EymOZgMKTxbAf
	Q+LTmxq39VdIg7AEXYu/lAL/lsjBIHszkGodCM3AIGhL2niemCO2Hu158SGUvHnTCkhDFL
	iU04GFF5uLndJ8AA55RNrD+K1SsNcPA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762228957; a=rsa-sha256;
	cv=none;
	b=ET13Ir2VXhU+sQP6BBPQPkWqywfelq51PWKCcLP2yTgGl2bjcQARaBv8fFjfm5TCj5B1on
	AtSex6CX5sg6tSQ/8rcN8e14Jz8FfVxtRVV2Xnl8qlXCj05aA5HFpn2es12XqP6BaZofFk
	SQ8bJRNP+n/MzSKmsoVx6OuzSRR2cEg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA7481C2B;
	Mon,  3 Nov 2025 20:02:27 -0800 (PST)
Received: from [10.164.18.64] (unknown [10.164.18.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E1ED3F694;
	Mon,  3 Nov 2025 20:02:28 -0800 (PST)
Message-ID: <2be04785-d725-4e79-a609-87f174271f83@arm.com>
Date: Tue, 4 Nov 2025 09:32:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
To: Qi Zheng <zhengqi.arch@bytedance.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, hannes@cmpxchg.org
Cc: ryan.roberts@arm.com, hpa@zytor.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shakeel.butt@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251103063718.90743-1-dev.jain@arm.com>
 <044e3f9a-3de2-4939-afff-3bb527eb024b@bytedance.com>
 <666e012e-0b13-4def-82de-55ccd5868d36@arm.com>
 <9359ce51-5ac7-4312-8ef8-79fa51d014f5@bytedance.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <9359ce51-5ac7-4312-8ef8-79fa51d014f5@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDC114000C
X-Stat-Signature: 15cyhufpxyhfnqfkoho651gjypx394eb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762228956-875573
X-HE-Meta: U2FsdGVkX1+M2NlbjNac8NWxGEE+YCZUPWWohf1NR54Sx5ZShiOvXKi5Vl3Y0QfTBJVq20/j7CzyG2ojZZ0r1MRHkBIE5w7gVkyUyBOrDzjOcHyQnKB+3fevz2cciAfeTvPDSDbyYX68+pT4pSd05YlB+RP3LEAi9a0m7oB2YM6TYdo2Wc8HB00DmBzKEF0ZraFUYR+OzeyP9XqLnxDIDM/uUus3kgROa7JE7P33GrhXaOcj6jrspiwm3SYtwgRyj+WTPvJagm+6nsI5xTwrBotFey76Z69PWDCfaNia9QfF9xBrbrAiJQgUupqVrlYEYnrmEGkYzZmBL3cLMPdPIMN5+lX02rXRWv8CMWkWw6DzcPYdt2nwqtKwXiueB93DVTGmE4at9zvsitKME5pA2d5pkG8o8VIx79S0cBFxPzlTumUGrcfC06TPue9258RTJdruk/Su2c5/Nw7t6G9PpYlWOaPNpI4tQOp/T8YB9sfBpJr3bVhBFdBL9gG4wlRihMsvDzoK+8HIRMULuBYqA8Mj56yj+IYFyotulIOpvx8I/PA/6oy1X0cd4cQc6Eup8L98OrLcTKEVYrpkE1PM2EHWZ+DRwv5V6GCMUTfIC4WHjX/BFnbyqbHxIFvWick4l1ypuUqgw2qQyvjRb68me/n1Zq8ac2tUyMIb7JVOZxVmU9tT671Oj6Fo+0aS9ayfiGh0FNRfZZ1uvwjtSiuMONpPSTOe4snG7BOdUQ3tdOzULyYls/gAK1TYrk8xrmTWBb1LLsgfTQM15qJ35z6CV8dI8109J2QUvDNpAV76R2cvqTM1l+wn1t010kBSxkX6efnCxWEGIIOy1Twrt1tfDGIxnOKV5eowoA1fGn3Bz2HGYpUPMzD50pBBAjCKJm8dsNWNcMTAV5ILPSZ36wu5U4qb4+n1Psk6JttJ+k8mUO7+aQWt+p1Blquq3zMz++WIFG/ZO35JT4aj8FLh1hp
 Ec4K6IGP
 RGsFjYFJil5P8fFXM56Dws+DKWY4dQvKzTh5PVyEZHjmyAwnz96iby8Y8YIIOTvdcI2s0sqxVKiFbtrEzzo7pmt9t5Qzq/5JtsaDOzeWBICVgxoUzvSSqjrbiBELU3Iu4wbQQlt4jdp6VrOTQAYi1q2RfVZi7t1ik2Pm20iWl5ImMbaMu7peVs5skpRdJF9TiYi4Bdmoziq0O13DG85V5sadmCNeSJZqyv9jRL+XpoQY/ff84JBXaHlXo5bfYKQ5pWORFsBSHnEdfv54VqmIkKu3AO2YbcZr49/PNN/OdbGkWXfkhV0knDh4/wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/11/25 2:37 pm, Qi Zheng wrote:
> Hi Dev,
>
> On 11/3/25 4:43 PM, Dev Jain wrote:
>>
>> On 03/11/25 12:33 pm, Qi Zheng wrote:
>>> Hi Dev,
>>>
>>> On 11/3/25 2:37 PM, Dev Jain wrote:
>>>> The implementation of CONFIG_PT_RECLAIM is completely contained in 
>>>> generic
>>>> mm code. It depends on the RCU callback which will reclaim the 
>>>> pagetables -
>>>> there is nothing arch-specific about that. So, enable this config for
>>>> all architectures.
>>>
>>> Thanks for doing this!
>>>
>>> But unfortunately, not all architectures call tlb_remove_ptdesc() in
>>> __pte_free_tlb(). Some architectures directly call pte_free() to
>>> free PTE pages (without RCU).
>>
>> Thanks! This was not obvious to figure out.
>>
>> Is there an arch bottleneck because of which they do this? I mean to 
>> say,
>>
>> is something stopping us from simply redirecting __pte_free_tlb to 
>> tlb_remove_ptdesc
>
> Some architectures have special handling in __pte_free_tlb(), and cannot
> simple redirect __pte_free_tlb() to tlb_remove_ptdesc(), such as m68k,
> powerpc, etc.
>
> For those architectures that call pte_free() in __pte_free_tlb(), it
> should be easy to modify them.
>
> If you're not in a rush, I can take the time to finish the above tasks.

Right then, I'll leave that up to you!


>
>>
>> or pte_free_defer?
>>
>>
>> I am looking to enable this config at least on arm64 by default, I 
>> believe it will be legal
>>
>> to do this at least here.
>
> IIRC, arm64 can directly enable CONFIG_PT_RECLAIM, as it is supported
> at the architecture level.
>
> Thanks,
> Qi
>
>>
>>
>>>
>>> We need to modify these architectures first, otherwise it will
>>> lead to UAF. This approach is feasible because Hugh provides similar
>>> support in pte_free_defer().
>>>
>>> Enabling PT_RECLAIM on all architecture has always been on my
>>> TODO list, but it's been blocked by other things. :(
>>>
>>> Thanks,
>>> Qi
>>>
>>>>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>>   arch/x86/Kconfig | 1 -
>>>>   mm/Kconfig       | 5 +----
>>>>   mm/pt_reclaim.c  | 2 +-
>>>>   3 files changed, 2 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>> index fa3b616af03a..5681308a5650 100644
>>>> --- a/arch/x86/Kconfig
>>>> +++ b/arch/x86/Kconfig
>>>> @@ -327,7 +327,6 @@ config X86
>>>>       select FUNCTION_ALIGNMENT_4B
>>>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>       select SCHED_SMT            if SMP
>>>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>> index 0e26f4fc8717..903c37d02555 100644
>>>> --- a/mm/Kconfig
>>>> +++ b/mm/Kconfig
>>>> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>         The architecture has hardware support for userspace shadow 
>>>> call
>>>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>   -config ARCH_SUPPORTS_PT_RECLAIM
>>>> -    def_bool n
>>>> -
>>>>   config PT_RECLAIM
>>>>       bool "reclaim empty user page table pages"
>>>>       default y
>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>> +    depends on MMU && SMP
>>>>       select MMU_GATHER_RCU_TABLE_FREE
>>>>       help
>>>>         Try to reclaim empty user page table pages in paths other 
>>>> than munmap
>>>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
>>>> index 7e9455a18aae..049e17f08c6a 100644
>>>> --- a/mm/pt_reclaim.c
>>>> +++ b/mm/pt_reclaim.c
>>>> @@ -1,6 +1,6 @@
>>>>   // SPDX-License-Identifier: GPL-2.0
>>>>   #include <linux/hugetlb.h>
>>>> -#include <asm-generic/tlb.h>
>>>> +#include <asm/tlb.h>
>>>>   #include <asm/pgalloc.h>
>>>>     #include "internal.h"
>>>
>

