Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BE6606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYqPx/9P
Received: by kanga.kvack.org (Postfix)
	id 714AE6B05B4; Wed, 28 Oct 2026 12:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6026B05B5; Wed, 28 Oct 2026 12:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC106B05B6; Wed, 28 Oct 2026 12:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC0E6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:35:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9B1AA6FB8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:35:11 +0000 (UTC)
X-FDA: 85372584822.22.7727EBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F17CC140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:35:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JYqPx/9P";
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793205310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6pcBVxdMQUwjf02KaU8qkuRRIgCQzwBtXV/ZrkSdNU=;
	b=yipd2xpV/gB3y5L4frYCBd4MxvNib4uxq79DSAKrCQOXLRmGHMOQLIyAHCqCsnb2K/Zci+
	FUO7CnmBjMKxsM/aZLV23ob/7FSMRZ40kG2o2Le2n4QA3pKqgEWZFomnoi+hlnyoP0BZ5k
	CHFN53rULB71pwmIzGJvoJ7qYSqjzqg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JYqPx/9P";
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793205310;
	b=TU14F6RAlkJ+WNvS4BYUXgE4/WSIkH9oC3CN3B7b8J8i59q3HCMs+cS3ZDI6CWYDx274qN
	DlgD9URYlGqgPU/0vSmVAu8bHG1fQ0EfuReQxRvzvsM/kb5hzTjnIMESmXtgxziXyfEL0s
	TDOEgwV6AZbfr4X9wq/KssizjSnZ+QI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 375BD40710;
	Wed, 28 Oct 2026 16:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7081F01825;
	Wed, 28 Oct 2026 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793205309;
	bh=b6pcBVxdMQUwjf02KaU8qkuRRIgCQzwBtXV/ZrkSdNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JYqPx/9PiWeGlzQLparH1mu72uexdOw6wZ7nbGw7qYqnQMS3ETSwIEk3w2TSKHjVP
	 BB/pzOw3/U82yOTB4H6G98SRIqIWXctRa0LL3MB/aC+N6Ujj8DrXnRI/H6cSIbqUPa
	 svHrpGyMmfba0sqKuiok9nWHOM0TFeoXNECKAOBUj6ZdyjgUgNd/o8oiuDBfQspV8s
	 BIlnVhzh51YMQqTwuDTzcUhTrGblROynC5JqngMW0B1DG2i4OAkgCs8QKuNTjGZahw
	 N2wfyTCtrNl01p4c6YGiCHfDgVH+xiXoqw1QY+N3q6vRQAuZsoQk9ubW9ett5TR210
	 9RUizdCTc+X1w==
Message-ID: <sashiko-outbox-188167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 1/2] kcov: collect early boot coverage of init_task
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunseong Kim" <yunseong.kim@est.tech>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "James Morris" <jmorris@namei.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Alexander
 Potapenko" <glider@google.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Petr Pavlu" <petr.pavlu@suse.com>, "Daniel
 Gomez" <da.gomez@kernel.org>, "Sami Tolvanen" <samitolvanen@google.com>, "Aaron
 Tomlin" <atomlin@atomlin.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>, "Joel
 Fernandes" <joelagnelf@nvidia.com>, "Josh Triplett" <josh@joshtriplett.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan" <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Nathan
 Chancellor" <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H.
 Peter Anvin" <hpa@zytor.com>
Cc: kasan-dev@googlegroups.com, linux-modules@vger.kernel.org, linux-mm@kvack.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20261027-early-kcov-v1-1-6f2f053255ad@est.tech>
References: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
 <20261027-early-kcov-v1-1-6f2f053255ad@est.tech>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 16:35:06 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F17CC140006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qq1bgizet51io6jy4mzfoacb4396yngw
X-HE-Tag: 1793205309-201553
X-HE-Meta: U2FsdGVkX1+jYw8gZqxSL37EUzAgP8yS3UsO1mfiJrwnMFFESTGpS5Wac3VGVRd4M0fV8fX37KIaKa3C3ybUyi4W4zI6WK2vBpA4zwlPSuUJhELK3rTcSSizKojTNz2dQZD9CtQ1ktHzLI8KD27okPERG8DQzcsAPjKM/FSxH21HGi0BeEul+TtugzJnoulpzc3sZgcxUrthpWf6DBlSLRmaenrxc8JN83WNZIje1AUhcg7LGA9HE4rkWznxiDSvXqx3CPKkzzr7FQ5nBml7ptIxNTqwNk+VSxSLxKY0Pa5lU491p+5ipi8AxI1SX5YtmxOboSzlX7U9M6vT4dWPlMwKzO16zCO4VjAV+2HzosiGgTrTFluDw3gtFvSDJpqsgFVczSPPCnWQP4T7Iw71p6hsjJJkC9ZuDXPAqSTXfq/cwHDHty09c2QB7NLn+Ew2EkLnUIktZGczPPgFq6koKAG1ATsqqYT/remL8CDusSeSuCWcpfeiCIQfiW/7tdUf2jDXYNQy8357pBA+MbQh7OysaDfpOOKmm4HKKr7so3wwWQBlrnIfX6sDv1rNm3wOGkZrTL+fuZj5R8U5fu5dpqjiF2Vt/z4Q0dj9anFiyE1gyuhWSvYORUvzxiHITJZeDgVpLajm+Bl3M6h2oiy4Q56/1wSBIqmobe353yuhfqkJRECxwaJT4pRtjs8nfnla/1dNZDZCPjAbBwEAhHIxLaKEM2wYIn5bp46W3dgHMb9ytAnfrdpWYYLr1z5VcMG7Qq4mgD780ibmhtTag9wek5tkzO6L/lam4N0sH+4DlviL50gt7hIZIuE+8wqmACONuWmoOgvO/MXG1eJLp4SE7mxtorsXU5+YiRKKHE4dwH3qbYfVNY3k21lOQKNZRLZoKsw2MCgi2/dtiJn4p7Uikx+4JK69q8akNQ2dfLIuGz+qwWIszx+gfedFPrXiiB+UOTNCA/dlWBfcNZC8+d1
 bbSmB799
 7qWkD4O9dn1kdKmExXs2h+FHg3XchdimM3ukDejBdoeOW5K0MErX7z/xw3OTzVGuo4CdpwljvGN4sNCl7WT51I7aIfTwW4Eb15tG5f6jqIO+L6BjL8qsoQnSzcoP0UqhLP8mOud39hn7qsiUqtTNrEN6TvH0vHzH9sP41K7wxnFYdSMMOzuAZ+guk/EAHJDagFPy2aTki8JRiAZCyrY09e6marQe9RF6CS5eZ2LB9+qC5p67+JHazhgOTSAAFjXag4RUqs4bn0+xRc/pTaNmfX0/taVZRs92B2n6X4HDxYQiUybpQcXwE4H0B9/Ejabs/NMskUWAQpIv8BEMpObXcbcmCG1eAQzSaOrh3cXdiGQq9Z1lsEsQJ84qVHA8k0Ro7CyF1Qdc6Yhf/pK6k7Y84zjgu4/Qxa4g+Ep3xMRTWksy/e4G2MV38I3O95BjhOwaTUDNDdlFWiCr4jloX46Sctpxawh6cd2euLMyRk+F6UQyf6zg/DywHKKTPcQh9WZPBrlMInxhf1X0Pl6EBtjf2WlNnSnRCn+0DUGtFkJotgumblL5TrcJbrOwSCMSi0noTd8ZQihgnbVJLQS33H0vB9+TC8VIqak4VBUEUVS86SlLjSdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kcov: NULL deref in __sanitizer_cov_trace_pc() during selftest()
--

commit 2f2cd36073f62980c1305efe82a4239b11c076f5
Author: Yunseong Kim <yunseong.kim@est.tech>

kcov: collect early boot coverage of init_task

This commit adds CONFIG_EARLY_KCOV to record code coverage of init_task
from right after early parameter parsing in start_kernel() until the start
of rest_init(), and exposes the collected PCs via
/sys/kernel/debug/early_kcov. It also introduces CONFIG_KCOV_INSTRUMENT_NOI=
SY
and a kcov-noisy kbuild helper to instrument core subsystems normally
excluded due to coverage noise.

> diff --git a/kernel/Makefile b/kernel/Makefile
> index 4ff92e24680c5..b9e4f06e02ad0 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -27,14 +27,14 @@ endif
> =20
>  # Prevents flicker of uninteresting __do_softirq()/__local_bh_disable_ip=
()
>  # in coverage traces.
> -KCOV_INSTRUMENT_softirq.o :=3D n
> +KCOV_INSTRUMENT_softirq.o :=3D $(kcov-noisy)

[ ... ]

> diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
> index cee1901d4cff8..9041cbbec9aae 100644
> --- a/kernel/locking/Makefile
> +++ b/kernel/locking/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Any varying coverage in these files is non-deterministic
>  # and is generally not a function of system call inputs.
> -KCOV_INSTRUMENT		:=3D n
> +KCOV_INSTRUMENT		:=3D $(kcov-noisy)

[ ... ]

> diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
> index 0cfb009a99b9f..fd23c1dad641b 100644
> --- a/kernel/rcu/Makefile
> +++ b/kernel/rcu/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Any varying coverage in these files is non-deterministic
>  # and is generally not a function of system call inputs.
> -KCOV_INSTRUMENT :=3D n
> +KCOV_INSTRUMENT :=3D $(kcov-noisy)

[ ... ]

> diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
> index b1f1a367034ff..4b4db5cca9b08 100644
> --- a/kernel/sched/Makefile
> +++ b/kernel/sched/Makefile
> @@ -9,7 +9,7 @@ ccflags-y +=3D $(call cc-disable-warning, unused-but-set-=
variable)
> =20
>  # These files are disabled because they produce non-interesting flaky co=
verage
>  # that is not a function of syscall inputs. E.g. involuntary context swi=
tches.
> -KCOV_INSTRUMENT :=3D n
> +KCOV_INSTRUMENT :=3D $(kcov-noisy)

[ ... ]

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 6759087154edd..40bf654ec7515 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2233,6 +2233,51 @@ config KCOV_INSTRUMENT_ALL
>  	  filesystem fuzzing with AFL) then you will want to enable coverage
>  	  for more specific subsets of files, and should say n here.
> =20

[ ... ]

> +config KCOV_INSTRUMENT_NOISY
> +	bool "Also instrument code excluded only for noisy coverage"
> +	depends on EARLY_KCOV && KCOV_INSTRUMENT_ALL
> +	help
> +	  Some code (scheduler, RCU, locking, page and slab allocators,
> +	  rbtree, stack unwinding, ...) is excluded from KCOV instrumentation
> +	  because its coverage is not a function of system call inputs and
> +	  only adds noise to coverage-guided fuzzing. Code that is excluded
> +	  because it cannot be instrumented safely is not affected.
> +
> +	  Say y to instrument the noisy code as well, so that the early boot
> +	  coverage shows the complete execution path. This degrades the
> +	  coverage signal for syscall fuzzing, so say n for fuzzing kernels.

[Severity: High]
Can enabling CONFIG_KCOV_INSTRUMENT_NOISY trigger a NULL pointer dereference
in __sanitizer_cov_trace_pc() during kcov_init() -> selftest(), as well as
record interrupt entry and exit PCs into task coverage buffers?

In kernel/kcov.c, check_kcov_mode() filters out interrupt context using
in_task(), which relies on HARDIRQ_OFFSET being set in preempt_count().
However, several functions in kernel/softirq.c, kernel/sched/core.c,
kernel/locking/lockdep.c, and kernel/rcu/ run on every hardware interrupt
either before HARDIRQ_OFFSET is added or after it is subtracted, while
in_task() is still true:

- In kernel/softirq.c, irq_enter_rcu() and irq_enter() are not marked
  noinstr or __no_sanitize_coverage, so the compiler inserts a call to
  __sanitizer_cov_trace_pc() at function entry before __irq_enter_raw()
  adds HARDIRQ_OFFSET to preempt_count(). Likewise, __irq_exit_rcu()
  (inlined into irq_exit_rcu() and irq_exit()) calls
  preempt_count_sub(HARDIRQ_OFFSET) before finishing execution.

- When CONFIG_DEBUG_PREEMPT=3Dy or CONFIG_TRACE_PREEMPT_TOGGLE=3Dy,
  __irq_enter_raw() calls preempt_count_add(HARDIRQ_OFFSET) in
  kernel/sched/core.c, which is instrumented at entry before
  __preempt_count_add() updates preempt_count().

- On interrupt exit after HARDIRQ_OFFSET is cleared,
  irqentry_exit_to_kernel_mode() / irqentry_exit_cond_resched() can call
  trace_hardirqs_on() -> lockdep_hardirqs_on_prepare() in
  kernel/locking/lockdep.c, rcu_irq_exit_check_preempt() in kernel/rcu/,
  and preempt_schedule_irq() -> __schedule() in kernel/sched/core.c
  (before prepare_task_switch() sets KCOV_IN_CTXSW and after
  kcov_finish_switch() clears it).

When CONFIG_KCOV_SELFTEST=3Dy is also enabled (for example in allyesconfig
builds), kcov_init() calls selftest() at device_initcall time with
current->kcov_area =3D=3D NULL and current->kcov_size =3D=3D 0:

kernel/kcov.c:selftest() {
	...
	start =3D jiffies;
	WRITE_ONCE(current->kcov_mode, KCOV_MODE_TRACE_PC);
	while ((jiffies - start) * MSEC_PER_SEC / HZ < 300)
		;
	WRITE_ONCE(current->kcov_mode, 0);
}

When a timer interrupt fires during that loop, the instrumented interrupt
entry/exit path invokes __sanitizer_cov_trace_pc() while in_task() is true:

kernel/kcov.c:__sanitizer_cov_trace_pc() {
	...
	t =3D current;
	if (!check_kcov_mode(KCOV_MODE_TRACE_PC, t))
		return;

	area =3D t->kcov_area;
	/* The first 64-bit word is the number of subsequent PCs. */
	pos =3D READ_ONCE(area[0]) + 1;
	if (likely(pos < t->kcov_size)) {
	...
}

Because area[0] is read before checking t->kcov_size, dereferencing area
when t->kcov_area is NULL crashes the kernel on boot.

Should these interrupt entry/exit helpers be marked __no_sanitize_coverage
(or noinstr), or should CONFIG_KCOV_SELFTEST depend on
!KCOV_INSTRUMENT_NOISY?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-early-kcov=
-v1-0-6f2f053255ad@est.tech?part=3D1

