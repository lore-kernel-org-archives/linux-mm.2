Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A82CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56C28E0006; Mon, 10 Nov 2025 22:20:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EAE8E0002; Mon, 10 Nov 2025 22:20:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944FB8E0006; Mon, 10 Nov 2025 22:20:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82BBC8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:20:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BA344BBAB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:20:43 +0000 (UTC)
X-FDA: 84096873966.15.5118536
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1827C000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:20:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qldQiTbD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831241; a=rsa-sha256;
	cv=none;
	b=2TWk0zWyL2rWo8Ftv2rhG65cTR6ZbFU9SG0Mo2ucLo5lwXWEenhOxwP+8fbyCvDZ1d3agX
	ncBzpgiNdOGD9PQAYRtmSPn4F1rEjygKdcXcCZfFVvBuxYkpXKr4Tb7ebJqfjsFnDvS6kF
	YGXeG1ilyXADp6raDihQpERMMsDLIUs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qldQiTbD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TjnAMwRA5cP5wMGVIyQAzD0ksmiesUlEX8b9U57VhE=;
	b=P6/OrRu7XCm85hLyueibx3mcxK72qyt5oQhQKG+qQcs8oaB29M4OuTfWwd8cTXZvmZMr5p
	zuPmyDhDuOivJPldfC23FqVinuS7MTS5eyQ7mPbjr/kgSLv6owi/u7FtT03P3/c3SAcYWv
	zCJEEVlVBOGMpXuC6uKbN/wIyn6Z76E=
Message-ID: <aef27438-7636-4c38-a5c7-beda95efa02b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762831236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TjnAMwRA5cP5wMGVIyQAzD0ksmiesUlEX8b9U57VhE=;
	b=qldQiTbDatoU6IH1wo9+2leMUJS+h+YzNt9j57iIjdLoUpD6HAm4kbwl7VQUy7ZaGWGSdI
	Xo0gKPh86ve4phAVfTgQ8DzZYmDNKj67oj63NHq4XIB+f4wKt0tF6DxczAs4Ny1Gq3SJ6P
	NzM2FCv4ZaJF/MrqSJ2mkG85wftiqaY=
Date: Tue, 11 Nov 2025 11:20:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA
 unmap paths
Content-Language: en-US
To: mike.kravetz@oracle.com
Cc: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Hillf Danton <hdanton@sina.com>
References: <20251110230745.9105-1-hdanton@sina.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251110230745.9105-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1827C000B
X-Stat-Signature: edpo8zbx7o5npui7r9146q767kb11s56
X-HE-Tag: 1762831241-140629
X-HE-Meta: U2FsdGVkX18qq3rAL6XgJFX5RZSRhsM8hSCeun9jQ2tcgdne42efJoiuzSLUIHLRdfQJjYE2Ql1Mcppn7tJv+caHl8KPCP/P65Y8CMaWmEX9vEQxQDbiGqVu7VJFlt9C76FBasMI5r32eKe4aja/ErqEgEIR4gzdPIk1CW1L5hwSIwgxt4YvnOKM1PgOSUYQdH/oRTC2bQtdYALuRcpHo+fCZBZLDkCOPOUNbzRymSISBpjA36/nfZhSYGdTF8N/4dTUTAaIMXUOu9vkPzH1HBFqnxSWud2p7cesHHzw3yEywdCGFlJNfKsqhIoTrQQ+U7AGD8Pigmngf9FEZIvcvaxWXmeDQME9bZRg3VWLZ2vgIl4FyxDFxGmCgEG1SZz0AY83YGBPCe/5+O9RSFaP52B1md4JpD8LShNELgJgi72XlWpkKTOiEno120sJi7ldo9VtkUpWri/v1W0SzX5JFDKD0XG1XuG5pwEvKQV+G5ieuWqRM8gN7zk1mC3FBOLcTio5fqSEa8M8faf/DRGu/kRUvYKI+10RP0de4K2YjipmKpvbBAkdbgmu+UlgDMeHb4TABnDo5gjbi4sn+ZOZrbHSQF3ybbtWsT6hT94qY1UW/FLOm/CXIF/LWeFE59I8W3eQ/JiQnK0l6OaLn+0rb8qXZMxpnd/pcGpxE9LTn3ZbPguTmG5pAUrVWp6+J/pELk6NhqzTcJcqmkK8o/qZyhwaTTWQmz5seL0Ye7uVv4boNohxyrKvS/M2YOhaS6tOvddix6cQvxyAG6VEsQzTou3rQNiLnCb45sUxCmwbwqpnsRo3zKaZ4lJKo7lOmTxf+jbcxk/na2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Mike

On 2025/11/11 07:07, Hillf Danton wrote:
> On Tue, 11 Nov 2025 00:39:29 +0800 Lance Yang wrote:
>> On 2025/11/10 20:17, Harry Yoo wrote:
>>> On Mon, Nov 10, 2025 at 07:15:53PM +0800, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> The hugetlb VMA unmap path contains several potential deadlocks, as
>>>> reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
>>>> move_hugetlb_page_tables(), and the retry path of
>>>> hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
>>>> unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
>>>> ordering conflicts with other paths like hugetlb_fault(), which establish
>>>> the correct dependency as i_mmap_lock -> vma_lock.
>>>>
>>>> Possible unsafe locking scenario:
>>>>
>>>> CPU0                                 CPU1
>>>> ----                                 ----
>>>> lock(&vma_lock->rw_sema);
>>>>                                        lock(&i_mmap_lock);
>>>>                                        lock(&vma_lock->rw_sema);
>>>> lock(&i_mmap_lock);
>>>>
>>>> Resolve the circular dependencies reported by syzbot across multiple call
>>>> chains by reordering the locks in all conflicting paths to consistently
>>>> follow the established i_mmap_lock -> vma_lock order.
>>>
>>> But mm/rmap.c says:
>>>> * hugetlbfs PageHuge() take locks in this order:
>>>> *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>>>> *     vma_lock (hugetlb specific lock for pmd_sharing)
>>>> *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
>>>> *         folio_lock
>>>> */
>>
>> Thanks! You are right, I was mistaken ...
>>
>>>
>>> I think the commit message should explain why the locking order described
>>> above is incorrect (or when it became incorrect) and fix the comment?
>>
>> I think the locking order documented in mm/rmap.c (vma_lock -> i_mmap_lock)
>> is indeed the correct one to follow.

Looking at the commit[1] that introduced the vma_lock, it seems possible 
that
the deadlock reported by syzbot[2] is a false positive ...

 From the commit message:

```
The vma_lock is used as follows:
- During fault processing. The lock is acquired in read mode before
   doing a page table lock and allocation (huge_pte_alloc).  The lock is
   held until code is finished with the page table entry (ptep).
- The lock must be held in write mode whenever huge_pmd_unshare is
   called.

Lock ordering issues come into play when unmapping a page from all
vmas mapping the page.  The i_mmap_rwsem must be held to search for the
vmas, and the vma lock must be held before calling unmap which will
call huge_pmd_unshare.  This is done today in:
- try_to_migrate_one and try_to_unmap_ for page migration and memory
   error handling.  In these routines we 'try' to obtain the vma lock and
   fail to unmap if unsuccessful.  Calling routines already deal with the
   failure of unmapping.
- hugetlb_vmdelete_list for truncation and hole punch.  This routine
   also tries to acquire the vma lock.  If it fails, it skips the
   unmapping.  However, we can not have file truncation or hole punch
   fail because of contention.  After hugetlb_vmdelete_list, truncation
   and hole punch call remove_inode_hugepages.  remove_inode_hugepages
   checks for mapped pages and call hugetlb_unmap_file_page to unmap them.
   hugetlb_unmap_file_page is designed to drop locks and reacquire in the
   correct order to guarantee unmap success.```

The locking logic is a bit tricky; some paths can't follow a strict lock 
order
and must use trylock or a drop/retry pattern to avoid deadlocking :)

Hoping Mike can take a look and confirm!

[1] 
https://lore.kernel.org/all/20220914221810.95771-9-mike.kravetz@oracle.com/
[2] 
https://lore.kernel.org/linux-mm/69113a97.a70a0220.22f260.00ca.GAE@google.com/

Thanks,
Lance

>>
>> This fix has it backwards then. I'll rework it to fix the actual violations.
>>
> Break a leg, better after taking a look at ffa1e7ada456 ("block: Make
> request_queue lockdep splats show up earlier")


