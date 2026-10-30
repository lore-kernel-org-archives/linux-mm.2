Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6D1606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eImVZmLs
Received: by kanga.kvack.org (Postfix)
	id 545286B00EF; Fri, 30 Oct 2026 04:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5796B05B1; Fri, 30 Oct 2026 04:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4256B05B3; Fri, 30 Oct 2026 04:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 165FE6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:34:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F33641605F7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:34:04 +0000 (UTC)
X-FDA: 85378630008.07.0AA4FA8
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0731620008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:34:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eImVZmLs;
	spf=pass (imf31.hostedemail.com: domain of elver@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793349243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OaDrDItNm4hikv/Q3sLJs60ByZn6DMzU1f9WMqSeQ8k=;
	b=RMcJ5MJnMvHtpjhyAe+gSfjWOiGPdfd8v+xQ5HGqVHVAocnvPS16gFOqF1IsTyKbYMDN6o
	G2ALzoy/GGZHltmc2TSWEA0OTyAD7fZeVNyd+ZZjYEnJMOA1ZRXnIZkbUzUEgs4JAhkjuP
	0zFNqYVLWbce+29AuEs1oHLn1uQt7Ss=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eImVZmLs;
	spf=pass (imf31.hostedemail.com: domain of elver@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793349243;
	b=hOZJiHPHITIZf6vRWEEGvuINZuUfxsl8qw+JK1vv2MU7lN9kfSK7PcSaYM3OX+MmFvDtjz
	FezoZn/V3U1hNjuJDTX6dldcUxH/ZfXG32DqqfN9mRnzP+AINjC17QgLwqgUTJcKx2/3IK
	eGxdeLY0GNIeCmo2C9RTxrjVv7nj14w=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so2150995e9.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793349242; x=1793954042; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OaDrDItNm4hikv/Q3sLJs60ByZn6DMzU1f9WMqSeQ8k=;
        b=eImVZmLspomc+XJsumEgG8Qh9GVBPEgmA2lbBBp7vk9XjmXndFSdazoJ8L+ETakD95
         /qREQugTdg2sm4L724EwIzVsGceY9lbdVQlKwD8/pJL4y0FrqjTJ4BQOPP1ZKqkRnWtQ
         7bbFlt1SjGre3FkgH1Nkc+6OWSmNayMc14wnKcM7hguT8jK5Vd2tCCNlPFaeJWDXcO1L
         srdN5b45Ietl6XBD/Tg6m97Nh3Amer3KLalx7xh0msMlxKVGvYs9ULD5vZggSMUSJDm+
         Be3xwhV3K/UZOb9QRjE/1Q9l44QZeOh8q00Xw9/NKUTXvam4DPgLQNaLsIuDPZASYQYU
         3N9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349242; x=1793954042;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OaDrDItNm4hikv/Q3sLJs60ByZn6DMzU1f9WMqSeQ8k=;
        b=GP0Y/60f39vb8syn/ZiwZqJerpn7LQRpoKkxVHsT2AhL57gC/dMLikw5Jvb5c1AhEM
         W1T9pFKtK3XjBHoP4msU7IXehrc+SkQ/ZwnM7yvRnaBh0W/VvOHVOAESF/YunHGZseUf
         G/A93jNl033cCkFXJwyRjC4C+sllrwMPgdqJ5/HYFkVXdSKh2Snw6svYW5OCNjE3RECZ
         +51iZiI7mXzrQLa7pZxYRUmpjKkTgz0LQVpc6oMKJq4WQFXhvlIo6UEt6qOyw6p1Mdnt
         i1PjCUQLhGVj5W/xCwKIr2/INiUiJXSDikCoA7SnC3r1ftQWz/S43Em0gDrjFUN1h8Bf
         qjcw==
X-Forwarded-Encrypted: i=1; AKwUvBx4hUL7CSVlaud0sAG00knPyzajKUy2AtUWxNngn/JEZ27aJbrjfYijZ+NBDGhB1uHOD1rcKwDqow==@kvack.org
X-Gm-Message-State: AFq9FYJLpdEiWryy7mfHfV8Fl5x6AvhaMVHr/ua8JXUA7umoCWu6vJoS
	nHyRXy/T+Afbnn0lVN3juVoSCCUnx7WTR1RdA5d4tfJSzraGg2/tAZ9RWgmlq9XsQw==
X-Gm-Gg: AYBFou3APoRXSdI8TZfaj3/MhS28ryt0caRJcbTeUUNCGByK80qrZE2IoEpYgTPQsIe
	KT2SWeC0j6gkBGz75BRs5dbCf5x/oa7CFnp8YTLd0lflbWw9J3obV6X6Upusw8LST0exA7btFFH
	NialnWGV3EsjlPxIrY4vxbMZQ4uLNyxI1My0a/7sKTJmsQeyly1pHQqdSwCFOYdjFdNDI7yrObZ
	PfihygvHQ8AF9F8YWsMeGUxGVKdzCeaasXpXT21qq/LTCv/H/O57m8BTWnG33SEHYo5zol1avSb
	utEspO7rtqlgwoRNY/OwNiGs64RgvA6892qyi51lcfsRNphpQ70kEsFdEN7keodOEck0ibJkLr8
	xt9EomyssHuO4O3rP+Sjop+75hBuG5H0E5mQ/kutFmN8OwqeNXrs7wSWZWJcgv3ofe/m42om7cP
	t62NxtmmkzjG/lwInwIr7OS/WrX5FVkg1qYIGG1KyS6llFUYcT1rdsSiBdanGwa8XJyGFEX0pCW
	/SKE5TuWeQE2LF/WkvjUu+yES57NAhjnxtZAHxDwzuL+xTCBkFVoPQ8vsT9R3ck/5BLXoFrRe0P
	cJAUVnYaJuOpo5rHX/98F4D9xyAWVEoYHlABn+tS2X4suDp1cBNtXU/WKuAL5De1e9QUx6CwV8w
	=
X-Received: by 2002:a05:600c:3144:b0:4a1:acaa:c355 with SMTP id 5b1f17b1804b1-4ac17ffb31cmr29522575e9.10.1793349240969;
        Fri, 30 Oct 2026 01:34:00 -0700 (PDT)
Received: from elver.google.com (124.100.205.35.bc.googleusercontent.com. [35.205.100.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723bfsm1906153f8f.15.2026.10.30.01.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:33:59 -0700 (PDT)
Date: Fri, 30 Oct 2026 08:33:55 +0000
From: Marco Elver <elver@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Message-ID: <auRWcyCJehRIi287@elver.google.com>
References: <97f6213a-1dec-494e-96d1-abe546bce993@paulmck-laptop>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97f6213a-1dec-494e-96d1-abe546bce993@paulmck-laptop>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0731620008
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: m4i5rcu4cckfshs5cpq8xh8phg5jwoiz
X-HE-Tag: 1793349243-609685
X-HE-Meta: U2FsdGVkX199v81bz1D047rXire4YfiZFwcHW/hmCv6wmG5FZfCIWKw2tE9nQObdFY5Lt8pAjyIcUVg38YsFY4MDCcifQd55eBMByktCHSILoCYukQUS279LcqHRNE8AL4LVBqzY1jkMy8YGgPMQUIBze60BsQnSyPQeOWJ7i9sCtII1YTJTmm7yl6kNayXTO4axLBmiYT1iz5M1USp6SUZE5hvEzfTqFuTR1HvFQ6h/9NA2hK6vzl3Yg0rDd4BnYcXD2Y298kQPV3Gr0el+4IO8rV4DpzqZqfGltcedLNHZGWa5LEpPOi2B69YOnqF7qxfDHzMPoeQetwY6CGDqxzQXOc88NVibUsbXv7Ww8ZyV95Z6EygftzJc7HxYEaA0ZSWZWenqk+6dr5yEeC2rgEYrzY7W5Q6W8Hf5hJKjDqzSLUS7MKEsiSOABGJNFuj/54yGCWg1rWml/u++4oAS/eM1oBISSgtMLUxz7xgzXGjlVucbrRKTUtD6F/XpMpPDf04ApNAA8gFUS6KzjhU1f5nzAFf9xoyrgvpfSXKsy50bc2Ioqip0u+f9q1tHUMtlyfPf7yizGbsICEGNktEu3lYR4TL0zoMe0uab1QFuKXGTBQ5sc1m4iEFXHKWdBTzhOfMbVx4ikX2HzkPhUO9NE6zzs1Pz0ekkZDRKW3OVGwNqmt3scVNE/ZTZ3BV/Ctb2CXr8RhPveM1gBw0dPMWtRncTwynwCXyZALWDgNqzWdu1eNIrVS80sR3S+0DAjqZOciu5ha72/umiv1b0RYfg7kya5e/h3yxZ0A15ORcjYyaoYt7INRRaR88w6S/plzXa3SMEZDRfY3/D0C2kuyopqY7U/2TvUBal7cFhdBVFtAbpsNNeZwIDN2jodX4XzFDk9yu1PjbRYi2rHdViJ7QYQ9LJmwpvb0VUbNenyVRwnyMdTvDQ1/KSPZRuFdv58qWbltTVITB198vDsaOeMAL
 c9IIhasN
 rmPYnHCL0yJJIYAPa8wMvp9QmQ0maEBSk/KyG+lRPMuVL+TxjCoBSii7a12WaFUIbzxjKpZ3Zt3Q1Or0qPTTf9/MaLqa/myGODuAtB46kCRdfXg63mui5is8wTknecoMvRkUdIwbFd6kHFhgQPprqNfbW6Fj9P/2EwU4oKYdZRxjVZ3sEfoZeW6RWlcJapV/aJ720KXsDpeq3kcR/3ex9SJ1JI5PM07BMsH3jLc0xUXK+MwutOAemIteQs73+1RBqf3qvbkmqzr0vOV7wfed9pGuLSfF2DHC1Gg5zivEXbkjpkcpSceyWGKgfsl0Wg2LNcYk57yuqJHPF8RRXqUrJWzjd4rOXPXu0EVLlfq/dqH9LpxjIK0svURdKxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:10PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> I am seeing the following (very) intermittent spat when running
> the rcutorture script torture.sh on recent -next (starting about
> next-20261014) with KCSAN enabled:

I think there's no reason why this should happen more often. Maybe the
torture testing or your system became better at exposing this?

[...]
> This is the code at line 344 of kernel/kcsan/report.c:
> 
> 	/* Should not happen; the resulting stack trace is likely misleading. */
> 	WARN_ONCE(1, "Cannot find frame for %pS in stack trace", (void *)ip);
> 
> This does not happen often enough for reasonable bisection.  However, the
> alleged fix below does seem to prevent this from happening.  This alleged
> fix should of course be considered to be part of the bug report: I am
> *not* claiming that it is a proper fix.
> 
> The diagnosis sounds plausible to me, but perhaps not to those who
> understand the affected code better than I do.  And I don't know why
> this wouldn't have been showing up earlier.
> 
> Thoughts?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> LLM alleged fix:
> ------------------------------------------------------------------------
> 
> kcsan: reset per-task KCSAN state in dup_task_struct

Yes, it's very plausible and the stack-trace and WARN all line up.

We don't need to reset kcsan_save_irqtrace as that's guaranteed to be
overwritten before reading out again.

Updated fix below; it's basically identical, except for
kcsan_save_irqtrace. Let me know if I can either add your
SOB+Co-authored-by, or you send it out as a PATCH yourself.

Thanks,
-- Marco

------ >8 ------

From: Marco Elver <elver@google.com>
Date: Fri, 30 Oct 2026 00:46:03 +0000
Subject: [PATCH] kcsan: Reset per-task KCSAN state on fork

arch_dup_task_struct() copies the parent's task_struct verbatim, which
includes kcsan_ctx and kcsan_stack_depth; nothing reinitializes them for
the child.

With CONFIG_KCSAN_WEAK_MEMORY this leaks a live reorder_access: an
access whose simulated reordering is only valid until the parent returns
from the frame that performed it (tracked via kcsan_stack_depth and
cleared by __tsan_func_exit()). The child inherits both the entry and
the parent's stack depth, but never returns through the parent's frames,
so the entry is never invalidated and is replayed on every subsequent
check_access() of the child.

The most direct way to hit this is the copy itself: __tsan_memcpy()
runs check_access() on the destination before copying. If that access is
selected for a watchpoint, set_reorder_access() records it (ptr = the
child's task_struct, ip in arch_dup_task_struct()) in the parent's ctx,
and the memcpy then copies that entry into the child. For an idle task
created by fork_idle(), the stale access covers thread_info.flags, which
other CPUs frequently access, resulting in false positive reports and:

  WARNING: kernel/kcsan/report.c:344 at sanitize_stack_entries+0x120/0x12c
  Cannot find frame for arch_dup_task_struct+0x40/0x154 in stack trace
  ...
  Call trace:
   sanitize_stack_entries+0x120/0x12c (P)
   print_report+0x84/0x488
   kcsan_report_known_origin+0x14c/0x1ec
   kcsan_setup_watchpoint+0x578/0x864
   __kcsan_check_access+0x1ec/0x1f8
   do_raw_spin_lock+0xa4/0x1c4
   _raw_spin_lock+0x70/0x88
   rcutree_report_cpu_starting+0x1ac/0x4b8
   secondary_start_kernel+0xe8/0x28c
   __secondary_switched+0xc0/0xc4

Reset the child's KCSAN state in dup_task_struct() after the copy,
alongside the existing kcov/kmsan initializers.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/all/97f6213a-1dec-494e-96d1-abe546bce993@paulmck-laptop/
Fixes: 69562e4983d9 ("kcsan: Add core support for a subset of weak memory modeling")
Cc: stable@vger.kernel.org
Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/kcsan.h | 10 ++++++++++
 kernel/fork.c         |  2 ++
 kernel/kcsan/core.c   | 16 ++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/linux/kcsan.h b/include/linux/kcsan.h
index c07c71f5ba4f..c7e9d15dd7bd 100644
--- a/include/linux/kcsan.h
+++ b/include/linux/kcsan.h
@@ -13,6 +13,8 @@
 #include <linux/kcsan-checks.h>
 #include <linux/types.h>
 
+struct task_struct;
+
 #ifdef CONFIG_KCSAN
 
 /*
@@ -66,9 +68,17 @@ struct kcsan_ctx {
  */
 void kcsan_init(void);
 
+/**
+ * kcsan_task_init - initialize KCSAN state of a new task
+ *
+ * @task: task to initialize; must have been copied from its parent already.
+ */
+void kcsan_task_init(struct task_struct *task);
+
 #else /* CONFIG_KCSAN */
 
 static inline void kcsan_init(void)			{ }
+static inline void kcsan_task_init(struct task_struct *task) { }
 
 #endif /* CONFIG_KCSAN */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 5ef413368912..62a096ca8dce 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -93,6 +93,7 @@
 #include <linux/compiler.h>
 #include <linux/sysctl.h>
 #include <linux/kcov.h>
+#include <linux/kcsan.h>
 #include <linux/livepatch.h>
 #include <linux/thread_info.h>
 #include <linux/kstack_erase.h>
@@ -986,6 +987,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 	kcov_task_init(tsk);
 	kmsan_task_create(tsk);
+	kcsan_task_init(tsk);
 	kmap_local_fork(tsk);
 
 #ifdef CONFIG_FAULT_INJECTION
diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index a3aa5e5b039d..d19d60ad007a 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -828,6 +828,22 @@ void __init kcsan_init(void)
 	}
 }
 
+void kcsan_task_init(struct task_struct *task)
+{
+	/*
+	 * arch_dup_task_struct() copies the parent's kcsan_ctx verbatim,
+	 * including a reorder_access that is still live in the parent's frame
+	 * (e.g. the write of the copy itself). The child never returns through
+	 * that frame, so it would replay the stale access indefinitely, causing
+	 * false positives and "Cannot find frame" warnings in replace_stack_entry().
+	 */
+	memset(&task->kcsan_ctx, 0, sizeof(task->kcsan_ctx));
+	task->kcsan_ctx.scoped_accesses = (struct list_head){ LIST_POISON1, NULL };
+#ifdef CONFIG_KCSAN_WEAK_MEMORY
+	task->kcsan_stack_depth = 0;
+#endif
+}
+
 /* === Exported interface =================================================== */
 
 void kcsan_disable_current(void)
-- 
2.56.0.317.g454f8302e1-goog


