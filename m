Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0761FD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FBF6B0088; Tue, 10 Mar 2026 22:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCDA6B0089; Tue, 10 Mar 2026 22:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C06D6B008A; Tue, 10 Mar 2026 22:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69C1C6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:58:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1662140375
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:58:03 +0000 (UTC)
X-FDA: 84532272846.11.DE5D337
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C7171C0003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:58:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aObveawp;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773197882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCqCXWA7676dPICIruRpxokb7vPTtkgULujt8gpuiuM=;
	b=ialyhTptSc98iNVIeTZ/mplE0y5JZaio83Wz2dYsfXzbzAlxlE2Wd2mkOixx+SKGQB/ORX
	ByUvSTdliz4btxpE3kGt9ghSFsCEgz8rDjjzvaHR+I8upNOt0MD78+mc1tlNoHiximuivx
	18Ok8iI3I8BWH8PhPvsCQTMcDtvozLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773197882; a=rsa-sha256;
	cv=none;
	b=nCK/PZVcSFDY5A8l1j56cAsJ2NMU6lXCEdwJj1MqYr4zbU2UnsZbjc1YW9lx8xtscppLOb
	VVMeZ1W1f99q8xZ9ETHEPthxvB+tWYNfropQ5r6kKFWhRQq26I8yPWT5yXK85LLRFtfbRZ
	I9ISg0HbBrVbTO6clQ1kEaZpNZE+wSw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aObveawp;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773197877; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=KCqCXWA7676dPICIruRpxokb7vPTtkgULujt8gpuiuM=;
	b=aObveawpwdup4wMqZdsQvqHUF2VSgeg+r1iCXuBeieZCdCPuq+Ntf5iQsZ8T6hAoF+I0WP4mOwPCGtoXMuGVdCbl8hcx2AMcpmoNgDddeHlUIfNwLV9NxCmxq0y9YfUmOv5y6MaIgk3Tg+3HacCPAo7meHKscFEHaj7aE8DfhsI=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X-iF9Lj_1773197800 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 10:57:56 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org,  akpm@linux-foundation.org,  mhocko@suse.com,
  vbabka@suse.cz,  apopple@nvidia.com,  axelrasmussen@google.com,
  byungchul@sk.com,  cgroups@vger.kernel.org,  david@kernel.org,
  eperezma@redhat.com,  gourry@gourry.net,  jasowang@redhat.com,
  hannes@cmpxchg.org,  joshua.hahnjy@gmail.com,  Liam.Howlett@oracle.com,
  linux-kernel@vger.kernel.org,  lorenzo.stoakes@oracle.com,
  matthew.brost@intel.com,  mst@redhat.com,  rppt@kernel.org,
  muchun.song@linux.dev,  zhengqi.arch@bytedance.com,  rakie.kim@sk.com,
  roman.gushchin@linux.dev,  shakeel.butt@linux.dev,  surenb@google.com,
  virtualization@lists.linux.dev,  weixugc@google.com,
  xuanzhuo@linux.alibaba.com,  yuanchu@google.com,  ziy@nvidia.com,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
In-Reply-To: <977dc43d-622c-411d-99a6-4204fa26c21e@linux.dev> (JP Kobryn's
	message of "Sun, 8 Mar 2026 21:31:27 -0700")
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
	<87seabu8np.fsf@DESKTOP-5N7EMDA>
	<977dc43d-622c-411d-99a6-4204fa26c21e@linux.dev>
Date: Wed, 11 Mar 2026 10:56:38 +0800
Message-ID: <87cy1boyzd.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C7171C0003
X-Stat-Signature: peowwzhtmhmczsomrg8g1q9s5zqmhfqq
X-HE-Tag: 1773197880-720180
X-HE-Meta: U2FsdGVkX1/oHyQjKrajyXvw3AT7P5t/Op/o64uUL5+O8pYG19L1DFfkCdP3hi+4uoglKvteGT66e7XxdjXlpcRAUbCZ0k9314OX2c/HDNZZjue9A5SmL3T92o5cCe+W8S6oCiGOW84Bt9Y+bh8Lj/MK+5GHAIJdZVdOni3nVRm5O6wgD1TOkHxwTrDeQx7asTO1rIxNwKYxSSxXsl00eFQ00JEGDBGXvlAwCulQdIsEUeBKwT6FkGZFGq6cid+aiEgNs7yIUriUYmsizmnv/bqN5qKaxHHUgE0RAYp5tUHBf/Y+MtJsKuqGh41Yn6HUDEmL9rXU8XYUw2k0TD0vDq+hU4sgjk8MeTTklLFlVfpxwa0b0OOFBEAI81utZrz/4rgrBnyMldnRzzlvNioncsaize1RanRtbAb+0PV17M7kA9fbqHdTfFYbe+xLi1Qfe/cCTme1AKM9b3LdnLMs6f905xOHRqR2ucBxV1wYrDPq+9Ay/3Ebr6lWC0ASRuk/L9PeUB2r+V765aJvaXMynvlzKZWu3OZYvnVuE8Q7Ql4GRIX2Bzlgk06HVDVdxx2SV1QvxOQsxMnoVbuB4ObUK4qUB71lK5SH8TSxPqRzcnK7mB1lZobRcZAkk+iaZ/BR2LyJbYl1naEhDDHBPFD1u1wOgvADD+zzBXKL8T4j823JRUTL2+/5VzCgNWOuHrr+qi8x82l/DF8DMM3xVQfg3iKT/lnaP3fS5JvWY10+UsV3g3X6Cu1TfWcXGu2f42YJ5gefXnVvg/t3f8huQwhosGxalXiZRjvXAW/T632ySvFYr3XijazCrHrK+/k8CEQ6QqD1blxLBefZdtjCQjSo1XcqTMupb4NkG8IX1T3k9ewyDFappA/+42dLgiI4g5dZdIj5gun4dXNH7nuZchKcb8Sbcxo1HMf2EhObA6bv+bs5ZrBaSnfQNJOBqf6znHY3bnMrunZeBLBehZv/mnu
 GUuxXndX
 7s1CL9Pj+TvB3bMZnSdjxohxUhIoZiGypkZDU8KTlqhVOgPUTGwLaTahWM4be6A2AWygavR1ASLb5QbRystdspR9Yhh8yGT5TEoI9Efx3App6uWh0uP4SaIW2lwNlmPfRdes0rJRA4iUtfg9Yv4QS3tZ69eRJdtlvD15FlS4YY82xg14qWIETsBywb4PCB0yUVqZ/Ygo4Bh3Le7KFTrvJ16OYMdJBsrd3aijacWZ0vgKGRmcDyhs2yJClIQagZO7xXhlPiWZlwj6Orw3rfAg7a2W1dmRza+qWSgWulkUqKYVmv2ol38AhkPEc4YYtgj0s74XTFXfBkHEGWNYnk65rFwK9KZam6V1JFipHRwfA5msbdk80FL2/B5uyxh0Mesa6zf1oeM3YU+K22xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:

> On 3/7/26 4:27 AM, Huang, Ying wrote:
>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>> 
>>> When investigating pressure on a NUMA node, there is no straightforward way
>>> to determine which policies are driving allocations to it.
>>>
>>> Add per-policy page allocation counters as new node stat items. These
>>> counters track allocations to nodes and also whether the allocations were
>>> intentional or fallbacks.
>>>
>>> The new stats follow the existing numa hit/miss/foreign style and have the
>>> following meanings:
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
>> IMHO, it may be better to describe your workflow as an example to
>> use
>> the newly added statistics.  That can describe why we need them.  For
>> example, what you have described in
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
>
> Good call. I'll add a workflow adapted for the current approach in
> the next revision. I included it in another response in this thread, but
> I'll repeat here because it will make it easier to answer your question
> below.
>
> 1) Pressure/OOMs reported while system-wide memory is free.
> 2) Check /proc/zoneinfo or per-node stats in .../nodeN/vmstat to narrow
>    down node(s) under pressure.
> 3) Check per-policy hit/miss/foreign counters (added by this patch) on
>    node(s) to see what policy is driving allocations there (intentional
>    vs fallback).
> 4) Use /proc/*/numa_maps to identify tasks using the policy.
>
>> One question.  If we have to search /proc/*/numa_maps, why can't we
>> find all necessary information via /proc/*/numa_maps?  For example,
>> which VMA uses the most pages on the node?  Which policy is used in the
>> VMA? ...
>> 
>
> There's a gap in the flow of information if we go straight from a node
> in question to numa_maps. Without step 3 above, we can't distinguish
> whether pages landed there intentionally, as a fallback, or were
> migrated sometime after the allocation. These new counters track the
> results of allocations at the time they happen, preserving that
> information regardless of what may happen later on.

Sorry for late reply.

IMHO, step 3) doesn't add much to the flow.  It only counts allocation,
not migration, freeing, etc.  I'm afraid that it may be misleading.  For
example, if a lot of pages have been allocated with a mempolicy, then
these pages are freed.  /proc/*/numa_maps are more useful stats for the
goal.  To get all necessary information, I think that more thorough
tracing is necessary.

---
Best Regards,
Huang, Ying

