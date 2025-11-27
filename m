Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90FED10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 07:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48196B0006; Thu, 27 Nov 2025 02:14:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8F46B0008; Thu, 27 Nov 2025 02:14:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7A16B000A; Thu, 27 Nov 2025 02:14:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCE96B0006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:14:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 349C18A533
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:14:57 +0000 (UTC)
X-FDA: 84155525034.29.E9DF5CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A5FEA40012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:14:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ksVrEcCC;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764227695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zH+sBJ7b8rTeq60rYqS0uTH/1KBsdypogMlIrpG0N4M=;
	b=1grh+E0lWQcyLs3WdiBmlEM9eclxAF4yVXs/2wea2tLbX24qLwZUKOcNrtn0OSSGhzzAKh
	n4b16ToebmEUYHOHyELMlTcUMzLUCWHG5dO3Lx2ccNuykoS6/t5X3EpSXosgYrkgPoyvWU
	cqi3oP/tT51+hvI3lJRfvPVtbevpcsA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ksVrEcCC;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764227695; a=rsa-sha256;
	cv=none;
	b=TCj35TlKT46AafDzYXy4/QEeuJ5vDiLSII4d7n5J/fXJCZPT18cLBT6uQgTOv4u1pH93OR
	50i0EPGhy7RWXPIS7FHS4jmGJG+Z+dHRZzuYKVLupjxMiILmezQGPGvXWByGskjWH+QS25
	Ig2Vm2LgioBzzjuPDGcNu+3GdercxhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED57360186;
	Thu, 27 Nov 2025 07:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EE2C4CEF8;
	Thu, 27 Nov 2025 07:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764227694;
	bh=nG1HIGyDMlgn0rC/3lX9+hsIsnZ635QMJyYQCko+Bio=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ksVrEcCCQASGC1x7cUjW8qzLgPsEpPh2R7b+sIcTD7eXFEI6M2WxpWQcmIrC/E1iX
	 EsoMz9AFQVpS3mokC3TqIYlZIok1kDTYNurKw3uyaCTORVJQh630uqj2bO1rvzhGv+
	 8zfXxfKpIv+xyJcKSv7MmbGj/xgY2oMo+LhDDeV3pj7bwiiR51dBmw+FIhe2nBPPw2
	 B8FMh2V5FtJDeyHcDjQOwoH8FNRqNoUpO4w6LYgCx7TjPc00Kwhsiq+TtG9gVKpynr
	 k6RpuSVIoNXfdLS9AB7NaP7zBPA/fXkZhYoW9iML+EGqrIpQcIJztFUuEJKAfEd7Vv
	 VtPOl+v12EneQ==
Message-ID: <bcd2a49d-a42f-41e8-9f64-4fd24fc862c7@kernel.org>
Date: Thu, 27 Nov 2025 08:14:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>,
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
Content-Language: en-US
In-Reply-To: <b2fbe58e-f47b-4a76-879b-fd38a915c2ce@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7xgtwdadmx1d7cz7h9t8tkw9wczx8bep
X-Rspam-User: 
X-Rspamd-Queue-Id: A5FEA40012
X-Rspamd-Server: rspam09
X-HE-Tag: 1764227695-693940
X-HE-Meta: U2FsdGVkX19I5X8MFy1R5e6gs7u9MUTCnM5epouzxxdpYhxXv7dMqolrGGVEz+oyOHHWuQYUywR+rIoCXBfU3sNAHjD0llPO9nkymi0v7ExtJCs4YcpkS/Om8I5xM4vR1CFbAvpu52xOA/SuEyDzwekVtvDIU0l0sqf5NbpDMx+hVIYb0pVeOQLWoRDP7KwaGBoOS8qAOA4kbMQg8xoBWy8j4uGWMDPL9XI68vTUOZNDoTngscRyBCGjF2XD2W/sv2YNILucb7lWElR/LjWna2NI7lHsYjB3We+yHu5bDugOGi5z72CTOxRqpi0vLTdb4XdP6TQn1yK73usbCHJH9bdkMFf2bKd3Rjbn4n69arN4Kr/tG22U11WndQWopEE4Ro18b1SJiWOqNtwjXb9lXoBZypUR/PNTTlE7/WO9KGFFZVMntKUWc95v9iDcAr3wUN5++gZAox5NYebXeKTXQWKSGpEzGYOglJZvF4MWn0BnkbUfnA7HhqBYd7o7AQExjWuZuEZnwvz/2JlS5X5dFcSOi41Sum1p1LRGsEAdoZ7ilCYCfRc114y6Ji/Tl6Bwyxd2hIQ85p5UG4igB58r7IDIAtBZAOmX7ws/t8aEeiPTdJKx6GXeLLhvlQbop85s6M8cgf+j88j3BFTfziGTkpLFqxTMXaXeZ9lBIclGe6enoEdPyUjXOAwXiunvCaWuw60oiHP5gr0NuQigFJlFMV+bGB+rGdR0DhU29E3rdIQdVXDY+qE+DPEnO3Q8RXuq/JAE4TlWQVsnsV2wj2PZe9E3uAlW8cmP4O8vfn0o9rtDWclvKLA8Mau3flZWJ28M82IjUK2nIJxSFG8kTLgZQ7Dn+OMjqoOO0PIBSI+F2cERPdJRDjrrt6Yq5cY7gBAy1wFySJASYwpP3wfR7Q+2ycprmZ3E7KoC+bwSbCcy/E8N6mNcbvFxhvLcqnwSixWtdYEd1a7oudAYx/CWVJK
 pCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 21:31, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 17:34, Ryan Roberts wrote:
>> On 26/11/2025 16:07, Ryan Roberts wrote:
>>> On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
>>>> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>>>>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>>>>
>>>>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>>>>>> requiring a READ_ONCE() further up the stack?
>>>>>>
>>>>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>>>>> functions are just simple stubs.
>>>>>
>>>>> OK, thought you were saying we should push further down the stack? Or up
>>>>> depending on how you view these things :P as in READ_ONCE at leaf?
>>>>
>>>> I think at leaf because I think the previous ones should essentially be only
>>>> used by stubs.
>>>>
>>>> But I haven't fully digested how this is all working. Or supposed to work.
>>>>
>>>> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h example to
>>>> see if I can make sense of it,
>>>
>>> I wonder if we can think about this slightly differently;
>>>
>>> READ_ONCE() has two important properties:
>>>
>>>    - It guarrantees that a load will be issued, *even if output is unused*
>>>    - It guarrantees that the read will be single-copy-atomic (no tearing)
>>>
>>> I think for the existing places where READ_ONCE() is used for pagetable reads we
>>> only care about:
>>>
>>>    - It guarrantees that a load will be issued, *if output is used*
>>>    - It guarrantees that the read will be single-copy-atomic (no tearing)
>>>
>>> I think if we can weaken to the "if output is used" property, then the compiler
>>> will optimize out all the unneccessary reads.
>>>
>>> AIUI, a C dereference provides neither of the guarrantees so that's no good.
>>>
>>> What about non-volatile asm? I'm told (thought need to verify) that for
>>> non-volatile asm, the compiler will emit it if the output is used and remove it
>>> otherwise. So if the asm contains the required single-copy-atomic, perhaps we
>>> are in business?
>>>
>>> So we would need a new READ_SCA() macro that could default to READ_ONCE() (which
>>> is stronger) and arches could opt in to providing a weaker asm version. Then the
>>> default pXdp_get() could be READ_SCA(). And this should work for all cases.
>>>
>>> I think.
>>
>> I'm not sure this works. It looks like the compiler is free to move non-volatile
>> asm sections which might be problematic for places where we are currently using
>> READ_ONCE() in lockless algorithms, (e.g. GUP?). We wouldn't want to end up with
>> a stale value.
>>
>> Another idea:
>>
>> Given the main pattern where we are aiming to optimize out the read is something
>> like:
>>
>> if (!pud_present(*pud))
>>
>> where for a folded pmd:
>>
>> static inline int pud_present(pud_t pud)	{ return 1; }
>>
>> And we will change it to this:
>>
>> if (!pud_present(pudp_get(pud)))
>>
>> ...
>>
>> perhaps we can just define the folded pXd_present(), pXd_none(), pXd_bad(),
>> pXd_user() and pXd_leaf() as macros:
>>
>> #define pud_present(pud)	1
>>
> 
> Let's take a step back and realize that with __PAGETABLE_PMD_FOLDED
> 
> (a) *pudp does not make any sense
> 
> For a folded PMD, *pudp == *pmdp and consequently we would actually
> get a PMD, not a PUD.
> 
> For this reason all these pud_* helpers ignore the passed value
> completely. It would be wrong.
> 
> (b) pmd_offset() does *not* consume a pud but instead a pudp.
> 
> That makes sense, just imagine what would happen if someone would pass
> *pudp to that helper (we'd dereference twice ...).
> 
> 
> So I wonder if we can just teach get_pudp() and friends to ... return
> true garbage instead of dereferencing something that does not make sense?
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 32e8457ad5352..c95d0d89ab3f1 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -351,7 +351,13 @@ static inline pmd_t pmdp_get(pmd_t *pmdp)
>    #ifndef pudp_get
>    static inline pud_t pudp_get(pud_t *pudp)
>    {
> +#ifdef __PAGETABLE_PMD_FOLDED
> +       pud_t dummy = { 0 };
> +
> +       return dummy;
> +#else
>           return READ_ONCE(*pudp);
> +#endif
>    }
>    #endif
>    
> set_pud/pud_page/pud_pgtable helper are confusing, I would
> assume they are essentially unused (like documented for set_put)
> and only required to keep compilers happy.

Staring at GUP-fast and perf_get_pgtable_size()---which should better be 
converted to pudp_get() etc--I guess we might have to rework 
p4d_offset_lockless() to do something that doesn't rely on
passing variables of local variables.

We might have to enlighten these walkers (and only these) about folded 
page tables such that they don't depend on the result of pudp_get() and 
friends.

-- 
Cheers

David

