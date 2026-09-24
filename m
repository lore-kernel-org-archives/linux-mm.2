Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E78C9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 01:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8FB6B0088; Wed, 23 Sep 2026 21:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A3D6B008A; Wed, 23 Sep 2026 21:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFD26B008C; Wed, 23 Sep 2026 21:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA726B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:22:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E283A0162
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:22:01 +0000 (UTC)
X-FDA: 85246904442.13.C20964F
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id B31C81C0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:21:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P3Y8eHu4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790212919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LWhXez4sMk0Rj3dZzRA5D+BV0ovazgjrIQQ/T3RSaA=;
	b=fYNOBJmTsVD91MX1t7rEILf/n7ieHAM98SI7iopxOdNodXCGiXlZi6ab/48VKgiKx8RpHJ
	wqT3a/H2QUfBU51Bdi9QVRITytlXdnuX+38LDQoOpg0R03/9yP2RegLOo8N+DW4cg1Tptj
	ce9remUYf8ZxUqQA0ZhJr+daLq0Vvag=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P3Y8eHu4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790212919;
	b=gywfZ/LyQ4DM4jN+bxbpfkQIbvNjD2gkgXZCXrAd4DVmDLzaSSYBKd6bqBQvC+PUnr8qr/
	pv7b70EWOy/frBnFJ/WK5k7A5AjMlXwAeSlebgkifV4QuSEp6Y+ddhqPzKA5porVCEqdCh
	v2CcSSMHxrLRO1gwRrkSyXHtPaTjflk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LDy+LskDsltkd/pJbNPXOEFYwbrB9PfyRO1YpNEnmcY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790212917; v=1; x=1790817717;
 b=P3Y8eHu4JpfHp0G9Z0fmjyEfLX+PsH2nq49v3PYwXOJbBjtsXKLhJEijyIFlrjAlDzDtVypp
 d9RxliYp7EjHWagyo8TDQSWZ7vc/CeEgGuuKsuyLFhzOJlmrTElszdNTcxlgKOb59TZiiOCISO4
 cPYmiGJN9y94hgX/N/Xfih3A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d7a3babc8545e2f9;
	Thu, 24 Sep 2026 01:21:57 +0000
X-Mizu-Trace-ID: d7a3babc8545e2f9
X-Migadu-Flow: FLOW_OUT
Message-ID: <edeaa8cc-e14a-4cf6-bb1b-1d3fd44d9cbc@linux.dev>
Date: Thu, 24 Sep 2026 09:22:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] alloc_tag: Add trace events for tracing allocations
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>
References: <cover.1790025465.git.abhishekbapat@google.com>
 <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
 <e8f65e6d-440b-418d-b7ba-e05ca2b0d712@linux.dev>
 <CAL41Mv7P3xDAvTGtdSHEG3Cvu70W6uhZ9mThm-OD3PcGDDU17w@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAL41Mv7P3xDAvTGtdSHEG3Cvu70W6uhZ9mThm-OD3PcGDDU17w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r4dj467uthiezo9x7b3rfafeqdxapr1f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B31C81C0004
X-HE-Tag: 1790212918-591160
X-HE-Meta: U2FsdGVkX19QwfgnjvptFbVan+txk8PgsDpVDkyokIzr5AWTTkpGs2/h+kEw7UF8f4mDcIFs6nsxPnMt70KWn+5EHawSjxK13BgDhWf0nUPfVcsenZ/bOOAPcZo04PPF2bZZR1D6xsQPz1YPARJhgpaO6LorM9+Ah8ebUrIjVBP0iFGDjaAeC+IposhynBaJI/Wh2ZOcDFnoe7rX1LMCxiwBP9iW0gZ2hNdawnILJk7zRMdgQl3B4YfesiVTgqY4wxlsjMSb1uYfe36fFztLWDayxY0DfV3yTTmNsyf+8KNjkT5M/d+60P/PXOMu7hoYu/HzAUp1TjBNHqhNVAig/nt2zB7WMXlAgRw25Hpmt2a20orTqQoMzi6b3iVM77p8dB0CN5YkQ/S+cI4YGtYYQJII0/Y7SM/xzmPazqbuBF2D+FLpF2DKp87sNjZmQL6LDyFWVUT+uu9HdsMLC4m3U2bO35VLvdvmBUd7TlvJlIbDYIvJfv44djGg8gQ7WjQvc4VvtE9Q4nByD2CTTtWqO7MfSMRMMUOkzXbO/nSn8IcsfZ4xlvipImBdHVQkKlq02UZWh986EezNr3DCwMK28bWjmCHHdlgl9hP7JCCN7YK+AEQlWV2Fwp18xUMmdHKatrj1vv7CHkFK48VjTRTmlkniaSp7kNrUDJqXbXwlfnEm02Wt1ZKqhMrhZ2nOK1KpbbnWFGCFmSipAU9d3ixNuhdeMbQx+dlE2SHJly5RSpEtnfJbC46HVRL3d47uP78ALQLmvi+/TzGLTrDpkIDM62bBDXzWUAbrF0ERBfWFppthNn6YcdMG+OKTDVk8a9hvy+XJX2U9rGAci0glNAuV6q1swYmVutPphX/EJzrHC5XWpwaqD1y9dJeiuYzy8bXE9S+4lTnAOApocDWaOkip2E4hI5w2qO3moG/hPzrM3JAAInfcF3owzBNPa9zvY6U7I3CWmRkcjkqySA+GGni
 dy9Pbs+x
 qXmJHcvHT5Yw5+eXJJzbBN4Snd53p039a3Fr786M/ESRRK8tprX09d06Syc/MnBWcifPXLMs+jjTSL39OwXxjO/pSgYuL1wK2dWRV5v6cEWZRTccg1mmjwnm+iYu0GjXrv78+BDla8IPo0R3yOA53zMtCx6zeMNfYeCCTLU6VUdfEMwQpUs4oes9/V5UqkzSOFl9t0XzA4ITIj9/a9y0EvRXo/8dyQiThqc/HwrAclDRCqccXy/kvkFyUk/JSlMuwLkFeUDfZLKEDb8ut1YC14a10THIh8CqiKpMHc5f4AC2pAaSSnkGGpbcDyLy8WoLeBKKhDPoSqrDPR1bcrnqfgHfevqFZNB39QFFZRI2Ea2WxzUmNZbfwZbi2tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek

On 2026/9/24 04:12, Abhishek Bapat wrote:
> On Wed, Sep 23, 2026 at 2:55 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> Hi Abhishek
>>
>> On 2026/9/22 05:26, Abhishek Bapat wrote:
>>> The memory allocation profiling framework intercepts allocations across
>>> the core subsystems, but currently lacks runtime tracing hooks for
>>> standard observability tools to dynamically track the context (stack
>>> traces and lifecycles of the individual memory chunks) of the
>>> allocations made.
>>>
>>> Introduce three standard trace events to allow this tracking:
>>>
>>> 1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
>>>    tools to trigger and capture a call stack.
>>> 2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
>>>    allocation. It records the allocated size, the tag, and the uniquely
>>>    generated codetag_ref metadata pointer.
>>> 3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
>>>    freed, yielding the same codetag_ref to allow tracing tools to find
>>>    the corresponding allocation.
>>>
>>> Because the introduced trace events occur at different stages in the
>>> call stack, userspace tracing tools must stitch them together to form a
>>> complete picture of a buffer's lifetime. Here's an example of how
>>> userspace correlates these three events:
>>>
>>> 1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
>>>    keyed by the combination of the current thread's PID and the `tag`.
>>> 2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
>>>    the event and looks up the stack trace cached in step 1. It creates a
>>>    new active allocation record, mapping the new provided `codetag_ref`
>>>    to this cached stack trace and the newly returned allocation size.
>>> 3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
>>>    the same `codetag_ref`. The tool uses this reference to look up the
>>>    original allocation record, correlates the free, and safely retires
>>>    the tracking entry.
>>>
>>> Also, introduce `alloc_tag_trace_key` static key to minimize the
>>> overhead when no tags are being traced (the usual case). Once tracing
>>> for any tag is requested, the key is set, opening the path to check
>>> whether tracing is enabled for the current tag.
>>> Nore that the mechanism to enabl tag tracing is implemented in the next
>>> patch, therefore for now, `alloc_tag_trace_key` stays always unset.
>>>
>>
>> nit: s/Nore/Note/ s/enabl/enable
>>
> Ack.
>>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>>> ---
>>>  MAINTAINERS                      |   1 +
>>>  include/linux/alloc_tag.h        |  57 ++++++++++++---
>>>  include/trace/events/alloc_tag.h | 122 +++++++++++++++++++++++++++++++
>>>  mm/alloc_tag.c                   |  28 +++++++
>>>  4 files changed, 196 insertions(+), 12 deletions(-)
>>>  create mode 100644 include/trace/events/alloc_tag.h
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 24420a8c06d0..29e1f7915cb9 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -17096,6 +17096,7 @@ S:    Maintained
>>>  F:   Documentation/mm/allocation-profiling.rst
>>>  F:   include/linux/alloc_tag.h
>>>  F:   include/linux/pgalloc_tag.h
>>> +F:   include/trace/events/alloc_tag.h
>>>  F:   include/uapi/linux/alloc_tag.h
>>>  F:   mm/alloc_tag.c
>>>  F:   tools/testing/selftests/alloc_tag/
>>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>>> index 7f2d80a59792..2994934cf44a 100644
>>> --- a/include/linux/alloc_tag.h
>>> +++ b/include/linux/alloc_tag.h
>>> @@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
>>>  DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>>>                       mem_alloc_profiling_key);
>>>
>>> +DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
>>> +
>>>  static inline bool mem_alloc_profiling_enabled(void)
>>>  {
>>>       return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>>>                                  &mem_alloc_profiling_key);
>>>  }
>>>
>>> +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
>>> +{
>>> +     return static_branch_unlikely(&alloc_tag_trace_key);
>>> +}
>>> +
>>
>> The tag parameter is unused here. Let's remove it for now and add it back when needed,
>> to avoid the -Wno‑unused‑parameter warning.
>> Some CI bots go through each patch one‑by‑one, so we can't leave warnings in
>> intermediate commits.
>>
> Ack.
>> One other thought: what about adding a sysctl knob here?
>> It would let users grab all alloc‑tag tracked allocations within a time window?
>>
> You mean to enable the static key? With the following patches, it
> would mean that the state of the static key would change by writing to
> sysctl and through IOCTLs. I am not sure if letting the static key be
> controlled by two mechanism is a good idea. I'd like to get Suren's
> thoughts on this.
>

This idea came from a kmalloc leak we observed on an OS.
My colleague took over this issue, and he first asked me
whether memory allocation profiling can track allocations
over a period of time. (I was happy he immediately thought
of our memory allocation profiling.)

Thanks
Best Regards
Hao

>> Thanks
>> Best Regards
>> Hao
>>
>>> +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
>>> +                           size_t bytes);
>>> +
>>> +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag *tag,
>>> +                          size_t bytes);
>>> +
>>> +void __alloc_tag_trace_hit(struct alloc_tag *tag);
>>> +
>>> +static inline void alloc_tag_trace_hit(struct alloc_tag *tag)
>>> +{
>>> +     if (alloc_tag_trace_enabled(tag))
>>> +             __alloc_tag_trace_hit(tag);
>>> +}
>>> +
>>>  bool mem_alloc_profiling_permanently_disabled(void);
>>>
>>>  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
>>> @@ -200,8 +221,13 @@ static inline bool alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *t
>>>
>>>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
>>>  {
>>> -     if (likely(alloc_tag_ref_set(ref, tag)))
>>> +     if (likely(alloc_tag_ref_set(ref, tag))) {
>>>               this_cpu_add(tag->counters->bytes, bytes);
>>> +
>>> +             if (alloc_tag_trace_enabled(tag))
>>> +                     /* Trace successful allocs with their unique ref */
>>> +                     alloc_tag_trace_mem_alloc(ref, tag, bytes);
>>> +     }
>>>  }
>>>
>>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
>>> @@ -222,6 +248,10 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
>>>       this_cpu_sub(tag->counters->bytes, bytes);
>>>       this_cpu_dec(tag->counters->calls);
>>>
>>> +     if (alloc_tag_trace_enabled(tag))
>>> +             /* Trace frees with their unique ref */
>>> +             alloc_tag_trace_mem_free(ref, tag, bytes);
>>> +
>>>       ref->ct = NULL;
>>>  }
>>>
>>> @@ -247,21 +277,24 @@ static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
>>>  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
>>>  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
>>> +#define alloc_tag_trace_hit(_tag)    /* NOOP */
>>>  #define alloc_tag_record(p)  do {} while (0)
>>>
>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>>
>>> -#define alloc_hooks_tag(_tag, _do_alloc)                             \
>>> -({                                                                   \
>>> -     typeof(_do_alloc) _res;                                         \
>>> -     if (mem_alloc_profiling_enabled()) {                            \
>>> -             struct alloc_tag * __maybe_unused _old;                 \
>>> -             _old = alloc_tag_save(_tag);                            \
>>> -             _res = _do_alloc;                                       \
>>> -             alloc_tag_restore(_tag, _old);                          \
>>> -     } else                                                          \
>>> -             _res = _do_alloc;                                       \
>>> -     _res;                                                           \
>>> +#define alloc_hooks_tag(_tag, _do_alloc)                                     \
>>> +({                                                                           \
>>> +     typeof(_do_alloc) _res;                                                 \
>>> +     if (mem_alloc_profiling_enabled()) {                                    \
>>> +             struct alloc_tag * __maybe_unused _old;                         \
>>> +             /* Fired here to cleanly capture the caller's stack trace */    \
>>> +             alloc_tag_trace_hit(_tag);                                      \
>>> +             _old = alloc_tag_save(_tag);                                    \
>>> +             _res = _do_alloc;                                               \
>>> +             alloc_tag_restore(_tag, _old);                                  \
>>> +     } else                                                                  \
>>> +             _res = _do_alloc;                                               \
>>> +     _res;                                                                   \
>>>  })
>>>
>>>  #define alloc_hooks(_do_alloc)                                               \
>>> diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/alloc_tag.h
>>> new file mode 100644
>>> index 000000000000..af2182501864
>>> --- /dev/null
>>> +++ b/include/trace/events/alloc_tag.h
>>> @@ -0,0 +1,122 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#undef TRACE_SYSTEM
>>> +#define TRACE_SYSTEM alloc_tag
>>> +
>>> +#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
>>> +#define _TRACE_ALLOC_TAG_H
>>> +
>>> +#include <linux/tracepoint.h>
>>> +
>>> +/*
>>> + * alloc_tag_hit is generated at the exact allocation call site and can be
>>> + * used to capture a clean stack trace.
>>> + *
>>> + * To link this stack trace to the actual allocated memory chunk, tools must
>>> + * correlate this event with the resulting alloc_tag_mem_alloced event. Since
>>> + * multiple threads can hit the same tag simultaneously, tools must match BOTH
>>> + * the `tag` field and the implicitly recorded PID provided by the core
>>> + * tracing subsystem.
>>> + */
>>> +TRACE_EVENT(alloc_tag_hit,
>>> +
>>> +     TP_PROTO(struct alloc_tag *tag),
>>> +
>>> +     TP_ARGS(tag),
>>> +
>>> +     TP_STRUCT__entry(
>>> +             __field(struct alloc_tag *, tag)
>>> +             __string(modname, tag->ct.modname ? tag->ct.modname : "NONE")
>>> +             __string(filename, tag->ct.filename)
>>> +             __string(function, tag->ct.function)
>>> +             __field(unsigned int, lineno)
>>> +     ),
>>> +
>>> +     TP_fast_assign(
>>> +             __entry->tag = tag;
>>> +             __assign_str(modname);
>>> +             __assign_str(filename);
>>> +             __assign_str(function);
>>> +             __entry->lineno = tag->ct.lineno;
>>> +     ),
>>> +
>>> +     TP_printk("tag %p, module: %s, filename: %s, function %s, lineno %u",
>>> +             __entry->tag,
>>> +             __get_str(modname),
>>> +             __get_str(filename),
>>> +             __get_str(function),
>>> +             __entry->lineno
>>> +     )
>>> +);
>>> +
>>> +/*
>>> + * alloc_tag_mem_alloced is generated after memory is successfully allocated.
>>> + * It captures the exact byte size.
>>> + *
>>> + * The `ref` pointer identifies the memory chunk for tracking its lifecycle
>>> + * (e.g., matching it with alloc_tag_mem_freed).
>>> + *
>>> + * Because the kernel isolates active allocations within the task struct
>>> + * (current->alloc_tag), this even will always share the same implicit PID as
>>> + * its corresponding alloc_tag_hit event. Tools should use the combination
>>> + * PID + `tag` to correlate them.
>>> + */
>>> +TRACE_EVENT(alloc_tag_mem_alloced,
>>> +
>>> +     TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes),
>>> +
>>> +     TP_ARGS(ref, tag, bytes),
>>> +
>>> +     TP_STRUCT__entry(
>>> +             __field(union codetag_ref *, ref)
>>> +             __field(struct alloc_tag *, tag)
>>> +             __field(size_t, bytes)
>>> +     ),
>>> +
>>> +     TP_fast_assign(
>>> +             __entry->ref = ref;
>>> +             __entry->tag = tag;
>>> +             __entry->bytes = bytes;
>>> +     ),
>>> +
>>> +     TP_printk("reference %p, tag %p, bytes %zu",
>>> +             __entry->ref,
>>> +             __entry->tag,
>>> +             __entry->bytes
>>> +     )
>>> +);
>>> +
>>> +/*
>>> + * alloc_tag_mem_freed event is generated immediately before memory is
>>> + * freed. The `ref` pointer matches the one emitted during allocation,
>>> + * allowing tools to match it to it's corresponding allocation and
>>> + * call stack.
>>> + */
>>> +TRACE_EVENT(alloc_tag_mem_freed,
>>> +
>>> +     TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes),
>>> +
>>> +     TP_ARGS(ref, tag, bytes),
>>> +
>>> +     TP_STRUCT__entry(
>>> +             __field(union codetag_ref *, ref)
>>> +             __field(struct alloc_tag *, tag)
>>> +             __field(size_t, bytes)
>>> +     ),
>>> +
>>> +     TP_fast_assign(
>>> +             __entry->ref = ref;
>>> +             __entry->tag = tag;
>>> +             __entry->bytes = bytes;
>>> +     ),
>>> +
>>> +     TP_printk("reference %p, tag %p, bytes %zu",
>>> +             __entry->ref,
>>> +             __entry->tag,
>>> +             __entry->bytes
>>> +     )
>>> +);
>>> +
>>> +#endif /* _TRACE_ALLOC_TAG_H */
>>> +
>>> +/* This part must be outside protection */
>>> +#include <trace/define_trace.h>
>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>>> index f30ef8dd24c7..a5339767efd5 100644
>>> --- a/mm/alloc_tag.c
>>> +++ b/mm/alloc_tag.c
>>> @@ -19,6 +19,9 @@
>>>  #include <linux/kmemleak.h>
>>>  #include <uapi/linux/alloc_tag.h>
>>>
>>> +#define CREATE_TRACE_POINTS
>>> +#include <trace/events/alloc_tag.h>
>>> +
>>>  #include "internal.h"
>>>  #include "page_alloc.h"
>>>
>>> @@ -55,6 +58,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
>>>
>>>  DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
>>>
>>> +DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
>>> +EXPORT_SYMBOL(alloc_tag_trace_key);
>>> +
>>>  struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
>>>  unsigned long alloc_tag_ref_mask;
>>>  int alloc_tag_ref_offs;
>>> @@ -485,6 +491,28 @@ static const struct proc_ops allocinfo_proc_ops = {
>>>  #endif
>>>  };
>>>
>>> +void __alloc_tag_trace_hit(struct alloc_tag *tag)
>>> +{
>>> +     if (unlikely(!tag))
>>> +             return;
>>> +     trace_alloc_tag_hit(tag);
>>> +}
>>> +EXPORT_SYMBOL(__alloc_tag_trace_hit);
>>> +
>>> +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
>>> +                           size_t bytes)
>>> +{
>>> +     trace_alloc_tag_mem_alloced(ref, tag, bytes);
>>> +}
>>> +EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
>>> +
>>> +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag *tag,
>>> +                          size_t bytes)
>>> +{
>>> +     trace_alloc_tag_mem_freed(ref, tag, bytes);
>>> +}
>>> +EXPORT_SYMBOL(alloc_tag_trace_mem_free);
>>> +
>>>  size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
>>>  {
>>>       struct codetag_iterator iter;

