Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4997CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487898E000C; Mon, 13 Oct 2025 03:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438708E0002; Mon, 13 Oct 2025 03:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375248E000C; Mon, 13 Oct 2025 03:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26F4F8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:28:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E55731DE8F0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:28:43 +0000 (UTC)
X-FDA: 83992263726.24.FF8A323
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D9D540012
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:28:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O1Zjb7eQ;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760340522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkLKvSUaQ4BnGmUhizr6OnCKnUnuAC5ZuO6XhuLGhRQ=;
	b=1Y41YE3z1xXuINNcLf1NrAQMCHBhrCC54vdXySPHCKB4DHbwZQE7FEblxasjp3x9kdGk8/
	uIKqri4ih6tZnsJlOnAcSMibAKp/nJNTqM2kPko9S+zHCqgmf/FjK/nMAo89BR7VK2YRoq
	yBIJTxlIpfh2hqh8jaC6AWvVwyFBhgA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O1Zjb7eQ;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760340522; a=rsa-sha256;
	cv=none;
	b=BADVx5BdwO8jPZuP7iCUBIWpmHPK1JQx1oNJa9YC7AP2AtmS3uKLqjMVROCXQX9fREWiUs
	dL0CbQ0XITATg3PBdS4SRvP42UJ/dFCyGkC41bt9CN697LuOx399odmkCWHfp8Xj7Fdsay
	Dlvz/LD6TLfWPWwV5VAIOXpZMgrouXk=
Message-ID: <ba2ec325-72d1-4a11-943f-b36a090cb68b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760340519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IkLKvSUaQ4BnGmUhizr6OnCKnUnuAC5ZuO6XhuLGhRQ=;
	b=O1Zjb7eQu5+hY64dyZyuiEp94+2tjMc+TNk3zePZG8N6CXTZ9bs0B6nz5bcpd/RRprCWyi
	k2CWFu4wddIDJRoOQUQZIyP/lCul2iotxNRRoGS2Rd2lTtDFfvercH+HFzJQ/FAxPIEwCq
	T2orOfnrwXuArjHFGynllIFgiY7dmmU=
Date: Mon, 13 Oct 2025 15:28:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <304df1ad1e8180e102c4d6931733bcc77774eb9e.1759510072.git.zhengqi.arch@bytedance.com>
 <x4d36plhxcbyp76q4gmesktnnh7yi7bfifx3amk3fwx2moqkk6@77umpnw6rkg3>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <x4d36plhxcbyp76q4gmesktnnh7yi7bfifx3amk3fwx2moqkk6@77umpnw6rkg3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1D9D540012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sgahnysxhumczh4zget6itpxxfp3fu4y
X-HE-Tag: 1760340521-62772
X-HE-Meta: U2FsdGVkX1+2dp0r3Y8Yqp/zD19v77mRK90JaFv9riJCHPcBbtJmBrmggKG7fVvToDLw625wLxzyZoziHHzjMjwpi9fQ9vnOU/6klK9e3ix0ypIswGRH5e/2cA5dhKMsA6E1Xg+YD2+aBADmgUqr4g5rN/2w3s03jDzPu3XEjNdX78R4kWOnA8B+SJjmFiYR4/nZ0YEJb0nBwXYyODD8OS55jPQsIN/qMVl6qOSk5moZ+ajCcpnCJsXXVHIwZ3sxG9tLgF6xi7uqVQ0BgY7iYasKGhAW+Rq4LMr2/6sQ5o5Ie82EnJbbIx3pZb5mFoTpTFHgacl9RUizdlLlJsXX8cm7olJDJ87XzhanngTaWKRZ1xJTy9MsslNzBzqAsWcODd5NPJUbHXa2AcrqDDESUMLmBs63AsOki/QznpuXoebtrTF9XcqAtEc+6iMMK39K3YFztsgaZQbswBmakrH15BrkJY54pFB2q5nmeKXTz5BJQ07Ny2OOKyjx0cj4aPDZvIboAaFOoEufwnN4cOBNEUgBMiACCdTZ1z4tDs/tx8srZ6gTm1X1XMqhAvpgLLV4BarqV3mkMN32qk4Io7kSfnZNdGakHtcUMKZ9xjpfPfv9S8PPXRhwleByH8FVYrdxt6oArrFGPMV9yiK9couDP3zLz3BqTFm1++kYhHpjTPV3jIp7zrk64Gor7yGWr6IMCzt1km6zTdYt2tOL8BT+753QhSFTQ1oDon04NfjvupwebJcAV3HzokYTZcEtg/1bEXNxNnyS/ZkK0GaKPAxOdUPFWRryM4al4T5m8U93q5L1rDM07zfk+HoS3BKUWF8FgpY4kW6CZk+IUz/QYnYPuDIi7GtsiWav8m9V9pdrba16AT2c6yazPOKv8sp3W3Eouf9LX93STsSpChpLgXjLp3/suXuW/RCAv/YhL2M5dwhnKR51Uwc7GAsAmBQhHyBP/R1SHJLvEpVOOrFfbW7
 F17ev5Tf
 3A2PRU4+GOd5A0ej8sHz26sHchvL60B5M4ecwOyfPeKFwF/lNI8uuUxYMT9HoFgP/l3JAcqscD/ZvnFLcxwvuyYh6ypUC6akuoISt5d5xAiuKIMRn2XlxTX3gKwJSeZscKVveRKXP0N4fZjZrXLRCWuUoQt1BLNveofnMwt2u63Cv6TiSkDj2DPUUJXmS3DyMaP6UO+xtHoLYKQ8sHSH+55Zs1cMsXZ5kNRaewOKmiHh1WU7VWGc6Etdxn4MdyG1D5LYmNtM9OtkqtFF2iPxzl0VFdyo4vRA8G57w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 10/7/25 7:16 AM, Shakeel Butt wrote:
> On Sat, Oct 04, 2025 at 12:53:17AM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The maintenance of the folio->_deferred_list is intricate because it's
>> reused in a local list.
>>
>> Here are some peculiarities:
>>
>>     1) When a folio is removed from its split queue and added to a local
>>        on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>>        updated, leading to an inconsistency between it and the actual
>>        number of folios in the split queue.
>>
>>     2) When the folio is split via split_folio() later, it's removed from
>>        the local list while holding the split queue lock. At this time,
>>        this lock protects the local list, not the split queue.
> 
> I think the above text needs some massaging. Rather than saying lock
> protects the local list, I think, it would be better to say that the
> lock is not needed as it is not protecting anything.

Make sense, will do.

> 
>>
>>     3) To handle the race condition with a third-party freeing or migrating
>>        the preceding folio, we must ensure there's always one safe (with
>>        raised refcount) folio before by delaying its folio_put(). More
>>        details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>>        split queue not partially_mapped"). It's rather tricky.
>>
>> We can use the folio_batch infrastructure to handle this clearly. In this
>> case, ->split_queue_len will be consistent with the real number of folios
>> in the split queue. If list_empty(&folio->_deferred_list) returns false,
>> it's clear the folio must be in its split queue (not in a local list
>> anymore).
>>
>> In the future, we will reparent LRU folios during memcg offline to
>> eliminate dying memory cgroups, which requires reparenting the split queue
>> to its parent first. So this patch prepares for using
>> folio_split_queue_lock_irqsave() as the memcg may change then.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> One nit below.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

> 
>> ---
>>   mm/huge_memory.c | 85 ++++++++++++++++++++++--------------------------
>>   1 file changed, 39 insertions(+), 46 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 134666503440d..59ddebc9f3232 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3782,21 +3782,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>   		struct lruvec *lruvec;
>>   		int expected_refs;
>>   
>> -		if (folio_order(folio) > 1 &&
>> -		    !list_empty(&folio->_deferred_list)) {
>> -			ds_queue->split_queue_len--;
>> +		if (folio_order(folio) > 1) {
>> +			if (!list_empty(&folio->_deferred_list)) {
>> +				ds_queue->split_queue_len--;
>> +				/*
>> +				 * Reinitialize page_deferred_list after removing the
>> +				 * page from the split_queue, otherwise a subsequent
>> +				 * split will see list corruption when checking the
>> +				 * page_deferred_list.
>> +				 */
>> +				list_del_init(&folio->_deferred_list);
>> +			}
>>   			if (folio_test_partially_mapped(folio)) {
>>   				folio_clear_partially_mapped(folio);
>>   				mod_mthp_stat(folio_order(folio),
>>   					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>   			}
>> -			/*
>> -			 * Reinitialize page_deferred_list after removing the
>> -			 * page from the split_queue, otherwise a subsequent
>> -			 * split will see list corruption when checking the
>> -			 * page_deferred_list.
>> -			 */
>> -			list_del_init(&folio->_deferred_list);
>>   		}
>>   		split_queue_unlock(ds_queue);
>>   		if (mapping) {
>> @@ -4185,35 +4186,40 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>   {
>>   	struct deferred_split *ds_queue;
>>   	unsigned long flags;
>> -	LIST_HEAD(list);
>> -	struct folio *folio, *next, *prev = NULL;
>> -	int split = 0, removed = 0;
>> +	struct folio *folio, *next;
>> +	int split = 0, i;
>> +	struct folio_batch fbatch;
>>   
>> +	folio_batch_init(&fbatch);
>> +
>> +retry:
>>   	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
>>   	/* Take pin on all head pages to avoid freeing them under us */
>>   	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>>   							_deferred_list) {
>>   		if (folio_try_get(folio)) {
>> -			list_move(&folio->_deferred_list, &list);
>> -		} else {
>> +			folio_batch_add(&fbatch, folio);
>> +		} else if (folio_test_partially_mapped(folio)) {
>>   			/* We lost race with folio_put() */
>> -			if (folio_test_partially_mapped(folio)) {
>> -				folio_clear_partially_mapped(folio);
>> -				mod_mthp_stat(folio_order(folio),
>> -					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> -			}
>> -			list_del_init(&folio->_deferred_list);
>> -			ds_queue->split_queue_len--;
>> +			folio_clear_partially_mapped(folio);
>> +			mod_mthp_stat(folio_order(folio),
>> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>   		}
>> +		list_del_init(&folio->_deferred_list);
>> +		ds_queue->split_queue_len--;
>>   		if (!--sc->nr_to_scan)
>>   			break;
>> +		if (!folio_batch_space(&fbatch))
>> +			break;
>>   	}
>>   	split_queue_unlock_irqrestore(ds_queue, flags);
>>   
>> -	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
>> +	for (i = 0; i < folio_batch_count(&fbatch); i++) {
>>   		bool did_split = false;
>>   		bool underused = false;
>> +		struct deferred_split *fqueue;
>>   
>> +		folio = fbatch.folios[i];
>>   		if (!folio_test_partially_mapped(folio)) {
>>   			/*
>>   			 * See try_to_map_unused_to_zeropage(): we cannot
>> @@ -4236,38 +4242,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>   		}
>>   		folio_unlock(folio);
>>   next:
>> +		if (did_split || !folio_test_partially_mapped(folio))
>> +			continue;
>>   		/*
>> -		 * split_folio() removes folio from list on success.
>>   		 * Only add back to the queue if folio is partially mapped.
>>   		 * If thp_underused returns false, or if split_folio fails
>>   		 * in the case it was underused, then consider it used and
>>   		 * don't add it back to split_queue.
>>   		 */
>> -		if (did_split) {
>> -			; /* folio already removed from list */
>> -		} else if (!folio_test_partially_mapped(folio)) {
>> -			list_del_init(&folio->_deferred_list);
>> -			removed++;
>> -		} else {
>> -			/*
>> -			 * That unlocked list_del_init() above would be unsafe,
>> -			 * unless its folio is separated from any earlier folios
>> -			 * left on the list (which may be concurrently unqueued)
>> -			 * by one safe folio with refcount still raised.
>> -			 */
>> -			swap(folio, prev);
>> +		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
>> +		if (list_empty(&folio->_deferred_list)) {
>> +			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
>> +			fqueue->split_queue_len++;
>>   		}
>> -		if (folio)
>> -			folio_put(folio);
>> +		split_queue_unlock_irqrestore(fqueue, flags);
> 
> Is it possible to move this lock/list_add/unlock code chunk out of loop
> and before the folios_put(). I think it would be possible if you tag the
> corresponding index or have a separate bool array. It is also reasonable
> to claim that the contention of this lock is not a concern for now.

Considering the code complexity, perhaps we could wait until contention
on this lock becomes a problem?

Thanks,
Qi

> 
>>   	}
>> +	folios_put(&fbatch);
>>   
>> -	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>> -	list_splice_tail(&list, &ds_queue->split_queue);
>> -	ds_queue->split_queue_len -= removed;
>> -	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>> -
>> -	if (prev)
>> -		folio_put(prev);
>> +	if (sc->nr_to_scan)
>> +		goto retry;
>>   
>>   	/*
>>   	 * Stop shrinker if we didn't split any page, but the queue is empty.
>> -- 
>> 2.20.1
>>


