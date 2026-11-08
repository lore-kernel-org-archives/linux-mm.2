Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53A0606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opMSA7c6
Received: by kanga.kvack.org (Postfix)
	id D52836B05BA; Sat,  7 Nov 2026 21:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC636B05BB; Sat,  7 Nov 2026 21:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB816B05BC; Sat,  7 Nov 2026 21:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9696B05BA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:41:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEBF68042F
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:45 +0000 (UTC)
X-FDA: 85410401370.06.4FF15C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D494180003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opMSA7c6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794105704;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snAZy0TRaI/5yCLv/8AT2xKsQtVcdUpmVZsnvggPr90=;
	b=tBFr37alKqS3RnXnfp0lTTEQ+H6+zsSVM/iUx3XG8Qrp22UK8tts1FhOUI2+xbbkUe8TlZ
	JkoR5RzhnDSDrrZFuLgHCqF0+DYenHrjIM+GnaQnTcHCLTr6GWlLksJLmK/GqNyZK68ZXA
	9sraZk11QtemiPjxlD8962nbXyBOa6I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opMSA7c6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794105704;
	b=r0oQ8LtJKzbGgw0zxQ82H7NHH/ylZB9n5BQKBlLdzB0jMYAbSa8zEannLm3i3IfLa+nf9m
	iSk70aUjJATvKC8QoD0zxO291hwcTv/7La9K36ZeO5hY5kKr5VqqfJgEho9n49x5sY7jr/
	mfBsyKKlaNtFtRWLKziLYFbSVwcjjt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8145740589;
	Sun,  8 Nov 2026 02:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A071F008A1;
	Sun,  8 Nov 2026 02:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794105703;
	bh=snAZy0TRaI/5yCLv/8AT2xKsQtVcdUpmVZsnvggPr90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=opMSA7c6Wi/B/LLwnruMkEd+UGP9wcNy73mMuP6HxO+XmpqZXeEW13hkrcezG8820
	 rztDNGQyCVTnCqslWlXFPSc+LLr3CAA20vxpZBeFOpcgiV+dh8avPmtoOWP8ZoImvt
	 FfnZbZB8dus4eX1mm/YrkM5EwdKYcw2bopsUUbfzmmFJ2Wt7vBjUXFoZq6dlbdQrqe
	 OINdpJ3A0zukkpz8Ly3nk+NBx0Yi+3Pd+wmJFegXLg2yBnAaWNjiEqLI3wJqsP0OT0
	 jt66IzryuXy2n5Oz2LbMgeJ396PMTQ5cgChc4k7Irc3OXRqOrxRRZbpt4IJPWydUs4
	 Qpb3sshIIzDJQ==
Message-ID: <sashiko-outbox-203528@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 7/8] riscv: Add software supported single stepping
 with mc/mc6 triggers
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
In-Reply-To: <20261107023917.40606-8-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
 <20261107023917.40606-8-himanshu.chauhan@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 02:41:42 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D494180003
X-Stat-Signature: z61mf5nki7j8ge99c7o3amqcihag7itq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794105704-560857
X-HE-Meta: U2FsdGVkX19VQR0qDthHFGdx3uG0PBIxf5E800PKTjbg+6IXAIOcgB7LWZRLA5jReKE8xzgsMNRPpOVJowaGji/6wdndnrMfVzi+Ltv047Lo1gV5baOMTJwMeOE9eN/aXTeAyXwaFRJeNns88nBqNLJ67JNODCokL+Hq7D0V9gMudNulJIeH9V+WgVyO6j87jbvUDh3ZrdRuGAmmWsqdGJsfeuShhduSQd8WKCCTTJMad48b9EXlFGIIjHw0XpGEZghw+jOPoeso6aFOH6XU+yxrhUZn5bSuBh7P5S/ZbekvduQeW63SE/fvd01KQLOx68mpLI+9NGOO2xNZe5ydBuAeEjM2sc1CLxBjD6oN08TXYIDK8tqloWIHzcwNGAoapEv6ln4qqJufJdynoGYbZ9orUAilIIzygWwfUDd7htCmp8zaNG9jIjtYfyUFbYSiRptKm9d5HvfnYTUJTYZuFCR8TaTzb6O6VlCsNfFWNDKztmI7U75htkMTfoxGcqaOq3YPhkfPEjdQgYpbCL47R5kx8arMefAwvzjIYnlDi0R9yLjBW7u0bG3o8ZF/VPjmF9OVAyXsGEhri3K/1Ep1ZeUueFMCJmQo8g/g0vHsHFg/Q9svOqBWtzKvahvBGaOLeA3CcYV1+crIoL4ZCDeS2tgznBuUbD6QqT9I7QXbCY6QtOuJOgJL3Ztz2vybr6nOzvkeHjy5pryOxsdY+xdiovo4KVpXPQkTHOoI2a8jKD7WoCtlwkZE7/KO3zzAk/oQ15a+Tl8O/oO1stTIr06In9Rtnhiha7jTN4DONW7w7Gbj8lSx6SAjibyh8H6ncAxMH1iLZ/apGk0rX1iJyYlvPXHwsSvNT+n1qQGYLtC/qBgYK8D525YFsvWjbEKZ95X0GWrWJH2gbMST/vuM4lRA3u/qg7s3ykNNVsDInA84N8KIqnEmB85SF0J3b8uf5u8VBx7crRUZ5pxgafazPJB
 bRKcV2pM
 QaGoqQaWpCPpyNDyUsFKmoXz25dMoQR4IYBwyHJ7NYQmZXUgDQzIMWo0vRVJb56ceNWIqA2x47JhP7Z3mp0m2ee1LRCDHCAjwITTI7bUSOoX/apJsgPZ0Jo2kNCvgok1PjOBfC1Qq4js8iYP7YynOBgh7p54coiB854s0YqseX+x2thsEE6E+zH0XCy4obU+Wy+GWyxug22avCXyAHn3dd6EDE65/duNYYkiNF8Ua2CHWpoovM0Q1RGuZSnRoL0f5UfpOnEP/fgSxN0glLMmdEi0GK1kMlBKZy3jd3J+1IqYGRVheDNTzc+5IelSnk2f1nOuRr8uYIFh9C+CTDom5pDDfJk2K0pzCeWCyXcQzUjgzJjiRwuz7KGySA4LvhbbMHC6vtcMBxgD8TYX5bkndzyOGjmZTmSf8rOZI+dpDEP1REZHkmd/MbBSrgO40Yht9icgY8p6kZA4+6WYz5sgf7CPampnlEvfEmI4NsNlWIkKM/CrqebFQq+29djgmPcDr+GqC6SInj5JknHCj8Y87DtXyYPZHw6+SQARhY/aqbiWJxV9hyCG1Ste+5y3eZgr+7WA+4eKlYBmJ2pnFheDDPOBK4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 11 potential
issues to consider:
- [High] riscv/hw_breakpoint: single-step trigger lost across context
  switches
- [High] riscv/hw_breakpoint: defer_perf retires user insn before
  perf_bp_event()
- [High] riscv/hw_breakpoint: broken watchpoint check and livelock in
  icount step
- [High] riscv/hw_breakpoint: deferred_step_event swallows ebreak and
  drops event
- [High] riscv/hw_breakpoint: deadlock and slot leak in
  restore_original_breakpoint()
- [High] riscv/hw_breakpoint: IRQ-enabled race in
  restore_original_breakpoint()
- [High] riscv/hw_breakpoint: trigger left armed in
  disable_unhandled_singlestep()
- [High] riscv/hw_breakpoint: CPU-wide breakpoints fail in
  setup_singlestep()
- [High] riscv/hw_breakpoint: missing sign extension in
  get_step_address()
- [Medium] riscv/hw_breakpoint: single-pass loop in
  hw_breakpoint_handler() starves step
- [Medium] riscv/hw_breakpoint: no software-step fallback in
  setup_singlestep()
--

commit d9e21ab5fc5abf89648b7ca31edbf8494d3f53a7
Author: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>

riscv: Add software supported single stepping with mc/mc6 triggers

This commit adds single-stepping support for RISC-V hardware breakpoints and
watchpoints using either Sdtrig icount triggers or software-decoded next-PC
execute triggers so that mcontrol/mcontrol6 triggers do not loop on the same
instruction.

> diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_bre=
akpoint.c
> index 4231170d49015..72be509439378 100644
> --- a/arch/riscv/kernel/hw_breakpoint.c
> +++ b/arch/riscv/kernel/hw_breakpoint.c
[ ... ]
> @@ -414,6 +433,168 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
>  	return ret;
>  }
> =20
> +static ulong get_step_address(struct pt_regs *regs, ulong insn)
> +{
> +	return get_next_insn_address(regs, insn, regs->epc);
> +}

[Severity: High]
On RV64, does get_step_address() -> get_next_insn_address() fail to
sign-extend negative branch and jump immediates to 64 bits?

arch/riscv/lib/insn.c:get_next_insn_address_standard() {
	if ((insn & __INSN_OPCODE_MASK) =3D=3D __INSN_BRANCH_OPCODE)
		return riscv_branch_taken(regs, insn) ?
			RV_EXTRACT_BTYPE_IMM(insn) + pc : pc + 4;

	if (riscv_insn_is_jal(insn))
		return RV_EXTRACT_JTYPE_IMM(insn) + pc;
}

In get_next_insn_address_compressed() and get_next_insn_address_standard(),
insn is a u32.  In RV_EXTRACT_*_IMM(insn) and RVC_EXTRACT_*_IMM(insn),
RV_IMM_SIGN(x_) and RVC_IMM_SIGN(x_) produce a 32-bit unsigned value that is
zero-extended when combined with 64-bit GENMASK() operands on 64-bit builds.
Adding that result directly to pc (or passing it to riscv_jalr_target()) pu=
ts
next_addr 4 GiB above the actual target on any taken backward branch, backw=
ard
jump, or negative-offset jalr, so the software step trigger never fires and
the original breakpoint is never restored.

> +
> +static int dbtr_update_event_tdata(struct perf_event *event,
> +				   unsigned long tdata1,
> +				   unsigned long tdata2,
> +				   unsigned long tdata3, bool wait);
> +
> +static bool hw_breakpoint_event_active(struct perf_event *event)
> +{
> +	return READ_ONCE(event->state) =3D=3D PERF_EVENT_STATE_ACTIVE;
> +}
> +
> +static void clear_singlestep_state(struct arch_hw_breakpoint *bp)
> +{
> +	bp->step_method =3D RISCV_HW_BP_STEP_DISABLED;
> +	bp->next_addr =3D 0;
> +	bp->pending_perf_event =3D false;
> +}
> +
> +static void disable_unhandled_singlestep(struct perf_event *event,
> +					 struct pt_regs *regs, bool deliver_event,
> +					 int err)
> +{
> +	struct arch_hw_breakpoint *bp =3D counter_arch_bp(event);
> +
> +	/*
> +	 * If the temporary step trigger cannot be installed or restored, leave
> +	 * the CPU with no active trigger instead of re-entering the same debug
> +	 * exception forever.
> +	 */
> +	pr_warn("single-step setup failed for bp_addr=3D0x%lx epc=3D0x%lx: %d; =
disabling event\n",
> +		bp->address, regs->epc, err);
> +	clear_singlestep_state(bp);
> +	if (deliver_event && hw_breakpoint_event_active(event))
> +		perf_bp_event(event, regs);
> +	if (hw_breakpoint_event_active(event))
> +		perf_event_disable_inatomic(event);
> +}

[Severity: High]
Does disable_unhandled_singlestep() leave the hardware trigger armed in DBTR
until asynchronous irq_work runs?

perf_event_disable_inatomic() only sets event->pending_disable and queues
event->pending_disable_irq without calling arch_uninstall_hw_breakpoint() or
clearing the hardware trigger on the current CPU.  When setup_singlestep()
fails with interrupts disabled in the trapped context (such as a kernel
breakpoint on sret or in an IRQ-disabled region) or on !CONFIG_SMP where
irq_work waits for the timer tick, returning from do_trap_break() resumes at
regs->epc with the trigger still active in hardware and loops on the same
debug exception forever.

> +
> +static unsigned long icount_step_tdata1(void)
> +{
> +	return dbtr_tdata1_type(RISCV_DBTR_TRIG_ICOUNT) |
> +	       FIELD_PREP(RISCV_DBTR_ICOUNT_COUNT_MASK, 1) |
> +	       RISCV_DBTR_ICOUNT_U;
> +}
> +
> +static int restore_original_breakpoint(struct perf_event *event)
> +{
> +	struct arch_hw_breakpoint *bp =3D counter_arch_bp(event);
> +	int ret;
> +
> +	/*
> +	 * Rebuild the original trigger from the perf attributes instead of
> +	 * keeping a second copy of the trigger data.  Do not update the
> +	 * temporary trigger in place when changing back from icount/software-s=
tep
> +	 * mode: uninstall/install gives the original breakpoint a fresh hardwa=
re
> +	 * slot and clears any transient hit state.
> +	 */
> +	arch_uninstall_hw_breakpoint(event);

[Severity: High]
Can calling arch_uninstall_hw_breakpoint() and arch_install_hw_breakpoint()
from restore_original_breakpoint() deadlock on ecall_lock or leak a duplica=
te
slot in pcpu_hw_bp_events[]?

Unlike mc_read_and_clear_hit() and dbtr_update_event_tdata(..., false), whi=
ch
use raw_spin_trylock_irqsave(&ecall_lock) because DIE_DEBUG can interrupt c=
ode
already holding ecall_lock on the same CPU, both arch_uninstall_hw_breakpoi=
nt()
and arch_install_hw_breakpoint() spin unconditionally on
raw_spin_lock_irqsave(&ecall_lock).

In addition, arch_uninstall_hw_breakpoint() returns void and leaves
*slot =3D event if dbtr_uninstall_trigger_locked() fails; calling
arch_install_hw_breakpoint() afterwards can install the same event into a
second pcpu_hw_bp_events[] slot, and later teardown only clears the first
matching slot, leaving a dangling perf_event pointer in the second slot.

> +
> +	ret =3D hw_breakpoint_arch_parse(NULL, &event->attr, bp);
> +	if (ret)
> +		return ret;
> +
> +	return arch_install_hw_breakpoint(event);
> +}

[Severity: High]
Because do_trap_break() enables local interrupts before calling handle_brea=
k()
for user-mode traps, can restore_original_breakpoint() race with event disa=
ble
or preemption across the unlocked window between arch_uninstall_hw_breakpoi=
nt()
and arch_install_hw_breakpoint()?

CPU0                                  CPU1
do_trap_break() [user_mode]
  local_irq_enable()
  handle_break()
    ...
      restore_original_breakpoint(event)
        arch_uninstall_hw_breakpoint(event)
                                      perf_event_disable(event)
  <IPI: __perf_event_disable>
    event_sched_out(event)
    event->state =3D PERF_EVENT_STATE_OFF
        arch_install_hw_breakpoint(event)
          *slot =3D event  <-- installed while OFF; dangling pointer after =
free

If a disable/close IPI runs between uninstall and install,
arch_install_hw_breakpoint() reinstalls an event whose state is already
PERF_EVENT_STATE_OFF, so perf_event_release_kernel() will free the event
without calling event_sched_out() again.  Similarly, if the task is preempt=
ed
in that window under CONFIG_PREEMPTION, perf_event_task_sched_in() installs
the event and restore_original_breakpoint() then installs it a second time.

Calling perf_bp_event() from hw_breakpoint_handler() and
disable_unhandled_singlestep() while local interrupts are enabled on user-m=
ode
traps also triggers lockdep_assert_irqs_disabled() in perf_bp_event().

> +
> +/*
> + * setup_singlestep - Set the breakpoint to next instruction after curre=
nt breakpoint.
> + */
> +static int setup_singlestep(struct perf_event *event, struct pt_regs *re=
gs)
> +{
> +	struct arch_hw_breakpoint *bp =3D counter_arch_bp(event);
> +	unsigned long insn, next_addr =3D 0;
> +	int ret;
> +	struct arch_hw_breakpoint tmp =3D {};
> +
> +	clear_singlestep_state(bp);
> +
> +	if (dbtr_icount_available && !arch_check_bp_in_kernelspace(bp)) {
> +		/*
> +		 * User breakpoints can use an icount trigger to retire exactly
> +		 * one instruction.  The sdtrig icount path reports EPC after the
> +		 * counted instruction, so the callback sees the post-step PC
> +		 * without decoding the original instruction here.
> +		 */
> +		tmp.tdata1 =3D icount_step_tdata1();
> +
> +		ret =3D dbtr_update_event_tdata(event, tmp.tdata1, 0, 0, false);
> +		if (ret)
> +			return ret;

[Severity: Medium]
If dbtr_update_event_tdata() fails to reprogram the current mcontrol/mcontr=
ol6
slot to RISCV_DBTR_TRIG_ICOUNT, should setup_singlestep() fall back to the
software single-step path instead of returning an error that disables the
breakpoint?

init_sbi_dbtr() sets dbtr_icount_available when at least one trigger on the
hart supports icount, but Sdtrig allows trigger types in tinfo to vary per
slot, so the slot allocated to an mcontrol/mcontrol6 breakpoint may not
support type 3 (icount) in place.

> +
> +		bp->step_method =3D RISCV_HW_BP_STEP_ICOUNT;
> +		bp->next_addr =3D 0;
> +		return 0;
> +	}
> +
> +	if (!event->hw.target) {
> +		/*
> +		 * A CPU-wide software-step trigger follows one task's decoded
> +		 * next PC.  If that task migrates, the per-CPU slot may wait
> +		 * forever for an address the CPU will not execute.
> +		 */
> +		return -EOPNOTSUPP;
> +	}

[Severity: High]
Does rejecting !event->hw.target in setup_singlestep() break all CPU-wide
kernel breakpoints (such as register_wide_hw_breakpoint() and per-CPU perf
events) on their first hit?

hw_breakpoint_arch_parse() accepts CPU-wide events and installs them into
hardware, but when they fire, setup_singlestep() returns -EOPNOTSUPP and
disable_unhandled_singlestep() disables the event (or livelocks if irq_work
cannot run before sret).  Moreover, because the !event->hw.target check is
placed after the dbtr_icount_available branch, a CPU-wide user breakpoint o=
n a
system with icount arms a per-CPU icount trigger across a preemptible user
trap without being bound to a task, so if the task migrates before returning
to user mode the icount trap and pending perf event fire on whichever user
task runs next on that CPU.

[ ... ]
> +	ret =3D dbtr_update_event_tdata(event, tmp.tdata1, next_addr, 0, false);
> +	if (ret)
> +		return ret;
> +
> +	bp->step_method =3D RISCV_HW_BP_STEP_SW;
> +	bp->next_addr =3D next_addr;
> +	return 0;
> +}

[Severity: High]
Is the temporary single-step trigger lost if the task is context-switched
before the stepped instruction retires?

setup_singlestep() writes tmp.tdata1 and next_addr directly to the current
CPU's slot via dbtr_update_event_tdata(), leaving bp->tdata1, bp->tdata2, a=
nd
bp->tdata3 with the original breakpoint or watchpoint values.  If the task =
is
preempted on return from do_trap_break() or faults on the stepped instructi=
on,
perf_event_task_sched_in() -> arch_install_hw_breakpoint() programs
bp->tdata1..3 back into hardware while bp->step_method and
bp->pending_perf_event remain set.

When the task resumes at regs->epc, the original trigger fires again with
args->regs->epc !=3D bp->next_addr (hitting the deferred_step_event fallbac=
k,
which clears bp->pending_perf_event without calling perf_bp_event()), or fo=
r a
watchpoint in RISCV_HW_BP_STEP_SW the step trigger at bp->next_addr is never
reinstalled at all.

[ ... ]
> @@ -574,12 +755,43 @@ static unsigned int mc6_read_and_clear_hit(int idx)
>  	return hit;
>  }
> =20
> +static int handle_triggered_breakpoint(struct perf_event *event,
> +				       struct pt_regs *regs)
> +{
> +	struct arch_hw_breakpoint *bp =3D counter_arch_bp(event);
> +	bool defer_perf;
> +	int ret;
> +
> +	/*
> +	 * Report user breakpoints after the temporary step trigger advances
> +	 * past the armed instruction.  Otherwise signal delivery can re-enter
> +	 * the same execute trigger before the PC has moved.
> +	 */
> +	defer_perf =3D !arch_check_bp_in_kernelspace(bp);
> +	if (!defer_perf) {
> +		perf_bp_event(event, regs);
> +		if (!hw_breakpoint_event_active(event))
> +			return NOTIFY_STOP;
> +	}

[Severity: High]
Does deferring perf_bp_event() until after single-stepping cause user-space
execute breakpoints to retire the breakpointed instruction before notifying
ptrace or perf?

When defer_perf is true, the kernel returns to user space, executes and
commits the instruction at bp->address, and only calls perf_bp_event(event,
args->regs) on the post-step trap with the post-step regs->epc.  A ptrace
debugger therefore receives SIGTRAP only after the instruction at the
breakpoint address has already executed (or never receives it if that
instruction faults or exits), and perf samples record the post-step PC and
register state instead of the breakpoint hit.

[ ... ]
> @@ -590,6 +802,74 @@ static int hw_breakpoint_handler(struct die_args *ar=
gs)
> =20
>  		bp =3D counter_arch_bp(event);
> =20
> +		if (bp->step_method !=3D RISCV_HW_BP_STEP_DISABLED) {
> +			bool pending_perf_event;
> +
> +			/*
> +			 * This trap is for the temporary trigger installed by
> +			 * setup_singlestep().  Software stepping must match the
> +			 * decoded next_addr; icount already reports the post-step
> +			 * PC and can restore the original trigger immediately.
> +			 */
> +			if (bp->step_method =3D=3D RISCV_HW_BP_STEP_SW &&
> +			    args->regs->epc !=3D bp->next_addr) {
> +				/*
> +				 * A nested breakpoint can fire before this
> +				 * event reaches its decoded next_addr, for
> +				 * example when perf delivers a signal handler
> +				 * with its own breakpoint.  Let the later slot
> +				 * handle that trap and keep this temporary step
> +				 * armed.  If nobody handles the trap, restore
> +				 * below so a real divergence does not lose the
> +				 * original breakpoint indefinitely.
> +				 */
> +				deferred_step_event =3D event;
> +				deferred_step_bp =3D bp;
> +				continue;
> +			}
> +
> +			if (bp->step_method =3D=3D RISCV_HW_BP_STEP_ICOUNT &&
> +			    args->regs->epc =3D=3D bp->address) {
> +				unsigned long tdata1 =3D icount_step_tdata1();
> +
> +				/*
> +				 * A trap can be observed before the original
> +				 * user instruction retires, leaving EPC on the
> +				 * armed breakpoint.  Delivering the deferred
> +				 * perf event here would account the same
> +				 * breakpoint twice, so rearm icount and wait for
> +				 * a callback with a post-instruction EPC.
> +				 */
> +				ret =3D dbtr_update_event_tdata(event, tdata1, 0, 0, false);
> +				if (ret) {
> +					disable_unhandled_singlestep(event,
> +								     args->regs,
> +								     bp->pending_perf_event,
> +								     ret);
> +					bp_ret =3D NOTIFY_STOP;
> +					goto exit;
> +				}
> +				bp_ret =3D NOTIFY_STOP;
> +				goto exit;
> +			}

[Severity: High]
Can the RISCV_HW_BP_BP_STEP_ICOUNT handling here fail on watchpoints and
livelock on same-PC triggers or self-branches?

First, setup_singlestep() enables RISCV_HW_BP_STEP_ICOUNT for all user-space
events including watchpoints, where bp->address is the watched data address
rather than the instruction PC.  Comparing args->regs->epc =3D=3D bp->addre=
ss is
therefore false when a watchpoint traps again before the load/store retires,
so the handler restores and rearms the watchpoint on the unretired
instruction.

Second, when args->regs->epc =3D=3D bp->address is true for slot i, jumping=
 to
exit immediately skips slots i + 1 .. dbtr_total_num - 1.  If a higher-inde=
xed
breakpoint or watchpoint triggered on the same instruction, that higher slot
remains armed and fires again on every retry while slot i keeps rearming
icount and exiting, causing an infinite trap loop.

Third, if an execute breakpoint is placed on a self-branch (such as j .) or=
 an
ebreak instruction, args->regs->epc =3D=3D bp->address remains true after t=
he
step, so this branch rearms icount and loops forever.

Fourth, because user_mode(args->regs) is not checked, a kernel ebreak (such=
 as
WARN_ON()) occurring while a user task has an active RISCV_HW_BP_STEP_ICOUNT
slot has args->regs->epc !=3D bp->address and is consumed as a completed us=
er
step with NOTIFY_STOP, looping on the unadvanced kernel ebreak.

> +
> +			pending_perf_event =3D bp->pending_perf_event;
> +
> +			ret =3D restore_original_breakpoint(event);
> +			if (ret) {
> +				clear_singlestep_state(bp);
> +				perf_event_disable_inatomic(event);
> +				bp_ret =3D NOTIFY_STOP;
> +				goto exit;
> +			}
> +
> +			clear_singlestep_state(bp);
> +			if (pending_perf_event && hw_breakpoint_event_active(event))
> +				perf_bp_event(event, args->regs);
> +			bp_ret =3D NOTIFY_STOP;
> +			goto exit;
> +		}
> +
>  		switch (event->attr.bp_type) {
>  		/* Breakpoint */
>  		case HW_BREAKPOINT_X:
> @@ -603,8 +883,7 @@ static int hw_breakpoint_handler(struct die_args *arg=
s)
>  					       RISCV_DBTR_MC6_HIT_FALSE;
> =20
>  				if (hit) {
> -					perf_bp_event(event, args->regs);
> -					bp_ret =3D NOTIFY_STOP;
> +					bp_ret =3D handle_triggered_breakpoint(event, args->regs);
>  					goto exit;
>  				}
>  			}

[Severity: Medium]
Can handling new breakpoint hits and single-step completions in a single pa=
ss
starve a pending single-step in a higher-indexed slot?

If slot 1 is single-stepping from instruction A to instruction B while slot=
 0
has an execute breakpoint armed at B, trapping at B matches slot 0 first and
jumps to exit before inspecting slot 1.  Once execution steps from B to C,
slot 0 completes its step at C and exits again, leaving slot 1 stuck in
single-step mode with its pending perf event undelivered and its original
breakpoint at A uninstalled.

[ ... ]
> @@ -653,6 +931,15 @@ static int hw_breakpoint_handler(struct die_args *ar=
gs)
>  		}
>  	}
> =20
> +	if (deferred_step_event) {
> +		bp =3D deferred_step_bp;
> +		ret =3D restore_original_breakpoint(deferred_step_event);
> +		if (ret)
> +			perf_event_disable_inatomic(deferred_step_event);
> +		clear_singlestep_state(bp);
> +		bp_ret =3D NOTIFY_STOP;
> +	}
> +
>  exit:
>  	return bp_ret;
>  }

[Severity: High]
Does the deferred_step_event fallback swallow unrelated software ebreak tra=
ps
and drop pending_perf_event?

When a slot is in RISCV_HW_BP_STEP_SW and any EXC_BREAKPOINT occurs at
args->regs->epc !=3D bp->next_addr without matching another hardware trigge=
r,
the trap was not caused by a hardware breakpoint (for example, a user-space
software ebreak in a signal handler or a kernel WARN_ON() / BUG() ebreak).
Returning NOTIFY_STOP here causes handle_break() to treat the software ebre=
ak
as handled instead of delivering SIGTRAP (TRAP_BRKPT) or running report_bug=
(),
looping forever on a kernel WARN_ON().

This path (as well as the restore_original_breakpoint() error path above) a=
lso
calls clear_singlestep_state(bp) without delivering bp->pending_perf_event,
and if control flow diverges away from bp->next_addr (such as via siglongjm=
p()
from a signal handler) without hitting another breakpoint,
hw_breakpoint_handler() is never entered to restore the original breakpoint.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107023917.4060=
6-1-himanshu.chauhan@oss.qualcomm.com?part=3D7

