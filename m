Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D040FD10F5F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAC96B002D; Wed, 26 Nov 2025 09:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D33A6B002E; Wed, 26 Nov 2025 09:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F626B002F; Wed, 26 Nov 2025 09:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2D9F6B002D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:56:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B98A3131663
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:56:23 +0000 (UTC)
X-FDA: 84153059046.09.5DEE2A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C552C0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:56:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=snGe7lbC;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764168982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOU0ZB7LQHvspO2XoRSSwfQDoD7E9vPxBNqMUEqvxlg=;
	b=d/5ZceEIwBK8IC3rTiYMdpjgb0QO97B9dG6m6n5WqpeY+XSA3KqwRo423Szs4UdfVzIXGK
	OD9Mhz/3/vdvoVQDNCpMk3M0H0JvebuHkVYBFbFgTvA0Cn5l8fx0be7SiG2jKFs8LfJuan
	T6SiZzNW1uOuz7b4CdHTsGg+cpxsA4g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=snGe7lbC;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764168982; a=rsa-sha256;
	cv=none;
	b=A82/9yPAFxkrlFyWbkEfDf2DyM979hMK6b+IDbomHqoFC6nZd1H9da2GlwgmAJaJmlzbP1
	YdXeMbxW6XVNFMTFjg83WIbvh75MU1wWl4R+K5VzuxyfLNUDvWsGFeMCog9sluPadYwxAj
	F7Ul4AcqGR8PghAuLptk74gKpfOGvvE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B03F60206;
	Wed, 26 Nov 2025 14:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E891EC4CEF7;
	Wed, 26 Nov 2025 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764168981;
	bh=MeTvCvxV+3MFnGJottwhuC9OB5zcau7n3a2ykik7c8M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=snGe7lbCYacch1xuECwqTvMnBkOI7LejV9Q29Sr1sI4VuESWqOzTzi4cajGQeY8Tn
	 uAyTV8LdLPGTY5p2yq02xOzTfLrefv/J5waZujSxVPQ/KVrQjn1n3FfNfIHfufumd7
	 bmGIiLCfi4slSlSZVHTBsmiSSdnh4WQYAcW0/JBWL16qr9moAC2hbY1bU22M+7532D
	 zmn+v3YTcEaI2Nj36GoaMXVa2TBgRfXVrk2zPi1cT7xiYG6+kvKRBoGE2hgiNFIENM
	 z0Lif+2gOU8Y96CDCaB2W46+eCIAMxYofGQNvNzLdPxvSHDx886s2UKPY/3Zofmuwl
	 PgpoGSq7E4lKw==
Message-ID: <1ca9f99f-6266-47ca-8c94-1a9b9aaa717f@kernel.org>
Date: Wed, 26 Nov 2025 15:56:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Wei Yang
 <richard.weiyang@gmail.com>, Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, devicetree@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Conor Dooley <conor@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
 <6b966403-91e0-4f06-86a9-a4f7780b9557@kernel.org>
 <ab39d448-aa1c-4c93-8e2b-5d97a9c76af5@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ab39d448-aa1c-4c93-8e2b-5d97a9c76af5@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C552C0010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ojtfe9hhow4wrxcsrzxpdb77atrn43cs
X-HE-Tag: 1764168982-727880
X-HE-Meta: U2FsdGVkX188kiHdOg9YiORrWAJvcOn1ufByDgZQvXfUNnMqeZm1VX4p0OVjCt05JnOyZnAsDsImhfHuHP2Z7nkU8k13CHIUAhgzulA0wZ/r3zBWhmcGJdO4Qip0pGN6Nv6s/RtLg14Uwi5VCam6KfRYLQ6UHEQ1kisa0Lu0pV0zOqfeH+vsrrO+IOlS/+4LRxeL7ofiLVWneapnY8imUrn3xE/Zd+k5WRzDD5abyhg3rl9Adjnsec2DOqB47wKPhg1ezvfS4RUQOcIycgeZj2Xig45lrbrlDHKw7eirgiwJZk44IlserSPuJEwjawb1JgrXOVK8ezVxbPvm+984fi1tspfkIlnVfwrJwPBCLP3tJWk3i5Zvp3VpNHNynF4U8Iku5G2Zkb+TkTeHXwE1vYiQI8htfMn1Qj/nakQ9LF/MVdATWlr+Cf4AX+RDvHqhGxKEUetNjx00y+jxVALM6Awl1bUOSPQOe3BpQ0wvmk70XOIbnWmeZsNcf4N7BXpjw/wNzRHNbAfQOYV5TiFFT0WWG2v2dLadGsNvhxUS7RNdxaaSCIW6fbFK/6Bv80wJTO6VDHcMpqLls+YNxk/spt4+AXxg1h2w0hHSvmvl6eKuYelhvmMhmHxPFzawOo+36tuoyPWtqoO8mqUbSMXn+L26UgiX4NXt9VVd9D2S4jJGhXbJv+g0pXBUm+qUK9Hw/5R82pIpYQK6G+9JeMaFzN+m1FvlUNDiPexH3TkzrUwa95j6BFb++VMBLuyVXPF4/iGkKTwTsBCjpsxBGfr66Mkz2+8XqNHJ07NajGw9DChqwFKOptKjk+rdJKsuKiiLXql4xUyVAbozNvMt3pA2v4KSeXDzMbbvPocQjC0RR3UIIyNpeQhemmsVc3RYoZRgm0WN6SoqSUWkT046fJq7B70qr6vhEOlVQFQtFviaAuf/wVDhQLbuC1bkPzOtMZCHN7dFzqrdR2xDLGN5YJM
 0LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 15:52, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 03:46:40PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 15:22, Ryan Roberts wrote:
>>> On 26/11/2025 13:47, Wei Yang wrote:
>>>> On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
>>>>> On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
>>>> [...]
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> I've just come across this patch and wanted to mention that we could also
>>>>>>>>>> benefit from this improved absraction for some features we are looking at for
>>>>>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>>>>>>
>>>>>>>>>> The main issue is that the compiler was unable to optimize away the
>>>>>>>>>> READ_ONCE()s
>>>>>>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>>>>>>> optimize
>>>>>>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>>>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>>>>>>> (redundant)
>>>>>>>>>> loads.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>>>>>>> this out internally?
>>>>>>>>>
>>>>>>>>
>>>>>>>> Just stumbled over the reply from Christope:
>>>>>>>>
>>>>>>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
>>>>>>>>
>>>>>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
>>>>>
>>>>> I certainly don't like the suggestion of doing the is_folded() test outside the
>>>>> helper, but if we can push that logic down into pXdp_get() that would be pretty
>>>>> neat. Anshuman and I did briefly play with the idea of doing a C dereference if
>>>>> the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
>>>>> helper. Although we never proved it to be correct. I struggle with the model for
>>>>> folding. Do you want to optimize out all-but-the-highest level's access or
>>>>> all-but-the-lowest level's access? Makes my head hurt...
>>>>>
>>>>>
>>>>
>>>> You mean sth like:
>>>>
>>>> static inline pmd_t pmdp_get(pmd_t *pmdp)
>>>> {
>>>> #ifdef __PAGETABLE_PMD_FOLDED
>>>> 	return *pmdp;
>>>> #else
>>>> 	return READ_ONCE(*pmdp);
>>>> #endif
>>>> }
>>>
>>> Yes. But I'm not convinced it's correct.
>>
>> Yeah, I'm also still trying to understand how it could work.
>>
>>>
>>> I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
>>> P4D must also be folded, and you effectively have a 2 level pgtable consisting
>>> of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
>>> all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
>>> was already called and used READ_ONCE(), you might hope the compiler will just
>>> drop the other loads and just use the value returned by READ_ONCE(). But I doubt
>>> there is any guarantee of that and you might be in a situation where pgdp_get()
>>> never even got called (perhaps you already have the pmd pointer).
>> With __PAGETABLE_PMD_FOLDED we treat the PUD to be fake-present, like
>>
>> static inline int pud_present(pud_t pud)	{ return 1; }
>>
>> And obtaining the pmd_t* is essentially  cast of the pud_t*
>>
>> static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
>> {
>> 	return (pmd_t *)pud;
>> }
>>
>> So in that case we might want to have the READ_ONCE() remove from the
>> pudp_get(), not the pmdp_get()?
> 
> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
> requiring a READ_ONCE() further up the stack?

See my other reply, I think the pmdp_get() is required because all pud_* 
functions are just simple stubs.

> 
>>
>> IOW, push the READ_ONCE() down to the lowest level so the previous ones
>> (that will get essentially ignore?) will get folded into the last
>> READ_ONCE()?
>>
>> But my head still hurts and I am focusing on something else concurrently :)
> 
> Even if we could make this work, I don't love that there's some implicit
> assumption there that could easily break later on.
> 
> I'd rather we kept it as stupid/obvious as possible...

Looking at include/asm-generic/pgtable-nopmd.h I am not sure we are 
talking about implicit assumptions here. It's kind-of the design that 
the pud_t values are dummies, so why shoul the pudp_get() give you any 
guarantees.

At least that's my current understanding, which might be very flawed :)

-- 
Cheers

David

