Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19F2E81A3C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DCE6B0088; Mon, 16 Feb 2026 11:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F046B0089; Mon, 16 Feb 2026 11:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51FD6B008A; Mon, 16 Feb 2026 11:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF3BE6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:03:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52EC3C404D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:03:54 +0000 (UTC)
X-FDA: 84450790788.17.A15D2AF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5419440009
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:03:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cww3fojq;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771257832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoBTiJLuQJ9fkPhkSercyUgUATiDuyc3IG1+yyGn5p0=;
	b=NzKj+qa9wZttba9IHqb5KGDj3yqDV7H6+KqjqNbkXjr1tQRE7mcwj9r8TGwT0hFROwKRXG
	+8BPIL9HBi1hcH3aozzjoPUsoqoKi17d7OjngjI/wDfVAajEZt43aws2m7YvEqpmAQdsUx
	vrx2ibQR02O+DQxXX7cYIzXXSB6WrzU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cww3fojq;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771257832; a=rsa-sha256;
	cv=none;
	b=tASV+vI/R2l2DXDJQwuGaZAQQqh1A1Cq399hI88qNtX2VC7d1RakkA1SJaUkhyT6HAXjUZ
	HpryZYUPYN7oWl00zD6JjWZGURRoXe9L0T50VG2iLEy4UZ0E5L63jIL9Z3pIG296NA2Fa9
	38Xd0qPgOfBhNMwL4zxT2t52C/+ZM64=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771257830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoBTiJLuQJ9fkPhkSercyUgUATiDuyc3IG1+yyGn5p0=;
	b=cww3fojq6AJxpft6Q4NoMLB9alkb2FcIGHFdMU9na1WLoNdoeGtMGycT6hDbp3v0U6s/BU
	V+HJN/izShNhsrA8tGR5/g9WbqtjFwR/SBd3SkJ1uT6IxSOrou9R4aff6Krchincb5x33b
	RXVB2I3jlAuqLQ6i3h3D3FNdJ6fnFe0=
From: Usama Arif <usama.arif@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v6 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon, 16 Feb 2026 08:02:37 -0800
Message-ID: <20260216160247.3956707-1-usama.arif@linux.dev>
In-Reply-To: <20260213181537.54350-4-tballasi@linux.microsoft.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1r7kkomsgkdpqz993txczwq6yfx44f6f
X-Rspamd-Queue-Id: 5419440009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771257832-459787
X-HE-Meta: U2FsdGVkX1+PGQaZjoEsJTmbjqpYGcVko9dmXyj/eH8ZeJtQUFSnLnZ1e19wbDpterIVotd7AmeV+BP/UozVr3xrjP0Uc8VHScGT/UHdFxeDTMpJ4ZSEogU1wypzGsGkyHYuYJj/D6YbSV7V2lNnJQAm88rCGC9psliThKikjR1oqLxbQXhPDX5dEQZMzatqJEWrDB/B17+LJc2VAhMGZLGB0d55W3VPC7OxpB0Y+ybXsb5T9Moq49wHNJrItzzEiMgSxOP7pvrhbFWGoO4c7DHcSdKCKyQN0OEib7L/UvX3zPlsUPaR2+Azdona0m2Gg1ElmpukvloCF7N+znHdgV7hfQ6mM9erhGiFFk2VPTsiyHwc0kLPrKPt8ryOac4yOR/Bb/Sk9yfeOzma/IjmeJYbBcvagDCC3boYrtiW4MTuFZ4n3pH843TPz2NRYbnub73inzHhFLDq4i/nqpNw7Msp+jzkk+9Wpl6v2RRr/Msp/aN86OTLuOjlueK6JkBbLas9y4cswUxkNi2o+WAsqF2ZnQrn4BgMwESrW23qs2JvM8UGVWS0iAPgaOyQK8nrRJVGzOXFX7CbjUNSXxnlMdtRlqwnYVuI7vL1r1G81QHVAEbGTUO/5kbWFaBdP+vj80vTLvtqHYIGqALOgdXEQV73g9XwcAioNFlLmwE2PaAgy5OsPXHkeP8KvxdcWLCFDlQSGlhTO7OENK/vN0Tw7xlGcTlkIKGZ02/3H6/zZaxDoUrSL3bxjHnRN2itvI/j8KKP52hU90iIRM2PQzJiGIcsA23K1yE0N8XOhBcU+7qFLKGSwdaKpKJVjO7p0X+ig3DKKhKf/CTqToo6ILWnQoti9l7wsIKLTT19JQG8TMScCHv4cITXUqBwvBRx6Jk9MoBx6ZyYJFe2Jv/iiwdWGETWHnf+QejnKshiFJ4sGwg3m+vSMg4tOJO2ydweOr8PynqGbjWA9H+bcDGljW6
 BJMXrMbn
 lmAgN3L0aVNhCcdcVpUTxuq7vYIzNXoB93KzOQtiHVyM+dw4kemAZfNT59Vt5GejOgTyVuzBEtjvkhVzPVUb8jRiqzH09Mg+CveaDHTMfNEa47a9AqFDxZTNiofAwEI/IzpkK617QWNzDY3s2dN2VpD2Qh3M5F/Oa4TQY7AgJoBJfixbi/e7ZGpbHYZRlHVkyfl5XkwmOH07K1EZLwVtygwuXp1d/Edr23J7m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 10:15:37 -0800 Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> The changes aims at adding additionnal tracepoints variables to help
> debuggers attribute them to specific processes.
> 
> The PID field uses in_task() to reliably detect when we're in process
> context and can safely access current->pid.  When not in process
> context (such as in interrupt or in an asynchronous RCU context), the
> field is set to -1 as a sentinel value.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
> ---
>  include/trace/events/vmscan.h | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 1212f6a7c223e..a68b712ef757a 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -122,18 +122,22 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  		__field(	unsigned long,	gfp_flags	)
>  		__field(	u64,	memcg_id	)
>  		__field(	int,	order		)
> +		__field(	int,	pid		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
>  		__entry->order		= order;
> +		__entry->pid		= current->pid;
>  		__entry->memcg_id	= mem_cgroup_id(memcg);
>  	),
>  
> -	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
> +	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%llu %s",
>  		__entry->order,
>  		show_gfp_flags(__entry->gfp_flags),
> -		__entry->memcg_id)
> +		__entry->pid,
> +		__entry->memcg_id,
> +		__event_in_irq() ? "(in-irq)" : "")
>  );
>  
>  DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
> @@ -168,16 +172,20 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
>  	TP_STRUCT__entry(
>  		__field(	unsigned long,	nr_reclaimed	)
>  		__field(	u64,	memcg_id	)
> +		__field(	int,	pid		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->nr_reclaimed	= nr_reclaimed;
>  		__entry->memcg_id	= mem_cgroup_id(memcg);
> +		__entry->pid		= current->pid;
>  	),
>  
> -	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
> +	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%llu %s",
>  		__entry->nr_reclaimed,
> -		__entry->memcg_id)
> +		__entry->pid,
> +		__entry->memcg_id,
> +		__event_in_irq() ? "(in-irq)" : "")
>  );
>  
>  DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
> @@ -220,9 +228,10 @@ TRACE_EVENT(mm_shrink_slab_start,
>  		__field(unsigned long, cache_items)
>  		__field(unsigned long long, delta)
>  		__field(unsigned long, total_scan)
> +		__field(u64, memcg_id)
>  		__field(int, priority)
>  		__field(int, nid)
> -		__field(u64, memcg_id)
> +		__field(int, pid)
>  	),
>  
>  	TP_fast_assign(
> @@ -236,19 +245,22 @@ TRACE_EVENT(mm_shrink_slab_start,
>  		__entry->priority = priority;
>  		__entry->nid = sc->nid;
>  		__entry->memcg_id = mem_cgroup_id(memcg);
> +		__entry->pid = current->pid;
>  	),
>  
> -	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
> +	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
>  		__entry->shrink,
>  		__entry->shr,
>  		__entry->nid,
> +		__entry->pid,
>  		__entry->memcg_id,
>  		__entry->nr_objects_to_shrink,
>  		show_gfp_flags(__entry->gfp_flags),
>  		__entry->cache_items,
>  		__entry->delta,
>  		__entry->total_scan,
> -		__entry->priority)
> +		__entry->priority,
> +		__event_in_irq() ? "(in-irq)" : "")
>  );
>  
>  TRACE_EVENT(mm_shrink_slab_end,
> @@ -266,29 +278,32 @@ TRACE_EVENT(mm_shrink_slab_end,
>  		__field(long, total_scan)
>  		__field(int, nid)
>  		__field(int, retval)
> +		__field(int, pid)
>  		__field(u64, memcg_id)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->shr = shr;
> -		__entry->shrink = shr->scan_objects;

__entry->shrink is removed here, but still printed below. Was this an intended
change of this commit?

>  		__entry->unused_scan = unused_scan_cnt;
>  		__entry->new_scan = new_scan_cnt;
>  		__entry->total_scan = total_scan;
>  		__entry->nid = nid;
>  		__entry->retval = shrinker_retval;
> +		__entry->pid = current->pid;
>  		__entry->memcg_id = mem_cgroup_id(memcg);
>  	),
>  
> -	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
> +	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
>  		__entry->shrink,
>  		__entry->shr,
>  		__entry->nid,
> +		__entry->pid,
>  		__entry->memcg_id,
>  		__entry->unused_scan,
>  		__entry->new_scan,
>  		__entry->total_scan,
> -		__entry->retval)
> +		__entry->retval,
> +		__event_in_irq() ? "(in-irq)" : "")
>  );
>  
>  TRACE_EVENT(mm_vmscan_lru_isolate,
> -- 
> 2.33.8
> 
> 

