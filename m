Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D7BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 03:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079BF6B0005; Mon, 13 Jul 2026 23:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A2F6B0088; Mon, 13 Jul 2026 23:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DB76B008A; Mon, 13 Jul 2026 23:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A40316B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:44:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 165A31C0195
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:44:28 +0000 (UTC)
X-FDA: 84985989816.18.E039704
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id 794BA100005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:44:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ouBI0wGg;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784000664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXOjuMzSvD+gYbqTC2OLzZ9jnmRNC6TFl8r9wiAZ3Pw=;
	b=qrvjcAIfSZKtlOh7I8aXBXvuj9bG5GDYXTdQ/shAP3VXHaf9SOjfwmun17ptoHUpbMGvgz
	DwEKvT/3Bk32PcLAykryTaeuOzXSOe7SXK8TG6jqx6K5oi+PUITYxV8OD5UT380c2BL1M4
	IqZ3qwor5mTmiN5Zfb1Hskq1MAUE7mw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784000664;
	b=Cga5okUkYVmtEBjAHYhTAxIgGaC5U3boq8QJT7UB04c15uhHaEr8U9gXO7TtV9tjBXKaOK
	eIkxKLARvLAQ4DePErgYe7Yh4MTMyn9Tnn4JBCajK4qZXz4Rb6lo9qcaqewtzBSGPUl6Lb
	MzL9DvVJFTEtyng0mM883i/5cXEYznk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ouBI0wGg;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784000660; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iXOjuMzSvD+gYbqTC2OLzZ9jnmRNC6TFl8r9wiAZ3Pw=;
	b=ouBI0wGgxJTn1/Z7aWqiKyXTcX+Fh2NwCxNWTl3JcPAVy3EvR9vtPM3HIhsV2BmEhzcOmDO/iSOI9tDAo2jK60qHQUxOWXuY3bZ2JQGlS2EDJMnKoZHUP/nrOpMoyd9ZEYx2nsT0wdd/VC9ScMS7HHcB0tVkl/Bgxpfw+njsOPY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X72hfDk_1784000658;
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X72hfDk_1784000658 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 11:44:19 +0800
Message-ID: <880d2e49-3225-405b-a0b6-d5a7d5d84648@linux.alibaba.com>
Date: Tue, 14 Jul 2026 11:44:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
To: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kirill@shutemov.name>,
 Hao Zhang <hao_zhang_kdev@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org
References: <20260710071344.GA106129@zh-pc> <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215> <alEg6ZPc-ao7s6o6@thinkstation>
 <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 794BA100005
X-Stat-Signature: dn1qtu3gfqh1yjg45hez7f1enj4497ob
X-HE-Tag: 1784000663-512296
X-HE-Meta: U2FsdGVkX18tXKk/XSNwmgVynSiwvtaSDAI2dKX7AXKm222d1xaz5FDl/bEVbIQB4ZhxeNdTQ0atSQZY/ZhBfSGV5qbgOplHUTYnW/9tfNMwkHKhWyk+OKZoNevO4Wn9LJ0QAqjJYtu79uYQpVc5BNbLcXEyGOLcM+rfhgzBhTRJqlS+mDrm76FN1r88P3dnPutcm1X+ru/Lz0cjSM9rBuIKuBRjULlHYvmlT8S0rnOXmRyqpooMRLwrJNqWJJfPx9/ZpjFYhEDi3w0VDbJQ/4lJBi38W7MA/0FzEwkxYNn139eiAk6HEToXhKnPQfLH7MlnovFqnMZUnOoMgllXGlb6TUAVEYIrf/scv9nhMYSE86r/Dd9V39c/BP9ZswxoNhZD682Q4nOTMIHA0yUU38I39hy8Z6koNDMciaMFT9SAO8+iGYSjzJTpPqmAdbIcTCBhVZ8QvFeIqAqbCY0E+ImPSZiItUjttv1Wzwokw8NgJU+FWFDNPijc5Qw3RXmOYSsxQXScB6o+74OVsEHEDqxyoQ2y/nnL3IFRaqwlnMY4w1nuuH5340Ksm7WRwu+iM5k6xIxdX5HT4bZ6R2l6aLD1DEzkmb+Dt9Ay2xvsANEn4UzQSJZxCJxG2d2/+ljTnaq01JwKCcMY14Ifr9VmF7fEf92tRM2+q2JWbSreHxBhiAKxqKjCOYaEiex18+l5RY6zxiilJxdwdhLc5FtcTgfF6/wRjD0qKLIzWvp7X+X/rz10hyrc8lTU7KeT5L/jCBP77IA28Ji/9n6LZOWH41KM1brYFqAxNtHsylqzabFRkvOKvzV2jH8RmRsATX12+nCSlOu5jnJawAxjiGNnVm51tMjOtK0bPCY+J7WW8owJBZD1kNWbohPIGCJjfoO4j11gO59UpTxRx8hKILW1IN/+qx6udNKXWRHle4J7w/I3PeLUgujVqqKfyfnXTJj+ovwAJ+NboE5jpRmnf3i
 O4TzpaRV
 3DSMOIuhhGt5hV6mo+YA12A6kO97rFh5GKtLqqUH+XNKumtijXC1P0aqTPMlVQsR4RN5/6XD4kPUkmJ7Jri8m/io20gaUrcCW970InMODrJWqfEqzDVANnDid8WdxNB2QBYHwZGK5tcoxDwUNegsWQnGhjuuy6kYOnBXg89EjBlMNfi1fNhf8fGuY8UiZCvCj0UBuGkKTPUpxa4VQ14Mvv2vWCYR4bRCf9+ed3zGLCK3C1OKBJeAaiBnBbqvtmKEbPjPf7pb8u+AdxgxoJjImVzvz+NIxaDsJIZ7AZEiJqXMVtvyPy/cU/drsvp6pQkWxPDuYzoTi9w3FzfxlYSKN2JpU2JIjQNh9FVO5N1+IgoDPB/ieaVnmtIdKdRMcLX98kZDka5N9QNB0g1iEphfUQ4mAD7ELeue2EIehIWqRmeOH5VoCT7vBRIeKfvUCMHxDJHeQaaTnarSVhL91O9I2yK6Uo+QNwz2KI+DV2dNGIi7MYa4cQF53Aq6iQKc7w0GhLVDfphsuAy3XZ5CDlwR+auI/WgUSXgdcH8AfOWWN+dKaU2LDy3PqVC2Xog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/26 10:15 AM, Zi Yan wrote:
> Removed owner-linux-mm@kvack.org from Cc.
> 
> On Fri Jul 10, 2026 at 1:17 PM EDT, Kiryl Shutsemau wrote:
>> On Fri, Jul 10, 2026 at 11:56:00PM +0800, Hao Zhang wrote:
>>> On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
>>>> On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
>>>>> From: Hao Zhang <zhanghao1@kylinos.cn>
>>>>> Date: Thu, 9 Jul 2026 16:30:00 +0800
>>>>>
>>>>> __folio_split() takes mapping->i_mmap_rwsem while unmapping and
>>>>> splitting a file-backed large folio. The lock is currently released
>>>>> only after the split folios that are not returned locked to the caller
>>>>> have been unlocked and put.
>>>>>
>>>>> That leaves a lifetime hole. Once the split folios are unlocked and
>>>>> their references are dropped, inode eviction can make progress through
>>>>> the final page-cache truncation path. After the folios are removed from
>>>>> the page cache and the last inode reference is dropped, the inode that
>>>>> embeds the address_space can be freed after an RCU grace period. A later
>>>>> i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
>>>>> from freed memory.
>>>>>
>>>>> A possible race is:
>>>>>
>>>>>    CPU0                                    CPU1
>>>>>    __folio_split()
>>>>>      i_mmap_lock_read(mapping)
>>>>>      ...
>>>>>      remap_page()
>>>>>      folio_unlock(new_folio)
>>>>>      free_folio_and_swap_cache(new_folio)
>>>>>                                            evict inode
>>>>>                                            truncate_inode_pages_final()
>>>>>                                            destroy_inode()
>>>>>                                            call_rcu()
>>>>>                                            RCU callback frees inode
>>>>>      i_mmap_unlock_read(mapping)
>>>>>
>>>>> Release mapping->i_mmap_rwsem after the page-cache and reverse-mapping
>>>>> work has completed, but before unlocking and putting any of the split
>>>>> folios. Clear the local mapping pointer after the early unlock so the
>>>>> common exit path does not unlock it a second time.
>>>>
>>>> I don't buy this analysis. We still have the lock_at page which is locked
>>>> and still in the page cache. Inode eviction cannot complete past
>>>> truncate_inode_pages_final() until it is unlocked, which only happens
>>>> after __folio_split() has released i_mmap_rwsem.
>>>>
>>>> One possible path how this can be hit is if lock_at ends up in an
>>>> after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
>>>> removes it from the page cache. Note the drop loop starts at
>>>> folio_next(folio), so this requires splitting at a tail page (e.g.
>>>> memory-failure) racing with truncate.
>>>>
>>>> But that's not what your analysis claims. Please share the actual crash
>>>> reports. Let's get to the bottom of the situation before changing the
>>>> code.
>>>>
>>>> -- 
>>>>    Kiryl Shutsemau / Kirill A. Shutemov
>>>>
>>>
>>> Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
>>> Injecting memory failure for pfn 0x81bfe at process virtual address 0x200000ffe000
>>> ==================================================================
>>> BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
>>> Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874
>>>
>>> CPU: 0 UID: 0 PID: 45874 Comm: syz.2.11034 Not tainted 7.0.0-rc3base+ #62 PREEMPT(full)
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>>> Call Trace:
>>>   <TASK>
>>>   __dump_stack data/linux/lib/dump_stack.c:94 [inline]
>>>   dump_stack_lvl+0xbe/0x130 data/linux/lib/dump_stack.c:120
>>>   print_address_description data/linux/mm/kasan/report.c:378 [inline]
>>>   print_report+0xd1/0x660 data/linux/mm/kasan/report.c:482
>>>   kasan_report+0xec/0x130 data/linux/mm/kasan/report.c:595
>>>   __asan_report_load8_noabort+0x14/0x30 data/linux/mm/kasan/report_generic.c:381
>>>   __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
>>>   up_read+0x22/0x30 data/linux/kernel/locking/rwsem.c:1633
>>>   i_mmap_unlock_read data/linux/include/linux/fs.h:537 [inline]
>>>   __folio_split+0x732/0x1640 data/linux/mm/huge_memory.c:4100
>>>   __split_huge_page_to_list_to_order+0x7b/0x140 data/linux/mm/huge_memory.c:4203
>>>   split_huge_page_to_list_to_order data/linux/include/linux/huge_mm.h:385 [inline]
>>>   split_huge_page_to_order data/linux/include/linux/huge_mm.h:389 [inline]
>>>   try_to_split_thp_page+0xab/0x390 data/linux/mm/memory-failure.c:1675
>>>   memory_failure+0x1394/0x26e0 data/linux/mm/memory-failure.c:2470
>>>   madvise_inject_error data/linux/mm/madvise.c:1487 [inline]
>>>   madvise_do_behavior+0x4ae/0x8a0 data/linux/mm/madvise.c:1925
>>>   do_madvise+0x162/0x230 data/linux/mm/madvise.c:2028
>>>   __do_sys_madvise data/linux/mm/madvise.c:2037 [inline]
>>>   __se_sys_madvise data/linux/mm/madvise.c:2035 [inline]
>>>   __x64_sys_madvise+0xae/0x120 data/linux/mm/madvise.c:2035
>>>   x64_sys_call+0x1bed/0x25e0 data/linux/arch/x86/include/generated/asm/syscalls_64.h:29
>>>   do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
>>>   do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
>>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> ...
>>
>>> Memory failure: 0x81bfe: recovery action for already truncated LRU page: Ignored
>>
>> This log line confirms my suspicion.
>>
>> The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
>> still holds the poisoned page locked. For the inode to be freed at that
>> point, eviction must have completed truncation, which is impossible
>> while a locked folio remains in the page cache. So the after-split folio
>> containing lock_at was no longer in the page cache — and the only way to
>> remove a locked folio is the split itself: the new_folio->index >= end
>> drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
>> tail page, which is what memory-failure passes.
>>
>>          CPU0                                    CPU1
>>    i_mmap_lock_read(mapping)
>>    __folio_freeze_and_split_unmapped()
>>      __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays LOCKED
>>
>>    /* no locked folio pins the inode */
>>                                          evict()
>>                                            truncate_inode_pages_final()  /* nothing to block on */
>>                                            call_rcu() -> free inode
>>
>>    i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode
>>
>> Your fix moves i_mmap_unlock_read() out of the window, but I don't think
>> it is complete: shmem_uncharge(mapping->host) a few lines up also touches
>> the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
>> that triggers this. So it is in the same freed window; the patch just
>> relocates the one dereference KASAN caught.
> 
> I was discussing this issue with Codex after I saw Kriyl's patch and the
> iput() issue raised by Sashiko[1]. Hao's patch might be still valid for
> shmem_uncharge(), since all after-split folios are locked at
> shmem_uncharge() and prevents inode from going away. So the rule is no
> mapping/inode dereferences after the after-split folios unlock loop
> begins.
> 
> But let me know if I miss anything. Thanks.
> [1]
> https://sashiko.dev/#/patchset/20260713170915.239819-1-kirill@shutemov.name

After reading the analysis, I agree with you. Hao's fix looks simple and 
effective, unless I've also missed anything. :)

