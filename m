Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E30C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E776B0093; Mon, 20 Jul 2026 22:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C360B6B0095; Mon, 20 Jul 2026 22:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73C96B0096; Mon, 20 Jul 2026 22:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0AE6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:21:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F384BC0361
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:21:35 +0000 (UTC)
X-FDA: 85011182550.10.5A8C8EF
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id C240A140009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:21:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784600494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OYAPq44wYI5s+aqmYwtG5kVnAEXbVfZSKfS1FN1XcQ=;
	b=aJyHuZHmmHPzH1ADWSvMUXEHYN5IbwTl6d/tO+IuhgsbOJkw5jGEk+wBKgLUq415KPUZkh
	i/OcnnncPtR6LMzvDK7BpVxMRhXxu3a/F+JKtzhnNoD3jGyZ63eGWn8VJhuJPbH6emnJN7
	yBzCfw8M/ZJ9k2ZVMhpAKKTfqSi9HJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784600494;
	b=fP0u1OExvzN7qoyvUl5dXgPvJQuBhgVA+IVva//Ce/b5jDfOAb/sUzUeANNU8VYBDyPjIQ
	cLrf6tk8RJjf3UqLlZ1vsKsK8EqKzs/efsnJYhzbFOoIC2ZAeu8xrMiZ6jyYrFqxnbAF02
	JsApSHTIYefTzJgN0r1mLiTBV4AjjOk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h41MY0lcyzYQtqW
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id AAA494057C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:21:23 +0800 (CST)
Received: from [10.166.163.161] (unknown [10.166.163.161])
	by APP2 (Coremail) with UTF8SMTPA id Syh0CgD33Cif115qK0rwBw--.29067S2;
	Tue, 21 Jul 2026 10:21:20 +0800 (CST)
Message-ID: <d47f870d-4065-436b-a8ad-9d4b2116d2ad@huaweicloud.com>
Date: Tue, 21 Jul 2026 10:21:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm, swap: Fix potential NULL dereference when trying
 a sleep table allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-2-shikemeng@huaweicloud.com>
 <al3WqZ45Tapey-eB@KASONG-MC4>
From: Kemeng Shi <shikemeng@huaweicloud.com>
In-Reply-To: <al3WqZ45Tapey-eB@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgD33Cif115qK0rwBw--.29067S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWryktr45GryUAFWrKryfZwb_yoWrXr1kpF
	nYgF90kF45XrnrGrsIvw1DK34agw40gryDG3WxGF1I93ZxXr1xWFn2krWYvFyDCF1kJr90
	qF1jqw17uan8Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbmii3UUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C240A140009
X-Stat-Signature: d9fffyo9rgqmcahejaiw8djhh1kiwnh9
X-Rspam-User: 
X-HE-Tag: 1784600491-72064
X-HE-Meta: U2FsdGVkX19VnvLmmm+44tGGltaOdnX6OBvsSiC3+YJ5391D7QqXzyD0QQoqxaFEm1AR7ZE832ldhJfhpgO1P991aVasy/DQ+iv0PeWcAXeB7iSNcxRjEGk+I/Dr035ae36J6LmeQ0umG+T2u0Zi7afp/4hQOrmAGa2OEV+uITFZfnbQCWoJMY1Mvkwdv8FKB83xUeTYI8jHwKLlkxG/wEwJBxV1vpo3iWOGMGSM/HD/Lqpd8o5JP0M2Pl+jSQ0DT+SWOp7fseK6cIiaebaX5Vcfhuk957qJD6fyMgQ4uEF0KvUGsd8uCIfsSfHWCR0bhXTAWA91fw6qjs9n1+wwX127BWB7rGTDrCMD0Guh0BJCdh/Um7fvRg/S69WKLlQTp9fH7QmH2FQBaWyIQlQfoqtDJaPGJDAiDwrjWST9ogX19KbqSCZUDwqj3gcTtMOiMvLfmTWrqNK4jvFh8gDNbYc+wXmOdS1By+/WNOB46IxrzvSeUUwTe+kcOFOsVBy+6h+mqvd74eyAiYXmitPaYHGUoDNUZLYz8jhsA0y5dnIn1fHe1AYkQRZMCP82cVasDB6M1tTSJSKdlU9YhDPEn0Jow4FEyS6Fc7X9JUeymbT7hccl0WSE6oFaSr1bz/gfTzY2rkKAXypUxg0jagQgw57DJgwS/w3Q3b/e0+YY/vpe8+ba4SCdUbvDusfwzTO5Dg/vXCWoXdrL0ouo+zT/7TOZDCeG3cnHxwx6kM2E/FaIFILVnfgVop/w7dSDbLj1iOVgfAQUxG2C0CTtm5SMJvpCcrbJdpQy7+/nkqOW9nGH4yTmtlNM17ZPFB76gJE+sxUSw9QD1GNIIRjaEK/cdd8EKpGCaEyXmizxTfwXLHnp+/N6IWc8pLc2pySpvpgw08H7q/ROYSEvfY6VVn5EYmZUfsN3jF8cpPr3PeLzzwhyjFBF57DyaTwxfD+zKe6J5k+W3Na6gVeRVM5rWiN
 03ls6TgH
 b6V9Mn/WOxsgJuC4K53mgbbx8dxCaLA2aJMmOl0ba9SU3aaBIyjRiCDD4ZhpekrD5HDctvZWWuF3qSy3nVF1T1LHiYFy5kOLdsUrqWmTMXLpZzw3xUrbC1q7RzSV/Iqxeq1qeSFT5pbvgSfwo86aWigZqU6aEZjDxcM2oKQCynVii4e3xBRTlY6NgqE8v+hfjQVn/kgt60Q21JxiaNVApEsPJSKK6z07uOEA4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/7/20 17:11:58, Kairui Song 写道:
> On Mon, Jul 20, 2026 at 03:13:39PM +0800, Kemeng Shi wrote:
>> The root cause of this issue is because multi-tables are updated in non
>> atomic context. To be more specific, the issue could be triggerred as
>> following:
>>
>> swap_alloc_fast         swap_cluster_populate()
>>                          /* Try a sleep allocation */
>>                          spin_unlock(&ci->lock);
>>                          swap_cluster_alloc_table()
>>                           rcu_assign_pointer(ci->table, table);
>>
>>  ci = swap_cluster_lock(si, offset)
>>  cluster_is_usable(ci, order）
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
>>                             rcu_assign_pointer(ci->table, NULL);
>>
>>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
>>      atomic_long_read(&table[off]); // NULL dereference
>>
>> Fix the issue by updating allocated tables in atomic context.
> 
> Thanks, that's a really tricky one, good catch.
> 
>>
>> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
> 
> This commit doesn't exist, you mean b197d41462c2 right?
The commit 2fe7a6f5024b8 and b197d41462c2 both exist in this tree:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git.
I search in another tree and only your commit exsits, so I believe
your commit is correct. Will fix this in next version. Thanks for
correction.

> 
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
> 
> Nit: The name is a bit misleading, it not copying the table content,
> just filled the d_ci with s_ci. And do we really need a helper for this?
As swap_cluster_alloc_table() grows from only table allocation to table,
memcg_table and zero_bitmap allocation. So I think maybe a helper may
inform us not to forget to do copy when new member is added. But I also
think about open-coding it. So both ways look good to me. I will open-code
it if you prefer it. :)> 
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
>>  
>>  	/*
>> @@ -552,7 +567,8 @@ swap_cluster_populate(struct swap_info_struct *si,
>>  		spin_unlock(&si->global_cluster_lock);
>>  	local_unlock(&percpu_swap_cluster.lock);
>>  
>> -	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
>> +	tmp_ci = *ci;
>> +	ret = swap_cluster_alloc_table(&tmp_ci, __GFP_HIGH | __GFP_NOMEMALLOC |
>>  					   GFP_KERNEL);
> 
> This allocation could be largely simplified with mempool, the reason I didn't
> use that is due to lack of RCU support, which can be done later to clean
> this up.
> 
> Please fix the Fixes tags, other parts are mostly fine, thanks agian!


