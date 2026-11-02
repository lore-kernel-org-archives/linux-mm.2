Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C17B606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 01:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IfBo6+HP
Received: by kanga.kvack.org (Postfix)
	id 428AB6B05B5; Sun,  1 Nov 2026 20:45:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA086B05B6; Sun,  1 Nov 2026 20:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF376B05B7; Sun,  1 Nov 2026 20:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02C3C6B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:45:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D862E1C44FB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:45:00 +0000 (UTC)
X-FDA: 85388485560.18.12463A1
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D79421C0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:44:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IfBo6+HP;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793583899;
	b=Tric+awBqsy/U6CNGQrEtY5X3pDBc+RK2yD9PE97kruLHjPx9dNk2F+bumQxmjyxJVmgo2
	Y+F21u2gsqDsC1NPKYFRK9yTfKJK067VlI5s800MiSd501qpF4KO3tdbUErhjjRtjrBPZJ
	3T7j11Eo6TUjRQbFLISiPieaU8oXwD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793583899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEkd9ETEU1H1/cSly+n00AuAS0WaAgvozTBt/yDaZw8=;
	b=5kqgNkHU0QJrsjoeR1x7MBkDLnSO9SxOkgAbpuHrlBndPxPSAwfGc7+T9z2L4dxA+Sscz+
	xt+tH+qBPmGtHfEQOXj5P2CoXijfyC7HC6ZmKekFKGCGup8PLjR5VUR3EQJ2MVLbUQJw1r
	urSCqSGlfXv0kXkkWVIKGwH6tBn+AOw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IfBo6+HP;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LDCglTFD9JJRIRS4upbDvcHxcWE5gfnfo+qT8Q0O0nI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793583897; v=1; x=1794188697;
 b=IfBo6+HPGHoCqWTW9d7FL3Mpzw7lVFltwm4e1CNHpRdpYX1/oO7kbHAbyScuoA30S2BusA2W
 cd8BbN3JXJ9mplCKX4Bc6UCX3qNxMIB68maKTGcggwzBi15S5TEKnwqE/7so3LsMq+EmyPo/kcI
 Qg0dC8Bj3teYPVCcfsZ650SE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 672eb1f5ae80b659;
	Mon, 02 Nov 2026 01:44:57 +0000
X-Mizu-Trace-ID: 672eb1f5ae80b659
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 09:44:53 +0800
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
Subject: Re: [PATCH v5 5/6] mm/mglru: add tracepoint for scan_folios()
Message-ID: <aufrFRiP-PyWsCzs@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-6-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031090041.58574-6-ridong.chen@linux.dev>
X-Stat-Signature: yuiqi898xawxnik9dtk9b69gzekho9w8
X-Rspamd-Queue-Id: D79421C0006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793583898-452371
X-HE-Meta: U2FsdGVkX18sLqV89zL6umW5gVqwzKx6jf4BGaS1X1G0mlqLtSdE732nYeYuBqaDfMvYQz87GABCBf6jrhePfJeiFSPWa9bcDhdbilqKRtjJYsJLepjau36hs3PSuyMIpE56TQsfnLsE58+CSm0K8WTsw4TuqLPYz01hExpyd49SXDZEKikU/mzTB9nnjV7cyDw2prT+UYahqF482vmd66Jp/Hwtu+bMP75mIuG0QW9Mddrl6UFS9EJIJ4iUkP9jMhsutHEE2ydDjBiwu36GDiHxPFRwI92cdGG7FYUBwtiw2YYFRSKjjfcsTTgIEH5tc2e3QZXekPpvjF49xIpTvE3kliRylukEQ27dPR1m4oJmaj4P5ZYhDhF+IT0sYpqW5bCMFJveTrbXG3f8+yhhF892MCFqch0J/dwqpEC9cqJbZomy2leIuWZrv76+fhxBPKLFnoOvbETHYBWUg08gSF/Mh3FGNBQKvDQ03XdeOl5vNCuyvAqKmaB8aq3S8H5Ht4ybW2qtZD5X+zC0+BtMKI9rVimk5SzHeFsrDpR2WLCpcBNj/+K1ojBlEn3UXLIDkh6kY9xDjXWw+zHkzQYzDcpwd+N5RYnqqc9mO15EiMK8GmeCx2ufZKWhLjS+xl2iTMICXBhs4iuLVXzcTbxOhr9gnURIJGRdLoWAypBcPPt68aM8t32Aqm9CH4Qu6S2h2K9LI36SKaQk06IeL0fK7/CUd4LuYylrjh7pjMZAYiN+WzH6aw+pHow2ILuKCOqQJtck6AqxhSFS+P4+AgG5Fg1QHaNZm/G0lc/WI7ojqNW7GpGm3ZUlfn1bYr4uLcKofT/eZnuVNKAlK7xJQa04ZoVxGm3ugv8zH7shxabJhTm0gFC2cECXmMcqcct9SggQ/2tmSZxwg4k8ydatWIaHKlUMuzp4F6G+PpuKjEeM57tRkRdyqejWzyQYVqsl/uUuJFimD+O7EJtW8TWLPJN
 A6q1Qp0b
 psUgjfZXJyjv2ua8HEj7n0MEf9E1Uh7rr+zLvKogcleF0v1Llk1crhWXgSHQwXxezPKB/U5uSXWRuJSPjo6CV+74hAT82sOilfC+X0H0YFv+8GesncblkYqgsrpsYv4nvNzi5TeD/aZ7IUBj4J1A8Powpr1+hJ4afStCYz5AqeJ4z7QJ0QfbFfAn6u4AgZamsA7Zzr3dJWVwKhJKsInqUW7OW4fhrEywB1ExwWdSMSbhVO51SS1Nk2N8X3Ah5H+mJ0+XQFtSonjhgxaONZ5VelgGh0h9cYUja8BXQfn0getknK4I5BxiiKtbWxzVOoFPTRUEnPhSty8Rs9AhKjgNEdU9AV0vReY5PBXAL1f7QMTpWAR07yfTFy4kEDNqe0bvSFTYYqiN76Rd/pkfxSNq7jCbtACowMoqQTLfy6SIiuRxVwTfURTR6BiqTZLu//GsGsLkS
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
> MGLRU's scan_folios() emits the classic-LRU tracepoint
> trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
> scan/isolate counts and the LRU type, but carries no generation or
> memcg context, so a trace of an MGLRU run cannot tell which memcg a
> given scan belongs to, nor how far reclaim has progressed through the
> generations.
> 
> Add mm_mglru_scan_folios next to it, reporting the same counters plus
> nr_sorted (folios moved to a younger generation by sort_folio()) and
> the context the classic tracepoint lacks: the node id and memcg id of
> the lruvec, and the max_seq, tier and min_seq of the type being
> scanned.
> 
> Now that struct scan_control is visible to the trace header, pass sc,
> lruvec, type and tier straight in and derive everything else in
> TP_fast_assign(), so nothing is computed at the call site when the
> event is disabled. The int fields are grouped at the end of the entry
> to avoid padding on 64-bit.
> 
> scan_folios() is the MGLRU-specific layer where folios are actually
> scanned, so it has no classic-LRU counterpart. The existing tracepoint
> is left unchanged.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/trace_vmscan.h | 66 +++++++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c       |  2 ++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index b2ad83e5f25e..8148b8224422 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -392,6 +392,72 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>  		__print_symbolic(__entry->lru, LRU_NAMES))
>  );
>  
> +#ifdef CONFIG_LRU_GEN
> +TRACE_EVENT(mm_mglru_scan_folios,
> +
> +	TP_PROTO(struct lruvec *lruvec,
> +		 struct scan_control *sc,
> +		 unsigned long nr_requested,
> +		 unsigned long nr_scanned,
> +		 unsigned long nr_sorted,
> +		 unsigned long nr_skipped,
> +		 unsigned long nr_taken,
> +		 int type,
> +		 int tier),
> +
> +	TP_ARGS(lruvec, sc, nr_requested, nr_scanned, nr_sorted, nr_skipped,
> +		nr_taken, type, tier),
> +
> +	TP_STRUCT__entry(
> +		__field(u64, memcg_id)
> +		__field(unsigned long, nr_requested)
> +		__field(unsigned long, nr_scanned)
> +		__field(unsigned long, nr_sorted)
> +		__field(unsigned long, nr_skipped)
> +		__field(unsigned long, nr_taken)
> +		__field(unsigned long, max_seq)
> +		__field(unsigned long, min_seq)
> +		__field(int, nid)

Now it has nid printed out, it's cool. 

This patch looks good to me, thanks.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


> +		__field(int, highest_zoneidx)
> +		__field(int, order)
> +		__field(int, lru)
> +		__field(int, tier)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> +		__entry->nr_requested = nr_requested;
> +		__entry->nr_scanned = nr_scanned;
> +		__entry->nr_sorted = nr_sorted;
> +		__entry->nr_skipped = nr_skipped;
> +		__entry->nr_taken = nr_taken;
> +		__entry->max_seq = lruvec->lrugen.max_seq;
> +		__entry->min_seq = lruvec->lrugen.min_seq[type];
> +		__entry->nid = lruvec_pgdat(lruvec)->node_id;
> +		__entry->highest_zoneidx = sc->reclaim_idx;
> +		__entry->order = sc->order;
> +		__entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
> +		__entry->tier = tier;
> +	),
> +
> +	TP_printk("nid=%d memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
> +		__entry->nid,
> +		__entry->memcg_id,
> +		__entry->highest_zoneidx,
> +		__entry->order,
> +		__entry->nr_requested,
> +		__entry->nr_scanned,
> +		__entry->nr_sorted,
> +		__entry->nr_skipped,
> +		__entry->nr_taken,
> +		__print_symbolic(__entry->lru, LRU_NAMES),
> +		__entry->max_seq,
> +		__entry->tier,
> +		__entry->min_seq)
> +);
> +
> +#endif /* CONFIG_LRU_GEN */
> +
>  TRACE_EVENT(mm_vmscan_write_folio,
>  
>  	TP_PROTO(struct folio *folio),
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 15e9184a580a..ff51fee872f8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4852,6 +4852,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
>  				    scanned, skipped, isolated,
>  				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> +	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
> +				   skipped, isolated, type, tier);
>  
>  	*isolatedp = isolated;
>  	return scanned;
> -- 
> 2.43.0
> 

