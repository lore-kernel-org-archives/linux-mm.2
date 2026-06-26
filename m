Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D112BCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F946B00AC; Thu, 25 Jun 2026 22:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8826B00AD; Thu, 25 Jun 2026 22:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37A06B00AE; Thu, 25 Jun 2026 22:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB2F6B00AC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:27:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B7691C5F60
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:27:53 +0000 (UTC)
X-FDA: 84920478426.07.C469474
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7D02F20002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:27:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dvmQTEAx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782440871;
	b=pSJvTpN1JTm/kCw229WOxxJ8UnC2MyK2PNyUkIPSxe0FC3nFHGcP3bOH9MCOFq0GYi9cfl
	UyaPSm2TshWHA3OfEOGipi+dje8Naqk21IzyNUGAOjhZosXlu+0InzyekMTBkPLqff6Ad1
	BbsrVdYWK58gnPbd6nI5o+nQ3K0ws5s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782440871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h48iMyZJeOBo8mJP1NqWzlLxC6G6uq5RUz9cl4e400U=;
	b=4nUpx/WkeSSBamPisQwvd2RySEPl3tgenOxWqdD4DHytquI2l/bSwOX1lRJTIi7Dpl8Fwu
	rTqVsNr8EojZijH1LOReRS4l19QdOrd15tqWggBDHFXu0PH/zMlHWn4Q4xarl+Jce3RP6S
	Aa71Ove0bgs+Yqm81E29u9OxUsN0IvI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dvmQTEAx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782440870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h48iMyZJeOBo8mJP1NqWzlLxC6G6uq5RUz9cl4e400U=;
	b=dvmQTEAxG5XVvmLYAb9HPsG9G5ggSSpuxSDd7nJhF49Q3rVYDso9H+zUiwWAzS6atUFeTa
	qZuLIm3ICeB8mEy2FSb0+fsLykYl2eJo+gz4kNIXZ+dkof0bMk05AS39jZVd0ZHrPMV5tr
	T2tb07g13wox1UbYqeJLskElVUNfOFs=
Date: Fri, 26 Jun 2026 10:27:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, harry@kernel.org,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj12aVq3he6q7b2C@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aj12aVq3he6q7b2C@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D02F20002
X-Rspam-User: 
X-Stat-Signature: 1s18yu3gi45oiz7ecruio8zbdhz9den8
X-HE-Tag: 1782440871-23315
X-HE-Meta: U2FsdGVkX19HbXOKOln2wkk/8e81FrcgeyQ8wL7XxBP5V5hElEaXCMpJYxhw1hB50qy8gOPbyzIpCAk7UksyPvudr8GHPgUq6MtCIG64sDTTs95GmtjNcmXHWu2LlcmZrxEDcxx8yvGXGYJyzGtWJj0IJYwBA8QE2Xi1QB1FTmBPs1OFAvrRk/wqft8kNSRrDjKjh7cQWteoBpgIUJxvSpVgNzN+Yj7B0iDh/0pFLCqgdYLH2KJUBwzUMcqVqBkHiUx/9O2hIUnXW7L/H6QR9vP7tHgNFyLcP2pE6KcUpj0wd+JOlJN8hRpTNiTQ4ct0M8Goa0Cm1WRfWRRSy6V1NODlafziq3ky8FBz42esyXnSHl+OCT9wS/mr9vZKpaJeOXIQHWD5twW+QKMBsdRC4sb6VMTpi9Fe0pVNiKaY1RwyhRnb9JsYbaPtjLE9HH4VQm7jJvFlcDdFWamPlfByOHozidvt8XWSjA39G1RIhkF7xi5b1vhkumf9jHoP3XowM+IPGOyBZ1rPZAP1lUkhqdvc+CAmJMAReGV6WcFaePjoxV4Qajt0PzAyj1lTb2vtCslkQ9R1u4+5MHuWPgZUe6dHT9WwA6A7/in/3QBR2UvwDWHaKMBHi1SZl3FUFfKHIzKwcqIn2t+5HI5z6QESPCVqmMZmIbZ0y0oJWHsU6MGTvV+63kFsRAm0hR2/biCrHNU9iQSRLaWslJuphTyxkGX8+0NOK8yWYyKTQ/F4QP79hk7eAFF+M8btv0S/76Y3A4MRkNK0DdThmHuAOWw1hdWQWOaigitwm3CsUyxKzMWhcHO+5f67i/j8jrEnlWowbzbqgqLAZEqggP60aa8uLEV04Eg2cppI95WGQcfVyAX4efBr23S40MsyE4GzTYj8yKrbcZ22j+KHFCvfH8A2CDK5NZPONb42UbkIDTe6XdC0CA/r0wNKsqoOI7ZMx0DwAYNJfDnY1ClawVB+4U6
 KgYC2Yg8
 kuCDoBqQO8lB51jq23rTweN7JCWu4qSPi8hQ0OXOxvCYgDRKKSH6ulWUYZ85N+P5QD7jWZ/Wt1Wx/lCAeqOkdAkFI2W6EvOMgpfv/FWWed+bqcfYGZdzueu19U+CsmjXnOQsDZzYf4uGfSPNLmvr+HIqCycw2GljEpYwJFqdcYBAUK6wCHDpl+woluNXtJ7h08VYgtLEhCcspgXFV0hlU1ODPUPIGQ6fCWbmthWzet/QUExNBaC9F3cJIcwI7GoZW1wrW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On 6/26/26 2:41 AM, Johannes Weiner wrote:
> On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The mglru page table walker batches per-generation size deltas in
>> walk->nr_pages while walking page tables without holding the lruvec lock.
>> The reset_batch_size() later folds those deltas into walk->lruvec under
>> the lruvec lock.
>>
>> The page table walker can run concurrently with the memcg reparenting path
>> as follows:
>>
>> CPU0                           CPU1
>> ====                           ====
>>
>> walk_mm
>> --> walk_page_range
>>      --> update_batch_size
>>          --> walk->nr_pages += delta
>>
>>                                mem_cgroup_css_offline
>>                                --> memcg_reparent_objcgs
>>                                    --> lock lruvec
>>                                        lru_gen_reparent_memcg
>>                                        --> reparent child folios to parent
>>                                        unlock lruvec
>>
>>      lock lruvec
>>      reset_batch_size
>>      --> child lrugen->nr_pages += delta
>>
>> This will trigger the following warning in lru_gen_exit_memcg():
>>
>> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>> 				   sizeof(lruvec->lrugen.nr_pages)));
>>
>> And the user-visible impact of underestimated nr_pages in MGLRU was
>> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
>> reaches zero, but there are still more pages.
>>
>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>> flushing the pending batch. A non-dying memcg keeps the original lruvec
>> stable against RCU-delayed offlining; a dying memcg redirects the deltas
>> to the first non-dying ancestor.
>>
>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> Changes in v3:
>>   - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>>     (suggested by Harry)
>>   - update the commit message (suggested by Harry)
>>   - temporarily drop the previous Reviewed-by tags
>>     (since the sync method has changed)
>>   - rebase onto the next-20260624
>>
>> Changes in v2:
>>   - update the commit message (pointed by Barry)
>>   - collect Reviewed-by
>>
>>   mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 38 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 35c3bb15ae96..1ec8c23c72b9 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>>   	walk->nr_pages[new_gen][type][zone] += delta;
>>   }
>>   
>> +#ifdef CONFIG_MEMCG
>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>> +{
>> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>> +
>> +	rcu_read_lock();
> 
> Where is this unlocked?

The lruvec_unlock_irq() in reset_batch_size() will handle the unlocking.

> 
>> +	/*
>> +	 * The memcg can be NULL when the memory controller is disabled.
>> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
>> +	 */
>> +	if (!memcg || !css_is_dying(&memcg->css))
>> +		goto lock;
>> +
>> +	do {
>> +		memcg = parent_mem_cgroup(memcg);
>> +	} while (memcg && css_is_dying(&memcg->css));
>> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> 
> 	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> 		memcg = parent_mem_cgroup(memcg);
> 		lruvec = mem_cgroup_lruvec(memcg, pgdat);

There is no need to acquire the lruvec before finding the first
non-dying memcg.

Thanks,
Qi

> 	}


