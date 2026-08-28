Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31E2C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904BC6B0088; Fri, 28 Aug 2026 08:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4F46B008A; Fri, 28 Aug 2026 08:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3AD6B008C; Fri, 28 Aug 2026 08:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5296E6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:01:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D60CD80325
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:01:37 +0000 (UTC)
X-FDA: 85150538634.30.83BCD86
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4FA9E20013
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:01:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="L5TmUoS/";
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787918496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9wXHToe1gmitoaVCqOPNDibrRSsPosBSME08usIeV8=;
	b=WTHFeFKo6tP3Z49JtbZvKX92EKPfv9x+dZC+x1MxRmigNeTIY0KzA7gMkMixj3fvxoH/0V
	3WKM6CMqJnU1ER2ydFMdwZfx7v6x2BjOY4QaN4L8iFZBeyxNtW3FbmZArZxh22SQ46md9C
	pUlE6FNBfhxOBkoE2qXA9kK0VJNjZmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787918496;
	b=YplAgFu82oSdzLyVe1DJAKQ4iXW0+18eiXIHWo3eGQzzfy15s/jm/RxQ3ATxb+IsI8HR6x
	Ogaby65sMKbIZG44/RbrkNkZ5y1wZYqAwehNlRsDJFtAwAzKqBfXWBDqBe0tR0a0cwoaet
	iBg/E+oTgPcJ1q/N8LY9isflcGrt/f4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="L5TmUoS/";
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R9wXHToe1gmitoaVCqOPNDibrRSsPosBSME08usIeV8=; b=L5TmUoS/h6NcQt7ksRhkKNOjmU
	1mNZG8RevUyyo9OJGFPhIYDs4SNBWCw1yeMvtwBYu45/aGh++P23bSfG4TALzpHf1wZYEOgtjJKu3
	FnuSMmszW1YDYwAM7yMMkYMwQwbu0tIaaTQyt30PKrGtqn+k/2O64P/xn9KhfygUBVqPXI3gK1cuI
	UGvVEVIM+uHmQxG6FgRN57xNt7z4qG6VT2+cGzugYZXmthX9aGYBnTbjGD4JDoaWSsd1tvJ9klC/u
	U5orgAvm9MO/sumxlfI7Mjrku7EtjdWOZc4Jn1Poa1RuzKk7ltmTfO4q8F9/76umByaXI7rn9DEbu
	WjOeNx6w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzvGk-0000000Ee7g-2dXG;
	Fri, 28 Aug 2026 12:01:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B423930116A; Fri, 28 Aug 2026 14:01:13 +0200 (CEST)
Date: Fri, 28 Aug 2026 14:01:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828120113.GM687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-7-stevensd@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4FA9E20013
X-Stat-Signature: u9s1nwux1o5x454rkhbbe73kagoyusfk
X-HE-Tag: 1787918495-25598
X-HE-Meta: U2FsdGVkX1+oOEuDnJkDwrc4Xb1P/OQLiVH8YUnxA8hzSTGil1zvndWUCquM9REtZX39HhFgUmMVNyznnHYPegeJQ1T0fdtGyF5P+t8r1AmnBVwWzBNJnSaXHE4WwSaAdMRVxxYFxYhbd7OpYFFI8CNOxtq0+Xy+Lq7ydrfCV+zO7+DOGajmDxwOTY5MKXhfBP8qriTAJapCJSqdB0RZ0g4TvhEJMKXN3AqDqOLjR/pfPyyhgCxflUnPcwlFuO04CNeJIoHhIsER6B++ynYyWe9HM0szaqwsPhrEb4Ek20onZfukLyjx4dafLxejC0P2ikz8zEidPgOZ8thSnSr/ndt/SBaeR+z22TFQ0xZD/VgmqVoXCz/5vI8iSgK1+TDbv5qVxqSfiQOiXlPxgyNLsHImsSloKMWlWFI471GWz+dBmVeHpwVRojcMZh5hbsMH72hc2y/BPwdNWjXL+kQhPCXuODxN7U1Js0HDsjgz/wjWzKw9gKk8RntQCTuXyKfGJgm24Gk7v5zZ25o/Fr+0iuEqzqw3nSrcAxTrZ/lG+gDsdIoI24AowcZ3vyk5mS8w3j+4+2P6MmjlizURwn+awR6D9J0ilQ8JJ2Kytijtce6F0pEXwMZvelZ9UaPEXSUBe2B1DmzZZd4uctmm9VC8a7gXj7Bn69w/PLGIVk6dKAM3cvp9dvJ76vkxVmd1eX31UvgMIEehiWRT/eimUQgpyhUfbuZNfRjgEoCSqN87w4sExG9rvaO1BgIB98XkMijeEaCCZGwtG3ftGCF2Gt+5awbCpYNbWay9M02CQi68s9NRQeFPOolc/4mFoAjyM+loZ7GQ9ZoSwwR+8EAWp5hPxP9nb4GXO3m/6tuVCE+YuQ+wPkhie6MivRkNC7bbl+A/u7jJ+WJGcIiIWF4wshJ7PdW8rv6zcFape2BdoMfL73hbIScI/ElEPKcble9Fsaj61Z1/LiDfQ8kleb5JkFF
 SJgmjqGK
 SyXx9iJdV8UOiM030ysKM5LR6LOaUQ/BnB4lc8lcxpTFDZeJTmULDgl4dNOzRhByYMoPhhaj7coNzTeTnrChCL/MJ8xCH4iCHWLIRdzxZ2MTn/IEb+/gAOYxE8p2/KZ373cGtaTE99CxrqZ1Jij/koC+w/QnA42peD6s3XE/spnBT3Agfd1xdIfN77tTdi/lj+Rqq3ArnnN8xss4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> @@ -4295,8 +4296,6 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  		if (!ttwu_state_match(p, state, &success))
>  			break;
>  
> -		trace_sched_waking(p);
> -
>  		/*
>  		 * Ensure we load p->on_rq _after_ p->state, otherwise it would
>  		 * be possible to, falsely, observe p->on_rq == 0 and get stuck
> @@ -4320,8 +4319,18 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  		 * A similar smp_rmb() lives in __task_needs_rq_lock().
>  		 */
>  		smp_rmb();
> -		if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
> +		if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags)) {
> +			trace_sched_waking(p);
> +			break;
> +		}
> +
> +		if (!ensure_stack_is_present(p, &need_deferred_repopulate)) {
> +			WRITE_ONCE(p->__state, TASK_STACK_RECLAIM);
> +			do_deferred_repopulate_wake = need_deferred_repopulate;
>  			break;
> +		}
> +
> +		trace_sched_waking(p);
>  
>  		/*
>  		 * Ensure we load p->on_cpu _after_ p->on_rq, otherwise it would be

Don't move that tracepoint. That's simply lying about how long it takes
to wake up the task.

