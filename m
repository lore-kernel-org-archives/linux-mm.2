Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB70D26D6A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF926B0088; Fri,  9 Jan 2026 10:40:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D476B0089; Fri,  9 Jan 2026 10:40:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53EE46B008A; Fri,  9 Jan 2026 10:40:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 418826B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:40:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D36BF1A0241
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:40:32 +0000 (UTC)
X-FDA: 84312837504.29.B663509
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F003E40003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:40:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K11C6Tgv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767973231; a=rsa-sha256;
	cv=none;
	b=bCtDnUICOSwWncg3RORPDJwNnbVQHW+Q6Ueu7d5HQHb0uwkAdPbE/676IgLYj7CoPaVitD
	Xrh5jaDApOOLX7HLkowcGoqzIk/i7jaNGUeDHcJjfuTqywmhLLZTaS4j+mhGNFwn/UawN2
	BTKxKucY4/QQQGqEgjY7FqL+l3WsvE0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K11C6Tgv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767973231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti4yVHUrx+jeohwN8YsvGO7hvE00mHXcQo/2klPesLU=;
	b=YVNbG2h0Owkrq/hTE//e5HIygbxOgJ0fV+zPY8rI8kO5HHUyRo2HkhgCyaOCNd+tNRQX4X
	6zmdK6UVwvXUlD8hczGNYWYMOrTi9c7QKaBQL8CatoE3YzwF8RX7A8b5Yi4/m7xai+V4nz
	bP7Qlii7pUaC5Cy47C7Rs8LnSw4W44w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCB90419B7;
	Fri,  9 Jan 2026 15:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3379C4CEF1;
	Fri,  9 Jan 2026 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767973229;
	bh=MClLfcW/LlA2fAjKxgewmcykTxQMbVVC8RBgYHlNmE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K11C6TgvxC8lsO0GRbqPjDBs0iDEYVVrnJ9KHwUsxL4dFqHYpSfmz2qn8S1nwvtS2
	 TqRxYkFkIdC4lOBszkOcY9dmC8sBAUaCanbxtGAW0Tu4Qb/3OZd/rVMKhgoti9NdVp
	 Uo1FoJNzVH6K2/DQ9O/AnIfl7x16z73RqMb565AtUaaMDru6CUZwdHcB0gbrn5KMta
	 LuM7SVgKVjSXmVfyU7KWxLUnyxx1zAVY3sbea0QBgfZoJnIKNhcy9ad75bGaoASXUn
	 3L5LfheloI+TrzIbPYDnbDmjuw43JcK4oQ0mN411rebJExnd+4WrP/4oVNEV06Uy5y
	 zqGxX7ux9jmKQ==
Message-ID: <bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org>
Date: Fri, 9 Jan 2026 16:40:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
To: Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com
Cc: dave.hansen@linux.intel.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
 <7472056a-3919-429a-845d-c2076496d537@linux.dev>
 <4d94363b-5b3b-4401-a9d8-da136d71f8c3@kernel.org>
 <f45a1760-7fa6-4e2c-ba5a-90e250a5792a@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <f45a1760-7fa6-4e2c-ba5a-90e250a5792a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F003E40003
X-Rspamd-Server: rspam06
X-Stat-Signature: nikswpm6ebnfwa1ayp1rt5h5yjfsh8wd
X-Rspam-User: 
X-HE-Tag: 1767973230-536427
X-HE-Meta: U2FsdGVkX1+HGKNqqrK3NoZpMX8n3Lh6fTyMDHdLAhORiXUrQQrjOaJGGD44dR1OBMgIfB5FaOuQGZLFac1sQec1DNhN24gDCj5+3dklxLQBncCzMV5epPVjE866L73mBeQvUsnmYHB2L00nNHPmnLNq2lGyaqkD0hsNDxyxXwZFw4ckNmUSUgROwN2zL9aZqz9TvNrZhxv8yC+YpAnF8sOOk6AiRRAy2atOBh59GaDLWHilSDrMrkcKZ6ovSflo8W/oHNEkz6lVtd3ezut8TpT0bvcLT0Yv1ue4bsEZvA/D1JyCaX7z2mMgFsVrryUvhyq5GPpB7WNiasZXi7ZiW+j8BvuDw5l5f3kGPzbEGBSj6umSUkxEoBp2CHtDuwlYtnntQW0zfteQsHrHjvOyQ4MnFae+1sREPtKzw4oq8Nga7YG0ke4QUEe1AXW0FLowY85n/NiLtuY8ClsfjxeLsOFHTCn21+9u+MgTvzAAShYJZtGfNKK28WTqbh0rML922JoIPJwcONZi8q+ylFI0iqTYztRpFCsmskM/mtyyZqcIbSrZ8YR97LFjox7Q35CE8UGx5iOcu66twQ1G1iQs5W+yPXOm5BHzix2LTXnm5/psC73imrqW5A9Xetg4PmoqST9beMoQKaXtBjsYP0UZQ/1eEauhSJq4b8vfYl4PpdU8ytHrZMm9g0D2iyY+Jl86vwjoNoydrpYCD4n70eiio+VUfSmkt92HT00qcpNbuUcE4aDti/JtvwjwA9S9uUwTsZ6v89LHBvV9ypQHG52SvscnVE3VtschW3h6Pa3GMdsI/sZo5HsbDuOLprunrC4wJd4Liv+fjrFLkPr0ZCSkxSfQPzc7+g4ktMpAHuvU17LxIUIikL8Xa8osZ7MgaODSdx+hWjWcTDc1B/qgk6ORUGDD2esKCZCSZd14kZcs6ayfU1BZgYOT7qZePovLmt+2gnivLM85d0QGCEA3c/T
 h/QjRh3Y
 /p6nN2YWR2l/QhxYT1wu0zuxus9JAfp4MYXqbBK4Bd3AfnksqeCPFVmsPCm4lyI8fNg44G3GH2bvoY3T/SRQu2yfUfixj1EleZDMh4cpXwOKOt9VmDM8rHCYW96fnGXRgY7AotMuFGVclq2OzDGm9mby4sdxcGDsLiG96z4khPBMi2nPsriOvg0xXK67WqIuHjyXc6kF1AzhnKAcnxLSEdJW4i/FPkxW8ejA9YYlWNDb2a7efHYkm2mQJvGybOl1+MvNr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 16:30, Lance Yang wrote:
> 
> 
> On 2026/1/9 22:13, David Hildenbrand (Red Hat) wrote:
>>
>>>> What could work is tracking "tlb_table_flush_sent_ipi" really when we
>>>> are flushing the TLB for removed/unshared tables, and maybe resetting
>>>> it ... I don't know when from the top of my head.
>>>
>>> Not sure what's the best way forward here :(
>>>
>>>>
>>>> v2 was simpler IMHO.
>>>
>>> The main concern Dave raised was that with PV hypercalls or when
>>> INVLPGB is available, we can't tell from a static check whether IPIs
>>> were actually sent.
>>
>> Why can't we set the boolean at runtime when initializing the pv_ops
>> structure, when we are sure that it is allowed?
> 
> Yes, thanks, that sounds like a reasonable trade-off :)
> 
> As you mentioned:
> 
> "this lifetime stuff in core-mm ends up getting more complicated than
> v2 without a clear benefit".
> 
> I totally agree that v3 is too complicated :(
> 
> But Dave's concern about v2 was that we can't accurately tell whether
> IPIs were actually sent in PV environments or with INVLPGB, which
> misses optimization opportunities. The INVLPGB+no_global_asid case
> also sends IPIs during TLB flush.
> 
> Anyway, yeah, I'd rather start with a simple approach, even if it's
> not perfect. We can always improve it later ;)
> 
> Any ideas on how to move forward?

I'd hope Dave can comment :)

In general, I saw the whole thing as a two step process:

1) Avoid IPIs completely when the TLB flush sent them. We can achieve
    that through v2 or v3, one-way or the other, I don't particularly
    care as long as it is clean and simple.

2) For other configs/arch, send IPIs only to CPUs that are actually in
    GUP-fast etc. That would resolve some RT headake with broadcast IPIs.


Regarding 2), it obviously only applies to setups where 1) does not 
apply: like x86 with INVLPGB or arm64.

I once had the idea of letting CPUs that enter/exit GUP-fast (and 
similar) to indicate in a global cpumask (or per-CPU variables) that 
they are in that context. Then, we can just collect these CPUs and limit 
the IPIs to them (usually, not a lot ...).

The trick here is to not slowdown GUP-fast too much. And one person 
(Yair in RT context) who played with that was not able to reduce the 
overhead sufficiently enough.

I guess the options are

a) Per-MM CPU mask we have to update atomically when entering/leaving 
GUP-fast

b) Global mask we have to update atomically when entering/leaving GUP-fast

c) Per-CPU variable we have to update when entering-leaving GUP-fast. 
Interrupts are disabled, so we don't have to worry about reschedule etc.

Maybe someone reading along has other thoughts.

-- 
Cheers

David

