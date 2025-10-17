Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0ABCCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 02:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F7A8E0008; Thu, 16 Oct 2025 22:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7268E0002; Thu, 16 Oct 2025 22:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33F68E0008; Thu, 16 Oct 2025 22:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBE208E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 22:34:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8F1D160499
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:34:16 +0000 (UTC)
X-FDA: 84006036912.11.7C87732
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 05AFC20007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:34:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMC7+Kml;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760668455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbO5pn8l4Y/yw529hagzahAyjhXmntVuhxc4yNmU1u4=;
	b=tif+TtxLEF+hgGJ68HRel9z08OlIchI7VLh36XLV5//n93Y6VEX6d68BkDqE7+STJH+gqv
	xp6O3lvNdlgWOQObgoy4H7TCiQJxoJyOQckwlTCW5Hs0NlRV6kuK5Whu0PJHCobBEnEz4s
	d0zUECehsOd0h3PAKujty9YMEc8amb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760668455; a=rsa-sha256;
	cv=none;
	b=G+AQkcPVFtjVyrp3/h1oahCd8ods+nczlMC+c2vwdxT9v4p+c+XKRdXh7MK65sqNAbIYKM
	s/QpVKG7zk7w14h9qWv32oMv1kBuTd/pDr2WVoRaeNsLY8Lp0cIPLzTOIRe3U+wYDifzif
	7pIgtgCkkMvcLbFPcudoJM7y07WUl+w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMC7+Kml;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0c263545-9b22-43b8-b919-3613ecc15553@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760668452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbO5pn8l4Y/yw529hagzahAyjhXmntVuhxc4yNmU1u4=;
	b=WMC7+KmlXtDn9J4nhg8GF3Fm7UZt5r8Z4BaRv4R6V+R0nrHNDGd1t6lgC57DEWPq98Cmdb
	y6XwFfBLXRhCkOM0Z9IESnjfmJ5GxY2Y7ukcw94YcmNwT4HfreVnVwIAw0zMwWN9QrXFOg
	2zTZiKCh8Sxd9VSVJNBi4ynxmA16p14=
Date: Fri, 17 Oct 2025 10:33:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
 <20251017004611.ccjq2343v43mimqq@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20251017004611.ccjq2343v43mimqq@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 4hyaki6ue9faiprkrs914xhag3nppxzu
X-Rspam-User: 
X-Rspamd-Queue-Id: 05AFC20007
X-HE-Tag: 1760668454-449340
X-HE-Meta: U2FsdGVkX19acXZ1Rub7ZVzwtY21ZgVvVt0tCv6W3kF3fYchyEgdbarhxRF03N9UreIMYX1W6WxGIz4qjzZYsBCKaeRiaF/CHhydNIev9yDnI+wCaapelltq4REYHLS7HVug7zqxZCx72e2/NWhan0SlqRAFIxGhmWhvRzf/KMK7I+moNesGHWukq1xkTZftdMQ1seSxcNwAAYK+8VNKhDQSDEUIhswjJTMP/5zSSp210Fe9rVhGPW7wjE1/f8hyLcaYqvxjeb0NrDeIFOeVjGTJjB+59EfMwxQxJ+Gj6Ec+TKXEiJZCjY0RKlwdC72WOFFJtdKZ9RkwOJSz4jpuoGS/+SlA2MXZQgA/WedNwM5d9Iw1LdyXyY1kR3ZMmDoUyEd5oCPhYt1RsTsoodMKyzNyvC2V0BlqhBSxSoRAK95X+eWLPNR9WtBqgl4CqhH63HH6L/X9KCnmaBCwsa2MxBVWSKX1VE/etdxYzBMoRe8buVATFviMVpljqx5nFUHCpM9IPLMuHhs1TBZSgz4AM466v+KucafZhpGXpWvIrPV6beVZM9pjPteR1gfSmb4hqWXqaMiy3QQcBdXObja7kJC7mhYHoS8VzH7Oel2uM/tYJTIdlmtL5BEUCfJ1fB/AE3t4fcqVceeXDcPZWTE3OlEoFrQ5Uf6BHzZrsV9+B3RkcmQ3IFvSEZRb+EBfmIzHjbM6JIL6XLVylfOPIdwzpfgT1A1Wwajbvpttot9Tulf7aRjgxphvZOakMu3qwqSYckHdoKk1cbN4FUr43sZdGpCHXYURa9eqxPUD3QKLE2o4i8pKZP8j5c3XuS+vhNMiJ7aC98yB8buwkC5fTiVPNvHufCVe6UWKxh6i2nH88h4ZmlRW4ObYtU9w47hOBRfY7q7jbqZ0iLAN9OyCxvRtyHexlfV0sbXwi57fvl4jMyddcnDkx0+RwY4y8T4rSbELlXckKxU3csswjgYTQhA
 /UkrDcXt
 bjKF3unOLERdAVcM/Ljfhi4+0ZVvvy1NLNNCQsvFCJsra7Uzsu/ACIK8w1rTTZbziyaa6GOYPGIzDuBySqOU1NB/a5W8vSHdKfTzfkOY5394qpbUhdaydU3ILp8KP/Oui/fG/WrPq5alKYvclHGvXZMGAbOEzAJaqGpHNJExbCCESE5gUGKzfeP1ZCZmjIn7k/TUydgA/No3yEemS4I+e7yW/dZlUi1nPBI/w1sL6O8k+4FDBdA026U5LrRThSBM5WGl2aRUiq3h6IRDbtYs3Iv+A3X+EQT90kw2Ss3EEC7JBGQRqivQLGl3Y8vZAnmjRrUCZdGpkr8CrGkATEE+Mk0+FZOluaH2EISpYiQBBsAWnypsS27nkXkqBV05XkS7iKf4G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/17/25 8:46 AM, Wei Yang wrote:
> On Wed, Oct 15, 2025 at 02:35:32PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The maintenance of the folio->_deferred_list is intricate because it's
>> reused in a local list.
>>
>> Here are some peculiarities:
>>
>>    1) When a folio is removed from its split queue and added to a local
>>       on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>>       updated, leading to an inconsistency between it and the actual
>>       number of folios in the split queue.
>>
>>    2) When the folio is split via split_folio() later, it's removed from
>>       the local list while holding the split queue lock. At this time,
>>       the lock is not needed as it is not protecting anything.
>>
>>    3) To handle the race condition with a third-party freeing or migrating
>>       the preceding folio, we must ensure there's always one safe (with
>>       raised refcount) folio before by delaying its folio_put(). More
>>       details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>>       split queue not partially_mapped"). It's rather tricky.
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
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Thanks.

> 
> One nit below
> 
>> ---
> [...]
>> @@ -4239,38 +4245,27 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>> 		}
>> 		folio_unlock(folio);
>> next:
>> +		if (did_split || !folio_test_partially_mapped(folio))
>> +			continue;
>> 		/*
>> -		 * split_folio() removes folio from list on success.
>> 		 * Only add back to the queue if folio is partially mapped.
>> 		 * If thp_underused returns false, or if split_folio fails
>> 		 * in the case it was underused, then consider it used and
>> 		 * don't add it back to split_queue.
>> 		 */
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
>> 		}
>> -		if (folio)
>> -			folio_put(folio);
>> +		split_queue_unlock_irqrestore(fqueue, flags);
>> 	}
>> +	folios_put(&fbatch);
>>
>> -	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>> -	list_splice_tail(&list, &ds_queue->split_queue);
>> -	ds_queue->split_queue_len -= removed;
>> -	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>> -
>> -	if (prev)
>> -		folio_put(prev);
>> +	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {
> 
> Maybe we can use ds_queue->split_queue_len instead?

Maybe not, checking whether the linked list is empty before traversing
it is more natural, and the overhead of the two methods is not much
different.

> 
>> +		cond_resched();
>> +		goto retry;
>> +	}
>>
>> 	/*
>> 	 * Stop shrinker if we didn't split any page, but the queue is empty.
>> -- 
>> 2.20.1
>>
> 


