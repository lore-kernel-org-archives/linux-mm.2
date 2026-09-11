Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD56C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83A16B008A; Fri, 11 Sep 2026 04:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33AC6B008C; Fri, 11 Sep 2026 04:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C506C6B0092; Fri, 11 Sep 2026 04:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA2E6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:47:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A9C5160159
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:47:33 +0000 (UTC)
X-FDA: 85200852786.13.B90601D
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf29.hostedemail.com (Postfix) with ESMTP id C4293120004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:47:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xLmZn2Pm;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789116451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yUwcX3UlLnLfoIr8zYfqVUEOK/MbgYFGnxLAsHWgYE=;
	b=JTmACoOAtPUBM0b+C8skH1fnbWDqkSCPACKRZiDb/eRhv64A4QITaP+dxGp+cejUehKt3Z
	hMnRkpjsiLx8z8mX6iPL0/539z9bRODiSxSUhq1jYnllDvyqtVepaKuiYmnlJBLQyV6bKC
	tWHqnBBLo2AnWacpT6vqNflBvTp16uY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xLmZn2Pm;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789116451;
	b=SkLf/deWNVwiXQOqyvFle4TxspJdPE55zTdJvtHFhGX3FJ1wbGGYex1s7fN1UB2A/M5gu5
	wop2flI6+v3GOwqhYCoFbii2IO2KWSRnIGmK+3wDO3xEQg0ZfrK0A4n+/cTQCIXPNy8xh4
	XEXV2g0Lp+yHjHBgKkjeLqUMcUxAcIY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1yUwcX3UlLnLfoIr8zYfqVUEOK/MbgYFGnxLAsHWgYE=;
	b=xLmZn2Pm+KYM1D0O+8lYHWWOWQ4Nw5UyxR8dYeNs7mSlCC2k7VR40D6an0jzMPdDsfLYAl4vK
	SCkgk5duhFud3ex0ylNZ1vS7gtFa47Ash4T5y96Kpoa+yY0nDPhLVib0lkQ435H0jJrf20Uulpw
	PGCvbiXg5nhT1rPjoECxGj0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hh7Dr42npzmV98;
	Fri, 11 Sep 2026 16:36:28 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 4BF1040573;
	Fri, 11 Sep 2026 16:47:24 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 11 Sep
 2026 16:47:23 +0800
Message-ID: <40c0c081-d636-407b-898e-f40f3d5d38cb@huawei.com>
Date: Fri, 11 Sep 2026 16:47:22 +0800
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
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4293120004
X-Stat-Signature: apqexowj5hqubjxffmk9kohuybniz854
X-Rspam-User: 
X-HE-Tag: 1789116449-301429
X-HE-Meta: U2FsdGVkX1/Bws00JV5OEf6NRmF3OQR9TztBjyZeOXpL9l8i+kffX+eowRNh/cVLA2H2pFrHbWHc43lbLzAD29GGKqOCdx6CSAxfLIntEAJm5qE2jq8F0qzg8bBkaYsZO9EUkPxdPs+NXk/6Tjrtb0jYQsLi6o0sDP40Qo6Mc0kn4gu5CAyjjc5xSjohOPADAsiK0kLlGmI0HBwIQOR45jYhH0oXUPTxXUFa7baDkv5a+3yKS05jqqDjaB35UMgksRRfRB+grWo404jMub97Ckj+AcCAfHH1v3g/pIxyRhNTR5N6rS9sPvzs2uuItCMzovTC48an6BkAqgZ3tswlry3ghvwQarudNC1oVVDN5Xb2+1MauHOPATsnUGhPImF/RpKraiA2nJkrMlLhGrNupwJUBu+xVm0YEG6DRQtVxz6EWn48CqThdYatfcZOmPaS1Kb5y0w4/XKaGQGw+LOvkLpnCY+0OVZiGhOycteLX2zT0LKUBLEJVemlIWUyLj9/9su6oAmWOrdjKz1xn+oTd49UHIRiw02E7dyyIFhW9Eeh2gK7u93Uacd/8AVcqWMtz5LCGZ1w4PGO9mlUBMbxSvxz8wqfp9jhmMeX6Lbu2EFDRDqCpPBaYJ2DDe4Kk/lp/9CnLYz6BQwDos3eENCBQmFXozs1CRYiGkpaHTjfqw8O5JgKraIFANzohnCBB3gYes4gA46kmUm1Jq3NFeXJw3T4R6znvARRvCdmplmsDdni50W3YuBIl7n/bLNCcgnT+HlSvs1ZAXEfvK/f4j+aTXkX3v4A1k3WjV6tbDN1NLf9cAboS4UlqbdRoGJhjq27goCh4pYKe3sFlPbq1uHpvyhFTkv5TD9mYJA1Wu1RmcLwUGwZ7SjrHhZJhYB2Ik0NbdWV3ZpEdf0TMbgJ2oNVrAyyCtpzBlGjxjVBRO3k6przCR5l153LATQyvH7+ULo/5TTdENoWlGZ3pt1cWMF
 rfGltRJq
 v4kP8mxQm+SER8uT4IWkKGCk7x9zz18UmYIQ4mbwMVo+2C+JGX564k23uuQmZgzdj8TOTa1CfKyqvm2q/BdFm962Lsqn58CJlcXMI9HtgkgSfzkeqDQq/CE+8XqLMWKBU+peDm4vRVLPYJ/cofXVOCKD7jhkdnfaIQo6iTI3nF2irF2P8wbRadwDaXAqDPWr+k17//uYAR4la3JWCjA2EcBeRHG0K7AetDtb5L0FihDNw3PdoJNwVQv3+zAnPRexvRM3G+wgNKmNPf7yWRHs1SvsN7CrccRHiy0QBAxbZha+p4k86VLyUkrhpYj2BeLbPiKxhJ3TWJ6tPPUvp0nYevMpIwBkZ10E7+n4J8YGCg+OiTXhFrCv2DjyxpIjHQeJsRQ1c5TtoICQlCNbmCMNO0IYVHCfYULvnO3ryqk+EV+Uj+RgC5r+c9mj5RJpP7kCNzOB7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/11 16:04, xu.xin16@zte.com.cn 写道:
> From: Xu Xin (ZTE) <xu.xin@linux.dev>
>
> KSM scans VM_MERGEABLE VMAs and currently protects each scan with
> mmap_read_lock(). Per-VMA locking allows KSM to read-lock only the VMA
> it is actually interested in, so that unrelated mmap()/munmap() activity
> in the same mm no longer blocks ksmd.
>
> This series is organized as follows:
>
>    Patch 1 removes an unused 'vma' member from struct folio_walk.  It has
>    never been used since its introduction and is pure cleanup.
>
>    Patch 2 adds a 'walk_lock' member to struct folio_walk and extends
>    folio_walk_start() to assert the required locking mode.  Existing
>    callers are converted to pass PGWALK_RDLOCK, so there is no functional
>    change.  This prepares folio_walk_start() for callers that hold a
>    per-VMA read lock instead of mmap_read_lock(), which is needed by the
>    Patch 4. No functional change.
>
>    Patch 3 tranforms the boolean 'lock_vma' into the enum 'page_walk_lock'
>    without any behavior changed, which is prepared for the Patch 4 to use
>    per-VMA locking. No functional change.
>
>    Patch 4 introduces find_mergeable_vma_locked(), which uses the
>    universal per-VMA locking helper vma_start_read_unlocked() to look up
>    and read-lock a VM_MERGEABLE VMA without taking mmap_read_lock().  All
>    KSM call sites that previously used find_mergeable_vma() under
>    mmap_read_lock() are converted to the new helper, and the locking in
>    get_mergeable_page() is switched to PGWALK_VMA_RDLOCK_VERIFY so that
>    folio_walk_start() can verify the per-VMA lock is held.
>
> A microbenchmark was run to measure the time KSM takes to merge a
> victim region under mmap_lock contention. Under interference from 4 churner
> threads, the merge time of the per-VMA KSM-optimized kernel is
> significantly reduced by 50%.

Hi.

During task exiting, __ksm_exit() uses mmap_write_lock() to synchronize with ksmd.
see the comment of ksm_test_exit().

void __ksm_exit(struct mm_struct *mm)
{
   ...

	if (easy_to_free) {
		mm_slot_free(mm_slot_cache, mm_slot);
		mm_flags_clear(MMF_VM_MERGE_ANY, mm);
		mm_flags_clear(MMF_VM_MERGEABLE, mm);
		mmdrop(mm);
	} else if (mm_slot) {
		mmap_write_lock(mm);
		mmap_write_unlock(mm);
	}

}

When ksmd currently is scanning the exiting mm, we should guarantee the mm pagetable
still valid (i.e., mm_users > 0). However, ksm_mm_slot only holds mm_count, which only
guarantees the mm_strcut isn't freed. So, __ksm_exit() uses mmap write lock to synchronize
with ksmd.

IIUC, vma_read_lock cannot be exclusive with mmap_write_lock().

>
> Xu Xin (4):
>    mm/pagewalk: delete the unused member
>    mm: make folio_walk_start()'s locking asserts scalable
>    mm/ksm: make break_ksm() more scalable
>    mm/ksm: add find_mergeable_vma_locked() to use per-VMA locking
>
>   arch/s390/mm/fault.c     |  4 +-
>   include/linux/pagewalk.h |  2 +-
>   kernel/events/uprobes.c  |  4 +-
>   mm/huge_memory.c         |  4 +-
>   mm/ksm.c                 | 85 ++++++++++++++++++++++++----------------
>   mm/migrate.c             |  8 +++-
>   mm/pagewalk.c            | 10 ++++-
>   mm/rmap.c                |  4 +-
>   8 files changed, 79 insertions(+), 42 deletions(-)
>

