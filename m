Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B5AC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F446B00A1; Mon, 21 Sep 2026 22:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046D76B00A2; Mon, 21 Sep 2026 22:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7506B00A6; Mon, 21 Sep 2026 22:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCC696B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:37:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3777080363
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:37:33 +0000 (UTC)
X-FDA: 85239837186.28.20DD1C8
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf29.hostedemail.com (Postfix) with ESMTP id 075DB120005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:37:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EQth+ETl;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790044651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjfysMf4HNwQJ0F4+jjSrFQjnob0U+APScEgUStFk68=;
	b=Thwj7SHkPlvcqKlcVFOsbum+59kyRzqsvCCka69U9ItHSRnhks780CuX2tMbZ9OU6WZ3pq
	Ibu2JtgOl3dzLyuIF5FWv97F4VLW82b2wgiQPT4SnfF57Zqx92hBZDwaFI0dtkEuGFS99U
	6PYMTQU9TlZvGw6qR0xGa6n8JgA96nM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EQth+ETl;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790044651;
	b=1UJz2ozqiQC1LIIBAoFlpwGDabO1pgKRKm8EicPUP2y0DzSDhzYqrQesWpoVDkXmp0zAnv
	gzxSZ68aMi45DaY9n99DPqZ49PmqCAwPrzf80SrvMlzY+UxtWbaL4/UHsMxo0mYuNARf8M
	XTPjM30BJNNH3oVxkf939PmMCURLe3M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oXcuiUEvPpxdNGvwMoDxu13JoB6hGuqYMXZ4T/ilDvE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790044649; v=1; x=1790649449;
 b=EQth+ETl80xFW214zMaf/kRRc8DXbeJAfqSwMA9pD3NSajRyxv/i20xZWyISUB8cPcxJ65li
 T8IKhyN5KGjoagnVOlDbVYmLLmmpUQ97RsetwOct0ar6idMKZh46qE7eka96Tmi37JJHeoHFokH
 m0ukylhRt/d4yYBWEoU5UTcw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 15abc27bba9dfcd4;
	Tue, 22 Sep 2026 02:37:29 +0000
X-Mizu-Trace-ID: 15abc27bba9dfcd4
X-Migadu-Flow: FLOW_OUT
Message-ID: <6dfa3c07-932a-4f58-9933-f7bd050d5f51@linux.dev>
Date: Tue, 22 Sep 2026 10:37:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] mm/vmscan: move struct scan_control to the local
 trace header
To: Baoquan He <baoquan.he@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
 <20260921114606.3871820-4-ridong.chen@linux.dev> <arHm0PVMaG08bq-Z@fedora>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <arHm0PVMaG08bq-Z@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 075DB120005
X-Stat-Signature: 1umqesxcnuoxgraqr87ub74tk5p1nioj
X-Rspam-User: 
X-HE-Tag: 1790044650-228128
X-HE-Meta: U2FsdGVkX1/w8ROzhlwENJNgec4fr09gba3L5JqtrdgDTPyumnV1831JG+atbNaLHXJY/EtfgoQJBCDS5OgrV/39f1VUjw+EVN90rPPaZIhpIOihKfT6ieFK0uRxGU4IYDcszmoyp0DN3pOCT0NaCb3cn+Gh4dggvO7g3Kwmg7tERUYDPpESqp9DXVaRPIge+4C4ADve5Rnf0VMmttRplY+MdWqzhDJRinhi6BKGWynfZxDQdOfeKKvB9tlPggUISx1r3bnop+vV3SbgxCGjho7pY+D4X/oHiIsBD3PVbpJRkG45JwaSwPY3Jy5fGK14p1me8CPQfzmASrIvcn2Y1PTEH0tp9/qsdGZxzRAcmhC4M0Ys+E4wUPISxmD+x8LoFAqVNU+/nr3HR+Zm2W+XmFsOaZvLfRztDRERrJoeeGpqtZGRfdIwU77I3Lh0LxMwzeyMy4U6JWuwilJTdzvh3gLycW2rlh+5KIY5A1fFJY9lTm9iLvGCKRdi5TG6jWwQvdrxcHQuOkE4XCXWd3jd3lC1j22SkhFYLwJMW/bebmU+gEZksKVPPGDRe2k7/lm9E2U7oljCyFwy5yuBHly0rMzEPzKe6G4p3vXAHrJ+O03yQrmuJpIqzNQPkKj4cYcLhBgg9eM3s89d33t5ckvGQkI3mmTZY8/CBTg+zA4JU93yNa1xTiDjHynC/MicvtNqYpv1s1vrIZxP3S164TgZI7ELTD3oK8nkDprcNpJXLUzdMHe/ebAXbX6pSXMRyY/smZ5IcTU8nivAOTwMGu3ta4m3DXifDvCrGoc79xL2iSlR5tBW41fo/JtXh3O6BceEtcFb0SS41h7sfLOLhaBRNx0/hFGCARugWhSUxdoh8f2JwY/RS2Wq1HCgLf2PjndqGgf9PucIC4xAf0pypTXqfE8L03exsyLSaiFG3jcEtOVvQznIWN/wnr6fDueytNof10ViOzQnA6ITDOYfFeZ
 V5YmFXf/
 Tfk0j0gcCXd0R36cm/9v5zJxc+QrPrbO0mTqEXkSIGUyefRIaooLu6ianwuutvsqxgUZ/nLmGpFaHPhNZB90BOl8DFkSSDg0j4Vihuw38o0WpKeaNCpIRC+7mvfFMiowEbKSKLy7xnXCRttOGNSwrhTmaTlIDDDvVUC+OeDO0E/Dcl6T4lN5prkNdvYYUflnqCmbTqubqCK1GiY81C1EbKgE49xSdc7iO1Sjn5orr4SVJitw3hyP2dO3I/v1DAMQleg2X/2R6PZZkrqd8RgRdW1/ut/uAZFGjgyQj5zmdhPFeyCu7bAw8gxQDjKMSKvJSXyNsli6quavNi+uJBEOafNjZ017pJsHDrktQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/22/2026 10:24 AM, Baoquan He wrote:
> On 09/21/26 at 07:46pm, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Now that the vmscan tracepoints live in mm/trace_vmscan.h, move
>> struct scan_control there as well so the trace events can reference
>> reclaim-internal state directly. The definition is wrapped in its own
>> include guard because the trace header is re-read under
>> TRACE_HEADER_MULTI_READ, while a C struct may only be defined once.
>>
>> No functional change.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/trace_vmscan.h | 115 ++++++++++++++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c       | 108 -------------------------------------------
>>   2 files changed, 115 insertions(+), 108 deletions(-)
>>
>> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
>> index c5d824fef554..c8ac5d4e4043 100644
>> --- a/mm/trace_vmscan.h
>> +++ b/mm/trace_vmscan.h
> 
> This looks not good, I would rather see it's added in mm/internal.h, or
> a new mm/vmscan.h. Putting scan_control in mm/trace_vmscan.h is too weird.
> 

Thanks.

I'm not sure whether the maintainers would be happy to make scan_control
external. I'd prefer to move scan_control to a new mm/vmscan.h, since
mm/internal.h is getting larger and larger. So I'd like to hear other
opinions.

>> @@ -9,8 +9,123 @@
>>   #include <linux/tracepoint.h>
>>   #include <linux/mm.h>
>>   #include <linux/memcontrol.h>
>> +#include <linux/swap.h>
>>   #include <trace/events/mmflags.h>
>>   
>> +/* Guard the struct against define_trace.h's repeated inclusion. */
>> +#ifndef _MM_VMSCAN_INTERNAL_H
>> +#define _MM_VMSCAN_INTERNAL_H
>> +
>> +struct scan_control {
>> +	/* How many pages shrink_list() should reclaim */
>> +	unsigned long nr_to_reclaim;
>> +
>> +	/*
>> +	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
>> +	 * are scanned.
>> +	 */
>> +	const nodemask_t *nodemask;
>> +
>> +	/*
>> +	 * The memory cgroup that hit its limit and as a result is the
>> +	 * primary target of this reclaim invocation.
>> +	 */
>> +	struct mem_cgroup *target_mem_cgroup;
>> +
>> +	/*
>> +	 * Scan pressure balancing between anon and file LRUs
>> +	 */
>> +	unsigned long	anon_cost;
>> +	unsigned long	file_cost;
>> +
>> +	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
>> +	int *proactive_swappiness;
>> +
>> +	/* Can active folios be deactivated as part of reclaim? */
>> +#define DEACTIVATE_ANON 1
>> +#define DEACTIVATE_FILE 2
>> +	unsigned int may_deactivate:2;
>> +	unsigned int force_deactivate:1;
>> +	unsigned int skipped_deactivate:1;
>> +
>> +	/* zone_reclaim_mode, boost reclaim */
>> +	unsigned int may_writepage:1;
>> +
>> +	/* zone_reclaim_mode */
>> +	unsigned int may_unmap:1;
>> +
>> +	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
>> +	unsigned int may_swap:1;
>> +
>> +	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
>> +	unsigned int no_cache_trim_mode:1;
>> +
>> +	/* Has cache_trim_mode failed at least once? */
>> +	unsigned int cache_trim_mode_failed:1;
>> +
>> +	/* Proactive reclaim invoked by userspace */
>> +	unsigned int proactive:1;
>> +
>> +	/*
>> +	 * Cgroup memory below memory.low is protected as long as we
>> +	 * don't threaten to OOM. If any cgroup is reclaimed at
>> +	 * reduced force or passed over entirely due to its memory.low
>> +	 * setting (memcg_low_skipped), and nothing is reclaimed as a
>> +	 * result, then go back for one more cycle that reclaims the protected
>> +	 * memory (memcg_low_reclaim) to avert OOM.
>> +	 */
>> +	unsigned int memcg_low_reclaim:1;
>> +	unsigned int memcg_low_skipped:1;
>> +
>> +	/* Shared cgroup tree walk failed, rescan the whole tree */
>> +	unsigned int memcg_full_walk:1;
>> +
>> +	unsigned int hibernation_mode:1;
>> +
>> +	/* One of the zones is ready for compaction */
>> +	unsigned int compaction_ready:1;
>> +
>> +	/* There is easily reclaimable cold cache in the current node */
>> +	unsigned int cache_trim_mode:1;
>> +
>> +	/* The file folios on the current node are dangerously low */
>> +	unsigned int file_is_tiny:1;
>> +
>> +	/* Always discard instead of demoting to lower tier memory */
>> +	unsigned int no_demotion:1;
>> +
>> +	/* Allocation order */
>> +	s8 order;
>> +
>> +	/* Scan (total_size >> priority) pages at once */
>> +	s8 priority;
>> +
>> +	/* The highest zone to isolate folios for reclaim from */
>> +	s8 reclaim_idx;
>> +
>> +	/* This context's GFP mask */
>> +	gfp_t gfp_mask;
>> +
>> +	/* Incremented by the number of inactive pages that were scanned */
>> +	unsigned long nr_scanned;
>> +
>> +	/* Number of pages freed so far during a call to shrink_zones() */
>> +	unsigned long nr_reclaimed;
>> +
>> +	struct {
>> +		unsigned int dirty;
>> +		unsigned int congested;
>> +		unsigned int writeback;
>> +		unsigned int immediate;
>> +		unsigned int taken;
>> +	} nr;
>> +
>> +	/* for recording the reclaimed slab by now */
>> +	struct reclaim_state reclaim_state;
>> +};
>> +
>> +#endif /* _MM_VMSCAN_INTERNAL_H */
>> +
>>   #define RECLAIM_WB_ANON		0x0001u
>>   #define RECLAIM_WB_FILE		0x0002u
>>   #define RECLAIM_WB_MIXED	0x0010u
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 0eb7fa8e1d43..2fd9b42f89d8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -73,114 +73,6 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "trace_vmscan.h"
>>   
>> -struct scan_control {
>> -	/* How many pages shrink_list() should reclaim */
>> -	unsigned long nr_to_reclaim;
>> -
>> -	/*
>> -	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
>> -	 * are scanned.
>> -	 */
>> -	const nodemask_t *nodemask;
>> -
>> -	/*
>> -	 * The memory cgroup that hit its limit and as a result is the
>> -	 * primary target of this reclaim invocation.
>> -	 */
>> -	struct mem_cgroup *target_mem_cgroup;
>> -
>> -	/*
>> -	 * Scan pressure balancing between anon and file LRUs
>> -	 */
>> -	unsigned long	anon_cost;
>> -	unsigned long	file_cost;
>> -
>> -	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
>> -	int *proactive_swappiness;
>> -
>> -	/* Can active folios be deactivated as part of reclaim? */
>> -#define DEACTIVATE_ANON 1
>> -#define DEACTIVATE_FILE 2
>> -	unsigned int may_deactivate:2;
>> -	unsigned int force_deactivate:1;
>> -	unsigned int skipped_deactivate:1;
>> -
>> -	/* zone_reclaim_mode, boost reclaim */
>> -	unsigned int may_writepage:1;
>> -
>> -	/* zone_reclaim_mode */
>> -	unsigned int may_unmap:1;
>> -
>> -	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
>> -	unsigned int may_swap:1;
>> -
>> -	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
>> -	unsigned int no_cache_trim_mode:1;
>> -
>> -	/* Has cache_trim_mode failed at least once? */
>> -	unsigned int cache_trim_mode_failed:1;
>> -
>> -	/* Proactive reclaim invoked by userspace */
>> -	unsigned int proactive:1;
>> -
>> -	/*
>> -	 * Cgroup memory below memory.low is protected as long as we
>> -	 * don't threaten to OOM. If any cgroup is reclaimed at
>> -	 * reduced force or passed over entirely due to its memory.low
>> -	 * setting (memcg_low_skipped), and nothing is reclaimed as a
>> -	 * result, then go back for one more cycle that reclaims the protected
>> -	 * memory (memcg_low_reclaim) to avert OOM.
>> -	 */
>> -	unsigned int memcg_low_reclaim:1;
>> -	unsigned int memcg_low_skipped:1;
>> -
>> -	/* Shared cgroup tree walk failed, rescan the whole tree */
>> -	unsigned int memcg_full_walk:1;
>> -
>> -	unsigned int hibernation_mode:1;
>> -
>> -	/* One of the zones is ready for compaction */
>> -	unsigned int compaction_ready:1;
>> -
>> -	/* There is easily reclaimable cold cache in the current node */
>> -	unsigned int cache_trim_mode:1;
>> -
>> -	/* The file folios on the current node are dangerously low */
>> -	unsigned int file_is_tiny:1;
>> -
>> -	/* Always discard instead of demoting to lower tier memory */
>> -	unsigned int no_demotion:1;
>> -
>> -	/* Allocation order */
>> -	s8 order;
>> -
>> -	/* Scan (total_size >> priority) pages at once */
>> -	s8 priority;
>> -
>> -	/* The highest zone to isolate folios for reclaim from */
>> -	s8 reclaim_idx;
>> -
>> -	/* This context's GFP mask */
>> -	gfp_t gfp_mask;
>> -
>> -	/* Incremented by the number of inactive pages that were scanned */
>> -	unsigned long nr_scanned;
>> -
>> -	/* Number of pages freed so far during a call to shrink_zones() */
>> -	unsigned long nr_reclaimed;
>> -
>> -	struct {
>> -		unsigned int dirty;
>> -		unsigned int congested;
>> -		unsigned int writeback;
>> -		unsigned int immediate;
>> -		unsigned int taken;
>> -	} nr;
>> -
>> -	/* for recording the reclaimed slab by now */
>> -	struct reclaim_state reclaim_state;
>> -};
>> -
>>   #ifdef ARCH_HAS_PREFETCHW
>>   static inline void prefetchw_prev_lru_folio(struct folio *folio,
>>   		struct list_head *base)
>> -- 
>> 2.34.1
>>

-- 
Best regards
Ridong


