Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A7EC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33446B008A; Mon, 27 Jul 2026 16:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A576B008C; Mon, 27 Jul 2026 16:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E479B6B0093; Mon, 27 Jul 2026 16:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B98946B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:27:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48E281C01F0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:27:23 +0000 (UTC)
X-FDA: 85035691566.14.472E7A7
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf09.hostedemail.com (Postfix) with ESMTP id 75E7214000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:27:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785184041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHYgk+6FaDxYOABh1H/05Q4WkbqQ5Pa2jWChEiITzT0=;
	b=wby46YCjTVni0fyeEyLrcPLrV5NOjYzusf5UTS+DI/BZLlO48z5i6ANLmloauzgpCcjQxl
	iRzPAoGLPfSKjrp1VCn2SrBGy7Pf9ef+FRekhj6+uBBynuwrY/vOkTN0Ly/YXqIP2NmKWj
	Yl9pMdsUKD2MVRQ8nzSz+qCc4L7TiZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785184041;
	b=jplu0TAHllbe4eG4su6lZrt8/wjwRrLrEBtvbq2rpEvNE3fLXQ1UdxQh7A2HG65hVQ+rKe
	WqlgTYygVVXsMya4xrwrJjeFu0WjbU6vyX1/rJicqXe4DNUeN3PrxVMn8/t8oCbAQGfy8G
	FUIj+UL4Nfxr7tTaEJJZsjXhFUwLuWs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	none
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A4E5401D5;
	Mon, 27 Jul 2026 20:27:19 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 7558A20029;
	Mon, 27 Jul 2026 20:27:16 +0000 (UTC)
Date: Mon, 27 Jul 2026 16:27:43 -0400
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
Subject: Re: [PATCH v3 2/5] refcount: add ref_trace_final_put tracepoint
Message-ID: <20260727162743.55ca2d14@gandalf.local.home>
In-Reply-To: <20260711-refcount-final-put-trace-v3-2-674c8f03d9f9@mavick.dev>
References: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
	<20260711-refcount-final-put-trace-v3-2-674c8f03d9f9@mavick.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19ZftNc9YOHVOuzN2od2wsTbU1P+xcBgB0=
X-HE-Meta: U2FsdGVkX1+NcYwiz6LsYobSPrRXvfmEsFQv7lCJ6wYiQ7Pw576BKNSNm8O3ULvb9YsMRNqhg+hr4tW7DcySZFQShCheBv7n4x4e94nBQ769pK8Mwcqn5gwkMRLZy2gxEtJjRXxgVjqn9UyvDwp1OvFskmjSxOQ6SuWhaySb/txyK//mMO2ipdnM2y6661+cgFSONAlzsn/FwOLv3EMhIxOwKnScb4TrOOqbcDLu1BuK6FWk4Q6sScV7nTgXtMp60OnVJbsXrNHH/UX8S9H/iQQTVlwS761IQwmLX54GhNg+d1Z7xJvKWNE0zi7GXNZh
X-Rspamd-Queue-Id: 75E7214000D
X-Stat-Signature: 77f5hjgk3wcfxpc6ett3pueof6jrewsi
X-Rspam-User: 
X-HE-Tag-Orig: 1785184036-372918
X-Rspamd-Server: rspam02
X-HE-Tag: 1785184041-476988
X-HE-Meta: U2FsdGVkX1+e2S6IkoN1HCpz6wgjfjeQb+5rCBSOfqSvUPg+4sJhxpU/aS/4LlIrpbC2kyl/med4n1e1JwSGD+uKXKKs9dKlyWdFQqs06zZtnh53zXIFZKV3oI195l8werIsdeDIMa2L8EolKENgxUQ39sTlAg5UoM3esmaVmIFcRKJwJilRNpPyYB00PebAV3bgiSaA3+sWyIogr33wKoyaBWYwLLb4f9kuNiKQORHDtLnkvyF/4bAyecKAkJybCVO+K9fPswt2DlBJORLC1DT2e628N26kvvmdzcIIwNaCjPsbbg/FxFPescrm/oPPNoBOr2ZMjpmvG4W6mWgvkYE7qqaIjBCT+kzLeLMlpMI1F3VSOYMbRSDOBNiskRXmsKKZ5Bg8jKWQX9g6CJOoP9rz0AJi+7AR4M0NxZzdzD78vfJSNMq3OO9OmKOgDqRr5lGaIWTGYUspPeuID39mQpTI+DHr2JKLl1xQjDsH6T0btwcwK+6qhJvU5es4tCS9CAO+u1xLN6EbWl9/3ZpvdUeeZNSOlZcJPSUyQmKGyEiaFSV0n/nlRphGck3rXhhHqCzFYIXPAQqvWnFdvSL7vDLODQMUqJzLVSGA92LLKth4H6vSNe43cCO0yEjWYyTg7bgHTTzjf2mdDcV6hfgYxrv6jZ1kMzATPYFQxTP5tTf7Egl3SYjDv40sa4/ExJbSYpY98UbrJ+TcR3A1I3tDDZnBICgk2Xo7jhLwGtFrLWO0riiZouFK92hdY8GruSkHh4lswmTvk2iij/52wDQfIbKl6F7DO+9QDKExRYJhAL0zTAdVMESoJP0RtrvFskongZJ4/Y87JoSJ3biGLNTjzZNT0ycp5Ag17fii67TWZRqxgIirUd4JJVGziN8ILR7XPGTgHsy/uRlREwnD+9WkKPkVhcGMU6yo/I1WZj3QTKBhdDT2G2o7u/EnZsLLw1jMNg1ilVdc6jjzGGU/fIn
 aMnU6Eg9
 HvAo5FlX2JKmnlVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Jul 2026 12:40:20 +0800
Eugene Mavick <m@mavick.dev> wrote:

> Add the ref_trace_final_put tracepoint to __refcount_sub_and_test() and
> refcount_dec_if_one()
> 
> This tracepoint fires when a refcount_t reaches zero, capturing the caller
> address, the function name, and the refcount_t address.
> 
> Signed-off-by: Eugene Mavick <m@mavick.dev>
> ---
>  include/linux/refcount.h | 2 ++
>  lib/refcount.c           | 8 +++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index ba7657ced281..70d07a462da1 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -107,6 +107,7 @@
>  #include <linux/limits.h>
>  #include <linux/refcount_types.h>
>  #include <linux/spinlock_types.h>
> +#include <linux/ref_trace.h>
>  
>  struct mutex;
>  
> @@ -393,6 +394,7 @@ bool __refcount_sub_and_test(int i, refcount_t *r, int *oldp)
>  
>  	if (old > 0 && old == i) {
>  		smp_acquire__after_ctrl_dep();
> +		do_trace_ref_final_put(r);
>  		return true;
>  	}
>  
> diff --git a/lib/refcount.c b/lib/refcount.c
> index a207a8f22b3c..cd7e32df3919 100644
> --- a/lib/refcount.c
> +++ b/lib/refcount.c
> @@ -7,6 +7,7 @@
>  #include <linux/refcount.h>
>  #include <linux/spinlock.h>
>  #include <linux/bug.h>
> +#include <linux/ref_trace.h>
>  
>  #define REFCOUNT_WARN(str)	WARN_ONCE(1, "refcount_t: " str ".\n")
>  
> @@ -56,7 +57,12 @@ bool refcount_dec_if_one(refcount_t *r)
>  {
>  	int val = 1;
>  
> -	return atomic_try_cmpxchg_release(&r->refs, &val, 0);
> +	bool ret = atomic_try_cmpxchg_release(&r->refs, &val, 0);
> +
> +	if (ret)
> +		do_trace_ref_final_put(r);
> +
> +	return ret;

Tracing should avoid adding any open conditionals. This is in the fast
path. No need to add an if statement that is only used when tracing is
enabled.

You can create another macro:

	do_trace_ref_final_put_cond(ret, r);

And have that defined as:

#define do_trace_ref_final_put_cond(cond, obj)					\
	do {									\
		if (tracepoint_enabled(ref_trace_final_put)) {			\
			if (cond)						\
				do_ref_trace_final_put(_RET_IP_, __func__, obj);\
		}								\
	} while (0)

That way the conditional is only checked if tracing is enabled.

-- Steve

>  }
>  EXPORT_SYMBOL(refcount_dec_if_one);
>  
> 


