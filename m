Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0808AC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D970B6B0096; Thu, 24 Sep 2026 03:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21A76B0098; Thu, 24 Sep 2026 03:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA236B0099; Thu, 24 Sep 2026 03:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91DF26B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:27:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F04011C21CB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:21:39 +0000 (UTC)
X-FDA: 85247810718.22.DE14559
Received: from mta1.migadu.com (out-249.mta1.migadu.com [95.215.58.249])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD039160006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:21:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vntrjYBC;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.249 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790234498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJ/PmnCoBhYXoW5EDloSneUdZSQZm/fVH7j0lrxElnE=;
	b=0EWpMSPZS4dsujN8HRaSCSgnIKZMjgMtfgyarY/faQnvgiowKS7bDdkblLTGsrRMXzoNrw
	8Z56nG7i7ydFe9SxKUB/VAIK9rqF/Zi4MarUBNh6yKrWEISfk3+UbsK+oQ+i7R/1/8DbAE
	tsucDpoFQNx6eqKVTZ+ua3aOMXIwt4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790234498;
	b=IU5/hVN74PCn6FEKmNgOP6u7kWDnmEirmyckcxkUBB4WU2/eg3L7S1iVw6sixdwj006z9U
	8eHdbae0fPY++8zEuZUblYFXNUWbKsAru4+3+as4G+yTgvoZNw/FA0GWL/kRdzH3tTzqiF
	fWecowMRw36kisR5r6HiJYsRi0KpbyA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vntrjYBC;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.249 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QLXA0h8W8eXCxkRqrbfPiCmYFGDASkv1cTc1YChr8x4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790234496; v=1; x=1790839296;
 b=vntrjYBCrdZd7s0L7hUXpnynxdPbThlDMTWORVlfS1nTzaxSbGAhic88+040ozcJsX9wdDmT
 uZkDpY3xdKGNrDLYgLrMXG7I4wqwTuqj311qNErQXv5WoypKNsQi+t4c1q7xEkb1KT0RijWD4sk
 uvhG0n8SfoUthXf1wWf3BeDM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 020ecb12d3a57268;
	Thu, 24 Sep 2026 07:21:36 +0000
X-Mizu-Trace-ID: 020ecb12d3a57268
X-Migadu-Flow: FLOW_OUT
Message-ID: <cb229e38-3e52-4309-9594-0d3947c1a81c@linux.dev>
Date: Thu, 24 Sep 2026 15:22:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] alloc_tag: Add trace events for tracing allocations
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>
References: <cover.1790025465.git.abhishekbapat@google.com>
 <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD039160006
X-Stat-Signature: o59nhm6997bnewh31b3zubrp9e7fx7dg
X-Rspam-User: 
X-HE-Tag: 1790234497-995397
X-HE-Meta: U2FsdGVkX1+GfxSg6vSTWpdLfbQGik5f5yu0ND+KWht/S4N7tnQtdYTpJNs4a8Bs6Y4Uwse66H/YFg4Ia62LcDPJ9i7XgJHsIYS3s5X3ffTU99RvwAoLxIyT9C6ENy15/1yHfN44E7CbJ6I/eQokM13nJJw1pagz7CkU2GFq6K3n6OvP9TwUfAHKyakHX+fectQEvA6RDTar9kv4wraRTfw/HX7UmjHDLRE75mwMt2toXFqmLIOqMLssmYc8WbDEAc1sx7HarE5lIhpM5b+IshRQBW6D7xlcVf5T76+AkOdjvDpYzwd26PgLrnrLcqBC0vjYyZ0979xUawx69U+b0gqt6aXI+/Pm9tzM9bFQ/M8xcaLv7eN0JuGh8iCSrbrnHZKAKNS3fHGJ/gBVFP01JLkQzvfczjOZAdceU25jcHh37Nia2htMh7JNzzx0nU6nOvNPNCnE/Nzek4pVPHKjuMQzNhTrNCzQN9V/KJlf0/jjS9QyM4ULj7qK6Ey6EPk0RNG3xUGVSTI2JYlVj3GPwQVy7soyo9EG3Ho0IjLvYI4GISp/mvUoe8xG2f55QV3fWFrH9egpOplQkmfF12NsqzfYCnKibeCb2hAJAA7rv25OjfwPYncXSimAxEXiZ6OQ96BRFUBMR6N2tQVTydjDW56buw+a5c0mBDbt1LrPaPLvulElvgFocsRngp5OsFiRwhE0J1MHEJ735lCjGjG20uBa9oZLbzMFOTNgL+F2EtAMAZlNEOnDd0osgI1uwmqYsvePK0t75r2MAZVCbPt2UZzl+YOyGMbBB8i/BIyzerM7Jzu3VayP434dwhamMLp+gjdOYKavWZkgG/x0zwUe33ZbfVorMEWV+kC/KVbMzfQIJudo2a1VynErIvHAqMtvM6n1+o+6j2ddvxTxJLFwTHYbg9alOsmZSe6swZixZfDCd8hs+JDizwBcz7EJoXtLX3bKAckwqiaRiLBNQxv
 sCjIxqoF
 xs+uLigrUHAtHxfbOfpPlIB+mFJbRyIL832pDeyZPGfGme9yizyZ4wg97u7eAoWyDahJ0wBD0xH+zjsyOYKXzHHetkONn9WH4E51p20dyLY/Nbxz2QbfNn7ggJEEZazD3TwBWEAYFlbCMfwYXUESX5WxGfU3dA0p4vmW9kUGoElLm3tuLWI0Ye3CCOTorq9MeBXN2HXV+9EHU77nSxC0rvgRuea6GSR2PxndrH0qJuEeRSCsDWhn621WQxp4lpcB9HITw+sYZQHZbhHP7a3ZnbyC9XiaGhgmVoXUUgAj9OIKyXE3ig6pgBJWb9wqyzo9bLekM5dv/kEYXJtFOiTyvc7W9MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek

Sorry, I merged and tested your patches today and found a few details,
so I've started a separate mail thread for this review.

On 2026/9/22 05:26, Abhishek Bapat wrote:
> The memory allocation profiling framework intercepts allocations across
> the core subsystems, but currently lacks runtime tracing hooks for
> standard observability tools to dynamically track the context (stack
> traces and lifecycles of the individual memory chunks) of the
> allocations made.
> 
> Introduce three standard trace events to allow this tracking:
> 
> 1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
>    tools to trigger and capture a call stack.
> 2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
>    allocation. It records the allocated size, the tag, and the uniquely
>    generated codetag_ref metadata pointer.
> 3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
>    freed, yielding the same codetag_ref to allow tracing tools to find
>    the corresponding allocation.
> 
> Because the introduced trace events occur at different stages in the
> call stack, userspace tracing tools must stitch them together to form a
> complete picture of a buffer's lifetime. Here's an example of how
> userspace correlates these three events:
> 
> 1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
>    keyed by the combination of the current thread's PID and the `tag`.
> 2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
>    the event and looks up the stack trace cached in step 1. It creates a
>    new active allocation record, mapping the new provided `codetag_ref`
>    to this cached stack trace and the newly returned allocation size.
> 3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
>    the same `codetag_ref`. The tool uses this reference to look up the
>    original allocation record, correlates the free, and safely retires
>    the tracking entry.
> 
> Also, introduce `alloc_tag_trace_key` static key to minimize the
> overhead when no tags are being traced (the usual case). Once tracing
> for any tag is requested, the key is set, opening the path to check
> whether tracing is enabled for the current tag.
> Nore that the mechanism to enabl tag tracing is implemented in the next
> patch, therefore for now, `alloc_tag_trace_key` stays always unset.
> 
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>  MAINTAINERS                      |   1 +
>  include/linux/alloc_tag.h        |  57 ++++++++++++---
>  include/trace/events/alloc_tag.h | 122 +++++++++++++++++++++++++++++++
>  mm/alloc_tag.c                   |  28 +++++++
>  4 files changed, 196 insertions(+), 12 deletions(-)
>  create mode 100644 include/trace/events/alloc_tag.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 24420a8c06d0..29e1f7915cb9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17096,6 +17096,7 @@ S:	Maintained
>  F:	Documentation/mm/allocation-profiling.rst
>  F:	include/linux/alloc_tag.h
>  F:	include/linux/pgalloc_tag.h
> +F:	include/trace/events/alloc_tag.h
>  F:	include/uapi/linux/alloc_tag.h
>  F:	mm/alloc_tag.c
>  F:	tools/testing/selftests/alloc_tag/
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 7f2d80a59792..2994934cf44a 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
>  DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>  			mem_alloc_profiling_key);
>  
> +DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> +
>  static inline bool mem_alloc_profiling_enabled(void)
>  {
>  	return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>  				   &mem_alloc_profiling_key);
>  }
>  
> +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
> +{
> +	return static_branch_unlikely(&alloc_tag_trace_key);
> +}
> +
> +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
> +			      size_t bytes);
> +
> +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag *tag,
> +			     size_t bytes);
> +
> +void __alloc_tag_trace_hit(struct alloc_tag *tag);
> +
> +static inline void alloc_tag_trace_hit(struct alloc_tag *tag)
> +{
> +	if (alloc_tag_trace_enabled(tag))
> +		__alloc_tag_trace_hit(tag);
> +}
> +
>  bool mem_alloc_profiling_permanently_disabled(void);
>  
>  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
> @@ -200,8 +221,13 @@ static inline bool alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *t
>  
>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
>  {
> -	if (likely(alloc_tag_ref_set(ref, tag)))
> +	if (likely(alloc_tag_ref_set(ref, tag))) {
>  		this_cpu_add(tag->counters->bytes, bytes);
> +
> +		if (alloc_tag_trace_enabled(tag))
> +			/* Trace successful allocs with their unique ref */
> +			alloc_tag_trace_mem_alloc(ref, tag, bytes);
> +	}
>  }
>  
>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
> @@ -222,6 +248,10 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
>  	this_cpu_sub(tag->counters->bytes, bytes);
>  	this_cpu_dec(tag->counters->calls);
>  
> +	if (alloc_tag_trace_enabled(tag))
> +		/* Trace frees with their unique ref */
> +		alloc_tag_trace_mem_free(ref, tag, bytes);
> +
>  	ref->ct = NULL;
>  }
>  
> @@ -247,21 +277,24 @@ static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
>  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
>  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
> +#define alloc_tag_trace_hit(_tag)	/* NOOP */

I'd prefer we use `do {} while (0)` here, following the same pattern
as alloc_tag_record.

>  #define alloc_tag_record(p)	do {} while (0)
>  
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>  
> -#define alloc_hooks_tag(_tag, _do_alloc)				\
> -({									\
> -	typeof(_do_alloc) _res;						\
> -	if (mem_alloc_profiling_enabled()) {				\
> -		struct alloc_tag * __maybe_unused _old;			\
> -		_old = alloc_tag_save(_tag);				\
> -		_res = _do_alloc;					\
> -		alloc_tag_restore(_tag, _old);				\
> -	} else								\
> -		_res = _do_alloc;					\
> -	_res;								\
> +#define alloc_hooks_tag(_tag, _do_alloc)					\
> +({										\
> +	typeof(_do_alloc) _res;							\
> +	if (mem_alloc_profiling_enabled()) {					\
> +		struct alloc_tag * __maybe_unused _old;				\
> +		/* Fired here to cleanly capture the caller's stack trace */	\
> +		alloc_tag_trace_hit(_tag);					\
> +		_old = alloc_tag_save(_tag);					\
> +		_res = _do_alloc;						\
> +		alloc_tag_restore(_tag, _old);					\
> +	} else									\
> +		_res = _do_alloc;						\
> +	_res;									\
>  })
>  
>  #define alloc_hooks(_do_alloc)						\
> diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/alloc_tag.h
> new file mode 100644
> index 000000000000..af2182501864
> --- /dev/null
> +++ b/include/trace/events/alloc_tag.h
> @@ -0,0 +1,122 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM alloc_tag
> +
> +#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_ALLOC_TAG_H
> +
> +#include <linux/tracepoint.h>
> +
> +/*
> + * alloc_tag_hit is generated at the exact allocation call site and can be
> + * used to capture a clean stack trace.
> + *
> + * To link this stack trace to the actual allocated memory chunk, tools must
> + * correlate this event with the resulting alloc_tag_mem_alloced event. Since
> + * multiple threads can hit the same tag simultaneously, tools must match BOTH
> + * the `tag` field and the implicitly recorded PID provided by the core
> + * tracing subsystem.
> + */
> +TRACE_EVENT(alloc_tag_hit,
> +
> +	TP_PROTO(struct alloc_tag *tag),
> +
> +	TP_ARGS(tag),
> +
> +	TP_STRUCT__entry(
> +		__field(struct alloc_tag *, tag)
> +		__string(modname, tag->ct.modname ? tag->ct.modname : "NONE")
> +		__string(filename, tag->ct.filename)
> +		__string(function, tag->ct.function)
> +		__field(unsigned int, lineno)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->tag = tag;
> +		__assign_str(modname);
> +		__assign_str(filename);
> +		__assign_str(function);
> +		__entry->lineno = tag->ct.lineno;
> +	),
> +
> +	TP_printk("tag %p, module: %s, filename: %s, function %s, lineno %u",
> +		__entry->tag,
> +		__get_str(modname),
> +		__get_str(filename),
> +		__get_str(function),
> +		__entry->lineno
> +	)
> +);
>

When I trace an interface provided by a kernel build-in such as shmem,
this is what I see in the trace:

trig-6838    [004] .....  1309.321906: alloc_tag_hit: tag 000000007874a2c9, module: NONE, filename: mm/shmem.c, function shmem_alloc_folio, lineno 2138

The module field shows NONE, which looks a bit odd.

> +/*
> + * alloc_tag_mem_alloced is generated after memory is successfully allocated.
> + * It captures the exact byte size.
> + *
> + * The `ref` pointer identifies the memory chunk for tracking its lifecycle
> + * (e.g., matching it with alloc_tag_mem_freed).
> + *
> + * Because the kernel isolates active allocations within the task struct
> + * (current->alloc_tag), this even will always share the same implicit PID as
> + * its corresponding alloc_tag_hit event. Tools should use the combination
> + * PID + `tag` to correlate them.
> + */
> +TRACE_EVENT(alloc_tag_mem_alloced,
> +
> +	TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes),
> +
> +	TP_ARGS(ref, tag, bytes),
> +
> +	TP_STRUCT__entry(
> +		__field(union codetag_ref *, ref)
> +		__field(struct alloc_tag *, tag)
> +		__field(size_t, bytes)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ref = ref;
> +		__entry->tag = tag;
> +		__entry->bytes = bytes;
> +	),
> +
> +	TP_printk("reference %p, tag %p, bytes %zu",
> +		__entry->ref,
> +		__entry->tag,
> +		__entry->bytes
> +	)
> +);
> +
> +/*
> + * alloc_tag_mem_freed event is generated immediately before memory is
> + * freed. The `ref` pointer matches the one emitted during allocation,
> + * allowing tools to match it to it's corresponding allocation and
> + * call stack.
> + */

But the thread for allocation and free may not be the same.
For example, memory allocated in thread A could be freed by kswapd.
In this case, would the ref fail to match and falsely report a memory leak?

Thanks
Best Regards
Hao

> +TRACE_EVENT(alloc_tag_mem_freed,
> +
> +	TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes),
> +
> +	TP_ARGS(ref, tag, bytes),
> +
> +	TP_STRUCT__entry(
> +		__field(union codetag_ref *, ref)
> +		__field(struct alloc_tag *, tag)
> +		__field(size_t, bytes)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ref = ref;
> +		__entry->tag = tag;
> +		__entry->bytes = bytes;
> +	),
> +
> +	TP_printk("reference %p, tag %p, bytes %zu",
> +		__entry->ref,
> +		__entry->tag,
> +		__entry->bytes
> +	)
> +);
> +
> +#endif /* _TRACE_ALLOC_TAG_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index f30ef8dd24c7..a5339767efd5 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -19,6 +19,9 @@
>  #include <linux/kmemleak.h>
>  #include <uapi/linux/alloc_tag.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/alloc_tag.h>
> +
>  #include "internal.h"
>  #include "page_alloc.h"
>  
> @@ -55,6 +58,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
>  
>  DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
>  
> +DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> +EXPORT_SYMBOL(alloc_tag_trace_key);
> +
>  struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
>  unsigned long alloc_tag_ref_mask;
>  int alloc_tag_ref_offs;
> @@ -485,6 +491,28 @@ static const struct proc_ops allocinfo_proc_ops = {
>  #endif
>  };
>  
> +void __alloc_tag_trace_hit(struct alloc_tag *tag)
> +{
> +	if (unlikely(!tag))
> +		return;
> +	trace_alloc_tag_hit(tag);
> +}
> +EXPORT_SYMBOL(__alloc_tag_trace_hit);
> +
> +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
> +			      size_t bytes)
> +{
> +	trace_alloc_tag_mem_alloced(ref, tag, bytes);
> +}
> +EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
> +
> +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag *tag,
> +			     size_t bytes)
> +{
> +	trace_alloc_tag_mem_freed(ref, tag, bytes);
> +}
> +EXPORT_SYMBOL(alloc_tag_trace_mem_free);
> +
>  size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
>  {
>  	struct codetag_iterator iter;

