Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE08CD98CC
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 19:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BD26B008C; Wed, 10 Jun 2026 15:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373566B0092; Wed, 10 Jun 2026 15:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B06C6B0093; Wed, 10 Jun 2026 15:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA916B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:20:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B05241A02B8
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:20:33 +0000 (UTC)
X-FDA: 84864969546.08.1D3B74A
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4FD26180014
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:20:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J9HpL/4+";
	spf=pass (imf16.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781119232;
	b=HlLJ17Qu0GBD4HbJ7dS6eOCi6GXPABlWjzhvUK9mOOF+lSSuxNbIGRf6/VUtcOWgYDEKa/
	tT05irvleOmzzfhPrffs+C64sA3nQ6q30YkLxYNI3PecHTrmBJ03+1hD33wGyQ4f2kIfav
	6JnA6sP4CMFVFzUMZj/92NnEMm7AAbk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J9HpL/4+";
	spf=pass (imf16.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781119232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWcyqlFHr5mEY42mMiFua4E/gMz+s/X2vILeDjuLg30=;
	b=ybUSybjHXmSQ/AZWxqXCOrwSjkLUi8YsFJIOdvbWP7YNka6xkT1UwBg/q9AN55tjhpRjlY
	qpHbG7eaXQfoRrpWZRq1si65FwlPVLYO2CnNUmbRyo1bLHCgtrhSUExLQSpyF5D1tPx2Gl
	XjL8EzKT5FLMI+cy/nlXmpSsiPeEjqQ=
Message-ID: <ffdf9b07-487b-4668-a91b-27b0ab29c70d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781119226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWcyqlFHr5mEY42mMiFua4E/gMz+s/X2vILeDjuLg30=;
	b=J9HpL/4+E3jEKvbtYmDAMJUgYViuJPtNed4QFKKvOa1p4lg+r7fS6BGHUGAvB3m36bE+ek
	V92qDCwWhQGhPfkq24rX/i31U5boavRKK4AoX2zXj34jzt5/6YVceXVs1yx1iHuYldBGzh
	yu5+6uON6ZndR5c6kTbmdfg3aeshNZI=
Date: Wed, 10 Jun 2026 12:20:19 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
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
 <6e7739cc-327e-4ca9-86f4-17729b624632@linux.dev>
Content-Language: en-US
In-Reply-To: <6e7739cc-327e-4ca9-86f4-17729b624632@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FD26180014
X-Rspam-User: 
X-Stat-Signature: scyiawbkqudj1w4fpfxs411rw18t6or1
X-HE-Tag: 1781119230-138915
X-HE-Meta: U2FsdGVkX1+Td52Q8RjkuSh8c5dPpeLpfsRLamEzY37ZbWooJzVYKqsxXVeYy/TaFAUtSoDCFSTGLXtMPtMmH2T9U6UC4vycTjHRQ91CoB+rahpTtT7HQ7Sk0rCCEScJaegMOFf8idBxLh/2/z0Pl1MUY3Iyq6clPB/EwUksqyGTBGFWsFM7kf48ijDRcwWkly3QYz+HAkwSdlbTZh7gZCtk7GwakRYNZ7kGPy8Q+RUzW2phCGi7PC8qkFwNzGtsGGUdaaykqjRzIlv4s1QH9R79YiggIP9manBbzpS8F1JyuWX+FAOtevgjnj4lJXTcWgWnM5o+dNo9GTiESsGWeUua4yVMVPUumvBjJqcIMCdG8WggHayI2NzTjibH0lm/UFt7EelbNUiMNdsTC/BFrj16FjM1j1sMS+w0B9SDso1uPz8P4Idi+SjHhxuuaUKHACD70A9dESlcbaocd8KpH045h1Vd2FGcLDTp0EmCdAVoLzTYMECR0uJZdGBWaqBpWwIGd/CAi0jvgqwK6PLZJkyqpYUxgbnQjuVUCusx6pyZ84Y/J9IGWxm22nKr7JCLi2P9r2+sWDqu4z3RrZ8rtNx3W1qFM/47weNTFYYnWGFitUc7CMskUazSA60mJVwvFzFKY5T/UA9aXL9vnoyPiQo3nifgWIz/5Fbf1K77bkNN+WGsIPSxWqPZt3VWoAmOGECrr7q0O4xzXcE+v9hgBpZcs5xQ1ynyfYNQmYi/FQ5xgUuV3pLiN3Cc7M8vF9hmGrZHzSmx0NYaVKFZ4HxthT5IhVuNfwxc15jhIx27PPkKd5tfp9A1zjs1xFFzWI5rto/PQMEVF2dpy/RMiEC0Hn3ak5DJXkWOrCdypYndJ6sgZ7Mjas+WyO31b9hsVV/Fj+GC9wwSowQUb3pqujWTOjVPzTQ2fcI3BMkQitfMQ5kCJ5y5X6eCWqUADtgQJ703Zrcw/ukoE8Kd8dqXTn5
 Fa4p5H5f
 pyqi6ChOKWSfulCDpzhgRAPKzn8PrhwE8PpaWoSaOKrHYYk/LS3VEv29/hBMkiZ49BWSa0v93eWsewImmT0fdBEoLgE4FuNGxfbRbLPNO6RhANl5gdh4Qx0f89/FZZl9h6w6qQJAPNMtsI22ZWRIpXNVmhpsAV5VM/ZrRvlO48kqIJl8OEzmYNqGfo5SL3tUpaODi+TUoPGvc2jcnpUn003JhZis/zUNgq7A80mKnX/Qamz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 11:54 AM, JP Kobryn wrote:
> On 6/9/26 6:21 PM, Shakeel Butt wrote:
>> On Tue, Jun 09, 2026 at 05:16:15PM -0700, JP Kobryn wrote:
>>> On 6/9/26 5:07 PM, JP Kobryn wrote:
>>>> On 6/9/26 12:44 AM, Barry Song wrote:
>>>>> On Tue, Jun 9, 2026 at 12:12 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
>>>>>>
>>>>>> LRU add batches can be drained before they reach capacity. This can be a
>>>>>> source of LRU lock contention, but it is not currently possible to
>>>>>> attribute these drains to callers with existing tracepoints.
>>>>>>
>>>>>> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
>>>>>> lru_add batch is drained. This allows tracing to distinguish full drains
>>>>>> from partial drains and attribute them to the calling stack.
>>>>>>
>>>>>> Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
>>>>>> per-CPU drain work. This captures the requester stack and target CPU for
>>>>>> remote drain work. The event is named as a drain-all queue event because
>>>>>> the queued work can be needed for batches other than lru_add.
>>>>>>
>>>>>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>>>>>> ---
>>>>>>  include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
>>>>>>  mm/swap.c                      |  6 ++++-
>>>>>>  2 files changed, 45 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
>>>>>> index 171524d3526d..ea8fc46bedb0 100644
>>>>>> --- a/include/trace/events/pagemap.h
>>>>>> +++ b/include/trace/events/pagemap.h
>>>>>> @@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
>>>>>>         TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
>>>>>>  );
>>>>>>
>>>>>> +TRACE_EVENT(mm_lru_add_drain,
>>>>>> +
>>>>>> +       TP_PROTO(int cpu, unsigned int nr),
>>>>>> +
>>>>>> +       TP_ARGS(cpu, nr),
>>>>>> +
>>>>>> +       TP_STRUCT__entry(
>>>>>> +               __field(int,            cpu     )
>>>>>> +               __field(unsigned int,   nr      )
>>>>>> +       ),
>>>>>> +
>>>>>> +       TP_fast_assign(
>>>>>> +               __entry->cpu    = cpu;
>>>>>> +               __entry->nr     = nr;
>>>>>> +       ),
>>>>>> +
>>>>>> +       TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
>>>>>> +);
>>>>>> +
>>>>>> +TRACE_EVENT(mm_lru_drain_all_queue,
>>>>>> +
>>>>>> +       TP_PROTO(int target_cpu, bool force_all_cpus),
>>>>>> +
>>>>>> +       TP_ARGS(target_cpu, force_all_cpus),
>>>>>> +
>>>>>> +       TP_STRUCT__entry(
>>>>>> +               __field(int,    target_cpu      )
>>>>>> +               __field(bool,   force_all_cpus  )
>>>>>> +       ),
>>>>>> +
>>>>>> +       TP_fast_assign(
>>>>>> +               __entry->target_cpu     = target_cpu;
>>>>>> +               __entry->force_all_cpus = force_all_cpus;
>>>>>> +       ),
>>>>>> +
>>>>>> +       TP_printk("target_cpu=%d force_all_cpus=%s",
>>>>>> +               __entry->target_cpu,
>>>>>> +               __entry->force_all_cpus ? "true" : "false")
>>>>>> +);
>>>>>> +
>>>>>>  #endif /* _TRACE_PAGEMAP_H */
>>>>>>
>>>>>>  /* This part must be outside protection */
>>>>>> diff --git a/mm/swap.c b/mm/swap.c
>>>>>> index 588f50d8f1a8..c385b93582eb 100644
>>>>>> --- a/mm/swap.c
>>>>>> +++ b/mm/swap.c
>>>>>> @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
>>>>>>  {
>>>>>>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>>>>>>         struct folio_batch *fbatch = &fbatches->lru_add;
>>>>>> +       unsigned int nr_folios_add = folio_batch_count(fbatch);
>>>>>>
>>>>>> -       if (folio_batch_count(fbatch))
>>>>>> +       if (nr_folios_add) {
>>>>>>                 folio_batch_move_lru(fbatch, lru_add);
>>>>>> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
>>>>>> +       }
>>>>>>
>>>>>>         fbatch = &fbatches->lru_move_tail;
>>>>>>         /* Disabling interrupts below acts as a compiler barrier. */
>>>>>> @@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
>>>>>>                 if (cpu_needs_drain(cpu)) {
>>>>>>                         INIT_WORK(work, lru_add_drain_per_cpu);
>>>>>>                         queue_work_on(cpu, mm_percpu_wq, work);
>>>>>> +                       trace_mm_lru_drain_all_queue(cpu, force_all_cpus);
>>>>>
>>>>> Do you need tracing on each CPU individually, or is tracing the
>>>>> entire __lru_add_drain_all() invocation sufficient?
>>>>
>>>> I think the latter would be fine. The remote work will invoke the
>>>> mm_lru_add_drain tracepoint, which will show up as kworker stacks. Since
>>>> the event already has the CPU, we could see where queued drains actually
>>>> ran.
>>>
>>> Actually if it's just a single invocation and the only event data is the
>>> force flag, a tracepoint may not even be needed. Other probes can be
>>> installed on function invocation and read the single argument. I can
>>> drop this from v2 and keep the single mm_lru_add_drain tracepoint.
>>
>> No we do want to trace the callers requesting to drain from all the CPUs. If you
>> trace just lru_add_drain_cpu() then you will only see that the drain is
>> requested for a given CPU but no information on the requester. 
>>
>> Also as Barry said, I think single trace for whole __lru_add_drain_all() is good
>> enough.
> 
> Right, but couldn't that already be done with fentry or kprobe? If we
> only need the calling stack and the argument value of force_all_cpus I
> don't see a strong need for a dedicated tracepoint.

Nevermind that. I see it's declared inline so I'll add a tracepoint and
send v3.


