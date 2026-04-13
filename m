Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3F4EBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F355F6B0093; Mon, 13 Apr 2026 03:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D536B0095; Mon, 13 Apr 2026 03:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E229F6B0096; Mon, 13 Apr 2026 03:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D26F36B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:44:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80EA2E416F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:08 +0000 (UTC)
X-FDA: 84652744176.02.CE9B39B
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8F85D18000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QBpEFrdz;
	spf=pass (imf06.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFe08Ts/hypKtbjTki6Zi9pd0qwjzgX8Ya0BzZ0CJRU=;
	b=HYZPpb6+ujM1SheEiWbRXTELv4LpYY8+DeMfKe4cy0y6wWr4Uq4RAqBJuZEMrlUQh0LF6i
	jDxtgZzwiDfyAA5F3615EroG8YEMccHnr7DzNG0vBulzN8H5PlSBYn6cHeXmAMa3HdMUIf
	M3iW7YHH2YSYTFX+fv1wsdCVZ2ee8FE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QBpEFrdz;
	spf=pass (imf06.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066246; a=rsa-sha256;
	cv=none;
	b=dHi2hxErWb3dM7WOUcKRDQxwr+GdauTtAasDsgAqcfiPo+d8ABeKv0sJxmaV6H1pR5Z24L
	OvD09ZwZL4LrNJogLZ+xAPSX1P31sPd9Xn596MxWmDlb9Nn+Ze0cV/xIUL0jwrnQifyQq6
	Kmt/E1NIji4qn9BZPu6yu0eYy6b5CCM=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12c1a170a50so3667415c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066245; x=1776671045; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oFe08Ts/hypKtbjTki6Zi9pd0qwjzgX8Ya0BzZ0CJRU=;
        b=QBpEFrdz47UuUR7qL/XuMCckHFJNHT3/J9lFpPFTOjHyCZog6jEMaXG3y2UMp86270
         VVHmrpxPnWJjGuJ9Cgs92Fp5Xad9mhNUCjklJH+c+nvpyH77hgHbWy2nygrJFcCau/bj
         4CcJtzOADPB3px/FiDSXpNVOn8zHVYF7dKwKyaBLWXnRn84A++iVkEDUosErDmhXVzq4
         g0V/6vxzyl/zibxUl08OdozWqhDiTij5mvfgh17+9WlYibcGw9M+5uD4M8JbFf8psjvn
         vBPDX+o4LNVrV3zK2gRsU/T1WiCTuF7JMEAolLsJcD120dlUUoNxBsF8LpdA+lBbMbay
         Z6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066245; x=1776671045;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oFe08Ts/hypKtbjTki6Zi9pd0qwjzgX8Ya0BzZ0CJRU=;
        b=MxQW4pY9yvurcWqF6DFHEbAKAUBxCozZmzwL3wEm11Svlw4sSaIu4y4/JfjW5bX5eB
         c8rtGHniChb6TG6dHU+CVD7g86PIdzsjTRvXX7fn1BlbBs7+Ag0O5+F16pOxV8BW3rGN
         9+T4gTQEFlmY6+iQY3TjUJ5uibNDqC9jkWanfjKw4iETBflcM0rG5/qltRwgCjc1Dygx
         7Q7kNbzKU1D4KP4YRpVOI9LbbgylB3TUOuVpnAVpJJGoXJnaB7W0ARWCuJxt3b5kdhCR
         X0MKfCgbepIwTcLIl+HsCz7XZC1K9thC0LHXdK1TcIddS75I3TkKMCj+V/PELnOKJBMo
         x5/A==
X-Forwarded-Encrypted: i=1; AFNElJ8prfJNWYg5Q7w0rFTzeZEvC/+iP6c1R/L9JSsHWqu4544eWhhbQBQUw+DAGWctEIo+csiUPBR+YQ==@kvack.org
X-Gm-Message-State: AOJu0YwusDJzsyUxpBXfsAC1x6SquKSPlQLWQCKUX3avKobjWfKuDZVR
	wdXyW0RVnJYb4/8Gstqh3aum9nAd/4r3Y/tyVjUyD1aKPZU+HruFuJpXIN/nKqTj
X-Gm-Gg: AeBDievUOQ3e3ABLyPzVOF36+YTg1E0O0Ks5q5J7cwftDnewjnWD+dDd8RNyJ2+uQwV
	jFi9H4opdt8jySYZqqQKyUkJWMRo4LnIG/FFL4sr0y3FY0FvhdrCys412Rsu5kvYnU43wxrBLlf
	R5Z1Ho5gMhVjOkj/hY1Ncxli1NEDY0Sg0gCkuE19Bgqs6LK0fmDhw2hmJnY1bMuJ7y+EUj6MMej
	l7KnLifL4/fsfqLCyIrBEWWZF3fU2lfR7TAulCuT7JlHssJAwbCGqxG2Nmno4M4GVffgOdsw3Zz
	xHWQ6CfhSan2u53OpEGtmR8NmKJoSygG5fBF6ekf1PbbyNzo6EElyI9KHkC74U/1elhXL5F4/A4
	K4WmfHcuCXyPyh3A0uNzo/aJdL+gDNbDd4Mccp4i/UILX7I/uKmKzikH1Vb4RofcKR6HB7sNe74
	WlfvTa2mABIy66I4Le
X-Received: by 2002:a05:7022:ec1:b0:127:5cd6:fa45 with SMTP id a92af1059eb24-12c34ea2415mr6243136c88.14.1776066245003;
        Mon, 13 Apr 2026 00:44:05 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:44:04 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:10 +0800
Subject: [PATCH v2 04/12] tick/nohz: Transition to dynamic full dynticks
 state management
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-4-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
In-Reply-To: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Waiman Long <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F85D18000E
X-Stat-Signature: oihaf7gx9tkd1zxpsykhpsas4e7s3sto
X-Rspam-User: 
X-HE-Tag: 1776066246-762855
X-HE-Meta: U2FsdGVkX1/asQ70goCIPzJFwLbpm1VHvHiohxvmgEsEH8pXlTs8I+JUpE+PAFP9GwquZyv/JBjtF6PdOYCqYA1ipWbcQ9A3FHVBzOOHKyFE4UvjW5gYLgm8LbWkIT9u3a4uzFCcCR9AKplEjV9xVIPsn0ExGJ2Fd6Log1rrrMYRsFAjEm0JWfWLyNpqgvkR+bq1RrisHIP/DbeVUicFuzsb15NEZ3KKooTteArNyZGDovVQC/oVwaa7elgEL4bz1uUlbedpfnpch7omLlKkpjtNSCxNlt93HNSdzU7+fWhqT/5bE4jkNPEErBpF+tNYEo4bw8kyKIly0OYVV5xfZtVmd/5q64QlgoFQXukhUcn1KjzvCXuVqjH5MPs115sr5ku/A4zN+TNnZPwcwL5EWpm7Niz2LkYOY2uJ1cdSzbJG87ubVCggYedLaryneccw6kvNnmMP6N0ermtd2EekMG0BkGBABXw7kqTGP6kHxtNASx5bIn5KFBjrA7U+T0MyZupFRd1+IOsWK/d97MD0+cqAQnsQAyLAS0nzozD0ZPhaTpD3Ylq02UfSt5dtx+zZ0ZbE+gmMGpkx3NN6YfgLHNwCyyIuWg81RaPsqpApo4S6pEDNE/eklv2obl1wmpIawtLk8Tgl63OREhwRuTSV0X2UhqAmqNAX0fm9hswy0FV+34WMRQ88gnj/1mss1zqaKAWlLT+Wixa1GLNj3WKW1iMgGOSlBdx0wyGhxOIGFvaS+XcjNHIzfWVfxay/cCm9lnUzGXJl3fLSY/YihQj3SGVd/yV2WHusRc3tTs9pBCbPchrk8A94w3YHvr6EixEPWsVgEpMJ/cgvSe0HO4uRegUO9+uolz5IuXYpThTMYe52t5tfw6fdbcLLoDydsf4VmPFfV5fkEq0TOUpl5+yDtD4CaaSQDeGXxl/K8lNfmxUvAaXo3SiqqD8h10UMUGgfxxUcIms8gA4kNUTtYMR
 P/Kh0afR
 8wiHbC839u0iuN8PwE0U/J6C0l9RZWfLmQn9mQenVSSlVLoTpLPqMMKJab5Ml9o2ONEdAenuKyZRq97nlJOqObrSWD7DFBoUJs/Js7uaeW+N5zzG7zCDvrk6DeVvOacF8EjaaWbHeZEawPj/IXdq9LCs6qecEx/vWgGY4nTHq2QdqHMwbp5Ywc7Ekf09QTs3Xt1QBQUW5edg3UXgwDnoQDI3TdpNDcgqlgyDbtoL+leYPMGDT5CVAhyoNvTNphHQOCFmrNv9im5nEhiGOpD0rsyhknMChTvg0RutUBTebTUJ+JOfXc3VVceyh9XFqONmKkr2w5LWMS2fR9Z6N44F/DOdOnkGzyPDKYw7PmmOK2thW2FFy5gGwcPq4mGhLiubuZ2RvKJ29VJX0D7Iza4ZaeR/KTsfhR2XRuogVfJEdOJOvBNMMU9j+W3mVfuX+WShqRgCM9MyROL5yqYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Context:
Full dynticks (NOHZ_FULL) is typically a static configuration determined
at boot time. DHEI extends this to support runtime activation.

Problem:
Switching to NOHZ_FULL at runtime requires careful synchronization
of context tracking and housekeeping states. Re-invoking setup logic
multiple times could lead to inconsistencies or warnings, and RCU
dependency checks often prevented tick suppression in Zero-Conf setups.

Solution:
- Replace the static tick_nohz_full_enabled() checks with a dynamic
  tick_nohz_full_running state variable.
- Refactor tick_nohz_full_setup to be safe for runtime invocation,
  adding guards against re-initialization and ensuring IRQ work
  interrupt support.
- Implement boot-time pre-activation of context tracking (shadow
  init) for all possible CPUs to avoid instruction flow issues during
  dynamic transitions.
- Hook into housekeeping_notifier_list to update NO_HZ states dynamically.

This provides the core state machine for reliable, on-demand tick
suppression and high-performance isolation.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/time/tick-sched.c | 130 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 105 insertions(+), 25 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f7907fadd63f2..23d69d7d44538 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -27,6 +27,7 @@
 #include <linux/posix-timers.h>
 #include <linux/context_tracking.h>
 #include <linux/mm.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/irq_regs.h>
 
@@ -624,13 +625,25 @@ void __tick_nohz_task_switch(void)
 /* Get the boot-time nohz CPU list from the kernel parameters. */
 void __init tick_nohz_full_setup(cpumask_var_t cpumask)
 {
-	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+	if (!tick_nohz_full_mask) {
+		if (!slab_is_available())
+			alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+		else
+			zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL);
+	}
 	cpumask_copy(tick_nohz_full_mask, cpumask);
 	tick_nohz_full_running = true;
 }
 
 bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
 {
+	/*
+	 * Allow all CPUs to go down during shutdown/reboot to avoid
+	 * interfering with the final power-off sequence.
+	 */
+	if (system_state > SYSTEM_RUNNING)
+		return true;
+
 	/*
 	 * The 'tick_do_timer_cpu' CPU handles housekeeping duty (unbound
 	 * timers, workqueues, timekeeping, ...) on behalf of full dynticks
@@ -646,45 +659,112 @@ static int tick_nohz_cpu_down(unsigned int cpu)
 	return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
 }
 
+static int tick_nohz_housekeeping_reconfigure(struct notifier_block *nb,
+					     unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	int cpu;
+
+	if (action == HK_UPDATE_MASK && upd->type == HK_TYPE_TICK) {
+		cpumask_var_t non_housekeeping_mask;
+
+		if (!alloc_cpumask_var(&non_housekeeping_mask, GFP_KERNEL))
+			return NOTIFY_BAD;
+
+		cpumask_andnot(non_housekeeping_mask, cpu_possible_mask, upd->new_mask);
+
+		if (!tick_nohz_full_mask) {
+			if (!zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
+				free_cpumask_var(non_housekeeping_mask);
+				return NOTIFY_BAD;
+			}
+		}
+
+		/* Kick all CPUs to re-evaluate tick dependency before change */
+		for_each_online_cpu(cpu)
+			tick_nohz_full_kick_cpu(cpu);
+
+		cpumask_copy(tick_nohz_full_mask, non_housekeeping_mask);
+		tick_nohz_full_running = !cpumask_empty(tick_nohz_full_mask);
+
+		/*
+		 * If nohz_full is running, the timer duty must be on a housekeeper.
+		 * If the current timer CPU is not a housekeeper, or no duty is assigned,
+		 * pick the first housekeeper and assign it.
+		 */
+		if (tick_nohz_full_running) {
+			int timer_cpu = READ_ONCE(tick_do_timer_cpu);
+			if (timer_cpu == TICK_DO_TIMER_NONE ||
+			    !cpumask_test_cpu(timer_cpu, upd->new_mask)) {
+				int next_timer = cpumask_first(upd->new_mask);
+				if (next_timer < nr_cpu_ids)
+					WRITE_ONCE(tick_do_timer_cpu, next_timer);
+			}
+		}
+
+		/* Kick all CPUs again to apply new nohz full state */
+		for_each_online_cpu(cpu)
+			tick_nohz_full_kick_cpu(cpu);
+
+		free_cpumask_var(non_housekeeping_mask);
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tick_nohz_housekeeping_nb = {
+	.notifier_call = tick_nohz_housekeeping_reconfigure,
+};
+
 void __init tick_nohz_init(void)
 {
 	int cpu, ret;
 
-	if (!tick_nohz_full_running)
-		return;
-
-	/*
-	 * Full dynticks uses IRQ work to drive the tick rescheduling on safe
-	 * locking contexts. But then we need IRQ work to raise its own
-	 * interrupts to avoid circular dependency on the tick.
-	 */
-	if (!arch_irq_work_has_interrupt()) {
-		pr_warn("NO_HZ: Can't run full dynticks because arch doesn't support IRQ work self-IPIs\n");
-		cpumask_clear(tick_nohz_full_mask);
-		tick_nohz_full_running = false;
-		return;
+	if (!tick_nohz_full_mask) {
+		if (!slab_is_available())
+			alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+		else
+			zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL);
 	}
 
-	if (IS_ENABLED(CONFIG_PM_SLEEP_SMP) &&
-			!IS_ENABLED(CONFIG_PM_SLEEP_SMP_NONZERO_CPU)) {
-		cpu = smp_processor_id();
+	housekeeping_register_notifier(&tick_nohz_housekeeping_nb);
 
-		if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-			pr_warn("NO_HZ: Clearing %d from nohz_full range "
-				"for timekeeping\n", cpu);
-			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+	if (tick_nohz_full_running) {
+		/*
+		 * Full dynticks uses IRQ work to drive the tick rescheduling on safe
+		 * locking contexts. But then we need IRQ work to raise its own
+		 * interrupts to avoid circular dependency on the tick.
+		 */
+		if (!arch_irq_work_has_interrupt()) {
+			pr_warn("NO_HZ: Can't run full dynticks because arch doesn't support IRQ work self-IPIs\n");
+			cpumask_clear(tick_nohz_full_mask);
+			tick_nohz_full_running = false;
+			goto out;
 		}
+
+		if (IS_ENABLED(CONFIG_PM_SLEEP_SMP) &&
+				!IS_ENABLED(CONFIG_PM_SLEEP_SMP_NONZERO_CPU)) {
+			cpu = smp_processor_id();
+
+			if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
+				pr_warn("NO_HZ: Clearing %d from nohz_full range "
+					"for timekeeping\n", cpu);
+				cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+			}
+		}
+
+		pr_info("NO_HZ: Full dynticks CPUs: %*pbl.\n",
+			cpumask_pr_args(tick_nohz_full_mask));
 	}
 
-	for_each_cpu(cpu, tick_nohz_full_mask)
+out:
+	for_each_possible_cpu(cpu)
 		ct_cpu_track_user(cpu);
 
 	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
 					"kernel/nohz:predown", NULL,
 					tick_nohz_cpu_down);
 	WARN_ON(ret < 0);
-	pr_info("NO_HZ: Full dynticks CPUs: %*pbl.\n",
-		cpumask_pr_args(tick_nohz_full_mask));
 }
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 
@@ -1209,7 +1289,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(report_idle_softirq()))
 		return false;
 
-	if (tick_nohz_full_enabled()) {
+	if (tick_nohz_full_running) {
 		int tick_cpu = READ_ONCE(tick_do_timer_cpu);
 
 		/*

-- 
2.43.0


