Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C40CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868A68E0010; Mon, 10 Nov 2025 22:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FE48E0002; Mon, 10 Nov 2025 22:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DA88E0010; Mon, 10 Nov 2025 22:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 691CC8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:26:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DBB61A036E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:26:00 +0000 (UTC)
X-FDA: 84096887280.26.BF55980
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4048EA0006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:25:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kRjP4hwt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831558; a=rsa-sha256;
	cv=none;
	b=gqCjHKWmguhNvSyGxviWt0LCBWHsQqZd5oE6uo6/5vC58AueKkjmT8BQZQm/EUQlqL1FZL
	KmcF1yjuAmxb4GlPSfnRiDBtfvkgDOEeVbnjhyUQojAFbwwHtv3aRE2YIn9bAJ6xjbp2p5
	EXyp+Yhiaepyrv7hx+r1Y80i4fRWP5U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kRjP4hwt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWmeOmbaA7+VgqiMTnj4K9aVuIljbTl3qUWGKZSf2ZI=;
	b=302CKcud1STukM3+jscKVtWrQK5qIdWePAoN5GJW1IFVC7DvymvPtOBAua2Hp/O8Y+FJwb
	shPhn9frC13mq8vJ+Ho041vhwGN3F8CfXG5dvZiKqPx0QV2pnugvuu0rWWIpqmKfnbh+xh
	BTm4yCi4ew+YEQk2uoklC0THW0ra1ss=
Message-ID: <0432bee6-b384-4cd7-ac1c-e9123c7b393f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762831556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWmeOmbaA7+VgqiMTnj4K9aVuIljbTl3qUWGKZSf2ZI=;
	b=kRjP4hwtLD/JKJhFT4zQmm9kFq1RTjPBFxj/uY9nDzwWWJ+0CxeWDkGfDw0cgwdDzBgWh9
	1qhVlRRJTFNiNdEaMuKaXVneQlZa9ZpQI6kBrhlWqcqUYjjj73FvsAPztH8Gaa1CNjy7sf
	7fqgBNkxyZYUM4R44GqIieGGbWGVi0U=
Date: Tue, 11 Nov 2025 11:25:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA
 unmap paths
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: mike.kravetz@oracle.com
Cc: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Hillf Danton <hdanton@sina.com>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org
References: <20251110230745.9105-1-hdanton@sina.com>
 <aef27438-7636-4c38-a5c7-beda95efa02b@linux.dev>
In-Reply-To: <aef27438-7636-4c38-a5c7-beda95efa02b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4048EA0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 5pfqcor41cd35snd85kxwd4nxzwypeop
X-Rspam-User: 
X-HE-Tag: 1762831558-506414
X-HE-Meta: U2FsdGVkX1/Yu9XM0l0znNc8OfZGfUrare1HLrFCn7/r33Up5ZnGc4pD3ydiYEgaJ/k2uXPryo5UYsr+VG6uNY9+nTNBty+hJvP4LjK6BDUtCXPMhqxMlck11Ge2NWoxwjHeKkrWtQJIb0W1uMJwHYW7fxRu/OLkdhxRHK8koY2h2fi/l0uCWNHq7qedC3iZPot+gFn95Q5n+2csJ4SKYGvtPJMbH9q7OWE1wNSBMZhy2ImluVnsh7eamxWR8ksUQoi4edILAhqEQVpUCMk2vL18vnP4YVUQUJ4z0VhAUTav9vFKWbFA96u0bck/HxHnjZCLhuIqPDuiAjtijM2+IvWnJ4XlQBCJAC39p9KR3Gol/rk5O38lyG8rRm8LUEJJMGE1zlcCm3s1hipQV+WmP8cq2wqYqQ4cWI6UDV+FQncZyQ66R5ufComGNzXBoVtPDzA7kWnbdf/uQezUAjyWFumSwpS3oDRavUkutL4OE4UqBpVUYbXHzfH/u0wYyzuP5P2uvOC4WuQ0y+4T/Y1kvm26IX9vZubdLXTMzofB8NlZnCHJfQN3s+fOXpSzhFO82u41Jzug492hO2QFW3O7nOdJpJWkRxZ1+ptHzSb5fkdAzA1pex3H32J9MyE0y1MVCGCHKBRShf3//CSQOjNn/Od7pK9LTUnaw5tTyKPPpIR1fvdYBBOxeCHp5ib6O8s5VkmIg05Fiy/Judf8FeTG7w+4kRO4aIxgqIyVOpg6iC5hmFnGLIJcM0q2HeUq4FpBKEiSRDXBcRLtMLPSIG3I15OaZazCdebyDKYlViZah9YFRR9pSEcg85bcKmFws4jYwNXlGDIE3tQd/LnUsajOek3nXWd5qqAavVmgH3K5z7+PoB4zuOWJ+o4agRKulnvi1YGeR2J5d1Ni37N8t9QbwGFdmHxSwG6UNN1Vz+gjFdMqbQXQq9ZQxThbH6fet7h+2vxiMBXsT34wIsprUmk
 tN+p1uiL
 PhVZlk9yv2ZoL9Qh/aCYmP9FO8StWIcHNVhn3znHK4s6OHGShnFpPCoo1He54NGgC1cVAKK4F7fcQgNxbiK6O2NL0ue1QKCF7wkbX1PSozHKiN75qMzeLaw95bze3yjqIjQo15Sfr8LO24DrvcPxIWlkqCysr7i4mzRUQr25sbiSz+rPCoszoLnUuSM7YniEYlkHsoeftxH+wYn/USbECfyWpiCMJ3BnBvIn8h2/UCjE/PeSTxtQ87iActl1Q78638wh3qGYX+MNqtYnuYqb4QSK1AATOM9eZkxeg7aQeBR1QC/aKUJjC2hY13g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: HugeTLB folks

On 2025/11/11 11:20, Lance Yang wrote:
> +Mike
> 
> On 2025/11/11 07:07, Hillf Danton wrote:
>> On Tue, 11 Nov 2025 00:39:29 +0800 Lance Yang wrote:
>>> On 2025/11/10 20:17, Harry Yoo wrote:
>>>> On Mon, Nov 10, 2025 at 07:15:53PM +0800, Lance Yang wrote:
>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>
>>>>> The hugetlb VMA unmap path contains several potential deadlocks, as
>>>>> reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
>>>>> move_hugetlb_page_tables(), and the retry path of
>>>>> hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
>>>>> unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This 
>>>>> lock
>>>>> ordering conflicts with other paths like hugetlb_fault(), which 
>>>>> establish
>>>>> the correct dependency as i_mmap_lock -> vma_lock.
>>>>>
>>>>> Possible unsafe locking scenario:
>>>>>
>>>>> CPU0                                 CPU1
>>>>> ----                                 ----
>>>>> lock(&vma_lock->rw_sema);
>>>>>                                        lock(&i_mmap_lock);
>>>>>                                        lock(&vma_lock->rw_sema);
>>>>> lock(&i_mmap_lock);
>>>>>
>>>>> Resolve the circular dependencies reported by syzbot across 
>>>>> multiple call
>>>>> chains by reordering the locks in all conflicting paths to 
>>>>> consistently
>>>>> follow the established i_mmap_lock -> vma_lock order.
>>>>
>>>> But mm/rmap.c says:
>>>>> * hugetlbfs PageHuge() take locks in this order:
>>>>> *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>>>>> *     vma_lock (hugetlb specific lock for pmd_sharing)
>>>>> *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
>>>>> *         folio_lock
>>>>> */
>>>
>>> Thanks! You are right, I was mistaken ...
>>>
>>>>
>>>> I think the commit message should explain why the locking order 
>>>> described
>>>> above is incorrect (or when it became incorrect) and fix the comment?
>>>
>>> I think the locking order documented in mm/rmap.c (vma_lock -> 
>>> i_mmap_lock)
>>> is indeed the correct one to follow.
> 
> Looking at the commit[1] that introduced the vma_lock, it seems possible 
> that
> the deadlock reported by syzbot[2] is a false positive ...
> 
>  From the commit message:
> 
> ```
> The vma_lock is used as follows:
> - During fault processing. The lock is acquired in read mode before
>    doing a page table lock and allocation (huge_pte_alloc).  The lock is
>    held until code is finished with the page table entry (ptep).
> - The lock must be held in write mode whenever huge_pmd_unshare is
>    called.
> 
> Lock ordering issues come into play when unmapping a page from all
> vmas mapping the page.  The i_mmap_rwsem must be held to search for the
> vmas, and the vma lock must be held before calling unmap which will
> call huge_pmd_unshare.  This is done today in:
> - try_to_migrate_one and try_to_unmap_ for page migration and memory
>    error handling.  In these routines we 'try' to obtain the vma lock and
>    fail to unmap if unsuccessful.  Calling routines already deal with the
>    failure of unmapping.
> - hugetlb_vmdelete_list for truncation and hole punch.  This routine
>    also tries to acquire the vma lock.  If it fails, it skips the
>    unmapping.  However, we can not have file truncation or hole punch
>    fail because of contention.  After hugetlb_vmdelete_list, truncation
>    and hole punch call remove_inode_hugepages.  remove_inode_hugepages
>    checks for mapped pages and call hugetlb_unmap_file_page to unmap them.
>    hugetlb_unmap_file_page is designed to drop locks and reacquire in the
>    correct order to guarantee unmap success.```
> 
> The locking logic is a bit tricky; some paths can't follow a strict lock 
> order
> and must use trylock or a drop/retry pattern to avoid deadlocking :)
> 
> Hoping Mike can take a look and confirm!
> 
> [1] https://lore.kernel.org/all/20220914221810.95771-9- 
> mike.kravetz@oracle.com/
> [2] https://lore.kernel.org/linux- 
> mm/69113a97.a70a0220.22f260.00ca.GAE@google.com/
> 
> Thanks,
> Lance
> 
>>>
>>> This fix has it backwards then. I'll rework it to fix the actual 
>>> violations.
>>>
>> Break a leg, better after taking a look at ffa1e7ada456 ("block: Make
>> request_queue lockdep splats show up earlier")
> 


