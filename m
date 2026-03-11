Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0293B1125854
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDEA6B008A; Wed, 11 Mar 2026 13:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B856B0092; Wed, 11 Mar 2026 13:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E156B0095; Wed, 11 Mar 2026 13:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16ECB6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:32:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C92A7B7F14
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:32:03 +0000 (UTC)
X-FDA: 84534475326.18.21CEE6D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8887640015
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:32:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=usFHXj3w;
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773250322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyM17D46yinvuYWaZAzccGihacHtVbtTSHoTyuFgaKc=;
	b=V/o1lhxpSx7hOzH3iBdwcv9BmTqpGibQf3MrvauryNCCy7rPCQJdDWTW71E9iQcG7UpC8q
	5tRTBv7TF/8MdG5gUNJOCokgEqWms4y6hzAbvr8s6BS8U2ybw5mbSLEXlZlf3vobyzfRku
	7/Qg0nxNHdGJJZuwlg2B/3zQsnz1RUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=usFHXj3w;
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773250322; a=rsa-sha256;
	cv=none;
	b=8i4mAqSxN8Y7t4/OM2DfDpnw0gF0PtQpxn7VBBqimD4mepa083twb5jrMFX5D7LzubjuJH
	me1Xz5kvSf2a7U8uJEDwdKRBBs1sQRyihdxHRMcnFNJTb+5S01pofiEb7k/isgEXk3/UKt
	HxZ81TjY859ZOOsxgnOUjWcvsL4Ef8k=
Message-ID: <a26df89c-5504-445d-a639-ffd2d12efaf5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773250318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyM17D46yinvuYWaZAzccGihacHtVbtTSHoTyuFgaKc=;
	b=usFHXj3w2AqXsJ1LOeGv31v5R1ETaH6/W/uYTGsa7F+xPjIgKyARdhZOrkYilhGHFs7aLY
	FM5REEnhV2QC9XKTI0PNHZnhd3aPQ9YOxkViH3/x/z/lZQarLQkOIxJBcumL6qqwh4i9bR
	tOTWYERaHxlalspfyH7cH1wJ2iLp7iY=
Date: Wed, 11 Mar 2026 10:31:48 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <87seabu8np.fsf@DESKTOP-5N7EMDA>
 <977dc43d-622c-411d-99a6-4204fa26c21e@linux.dev>
 <87cy1boyzd.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <87cy1boyzd.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dohss5zgpb5z9w96j9xag6sjoudjm5ke
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8887640015
X-HE-Tag: 1773250321-321592
X-HE-Meta: U2FsdGVkX1/ysXz6z0R4GI8+DA/sIZLJCjexaZKKdUXHgBFWfnHReRPwt7ZShF8VAUy5bGUGRLfGansH7Rpy7RX6+vBDt5b1V06G4mtMO85GYbR04RA1Etevg/MCpe57/Kh4gfn1rHRV8hoqgqVR28hYSfgJGTpwiGGGLx79S4FaWJWHrmN02416xsqi2KUBW6uCPTefRYltTaq/7K4Xg97BvjJoaP5QE9PjSG1c43/InUmrwzVSyp6CeGm7liSkXnSQdbkfH0PQ1W81EwZ54zxs/SSAYmAXXJW3q1IpHDsdmjjkb8Bq/bBQTMHQWMw7F0T/k1zgrpDQhEUwIBE1VSHxpbKCquSR2js5jPB5m4YYkNi5ZFr9bl8JFy7pgRXvrCYMEK7wf/+tGHU2M/Or+L8WsVXqHfAV7EPev8CDq5dbe79Ehhe9H0jBjsMQVI5L+b68LWIigplYEWt5vU2lviX+HuszgpFR00KazecAB9zkwVtrIu9mxzPs93xYuyIabxJie+KVeURg8xXyJGw7JzzU4ib4wKwaYQpJRW9TrlgmMrgM83RJxtQz+vsdffjhH5QnnYbBFSIUW9hxvfP3c0nZM4QMB1J0UWJEIa9Z+h0YLfNL2D8ZX5PHybGEcjKWpNcDHePtCF49BzZqVq/YP6P/5WlBfzHlyA0E5FUzx9T52Zlon0nOdmdXcdvl912BnW6zps4i9G6IA29EvhUeSzjgCHq8y+vOtFCwk6WN6GlUxuwHoNh5OW0ikYWRAFYULdfBszCKEhOG8eEEd00oMo1IcVGwr8R7NwbywjTUcA7czwMkJBtOV6XXV0lk/1XqFbR3OQKCPSdHsFbxAA3DDto73/HMmUpTyHQKQ/VIvKvWJHUfkPzQ1ojPijMGCr8PTXqlVIWkYwGZ8IlaKp7hf583fUGWIA88ODGcTdHVKlCxb3M21r3S4Z8Mz61fdmSxpNKdmOYNvQjA6cHZ4YQ
 OI00fP9r
 +pew3SAH5KcIYGM/zgcHQj8KlkEaBVT1Ly1drhM1yWz05FlyaIrcbopRKNSwyKgRU/JeDBwZUfPXhkwCMxjZ4lVnsdFYBkZXVcj2Rvsv5aTdASb5vgCV2i0lQN7+gCbwo6FXrq+DWf1of9HJ/aB/Aj6pFj1xmTEWoPiTdieacQYytm8nj9wuNDAaqiWhTeIyqTUOTr9L//ZMgv5sO9GU2FCLuPnu3yFWvl6OFxXf+4Iug/S8NTWmw+wMOLoeRBCyPwNb5sxCpLnYu6ILe+oMEeoUULWNdCutJyMUTobFQiSeitXFMyRIV0Wz0RKyIzolgXHjezfr4naUPikg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 7:56 PM, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>> On 3/7/26 4:27 AM, Huang, Ying wrote:
>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>
>>>> When investigating pressure on a NUMA node, there is no straightforward way
>>>> to determine which policies are driving allocations to it.
>>>>
>>>> Add per-policy page allocation counters as new node stat items. These
>>>> counters track allocations to nodes and also whether the allocations were
>>>> intentional or fallbacks.
>>>>
>>>> The new stats follow the existing numa hit/miss/foreign style and have the
>>>> following meanings:
>>>>
>>>>     hit
>>>>       - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>>>>       - for other policies, allocation succeeded on intended node
>>>>       - counted on the node of the allocation
>>>>     miss
>>>>       - allocation intended for other node, but happened on this one
>>>>       - counted on other node
>>>>     foreign
>>>>       - allocation intended on this node, but happened on other node
>>>>       - counted on this node
>>>>
>>>> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
>>>> in /proc/vmstat.
>>> IMHO, it may be better to describe your workflow as an example to
>>> use
>>> the newly added statistics.  That can describe why we need them.  For
>>> example, what you have described in
>>> https://lore.kernel.org/linux-mm/9ae80317-f005-474c-9da1-95462138f3c6@gmail.com/
>>>
>>>> 1) Pressure/OOMs reported while system-wide memory is free.
>>>> 2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
>>>> down node(s) under pressure. They become available in
>>>> /sys/devices/system/node/nodeN/vmstat.
>>>> 3) Check per-policy allocation counters (this patch) on that node to
>>>> find what policy was driving it. Same readout at nodeN/vmstat.
>>>> 4) Now use /proc/*/numa_maps to identify tasks using the policy.
>>>
>>
>> Good call. I'll add a workflow adapted for the current approach in
>> the next revision. I included it in another response in this thread, but
>> I'll repeat here because it will make it easier to answer your question
>> below.
>>
>> 1) Pressure/OOMs reported while system-wide memory is free.
>> 2) Check /proc/zoneinfo or per-node stats in .../nodeN/vmstat to narrow
>>     down node(s) under pressure.
>> 3) Check per-policy hit/miss/foreign counters (added by this patch) on
>>     node(s) to see what policy is driving allocations there (intentional
>>     vs fallback).
>> 4) Use /proc/*/numa_maps to identify tasks using the policy.
>>
>>> One question.  If we have to search /proc/*/numa_maps, why can't we
>>> find all necessary information via /proc/*/numa_maps?  For example,
>>> which VMA uses the most pages on the node?  Which policy is used in the
>>> VMA? ...
>>>
>>
>> There's a gap in the flow of information if we go straight from a node
>> in question to numa_maps. Without step 3 above, we can't distinguish
>> whether pages landed there intentionally, as a fallback, or were
>> migrated sometime after the allocation. These new counters track the
>> results of allocations at the time they happen, preserving that
>> information regardless of what may happen later on.
> 
> Sorry for late reply.
> 
> IMHO, step 3) doesn't add much to the flow.  It only counts allocation,
> not migration, freeing, etc.

This logic would undermine other existing stats.

> I'm afraid that it may be misleading.  For
> example, if a lot of pages have been allocated with a mempolicy, then
> these pages are freed.  /proc/*/numa_maps are more useful stats for the
> goal.

numa_maps only show live snapshots with no attribution. Even if we
tracked them over time, there's no way to determine if the allocations
exist as a result of a policy decision.

> To get all necessary information, I think that more thorough
> tracing is necessary.

Tracking other sources of pages on a node (migration, etc) is
beyond the goal of this patch.

