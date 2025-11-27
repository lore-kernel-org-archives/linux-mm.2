Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B3CCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 15:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506356B0023; Thu, 27 Nov 2025 10:32:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE246B002C; Thu, 27 Nov 2025 10:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F42B6B008C; Thu, 27 Nov 2025 10:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3606B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:32:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA4B612A49
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:32:42 +0000 (UTC)
X-FDA: 84156779364.30.579620D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD1CB140015
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:32:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764257561; a=rsa-sha256;
	cv=none;
	b=6Yd3q1U1GYue2SsPQ4jhf+Ql0QuEDyPJUTzBqKJuc/z2rIT68EUcz/Pz/CPwtotsDnQElA
	l26eVYDsJBuCkbDaSrdHdpMjZFeLmaBKApXyA4b4KikvRPdxWxKDwuY/fk6sbPDeG+4VYI
	YXtl4qTMGr2tsXbgw3DWdL/pKcO+tiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764257561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8j5Dx4j+5E6vBjj6zHqnvY8z9PqxcdVEE4VX9gNNiQ=;
	b=GV/jkzLxpGeElTTwp1Oa1rOu6I0/sNLi1J5uaVNxFECNkK6jQnrfSOqmKtR1/MY59QFLxY
	2jl/FbxHVJ0aJ5fPdRHi2P1UxJ0ZBozt8YCAWBCqikQPjHRMn0eIGt34mnxB1q9JjPyEsU
	8Gdo4rCxuVvJirQz703uLnQvRkfZd1A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36AA81063;
	Thu, 27 Nov 2025 07:32:32 -0800 (PST)
Received: from [10.57.87.167] (unknown [10.57.87.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F26F43F66E;
	Thu, 27 Nov 2025 07:32:35 -0800 (PST)
Message-ID: <f1932547-0fc6-4dbd-868c-0b0b34429a33@arm.com>
Date: Thu, 27 Nov 2025 15:32:34 +0000
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
 <4505a93b-2bac-4ce1-8971-4c31f1ce1362@arm.com>
 <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
 <b2fbe58e-f47b-4a76-879b-fd38a915c2ce@kernel.org>
 <bcd2a49d-a42f-41e8-9f64-4fd24fc862c7@kernel.org>
 <bd4d746b-8929-4fd2-bd59-70654e794ee6@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <bd4d746b-8929-4fd2-bd59-70654e794ee6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD1CB140015
X-Stat-Signature: mnd36rn7f7f5ehf9u9scpcmd6huj8npa
X-Rspam-User: 
X-HE-Tag: 1764257560-921967
X-HE-Meta: U2FsdGVkX1/TRSXtGo7wMS77Kla1bbY3Q9N/uguJ/8TWKkwcDLYUJCmw+OVtEcbsAxC6TgL1oeX2VfNt3iXg9WhNYePns2Lurk3TGoi6cixzk9ix2aPJFMMnne5t1leCPYU2A05L8vHc+hC2I0jasqMhIw65s3+kCGujDn/qSdei+XOgifXz8VUvxE++N+ItdVwsmAzQgvHTTNqLV+WSmTkirmd6Jic3ciziXLt4WsR540VWGnbwNKjxSvBIdXGFV7dBa0dqHwsfGdsZyvryhqb63gaCCVD/ss7XuWiUFDbtCIRHaUOBWJ1Z4SdMjgkNrrMH7LnilkbX2A19pWfNITra/bJ9RJdhI97RUFOf6HaWXmJcHyqrbyoCMxPjZ3L5UjQsqe5qK5iiMKUFKuHB+xl0iMHoF90rUn4dhBIYempTSw+/Mw1LU2ozibkCWKyq2w+pq8S/MxiSb30tWklrgDIH2FOnga0CJUPr3QTLMjLrKh57SjGiYocWwkUA0q66Vf8b2E2PFvS8daUNG3JF/SjUmnffVd57u5lSIgiNGsP4PHg/L4MmrnRcxWSRxeL+RVYjDbzfgH1I2dDCaMhFac3JXDAzsBUbRAoxq5eQfsQtZYHUAiWN5zkyMDzqAF7aovCjMxwi7nDVHAC9FyHzHT5DgB+8aV6HIZ/jZJ3OZF46OY8/cSmJl0YmAuZQSrJEVu3AocyVVGwOZVF40aWPPw+Raf8MlHi5wzB70HIP//jPEAEfUPalVQ7h2J86tICBjv0aPTGHcCWwYIItMwDH4szjlKxhrwlclKAMdw4Fte4MgJFia5kU8L9plljatj7R96hM2lqAHRFW1+oA+rBq8kZKT2MHmos/4PJXxdkiaoUAbfzY+GiQOVMlPhBmzn7bdnp/1gXyZl3JPk+KI/IebY1ow/lF15nfd0+s6hSH0HucR+C1zuilFOKEMiU1NV0RH1QfuGdErt4dpYN2o5q
 0NbMarh/
 CQp2FCnseZJ5Mi+4u2Vml7uLbN0MVTLEton0XTdsEWYrk/g8hMP9Ork5zsOgSQQPlVehSNBADBZRVYTqRTTtr6I/XWOnHZHZAT1xVo6bjadgc6x0lJHXqucYd4G7cCzfVbx5VJNSw1aH9R/GOtI+QFRVhoaLxtaZrImNd3CqZ0WKEmmLF3EvcB90freBhkPxHxIGwKet0OofdMLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/11/2025 07:31, David Hildenbrand (Red Hat) wrote:
> On 11/27/25 08:14, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 21:31, David Hildenbrand (Red Hat) wrote:
>>> On 11/26/25 17:34, Ryan Roberts wrote:
>>>> On 26/11/2025 16:07, Ryan Roberts wrote:
>>>>> On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
>>>>>> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>>>>>>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>>>>>>
>>>>>>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that
>>>>>>>>> end up
>>>>>>>>> requiring a READ_ONCE() further up the stack?
>>>>>>>>
>>>>>>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>>>>>>> functions are just simple stubs.
>>>>>>>
>>>>>>> OK, thought you were saying we should push further down the stack? Or up
>>>>>>> depending on how you view these things :P as in READ_ONCE at leaf?
>>>>>>
>>>>>> I think at leaf because I think the previous ones should essentially be only
>>>>>> used by stubs.
>>>>>>
>>>>>> But I haven't fully digested how this is all working. Or supposed to work.
>>>>>>
>>>>>> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h
>>>>>> example to
>>>>>> see if I can make sense of it,
>>>>>
>>>>> I wonder if we can think about this slightly differently;
>>>>>
>>>>> READ_ONCE() has two important properties:
>>>>>
>>>>>     - It guarrantees that a load will be issued, *even if output is unused*
>>>>>     - It guarrantees that the read will be single-copy-atomic (no tearing)
>>>>>
>>>>> I think for the existing places where READ_ONCE() is used for pagetable
>>>>> reads we
>>>>> only care about:
>>>>>
>>>>>     - It guarrantees that a load will be issued, *if output is used*
>>>>>     - It guarrantees that the read will be single-copy-atomic (no tearing)
>>>>>
>>>>> I think if we can weaken to the "if output is used" property, then the
>>>>> compiler
>>>>> will optimize out all the unneccessary reads.
>>>>>
>>>>> AIUI, a C dereference provides neither of the guarrantees so that's no good.
>>>>>
>>>>> What about non-volatile asm? I'm told (thought need to verify) that for
>>>>> non-volatile asm, the compiler will emit it if the output is used and
>>>>> remove it
>>>>> otherwise. So if the asm contains the required single-copy-atomic, perhaps we
>>>>> are in business?
>>>>>
>>>>> So we would need a new READ_SCA() macro that could default to READ_ONCE()
>>>>> (which
>>>>> is stronger) and arches could opt in to providing a weaker asm version.
>>>>> Then the
>>>>> default pXdp_get() could be READ_SCA(). And this should work for all cases.
>>>>>
>>>>> I think.
>>>>
>>>> I'm not sure this works. It looks like the compiler is free to move non-
>>>> volatile
>>>> asm sections which might be problematic for places where we are currently using
>>>> READ_ONCE() in lockless algorithms, (e.g. GUP?). We wouldn't want to end up
>>>> with
>>>> a stale value.
>>>>
>>>> Another idea:
>>>>
>>>> Given the main pattern where we are aiming to optimize out the read is
>>>> something
>>>> like:
>>>>
>>>> if (!pud_present(*pud))
>>>>
>>>> where for a folded pmd:
>>>>
>>>> static inline int pud_present(pud_t pud)    { return 1; }
>>>>
>>>> And we will change it to this:
>>>>
>>>> if (!pud_present(pudp_get(pud)))
>>>>
>>>> ...
>>>>
>>>> perhaps we can just define the folded pXd_present(), pXd_none(), pXd_bad(),
>>>> pXd_user() and pXd_leaf() as macros:
>>>>
>>>> #define pud_present(pud)    1
>>>>
>>>
>>> Let's take a step back and realize that with __PAGETABLE_PMD_FOLDED
>>>
>>> (a) *pudp does not make any sense

I'm struggling with this statement. The PMD is folded, not the PUD. So the PMD
table consists of a single entry, which overlays the entry in the PUD, right? So
the PUD exists and *pudp must be valid?

Now, pgtable-nopmd.h includes pgtable-nopud.h so actually the PUD is also folded
into the P4D and the P4D is also folded into the PGD. But the PGD exists and is
not folded.

So what you are saying is true in practice, I guess. But it's not true if you
replace PMD with P4D and PUD with PGD.

Does what I'm saying matter or have any impact on your assessment below? I have
no idea. My head hurts.

>>>
>>> For a folded PMD, *pudp == *pmdp and consequently we would actually
>>> get a PMD, not a PUD.

Well based on what I said above, the PMD is folded into the PUD, the PUD is
folded into the P4D and the P4D is folded into the PGD. So all of those things
are actually pointing to the PGD entry in the PGD table, right? And pmd_t,
pud_t, p4d_t are all defined as containers holding the next thing up:

typedef struct { pud_t pud; } pmd_t;

So it all works out, and is safe, I think?

>>>
>>> For this reason all these pud_* helpers ignore the passed value
>>> completely. It would be wrong.
>>>
>>> (b) pmd_offset() does *not* consume a pud but instead a pudp.
>>>
>>> That makes sense, just imagine what would happen if someone would pass
>>> *pudp to that helper (we'd dereference twice ...).
>>>
>>>
>>> So I wonder if we can just teach get_pudp() and friends to ... return
>>> true garbage instead of dereferencing something that does not make sense?

Sorry, I don't really understand why dereferencing does not make sense. the
pud_t is a struct containing a single p4d_t and that is a struct containing a
single pgd_t and it is pointing to the pgd entry. So why isn't it safe?

>>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index 32e8457ad5352..c95d0d89ab3f1 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -351,7 +351,13 @@ static inline pmd_t pmdp_get(pmd_t *pmdp)
>>>     #ifndef pudp_get
>>>     static inline pud_t pudp_get(pud_t *pudp)
>>>     {
>>> +#ifdef __PAGETABLE_PMD_FOLDED
>>> +       pud_t dummy = { 0 };
>>> +
>>> +       return dummy;

If you're confident that this is correct, then I believe you. But I can't follow
your logic at the moment. But we have a fairly long history of you being right
and me not understanding... :)

I don't think in general it is invalid for something to call the getter and do
something with the result just because it's folded. e.g. log it's value. So I
don't think returning a dummy value is ok.

See __print_bad_page_map_pgtable() for example?

>>> +#else
>>>            return READ_ONCE(*pudp);
>>> +#endif
>>>     }
>>>     #endif
>>>     set_pud/pud_page/pud_pgtable helper are confusing, I would
>>> assume they are essentially unused (like documented for set_put)
>>> and only required to keep compilers happy.
>>
>> Staring at GUP-fast and perf_get_pgtable_size()---which should better be
>> converted to pudp_get() etc--I guess we might have to rework
>> p4d_offset_lockless() to do something that doesn't rely on
>> passing variables of local variables.
>>
>> We might have to enlighten these walkers (and only these) about folded
>> page tables such that they don't depend on the result of pudp_get() and
>> friends.
> 
> Talking to myself (I know), handling this might be as simple as having
> 
> diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-
> nopmd.h
> index 8ffd64e7a24cb..60e5ba02bcf06 100644
> --- a/include/asm-generic/pgtable-nopmd.h
> +++ b/include/asm-generic/pgtable-nopmd.h
> @@ -49,6 +49,13 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long
> address)
>  }
>  #define pmd_offset pmd_offset
>  
> +static inline pmd_t * pmd_offset_lockless(pud_t *pud, puf_t pud, unsigned long
> address)
> +{
> +       return (pmd_t *)pud;
> +}
> +#define pmd_offset_lcokless pmd_offset_lockless
> +
> +
>  #define pmd_val(x)                             (pud_val((x).pud))
>  #define __pmd(x)                               ((pmd_t) { __pud(x) } )
>  
> 
> IOW, just like for pmd_offset() we cast the pointer and don't ever touch the pud.
> 
> 
> As a reminder, the default is
> 
> #ifndef pmd_offset_lockless
> #define pmd_offset_lockless(pudp, pud, address) pmd_offset(&(pud), address)
> #endif
> 
> (isn't that nasty? :) )

Just as a general comment; arm64 expects and requires today that any pte_t
pointer passed to ptep_get(), set_ptes(), and all the other ptep helpers point
to entries in the pgtable. We cannot tolerate being passed pointers to stack
variables. We assume we can roam around in the pgtable for contpte purposes.

Extending this to the other levels, we would have the same requirements.

Thanks,
Ryan

> 


