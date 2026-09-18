Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD66C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0888E6B0092; Fri, 18 Sep 2026 02:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F086B0093; Fri, 18 Sep 2026 02:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91546B0095; Fri, 18 Sep 2026 02:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA1D16B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:05:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DAAF80346
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:05:45 +0000 (UTC)
X-FDA: 85225846650.12.6DD1EEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71864140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:05:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRYJtWuL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789711543;
	b=Uaoyuk9qjaDV91lHk1NWnoV4D8Yk5edCuI6u0RnhHE7SsgdowYhPcyLh9oNaFx2kAZY7v/
	vu1ZGSeBDUZLOkAaBOv/j+0qFcTjXe2HBDoNJ10n7p3DoNhfNnjJzmXY1hnuxOaaVv6aEi
	4X+IMUKWAeURF14kgfhb3JJbYIIVb8k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRYJtWuL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789711543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iSN1j31Sw9qmqTYVp6Ry3mKQfg4lt3sT+FCrOQ8mF4=;
	b=3+YGqj+srPFp9jCZ7pLEOSSU10xPb8o9oQ1FgoSDRRK2L93cQWx3AyodXEu9a4/9ZE4vJA
	Lg8fm5QPiSo4pgmmhXX4pZsfwLpWyRXk7mHpgfWFi+V+8z5BWN0C8ocJwPeX2TWU4VP9YZ
	nhXmOMKvI2QHkmwPkUqK3f7/cdxlZOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B76F8601EF;
	Fri, 18 Sep 2026 06:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB971F000FF;
	Fri, 18 Sep 2026 06:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789711542;
	bh=2iSN1j31Sw9qmqTYVp6Ry3mKQfg4lt3sT+FCrOQ8mF4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HRYJtWuL74SbBnfcEwdWnfbXL/tQ2LS0eZcRDZCBlNLQXBydIBtYqkiENXlDagnbT
	 C2yEEFg2K7h5z+2opnb1JHsi/x+l+mdBVTLNqkvv/DpshLB82Svt8wnmGViSmp38iu
	 RqWJqCe9NjqFd7sIoVai7vkuR1L3g/ELqekIScdjqxdSM+2tF1sE2M5vUb+ybXhH2T
	 qeHd1/7ezHu35c25/Re5wk4kWvG7SMvYr71yv/QjO7HFaVvMkPqGp28tk2Tjav58QQ
	 8Q3/O3ocmaqrfak5BYTC5KAwevQhgl+fUqMCEBp14MV+FG3sEjD8+8xfzUSXElZXjR
	 UltrRtZcQGVSg==
Message-ID: <2462f67c-f7d3-4eb3-a093-6a338ef49f14@kernel.org>
Date: Fri, 18 Sep 2026 08:05:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Barry Song <baohua@kernel.org>, Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org,
 dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com>
 <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
 <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
 <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71864140004
X-Stat-Signature: mwoh9uaq136ynrhy5rc9b3s1akitupq4
X-HE-Tag: 1789711543-361142
X-HE-Meta: U2FsdGVkX1/WlxRmKLX8B2EmBVm7lZu/UVZqYVp5FBqmnwu0WhP6tBeXfyFcp2KJt93PPCwNfVXL94GIbpZfQdWwPpy7OyiNAlfPXkotqV/kbCn3RbacRhEY33JtnWR/Na9+Kh9sq5YxOMWXjasG+OH0rZdVKRkcsfhgpWr5YcwnE/lehJU/rd+RNapINlrzwExn9gikDIzAplcK34ywBc0O0O1FxpCofObfvO1JW0t1Hbh08WBv/dfCgm982CdJXnU5XDSE0MA7cWV3fZRLUoeaCcHpCJR+ogbNEnMTiqW+t8f9afc5vxGXMejMej38I30DANQHMtkKVT3YIOKHEbl8zMelohavk6GmK7+jaCS4z6VhqiOyyL4jbtEfRAM8n07pxqgr7lWpwUyTV954vhvsvyxeQf7977cAM7UP8sXafWJc7mGfvryLJWB/UNEm8hXQohfoK61NTjJfJNrvhs6CL0qfu4d1ecpd3Rp0wEIMIxuUiiiz5jj+KIbCueWQhJl2D40RNeAAzI/AdOsMICFiMTNwdXuVH2tRm25SRg1yKrlqXH0leZzyujk1Ecrh5VsKmtKVFj1MPVzPebQsM4WMHrlC/nobpv4WtSnv0psumf+NzAUy1ht1r4Z/irBYEkISQHTA+/4kQr36hr7XT4SusfVLEGmDD8EYiCDEwEd0Z0j9RLFtu+LyOVZYPccT3a/dpayyXc5okV2WDB3M4GcUEv/+aV5pcVIfChmPgsC5phXq6lvivmNACDLZm4U2JKrkm4sIj1BIv9PWj93hLdq4wt+e2l8+rdVDAQAUf5JBrQSufFTkDAoK6DzQLMQUALKl3dd8kpOgrazm3CDFFC6LoCDK7/JrX69m8/ONyZNaxsM3sr8b4ERa0hyG07qt84kOXuSaYD4rLrk86kCjNAV7B552mbx23DnBeH3/lvJCnoF0vWyHobXgZKmSN/WPDa+uO/3w53jrogTUc59
 aSUYYG0m
 /Kstz9GrYhUmRSUjQeGyLglw9KF95fRp6OLpdPvbX6h6xfrwKcB96zgB3oFaJsvaQSSGuk/bBBQ3FLumQFZKGdWDGdmBsLUN1ulreK7YlyyI5uQroEqOrgwkWt0IZ3CQG4l78fT8cB+qxzVjUtq4XD4xNwpxRuzjoeA00HJZU3L2FA1eSlWKP0AAwfANiNLvclopc0GgRqqw2XBb+uoecEmDTMPD6p52afGv/ZeXHnd8V3U9WLqwg9JMzRgNwDYG5Z/pMqmUaWC1p13kx5goz7Im+1wlUSjZw7/Fxn84E8LsUzVPb97NHDuh00F9sbIsPpw4tI46WXko9Q/D6plKewMWhAVyCOoZLCkY5qy73cksecIPvKr4ZuD4jyj+5SxTKCUVdmFc5IyfnO8Db7zvew+uulG++TGlxTiame9PAorLtd5sr524cn65HAlKNjao4XPpGfHYapkHLTxsNXnwO5MwN8Dgl39eu+VUFHLHW3Zpr2myGDgmL1RydLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 17/09/2026 à 23:44, Barry Song a écrit :
> On Thu, Sep 17, 2026 at 10:41 PM Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>
>> On Thu, 17 Sept 2026 at 22:00, Christophe Leroy (CS GROUP)
>> <chleroy@kernel.org> wrote:
>>>
>>>
>>>
>>> Le 17/09/2026 à 07:29, Wen Jiang a écrit :
>>>> From: Wen Jiang <jiangwen6@xiaomi.com>
>>>>
>>>> vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
>>>> huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
>>>> the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
>>>> couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
>>>>
>>>> Now that arm64 and powerpc/8xx provide pte_set_huge() and
>>>> pte_clear_huge(), add the generic fallbacks next to the existing
>>>> pmd/pud_set_huge() family and convert vmap_pte_range() and
>>>> vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
>>>> around the block-mapping paths are dropped, so PTE-level block mappings
>>>> now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
>>>> longer includes <linux/hugetlb.h>.
>>>>
>>>> The fallbacks exist only to keep the build working on architectures
>>>> without PTE-level block mapping support. They are unreachable there:
>>>> the callers only run when arch_vmap_pte_range_map_size() or
>>>> arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
>>>> which requires an arch implementation. WARN_ON_ONCE() makes that
>>>> explicit rather than silently doing nothing.
>>>>
>>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>>> ---
>>>>    include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
>>>>    mm/vmalloc.c            | 19 ++++++-------------
>>>>    2 files changed, 35 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>> index cdd68ed3ae1a9..349ced999f959 100644
>>>> --- a/include/linux/pgtable.h
>>>> +++ b/include/linux/pgtable.h
>>>> @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
>>>>    }
>>>>    #endif      /* CONFIG_HAVE_ARCH_HUGE_VMAP */
>>>>
>>>> +/*
>>>> + * PTE-level block mappings for vmap.
>>>> + *
>>>> + * pte_set_huge() only has to be implemented by architectures whose
>>>> + * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
>>>> + */
>>>> +#ifndef __HAVE_ARCH_PTE_SET_HUGE
>>>> +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
>>>> +                             phys_addr_t phys, pgprot_t prot,
>>>> +                             unsigned long size)
>>>> +{
>>>> +     WARN_ON_ONCE(1);
>>>
>>> BUILD_BUG_ON() would be better here.
>>>
>>> It should be possible because fallback arch_vmap_pte_range_map_size()
>>> will constant-fold PAGE_SIZE so pte_set_huge() will never be called.
>>>
>>
>> Agreed. These fallbacks exist only to keep the build working on
>> architectures with PTE-level block mappings and should never actually
>> be reached, so BUILD_BUG_ON() is right. I'll make that change in v9.
>>
> 
> I am not quite sure. It won't be called at runtime because
> `vmap size`/`unmap size` return `PAGE_SIZE`, so the code won't
> reach this branch. But it will still be built.

The fallbacks are defined as:

#ifndef arch_vmap_pte_range_map_size
static inline unsigned long arch_vmap_pte_range_map_size(unsigned long 
addr, unsigned long end,
							 u64 pfn, unsigned int max_page_shift)
{
	return PAGE_SIZE;
}
#endif

#ifndef arch_vmap_pte_range_unmap_size
static inline unsigned long arch_vmap_pte_range_unmap_size(unsigned long 
addr,
							   pte_t *ptep)
{
	return PAGE_SIZE;
}
#endif

Therefore in:

                 size = arch_vmap_pte_range_unmap_size(addr, pte);
                 if (size != PAGE_SIZE) {

GCC knows 'size' is const and its value is PAGE_SIZE, so it won't emit 
the branch at all.

It is call constant folding, some explanation here: 
https://en.wikipedia.org/wiki/Constant_folding

> 
> So, would a `BUILD_BUG_ON()` trigger a build failure here?

It shouldn't, if it does it is a compiled bug or this is because someone 
has redefined arch_vmap_pte_range_map_size() and not pte_set_huge() 
which we'd better know at build time rather than at runtime.


> 
> Best Regards
> Barry
> 


