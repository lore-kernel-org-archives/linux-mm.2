Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2A0C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421116B0092; Tue, 15 Sep 2026 07:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D32E6B0093; Tue, 15 Sep 2026 07:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA8B6B0095; Tue, 15 Sep 2026 07:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 041C16B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:14:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82ADEC03CD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:14:16 +0000 (UTC)
X-FDA: 85215737712.08.5F81248
Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34E9EC0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:14:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FE2PuXkI;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789470854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akRX+1+o4nWrm+Sq28PJaosZOQMk/YL+uJf1YcDQ6jM=;
	b=JywMKcWDCCpwtVt51QHWaF62WX06BhgtIkgcIExkXCo7L8IcUeUHdVIFBUjnlog/p5dU2P
	zSl5j1cEyTCOua8YqXNsOh5ruh/pFgw/9YO6vpUELPPFniTMbwAt2nrA1zZToWT//BWLD6
	nnFdNTyh/V+hm0MJ01T3iGTgNKgh52o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789470854;
	b=jOgPEmRiqVH5lxyORt3cfwAVPO+v06bcD8rdBJ2B1BdHenmKFY1oktVGrvRxtxbaVSYusg
	qepG3x5tSB33l1zRWc0ujgm0V9OPg2bHUkMeD7dLdiOMEZswW/PLCftyEMdYDg9NBd2Viu
	Djc2GBm0DRsQDJyZZE9e+i2Ej5rw0kQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FE2PuXkI;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wibSmjO0uWDWPZo+iAJSWnYXVZkkfn1R+Ze2nTc0SPE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789470851; v=1; x=1790075651;
 b=FE2PuXkIoaFqNjMAZYoSECHKT6ixpowIcLWuqP289hxHpEXAYJcy+eDffM+Lwy8fG8nW9sPn
 9a2wQv+/xbHrZrKeBlZFioYWAVdRVoujEJ7jxeU99ksEpB3L0xqoLJ7UW6e1fuDXxJhxI82iO4m
 unMffzWRWK3Cq72C38PpY2kI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9e5b113a4fa06a2f;
	Tue, 15 Sep 2026 11:14:10 +0000
X-Mizu-Trace-ID: 9e5b113a4fa06a2f
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 19:14:00 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
Message-ID: <aqkoeJvFzqpoGeaP@fedora>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911102939.2485750-3-ridong.chen@linux.dev>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ndu4q5bxd536ywhfaibdpq4qfjak7bpq
X-Rspamd-Queue-Id: 34E9EC0009
X-HE-Tag: 1789470853-35686
X-HE-Meta: U2FsdGVkX1+si1yFBChVAh2Y81arHsnLOfGpoIPz8mxrFktQFq+tHB8eDzJkVa7m8QuZKLkhifDCMJ3seV65GDMFofz33wcdaDeyjWnejKUKRaAWpb1L8CpRYnZaZKoWXRQfybCULhWU9IGqTEvsMn1qh0L9AUzT+LvKzZJTo4DTYd2r4ydVc1g5bqXPkivzrPlsDh7LjgVwYWvQ0BRCZkyhoWA8MBGIwBeWhYc3j6i+QXW3dUufko5f5W9FiiQn5iJ4bVmKZbBF6zzebWQkeYaUwGjX70FnWG5STvIF1Kg5EurAE+F1vbdXbF8FugnKZNVxhZkRTd3/eHULV1ksuAWEqhRj5IloiQtWpSVcMrD1xuhpcuH7FHSUMy05oGOWA2kKTVjkH3vIFfzP6nYTIUIh42cB68DPdwmYgmzm/khd/QTP+ZwEn/G81o04SHEhLNij3X8cCaWiPvIBwOjAuI0Tfe7YfCq6vlKOvOkUNBWxpse+S38Bo5sfXRppnKOwUuMOjjhai6NhiwUTrnRmstZ3NC/ZKMTN9rgHmh4bfXK7BCou7/8A77L/baV5a/UFZQ1tap/G6cEFGd0ZA33wlWapdq67OJTfCZJ+95AjX9QHT9CTpbxxfGuAH2KaEUzqyV4RFc1I49sA/LkFMij2JDroqe8C3HcYiAiAbuapyb0ApNCBI1NAJgOWVzsWAd9Vx+2euNXSDqmxBuN6wrhfzJRg4SVE0dxD3nvEymVTiSefcrx9WMJ7bnHfswnkNztVfCnrXaXQ46esbZDeT/RePTzpC7ri342wcDTJSbMfgqazDB0SKQLfqaD5le8ThVVAkOwdwhEliGdt7jTHfC9yyMQVRsCv/3MLkPpFVg1mTv19pAutXTRWbVO9SYhcmuEFHcoxup2MeuBVD5Z4e1/AzIAUnElxQw2ty0V3KCSEbAt4OSAzRkA6p70LTvyleLEoUhV6Vv5xz0QNf7fdr1s
 rVgBg/wm
 L4i6Y5q7jZwOW/10qQthZhMJwrnbTT3RtgX4geQ69DDRPpJgQQw4/omsrAiszWEd1B+t9fR8wTIVbrN2idCgTiChnuNeKWdR6m9qx7ghbuCl3vIBl7v/ucvAyGr6MgMW8cn9juKwFIPGUu+B8lUwkXHVPKygcc3bq0TCcZWfsBPlv9LjzNgzk8LJjkjQf+KJU7n6rlXFXvEbrVQx3kG9OMExHwSI3LTDmQNyokKzND1QnKQk2b28AaTiuaSNzK6Qt74muLRIi78QXBkyGmBCkJrbI+ZZAh72QUCiP7tHEJCUJOBOz58q+6bGjHMvPg4rZ5U5Mn8D7hVX1jZmcsiPhLqp1Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/11/26 at 06:29pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
...snip...
> ---
>  include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                   |  6 ++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 8a872990b4be..5defa8f6719c 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>  		__print_symbolic(__entry->lru, LRU_NAMES))
>  );
>  
> +TRACE_EVENT(mm_mglru_scan_folios,
> +
> +	TP_PROTO(struct lruvec *lruvec,
> +		int highest_zoneidx,
> +		int order,
> +		unsigned long nr_requested,
> +		unsigned long nr_scanned,
> +		unsigned long nr_sorted,
> +		unsigned long nr_skipped,
> +		unsigned long nr_taken,
> +		int lru,
> +		unsigned long max_seq,
> +		int tier,
> +		unsigned long min_seq),

Do we need show nid? Guess phone vendor doesn't care about multi-NUMA
system.

And I checked v1 thread, seems Steven suggested to move the two int to
avoid extra padding.

> +
> +	TP_ARGS(lruvec, highest_zoneidx, order, nr_requested, nr_scanned,
> +		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
> +
> +	TP_STRUCT__entry(
> +		__field(u64, memcg_id)
> +		__field(int, highest_zoneidx)
> +		__field(int, order)
> +		__field(unsigned long, nr_requested)
> +		__field(unsigned long, nr_scanned)
> +		__field(unsigned long, nr_sorted)
> +		__field(unsigned long, nr_skipped)
> +		__field(unsigned long, nr_taken)
> +		__field(int, lru)
> +		__field(unsigned long, max_seq)
> +		__field(int, tier)
> +		__field(unsigned long, min_seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> +		__entry->highest_zoneidx = highest_zoneidx;
> +		__entry->order = order;
> +		__entry->nr_requested = nr_requested;
> +		__entry->nr_scanned = nr_scanned;
> +		__entry->nr_sorted = nr_sorted;
> +		__entry->nr_skipped = nr_skipped;
> +		__entry->nr_taken = nr_taken;
> +		__entry->lru = lru;
> +		__entry->max_seq = max_seq;
> +		__entry->tier = tier;
> +		__entry->min_seq = min_seq;
> +	),
> +
> +	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
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
>  TRACE_EVENT(mm_vmscan_write_folio,
>  
>  	TP_PROTO(struct folio *folio),
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2554a6513aa8..67f59aa73fb9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> +	trace_mm_mglru_scan_folios(lruvec,
> +				   sc->reclaim_idx, sc->order, nr_to_scan,
> +				   scanned, sorted, skipped, isolated,
> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
> +				   lrugen->max_seq, tier,
> +				   lrugen->min_seq[type]);

And seems Steven also suggested to calculate lru, max_seq, min_seq in
TP_fast_assign() in v1 which could be missed.

        TP_fast_assign(
                __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
                __entry->highest_zoneidx = sc->reclaim_idx;
                __entry->order = sc->order;
                __entry->nr_requested = nr_requested;
                __entry->nr_scanned = nr_scanned;
                __entry->nr_sorted = nr_sorted;
                __entry->nr_skipped = nr_skipped;
                __entry->nr_taken = nr_taken;
                __entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
                __entry->max_seq = lrugen->max_seq;
                __entry->tier = tier;
                __entry->min_seq = lrugen->min_seq;
        ),


>  
>  	*isolatedp = isolated;
>  	return scanned;
> -- 
> 2.34.1
> 

