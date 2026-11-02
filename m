Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAD4606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 01:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HmAw0eVp
Received: by kanga.kvack.org (Postfix)
	id DBA506B05B2; Sun,  1 Nov 2026 20:38:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91546B05B3; Sun,  1 Nov 2026 20:38:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83E76B05B4; Sun,  1 Nov 2026 20:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F88E6B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:38:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DCD7C0BC8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:38:32 +0000 (UTC)
X-FDA: 85388469264.06.000B782
Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	by imf06.hostedemail.com (Postfix) with ESMTP id CEC0F180002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:38:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmAw0eVp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793583510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BO+2l3cgL7JHer1ORyq5HwVzOnSR8fUjlI8lNnXx5Q=;
	b=CA6uk9PCp0bY6qA+49bONmWFG6FxCRTUnV28yKtnC8Bh6jNgK9Vl4DyOedoM5h2LJDMzCx
	szS8SdmXio2h1xQF6c5XXwVsJuHT9jdE8b8DnOjhDyfVI8wzq9RiKUiDjHPdlHwc4sdenq
	DK6sC4+zjkLds6KwTNicSAjDbxsfxMI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmAw0eVp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793583510;
	b=zwoeOusr6wv1BrvAPjVE2a/k8klniS428SrWTtLmccmml2D7ZbekNmbhuiGUFbu705Zzpy
	c+U4ALhhLRRS8jln0COg9IcmvzwfCLQMq4K+aE0TYgcUCsIbrMNWv0fAD79CrKOl4iw2su
	E0GntRgJTYHELRB8F7nb34IlbGcPBj4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g1FggnIgcCQnDNhXHN5uinyRfEc/8X25vOiWkoW0Se4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793583508; v=1; x=1794188308;
 b=HmAw0eVpn7bvdijbrdFksDnNhvYSi6v5iijQGaRr8Davn6PyHIjOwLjQjIpB1vpuN2gyK3Bt
 8cAdeu3jZvEfyIIW6GB9fpGzm0/pm8G6kkl5cWHj0XlRJEAOO5WOLs3OD3vVos4e39EYvfSW7wx
 7WAmLpNd3NJ8rkc5SCNk/5HY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d5eaad83a3702ba8;
	Mon, 02 Nov 2026 01:38:28 +0000
X-Mizu-Trace-ID: d5eaad83a3702ba8
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 09:38:18 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 3/6] mm/vmscan: move struct scan_control to a
 dedicated header
Message-ID: <aufpiiCkpQaHG04m@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-4-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031090041.58574-4-ridong.chen@linux.dev>
X-Rspamd-Queue-Id: CEC0F180002
X-Stat-Signature: u61i8dp6rntqzkt11pc397fhkp65c4c6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793583509-697916
X-HE-Meta: U2FsdGVkX1/osFUBkG9t7+lnUid3ipV5FquImt2Ux4FKhx6TN1NdqdZH+uS0+sDFy/tZ+XstJp80bbpgfZPy4n5UU2LERTLNoLAc2QNsh808l3uCv2IToWD91klcwtpeqTUzVjCTHpgiUvq0+7gQVAaiSJKWhNu48fxNqMBdaHSR7eonYazW2knblkhDoeZraQlGYYos46Q+iYeqgrkKcZNYtcIy0IdJQBLILFZnnF+s8MBFacdFUpfcW0QgwUntPkS69jVGW4TXVjTvdX4WE9vxU5f2rugFN0Rjt41UAsVafvTTNtvNbchedMaIUx7aXsarX/F0QsxHcOVBTxCvOWWrGZ56QFSxOKUhNLsyuzfLiGoz/uruypaDUPrF32AoN9M4dU6AWTcNhHn2DJAND8icYr0iAm0wu4jVEiITw3bsLbWU5+Wh+77eXZ6hQe0R4ACoTzPpmUAdw42OUfPCOJ56QZgXgwD569i009RtBa1z2kNG/dmygMYB+2MVfWIhXlrznhxAnjVsMfFxX1fswCfQSTbEiqSIUyhpQSPewP6qaGRK1RccKcSfgL9Kg/1Gyd3OF8mgZX7wTANOwuDe30lR6mLhZYoB23qMDO31h8YiOnsB28PsErBEuP8qBfltpfQVX2OYS2ktgPIeV4aJ5XVQvYcg+GovVXm/DKGqt6YTKpo386BBoerQccArrtrgmLhK8rzy8Oj/qU6mBOCSO1UyKgtFpRBdKSHwWG26h/3L3Eh3Ndc3KxLFUVWdt/LP+MJBuZH62rFuJFuzrDtW+Gn9MndYoxGng5UUadARXW+IyKc7yozSzv33qlsEhMP2bnva+7pnui2jbOEE9/gP4pMsW6kW30ZiDmozULqI8RGI8OJF0wTvjSJw2T/OSAtNf+N1S0OR8h0XIUL1QYWqOGsWmg/I5ci6Q+0PGcciPboXmFzfjT4xjlHcVZlfxfPHdAXgyqFQ3cvJ8ZvGjWv
 sb2lNjEr
 S8AgQOWP6/UmukJSKzqjmeeMQvojJ7iqxO2IP/nUZzkzYQ3j7gtDqnNNsQYkszAF9odjygthEcWNtin9JnOlKoMohr/MUR7fiHtnVuWWQ3qdCD7y+DJ1V6HS+PXDdshW39uzg4sLfMjlnmYuZzfL4pgY5VKKCHHsH8a7Tbx90n2FA+FEw2mTA5GtlC6mk/oYB04jx6y7Cg5g80UJSPJbQxGAuDD13yVjvLczzNqavW4DJQck14Ed7Mla7JpMDzI4PC3+6yfhuwrNLC7b1SB+n/8oGDAUGZAhYCrm1+89D3yXFzxOmC0XWOKOyGp4Cdzglgng+Yn1fpLCbYyAQQYRRhnQPJTZKEn+CPX7fn3gSg4XudLVNYwQYyp1y9UNBaOoiQnYPfBYw7xSiI0TzRdvG4k+Ndg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 at 05:00pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The definition of struct scan_control has lived inline at the top of
> mm/vmscan.c. Move it out to a new mm/vmscan.h so the reclaim-internal
> state can be referenced from other reclaim translation units without
> duplicating the definition.
> 
> The header uses an ordinary include guard and pulls in only what the
> struct needs (nodemask_t, gfp_t and struct reclaim_state).
> 
> mm/trace_vmscan.h includes the new header directly so that any
> translation unit pulling in the trace events (mm/vmscan.c, mm/shrinker.c)
> sees the full definition of struct scan_control regardless of include
> order.
> 
> No functional change.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  MAINTAINERS       |   2 +
>  mm/trace_vmscan.h |   2 +
>  mm/vmscan.c       | 108 ------------------------------------------
>  mm/vmscan.h       | 118 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 122 insertions(+), 108 deletions(-)
>  create mode 100644 mm/vmscan.h

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2ad01107fa05..724791bb779f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17655,6 +17655,7 @@ F:	include/linux/mm_inline.h
>  F:	include/linux/mmzone.h
>  F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
> +F:	mm/vmscan.h
>  F:	mm/workingset.c
>  
>  MEMORY MANAGEMENT - MIGRATION
> @@ -17805,6 +17806,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
> +F:	mm/vmscan.h
>  F:	mm/workingset.c
>  
>  MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index ad90f0e9bf2e..3917e1b62dfa 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -11,6 +11,8 @@
>  #include <linux/memcontrol.h>
>  #include <trace/events/mmflags.h>
>  
> +#include "vmscan.h"
> +
>  #define RECLAIM_WB_ANON		0x0001u
>  #define RECLAIM_WB_FILE		0x0002u
>  #define RECLAIM_WB_MIXED	0x0010u
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 79d2d614afd0..49677464fc9a 100644
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
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> new file mode 100644
> index 000000000000..adb22e80d760
> --- /dev/null
> +++ b/mm/vmscan.h
> @@ -0,0 +1,118 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _MM_VMSCAN_H
> +#define _MM_VMSCAN_H
> +
> +#include <linux/gfp_types.h>
> +#include <linux/nodemask.h>
> +#include <linux/swap.h>
> +#include <linux/types.h>
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
> +#endif /* _MM_VMSCAN_H */
> -- 
> 2.43.0
> 

