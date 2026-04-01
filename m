Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FBB10F9318
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E336B0089; Tue, 31 Mar 2026 22:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEC66B0095; Tue, 31 Mar 2026 22:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD686B0096; Tue, 31 Mar 2026 22:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 041E86B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:53:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AC291405CD
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:53:06 +0000 (UTC)
X-FDA: 84608465172.12.BCBD65A
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 038B220004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:53:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OzJ57Ydc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775011984; a=rsa-sha256;
	cv=none;
	b=p4IgiNvJNNc6jvm90KTOMsLQE1wuwPzTg9gjPhPnRSCNzlkCr9sXm1w0Pk2K2e36dUw5QN
	sEJbhp6ICartranUe8F/xHNZA7/m7FBMDVmzIRjkDC0DwP2ZWAfqtsgpvhiPpmnbbIImYD
	m3vb0xG8yiZ5XHKUxfO0mOZHWsMSa1E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OzJ57Ydc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775011984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qJETKdJ/PuWhgUurZhaJAwsJvqVhAJQodbiLbzpWug=;
	b=xo51k6Ua4oqf1KOywFaOGFmdxMhHrUmF60LR32sSqb+ondyhRjGBkZNBxNNa7T0f3VbAWZ
	/hqu6nZvZrtlmB10kh8Q18aI+bDbIQ1gd59HZqJlgutW2HMCY7/NyDFaC358DAyfW4x1gV
	l0hZTiHQvxzF3GCgB2MkJVY5PkNm1Ok=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775011978; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0qJETKdJ/PuWhgUurZhaJAwsJvqVhAJQodbiLbzpWug=;
	b=OzJ57Ydcb8kYpokkfKgzaFSyasnyE9gPwhlGBy+Zm6ouXU8pW3YXJltADVSpIkk39HKwgsByZKE9psm5mu2JXXWQ2iYx9AT3yut60hWw8EWKWj9RGK5ww5ASwOw/ntUJi/iNHawsUfQ424TRR+dpAvSZyz+hUrV954x/dzfDG1s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0X06XQfq_1775011975;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X06XQfq_1775011975 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 10:52:56 +0800
Message-ID: <703627b8-4c7b-483a-8c5d-379d98400154@linux.alibaba.com>
Date: Wed, 1 Apr 2026 10:52:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
 <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
 <acuNtuf-mv3KJJdn@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <acuNtuf-mv3KJJdn@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o8trfuxrb95urcdq6bnynoc31qxrn878
X-Rspamd-Queue-Id: 038B220004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775011982-741890
X-HE-Meta: U2FsdGVkX182H2j8YAWGmr0eX2pJ4ACP1OheERYfUZk68YJLCfdO9/j/hBaisBKJpdTWR2/PfQmvMHpB2l6F4AhvZiPxZt87nqT+fldUevT+wxCiwQr8xH3ZDhMudPitbzfYrFgkaJ+dP0k2RjcgJvyrnThpRTAZxzcG6SZAVF4bRDxj81i+RosHvBui9BiDg3fJ5AVVC4zCW+m0q0/jce/lgT/FuOkYKPNcKiGFf+uYCxLoJUdyu7wlnfqIq8Zeanb9w0UadTidYyTtLcs4PGXYXka1L4XRcO9GQrCmTloOZjMolCwzP7p06wjzX/xihKGz7Mk/q3dijkZ0HUWuYWRlE5MHcvswugXPyFoOx0zAyqzr5Wq+fHr6JCh2yqEbvHKffh/D612RO//luKeGeBspLLcWKybg8SPVGdh2ZPMZv8r4l+2jPQSbv9BEKcQBF0wCl46kCMBK9Uci+dL3EuS4UeaX2+xuuWwbiYvw/ZZYJwB4dRAPa9y1EqooXqiQRFf5COeR4ub3S3ZEap/sYIAR7Uj3+XdDnjBTGEyopuXOuUIR+HDoMQnGubhAq5RyQRc37ocnFrg0e//Q58SGxmsXHOsRMU0Z3yWmtfmrQOCw1wHVb+lRDG3NT4j6v9X1/SuoN7JgIkzrD2KQh3ofnQlG/HNBJbobUT0KY3K1MqPnIIe+d8KP9ZzJZLZbwOzfdB2LzH2BZcmjqgT2Dm/0ryGcYA5f3fzjZD4n12RnCz2Y3dTIbzjG0p19kI44Y3JxbcUDzrqI9TH+K4M2NwlDOYe3+tLR2EGdw4lWo0u5vlE550EtlJcABz5E+e0Z//o75AVWijSKE5xkd1tt7nm6YfOvYTTujdaanLOZ3sPxZbrLXOZpq7/OdvSzlKaV9KgBzZSP+oW8cqQJVrC6A0NeiPCHp8ueaBfElPfpVz/WOkSqzao08iUTtXsfjy6UwmnfJkaNy3t5OOZK8fGltoo
 msMlqaHX
 UC0iimedlQ7RP+ccFff92mWjcQ2fWrhtDCWMAML2AuVf7XkUZDNDRCPLXOReZV/XtlzNpJSWHn856gieKadrwg/iE3NyzyWz40bWjAc2rTS9NjDlGMwbm7Fh+sA0WtL9wLI+i9WRdAfZ7/F/DCLfit0MjPA4VP6BV+2ZTwHGH9Kq7rWPfmBUunbtL8w1ffGX3A8jzyPCKDZrG4IQtqBml1nw1rbm5pRJKGTGCHPk6B9u5z4NyYBbq3jMH+QfI3A6NRcYLyhiBySdqLhXN9HLm6BgmOcew2m1ec3ct4kfN7vu/NhWwqeC4xAPIq7qbuD/to6O8Hf+WT+sQ/EXsWBSmewYr2eZrAfFvZkQZz05q3iSmieaaQ89a54eYSM0rBbzzFGe8qVMYfc4w2hqul8Bm9uDMM/NjI8TiHpf/hjAtjifI4v/RcVdjfhqSaNY3sfxFbM/mci0HFOtV4ueTwpDgxJqO/qN9WOqryl8GP1RSmLi2zWgrbGLleFyyMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/31/26 5:18 PM, Kairui Song wrote:
> On Tue, Mar 31, 2026 at 04:42:59PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The current handling of dirty writeback folios is not working well for
>>> file page heavy workloads: Dirty folios are protected and move to next
>>> gen upon isolation of getting throttled or reactivation upon pageout
>>> (shrink_folio_list).
>>>
>>> This might help to reduce the LRU lock contention slightly, but as a
>>> result, the ping-pong effect of folios between head and tail of last two
>>> gens is serious as the shrinker will run into protected dirty writeback
>>> folios more frequently compared to activation. The dirty flush wakeup
>>> condition is also much more passive compared to active/inactive LRU.
>>> Active / inactve LRU wakes the flusher if one batch of folios passed to
>>> shrink_folio_list is unevictable due to under writeback, but MGLRU
>>> instead has to check this after the whole reclaim loop is done, and then
>>> count the isolation protection number compared to the total reclaim
>>> number.
>>>
>>> And we previously saw OOM problems with it, too, which were fixed but
>>> still not perfect [1].
>>>
>>> So instead, just drop the special handling for dirty writeback, just
>>> re-activate it like active / inactive LRU. And also move the dirty flush
>>> wake up check right after shrink_folio_list. This should improve both
>>> throttling and performance.
>>>
>>> Test with YCSB workloadb showed a major performance improvement:
>>>
>>> Before this series:
>>> Throughput(ops/sec): 61642.78008938203
>>> AverageLatency(us):  507.11127774145166
>>> pgpgin 158190589
>>> pgpgout 5880616
>>> workingset_refault 7262988
>>>
>>> After this commit:
>>> Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
>>> AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
>>> pgpgin 101871227                        (-35.6%, lower is better)
>>> pgpgout 5770028
>>> workingset_refault 3418186              (-52.9%, lower is better)
>>>
>>> The refault rate is ~50% lower, and throughput is ~30% higher, which
>>> is a huge gain. We also observed significant performance gain for
>>> other real-world workloads.
>>>
>>> We were concerned that the dirty flush could cause more wear for SSD:
>>> that should not be the problem here, since the wakeup condition is when
>>> the dirty folios have been pushed to the tail of LRU, which indicates
>>> that memory pressure is so high that writeback is blocking the workload
>>> already.
>>>
>>> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
>>> Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    mm/vmscan.c | 57 ++++++++++++++++-----------------------------------------
>>>    1 file changed, 16 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 8de5c8d5849e..17b5318fad39 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>>>    		       int tier_idx)
>>>    {
>>>    	bool success;
>>> -	bool dirty, writeback;
>>>    	int gen = folio_lru_gen(folio);
>>>    	int type = folio_is_file_lru(folio);
>>>    	int zone = folio_zonenum(folio);
>>> @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>>>    		return true;
>>>    	}
>>> -	dirty = folio_test_dirty(folio);
>>> -	writeback = folio_test_writeback(folio);
>>> -	if (type == LRU_GEN_FILE && dirty) {
>>> -		sc->nr.file_taken += delta;
>>> -		if (!writeback)
>>> -			sc->nr.unqueued_dirty += delta;
>>> -	}
>>> -
>>> -	/* waiting for writeback */
>>> -	if (writeback || (type == LRU_GEN_FILE && dirty)) {
>>> -		gen = folio_inc_gen(lruvec, folio, true);
>>> -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>>> -		return true;
>>> -	}
>>
>> I'm a bit concerned about the handling of dirty folios.
>>
>> In the original logic, if we encounter a dirty folio, we increment its
>> generation counter by 1 and move it to the *second oldest generation*.
>>
>> However, with your patch, shrink_folio_list() will activate the dirty folio
>> by calling folio_set_active(). Then, evict_folios() -> move_folios_to_lru()
>> will put the dirty folio back into the MGLRU list.
>>
>> But because the folio_test_active() is true for this dirty folio, the dirty
>> folio will now be placed into the *second youngest generation* (see
>> lru_gen_folio_seq()).
> 
> Yeah, and that's exactly what we want. Or else, these folios will
> stay at oldest gen, following scan will keep seeing them and hence

Not the oldest gen, instead, they will be moved into the second oldest 
gen, right?

if (writeback || (type == LRU_GEN_FILE && dirty)) {
	gen = folio_inc_gen(lruvec, folio, true);
	list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
	return true;
}

> keep bouncing these folios again and again to a younger gen since
> they are not reclaimable.
> 
> The writeback callback (folio_rotate_reclaimable) will move them
> back to tail once they are actually reclaimable. So we are not
> losing any ability to reclaim them. Am I missing anything?

Right.

>> As a result, during the next eviction, these dirty folios won't be scanned
>> again (because they are in the second youngest generation). Wouldn't this
>> lead to a situation where the flusher cannot be woken up in time, making OOM
>> more likely?
> 
> No? Flusher is already waken up by the time they are seen for the
> first time. If we see these folios again very soon, the LRU is
> congested, one following patch handles the congested case too by
> throttling (which was completely missing previously). And now we

Yes, throttling is what we expect.

My concern is that if all dirty folios are requeued into the *second 
youngest generation*, it might lead to the throttling mechanism in 
shrink_folio_list() becoming ineffective (because these dirty folios are 
no longer scanned again), resulting in a failure to throttle reclamation 
and leaving no reclaimable folios to scan, potentially causing premature 
OOM.

Specifically, if the reclaimer scan a memcg's MGLRU first time, all 
dirty folios are moved into the *second youngest generation*, the 
*oldest generation* will be empty and will be removed by 
try_to_inc_min_seq(), leaving only 3 generations now.

Then on the next scan, we cannot find any file folios to scan, and if 
the writeback of the memcg’s dirty folios has not yet completed, this 
can lead to a premature OOM.

If, as in the original logic, these dirty folios are scanned by 
shrink_folio_list() and moved them into the *second oldest generation*, 
then when the *oldest generation* becomes empty and is removed, 
reclaimer can still continue scanning the dirty folios (the former 
second oldest generation becomes the oldest generation), thereby 
continuing to trigger shrink_folio_list()’s writeback throttling and 
avoiding a premature OOM.

Am I overthinking this?

> are actually a bit more proactive about waking up the flusher,
> since the wakeup hook is moved inside the loop instead of after
> the whole loop is finished.
> 
> These two behavior change above is basically just unifying MGLRU to do
> what the classical LRU has been doing for years, and result looks
> really good.

One difference is that, For classical LRU, if the inactive list is low, 
we will run shrink_active_list() to refill the inactive list.

But for MGLRU, after your changes, we might not perform aging (e.g., 
DEF_PRIORITY will skip aging), which could make shrink_folio_list()’s 
throttling less effective than expected, as I mentioned above.

