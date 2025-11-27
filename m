Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21474D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568936B0032; Thu, 27 Nov 2025 14:39:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5402D6B0098; Thu, 27 Nov 2025 14:39:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47DB56B009B; Thu, 27 Nov 2025 14:39:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 382B76B0032
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:39:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE33116027F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:39:13 +0000 (UTC)
X-FDA: 84157400586.09.E98F813
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 19C5EC0014
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:39:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CC1qyyXK;
	spf=pass (imf28.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764272352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZNvrU52zgbgBHftvOlOoh6DfoEQohFr9AGlTYCcwW8=;
	b=K0EEMs4wdM0RXppvN1oy/6CnZ/ZepYzEktDCvDg+x8XIvi521dBFu1y2XDB3cpfx95XNGa
	7zBQd2HDgSMKyVyNjzIg05P0hAcr1qLF2hbPzfZVbmZIwL+yraq+W9zKot8dKzBTgL8TVj
	tKXGum2St1SIKkSpmWMSORZVYC16Xsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764272352; a=rsa-sha256;
	cv=none;
	b=gFrlH5r5DizF4n3s1z4yJia/eIR7TZqCxJlacMG9P67Wq2EuyNx949JXfL011peXh5SjRG
	ZPpCRJo5K6raie9WNXI7I09SrJoJ8DTLqdrMtfjPO9toP9QnTDP8nBuRSgor5/6E25Ab9O
	xE4nc7ASyttUguPG+oXWBGBxzogE+bE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CC1qyyXK;
	spf=pass (imf28.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE4DA43DF8;
	Thu, 27 Nov 2025 19:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671B7C4CEF8;
	Thu, 27 Nov 2025 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764272350;
	bh=9CmP20l5fh1wI0Qc9aslBQ2/q51oJ57cp2te1agYTJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CC1qyyXKyo4HeL/hyEiAmjyrdFYZCtsA9ufEs1ZbODnUMjPMpmfB0ekb5LgdLYCLX
	 CHpUVRLmWiP618uKzGcw7wbVXFiwRW6iCG11whNx4s8RBhJ8T9/2zgzHzeMA5neH+X
	 jzNpS88WZd5RjEB1yebsUUYBbWhpHDbiEFxPLMdhwQ4oBHPrIE4ZWkloGCINaM2Td4
	 NRFHi45iMDD6psQhkBxKT8Hte/o1Jf+XR9XXzKyaG1hLm6nKuFwYsMDrEhw0+17Fso
	 Ig8qddeXGqDngyGmHRXeegLObMvmeRhAeq0whuZCSxPlUukv5cYyvoYlWUMy+FQ+1D
	 EZxUxaIVmEl9w==
Message-ID: <cdfb3e14-f85b-4c85-9042-f9bc7728b375@kernel.org>
Date: Thu, 27 Nov 2025 20:39:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Ryan Roberts <ryan.roberts@arm.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
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
 <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ib81hxawdmj5syfozb7z38y96djz48mn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19C5EC0014
X-HE-Tag: 1764272351-805085
X-HE-Meta: U2FsdGVkX1+A9uYFJAlG1pZ9w+cSBh+/rTU44I2U1KSJo4HjOlRaSdOAyfSz5RT/9FTeWnHPVfAGBG7Jsjis18IWusmxWqYgSCpRdYr+zP90F0NhgK9p4G+rtehxkv1D4q90VsuBkHV46bI+dwQQVdu3g1cQpqIICFiVXa7Tn00bhmZ5zpic4Hec8p3iKhcQ2hWupxlrl4w6TU22L5zVpgjADVxZnriAtWHx/lVAxvb3GAm5YNKIVTvrE9OkhaQYYAu6T68DM2mP02MR1xT9GQ95B0AzIuynJlQqlfe/bxijDUA1HKXnfGREAqPEWh+3/IXViWbZ+odEr4OPi7Qz9DyZ2QQpsMy+3t2STw2fOzbrvWT9o6RR33+WJIPxtCSGHdhQM8Sz7Ate/70EHje1F7gpuH0j+zyQhcKXGHCbUSsFQqo4CxTz8PxLBWMipEEKVhcamyZ8fMxHjhl9TPe1pGQj2UQeI86rDTGpktKbfwI7nGbulPOrc3ribmH0w9ZO3Eyg+cSMeFJ6ZuWE9tzwAl+I4wkPEpCJG6Cif1RdgrtF1KiQGWY4sTJeDYiLw2xg4Q3cuJWfj9OCFxhzkCsAikEq521dnd+iVrmL9EOoIM4cSlMRVCTNjIPJHXFXK9mR5iwExU19WsfyXn00iObEWRm3FklWv2P10HXaDN63iBm9tj73NAWupo4yG7FOTT8eVieKQg5dBqylNbT54RsG2Y9O0NI7ufLckWlpjf0X1dlAf0iFpP0QzIe1uTBH1oKp+FDOiPNDB5SQhJuBd8Ic+U9DU60wJtLQXKP35OG9xGiBgqySu6w72JzgkJf37axm6oGSU2mhk+XWojRRfSov34H0F61mn73AMY8NnTRiiRonfR9pVRuUJmC6depi+JqbTgiEDYtCiuOC9ZiS8RaY4hqY4nGIsC+M7MKt1ecPtCUlvlvTh2iUOj5hfBsWKdjskTQqakVFIZJWrRXQNgu
 J06KEVBO
 dNNlxiaRlHbZdySTloMRxfaqZeVhLY+tNTaTF2BFZxHuADuJj8xe7xpF2ice6ddLsmElbso8nB0eyGYZrod76JeNeePh0PhuaPQ7ZITf09MYndHmuoO/+EV07SCzJOVM1aPfXOIeCVKy/D2IBU6Lnz4RA62uhZZeFvUObvFOuBbUrzHugnREX3UakF/9Wxc/Heb7nwxBSQk+EUYUPsvyOVSNTuK2bUSJ2QPHmThT3L0ceNP8XDHBDHGYxQ3N/ckCKlEG+5pL/1O+17apDXjFPt6Nowm0013Mi6tZbFJEqZCJ489/28F2pwzX9FxP7a+Gh8zpH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 26/11/2025 à 17:34, Ryan Roberts a écrit :
> On 26/11/2025 16:07, Ryan Roberts wrote:
>> On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
>>> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>>>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>>>
>>>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>>>>> requiring a READ_ONCE() further up the stack?
>>>>>
>>>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>>>> functions are just simple stubs.
>>>>
>>>> OK, thought you were saying we should push further down the stack? Or up
>>>> depending on how you view these things :P as in READ_ONCE at leaf?
>>>
>>> I think at leaf because I think the previous ones should essentially be only
>>> used by stubs.
>>>
>>> But I haven't fully digested how this is all working. Or supposed to work.
>>>
>>> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h example to
>>> see if I can make sense of it,
>>
>> I wonder if we can think about this slightly differently;
>>
>> READ_ONCE() has two important properties:
>>
>>   - It guarrantees that a load will be issued, *even if output is unused*
>>   - It guarrantees that the read will be single-copy-atomic (no tearing)
>>
>> I think for the existing places where READ_ONCE() is used for pagetable reads we
>> only care about:
>>
>>   - It guarrantees that a load will be issued, *if output is used*
>>   - It guarrantees that the read will be single-copy-atomic (no tearing)
>>
>> I think if we can weaken to the "if output is used" property, then the compiler
>> will optimize out all the unneccessary reads.
>>
>> AIUI, a C dereference provides neither of the guarrantees so that's no good.
>>
>> What about non-volatile asm? I'm told (thought need to verify) that for
>> non-volatile asm, the compiler will emit it if the output is used and remove it
>> otherwise. So if the asm contains the required single-copy-atomic, perhaps we
>> are in business?
>>
>> So we would need a new READ_SCA() macro that could default to READ_ONCE() (which
>> is stronger) and arches could opt in to providing a weaker asm version. Then the
>> default pXdp_get() could be READ_SCA(). And this should work for all cases.
>>
>> I think.
> 
> I'm not sure this works. It looks like the compiler is free to move non-volatile
> asm sections which might be problematic for places where we are currently using
> READ_ONCE() in lockless algorithms, (e.g. GUP?). We wouldn't want to end up with
> a stale value.
> 
> Another idea:
> 
> Given the main pattern where we are aiming to optimize out the read is something
> like:
> 
> if (!pud_present(*pud))
> 
> where for a folded pmd:
> 
> static inline int pud_present(pud_t pud)	{ return 1; }
> 
> And we will change it to this:
> 
> if (!pud_present(pudp_get(pud)))
> 
> ...
> 
> perhaps we can just define the folded pXd_present(), pXd_none(), pXd_bad(),
> pXd_user() and pXd_leaf() as macros:
> 
> #define pud_present(pud)	1
> 
> Then the compiler will never even see the pudp_get().

Take care about macros with unused parameters, it can be a problem 
sometimes, see commit 05a4ab823983 ("powerpc/uaccess: fix warning/error 
with access_ok()")

Christophe


