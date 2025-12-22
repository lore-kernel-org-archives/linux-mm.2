Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4373D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 04:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2326A6B0088; Sun, 21 Dec 2025 23:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6616B0089; Sun, 21 Dec 2025 23:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C20D6B008A; Sun, 21 Dec 2025 23:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F13F76B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:00:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7F72B983E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:00:03 +0000 (UTC)
X-FDA: 84245753886.05.7F53DD6
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB7071C0004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:00:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6v2xQ7M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766376002; a=rsa-sha256;
	cv=none;
	b=X5j05Mr43MM2pwznyvhZYu2PWdZd/SdPDasOS43WmvsmBimEUgzooO9BYNKWl13bkR9o0b
	WJd/5OXDOMmoORRahxmWduoU0Cxqa9K7f2NES34LkRULV68Im4daPRP7oSkabtSDTYb1PX
	jhsHCgNkpJpl8abUgQJ1eslkFc9Pl/Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6v2xQ7M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766376002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMAUFbvixYMyej2RaSYfA1urQk5c5I28T+hhpcsE9H0=;
	b=eKL/Y1km37mRaj88b7DnRcJ1w84a39KmWJ08Ee64JxZKhAKFWWCnwvaxCAst0uw5WFhvFz
	bhZqg/KyfGwVN6iYwcAuwug2DiCW84hdb0H7XERKlPTS+qnonh2dLnQDUPHtnCLnZ5GEvN
	dd38BLEomzwU+M9z5sKJ6oqc+Y8iUaU=
Message-ID: <646b9414-baf6-4278-b4df-5f4abeca5e67@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766375996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oMAUFbvixYMyej2RaSYfA1urQk5c5I28T+hhpcsE9H0=;
	b=g6v2xQ7M8QO66aigU0pLALSMnoZMrAa0ibLD6yQBpo955FlVEJHREynjUrmcTOE07I8f0P
	kpM7NEgztyVHuj9o+us7wsmmttYuoj6+q3bQ6rdT/yygYGfMGCeh5Mgad3knDvZ3QfhA0T
	Y6t6WGSMh9/TudxQzDc1wnao7Oa/uWg=
Date: Mon, 22 Dec 2025 11:59:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
 <aUQKdZsMclicBDYx@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUQKdZsMclicBDYx@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB7071C0004
X-Stat-Signature: jsxn1rdz81ghyrn63d4i871c6ckjow8k
X-Rspam-User: 
X-HE-Tag: 1766376001-67334
X-HE-Meta: U2FsdGVkX19jD4VxXJTB/Y7ANJ+6d2p8er8JePZaEvTYi04uc75jiWC0Y2xnCpu1CNmLavyYG9zZTiZO89jzUtC3nA18AS2BEocbPe9XvyK7kexTTO1YYSe8RWztbkgMIsgP1ip5z2xxJrVMHKhaZ2LXOd5Wj2LdM0wHKtBJ0I+wUVCHkhH3uIF+Ueh01/azVJS4yT+duEEmMDno/aGWzR1+OWpXIE9USZdtBWF0swZFtU28NOn3FBAvjWQ4uGSiFIkKjUXokaOcOC7CgLpOSz25oQZhWkj20dq+ehsjsaMiVHktasW+b8BCvTMwe1ViqGgpJQnaf7+i9xXKwI3Gb595Q8FuoBSDoWDvJRtHOua/bOsY7pvloiB/N4clLDpGeAvdYLHaFbRYGjSpkTiJlBZPwY7wLKLEnXGqWIWhP9Y+rWIHFBaoc27Tbk2zt04etHHAg4FtYhETJ36tLVj68LY+ZRpjXbLrRU7ZNOloyHhZH5ba6cnMSNiszPOF31BLLCQxWnJmfQpc3nPBUF49aQdoPQHAKo7gnYI5o95tAUel5KM1LOBx+xtYSZDlwJnLbSeLnhgc09Bg79ERePmSw/U6ooiYbdnwvSKjj19CawM41QSfz6KxQ1yRNxpk7j6SMiNT7ixX7eneHndzkOfevtIFcK/WNm0L0xP/pkz9EcSCj2R/+5U4mGmpLCdrJL6ygVCaJPITzpgtwCBPeE0sfwnO5qoC+GakU+I0esvGLyU0CXrDQ8slZrq9GC+7kOj93J1YjH15VX4mAKAi2qh2AQwTDu/uET7jLg304GlKsSFoADmHphAGy5Ycob+G/UgEr0qL4CieWKqbyesiOTy+KYfdSukH4XTCVzbiDqeumtcpF3ZZVsNQ4sVmcjJoSr9Ve8wFti2SkiZC8IZVT5ch6hIaHXncSgFDykfRuBQCxYULT+/DHqiTBHgFb8VtxhglTKxErglKhF+4CNClV9x
 0JZUm6G8
 Hd4Od6dUVmIvDhaj8fP2iPEFSpT5AWsAKEIm7BviKiriSggiq0Uyvp+t34hLrcMDr2uHsTkt+jqhseuCENrwr0ooyao3LVsfGD5AXtT9pEUI6kEZVyvWSJ6DHv9xTAYAWIdYDYLv+7PonloG7gnHPQl9le99YPKtNy0HZ/dYh7BdAbEjZV3aP9yoJjAMdnVC8ic3WqWPqHtXy9WVMMCMjHJU4rvxlHm7f6KowLgH4ApfgTiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 10:06 PM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:51PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> Pagecache pages are charged at allocation time and hold a reference
>> to the original memory cgroup until reclaimed. Depending on memory
>> pressure, page sharing patterns between different cgroups and cgroup
>> creation/destruction rates, many dying memory cgroups can be pinned
>> by pagecache pages, reducing page reclaim efficiency and wasting
>> memory. Converting LRU folios and most other raw memory cgroup pins
>> to the object cgroup direction can fix this long-living problem.
> 
> This is already in the coverletter. Please describe here what the
> patch itself does. IOW, now that everything is set up, switch
> folio->memcg_data pointers to objcgs, update the accessors, and
> execute reparenting on cgroup death.

Got it, will do.

> 
>> Finally, folio->memcg_data of LRU folios and kmem folios will always
>> point to an object cgroup pointer. The folio->memcg_data of slab
>> folios will point to an vector of object cgroups.
> 
>> @@ -223,22 +223,55 @@ static inline void __memcg_reparent_objcgs(struct mem_cgroup *src,
>>   
>>   static inline void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
>>   {
>> +	int nid, nest = 0;
>> +
>>   	spin_lock_irq(&objcg_lock);
>> +	for_each_node(nid) {
>> +		spin_lock_nested(&mem_cgroup_lruvec(src,
>> +				 NODE_DATA(nid))->lru_lock, nest++);
>> +		spin_lock_nested(&mem_cgroup_lruvec(dst,
>> +				 NODE_DATA(nid))->lru_lock, nest++);
>> +	}
>>   }
> 
> Looks okay to me. If this should turn out to be a scalability problem
> in practice, we can make objcgs per-node, and then reparent lru/objcg
> pairs on a per-node basis without nesting locks.
> 
>>   static inline void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
>>   {
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		spin_unlock(&mem_cgroup_lruvec(dst, NODE_DATA(nid))->lru_lock);
>> +		spin_unlock(&mem_cgroup_lruvec(src, NODE_DATA(nid))->lru_lock);
>> +	}
>>   	spin_unlock_irq(&objcg_lock);
>>   }
>>   
>> +static void memcg_reparent_lru_folios(struct mem_cgroup *src,
>> +				      struct mem_cgroup *dst)
>> +{
>> +	if (lru_gen_enabled())
>> +		lru_gen_reparent_memcg(src, dst);
>> +	else
>> +		lru_reparent_memcg(src, dst);
>> +}
>> +
>>   static void memcg_reparent_objcgs(struct mem_cgroup *src)
>>   {
>>   	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
>>   	struct mem_cgroup *dst = parent_mem_cgroup(src);
>>   
>> +retry:
>> +	if (lru_gen_enabled())
>> +		max_lru_gen_memcg(dst);
>> +
>>   	reparent_locks(src, dst);
>> +	if (lru_gen_enabled() && !recheck_lru_gen_max_memcg(dst)) {
>> +		reparent_unlocks(src, dst);
>> +		cond_resched();
>> +		goto retry;
>> +	}
>>   
>>   	__memcg_reparent_objcgs(src, dst);
>> +	memcg_reparent_lru_folios(src, dst);
> 
> Please inline memcg_reparent_lru_folios() here, to keep the lru vs
> lrugen switching as "flat" as possible:
> 
> 	if (lru_gen_enabled()) {
> 		if (!recheck_lru_gen_max_memcgs(parent)) {
> 			reparent_unlocks(memcg, parent);
> 			cond_resched();
> 			goto retry;
> 		}
> 		lru_gen_reparent_memcg(memcg, parent);
> 	} else {
> 		lru_reparent_memcg(memcg, parent);
> 	}

Looks better, will change to this style.

> 
>> @@ -989,6 +1022,8 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
>>   /**
>>    * get_mem_cgroup_from_folio - Obtain a reference on a given folio's memcg.
>>    * @folio: folio from which memcg should be extracted.
>> + *
>> + * The folio and objcg or memcg binding rules can refer to folio_memcg().
> 
>        See folio_memcg() for folio->objcg/memcg binding rules.

OK, will do.



