Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34316CD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533A26B00BA; Tue,  9 Jun 2026 21:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AD26B00BB; Tue,  9 Jun 2026 21:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D0D6B00BC; Tue,  9 Jun 2026 21:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 331FA6B00BA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:21:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBF18C29D0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:21:19 +0000 (UTC)
X-FDA: 84862249878.06.1783E0A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4419A20008
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:21:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Lx5n6/+d";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azd4gYJ8VwEn2xnFPZe1dtA7NyI9LqyXIAgOAuiZywE=;
	b=Su6/G2GRV7Pi2RUHfF9PODbT70h2X+xtwsDDuCMk8+l9yq2frjXD3WDitcKYDNRoNKapBQ
	ZP9+nh+Zv6DwmsaUOT+ciiKO09CKdHddRQ3FFxBM4aPTVi5hBE7EKTra+/JTEi/VtGll0R
	dBGe33sYLunpfyBApnraZFTMF5OE0Zo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Lx5n6/+d";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054478;
	b=FitE1p1EJpTPrTlln65TFwS0scemZCcv4wVAjKCUGwFrrOyQ3Zqw/8qhw34ouckfee2HPQ
	OP/EqR4y6knQot2tegSJG02Wq+JOHzHkq+EJGpCfuNKVL8EN1tM9DcjMqkX8i+ESAhy0Sg
	H/pxgYeoOf5G9hiviLqTlOhCd0bAppI=
Date: Tue, 9 Jun 2026 18:21:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781054473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azd4gYJ8VwEn2xnFPZe1dtA7NyI9LqyXIAgOAuiZywE=;
	b=Lx5n6/+dbX6TSJvF8ziNSZj3YhshjgeYfUcQDJVS9dPCZZfET22G20+Pf/vqtgLrj9wPs5
	0YuheS0EQbx5JuKl5MpexDUnIWhLeb+pYnVWSVyVsa5IvT70EfyAvWwAYUmhIFjm4c2ZkT
	oIx9CMq63WH0TFjWB4/fgIf0qyWSzk8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	willy@infradead.org, usama.arif@linux.dev, akpm@linux-foundation.org, 
	vbabka@kernel.org, mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
Message-ID: <aii7WWFmAyoXn9rk@linux.dev>
References: <20260609041156.31127-1-jp.kobryn@linux.dev>
 <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
 <3e55e520-b979-4b1c-874c-3b4e5ca629e2@linux.dev>
 <d676cf78-4b0a-4d6b-b322-f64826aaca75@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d676cf78-4b0a-4d6b-b322-f64826aaca75@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4419A20008
X-Rspam-User: 
X-Stat-Signature: xkirne7bcwdgkbr74qtpc5zhsixca36a
X-Rspamd-Server: rspam09
X-HE-Tag: 1781054477-321432
X-HE-Meta: U2FsdGVkX1+9Q2OI09q7ADQCXdLkZnv7MF9GcBsN97WxKZtHY/oAHRBmE2rH3+01YY6DCfIr+PI66iNMV2asK6+SSrzPk0T/P96/jKOQQwDCIayc1G0GUVWgzraNP4MbHAorWF0kHT6Gf9/IGebNBjbOtUncXcbj3KQfFj7Aa5TBsZPJj8phK74NSka9cePqR9/fBwtoogq1jFgkc0CV36O1YALHXlkaUzkulxMP/TRJPsQtj8fSAA23Wqm6qSS+rlKZBzMjGKGq8YMuap9sFSfAbLjr5/9anSuvIK9pNpCzhqUtHHRMrPATHfWymqJK8PpJ5raxbU+LCU8TG6tXghbNeeoC5bmF2gF0rKRRuH8Yq1Nis8RS/g0UPc2BT5g50JrQh40UNL0TmctpjsSWZnnXigtx70+y1fZi+KYtox/38uk2hFEth5MZKW64HfwXE2/Ar5zZ7c1LrqXa08g2YZqT5TvRct1WzWMDyh0+iZiRdgYDJ6nhQ9kZLvTbFYl8CR4HVxw8qFbxOVTNQbIkginbca9Tn78pSu3xARRobGZjI8u0uufcDKyJS3H8tzZ8dGvsFQ31DMj/lb5x9VXFG8UiqlOEgm4p/64QR6vYtFGx6RUCCy/zSN9onEDVyJ94BMQecA6aiBPGckXiKIp2lCZBLh/MswGvI0I1NFQN91F7GqOzJgtouXPO74PQcliysLh2HVwuXrZIlh0ONgomvu83QjA5FgkonSaT9CdtJUUELwlWDNtEZTU9brxNho2147ElIoLCclGGc3G8ywQr+9NNW8ilaz7LEOajTpkUPhK66GULFX8pyxm/N4urslWiFcIktgtprONEebdaBohs3I+MzRHEfPZqyX0v0NrnIvy7j+5WcSTe1Du3kVysi3rJGGf32XW8G+XtMCp95yJhTaiElmxFjFkNw6hzMQascrrddGeTxS1yIdu34n9zqqZBUAwZ/LbI5OVQVVhcSUL
 F24Aq3wT
 b41pwO2/IbZtGrXbv7gFfKNd1gGke46VzSrYkoFoW0Vb2Xg0Z3k6LOnIObsANYXS0oyhIagL8aFi8g3tgNyAsk79Bs9O3Q82emNKIsQRC7C2D3DzfkIM7T/d7BQKxcJTc7ZyKJkl3FVsVb/Yu7uOGHYq/EPE38xlWNls+hf7Qz8+bciylDRPqkBSEh6/7trOjCg1GwTYR4+SC4Am78a4Bf8PlNnYC9c3TsiYrIQqwaSxRwp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:16:15PM -0700, JP Kobryn wrote:
> On 6/9/26 5:07 PM, JP Kobryn wrote:
> > On 6/9/26 12:44 AM, Barry Song wrote:
> >> On Tue, Jun 9, 2026 at 12:12 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
> >>>
> >>> LRU add batches can be drained before they reach capacity. This can be a
> >>> source of LRU lock contention, but it is not currently possible to
> >>> attribute these drains to callers with existing tracepoints.
> >>>
> >>> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
> >>> lru_add batch is drained. This allows tracing to distinguish full drains
> >>> from partial drains and attribute them to the calling stack.
> >>>
> >>> Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
> >>> per-CPU drain work. This captures the requester stack and target CPU for
> >>> remote drain work. The event is named as a drain-all queue event because
> >>> the queued work can be needed for batches other than lru_add.
> >>>
> >>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> >>> ---
> >>>  include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
> >>>  mm/swap.c                      |  6 ++++-
> >>>  2 files changed, 45 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
> >>> index 171524d3526d..ea8fc46bedb0 100644
> >>> --- a/include/trace/events/pagemap.h
> >>> +++ b/include/trace/events/pagemap.h
> >>> @@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
> >>>         TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
> >>>  );
> >>>
> >>> +TRACE_EVENT(mm_lru_add_drain,
> >>> +
> >>> +       TP_PROTO(int cpu, unsigned int nr),
> >>> +
> >>> +       TP_ARGS(cpu, nr),
> >>> +
> >>> +       TP_STRUCT__entry(
> >>> +               __field(int,            cpu     )
> >>> +               __field(unsigned int,   nr      )
> >>> +       ),
> >>> +
> >>> +       TP_fast_assign(
> >>> +               __entry->cpu    = cpu;
> >>> +               __entry->nr     = nr;
> >>> +       ),
> >>> +
> >>> +       TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
> >>> +);
> >>> +
> >>> +TRACE_EVENT(mm_lru_drain_all_queue,
> >>> +
> >>> +       TP_PROTO(int target_cpu, bool force_all_cpus),
> >>> +
> >>> +       TP_ARGS(target_cpu, force_all_cpus),
> >>> +
> >>> +       TP_STRUCT__entry(
> >>> +               __field(int,    target_cpu      )
> >>> +               __field(bool,   force_all_cpus  )
> >>> +       ),
> >>> +
> >>> +       TP_fast_assign(
> >>> +               __entry->target_cpu     = target_cpu;
> >>> +               __entry->force_all_cpus = force_all_cpus;
> >>> +       ),
> >>> +
> >>> +       TP_printk("target_cpu=%d force_all_cpus=%s",
> >>> +               __entry->target_cpu,
> >>> +               __entry->force_all_cpus ? "true" : "false")
> >>> +);
> >>> +
> >>>  #endif /* _TRACE_PAGEMAP_H */
> >>>
> >>>  /* This part must be outside protection */
> >>> diff --git a/mm/swap.c b/mm/swap.c
> >>> index 588f50d8f1a8..c385b93582eb 100644
> >>> --- a/mm/swap.c
> >>> +++ b/mm/swap.c
> >>> @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
> >>>  {
> >>>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> >>>         struct folio_batch *fbatch = &fbatches->lru_add;
> >>> +       unsigned int nr_folios_add = folio_batch_count(fbatch);
> >>>
> >>> -       if (folio_batch_count(fbatch))
> >>> +       if (nr_folios_add) {
> >>>                 folio_batch_move_lru(fbatch, lru_add);
> >>> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
> >>> +       }
> >>>
> >>>         fbatch = &fbatches->lru_move_tail;
> >>>         /* Disabling interrupts below acts as a compiler barrier. */
> >>> @@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
> >>>                 if (cpu_needs_drain(cpu)) {
> >>>                         INIT_WORK(work, lru_add_drain_per_cpu);
> >>>                         queue_work_on(cpu, mm_percpu_wq, work);
> >>> +                       trace_mm_lru_drain_all_queue(cpu, force_all_cpus);
> >>
> >> Do you need tracing on each CPU individually, or is tracing the
> >> entire __lru_add_drain_all() invocation sufficient?
> > 
> > I think the latter would be fine. The remote work will invoke the
> > mm_lru_add_drain tracepoint, which will show up as kworker stacks. Since
> > the event already has the CPU, we could see where queued drains actually
> > ran.
> 
> Actually if it's just a single invocation and the only event data is the
> force flag, a tracepoint may not even be needed. Other probes can be
> installed on function invocation and read the single argument. I can
> drop this from v2 and keep the single mm_lru_add_drain tracepoint.

No we do want to trace the callers requesting to drain from all the CPUs. If you
trace just lru_add_drain_cpu() then you will only see that the drain is
requested for a given CPU but no information on the requester. 

Also as Barry said, I think single trace for whole __lru_add_drain_all() is good
enough.

