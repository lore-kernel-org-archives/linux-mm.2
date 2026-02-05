Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF00ECD9B1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D796B0088; Thu,  5 Feb 2026 17:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAF16B0089; Thu,  5 Feb 2026 17:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2796B008A; Thu,  5 Feb 2026 17:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBA136B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:50:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94BCCBA930
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:50:04 +0000 (UTC)
X-FDA: 84411897528.25.2FECA9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E03F8160004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:50:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/SR602y";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770331802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMjIABn5049/7ZD02kCjYJWMzULpkGl6BKmXWpQ8qpc=;
	b=xEPxEIYrOhni5enLe/c0rDnxDIuM70fIsQFzN1eIhdDsKQSb5Q7OFeCpu3WUKVVVqFYmch
	4P380ShZq29NmooATegb/1lCIpXhraUO8v5yx/DrA3pE30B5Z5dIIB0c2Hk15XZf3PTicZ
	9DhH7KKrdNWfy4K4S/MsmBVRyPNSrb8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/SR602y";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770331802; a=rsa-sha256;
	cv=none;
	b=6vaD9oq1tkI2wYapsluho/Qj5VR3cImQzmt2990Pbx4nZCqtocz5pyEnPG2oFnWlq+VDrv
	zzN6b5fQSPB7EvvAEABrAAi/glGHjP57dBrxIuqm7ObPFLDG8w5xNdZH3LRMHY1c2SW6Em
	443RafE9FMjA5KCELD7GREtomTrzoZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DABB3600CB;
	Thu,  5 Feb 2026 22:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD4CC4CEF7;
	Thu,  5 Feb 2026 22:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770331801;
	bh=YOPGTx/uNoRGPiTuKSAmlmtOdQ94Syqiy9VQuyFLLX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I/SR602yFdV2tzlaJOUFUht6cqmXFbDlNvkdpb8TiBZLqYQtp9nr9sR9trhMk9dFs
	 uiy5i4ApupvlkMfhZIp6wryR73H+/vV/1JvDQBlQn2TruL+9EZ9lj9dPVV9WmdqyW9
	 qUabqRNLGg6XhymBVYvETuIGbydf3vqDvcGre4MuuTn46kmJRFLPcvCiixzq6V/nI0
	 PZ7L+roqY1Z7YgXnngGxQbQYFDDcTIFPsW3CW2yska+ACb5kqVviK+RJQBQhth5uVk
	 YicdSNkZhtDzkupG4V7xrRO+KKNmWZGjxnaHzyMCjN5rJT+fsfHc7/WiL4GEkZCoc9
	 xsTai+DaQFGXg==
Message-ID: <bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org>
Date: Thu, 5 Feb 2026 23:49:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: Dave Hansen <dave.hansen@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Lance Yang <lance.yang@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, aneesh.kumar@kernel.org, arnd@arndb.de,
 baohua@kernel.org, baolin.wang@linux.alibaba.com,
 boris.ostrovsky@oracle.com, bp@alien8.de, dave.hansen@linux.intel.com,
 dev.jain@arm.com, hpa@zytor.com, hughd@google.com, ioworker0@gmail.com,
 jannh@google.com, jgross@suse.com, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 npache@redhat.com, npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
 <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
 <aYTJzft5cuqD9akC@casper.infradead.org>
 <6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org>
 <dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E03F8160004
X-Rspamd-Server: rspam07
X-Stat-Signature: ak41mf79t5qitco5pd8dcf6nzxppu6f7
X-HE-Tag: 1770331802-388257
X-HE-Meta: U2FsdGVkX19Z5gTWcX5eJlvvrYTaNIOvdzPZeNAI8z9dnPrPRxQbSyVOxJPoRifAUlpIh0UdJyAncvBgw9Ev2MybgaSRhimPXb+lptPwKIKrtORhogldZGlPh6WY8zg1/UGqff0YtSpPSPRnodyGUdoYJP884FeOkErihJWgJOGIbz7QL1Gd2dUvFAOT8kHeSk8Qr4eq/xfzDDUIc7qL7dLUl01yvAKnE08Bz877zLtBYw65IheKjv7kHi48SyyZn7lOT0jUwTqDIHZC/rbp/UOIdMnnzdIpuqN/OWJyq76VSCdQS32BEg2JQqeAxIP4pi2GlNt7N1q0bwqzOAhVsbKQ4T0txQBvMqvuvzgCc8PDTscCe6Ys9Et/ooFYO4/G2XAnXV2J//qYksSIPDNl8BsD6M8e8cZs5zZ/PAaVOfA1w09zKL6zdK5pwDY8wstQtvBiLmILSdky8eTGYx04A0+M55yCIYucjURB0iKwTzEblEWnLdRp0thEZ0l07UQy5AHLPJSwJuNRYHKyn/iMpAc1AWmpUi3HGbm5SKF0N4N/jYAnzRaKop+2E46AOT63TDcTi/Av4NJ8m/Ec8jIHdqzAeiyqZf2UrjoKj8CoQko4gyjTXohKOoVc5eRhE0fSRwOQJ/6LAZAm9rFPdu/6C6b4k6b6qy8TPVOcqOr7c+UvA3VCEQotPFaM/2fKwpqBF64Lg5V7d4ZrtxGS1t6AsoY23dGS8D8QrhMDwBHNNnuFRn1dt72lF5POfVll+tw3CpgoXmLI9fn9JMnVFUqnukwQgajONWW2yHJ0oFBwBgrLC6mNw0m/yrV4ymm/F3SIaT3DsG+sd3HC9WjmPWCAlvfIn/n6iI4/eTtNigFap4K2QUT2lLVP5hDjFYoAI7/MQCmjBHT5DfIA+8ekNc12yzGAu0toYCQDMwvKcbCtteBEPLimX/j5mzko1bkY/6ohtO4TixpBY5OgOZ5QHU+
 9RSHvKuF
 HrEJK2oz9ImutydFN5o9ne23/5Ya5yjPBpu9TlpbwQR2lrRRwndK502Oym4ZElgwoCV+GPI2/8QHj11j17uxeRsm78WPdD3jV68ZxDto9BT0j1yG2rQzw36C3ZKt/rnLTpMdLEe7DWo7eyLEMB/K1zUx4i4BHlEdH9qlnjAwW2i9hJuzeEiVzmqMwY2vhiibiN/apxKvGNdFEv2Rfqlnp3ycuwtjLsn+A0Rfsa4CI22XYoPMjCc3j/ShETewbBPz/Nqe3KzdA/0KY0AsTef1pgrl/3Ss24Wvbaxmr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 19:36, Dave Hansen wrote:
> On 2/5/26 09:06, David Hildenbrand (Arm) wrote:
>>> But can't we RCU-free the page table?  Why do we need to wait for the
>>> RCU readers to finish?
>>
>> For unsharing hugetlb PMD tables the problem is not the freeing but the
>> reuse of the PMD table for other purposes in the last remaining user.
>> It's complicated.
> 
> Letting the previously-shared table get released to everything else in
> the system sounds like a fixable problem. tlb_flush_unshared_tables()
> talks about this, and it makes sense that once locks get dropped that
> something else could get mapped in and start using the PMD.

Yeah, I tried to document that carefully.

> 
> The RCU way of fixing that would be to allocate new page table, replace
> the old one, and RCU-free the old one. Read, Copy, Update. :)
> 
> It does temporarily eat up an extra page, and cost an extra copy. But
> neither of those seems expensive compared to IPI'ing the world.

I played with many such ideas, including never reusing a page table 
again once it was once shared. All turned out rather horrible.

RCU-way: replacing a shared page table involves updating all processes 
that share the page table :/ . I think another issue I stumbled into 
while trying to implement was around failing to allocate memory (but 
being required to make progress). It all turned to quite some complexity 
and inefficiency, so I had to give up on that. :)

> 
>> For page table freeing, we only do it if we fail to allocate memory --
>> if we cannot use RCU IIRC.
> 
> But that case is fine to be slow and use synchronize_rcu(). If you're
> failing to allocate a single page, you're in a way slow path anyway.
That's true. We could likely do that already and avoid the IPI broadcast 
there that was once reported to be a problem for RT applications.

-- 
Cheers,

David

