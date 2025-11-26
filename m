Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9DBD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9F86B0026; Wed, 26 Nov 2025 11:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1D66B007B; Wed, 26 Nov 2025 11:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE73A6B0089; Wed, 26 Nov 2025 11:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8EDD6B0026
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:07:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 532A21606C4
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:07:31 +0000 (UTC)
X-FDA: 84153238302.28.1AEDCD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E22F31A000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:07:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764173249; a=rsa-sha256;
	cv=none;
	b=B6Yh0/FpVc1FfhVrLSk8WWxAJDy0vugZw7cU9nvaXOdhSEz/ok+K9u5OjQLZ8Gm6bl5UWX
	INkI5lCWTdmF4y6hQldzsq5zG17t4x2AlSBnisUyqBhWRV8wAA2Ru6gqlIFfqJcdt++HTn
	ohzuswbPaEbHD9oL2MNe7Ae3qLlmMoI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+RW7cdtseao8/7aTNgdH2Rhr+bJ6eoSju9CyIpiM7Cw=;
	b=Ztf50RsVTL05xTFu1BtmbNelkSZwOsY0C4+je62WoLvy7KXBTJFZhRqwnaa19fTXclMReR
	yI9HalOA76N9xlCEgF+uyGShjC+ILOF1vwSsExMsxiY9LVAiHPBPj7TSSats74BlEj7xX7
	pPxguRw/+S+xCncF7lOAhLidKNLxpg0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B9C41692;
	Wed, 26 Nov 2025 08:07:20 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 051ED3F73B;
	Wed, 26 Nov 2025 08:07:24 -0800 (PST)
Message-ID: <4505a93b-2bac-4ce1-8971-4c31f1ce1362@arm.com>
Date: Wed, 26 Nov 2025 16:07:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Content-Language: en-GB
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <a1d25bde-3ab6-46b5-a957-db80da7e737b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E22F31A000F
X-Stat-Signature: 5idqjiryyd7zqeyooxybs5chbkks9s8c
X-Rspam-User: 
X-HE-Tag: 1764173248-541596
X-HE-Meta: U2FsdGVkX1988frlkC5Z1tfe36B97iMrAnHFlyzaWwB4E2vDWtAC/wJjc2lbnx9/qoqvn/YDHnuNoZZl5LlqIUKOBWqlesRQAcrJspv9h716jl9DBZeA6g6uj+3+vmMLlPnm4Ws4fNJidTzs1VRs2BRbVe2/A6Ooco9ALtARVOlJzBC+77h1owAzoQEyTveYSw16ROIoopYwNZ1wiNwpSHVrdQxMZGlFQYUNNX6g1KjE15Cad+pvXM6YzQFkZNRTPKXj5YKt8/gqS/5WFE0uALjKuR2inhfZSyKYaYkd0ewKnsH/rMzo6+LLug3M/I6UQlrM3VLWbn9owb9gEmYja9q183jpoxxFgIhj+TChnbZXKwZBZD7Pp9qn129q1uyZvnUykw52b6IRRJzui0CPPMQ/KT82s3JjDwsHK/kYbOWEWrzqdh+d0QhVtWgsfqGuhbIsHu3Y0003+YmEWhQsbo/N4a/Wumn1Ucw0UpuKP2WbauNkznGTI6kXz/H+G0v35SCJnHecU9Y/w6oN2pSZ7qwigRjRQBTKz+Ot0q/xsH4jdoGduZaohDvDZWUAgKlbIuuw+/GCyD0+7NUIQBn7jrysox3dtsDhCvrIIGyogpuGCLK8O6JfOPaitLnRVPhh4f5ZQhxMKmxxnMjYBCiBh9tSv9KF3QHNgmQz7pSCRPfj9XYTj0XymUDRwxiVh30iaRFBK3Dv3+GDDvXxtX8gB4+0KwTCA67tkJMoK3rVX1t5gEN4LBzV6ihFz/elvXDp/amVAyGW5JsTEgnBNwrRnmt9vQa9hA84lOuzXp5dnp5iYZwLE7d7DdZ2eAuzYD0YrRP5ZtsnfgBYZclzvBJuSnOzRO7mjc2EhcmB0vHdUvTF6XS4t01+JVo2mDcGeoCxgunwlW+9D4QNrM8ohQpsLq8/eFrZLi38hRTfkGDa6wwh1csZ7yqvUtQDecEQcdDESMts2ZT0DE2o5xLV4ox
 FSRgu9jI
 cq81x8MpM/ezvDj3Jh3/sAxfSLo1Ag5AJD9pCq8jd5IQsTvX0La2wZITg9Wv2Bb8D1ygtOksTAfoZvoLvPQCh6DC8Czv8ax264t+1CEkIUxwIM3imGV5jkRuVJvTb2pSkPAAN0xRSBohcFR0f/ZmB4ELR86n/ui5ZsxwGqTrOhf1mH/Hys0IuBEmW+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>
>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>>> requiring a READ_ONCE() further up the stack?
>>>
>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>> functions are just simple stubs.
>>
>> OK, thought you were saying we should push further down the stack? Or up
>> depending on how you view these things :P as in READ_ONCE at leaf?
> 
> I think at leaf because I think the previous ones should essentially be only
> used by stubs.
> 
> But I haven't fully digested how this is all working. Or supposed to work.
> 
> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h example to
> see if I can make sense of it,

I wonder if we can think about this slightly differently;

READ_ONCE() has two important properties:

 - It guarrantees that a load will be issued, *even if output is unused*
 - It guarrantees that the read will be single-copy-atomic (no tearing)

I think for the existing places where READ_ONCE() is used for pagetable reads we
only care about:

 - It guarrantees that a load will be issued, *if output is used*
 - It guarrantees that the read will be single-copy-atomic (no tearing)

I think if we can weaken to the "if output is used" property, then the compiler
will optimize out all the unneccessary reads.

AIUI, a C dereference provides neither of the guarrantees so that's no good.

What about non-volatile asm? I'm told (thought need to verify) that for
non-volatile asm, the compiler will emit it if the output is used and remove it
otherwise. So if the asm contains the required single-copy-atomic, perhaps we
are in business?

So we would need a new READ_SCA() macro that could default to READ_ONCE() (which
is stronger) and arches could opt in to providing a weaker asm version. Then the
default pXdp_get() could be READ_SCA(). And this should work for all cases.

I think.

> 
>>
>> Anyway. I am now designating you the expert at this ;)
> 
> Oh no. :)
> 
>>
>>>
>>>>
>>>>>
>>>>> IOW, push the READ_ONCE() down to the lowest level so the previous ones
>>>>> (that will get essentially ignore?) will get folded into the last
>>>>> READ_ONCE()?
>>>>>
>>>>> But my head still hurts and I am focusing on something else concurrently :)
>>>>
>>>> Even if we could make this work, I don't love that there's some implicit
>>>> assumption there that could easily break later on.
>>>>
>>>> I'd rather we kept it as stupid/obvious as possible...
>>>
>>> Looking at include/asm-generic/pgtable-nopmd.h I am not sure we are talking
>>> about implicit assumptions here. It's kind-of the design that the pud_t
>>> values are dummies, so why shoul the pudp_get() give you any guarantees.
>>>
>>> At least that's my current understanding, which might be very flawed :)
>>
>> I mean I'm waving my hands around like I'm working on an aircraft carrier here
>> so if you're _sure_ it's _absolutely_ safe then fine :)
> 
> Well, not yet ... :)
> 


