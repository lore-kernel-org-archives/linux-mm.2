Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63A1CED617
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 12:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8F26B0096; Tue, 18 Nov 2025 07:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0F66B0099; Tue, 18 Nov 2025 07:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F4F6B00A8; Tue, 18 Nov 2025 07:11:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0E3C6B0096
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:11:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F49F13B243
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:11:26 +0000 (UTC)
X-FDA: 84123612972.11.B53141C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BCDB14000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:11:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWcpFE9b;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763467883; a=rsa-sha256;
	cv=none;
	b=Vyev9+z92gBP8Sv5qv4RISIfIT4BjfDep8KwkfifKYDVj5SnYZA4ddJfjocp5HuZZ5wftw
	wA9seaT3WqOfYNMg1titn44IchwZZHRiicJG+SFY27oQexJk436DZscda/348cMXHRsS8d
	fwqohlQgTc0BZXLYiR78mIv7vpY2xxs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWcpFE9b;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763467883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lNwnvmSsPR/k/zhjmVCKNI0fGEACpfEUHv6io9dj+U=;
	b=jp6yzJ9nWfKXjXyh8EvfhTUyNphA/2Mndn0uQyTjHjHd8J7qpWFd8Tx+4ITzDetQyGwAVU
	FGYg9t8aGP5YucIAVgSTWP9wVPP6O1rNsjYo6jnGzmnAkeKdm3+ZRFnr1/9dFwhc1qXQ2K
	zaPmQzNQP/PTftFVrjlVBKTIbUs7JH4=
Message-ID: <a64d9d17-1706-4936-8742-8ee5bc4988ab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763467879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lNwnvmSsPR/k/zhjmVCKNI0fGEACpfEUHv6io9dj+U=;
	b=XWcpFE9bHyrL3ur4jyLZUcH0ErcPM8hhnMwadsfGMXehkbuBJdkd1yEAxdN/M1/RLt6XPo
	JcN2VN7T4K7pbMyfxZEYNiIJp5yCrjNpHytpSb2fgcbYS4zRdFg2rqw9uz8Em1YcLAjVAP
	LarhuYQHkv5JuvBqxHUwezsqqG6aJug=
Date: Tue, 18 Nov 2025 20:11:04 +0800
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
 <aRroO9ypxvHsAjug@hyeyoo> <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BCDB14000E
X-Stat-Signature: zzgwsm1smqbjxdhxquirwjhzaegpaoe3
X-HE-Tag: 1763467882-52795
X-HE-Meta: U2FsdGVkX18HQU3KsFnuOyUa4mF06PwrLTg2FPKQr4ljVj8syo36YdLsH6RKPRVNR+ejVbm6L9Yv5AUOPr9rNmWicNHitPFJewyzdfakmEcDWg5U6oV32tKSniyS68mGH5gNlv/0eAVlhhsByT9ZW3bW+71wOvuIcpH6gbQNWPqBRdJjwLwmVU6vhY+AqSY3ocMZxFsDQ5szW//87bShWZh1oRhDKDlaOzM/wk4ezouAZscFIE/O5L715qAbapo/UHLUdU3pRhUaK8a9Z+F4zGNFzQVO3lT8u9YwowAug8tTuzbOjVFFS+o+NAl0muSBIvjr7HETTIWgXfUVyXrrUNpH3zU3TW2H3O1jRXXGpMeGGPqpqFPaAt3y3dz39JzN2MPlIDIOYItQVVX/vmoFjv1l3FDigUtKg4jYu3W87+Sv+f53IoJgvmT0MSmgmr3+hywVprh+yALiKUTdnu1vFusQFdx2b+spRq40nafSmgWW68+z+eGjxZvSqpR/Azz5maRDegVxivNi1o74xFh3O+vUrDN8KJsu9g49HLUQ1WAziAdZdeq1/ApjV87Su3mAcTqupajPkBuff0R5FFrbaWpCMyJ07i7BkXnIHwFK83msdPGZbizPflIVyvBScWIiwbjdBHKcHM24pKsoDgwndRWAhjFtm+GE/hTVWOuZuAvYOYE/qQFLQq7aoTdNVrzgG+X2YJCOdfDuxerRBqpNQs34zfI7F+2hAVm39by5mbs/P0H3R0eu0/Fnkyu0+289srEN46RaJICVhlfdjG3NFnDmx9qZ0ZlgUPfsozJwRUIyXPPB1TXQ7+b1/hmN7YsMkSo5osh1s6vTYtSnQApecmbF/D6r9r+rhGQIzD2dZyvr38xxeMDwV1JzEicfOSvtWxgmuIs4OpLQYFU1IaKe+xclWImaDr/JQMdnWfVXFEZY68GuNsS9cwpzEG58W5W/ErzVOdUGnGu/bOTbIKM
 PcuR6K9T
 Dg/iUVakcFMuWcGU8McpII976B3JoX4EYIZuWmLGZW3Dz/O01JJFfmLKirg2uWEu26EyRlXl+k3GbXa2wU7mDLWABrP6QNSCJ303JXzJ4W/f4jTTiqQ8OFhPZqe1HRsTW4iCe/voGKP5iDAFxffpPcx1xIkO7+iqljLzoD84FCmFzmSKEOeJakX8tpyJ9VYFc+7iCc8boJqgzQCRXYaKuaVmU82ARVyb9o15WMgVtqwOOo4110+rAk9rDlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/18/25 7:28 PM, Qi Zheng wrote:
> Hi Harry,
> 
> On 11/17/25 5:17 PM, Harry Yoo wrote:
>> On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
>>> From: Muchun Song <songmuchun@bytedance.com>
>>>
>>> Memory cgroup functions such as get_mem_cgroup_from_folio() and
>>> get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
>>> even for the root memory cgroup. In contrast, the situation for
>>> object cgroups has been different.
>>>
>>> Previously, the root object cgroup couldn't be returned because
>>> it didn't exist. Now that a valid root object cgroup exists, for
>>> the sake of consistency, it's necessary to align the behavior of
>>> object-cgroup-related operations with that of memory cgroup APIs.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>   include/linux/memcontrol.h | 29 +++++++++++++++++-------
>>>   mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
>>>   mm/percpu.c                |  2 +-
>>>   3 files changed, 46 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 6185d8399a54e..9fdbd4970021d 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -332,6 +332,7 @@ struct mem_cgroup {
>>>   #define MEMCG_CHARGE_BATCH 64U
>>>   extern struct mem_cgroup *root_mem_cgroup;
>>> +extern struct obj_cgroup *root_obj_cgroup;
>>>   enum page_memcg_data_flags {
>>>       /* page->memcg_data is a pointer to an slabobj_ext vector */
>>> @@ -549,6 +550,11 @@ static inline bool mem_cgroup_is_root(struct 
>>> mem_cgroup *memcg)
>>>       return (memcg == root_mem_cgroup);
>>>   }
>>> +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>>> +{
>>> +    return objcg == root_obj_cgroup;
>>> +}
>>
>> After reparenting, an objcg may satisfy objcg->memcg == root_mem_cgroup
>> while objcg != root_obj_cgroup. Should they be considered as
>> root objcgs?
> 
> Indeed, it's pointless to charge to root_mem_cgroup (objcg->memcg).
> 
> So it should be:
> 
> static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
> {
>      return (objcg == root_obj_cgroup) || (objcg->memcg == 
> root_mem_cgroup);
> }

Oh, we can't do that because we still need to consider this objcg when
uncharging. Some pages may be charged before reparenting.

> 
>>
>>>   static inline bool mem_cgroup_disabled(void)
>>>   {
>>>       return !cgroup_subsys_enabled(memory_cgrp_subsys);
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 2afd7f99ca101..d484b632c790f 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -2871,7 +2865,7 @@ int __memcg_kmem_charge_page(struct page *page, 
>>> gfp_t gfp, int order)
>>>       int ret = 0;
>>>       objcg = current_obj_cgroup();
>>> -    if (objcg) {
>>> +    if (!obj_cgroup_is_root(objcg)) {
>>
>> Now that we support the page and slab allocators support allocating 
>> memory
>> in NMI contexts (on some archs), current_obj_cgroup() can return NULL
>> if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi()) returns true
>> (then it leads to a NULL-pointer-deref bug).
>>
>> But IIUC this is applied to kmem charging only (as they use this_cpu ops
>> for stats update), and we don't have to apply the same restriction to
>> charging LRU pages with objcg.
>>
>> Maybe Shakeel has more insight on this.
>>
>> Link: https://lore.kernel.org/all/20250519063142.111219-1- 
>> shakeel.butt@linux.dev
> 
> Thanks for this information, and it seems there's nothing wrong here.
> 
> Thanks,
> Qi
> 
>>
> 


