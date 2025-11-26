Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4754D1039B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C016B0007; Wed, 26 Nov 2025 11:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC8B6B0089; Wed, 26 Nov 2025 11:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4B46B008C; Wed, 26 Nov 2025 11:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E959E6B0007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:34:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 984E0C06BD
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:34:58 +0000 (UTC)
X-FDA: 84153307476.14.07D6F8E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id C7B1F1A000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:34:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764174897; a=rsa-sha256;
	cv=none;
	b=ew+rwaWa9+LWJhu4a7Q7r+BfpztRV4rhp7vDllhPnEpbgKDu9qHuvXehAjh8rU3MQ3V4Dq
	apoXbGf0xQrvbLMNBihDtSq5HRBI0tbvBbrRzslCAp6g4ZOPoEBRvEG1kFp4mfXCmRHZF7
	d2R+ZOnjPdZ42VCDwpvQ1N6Dq4TBfFw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764174897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zN8ZY/fiM7XRSC1YbT6SosMoGCh3laiOQ8J57i+fJBw=;
	b=v4066H0IOuV8rO4D3JOlWs3INEaFFR47B7+lv01eDoksT10xgjw604FPgYoVfesmVCpDSQ
	GvYINe5mtcbaUFSy+jduJdLnQ4kPGMz4WpFhAYAkk3jjPwCHLxPrAoNHSmiGN1Z08OWD5Y
	1WScjpBbXuXL9IPVMQPhxid/YM2Vi5Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0459C168F;
	Wed, 26 Nov 2025 08:34:48 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2E773F73B;
	Wed, 26 Nov 2025 08:34:52 -0800 (PST)
Message-ID: <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
Date: Wed, 26 Nov 2025 16:34:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
 Samuel Holland <samuel.holland@sifive.com>,
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
References: <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
 <6b966403-91e0-4f06-86a9-a4f7780b9557@kernel.org>
 <ab39d448-aa1c-4c93-8e2b-5d97a9c76af5@lucifer.local>
 <1ca9f99f-6266-47ca-8c94-1a9b9aaa717f@kernel.org>
 <37973e21-e8f4-4603-b93d-4e0b1b2499fa@lucifer.local>
 <a1d25bde-3ab6-46b5-a957-db80da7e737b@kernel.org>
 <4505a93b-2bac-4ce1-8971-4c31f1ce1362@arm.com>
In-Reply-To: <4505a93b-2bac-4ce1-8971-4c31f1ce1362@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7B1F1A000D
X-Stat-Signature: whkm4eo5xnhpqkxb3ij6kn5n34dfnq6a
X-Rspam-User: 
X-HE-Tag: 1764174896-17453
X-HE-Meta: U2FsdGVkX1/ZkWCMXJNQkIeqD90onrCNJdICRkeSct3GyWvTwsJcwAf8EgWxUrj0C+nJGqvOmImQ1n+OEP/bVvvK8MW7BNONnao86yoUQcqVWQ2LIcEKLruBbJjoxprzm4i8xSNMuTQoDwhdG82Cu2WTR9VHYyaAnoueX23zQ4/3a3gf31857ThamKJTuMpGIWGFc/gFHkNh11R64RHxGstuslwwnhBiybKoeIm+PFTSst2w1PU7jkxAVB6tlyKshr26V50vr6FFnZLrpyWQxqqGJ1EB4O0hmFighG5pDGZ2LyI0A8Xn9L+fL2oanHukNRwQxkfmw/Mv9bCxq0wQFCedA6BXt2zZq2xl1tR/NCgHh1dv+SBilMOu+NxH2p66GstTvumRS1VTgYo608nMp7i3J8T1dWqZQteJyb88cPhXOyCTNxlI6Jnk2ZcK4/XkHaE3CJlE7rHSMRmcTXJwx+otR80idWkK1tIxBkV36TCH4k701ye+OOfIfZsltyHDvNfYIa9LGnZsNzTi2vqCEcUCvT17nh7TX96qQ9YImeezl5wWWMwE7GgV9Or6XM4f5wSPXuffARL4rAfUm0hH376HhkTcDNp4Hj7L0dUmrI6PLkKatyd1bWScCghygkQXHKxrzZMECpWix/D/hZ4wPgsle212fDNrJsTW+ZCBzM6avl901o+EORNH7L4BS0RWO36QPzMX0f/gVP3odhiS1fPqNHhvoN8SjEL/rmwceAHIYrZ21RZTgAKxrqCjZZtiyTVmlHhdJD+RUNmgFD/04+8q4N3qxrDrEDdDNIEjDEKrM6FmYEl2gf0W83mRcVVojnlQq7u1q0rO9Gdtuc+Vogl0W4tSP6iNrhNYg23vxuWCSEC8Y9g9jpnANaYP4tsb1wVPae1DZmfKoA8VnJSpl8mpbJeX8tvrWkIxRl+u37BdIY1RkEvEHdmKqT9yNoErJRu5j44CE3yuFVyVnEB
 znw/vlRm
 DN/q7LFqJoTRzdAib0CWLq+oERWV5KPzLTovaXRL8Pd51RGPMp8BnfP1C6Pax4NOM4nbc6+QR7b9P3Jocog16P72lJSkvyb2+bR4YpkM+eaZsqJSo4PDqgD8Efc+rEcUMvKcEL77TwANz0VQ7r+a6vasPBgWuXvZFArjciD/UXaBVFUjiM3F+3A0ssQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/11/2025 16:07, Ryan Roberts wrote:
> On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>>
>>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>>>> requiring a READ_ONCE() further up the stack?
>>>>
>>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>>> functions are just simple stubs.
>>>
>>> OK, thought you were saying we should push further down the stack? Or up
>>> depending on how you view these things :P as in READ_ONCE at leaf?
>>
>> I think at leaf because I think the previous ones should essentially be only
>> used by stubs.
>>
>> But I haven't fully digested how this is all working. Or supposed to work.
>>
>> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h example to
>> see if I can make sense of it,
> 
> I wonder if we can think about this slightly differently;
> 
> READ_ONCE() has two important properties:
> 
>  - It guarrantees that a load will be issued, *even if output is unused*
>  - It guarrantees that the read will be single-copy-atomic (no tearing)
> 
> I think for the existing places where READ_ONCE() is used for pagetable reads we
> only care about:
> 
>  - It guarrantees that a load will be issued, *if output is used*
>  - It guarrantees that the read will be single-copy-atomic (no tearing)
> 
> I think if we can weaken to the "if output is used" property, then the compiler
> will optimize out all the unneccessary reads.
> 
> AIUI, a C dereference provides neither of the guarrantees so that's no good.
> 
> What about non-volatile asm? I'm told (thought need to verify) that for
> non-volatile asm, the compiler will emit it if the output is used and remove it
> otherwise. So if the asm contains the required single-copy-atomic, perhaps we
> are in business?
> 
> So we would need a new READ_SCA() macro that could default to READ_ONCE() (which
> is stronger) and arches could opt in to providing a weaker asm version. Then the
> default pXdp_get() could be READ_SCA(). And this should work for all cases.
> 
> I think.

I'm not sure this works. It looks like the compiler is free to move non-volatile
asm sections which might be problematic for places where we are currently using
READ_ONCE() in lockless algorithms, (e.g. GUP?). We wouldn't want to end up with
a stale value.

Another idea:

Given the main pattern where we are aiming to optimize out the read is something
like:

if (!pud_present(*pud))

where for a folded pmd:

static inline int pud_present(pud_t pud)	{ return 1; }

And we will change it to this:

if (!pud_present(pudp_get(pud)))

...

perhaps we can just define the folded pXd_present(), pXd_none(), pXd_bad(),
pXd_user() and pXd_leaf() as macros:

#define pud_present(pud)	1

Then the compiler will never even see the pudp_get().

Thanks,
Ryan


> 
>>
>>>
>>> Anyway. I am now designating you the expert at this ;)
>>
>> Oh no. :)
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> IOW, push the READ_ONCE() down to the lowest level so the previous ones
>>>>>> (that will get essentially ignore?) will get folded into the last
>>>>>> READ_ONCE()?
>>>>>>
>>>>>> But my head still hurts and I am focusing on something else concurrently :)
>>>>>
>>>>> Even if we could make this work, I don't love that there's some implicit
>>>>> assumption there that could easily break later on.
>>>>>
>>>>> I'd rather we kept it as stupid/obvious as possible...
>>>>
>>>> Looking at include/asm-generic/pgtable-nopmd.h I am not sure we are talking
>>>> about implicit assumptions here. It's kind-of the design that the pud_t
>>>> values are dummies, so why shoul the pudp_get() give you any guarantees.
>>>>
>>>> At least that's my current understanding, which might be very flawed :)
>>>
>>> I mean I'm waving my hands around like I'm working on an aircraft carrier here
>>> so if you're _sure_ it's _absolutely_ safe then fine :)
>>
>> Well, not yet ... :)
>>
> 


