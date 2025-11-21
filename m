Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1EFCFA468
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59156B0088; Fri, 21 Nov 2025 03:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08EE6B009E; Fri, 21 Nov 2025 03:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8F26B009F; Fri, 21 Nov 2025 03:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0A56B0088
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:18:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C4EB895FA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:18:13 +0000 (UTC)
X-FDA: 84133911666.01.B38CA05
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5972640013
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:18:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l9cINglt;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763713091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6j/lGFm/xWvuyqpIw5QwOUGYGHYdfUywDo5MBgkolKk=;
	b=ksUpSc34GTyQEbnU0cghEaQcrYnqwk9wb1RvJkLGQUDsyxnXiltkwRLXiL/IqwTOcnYTIe
	xbnOi/DwlYxlF80haNuTo8rNl6akt04/rvnHcQXcoLlBEfNAEEgPO0nx23ZBK5Ychfh5Qt
	Qreh0cOXLMXaNysuKmlgNVll0tP8thI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763713091; a=rsa-sha256;
	cv=none;
	b=FO91FjEBWS7tyDiDDvyvKlbNnLtdsoLxfu2HsF/FCOtHEkb8QYCwMJ2m8jQcTFIKJUY4k7
	1yorEeeSq+b5EhDLkjg/xHXOs6ox7q3lm4Gc4VIUn8MWmb1Jx6G6i/X1PCuU3fIIFexODk
	wl8vWibC0iSS8J8OfRaATRWGHY1KXzI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l9cINglt;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b2a64a62-9cf2-4d81-bcd0-1af7e64a34db@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763713087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6j/lGFm/xWvuyqpIw5QwOUGYGHYdfUywDo5MBgkolKk=;
	b=l9cINgltohrtcBrc+2AtYmFNx8lZUo78oRgRikFYsusMSs99QnTpPxcYIQXUPu1wyugYP8
	iJkure1G943I4FPT/NCqiPEGjQaOP5goQgwlF5oWncxnldZqeUfOCLb1/dg3cED7tv6hL8
	kQQWjvNpP0As3m+DftnL7if3nTiV5hc=
Date: Fri, 21 Nov 2025 16:17:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 05/26] mm: memcontrol: allocate object cgroup for
 non-kmem case
To: Chen Ridong <chenridong@huaweicloud.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <05ef300193bbe5bb7d2d97723efe928dab60429b.1761658310.git.zhengqi.arch@bytedance.com>
 <f31661d8-21e4-4626-86bb-8a8daa5d47ef@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <f31661d8-21e4-4626-86bb-8a8daa5d47ef@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5972640013
X-Stat-Signature: hu9gkpswpz1ftobeditg7bkc71ud4adn
X-HE-Tag: 1763713091-943005
X-HE-Meta: U2FsdGVkX18NpBX4E/BLUWuHKEaqgiKEVmRKPV5CHfTs/R2pp5cQSvG4R8Ppk3KTJgTsgTtwWDToPU75/acUy8P7S+5TXT67cZIolLWyOkxhVDJtpnvFC26I5qZM1fBoZVQsrZxniSf9baR8aAXafoZ/hLOBRQH2bJ6ULlB/eOoX/fw+oYOGeaLxN9LE7sPfdHel1kHYc4myOFOm/0EDLxraK7AUlXQazDWN7TiBYM1bfuBLBEYCMnjTxCpgncptC8iJAnP17KMopiEUIrrVo/wMAswrC5m20KhcbomsY0aHBerz4XIyPGcG/+924IrManXw06d0TvSeGx1Wst0uQfvckuxPpjkVk72Dk0VqXRn2XcnaiYKoRnwWQpQITwFzUHtFuhVUKFunHTQydwlhkOSsjM6W/MvNsJLP14jk3RFJ65+Hnk5zWaVZh76g7gH7craOgdxhUmyE6D0AMYfDKGh48b5HqnzuVfRER4+Mk4HOSQi7nuAnfmBcKikKc0qflaOkBWkCDzmgx235XgCsU7YKs7pO32wBNRRW8xfvU9JKi7WCWxmmBzUUJKU6yEtj1TPtYfVr3lTRSyVGVn1+MYz9cb50USAXKDJ4hwexflv93ImeU40VJnZnr9ooTfxd3Vv2Di3tuVLZeTgF9tW4A2rD1ulfnaP8NqfVL6eBPLUfKuT97e4zqmqzod6lEYacjOEPxNvHeqTJFBnXKURSh48yM65WuwntZDxxUvQ5Lyb9A9oVaQVc+5LJ1D1xCjkWp9i1gNehEcFzXfEuH4nICgSx7Vr8ngJxmKi7TPDhE0ynycRuXwbS1Nrg717+QiN8yEAxlePiJSQFwdvRb1T6owfUxvFFZPDV6LzkU8tJLFUSSvNe3obAGL4XN+7n1G4f82aXCRhyDBFsUDgzc8zVjQ6WUfXY2aZIBT4ioon2Ez9CPXImjvf0Bb7/ZS2a7w2GqFEVcdzOF9oLUtHnQmi
 1LSw8GS7
 uL4CkxtOnuSL/+XkUBxQI8mgRDMYc+el96FubD1aIswL1YT+u4Qfx7ZaTjWQ75568Du6zT848uBikZ8sUhrBGX/EVmqi0siz9+X+TlIkycLHLYwA9VO+ZvG1XJlhhBoRDyK292I87zAzmIhz7meShgeV7KiM3GMPOpvIp66aqQloOPWFW/D5ZN9a/wyaA3nUXHSY8pFetyxAjLrtQza1wkMMJTdTZl0xt3Ph/Qg1dXoAjC8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/21/25 11:58 AM, Chen Ridong wrote:
> 
> 
> On 2025/10/28 21:58, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> Pagecache pages are charged at allocation time and hold a reference
>> to the original memory cgroup until reclaimed. Depending on memory
>> pressure, page sharing patterns between different cgroups and cgroup
>> creation/destruction rates, many dying memory cgroups can be pinned
>> by pagecache pages, reducing page reclaim efficiency and wasting
>> memory. Converting LRU folios and most other raw memory cgroup pins
>> to the object cgroup direction can fix this long-living problem.
>>
>> As a result, the objcg infrastructure is no longer solely applicable
>> to the kmem case. In this patch, we extend the scope of the objcg
>> infrastructure beyond the kmem case, enabling LRU folios to reuse
>> it for folio charging purposes.
>>
>> It should be noted that LRU folios are not accounted for at the root
>> level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
>> the folio->memcg_data of LRU folios always points to a valid pointer.
>> However, the root_mem_cgroup does not possess an object cgroup.
>> Therefore, we also allocate an object cgroup for the root_mem_cgroup.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/memcontrol.c | 51 +++++++++++++++++++++++--------------------------
>>   1 file changed, 24 insertions(+), 27 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index d5257465c9d75..2afd7f99ca101 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -204,10 +204,10 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
>>   	return objcg;
>>   }
>>   
>> -static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
>> -				  struct mem_cgroup *parent)
>> +static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
>>   {
>>   	struct obj_cgroup *objcg, *iter;
>> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>>   
>>   	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
>>   
>> @@ -3302,30 +3302,17 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>>   	return val;
>>   }
>>   
>> -static int memcg_online_kmem(struct mem_cgroup *memcg)
>> +static void memcg_online_kmem(struct mem_cgroup *memcg)
>>   {
>> -	struct obj_cgroup *objcg;
>> -
>>   	if (mem_cgroup_kmem_disabled())
>> -		return 0;
>> +		return;
>>   
>>   	if (unlikely(mem_cgroup_is_root(memcg)))
>> -		return 0;
>> -
>> -	objcg = obj_cgroup_alloc();
>> -	if (!objcg)
>> -		return -ENOMEM;
>> -
>> -	objcg->memcg = memcg;
>> -	rcu_assign_pointer(memcg->objcg, objcg);
>> -	obj_cgroup_get(objcg);
>> -	memcg->orig_objcg = objcg;
>> +		return;
>>   
>>   	static_branch_enable(&memcg_kmem_online_key);
>>   
>>   	memcg->kmemcg_id = memcg->id.id;
>> -
>> -	return 0;
>>   }
>>   
>>   static void memcg_offline_kmem(struct mem_cgroup *memcg)
>> @@ -3340,12 +3327,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
>>   
>>   	parent = parent_mem_cgroup(memcg);
>>   	memcg_reparent_list_lrus(memcg, parent);
>> -
>> -	/*
>> -	 * Objcg's reparenting must be after list_lru's, make sure list_lru
>> -	 * helpers won't use parent's list_lru until child is drained.
>> -	 */
>> -	memcg_reparent_objcgs(memcg, parent);
>>   }
>>   
>>   #ifdef CONFIG_CGROUP_WRITEBACK
>> @@ -3862,9 +3843,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>>   static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   {
>>   	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>> +	struct obj_cgroup *objcg;
>>   
>> -	if (memcg_online_kmem(memcg))
>> -		goto remove_id;
>> +	memcg_online_kmem(memcg);
>>   
>>   	/*
>>   	 * A memcg must be visible for expand_shrinker_info()
>> @@ -3874,6 +3855,15 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   	if (alloc_shrinker_info(memcg))
>>   		goto offline_kmem;
>>   
>> +	objcg = obj_cgroup_alloc();
>> +	if (!objcg)
>> +		goto free_shrinker;
>> +
>> +	objcg->memcg = memcg;
>> +	rcu_assign_pointer(memcg->objcg, objcg);
>> +	obj_cgroup_get(objcg);
>> +	memcg->orig_objcg = objcg;
>> +
> 
> Will it be better to add a helper function like obj_cgroup_init()?

This part is not complicated, and it is only called in this one place,
so perhaps there is no need to add a helper function?

Of course, it doesn't matter, I'm fine with either method.

> 
>>   	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
>>   		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
>>   				   FLUSH_TIME);
>> @@ -3896,9 +3886,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
>>   
>>   	return 0;
>> +free_shrinker:
>> +	free_shrinker_info(memcg);
>>   offline_kmem:
>>   	memcg_offline_kmem(memcg);
>> -remove_id:
>>   	mem_cgroup_id_remove(memcg);
>>   	return -ENOMEM;
>>   }
>> @@ -3916,6 +3907,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>>   
>>   	memcg_offline_kmem(memcg);
>>   	reparent_deferred_split_queue(memcg);
>> +	/*
>> +	 * The reparenting of objcg must be after the reparenting of the
>> +	 * list_lru and deferred_split_queue above, which ensures that they will
>> +	 * not mistakenly get the parent list_lru and deferred_split_queue.
>> +	 */
>> +	memcg_reparent_objcgs(memcg);
>>   	reparent_shrinker_deferred(memcg);
>>   	wb_memcg_offline(memcg);
>>   	lru_gen_offline_memcg(memcg);
> 


