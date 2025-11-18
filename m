Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332EBCED617
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 12:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E726B0089; Tue, 18 Nov 2025 07:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71ECA6B008A; Tue, 18 Nov 2025 07:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634BD6B0093; Tue, 18 Nov 2025 07:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5159D6B0089
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:03:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E09B55952F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:03:44 +0000 (UTC)
X-FDA: 84123593568.21.91E04D2
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68E5F180014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:03:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z9Rbcq7i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763467423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSfDkQJHByC5W64S3r1RZBfV7l+QzHRtZt5IkHkWjXM=;
	b=j/HOK51pFE/+85blaaocQoXEPdD18g6MQ8FZgM30yBVXEkhA2ih+upHiw1veSgSNmFkXwh
	8dH5FpdakbeTpITy2hCirHCvPb1Pi97SfOiUA+hec0qAtsxAcWFgBon+LaFL2CyIYt449P
	2afvIY8xWfhgVCLsbWtiTtnPQfoa5bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763467423; a=rsa-sha256;
	cv=none;
	b=bHwmYMctbk4Ze9ZOYF/kdijxXuPV9ANSP3zMOeATUy9Veku/k6tO8i/OgUQD0euayLAIeM
	6PnzDtWUrk9o/IkJaOkv+AhlOl7yx45XrIjRsWeHOeU5hS2UUDGofQTKTFCl7BdEAJlm6N
	qNPUuHoBVZoZeD/mBiuf8b5G1HFYiM4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z9Rbcq7i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <195baf7c-1f4e-46a4-a4aa-e68e7d00c0f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763467417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YSfDkQJHByC5W64S3r1RZBfV7l+QzHRtZt5IkHkWjXM=;
	b=Z9Rbcq7i2Y1LGHCoUGuTi6ppSLunSulmRKUQ4pjayjy42viyJ+DcXrTYmImrfSRJw+UKR4
	UVTRGLFHLTlNdVaXnjT3ixLkagqhNZyq0Aqov/I7FCpMijq/fe4cVtkKv+q+YaHP5txxbN
	qqqQe//KpgfJbRYA+2BGf/imvJ4aYQ4=
Date: Tue, 18 Nov 2025 20:02:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
 <355d3bf3-c6bc-403e-9f19-89259d868611@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <355d3bf3-c6bc-403e-9f19-89259d868611@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8hppcrzibrrcorxo3o3nh6erf8pn9xx3
X-Rspam-User: 
X-Rspamd-Queue-Id: 68E5F180014
X-Rspamd-Server: rspam10
X-HE-Tag: 1763467421-75557
X-HE-Meta: U2FsdGVkX19Q3gGbrhlJVtcXlvx7a79AUAFGiEo0VSmGS3naame+BSh7LBr1NoON9hoKz4RO5tnEYkXdRS+veBPQBKVbLGnMgyT7xr7R3hfOuAli0ozbNesD47VD/l9x3wDBQLXqq28Zy6RvRpYuXIOhf9wMBp+akvPn1jrdbHNuN7UJaU4GX7MDn1CZ6cwBVV35NhlNA5wFWbh59EC7UstUMFdkbpw4xeti8TJB2hVjqjgF9JLpwTzRO8B3Zn7c9ZWZuGufi4t6upYMyOvvRrXS1AkdZCaRkheu4Kma7tgYNCZJTodgHqdF51eEtd73Au20+dX7OUVSQwRNv3szaa1cVSbH3I+Vv0BjBvtX9NYUKXwIOw+08IaoeV7vcoxnM9S5akGJnBIv2QgISxtIBT8I17nbrIEF+VWiXtNVYB3LY0RxR/Y+y4QhHCuQKzOOk+H2ak3Ml8BF2qZJXBd3Ja2O1vBn1rJ+s+A64Dx0nqXx0CxlGJfP+FdxYmaSN+V4WYs9k6uSgpzFiNuMP7hYh9T5CvkKzH/qhJRQcsnzbSOBPgs0WH/3zf9z2QefwVA6vV1Rv5jpTaBOTIYebElOu+tZyKMhdjN+vb3KlN3D6AC5+TOVKmBVsQ2bqi4TcahazHD49nePel+7agjpd19MCXJRpPvoL07U2LakEDo83VL/Ogd+2YoNqM6cvmdaegshvS3AcNdn9Y6qXfpPQIZLPZYC3x/rSEW0Dneg2AgRp32ADV+5byYAKpxZA+gXT6PB6jPVUz4kWYqP2KymJKhHwepOUz925k70arnLSGdm0t4S3NDFj8QOsqsDAhEiMBBqIkKlzWrpAiiJeKKkGWeiHP8kGIdjrZO8MXTylEpcZ4d34vKiROXn0BSJoMI95x1+qcWljUsyTOiJsXDCocPXu9FmoWtsdyjfGMPU19Y5ywMbbtqVWMogTDBl0qVu307G0jIuPbuJA9AiiNsvvCb
 sEbev0hL
 Q/bTfLSRb0P/qP3bCHG6cG0MLOgKombGy8vAAovvdJuvoDrRTWQcxJZzH1zePWRB8KUbGL7Ch0iF8wHv8OUedQIKc4xdaPfOAG6Bcpe/vhOQhroREvgT5kGuKqdzhh4Hy17VxKYWQj1Pey5AF5x4o03Qm1hSC+wuzta3F5VkQUVfqg1r2mb+vYcNo9muNHM1R1k0nUvfKffopYqpfxX2g0RPlMZxfPJE93vxqqhsaug5C+0pEgRC0AQjmJ/EQK189Ar+fif8J9MkRwnyFkrf4fNnRZ9Z70VrbdJQ0yq3XIVtiKZdItYxV7yV8kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/18/25 12:57 AM, David Hildenbrand (Red Hat) wrote:
> On 14.11.25 12:11, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Subject: s/&&/&/

will do.

> 
>>
>> Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that PT_RECLAIM 
>> can
>> be enabled by default on all architectures that support
>> MMU_GATHER_RCU_TABLE_FREE.
>>
>> Considering that a large number of PTE page table pages (such as 100GB+)
>> can only be caused on a 64-bit system, let PT_RECLAIM also depend on
>> 64BIT.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   arch/x86/Kconfig | 1 -
>>   mm/Kconfig       | 6 +-----
>>   2 files changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index eac2e86056902..96bff81fd4787 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -330,7 +330,6 @@ config X86
>>       select FUNCTION_ALIGNMENT_4B
>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>       select SCHED_SMT            if SMP
>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index a5a90b169435d..e795fbd69e50c 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>         The architecture has hardware support for userspace shadow call
>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>> -config ARCH_SUPPORTS_PT_RECLAIM
>> -    def_bool n
>> -
>>   config PT_RECLAIM
>>       bool "reclaim empty user page table pages"
>>       default y
>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> -    select MMU_GATHER_RCU_TABLE_FREE
>> +    depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT
> 
> Who would we have MMU_GATHER_RCU_TABLE_FREE without MMU? (can we drop 
> the MMU part)

OK.

> 
> Why do we care about SMP in the first place? (can we frop SMP)

OK.

> 
> But I also wonder why we need "MMU_GATHER_RCU_TABLE_FREE && 64BIT":
> 
> Would it be harmful on 32bit (sure, we might not reclaim as much, but 
> still there is memory to be reclaimed?)?

This is also fine on 32bit, but the benefits are not significant, So I
chose to enable it only on 64-bit.

I actually tried enabling MMU_GATHER_RCU_TABLE_FREE on all
architectures, and apart from sparc32 being a bit troublesome (because
it uses mm->page_table_lock for synchronization within
__pte_free_tlb()), the modifications were relatively simple.

> 
> If all 64BIT support MMU_GATHER_RCU_TABLE_FREE (as you previously 
> state), why can't we only check for 64BIT?

OK, will do.

Thanks,
Qi

> 


