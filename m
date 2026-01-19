Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C80CCF2D9
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7491E6B0160; Mon, 19 Jan 2026 05:12:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6F16B0162; Mon, 19 Jan 2026 05:12:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEC56B0163; Mon, 19 Jan 2026 05:12:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A29D6B0160
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:12:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDFE71406DB
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:12:58 +0000 (UTC)
X-FDA: 84348300036.25.6DCED45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A69F4000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:12:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=me8+IGew;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768817577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpEfxgQgJH19fN10/GjA7dR7y5iNeQpprdp9wvrRXcQ=;
	b=ipQuH1hfR77NIylOgdWZiI4ex58WAC8fXJGAz4fRsdAIMfsupo2tllOwwmSFI1iRYyVhwi
	WIhLvTnwKBb3B8RqaTc4QxJuRjktuOZ7Ajpaq/ik2POcJe64gMxuyVx07YAR9kHQ69RZn1
	tH3lhO5V1fnNcpQeFNfiR0BjW/dTIY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=me8+IGew;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768817577; a=rsa-sha256;
	cv=none;
	b=GpUAQMt4wT0EjnqVHtkGQdrEJeu8lyP7kyaxU1q2tj03mgvrC3ATWSTFkbrhRtdWyy1Mkj
	wBPE22xl9WiGXe3P2bHqjP7hCS6EEE7EZbTdrrB1/Z/ieTuhvRB7Ih00tKulJ4zWroyXHr
	F08b1rqCPe1+239qfZwhDCe84PmVrrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30E694091A;
	Mon, 19 Jan 2026 10:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7840C116C6;
	Mon, 19 Jan 2026 10:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768817576;
	bh=JzYfQ2HAxs4i1+wCNZ4YJF2miFvaY77kYkNH822rrWs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=me8+IGewGCeffwxGVagl70q+hrSe2opYVeA1iGHPxfp3jOTyA5Mb5KeeLkc/Xja14
	 HfCoVgl4rWFfeV2WDNbJUF3aDkXBLFx+1M/3Kr8Mo/047Y4IUJprtnZUgHNC0AUUCr
	 89z9nS4T9hLB1/EnWTxzIbJhlH1HocGK/UMOIYYxqsRRynUaByy3bX0BWBcPAUw7sy
	 WQneEXcH6ogG6xNS1YOTkZw8XHe0vetHdKxlkRbStzTvr/D+mbvAndI4gRQBd2SP9L
	 aPNuojOPQ0OHFPjwXGaM7HxgAP5LamThIQoakceGGuilMqy4wQEx6wGMh8/64SuQCD
	 mHUCpaQBpY2lA==
Message-ID: <74607439-5f52-4c03-904f-01c675e8bb06@kernel.org>
Date: Mon, 19 Jan 2026 11:12:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com, linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <bef9fc2c-c982-4b46-b16a-8ecbc9584d62@kernel.org>
 <24837e0e-db86-4c64-8387-243d94293b48@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <24837e0e-db86-4c64-8387-243d94293b48@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 961qgawhu858ndmp31naxgkcf6ezjd5u
X-Rspamd-Queue-Id: 1A69F4000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768817576-279598
X-HE-Meta: U2FsdGVkX19ceTosbELAt7Qa4ofN9ETaKWaILHg+i6C8EWRcaazelTnm2GzhMv5eo/TMkL8QunnX8fWkUbZijkuAaQcTqROhjWAjf/PPfN1cHz4mBs9/y0mAQ8PRmZSv9oAwrHVo5bGZmPkG8dlWM5QIjGj2je490szefn8LaS+dyPdpyJOKH9fj+ecYGJ+ZGiDdyMWXtaLr2UngjWD6Sk7bJRovhNpzTwPx+nuJXbXlhjIrZPzhcynNsmqpf3qMLAS7xQuTMcQ8ddM94GrZUFH5+dqsnYHyCSs9SQb9o+BrwCbVhXQd3/KfqdK9U+9STF/6MU/V0pSm+TntJLCgf+WehF+r1ewcF/b6L1kvW7wBGbgrZd7jNOyWwOpiHilOVvWIDrhPoOoeHCoBI4CSLEKYasl/RnrzJeOH4BHG/8zmYb3plDmLudsCpMhNYgGhIdkUYq2v8AboVXBtqdCxS7tXgV5EDxQXuoB0vtWtXX00wnSAbIPyt2hAmhm6G2K1PZl+pVKVCYJEyKlT3bvzHgWDyiLkfnQSzffzH1rpzoC++l3yji4oBkzjCaPZga8Xa+rH0+ZRBfcaYOijdgrHVkQJ8W+5bzec2N+BTmXlN8OosgSrS6zoUJHnY6kgiD+wE9E0EhOQv9hIhx7FBUdxqXPwAnR29vVuv58Tlr0DKeKKwOB5VyZVl8ObdAw+WpIfIU8JjfDo7mgD0ttGrB2SgWftNHDD6esnE/cb9ZEUfXBc95Mhuwh5va6HYd0aAvUNdQ4pdGzuxLGweIBmMk87fpmxieFkugaAJjIWtcBviOdS8cuy8LvTOUI3ND4IwH0seNaYS/2HwtVmAgUbdgI9EKZaN7OdCnqLeHMW/SKMoB2hv7A+J71fSD/SRUPQxt0mSKl67pq3+9dpJB94k5LAodBWDfHTT9myw0gvFACeyfnE1it9mIrmO71qSa13VP0xPonDlz99vxySz3Emb3Y
 HYITsHyl
 tPkTvzqWGB9f5hWibgJhuBu+3cOCbBf7qK1WKhbk58LoPoI876PFQbUd9r4l/L7y0A/A5FVuH0sl4USp5iy3tY7OHWnXtNQOHISfeVK6yAYsJ+5nLWZk7dlfv8DtXfw14zV0cUMDH4SfLMoMaArmdoA0M9+5lzcgimq3pi431rKYFseFHlMYf7nTsirewYdRSyIH0up+Yvv2VJR8EqetZx43HUMVXuUJg8Q8M9MpBFe1aLHKZptVRBLbBEQDNm14iumiTN3WYCqNTkKLo+KxDRewJddnUlQWW8n4JOx+KMcRda8/e/Smb+TQzZJqNMv9S3EQkui0Svrtfb/gCoXiTUdSHUIN252jrzOicJ/9wRSh0X1qaG752R2Q6g3oxJS87MWuQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 04:50, Qi Zheng wrote:
> 
> 
> On 1/18/26 7:23 PM, David Hildenbrand (Red Hat) wrote:
>> On 12/17/25 10:45, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> The PT_RECLAIM can work on all architectures that support
>>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>>> MMU_GATHER_RCU_TABLE_FREE.
>>>
>>> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>>> to turn it off.
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>    arch/x86/Kconfig | 1 -
>>>    mm/Kconfig       | 9 ++-------
>>>    2 files changed, 2 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index 80527299f859a..0d22da56a71b0 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -331,7 +331,6 @@ config X86
>>>        select FUNCTION_ALIGNMENT_4B
>>>        imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>        select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>        select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>        select SCHED_SMT            if SMP
>>>        select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index bd0ea5454af82..fc00b429b7129 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>          The architecture has hardware support for userspace shadow call
>>>              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>> -    def_bool n
>>> -
>>>    config PT_RECLAIM
>>> -    bool "reclaim empty user page table pages"
>>> -    default y
>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>> -    select MMU_GATHER_RCU_TABLE_FREE
>>> +    def_bool y
>>> +    depends on MMU_GATHER_RCU_TABLE_FREE
>>>        help
>>>          Try to reclaim empty user page table pages in paths other than
>>> munmap
>>>          and exit_mmap path.
>>
>> This patch seems to make s390x compilations sometimes unhappy:
>>
>> Unverified Warning (likely false positive, kindly check if interested):
> 
> I believe it is a false positive.
> 
>>
>>       mm/memory.c:1911 zap_pte_range() error: uninitialized symbol 'pmdval'.
>>
>> Warning ids grouped by kconfigs:
>>
>> recent_errors
>> `-- s390-randconfig-r072-20260117
>>       `-- mm-memory.c-zap_pte_range()-error:uninitialized-symbol-pmdval-.
>>
>> I assume the compiler is not able to figure out that only when
>> try_get_and_clear_pmd() returns false that pmdval could be uninitialized.
>>
>> Maybe it has to do with LTO?
>>
>>
>> After all, that function resides in a different compilation unit.
>>
>> Which makes me wonder whether we want to just move try_get_and_clear_pmd()
>> and reclaim_pt_is_enabled() to internal.h or even just memory.c?
>>
>> But then, maybe we could remove pt_reclaim.c completely and just have
>> try_to_free_pte() in memory.c as well?
>>
>>
>> I would just do the following cleanup:
>>
>>   From cfe97092f71fcc88f729f07ee0bc6816e3e398f0 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Date: Sun, 18 Jan 2026 12:20:55 +0100
>> Subject: [PATCH] mm: move pte table reclaim code to memory.c
>>
>> Let's move the code and clean it up a bit along the way.
>>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
>>    MAINTAINERS     |  1 -
>>    mm/internal.h   | 18 -------------
>>    mm/memory.c     | 70 ++++++++++++++++++++++++++++++++++++++++++-----
>>    mm/pt_reclaim.c | 72 -------------------------------------------------
>>    4 files changed, 64 insertions(+), 97 deletions(-)
>>    delete mode 100644 mm/pt_reclaim.c
> 
> Make sense, and LGTM. The reason it was placed in mm/pt_reclaim.c before
> was because there would be other paths calling these functions in the
> future. However, it can be separated out or put into a header file when
> there are actually such callers.

Most relevant zapping better happens in memory.c :)

There is, of course, zapping due to RMAP unmap, but that mostly targets 
individual PTEs, and not a complete pte table.

Likely, if ever required, we should expose a proper zapping interface 
from memory.c to other users, assuming the existing one is not suitable.

> 
> would you be willing to send out an official patch?

Yes, I can send one out, thanks.

-- 
Cheers

David

