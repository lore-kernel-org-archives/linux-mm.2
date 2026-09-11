Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9668C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11326B008C; Fri, 11 Sep 2026 10:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC24A6B0092; Fri, 11 Sep 2026 10:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8376B0093; Fri, 11 Sep 2026 10:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8960E6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:10:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F3D6160259
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:10:07 +0000 (UTC)
X-FDA: 85201665654.27.91D12D6
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id BA84AC0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:10:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789135805;
	b=wPwIGYKnZwtvW19p12i0amU/kwBmwTJYs1D9CAxjMySOHHduuvAVkXHJGruofQ1dxvk3+d
	/BHawHJyFvvxzmkkuz+j/3sH8S62cXQirzgPy20FRAags33tHbrYvJkNlPFpDl/+EznWVo
	82jYJKuGBhtOW7sOmfU6UkwG03XkI50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789135805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNBI0OlIe4nzIdsfwzVCeMqFH4qZxaPBgm0tmhtgZaE=;
	b=1WoUPaDEsjieft9V+YNK5gDzTwuLs142thIJWzrt/WrTSI/PKaL2CrO64fm18csNCYRdZ4
	q7RDmQTBFioT1xf+Fsp4L1eHdQyIsDNZjFvPOWeSHUNosc8JkS2yLOh4wfjlbHMBMhQ8oR
	RdoaKP7YKxP/uQsGmU6FVI4ijwIlg+A=
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6324E1C1C17;
	Fri, 11 Sep 2026 14:10:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 7288820028;
	Fri, 11 Sep 2026 14:09:59 +0000 (UTC)
Date: Fri, 11 Sep 2026 10:11:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 2/3] mm/mglru: add tracepoint for scan_folios()
Message-ID: <20260911101120.25e3495a@gandalf.local.home>
In-Reply-To: <20260911072848.2346073-3-ridong.chen@linux.dev>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
	<20260911072848.2346073-3-ridong.chen@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19T0oTOyvjgt5li9uFXcMUJERRsN76FEGY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=mNBI0OlIe4nzIdsfwzVCeMqFH4qZxaPBgm0tmhtgZaE=; b=Y2VxROuqMdZ4zfgK9/f6AKrfKHXGoeUDmeQv85XnbiZZQOMTF84x1FM/RTeVyxo4c567bHvNLMv8fTaprArehqeBQaXu9+F3Fwb7c2U9XoNA2SABG8sRvSLIVDKgnIixjSDjNqUuEvsMg+yDH0sL5ZDc4JhdSUkDNxS7ijgRmm4=
X-HE-Meta: U2FsdGVkX1+EGFXRnXr/J3wqoz/KqkpAHbA33YbqajygCWkhwg0wfXJt4aZhAuaXRBNKSnOvt5Z3reG4g4wu6PCXgzdWSCgHqVcFVkESUfxoMO/77XBjhN99o1EqRO41WYpphK4aOzeD0N1FBkMjLmsBujhRKUu/j4e/7ZyF7tAFOB+E5VfYDkQQ7ywkxfGmY11K29qi83HDWYmpUgikZxAp408wyXkvXPXELwZXt2ND5qHAPSv4zy2c8iVVDfodX1h/OMI5ap/AS19+U1ehwrEg+EO8tBTvAO3Bqn+HsYG9dTSgMQb1FqtrqWMTU9l0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA84AC0005
X-Rspam-User: 
X-Stat-Signature: kncefyo9uzrzzhno1can5mi4yekcgefn
X-HE-Tag-Orig: 1789135799-473225
X-HE-Tag: 1789135805-931675
X-HE-Meta: U2FsdGVkX1+0JYiNgDYRfzlvkRMTEGYp4uZue+PTE1go702WTASxOh2yOrr1S+4oSEk9izt7E/qeev731XwlRJ1c+uAxVZuO27r9UqDQEClEZAB+riffJUN+GKad+TpztdDjpd7YROIcFgDsyV/n58UGLzt8AsYQT4FCKqy7UxPJiyLDfN056arKKEA0tPv79sGcIKlMEtzD03TsdudVJVA3ouGhrPgRCgaRdSveL6swNX9rqksv58uuohvSDKDNvlzW8ZoZhfHANkrImPssQJXgvIdqeqiYkg8Fq0pGubcHEL2plNjpZLR2BhnLBiIevOfZ2Ma7kE18QZmnSTaxtRvjG4ccQjuUBBMcM2Bc7SA0CnfpzcwpGiKVxdpGv+Ih1sx8F1u7QM0yBUAqyYrhDngNmC/EzlOtVGm7L0JX8/AVsxlh2tMacLMNmx5YHMupxFTBOIB7c4nMo2iX6eDIn7Y2iDs5/d9Hs/xUsVMXyvYlos5oiItv+AZ1KHxBqZOJhzIWWhYIA/zNcwNl+6bFgHbcLGqRyI4rHmHsZazZFXrBThrLXzuhQave4sGebiZoMqsFUhaJ81x0XM+tBiGnaQPL8HjuUE+mfQmJfzeftkQe7Udhf/bQumOnADK02/l3jsfpVSu8ZvQ1cXgZXHRoPY4EB0EYF6XwU0OH4LgJNRViXJIvzuFr4HlfQLHSbQfNNlStaY9NwDZbOFIyBkFggiY1yG6jZDBkUpmzA8P0l2QNB/ipMMAO5gmXrB14nVj7pZlMvU6Ao7URevVKzdcoNt/t8u95UQhCsAzNHp6yfvOgqYiRNmq9q2qTTgSPx94jV0U+l2AP4mOTPNy7TSn2ow079eypMirmcKmudf6Rvaj7pA1rVdL6Phj9yEN9M1G8n5F+QWAlorAZ9z2+wG9Rj3CDVoQ2QEuVe5MzcP8zQcJmBtXWHPvnjH+VQPv3VlA2CrAN167Fv9DIr0e8yzk
 Pqs8a+En
 m87tXDro33mI+21xLYrKXJF8XBS3KzkGjfTFCYZLEuRpkou2ShKx5t+Cz9yd149bpOHfodt2Cs6sMK/FEH4uigzo5iMGt/DgduDUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 15:28:47 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 8a872990b4be..c39dfacef033 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>  		__print_symbolic(__entry->lru, LRU_NAMES))
>  );
>  
> +TRACE_EVENT(mm_mglru_scan_folios,
> +
> +	TP_PROTO(u64 memcg_id,
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
> +
> +	TP_ARGS(memcg_id, highest_zoneidx, order, nr_requested, nr_scanned,
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

Please keep "int"s together. This creates a structure that is used to write
into the ring buffer. On 64bit machines, the above would add 4 bytes of
padding after each int, whereas:

		__field(unsigned long, max_seq)
		__field(unsigned long, min_seq)
		__field(int, lru)
		__field(int, tier)


would not.

> +	),
> +
> +	TP_fast_assign(
> +		__entry->memcg_id = memcg_id;
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
> index 2554a6513aa8..bd1b9ecf2e84 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> +	trace_mm_mglru_scan_folios(mem_cgroup_id(lruvec_memcg(lruvec)),
> +				   sc->reclaim_idx, sc->order, nr_to_scan,
> +				   scanned, sorted, skipped, isolated,
> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
> +				   lrugen->max_seq, tier,
> +				   lrugen->min_seq[type]);

Can't this information be processed in the tracepoint? That is:

	TP_PROTO(struct lruvec *lruvec,
		 struct scan_control *sc,
		 struct lru_gen_folio *lrugen,
		 unsigned long nr_requested,
		 unsigned long nr_scanned,
		 unsigned long nr_sorted,
		 unsigned long nr_skipped,
		 unsigned long nr_taken,
		 int type),

	TP_ARGS(lruvec, sc, lrugen, nr_requested, nr_scanned,
		nr_sorted, nr_skipped, nr_taken, type),

	TP_STRUCT__entry(
		__field(u64, memcg_id)
		__field(int, highest_zoneidx)
		__field(int, order)
		__field(unsigned long, nr_requested)
		__field(unsigned long, nr_scanned)
		__field(unsigned long, nr_sorted)
		__field(unsigned long, nr_skipped)
		__field(unsigned long, nr_taken)
		__field(unsigned long, max_seq)
		__field(unsigned long, min_seq)
		__field(int, lru)
		__field(int, tier)
	),

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


This moves the code to generate the parameters into the TP_fast_assign()
which is in a separate text section. It remove code from the work flow
improving instruction cache.

Same can be done for that trace_mm_vmscan_lru_isolate() trace event.

-- Steve

>  
>  	*isolatedp = isolated;
>  	return scanned;
> -- 

