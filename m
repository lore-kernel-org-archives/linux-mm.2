Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27692CD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C9B6B0088; Tue,  2 Jun 2026 22:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395F26B008A; Tue,  2 Jun 2026 22:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284F06B008C; Tue,  2 Jun 2026 22:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14BEA6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:00:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E81A161388
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:00:56 +0000 (UTC)
X-FDA: 84836948112.09.167B01C
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74F73C000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:00:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OpV6w1zh;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780452054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeJhAZRLWtGVTIwFCHuqUJodfl2KhzLTyWve4qcCjP0=;
	b=2g4guG6GoCuS7U6BsMF8O+O4aGJyLgDgPMdKaw/l/9DMyGQzW5pl8oPXYA+bWbzobJ708o
	qLUYF9fb453Xh+9Pw9fp5eSw8PQWj7ao/gq7jJe2M0kXVd8EzLPamXblbVFoXNkRMzJ/MZ
	xx6X1qV8sSeBgindQdUTjn2eC2/WIVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780452054;
	b=Y+Tz07/pYpZ8IG9kEIHZYR3Qg7/O9iNEAXbiqXwmIhLUSWF5RePzdI+2yJMDr/svg5zX4J
	nmYcyvb6Ekq101/TlrsEghHKf4bh4IkxhktfqgzdzfL/aQYVYm38Xh5259Bnpj58NlOD4U
	Q7qX/OQU8O++fZkXbSh++Z7XwpzObA0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OpV6w1zh;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f5061a2f-c52a-47c4-855c-82f3967833d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780452052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LeJhAZRLWtGVTIwFCHuqUJodfl2KhzLTyWve4qcCjP0=;
	b=OpV6w1zhJuO9Fvzn8HsG5QQIKizSG6UQlTGMYcaaGFMyxQu6EKE+D7en/a3XSllzlZr09c
	OL45e43afq5M8uzJH+i6A6D/I/7sBvkz4DASrXvWF8YTzQPYljiqO0j2vMSg8whTUhwLAm
	sdEXdAeJV4ySUtPk/pQSFbGcLsXdX4g=
Date: Wed, 3 Jun 2026 10:00:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, wangkefeng.wang@huawei.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20260602043453.67597-1-lance.yang@linux.dev>
 <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 74F73C000A
X-Rspam-User: 
X-Stat-Signature: a67heqyq9o6111cydhw6em9arhbu1yh5
X-Rspamd-Server: rspam08
X-HE-Tag: 1780452054-978612
X-HE-Meta: U2FsdGVkX1+IscephYjXlonctaYXw6u7i8j0z0fXtlCnyZ7puRAZGxCWvNDC+ouJXqAERUuFiAMHgfJSm88D9JnKSg1EDgxwClRqTomvRGX9f+TPiZWFfEn9Wi9U6lvzR+BaO2HrSw5f6biI8l5B9qA11rQlQ1g6FdJEnzdTzW3yOoDLL/DqS38FOuhVglN4co6yGOXYWXe3DCk2A5tVaNpmN2nZBJKNBZQ78hfzIguBRIw8PR5GmALuCmkHnxkjcRdhq7qIAKrPUAeTT6aUSWiOfXZxSxWDOEgBwVUOCyOTtqUrc+6BZibW++xvAoMCLRnAnsIx2MNP/+wOEEDiOVxdTZ97EAKhjd/gfAzyaqU6y6Uo113Ep8fB27qnCFUUL86mn1pUktICxwp6oZ5PN2QvGDLoyp4jftZz/mPW4a/TKi0TY0BIzcMLY2mt7RC+sb/bC4YwN5QZatmr48bX74t4uv4eu9xSUXyeHpr5W58Fg5uk3EydhTnvyOzjev/ZZayYrOmXPNKHgQP1s0H/9lmJmrspj7Jc0oLJJBrTon0JFQ7GCD+GyhK8F4MjnJVppN68S0wifmgzbHDUryE6n1NUltRg5guchvgeK32vz7eigCzyxfozU2ryZ3AUAX+Ttxos6iWz0DC/FH6XlfnnKj6S21NTy56hOj5B5oIGaftilT0YDfRZ4/t8OZ9bschzMwa3BhuWV0zNdnIpvEi6n6eTSpcwj0MKqCqg35XGgimHMPix9D1TDJNFB94+S/gYNZDaCbDsyLxJqkEqLT5i0RQ/Vv0eLjJwIYexT+DFi/kPpF6SnC3HWMzPLhRCkFjMFdI7MwrRuFl0d1FyCX9yxYOFK6zXQAlCFwIByNDkOfwfNJ0uVFAqeIGZCAWN6/ERXT1xjvh8yeG1IQrCPj2MqqcqNBuMzTgDwxMNsNN0BoqLmIbzDcZqDX0yEaTZX8Cg0YZHOVsvYPMwQVWU5No
 nXbrhUuX
 yvfeF3quPGOpnI6/Xpyw/64PAIyWkEqvvVcOQZ7C7rHNGZdqaTaszjagDyFVgvJdQh/sVQfcEGCTEazp6LYJBlJXAs1kWzyTIWe3TCPcpg9zbbwccET95wqtpYzpO5j2yGZTkGM8gu3vXtBAbzmXXNx/SqhQ/WPVsjREaKNt0/CFfzyOg8wgALQgwWF7Arkhx4KpouOC0O0HPBl3AnSuIV9J4HlSC7EzNbPKJwsQTuzBLbmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/3 04:37, Andrew Morton wrote:
> On Tue,  2 Jun 2026 12:34:53 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> deferred_split_count() returns the raw list_lru count. When the per-memcg,
>> per-node list is empty, that count is 0.
>>
>> That skips scanning, but it does not tell memcg reclaim that the shrinker
>> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
>> count callback reports SHRINK_EMPTY.
>>
>> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
>> cleared once the queue has drained.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/huge_memory.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 72f6caf0fec6..62d598290c3b 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>   static unsigned long deferred_split_count(struct shrinker *shrink,
>>   		struct shrink_control *sc)
>>   {
>> -	return list_lru_shrink_count(&deferred_split_lru, sc);
>> +	unsigned long count;
>> +
>> +	count = list_lru_shrink_count(&deferred_split_lru, sc);
>> +	return count ?: SHRINK_EMPTY;
>>   }
>>   
>>   static bool thp_underused(struct folio *folio)
> 
> Should this be handled as a fix against hannes's "mm: switch deferred
> split shrinker to list_lru"?

Hmm ... I noticed this while looking at Johannes' work, but the
behavior is older than that ...

We also discussed the Fixes tag earlier[1] and decided to leave it
out. There is no missed reclaim, only some extra reclaim work :)

[1] 
https://lore.kernel.org/linux-mm/63797977-1c18-4885-8099-f5c21c80da39@linux.dev/

Cheers, Lance

