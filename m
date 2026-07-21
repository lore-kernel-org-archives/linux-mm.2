Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE0BDC44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 01:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B87C6B007B; Mon, 20 Jul 2026 21:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569826B008A; Mon, 20 Jul 2026 21:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A346B008C; Mon, 20 Jul 2026 21:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04B2C6B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:50:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67BF4140317
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:50:03 +0000 (UTC)
X-FDA: 85011103086.19.7A9850B
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 35B2280006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:49:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784598601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/b0G6WHeMWneAV9LiWKjIuvcWRtlftLQ08PEtj8XSIQ=;
	b=WsttQYbw1We26b0gAgKNLQXGGZOfo5p8WsoAuiFuIxXmIJpfFxdceGROrkjRv6qI39ZPas
	xHAh5m+P4p1ErTeqhY42oz0OOBj8/AjAoY0cQeL9CsHNTYNjHZykmo2P3yMZDFPoMCsaqH
	Sr3AyCfFMunD37/gCsN3XZpCud/biag=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784598601;
	b=WHzvkWljNRqFr6GRl23yfkg6/KGoJXqUzoujZB99OsiCrCZHZidEPwQwK/e9356leTm1m8
	85LPXYeTqmzbCssnO1TF6LvpDLG/WCuMbWxT0DlXm1Q11f4eQURk5oQAH9MjZ3rMk9/tll
	h4PxXtPTAzpAsQHolxiZpzYtmnIVkd0=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h40gD5sZlzYQvLv
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:49:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 5BF9C4056E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:49:55 +0800 (CST)
Received: from [10.166.163.161] (unknown [10.166.163.161])
	by APP2 (Coremail) with UTF8SMTPA id Syh0CgBnTChB0F5qlpbtBw--.23847S2;
	Tue, 21 Jul 2026 09:49:55 +0800 (CST)
Message-ID: <0884d36c-06b3-4df1-8fd2-8abc9e6c97ee@huaweicloud.com>
Date: Tue, 21 Jul 2026 09:49:53 +0800
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
From: Kemeng Shi <shikemeng@huaweicloud.com>
In-Reply-To: <al3mWmCN3lNv8jMu@yjaykim-PowerEdge-T330>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnTChB0F5qlpbtBw--.23847S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyUuFykCF1ruFW5KF1Utrb_yoWrtF4DpF
	ZYgas0kF4rXr9xGrsxA3WqgryrWw40gr9rJa1fKr1293ZxZr1fWFn2yrZ0vFyDCF1kJFn0
	gr1Yq3sruanYka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Queue-Id: 35B2280006
X-Rspamd-Server: rspam01
X-Stat-Signature: nt93ij4pyforr8if1dtod9r9pez4twba
X-HE-Tag: 1784598599-278440
X-HE-Meta: U2FsdGVkX1+NOvfGsIcZptydewZWaxLmUkv8r+Cm/kS3RRvJkXf0QqLNJfbGDXVnotLOMHWBmEfwT/om1CKf5FRUVtjf0IUAMAtC6hYY2XN6+gztwRjdx2w5H0Lrcd6934csI499dRPk+UpA4ZcYMiMJccxfkeZEzQv47bup44TPO6M8mHvAVIb2cM267EHEuHiZ0F24T6V7Zu41IRzoapCa2ptQnxnUXj2YgUlBtyqXgBwXWmYr9ShbYpvrTYFZAFj74JiZDuYaikIrPAdVwgrkz0LH/2U/6eX32XvJg3NxV2x8ZmcruRaOncWSPyzADiQ9+JfAXIOS4l/mL7q+IqzKws/hAXPE06ENcZQyrarvGZq3teGbjl7SNZCqdGIH7Xs8xl4ygn7HK8S9KMC+iH4UAm2CHIVk7pbOokjz+6Lf31iubzodJoVqsIUGKGdHE4s9qV9qlPVVStDUua1l70wj4d/I6uwIcTEB6XwZRc/VLWAgT1ip9hDcX5q8XLqBZ+8KrrRtcInEZWCLBoOS9NO+TvWWPwY1AuhW51Mp94ZYoKCIAatCsjujn83n6y+In7MP8L20ShYtm/bPhX5Rh/1PpXqtplN6IdFZ2ijKxvNgphEwpiLnLO4LhtujwOje87NOCSWHdDWR4Ss7v3rFy577OuW+T8OeBuEIjh24qrAlwh87gy2wwqYeMdjycZ9sy1UufhhqXvinGQQTOO0/U4v/FZo6WD3PF4TZSSP9eF1TWMde5fDZYB4PgIkmCWM0MDpR8i3xhdbKPR+9Tmk1nkS1CZP8+Q5sWm9LVWjMaT4CUK+82F5qON6WmWIQWoE2co7ZE2sRzAFBoulJSgedDmkjTmr7XgugjwqCzWBKEE+d69JecrDtJoCQLa3WmSYwYZ0tqCaTArwaj1VljLvQ6mM4PdMld732kMV4Y37Ivr/0NGuvSrLpxuST+QrCqS+ajF76MAftoOLg+rF5laj
 KYb80DOP
 1SLp/FtMVFfwb8Gv39UI6opY2RfD3qMC6D6OxeGkHqdsiOwnxXREElXde8KiuJR7wv10noD3CtCBpsgyhyhrfxY0nL+5enJs4gR6UeHkSH9bJbI7ohQeW8v+djdNYF4e5poarb6nxu6LLLjW9kZFmEiXclTnBk/BJm8U2KEt/GJk+4eaOukATO7KM/FkCAN5mdVxImOBOfUkm/dY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/7/20 17:11:54, Youngjun Park 写道:
> On Mon, Jul 20, 2026 at 03:13:39PM +0800, Kemeng Shi wrote:
> 
> Hello Kemeng Shi,
> 
> Good catch!
> 
> it indeed looks like a possible race condition 
> (though I haven't verified it at runtime either).
> 
>> The root cause of this issue is because multi-tables are updated in non
>> atomic context. To be more specific, the issue could be triggerred as
>> following:
> 
> Here the cluster is isolated (CLUSTER_FLAG_NONE).
> 
>> swap_alloc_fast         swap_cluster_populate()
>>                          /* Try a sleep allocation */
>>                          spin_unlock(&ci->lock);
> 
> And from here, the table becomes visible,
> 
>>                          swap_cluster_alloc_table()
>>                           rcu_assign_pointer(ci->table, table);
> 
> All entry on this cluster is freed(e.g process dead) , 
> so this might be the free cluster.
> 
>>  ci = swap_cluster_lock(si, offset)
>>  cluster_is_usable(ci, order）
> 
> Since it's a normal cluster (CLUSTER_FLAG_NONE) and the table exists,
> it passes here...
> 
>>   if (!cluster_table_is_alloced(ci)) // ok 
>>  alloc_swap_scan_cluster()
>>   cluster_scan_range()
>>    __swap_table_get()
>>
>>                           /* free table when more table allocation fails */
>>                           ci->memcg_table = kzalloc_obj(*ci->memcg_table,
>>                                                         gfp);
>>                           if (!ci->memcg_table)
>>                            swap_cluster_free_table()
> 
> Nullified
> 
>>                             rcu_assign_pointer(ci->table, NULL);
> 
> Now it happens.
> 
>>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
>>      atomic_long_read(&table[off]); // NULL dereference
>>
>> Fix the issue by updating allocated tables in atomic context.
>>
>> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
>> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
>> ---
>>  mm/swapfile.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 615d90867111..d29062d9c3cd 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -490,6 +490,20 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>>  	return 0;
>>  }
>>  
>> +static void swap_cluster_copy_table(struct swap_cluster_info *d_ci,
>> +				    struct swap_cluster_info *s_ci)
>> +{
>> +	rcu_assign_pointer(d_ci->table, rcu_access_pointer(s_ci->table));
>> +
>> +#ifdef CONFIG_MEMCG
>> +	d_ci->memcg_table = s_ci->memcg_table;
>> +#endif
>> +
>> +#if !SWAP_TABLE_HAS_ZEROFLAG
>> +	d_ci->zero_bitmap = s_ci->zero_bitmap;
>> +#endif
>> +}
>> +
>>  /*
>>   * Sanity check to ensure nothing leaked, and the specified range is empty.
>>   * One special case is that bad slots can't be freed, so check the number of
>> @@ -527,6 +541,7 @@ static struct swap_cluster_info *
>>  swap_cluster_populate(struct swap_info_struct *si,
>>  			 struct swap_cluster_info *ci)
>>  {
>> +	struct swap_cluster_info tmp_ci;
>>  	int ret;
> 
Hello, Youngjun

Thanks for feedback.> IMHO, How about resolving everything inside swap_cluster_alloc_table() instead?
> 
> We could consider the following two things.
> 
> - Assign the table at the very end inside swap_cluster_alloc_table().
> - Handle the table freeing properly if subsequent allocations fail.
> 
> Rather than allocating a temp_ci (which adds special handling
> for this case), wouldn't it be better to maintain the original intention
> of the swap_cluster_alloc_table() function?
> 
> Although this is not a hot path and table allocation will usually succeed with
> the ATOMIC allocator, this approach would also save the memcpy overhead
> and stack memory usage.
Yes, it will be better to handle the issue inside the swap_cluster_alloc_table()
and I also consider this before. However, I didn't find a way to properly handle
the lock as swap_cluster_alloc_table() will be used for both ATOMIC allocation
and sleep allocation. So what about introduce a new helper like:
swap_cluster_alloc_table_unlocked()
{
	table = kmem_cache_zalloc()
#ifdef CONFIG_MEMCG
	memcg_table = kzalloc_obj()
#endif
#if !SWAP_TABLE_HAS_ZEROFLAG
	zero_bitmap = bitmap_zalloc()
#endif

	spin_lock(&ci->lock);
	/* update all tables in atomic */
	spin_unlock(&ci->lock);
}
In this way, there are some repeated code, so it is also a little ugly...
I will appreciate if you have any better idea!
> 
> (Another option might be checking memcg_table and zero_bitmap inside
> cluster_table_is_alloced(). However, I personally dislike this idea as
> it might introduce side effects regarding its coverage.)
Yes, I also think we should try not to introduce any cost in hot path.> 
> Your current approach is also a good direction, but please review this
> idea as well :)
> 
> Thanks,
> Youngjun


