Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85A2D31A0E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 06:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460766B0089; Wed, 14 Jan 2026 01:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E066B008C; Wed, 14 Jan 2026 01:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5846B0092; Wed, 14 Jan 2026 01:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9116B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:25:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A24AF1403B1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:25:53 +0000 (UTC)
X-FDA: 84329583786.26.C117D17
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E756100008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:25:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sDrtDcU6;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768371952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFFYK3SE7r2jMbbMc8V7DFpSaOQnml1wlEvXbwdqn0w=;
	b=5cEfVe1+ocMKDw6SbD7I+2rQpp1buK8nHbuUwUH1J9h6JSzyCfwoyxLd0sxUqpSRScq1WW
	WEOXIPGKtZtVUWQefxgdgkoZ5Thdn4xJds9wyhHw18CfNBBvDDrG+vWc1brj+KiM76+ivb
	v5rdyW2UZ8cmpoTcqP1dPgoqNHEwrt8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sDrtDcU6;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768371952; a=rsa-sha256;
	cv=none;
	b=7za162KwqRfHZx2Z8siVkZpcqwSdbY0cwoCODIp5tcAsK17VKip7iY5j8soZ83lwiixFCw
	9iRg3QW8p6TcQuWDoes+bxdnOtn4Dxrgat0/zN75wfJJCyDwBVfVy0hoXqnWCBFuCKrwq0
	b75SbLwOWPwflm2uvPZDlSPgXP3bhR8=
Message-ID: <3d8dd14c-d3a7-4cae-99e3-10ebe4ad52aa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768371949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IFFYK3SE7r2jMbbMc8V7DFpSaOQnml1wlEvXbwdqn0w=;
	b=sDrtDcU6+9FNmrn80sPQ0xpW9+mgxv3nW9uh9blN+4oe8m5pKHBBbepifPRNQIAzUCFlHt
	CR4rAUx1rUe1a3w1eTQRFumSat5ztHxZ9Fb9IqVGEduxYj4DSgXBpGW0y7/bm4lAc3Dhg8
	9eg0V0X6+Xv/jOpaN6RTcaQETl/FM2M=
Date: Wed, 14 Jan 2026 14:25:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Harry Yoo <harry.yoo@oracle.com>, Chris Mason <clm@meta.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <8703f907c4d1f7e8a2ef2bfed3036a84fa53028b.1762762324.git.zhengqi.arch@bytedance.com>
 <20260113220046.2274684-1-clm@meta.com> <aWcrVRT_RjxdjoN7@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aWcrVRT_RjxdjoN7@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dprzq1uwho7xuk8n71akndyku1dzmddt
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E756100008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768371951-9337
X-HE-Meta: U2FsdGVkX1+bMyxUsfoTrmYB0o0F5ImqJNwkmqiPwNmrwUXanK8L6g7N9iGeHtkmJPkN6BZ2R30FhHxbUwhU+1O9LZEQSEyGhZUUDusKuRhKwOqpr7xXGmZzhfGyy057PZze8sarHdopgwIedZQ1sSQnDN/MT5oxndz3jxlpsqJBtfw0V1ag3EeY3Xe6MREeoS+bcBCopiEeytU3kGN+KZXDviy3H8NqMBTsKr3BcVX7FeD6dpua6zssDMhERgd6Sb/64Q/REIfwJLZ8f6UonZDHiS1dvQsILOy8RL6szwyfLUQ48c2IPnmWvncIRr4GjVIq+I2UgSatolDsfP/dxlHv/KoDK7NXQqwg64XRugGuVjEN0s4sVfpFDpQzSm7vGiwDb6DVpBlc7x3oOF3SDwXPAU/FCAU2pxIBzpG7ej+WAeQOvSgeKCayThgoQlqReBZOnkELsipneLZ/PuSu7ibJWYXqk0N7VFJge4BXY5Fpd+ouieiz9I1Jm7QTDT28f9REFePb0DX99qqyzzUq8VXiieSGXIE/56MHj1iEmC93RSmtGo6LXsuuYzmbZCZpzVS5XoAC1jU4R8mS27eg2tQ+2aZM9jjKyJpIzSGG2IXsfzwlEgYTPDNKcgIsat4BezH6dYROixGrAN78AKlu+V/svUTFaARUrNHb+ambD98yPvF6Bqk1Pa9Br0dbFIfNlJ3WxLbAge0lZOkbliEafKslwQt5U++XFaTLChaeUJB1CRce3Vsgs7UVhWrXCOmnyKirB53VruzgEnLkypUBKVif9QM32n6lcNibPRLMQT6WMfPJzgL05y78PqYBcY5idVyJY6lJ08QUuAorYlmHmt15WWy963WF/qFvuW9rgIAs8h4eIqzupSlifZgqZ9ikFuP9pjtXkxNBkvOu4ElTfZL8gacMKlPT0+6wZfaCLq5o3LVfaNhWsUlT2q68+X5KbWaErhkcNpJ5dv74Is8
 3ALwCrLF
 iHD+ICUvDpcQ1D2puV+TRDoW651CAvUmoDppiyanaY04lxSRIFtMqjWxWwDyIqEFnD3RL75t4iqLj1v9T3/3HFSKEJAI1pyYYAMVdnKZZoNsYfZIhoBluGPftwg0qZMipvWlZJm7TFRAByOfSFnEH3ZX/DaDC2XVYn1M0TMbKeQ/hEDdjQwDzg0z9OojY09xBrVmYNFWakfCLQtBySsBH9QGNLHoWebTMUKP1Y7i8MYfKmBgPZMCyPjfEOCvwuvfjaU5t/rcAfFrQqwhiS18ohf3nfBSF319S7hC2uPg/JfrmjUlOj/YkxpReEoLK4zTBwo9rP8qaHFoFM5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/14/26 1:36 PM, Harry Yoo wrote:
> On Tue, Jan 13, 2026 at 02:00:43PM -0800, Chris Mason wrote:
>> On Mon, 10 Nov 2025 16:17:58 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Similar to list_lru, the split queue is relatively independent and does
>>> not need to be reparented along with objcg and LRU folios (holding
>>> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
>>> to reparent the split queue separately when memcg is offine.
>>>
>>
>> Hi everyone,
>>
>> I'm running all of the MM commits since v6.18 through the AI patch review
>> tools, and this one was flagged.  I'm much less confident in this report,
>> AI tends to get these races wrong:
>>
>> [AI review output]
>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index b0c6a4635c67b..cc6db20d7dca0 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -1775,6 +1775,12 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
>>>   bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
>>>
>>>   void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>>> +
>>> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
>>> +{
>>> +	return memcg ? css_is_dying(&memcg->css) : false;
>>> +}
>>
>> [ ... ]
>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 13684e5376e82..d17d3810a882c 100644
>>
>> [ ... ]
>>
>>> @@ -1129,8 +1140,14 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
>>>   {
>>>   	struct deferred_split *queue;
>>>
>>> +retry:
>>>   	queue = memcg_split_queue(nid, memcg);
>>>   	spin_lock_irqsave(&queue->split_queue_lock, *flags);
>>> +	if (unlikely(memcg_is_dying(memcg))) {
>>> +		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
>>> +		memcg = parent_mem_cgroup(memcg);
>>> +		goto retry;
>>> +	}
>>>
>>>   	return queue;
>>>   }
>>
>> There appears to be a race window that can cause split_queue_len counter
>> mismatch. Between the time CSS_DYING is set (in kill_css()) and when
>> reparent_deferred_split_queue() actually runs (asynchronously in
>> css_offline), folios can be unqueued via __folio_unqueue_deferred_split().
>>
>> In this scenario:
>>    __folio_unqueue_deferred_split()
>>      -> folio_split_queue_lock_irqsave()
>>         -> split_queue_lock_irqsave() sees memcg_is_dying() == true
>>         -> returns parent's queue (locked)
>>      -> ds_queue->split_queue_len-- decrements parent's counter
>>      -> list_del_init() removes folio from child's list
>>
>> The folio is correctly removed from the child's list (list_del_init is
>> self-referential), but the wrong queue's counter is decremented.
> 
> Good point. Sounds pretty possible to me?
> 
> I don't think there's anything that prevents it from unqueued
> before it's reparented.
> 
>> If the parent queue was empty (split_queue_len == 0), this would cause an
>> unsigned long underflow to ULONG_MAX.
> 
> Although the accounting mismatch will only persist until
> reparent_deferred_split_queue() reparents the deferred split queue.

This period is very short, and the only thing affected should be
deferred_split_count(), but it does not cause a system error.

So I think maybe we can leave it unrepaired.

> 
> Ideally this should be fixed by checking if the folio has been
> reparented after acquiring the split queue lock, but since we don't reparent
> LRU pages yet ... do we need a band-aid before then?
> 
> Do we want to have is_dying property in the split queue as it was in v2? [1]
> [1] https://lore.kernel.org/linux-mm/55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com
> 
>> Could this be addressed by checking that the folio is actually in the
>> queue being unlocked, perhaps by verifying the list head matches before
>> decrementing split_queue_len?
> 
>> [ ... ]
>>
>>> @@ -3920,6 +3920,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>>>   	zswap_memcg_offline_cleanup(memcg);
>>>
>>>   	memcg_offline_kmem(memcg);
>>> +	reparent_deferred_split_queue(memcg);
>>
>> The race window exists because CSS_DYING is set in kill_css() before
>> css_offline() callbacks run asynchronously. The comment in split_queue_lock
>> mentions that THPs will be "hidden from the shrinker side" during this
>> period, but does not address the counter accounting issue when folios
>> are unqueued.
> 


