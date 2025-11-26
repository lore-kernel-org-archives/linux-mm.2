Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8C7D10F5F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3A66B0010; Wed, 26 Nov 2025 09:53:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB7B6B002B; Wed, 26 Nov 2025 09:53:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8116B002C; Wed, 26 Nov 2025 09:53:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8106B0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:53:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CD8D8A1A4
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:53:40 +0000 (UTC)
X-FDA: 84153052200.22.7F4EE00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4409940011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:53:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iKA8ZPZB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764168818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqvNSEQ98GWuGXUPR5TKOMta3QXmPgg9acKPBB+9nvE=;
	b=xZtsHVfqOzKunD/bHllLWYwWLOuuXj5+iRyvCGvN8eI/0kXCfHm28PJ2x0kkx97wGY+OFf
	UyzBFF9Fu0L5vz1mP4iJhSbbDV5ccD5RTzVtvAPANFq8BaRTJ9kYFkq81E9l8v7q/xXkBH
	xNjh/T3ls7wNQ3Uc00NxE9VxePZazaM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iKA8ZPZB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764168818; a=rsa-sha256;
	cv=none;
	b=j6ab0SF7od1vQHBHRFTVoSJ6592SaXl19nZ0Z1X2TFcjnmumFyz69htuErS0PUopFZTrBn
	O3vBbnrVWLaNN9yk9RFqCInhRU6i+ihRpPcS0feP00esmrybfLhdGoRhQDj/ylFrHQjHQ3
	vP20RNvPRApF55+taBDOq0oV7ckS+u4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EFD0416DE;
	Wed, 26 Nov 2025 14:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22155C4CEF7;
	Wed, 26 Nov 2025 14:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764168817;
	bh=c3XYY0cYtWPbzdfFG05mXSc/WqtZze6j0CNfdBzcecg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iKA8ZPZBzJCQYVEC7nRsRPwzuuWCfBhocWIEE6hhn+ym5dSpRSL0fAPhaA+Clc/qg
	 Acxjig2SijB4lbZWCCfVV+gD5keP+RT0r+pRsypmohhmQS1poaaqmC0ozypxxymmEG
	 bFNhTQliyy/QUx2BoZ6GnpplECtgUZz1k8uSqlQueSYJrbJTZWEnezPFBR2iicpBNv
	 VvQdvJLq66DJ3TDKqr1po8RlbDflk5NTEaXIGwhIEd8GA3vlrtFeGRlnoNqkHtKQZy
	 ZYtNKHlp5O9GEwLFOR33JAkEXGpVE81UDAWVtj/1iiW2t2+3VFj6LQeI7m054cCRrR
	 LWQawhT0xSlGA==
Message-ID: <82dca16e-6f71-45a9-9748-db47c1f42597@kernel.org>
Date: Wed, 26 Nov 2025 15:53:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>
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
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
 <dce86811-e085-48f9-a0b3-977238877f7a@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <dce86811-e085-48f9-a0b3-977238877f7a@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4409940011
X-Rspamd-Server: rspam11
X-Stat-Signature: f1r74rf63t4z4z468twtdz7mg9ggcygm
X-HE-Tag: 1764168818-4577
X-HE-Meta: U2FsdGVkX192zo3rtWBR8DD8OC1n+koCtJKV1ST8GZPOD6oY5C7SBDMywMujYUpVoOGdV6ACIHI59ROzaTg0mWQ5ZRXNFlQnuNveeMUur5+cq2ZEl+bEhmuw4i6sup89oOzpR3SUlm67lBZZtfyYZWHePx5qZBPPTUbKgPu5r5XAZiVZz/MqgLpgkFumVeA22/foZ5yyLKYKQ8JrBz3XeXXmbw16QlVYN2IWQN9KqYY2YY+imNcF3wLIf0FQ/FoOHAg5QccB3PCkFp0ZW1rFJGxzAXb6uKTJboklLTKDfTPR4Dn4nOih/z6yE9Jj5zScYw1nIj2FMpyjXAm9LMTtbSTqKlsSdp034bc/48Df6cWeS41jgsN8QbuRbdAhviehNrQOS0hANchrZZGEnbfms9LG1q+UQbw4fMLqPgM/5w0851XFFHtT/TyQuaZx0EEWkGOX3Mzqe2R0C/HJxv4K911anRsrGF/v7AWO3pabHM0ZjXvQc1X5yUQ39v196tJFdzCZXK+vJzvP338lhy/CyA7dE0R2lfP7Oj3ubxfMChzQkC07h55c8Ya+FyclQO4jIY6cdTJGbziOGZO9611pve7Y5/cgGeD7t+y/TZe+xm1TKgV5wSp/i1AK3H4m6Sg3YuNLRSr0aT2THoE0mYcH8nivn8qzDeVtwRmCoSCxe55Hqs6+k4OsQAEuHoRK1I+dc/+d9COGJiYJb5cvUGEBCcZRimq6i/MdYkG9FhKo7NokJrZl8/9At0rWCO0pjQ2uKNTiwHYpna1bDMdQFT4rCduiBYBmnizX84ZweYRthRwpdgRWkwUpL9nQJ3taeMx61cEClaxFsCuYSMHifJtIhGgY9Cfp5YrtCAaRplfxXQHANVqjODMo4FWXLQVPti3IZKVygYL7/hoI+tbeWoreFVdgfkfAS7Cpsl59TE8K7sEfABVjxIfpTgmpE0Cyr6EvJ1YCCjrU59ruJeBuaoH
 MK+Qb9CP
 zCsXLe5wtvbuNhwpmkAOV0axGm3zqt/iuL6Eg2Y6sZ4uUmp93pzFVxZ2yW6Q7ldYljrIwepr8G1mj2dzSqjjWTUoAAU+gykqe2FXLN9HsmfdF9yqple7ZibNHg9liQ+Qb/f8uHL8tfDE4RfPQwGClyGAcMy7tzMpat+izvu4ejlt1IE/RuLqBj31hxzJlsmUz/yMx/j+DGwz/ql4RwwkJu2GyX7e1fK1RaaHcm7rfpESeiBSW6dcw3s3TxaaRRrS7zstELEsUg0DhiN//EVafOvU9nRS2T0LIafl6bUuPEMHQmkerLP1RJ/ABJvscRRvalihNN9Am/E7bpt8A8L5rf5zdWkmP4X7KSQZ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 15:37, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 02:22:13PM +0000, Ryan Roberts wrote:
>> On 26/11/2025 13:47, Wei Yang wrote:
>>> On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
>>>> On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
>>> [...]
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I've just come across this patch and wanted to mention that we could also
>>>>>>>>> benefit from this improved absraction for some features we are looking at for
>>>>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>>>>>
>>>>>>>>> The main issue is that the compiler was unable to optimize away the
>>>>>>>>> READ_ONCE()s
>>>>>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>>>>>> optimize
>>>>>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>>>>>> (redundant)
>>>>>>>>> loads.
>>>>>>>>>
>>>>>>>>
>>>>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>>>>>> this out internally?
>>>>>>>>
>>>>>>>
>>>>>>> Just stumbled over the reply from Christope:
>>>>>>>
>>>>>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
>>>>>>>
>>>>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
>>>>
>>>> I certainly don't like the suggestion of doing the is_folded() test outside the
>>>> helper, but if we can push that logic down into pXdp_get() that would be pretty
>>>> neat. Anshuman and I did briefly play with the idea of doing a C dereference if
>>>> the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
>>>> helper. Although we never proved it to be correct. I struggle with the model for
>>>> folding. Do you want to optimize out all-but-the-highest level's access or
>>>> all-but-the-lowest level's access? Makes my head hurt...
>>>>
>>>>
>>>
>>> You mean sth like:
>>>
>>> static inline pmd_t pmdp_get(pmd_t *pmdp)
>>> {
>>> #ifdef __PAGETABLE_PMD_FOLDED
>>> 	return *pmdp;
>>> #else
>>> 	return READ_ONCE(*pmdp);
>>> #endif
>>> }
>>
>> Yes. But I'm not convinced it's correct.
>>
>> I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
>> P4D must also be folded, and you effectively have a 2 level pgtable consisting
>> of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
>> all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
>> was already called and used READ_ONCE(), you might hope the compiler will just
>> drop the other loads and just use the value returned by READ_ONCE(). But I doubt
>> there is any guarantee of that and you might be in a situation where pgdp_get()
>> never even got called (perhaps you already have the pmd pointer).
> 
> Yeah, it kinda sucks to bake that assumption in too even if we can prove it
> currently _is_ correct, and it becomes tricky because to somebody observing this
> they might well think 'oh so we don't need to think about tearing here' but in
> reality we are just assuming somebody already thought about it for us :)

Looking at include/asm-generic/pgtable-nopmd.h, PUD entries there are

* always present (pud_present() == 1)
* always a page table (pud_leaf() == 0)

And pmd_offset() is just a typecast.

So I wonder if that means that we can make pudp_get() be a simple load 
(!READ_ONCE) because nobody should possibly do something with that value 
as we must perform the pmd_present() checks etc. later and obtain the 
PMD through a READ_ONCE().

So far my thinking, maybe it's flawed :)

-- 
Cheers

David

