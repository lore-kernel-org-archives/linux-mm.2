Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69EA0CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 18:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4EA6B0005; Wed, 10 Jun 2026 14:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5726B0088; Wed, 10 Jun 2026 14:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB5F6B008C; Wed, 10 Jun 2026 14:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1626B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:55:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07A9F1A02A7
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:55:06 +0000 (UTC)
X-FDA: 84864905412.06.ECD287A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5961A18000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:55:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fVrOYUWX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781117704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfF9RI+iBUohFlyVvEs6LdGT+K29EajhjVSojF8K/mI=;
	b=qiOGlqw3kiNQlAIJ/YGsqQ5I6oepysdlel2MsnrVxMQeHxQW2ZdRYDB+/0fwSDmeU1FahN
	4Kr8m5cXOve8OAGhk7YraWx/Z00T8NeJoTGxXDNM81XXpjBJH3lysWv5JJyy1gmA+qD3At
	sbQNkDXrs9dgSGOaG16y6AVnys2CFmo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fVrOYUWX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781117704;
	b=mBe9nfUk4fC//aQ4I2Ql0mKvTx+lYFJ8esxzbSbnTbHSIeHPAkuasqyam1+OXNnfIgu3Vt
	1hEIuCydYYj1+6wjlTXJBOYH7rm7qlIzJOn+ZjNOAtJAxBYBvITTnaLFJTjGf1tlsu2qYq
	kD3JkNw13VqIzbN6ClySnpCS4/KiaiU=
Message-ID: <6e7739cc-327e-4ca9-86f4-17729b624632@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781117700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lfF9RI+iBUohFlyVvEs6LdGT+K29EajhjVSojF8K/mI=;
	b=fVrOYUWXUVlrBfNXAhQTMoDvIZnpoFcfZw/N8kWM0UJhwbqwCvWHOnUH1GLRd2XFk31Y0D
	KtRzgsYUb3TtLR/EB8DOAy1PmMrLVX3hhZvyMYh6/dqUzPFbcFDSxTf5bLh8gVeC1R9O1L
	PJzAfMQ2NGHxaWsC2vwPLS0Sq6pUnPg=
Date: Wed, 10 Jun 2026 11:54:52 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>, linux-mm@kvack.org, willy@infradead.org,
 usama.arif@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org,
 mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260609041156.31127-1-jp.kobryn@linux.dev>
 <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
 <3e55e520-b979-4b1c-874c-3b4e5ca629e2@linux.dev>
 <d676cf78-4b0a-4d6b-b322-f64826aaca75@linux.dev> <aii7WWFmAyoXn9rk@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <aii7WWFmAyoXn9rk@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5961A18000C
X-Rspam-User: 
X-Stat-Signature: 5t5ftfw3imn6ku3njbxoh6ukh85no54p
X-Rspamd-Server: rspam09
X-HE-Tag: 1781117702-494001
X-HE-Meta: U2FsdGVkX1+9TUJKmvubSF3foexIjDGRMm/3nyXQaHGwIQOJD+DU2frb6Ai0oAecxtbR1oV1AjBrq/HsZX257ZZpGiFt4dlnDOI5V42XXDqmyUmHSP3jZLrmM5FG48c2A6mZh1bZEVDqBk+SgH/H3wzbHpPPcn7ZE1mfIoj0hcX2BvQHSzQhSw88xjs4QRh65jKpQYJgaTc6VLA0DPGPgNXGj775vSKY0BL4BKUcalpZpcldw82d63GPiINwGVeoyMsA6GlZcplHCHQh9/RpWpnkbV+F8JetXzkmfbc8O7Foyylu6/2Umg4cBTUcd/lK5K185QnEGcny0gjRSngNmD1J2D/ipJy1JKeqc915u344BVrH6cboAw2pxT+1FtPIfJ5RlmRNip0mq1Oqb99cUEeeW0IgoBF8GX4e24GU5fQP2/vY6sh+RpI7cGvJeBV8bq+s4eZ+HarobDaiNJ1LFOqDOm+ajgcu3zJH678bU9gC/ikmRH4IzqzMaZQBaMIgbyicTnfq7Yi1lGfh2GmsMvyWGcO3HT0MxjPg4X/J01hRtH04tP3zb++JJiBeQvzMmI6ZsB4bkekYinGt20CXxO/w5F7Fv02DCUXXe5/W8mBQKu8IfX+Ac3sko/EJEmhDUBKO3rZcjzhnnDRllbCDSjPhVoMziSTO88sOLEk4AqDUlPN7StTwynOJYLsrkRxAyi4Ecrga3Ws1XJw+wS48qBK23sEIWDMGB+GTtI0gmW55NnBboW9lzUgskxDO8R9eagmMzKyFJQo6t9Xfc5RGwm6Vc3YhHHjTRCZ7861c9nbrTSsrC5Ai2xBW087n/RGvBj4gh40gI6Dp9O1C9nBrBXfYoL1ipAn4ugRBQcy7IGCVs0ijs8L9l2ga0E+jcgCWqRtmTDFctKxOnhe1KDmZ8iLVDXl4133k9LbMQEzd9BvjvJwpaWxvb+7wR638zlU4zLuH8NxXqmBYWeODA6D
 ggr2BSIW
 fuyDmKA+nMc1EJT6dLRdpQ3NgauqRnboqALnVpi+lOG8BPnb4w2R63tr4JgXtBh6aEFzcUpCBVymyJxebSKSz8SRvhHYx84QA8x9opEK5qaefxJepwu10J8M5lQKsLhDf8oVdDx7Ff62UPGyUiyuJhip+0AACeG231B/IMuQv3r5/IZh9ho0wPw+Ss+sdU2QA+gcitkwlzzZPutA9Wm5ltawLoO2ey67Q7YpVbmKdWD903ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 6:21 PM, Shakeel Butt wrote:
> On Tue, Jun 09, 2026 at 05:16:15PM -0700, JP Kobryn wrote:
>> On 6/9/26 5:07 PM, JP Kobryn wrote:
>>> On 6/9/26 12:44 AM, Barry Song wrote:
>>>> On Tue, Jun 9, 2026 at 12:12 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
>>>>>
>>>>> LRU add batches can be drained before they reach capacity. This can be a
>>>>> source of LRU lock contention, but it is not currently possible to
>>>>> attribute these drains to callers with existing tracepoints.
>>>>>
>>>>> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
>>>>> lru_add batch is drained. This allows tracing to distinguish full drains
>>>>> from partial drains and attribute them to the calling stack.
>>>>>
>>>>> Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
>>>>> per-CPU drain work. This captures the requester stack and target CPU for
>>>>> remote drain work. The event is named as a drain-all queue event because
>>>>> the queued work can be needed for batches other than lru_add.
>>>>>
>>>>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>>>>> ---
>>>>>  include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
>>>>>  mm/swap.c                      |  6 ++++-
>>>>>  2 files changed, 45 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
>>>>> index 171524d3526d..ea8fc46bedb0 100644
>>>>> --- a/include/trace/events/pagemap.h
>>>>> +++ b/include/trace/events/pagemap.h
>>>>> @@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
>>>>>         TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
>>>>>  );
>>>>>
>>>>> +TRACE_EVENT(mm_lru_add_drain,
>>>>> +
>>>>> +       TP_PROTO(int cpu, unsigned int nr),
>>>>> +
>>>>> +       TP_ARGS(cpu, nr),
>>>>> +
>>>>> +       TP_STRUCT__entry(
>>>>> +               __field(int,            cpu     )
>>>>> +               __field(unsigned int,   nr      )
>>>>> +       ),
>>>>> +
>>>>> +       TP_fast_assign(
>>>>> +               __entry->cpu    = cpu;
>>>>> +               __entry->nr     = nr;
>>>>> +       ),
>>>>> +
>>>>> +       TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
>>>>> +);
>>>>> +
>>>>> +TRACE_EVENT(mm_lru_drain_all_queue,
>>>>> +
>>>>> +       TP_PROTO(int target_cpu, bool force_all_cpus),
>>>>> +
>>>>> +       TP_ARGS(target_cpu, force_all_cpus),
>>>>> +
>>>>> +       TP_STRUCT__entry(
>>>>> +               __field(int,    target_cpu      )
>>>>> +               __field(bool,   force_all_cpus  )
>>>>> +       ),
>>>>> +
>>>>> +       TP_fast_assign(
>>>>> +               __entry->target_cpu     = target_cpu;
>>>>> +               __entry->force_all_cpus = force_all_cpus;
>>>>> +       ),
>>>>> +
>>>>> +       TP_printk("target_cpu=%d force_all_cpus=%s",
>>>>> +               __entry->target_cpu,
>>>>> +               __entry->force_all_cpus ? "true" : "false")
>>>>> +);
>>>>> +
>>>>>  #endif /* _TRACE_PAGEMAP_H */
>>>>>
>>>>>  /* This part must be outside protection */
>>>>> diff --git a/mm/swap.c b/mm/swap.c
>>>>> index 588f50d8f1a8..c385b93582eb 100644
>>>>> --- a/mm/swap.c
>>>>> +++ b/mm/swap.c
>>>>> @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
>>>>>  {
>>>>>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>>>>>         struct folio_batch *fbatch = &fbatches->lru_add;
>>>>> +       unsigned int nr_folios_add = folio_batch_count(fbatch);
>>>>>
>>>>> -       if (folio_batch_count(fbatch))
>>>>> +       if (nr_folios_add) {
>>>>>                 folio_batch_move_lru(fbatch, lru_add);
>>>>> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
>>>>> +       }
>>>>>
>>>>>         fbatch = &fbatches->lru_move_tail;
>>>>>         /* Disabling interrupts below acts as a compiler barrier. */
>>>>> @@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
>>>>>                 if (cpu_needs_drain(cpu)) {
>>>>>                         INIT_WORK(work, lru_add_drain_per_cpu);
>>>>>                         queue_work_on(cpu, mm_percpu_wq, work);
>>>>> +                       trace_mm_lru_drain_all_queue(cpu, force_all_cpus);
>>>>
>>>> Do you need tracing on each CPU individually, or is tracing the
>>>> entire __lru_add_drain_all() invocation sufficient?
>>>
>>> I think the latter would be fine. The remote work will invoke the
>>> mm_lru_add_drain tracepoint, which will show up as kworker stacks. Since
>>> the event already has the CPU, we could see where queued drains actually
>>> ran.
>>
>> Actually if it's just a single invocation and the only event data is the
>> force flag, a tracepoint may not even be needed. Other probes can be
>> installed on function invocation and read the single argument. I can
>> drop this from v2 and keep the single mm_lru_add_drain tracepoint.
> 
> No we do want to trace the callers requesting to drain from all the CPUs. If you
> trace just lru_add_drain_cpu() then you will only see that the drain is
> requested for a given CPU but no information on the requester. 
> 
> Also as Barry said, I think single trace for whole __lru_add_drain_all() is good
> enough.

Right, but couldn't that already be done with fentry or kprobe? If we
only need the calling stack and the argument value of force_all_cpus I
don't see a strong need for a dedicated tracepoint.

