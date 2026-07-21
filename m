Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65AFAC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50EAE6B008C; Tue, 21 Jul 2026 02:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE656B0096; Tue, 21 Jul 2026 02:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBA96B0098; Tue, 21 Jul 2026 02:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4D16B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:12:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82F1516040B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:12:25 +0000 (UTC)
X-FDA: 85011764250.17.A050A5B
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id AC03020007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:12:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784614343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DaCathYsgsDVQRuU1H0n6jHM0UuuIDUu1vG3OL75lv4=;
	b=4VZbVj92htJtGlAPXh8XmEQUBUA5+IFDARtTK+JJbca1tIkHb4UHoh7VI7zpCXkaVG8mdG
	TMCDcJcXaov1PWVpOxMA78GP2huME4dyOe1yMgzj98Wq/ENLsLtkk+0Po7l+qxxVGSEusi
	YRoL+S9vHcrqNocWSS/jUQpUxcj1BVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784614343;
	b=IYBab9c40TEmIjEkr34tyYjzIo9tne3OGEv0udqjogPmFmulDy1tqWAYXNBBHbNekVgBBO
	SSQ9SlJHQHtQWPo7BF4/zOgNGiLrOP4RWLBzEsvN2UB4PR92G+XZiBwjYADSJC9wGhhihs
	1hflu/Yx50ifoayq5YLCKnSFb19klLU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h46Tv40l0zYQtHW
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:11:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 6613540539
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:12:14 +0800 (CST)
Received: from [10.166.163.161] (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgCHUaK8DV9qC63yBw--.2432S2;
	Tue, 21 Jul 2026 14:12:14 +0800 (CST)
Message-ID: <76738b02-1f12-4deb-84f7-542d9830b0b5@huaweicloud.com>
Date: Tue, 21 Jul 2026 14:12:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm, swap: Fix potential NULL dereference when trying
 a sleep table allocation
To: Youngjun Park <youngjun.park@lge.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-2-shikemeng@huaweicloud.com>
 <al3mWmCN3lNv8jMu@yjaykim-PowerEdge-T330>
 <0884d36c-06b3-4df1-8fd2-8abc9e6c97ee@huaweicloud.com>
 <al7WTNXanPVSELAH@yjaykim-PowerEdge-T330>
From: Kemeng Shi <shikemeng@huaweicloud.com>
In-Reply-To: <al7WTNXanPVSELAH@yjaykim-PowerEdge-T330>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHUaK8DV9qC63yBw--.2432S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AF17tFyrZFWfCrWfAF1DKFg_yoWxtFW3pF
	4FgF90kF4rXr9xWrsIvw1qq34rtw40gr1DWr4xJr1293ZIqr1fWF1xArWY9FykuF1kJF1q
	qr1UK347uFs5AwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Stat-Signature: z1wppje7858d1bqns6wr8sz3kr7zrajw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC03020007
X-HE-Tag: 1784614341-163775
X-HE-Meta: U2FsdGVkX18Kz9lo8d7/jnW6Y5h2+0bX5xLWyLYFERTWaZXIHQe+IorCxb53znfsvXxNbuj+KvbjzF/DPP5u3gP+Md9F4oZgvdeeaRizibytL4n3CBRkC3UjSip19kyp/xWB2Dwfi/q1tqDYpObol2FXHU/8fEmkS2ERk3yFvR+BkOWs5whGRGaJJNvxhkVkAFvShK7KRzAqA/TBnSTo6cGz0/krZkLbz2c39JD7gRow6H4m3BJ5nKo6SH6bSk/pheGV+8ATayu6ijkJlqAGeTl9e8s8Tv8ChK/mxZPHYLD7cNXJXNLf5JuNjmXEuWG9r4K78mt1TU6PzLT83X8t/3l2ykkVjK838eCCrtLjVdDd+7iLfqjp3Gs15ML99nI+s4iWIZJ3hcVOfnxDVM6FK0EnUFJYI7SU+SW+YnEXRROH5wrmYq6FFcT66xtfJvPwWsRQJ1D8NwgnGCixkmtvDyO4tKMXqbnGfI1lijQSTT5/b3nZ7yNT+YX0Jj96hRZTMBjo1/dQmYpSxR6afWMWp5OsYq6zaZCKiMl3TE/KL/j4cJjPpu68dk73ReO2198mfy3pSWiwuHUQlT4WqcKjwt053Somzk8XJzQKksy0fXmYa84nr71crkKtbouTXmjlewWqjqRxMDVgfb2BzegJbX6a8xyoVOpN7usfg72nkfDYsUGGpBMD0jX/eXLHMQ8ZalD2JEwQHfIECM6Vxnq1A22ri3Y4rotlptoCRMiQ8NwyZI9K1+JWhxi9OnCUZD+L7IeTV2gJ96plwVbknICS3bcvpNffJ4rB2ZsH08I/emCIFRESBePlgiYINp2FuRJZT0d5pMm2pE5NzRkmuI0TpCgDn/hRAG1Gzp+yg069KPscMa0ivD25wCNhHJ/86ymCnD+Sejm6ymBOfTKpeL7Zt4hCNllq22EiQ6mIv2izKewqp8cDCKWnIEOCbX1rUd04N3/S1zizXA68JeU1rf1
 yOg65yR4
 zQWwg5meaJbD/j7oTLs/FJQFCAXekhmp+hsGHR2Jh1Hkx7/gKR+uS250w4Hik2jLtkVntMtaFuUj8aZzIlTRw35bg39fYtrPH1Atm3MstVh+0RjP4ELHu0AkgjV+NUrQmANDC8mhjSmKdeVN/YbQ6fKNxmbxAACqq9TSy4b20xhyLM6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/7/21 10:15:40, Youngjun Park 写道:
> On Tue, Jul 21, 2026 at 09:49:53AM +0800, Kemeng Shi wrote:
>> 在 2026/7/20 17:11:54, Youngjun Park 写道:
>>> On Mon, Jul 20, 2026 at 03:13:39PM +0800, Kemeng Shi wrote:
>>>
>>> Hello Kemeng Shi,
>>>
>>> Good catch!
>>>
>>> it indeed looks like a possible race condition 
>>> (though I haven't verified it at runtime either).
>>>
>>>> The root cause of this issue is because multi-tables are updated in non
>>>> atomic context. To be more specific, the issue could be triggerred as
>>>> following:
>>>
>>> Here the cluster is isolated (CLUSTER_FLAG_NONE).
>>>
>>>> swap_alloc_fast         swap_cluster_populate()
>>>>                          /* Try a sleep allocation */
>>>>                          spin_unlock(&ci->lock);
>>>
>>> And from here, the table becomes visible,
>>>
>>>>                          swap_cluster_alloc_table()
>>>>                           rcu_assign_pointer(ci->table, table);
>>>
>>> All entry on this cluster is freed(e.g process dead) , 
>>> so this might be the free cluster.
>>>
>>>>  ci = swap_cluster_lock(si, offset)
>>>>  cluster_is_usable(ci, order）
>>>
>>> Since it's a normal cluster (CLUSTER_FLAG_NONE) and the table exists,
>>> it passes here...
>>>
>>>>   if (!cluster_table_is_alloced(ci)) // ok 
>>>>  alloc_swap_scan_cluster()
>>>>   cluster_scan_range()
>>>>    __swap_table_get()
>>>>
>>>>                           /* free table when more table allocation fails */
>>>>                           ci->memcg_table = kzalloc_obj(*ci->memcg_table,
>>>>                                                         gfp);
>>>>                           if (!ci->memcg_table)
>>>>                            swap_cluster_free_table()
>>>
>>> Nullified
>>>
>>>>                             rcu_assign_pointer(ci->table, NULL);
>>>
>>> Now it happens.
>>>
>>>>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
>>>>      atomic_long_read(&table[off]); // NULL dereference
>>>>
>>>> Fix the issue by updating allocated tables in atomic context.
>>>>
>>>> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
>>>> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
>>>> ---
>>>>  mm/swapfile.c | 21 ++++++++++++++++++++-
>>>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>>>> index 615d90867111..d29062d9c3cd 100644
>>>> --- a/mm/swapfile.c
>>>> +++ b/mm/swapfile.c
>>>> @@ -490,6 +490,20 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static void swap_cluster_copy_table(struct swap_cluster_info *d_ci,
>>>> +				    struct swap_cluster_info *s_ci)
>>>> +{
>>>> +	rcu_assign_pointer(d_ci->table, rcu_access_pointer(s_ci->table));
>>>> +
>>>> +#ifdef CONFIG_MEMCG
>>>> +	d_ci->memcg_table = s_ci->memcg_table;
>>>> +#endif
>>>> +
>>>> +#if !SWAP_TABLE_HAS_ZEROFLAG
>>>> +	d_ci->zero_bitmap = s_ci->zero_bitmap;
>>>> +#endif
>>>> +}
>>>> +
>>>>  /*
>>>>   * Sanity check to ensure nothing leaked, and the specified range is empty.
>>>>   * One special case is that bad slots can't be freed, so check the number of
>>>> @@ -527,6 +541,7 @@ static struct swap_cluster_info *
>>>>  swap_cluster_populate(struct swap_info_struct *si,
>>>>  			 struct swap_cluster_info *ci)
>>>>  {
>>>> +	struct swap_cluster_info tmp_ci;
>>>>  	int ret;
>>>
>> Hello, Youngjun
>>
>> Thanks for feedback.> IMHO, How about resolving everything inside swap_cluster_alloc_table() instead?
>>>
>>> We could consider the following two things.
>>>
>>> - Assign the table at the very end inside swap_cluster_alloc_table().
>>> - Handle the table freeing properly if subsequent allocations fail.
>>>
>>> Rather than allocating a temp_ci (which adds special handling
>>> for this case), wouldn't it be better to maintain the original intention
>>> of the swap_cluster_alloc_table() function?
>>>
>>> Although this is not a hot path and table allocation will usually succeed with
>>> the ATOMIC allocator, this approach would also save the memcpy overhead
>>> and stack memory usage.
>> Yes, it will be better to handle the issue inside the swap_cluster_alloc_table()
>> and I also consider this before. However, I didn't find a way to properly handle
>> the lock as swap_cluster_alloc_table() will be used for both ATOMIC allocation
>> and sleep allocation. So what about introduce a new helper like:
>> swap_cluster_alloc_table_unlocked()
>> {
>> 	table = kmem_cache_zalloc()
>> #ifdef CONFIG_MEMCG
>> 	memcg_table = kzalloc_obj()
>> #endif
>> #if !SWAP_TABLE_HAS_ZEROFLAG
>> 	zero_bitmap = bitmap_zalloc()
>> #endif
>>
>> 	spin_lock(&ci->lock);
>> 	/* update all tables in atomic */
>> 	spin_unlock(&ci->lock);
>> }
>> In this way, there are some repeated code, so it is also a little ugly...
>> I will appreciate if you have any better idea!
> 
> Hello!
> 
> I don't quite understand why we need to introduce a new helper function.
> Is it because the table assignment must be done strictly inside the lock?
> In successful cases, wouldn't it be fine to assign the table without holding
> the lock? (Please let me know if I am missing something here.)
> 
> If we just add error handling to free the allocated table inside
> swap_cluster_alloc_table(), swap_cluster_free_table() will properly free
> memcg_table and zero_bitmap as long as ci->table is not assigned yet.
> I don't think this will cause any issues.
> 
> My intention is something like this:
> 
> -       rcu_assign_pointer(ci->table, table);     /* Remove this */
> ...
> 
> #ifdef CONFIG_MEMCG
>         if (!mem_cgroup_disabled()) {
>                 VM_WARN_ON_ONCE(ci->memcg_table);
>                 ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
>                 if (!ci->memcg_table) {
> 			+ free table
>                         swap_cluster_free_table(ci);
>                         return -ENOMEM;
>                 }
>         }
> #endif
> 
> #if !SWAP_TABLE_HAS_ZEROFLAG
>         VM_WARN_ON_ONCE(ci->zero_bitmap);
>         ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
>         if (!ci->zero_bitmap) {
>                 + free table
>                 swap_cluster_free_table(ci);
>                 return -ENOMEM;
>         }
> #endif
> 
> ...
>         /* Assign here! */
>         rcu_assign_pointer(ci->table, table);
> 
> 	return
> }
> If it becomes visible at the very end, wouldn't it be safe from any issues?
Sorry, I misunderstand what you mean. I think this is a better direction!
As we rely on memory ordering, I'm checking if we need add memory barrier
betwwen access ci->table and zero_bitmap or betwwen ci->table and memcg_table.

On write side:
rcu_assign_pointer(ci->table, table) will offer release to ensure
zero_bitmap and memcg_table visible before ci->table.

On read side:
folio_alloc_swap
 swap_alloc_fast/swap_alloc_slow
  /* access ci->table under cluster lock */
  swap_cluster_lock
  cluster_is_usable
  ...
  __swap_table_set
  ...
  swap_cluster_unlock
  
 mem_cgroup_try_charge_swap
  ...
  /* cluster lock will ensure order betwwen ci->table and memcg_table */
  swap_cluster_get_and_lock
  __swap_cgroup_set
  swap_cluster_unlock

swap_writeout
 swap_zeromap_folio_set
  /* cluster lock will ensure order betwwen ci->table and zero_bitmap */
  swap_cluster_get_and_lock
  __swap_table_set_zero
  swap_cluster_unlock

So I think we can fix the issue in this way and I will do it in the next
version. Thanks for this great idea.

Kemeng Shi


