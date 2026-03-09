Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DF1EA8551
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 04:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A302C6B0088; Mon,  9 Mar 2026 00:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDE86B0089; Mon,  9 Mar 2026 00:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF736B008A; Mon,  9 Mar 2026 00:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 798476B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:12:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3896140CF6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:12:17 +0000 (UTC)
X-FDA: 84525202314.02.C18C5B7
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1CBEA40006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:12:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ieW0DHeZ;
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773029536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+We0UTCfei8hJDh4dOY5+VilrUyV36V3uZTQdBlRfg=;
	b=Tgx3ViN5wsym22zPXZjwrAjatFkzzv+QFL9ATLTPh5JlZlRaoePE8TmfZwRbVGtUR58hdJ
	Mu8PRzdT3xBpWRWWFkCjZDUCmLqmJkpIz5tJ1mlffT6LHqthPa2gY0vzU2Vh2qKmudeKYi
	zj7ijEUrlMmXzrqIjxMBFPD+G7C7490=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ieW0DHeZ;
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773029536; a=rsa-sha256;
	cv=none;
	b=sIyXtUlfjFSmyqxf1ZqsymchZnuaTXjwgmxgtIfFwwIuB0RIrxYoEu+n+Uf2EkF7Ty6zDV
	c9HotH0UNnEprTFhdV8nizvKQ2XmDj7zsgLuSM3SyqvRs/OTGzH5k4F3V11m2i1Yu41fhh
	trhJHoqdR82koV5vwJeen3G3uPwZ/PQ=
Message-ID: <0829a4f6-f885-4727-b9bb-b274fd444b5e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773029533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7+We0UTCfei8hJDh4dOY5+VilrUyV36V3uZTQdBlRfg=;
	b=ieW0DHeZxDFVY9pCFQ77R7jbAOeRtZSOCy3S74dqwXfxr6WmNfhFbhv92YTa39I40TYVK9
	TfzDax1iWH4zLO74kWRVKpvQgJ/mWwbzO7RB57vZkDSrgm/MuYHALYPZ7xuJ4dbpm59ABK
	Ab7q6dvbWfsONJI36NxztfUOmivs8Zk=
Date: Sun, 8 Mar 2026 21:11:59 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: Gregory Price <gourry@gourry.net>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <87seabu8np.fsf@DESKTOP-5N7EMDA> <aa3MBp0JhUN6zE8i@gourry-fedora-PF4VCD3F>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <aa3MBp0JhUN6zE8i@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CBEA40006
X-Rspamd-Server: rspam08
X-Stat-Signature: fjoz99tzrrumwk6fi3n83omjbqnhsyge
X-HE-Tag: 1773029535-518980
X-HE-Meta: U2FsdGVkX18PjYhQmO4aZYJ+BmofIQN8NTiXBXYu2VmARhcDC4CLKvgNXGldr5nCc2sgVCNQYuVN1MMAURt3I4z12ZLKw+UtLImjn6Uz9/BDl80ch2lF4Mo91lcU/VJlKjC2Ts6Svq6fXb+qXD6MsTy0aq/w0Ht5hVzhr5QLavnYvF61RCuXHZINYDLCoFOLoTQd0aeTzy7TIyD8+nX6VRFeN372cj+zCODcCG4/JTdj4P6nfBRBNzE/VpOXdqQvrRpkXQGxEyqdMYffb/QmpGHQQdGubazBcit2xyNLu2SyYERN5Z63MDRFkzkA78wZq9fQi3lNBPHw6Jvi4UMHeNMLW437mtk70viSlSHi3yT7Hz8oP01NgTajl9jWABxEzIQMTbHSIjqT+6WUizbZvsC2XsaRhDbX/KoQfqfqccn0GBRKGV5v6mnH5ji8TzOeOaEI604M1HoDcJbz6Nk0+XMygV+t43BnZsATjXm6qqrGv7AnCHzASUP5LUf31D3f+JggcBercWtz+jIeijXDxTS0YChupjX4acHUhHYmwoOTgXFamnBGBt0btJTm5ZdK2tnnDW0Zfpfip09HzVTEFXw6S/677avo9PGjWpfuqsKJLDG/+4zYAjmv+lYWuJPrN0ZYeRz9T1CAj6pkihC5tuhde4LfHMKYApFKqA78lgsv+SKqMdvM32rfof5A55DXFEX3YD326+PCurQdJAbOOW3d3DTkVlYS09RmMWCCblyYQKNJcDA72Q+tnBupeSTdLOz/zniKYDH4o2g0ETJ2WEoGc43/UWVlsUuneAS02TSmdMERTzk33H+POUVLY7BkFZK13ZGDWNyKdbkxbDIfGI6W5ZF1mbZWiqCPLPJBJKEY2EPYvDGWtfklv0DDvD8NUOLb//xsfnztlw8ZS7ezt+qbomhJQx/NSq6SYfTZ8EzFdwoxZxyh7cAb0QNMl+Yhyy9bwaBGd3cHtfQqbnm
 OAC6CUPB
 6Fht+fchEwYTmJ7DJT/W7XXVeUU45/j5IyvTYtAFr06Mq2vLIOzLgrA6Gsr29mGxnYxgCdJWHBpW4L43ZeBmsOMZOI9qFP6tQgsHyw5CWH5nsp48nbj2xFjDpAZ1UxW7H4QvlQ656n+nD50/fxC6QwFW8pqVYDOzbnj1r9wF2d9oVIJ6HlHOrcGjIF/OAqiKDA3QLoFUYBE5XgPtRrH5ssAxxEu2EoJaEvhoWTi2b+LWyGrnSNPOT9K9o0AXByL9LaiFb97g3V5yOhDtGt5kmxdMTT7axw56A5+UulVBU/QMYij1AcAL7aIRPKHrk9uOrQBKNgiULDrS6Jog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/8/26 12:20 PM, Gregory Price wrote:
> On Sat, Mar 07, 2026 at 08:27:22PM +0800, Huang, Ying wrote:
>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>
>>>
>>>    hit
>>>      - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>>>      - for other policies, allocation succeeded on intended node
>>>      - counted on the node of the allocation
>>>    miss
>>>      - allocation intended for other node, but happened on this one
>>>      - counted on other node
>>>    foreign
>>>      - allocation intended on this node, but happened on other node
>>>      - counted on this node
>>>
>>> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
>>> in /proc/vmstat.
>>
>> IMHO, it may be better to describe your workflow as an example to use
>> the newly added statistics.  That can describe why we need them.  For
>> example, what you have described in
>>
>> https://lore.kernel.org/linux-mm/9ae80317-f005-474c-9da1-95462138f3c6@gmail.com/
>>
>>> 1) Pressure/OOMs reported while system-wide memory is free.
>>> 2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
>>> down node(s) under pressure. They become available in
>>> /sys/devices/system/node/nodeN/vmstat.
>>> 3) Check per-policy allocation counters (this patch) on that node to
>>> find what policy was driving it. Same readout at nodeN/vmstat.
>>> 4) Now use /proc/*/numa_maps to identify tasks using the policy.
>>
>> One question.  If we have to search /proc/*/numa_maps, why can't we
>> find all necessary information via /proc/*/numa_maps?  For example,
>> which VMA uses the most pages on the node?  Which policy is used in the
>> VMA? ...
>>
> 
> I am a little confused by this too - consider:
> 
> 7f85dca86000 interleave=0,1 file=[...] mapped=14 mapmax=5 N0=3 N1=10 ...
> 
> Is n0=3 and N1=10 because we did those allocations according to the
> policy but got fallbacks, or is it that way because we did 7/7 and
> then things got migrated due to pressure?

That ambiguity should be resolved with this patch.

> 
> Do these counters let you capture that, or does it just make the numbers
> even more meaningless?

You would be able to look at the new counters and see that the
allocations were distributed evenly at the time of allocation. If an
imbalance is observed afterward we would know that it was due to
migration.

> 
> The page allocator will happily fallback to other nodes - even when a
> mempolicy is present - because mempolicy is more of a suggestion rather
> than a rule (unlike cpusets).  So I'd like to understand how these
> counters are intended to be used a little better.

That was the motivation for v2. In the previous rev, there was debate on
the lack of accounting for the fallback cases. So in this patch we
account for the fallbacks by making use of miss/foreign. In terms of how
the counters are intended to be used, the workflow would resemble:

1) Pressure/OOMs reported while system-wide memory is free.
2) Check /proc/zoneinfo or per-node stats in .../nodeN/vmstat to narrow
    down node(s) under pressure.
3) Check per-policy hit/miss/foreign counters (added by this patch) on
    node(s) to see what policy is driving allocations there (intentional
    vs fallback).
4) Use /proc/*/numa_maps to identify tasks using the policy.

