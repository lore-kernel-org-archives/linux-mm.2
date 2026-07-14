Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F304CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7A46B0092; Tue, 14 Jul 2026 07:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECEDB6B0093; Tue, 14 Jul 2026 07:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C726B0095; Tue, 14 Jul 2026 07:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B00DB6B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:31:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31BBE14032C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:31:30 +0000 (UTC)
X-FDA: 84987166740.06.4CF1882
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFAE0140004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:31:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aubsTbCz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784028687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwhrkQgNNnztcrozTTZGeAnrDC8vAtQeya0vh3r35g4=;
	b=sc5eslj4diQoH1XfKSVs80rsjt+9+XWJ2J6PB5BYGFI89aLcOfZVmvZX50ES24vnh1ComS
	PpVmE7YTNDpgUAm8pC3pWQTaISWB+RhfKJPJsZ7afaowQCMq0UnEbh7tdVIvbf3A1LUa3k
	osUOfrzCcBHaKk/m4ys0he2TquJpdhw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aubsTbCz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784028687;
	b=OMgre4Gca23+YzkPJesMcvYRHBS57etIlwvTblNTPtiU9Tv4UR0i2f/LcuZarUhFXMypVD
	t1I5ecNJkAs1/gJqgR2jCqPmzlmfqJIHULGbctpWB2V36O3GBipOFjxBaA7Gs2SHM1jNYn
	8yOvJ0niKyxXj8BtpHfTPmC5ungJrFs=
Message-ID: <bfb1cfa1-691a-4bac-beb6-caef9b3ac4e8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784028683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwhrkQgNNnztcrozTTZGeAnrDC8vAtQeya0vh3r35g4=;
	b=aubsTbCz2J03ebsHx5YMNPz+vCnRTn2SVDUHzV4RWAcoPSGngHtReBCmi1/XyTh4KGbt8A
	72hx/ld7+39lC45i4jqGr1WlT4lLcu/Rkvyu7Xj+/pjRSGYywHARH9pvG50tCZrLWq5EMW
	pyoqFG4tdKTLCW8zpowzsqFvlGyB/GM=
Date: Tue, 14 Jul 2026 19:31:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev>
 <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev>
 <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
 <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
 <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev>
 <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sdhrrnwk9i1a5hkbsnu3i4pdx8kkqrfh
X-Rspamd-Queue-Id: CFAE0140004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784028686-327139
X-HE-Meta: U2FsdGVkX19oOVOLUQ43wr+Man8lSiDz//Ou/tHI43Kj7AldEsV3Rnmplz+ImZQGpU6HDQCyNBMk1nE2bUntgiPRsHr2+/5oimL5xrOSpy0LAwyHYqXzd68ZcBpNKHCI5i2YqHWp7xjm+/WvFzzwvxpHyguvdEKNcFDo6mAUb0rTijNTfYM5rmga9dTCb1B7ZL34yqsv6+gb53Fl7GOLYNNGQdqszcLsZ7yjVdziZ3Negg0mE0uq+tjDcmU9fxXeWdCcZ+1fplTnd6LtuevgRLPmQh0tV3R5DtXrg1TeWnKxyLinMb38oezvsD7pp71Fxagc2kckLYNKj8PHpQ/+BAGIYFoYZeTBUrOYyBEZJZcgA8BwwES7I/YZd8Vkzvl4sgt/xrytT8ri8zB16FlDU1wNsrEqpLAbHGTz4AoX1+UJvy+1fpZzqK6cz2IoSBkGasXt+kWOZ9Zl0jSRgODQPUUkPTB6H8NT3tczwqpaWGjxkRPLGw9h/p652NgJ8Qp+cfnv61XuLWrJNakIYbcK0OYOYjYT3k+NVLydKmTM2Wx0vZd6DoSpZd5W23oSYlQFSE+PgJUNgfPzZRN6nnkd7ccyuVFlHE346/pRTrL9TVg7zdGW+kAf544HP/1BlBAmUVtDT5d1F13KGyH7+5uf47bMaub0bA28TNu3Ed23fU7/XYiP6GSkxJSpaMiHWScV00/dSd0GxoxgEKsb6xHr2H2NkDwudOT6xsBvWDCXzE7mfAKU9JtTH8ESoKdJNknhOOISBk/nvH6A1B0691sQBrUTIS+fhSgH4TYUG1xtDX6ahWnfx+PeCqmCFhKAV2zF83Ks/LoTq6aJ1CBV5zw9/TWIAHZ6ZEsPb+IN7O25uYBu1sV8RlBJGQjwmXX0LIfYlJcLID/2hhoRSSvdNzjQXAisCuQzkWlSf/4JiFVm6uJuObetOwyHyFZ/K9tcYzO34ryIjiXqUcNTqIusBh9
 3oziqG3H
 k9cTLASuSvgg2MmwW9MJz36PvLh7etH+oC/UFZ8q82sZQmi16KqHkG23G31xyq5UqoEEE3JAKDJiz8NNK/qJ47Wl9rkD8wkD87jYrM7ZuK1dsBmd1QVSBtJKxBVdBAZNp53eWGSy7LmP6PuXv9Fo3woIf3WDEDRIf5A9JB3zdP0iQ19OG4KmLo09Es8AJRzqApIqIFE1VeW8Ad1veCDoJWd9rr6jTbEwEfm+EUpqwFDDSeztqfNTqwYNlZgKsS0ox2OxMaTejJrrCCt3tAjT7OmjtRZju1Qm+PgrJofRMyc7C/iP/I4PkZjbLkSsF2UxtNtr96oLb4RnFQFu+ROEtrBHw4aLYtvFQLIONWsCxlvYiSGiNVZMDtGDWsXIPAulbJyUr1V8OVmlWzAzNlNUGgWxHu7lvk/qwLvWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/2026 6:21 PM, Barry Song wrote:
> On Tue, Jul 14, 2026 at 3:43 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 7/14/2026 9:48 AM, Barry Song wrote:
>>> On Tue, Jul 14, 2026 at 9:43 AM Barry Song <baohua@kernel.org> wrote:
>>>>
>>>> On Tue, Jul 14, 2026 at 9:20 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 7/13/2026 11:08 PM, Barry Song wrote:
>>>>>> On Sat, Jul 11, 2026 at 5:12 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>>>>
>>>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>>>>
>>>>>>> The per-memcg swappiness knob is v1-only; v2 always uses global
>>>>>>> vm_swappiness and ignores the per-cgroup field.
>>>>>>>
>>>>>>> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
>>>>>>> to memcontrol.h where it belongs.
>>>>>>>
>>>>>>> No functional change for v1; v2-only kernels drop the unused field.
>>>>>>>
>>>>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>>>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>>>
>>>>>> Reviewed-by: Barry Song <baohua@kernel.org>
>>>>>>
>>>>>> With some nits.
>>>>>>
>>>>>>> ---
>>>>>> [...]
>>>>>>>            struct mem_cgroup_per_node *nodeinfo[];
>>>>>>> @@ -365,6 +366,9 @@ enum objext_flags {
>>>>>>>
>>>>>>>     #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
>>>>>>>
>>>>>>> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>>>>>>> +extern int vm_swappiness;
>>>>>>
>>>>>> This is a bit unusual. I'm not sure whether mm/swap.h would be
>>>>>> a more appropriate place for this.
>>>>>>
>>>>> Thank you for your reply.
>>>>>
>>>>> The vm_swappiness variable is not utilized within mm/swap.c.
>>>>> Furthermore, since memcontrol.h does not include swap.h, retaining the
>>>>> extern int vm_swappiness declaration in mm/swap.h will result in a
>>>>> compilation failure.
>>>>
>>>> If this is the case, it still seems better to keep
>>>> extern int vm_swappiness in include/linux/swap.h.
>>>>
>>>> Then we don't need the comment:
>>>> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>>>>
>>>> It also makes it clearer that vm_swappiness is an extern variable
>>>> belonging to the swap module, rather than the memcontrol module.
>>>
>>> BTW, if mem_c_group_swappiness() and vm_swappiness are only used
>>> within mm/, could all of these be moved to mm/swap.h and
>>> mm/internal.h instead?
>>>
>>> We are making a big effort to move many unrelated things out of
>>> include/linux/swap.h recently. Could you check?
>>>
>>> https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com/
>>
>> Good suggestion. Moving them to mm/internal.h makes sense. Will update
>> in the next version.
> 
> Either mm/swap.h or mm/internal.h.
> vm_swappiness probably belongs in mm/swap.h rather than
> mm/internal.h, right?
> 
> BTW, I am not particularly eager about this cleanup;
> it could be done later as a separate patch.
> 
> If you decide not to do the cleanup, I think it would be better to
> leave "extern int vm_swappiness" in include/linux/swap.h rather than
> declaring it in include/linux/memcontrol.h?
I noticed that some swap-related macros are already defined in 
mm/internal.h, so I'm planning to place the code right after them for 
better grouping. Does that work for you?

```
...
#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
#define MIN_SWAPPINESS 0
#define MAX_SWAPPINESS 200

/* Just reclaim from anon folios in proactive memory reclaim */
#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)

extern int vm_swappiness;

static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
{
#ifdef CONFIG_MEMCG_V1
	/* Cgroup2 doesn't have per-cgroup swappiness */
	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
		return READ_ONCE(vm_swappiness);

	/* root ? */
	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
		return READ_ONCE(vm_swappiness);

	return READ_ONCE(memcg->swappiness);
#else
	return READ_ONCE(vm_swappiness);
#endif
}
...
```


-- 
Best regards
Ridong


