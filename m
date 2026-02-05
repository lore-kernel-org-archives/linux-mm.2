Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01BFEC1EA2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207F36B0099; Thu,  5 Feb 2026 06:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6036B009B; Thu,  5 Feb 2026 06:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5636B009D; Thu,  5 Feb 2026 06:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F001C6B0099
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:22:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D93C1C3B4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:22:24 +0000 (UTC)
X-FDA: 84410164608.12.A59D935
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C26620002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:22:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMdBeOSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770290542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7IgrYyjndK7+NvhUmbSOL9i6+x+uFretOEpg54BU8U=;
	b=oluxim9MnMJsg9TRPghYCO0EibpEoFCVTM04FW40Z1x2O8XifXq2QL0dfdhVslsq1pf0TR
	lKV3qZCd5SLOuO5awf6OBCHO9HhEFNU979R7X+CqVyqFtUqPRugAU0Fz1ZQt9uKLgH1/+C
	ZblmyZxW58o31feJbLobQdaZWE/1670=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770290542; a=rsa-sha256;
	cv=none;
	b=0CAcEoT3cpYQO78qwKA/uC9nVQaH7/Jc5uzYKtOEJ3nfq/jtJWzQMWyf1dVKhmH1Ou8AU2
	bVZ/RgMj92KpWYaNnc9B7Vto7+KSphNm3tQ7zR8UVSYpARhWQAsTngYkGSvm/K2/RjYX9Z
	sY5PYCS6TejvTqNeRC6zo2Gb/ILYHjw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMdBeOSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC85E600AD;
	Thu,  5 Feb 2026 11:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A343C4CEF7;
	Thu,  5 Feb 2026 11:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770290541;
	bh=zHZyrBn1zttFxJ3wimYuvVra0sIVLumPZiL3EfDi55s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fMdBeOSiJ+R+DDlmzWfQaNRVkYB4AdKxjnCwrzSTfZvFklThcSFNBhwWT1mTSLLrB
	 nZRR5d/ANJ36zcmLQFzvtZccSB+Q5k5FMZrmlgsMiff8EQM+oAYDjwsLIM1R8/UI59
	 04jthtIbMKjOD+D3I5sQBHHu/3aTxFHXS0LH8D2vIiuhCmkC0X8mbW57TqLkmfqHSC
	 bIe11JJfkz6y+Nq/99se+nbn/p0aUKOsAvO5YtGpvpKbOmaRquDGRiF6kCKApGMB6Q
	 +qKVw+GK6rVfp+AR0BaFxfUz2WL60BkzGmfsJOHBQP4Pf097/K8sgZS1squrZWn+Ci
	 auf+s4ZBZjksw==
Message-ID: <5de4d58d-649f-4eb3-81dd-8313d17a9725@kernel.org>
Date: Thu, 5 Feb 2026 12:22:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>, Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Frank van der Linden <fvdl@google.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
 <7d246914-6077-4dc1-bbcf-8dabbe6183e7@lucifer.local>
 <2B979847-CED0-41AE-AEB1-BEFB267B1E14@nvidia.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2B979847-CED0-41AE-AEB1-BEFB267B1E14@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C26620002
X-Stat-Signature: 7i8xer7okuo4ye3ag1dnajbsc7bgobs7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770290542-367317
X-HE-Meta: U2FsdGVkX18OhZTzqaswrABGtQg86IWbpGCZHIHtWojhhQZJpayMYJjReiegKrlY66+dx/cpvxkuvZmD7Ga7gmXn4kAmA7JDfjUfQ1KADJ8BzNl2FbqSnEnIM9yFEF0IyplKV6x1jtRGqZuwMeB8GF4b8tsBAyk2AAx1aF8w5SmRjSN8T+vacjBvWZZKJySBeudTuKrpziD0vEkNrRsv1fuAm+8NP2mYsMLTnJGeiCHpxkyPTEjERtG9RxugZXmPlEmpty0mbruLnI9uE9WpgFymTwfCGyj0qZZXEJMGI6Q9w9oE9eYgIWZ5FlRpGyHw95jk0ue+rioxJndSCPMOesP/ncN7dkgL/hXv2W6TA3tbNA0TshJqQBUb8r+fD2g2TCa7osLt33f3pLJHNDTNZOUw/x+xjm958In5ZYJEZivFoi68tVt1EnYD8eN+/ENgLUgN81RpU1HqOkk4OZXHhQGfH5mtIc4RyQs0WvhxAqGYzODK9hapVZh3AHp+K88GCOBM4wl39nSfSwyCjhAKgHK2qK+SnCVzkIaluvVJN5pHJ3GP5CVJJ7xPBKHJf6z4oRhPqdTbwODhJ/qjevOmtuAIO3wTzLL+3Ng+twhzwLOBO/MFAOH7xPbBIgLiPB6gcJUxPfbaMtEtdbG3fH1B89rSKRm2b/rHUdT2yNnbLsX3vVPzYPUXVbqgdGmfYLq6GMAINJUyJdLruXVa6mjpmroDATAe9pW2oJ14sMz6gGH2YEWTnDKDCTQm1Ik9q49Wi6EwkxyCuiLxMCXdpSz/Zeg4x01qX61miTye8xJ3Pwbxsofgsg8SoNVbWUEeay2LvXE9ghBThiq0XDBIHAP/mQBVwHoIdhAkXKTzJ0qlAo+3WtZGTLvmZND+AwBXbf1v4/OJYw33JAg7nkfLXE54rf6Q88Y8GXKIT0zT6qLduD9O0QNKeqrY9MbaVrHwyP4PO7sV7ZGblI7Spa87HmR
 V5/e0FTi
 fBOhupK4u8QVS3YHvjWpwmD+FbeicPDKhOvNq+RsEGK0pJjlswDe2211bxyJQi6loMFyulKnzWCv5x+BywLbZ2XTfNLIFgHIveNA3q54+igAxuPZJT5/a8UPx+mBa0xK/QI0bTvULoiRaQQfYus7xMfnpTwmECuloK9aVg7RD/NdPHYUNlxdrrDXTPS1kG2QwBVMG4Op6AC6yDN7aO7qi9vzRLOnv5BCCKPTgYhByLtxLVuAMYVInrBR+F6EAhxXFiU4S1IvLahQ00SHB2UNA2j26cmvNBTE/EKbAvHu9sIg0DWJiqCbpPAAXXJtdYJs2bllB809JSBHc9VhBN+g9S+Kx3gn9gZcOvgRIFqn/GsRsneZ17q7ClBgKWIop7rJi8t9xC8IDRPAqrUXkHfotVFYekw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:50, Zi Yan wrote:
> On 2 Feb 2026, at 6:30, Lorenzo Stoakes wrote:
> 
>> On Sun, Feb 01, 2026 at 09:44:12PM -0500, Rik van Riel wrote:
>>> To address the obvious objection "but how could we
>>> possibly allocate 1GB huge pages while the workload
>>> is running?", I am planning to pick up the CMA balancing
>>> patch series (thank you, Frank) and get that in an
>>> upstream ready shape soon.
>>>
>>> https://lkml.org/2025/9/15/1735
>>
>> That link doesn't work?
>>
>> Did a quick search for CMA balancing on lore, couldn't find anything, could you
>> provide a lore link?
> 
> https://lwn.net/Articles/1038263/
> 
>>
>>>
>>> That patch set looks like another case where no
>>> amount of internal testing will find every single
>>> corner case, and we'll probably just want to
>>> merge it upstream, deploy it experimentally, and
>>> aggressively deal with anything that might pop up.
>>
>> I'm not really in favour of this kind of approach. There's plenty of things that
>> were considered 'temporary' upstream that became rather permanent :)
>>
>> Maybe we can't cover all corner-cases, but we need to make sure whatever we do
>> send upstream is maintainable, conceptually sensible and doesn't paint us into
>> any corners, etc.
>>
>>>
>>> With CMA balancing, it would be possibly to just
>>> have half (or even more) of system memory for
>>> movable allocations only, which would make it possible
>>> to allocate 1GB huge pages dynamically.
>>
>> Could you expand on that?
> 
> I also would like to hear David’s opinion on using CMA for 1GB THP.
> He did not like it[1] when I posted my patch back in 2020, but it has
> been more than 5 years. :)

Hehe, not particularly excited about that.

We really have to avoid short-term hacks by any means. We have enough of 
that in THP land already.

We talked about challenges in the past like:
* Controlling who gets to allocate them.
* Having a reasonable swap/migration mechanism
* Reliably allocating them without hacks, while being future-proof
* Long-term pinning them when they are actually on ZONE_MOVABLE or CMA
   (the latter could be made working but requires thought)

I agree with Lorenzo that this RFC is a bit surprising, because I assume 
none of the real challenges were tackled.

Having that said, it will take me some time to come back to this RFC 
here, other stuff that piled up is more urgent and more important.

But I'll note that we really have to cleanup the THP mess before we add 
more stuff on it.

For example, I still wonder whether we can just stop pre-allocating page 
tables for THPs and instead let code fail+retry in case we cannot remap 
the page. I wanted to look into the details a long time ago but never 
got to it.

Avoiding that would make the remapping much easier; and we should then 
remap from PUD->PMD->PTEs.

Implementing 1 GiB support for shmem might be a reasonable first step, 
before we start digging into the anonymous memory land with all these 
nasty things involved.

-- 
Cheers,

David

