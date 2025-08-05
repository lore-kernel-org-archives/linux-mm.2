Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B50C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CCA8E0002; Tue,  5 Aug 2025 06:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05018E0001; Tue,  5 Aug 2025 06:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B414B8E0002; Tue,  5 Aug 2025 06:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A87548E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:07:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FFEF1DAC1C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:07:12 +0000 (UTC)
X-FDA: 83742275904.30.CCE1189
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id B369114000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:07:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nfnaMosI;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754388430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ze3GOW3FYLRkT2szR3JOGlwVtUNL/sUjzyH2NQ1q7M=;
	b=PbgxwqA3XcuRCvwHcnNeySWBmiq/J+5ukis3E6F2nPaowlDAdVofX7A/FlRfiMOKSCTEUY
	nft7DnxL/gEuxq2eIMO/n5blsVi3Vh00N2XeBjBjHDy6DmOUEXaSMd7W+ttZyZsqTQJdlW
	LqWS2wnvwAHfS23DtQ2FmJybat05qsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754388430; a=rsa-sha256;
	cv=none;
	b=AHYLHUDhFcJdxifQQ/Wty505xl+t9Y854lj+8reIb8OFbPUFGAVqBAODw+AdveFVimNSfr
	DxitcuctoNpzlNDSmii03ouvgL89uQOYzPLK3VON6AA/EPB+cDqx/eE1vX+PM5oRr/s+XN
	NP2EjiXpF+KunK/IO6Kdo9JmmPlqPIE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nfnaMosI;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754388425; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7Ze3GOW3FYLRkT2szR3JOGlwVtUNL/sUjzyH2NQ1q7M=;
	b=nfnaMosInG3VsvidKsft+1ZtqQVouK3mqFED6Env3cetAain5TdpzJ0Opnjz/KqS2TBCACokxFG4u6J1mVuBKF+s7O3kj07MF9f99fQme1vc7XqcsHAt9Rw/uwWdO0IumQItmlLM7xUp+nsPIlqVkJZL2cYOBGkL0BstdWDNIa8=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wl4v-.X_1754388423 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 18:07:04 +0800
Message-ID: <46f0b251-237c-421d-aec0-adff6c2e1bb4@linux.alibaba.com>
Date: Tue, 5 Aug 2025 18:07:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: David Hildenbrand <david@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Barry Song <21cnbao@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 Lance Yang <ioworker0@gmail.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
 <35417160-86bf-4580-8ae9-5cadd4f6401d@bytedance.com>
 <d73213ba-5ca0-451c-b82b-f590d10da6d7@linux.alibaba.com>
 <b594a315-8458-439c-b535-fc7f052a3fae@bytedance.com>
 <c6f9dacf-d520-4cc3-88ac-c5937916aa2c@linux.alibaba.com>
 <064cca31-442d-4847-b353-26dc5fd0603c@bytedance.com>
 <5ac2ec58-3908-4d0e-a29b-8b4d776410e3@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5ac2ec58-3908-4d0e-a29b-8b4d776410e3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B369114000C
X-Stat-Signature: satsjmsrrk6kq9817u6uzuh9ohrpxf47
X-Rspam-User: 
X-HE-Tag: 1754388428-347741
X-HE-Meta: U2FsdGVkX1/8EOV8KGsUdafRSxJKh0k1LSbtdwA5sk6uZhUE93H6lN+fvnRRtEIqeFxw69qt0oJZew1HvkTRBvK0Vb5Wul+Kb/HeNQmc2yt8HRl78OdVWkX1KLttCyVqL0PTzv1jhYlxBex9/F2TZusNg0wpzlzDBalLwA1waXUU9xGbDQ2TKev+amck9pGw4c5noGuaXQWpYA03HySASH8M8Zn1TZuOLNv71rmZsJey8UDG/deQAvl6WFGBO50u3BroiWuh+yaxmg9Zjk70o7kztvjXQ/nu70F2V3WlS/jZSyijqppB6BpyK1QO9vPQvBtSeVlh5DmP6BWv3xJjZGSdDO8c6Y0Iyife4VNsEMDvlOITgnFvdz0vzzR9Bt3RbFZ1Ha+2oCFQMbLmXETfTDqRsRU7TnbrtPD8JSo8gRYLxCZ5Xyg8gPHKbwiaA3tFbH6ZHthFgeAd949NwN7M1PmqyIfhERU7RGZ1lCLjHsOGiqN0wyTdEVuYVb5GRbR8RNRhiHBROm4fNV8+w9IV+wGGRKoJeibrIm5w3srYPqgijXnMxoOYRG1yvq9MYqdfaPhykZfgY8zZA7uAqqm3/XXPMogF1iL3pWPrOCQ6S+A3UY2SuYnNIgGG7H9PS3hwA6nHtk2Q47+M2pxpYaNpzvtwaKQbmaTtKl6hZOvRKpI1X5HZM39WnziVHPiwZolXDuPHcJDmrp/7DE14TPeTXJ7oRH0qes7NQaD9WgGGjRsT4kwSvdhjMP1csU/Ws5TJ3+Auag7SZr/xQ3pxY3nde1jdVyrjRkUtgQbnUr9yOHy846PBpZpMT27xlOtE+XSQ8gRN9oygNbholTFHT/gZ7Mbcjj60QyEBp5z+ChkWJwpoxOvodPAY2oUaerfiI3y0/z2yGWr7GRTE0ffbDYhwcd/th+fPHwXYFgKQqye/39Y0dW/rjp/agt0JRVSahKR67CbiST2uLp0QEZoYBei
 hYO2LwNG
 +i/58rDjRZ3kSXomYm4LpZPUu4mtQnsb85AYk6rI1QsZZnNuUbsJzt0Bcnjn/TF2DIDaJ/SlHrE7aulWtCzJ5QCrL6ktLy1rl0P4auJ4DJeN3GgNoRZ/TwIKq8y6LVK7f05LDAVJmqWCAgEyZaX4GXIL8o9y/zwWyHo0zpZOUeB3IWDbcR51hG6soUrGS/QARFc7vIFsoAuRQhmRTXVw6BwhBo+t9lmM6qYrVC/CcaSMc6ZyFegHWsxaXVpXSWX8NWeij63LpKIzumNVaWiV5meYL699ZFSJFuSlxHO0FuYomgsi1GvRpcAFM3bTS97X6lz3NAlgedp1WoD0M5EPChoVaw1dEnC28aQFHkDnhRsJf9SFgG7vo/mVSQDuhnVRj4729XCATu8NCXjYC/kZrpqm3MzXJReGDdVh1nfcMTF5RbGhtmVxoLyFuwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/5 17:50, David Hildenbrand wrote:
> On 05.08.25 11:30, Qi Zheng wrote:
>>
>>
>> On 8/5/25 4:56 PM, Baolin Wang wrote:
>>>
>>>
>>> On 2025/8/5 16:17, Qi Zheng wrote:
>>>> Hi Baolin,
>>>>
>>>> On 8/5/25 3:53 PM, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 2025/8/5 14:42, Qi Zheng wrote:
>>>>>> Hi Barry,
>>>>>>
>>>>>> On 8/5/25 11:54 AM, Barry Song wrote:
>>>>>>> From: Barry Song <v-songbaohua@oppo.com>
>>>>>>>
>>>>>>> The check_pmd_still_valid() call during collapse is currently only
>>>>>>> protected by the mmap_lock in write mode, which was sufficient when
>>>>>>> pt_reclaim always ran under mmap_lock in read mode. However, since
>>>>>>> madvise_dontneed can now execute under a per-VMA lock, this 
>>>>>>> assumption
>>>>>>> is no longer valid. As a result, a race condition can occur between
>>>>>>> collapse and PT_RECLAIM, potentially leading to a kernel panic.
>>>>>>
>>>>>> There is indeed a race condition here. And after applying this 
>>>>>> patch, I
>>>>>> can no longer reproduce the problem locally (I was able to 
>>>>>> reproduce it
>>>>>> stably locally last night).
>>>>>>
>>>>>> But I still can't figure out how this race condtion causes the
>>>>>> following panic:
>>>>>>
>>>>>> exit_mmap
>>>>>> --> mmap_read_lock()
>>>>>>       unmap_vmas()
>>>>>>       --> pte_offset_map_lock
>>>>>>           --> rcu_read_lock()
>>>>>>               check if the pmd entry is a PTE page
>>>>>>               ptl = pte_lockptr(mm, &pmdval)  <-- ptl is NULL
>>>>>>               spin_lock(ptl)                  <-- PANIC!!
>>>>>>
>>>>>> If this PTE page is freed by pt_reclaim (via RCU), then the ptl can
>>>>>> not be NULL.
>>>>>>
>>>>>> The collapse holds mmap write lock, so it is impossible to be
>>>>>> concurrent
>>>>>> with exit_mmap().
>>>>>>
>>>>>> Confusing. :(
>>>>>
>>>>> IIUC, the issue is not caused by the concurrency between exit_mmap
>>>>> and collapse, but rather by the concurrency between pt_reclaim and
>>>>> collapse.
>>>>>
>>>>> Before this patch, khugepaged might incorrectly restore a PTE
>>>>> pagetable that had already been freed.
>>>>>
>>>>> pt_reclaim has cleared the pmd entry and freed the PTE page table.
>>>>> However, due to the race condition, check_pmd_still_valid() still
>>>>> passes and continues to attempt the collapse:
>>>>>
>>>>> _pmd = pmdp_collapse_flush(vma, address, pmd); ---> returns a none
>>>>> pmd entry (the original pmd entry has been cleared)
>>>>>
>>>>> pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); ---> returns
>>>>> pte == NULL
>>>>>
>>>>> Then khugepaged will restore the old PTE pagetable with an invalid
>>>>> pmd entry:
>>>>>
>>>>> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>>>>
>>>>> So when the process exits and trys to free the mapping of the
>>>>> process, traversing the invalid pmd table will lead to a crash.
>>>>
>>>> CPU0                         CPU1
>>>> ====                         ====
>>>>
>>>> collapse
>>>> --> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>>>       mmap_write_unlock
>>>>                                exit_mmap
>>>>                                --> hold mmap lock
>>>>                                    __pte_offset_map_lock
>>>>                                    --> pte = __pte_offset_map(pmd,
>>>> addr, &pmdval);
>>>>                                        if (unlikely(!pte))
>>>>                                            return pte;   <-- will 
>>>> return
>>>
>>> __pte_offset_map() might not return NULL? Because the 'pmd_populate(mm,
>>> pmd, pmd_pgtable(_pmd))' could populate a valid page (although the
>>> '_pmd' entry is NONE), but it is not the original pagetable page.
>>
>> CPU0                          CPU1
>> ====                          ====
>>
>> collapse
>> --> check_pmd_still_valid
>>                                 vma read lock
>>                                 pt_reclaim clear the pmd entry and will
>> free the PTE page (via RCU)
>>                                 vma read unlock
>>
>>       vma write lock
>>       _pmd = pmdp_collapse_flush(vma, address, pmd) <-- pmd_none(_pmd)
>>       pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); <-- pte is
>> NULL
>>       pmd_populate(mm, pmd, pmd_pgtable(_pmd)); <-- populate a valid 
>> page?
>>       vma write unlock
>>
>> The above is the concurrent scenario you mentioned, right?

Yes.

>>
>> What types of this 'valid page' could be? If __pte_offset_map() returns
>> non-NULL, then it is a PTE page. Even if it is not the original one, it
>> should not cause panic. Did I miss some key information? :(

Sorry for not being clear. Let me try again.

In the race condition described above, the '_pmd' value is NONE, meaning 
that when restoring the pmd entry with ‘pmd_populate(mm, pmd, 
pmd_pgtable(_pmd))’, the 'pmd_pgtable(_pmd)' can return a struct page 
corresponding to pfn == 0 (cause the '_pmd' is NONE) to populate the pmd 
entry. Clearly, this pfn == 0 page is not a pagetable page, meaning the 
corresponding ptl lock of this page is not initialized.

Additionally, from the boot dmesg, I can see that the BIOS reports an 
address range with pfn == 0, indicating that there is a struct page 
initialized for pfn == 0 (possibly a reserved page):

[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] 
reserved

Of course, this is my theoretical analysis from the code perspective. If 
there are other race conditions, I would be very surprised:)

> Wasn't the original issue all about a NULL-pointer de-reference while 
> *locking*?

Yes.

> Note that in that kernel config [1] we have CONFIG_DEBUG_SPINLOCK=y, so 
> likely we will have ALLOC_SPLIT_PTLOCKS set.
> 
> [1] https://github.com/laifryiee/syzkaller_logs/blob/ 
> main/250803_193026___pte_offset_map_lock/.config
> 

