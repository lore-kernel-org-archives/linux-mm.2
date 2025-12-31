Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F58EE57FA
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 09:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792FD6B0088; Wed, 31 Dec 2025 04:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7166D6B0089; Wed, 31 Dec 2025 04:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622726B008A; Wed, 31 Dec 2025 04:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 524E46B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:53:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D095FC2C93
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:53:11 +0000 (UTC)
X-FDA: 84279302982.08.0DEF3EB
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id D7CE51C0003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:53:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kA0qCy5s;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767174790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wl7HEoZMUzGsbQepWMVSfO0JV4YjBapS0e5mq4W7b+4=;
	b=K1sK9smldBShtXf000EQNmhBNgxOfFC3qZKoYLLo8HhsJd3G+awsitJPeX9IDvgHUyYF4B
	GBesQuHoBTabYCpl9arlp6y0hSICYq3/jtlgPYgeFZcabooEA9QT4oALjq9In8lnQYRcYI
	k/8c0OJ2yHh10fay00RXJBytBdk5JK4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kA0qCy5s;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767174790; a=rsa-sha256;
	cv=none;
	b=heLyEPu0nZ9SQGjhcrG0y7igEGgbMf+JVqJmHusXsx7paXJdRmRLvA41zjxyq0I28NCz6E
	ONLH3VGahFmSyid9jZ3toaqz3wKD8UFLUQnu2X+pgjPXOOdlM2JRiPpp4APHsIdYXFh0Bs
	gpCMMtIT1IkBzcUcqH76zC+htKr+ttU=
Message-ID: <a3a60bbb-70b7-49ed-abc6-937e6c13d681@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767174787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl7HEoZMUzGsbQepWMVSfO0JV4YjBapS0e5mq4W7b+4=;
	b=kA0qCy5swxT9/bUHnpErzkaTUIfgXxao85n1AotjzFLMJUomMkCAQjLXpZ4B+KRO9Tbq2L
	WU+1OAl5FxBAuCo1I3+CkOeCjPhLEPbag/rozOxh+CRn8kHOwBSKIYK4ige8l1o+gK7jtK
	Vz5BljGIGicYjbCKFeIBggxM5nn/wOQ=
Date: Wed, 31 Dec 2025 17:52:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Wei Yang <richard.weiyang@gmail.com>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 david@kernel.org, ioworker0@gmail.com, linmag7@gmail.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <20251231094243.zmjs7kgflm7q6k73@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20251231094243.zmjs7kgflm7q6k73@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nykufjhkg9ifg9ydfqqzhjgpbdiyeawn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7CE51C0003
X-HE-Tag: 1767174789-456259
X-HE-Meta: U2FsdGVkX1+GFa7AxTs2kcuErBGXPi+RhzGNhYwNIS2si8K7uldOwGPCmbDkkjRqH3rWw4j/4smLgGz1E+XKzsckahtu4wDQY/qL3bzfaPM+c7skOjDD+Y6j/LWyANKo2pPB1pC2LRLD2Yu2rQFq4oHR++mqEXZZ+hKwxoz8rnnKhRno671TUbh6VCcCIYF0Pxy8u6FhpUk5NQGy5+Mz0YYi4yjURA/7eKMEGibN1HrQzYELa/sX5PGYBhrS+Jk56RXNvcHq/j1tf1gs2PAjgyAyHm6F1sGKGTFoZqW2CZs+22QwFtr8RtcVczlbwTODobTZteyBY9b7KEx+crrT3qKDpK2cwK0mxCA/ewawShCRTCl7OfmvhezWQEx1r1pc9sE5b2Y/yFpuV7o5brEsElubBl3gFamFKtjJZW3xFm3mDanR/FBDnOqotq7PDHksBnpR6K+jRQK2K1VA61EOh5KzMwTm2JBiCrSFJ/ubur2O/WXTdLqTynDvrgYziUkw31OtkZg2YLKs400GbbY9PTVjvyDBsAvEVEj1NHosfM0Uq7O0h6m6qESojizm73yuneZGdY1qYlYyCd276oN83+ccI07TnGCHH8WMsymNZpPR1m0ND4WDKUH6sMCMlpLQfzef0aCHXlbfZr9uW7hL9KW1lBXrwelUCs82dQnn8GEPUQ5vxVTMJdzPCIUzVLM81nVKcZeETYqvxK7vk8eO5LJOJnQZW5kar1sHkQ2PSCBoTbHUwNg0NPBa0uh1B+ukjkmmyMap0g6z/+ky+5UZeCQogKTBVUeVWFngpySFStgpdDHMWCyFMbR+Ab5Tz5W+2h/sBqriY4uVKRh/jIPBirAwb2QSCEotfdF8c7Mf0yWC59UTVtpLJEFQ9FX5naBnu3eoX4rkuY70SJL6WXU5gm6swn0REF03bM/AhB7pGwhQ7kbugOO0JyOue0k0/HNDi7iZOiDreHqQwCsw/kW
 PpBKj65b
 LL/hFMXQzFidxyfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/31/25 5:42 PM, Wei Yang wrote:
> On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The PT_RECLAIM can work on all architectures that support
>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>> MMU_GATHER_RCU_TABLE_FREE.
>>
>> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>> to turn it off.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> arch/x86/Kconfig | 1 -
>> mm/Kconfig       | 9 ++-------
>> 2 files changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 80527299f859a..0d22da56a71b0 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -331,7 +331,6 @@ config X86
>> 	select FUNCTION_ALIGNMENT_4B
>> 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>> 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>> 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>> 	select SCHED_SMT			if SMP
>> 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index bd0ea5454af82..fc00b429b7129 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>> 	  The architecture has hardware support for userspace shadow call
>>            stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>
>> -config ARCH_SUPPORTS_PT_RECLAIM
>> -	def_bool n
>> -
>> config PT_RECLAIM
>> -	bool "reclaim empty user page table pages"
>> -	default y
>> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> -	select MMU_GATHER_RCU_TABLE_FREE
>> +	def_bool y
>> +	depends on MMU_GATHER_RCU_TABLE_FREE
>> 	help
>> 	  Try to reclaim empty user page table pages in paths other than munmap
>> 	  and exit_mmap path.
> 
> Hi, Qi
> 
> I am new to PT_RECLAIM, when reading related code I got one question.
> 
> Before this patch,  we could have this config combination:
> 
>      CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM
> 
> This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
> is semi rcu version.
> 
> I am curious could we use rcu version tlb_remove_table_one() for this case?
> Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
> there some limitation here?

I think there's no problem. The rcu version can also ensure that the
fast GUP works well.

> 
> Thanks in advance for your explanation.
> 
> 


