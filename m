Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD582D6CFBA
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041516B0386; Thu, 22 Jan 2026 23:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F7E6B0388; Thu, 22 Jan 2026 23:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88806B0389; Thu, 22 Jan 2026 23:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D611D6B0386
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:00:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA1F3140147
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:22:15 +0000 (UTC)
X-FDA: 84361780230.04.6B827F6
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A574140006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:22:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eXPMNHh9;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769138534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpeJcCHVDm9aGgZT7fLJbUNNelWHXP+Bu4gd7TvaW7g=;
	b=gXwMaIKWqA7ENETGxzB+skkk595qwO6VLILEfLqxGX9gMMrnFyUlTirSQVm17ZUZpfXS36
	lNTpXRhqUoDk5r/pAM5jELhN7Otzqe+pONmlEXQOnI7ZFQeNCUp5f6CXuffb8p91gCq59z
	4lGpv7NP+iv2fPNQ060AeN2oCPS5KeA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eXPMNHh9;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769138534; a=rsa-sha256;
	cv=none;
	b=7H4VnakPI3p3JXHzMb/pQIat/yNffnK5aJ93V3Cu4KJqh3AwCZonW5pfqFoqI8D4APqC9J
	ayKqExH6Km64B1VwMsDQVoCa4PnIHQE+UO/Lf7f/CqQr7CF9ONCqWigbScoHH6tBLc5chR
	5TJq/J1cd/b5vDcMuvNWZ6b8LVsn1fE=
Message-ID: <fd90c84b-9829-4699-b7df-c43020519ec9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769138529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpeJcCHVDm9aGgZT7fLJbUNNelWHXP+Bu4gd7TvaW7g=;
	b=eXPMNHh9ctUnhtpd2wXxPJprv0KOzhjIIb/JZN2sRw4sr1qJsj2GswbWUwjQC99xFlGN+J
	QxtDjJNo/hWzlNu69ifrt1uEPxLsnWQciI1TqcX0DRrEmtCLkDY/tqkEIuT8fAicEwvtwZ
	cI4zum4BNHwOopAuRPtAWL6yfr/S8g4=
Date: Fri, 23 Jan 2026 11:21:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Wei Yang <richard.weiyang@gmail.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 ioworker0@gmail.com, linmag7@gmail.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <20251231094243.zmjs7kgflm7q6k73@master>
 <a3a60bbb-70b7-49ed-abc6-937e6c13d681@linux.dev>
 <20260101020715.45wqnjgcklvjcth3@master>
 <d38fcbe5-8b4a-40bc-b8c8-1c49ccaa9964@kernel.org>
 <20260122140034.ymigrfppzwvmcjkr@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260122140034.ymigrfppzwvmcjkr@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 7cqzdwbzgac4srexhfkwe1nhuu543keb
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A574140006
X-HE-Tag: 1769138531-323942
X-HE-Meta: U2FsdGVkX18FMNlrfVcER1MjOyGAu3wOgh08doVzMz3HAT9RhDLLqNi6uWcg4jraayu05ObTJ5ecCecT4ivsPSc61JOeYrNq4jk2whyPXzCf5ETgC8cAhwxN/GiULlKiJK+t/0e1KUtuTo/UR+EtIZM8DzcyBd4y8LliY2ZcarxoFT2XgL9QlVZ3FMx1pSvuONZOq7OIn/OZEQnqcm89cpECT+xlCmyU4CIbgnt04J4rfbJ9lfNt3W9rcRj99AC+a0Af/TH9Kg4QcXehZb1ecOKpQQP112egLZbEZEfvq/s1zBvxValGZbngKBUL/uunuyjq1Sei/FTXjVljbjSy7oxux4rcOolf+jS3aWlVvXg/cvjo4rOTaDRVbbT5V/RpslvgINbsh430bFF7bM+Kzn65LP4xFhWZ3i7sNPHFJI/TjHZ+4G7vBNVGP0TO6rGDj5pLjvYX7vpWaVnaPI6754yjoiJ9oa45uv3Iv5HHtvbBhnohIPPlMuLMmEX59W3wn6GpTakl/z6IfmPSsUBjK2hiX/WTv2STEtCyxdZrvYmzHQduqsy/l/g75oarlcCMxepnt/DQCU6ZVCSqI65XECjFNmFstd3w82Bkg+gu0fM8Y4OGWar/VMPD6k8Vrs9lcNRsUuS58ADovoRvIsBELk6nrZtA4We5Qci1fBqbHNWrxw5TwTaBWmIbamti6qYguVXj9yUQ1Y2bA4inXm1I7XZ2V4mCRRF4i3OBAX0ju8cA7dE3ANw4dYueylWCQAMYnUXq2WLXcNaQa29rOL546x1itiC3GRTGUAWjpketXK8doZtflTdXucOR3JqlZ2fD9t4XE5Xh8FujJt5vcqBIIEg7azqGQTXdmKkB+TkttSHivWW5OP3lhke/w7/F0yfS6SpCxARl1nLsBFGFBF/V3IJRhcYHFbo0nbqboD0/QTs7yX19DBGihks7fKl4iBqkMtSEEhAdElK9d61t0/X
 tm+kFWwJ
 90kAjCiLtwxCYM0eOLI8EgAw2kwRp0FS1x1Mq1OfmurMTVk+qlqMfdNOZu4yFI/ilSOxT9cIfibnwwzdup3C5Pj4Z6g7V5IRgBEUvI6LeArwCMsmb8pV4UoXLDyFalRsHUSj2OJXXL53eiZWFaw6dRNm3P1rYne/G/8FiVwCDbVanTLlFzBvWzNJRPKVc2rQucU5yiFRQfUHgekofhosSUoJyc6rsZXhovAuf2otvTxtpwC2SYnDWtVTHsqCnyJ+ZWPcsPx2WpJkqVQswfAK3eAWKLUX/28IQ0hLh2X+sbvWOWL5XeazSduo8pBiPsnbBbfX5r46g7c6RJmcWDLgX6a3Ltn1dKfYGn2Jg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/22/26 10:00 PM, Wei Yang wrote:
> On Mon, Jan 19, 2026 at 11:18:52AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/1/26 03:07, Wei Yang wrote:
>>> On Wed, Dec 31, 2025 at 05:52:57PM +0800, Qi Zheng wrote:
>>>>
>>>>
>>>> On 12/31/25 5:42 PM, Wei Yang wrote:
>>>>> On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> The PT_RECLAIM can work on all architectures that support
>>>>>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>>>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>>>>
>>>>>> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>>>>>> to turn it off.
>>>>>>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> ---
>>>>>> arch/x86/Kconfig | 1 -
>>>>>> mm/Kconfig       | 9 ++-------
>>>>>> 2 files changed, 2 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>>> index 80527299f859a..0d22da56a71b0 100644
>>>>>> --- a/arch/x86/Kconfig
>>>>>> +++ b/arch/x86/Kconfig
>>>>>> @@ -331,7 +331,6 @@ config X86
>>>>>> 	select FUNCTION_ALIGNMENT_4B
>>>>>> 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>>> 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>>>> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>>>>>> 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>>>>>> 	select SCHED_SMT			if SMP
>>>>>> 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>>>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>>>> index bd0ea5454af82..fc00b429b7129 100644
>>>>>> --- a/mm/Kconfig
>>>>>> +++ b/mm/Kconfig
>>>>>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>>> 	  The architecture has hardware support for userspace shadow call
>>>>>>              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>>>
>>>>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>>>>> -	def_bool n
>>>>>> -
>>>>>> config PT_RECLAIM
>>>>>> -	bool "reclaim empty user page table pages"
>>>>>> -	default y
>>>>>> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>>>> -	select MMU_GATHER_RCU_TABLE_FREE
>>>>>> +	def_bool y
>>>>>> +	depends on MMU_GATHER_RCU_TABLE_FREE
>>>>>> 	help
>>>>>> 	  Try to reclaim empty user page table pages in paths other than munmap
>>>>>> 	  and exit_mmap path.
>>>>>
>>>>> Hi, Qi
>>>>>
>>>>> I am new to PT_RECLAIM, when reading related code I got one question.
>>>>>
>>>>> Before this patch,  we could have this config combination:
>>>>>
>>>>>        CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM
>>>>>
>>>>> This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
>>>>> is semi rcu version.
>>>>>
>>>>> I am curious could we use rcu version tlb_remove_table_one() for this case?
>>>>> Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
>>>>> there some limitation here?
>>>>
>>>> I think there's no problem. The rcu version can also ensure that the
>>>> fast GUP works well.
>>>>
>>>
>>> Thanks for your quick response :-)
>>>
>>> And Happy New Year
>>>
>>> So my little suggestion is move the definition of __tlb_remove_table_one()
>>> under CONFIG_MMU_GATHER_RCU_TABLE_FREE. Do you thinks this would be more
>>> clear?
>>
>>
>> Do you mean
>>
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 2faa23d7f8d42..6aeba4bae68d2 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -319,7 +319,7 @@ static inline void tlb_table_invalidate(struct mmu_gather
>> *tlb)
>>         }
>> }
>>
>> -#ifdef CONFIG_PT_RECLAIM
>> +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
>> static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
>> {
>>         struct ptdesc *ptdesc;
>>
>> ?
> 
> Sorry for the late reply.
> 
> Yes, and maybe we can move the definition to the
> #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE code block above, then to be next to
> tlb_remove_table_free().
> 
> So that we always have rcu version when CONFIG_MMU_GATHER_RCU_TABLE_FREE.

LGTM, could you help submit an official patch?

Thanks,
Qi

> 
>>
>> -- 
>> Cheers
>>
>> David
> 


