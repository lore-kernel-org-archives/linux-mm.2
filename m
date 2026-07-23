Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97751C4453D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E08B6B00AC; Wed, 22 Jul 2026 22:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6D96B00AE; Wed, 22 Jul 2026 22:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4AB6B00AF; Wed, 22 Jul 2026 22:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2DD6B00AC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:14:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DD2580381
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:14:38 +0000 (UTC)
X-FDA: 85018422636.01.E444317
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B2301C000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:14:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aUNZUcEl;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784772877;
	b=nVPU22QUVYs6XuIcYMmafuyD96bpDBVq2h8V5Z1BbAuR6kR490xVoAFCvNqyd0TygC0LeF
	W2zumO/oLDbbp1luDLoXWeJ+dYROoDHCipQEGYuSd4GwQnk6bXzjFH+OqczFk99PC1LKDf
	WgcguR//19cLwcXceXImiURUYnGoD6Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aUNZUcEl;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784772877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ambDkTqQMLokaCulVxvlNgNFFnydU6SgnMT5PS4qzuQ=;
	b=ypMkmseu0DUchsLR8r6BnaStD1/FAZgLmk1Bc1l44yz3m9Ua2MQCkqijSJfEntX4IUA8OR
	dQCzeOrOko10jkY1gu4v0OaSeMLwGGcO12po00XsDOzoAhagx26mTTFlmQCi0l9u7X8jVH
	EWZP2wQWqBICb6Eg66fRqJs+/vLSQMA=
Message-ID: <17abc770-0185-4795-a23f-f4e9ab1772bc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784772874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ambDkTqQMLokaCulVxvlNgNFFnydU6SgnMT5PS4qzuQ=;
	b=aUNZUcElT+mIglubR8NDtCpfKeCsaKFekTufe9eEjIjAvSOpyrsEm9TWp9JX3MP/hVdEEB
	iIqhAni30uRN85pi/rT4AvzXb+6qimcmDC4GS/pSHGOTce3rlwqAypgMjWJLXy8E2WRSY8
	9i+ZSEmkR9oBrlSqTRoNIDVZaGD6S20=
Date: Thu, 23 Jul 2026 10:14:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-2-ridong.chen@linux.dev>
 <amF1ii74RlzKiepO@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <amF1ii74RlzKiepO@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B2301C000B
X-Stat-Signature: 4k6sk5c64qcj3d8spi4678ywduz5e3hs
X-Rspam-User: 
X-HE-Tag: 1784772876-573729
X-HE-Meta: U2FsdGVkX18tJB8rlW2A5HRU4KuoyLrwCeVSJ9VXuZwfoxhxHTnNN8W8y8K3qHYW1B4lSZnylvQSSziFXzjeiZlVWH9z5NagseoUtpsy9G5xHj+OsfOoUuk1vag1OHy6lk/MAoWQwVkHg9aBnV1zDwXX0ymgzKcC///0GhbwhKuIJwG7dWmEktOhVFDyfKpKyva+lsNoWUqVWT4AXEpzTWJNgmp6Kegy5zVRm29IW6PGNM2BPb4/orPzyUB07XAbN0Tln3qYt7HcEkwE0adPQbtCi2a07kE3gW4wPUEysWuoWirqnSc5enHpbszEab7OJ+DDoxKvmg1PrqO+0AiH2HqSfDKOe3fO9M3pMj/Ca95iLn/N4y+etycotan3Uvw3TTwsIquCf7dOOyWWnpkl85fyugsKaIkjeIj8l1mSMrqstLmDjrm4el/MfwJ2aaZSa6LJvKhc66B5sIGQpB+KaS6KAEjLMJojpIICJC0WEioAg6zZRr1RSj5BdWDmRHj7Go+vUl7NyWNjzMBmH1ig69O7tCsT69D7BcpYWQ6EQvdyRpx+fHnZwDHUrZ2UUZ1BvjuCeR86gXt0g671qw/LroiL+/KQ2zo9sHd0yJelX2sNaJxPHQ+Cq7eRJWOuk4e8HCuoLIJIsJBVYkcRxWS5L8Wzp2MLAXRLruQMq8ZacUOckgwLBHu+b1ONkPNvx5rEimQYpB4rm3/WCmRAzY6Pnln/3a4RdmmKX2MMf2o9JjEdGhBzUxy3KBWRAI3NbY2gNHHpRWxtpkt55DYe710yC88omXk1LEeiaJJdr2ng/7vSbO5EHIjxUmIcNKQZBDc1As2ZiN0uaNW+GVIoxBxNBWuszWfq7YMYD8SRIEof7uvTnRINlspSnRFxL6WDho2rMGGVb1QrCNLcEMcC4FoFoIw6bZuF38Pe9kM3HACgoiz+d0rXL1g/+o6eDsLnyIX5CWQBVcQ8NX+3I9r8Xyn
 krGuhY2G
 h/e0a3KgdXsniamOPRapCJuvPLOi5wzM0KECXDuo8iwftpkPsSNxuvvEGM1TXb8ZWn2yXJpMRdXZmxq/P1WwLEPHzBXGFnDhfYcN3GsxDUKmxNWoQiGUTV+8XRwtsAzrl6PYRwyVUJaRcyjwsDwf22UZrpvmEed0EYKtdOqsShZ5P/mgIJYWdOU2IY7SgbmWRRkuRXMowbsylvUxmV2wkyzF3VUTH8KxPcrngxsS1PaarwgX9PAWcSqm3xDUjGHbnThLa9Wg1AOV1WSzGg/vGmqhMucOg1ppHemgsuUCJN2NYK6hb5pSnb32B0LBaxq00wyks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/23/2026 9:59 AM, Johannes Weiner wrote:
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> One small suggestion:
> 
> On Thu, Jul 16, 2026 at 11:17:28AM +0800, Ridong wrote:
>> @@ -76,6 +77,25 @@ enum swap_cluster_flags {
>>   	CLUSTER_FLAG_MAX,
>>   };
>>   
>> +extern int vm_swappiness;
>> +
>> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>> +{
>> +#ifdef CONFIG_MEMCG_V1
>> +	/* Cgroup2 doesn't have per-cgroup swappiness */
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +		return READ_ONCE(vm_swappiness);
>> +
>> +	/* root ? */
>> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
>> +		return READ_ONCE(vm_swappiness);
>> +
>> +	return READ_ONCE(memcg->swappiness);
>> +#else
>> +	return READ_ONCE(vm_swappiness);
>> +#endif
> 
> How about:
> 
> #ifdef CONFIG_MEMCG_V1
> 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
> 	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
> 		return memcg->swappiness;
> #endif
> 	return READ_ONCE(vm_swappiness);

This is simpler.

Hi, Andrew, I notice you just applied this series to mm-new branch. Would you 
mind I update it?

-- 
Best regards
Ridong


