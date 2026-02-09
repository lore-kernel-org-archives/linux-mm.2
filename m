Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899CDEF06E5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 03:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6DF6B0089; Sun,  8 Feb 2026 22:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84916B0092; Sun,  8 Feb 2026 22:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90C46B0093; Sun,  8 Feb 2026 22:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94D246B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 22:50:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28F2F1A0688
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:50:07 +0000 (UTC)
X-FDA: 84423540054.14.571BA45
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04071C0009
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:50:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AHdaa4Km;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770609005; a=rsa-sha256;
	cv=none;
	b=mntfbq3Q5tz0dwZyo5h1LhNCJhbUAlAirAdGhfLxkyE5S7QWTPbV2WgjVXoRE6VBiiTfV1
	/ZQrf36lu+FG3uChP5q+xLC0sUZQnen0q2Yffsn6LZ+d3yuF998MkhlqSoptgnQru/Yjj4
	ddzgIiQ5PYlhjQkElrmXAqioHE/jqz8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AHdaa4Km;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770609005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUEvjV24W4taMCJI79PwPAm96gzGFacZTZhUwE8Scdw=;
	b=1FqevA94eJvSZNX1Bv3lHeuY4EoFxD4B84yJnuCjc6cHpbOHhTDCSp459UHyJv3RNj3YDF
	47GGSS3H1eLKWJFyuhwLOyrn/4V+RG73rGV8XuJZLCzgCVw/JS3XhJ6DE5ej65Uus0THRv
	I7pdsmevg+Qjmhz7ejKQa8bd+Lb8VNs=
Message-ID: <2a0e4ae2-457b-4d16-a7b9-7372fd665337@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770609002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUEvjV24W4taMCJI79PwPAm96gzGFacZTZhUwE8Scdw=;
	b=AHdaa4KmJv0DVYbZg2OETQenH+i0unZQZKmxwtvZguQZPX0Z3ACaDjJDpeJbB65N60qqHY
	dRVVsXNsFHEXwd/IfzXfcPLnHCh69Sd0TQlJ1CpeaBHIqt1CMrNe8grlG0RbwoKvWbZwIT
	XurKQaHuQceIlzO7x+59wMkxJ0iYw+E=
Date: Mon, 9 Feb 2026 11:49:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 30/31] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
 <aYe1R2MMcXbPVYUW@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aYe1R2MMcXbPVYUW@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04071C0009
X-Stat-Signature: xtdea45ux1gyno7odjnj9kih7ti3wu89
X-HE-Tag: 1770609004-451708
X-HE-Meta: U2FsdGVkX19FnQ+bTfwM4Ka0p2f5JwytFoB0R4/EoZb0Wms3cl7kuuVmmYM7u101ItqBu6YlolLc4rpZtIICL9QOjI3pX9HVnf0s1Y4JyqmxgAerHdZjluw/e/YMAjaRnWbMj20nuQJx1yh0UytaMeP+yJx3TfqyWLqpr2MlB9AhcVFMBTNzNucHl86GyYv1MY85rlgnUwX5OFEaS27+D8sWFrJ3atthVAaV0gtjJOQuQBPlXS1jezMzAnXFJcC745/9LjoFUFnEpZDL6XeGWUdONlR0hb3OMokJUVWC9oAaY24MtV4fYk00UeLN9NVqnQkikHQXlkOS8fIJxkD2QniE9RbUQXtJG3xjdIdwdi+dRmGLkMcodzZWtA8xpRvmoSD3FmnACOqqB5mQDaiskh/F0C/JPCMeGI31Im1kjhYG3ZnKXvRngdAY0ko8qDjyxf3RTdiKYHTn4rXXReLo46HEi8u6qhjG+UH5P+hbGql3nNXwjxGIXB1CbP5GoBPt/J53PzHIwXOXtPgFzS3kgwCAPMlgUvsJtxN0ego+FnAE6Kef5CRngCBeOE0k/z9Z24vUjeui5bkI94CyudC+im3TZkHhnH//0mtOTqSDApfDOawQvGrfCpR4V7w4kaJnwv2VMdMCQYlbIliYR6uhgObcw1otKB+ksGJ1P7WjzskIMVpjTAGOewwZH8J/i7a5zoXVgKlPAT28WfVmSaRWtgGgHYxznpCKTKOSRoJIz8KO1nx6D+h/CJX/OCOaeZbD61l/smPp7VUqhYK4lbt91LyyUlHfCophOLih+OCPv6jhetXEtAcBQHX1GWza/tJepEAjzIuU0rT+EYnEQM7huS8SB90UrugQ0YOOmjEaj93rRvjMjTWn0DeDrue+ic/F8Qj9hVmK9FAMKNfyEcpesn+kAUNddR/2yWt7pWIrxE/uSq+ljXojoIENtj13hrdFryUh8SfJV2YWEsmk86D
 YIu/CNk5
 OWq+nchD4PUCDKpqfpbsfDidFPSfU8ICXC+QTVD/s/w52AUkYtdLf9FMdO40azTL6n0f8sUqCtNzFj4nLfcwu5TGve0aV+fccyJJ3BBHtDxBwOh90/8xgRYOpWBpebPN+m4/wp3DXgr5CTBAdNhltpuJZNn3PP/Q8wEjTuebGLppb+U4GqupglUewpeZtA2oRpedEuCoF0HI23Cd36VFIQtkqTH9N5T0IXQO666o03tljmqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/8/26 6:25 AM, Shakeel Butt wrote:
> On Thu, Feb 05, 2026 at 05:01:49PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> Now that everything is set up, switch folio->memcg_data pointers to
>> objcgs, update the accessors, and execute reparenting on cgroup death.
>>
>> Finally, folio->memcg_data of LRU folios and kmem folios will always
>> point to an object cgroup pointer. The folio->memcg_data of slab
>> folios will point to an vector of object cgroups.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>   
>>   /*
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e7d4e4ff411b6..0e0efaa511d3d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -247,11 +247,25 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>>   
>>   static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>   {
>> +	int nid, nest = 0;
>> +
>>   	spin_lock_irq(&objcg_lock);
>> +	for_each_node(nid) {
>> +		spin_lock_nested(&mem_cgroup_lruvec(memcg,
>> +				 NODE_DATA(nid))->lru_lock, nest++);
>> +		spin_lock_nested(&mem_cgroup_lruvec(parent,
>> +				 NODE_DATA(nid))->lru_lock, nest++);
> 
> Is there a reason to acquire locks for all the node together? Why not do
> the for_each_node(nid) in memcg_reparent_objcgs() and then reparent the
> LRUs for each node one by one and taking and releasing lock
> individually. Though the lock for the offlining memcg might not be

To do this, we first need to convert objcg from per-memcg to per-memcg
per-node. In this way, we can hold the lru lock and objcg lock for
each node to reparent the folio and the corresponding objcg together.

Otherwise, the folio might have been moved to the parent lruvec, but
objcg hasn't been reparent. In that case, it might be holding the lock
of child lruvec to operate on the folio on the parent lruvec.

> contentious but the parent's lock might be if a lot of memory has been
> reparented.
> 
>> +	}
>>   }
>>   
>>   static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>   {
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		spin_unlock(&mem_cgroup_lruvec(parent, NODE_DATA(nid))->lru_lock);
>> +		spin_unlock(&mem_cgroup_lruvec(memcg, NODE_DATA(nid))->lru_lock);
>> +	}
>>   	spin_unlock_irq(&objcg_lock);
>>   }
>>   
>> @@ -260,12 +274,28 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
>>   	struct obj_cgroup *objcg;
>>   	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>>   
>> +retry:
>> +	if (lru_gen_enabled())
>> +		max_lru_gen_memcg(parent);
>> +
>>   	reparent_locks(memcg, parent);
>> +	if (lru_gen_enabled()) {
>> +		if (!recheck_lru_gen_max_memcg(parent)) {
>> +			reparent_unlocks(memcg, parent);
>> +			cond_resched();
>> +			goto retry;
>> +		}
>> +		lru_gen_reparent_memcg(memcg, parent);
>> +	} else {
>> +		lru_reparent_memcg(memcg, parent);
>> +	}
>>   
>>   	objcg = __memcg_reparent_objcgs(memcg, parent);
> 
> The above does not need lru locks. With the per-node refactor, it will
> be out of lru lock.
> 
>>   
>>   	reparent_unlocks(memcg, parent);
>>   
>> +	reparent_state_local(memcg, parent);
>> +
>>   	percpu_ref_kill(&objcg->refcnt);
>>   }
>>   
>>   
> 
> [...]
> 
>>   static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>>   			gfp_t gfp)
>>   {
>> -	int ret;
>> -
>> -	ret = try_charge(memcg, gfp, folio_nr_pages(folio));
>> -	if (ret)
>> -		goto out;
>> +	int ret = 0;
>> +	struct obj_cgroup *objcg;
>>   
>> -	css_get(&memcg->css);
>> -	commit_charge(folio, memcg);
>> +	objcg = get_obj_cgroup_from_memcg(memcg);
>> +	/* Do not account at the root objcg level. */
>> +	if (!obj_cgroup_is_root(objcg))
>> +		ret = try_charge(memcg, gfp, folio_nr_pages(folio));
> 
> Use try_charge_memcg() directly and then this will remove the last user
> of try_charge, so remove try_charge completely.
> 
>> +	if (ret) {
>> +		obj_cgroup_put(objcg);
>> +		return ret;
>> +	}
>> +	commit_charge(folio, objcg);
>>   	memcg1_commit_charge(folio, memcg);
>> -out:
>> +
>>   	return ret;
>>   }
>>   


