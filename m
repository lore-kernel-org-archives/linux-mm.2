Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1DC9CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9D48E001D; Tue, 21 Oct 2025 05:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A908E0002; Tue, 21 Oct 2025 05:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB158E001D; Tue, 21 Oct 2025 05:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D91378E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:43:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D67E584EF
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:43:47 +0000 (UTC)
X-FDA: 84021634494.05.8C017D8
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 612D4A000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:43:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IHGqQc8U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039825; a=rsa-sha256;
	cv=none;
	b=VKKe9clwWhvWNu3lN25NEmP9OQOunBLptK2Vnvii7fVAkZO3yL6oz1sMJEBKxXNv4kR9Am
	xmc2Jz5vAZeunriK3iTZAYsJNvIzQ7m+VQvdz/yhz2QtyPzF5ZQcnKCIOCF2k7mPsoHRBw
	9V4z3pFCmEt5CJ75/3F4hWKybRQgShU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IHGqQc8U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y68f6ioof0lkMrxXjDHFuuOelLAqNc2E80mHKKj9Gtg=;
	b=siF/bBBvAbwn1bAdSwsaQu0v7s8tJcURVGu1t/PUjL41L/+H6rkDaPJ3+lDJdsJ4atFYcd
	CUq9yNUKwHxNXmHT9lQgzSuR9c4bu0SrEI2KKLEkcROsZaH1zDlTmB9fzEkO3aGI36iJJ2
	ygHdSTaL3Mml5b1W/IDneC06IkRTtBg=
Message-ID: <ba8bb85a-af2c-47b4-8d68-5b4c554dc819@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761039822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y68f6ioof0lkMrxXjDHFuuOelLAqNc2E80mHKKj9Gtg=;
	b=IHGqQc8UE6T0NyZE6pCdcE3h8Yl/eLqkrpDlLIATgAoiT1JduWDb/ea4MBvvF8ZrdG9tRg
	6uhsjfaZ6mMEJ/SEvNDefSRRiBusqvxC8/Qj9hgS1ueBAUA/iPG80IzM6Td8Q2uwOgPsBF
	CGtSKKuxjN+y5gEimmBK5eil6Q6SvNI=
Date: Tue, 21 Oct 2025 17:43:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <645f537dee489faa45e611d303bf482a06f0ece7.1760509767.git.zhengqi.arch@bytedance.com>
 <aPcjnKAapap5jrK-@hyeyoo> <3acbf7df-b890-4679-bbbe-959bd45fdef3@linux.dev>
 <aPdSbO-6xTmr4IsX@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aPdSbO-6xTmr4IsX@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h675jqj5qozxch1nh3s86d4uz58grpmk
X-Rspamd-Queue-Id: 612D4A000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761039825-142592
X-HE-Meta: U2FsdGVkX1/Kafm+Fv0LjfEshIAZI1yUtiCX5uShYHnWIZ5bvsX9g4KkW+Ns2625AJnpMI6QKfZ4jDVup9omLpQjYDjwmRGF8n+jSUD3XxKefZPWvEftD1EwXX3CdiStY13gqEN8Af9fuwZ7kcOy75TIZ0KsSIw7UZ9vzkOMosP1diVfzxEAs6IwXICQ0hBfcOiTql2k000VgUCYRsekQ8SpvAPvIyeBG6/UopU7CEK/zr1g0axu2MkGq+zbRDSqdVZirFsuD3UYe3hsD19H6RCO1d1MADslRk6NA6UFQDFM3rd8f1ztHK0VF8u38TCVoYc0S+lLYY0aoUlumhZs3XBHwS5haNhFmzObgkCU4oWR2UsasrVqjQLX1MqifP8b9YO2fidmtJDwbqsu7/e/4Q7jOwFB6cb/5lNJCzVBUljSZx2j43VkxmYcL9UCOri2pazXAwxw891/TDi/L/STLHysHVT7aenR27wQZevViYhh9S7ymil2zOmNCRY85Dkn71G3+ROby1laP6wZWbYdDpiQZvq2bXzwJXE2qTgy0RvTQG9KB5Lu6en2CWA9M8VC4jBpqwLwJjJF8Af2VgnkKSXuSnC9kynuX3nQUFCCqECMyyL3ixKpLqhi6m1i9vPkyNJFc5wt1f/5HQLVyzFwUzdHFd6WpdZl6x2PJtWRAN1Jb3I10haoRxMCFxNRN8uyZtkm035xRSHs/4EKyzTKFB7BxXf4SXqCBlZqCukrATiHGJ0N9LbnnSLprokAM8LCL5/haA5vXuQFpkNelWJY2Kj1fVBUUqkZP0qqxCX1RT1dI9Vzms23R5u1P3YKHHx+veuJcFlDq+v+r34X6OQ8afuL1ql8H10uajnSRWrW0HmDhr9vsNm6Lf2E6ZiSOy+eoc5N2mh0fTN884pKV826lwqtyFM3excuK6UCRNCrpfjNOt+JO9lVpW8LTLokOSQtp6Q0i8dCMbn8RoXQBaj
 2rRppH9H
 GxaUZa3jMHu1JFL4gRe39jPEfWNnv3jhD07LBuLzETEF/FTkhDSUK6hWEVGYzm2J1A8DTPxxxqR/Ro2/N7y2DTb6RFwGs3YIf6tHmqixzWrotoqU2mdYFq55AFoAwU9HExJ0ImXTLHrFueZ2jEPu3pChqnOvixQmIH/kcWyOkcRIAVmxTORxvDAl+5T2uG0r7Jan+HU/MoqyC/gEr4bkxRZacNZW0NRkC4UcAYlI9xbwbpsRJK3VR5n4R+jorYj0DKp4v0xLjoofuuShnOlufc5T2gd8Fbi/FTgacGz43PQBgaK5DS6wfD3O1sQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/21/25 5:29 PM, Harry Yoo wrote:
> On Tue, Oct 21, 2025 at 02:21:55PM +0800, Qi Zheng wrote:
>>
>>
>> On 10/21/25 2:09 PM, Harry Yoo wrote:
>>> On Wed, Oct 15, 2025 at 02:35:33PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Similar to list_lru, the split queue is relatively independent and does
>>>> not need to be reparented along with objcg and LRU folios (holding
>>>> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
>>>> to reparent the split queue separately when memcg is offine.
>>>>
>>>> This is also a preparation for reparenting LRU folios.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>>> Reviewed-by: Muchun Song <muchun.song@linux.dev>
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>> ---
>>>
>>> Looks good to me,
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>
>> Thanks.
>>
>>>
>>> with a question:
>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index e850bc10da3e2..9323039418201 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -1117,8 +1117,19 @@ static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg
>>>>    {
>>>>    	struct deferred_split *queue;
>>>> +retry:
>>>>    	queue = memcg_split_queue(nid, memcg);
>>>>    	spin_lock(&queue->split_queue_lock);
>>>> +	/*
>>>> +	 * There is a period between setting memcg to dying and reparenting
>>>> +	 * deferred split queue, and during this period the THPs in the deferred
>>>> +	 * split queue will be hidden from the shrinker side.
>>>> +	 */
>>>
>>> You mean it will be hidden if the shrinker bit is not set for the node
>>> in the parent memcg, right?
>>
>> Look at the following situation:
>>
>> CPU 0                   CPU 1
>> -----                   -----
>>
>> set CSS_DYING
>>                          deferred_split_scan
>>                              /*
>>                               * See CSS_DYING, and return the parent
>>                               * memcg's ds_queue. But the pages on the
>>                               * child memcg's ds_queue has not yet been
>>                               * reparented to the parent memcg, that is,
>>                               * it is hidden.
>>                               */
>>                          --> ds_queue = split_queue_lock_irqsave()
>>
>> reparent_deferred_split_queue
> 
> Ah, I see what you meant. Thanks.
> 
> So we may end up shrinking the parent memcg twice if it's
> hidden, but I guess it's fine as it'll be rare?

Yeah.

> 
>> Thanks,
>> Qi
> 


