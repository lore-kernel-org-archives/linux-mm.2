Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184A1CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208096B0093; Fri, 22 May 2026 08:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D84E6B0095; Fri, 22 May 2026 08:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1157E6B0096; Fri, 22 May 2026 08:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00AC46B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:00:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D9711409E9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:00:01 +0000 (UTC)
X-FDA: 84794912202.14.50B75E9
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90227140005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:59:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779451199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/WOsHXJfseBrt123OcxahgQb+ZAfQEm32pCKYJY0Hk=;
	b=f62HFZ/27fE8zHa2TNfo0gQ8hV/fxUCRUAHEt+Nzh19PvulZ2C8M8qhw6OwhzoMog+0EEL
	K0qV3+tq0Xs9nCZmHz6Ng5qF21Iz9QZJlRhA4bWWzXPMOV9udifjdkSL21p9WNaSvq6Ka/
	b5KdX9wrq4Sqev8LA2CzSGII/jGyigg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779451199; a=rsa-sha256;
	cv=none;
	b=W3ooRn3w3UrKWorTk/suBa3Kw4DCZa8BELHqbP0Iq3QWiBNpERAI3W0cKe11zuNTCKi8dk
	A3EGMmlMLGzMo3IZsDhINamLYDaKL/tMjSxqwQXW0JtSgakn1VIirnoKYum+v5nGim+1kS
	Kxko+Xgk7BHj3HnEA8R5lIt3R79qi7g=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2B76E1F415;
	Fri, 22 May 2026 11:59:51 +0000 (UTC)
Message-ID: <601a6c29-de31-44d7-b354-cc7a0e42d732@ghiti.fr>
Date: Fri, 22 May 2026 13:59:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm: memcontrol: track MEMCG_KMEM per NUMA node
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Wei Xu <weixugc@google.com>,
 Yuanchu Xie <yuanchu@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-5-alex@ghiti.fr> <ag9AY2SrcsE1B3Ti@linux.dev>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <ag9AY2SrcsE1B3Ti@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEfzuW/isuEquYusTjkCChymQZGYrE6UQrubmew1s29pfPbQNHYcMXPE1xkckOz4Gx0v3nmpsWrjOwwNI/NQP2eMy0oeQPLTyFe6w5utDyi4foMiOVk4+AXCNSKtaXZSJaS8qbvrdYN8pxLR2nFCYce0CWO3EmPID8zG5tYwOwQfHMa1OEb945QZyjUtxYGW1qqWXOSWY/gnoZgw2ppsRwrCUORANR234l8GGNNWkEZCc8iIZNv6/ArqYXZ5daLx5INydrxyR9kh4hQlxTLIdopou03K9EciWwQERt8JUyD/HkFt5SP0vbD1yY5ukGLKg8ld6Sa0ErWG65+c1P3ct8HSKRcjr5HVfJKW0/9xYzRmfz2BxG3HmECiQ+iT/sIjdchBLIyxQpMTorwb5K6HA8z0DGz9RvGwfqqEF+NaUoz3InIEWgSYze4ATmZ/p0clh5zOYJ9N4VMhQ+b/CTqJrUNWEtBqGBTAah7NOliBmO9ZTLNskkzAQtwc7R5ZBALlgbV49CtnhHnXOD6m5kqj/qNOSnJqydGb6oUVFMpDj5tYC1jWxVdrNYxX/x/g1USbTUsLpDGxM1+q0vhJftZRIcFM3d7qTVClJAqLoPdu6utVZx1uwc3/X+FUEQ3DuysdHQ0g/JAUFyLxprfZr1MJ7aRYH7NUQsDbBIPkY6P1/G4WA
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90227140005
X-Stat-Signature: rbkw3cef69kwgiemoft3jhzkkccjjroy
X-Rspam-User: 
X-HE-Tag: 1779451199-164426
X-HE-Meta: U2FsdGVkX1/h6VDajjkLJ8to4G3UW7sHy4MV8tKkwuO2LLs+0KyYWCOgiDjUb3F+L4V2oCKlZdcpRdC6gFRPCarF5Z5TKAlkmaEKrZohVi3rWghYJofOBp7fhw/tVs9T9AG9HvINvG6ThVyf17JfzwIqqXLceowb0yxRh7m/Ji+U0bSkegk+g0df8+PLnH+1tdt58na/hM54YtUp9rw7hSUTbuerNwcfrD/NiA+5AXHqLTWpKIASS/BNfjMLD8PF9Z3SsqOYhNvxXq8uEl+EIfVBqr3cwngYe4Z0SBf8Ct0vXTkFztKb2vaCsafG818uzh2zIGcH/eI3Q07wb6AfA/2dPzgp4xmrZTrjB0XINM/Yef1iwAdewNyMx1x2Oj1Ljx/uxQQuOMa1efCY8ZePwykXLZZJ8NZm7gZx+hLzqRJmvPtBhc2apYH9Ksnz+plLha0Fe/hLwiHhxmnW90lPOf0RelEc0VVioqa80y63+O5YCyz2JkwmNM6kh6x2/7lvdANdlWVm51LXPbvVEuUsgOdHpiRpEPCNiyhaNkDBKh+ouhgQMCoIi5MHbkdNFqwgaoUzXv9r8TV/V8f+tB5QZ3Jj0ryalHgLcFKl3brnq8QfzvQSsj0UJtjdwOPwFhaZ/4IsyYpK8FeWKaSnsqV60s8xfroc0NQ4egJBlFmEsQ25jilnkTXBrFQucieF9xGblmwPSxEX2NvEAe1vj31Ppq7atRWJO3y8UrswT3m5hKPF33sYPn14dYsu022vP72lC+mwIQzCpu0Bz9a75tt3dIEqicv8cEcQy2/2AVVy57D7+UJAAYdi0vrvAV4nRO8FxqTGuMtWHIR93KkQ1tQK77pNWGUvGTNC3D0Ri++PXSVH8gwl6EwCvIKuLhUj2AHHwKDViJ404zJp40V+Z1fpMQ7uavFbmKQpEC5+TgouPlVnnQaz77BoAw/rgStqkZg2blPjU8/ZaRaDYt0HPfL
 Fks9SIec
 SSp1gM64NzZ7itOty64ex129Whlki289Wh0lAqA4pjiapHk23VlkCtrdBy7mNMPeYzPZZvhs4/MQNiYOFYX8kUVuJELpn2wMQ74KIrCEHechaGGo3pkD4C4GaEeeyyyGH0KIjjvd98VLcjO87UW+gcxuf3TcRtCzagvYNekGZp8xRGistiNf7WXNSlLI5Z8hqcr2crj/cdkV4XiZ5B8q2xIlYQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 19:28, Shakeel Butt wrote:
> On Mon, May 11, 2026 at 10:20:39PM +0200, Alexandre Ghiti wrote:
>> This patch gets rid of MEMCG_KMEM and wires all the "generic" functions
>> by introducing per-node obj_cgroup objects.
>>
>> Note that it does not convert the kmem users to proper per-memcg-per-node
>> accounting now, this is done in upcoming patches.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>   include/linux/memcontrol.h | 23 ++++++++++----
>>   include/linux/mmzone.h     |  1 +
>>   mm/memcontrol.c            | 64 ++++++++++++++++++++++++--------------
>>   mm/vmstat.c                |  1 +
>>   4 files changed, 59 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 568ab08f42af..17cf823160e4 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -35,7 +35,6 @@ enum memcg_stat_item {
>>   	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
>>   	MEMCG_SOCK,
>>   	MEMCG_PERCPU_B,
>> -	MEMCG_KMEM,
>>   	MEMCG_ZSWAP_B,
>>   	MEMCG_ZSWAPPED,
>>   	MEMCG_ZSWAP_INCOMP,
>> @@ -126,9 +125,10 @@ struct mem_cgroup_per_node {
>>   	struct list_head objcg_list;
>>   
>>   #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>> -	/* slab stats for nmi context */
>> +	/* slab and kmem stats for nmi context */
>>   	atomic_t		slab_reclaimable;
>>   	atomic_t		slab_unreclaimable;
>> +	atomic_t		kmem;
>>   #endif
>>   };
>>   
>> @@ -190,6 +190,7 @@ struct obj_cgroup {
>>   		struct rcu_head rcu;
>>   	};
>>   	bool is_root;
>> +	int nid;
>>   };
>>   
>>   /*
>> @@ -254,10 +255,6 @@ struct mem_cgroup {
>>   	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
>>   	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>>   
>> -#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>> -	/* MEMCG_KMEM for nmi context */
>> -	atomic_t		kmem_stat;
>> -#endif
>>   	/*
>>   	 * Hint of reclaim pressure for socket memroy management. Note
>>   	 * that this indicator should NOT be used in legacy cgroup mode
>> @@ -776,6 +773,20 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
>>   		percpu_ref_put(&objcg->refcnt);
>>   }
>>   
>> +static inline struct obj_cgroup *obj_cgroup_get_nid(struct obj_cgroup *objcg,
>> +						    int nid)
>> +{
>> +	struct obj_cgroup *nid_objcg;
>> +	struct mem_cgroup *memcg;
>> +
>> +	rcu_read_lock();
>> +	memcg = obj_cgroup_memcg(objcg);
>> +	nid_objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
>> +	rcu_read_unlock();
>> +
>> +	return nid_objcg;
> What is guarating the life of nid_objcg?


Sashiko raised the same question, so I need to be educated here: what 
currently guarantees the life objcg returned by current_obj_cgroup()?


>

