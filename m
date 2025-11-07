Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3728CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371418E0009; Thu,  6 Nov 2025 21:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349038E0002; Thu,  6 Nov 2025 21:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2857C8E0009; Thu,  6 Nov 2025 21:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 175B28E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:51:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D705DB7F2A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:51:34 +0000 (UTC)
X-FDA: 84082285308.15.D9F9572
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id DEDBB1C0005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:51:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bzZlJvVZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762483893; a=rsa-sha256;
	cv=none;
	b=eroC4ce2rHlsRLT+rcRO5MuaooZp/cyz+kejfIz/39LpYz4EdgcsWRJcysaMIUotrvhQ1h
	suejNdu4fTykfHnPn2mmBWAiUb17UsOStazejwPKJeFB2Z+W1z8YKBk5T5rFpT6Y4a/cTz
	fiHb4ziDgB9W60YhhTfBCoWKkzbV0A8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bzZlJvVZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762483893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DG0Pm3cx15SZFs+emOMlWtRSV7YqmPrwZzDA3RG3IYY=;
	b=q5m+Rm6/V4cC2qyKQuRd6rwqYblztKVEjadtJF6BtCaLmRCS8/UIS0AHH+ykYQldlzjqQv
	8JHyzdVVbWsF22UFuQwcgVeOg/LQ421u3UcoTsEzj1KLFJo3Hmp0kw1XiB42vA9hsm90CG
	/4XpmzSamMzmc37HtO9Gb1qqorywTYI=
Message-ID: <131176ed-8901-4a04-92ce-e270fc536404@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762483890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DG0Pm3cx15SZFs+emOMlWtRSV7YqmPrwZzDA3RG3IYY=;
	b=bzZlJvVZxZRP5AChCD7RthMKFu+lDwVz0r/gOn4BxXW7bSJ4JxWILPObhbvN8szk3TQahV
	Db8ybcuhKqZmUQKyyueNTvvaomWY5OcKZB0m4AbdLIaW/A0qt+RQoJf8KqhqaQ6HUjCEU5
	Xy99rJl48vXIlMO3YaGG4kmPV817K3A=
Date: Fri, 7 Nov 2025 10:51:15 +0800
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
 <20251106145213.jblfgslgjzfr3z7h@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20251106145213.jblfgslgjzfr3z7h@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEDBB1C0005
X-Stat-Signature: p7odrhmzm9e3ggpqrz5kmm879uhu6kqe
X-HE-Tag: 1762483892-29658
X-HE-Meta: U2FsdGVkX19klPAY2D4Qy7h8TU3MvyBYWf/ZkeRHcsWObTK/Y3Qy38amDFkhb6adPLGr4QumkNMg6CPgOjHfAYe2mhtFPuhONRlz4QHfIgVnRm876SLxc5dLh1YZ4t+dl6VQJSUHjYeUNriBJXkN2iMcZh09rB5Wdk4X6Lm5QLZX3hu1I0+UBKijrbIvVgnwJFQnz8Z7h8noKQOj3Geh6UlW/DUelKQMxZnW0RcdQ9enh5IDYjzJ05MHjALd9haYz2Ox1WPdJog8oan4AQEkCn22I8MfqAR+1XhICSMt5WYS0DN3jscykxBNGzkn8OcYzoMGCdBU09f+hzD2BLD7yDNw8A5ip+lkeo+y1tCr4Wd+yp0BZjakUUz/lfCRSCKwXAWG78Vh2jEUR+gxdFIGpbrS4M7zoqCHgOBFsLmjt6pozze8iH7vUIWmLJUbgHBg8LfC84tHw/m3Sr2AiN1wBTPzFmL/wL8HHKBlXSh5DJEHL7DV6CDa6HspehSWA7WHFDixIwXYupVpL0ayaYb0kI6YEOVdKTP0hpn5HipM1errrpqE59l0KHrWYPc5nM/ITIQyx+q8RWo2pKRNEyZMHqYzdd/H/PcYC6SZVbxN78OQwnky0ODQ7R8y8o0cprhkj2oX7sm8j+oQFgTy97gbEIwqf9HkVTP5cYmJ9BY4cefcqr3heES5uZRDGI4oXngewPqOxYVn0Gh7YTQTpHV6Se2xpNWWzu2GwPoYnGnKLlMQsBPp9GdJpIlFgXOcZpqlOoQnAMPADCdkgZNEicKd9SlK9xUoS7YKaicREqbvmhrtjWvxG7QbbcxwkK9hOmA6r5w38iWa9E2QDlUE2jUShXar+5lNOBYV6BQCq30LnUw4nw503aaFngFi/g1RQgvP8Hqd48jDx0r22GQ7A3hnSgRy54LbU3hbDJMcJ9zAHUMxTJYMdnM7KtJROLlA3Lur4zMDA2/krs8D1GOfIkU
 a+Zf6/es
 QsqvEEYXLYxu70EZA6QK4Lfvu/HlhhbgiTzJ9expSf6ssA3dnMtjUZQ+/vXrkx544GRhAhA82G7TKC/a26bV6du59xPtCJCa/bUpfduOU/njhK+me5Yb5Ku3krN8rpaPdip09N2UuwTHh2Lm8dzz34gEhN1kGdGRssSjzYUMrtTMn9IcmaV9RrN8Nw3WcXkHz9yO1dkA6DGzt+OqEOQQDyqcnpOdFAvcdDhm1km7423Dt+4Jz1yRsDPb7zpCKaGcRdN0xN9GbUYkxptVZXJFviEj5KC79Xn7kNGlqfyQuamQaJ0tRD+f5C+JL/wPwqLlJTk5MYYEZGaKwHepg9PkdkFY8Pd+ciUaNp2tbeAxoCbgP/gw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/6/25 10:52 PM, Wei Yang wrote:
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
>> ---
>> mm/huge_memory.c | 87 +++++++++++++++++++++++-------------------------
>> 1 file changed, 41 insertions(+), 46 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index a68f26547cd99..e850bc10da3e2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3782,21 +3782,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>> 		struct lruvec *lruvec;
>> 		int expected_refs;
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
>> 			if (folio_test_partially_mapped(folio)) {
>> 				folio_clear_partially_mapped(folio);
>> 				mod_mthp_stat(folio_order(folio),
>> 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> 			}
>> -			/*
>> -			 * Reinitialize page_deferred_list after removing the
>> -			 * page from the split_queue, otherwise a subsequent
>> -			 * split will see list corruption when checking the
>> -			 * page_deferred_list.
>> -			 */
>> -			list_del_init(&folio->_deferred_list);
> 
> @Andrew
> 
> Current mm-new looks not merge the code correctly?
> 
> The above removed code is still there.
> 
> @Qi
> 
> After rescan this, I am confused about this code change.
> 
> The difference here is originally it would check/clear partially_mapped if
> folio is on a list. But now we would do this even folio is not on a list.
> 
> If my understanding is correct, after this change, !list_empty() means folio
> is on its ds_queue. And there are total three places to remove it from
> ds_queue.
> 
>    1) __folio_unqueue_deferred_split()
>    2) deferred_split_scan()
>    3) __folio_split()
> 
> In 1) and 2) we all clear partially_mapped bit before removing folio from
> ds_queue, this means if the folio is not on ds_queue in __folio_split(), it is
> not necessary to check/clear partially_mapped bit.

In deferred_split_scan(), if folio_try_get() succeeds, then only the
folio will be removed from ds_queue, but not clear partially_mapped.

> 
> Maybe I missed something, would you mind correct me on this?
> 


