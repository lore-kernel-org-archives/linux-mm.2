Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89EECCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088E38E0005; Mon, 10 Nov 2025 04:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060B68E0002; Mon, 10 Nov 2025 04:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFE08E0005; Mon, 10 Nov 2025 04:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBADC8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:19:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 848BC4CA3A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:19:53 +0000 (UTC)
X-FDA: 84094150266.14.F97ABDE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7AB75100003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:19:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762766390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BE9g58aO+50xrZTAkMSZ+nucJ9JIlqY0y6onurX6UkE=;
	b=EnvAdVGKQ8/ltAmkTcEltygSW30IMo07c1/5D5TZBT1jVHU5VZoVECMlad1IfOckvTTtWm
	rZ8udJyX+ViiDFLM4wb7cndjcXg2mX1TFTGLOyi3Y0ghDJV3zQ6lMJYt7gRQfEIQdTHM6j
	Wv/KiqeSbinxuJHRSHMtldqODsrgThQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762766390; a=rsa-sha256;
	cv=none;
	b=C2Yl1ZMhBnPvx4vMzk/e/n1rbXYiVUFicaK7eo/4mTZirxzlkx4F6RqyV4ARf2cUyNC1+1
	PE0hf0L0EjvlPkyP8egfohEmzFgbQMuCn/bUAMiqedDXP1I3B5sUXZjjIkqmkjc9Arat+i
	scGZfFrKxOyGDLdlSHe0/8+1pg5hGf0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91A6F2B;
	Mon, 10 Nov 2025 01:19:41 -0800 (PST)
Received: from [10.57.85.123] (unknown [10.57.85.123])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CED693F63F;
	Mon, 10 Nov 2025 01:19:42 -0800 (PST)
Message-ID: <e428b1d5-65a8-49bc-92dc-ec4a4d933dec@arm.com>
Date: Mon, 10 Nov 2025 09:19:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
Content-Language: en-GB
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
 <c764489e-0626-4a50-87b5-39e15d9db733@gmail.com>
 <645178fd-df4e-42fe-b55e-97d9506499be@arm.com>
 <413b2c49-f124-4cda-8fea-a6cc165f6326-agordeev@linux.ibm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <413b2c49-f124-4cda-8fea-a6cc165f6326-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AB75100003
X-Stat-Signature: pnpw7rew3kdjd9xostb8f3b8f584ay1u
X-Rspam-User: 
X-HE-Tag: 1762766390-884478
X-HE-Meta: U2FsdGVkX1+48cqe37bnTmiPixvznue+krg6kBTRBg6FJmo5aAXcBhFfc2q+21rKMxSY0kQ3I+WmG6iP1DKOS1KWerdPoFMDw6e602h3mN+uw325k2CApetQI3Dtq1z4SQgA1ta2+Kr8Dn6bFVr7yQLGY2TNjvRLGm2Z2cYJJ0QAWBS0iiSbuyA7fVf/O2H5RgTdB9mKw7tUwOg67H0eT92c+6/axjW5rjQXD2JjOu6d1j2ds8VJczugtZuxqYImCz7rizBq9LXDhjbHqep5rorJI6iVEmYcFWO2sb/10t+ZSspvUgE63Fwl50I58bWtu8QmYSECS//NgDE6+CyB5XNeP/Zp8gGWiv16kqbw8zhHcXESPr0ZDolcpWortX6bhUmDVnzpq+g5E6b3+IPwS2ux4x7T8v5m3txpnQwLbbb3Q7kwDASklTxgKtJ4d6lDBTJGj8k7C3DEmQ9hbr9jCoIvlMyQ9+q3gNcrPZAuVh+954h6U7t8QR/LK0jqeXg7Nx910S33feh0Coqb4xqVfOPDPFl/AKiUspbmobM01qWMhgVMpZKIEzd0t1pm2EQ+CfYNmHRyDTvP7llxMAG0BdNnYJLp3Iv1/NGdl6P8Qrt1bc2jOdnTopi6ElxV/okSkG7JU/n/l/QFr3+9mYVzmo/0uSExU4X4EPrFmbmv0V1Li7MZDOuSgYiQ3AxEF9LDh9xiQg+RcUf5ATGbzlo9qEGsHMQMyoDZq1JXDCVgDyyLxmQqErMAu+ZZxUf8o0Y4hBNrq6Fy6ZmaT7hKDeNgwxC4SZq0HRWCaheJQDHolWX6RZaPDh0IEWncyTo7dEqzoyZWOO5kYGo+G08sn9Il33n3hTuIUrAhxVbwBTHOqcRI8aMvXVsY3ARY3VEmFZSttJRa0voYauz7PFeM6uONTGucNr6VjzHa5euisgoQGZSSSwxpP5ylOrhc8Adx9mAxEl5xECPje1tAvWfr+Jf
 TD5hO7VC
 5vCvsuQzUyvQRLNJf9LOUlscMsQx2S/e687bvyNXR9UEv3GLf4a58r4KwIa3S7vwSFOVRneUCdV1qBarpvA2f9+veuNjpdRwG1VV5g9ZGPnVRs04H2h7OMfo+W1GdGy51NlISNqHxDFPdpRw6sxbc8KIKjM+Uz3AX01YHh5F+H4PFuAg3U20a/DnIHiJIJ5uvCC6oTlnbgG5x18JJhHfmaokF4n/63B8MIVfQx+QGzMztUsBFWoBslJ3DCBn2aG3DMjlDghoJJXiwmOR+8jw9zJMeKzQSEwzUym7LqerSEFM6gX4F0v4lcI629mCFLlT6exKE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/2025 08:11, Alexander Gordeev wrote:
> On Fri, Nov 07, 2025 at 03:22:54PM +0000, Ryan Roberts wrote:
> 
> Hi Ryan,
> 
>> On 07/11/2025 14:34, David Hildenbrand (Red Hat) wrote:
>>>>>   #ifndef pte_batch_hint
>>>>> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>>>>> index 5d2a876035d6..c49b029d3593 100644
>>>>> --- a/mm/kasan/shadow.c
>>>>> +++ b/mm/kasan/shadow.c
>>>>> @@ -305,7 +305,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep,
>>>>> unsigned long addr,
>>>>>       pte_t pte;
>>>>>       int index;
>>>>>   -    arch_leave_lazy_mmu_mode();
>>>>> +    lazy_mmu_mode_pause();
>>>>
>>>> I wonder if there really are use cases that *require* pause/resume? I think
>>>> these kasan cases could be correctly implemented using a new nest level instead?
>>>> Are there cases where the effects really need to be immediate or do the effects
>>>> just need to be visible when you get to where the resume is?
>>>>
>>>> If the latter, that could just be turned into a nested disable (e.g. a flush).
>>>> In this case, there is only 1 PTE write so no benefit, but I wonder if other
>>>> cases may have more PTE writes that could then still be batched. It would be
>>>> nice to simplify the API by removing pause/resume if we can?
>>>
>>> It has clear semantics, clearer than some nest-disable IMHO.
>>>
>>> Maybe you can elaborate how you would change ("simplify") the API in that
>>> regard? What would the API look like?
>>
>> By simplify, I just meant can we remove lazy_mmu_mode_pause() and
>> lazy_mmu_mode_resume() ?
>>
>>
>> We currently have:
>>
>> apply_to_page_range
>>   lazy_mmu_mode_enable()
>>     kasan_populate_vmalloc_pte()
>>       lazy_mmu_mode_pause()
>>       <code>
>>       lazy_mmu_mode_resume()
>>   lazy_mmu_mode_disable()
>>
>> Where <code> is setting ptes. But if <code> doesn't need the effects to be
>> visible until lazy_mmu_mode_resume(), then you could replace the block with:
>>
>> apply_to_page_range
>>   lazy_mmu_mode_enable()
>>     kasan_populate_vmalloc_pte()
>>       lazy_mmu_mode_enable()
>>       <code>
>>       lazy_mmu_mode_disable()
>>   lazy_mmu_mode_disable()
>>
>> However, looking at this more closely, I'm not really clear on why we need *any*
>> special attention to lazy mmu inside of kasan_populate_vmalloc_pte() and
>> kasan_depopulate_vmalloc_pte().
>>
>> I *think* that the original concern was that we were doing ptep_get(ptep) inside
>> of a lazy_mmu block? So we need to flush so that the getter returns the most
>> recent value? But given we have never written to that particular ptep while in
>> the lazy mmu block, there is surely no hazard in the first place?
> 
> There is, please see:
> https://lore.kernel.org/linux-mm/cover.1755528662.git.agordeev@linux.ibm.com/

I've stared at this for a while, but I'm afraid I still don't see the problem.
This all looks safe to me. Could you explain exactly what this issue is?

If I've understood correctly, kasan_populate_vmalloc() is called during virtual
range allocation by vmalloc. This is not in a nested lazy mmu block (but it
wouldn't matter if it was once we have Kevin's nested changes to ensure flush
when exiting the nested scope). kasan_populate_vmalloc() calls
apply_to_page_range(), which will walk the set of ptes, calling
kasan_populate_vmalloc_pte() for each one. kasan_populate_vmalloc_pte() does a
ptep_get() then, if none, calls set_pte_at().

That's not a hazard since you're calling get before the set and you only visit
each pte once for the apply_to_page_range() lazy mmu block.

> 
>> apply_to_existing_page_range() will only call kasan_depopulate_vmalloc_pte()
>> once per pte, right? So given we read the ptep before writing it, there should
>> be no hazard? If so we can remove pause/resume.
> 
> Unfortunately, we rather not, please see:
> https://lore.kernel.org/linux-mm/d407a381-099b-4ec6-a20e-aeff4f3d750f@arm.com/

Sorry but I don't see anything relavent to my point in this mail. Perhaps there
is some s390-specific detail that I'm failing to understand?

Thanks,
Ryan

> 
> The problem is kasan code invokes apply_to_page_range(), which enters lazy_mmu
> mode unconditionally. I would claim that is rather an obstacle for the kasan
> code, not a benefit. But it needs to be tackled.
> > Should apply_to_page_range() had an option not to enter the lazy_mmu mode
> (e.g. an extra "bool skip_lazy" parameter) - the pause/resume could have
> been avoided.
> 
>> Thanks,
>> Ryan
> 
> Thanks!


