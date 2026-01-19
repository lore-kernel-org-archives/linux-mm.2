Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F14CCF2D2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C766B0163; Mon, 19 Jan 2026 05:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1644E6B0164; Mon, 19 Jan 2026 05:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0664B6B0165; Mon, 19 Jan 2026 05:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB8416B0163
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:19:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 970CAD1924
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:19:02 +0000 (UTC)
X-FDA: 84348315324.28.B249B49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA0DB40008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:19:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d7bFMmLq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768817940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AeXwYwnz7qLDfFEoaMRB4whAgP1Yo3U6h7g3p4bkyAI=;
	b=i9/1IsXHNH4/HYpHppsC2VJR34Z0Bf/tfYLYv80Tf8KYmWec/YMi/Sm9o5Av+GtNJl5nTE
	Ga5KXKM5uSLkQ2rNVWNpB9yqVp/oF7NlgiZ4gp77+CqZMzS7NiETEY07kGxiI39vGJaTMI
	M1Zi3Se4e3aYEReD3VCs+rCVmqoUEwQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d7bFMmLq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768817940; a=rsa-sha256;
	cv=none;
	b=vbJrROKgRDYsFQfSO+ueho301zEd3SePttQwpx9C+jfRD7crq6eDeNSOoi3Tz6v/Gn70l+
	IYvpkB8nEAGnkts8NlKa8etmpjFaowncEW+iIb1KrFhrFA3qGxG67uig6v6a9zQc6T3ofy
	e6TM25m5fxOvSdXqHh4WLYTXyFMURAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C34443303;
	Mon, 19 Jan 2026 10:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AFFC2BCB2;
	Mon, 19 Jan 2026 10:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768817939;
	bh=fChsW6zHlCrxmXpBWFm7rxfPs3w59SiQtBb4E9KHfFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d7bFMmLq1M9B8AoeKJQ9vihTU2U179+WmU91kWylvHMAex0kvNr1DQu7ArTzlhgmn
	 4pPAxBoFN99lPf4XxyZ7tKbta1qikb7XJrp4yQh6co8oYvuotYRIA1NvXdzUJZRifS
	 FxhutMYG4Y4QWgPa5uqAQinVsFZ/C3a1U/Ly553bgwajDO3Eafz7qBAx+ZsgAtcKkO
	 zZN7xdRM9KwgEZWJ72QmBNlK7I+iUWDUAFicFdjUCQSAPYwBG/CXF+M+t1L9sAxu1e
	 JiR+7Xwrb5/DZiknvTj7tiHrF90zeuEV3qr6RB81V4uGa/vwe/R5dc7JkZ36tQyv3/
	 F3k5MADrrYaOg==
Message-ID: <d38fcbe5-8b4a-40bc-b8c8-1c49ccaa9964@kernel.org>
Date: Mon, 19 Jan 2026 11:18:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Wei Yang <richard.weiyang@gmail.com>, Qi Zheng <qi.zheng@linux.dev>
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260101020715.45wqnjgcklvjcth3@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BA0DB40008
X-Stat-Signature: 7d39dyebctwcoxfqb7qdud6bc1wsxk3u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768817940-877916
X-HE-Meta: U2FsdGVkX19rmCIIZ6q9Ul6XocBwu5wib5rUxo+jjGZch0SU1bTj+8FvKRLlI7Oa+pSni8BsMtFnolk91GpqG74Xd+gt0B53dAtsPU7GUyMC2ZuKPZxUNPnZtlyHnTepYWl62c4vNrc/iOkXsf+u+wEeLwZFHPedswuhBnXoyFY7lmmUPheeCWXYQcdrPL27ZWFgyfZCjw1tIaEaqMfLStLnb4IThs5g2Qz4rhSnwfNVQ9/op+XIPWlmr9rqNm1qv2uNY8hK/JD5A7QtxoiNmjxwKofh8HcC/cBfrJn3sS/ewMrPfErcg+pfjPUlyP/2z0K4tiC9027WKyyOHYU7qHjR6lgjpfKHxVUAZqbazMcMdRxURU+p/4xTfFjaHvpFvCLG5/BoVjho4KCHYPD2Hfoobwb2Fy5FuugVoWfe58paNfIdTvOuXRwPiRwEGW+NtMAHZDxICpK6MH9jVncaY5NITYRKtV2t9wrhus/T8/dOPi5uMECFGxNOWa1OuSKO+Z0/kVAHdSgfGqiH/d3JDqpU6ivuDamoRncOeKN6YzrLE0QwON92OpoSiP+9IVxNKzmDH8WsYHIODNQrzMeIpu3qMg/p1RhElbuOnMRQdHfKq6MDgzRqlzuMrDGNDCFbLPl0YmtSYOsjpeUuoasnYR4Xl8MW/IPxMv5zjq5rOAV6DcNhEUp4OQWRzt9QMLvdweuOcNDIALratclWgcB8SLt/5O5MZC59bekUMcPUFBXKVGVUUfVQu1nZkKgo3/VV/d/76+xMMwJkcFRR1uDOMRukswQqIAP67Qi0H5DKzaA6pvD6/eueDnJDUmUC9OogE0VOMA0FPAG9rY9j2IQnKts4No8NZmOHdyloWGMrHSQigIznJa4YdFIcOWxA75P3JVPFr11J2YVoxb/TvpTKXpomtoU9wlIM8orKPsn0ZAxfwvEKja5hUarOorYkVQ3wR2O2wcKXSL5JEOBKkHW
 1vhAja2c
 qBbJkSagNCTLkzA+blNz3HTkhhS6jJHygQkSDVnWzGRP03z3zVpbUtIdUsB8YdcGcc7NLvQjFdsCTdhEUxcu+DF8+D9Y92O/vm3g3yLpiIaXrn5LMQlZiPpYi0TnEVN6BD+GrsjGvveRvu1GaevlOOL7Ht0kctbiVbeVEAEOKXdhBTmscEDG39/5/ll+kYs4/f11E5yPWF/EtjI0n8edqy3UuvjbWlkm4NvTp6zRdNu+2oo+2eCgSJJQw+MTiZDTBr7sv7XOCPYKooZkKGTY7jK1eOeiLts5j8ISZfZ+wIYO+6KxIyyEIqgGG8dBroAeUEfxDfG8RT+o/RoeAfL6fLPsTyAuBQe8bY0zH0bGAAQp2c3b8M1yRijwlwSchM+E+U5QZgzho5L2EE1rnJvWiosEEsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 03:07, Wei Yang wrote:
> On Wed, Dec 31, 2025 at 05:52:57PM +0800, Qi Zheng wrote:
>>
>>
>> On 12/31/25 5:42 PM, Wei Yang wrote:
>>> On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The PT_RECLAIM can work on all architectures that support
>>>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>>
>>>> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>>>> to turn it off.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>> arch/x86/Kconfig | 1 -
>>>> mm/Kconfig       | 9 ++-------
>>>> 2 files changed, 2 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>> index 80527299f859a..0d22da56a71b0 100644
>>>> --- a/arch/x86/Kconfig
>>>> +++ b/arch/x86/Kconfig
>>>> @@ -331,7 +331,6 @@ config X86
>>>> 	select FUNCTION_ALIGNMENT_4B
>>>> 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>> 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>>>> 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>>>> 	select SCHED_SMT			if SMP
>>>> 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>> index bd0ea5454af82..fc00b429b7129 100644
>>>> --- a/mm/Kconfig
>>>> +++ b/mm/Kconfig
>>>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>> 	  The architecture has hardware support for userspace shadow call
>>>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>
>>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>>> -	def_bool n
>>>> -
>>>> config PT_RECLAIM
>>>> -	bool "reclaim empty user page table pages"
>>>> -	default y
>>>> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>> -	select MMU_GATHER_RCU_TABLE_FREE
>>>> +	def_bool y
>>>> +	depends on MMU_GATHER_RCU_TABLE_FREE
>>>> 	help
>>>> 	  Try to reclaim empty user page table pages in paths other than munmap
>>>> 	  and exit_mmap path.
>>>
>>> Hi, Qi
>>>
>>> I am new to PT_RECLAIM, when reading related code I got one question.
>>>
>>> Before this patch,  we could have this config combination:
>>>
>>>       CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM
>>>
>>> This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
>>> is semi rcu version.
>>>
>>> I am curious could we use rcu version tlb_remove_table_one() for this case?
>>> Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
>>> there some limitation here?
>>
>> I think there's no problem. The rcu version can also ensure that the
>> fast GUP works well.
>>
> 
> Thanks for your quick response :-)
> 
> And Happy New Year
> 
> So my little suggestion is move the definition of __tlb_remove_table_one()
> under CONFIG_MMU_GATHER_RCU_TABLE_FREE. Do you thinks this would be more
> clear?


Do you mean

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 2faa23d7f8d42..6aeba4bae68d2 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -319,7 +319,7 @@ static inline void tlb_table_invalidate(struct 
mmu_gather *tlb)
         }
  }

-#ifdef CONFIG_PT_RECLAIM
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
  static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
  {
         struct ptdesc *ptdesc;

?

-- 
Cheers

David

