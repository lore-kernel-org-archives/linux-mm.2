Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4FE606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 01:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EJ/8kP6F
Received: by kanga.kvack.org (Postfix)
	id A143A6B05B4; Sun,  1 Nov 2026 20:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5166B05B5; Sun,  1 Nov 2026 20:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3DB6B05B6; Sun,  1 Nov 2026 20:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA506B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:40:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB17BC0AF2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:40:47 +0000 (UTC)
X-FDA: 85388474934.03.DC71C3D
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf30.hostedemail.com (Postfix) with ESMTP id C5B8580004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:40:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="EJ/8kP6F";
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793583646;
	b=uS0AGQxNLRy4y7lCLVtlacys02ZQHDJjYu+gYTy0b40WnPCkf2OUAX4tSPVzqmt0ST21XN
	jKqZV9Sy0nGZur0kKelEErgqM7IRoJTOo5LJduFadQEGVKkP5fa747+BKD8Zr2q0FL1Z67
	KnR0Fhd7t0X1x/42mmymB6FVN/bm/pw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="EJ/8kP6F";
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793583646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21iyJewWNMd8e6IRBB4JcFUC4Bis5AUIkV2DhaUZxHI=;
	b=ohE3gZaz6neXTHob59rXoTXYenz9TzF67255qCadbb2hYp/479FSvDnIka9B31fe0Pyjcq
	HbvwTLkOanjuALMRUasuSiAPUTEP1j2fKkb7gRZzGj79MobW1j2CjNu6A9Or34zymRlfNe
	UK/mJKJ4aCqkQ2RkkuOklBnTfDgvBTo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iE4Og/RYsCLiJImeDE5CnrDr9Hp7GqmhqU4rDjUMu18=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793583643; v=1; x=1794188443;
 b=EJ/8kP6F/8KtLi+DRS/fHEWqhvO8j1vNii3g6SFspbIfimuq5hh/jhXQCwz2btup0I0+zLnD
 jfqSumpbPdfv7MDyz4c79zZ0w8gWD+V/iHmaR/YhLaL5ZF47uir2e5ZE53BeHbOjhbMCeA5CYvx
 NAH1t3GQeTEDumf0llQdjR+k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id daf7adf831016618;
	Mon, 02 Nov 2026 01:40:42 +0000
X-Mizu-Trace-ID: daf7adf831016618
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 09:40:38 +0800
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
Subject: Re: [PATCH v5 4/6] mm/vmscan: pass scan_control to the vmscan
 tracepoints
Message-ID: <aufqFmK5sDnM8vgj@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-5-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031090041.58574-5-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: C5B8580004
X-Stat-Signature: mzzys9fdsqqo796d3ig3x81xn7p5zzsp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793583645-322357
X-HE-Meta: U2FsdGVkX1/tKLCH66eg5vZzkI0B4V5hkTQ4qrta9jsoc9AS4JNP16QKjZGKOXSlj9eTZbsNYspRnDQSCL32qscLjR9VewVaxkemaozIlKYyO6ggVCn1WV3cA/z0VJ+om6aNkEIuuqz8hc9M3OSMnCNUjRF6rfJQBDi7HDU6lqoJjCHhWEZMy2mbaAOmamhf3E9AvayiMQ0pR2gEDDK/jnVsGuEACpayhZ/S2m9ZQ6MtNEGsOZMtz79Frf+1K722FIasQbUs7+P/oyYNWzafLeenmy8ZcE09HeHpdC5XZuYUicdEdYdYgN60qEbme99It0EJMYypBgnEs5VDK2lRS2CEAME/jQ1IjZJePybV/aN/DiiERZ6fcIKyRjrNP2rlsbWSZz9JGZeYSE0zKgTRb0gxHBwsdrW/7LAD28h78mdLKOeEjrMiouml5DvMzGA/6Lb9kRhpmXxlp7/xNjJGestZPSeXvzLYtWJwlIzw9R3jaBzOkguUDmBQcjZYabmqWp5F+m1rVvVME4RhyLOB9HRZoHmHwktfYGRtwjt2BzPwKCYGsNOZ3UaEAXgWNmkMA8l4/5bgUlid5BsjvKrfsDXjGrySajk6GXg2VWsk9ojETuap85s7Pyf5lKUngyUpVCCJ2TwMro6zi7C/+26YOeMXLdXBj/loBcyM9nCkLlvDIxMYKX9PFaCiOdz8bQpGxeujbC+SoLYbEF6LbZqzFOq7ckQDOQfrcnItkRAjcpz1MrVm5LCasj40MMvqnvh/+xguPV6q1UJt8GpQkSrlmp+/AHG4uyU2qQjw44RgYexJjnabFYnsodF+AHnspJd53WaAMx1rY9yX8YGIT/ZUdooOw4zCHz3P0RSrtPQjvKdpotlCl3jO3qEJxBa0/LsjxIMQvUa40o6Q8RCDAo8qxeYdqgZF9FypjAsXBB2y18buHCS12G2ZBfcJq4nDRnf9P1YbAC+2OMsWaASy9lt
 D9Njlb+6
 QMzSRzcw+rM9fPxnRUo7Xe29EmTKjq0uYJqX9IEqrcq1KKPnSqn/WpKUomqjbz/vaxcziRJDhi7gZwAXH1IH8lBgZj8DtIRVJnOH0VLLbm2lThpcCHyttSJQYh6d8/RBuqQMdGktT3pmfUwmgPLuGYKcW7+/V4LMErbF03YyGq5usly91TT8PoJ3MAHA3wT3IF7Yfb4QAxD464QIgB3oivCs7e5ZkUi6SipH9+h9vUMt1Q39BcEwZxKqnhBRl02N8qLuRJBhxwff7unWqRj99hXTfnr/F8DCVPui9PGcxmSIGq7ZvqKDB545n4W4kInyMvwOEraRDru1eOYkfd4KR4CCmNw==
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
> Several vmscan tracepoints spell out reclaim state as individual
> arguments, all of which the caller already holds in struct scan_control.
> Now that the struct is visible from the trace header, pass sc directly
> and pick the fields out in TP_fast_assign instead of spelling them out
> at every callsite:
> 
> - mm_vmscan_direct_reclaim_begin, mm_vmscan_memcg_reclaim_begin and
>   mm_vmscan_node_reclaim_begin: gfp_mask and order.
> 
> - mm_vmscan_lru_isolate, mm_vmscan_lru_shrink_inactive and
>   mm_vmscan_lru_shrink_active: reclaim_idx, order and priority.
> 
> - mm_vmscan_reclaim_pages: nr_scanned. nr_reclaimed stays a separate
>   argument: it is the return value of shrink_folio_list(), which does
>   not update sc->nr_reclaimed.
> 
> - mm_vmscan_balance_pgdat_end: order and nr_reclaimed. highest_zoneidx
>   stays a separate argument: it is a balance_pgdat() parameter, and
>   sc.reclaim_idx may differ from it by the time the end event fires.
> 
> No functional change. The tracefs event format (TP_STRUCT__entry and
> TP_printk) is unchanged, so tracefs-based consumers are unaffected.
> BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
> to be adjusted; tracepoints are not a stable ABI (see
> Documentation/bpf/bpf_design_QA.rst).
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/trace_vmscan.h | 74 +++++++++++++++++++++++------------------------
>  mm/vmscan.c       | 26 ++++++++---------
>  2 files changed, 48 insertions(+), 52 deletions(-)

LGMT,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index 3917e1b62dfa..b2ad83e5f25e 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -124,10 +124,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
>  
>  TRACE_EVENT(mm_vmscan_balance_pgdat_end,
>  
> -	TP_PROTO(int nid, int order, int highest_zoneidx,
> -		 unsigned long nr_reclaimed),
> +	TP_PROTO(int nid, struct scan_control *sc, int highest_zoneidx),
>  
> -	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
> +	TP_ARGS(nid, sc, highest_zoneidx),
>  
>  	TP_STRUCT__entry(
>  		__field(int, nid)
> @@ -138,9 +137,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_end,
>  
>  	TP_fast_assign(
>  		__entry->nid = nid;
> -		__entry->order = order;
> +		__entry->order = sc->order;
>  		__entry->highest_zoneidx = highest_zoneidx;
> -		__entry->nr_reclaimed = nr_reclaimed;
> +		__entry->nr_reclaimed = sc->nr_reclaimed;
>  	),
>  
>  	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
> @@ -178,9 +177,9 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
>  
>  DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  
> -	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
> +	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
>  
> -	TP_ARGS(gfp_flags, order, memcg),
> +	TP_ARGS(sc, memcg),
>  
>  	TP_STRUCT__entry(
>  		__field(	unsigned long,	gfp_flags	)
> @@ -189,8 +188,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  	),
>  
>  	TP_fast_assign(
> -		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
> -		__entry->order		= order;
> +		__entry->gfp_flags	= (__force unsigned long)sc->gfp_mask;
> +		__entry->order		= sc->order;
>  		__entry->memcg_id	= mem_cgroup_id(memcg);
>  	),
>  
> @@ -204,17 +203,17 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  
>  DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
>  
> -	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
> +	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
>  
> -	TP_ARGS(gfp_flags, order, memcg)
> +	TP_ARGS(sc, memcg)
>  );
>  
>  #ifdef CONFIG_MEMCG
>  DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
>  
> -	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
> +	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
>  
> -	TP_ARGS(gfp_flags, order, memcg)
> +	TP_ARGS(sc, memcg)
>  );
>  #endif /* CONFIG_MEMCG */
>  
> @@ -350,15 +349,14 @@ TRACE_EVENT(mm_shrink_slab_end,
>  );
>  
>  TRACE_EVENT(mm_vmscan_lru_isolate,
> -	TP_PROTO(int highest_zoneidx,
> -		int order,
> -		unsigned long nr_requested,
> -		unsigned long nr_scanned,
> -		unsigned long nr_skipped,
> -		unsigned long nr_taken,
> -		int lru),
> +	TP_PROTO(struct scan_control *sc,
> +		 unsigned long nr_requested,
> +		 unsigned long nr_scanned,
> +		 unsigned long nr_skipped,
> +		 unsigned long nr_taken,
> +		 int lru),
>  
> -	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
> +	TP_ARGS(sc, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
>  
>  	TP_STRUCT__entry(
>  		__field(int, highest_zoneidx)
> @@ -371,8 +369,8 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>  	),
>  
>  	TP_fast_assign(
> -		__entry->highest_zoneidx = highest_zoneidx;
> -		__entry->order = order;
> +		__entry->highest_zoneidx = sc->reclaim_idx;
> +		__entry->order = sc->order;
>  		__entry->nr_requested = nr_requested;
>  		__entry->nr_scanned = nr_scanned;
>  		__entry->nr_skipped = nr_skipped;
> @@ -419,11 +417,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
>  
>  TRACE_EVENT(mm_vmscan_reclaim_pages,
>  
> -	TP_PROTO(int nid,
> -		unsigned long nr_scanned, unsigned long nr_reclaimed,
> -		struct reclaim_stat *stat),
> +	TP_PROTO(int nid, struct scan_control *sc,
> +		 unsigned long nr_reclaimed,
> +		 struct reclaim_stat *stat),
>  
> -	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
> +	TP_ARGS(nid, sc, nr_reclaimed, stat),
>  
>  	TP_STRUCT__entry(
>  		__field(int, nid)
> @@ -441,7 +439,7 @@ TRACE_EVENT(mm_vmscan_reclaim_pages,
>  
>  	TP_fast_assign(
>  		__entry->nid = nid;
> -		__entry->nr_scanned = nr_scanned;
> +		__entry->nr_scanned = sc->nr_scanned;
>  		__entry->nr_reclaimed = nr_reclaimed;
>  		__entry->nr_dirty = stat->nr_dirty;
>  		__entry->nr_writeback = stat->nr_writeback;
> @@ -466,9 +464,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
>  
>  	TP_PROTO(int nid,
>  		unsigned long nr_scanned, unsigned long nr_reclaimed,
> -		struct reclaim_stat *stat, int priority, int file),
> +		struct reclaim_stat *stat, struct scan_control *sc, int file),
>  
> -	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, file),
> +	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, sc, file),
>  
>  	TP_STRUCT__entry(
>  		__field(int, nid)
> @@ -498,7 +496,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
>  		__entry->nr_activate1 = stat->nr_activate[1];
>  		__entry->nr_ref_keep = stat->nr_ref_keep;
>  		__entry->nr_unmap_fail = stat->nr_unmap_fail;
> -		__entry->priority = priority;
> +		__entry->priority = sc->priority;
>  		__entry->reclaim_flags = trace_reclaim_flags(file);
>  	),
>  
> @@ -517,9 +515,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
>  
>  	TP_PROTO(int nid, unsigned long nr_taken,
>  		unsigned long nr_active, unsigned long nr_deactivated,
> -		unsigned long nr_referenced, int priority, int file),
> +		unsigned long nr_referenced, struct scan_control *sc, int file),
>  
> -	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
> +	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, sc, file),
>  
>  	TP_STRUCT__entry(
>  		__field(int, nid)
> @@ -537,7 +535,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
>  		__entry->nr_active = nr_active;
>  		__entry->nr_deactivated = nr_deactivated;
>  		__entry->nr_referenced = nr_referenced;
> -		__entry->priority = priority;
> +		__entry->priority = sc->priority;
>  		__entry->reclaim_flags = trace_reclaim_flags(file);
>  	),
>  
> @@ -551,9 +549,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
>  
>  TRACE_EVENT(mm_vmscan_node_reclaim_begin,
>  
> -	TP_PROTO(int nid, int order, gfp_t gfp_flags),
> +	TP_PROTO(int nid, struct scan_control *sc),
>  
> -	TP_ARGS(nid, order, gfp_flags),
> +	TP_ARGS(nid, sc),
>  
>  	TP_STRUCT__entry(
>  		__field(int, nid)
> @@ -563,8 +561,8 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
>  
>  	TP_fast_assign(
>  		__entry->nid = nid;
> -		__entry->order = order;
> -		__entry->gfp_flags = (__force unsigned long)gfp_flags;
> +		__entry->order = sc->order;
> +		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
>  	),
>  
>  	TP_printk("nid=%d order=%d gfp_flags=%s",
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 49677464fc9a..15e9184a580a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1764,7 +1764,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>  		}
>  	}
>  	*nr_scanned = total_scan;
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
> +	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
>  				    total_scan, skipped, nr_taken, lru);
>  	update_lru_sizes(lruvec, lru, nr_zone_taken);
>  	return nr_taken;
> @@ -2053,7 +2053,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>  	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> -			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
> +			nr_scanned, nr_reclaimed, &stat, sc, file);
>  	return nr_reclaimed;
>  }
>  
> @@ -2160,7 +2160,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
>  
>  	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
> -			nr_deactivate, nr_rotated, sc->priority, file);
> +			nr_deactivate, nr_rotated, sc, file);
>  }
>  
>  static unsigned int reclaim_folio_list(struct list_head *folio_list,
> @@ -2183,7 +2183,7 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
>  		list_del(&folio->lru);
>  		folio_putback_lru(folio);
>  	}
> -	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
> +	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
>  
>  	return nr_reclaimed;
>  }
> @@ -4849,9 +4849,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	mod_lruvec_state(lruvec, item, isolated);
>  	mod_lruvec_state(lruvec, PGREFILL, sorted);
>  	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
> -				scanned, skipped, isolated,
> -				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> +	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
> +				    scanned, skipped, isolated,
> +				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  
>  	*isolatedp = isolated;
>  	return scanned;
> @@ -4993,7 +4993,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	if (isolated)
>  		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
>  	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> -			type_scanned, reclaimed, &stat, sc->priority,
> +			type_scanned, reclaimed, &stat, sc,
>  			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  
>  	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> @@ -6889,7 +6889,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  		return 1;
>  
>  	set_task_reclaim_state(current, &sc.reclaim_state);
> -	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
> +	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
>  
>  	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
>  
> @@ -6930,7 +6930,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
>  
>  	set_task_reclaim_state(current, &sc.reclaim_state);
> -	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
> +	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
>  	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
> @@ -7407,8 +7407,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  	psi_memstall_leave(&pflags);
>  	set_task_reclaim_state(current, NULL);
>  
> -	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
> -					  highest_zoneidx, sc.nr_reclaimed);
> +	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
>  
>  	/*
>  	 * Return the order kswapd stopped reclaiming at as
> @@ -7886,8 +7885,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>  	unsigned int noreclaim_flag;
>  	unsigned long pflags;
>  
> -	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
> -					   sc->gfp_mask);
> +	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
>  
>  	cond_resched();
>  	if (!sc->proactive)
> -- 
> 2.43.0
> 

