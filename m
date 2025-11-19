Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6D4CF31AD
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 11:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2456B008C; Wed, 19 Nov 2025 06:39:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B6A6B00A3; Wed, 19 Nov 2025 06:39:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133FC6B00A4; Wed, 19 Nov 2025 06:39:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F05C06B008C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:39:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89C7D14049B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:38:57 +0000 (UTC)
X-FDA: 84127159914.21.17CA562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id AF4B340016
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:38:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbpzBxMP;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763552335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1k6hiefpZNiDm3uqDBvrzYJ/HsNFRw0daGH2fKm6G6Y=;
	b=ehjhuXQsXs2kPdqTaKJ+HD43e9sMYFtgetSKnFnBt9q+90bZjrGL7dueeLEtzytisjPkKj
	SKCnSiOQCCNpU7lVhdUgY1fsnQ/UHmnRrvl68r2Mk+v0/lnZi/kv+sQcxW7PELslwSGrNM
	3DRbBUGCnady5+VgYyH5Mr+N2Rew7ss=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbpzBxMP;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763552335; a=rsa-sha256;
	cv=none;
	b=IpX80dZ5RXeiQr7cLWZvv2cvvyp3NfbOLHAepcGh2bI0TohC0SMeqX67R5rTgy9qf2hKGw
	y1PQ3diRYD5FsWvGwcgUMVytuYiga7yXRgeHyo/9d23qlG8a0AM3J2N4TdTHixzWbCxLZ1
	mXgzcsjZ8Me8QeqDGSRT2Do5Ss8udOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9B6143B53;
	Wed, 19 Nov 2025 11:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B7C2BCB4;
	Wed, 19 Nov 2025 11:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763552334;
	bh=09EAP2XN+lRanTOPE2mYQg/imEyLIAMTytu/FERJ3KE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZbpzBxMPlijcUIWVvcKZTNGa7zCAJwZY9chXx+w8GbRHAR+rI1lSfYrqXSSvSDYaE
	 MePEVV4EjqdFYyQgiSidQHYaWwO7pQarT3TKZOtNh3sSfSwIQ6SflX1gDL9lMSxLny
	 w06MV9gY5w5TZlc4+ewlulKiXr9osdtN3qFwbuQWIMM4miVH0RvJzhNpO1lxypNit0
	 eeE/heuKvBJlnAAv4sK4Mv4MYw7Xohrvhu7Amo4HOBaY8PCND2DXnAiONttsXskaMh
	 8/Bno4vIYUEF05KYxb1WyXsUI4O64niqkk/pUg+0oPMnWbdq0tM2VTdA0KoQ6gV8im
	 c4sJ+iwsxJ/XQ==
Message-ID: <9b55623a-4606-4610-a0fe-55b8cd6b95e7@kernel.org>
Date: Wed, 19 Nov 2025 12:38:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] mm: enable PT_RECLAIM on all 64-bit architectures
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com, linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
 <caacf08b765ef00770b7c75afdb5e5754485b2aa.1763537007.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <caacf08b765ef00770b7c75afdb5e5754485b2aa.1763537007.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF4B340016
X-Stat-Signature: m31gegs4ec35phpkdxz8jjjcm87nt1n3
X-Rspam-User: 
X-HE-Tag: 1763552335-981251
X-HE-Meta: U2FsdGVkX180yZSvquBDGImaLrLQQbubWZd14iquwsWNTMCsIJ8g9jWmb/3Qfla/LGAtYol5GZfTaeiS1+/g+fYfnRO7E0ec1KB7/+3Jsd3Gif6b8ghOoOhBn3SADtislNNGT2tacIXXqDB05RKiAoSzMUG1G6RpluPZBHrwl0zdeL8X9ee+20eUsiZicMAfZt3cpooNZi4XZf7wdJLKd2Tqf9Y0xRBmJyOoO7Iyy/oGJ5yOscqv1h2HNwCP03xJSKTfs7WfY9KWQkaD52/aXeOQnDkCe/QCWYbUmo9u3MfTrFnk+Ften/UK2yUpzpjgATIkp9bxDpD4V4R9WhQ6lk3r311ZlBO+yQBsuYt9tqMUPXky1qvk8iNLNXQ6vI/dCFPXhV/BdoC/wx76G55nan3nEFKEhXYMJYIdWCEtes9Yrx44VomaCrDmL+pCkR7anMFmUMUmhemJ1dxqpnHJCfRq7UiItT/ZQqRfRoscgTcBphDVMtNQ964WbNk2ZmWnU/Gojh+L3WQBkqviD9IaIClr3NoCV4UreTWmpx0519LgNgsTxMCMcK8iawZQ2bI3DvcbkLjjibsN2rZEwAE+DtEzHqwAWETQEf5J+qE5BaFujBlwq2SBkIQipdnZZuCnEIIum/flL+7NtlWSFgjPtYwsmeaO7xtFnoO1TXOGFVbbEEG+5g84Ee9d2sKufFIFaOkLZTvJweywTl0j4TP834AbA4lVfwVjiMcWNmDAdRvpmfXRBcq9kPimF5edyPAJGLmZqGaxwyOrtP9sSNOxkP20wbgktmwTqq67K1MwHTEE0n2wwocti1qhR3j1qB5hbrB9vN52emist2S6TF6RJg71ho19VPQcYcjlUrSmIAht+pxZt+KmPXC2GzK7mp37vfubWsVRz6JtWEoPMiVEsmy4w2F4jqvJRvvhvzcDENqbDGwst+fWqrGPx8K1UKlsEYIukW2BUSQghbFpDxx
 JYpoaLni
 ApLX+5JwTMVqz3iMkCJ94BZ/YqqRvJFPfMFxy+dFHsocBy9PF5aeuyGD6cs4whktHcFqy8Hn/3n9Y88X4EXu9QL6BCHSpijDG4V5eyi/qluZyMD+lX4kXmkNSskysjn+/pXWN6qvyLhDw7lyMX4ZZcqzju+mO8OpZdg17L663KpV06QddAsvpBdepNAAwARgy5210wJZV1VI6VdOBhGXAHFsSwL4CYwVP0EmJ4QsilkLPRd8kO0zb9/bHJTcYGc7Jl54zX1rrPYgPaCm279f03Zf9xt0g8q75B33xDWyqNt2Dk+u1X9S3TkyLVU4KqSN8LRtVPf4t7TjBKts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 08:31, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Now, the MMU_GATHER_RCU_TABLE_FREE is enabled on all 64-bit architectures,
> so make PT_RECLAIM depend on 64BIT, thereby enabling PT_RECLAIM on all
> 64-bit architectures.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   arch/x86/Kconfig | 1 -
>   mm/Kconfig       | 9 ++-------
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index eac2e86056902..96bff81fd4787 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -330,7 +330,6 @@ config X86
>   	select FUNCTION_ALIGNMENT_4B
>   	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>   	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>   	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>   	select SCHED_SMT			if SMP
>   	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index d548976d0e0ad..94eec5c0cad96 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1448,14 +1448,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>   	  The architecture has hardware support for userspace shadow call
>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>   
> -config ARCH_SUPPORTS_PT_RECLAIM
> -	def_bool n
> -
>   config PT_RECLAIM
> -	bool "reclaim empty user page table pages"
> -	default y
> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> -	select MMU_GATHER_RCU_TABLE_FREE
> +	def_bool y
> +	depends on 64BIT

As discussed in the other thread, likely

config PT_RECLAIM
	def_bool y
	depends on MMU_GATHER_RCU_TABLE_FREE && 64BIT

Could be nice, and if possible even dropping the 64BIT limitation as 
well if there is no need to.


-- 
Cheers

David

