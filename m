Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36087D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6661D6B0088; Wed, 26 Nov 2025 10:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6169E6B0089; Wed, 26 Nov 2025 10:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEE76B008A; Wed, 26 Nov 2025 10:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36E926B0088
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:13:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A685F13159C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:13:08 +0000 (UTC)
X-FDA: 84153101256.23.CED9B29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD34F100012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:13:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XvQkRN19;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764169986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8s9o9QhS0HMeCytZSyduH2OjhkvKnEwbnGOB1GOpJw=;
	b=R6jXK4voKbyrak/F7Laj75Z68xBsUunLbqCIhaIBarkhSKLBczPJvWiEr8GXWLjqQ2ONmS
	TA2dlbVE01EESSOGU7DIArh4mk6wj1Ee+mlyklhTy9MeHtyE0Lf2UX8Iy+LfPTqjoYgOtI
	FxOP9qMaZLiOogWXPnzjdS4rNLJgfQU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XvQkRN19;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764169986; a=rsa-sha256;
	cv=none;
	b=cwAj1g4Y26m613o0xsalFpXbCPhiZ1FOQRBOhpy8UfBPuc0M3QTbn+MouA4PCpDaPBZzuu
	cs3YUnXAKNQWI6AWxmmercqG8e/LTUEd2r0tnJPWOouiQbDCCNb6EI0IgFdIXl3qU4mtAI
	JgBV/zcqxWa6fEFrca5Mbqg0BKoOp0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D3CE60206;
	Wed, 26 Nov 2025 15:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7514BC4CEF8;
	Wed, 26 Nov 2025 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764169986;
	bh=0u1o2KJFgGMlu+9bXPvNMO4fZcJG4zl5WGYFbdjOE0Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XvQkRN19LTR69pvq2REcXFW4oZY2i6UXRWgCyQ+XMFsOHihwUBtRRoLFAqpzZh/7A
	 QSmA9b7gJXSongNcKgQRd0Tl81WGpeWnFPHPCE5XLU20g83tc9/LiFpPnla6RobhWK
	 7WJlJ68CBeBqZnbfDcilHelOkUJ0XgBa6yhQJsUpyY/AdVSi5b3JtEZV6jjvvo9rro
	 X6orAvcL9QSKPyIUJnbAqHNObN42cyYmzMr89w7Nu4SWB423xBfhJFOM6bKgasGFaD
	 N7TmXBm8NiGtSi1DuX0uaQ4PdUWXN3llZdwJ/rL/iuND4nZeCj68zfriwWrVUeIyRT
	 Yu5/d68RRECEg==
Message-ID: <a1d25bde-3ab6-46b5-a957-db80da7e737b@kernel.org>
Date: Wed, 26 Nov 2025 16:12:59 +0100
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <37973e21-e8f4-4603-b93d-4e0b1b2499fa@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8ohb1jc6rnei3nf97878fmtjbddzzjgr
X-Rspam-User: 
X-Rspamd-Queue-Id: DD34F100012
X-Rspamd-Server: rspam09
X-HE-Tag: 1764169986-632767
X-HE-Meta: U2FsdGVkX1/VcSZSh8azIhw5KvryTM7t65v8CKBKMHDQdMX/vQ12yKIqTc0+6BztdAxe1CnFhQ0KPiED9siZVCZjDNNfqmjvjoKH6ZPGjj5Vmz5Pc4/ZJh496juK1w/T8QCNOPOT7vjZe8E3/9nH/DKJ5tmnwwKMjpk0Wp/f/GHFGT2oHorgTCNPHjUh76uD5ysWXZ1ppoNPOaNgWOSAJLN+zwCZgvpr4Hu0i0LJcyickK3x3EFNIDqSqbp3yW3OVRsbX0b91Ts1t8/c9OW5awuwCOIiRgYTPU+oi4DKcAG656HPCV9dBWbo8ZUh3CfRrVCDS9PdVoJGKUb2EgnpcCdPGBaaergP0MRfLcDBlWfNCswCBt3oR17mpwEOOl/h+5ZBNMgt7eDnjxzu/BMyJLWG12tZAMIH3NuRRNmNuufx3iXwDfN/M2OCsiERi6yfQIaowyp8usfHnQPwgojMXbwz1e2Ax4X5tuocJX0vzsTysgDeqd+eAGYHbeVla+82TdVMC6SmOjv8r8NnYSYrX1Mb3wSg7qFh0FAJTEdw5sI7l6uxYFNkOgu4QmByImq1KeAQSwQop7yOqYo5c4UDhoDLKNv0CDcAJNibLyFbQXN9q67qnpC1INxslw6y2jxASVVTs3c3iiBvZ5LhmA4h8GmGRiPCzHWXzl4csqd77TAhaFRGbrdHvzeP6v5krH0AZWLXdHLhkx1Q5vzRwM7Hm4LkWT/5yLfxevqV3aR/QmDnexdev+pSEr5L80C8g4GZA5kacVW19LZFE7di41kdevWqAFI0Zw4K4m/hgCydT1RRVTtgW70dHYJCUuZ6J7fb1dBUaadYBGYszjhV6+wUadrqqpMPwCMGGWnI/fGQ4EN1nIfkZbQsWfT0ZYI5GQs+/PvQE/jI4jnKdXP+YPjEWSrAqjcPfm2Hq9dZ+OSGBJjY0IwX2I5MI+z4UuWC+k7MmsrcmM+CMKehk6krznk
 Ilfj8LF2
 QxoaY26bnREJKqtRT8cZGd+YEgY4ns5Ehw8Ju3ZKnWt33mRiqyoLn7Nkkj+E2CHsfTZhz2azvHZhIvns+C60Cp8uPkBPb7IR7nm+b2iItDplWt5k3fulHH2DIZaAWXjKu1RedYbztFMCv9I+r1fnTpr0n6qk/TMvFyFXyNx8+ZKLDEsPk3ORZhgGzdSk6iveOJOcmG+XmeA12FucFFnHW2F26jJoSAmJScphL0sGC1c0eplZGtajKVQ0Zb0HmoQzUoG1pcRx+Dqt5CHR+j4p/HSin+ga7VosrIoEK8O+tr5ZbrXt9AyvbBxcj/xhiZrWnIuRWiNwhm5Va+/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 16:08, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>
>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>> requiring a READ_ONCE() further up the stack?
>>
>> See my other reply, I think the pmdp_get() is required because all pud_*
>> functions are just simple stubs.
> 
> OK, thought you were saying we should push further down the stack? Or up
> depending on how you view these things :P as in READ_ONCE at leaf?

I think at leaf because I think the previous ones should essentially be 
only used by stubs.

But I haven't fully digested how this is all working. Or supposed to work.

I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h 
example to see if I can make sense of it,

> 
> Anyway. I am now designating you the expert at this ;)

Oh no. :)

> 
>>
>>>
>>>>
>>>> IOW, push the READ_ONCE() down to the lowest level so the previous ones
>>>> (that will get essentially ignore?) will get folded into the last
>>>> READ_ONCE()?
>>>>
>>>> But my head still hurts and I am focusing on something else concurrently :)
>>>
>>> Even if we could make this work, I don't love that there's some implicit
>>> assumption there that could easily break later on.
>>>
>>> I'd rather we kept it as stupid/obvious as possible...
>>
>> Looking at include/asm-generic/pgtable-nopmd.h I am not sure we are talking
>> about implicit assumptions here. It's kind-of the design that the pud_t
>> values are dummies, so why shoul the pudp_get() give you any guarantees.
>>
>> At least that's my current understanding, which might be very flawed :)
> 
> I mean I'm waving my hands around like I'm working on an aircraft carrier here
> so if you're _sure_ it's _absolutely_ safe then fine :)

Well, not yet ... :)

-- 
Cheers

David

