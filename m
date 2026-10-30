Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BA3606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWS5bIXf
Received: by kanga.kvack.org (Postfix)
	id 902ED6B00EF; Fri, 30 Oct 2026 10:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3B16B05B1; Fri, 30 Oct 2026 10:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2406B05B4; Fri, 30 Oct 2026 10:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54DD36B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:25:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50C0DA0759
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:25:16 +0000 (UTC)
X-FDA: 85379515032.10.C7D956A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C66A4000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:25:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWS5bIXf;
	spf=pass (imf11.hostedemail.com: domain of "SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793370314;
	b=7l9inWczD1Crf+YjKtXyGK6W1n52KhWwZeMkZbyydcW5A/frgNxF6nptHA02UpF3YwhLm3
	1pvWdHLtu5cTMvChmsdQ62ij29DL6Zl5S44hIUOJMWXEbGhhoJrBBr8UKUF0gvlmwWdgfS
	CMmR48W1iL6siVMfQq7Sq1IUDik2MJo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWS5bIXf;
	spf=pass (imf11.hostedemail.com: domain of "SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793370314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGVaOZX62QNtOidP1MYg8O90e6ZEkAc58ZUQbuvc14s=;
	b=07uOiRV0eKWGUIW+J3XFDD2lyTaqD6KIL5BjFrqbGrumXaRKTOipdZpKq9GJ9HEsONF6zz
	kQH78GqaDJ0gMapiX/9ZNijfBePpYu4NrP1olyJ8Dr0a/N7EKFPU/7V3DKPRKoUzy2PhDL
	VwFw9BEPF9TQmfDCZ2nJrYt9u3hEnSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 604B943D52;
	Fri, 30 Oct 2026 14:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421151F000C1;
	Fri, 30 Oct 2026 14:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793370313;
	bh=MGVaOZX62QNtOidP1MYg8O90e6ZEkAc58ZUQbuvc14s=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=cWS5bIXf+XIXia3oxdZRWq1FVnFpwhazVkp3oVVMGaoANXG07Ye7QH2qS5pb2YUyn
	 KKM2yyWPJPGWbccST9ox3FJjRCAe+HvrXcFgBg+D5Gjj/KIS1ykcE3BQfoPdOdJqMS
	 3tlCu7KWhOGX8NP8XvQrtwoaG9SHsFelcn8py7/hhzv3cVGZsEvhLFvfPtSsrT15Nu
	 PlsSKdiS0eDRpZ0km2nbc5ApeFlQ9+UpP5H2HVYbxMOwYCyB/GTqmsHsVzBVmrbskn
	 23ViA0BWBg6rt72ijdGqWSot8hwSyQEbSQifOOsvs0QqC/k9WSi67tDxkUxrW7FIWl
	 ZHc4HfCXj/hAw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 0173DCE09CD; Fri, 30 Oct 2026 07:25:12 -0700 (PDT)
Date: Fri, 30 Oct 2026 07:25:12 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [BUG] KCSAN cannot find frame in stack trace
Message-ID: <35116d04-624a-4a5b-b586-b8cc43192d34@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <97f6213a-1dec-494e-96d1-abe546bce993@paulmck-laptop>
 <auRWcyCJehRIi287@elver.google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auRWcyCJehRIi287@elver.google.com>
X-Stat-Signature: txqyx9fr1nbbxo6yjy6am4h6tkyt1a6p
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C66A4000B
X-Rspam-User: 
X-HE-Tag: 1793370314-979197
X-HE-Meta: U2FsdGVkX1/weSpCvkTY2Uimb1nCmUzLM8OixBSELrmSTNt00h+tLjq1KfAG1Elsa36BewwLiATieTM0dlNj5IarSMaa30+TNBKaKskyNRwxDAyKalAZr2s/kyI/oP/MlyKPZkErZkyIkCTEA8yYGyaIKMiOEFqlCGAZc9ASot/6CrHVPVQVzMzSCHkElLcOAfJt2hE7x15M1wceN5gJW5mtfL2l+CPDLqe6lDwpuUXbH49VwuipRYT7kWOiiPZe2gXPur5sSHGce/6qmzJxIlLjuVQ3VFUbIzfwLdiuK/ZxfCaKRhxLiSKaojUwMd/aHenlDZtCjuYW79feiaOnGb2y1hP0FHn7x1b1riGcQNEsV9rOcHzzEYpH26gHFag4E/JuzXG75Fd35HjL89upgrsw0X1VLQi4H2/RNF1nJeK5r/iNipooHOldhI65ih1gl2/ebwLw0dVrMJRzDigjXvckhZ5xaNfqmLRMZySBXFpDMh788ta0/Pomoh3up7O8BsfFsN38sPZdQ5E5ii6QrCKxP6XRw6CB3SWqJFYZvURfFxhoXr8MdSn2/2jbmtfFviNTwuypTcIpQboHXCUTxKNmm1vRaZW7/8SgBxkYgrEB+jfiEvIUpV26cxtLG+6EVhmGZExduONU/umOO3McrkDbr6McEMhQe9zyw6L0LB8tcf/ic8T1PX2h/flm4EqR2Q7QAnrbA2MNPQJQtZ3Za/Vexhi5AfU6dNvc0HlpiGogz3I82qUOtIJw+UZdu63VXK7q/DQcQ0vW9m44w5ucZnsXI03fGmXW/MGIlNnn8Mkz/IC5oFaRkuE+hs1OdRJjpEb49MpOUVUs5qM/i7QHZoal60l4g1Ha55akdaIFIb/X/CGtj9Q2J15K3tM2rxraiqWPZet5JHyHv1U9ReMIoxTMzMoe6n8koD+U074X8CKjTUiAUXfDc6kunSjrP5UYvCtK4/oCt3jjEWdPzrw
 WBb3Idlv
 uQozA5fj4L7S3ZpzX11sNEZiC7Vv6ATqM/MkJVzkBc8IX8b5HTreEY2YVqU+jDGTiwxMc31PVHuKUr8cMqSHOyg/TAb/RJzPUfJBIa9ANgmkWR1tn4oAKx6rwzbe0dmTvD7oXgJ9dkE0G8eL7QnwKmJYsMJbkOx3qye5JmLYP9tBHgiea/jSQCU7+UeCiDhi0v59P+4kqd/a3/XJQxT5WRV7z93Pm9rh7IoVgQ8x4mMO8M+mmzn4XY/FVuvzi/YffI56e1YCFZHlN46R6TKPD7y7I2o4/jlIb6A11a2I8WryHeZfrU+zbN6lK6PPU8uTjNzmpQWOzi92YY4Ky4V0GQaxk9w9srQQOdNWjXQlAeJg2r36j5xaMedxMReSJJnNZKa4CqifAn0Tt7eZRDVhUz/LSaN4Sf/B9lY/LFbGU/2Mou7ROegs2XZB2a4A2JenTPvnEgnPabPCVYkOv+veFBsFnXolT1xSWiE2CGRvtCcvZLkT7wH0UOQjtVxU7rgYtXOzcONjDsnUeyqnnMjLYNhN9lYwlURazZtgvR8wea0TQZ2bbGfnmjoouw4hyerzN6xts0yL9Hd5fwJVYCMz53uKldSX7yZlPGvm9mKX3OR9n9beZU2hpvGuxctQ9HcYkyPB4a0RDXRTfj4NNy5QBAh0Bv+xmwH6ERrA8p0RWRGQCpQh/x0ZpVWVnu7kxkKvt6VTxhjp0b+IiB76DR8AsR7RuKTsZ2KV4IiVHr5s88atcTuU0Zf6b2M5Swr3ApVCflnAFjScenQO9eyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 08:33:55AM +0000, Marco Elver wrote:
> On Thu, Oct 29, 2026 at 05:10PM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > I am seeing the following (very) intermittent spat when running
> > the rcutorture script torture.sh on recent -next (starting about
> > next-20261014) with KCSAN enabled:
> 
> I think there's no reason why this should happen more often. Maybe the
> torture testing or your system became better at exposing this?

Quite possibly.  An effective test suite never stands still.  ;-)

> [...]
> > This is the code at line 344 of kernel/kcsan/report.c:
> > 
> > 	/* Should not happen; the resulting stack trace is likely misleading. */
> > 	WARN_ONCE(1, "Cannot find frame for %pS in stack trace", (void *)ip);
> > 
> > This does not happen often enough for reasonable bisection.  However, the
> > alleged fix below does seem to prevent this from happening.  This alleged
> > fix should of course be considered to be part of the bug report: I am
> > *not* claiming that it is a proper fix.
> > 
> > The diagnosis sounds plausible to me, but perhaps not to those who
> > understand the affected code better than I do.  And I don't know why
> > this wouldn't have been showing up earlier.
> > 
> > Thoughts?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > LLM alleged fix:
> > ------------------------------------------------------------------------
> > 
> > kcsan: reset per-task KCSAN state in dup_task_struct
> 
> Yes, it's very plausible and the stack-trace and WARN all line up.

Whew!!!

> We don't need to reset kcsan_save_irqtrace as that's guaranteed to be
> overwritten before reading out again.
> 
> Updated fix below; it's basically identical, except for
> kcsan_save_irqtrace. Let me know if I can either add your
> SOB+Co-authored-by, or you send it out as a PATCH yourself.

Please do send it out.  A Reported-by will more than suffice.  It is
not like I put any of my own effort into that patch.  ;-)

But if (and only if) your procedures absolutely require it:

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

							Thanx, Paul

> Thanks,
> -- Marco
> 
> ------ >8 ------
> 
> From: Marco Elver <elver@google.com>
> Date: Fri, 30 Oct 2026 00:46:03 +0000
> Subject: [PATCH] kcsan: Reset per-task KCSAN state on fork
> 
> arch_dup_task_struct() copies the parent's task_struct verbatim, which
> includes kcsan_ctx and kcsan_stack_depth; nothing reinitializes them for
> the child.
> 
> With CONFIG_KCSAN_WEAK_MEMORY this leaks a live reorder_access: an
> access whose simulated reordering is only valid until the parent returns
> from the frame that performed it (tracked via kcsan_stack_depth and
> cleared by __tsan_func_exit()). The child inherits both the entry and
> the parent's stack depth, but never returns through the parent's frames,
> so the entry is never invalidated and is replayed on every subsequent
> check_access() of the child.
> 
> The most direct way to hit this is the copy itself: __tsan_memcpy()
> runs check_access() on the destination before copying. If that access is
> selected for a watchpoint, set_reorder_access() records it (ptr = the
> child's task_struct, ip in arch_dup_task_struct()) in the parent's ctx,
> and the memcpy then copies that entry into the child. For an idle task
> created by fork_idle(), the stale access covers thread_info.flags, which
> other CPUs frequently access, resulting in false positive reports and:
> 
>   WARNING: kernel/kcsan/report.c:344 at sanitize_stack_entries+0x120/0x12c
>   Cannot find frame for arch_dup_task_struct+0x40/0x154 in stack trace
>   ...
>   Call trace:
>    sanitize_stack_entries+0x120/0x12c (P)
>    print_report+0x84/0x488
>    kcsan_report_known_origin+0x14c/0x1ec
>    kcsan_setup_watchpoint+0x578/0x864
>    __kcsan_check_access+0x1ec/0x1f8
>    do_raw_spin_lock+0xa4/0x1c4
>    _raw_spin_lock+0x70/0x88
>    rcutree_report_cpu_starting+0x1ac/0x4b8
>    secondary_start_kernel+0xe8/0x28c
>    __secondary_switched+0xc0/0xc4
> 
> Reset the child's KCSAN state in dup_task_struct() after the copy,
> alongside the existing kcov/kmsan initializers.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Link: https://lore.kernel.org/all/97f6213a-1dec-494e-96d1-abe546bce993@paulmck-laptop/
> Fixes: 69562e4983d9 ("kcsan: Add core support for a subset of weak memory modeling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  include/linux/kcsan.h | 10 ++++++++++
>  kernel/fork.c         |  2 ++
>  kernel/kcsan/core.c   | 16 ++++++++++++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/kcsan.h b/include/linux/kcsan.h
> index c07c71f5ba4f..c7e9d15dd7bd 100644
> --- a/include/linux/kcsan.h
> +++ b/include/linux/kcsan.h
> @@ -13,6 +13,8 @@
>  #include <linux/kcsan-checks.h>
>  #include <linux/types.h>
>  
> +struct task_struct;
> +
>  #ifdef CONFIG_KCSAN
>  
>  /*
> @@ -66,9 +68,17 @@ struct kcsan_ctx {
>   */
>  void kcsan_init(void);
>  
> +/**
> + * kcsan_task_init - initialize KCSAN state of a new task
> + *
> + * @task: task to initialize; must have been copied from its parent already.
> + */
> +void kcsan_task_init(struct task_struct *task);
> +
>  #else /* CONFIG_KCSAN */
>  
>  static inline void kcsan_init(void)			{ }
> +static inline void kcsan_task_init(struct task_struct *task) { }
>  
>  #endif /* CONFIG_KCSAN */
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5ef413368912..62a096ca8dce 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -93,6 +93,7 @@
>  #include <linux/compiler.h>
>  #include <linux/sysctl.h>
>  #include <linux/kcov.h>
> +#include <linux/kcsan.h>
>  #include <linux/livepatch.h>
>  #include <linux/thread_info.h>
>  #include <linux/kstack_erase.h>
> @@ -986,6 +987,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  
>  	kcov_task_init(tsk);
>  	kmsan_task_create(tsk);
> +	kcsan_task_init(tsk);
>  	kmap_local_fork(tsk);
>  
>  #ifdef CONFIG_FAULT_INJECTION
> diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
> index a3aa5e5b039d..d19d60ad007a 100644
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -828,6 +828,22 @@ void __init kcsan_init(void)
>  	}
>  }
>  
> +void kcsan_task_init(struct task_struct *task)
> +{
> +	/*
> +	 * arch_dup_task_struct() copies the parent's kcsan_ctx verbatim,
> +	 * including a reorder_access that is still live in the parent's frame
> +	 * (e.g. the write of the copy itself). The child never returns through
> +	 * that frame, so it would replay the stale access indefinitely, causing
> +	 * false positives and "Cannot find frame" warnings in replace_stack_entry().
> +	 */
> +	memset(&task->kcsan_ctx, 0, sizeof(task->kcsan_ctx));
> +	task->kcsan_ctx.scoped_accesses = (struct list_head){ LIST_POISON1, NULL };
> +#ifdef CONFIG_KCSAN_WEAK_MEMORY
> +	task->kcsan_stack_depth = 0;
> +#endif
> +}
> +
>  /* === Exported interface =================================================== */
>  
>  void kcsan_disable_current(void)
> -- 
> 2.56.0.317.g454f8302e1-goog
> 

