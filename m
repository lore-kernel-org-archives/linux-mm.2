Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478E5606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB0NcMOt
Received: by kanga.kvack.org (Postfix)
	id 626A56B05B4; Sat,  7 Nov 2026 21:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF466B05B5; Sat,  7 Nov 2026 21:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F096B05B6; Sat,  7 Nov 2026 21:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC706B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:41:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB4A080311
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:40 +0000 (UTC)
X-FDA: 85410401160.28.4626DF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1A9FC80004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bB0NcMOt;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794105698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf+6PZjys2Xut4mx+fifSXamBJdpHDZB6TJ36IBUsJ8=;
	b=kiDv87KAY+Hvn45ZIgkV0Cvc807b26pyF4r4+A9eWEFh5HbeaJWfvpqFzr6DO7VbAwuEKZ
	u6tjEWig+XBZRg3j88Ge1LlU77djZ9ycEh0QFBsv9col/K/G4dUB4Z9UeVwkTFoz/dsgur
	qtRxpMbNrvCBUcB9qAWTDgNgfxEjciE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794105698;
	b=gjJeEgthC2zazdMCVnqVG/yNHNnYdaUohBlzioLJkszyGTFLrBOQ+CkzvPdZa1YaVMcSfN
	6uBMrY6nQy3vEqgLLh96IkBguvy4A1Bb71wA+2cbR30Wi41Yy2t8wOqB4t1OAeiQtQT972
	pmCSuPOHKQMBAPK/tSAbWJNOr7rmy5Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bB0NcMOt;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B545F612CE;
	Sun,  8 Nov 2026 02:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C671F008A3;
	Sun,  8 Nov 2026 02:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794105697;
	bh=Kf+6PZjys2Xut4mx+fifSXamBJdpHDZB6TJ36IBUsJ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bB0NcMOt0s9iJy+XpzEpAzuBB9P70XuU28qNAL+49FZ85MslZnzbFBpSnHPjCLN5x
	 gpMIFydbsNbuNsAAMik/mvRQexDj8oDK/cH3nmS1oAUYCwyXjErVXso6e8YzKllM+U
	 dHwumESx/ACvXZasifg1muKOnO7OiiXAo4Gi3erlRcGZfmfet4tL5Nu77rGJ+VAugI
	 LU61/wR6IT/Grzv4NGC/JhN4/vV/S4Su8DfVLzuzH4g6z0aN5pGjPi95ur4KSnusvx
	 4aheXZsKKOKGGO/IFrpIwagRDWztEpwT1aDufgdd0ww8rERuc24vqDZmH1smMG0zkN
	 hK5GSCon/ie3w==
Message-ID: <sashiko-outbox-203524@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/8] riscv: add ptrace requests for hardware
 breakpoints
Reply-To: sashiko-reviews@lists.linux.dev
To: "Himanshu Chauhan" <himanshu.chauhan@oss.qualcomm.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Jesse Taube" <jtaubepe@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, "Kees Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa" <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "James
 Clark" <james.clark@linaro.org>, "Shuah Khan" <shuah@kernel.org>, linux-mm@kvack.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261107023917.40606-4-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
 <20261107023917.40606-4-himanshu.chauhan@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 02:41:36 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A9FC80004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rciqgs6i6g8gu14kyxi8mzyfn9ka1df1
X-Rspam-User: 
X-HE-Tag: 1794105697-247312
X-HE-Meta: U2FsdGVkX1/6jTAS4Nl1r+jj+qpwUBkJQa+NefwiyrV6BKTJ0Yiyvi5jHAMZz5iGuvfT+kBvYlLqZbsH9YioQf+yvvm8P6A6jULPNrYnCCLaC0JEjmxl++XqUoAWG3BlbanymYqQ6T8E7X0u7lDVWQ8+8BML9/ACuJJU91tBQMOuSykaXjLs4oNdUeS42dn04Z7rnjHb2mfLXiCLAFLLrUL7JzVz2QlC7bEYgQItVjM6izbmMbubknqSrSDWkFSRJ+O9t2CdQ8HCgY6gO7Q+sgKJ5Oma0GZ1Z+C3K2BZMvE3Mi9Hw2XOxsythfXWTGCbdZFf7FawnVAEwyCaoFbIMVirbjRKSzZja0uYeeDBAq1Tt9y4f3cJy5wK6/C/AfkmYVExG1bu8HrnIDJsf09vKFRhDDkLRMMg1HjzspoLvlpcGNqnFripHYtDw3DQYxaOhzXZGg5uffAeQFZWJZcwf4U4Ixneu4ckvWE36jX/ooKL+oZEMgxYpycjbN250pAU1TFuLJDw+Y6LxbSCVolzk7S3aVHi2v2+MpIDoyJnEAXBsUwhvhBrdi4I6Q6dIgnNlrmqOTZrcl6fuL3VzlJ9JL48KOE25eryhnHuK3Z089JjUzsjLq04GHYifDvq1y1RgYC/6IV6LMUpAkUWvllpJDiYmSfkwEusftTY0C3P+fAmZylAm3pMvPUeRm1s+PS93+uja9gqKeF+fyLvvPxcqjb4/SH/RNW4oSfCZvuQDHTlNEvH66MHZfq3qmwAViGeq9OxvH67nrzr9PG0NfmDrVySBmN/JZjdJny+LvtSMX01Loke80S3c52hMTtOr1Yk52QICjXCBxh6IpsITkY9NSrDVtETKKfI5fih69IW99pepq9fjRzx9q6CFXPSb5eM0VOF/AT62jDZ0QRR6Ka07xLGZiMYVzCTnbhpO3gGET81UBMqDZDNo/14PQ+aBkFAy+5KtCQmR0FUbi+Lp4M
 Y2MGwovX
 riamctVrYaKyTSocgcQv3Zi5ovQZLyDTHqt+ZCYUq8Uak+DVma++nsKyI9E48TSxNeMGdm7vShktQESVLTKcsDJ6gVfu6VO04ZIFzMIEbO7iEaN/zTRKxxgHJjSOkVoq2Wog58WvIwSflJT7u0uCH3/HNQEWuHPGEdsJVtEGLj67Gx5PJV/dtvs/hVF3iIL69m9PKwVWr/mn7LpJRXxqU6aRZKryPSJMKg1e+BuRwtrvoGtRnUpIvi/wIcs9ioZeCctwOvBSXReI+gpqBy6eATbuCGjD4mcmmevC0jjlCveuMp686T8T36aSoNLpv1zXjNPY1R8s8ZKpMLlJO9d60H75hxhb+2XGb8vOiZVf+1H4bYb+JfdWwJbUUevP9nKFVDof6rRc/AVNJVCcz7w4omksnOPijVzPfnPYzt7JW5jCN+ftu6jKIhlsvrcdPGz0+2aQE8X63gQT0KXmNAXtGHu04laHu6Wf+YbFGlSK1c8FXdlu2cHmcBplPCNYMZN5eJ4c6FB3yh/5vIAkLmtrw3XqLkeKDc7w1tDr+aM1fNTmRxZFSL6mwDbuzkZNO/ZJHNjpWhQ2rDVv5PBhdhMGlvhVc7A2G2/f9tP2ZEtsxlzUnlxTDs8eSoUS89TSvKm2KVxaG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] riscv: ptrace: PTRACE_GETHBPREGS/SETHBPREGS collide with
  generic SUD requests
- [High] riscv: hw_breakpoint: duplicate flush_ptrace_hw_breakpoint()
  stub breaks build
- [Medium] riscv: ptrace: switching slot type in riscv_ptrace_bp_set()
  fails with -ENOSPC
- [Medium] riscv: ptrace: sleeping lock in riscv_ptrace_hbptriggered()
  with IRQs off
- [Low] riscv: unused clear_ptrace_hw_breakpoint() prototype and
  debug_info fields
--

commit 99a21b5687d9bebf111bc51526d0fe5d8bd289d6
Author: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>

riscv: add ptrace requests for hardware breakpoints

This commit adds support for the PTRACE_GETHBPREGS and PTRACE_SETHBPREGS
ptrace requests on RISC-V, storing per-task perf hardware breakpoint events
and reporting hits via SIGTRAP/TRAP_HWBKPT.

> diff --git a/arch/riscv/include/asm/hw_breakpoint.h b/arch/riscv/include/=
asm/hw_breakpoint.h
> index dcce20ba3faab..6e8913d69df23 100644
> --- a/arch/riscv/include/asm/hw_breakpoint.h
> +++ b/arch/riscv/include/asm/hw_breakpoint.h
[ ... ]
> @@ -42,8 +49,14 @@ void arch_disable_hw_breakpoint(struct perf_event *bp);
>  int arch_install_hw_breakpoint(struct perf_event *bp);
>  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>  void hw_breakpoint_pmu_read(struct perf_event *bp);
> +void clear_ptrace_hw_breakpoint(struct task_struct *tsk);
> +void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
> +void ptrace_hw_copy_thread(struct task_struct *task);
> =20
>  #else
> =20
> +static inline void flush_ptrace_hw_breakpoint(struct task_struct *task) =
{ }
> +static inline void ptrace_hw_copy_thread(struct task_struct *task) { }
> +
>  #endif /* CONFIG_HAVE_HW_BREAKPOINT */
>  #endif /* __RISCV_HW_BREAKPOINT_H */

[Severity: High]
Does defining flush_ptrace_hw_breakpoint() here break the build when
CONFIG_HAVE_HW_BREAKPOINT is disabled?

include/linux/hw_breakpoint.h already defines a static inline stub for
flush_ptrace_hw_breakpoint() when CONFIG_HAVE_HW_BREAKPOINT is not set
(and declares the prototype when it is set).  Since asm/processor.h now
includes asm/hw_breakpoint.h, any translation unit including both
linux/sched.h and linux/hw_breakpoint.h (such as arch/riscv/kernel/ptrace.c)
fails to compile due to the redefinition.

> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/=
processor.h
> index e9d339bcb7e9f..a124ea48d8058 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
[ ... ]
> @@ -111,6 +112,19 @@ struct pt_regs;
>  #define RISCV_PREEMPT_V_NEED_RESTORE	0x40000000
>  #define RISCV_PREEMPT_V_IN_SCHEDULE	0x20000000
> =20
> +struct debug_info {
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +	/* Have we suspended stepping by a debugger? */
> +	int			suspended_step;
> +	/* Allow breakpoints and watchpoints to be disabled for this thread. */
> +	int			bp_disabled;
> +	int			wp_disabled;
> +	/* Hardware breakpoints pinned to this task. */
> +	struct perf_event	*hbp_break[RISCV_MAX_BP];
> +	struct perf_event	*hbp_watch[RISCV_MAX_BP];
> +#endif
> +};

[Severity: Low]
This isn't a bug, but suspended_step, bp_disabled, and wp_disabled in
struct debug_info, along with the clear_ptrace_hw_breakpoint() prototype in
asm/hw_breakpoint.h, are never used in this patch or later in the series.

> diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/ua=
pi/asm/ptrace.h
> index 3de2b7124aff3..373a1c14f2073 100644
> --- a/arch/riscv/include/uapi/asm/ptrace.h
> +++ b/arch/riscv/include/uapi/asm/ptrace.h
> @@ -15,6 +15,8 @@
> =20
>  #define PTRACE_GETFDPIC_EXEC	0
>  #define PTRACE_GETFDPIC_INTERP	1
> +#define PTRACE_GETHBPREGS	0x4210
> +#define PTRACE_SETHBPREGS	0x4211

[Severity: High]
As reported by Rui Qi on v6 [1], do these values collide with the generic
PTRACE_SET_SYSCALL_USER_DISPATCH_CONFIG (0x4210) and
PTRACE_GET_SYSCALL_USER_DISPATCH_CONFIG (0x4211) requests in
include/uapi/linux/ptrace.h, where 0x4200-0x4300 is reserved for
architecture-independent additions?

Because arch_ptrace() and compat_arch_ptrace() intercept 0x4210 and 0x4211
before calling ptrace_request(), a tracer calling
PTRACE_SET_SYSCALL_USER_DISPATCH_CONFIG when CONFIG_HAVE_HW_BREAKPOINT=3Dy =
is
routed to riscv_ptrace_gethbpregs(), which overwrites the caller's input
buffer via copy_to_user(), while PTRACE_GET_SYSCALL_USER_DISPATCH_CONFIG is
routed to riscv_ptrace_sethbpregs().

> diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> index a0055743d3ba5..be076865d02d0 100644
> --- a/arch/riscv/kernel/ptrace.c
> +++ b/arch/riscv/kernel/ptrace.c
[ ... ]
> @@ -380,6 +382,152 @@ static int riscv_cfi_set(struct task_struct *target,
>  }
>  #endif
> =20
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +enum riscv_hbp_type {
> +	RISCV_HBP_BREAK,
> +	RISCV_HBP_WATCH,
> +};
> +
> +/*
> + * Handle hitting a HW-breakpoint.
> + */
> +static void riscv_ptrace_hbptriggered(struct perf_event *bp,
> +				      struct perf_sample_data *data,
> +				      struct pt_regs *regs)
> +{
> +	struct arch_hw_breakpoint *bkpt =3D counter_arch_bp(bp);
> +
> +	force_sig_fault(SIGTRAP, TRAP_HWBKPT, (void __user *)bkpt->address);
> +}

[Severity: Medium]
Can calling force_sig_fault() from riscv_ptrace_hbptriggered() sleep with
interrupts disabled on PREEMPT_RT?

When a breakpoint triggers, hw_breakpoint_handler() -> perf_bp_event() ->
perf_swevent_event() disables hardware interrupts via guard(irqsave)()
before invoking the overflow handler:

  perf_swevent_event()              [guard(irqsave)()]
    -> perf_swevent_overflow()
      -> __perf_event_overflow()
        -> riscv_ptrace_hbptriggered()
          -> force_sig_fault()
            -> force_sig_info_to_task()
              -> spin_lock_irqsave(&t->sighand->siglock, flags)

On PREEMPT_RT (RISC-V selects ARCH_SUPPORTS_RT), sighand->siglock is a
sleeping rt_spin_lock, so acquiring it with interrupts disabled triggers a
sleeping-in-atomic warning and blocks with IRQs off if contended.

[ ... ]

> @@ -549,12 +697,173 @@ void ptrace_disable(struct task_struct *child)
[ ... ]
> +static int riscv_ptrace_bp_set(struct task_struct *child, unsigned long =
idx,
> +			       struct __riscv_hwdebug_state *state)
> +{
> +	struct perf_event *bp;
> +	struct perf_event_attr attr;
> +	enum riscv_hbp_type hbp_type, other_hbp_type;
> +	int ret;
> +	bool created =3D false;
> +
> +	if (idx >=3D RISCV_MAX_BP)
> +		return -EINVAL;
> +
> +	idx =3D array_index_nospec(idx, RISCV_MAX_BP);
> +
> +	ret =3D riscv_ptrace_bp_type_to_hbp(state->type, &hbp_type);
> +	if (ret)
> +		return ret;
> +
> +	/* The legacy request exposes ctrl as a disabled/enabled boolean. */
> +	if (state->ctrl > 1)
> +		return -EINVAL;
> +
> +	other_hbp_type =3D hbp_type =3D=3D RISCV_HBP_BREAK ?
> +			 RISCV_HBP_WATCH : RISCV_HBP_BREAK;
> +
> +	bp =3D ptrace_hbp_get_event(hbp_type, child, idx);
> +	if (IS_ERR(bp))
> +		return PTR_ERR(bp);
> +	if (!bp) {
> +		bp =3D ptrace_hbp_create(hbp_type, child, idx);
> +		if (IS_ERR(bp))
> +			return PTR_ERR(bp);
> +		created =3D true;
> +	}
> +
> +	attr =3D bp->attr;
> +
> +	attr.bp_addr =3D state->addr;
> +	attr.bp_len  =3D state->len;
> +	attr.bp_type =3D state->type;
> +	/* Enable or disable as requested by ctrl (0 =3D enabled, 1 =3D disable=
d) */
> +	attr.disabled =3D state->ctrl =3D=3D 1;
> +	ret =3D modify_user_hw_breakpoint(bp, &attr);
> +	if (ret) {
> +		/* Drop only events allocated by this failed request. */
> +		if (created)
> +			riscv_ptrace_bp_clear_event(child, hbp_type, idx);
> +		return ret;
> +	}
> +
> +	/*
> +	 * If the same index changed from breakpoint to watchpoint, or back,
> +	 * clear the old opposite-type slot after the new event is valid so a
> +	 * failed update does not destroy the previous state.
> +	 */
> +	return riscv_ptrace_bp_clear_event(child, other_hbp_type, idx);
> +}

[Severity: Medium]
Can switching an existing slot between a breakpoint and a watchpoint fail
with -ENOSPC when all hardware triggers are already in use?

RISC-V selects CONFIG_HAVE_MIXED_BREAKPOINTS_REGS, so breakpoints and
watchpoints share a single pool of dbtr_total_num slots in
reserve_bp_slot().  Because debug_info splits storage into hbp_break[] and
hbp_watch[], changing the type at index idx causes ptrace_hbp_get_event()
to return NULL and ptrace_hbp_create() to allocate a second perf_event
from the shared pool before riscv_ptrace_bp_clear_event() frees the
existing event at the same index.  Modifying the existing perf_event in
place via modify_user_hw_breakpoint() (or storing unified trigger slots in
a single array) would avoid needing a spare hardware slot.

[1] https://lore.kernel.org/r/5a7c08bd-4313-4424-b649-a19ffe5242e4@bytedanc=
e.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107023917.4060=
6-1-himanshu.chauhan@oss.qualcomm.com?part=3D3

