Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80568E7AD77
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 03:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2116B0088; Thu, 25 Dec 2025 22:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C506B6B0089; Thu, 25 Dec 2025 22:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31966B008A; Thu, 25 Dec 2025 22:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A097A6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:10:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40B561408F9
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:10:51 +0000 (UTC)
X-FDA: 84260145102.08.51F669A
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 481BEC000D
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:10:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F1rcE0X5;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766718649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oakc8UIltDCqM50pbiDVUP88U4Bwxm69FCpdnnX3hns=;
	b=UDojHv6iEv8cBZdDwzvUfKUTQ8bohODT0kdfCeAJ4Mgmha71QK80fGBD4fcHJFpvF8uKvz
	HOcuYN3qxdSZ38SMLV+jmBPKaNnnLaISF6gUyhIMgAsAoSM0ycz9GZJds/OTjgnUICmMJG
	DAGbNwG6EiPBMA1TL2LuLPtnJXobtAA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F1rcE0X5;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766718649; a=rsa-sha256;
	cv=none;
	b=4tvQOHB9gC5a7yx2oXwo02Ay/DeUgUltYUfGLNyU5MMdLrIbco+dB68cOvTHWjyDZ/tLzt
	83rzFYkp9xPKm3soCyPeAarIhLy7ljZ+DlzKhA7w5HY9Munoko7pOBh+uI4tXUtOCWV/1o
	tF4gQJHmnUfH0xZgIjWbIA6SQDyBk+E=
Message-ID: <a055507f-9c4d-4fb1-b5a6-bda9c2dc20ac@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766718645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oakc8UIltDCqM50pbiDVUP88U4Bwxm69FCpdnnX3hns=;
	b=F1rcE0X51B4tiRn0V9OLndqsZkOiOeIoMejY+ZIBYwnNfFhgrjbtHaTIXc8Mp7ONsrsfkf
	7CCxsZJFda1viXd/0vFCv4ULvpZcwyEWRrQn7Q73ooh7h+9eChDvuYHHRlh3hBEDu8vEB4
	cYiXwFGZqDn2zaP8MSwF7Lav6dxbZwU=
Date: Fri, 26 Dec 2025 11:10:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 07/28] mm: memcontrol: return root object cgroup for
 root memory cgroup
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Qi Zheng <qi.zheng@linux.dev>,
 hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <3e454b151f3926dbd67d5df6dc2b129edd927101.1765956025.git.zhengqi.arch@bytedance.com>
 <05500a05-aa90-4b60-a324-2819dc2c5805@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <05500a05-aa90-4b60-a324-2819dc2c5805@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 481BEC000D
X-Stat-Signature: 4rjihy3rgsdy6rc6youpb5hg8cdwo3jt
X-HE-Tag: 1766718649-823514
X-HE-Meta: U2FsdGVkX18A1GKcF92Vcin1VmCw2rauJWQUJZ8jmoZjPjUWgndpkX3gsYCjkbaIQOpYAoabVAZ3HAUUeuAzOVs92N3gXUR/KkYmwe7D/VQOLh45oiYr7OlqpOOYRE+buuDmgu/YHHbg25wstT6b0LZnSIK3IwcocpTh7IEIDajqWVSwX3tYzKdb118k+08tSEtQuG+cA2iwl/d7DPu9PzA/LYfT3LKyLZrSl+rMTKdwnQUTMWTt9tfYhB/jymMsJ5JEXRZlgynhxaLWHtdW1Yc3s+RVHUMfTb7GpOgErRLDYcVWG64wFGjcGF5A90lA61dGhyPgIdyabPAttmhAgig/ZT1EvSwc0tTyzfK63bsle99IK3isGO0GGennFprJ9AkWhjDXmN15nx12yJKmSX0Ut8M/w4dbe+97u7XA/JF6InzNe+8GQElNDJ6KCdRFYYzeEFR0BuiImQnPW6c3m6jDf0PtDmtMUZJcQQCeZjWFeqvbCrehPghRztOCrr1/9nvlD4zMx24jybxQW6Yu+n4o2q7rinRTw//RnSlxXkyg6PdCXuP2SjlyYj4Lbb2Ads0lvB+t6bax9F3IHm2HlFTc0KyQjmTMqYwSOjU/mZngOUpTKsK73nhqmJaNoG/cJ9P8gzs/iru24AwKl/fadrw9LIziTx51oVI+ajSA7YDFBYRtOj4e9ysIEenA83ikl4A64eBUQLgDzRS0fd7cxrTYE/keOp0eR0E13Q2xnc2VS9uXM9Q5JqPg1OaOyXpp5VwhXpLL4hDq1dzhKCN0TJDT2bd4UuPmTrYjwW792bal2XZvVBz/QQgvtjKROhKthsq7kqqmJUvsfRabKzRYqKQv0pimeHfEXYS0CU8oO8viwehsPCe+trLQY4Z5UcxnnHoU+3JYbJD91QoQeziPJuoXRT1AhDlpM9/iypcivjHF+PzIkDnCCCIHgKn8dfpksoUODITPhxy0Fgbpyc0
 tSXto/UG
 2FlpYn67qG9zviyLKLdE7B3TEWJ/bjSMaDDN5zhgQmyXb0WLwFcbOoeV+qBEAMz264hevDCkc6nLptJDJWimztnfPlZDtmwfDSMU/MfbfG/YZqIjQ/29JJMvEPcRbU+cSMVZqOEaC6qoVAZwGnUl1DSncKxCpqQfrkEUVQ1VWLphHg9oczYs5AMUU43bN4j33WDOv781eI+MdDAAi/2Z6XQ8cwiPx/RS2sz2ASBCLc277OjLUMHgCA4WPe1CqugUWqgCIPUGLSo57Q6c32Eb2+XofNpgfEapnTsV5LfhcHIM44O0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/26 09:03, Chen Ridong wrote:
>
> On 2025/12/17 15:27, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> Memory cgroup functions such as get_mem_cgroup_from_folio() and
>> get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
>> even for the root memory cgroup. In contrast, the situation for
>> object cgroups has been different.
>>
>> Previously, the root object cgroup couldn't be returned because
>> it didn't exist. Now that a valid root object cgroup exists, for
>> the sake of consistency, it's necessary to align the behavior of
>> object-cgroup-related operations with that of memory cgroup APIs.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/memcontrol.h | 26 +++++++++++++++++-----
>>   mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
>>   mm/percpu.c                |  2 +-
>>   3 files changed, 45 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 288dd6337f80f..776d9be1f446a 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -332,6 +332,7 @@ struct mem_cgroup {
>>   #define MEMCG_CHARGE_BATCH 64U
>>   
>>   extern struct mem_cgroup *root_mem_cgroup;
>> +extern struct obj_cgroup *root_obj_cgroup;
>>   
>>   enum page_memcg_data_flags {
>>   	/* page->memcg_data is a pointer to an slabobj_ext vector */
>> @@ -549,6 +550,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>>   	return (memcg == root_mem_cgroup);
>>   }
>>   
>> +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>> +{
>> +	return objcg == root_obj_cgroup;
>> +}
>> +
>>   static inline bool mem_cgroup_disabled(void)
>>   {
>>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>> @@ -773,23 +779,26 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
>>   
>>   static inline bool obj_cgroup_tryget(struct obj_cgroup *objcg)
>>   {
>> +	if (obj_cgroup_is_root(objcg))
>> +		return true;
>>   	return percpu_ref_tryget(&objcg->refcnt);
>>   }
>>   
>> -static inline void obj_cgroup_get(struct obj_cgroup *objcg)
>> +static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
>> +				       unsigned long nr)
>>   {
>> -	percpu_ref_get(&objcg->refcnt);
>> +	if (!obj_cgroup_is_root(objcg))
>> +		percpu_ref_get_many(&objcg->refcnt, nr);
>>   }
>>   
>> -static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
>> -				       unsigned long nr)
>> +static inline void obj_cgroup_get(struct obj_cgroup *objcg)
>>   {
>> -	percpu_ref_get_many(&objcg->refcnt, nr);
>> +	obj_cgroup_get_many(objcg, 1);
>>   }
>>   
>>   static inline void obj_cgroup_put(struct obj_cgroup *objcg)
>>   {
>> -	if (objcg)
>> +	if (objcg && !obj_cgroup_is_root(objcg))
>>   		percpu_ref_put(&objcg->refcnt);
>>   }
>>   
>> @@ -1084,6 +1093,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>>   	return true;
>>   }
>>   
>> +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>> +{
>> +	return true;
>> +}
>> +
>>   static inline bool mem_cgroup_disabled(void)
>>   {
>>   	return true;
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 544b3200db12d..21b5aad34cae7 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -83,6 +83,8 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
>>   struct mem_cgroup *root_mem_cgroup __read_mostly;
>>   EXPORT_SYMBOL(root_mem_cgroup);
>>   
>> +struct obj_cgroup *root_obj_cgroup __read_mostly;
>> +
>>   /* Active memory cgroup to use from an interrupt context */
>>   DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
>>   EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
>> @@ -2634,15 +2636,14 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>>   
>>   static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>>   {
>> -	struct obj_cgroup *objcg = NULL;
>> +	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>> +		struct obj_cgroup *objcg = rcu_dereference(memcg->objcg);
>>   
>> -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>> -		objcg = rcu_dereference(memcg->objcg);
>>   		if (likely(objcg && obj_cgroup_tryget(objcg)))
>> -			break;
>> -		objcg = NULL;
>> +			return objcg;
>>   	}
>> -	return objcg;
>> +
>> +	return NULL;
>>   }
>>   
>>   static struct obj_cgroup *current_objcg_update(void)
>> @@ -2716,18 +2717,17 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
>>   		 * Objcg reference is kept by the task, so it's safe
>>   		 * to use the objcg by the current task.
>>   		 */
>> -		return objcg;
>> +		return objcg ? : root_obj_cgroup;
>>   	}
>>   
>>   	memcg = this_cpu_read(int_active_memcg);
>>   	if (unlikely(memcg))
>>   		goto from_memcg;
>>   
>> -	return NULL;
>> +	return root_obj_cgroup;
>>   
>>   from_memcg:
>> -	objcg = NULL;
>> -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>> +	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>>   		/*
>>   		 * Memcg pointer is protected by scope (see set_active_memcg())
>>   		 * and is pinning the corresponding objcg, so objcg can't go
>> @@ -2736,10 +2736,10 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
>>   		 */
>>   		objcg = rcu_dereference_check(memcg->objcg, 1);
>>   		if (likely(objcg))
>> -			break;
>> +			return objcg;
>>   	}
>>   
>> -	return objcg;
>> +	return root_obj_cgroup;
>>   }
>>   
>>   struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
>> @@ -2753,14 +2753,8 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
>>   		objcg = __folio_objcg(folio);
>>   		obj_cgroup_get(objcg);
>>   	} else {
>> -		struct mem_cgroup *memcg;
>> -
>>   		rcu_read_lock();
>> -		memcg = __folio_memcg(folio);
>> -		if (memcg)
>> -			objcg = __get_obj_cgroup_from_memcg(memcg);
>> -		else
>> -			objcg = NULL;
>> +		objcg = __get_obj_cgroup_from_memcg(__folio_memcg(folio));
>>   		rcu_read_unlock();
>>   	}
>>   	return objcg;
>> @@ -2863,7 +2857,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
>>   	int ret = 0;
>>   
>>   	objcg = current_obj_cgroup();
>> -	if (objcg) {
>> +	if (objcg && !obj_cgroup_is_root(objcg)) {
>>   		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
>>   		if (!ret) {
>>   			obj_cgroup_get(objcg);
>> @@ -3164,7 +3158,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>   	 * obj_cgroup_get() is used to get a permanent reference.
>>   	 */
>>   	objcg = current_obj_cgroup();
>> -	if (!objcg)
>> +	if (!objcg || obj_cgroup_is_root(objcg))
>>   		return true;
>>   
>>   	/*
>> @@ -3851,6 +3845,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   	if (!objcg)
>>   		goto free_shrinker;
>>   
>> +	if (unlikely(mem_cgroup_is_root(memcg)))
>> +		root_obj_cgroup = objcg;
>> +
>>   	objcg->memcg = memcg;
>>   	rcu_assign_pointer(memcg->objcg, objcg);
>>   	obj_cgroup_get(objcg);
>> @@ -5471,6 +5468,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
>>   	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>   		return;
>>   
>> +	if (obj_cgroup_is_root(objcg))
>> +		return;
>> +
>>   	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
>>   
>>   	/* PF_MEMALLOC context, charging must succeed */
>> @@ -5498,6 +5498,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
>>   	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>   		return;
>>   
>> +	if (obj_cgroup_is_root(objcg))
>> +		return;
>> +
>>   	obj_cgroup_uncharge(objcg, size);
>>   
> If we modify zswap by adding MEMCG_ZSWAP_B and MEMCG_ZSWAPPED with obj_cgroup_charge_zswap , then
> remove a control group (via rmdir) and reparent its objects to the root cgroup, then for the root
> cgroup, obj_cgroup_uncharge_zswap will return directly due to the obj_cgroup_is_root check. Would
> this cause us to miss decrementing MEMCG_ZSWAP_B and MEMCG_ZSWAPPED?

I'm not sure I fully understand the problem—how could this happen, given 
that
obj_cgroup_charge_zswap also checks for the root objcg?

Muchun,
Thanks.
>
>>   	rcu_read_lock();
>> diff --git a/mm/percpu.c b/mm/percpu.c
>> index 81462ce5866e1..5c1a9b77d6b93 100644
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -1616,7 +1616,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
>>   		return true;
>>   
>>   	objcg = current_obj_cgroup();
>> -	if (!objcg)
>> +	if (!objcg || obj_cgroup_is_root(objcg))
>>   		return true;
>>   
>>   	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))


