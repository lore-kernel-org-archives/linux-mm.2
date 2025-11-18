Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D0A2CED606
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58656B00AB; Tue, 18 Nov 2025 06:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FBF6B00AC; Tue, 18 Nov 2025 06:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D266B00AD; Tue, 18 Nov 2025 06:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3D776B00AB
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:29:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FF9B4DA5B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:29:47 +0000 (UTC)
X-FDA: 84123508014.23.A2DF210
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5828B160009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:29:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gspnzMPR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763465385; a=rsa-sha256;
	cv=none;
	b=Enc1qln8bn+Ov6hOSuJPoLQtDhK+m/sCrPl9+XVPdYDxhnRQLl9tFCPAqSdufuNYg7qI4E
	9u6BdydjiDxw1x09Pb4G/xqydqsPCLkqaEDAlLQHCd5r3Ua/TDW2pu5gzsGYHPOrd5HSbR
	jwNLnM/oRHhLIjCWE5GTclgAoxSdiUc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gspnzMPR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763465385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0v0oDcmCB5Zh0jXwX66CTwJWuRZAjcycr0+mPGx35yo=;
	b=2mlGpvxstlWFFT6SyLnhEY0IAdRPa9irDypCgRRxeUWjCBOkJT74NhoMiAz48KofNuxOVm
	dXi/dF33Ug0GN7TcdtkLE3qhoMYP4TrCMp3sN8aaB0EL9QR+z8jQQ20upyU9jK22pf+DoE
	Ja6I1bd9e8wzbRIG0lCzGJ8hORQ7tp0=
Message-ID: <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763465382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0v0oDcmCB5Zh0jXwX66CTwJWuRZAjcycr0+mPGx35yo=;
	b=gspnzMPRplkGC7z867QwFTewkyJ1jjD8SAY4+hZ5grMuKYL4z3vcftv20YsB7Tvuoklsnr
	lIldrY/eVYcS/1pcbbKqyyBzBTryTYFum5nsvx+FUvKU0xMCV+MjQZ3x65rVy2dTaKNs0g
	adrtIcsNfbPNmXZFG6gXMX4BVkJRCjc=
Date: Tue, 18 Nov 2025 19:28:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 06/26] mm: memcontrol: return root object cgroup for
 root memory cgroup
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <5e9743f291e7ca7b8f052775e993090ed66cfa80.1761658310.git.zhengqi.arch@bytedance.com>
 <aRroO9ypxvHsAjug@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRroO9ypxvHsAjug@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5828B160009
X-Rspamd-Server: rspam07
X-Stat-Signature: o4uhg515de5g9gyx94mtyczwn1memo7p
X-Rspam-User: 
X-HE-Tag: 1763465385-157734
X-HE-Meta: U2FsdGVkX18ho89WdXp+cfUWBW7sdTzCknneVQtWsDbDeA33Dcqwb/K8TapHZ9iwDvwpnn7RlOR31hZxGYgMRK6DfijwjgEOxi+6iC3PU9ulAxz64HnttP5OwOLfoq9JCCYrpV6zNX5CZOe2QzCjyWLHreg/by1HbO/z5rruDwe4smNa7Zgl8A8yulyZNiUKYWDBcJj68ztQSKngPrzK2tIx7KPcYJ+MMci5No0y6smldICagSSdayaW0n8v9ltplhKVmLklK6wpGgcKeLkyoMckr10SyRDsVcCx5Zl+6Nus8fW4uCJKsTAoxZEo0HSYmX3T1kBNIqplrGt8eu91TM1VeQf72hp84iHfu64HtpACik3znrGd2UTnYFPtnFdREjUItiqSsbgQKB12s0+hBBTMgXF5bETOT0BphmuK8tWW0BYID77Nh1q2yT6atz0UZ8jjolMGVgRhhKr4bPlKYPQckLRZYfXqTyvPLv+ldXyuSm9npyU9/Ufinv0jl5bt+ohrzGNhT34lgUvY1m3QZgoyX6JjCelwPkbRcqYQTc4SJS1FbN6LYqGPx1Yhszh4LomdUIFLMbxZ//+cA5RhzUwPPV9LJxSJQJqFQ0dnDRal6Mz/gFNjXi/H8Bt+D21TXR/y/uC8T3FdTyLpLd4N9pxfqfODkqq3vqWXwYsxD/a7aQPsUYUHOoh6EhP3O8VN8w4UEzbGUAqJJ2APkDiGzjfki7Axek/ZqyDQg6EC5nGOPy9UzuX8JsaHwr5z874P/SPxAJQoFj1c1byS80GegxlNJakkdQvi8GoXdG8HqPGaAHBO64cgD4Q813a9RfVmHe18EmqvHrQj+VfNKiWtEYxdQMuNpipuwGVFa0ChkU/CiRdFwMtQtlcrsD9AtszPy3SadWqdPieOTBaUyJ2tmazgL9sa8FXrcMpnKPOHrIYCoX1TXHCIQaJDb8sMCqK7RVodEgPouVM/2MkfZKZ
 sSFo2t8B
 Ztb8GTiudTLQRUnkUkFplNJNsUT0Wn6HNtaRiPi8L0btnpNFRQYkdE1FszzrrGR6FZFY+s2LFutljUiOx5Tj8zsMNpYLobQbpQamsH/BGwet6TXG8YuOIU3pzAuF3rG4yuZ4kwLM2UTPpOixbyEZ80WnlcGRdyUIKzaC7+XHzx+zvfhS3/gCR/h0Zjh7KkXJewzg2KIJRbGhJ8ZnZCQwqbPgWZdCT6R36rSJuoAQnGXEtkPgMlwfJ39tKUd4PKBq+/EjGqBYeJ3KHl+eOQL+6PQdyOZLiLD/uiQY4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 11/17/25 5:17 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
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
>>   include/linux/memcontrol.h | 29 +++++++++++++++++-------
>>   mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
>>   mm/percpu.c                |  2 +-
>>   3 files changed, 46 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 6185d8399a54e..9fdbd4970021d 100644
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
> 
> After reparenting, an objcg may satisfy objcg->memcg == root_mem_cgroup
> while objcg != root_obj_cgroup. Should they be considered as
> root objcgs?

Indeed, it's pointless to charge to root_mem_cgroup (objcg->memcg).

So it should be:

static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
{
	return (objcg == root_obj_cgroup) || (objcg->memcg == root_mem_cgroup);
}

> 
>>   static inline bool mem_cgroup_disabled(void)
>>   {
>>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2afd7f99ca101..d484b632c790f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2871,7 +2865,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
>>   	int ret = 0;
>>   
>>   	objcg = current_obj_cgroup();
>> -	if (objcg) {
>> +	if (!obj_cgroup_is_root(objcg)) {
> 
> Now that we support the page and slab allocators support allocating memory
> in NMI contexts (on some archs), current_obj_cgroup() can return NULL
> if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi()) returns true
> (then it leads to a NULL-pointer-deref bug).
> 
> But IIUC this is applied to kmem charging only (as they use this_cpu ops
> for stats update), and we don't have to apply the same restriction to
> charging LRU pages with objcg.
> 
> Maybe Shakeel has more insight on this.
> 
> Link: https://lore.kernel.org/all/20250519063142.111219-1-shakeel.butt@linux.dev

Thanks for this information, and it seems there's nothing wrong here.

Thanks,
Qi

> 


