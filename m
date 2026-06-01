Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21BA7CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5EC6B031C; Mon,  1 Jun 2026 06:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FDF6B031D; Mon,  1 Jun 2026 06:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427D26B031E; Mon,  1 Jun 2026 06:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEDD6B031C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:48:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDACF1C0A8B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:48:23 +0000 (UTC)
X-FDA: 84831019686.04.3BE4D81
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id DB0C620002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:48:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=neaGU8o1;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780310902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpP3p+OZ5kTTKtnC7lknJ8SUiTBUDhdsLvtMvZmEm/4=;
	b=rpTTHs6FAMCf9p/fNLt5cd4LZheePensF90ciFx1Ti1Yut5UR6PZmZf/+bMM83yHlmnQWK
	qIhyAErQh1VFkfT8BXBs7x5HKcBjwZvz3IRC0yqapxZfsBrs8JoXlo0FTEUiTRL/Sylbh2
	yud97GVd+MQxim8KlT7r2U3hZPdlQT4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=neaGU8o1;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780310902; a=rsa-sha256;
	cv=none;
	b=adjU9pYVEliN1LLM6tku18KTnWjZ1pbb58g6GYrRhIvzI4ogjfBs/PJ1SDeEDwpKDbBeTM
	JTgaulO4I/Cw1oELBfjFJesplkDSL+DU8cShk2pX+UTQuees4hdMrVyCfseQh5eJhmPN4J
	oBdhGiIZZQEAt58dW5GG/Ht3SvXciBs=
Message-ID: <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780310899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CpP3p+OZ5kTTKtnC7lknJ8SUiTBUDhdsLvtMvZmEm/4=;
	b=neaGU8o1iE3/4nTUTm1ddWoYsE2dfW3eX7wU62CONcntJ79HSV+NHfJSc9y6ThIun4wasJ
	BP4QDwazz2Xy7sFW7AuQhOUSjEUvavOzPE0+8qTglgU72VGjV5ffSvP3JWtwytKfZnfQwP
	88YxT/UrKu+ag27omxnIeveYLz889ok=
Date: Mon, 1 Jun 2026 18:47:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ifqdiig1sww1udwdbim3ukrefdi95ref
X-Rspamd-Queue-Id: DB0C620002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780310901-295199
X-HE-Meta: U2FsdGVkX1+7Qg7odMi38O3XTmYJaslP7DF8+mOrwwltPebgl4YkgtOi8ZBH9ljg2I7IYvSf1icsRlno+QAwynDF5qpdYhMc1PCoofY5sW6y9yEnErpDHE8V8AnknXGXs/GOSNax/9EcbjrqNf9ZjcPsXPgzOujaP5lawRmTifsVLXOB+Sx6NuiWvpi0uEBIpIBJv/Hug+p+fBOcBw85rUDYpcdvkb71u8riyRiuxzuiCfRUcZYjsHzkKw3zYfSQzJBnLmCSFoYe5i1QOq8NGX2+Fcxc6eofsKiT7FixwAUKIs5/2Q+iaEw3RvQmTsMMYZw9+lfzxPLgDvfxk1NW9zgArCOjAJBKj6pzFqeS+2WdfitI2dKQZrc2OxmIHL6M+8idM282ZRKSYDQFY6aWEDgpgmhTEvd8wCBiQxamGdyejbAXBOjazXjoQa3I+f2aZo+vFGZ68BSKC9j2sBG6VxjPveZVYEHgnhB9Ku1lbuSeqVgbWpAD2Ffp5NmBXSp6rEHDRNwN5X6xVVbM2TOnMoDqrK/rXIK5RtDhJ8wmRlP8IQuAOjHeToh7bPU2wVn+98btQ1mQ5PL2tKbpXL072StvD6j6MP828NoXJJZoQoU2mZ7oe5+4TJ+d5CauDoh7AzH3+F+r4/hpmO6V+UEocFtpT7LTEObpvateRR4emD5mby13LKhWov60Pce7XDp+6owoA7mZ/dhZssYxTqWLC7F+4sma3xoaLyKvVQqGbjCdfGTNlcxN60r4DmF+RR6aKmm1vaRRcdw+PkSGGrXBnJc7rlFuP/N4JAB503twCrReYlon2ho/lx7opVbhBK4TCegKY2Xtdx4T3i5hmEwV3E/ejIU9zembsyPxEHH4nzaBdIzMJ805y9guTF6n9LPnzkOrqsFtcSCz28Fhq2ve3+9G56buczO2yT2+cR8z/8UunY89d59Y7KQeFOllBtZhNZLwlVjhST+veBJ97jj
 2/Ev7B5b
 FWumortAJ5t1YoTizFqbTy6Rsvy6mhH90EydY87L6iRazcMtMUKtY4EeRqGEUl/ZkaB03SHpQhlteZ3ldifPYI9jLggUXEZ9HrrtiBFnP4y38UKaRDJD6vFqA82knMj8UphT/1OgqiTpt11CHcvPV4sXr9W6gtZLVLEn8SN385RDblZUebDkSq+BI/1ufHHd+ne8O/9896n/HpI0iZCF9/YR5446ju8ATkYUPiRpdVedn1ewU2x/yRRg2Xzr7XwzuUP+B3pJU0mDL/biY2nKjDs26YEF9Yz/VwxiOk9PH8xl4AqBw2xbLPmV3MhFD1WzQeSmepXPEQeaZ3fOFsqCb0TZjjA9UGrQNsq9OMKC3JQzZDPjjP2v7vPr6FY8nCrMoJd9X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
> On 6/1/26 11:08, Lance Yang wrote:
>>
>>
>> On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
>>> On 6/1/26 05:28, Lance Yang wrote:
>>>>
>>>>
>>>> Ah, fair point.
>>>>
>>>> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
>>>> than only using the pte pointer passed in. For example, mips does:
>>>
>>> Right, a re-walk would be the real problem.
>>>
>>>>
>>>>     update_mmu_cache_range()
>>>>       -> __update_tlb()
>>>>         -> pgd_offset(vma->vm_mm, address)
>>>>         -> pte_offset_map(...)
>>>>
>>>> and __update_tlb() has this assumption:
>>>>
>>>>          /*
>>>>           * update_mmu_cache() is called between pte_offset_map_lock()
>>>>           * and pte_unmap_unlock(), so we can assume that ptep is not
>>>>           * NULL here: and what should be done below if it were NULL?
>>>>           */
>>>>
>>>> So if khugepaged happens to run with current->active_mm == vma->vm_mm
>>>> here, could __update_tlb() hit the none PMD, get NULL from
>>>> pte_offset_map(), and then dereference it?
>>>
>>> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
>>> even spells that out. :(
>>>
>>> Do you know about other code like that, or is MIPS the only one doing a
>>> re-walk and crossing fingers?
>>>
>>>>
>>>> Just wanted to raise it since some arch code may still have assumptions
>>>> like this, and the always-enable-mTHP work is getting closer ...
>>>
>>> Right. I assume set_pte_at() couldn't trigger something similar (re-walk) in
>>> arch code,
>>> because we simply provide the ptep. update_mmu_cache_range() only consumes the
>>> pte.
>>>
>>>>
>>>> Probably very very very hard to hit, though :)
>>>
>>> Delaying update_mmu_cache_range() is nasty, as we'd have to make sure that
>>> nobody can interfere in the meantime ... and the PMD lock will not be sufficient.
>>>
>>> Maybe we could reinstall the page table with the cleared (none) entries while
>>> still holding the PTL?
>>>
>>> Thinking out loud:
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 5ba298d420b7..e39b750b1e6f 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(struct
>>> mm_struct *mm, unsigned long s
>>>                   map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>>>           } else {
>>>                   /*
>>> -                * set_ptes is called in map_anon_folio_pte_nopf with the
>>> -                * pmd_ptl lock still held; this is safe as the PMD is expected
>>> -                * to be none. The pmd entry is then repopulated below.
>>> +                * Re-insert the page table with the cleared entries, but
>>> +                * hold the PTL, such that no one can mess with the re-installed
>>> +                * page table until we updated the temporarily-cleared entries
>>> +                * through map_anon_folio_pte_nopf().
>>>                    */
>>> -               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /
>>> *uffd_wp=*/ false);
>>> -               smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
>>
>> One small thing, I think we should probably keep the smp_wmb(), and just
>> move it before the earlier pmd_populate().
>>
>> IIUC, the ordering we want is still:
>>
>>    clear old PTEs
>>    smp_wmb()
>>    pmd_populate()
>>
>> so another CPU cannot walk through the re-installed PMD and still observe
>> the old PTEs, right?
> 
> There is a smp_wmb() in __folio_mark_uptodate(), that should be sufficient?

Ah, cool! __folio_mark_uptodate() already does the job :P

So yeah, no extra smp_wmb() needed here!

Cheers, Lance


