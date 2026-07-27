Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421B4C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403E66B008A; Mon, 27 Jul 2026 16:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B46C6B008C; Mon, 27 Jul 2026 16:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB506B0093; Mon, 27 Jul 2026 16:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F07326B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:20:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3D2C1601EE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:20:56 +0000 (UTC)
X-FDA: 85035675312.12.CC70B6F
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C2D314000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:20:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785183655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=essjZcvpTbfjor+MeAk2JZas4VeRsdkEDUUFxrlCFHU=;
	b=NC5+tTgdTaU0GUi+lIphQJLTOhQIFOQPLNxP6QrrVcvhzmnPe+OkOHlhoY8FjYasdZ+K44
	68uPvNI/w7yE2bwwOfv5jp8LIXsgHonL2hAMMzyF1QNC00NoYVzqCMYdXzVooI06pcqt+A
	4uGWHpu2gxMGyG15QcBe+wkfH3/ofsU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785183655;
	b=2iB1lgLBrUKhYJoh/tmUVNxj7qTcIGtr208XKVYCM/z6ItLIDIahbUyI/TS12t+AXfMGZx
	8u1N7YkeMSM4LjxeydUW+2wS6B+CYK0CMN1xMnx86GQ9Up/1A6Hk3Pe9Z/wuiT/TKVbLyK
	KdokUiDLGBaBFD7gLCky6zyEQ3c2WQM=
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 699471401ED;
	Mon, 27 Jul 2026 20:20:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 644302000F;
	Mon, 27 Jul 2026 20:20:50 +0000 (UTC)
Date: Mon, 27 Jul 2026 16:21:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Eugene Mavick <m@mavick.dev>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Gary
 Guo <gary@garyguo.net>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 1/5] tracing: add ref_trace_final_put tracepoint
Message-ID: <20260727162122.39f292fe@gandalf.local.home>
In-Reply-To: <20260711-refcount-final-put-trace-v3-1-674c8f03d9f9@mavick.dev>
References: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
	<20260711-refcount-final-put-trace-v3-1-674c8f03d9f9@mavick.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+U+kKjBbPFD54KqmqnnY4FS5W9hOMdd5g=
X-HE-Meta: U2FsdGVkX19FO7mRN3KFTDvCHJwoCxA+GKzV5oe1wAT+Fjd5iIGO8q/9zt375ZLf4Ob80IvMvlnJGLG/tCdIh7OhHlhDp2W0SrUYescMSrcsCWVZ+JGZxAhwb9MqKSoU6YXSLi+R9qwmL2wdFt9vLAyeD1JY+iai+6uPt5Qwj7ztXOTUSVN2F4fhMQTT+mVjzWxIocKOOTzF71pXyLJPaauqDBCOAw3gbEUYZJMk1HoBZD5Y07/cmp94BTidwr0ft2PIuSmhbywuqLfRkdwWpzsz4VRotMPAcsdf5u3qcuOVYzN6nCVtkwAnVqPfFpMda5z6R0q8sr0WJ1L9isOap/EvRPTWfIBB
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C2D314000F
X-Stat-Signature: fgcfqqm13143u3ims6rkybjnkfsaj7qa
X-HE-Tag-Orig: 1785183650-206634
X-HE-Tag: 1785183655-887624
X-HE-Meta: U2FsdGVkX1/Pf2yw2xtl6HVI/Wf77FsOyGn+u3bzxIr6pvZ8I0bQt9I9l0sHrVpSpiAb+BsaT3Xw+Ye3ycgQy1VEaWE4RVOdb9x3V9MIr9nkp77XkIWZPQzWRxqg86tdam3hIPLRbs15riuM17/spQxBz38Xama428qt+J6Je44kTzbMnff94JMGOFyiM/EXpfAn3clht4suvApsvXEWAyF/N1r4KoUrlxcLunVheaPHTPqNXRf3jJU0/nVap0rB5vtFi29SmDjngB91ax4TCcmp2C1FXKLNhB9JR6WNcetzOUTs7nCMHDPNMPBuM2w5EQ1h5fnB9t5cclCzAkC132nNm1V07LQ4mblmOTXxChejCni3BwG2obYUIqLTGSYXGu0XT3ohuXhA9rj/iRn1E+lVgJd3f57POrAUEGqA94fXSODH5fMddI+Cz+q8WNsHvRPNA5+QW1Od16HY7FbKHvRgYb6FCWVOSoCj6WfVX5UdyLMvLS/iGnJGSYi3are/J++O74UDWAewojVxxsLPuYRdI+vzc6W+c12uEm+eVis3HSyx7A+PgS5rnNRt//4YMMfviRZJbvEbcYTuxsyas4BdBeix8/eHGQFnGwdEAzNRhGttf3Wj0kgmihkVPMKnfzCYg017vm2oWXeWJvHBCZwXBKw20a++tnI1eLBdn2abCVrkWREC1NlJRJOeOuJOXJaXr9qfQS51jiPVONMcFDZrNWzGK1sYPMzO17RpcqHsV3ShAupq5cmbRavfXDrnbCd4T/lVN6mfuLPRt3JnqDSNO1mH5ky0YKd2/5wKMIQzuJnqODEMilH/6o88yxMVuVHZti5C+CjQuAs9fhsIWdqLbRwP6hQWM9O8/e1oNPuOOK4oSKCeIqN9U77AReIh4f7dnhtY1sYQk44VNLelc9ZXiPODyrwz3aJY6kvVh3lgEXHRGhJjHAVUmBTE3FLOS3LynsWl/GcVj+wOnTz
 F8GeBfV9
 8PsQz4jxbJuAboLhWMUWWzma7/mdAyTb132PYWmQGPoP4JWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Jul 2026 12:40:19 +0800
Eugene Mavick <m@mavick.dev> wrote:

> Add ref_trace_final_put tracepoint and related core infrastructure
> 
> ref_trace_final_put fires when a reference
> count reaches zero and the object enters its final release path.
> 
> The tracepoint records three fields:
> - caller: function that called the refcounting
>   function(refcount_sub_and_test, percpu_ref_put_many)
> - fn: refcounting function(eg refcount_sub_and_test)

Why save the string just to figure out which function is used. It's quite
expensive in both recording the string and saving the name all over the
place.

> - obj: refcount object(struct percpu_ref, refcount_t)
> 
> Signed-off-by: Eugene Mavick <m@mavick.dev>
> ---
>  include/linux/ref_trace.h        | 26 +++++++++++++++++++++++
>  include/trace/events/ref_trace.h | 46 ++++++++++++++++++++++++++++++++++++++++
>  lib/Makefile                     |  2 ++
>  lib/ref_trace.c                  | 13 ++++++++++++
>  4 files changed, 87 insertions(+)
> 
> diff --git a/include/linux/ref_trace.h b/include/linux/ref_trace.h
> new file mode 100644
> index 000000000000..6c6600938a47
> --- /dev/null
> +++ b/include/linux/ref_trace.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_REF_TRACE_H
> +#define _LINUX_REF_TRACE_H
> +
> +#include <linux/tracepoint-defs.h>
> +#include <linux/instruction_pointer.h>
> +
> +/* Declare the tracepoint so tracepoint_enabled() can be used */
> +DECLARE_TRACEPOINT(ref_trace_final_put);
> +
> +#ifdef CONFIG_TRACEPOINTS
> +/* Wrapper function implemented in lib/ref_trace.c */
> +extern void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj);
> +
> +#define do_trace_ref_final_put(obj)						\
> +	do {									\
> +		if (tracepoint_enabled(ref_trace_final_put))			\
> +			do_ref_trace_final_put(_RET_IP_, __func__, obj);	\

Why save __func__ and and not just __THIS_IP__?

The name is quite expensive to save and even to store in memory, as it will
*always* be there.

> +	} while (0)
> +
> +#else /* !CONFIG_TRACEPOINTS */
> +static inline void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj) { }
> +#define do_trace_ref_final_put(obj) do { } while (0)
> +#endif
> +
> +#endif /* _LINUX_REF_TRACE_H */
> diff --git a/include/trace/events/ref_trace.h b/include/trace/events/ref_trace.h
> new file mode 100644
> index 000000000000..3bf1b1d390b8
> --- /dev/null
> +++ b/include/trace/events/ref_trace.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ref_trace
> +
> +#if !defined(_TRACE_REF_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_REF_TRACE_H
> +
> +#include <linux/tracepoint.h>
> +
> +/**
> + * ref_trace_final_put - trace when a reference count reaches zero
> + * @caller: return address of refcount
> + * function(refcount_sub_and_test, percpu_ref_put_many)
> + * @fn: refcounting function(eg refcount_sub_and_test)
> + * @obj: refcount object(struct percpu_ref, refcount_t)
> + *
> + * Tracepoint instrumentation can be added using the do_ref_trace_final_put
> + * macro defined in include/linux/ref_trace.h
> + * which uses _RET_IP_ and __func__ for caller and fn arguments respectively,
> + * thus only requiring obj arg to be supplied
> + */
> +TRACE_EVENT(ref_trace_final_put,
> +
> +	TP_PROTO(unsigned long caller, const char *fn, const void *obj),
> +
> +	TP_ARGS(caller, fn, obj),
> +
> +	TP_STRUCT__entry(
> +	__field(unsigned long, caller)
> +	__string(fn, fn)
> +	__field(const void *, obj)

The TP_STRUCT__entry is to be in structure format:

	TP_STRUCT__entry(
		__field(	unsigned long,		caller	)
		__field(	unsigned long,		ip	)
		__field(	const void *,		obj	)
> +	),

See how much better that looks and easier to read. Just like writing:

struct entry {
	unsigned long	caller;
	unsigned long	ip;
	const void	*obj;
};

	
> +
> +	TP_fast_assign(
> +	__entry->caller = caller;
> +	__assign_str(fn);
> +	__entry->obj = obj;

The code should be indented:

	TP_fast_assign(
		__entry->caller = caller;
		__entry->ip = ip;
		__entry->obj = obj;
> +	),

> +
> +	TP_printk("caller=%pS fn=%s obj=%p", (void *)__entry->caller, __get_str(fn), __entry->obj)

	TP_printk("caller=%pS fn=%pS obj=%p", ...

-- Steve

> +);
> +
> +#endif /* _TRACE_REF_TRACE_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/lib/Makefile b/lib/Makefile
> index f33a24bf1c19..41737090a95d 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -335,3 +335,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
>  obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
>  
>  subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
> +
> +obj-$(CONFIG_TRACEPOINTS) += ref_trace.o
> diff --git a/lib/ref_trace.c b/lib/ref_trace.c
> new file mode 100644
> index 000000000000..466647772ce1
> --- /dev/null
> +++ b/lib/ref_trace.c
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/ref_trace.h>
> +#include <linux/ref_trace.h>
> +
> +//Wrapper function for functions defined entirely in header files
> +void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj)
> +{
> +	trace_call__ref_trace_final_put(caller, fn, obj);
> +}
> +EXPORT_SYMBOL_GPL(do_ref_trace_final_put);
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(ref_trace_final_put);
> 


