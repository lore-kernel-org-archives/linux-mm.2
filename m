Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FDAC88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF13D6B008C; Sun, 13 Sep 2026 23:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9576B0095; Sun, 13 Sep 2026 23:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF3E6B0096; Sun, 13 Sep 2026 23:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64C176B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:09:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93C7240A41
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:09:39 +0000 (UTC)
X-FDA: 85210887678.02.DFF502D
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf07.hostedemail.com (Postfix) with ESMTP id 81F1F40007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:09:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VtA423Yi;
	spf=pass (imf07.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789355377;
	b=vZiSEtqoYzboLiijEHq/4aNuIR6osjYyL11YoZ7HNnPOI+DuWqoOYOz0/uvrAWWHxLXOxi
	APQ1F5Z8cmNhffq+O1RNYDWpDT1agU9ItKSVy6hEpvRMdFVWJZO29qp7NRnubeC189a2BE
	nK2VKjH/pXv9tFd5nwlLfPBhXILHxok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VtA423Yi;
	spf=pass (imf07.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789355377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9N6gaJR2vJOsZjjclQfE1bobd9p7/9wtxiewg0sEGo=;
	b=4VxrcuC94yKH+VP9EHaP5B4r8KiwlLSNVfkHNl7Z5ghHeuHP9l3o9OgPdXE1B3v6hFehIe
	MleEJQxg6dG5xXysq8+RM2OMdfmhvGR5WVQpQkWk6nZhJDM5Q6ns80USLLr4ipMnyxZN/y
	RdbrfWsTfQ+amEwUaGUXqnHmRaaPwxQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y9N6gaJR2vJOsZjjclQfE1bobd9p7/9wtxiewg0sEGo=;
	b=VtA423YikAc4SOwGutUyAa1ayWYYa1oG7HNN1zslMabwEZ7nNrirH4xNz64wP77MS6qVF2wu5
	GWVERnST/Zs9hTbqnWC0hCl9v0X9pUjudQID4Ga863RQKzFPIlTR264e+81NUdEooIKQzy+lEbv
	UmeGd7qjrnyyHMuR5M27C2c=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hjqbX22SKzKm6j;
	Mon, 14 Sep 2026 10:58:32 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 36B8A40578;
	Mon, 14 Sep 2026 11:09:33 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 14 Sep
 2026 11:09:32 +0800
Message-ID: <fd88104a-982a-4c73-9a5f-8c67ded3d5ca@huawei.com>
Date: Mon, 14 Sep 2026 11:09:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm/ksm: use per-VMA locking for find_mergeable_vma()
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<liam@infradead.org>, <surenb@google.com>, <rppt@kernel.org>,
	<ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<chengming.zhou@linux.dev>, <usama.arif@linux.dev>, <gourry@gourry.net>,
	<harry@kernel.org>, <vbabka@kernel.org>, <peterz@infradead.org>,
	<borntraeger@linux.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
 <a19a0c1d-d2bf-4c40-9308-e815f925f87a@huawei.com>
In-Reply-To: <a19a0c1d-d2bf-4c40-9308-e815f925f87a@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81F1F40007
X-Stat-Signature: xrmjeyxkkmxddnxfhua4thk9ipm1jj17
X-Rspam-User: 
X-HE-Tag: 1789355376-800141
X-HE-Meta: U2FsdGVkX1+RoQNbj8x3Ui4fqJPzDH3avY4W5ypaNrRUHwFqzNTZu2ekOL0zzaALfNtqrPQ3cfQ+4l4J2+uLs2pSxaAH8YmiAeGxbZufjHcurJsTJqFXhWvB8wTvauKpTtqgbbi5iF964LNvmVMqGNQcsLEHB7rOx5Yv31C5p9gQ2DptqhqWSnq7inX3l4PgGbd1POqNII4UnmwmLb5oGrWAIjvQq0IToSztpmYt231mH2SUYfovW+cy0LvEtAIyiDvHkQj9MeMe7czoraVSVHkpqw22FMU6TzPCWyFSmZX0iCQOaLVupZrN2tkZs0sggxHT8JmClJOwcl/SxDMG0hn5HpmCkpDwMbPD7KTL5q/rArv1N1jzbU1E19s+CAaDtvEnpB2HSUSFyKm/guH7UGOdyVJ/5YFG8t5qLOH2i4vLwj9hKjcEXKbIR+rH7y43zXv1omcAOOx8MV5WooO797pEZw1i/c3emJ2ZymnnY82rSAzl8n2jE6jJShzaBSp3psxq2lAOLyEXTTYCpx8uj1bn2JVWLmf5SvEGEgfG4GJ0mJ82bTzpp5US5oQqYDI17+8KovrpXEd6ECCG/8yGU9Si00/nKGyB9nvpyqkuMMaWucPWMfNtaRmPtWMyCNSx8ExkLVOvObxozd7YohouUI8q53zlZNmCOZOy9wkSW4Pbr5yDzK7dpb9ImzVp0oxrJDScxiuYqCZK7adsDCgLAV62RkkgyJ1NJWG9siNY1lu/Cvxkq0sKqg9DeIiLCUeX9I7UeDPSsAxNL3oj+UbF2r8pSyokLSiGChM1DvKx0veHCMUEflA0rOvclzJfwK1thSmQm2/75LAF4Kf9rkBMKwM0aB5AquYrXCNNLUfH2Nn/5bDXQ9uaciRnz/CzfJ2r8eV7ffQGQpIKJqeV9SXnsnkLJYSEb0fYrckHkLMOHY9pbZA14fodDKs3v+kVdrOqlT7kJTd0b+3ToMOMZ1l
 bRQdOZpc
 bGvRFEMGnPFZZLr0KiZGr6kqhNa5zV74Ok/KH1SWLv6UuDUkYUu6qDxx4Ig+P54UJUmdD+60NyrqzBmeXsdmorF2F/HL7OFMYQJpU+cY4B6daT+Ei4mrhRbHvBGlSpXScOp4t5RNGfqZajpWFvvbOSf7Z+MvhsDHSCNNv2YkrhckVokw9M93YOZY28W0mwa5N4dWKmkQAH7SpTFmYvQEaaQTi3+p2qOTk4YEEopD8GrU1sF/lJHKiI/gxgH3M7YFONWuXfe17TJcnJY7PZB2j5z0DVoN4mwZZRfOdKBH6+9JX9qMNKlXZSeqLl3SfT2I/RY6Vz14FpBPD/HKC2KmuZoGUz2DVOmlt2u3khoIpOZFlxImwvBgOILmo1P+GeZdyFnVXF6a2YFael6wAXE//OQjng0tmtawOH0at22NGjBMicLWtSOwfHtvybUboTcYFTASG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/14 11:03, Jinjiang Tu 写道:
>
> 在 2026/9/13 12:17, xu.xin16@zte.com.cn 写道:
>>>>     Patch 1 removes an unused 'vma' member from struct folio_walk.  
>>>> It has
>>>>     never been used since its introduction and is pure cleanup.
>>>>
>>>>     Patch 2 adds a 'walk_lock' member to struct folio_walk and extends
>>>>     folio_walk_start() to assert the required locking mode. Existing
>>>>     callers are converted to pass PGWALK_RDLOCK, so there is no 
>>>> functional
>>>>     change.  This prepares folio_walk_start() for callers that hold a
>>>>     per-VMA read lock instead of mmap_read_lock(), which is needed 
>>>> by the
>>>>     Patch 4. No functional change.
>>>>
>>>>     Patch 3 tranforms the boolean 'lock_vma' into the enum 
>>>> 'page_walk_lock'
>>>>     without any behavior changed, which is prepared for the Patch 4 
>>>> to use
>>>>     per-VMA locking. No functional change.
>>>>
>>>>     Patch 4 introduces find_mergeable_vma_locked(), which uses the
>>>>     universal per-VMA locking helper vma_start_read_unlocked() to 
>>>> look up
>>>>     and read-lock a VM_MERGEABLE VMA without taking 
>>>> mmap_read_lock().  All
>>>>     KSM call sites that previously used find_mergeable_vma() under
>>>>     mmap_read_lock() are converted to the new helper, and the 
>>>> locking in
>>>>     get_mergeable_page() is switched to PGWALK_VMA_RDLOCK_VERIFY so 
>>>> that
>>>>     folio_walk_start() can verify the per-VMA lock is held.
>>>>
>>>> A microbenchmark was run to measure the time KSM takes to merge a
>>>> victim region under mmap_lock contention. Under interference from 4 
>>>> churner
>>>> threads, the merge time of the per-VMA KSM-optimized kernel is
>>>> significantly reduced by 50%.
>>> Hi.
>>>
>>> During task exiting, __ksm_exit() uses mmap_write_lock() to 
>>> synchronize with ksmd.
>>> see the comment of ksm_test_exit().
>>>
>>> void __ksm_exit(struct mm_struct *mm)
>>> {
>>>     ...
>>>
>>>     if (easy_to_free) {
>>>         mm_slot_free(mm_slot_cache, mm_slot);
>>>         mm_flags_clear(MMF_VM_MERGE_ANY, mm);
>>>         mm_flags_clear(MMF_VM_MERGEABLE, mm);
>>>         mmdrop(mm);
>>>     } else if (mm_slot) {
>>>         mmap_write_lock(mm);
>>>         mmap_write_unlock(mm);
>>>     }
>>>
>>> }
>>>
>>> When ksmd currently is scanning the exiting mm, we should guarantee 
>>> the mm pagetable
>>> still valid (i.e., mm_users > 0). However, ksm_mm_slot only holds 
>>> mm_count, which only
>>> guarantees the mm_strcut isn't freed. So, __ksm_exit() uses mmap 
>>> write lock to synchronize
>>> with ksmd.
>>>
>>> IIUC, vma_read_lock cannot be exclusive with mmap_write_lock().
>>>
>> Nice catch. Thanks for pointing this out. Indeed, the original 
>> exclusion between
>> __ksm_exit() and ksmd relied on mmap_write_lock() blocking 
>> mmap_read_lock(),
>> and per-VMA read locks do not provide that exclusion.
>>
>> A possible approach to restore the necessary guarantee is to pin 
>> mm_users while
>> ksmd is walking the page tables:
>>
>> Before scanning a given mm, try to take a reference with 
>> mmget_not_zero(mm).
>> If it fails, the mm is exiting, so we skip it.
>>
>> Hold that reference for the entire duration of scanning that mm (not 
>> per-VMA),
>> and drop it with mmput() when done.
>>
>> On the fallback path where we need to acquire mmap_read_lock(), drop 
>> the mm_users
>> reference before waiting, to avoid delaying an exiting mm.
>
> We should avoid holding mm_users ref too long. Otherwise, when the 
> task being scanned
> by ksmd is OOM-skilled, even though the victim task has responsed 
> SIGKILL signal and
> exited, the mmaps aren't released due to mm_user > 0.

In this case, we have to relying on OOM reaper to work. But it need to wait OOM_REAPER_DELAY
(2s) to response.

>
> We should check whether the mm_user has dropped to 1 during scanning, 
> like what
> ksm_test_exit() has done.
>
>>
>> This directly guarantees that mm_users > 0 while ksmd is accessing 
>> the page tables,
>> so __mmput() cannot reach exit_mmap() and free them. It is more 
>> precise than the
>> old mmap_write_lock() synchronization and should not introduce 
>> noticeable delay,
>> since the reference is only held for the scan duration.

