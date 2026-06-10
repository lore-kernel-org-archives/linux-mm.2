Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F6DCD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95AB76B0092; Tue,  9 Jun 2026 20:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BEE6B0093; Tue,  9 Jun 2026 20:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA606B0095; Tue,  9 Jun 2026 20:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3386B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:07:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39D821C2EB9
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:07:16 +0000 (UTC)
X-FDA: 84862063272.20.F3056FC
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 40D831A000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:07:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PvKUzKJl;
	spf=pass (imf19.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050034;
	b=SVQb4QF3DJAOJuNxUBqPNWv5VOAt6BuSm3Poz0Y58hsaCmATKkkKwarn1i6BWKDC+DG72e
	tctmryxbu8plstXZGjRKrwRseHPd7dLoP6srpU88CZSrtr31QmbgxvkPgCDE2HuafFw8He
	5UOVWM98Wy3nfy2iRUEEVSWh6rbaLVM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PvKUzKJl;
	spf=pass (imf19.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwJzDDAOSFuZjBaB9TmeW/QSyG/8wM8MFjZ03MHUWhU=;
	b=yKq7Ph1eUfkbNqLWSyLlbvOQ58Lb3VHApBdxtEtKRsGUor7iYJMIsjPLAjARxBGx7SqJj1
	3oMrjr/s3Tb8ZY9RUXK7n62HiBKWhNlN3BDvhbPhYHQmLOhoCjaDe6XTkXUSBXXKawMiDr
	cmky0SNYw7Fa/UA9JfZZLJBSmT8Cnpo=
Message-ID: <3e55e520-b979-4b1c-874c-3b4e5ca629e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781050028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AwJzDDAOSFuZjBaB9TmeW/QSyG/8wM8MFjZ03MHUWhU=;
	b=PvKUzKJleDOKAW/fMSWZhcpCF9sreXbb/V2RKVKUALR0+9bhdUr9iSvrWc0vi/1DLR5ma5
	l9dpIr39/jwnd2ZZ0anZNd+dHr1WXt/qr3I7YU1mj5BjZq+S+A9a0x7D0WPBYIzYiRqpqN
	+SgFOhvwGk5oxb5woyrW62JDeMXcomo=
Date: Tue, 9 Jun 2026 17:07:00 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, willy@infradead.org, shakeel.butt@linux.dev,
 usama.arif@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org,
 mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260609041156.31127-1-jp.kobryn@linux.dev>
 <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40D831A000D
X-Rspam-User: 
X-Stat-Signature: s1uaf5x4y76y6wgao8n4goxhfjpjmq18
X-HE-Tag: 1781050032-427570
X-HE-Meta: U2FsdGVkX1+EztwReUy5sEQb9Hqx2JZ3cuqCT5q8bI3VocFFkRGnIAsgNUlCxZR6R1vEU8Ot2j/C522Zm/nWaNQMF4W+PXbCwiHrm2Ihu4D16vRT8v6zJUTsDDkM3fwQ7Ot+F5JYYLW8+y2ofORz2sX9TJTNo6fJCTYwlF5SVAepWxO6p50WKdHSrIcZr7ep4gr9PED6y4xjVh25THN2UAVYtSx4fzQByIrUWITvt8euFjM1774mZp76B8mMM9vneU8bC4j5EFKWs7Vds2sYS9lLoZUmAFa6rqVQ9XWCCG3ltefe5Y8daXWIYdXffcMXPvMQJkgKS6wzt7Mpc8zh6nSFSv9HnYupxYBhyvhcSoN9IgVDx2cJolT18uSfYAFeko917u3rUHp8osgk+RKig3BsONwma92osu2zAolUceiVu/iGHsjTw3KVM7Im8gMMg6Fl9e/mEEnmOS4JHmrIwLtb4KiJQYVPsg4WxywQpAaIq9Y09SgNoYjeZMcR+HO+xicniBZzBtRhNC2wIq0YViK+6+/PAI2H+4DCDX+Kv1rgp7PFoiDT9OKsq9sGCsM9dxFWOUyTKjhgXBjaMRxhW5f/lbSphQQpBmQsYXydQjjsj4PlvUl/tuHyiaV+TWAbdUPb2Jwq+P/TmtN6y5JJgiL7Z/fVawUpXyUF4bcQ6dksEjk5BU5GgnFP6wKl0AJra8Qcb9/g6vhd6F4jxMjb59QuhbC5NRCiBPTRjsSdqkB4I7Tqg8bJ/WJ2sHF/KWei/NqebMhuGRPmCcMxsEpxYOB5HHeAxR8OeHzi8Tdoz+5Z9JufDg+A4wwtaRHaSma2wDwbeQKT0agw7Ya7U7u64jTzZat+5ZFWWaqdBkwbe0c4wRHRjah9VRne3AlUBGBUw99TIS+dihYgwntCoflneqt/n6bV+bD3pUDzbqhNQsyLDKkpt+EwmZTwmgEJ7fkESTtpRPHdJwt2EudPk19
 rpeHiMbc
 q/zuWIiYPx1ffoJ6TQ6xYzcpMXLrXGUfOKxN/hFDem4+cxQJeEeNRrQVj4/0Bo6MusYcmA9HeHn6DKawcAKgBmJ5w1kxCmCXGguBkISuKyu+2LFMW5DB6pDBtvxYZnmji8xdMcHGoDxg0lzCtBCRoM7emAu3MF50jtC1I59j2Fvd9vshOEynjVPLwMpMKENRQpsKV1kWJhNUFqRhA/DcwF5isl8oLmkzU/duUDrqk8KfEq/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 12:44 AM, Barry Song wrote:
> On Tue, Jun 9, 2026 at 12:12 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
>>
>> LRU add batches can be drained before they reach capacity. This can be a
>> source of LRU lock contention, but it is not currently possible to
>> attribute these drains to callers with existing tracepoints.
>>
>> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
>> lru_add batch is drained. This allows tracing to distinguish full drains
>> from partial drains and attribute them to the calling stack.
>>
>> Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
>> per-CPU drain work. This captures the requester stack and target CPU for
>> remote drain work. The event is named as a drain-all queue event because
>> the queued work can be needed for batches other than lru_add.
>>
>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>> ---
>>  include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
>>  mm/swap.c                      |  6 ++++-
>>  2 files changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
>> index 171524d3526d..ea8fc46bedb0 100644
>> --- a/include/trace/events/pagemap.h
>> +++ b/include/trace/events/pagemap.h
>> @@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
>>         TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
>>  );
>>
>> +TRACE_EVENT(mm_lru_add_drain,
>> +
>> +       TP_PROTO(int cpu, unsigned int nr),
>> +
>> +       TP_ARGS(cpu, nr),
>> +
>> +       TP_STRUCT__entry(
>> +               __field(int,            cpu     )
>> +               __field(unsigned int,   nr      )
>> +       ),
>> +
>> +       TP_fast_assign(
>> +               __entry->cpu    = cpu;
>> +               __entry->nr     = nr;
>> +       ),
>> +
>> +       TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
>> +);
>> +
>> +TRACE_EVENT(mm_lru_drain_all_queue,
>> +
>> +       TP_PROTO(int target_cpu, bool force_all_cpus),
>> +
>> +       TP_ARGS(target_cpu, force_all_cpus),
>> +
>> +       TP_STRUCT__entry(
>> +               __field(int,    target_cpu      )
>> +               __field(bool,   force_all_cpus  )
>> +       ),
>> +
>> +       TP_fast_assign(
>> +               __entry->target_cpu     = target_cpu;
>> +               __entry->force_all_cpus = force_all_cpus;
>> +       ),
>> +
>> +       TP_printk("target_cpu=%d force_all_cpus=%s",
>> +               __entry->target_cpu,
>> +               __entry->force_all_cpus ? "true" : "false")
>> +);
>> +
>>  #endif /* _TRACE_PAGEMAP_H */
>>
>>  /* This part must be outside protection */
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 588f50d8f1a8..c385b93582eb 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
>>  {
>>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>>         struct folio_batch *fbatch = &fbatches->lru_add;
>> +       unsigned int nr_folios_add = folio_batch_count(fbatch);
>>
>> -       if (folio_batch_count(fbatch))
>> +       if (nr_folios_add) {
>>                 folio_batch_move_lru(fbatch, lru_add);
>> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
>> +       }
>>
>>         fbatch = &fbatches->lru_move_tail;
>>         /* Disabling interrupts below acts as a compiler barrier. */
>> @@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
>>                 if (cpu_needs_drain(cpu)) {
>>                         INIT_WORK(work, lru_add_drain_per_cpu);
>>                         queue_work_on(cpu, mm_percpu_wq, work);
>> +                       trace_mm_lru_drain_all_queue(cpu, force_all_cpus);
> 
> Do you need tracing on each CPU individually, or is tracing the
> entire __lru_add_drain_all() invocation sufficient?

I think the latter would be fine. The remote work will invoke the
mm_lru_add_drain tracepoint, which will show up as kworker stacks. Since
the event already has the CPU, we could see where queued drains actually
ran.

> 
> Do you also need this_gen and lru_drain_gen to be traced?

As trace parameters, I don't think they give meaningful info on who is
making requests to drain all. But since I'm going to move the trace call
from within the CPU loop to earlier in the function we can still see
requestors even if the function exits early because a parallel drain
generation already satisfied the request.

> 
> By the way, I'm not sure drain_all_queue is the best name here.
> Why not simply use add_drain_all()? It would match the existing
> function name better.

The new tracepoint name can be mm_lru_add_drain_all.


