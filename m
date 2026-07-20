Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96014C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674CC6B008C; Sun, 19 Jul 2026 22:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625CB6B0092; Sun, 19 Jul 2026 22:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B436B0093; Sun, 19 Jul 2026 22:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 224C36B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:24:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A824FC06E5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:23:59 +0000 (UTC)
X-FDA: 85007559798.22.E783BE7
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4D61D14000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:23:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J91TRnw/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784514238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8X2N36SkSYXjR3Lmfvw9oc82NSEhF0xR/1+TvWCook=;
	b=mfJMY8kiukQycet6p9Mpt8wbB1A4catJs7/OsRn5NukcOHA3ryqw1eYgcRzBPqzINX14yO
	Cq8n1bY4IR25gx0xa4hSm9RkfpKNf2BA9HF/7dK09anp3plFLzpRT0hYOL3ja8h2opx/g6
	cKPyvbJKzr/Qp1PBSMICIRRTYWJ3mE4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J91TRnw/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784514238;
	b=ueuO+fa+6xdn0d3KLOQekmakapnYvb76xoP0j8VxDVxMhlYn6E5tCXRf0l5bTxX2hC6hVz
	dHIHL3RcTNkbsa/caapeAAHDxUeZZh8mATv0m9QG+Cmpp3Ztw0LqE4yNSDJKw4Trbvv1nw
	vgI1T+n1m8EuN0bOtDGlAY+m/B8rlGU=
Message-ID: <f39a287a-3f70-4f6b-8c5b-5f6cb78bfda2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784514233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8X2N36SkSYXjR3Lmfvw9oc82NSEhF0xR/1+TvWCook=;
	b=J91TRnw/4A5FT66aJBIZ+uOdUSXLsRzfDF3RvMU8zEjoBvqfQAoDKQkOq0W9YGBjOm2SfO
	G689c4vi4VadKqANJ6lfllc2vTi49Fbw+SaVc6EYEU/Y0ij5BjMCDmMdhCzCUKoJ7BBf9a
	DXxPAxpQZWms4TkrGowKF3I7Kav/1dU=
Date: Mon, 20 Jul 2026 10:23:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: shmem: make unused huge shrinker memcg aware
To: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com,
 akpm@linux-foundation.org, usama.arif@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260714031918.308-1-qi.zheng@linux.dev>
 <7624107f-6a2d-4959-b2ee-aa362a8972eb@linux.alibaba.com>
 <ac0cd32c-8255-41c6-9814-22a02aa50dbf@linux.dev>
 <d850e8e2-ba53-4876-b92d-88c3d341b8e6@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <d850e8e2-ba53-4876-b92d-88c3d341b8e6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D61D14000A
X-Stat-Signature: 3bhuubn8fqtz41gbeqbz4yu8pqo5pg3q
X-Rspam-User: 
X-HE-Tag: 1784514236-761831
X-HE-Meta: U2FsdGVkX1/CZPnfjdp+jYWqHMDFmS1hlSEbDNYi9AliXhzU2gojbV5hW3cZ8sa/6SMIhH2tzQyoF6IbcAIyVpHdOZyGVArFlakJY+FvRO4czDOZB/PUU4GCupth9aSr6x+w4boCv4wfOv572vrNBwxza4fW+YpCijycCvolH41wUTzpV6VXL81Vf1txn17vLl5L41zcIrQGKR5xbd2WfneJDqUCclnyPYw9IhFBgahctN3UUyTI6HcNNyrTlZnlhSTcm2YFC6uGxUqLlfpmwrpLxAWtZ+88RJqb1KHwYOPA+ZYkuEhXmf0vSIn74AAnvaU5xiAuOgv+la9ja2U/DFd6en5mWC92fZTtTmewYT+w0vWFSVDUSVa+YhT+nI0NegRuKrKXmzVgwB3v2fJR0lwOT0PyGTZf6oO+yeEcC8dgRT7o/iBN9oH7bWL7NKlg91Cr6pNGfR8HhbgF9swiK7qZwclQN9Em/x8o5DPqusYNny9mJ7OAWig98ckPZU1Nz4D+WLseLidP6sfD5aSkaROzZHREVZhgDuYYmyUR8VlURWeU79PJDScOna2zw++4Qj1uVt4Q8tFzonknfCHcy6oTh1tZmI+JvGeYsdF4A3zk0ClpmEi12llN3uyw7HzGB3naNxmU/fRbAg5B8+TFoLFXvpUq/cghPVSXMq95yXFlmh5UIDBUDmKuSkm0PMVJrJmu7EruRZ6Bf0RLUByqYc9S1SPt91fB5EoUd6TTTaPiEuA3lKV8L3+6yVC1sGg/B82Ogq5bd5cE2F69++F7WJ3PihgBJJKqO29/DM72fkDCU/4iGQiDGDI+/7Kr2rLpddmmnpIqGujLqhEiBrZA5Bcma2TYS2dmVI2MepTBeR+F8+47+1ZyfgG0UpBAJ9++FlLCA1d1NTpCB1R5YIaZjIfssKp5u7aDj7OHSwjRq5mq1wTYca4Kj0b5ijV2DI4N/MBZlGyRH0MrQagZ10R
 635HLcNi
 O+A8+QW9HX2jVLwm1mqhXY7dqmhcJWazdhn79jC2w5mdy3jHOSAEeWHO2bP4nobrQ+1VR3/8qlskaWoGoevBxca56BsLthwIs22Jk8jqZUhut0OtG8QZnwFGLTCiFDUyjrhqYhM3mpjmPUSP/+WrRqJUd+KFP4+g/sESAPlxvz04leRQhpR1CEurHE+3IJi+qZTzM/ia7lWUo7OkD13JlFKUKJVCyXd3wqv7sj+wJbRwuF5kjLkrO0uOWuVvWq8kGSg9dzrY93NMGwdljZs9P5r+LyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On 7/17/26 8:50 PM, Baolin Wang wrote:
> 
> 
> On 7/15/26 5:55 PM, Qi Zheng wrote:
>> Hi Baolin,
> 
> Sorry for late reply.
> 
>> On 7/15/26 5:37 PM, Baolin Wang wrote:
>>> Hi Qi,
>>>
>>> On 7/14/26 11:19 AM, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The shmem unused huge shrinker keeps a per-superblock list of inodes 
>>>> whose
>>>> tail huge folio extends beyond i_size. Since that list is not memcg 
>>>> aware,
>>>> reclaim triggered by one memcg can scan inodes from the whole 
>>>> superblock
>>>> and split shmem huge folios charged to unrelated memcgs.
>>>>
>>>> Convert the shrink list to a memcg-aware list_lru. Queue each inode 
>>>> on the
>>>> list_lru sublist matching the memcg and node of the current tail huge
>>>> folio, so non-root memcg reclaim only walks candidates charged to the
>>>> reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
>>>> reclaim keep global semantics.
>>>>
>>>> The list_lru still tracks inodes while the actual split target is the
>>>> current tail huge folio, so validate the folio memcg/node during 
>>>> scan. If
>>>> the folio no longer matches the reclaim context or splitting cannot
>>>> proceed, requeue the inode according to the current tail folio; if the
>>>> inode is no longer shrinkable, drop the scan entry.
>>>>
>>>> This can be tested with the shrinker debugfs interface by allocating 32
>>>> tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs 
>>>> shrinker
>>>> with memcg A's cgroup id:
>>>>
>>>>                 before A scan        after A scan
>>>>    base         A=64M, B=64M         A=0,  B=0
>>>>    patched      A=64M, B=64M         A=0,  B=64M
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>
>>> Thanks for your patch. This work has been on my TODO list for a while :)
>>>
>>> Overall it looks good. I'll take a closer look and run some tests.
>>
>> Thanks!
>>
>>>
>>>> This patch is based on next-20260701 because it doesn't include this 
>>>> patch:
>>>>
>>>> https://lore.kernel.org/all/20260609123047.1948242-1- 
>>>> usama.arif@linux.dev/
>>>>
>>>> Later on, Usama will consider moving this restriction down into the 
>>>> fs callback.
>>>>
>>>>   include/linux/shmem_fs.h |  14 +-
>>>>   mm/shmem.c               | 379 +++++++++++++++++++++++++++++ 
>>>> +---------
>>>>   2 files changed, 310 insertions(+), 83 deletions(-)
>>>>
>>>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>>>> index e729b9b0e38d4..0b14de1e890a9 100644
>>>> --- a/include/linux/shmem_fs.h
>>>> +++ b/include/linux/shmem_fs.h
>>>> @@ -11,6 +11,7 @@
>>>>   #include <linux/fs_parser.h>
>>>>   #include <linux/userfaultfd_k.h>
>>>>   #include <linux/bits.h>
>>>> +#include <linux/list_lru.h>
>>>>   struct swap_iocb;
>>>> @@ -56,6 +57,13 @@ struct shmem_inode_info {
>>>>       struct dquot __rcu    *i_dquot[MAXQUOTAS];
>>>>   #endif
>>>>       struct inode        vfs_inode;
>>>> +
>>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> +    struct list_head    shrinklist_scan;
>>>
>>> Why introduce another list_head member? Why can't we reuse 
>>> 'shrinklist' in this structure? In other words, if we isolate this 
>>> inode from list_lru, then 'inode_info->shrinklist' can be reused to 
>>> link it into the temporary list, right?
>>
>> After list_lru isolation, the shrinker drops the list_lru lock and
>> processes the inode on a local scan list. During that time, shmem
>> faults can make the inode's current tail huge folio change, and
>> shmem_unused_huge_add() may need to queue the same inode again on
>> the active list_lru, possibly under a different memcg/node sublist.
>>
>> If we reused info->shrinklist for the temporary scan list, then while 
>> the inode is being scanned:
>>
>> 1. info->shrinklist would be non-empty because it is on the local scan
>>     list, so shmem_unused_huge_add() could not tell that the inode is no
>>     longer on the active list_lru.
>> 2. Re-adding it to list_lru with the same list_head would corrupt the
>>     local scan list.
> 
> Right. Just some preliminary thoughts:
> 
> If the current inode needs to be re-added to the list_lru, it means the 
> inode's i_size has changed. If 'info->shrinklist' is on the temporary 
> list at this point, we can follow the same logic as the original 'info- 
>  >shrinklist' handling and simply skip the re-adding to list_lru. 
> Instead, we can let shmem_unused_huge_shrink() get the end folio via 
> filemap_get_entry(i_size), and then check the memcg and nid — if they 
> differ from the 'sc', we can re-add the inode back to the list_lru in 
> shmem_unused_huge_shrink().

That also sounds workable.

> 
> Of course, there may be other races that need to be considered as well.

I will look into it.

> 
> In any case, we should try to avoid adding too many members to the 
> 'shmem_inode_info' struct, since when there are many tmpfs files this 
> could introduce noticeable memory overhead.

Got it.

Thanks,
Qi

> 
>> 3. Skipping the add would lose the new current tail huge folio if the
>>     scan later drops the old scan entry instead of requeueing it.
>>
>> So isolation removes the inode from the active list_lru and leaves
>> info->shrinklist empty. A concurrent fault can safely add the inode back
>> to the active list_lru with the current folio's memcg/node, while the
>> shrinker still owns the old scan entry through shrinklist_scan. The scan
>> loop then detects that re-add and drops the stale scan entry, leaving
>> the active entry for a later scan.
>>
>>>
>>>> +    struct mem_cgroup    *shrinklist_memcg;
>>>> +    int            shrinklist_nid;
>>>> +    bool            shrinklist_isolated;
>>>
>>> Do we need an extra bool to indicate whether it's isolated? Can't we 
>>> just use 'list_empty(inode_info->shrinklist)'? I may have missed some 
>>> details.
>>
>> list_empty(info->shrinklist) cannot be used for this. That list node 
>> tracks active list_lru membership only. But you are right that the
>> explicit bool is not necessary, we can use list_empty(&info- 
>>  >shrinklist_scan) instead.
>>
>> Thanks,
>> Qi
>>
>>
> 


