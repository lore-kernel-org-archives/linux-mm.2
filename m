Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54F2CF258E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 06:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2756A6B002D; Wed, 19 Nov 2025 01:41:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C996B0089; Wed, 19 Nov 2025 01:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189A16B008A; Wed, 19 Nov 2025 01:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1A76B002D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:41:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80B95140392
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:41:52 +0000 (UTC)
X-FDA: 84126411264.15.054138A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 751324000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:41:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m8baIxmI;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763534510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tF+DaTtHEKwuWpwk2dCWacezPhWqck0SR+2rBvFOiOI=;
	b=EhQhvfd+rXnPvsN1ENjsOzcBQ02WXtrnHcJmIwEhDe9YnJ8Eff/a+Up6z+awIB6JQuKTHB
	tElmzE3nlfVjmvrQsg9xRDVCTkqyezm1N3o7Br+jqNSF56BVslbduxmwsy0deAsGdBn/aQ
	iCqeT61RKCP36allTTGbsm6TT3wEN28=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m8baIxmI;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763534510; a=rsa-sha256;
	cv=none;
	b=6T1MPP4vS8sjiAYxmYb1xc0k2u+RTqNkyFjVeUjlKthEtF+RJH9no8+rsUVYPcw7Ntt6dL
	08DMgn4fr2LU+8SkkPNxmvs/1G2f5nQ6jzUcszdZ9urV4lf1sr3RApptz1QkoSx/W4fUEc
	qIggymXDyG8u/HFY2CyZP3p0rh592RQ=
Message-ID: <e323f903-d366-41c0-a20e-6d743865d984@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763534508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tF+DaTtHEKwuWpwk2dCWacezPhWqck0SR+2rBvFOiOI=;
	b=m8baIxmI7QMgoHM7OyRydLDKuOkXFxqDUbkf6IAICv71rdpk5TnrHK6y1bmuGu7FtOzyvI
	/EyLsvriaV6pgXd8TI7njevCzDSFezw8k5asnaayRJOzSzFpUh4dUDwbgYnd2GyzWY14dQ
	9M9Yji7LwyvLUz/9QDvc7ArkVkKWUL8=
Date: Wed, 19 Nov 2025 14:40:44 +0800
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
 <aRxingFU0OKRnv8E@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRxingFU0OKRnv8E@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 751324000A
X-Stat-Signature: r43zuuh8tphrz1gpgnnpiboxy5ymt7jc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763534510-765647
X-HE-Meta: U2FsdGVkX18HvIZcQNqo6EX01PZLzA9eEsTW2BLxx1m3BdP8OfqBBwic25fOo6FjkPerm8Ly88QOgZt0jgjypN6Y07h7BxnirQZEplkesWQWLmQ5wF44ZlOac34q+f8efCi0d1Z1eqlPH0B3+Sq723jJXt96rc1sp2yCJPF35R3j9Oem3tDsmdl13kjr99ZqaqhQMKIohOMxpKxw1UjmfI1PBgobUrvY8hPTwva6s3AwF9ARH2bfhjuFBSyQr3mMP0Xfo06TJfn3IxxLyhqRJtwfPBfKW9/+aqEIIUbBdGS85pbJkJyL+JKE7JKiV/FcBf9ryvN8oYLecRtbuOS/pDQ7zDL3vNpml6+rRQx35hub4mUMvpcc8cdlPKqO8+LQgMaXmB5E+VWk1IlXUDTP2hjDLa3vakWa4zDgSQWZztY7jiqOhbLNthi7XkkWiLuwwRXqFw5+r2oU62PqzjXU0WWf7nXSCHKb9XtVs7OarCC5O5Zi9/BJY9NbdxxLp1SCsHVxraymbyiHEp1cxVCFvC25IApRZsO/79ociZhjMzgI2t9ZGUgZC9aZ9Y/nDabNriRBbQrTuZfp/8zwEpzn5IqjsoBZjYBzG72LeSpa0JW5JK0nyeQwA89RRkMMD5WJFgxGADel5J0AOFSKJXb8psFM9NbeC1Uuc11V+MWn4rv1bdubwXql4yWsJ8rUaQzJDUoRCM8JuCGL3shkRxiH4vwFtTbtvMpD5B0Y6HZM0jrszwYyWiz+E8xfC96es2MIKXlLpl7jSAlmC/8CFA94E6eUdYQe7fwGvxYV4WjrKdOV55O3yQedOuO8qu9QJoViqDeX93sjaiYP8MC5Jd1lzN9uNIsIqgdbs4u/4//hXJC+Rc1febqp8Zm5OWrxjsvPGXZhS8ouaYiiPbpStRU+tLRXU1QqFddRJyT4TjJfHHquy1/mCfdyLMUO3RBO9FfAEN1y5Ux4GQAoqcBZVvI
 MnHL5ZUd
 haK9vZ6mJW0qxUn2GM9zvizt8smIyLXWetE1PXIEeHhbDAiWoKKW0W8QoT8DmWGu8C3Pij6ike+TLpcuEimSgVmKJDx2hHlJeq/I7iOpfOJsYDqKHj1V15heWHtGLY8/8tc8K7VebRa9FexcHcJFPEmsxExRHHcE/APxCDPulK1ZzkcPwg2kbF6s0tSeLUBC9p2z/SlOhfAfDBOMzSfHRAtSkYnPpyBgHYp4k8477+Xvpp2TsyBiIB1/+Jd2QIsFz1CvK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/18/25 8:12 PM, Harry Yoo wrote:
> On Tue, Nov 18, 2025 at 07:28:41PM +0800, Qi Zheng wrote:
>> Hi Harry,
>>
>> On 11/17/25 5:17 PM, Harry Yoo wrote:
>>> On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>
>>>> Memory cgroup functions such as get_mem_cgroup_from_folio() and
>>>> get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
>>>> even for the root memory cgroup. In contrast, the situation for
>>>> object cgroups has been different.
>>>>
>>>> Previously, the root object cgroup couldn't be returned because
>>>> it didn't exist. Now that a valid root object cgroup exists, for
>>>> the sake of consistency, it's necessary to align the behavior of
>>>> object-cgroup-related operations with that of memory cgroup APIs.
>>>>
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>>    include/linux/memcontrol.h | 29 +++++++++++++++++-------
>>>>    mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
>>>>    mm/percpu.c                |  2 +-
>>>>    3 files changed, 46 insertions(+), 30 deletions(-)
>>>>
>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>>> index 6185d8399a54e..9fdbd4970021d 100644
>>>> --- a/include/linux/memcontrol.h
>>>> +++ b/include/linux/memcontrol.h
>>>> @@ -332,6 +332,7 @@ struct mem_cgroup {
>>>>    #define MEMCG_CHARGE_BATCH 64U
>>>>    extern struct mem_cgroup *root_mem_cgroup;
>>>> +extern struct obj_cgroup *root_obj_cgroup;
>>>>    enum page_memcg_data_flags {
>>>>    	/* page->memcg_data is a pointer to an slabobj_ext vector */
>>>> @@ -549,6 +550,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>>>>    	return (memcg == root_mem_cgroup);
>>>>    }
>>>> +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>>>> +{
>>>> +	return objcg == root_obj_cgroup;
>>>> +}
>>>
>>> After reparenting, an objcg may satisfy objcg->memcg == root_mem_cgroup
>>> while objcg != root_obj_cgroup. Should they be considered as
>>> root objcgs?
>>
>> Indeed, it's pointless to charge to root_mem_cgroup (objcg->memcg).
>>
>> So it should be:
>>
>> static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>> {
>> 	return (objcg == root_obj_cgroup) || (objcg->memcg == root_mem_cgroup);
>> }
>>
> 
> Thanks and tomorrow I'll try to review if will be correct ;)
> 
>>>>    static inline bool mem_cgroup_disabled(void)
>>>>    {
>>>>    	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 2afd7f99ca101..d484b632c790f 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -2871,7 +2865,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
>>>>    	int ret = 0;
>>>>    	objcg = current_obj_cgroup();
>>>> -	if (objcg) {
>>>> +	if (!obj_cgroup_is_root(objcg)) {
>>>
>>> Now that we support the page and slab allocators support allocating memory
>>> in NMI contexts (on some archs), current_obj_cgroup() can return NULL
>>> if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi()) returns true
>>> (then it leads to a NULL-pointer-deref bug).
>>>
>>> But IIUC this is applied to kmem charging only (as they use this_cpu ops
>>> for stats update), and we don't have to apply the same restriction to
>>> charging LRU pages with objcg.
>>>
>>> Maybe Shakeel has more insight on this.
>>>
>>> Link: https://lore.kernel.org/all/20250519063142.111219-1-shakeel.butt@linux.dev
>>
>> Thanks for this information, and it seems there's nothing wrong here.
> 
> I mean at least we should not introduce a NULL-pointer-deref bug in
> __memcg_kmem_charge_page(), by assuming objcg returned by
> current_obj_cgroup() is non-NULL?
> 
> 1. Someone allocates non-slab kmem in an NMI context (in_nmi() == true),
>     calling __memcg_kmem_charge_page().
> 2. current_obj_cgruop() returns NULL because the architectures
>     has CONFIG_MEMCG_NMI_UNSAFE and it's in an NMI context.
> 3. obj_cgroup_is_root() returns false since
>     objcg (NULL) != root_obj_cgroup
> 4. we pass NULL to obj_cgroup_charge_pages().
> 5. obj_cgroup_charge_pages() calls get_mem_cgroup_from_objcg(),
>     dereference objcg->memcg (! a NULL-pointer-deref).

Oh, indeed. After adding MEMCG_NMI_UNSAFE, we should first check
if objcg is NULL.

Thanks!

> 
>> Thanks,
>> Qi
>>
>>>
> 


