Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32DAC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 08:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EED76B009B; Tue,  5 Aug 2025 04:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F9E6B009F; Tue,  5 Aug 2025 04:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5866B00A0; Tue,  5 Aug 2025 04:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF5626B009B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:56:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAEFB14011B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:56:32 +0000 (UTC)
X-FDA: 83742097824.25.5022B7C
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7560E40008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:56:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AdHKDmDH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754384191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NBVVAA2DuTVhMuc2zncIDms1+52a6Ct/b9XmMxwvBQ=;
	b=eoO6BsHRLgaVp1Z1H5b99OKkOklOqKDtvhL6Hmj1PbUNmR9f+6FmaYht4dAyXnt38l6YyI
	rTRVDW4WbT9p1C8XrGK8sjOmLxCWtYUvXLGAWJvlmKaT5Zdolqt3FNcxjznSyNg2sQnXZE
	yRg7PdsqY3aEBzg9BfUiHD2x0iTepK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754384191; a=rsa-sha256;
	cv=none;
	b=acyYGNKJ5u8ABmNN2KDOGIalR7i9sXJBxVBVh/QfefleSbJ0UUQ8u5+ycWKdFiSEY5WSgE
	Y/Hu9SoHX+7jV+iN7qjurJwzt23/6+t0JaWFE3O+ULHuHZclwCg8xAafCnRGN3qWjBWF9R
	lARI8Fyi7bNfAB4f4CSXVPo2kwuul7s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AdHKDmDH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754384185; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2NBVVAA2DuTVhMuc2zncIDms1+52a6Ct/b9XmMxwvBQ=;
	b=AdHKDmDH9gYhSk9PV47/+9PYkuvl2CEtk+PKCp4rNqhQJQG8gE6Mj3mY7kiICsvE5HJflYP8MyZ49BMVclmn7PiVu7p0JnAXgFEE1bs0DBCJuc0U66gCfphOQXYF1ymMTEoACmysS0ifpH/AuV27ODr/kOTO9pvagyi+594zPDg=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wl4cIP7_1754384182 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 16:56:23 +0800
Message-ID: <c6f9dacf-d520-4cc3-88ac-c5937916aa2c@linux.alibaba.com>
Date: Tue, 5 Aug 2025 16:56:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Qi Zheng <zhengqi.arch@bytedance.com>, Barry Song <21cnbao@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>, David Hildenbrand <david@redhat.com>,
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <b594a315-8458-439c-b535-fc7f052a3fae@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r8ifdgsykw9bmngp3tptso7xohqzazt5
X-Rspamd-Queue-Id: 7560E40008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754384189-609005
X-HE-Meta: U2FsdGVkX18ajD6bwF4UGulRh0r6qJnBgKax4BS7Vg6MdgfkQJ4lgj44jDP9rKlO2zB8CQRvXtHZcxvn5hPzeLfvjUzQRlNE46SeW62uERliZhb3KOCMcB9wwDlSw8mh8/DsuKWx7Qzs7zNew34W41cIHyehrXPe5ulaeKaa9eXj8LGX07UWcvTFip3SHUgCx7gM/BoTSKkvvDxtP0p7aFfw7iM/Ou1HdgV+4HiI8LFEQ06Jb7cCePbi1+ftW0HMrAaPZ6GwmWp6yNSTZmsR3Bmc1138rWfBlM/a6/SKlsCJ/YH1E54/MFkP6KHMobfUBB3sGnl+ewBdG41AE6b2LTUL/3JLmh+sBY4GYJeb0hMtt0EKDsd7v7nNk7zixvFCmASJ0s+yenzbStYNopWoC8iFe3sMg3R4/7IRvT/Epd3xq2quHxpbcx7YkGnuuQnGznt4Uh7F/KOPPuzJlA29TooeDTkOBwUWNcwu45NnSC0YkVPf9lgeRJ7t2Dgsi5ssWgp1n3Zu5Wwc+7M5cmEHsujDfECeK0aazDgSyWrF6f1f7ZFIKQS63HwTCBUFO+pyiEe6vLEr5knYShcvHcipHjLmgYHlRVcZH0RHl328jBPvu56HaNpgIHUEodW4xWG5qs8mX9eXYtRLGXcVSbdYSSbEbBa5/Y+Wv9l6PUQ7YsRqxD21oOLqUHPMeTs8OMwVQrYoDW/S6QB2wkbm8a+nN/Yl1TLcUH41Kv989vsoJTh7ebxF57GZXz+Vx5KNBxpDHZ5CXLbCOwv4Pp8rURDfPJVMPejflse9ufX81XPln0svT7WtsPkRTOhtcvti+/vEcsnXmpdq4gtCxi/ZkokXtf3aYIYh39mF+GSzPlcAOKYXRs5FYdDIL3VayTPfWhb5XOohKSNbJUbYvfQnZaRKgu1aeW+41001US7FLX1TnLz1Ya4k7coRfS0v79TZqwyw8RKqyKanNfKPhvPM+xc
 9YNFt/yk
 f6bvXlNxyOgIBSqhN1lTo6YsKGOKyoST0iLbEhRx6ry4hei/xufE7dBXHFWvTtUX6W1W5DsZ2rqivv3VndAiAs+phtEbmdJWFNWon6oaLI62VuJcgnytIOrgTrjA+ceVbS0M6yUqQq82IK/0XmLjufvz7sQrZm3Qn2I6NnzDr6Eevy2rStdKPKUQXaGC2GVpZohhQJCNI+lgExpxIg2cvjpH31alcTfqt6Uj1OAsJ/FCvlRWSR49Ux7inCcinc/Sqczhv9Fb5AR6kGwGFhy9kMFJFYjK7sjiKykhoK6OPki4kFxo6/KPjRcGhh0uV57Hj3+Ca7aJW8wfP20JitBkqIfnCYM6NO3vFnUxGmlGMTgczTmKdypG2UP9NItg6wE/KtEdMh9AdLvyL6JQeSHDEtmQtbFrj7EhknlqASp0VIijnGvFX5zdO++UkQrH5NfCEKaA3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/5 16:17, Qi Zheng wrote:
> Hi Baolin,
> 
> On 8/5/25 3:53 PM, Baolin Wang wrote:
>>
>>
>> On 2025/8/5 14:42, Qi Zheng wrote:
>>> Hi Barry,
>>>
>>> On 8/5/25 11:54 AM, Barry Song wrote:
>>>> From: Barry Song <v-songbaohua@oppo.com>
>>>>
>>>> The check_pmd_still_valid() call during collapse is currently only
>>>> protected by the mmap_lock in write mode, which was sufficient when
>>>> pt_reclaim always ran under mmap_lock in read mode. However, since
>>>> madvise_dontneed can now execute under a per-VMA lock, this assumption
>>>> is no longer valid. As a result, a race condition can occur between
>>>> collapse and PT_RECLAIM, potentially leading to a kernel panic.
>>>
>>> There is indeed a race condition here. And after applying this patch, I
>>> can no longer reproduce the problem locally (I was able to reproduce it
>>> stably locally last night).
>>>
>>> But I still can't figure out how this race condtion causes the
>>> following panic:
>>>
>>> exit_mmap
>>> --> mmap_read_lock()
>>>      unmap_vmas()
>>>      --> pte_offset_map_lock
>>>          --> rcu_read_lock()
>>>              check if the pmd entry is a PTE page
>>>              ptl = pte_lockptr(mm, &pmdval)  <-- ptl is NULL
>>>              spin_lock(ptl)                  <-- PANIC!!
>>>
>>> If this PTE page is freed by pt_reclaim (via RCU), then the ptl can 
>>> not be NULL.
>>>
>>> The collapse holds mmap write lock, so it is impossible to be concurrent
>>> with exit_mmap().
>>>
>>> Confusing. :(
>>
>> IIUC, the issue is not caused by the concurrency between exit_mmap and 
>> collapse, but rather by the concurrency between pt_reclaim and collapse.
>>
>> Before this patch, khugepaged might incorrectly restore a PTE 
>> pagetable that had already been freed.
>>
>> pt_reclaim has cleared the pmd entry and freed the PTE page table. 
>> However, due to the race condition, check_pmd_still_valid() still 
>> passes and continues to attempt the collapse:
>>
>> _pmd = pmdp_collapse_flush(vma, address, pmd); ---> returns a none pmd 
>> entry (the original pmd entry has been cleared)
>>
>> pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); ---> returns 
>> pte == NULL
>>
>> Then khugepaged will restore the old PTE pagetable with an invalid pmd 
>> entry:
>>
>> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>
>> So when the process exits and trys to free the mapping of the process, 
>> traversing the invalid pmd table will lead to a crash.
> 
> CPU0                         CPU1
> ====                         ====
> 
> collapse
> --> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>      mmap_write_unlock
>                               exit_mmap
>                               --> hold mmap lock
>                                   __pte_offset_map_lock
>                                   --> pte = __pte_offset_map(pmd, addr, 
> &pmdval);
>                                       if (unlikely(!pte))
>                                           return pte;   <-- will return

__pte_offset_map() might not return NULL? Because the 'pmd_populate(mm, 
pmd, pmd_pgtable(_pmd))' could populate a valid page (although the 
'_pmd' entry is NONE), but it is not the original pagetable page.

> IIUC, in this case, if we get an invalid pmd entry, we will retrun
> directly instead of causing a crash?
> 
>>
>> Barry, please correct me if I have misunderstood something.
>>
> 


