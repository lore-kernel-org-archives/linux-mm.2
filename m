Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A7610FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 01:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1156B0088; Wed,  8 Apr 2026 21:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60996B008A; Wed,  8 Apr 2026 21:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F876B008C; Wed,  8 Apr 2026 21:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 840D16B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:29:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46F52C01FD
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:29:14 +0000 (UTC)
X-FDA: 84637284228.28.23755EC
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03F25A0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:29:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TaMrpk3L;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775698152; a=rsa-sha256;
	cv=none;
	b=YKEN3xW53mIB3juBxexaKTVFLgqULeaIS+2NmKplXO+ZAHA3o/1BgmmVX9rw4lgcS00qvV
	Y+opufmkPDW0+InEEEE4f06uwonGJ1xAUt82cEQUsZH894ZQj3hES69ruH8TwU8ecqO4WU
	+s8uB8IGVIhDPV3bgktAPv94ysMEI4M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TaMrpk3L;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775698152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DpAhVDfr8Quok6ciQMR/TnrA+KAslBk5pzeRLG23+s=;
	b=mpQni0IamXSxwSzkVGoxWvamF/YpjWgZp8s8lz8hCub0MnnYqvFogJh4Nd2ExGTT2Ik9r9
	FnooiTpFf/a3ZzQcORhBtYNA4YjXxovbOEYHg1OIxesVLHYM2LAst/v7nkhH7S4cRb4PgO
	ovKB48zHD3ivIyuJHOV8S4E1FkttpdQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775698147; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=6DpAhVDfr8Quok6ciQMR/TnrA+KAslBk5pzeRLG23+s=;
	b=TaMrpk3LjMSCPKoDQeXAKq+UqQio2aNusArP0LUNM6fVwMOqGQ9gIONwl06GLMKR9pUpUPeK2ltYBJF1CX6bJHucoXQ/uZ+cS5+P/Rkz443iKMet5+AgIXCI87cP0v9paoyqKSE9/Lq9lgLOBYhuqQVjepbza7HzvzRz50tVo68=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0gT4kj_1775698136;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0gT4kj_1775698136 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 09:29:05 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ingo Molnar <mingo@redhat.com>,  Peter
 Zijlstra <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com> (Donet Tom's
	message of "Wed, 8 Apr 2026 18:50:28 +0530")
References: <20260323094849.3903-1-donettom@linux.ibm.com>
	<87wlyqt52m.fsf@DESKTOP-5N7EMDA>
	<c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com>
	<87o6k1ubg4.fsf@DESKTOP-5N7EMDA>
	<bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com>
Date: Thu, 09 Apr 2026 09:28:59 +0800
Message-ID: <877bqgvs4k.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 03F25A0005
X-Stat-Signature: af64n1a4an8os6sqwpms8474hr5qixi3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775698150-772446
X-HE-Meta: U2FsdGVkX1/ux8LaV8L6sXbsk/UD9mPqkFwcKqWvLMNz/NYOO+5CVAaeLKa4yykXc/OA5XRZCqpDDEFL9XXSIx7E2bnMSESN7kBO8dkFNi+gKFkLiozztEnvK0XChnurE4YP2JPO/e8Z8MWo13npMegXq9IyoUOmXOyMZPi8opXBTtNdraSMzLDricajnp5PS5j5lNUYpik5haZq9QWGSvFnAl7+SS5p7yAEx0y9Vdl1Tma38xUjOPAM3s07Pr+TexmD8p3H+2vYbWFc65FYDbaOJ8zr2Z8v8jIw5cDEZOQVHBtgTXeN8VzarzkttNT7po2ohwgoCQ7p1Y8YBH04yVei0sKfkznAXC1ccxj8T8HoELckern99uQYaFkcuVtTVsrnQonLzwxYMwoPAse5sqtMsXA6J3dDfw2tl0QWFV/5WNR5lwc9UAQ1nBmUfsD8a/azUeqF/WaQ0jI20edeiC9El5QbXyUOrKcxxZL1w8Prlkc5LUlU5rKXOm6Rwy71w3lMMMxM4EgLUkM9W0PuDZqH1RPfiTyxJvP7bl/PRG7sijQTkHzo3PwLMZe4fEVCeeVE+wACXtuUblBkHyQNmvLQKGUUhla+FjJbMV/IpxQfyZ62HXp3eZDE5gDSWty8r/u4idGkacX1SHfwuSvOEATterg7bvKECSO6SOl1oy5e8Be7lpS+FB5uFk0R0e2Md44wxmOxZz+hnVQAoThJRDE01cmWx71pAHKVFOcrZYOaTzKfMkGhAg7jgxx70Ll1OlSnKU4BGlHHnfYfK68CCqU/aZTurU4+8rMsnvD4A0HhuJev9pMInQ840wjocF7qDoezPSgs4l13emtj4fM6nWcTag+SKq42lFcjZBQANfIl0O3UbrGRVN+NNA7Q+/QoWApd5Bij9ZOs/fyDtw7D0iDUsjKBzeSNjbA/zZzut8W4P3xCXJ3ANCHzKwYdC62x9XuNg0prDOl8TWKI0+u
 bxD4JIDL
 FmDVwe67XOjO4cFEzq0y300Dy4EqtHiWFu0y7Y3fWrBvHEVcBiuBD22yhXIcI5Jo0dtO6Rw7OpfwJ0wNHQbtG9NebPlr6nmC3VUNxVHY+egEXkqd54rK5sdBX4OVv8MMvjDGDsaitPn7fCjp2heJRSfa46oBqBbFSq1d0E8sabLuWCWlGzRy6/SnixsPbTCi0VXWGDW8qzsyyC1jrNfjkk38//WxtZt8Leb1DEYxmS+a3Iz2lZ2U76VoUg6bdymBZb8PannL+5uJyjQGHdfyGjVOjiayCqLLpZJGJFdYtpS3mOOSu+8jrkKXUNacsfPBUKEQHLh9j6nrTZQDAVzbjXhCNCy24qYzquqVbsfMc0q5OeN3Xd6Lx2HJXJNDBbHy4dpyJ6JXxmT/EVZBXThS7pJ56EUCrKRSE067v4tJJ2nC6aaOHey/LYYzh7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Donet Tom <donettom@linux.ibm.com> writes:

> On 4/2/26 11:54 AM, Huang, Ying wrote:
>> Donet Tom <donettom@linux.ibm.com> writes:
>>
>>> Hi
>> Hi, Donet,
>>
>>> On 4/2/26 8:57 AM, Huang, Ying wrote:
>>>> Donet Tom <donettom@linux.ibm.com> writes:
>>>>
>>>>> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
>>>>> disabled and the pages are on the lower tier, the pages may still be
>>>>> promoted.
>>>>>
>>>>> This happens because task_numa_work() updates the last_cpupid field to
>>>>> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
>>>>> enabled and the folio is on the lower tier. If
>>>>> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
>>>>> can retains a valid last CPU id.
>>>>>
>>>>> In should_numa_migrate_memory(), the decision checks whether
>>>>> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
>>>>> tier, and last_cpupid is invalid. However, the last_cpupid can be
>>>>> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
>>>>> evaluates to false and migration is allowed.
>>>>>
>>>>> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
>>>>> disabled and the folio is on the lower tier.
>>>>>
>>>>> Behavior before this change:
>>>>> ============================
>>>>>     - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>>>>>       nodes within the same memory tier, and promotion from lower
>>>>>       tier to higher tier may also happen.
>>>>>
>>>>>     - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>>>>>       lower tier to higher tier nodes is allowed.
>>>>>
>>>>> Behavior after this change:
>>>>> ===========================
>>>>>     - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>>>>>       between nodes within the same memory tier.
>>>>>
>>>>>     - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>>>>>       tier to higher tier nodes will be allowed.
>>>>>
>>>>>     - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>>>>>       enabled, both migration (same tier) and promotion (cross tier) are
>>>>>       allowed.
>>>>>
>>>>> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
>>>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>>>> ---
>>>>> v1 -> v2
>>>>> ========
>>>>> 1. Dropped changes in task_numa_fault() since the original changes
>>>>>      already handle runtime disabling of NUMA_BALANCING_MEMORY_TIERING.
>>>>>
>>>>> v1 -> https://lore.kernel.org/all/20260320092251.1290207-1-donettom@linux.ibm.com/
>>>>> ---
>>>>>    kernel/sched/fair.c | 6 +++++-
>>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>>> index bf948db905ed..4b43809a3fb1 100644
>>>>> --- a/kernel/sched/fair.c
>>>>> +++ b/kernel/sched/fair.c
>>>>> @@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>>>    	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>>>>>    	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>>>>>    +	/*
>>>>> +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
>>>>> +	 * and the pages are on the lower tier.
>>>>> +	 */
>>>>>    	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
>>>>> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
>>>>> +	    !node_is_toptier(src_nid))
>>>>>    		return false;
>>>>>      	/*
>>>> No.  Even if NUMA_BALANCING_MEMORY_TIERING is disabled, we should still
>>>> allow migrate pages from lower tier to higher tier via
>>>> NUMA_BALANCING_NORMAL.  If we have precious DDR, why waste it?  This
>>>> follows the semantics of NUMA_BALANCING_NORMAL before introducing
>>>> NUMA_BALANCING_MEMORY_TIERING.
>>> Thank you for the review comments.
>>>
>>> One thing I am trying to understand is that page promotion
>>> appears to happen regardless of whether
>>> NUMA_BALANCING_MEMORY_TIERING is enabled or disabled. In that
>>> case, what is the specific role of
>>> NUMA_BALANCING_MEMORY_TIERING? Do we get better performance
>>> when it is enabled?
>> You can search NUMA_BALANCING_MEMORY_TIERING to find out what it does.
>> We can get better performance as the original commit message says.
>>
>> When NUMA_BALANCING_MEMORY_TIERING is introduced, we didn't change the
>> original behavior of NUMA_BALANCING_MEMORY_NORMAL because we had no good
>> reason to do that.  In fact, you change its behavior, so you should
>> provide some supporting data or bug report to justify the change.
>>
>>> My initial understanding was that disabling
>>> NUMA_BALANCING_MEMORY_TIERING could be used to turn off
>>> promotion. However, it seems that currently we cannot control
>>> promotion independently. If NUMA_BALANCING_NORMAL is disabled,
>>> neither migration nor promotion happens, and if it is enabled,
>>> both migration and promotion can occur.
>>>
>>> I was under the impression that:
>>> - NUMA_BALANCING_NORMAL would handle migration within the same tier,
>>> - NUMA_BALANCING_MEMORY_TIERING would handle promotion across tiers,
>>> - and enabling both would allow both migration and promotion.
>>>
>>> This would provide more fine-grained control. Is my
>>> understanding correct, or am I missing something here?
>> You can change this, if you have some supporting data or bug report.
>
>
> Thanks for the clarification. I was running some experiments where I
> only required migration, not promotion. However, I observed that
> promotion was still occurring even when NUMA_BALANCING_MEMORY_TIERING
> was disabled, which led me to believe it might be a bug, so I reported
> it.
>
> As I understand it, enabling both NUMA_BALANCING_MEMORY_TIERING and
> NUMA_BALANCING_NORMAL results in both promotion and migration. Given
> this, do you see any concerns with modifying the behavior of
> NUMA_BALANCING_NORMAL?
>
> With this patch, we would have better control over enabling and
> disabling promotion independently. I would appreciate your thoughts on
> this.

IIUC, we change the existing user visible behavior only with strong
enough practical reason.  If so, making something conceptually better
isn't enough for that.

---
Best Regards,
Huang, Ying

