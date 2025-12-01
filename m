Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F7ED116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 15:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68CE6B000D; Mon,  1 Dec 2025 10:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40B46B0024; Mon,  1 Dec 2025 10:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D546B0026; Mon,  1 Dec 2025 10:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C387A6B000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:41:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FCC61402DF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:41:44 +0000 (UTC)
X-FDA: 84171317328.12.7D085B3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6441480014
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:41:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZzA+zGcb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764603702; a=rsa-sha256;
	cv=none;
	b=D3LXEcFMBmp1MhRAqtzINt4zty07c7uHareit9+qVecj5nR2235eFOySTcLqmskTVFaAvM
	HhlLtAeaOqIR9FrIEeRinRCtGIeg501ChgIw/YW0WajB/j3ZQzUv16Aj7jzVWC8V/Xgpwy
	4dAAbllfOEoZ9w5F4CEV9MvuYLtW7hc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZzA+zGcb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764603702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uT9+iCk1C9W8oKaATIUH1G8jZwnmHrr4Jk2aweSPxhw=;
	b=m/NUQ3ApMi604oX+4uOyh4iy8FbDcxANjA/yROA5u/dqYt5nU31he1X+MlvcOsfpj9Oifj
	Fuo/Nehnmxd9grFekKFdJup+jf/wH9BF5MALa5fz2nD+z8N14CZhSU3hyFEnuFS96pYQhI
	5n8HsUzRd2ekZC8ltGmg7EKFIvQAzhQ=
Message-ID: <d94fe146-5cc6-4aa2-bd7f-8ca2a12e5457@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764603699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uT9+iCk1C9W8oKaATIUH1G8jZwnmHrr4Jk2aweSPxhw=;
	b=ZzA+zGcbfVaF0IbxZAcyuNjv0u24QwW+Exx11JVnVgnKJMNQ876Zu3WzrgtNGfGB9g2W3l
	pZR6eaHFu4H43WJN2dh8RPmTqQqQ/THi68oYhI6t26RqdFVxCh7Zuzpo8Cx2XdFvQCovCb
	bdvKKrcGaIP6J4hvwcUw4QyzEr+TKNc=
Date: Mon, 1 Dec 2025 23:40:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
 <aScFNZjGficdjnvD@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aScFNZjGficdjnvD@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6441480014
X-Stat-Signature: rfnfy8fspepcfngt3edyzrkp6wgzwqao
X-Rspam-User: 
X-HE-Tag: 1764603702-479041
X-HE-Meta: U2FsdGVkX18UUrArl8WMs6G2m4WfwR5vX+ARtuQo7TT81A7Fvg6oAoTjo8w10/hjda9mSF3k6JPztjlwJS9GIXmiuwb27pjn7s91CdI+86Dldo/879JTzOZyjK7EGes9Gq4D6QJJFSGXhzReEBn0CKPTHnfxZj14ZUkrmhAzov91wuW6S10jm/pi5gwKs2P49/+NtHInuObDWqRO9cL+HYIy4OTlDk0+yYnScC7PXtcy2VrO4lx/Xl2fJ1LyYLPrHkX1R3TUQMiTnsgw+Une8rE8dOdvP5C0di5AjZ2/0qt8cF+V5XTyAizIg3QFxPmIxNqz/4i5PcG4KMbEdea+NYakOtNHaaJhyHiRa/XPv7xI1iGUWaBtOOUSm4qBkim5Tg6M91y2IQPIvi4YV2xUCBRv+6dFuDOlNp0+FFdFMY4L0ORyHXb5DrLnSzeriHDqtAQGcDSrB1f4xM3Iy1z4Cflaet40lj3KheKKiVw8KM0HoMrue9K7KFquLAnNT6aVKcZARz+70hCmlEjufInd6bb1RZ4xWkiGhaBMW6VOEUAkiswQhQ/27jZdH1LR5VD+ngaXw/Y2a23J559JrxGY+bhf8ekl23kRgruDkrNaGlUCevDhjQrKQ7ZjYvK7BVawm87t8/qOErH7Dym0fkCi34B4A3pD1BJdpiR8Cct3OtjORg/gfCbNavWDol0SICYrNhppYtjE72sUyPZBMaL+zLatR+jBlo6XwXD+P7yxL7KUSQwv60I4DMG3wNUImwWVZSV8vw45Gx8FBx5dQIVLtsucT2zlN99aQB2CYG6JxFToIoUPbePqQE4nbseMd0CqYyMSrXOwAgzhYR5vE+G/NwiKwYzBs1eBx3ZTpxNIk464lgpNDITiPCuxaEpumFjI6Sg3y08zoxen1bcuw1lUNBV2yCCb9vIqADcIg9dazUsC0EEo3XXLAsFtqmhBcKB8tVe7gZbA06DWnfk/82O
 etpYtf4Z
 M+2K6Q9IWF/yAY/kZL/MS5f4cjFxf1vdrRgSed50KoYJryt2PEFdnGh2W4rd/3YKtEpfreapwY6YY1DzoRHYsIrPUbfdMtCgitaMCr4XHiIOPyBXRw8B5+HbLn/I6pzlr7GtkjY6X+qjB4/FbIZ3hnUIlABkxa/HrG+ZDzG4eCXCCtXs2KeZgyei4gTZc/YHx5ekXndOlPzh8Z2tQcdda7SkujQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/26/25 9:48 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:36PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to traditional LRU folios, in order to solve the dying memcg
>> problem, we also need to reparenting MGLRU folios to the parent memcg when
>> memcg offline.
>>
>> However, there are the following challenges:
>>
>> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>>     number of generations of the parent and child memcg may be different,
>>     so we cannot simply transfer MGLRU folios in the child memcg to the
>>     parent memcg as we did for traditional LRU folios.
>> 2. The generation information is stored in folio->flags, but we cannot
>>     traverse these folios while holding the lru lock, otherwise it may
>>     cause softlockup.
>> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>>     may be updated, but the folio is not immediately moved to the
>>     corresponding lru list. Therefore, there may be folios of different
>>     generations on an LRU list.
>> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>>     found based on the generation information in folio->flags, and the
>>     corresponding LRU size will be updated. Therefore, we need to update
>>     the lru size correctly during reparenting, otherwise the lru size may
>>     be updated incorrectly in lru_gen_del_folio().
>>
>> Finally, this patch chose a compromise method, which is to splice the lru
>> list in the child memcg to the lru list of the same generation in the
>> parent memcg during reparenting. And in order to ensure that the parent
>> memcg has the same generation, we need to increase the generations in the
>> parent memcg to the MAX_NR_GENS before reparenting.
>>
>> Of course, the same generation has different meanings in the parent and
>> child memcg, this will cause confusion in the hot and cold information of
>> folios. But other than that, this method is simple enough, the lru size
>> is correct, and there is no need to consider some concurrency issues (such
>> as lru_gen_del_folio()).
>>
>> To prepare for the above work, this commit implements the specific
>> functions, which will be used during reparenting.
>>
>> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/mmzone.h | 16 ++++++++
>>   mm/vmscan.c            | 86 ++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 102 insertions(+)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 7aa8e1472d10d..3ee7fb96b8aeb 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4468,6 +4468,92 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
>>   		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
>>   }
>>   
>> +bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
>> +		int type;
>> +
>> +		for (type = 0; type < ANON_AND_FILE; type++) {
>> +			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
>> +				return false;
>> +		}
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * We need to ensure that the folios of child memcg can be reparented to the
>> + * same gen of the parent memcg, so the gens of the parent memcg needed be
>> + * incremented to the MAX_NR_GENS before reparenting.
>> + */
>> +void max_lru_gen_memcg(struct mem_cgroup *memcg)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
>> +		int type;
>> +
> 
> I was testing this series and observed two warnings...
> 
>> +		for (type = 0; type < ANON_AND_FILE; type++) {
>> +			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
>> +				DEFINE_MAX_SEQ(lruvec);
>> +
>> +				inc_max_seq(lruvec, max_seq, mem_cgroup_swappiness(memcg));
>> +				cond_resched();
> 
> Warning 1) Here we increment max_seq but we skip updating mm_state->seq.
> (try_to_inc_max_seq() iterates the mm list and update mm_state->seq after
> an iteration, but since we directly call inc_max_seq(), we don't update it)
> 
> When mm_state->seq is more than one generation behind walk->seq, a warning is
> triggered in iterate_mm_list():
> 
>          VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->max_seq);

The mm_state->seq is just to record the completion of a full traversal
of mm_list. If we simply delete this warning, it may cause this judgment
in iterate_mm_list to become invalid:

         if (walk->seq <= mm_state->seq)
		goto done;

So it seems we can manually increase mm_state->seq during reparenting to
avoid this warning.

However, we cannot directly call iterate_mm_list_nowalk() because we do
not want to reset mm_state->head and mm_state->tail to NULL. Otherwise,
we wouldn't be able to continue iterating over the mm_list.

> 
> Warning 2) In try_to_inc_max_seq(), the last walker of mm list
> is supposed to succeed to increment max_seq by calling inc_max_seq():
> 
>          if (success) {
>                   success = inc_max_seq(lruvec, seq, swappiness);
>                   WARN_ON_ONCE(!success);
>           }
> 
> But with this patch it may observe the max_seq is already advanced due to
> reparenting and thus inc_max_seq() returns false, triggering the warning.

After we correct the warning above, we will satisfy this condition in
iterate_mm_list():

         if (walk->seq <= mm_state->seq)
		goto done;

thus returning false, and avoiding triggering this warning.

> 
> I'm learning MGLRU internals to see whether we can simply remove the warnings
> or if we need to do something to advance max_seq without actually iterating
> over the mm list.

So IIUC, we can simple increase mm_state->seq during reparenting to
fix these warnings.

> 


