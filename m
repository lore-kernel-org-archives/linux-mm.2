Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE029C982FD
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17846B00A0; Mon, 21 Sep 2026 22:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8D66B00A2; Mon, 21 Sep 2026 22:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6A26B00A4; Mon, 21 Sep 2026 22:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79E126B00A0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:24:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D429280358
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:24:27 +0000 (UTC)
X-FDA: 85239804174.13.1D0BA9F
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf20.hostedemail.com (Postfix) with ESMTP id 999291C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:24:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t4IaOsFw;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790043866;
	b=30D5zB9IGVpOcQqhlz1HW65rgCYVT9zPIrIhM85gg4lKHHgoPq2vm0unCWJ5fed5hBVAad
	tSCGDddakfO/+LF3PsEp3zgUaIp6pbOgcspVAgD3qbXesakJ+/jViF/DgWa7yhoAm5/lmV
	n7LIJtXbmg1ygIcrh1aITWSZSJl2dII=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t4IaOsFw;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790043866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2H/S+DZbECctYnGZmmiBTIIP/TlRhAL/8fjYNSOhAc=;
	b=f2Pavxt3fbFMNK25veRaJQpnlGkE/ToqFlujOAktHXPoduMVWl6ftKZqPrYpy0WCPJcBER
	kMGVBFk//plN4LdYFCQDkMQpGHHubdd5ON73kT/bZF5HkVk9LKx5YKUHB6KSVykZZRoAI3
	icuUfYo5/L/uIS6Zg/6ytSWB1Onxy08=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DWZKjp4sCqIk8e08lozR04iXNlC3I5VUKgCLN8uovio=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790043863; v=1; x=1790648663;
 b=t4IaOsFwT42y5LoTk6Wi5j+VZ7kgkjZsD6fKr/vhVV70mVtBlmonjRMmEX9KKXcnn85wDr0Y
 BUuQhtngeKVwdzpnsv6eQN1y6agd3i3Jm00bSNwUC8QiVHAQifwxHRdN6L4gWbJLji/RhzZ1f7C
 aXZnBDSXmMH8y4BFZ5uI0+ok=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e4324fc653d572c0;
	Tue, 22 Sep 2026 02:24:23 +0000
X-Mizu-Trace-ID: e4324fc653d572c0
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 10:24:16 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH RFC 3/4] mm/vmscan: move struct scan_control to the local
 trace header
Message-ID: <arHm0PVMaG08bq-Z@fedora>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
 <20260921114606.3871820-4-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921114606.3871820-4-ridong.chen@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 999291C0002
X-Rspam-User: 
X-Stat-Signature: m7x1k6ec4c6ydm88rfu53arxup1c8jan
X-HE-Tag: 1790043865-907009
X-HE-Meta: U2FsdGVkX19EKebQPifTRvelLgkcMU/Rncl6Rk6ZoXTT1Ewa/BJD1cx2eZ+XIi3CyX16PERkKVam0ZVVEebNSsMhg3MfC6vHm8VsorM+lNMWuBy5tE7i8IxDTy1i/SstC14DqJprzPCf6pieWAyetpmC6snC5n3yosd/zYSPTgqmA2gWXCeovTVFyJEyKlDI6w2dOM5yYMuZsk9mc9PWLdyC25zVcaNq5/qgrX79q73VeW1n8ZOTDDgZNoOeJTKIihIN9wGvGz5elWfxyHq0NcOsDj9Mcrh1BDzL7nwBma0DDtV7pgIK1IPPGCLT8xoExqDKCOeBJ9IytfJ4exSkppm/+aQovpWmK2boGZFqd5ekzr+tl7ccaYimD1MGINVochH6E7NsD9R7WZAEkT9QeFOCW0b1oKUziCVCLB127FeY6N/TqwR5Jx9e2TFu5bFFhHBQ0u9rR7Y3YWb8Dda689e3DdHEF+/8JX0qSBrQ75zjYcs486Ae/rDttgUrkqStcvXuJAyjpnvWGjGrJEuCAFQhH/JsCQV3thg2qUE35QXZoidfSwa8aZJeIzPJOP0AKfLpK6b+lqf8OjfSMJibWLntaWQRCUeETlDP4vVCJ3jRNIa4i0HFX9aI5TtxKMXGXW4Ce/E8NijfI4/I66PYVW7tE0bTVYDEUm63T+xFuag5o/mtapAuFXjHjqVE1yLPEYTyU4ZgNPWrUAlL9npgWKHRj5miAMaTegDC6Xyl6s58V7Ya1qw19qIfcoRHU3ZIbiTqekc5S02me5iRgFaJLSIXMJxEVql06/qMmVcv7Wxz3C7sBAqYhyjXTF90u8+xtLys3adU9lj6jiYv8cxbNh+obtPBCC6PjhKXNzsyfC3deNucvcnlIh7CPak0GYevvSVka0eYKv5Y+TsyQggjMknduqQsHOLazq2ToaDmC6MP6sxW4Ds5OWJ+r4D9YwLXOkYg4qiLa6QbsEHOaqE
 DAy9j0Z6
 uY31T6hjrtulj0q6MbUUhMoqVkZqMAv7xO06qF7rnRWe8eAPygVXL/tTgjfUA+LZ+GnR53u38gsNT7UUPhho4fCO30yNzykQ617RcpQJSHaIMbHT+jO+OcjNl3RrButWzI8DOve6p0FnAJF6MRnJzp5ra2LNNWfOBy21JicivEia+7ZprpT8veQh/fJFIIPKYSjzdPRNGpTYb13KUCCFrbJzQOThxQJJk94xc1vaXmYK4EoD+hhdyBuwwJlj2MF655HSy/xPIjeR0BNXenWSHDClQ+RYirhhlg41FPKpnPmQj7Ckqnxs9ws+iRwA3ii2Hdtq9VkW9VeY2fq6zHJ9mudUaeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21/26 at 07:46pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Now that the vmscan tracepoints live in mm/trace_vmscan.h, move
> struct scan_control there as well so the trace events can reference
> reclaim-internal state directly. The definition is wrapped in its own
> include guard because the trace header is re-read under
> TRACE_HEADER_MULTI_READ, while a C struct may only be defined once.
> 
> No functional change.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/trace_vmscan.h | 115 ++++++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c       | 108 -------------------------------------------
>  2 files changed, 115 insertions(+), 108 deletions(-)
> 
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index c5d824fef554..c8ac5d4e4043 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h

This looks not good, I would rather see it's added in mm/internal.h, or
a new mm/vmscan.h. Putting scan_control in mm/trace_vmscan.h is too weird.

> @@ -9,8 +9,123 @@
>  #include <linux/tracepoint.h>
>  #include <linux/mm.h>
>  #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>  #include <trace/events/mmflags.h>
>  
> +/* Guard the struct against define_trace.h's repeated inclusion. */
> +#ifndef _MM_VMSCAN_INTERNAL_H
> +#define _MM_VMSCAN_INTERNAL_H
> +
> +struct scan_control {
> +	/* How many pages shrink_list() should reclaim */
> +	unsigned long nr_to_reclaim;
> +
> +	/*
> +	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
> +	 * are scanned.
> +	 */
> +	const nodemask_t *nodemask;
> +
> +	/*
> +	 * The memory cgroup that hit its limit and as a result is the
> +	 * primary target of this reclaim invocation.
> +	 */
> +	struct mem_cgroup *target_mem_cgroup;
> +
> +	/*
> +	 * Scan pressure balancing between anon and file LRUs
> +	 */
> +	unsigned long	anon_cost;
> +	unsigned long	file_cost;
> +
> +	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
> +	int *proactive_swappiness;
> +
> +	/* Can active folios be deactivated as part of reclaim? */
> +#define DEACTIVATE_ANON 1
> +#define DEACTIVATE_FILE 2
> +	unsigned int may_deactivate:2;
> +	unsigned int force_deactivate:1;
> +	unsigned int skipped_deactivate:1;
> +
> +	/* zone_reclaim_mode, boost reclaim */
> +	unsigned int may_writepage:1;
> +
> +	/* zone_reclaim_mode */
> +	unsigned int may_unmap:1;
> +
> +	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
> +	unsigned int may_swap:1;
> +
> +	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
> +	unsigned int no_cache_trim_mode:1;
> +
> +	/* Has cache_trim_mode failed at least once? */
> +	unsigned int cache_trim_mode_failed:1;
> +
> +	/* Proactive reclaim invoked by userspace */
> +	unsigned int proactive:1;
> +
> +	/*
> +	 * Cgroup memory below memory.low is protected as long as we
> +	 * don't threaten to OOM. If any cgroup is reclaimed at
> +	 * reduced force or passed over entirely due to its memory.low
> +	 * setting (memcg_low_skipped), and nothing is reclaimed as a
> +	 * result, then go back for one more cycle that reclaims the protected
> +	 * memory (memcg_low_reclaim) to avert OOM.
> +	 */
> +	unsigned int memcg_low_reclaim:1;
> +	unsigned int memcg_low_skipped:1;
> +
> +	/* Shared cgroup tree walk failed, rescan the whole tree */
> +	unsigned int memcg_full_walk:1;
> +
> +	unsigned int hibernation_mode:1;
> +
> +	/* One of the zones is ready for compaction */
> +	unsigned int compaction_ready:1;
> +
> +	/* There is easily reclaimable cold cache in the current node */
> +	unsigned int cache_trim_mode:1;
> +
> +	/* The file folios on the current node are dangerously low */
> +	unsigned int file_is_tiny:1;
> +
> +	/* Always discard instead of demoting to lower tier memory */
> +	unsigned int no_demotion:1;
> +
> +	/* Allocation order */
> +	s8 order;
> +
> +	/* Scan (total_size >> priority) pages at once */
> +	s8 priority;
> +
> +	/* The highest zone to isolate folios for reclaim from */
> +	s8 reclaim_idx;
> +
> +	/* This context's GFP mask */
> +	gfp_t gfp_mask;
> +
> +	/* Incremented by the number of inactive pages that were scanned */
> +	unsigned long nr_scanned;
> +
> +	/* Number of pages freed so far during a call to shrink_zones() */
> +	unsigned long nr_reclaimed;
> +
> +	struct {
> +		unsigned int dirty;
> +		unsigned int congested;
> +		unsigned int writeback;
> +		unsigned int immediate;
> +		unsigned int taken;
> +	} nr;
> +
> +	/* for recording the reclaimed slab by now */
> +	struct reclaim_state reclaim_state;
> +};
> +
> +#endif /* _MM_VMSCAN_INTERNAL_H */
> +
>  #define RECLAIM_WB_ANON		0x0001u
>  #define RECLAIM_WB_FILE		0x0002u
>  #define RECLAIM_WB_MIXED	0x0010u
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0eb7fa8e1d43..2fd9b42f89d8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -73,114 +73,6 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace_vmscan.h"
>  
> -struct scan_control {
> -	/* How many pages shrink_list() should reclaim */
> -	unsigned long nr_to_reclaim;
> -
> -	/*
> -	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
> -	 * are scanned.
> -	 */
> -	const nodemask_t *nodemask;
> -
> -	/*
> -	 * The memory cgroup that hit its limit and as a result is the
> -	 * primary target of this reclaim invocation.
> -	 */
> -	struct mem_cgroup *target_mem_cgroup;
> -
> -	/*
> -	 * Scan pressure balancing between anon and file LRUs
> -	 */
> -	unsigned long	anon_cost;
> -	unsigned long	file_cost;
> -
> -	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
> -	int *proactive_swappiness;
> -
> -	/* Can active folios be deactivated as part of reclaim? */
> -#define DEACTIVATE_ANON 1
> -#define DEACTIVATE_FILE 2
> -	unsigned int may_deactivate:2;
> -	unsigned int force_deactivate:1;
> -	unsigned int skipped_deactivate:1;
> -
> -	/* zone_reclaim_mode, boost reclaim */
> -	unsigned int may_writepage:1;
> -
> -	/* zone_reclaim_mode */
> -	unsigned int may_unmap:1;
> -
> -	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
> -	unsigned int may_swap:1;
> -
> -	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
> -	unsigned int no_cache_trim_mode:1;
> -
> -	/* Has cache_trim_mode failed at least once? */
> -	unsigned int cache_trim_mode_failed:1;
> -
> -	/* Proactive reclaim invoked by userspace */
> -	unsigned int proactive:1;
> -
> -	/*
> -	 * Cgroup memory below memory.low is protected as long as we
> -	 * don't threaten to OOM. If any cgroup is reclaimed at
> -	 * reduced force or passed over entirely due to its memory.low
> -	 * setting (memcg_low_skipped), and nothing is reclaimed as a
> -	 * result, then go back for one more cycle that reclaims the protected
> -	 * memory (memcg_low_reclaim) to avert OOM.
> -	 */
> -	unsigned int memcg_low_reclaim:1;
> -	unsigned int memcg_low_skipped:1;
> -
> -	/* Shared cgroup tree walk failed, rescan the whole tree */
> -	unsigned int memcg_full_walk:1;
> -
> -	unsigned int hibernation_mode:1;
> -
> -	/* One of the zones is ready for compaction */
> -	unsigned int compaction_ready:1;
> -
> -	/* There is easily reclaimable cold cache in the current node */
> -	unsigned int cache_trim_mode:1;
> -
> -	/* The file folios on the current node are dangerously low */
> -	unsigned int file_is_tiny:1;
> -
> -	/* Always discard instead of demoting to lower tier memory */
> -	unsigned int no_demotion:1;
> -
> -	/* Allocation order */
> -	s8 order;
> -
> -	/* Scan (total_size >> priority) pages at once */
> -	s8 priority;
> -
> -	/* The highest zone to isolate folios for reclaim from */
> -	s8 reclaim_idx;
> -
> -	/* This context's GFP mask */
> -	gfp_t gfp_mask;
> -
> -	/* Incremented by the number of inactive pages that were scanned */
> -	unsigned long nr_scanned;
> -
> -	/* Number of pages freed so far during a call to shrink_zones() */
> -	unsigned long nr_reclaimed;
> -
> -	struct {
> -		unsigned int dirty;
> -		unsigned int congested;
> -		unsigned int writeback;
> -		unsigned int immediate;
> -		unsigned int taken;
> -	} nr;
> -
> -	/* for recording the reclaimed slab by now */
> -	struct reclaim_state reclaim_state;
> -};
> -
>  #ifdef ARCH_HAS_PREFETCHW
>  static inline void prefetchw_prev_lru_folio(struct folio *folio,
>  		struct list_head *base)
> -- 
> 2.34.1
> 

