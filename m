Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94452CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0404D6B00A6; Tue,  9 Jun 2026 20:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018056B00A7; Tue,  9 Jun 2026 20:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96F96B00A8; Tue,  9 Jun 2026 20:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC72F6B00A6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:16:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F6011C2726
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:16:31 +0000 (UTC)
X-FDA: 84862086582.18.3A8C7F0
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id E4A6220003
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:16:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N9AMYlrX;
	spf=pass (imf03.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzAEXk5KPclAfgMQutz0DumixpunNsLKg76V7zToonI=;
	b=R212hVyDpKlrjxVTTVJOxW/qtzW6+Gf7mML6Z1hxUWithJ9wXyciwdRMpzmb4+3qf2Ervz
	6aR3EbNv4TTJ2YrK7p6FN6Njcyj6Hi9nWl9nGgGSjZC/Ezb32M1w9LpM2+qz7b4sJPZTfP
	Ny4JsI0YWoUePOAoSvXwbmaTgZqeqv0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N9AMYlrX;
	spf=pass (imf03.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050590;
	b=7tjZI+eyPXGOpYpUDjIZuoLZ3gUm6bhYJJTK2ChCwJj+DZKOj/u2/p1bCkOeOHBloWoa8S
	2JLlizs2TCszzgHu+dtMXHjg5gu5UYiK9d0Axg34ZpcSE95uUhJeA36msH0QYH+LuaVBWh
	rgPnG70u32KXEFtp9irHkJpP8blA7ec=
Message-ID: <d676cf78-4b0a-4d6b-b322-f64826aaca75@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781050586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CzAEXk5KPclAfgMQutz0DumixpunNsLKg76V7zToonI=;
	b=N9AMYlrXIzwyumzQyTktM8h0i2p/fp9gGlSYYjTuCcWTo0CU4e3r5Tz0uYM9RIo4S+s1oI
	GlvvisRrUGs11EEmukx64OEAofPGvmS6m2gNCdWqQnpAtVS41aHrLJo6/PjatMbFct5p+a
	tVN1NPWTWUFVqj0vu+4gkubpRzuFVMw=
Date: Tue, 9 Jun 2026 17:16:15 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
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
 <3e55e520-b979-4b1c-874c-3b4e5ca629e2@linux.dev>
Content-Language: en-US
In-Reply-To: <3e55e520-b979-4b1c-874c-3b4e5ca629e2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E4A6220003
X-Stat-Signature: zng8yohxw9i66k8sopgk1re8pma4u5jh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781050587-452612
X-HE-Meta: U2FsdGVkX1/qYtYUyuMY+v1g6zBjAcROv4DgraDCQh6iLnqHjzaqJ03t+GTA0dlCHkAEUZdQvfbPwOBAXqdv4LlD+xzd0QDEEUhSISEt/bEYzdWhP5TzpM5/muqq4N4uENgYvHI2wnbs6Qqob/pjjVuWntGz3ATftVz1T9hZfBJFAkVd1UDuNI2kH12+ZQSd3mTRLpB/m31j7pi/bLjcKDvUsOlT3X6xMyrszgmmQW930/TjM15cEdzOL1a/2/0JkKdGY3a+a6Fb5YgKE4wOUrCfjUCii1jGdgJpjzo9rqtJCEm7NaCatdOaB+e8NwOzGPTmj3HPsSPNfxtMEm6w5Oz2THSBxCeP+55ws9QxGVEzAWg0B+t4eOoZ27tpbVrPCMgcmvBpyLyCd6m60Fqgi/SUYU1Hr0IXLTGDPYthKm/GIcOtGkOhVhKik1Gq+xxspjA4OC1hUAmYW2TIzK+WurKVHeaAlfEUfkXvWorBxmXYTpp0Oy4b3dlG3uSelKpAKzyzvTRML8zpyfIr5T7hEUo1Q3/uFLskbFng6a8B7ssSgrfOBao+a5NdnCvz4SrWI/118L0cXrjTC7ee8rriixA9wckdyZF2x0sJ9oWT9C9wnskRtG2XPSfrZKe0y+phA3VbtBk83EHXkAZAOPbLAIp+ZGJAM9OeJCq3pulZvT88aKA9LTuvXBozjWKmQWYuHfGa9ZnDE2IO+GLZl1HcJNdmx6w8ToSs27MoxID3QGi6ngNR/EzwoogjKbMzSlkDIfAZ52JdaLUo8mO7YHxKuZWJJ8eauU5q9L3ZQ240bJy8hihyu+j2rQKo/iNoArW1+pkJQLzy9PJEUFp0CPOBTV0g5zeJmvcU3NUZDloSb+uvig7ulRtsFrT81e4xDeZh8lPO+zUJG2gvoR95/1GHRYcXFo72I9zlEaoxHDqNMAuHL3Atl3kBlY26Oe3clykmXqW/Spn4283+jJSI65e
 Y9a1bHoZ
 m517TpDYHevI20syyi+RKTSgOnR1g/wpzwfm+Yl6pJN0JB6YCjSRv4mZNxq64GsAgiTO//EDY+XMTm/3huQ+Znap7U8/TCFPpzYtv1NZcueCEOC2yJ9MKSAz3yBlKddo2HbBgdyM7fl4oBKauXp0BaXh6y5//rxR7Z0Yln421huNLQlk8Mk1P+bjHnCrg/GZ2FmO4qgBwZQtR9qKCUOf/atVqjYdcd+k3G6kjH9hccjnGTPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 5:07 PM, JP Kobryn wrote:
> On 6/9/26 12:44 AM, Barry Song wrote:
>> On Tue, Jun 9, 2026 at 12:12 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
>>>
>>> LRU add batches can be drained before they reach capacity. This can be a
>>> source of LRU lock contention, but it is not currently possible to
>>> attribute these drains to callers with existing tracepoints.
>>>
>>> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
>>> lru_add batch is drained. This allows tracing to distinguish full drains
>>> from partial drains and attribute them to the calling stack.
>>>
>>> Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
>>> per-CPU drain work. This captures the requester stack and target CPU for
>>> remote drain work. The event is named as a drain-all queue event because
>>> the queued work can be needed for batches other than lru_add.
>>>
>>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>>> ---
>>>  include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
>>>  mm/swap.c                      |  6 ++++-
>>>  2 files changed, 45 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
>>> index 171524d3526d..ea8fc46bedb0 100644
>>> --- a/include/trace/events/pagemap.h
>>> +++ b/include/trace/events/pagemap.h
>>> @@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
>>>         TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
>>>  );
>>>
>>> +TRACE_EVENT(mm_lru_add_drain,
>>> +
>>> +       TP_PROTO(int cpu, unsigned int nr),
>>> +
>>> +       TP_ARGS(cpu, nr),
>>> +
>>> +       TP_STRUCT__entry(
>>> +               __field(int,            cpu     )
>>> +               __field(unsigned int,   nr      )
>>> +       ),
>>> +
>>> +       TP_fast_assign(
>>> +               __entry->cpu    = cpu;
>>> +               __entry->nr     = nr;
>>> +       ),
>>> +
>>> +       TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
>>> +);
>>> +
>>> +TRACE_EVENT(mm_lru_drain_all_queue,
>>> +
>>> +       TP_PROTO(int target_cpu, bool force_all_cpus),
>>> +
>>> +       TP_ARGS(target_cpu, force_all_cpus),
>>> +
>>> +       TP_STRUCT__entry(
>>> +               __field(int,    target_cpu      )
>>> +               __field(bool,   force_all_cpus  )
>>> +       ),
>>> +
>>> +       TP_fast_assign(
>>> +               __entry->target_cpu     = target_cpu;
>>> +               __entry->force_all_cpus = force_all_cpus;
>>> +       ),
>>> +
>>> +       TP_printk("target_cpu=%d force_all_cpus=%s",
>>> +               __entry->target_cpu,
>>> +               __entry->force_all_cpus ? "true" : "false")
>>> +);
>>> +
>>>  #endif /* _TRACE_PAGEMAP_H */
>>>
>>>  /* This part must be outside protection */
>>> diff --git a/mm/swap.c b/mm/swap.c
>>> index 588f50d8f1a8..c385b93582eb 100644
>>> --- a/mm/swap.c
>>> +++ b/mm/swap.c
>>> @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
>>>  {
>>>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>>>         struct folio_batch *fbatch = &fbatches->lru_add;
>>> +       unsigned int nr_folios_add = folio_batch_count(fbatch);
>>>
>>> -       if (folio_batch_count(fbatch))
>>> +       if (nr_folios_add) {
>>>                 folio_batch_move_lru(fbatch, lru_add);
>>> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
>>> +       }
>>>
>>>         fbatch = &fbatches->lru_move_tail;
>>>         /* Disabling interrupts below acts as a compiler barrier. */
>>> @@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
>>>                 if (cpu_needs_drain(cpu)) {
>>>                         INIT_WORK(work, lru_add_drain_per_cpu);
>>>                         queue_work_on(cpu, mm_percpu_wq, work);
>>> +                       trace_mm_lru_drain_all_queue(cpu, force_all_cpus);
>>
>> Do you need tracing on each CPU individually, or is tracing the
>> entire __lru_add_drain_all() invocation sufficient?
> 
> I think the latter would be fine. The remote work will invoke the
> mm_lru_add_drain tracepoint, which will show up as kworker stacks. Since
> the event already has the CPU, we could see where queued drains actually
> ran.

Actually if it's just a single invocation and the only event data is the
force flag, a tracepoint may not even be needed. Other probes can be
installed on function invocation and read the single argument. I can
drop this from v2 and keep the single mm_lru_add_drain tracepoint.

