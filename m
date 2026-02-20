Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1C0C531E4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487326B0088; Thu, 19 Feb 2026 23:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435456B0096; Thu, 19 Feb 2026 23:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316886B0098; Thu, 19 Feb 2026 23:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5AA6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:12:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1A125C242
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:12:55 +0000 (UTC)
X-FDA: 84463514310.18.87FD9B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6143C140003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:12:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771560774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9drD0xvk2/sSUZgUNn+/Wos7OqQ6apy7XGgOP+RDgXg=;
	b=JkQd/hM+AYAYN7EqYiAFzEjN1ijemshUX9NTWpzRyzKCDMJrV72rDwdTTF0trRQvGLM0oS
	6feCIRy0S6w6s3ni7EC5wvrvM0Vj8H+8QLsAkeIfKVvA7QTzLxqCtgbfHjn9BgzUCESUz4
	zstkC+jOODx90l+6hzCRHmmCM/MAKfc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771560774; a=rsa-sha256;
	cv=none;
	b=nb8EeCfpU+NHELi0GDzQC7AC3WOEtkFiPdUl1Vzh9G+SIveS8FL5mvaqzYj8ZQFyDjKE5K
	7Zw+mSLVAorgnxO+JeVu7GjGg3TwcvYNfiRJRTAdicuMeYsoV5g2jRIIlzrL1YJMSHLr8i
	KLibghlge6ae7bVT/KhwYb/7cLUlC5Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF965339;
	Thu, 19 Feb 2026 20:12:45 -0800 (PST)
Received: from [10.164.148.40] (unknown [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8EFF3F62B;
	Thu, 19 Feb 2026 20:12:48 -0800 (PST)
Message-ID: <484434ed-6300-450a-aacd-3e370e1c167c@arm.com>
Date: Fri, 20 Feb 2026 09:42:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Pedro Falcato <pfalcato@suse.de>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luke Yang <luyang@redhat.com>, surenb@google.com, jhladky@redhat.com,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org,
 vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
 <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
 <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
 <624496ee-4709-497f-9ac1-c63bcf4724d6@kernel.org>
 <r2b2cjuqicmrw3zdwruacpelulhjhfdawrtbgzph5vsf6h5omj@dhrga7p62hju>
 <9209d642-a495-4c13-9ec3-10ced1d2a04c@kernel.org>
 <rtaao2lmzbmyugjeqdwhnacztjfgijjcax6itgst557qhqsnkr@iibocfiibsfh>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <rtaao2lmzbmyugjeqdwhnacztjfgijjcax6itgst557qhqsnkr@iibocfiibsfh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6143C140003
X-Rspamd-Server: rspam02
X-Stat-Signature: wkdakess9jie7u5gxb18neek5hhsm5gq
X-HE-Tag: 1771560773-28007
X-HE-Meta: U2FsdGVkX1/J27R2deSDZxNSpywYW1qs/zV+VNVtRUqU2emnCmjxY4TyC6OBbC6vR7nSz555J2ajGTm4pczpc5iIF2eOxE96nV4IozIdk3VqCzQ40B+KyTWYCBquOGH4ZKZr7DNpbzTFy1xAXC4KVQOKrreadykYhqAaBRbbvjcgO4gruW0xn9DZhyfn3ZXfkeWwxRTyJWYW0TYp0lWTw7stYgS3tIkuTtvYG+8e26KiLP0z+3ycgscj1fxnrgz2UCanJb4jH+I0OF7AnkGKirEHQArPmpcocJswKATr6oeN5x8qU+br/+I6tsfkfCDl53of8vNUwZzmguzRxg5HM/io6rSrHtcLRqjypViKE7dtBZwCktq23SM3mU+PeZOrd4r4T9vHlKuMi5jzFbBeul1Qz9cL5wWH4wZXd0rLDjI+SYyal8y0fiD/cEgaoeJzFNZE5Ffq8JYkCCMJ9pkYnGvb0KWd9wZ+8ewsQKG22mL60K3BYDEEMYYYzR72+u75vFdnntvRLZ5eUFRMD2C2Jgt8ejE0mxotrqwmcGdMZQ4IaRyhb+hVJEHP4LvbcPhSk3NzkgYtlCJqUbhaYQxB5q6h6pMKt7OeA78pvGr5CXtB/fhVM5KPUutF9o/arWguFZceFLSSa8Ane4Uop6bdPFjiAbekne4sDkLMyQz7qcOnngXdUGzw4mAtUchzOIaCmpFiOuf4oZvcn/ZYxCZkgDC/7LZBJvZqRId0NqsJsy8qFXMKySmHq3cRn7uLYN2IgEykDbNvatw75XYSq2QF9JLUhQJ4gMt7OMIPEjPwwgWeqieiLGUgr9e6lncr3/HU7lXRBe+rOiQwPLZKacIJN8eOZvyL3fWlzBJEBhOyZo1KgXI9USm0kgHYPyRgL5e269x8GiyeBA66ZR4Zvs0FwJErr00j8AsTaBg9hASaq/r6g4KwmJGaHS9OtONXEBgJ8uv3NNJMvEE0Fra+txT
 UQMtq+md
 7rCMvOsbGCUuRlPBuAEpc3ggErZhnITCaoJ+ktrt0Ij6sHbtp1W/ij/59pM1vGPIBm2Q5iSwlLpyUzP+SyXIEZKZYUqXW+ifE4k9+R98LkVmoZmkiPu6g5n7MNtgqxghTBD6Qt/vTVC58OBs9fGfug8tkJ9ANbGO04e0P2nlvKlRc3DNTH9fBvslrKoyyzVaAveA5UO4Nyd1MCd+V9zclTj3I3vwQJXWRQn+s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/02/26 8:30 pm, Pedro Falcato wrote:
> On Thu, Feb 19, 2026 at 02:02:42PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/19/26 13:15, Pedro Falcato wrote:
>>> On Wed, Feb 18, 2026 at 01:24:28PM +0100, David Hildenbrand (Arm) wrote:
>>>> On 2/18/26 12:58, Pedro Falcato wrote:
>>>>> I don't understand what you're looking for. an mprotect-based workload? those
>>>>> obviously don't really exist, apart from something like a JIT engine cranking
>>>>> out a lot of mprotect() calls in an aggressive fashion. Or perhaps some of that
>>>>> usage of mprotect that our DB friends like to use sometimes (discussed in
>>>>> $OTHER_CONTEXTS), though those are generally hugepages.
>>>>>
>>>> Anything besides a homemade micro-benchmark that highlights why we should
>>>> care about this exact fast and repeated sequence of events.
>>>>
>>>> I'm surprise that such a "large regression" does not show up in any other
>>>> non-home-made benchmark that people/bots are running. That's really what I
>>>> am questioning.
>>> I don't know, perhaps there isn't a will-it-scale test for this. That's
>>> alright. Even the standard will-it-scale and stress-ng tests people use
>>> to detect regressions usually have glaring problems and are insanely
>>> microbenchey.
>> My theory is that most heavy (high frequency where it would really hit performance)
>> mprotect users (like JITs) perform mprotect on very small ranges (e.g., single page),
>> where all the other overhead (syscall, TLB flush) dominates.
>>
>> That's why I was wondering which use cases that behave similar to the reproducer exist.
>>
>>>> Having that said, I'm all for optimizing it if there is a real problem
>>>> there.
>>>>
>>>>> I don't see how this can justify large performance regressions in a system
>>>>> call, for something every-architecture-not-named-arm64 does not have.
>>>> Take a look at the reported performance improvements on AMD with large
>>>> folios.
>>> Sure, but pte-mapped 2M folios is almost a worst-case (why not a PMD at that
>>> point...)
>> Well, 1M and all the way down will similarly benefit. 2M is just always the extreme case.
>>
>>>> The issue really is that small folios don't perform well, on any
>>>> architecture. But to detect large vs. small folios we need the ... folio.
>>>>
>>>> So once we optimize for small folios (== don't try to detect large folios)
>>>> we'll degrade large folios.
>>> I suspect it's not that huge of a deal. Worst case you can always provide a
>>> software PTE_CONT bit that would e.g be set when mapping a large folio. Or
>>> perhaps "if this pte has a PFN, and the next pte has PFN + 1, then we're
>>> probably in a large folio, thus do the proper batching stuff". I think that
>>> could satisfy everyone. There are heuristics we can use, and perhaps
>>> pte_batch_hint() does not need to be that simple and useless in the !arm64
>>> case then. I'll try to look into a cromulent solution for everyone.
>> Software bits are generally -ENOSPC, but maybe we are lucky on some architectures.
>>
>> We'd run into similar issues like aarch64 when shattering contiguity etc, so
>> there is quite some complexity too it that might not be worth it.
>>
>>> (shower thought: do we always get wins when batching large folios, or do these
>>> need to be of a significant order to get wins?)
>> For mprotect(), I don't know. For fork() and unmap() batching there was always a
>> win even with order-2 folios. (never measured order-1, because they don't apply to
>> anonymous memory)
>>
>> I assume for mprotect() it depends whether we really needed the folio before, or
>> whether it's just not required like for mremap().
>>
>>> But personally I would err on the side of small folios, like we did for mremap()
>>> a few months back.
>> The following (completely untested) might make most people happy by looking up
>> the folio only if (a) required or (b) if the architecture indicates that there is a large folio.
>>
>> I assume for some large folio use cases it might perform worse than before. But for
>> the write-upgrade case with large anon folios the performance improvement should remain.
>>
>> Not sure if some regression would remain for which we'd have to special-case the implementation
>> to take a separate path for nr_ptes == 1.
>>
>> Maybe you had something similar already:
>>
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index c0571445bef7..0b3856ad728e 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -211,6 +211,25 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>>         commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>>  }
>> +static bool mprotect_wants_folio_for_pte(unsigned long cp_flags, pte_t *ptep,
>> +               pte_t pte, unsigned long max_nr_ptes)
>> +{
>> +       /* NUMA hinting needs decide whether working on the folio is ok. */
>> +       if (cp_flags & MM_CP_PROT_NUMA)
>> +               return true;
>> +
>> +       /* We want the folio for possible write-upgrade. */
>> +       if (!pte_write(pte) && (cp_flags & MM_CP_TRY_CHANGE_WRITABLE))
>> +               return true;
>> +
>> +       /* There is nothing to batch. */
>> +       if (max_nr_ptes == 1)
>> +               return false;
>> +
>> +       /* For guaranteed large folios it's usually a win. */
>> +       return pte_batch_hint(ptep, pte) > 1;
>> +}
>> +
>>  static long change_pte_range(struct mmu_gather *tlb,
>>                 struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
>>                 unsigned long end, pgprot_t newprot, unsigned long cp_flags)
>> @@ -241,16 +260,18 @@ static long change_pte_range(struct mmu_gather *tlb,
>>                         const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
>>                         int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
>>                         struct folio *folio = NULL;
>> -                       struct page *page;
>> +                       struct page *page = NULL;
>>                         pte_t ptent;
>>                         /* Already in the desired state. */
>>                         if (prot_numa && pte_protnone(oldpte))
>>                                 continue;
>> -                       page = vm_normal_page(vma, addr, oldpte);
>> -                       if (page)
>> -                               folio = page_folio(page);
>> +                       if (mprotect_wants_folio_for_pte(cp_flags, pte, oldpte, max_nr_ptes)) {
>> +                               page = vm_normal_page(vma, addr, oldpte);
>> +                               if (page)
>> +                                       folio = page_folio(page);
>> +                       }
>>                         /*
>>                          * Avoid trapping faults against the zero or KSM
>>
> Yes, this is a better version than what I had, I'll take this hunk if you don't mind :)
> Note that it still doesn't handle large folios on !contpte architectures, which
> is partly the issue. I suspect some sort of PTE lookahead might work well in
> practice, aside from the issues where e.g two order-0 folios that are
> contiguous in memory are separately mapped.
>
> Though perhaps inlining vm_normal_folio() might also be interesting and side-step
> most of the issue. I'll play around with that.

Indeed this is one option.

You can also experiment with
https://lore.kernel.org/all/20250506050056.59250-3-dev.jain@arm.com/
which approximates presence of large folio if pfns are contiguous.

>

