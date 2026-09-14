Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB796C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC756B0092; Sun, 13 Sep 2026 23:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566A66B0093; Sun, 13 Sep 2026 23:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F026B0095; Sun, 13 Sep 2026 23:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0225D6B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:04:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E41B7120F00
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:04:06 +0000 (UTC)
X-FDA: 85210873692.18.46C60BC
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf01.hostedemail.com (Postfix) with ESMTP id 752004000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:04:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AWQVK5l2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AWQVK5l2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789355045;
	b=PNUyY5PoxYzlsqJabJ5cTvL17EdxYxQsqb3YNlw5hrF6pWkj9VF1o44d+yIBbc6r/Ub8eG
	cqj/le7OBUgKDBq8ljvJ4yodUSVUr1icKfiNkzEC/B0YLdixkvT8DOzEE35TjxnR/ouXgU
	xVM0m5mf/zfKI1vDibCkvgpMqWmUC1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789355045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbEkjRvDTT9Ap9hbZxOwJdBfJpMC1NbhJsmL6dREPI0=;
	b=bIf0XH0xMAGBmHSSuEa4doDekEdWyvpBcsuLEV8MyqunkpE+I/zy1SeOcvqDLRGElsnbh2
	8Ffr1NVngciXJNtokuyuC3mZeNVnzSgwOakHSVujJi4idpOe1DVVvvtHQOuAxXTyTp3htC
	py90Rg7+X88TmD9N3JmTEuiyqNLLXWk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QbEkjRvDTT9Ap9hbZxOwJdBfJpMC1NbhJsmL6dREPI0=;
	b=AWQVK5l2K6Dpg0gktWDL2TJvnP5Ac0hQYTpF5TUw9YTxGcbFv2O2SvIIxShFtx6UWLkKTYsAa
	+V/nj3qjjhqxQP4g3ap+H+yDLiMZhmRWiOeUgGhcWOG8NgkRXke+5Io8BC0dB9ayefXkhG/rV1G
	tIkK3g5vXP6BxnAuPXq1OWk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hjqSM4PQQz1T4JM;
	Mon, 14 Sep 2026 10:52:19 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id D9B3040537;
	Mon, 14 Sep 2026 11:03:57 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 14 Sep
 2026 11:03:56 +0800
Message-ID: <a19a0c1d-d2bf-4c40-9308-e815f925f87a@huawei.com>
Date: Mon, 14 Sep 2026 11:03:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm/ksm: use per-VMA locking for find_mergeable_vma()
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<liam@infradead.org>, <surenb@google.com>, <rppt@kernel.org>,
	<ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<chengming.zhou@linux.dev>, <usama.arif@linux.dev>, <gourry@gourry.net>,
	<harry@kernel.org>, <vbabka@kernel.org>, <peterz@infradead.org>,
	<borntraeger@linux.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 752004000B
X-Stat-Signature: 5xesotp14mxy4cnzh8qayko879dqax7c
X-Rspamd-Server: rspam01
X-HE-Tag: 1789355043-272449
X-HE-Meta: U2FsdGVkX1+N2p/gdceBnmdx3IGHGCcv6mcBcqnSTg+6JE/HmMPHBTOsgYefZuPR3U7IyEid8rpYevTjWwzOey+Mn4dHJeBXTxPEbKlrZoWxFRUKE4uUhcJ4dawAyDM03TisuFyxKyN9GjIhWRcH6IfYPs6Q1gNnoyxnzwzJWKgwk//jKlOrA75ssFa329k2RK8tJRzpiQ/OdUyGuy52Jshi5BcH/PzPYjtRM3Hd+1SJNTzBfOrV8Wqp9kenW3XJDxiA5kquLEs3+Tg1lMF5bEEkMVnXnab/oq0AE8SdAMFurl+Lv1yukQRV7YcwMfbYqSUquWryPiqNI687sUaXFMDL59HyG9dQhSIRcCZKrnZSPe1yZiMtL1OSFfnwqi3/g2nic6E2diNOGqm29fKnX2tfoWhIhvLWPOVYFzsNvHC8Ltt+GBTAuvzEo7l/ibjT7a3BzR32l5xUVNy4P8LmbcDPbE++N4k3GT6xSIidsdbkIj9ldIruPI78IDXxwIgQFqp09ozyObdNrq+WTAHoQ2N3er1t2XSxSBVRb1vPIxh6K6dfXPGDNnG3OKVhWaWB3xVfXRTca/KcDOJrY1OPwUJ6jtIssSOPDTlrzlqZAHr/oV546CO1IIqifd67aWXatfzJgmsIwUOsjuOsza+2LUPBn2CESGCJoqaDrtDxd+G1v4Fk01yeE0qedt6oyhjt7YP1yF4VYIt9RPyBpNV8G5Yn2ZNX7WBzZbM7NwtDRn0iZsuIv4mVl25SpPrSiDymlRTjLmeGvFcNjY++vVpojXH3UWjTxkJhcL6TK89P2JGhj2Tn8WH8KK2AT4v2CrDrTsfgj1EvKvQaZ16oi9Z3oWV5KzFP7wWZ44etflaX8RMTF1WuNyGKrI5AElouADPQ0bB1OYbmhE5LzYmLCS2vP4vkJFxp9BC2MagUPa79Ak5hqAHYDwtirRTw9R0zRBPqJr6VvBk2ZMaJi1xz62q
 Un24NUpN
 mrxI3PihULnumwVksM1BuXN54P8ULvfXiq+6VyyB2jJ/BiogcjiWtONMMC2B0iMWftMHheOfRJusymZOyjc3zC2r9/hlTuULdWl+BAYkHVYYZ3NK5dkdp8ncWD/Pe5mg4lkIM67fD7Gg46GsKJajsPiWZ7lTd8E99AtHvAhrcOQxp1geN6xzH2IF10zpJ2IjABv2S6OaafFYqY8nnah7LOwT4VW+8hL8dSQiVhNy3wUXfLunxFZWSpYMtKwg5I4ZpbveBXShGhGTgE07jpBvm0lBzFJEtWK5bRKL6rPA1FMdOc54Am+lWIfdlxtdZC/LRV0jI4SN27i1EsouqU6s886hqjcX19qKKF8CCr/NpXpycTM6n4VbjPzYw1Uj4nyRReK9RzyB961rUo6aTXx516VBWf9q8xCxH+ZnA3uo7xVPSUValukhUOZvVx4VfjYQ/m8TR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/13 12:17, xu.xin16@zte.com.cn 写道:
>>>     Patch 1 removes an unused 'vma' member from struct folio_walk.  It has
>>>     never been used since its introduction and is pure cleanup.
>>>
>>>     Patch 2 adds a 'walk_lock' member to struct folio_walk and extends
>>>     folio_walk_start() to assert the required locking mode.  Existing
>>>     callers are converted to pass PGWALK_RDLOCK, so there is no functional
>>>     change.  This prepares folio_walk_start() for callers that hold a
>>>     per-VMA read lock instead of mmap_read_lock(), which is needed by the
>>>     Patch 4. No functional change.
>>>
>>>     Patch 3 tranforms the boolean 'lock_vma' into the enum 'page_walk_lock'
>>>     without any behavior changed, which is prepared for the Patch 4 to use
>>>     per-VMA locking. No functional change.
>>>
>>>     Patch 4 introduces find_mergeable_vma_locked(), which uses the
>>>     universal per-VMA locking helper vma_start_read_unlocked() to look up
>>>     and read-lock a VM_MERGEABLE VMA without taking mmap_read_lock().  All
>>>     KSM call sites that previously used find_mergeable_vma() under
>>>     mmap_read_lock() are converted to the new helper, and the locking in
>>>     get_mergeable_page() is switched to PGWALK_VMA_RDLOCK_VERIFY so that
>>>     folio_walk_start() can verify the per-VMA lock is held.
>>>
>>> A microbenchmark was run to measure the time KSM takes to merge a
>>> victim region under mmap_lock contention. Under interference from 4 churner
>>> threads, the merge time of the per-VMA KSM-optimized kernel is
>>> significantly reduced by 50%.
>> Hi.
>>
>> During task exiting, __ksm_exit() uses mmap_write_lock() to synchronize with ksmd.
>> see the comment of ksm_test_exit().
>>
>> void __ksm_exit(struct mm_struct *mm)
>> {
>>     ...
>>
>> 	if (easy_to_free) {
>> 		mm_slot_free(mm_slot_cache, mm_slot);
>> 		mm_flags_clear(MMF_VM_MERGE_ANY, mm);
>> 		mm_flags_clear(MMF_VM_MERGEABLE, mm);
>> 		mmdrop(mm);
>> 	} else if (mm_slot) {
>> 		mmap_write_lock(mm);
>> 		mmap_write_unlock(mm);
>> 	}
>>
>> }
>>
>> When ksmd currently is scanning the exiting mm, we should guarantee the mm pagetable
>> still valid (i.e., mm_users > 0). However, ksm_mm_slot only holds mm_count, which only
>> guarantees the mm_strcut isn't freed. So, __ksm_exit() uses mmap write lock to synchronize
>> with ksmd.
>>
>> IIUC, vma_read_lock cannot be exclusive with mmap_write_lock().
>>
> Nice catch. Thanks for pointing this out. Indeed, the original exclusion between
> __ksm_exit() and ksmd relied on mmap_write_lock() blocking mmap_read_lock(),
> and per-VMA read locks do not provide that exclusion.
>
> A possible approach to restore the necessary guarantee is to pin mm_users while
> ksmd is walking the page tables:
>
> Before scanning a given mm, try to take a reference with mmget_not_zero(mm).
> If it fails, the mm is exiting, so we skip it.
>
> Hold that reference for the entire duration of scanning that mm (not per-VMA),
> and drop it with mmput() when done.
>
> On the fallback path where we need to acquire mmap_read_lock(), drop the mm_users
> reference before waiting, to avoid delaying an exiting mm.

We should avoid holding mm_users ref too long. Otherwise, when the task being scanned
by ksmd is OOM-skilled, even though the victim task has responsed SIGKILL signal and
exited, the mmaps aren't released due to mm_user > 0.

We should check whether the mm_user has dropped to 1 during scanning, like what
ksm_test_exit() has done.

>
> This directly guarantees that mm_users > 0 while ksmd is accessing the page tables,
> so __mmput() cannot reach exit_mmap() and free them. It is more precise than the
> old mmap_write_lock() synchronization and should not introduce noticeable delay,
> since the reference is only held for the scan duration.

