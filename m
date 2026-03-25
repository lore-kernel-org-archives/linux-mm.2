Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E50FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6496B00A9; Wed, 25 Mar 2026 05:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FDE6B00AB; Wed, 25 Mar 2026 05:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F7A6B00AC; Wed, 25 Mar 2026 05:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D76B6B00A9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:11:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D80B160841
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:02 +0000 (UTC)
X-FDA: 84584015964.02.432D043
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B7D3140009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pOOawX0p;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j696bvYoqH2TUY0iU+oTg40Ft0YnS+LfzToj8hbXNYs=;
	b=EnWFQ9io+uVw5akqacOziVfzm6InkaZAWirgr10NtXPAvcLVIZtya99l81o9M8wjf+DRh5
	2JqPiHrlCVhoL+7tEVgZn12xoTLDB6wDnrwG3Ga4UsU6ng/JxlI6CzVExh/mflTEQQ/CTm
	7YAKeNs1m28lCGlPmw3TMv9rVWXylbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429860; a=rsa-sha256;
	cv=none;
	b=N1KiILvBj1BltszQN9oW1uZKG2GXmvSwPEQuaLd869Lm+UW6kb93BOBZnXsoDPo56t1vd9
	88JcTnDe9oNnfDWzPiguQiY6Ih4WnhtyJDh9yKwYy9DM1a1kEATsAVDuvgn7vhcv7PEJ+k
	Tb1Y09DXvH1fbkfBO5KhFec29YnHT64=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pOOawX0p;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2c1632faeb9so621490eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429859; x=1775034659; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j696bvYoqH2TUY0iU+oTg40Ft0YnS+LfzToj8hbXNYs=;
        b=pOOawX0plYlCW0TY3NUevSmnGHBcNlG/jTbTdKoOK/iCAeuVzcPHtRBUu3s6ssVMyQ
         J+crZqx8z5pPE0NoNShNCWN9UFwjhzyugqCsmXdPLcvjmHh9/hKo5ZWRSMAsrMK+TYcX
         tMTsAbfdq1tJtV+cQnzVxqHPIcNWw1oM9EHYx+AforN4gLNufXWHwT42yC1brwIJS59p
         SEggTNaVxmibyrh47++ZVBKzHEuqT10DT2oo2SBZOCuQP5qjVeFcSg9Kd0W3OmJIeruG
         hUMTdegUN+4NSDqNOXRRXv7nIGJ4J8PkkD3A+dw80X8QPpIrRZ1H2ySHBHzkZxbT1b0S
         Npgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429859; x=1775034659;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j696bvYoqH2TUY0iU+oTg40Ft0YnS+LfzToj8hbXNYs=;
        b=M93iuYDbF5QTFBQ8JoXPc/nOSgpKDeAvhaA0wcxIfzTYxAa1J9YHIf6+4k99sucz02
         rue8YX5Ddc+Bzlzppx4vtmeGOEdtzk6KOGSAYbhpbYHhYVB3yW4+vmWv4aMsd7GEJ+mq
         iKRQujwJ2z1b5isc7zujvIooyfZHFMs2IG2WSxuxt0VFBU0WhMbSikH8we35ynwVT3GB
         4s57UcWdNNVRkN46GmPk6/fwr5xDvWiNk5VRD2z2caRi5LKUQbIhjvYWAegH+g/aLlsC
         sakDhpUIMn6IdLwWwdFa+ByoY0gv/+tByJw1e0OkOHAQW2fjAsPeEODqwWEp2C7wmCwP
         uIvw==
X-Forwarded-Encrypted: i=1; AJvYcCVE+FIngJNxxMtp9Erl3QYK5p3NZ2ZtFXPdEoy/nBmzK2l1NB5/y6ysCSqlAbrsV9sAT4X3R1UGxw==@kvack.org
X-Gm-Message-State: AOJu0Yw9eEbNfHdyW0+J7l03VpM43pmktTjxJM4qgqPc/utePAZECyzm
	dYJFwviX/cNlM4S4TfhnDMsT7X9qshUnsw5FIA68hUlgYldax4j0sGkO
X-Gm-Gg: ATEYQzyVcQ6RHy8kN09YumPmrDK4gUmbxTfwOuFaWPK9AcuW0jRymqzgSAE5NBoeVDF
	JYjKJbzzZ0+bRqEQEMgPRPjqOITs3bapobf813XcOAblAH07KrKitOzK66sKfV+mzY66bE2Zgaa
	pj2rDIZXjhXnjqOlIa2cf6e+qBhIlZyDtnOngQX5sMq82dqKH1uEQ0s4YW285HdN2jAF6rmJP7W
	CqVw/lCdYoT52o/HLn7ychWD58Z5UWkpvfZcEVoJMtjUDNhLQ7wkit5enpcWpsFXDNteEfAQOQ9
	HhD/vDpBZW2uhilz02d3L0aWJDUEZVXDNShzLyuQZrlP7ihO4Z7KfbByqR4iXTVQVUXrCoGwHtD
	UOcBknJQ0KX2jeFl71JXvkJFns/Pdgm9KrJXzrcn5bcl5+egYcxhW8OH31T6ITW7np3BJYcNRUb
	JVP0+bf7zx4zTDwMSX
X-Received: by 2002:a05:7300:cb0e:b0:2be:8216:57c8 with SMTP id 5a478bee46e88-2c15d4a74bdmr1207196eec.30.1774429859013;
        Wed, 25 Mar 2026 02:10:59 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:58 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:41 +0800
Subject: [PATCH 10/15] tick/nohz: Transition to dynamic full dynticks state
 management
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-10-919cca23cadf@gmail.com>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Stat-Signature: w64jeidu4g3ttdj8wc58mpbepaj45674
X-Rspamd-Queue-Id: 3B7D3140009
X-Rspam-User: 
X-HE-Tag: 1774429860-510113
X-HE-Meta: U2FsdGVkX18DhD3+czR+Tmp5RT+LqSjwR/pl47A0f9prcZ8ef9diI+lXDbNGMfTBLX5EfgAcdrWu19sYXzEY8skJFGD5sNItLPF5EenN14MKvKp1PeeAg9sg0WHGiVU9LwdBEP2DLopEzUeWRqWJb09WrLK6v647A8DjraFmT9RHDxBvmGRHFhbxN7vwE/2fZOLs+3iWacA1k7zCRBgUJyd33BrXgvsRki0kG045CKZV2N6UCaLZGwBjCQphosxxFbLw2NX8xKGu5uO+0SoYFZNDhsHxHG2ZsWKWAVIrMng+lYIEGybkJVpmswKTziKmXogSko9JY4K2hUtSiVGzny8AKfc34Y95nisSR6R7qibrvcblR70K1GLADUAgnO2BjvkKkcugCxvCoRgE+ZqP4dlPfD8GEGX4ACZjKfPS54vEz4qTlza4AbubRPXtyxrGYcr4Rew6Jo1YvDq0WI2T19GVM8+tRTR38V9PRVu/Jf+tLXT2ggI+2VHFLdXPRy7MAApaheqWAbhsMJfivaGI600t+sGN/h4TL/9EQ9/Q6tQ+b9enC7F1RNH6GfGuP8YiL6oIca4jHg5lbm/kJailUdLb8pzVyuLl4AFApW6EsXKf1hx09Wlfc0MavUKuwUt+338Lg/S3c6kCXdCVdOAQVgsweep4I7e3BtI7JJR/4dukGqYCjDCE1CRbq2k41n9sAuNzmOkMMge4dJH+bbDWXHrqVKz0140B2aLew9wrGDrmMYaho04O47X9g6PUx5micvCFWZWW5VEXo/emCq+8n5Ssv+5X4xB2aLEs63ZTstxf+45kQpARmQosOg5jYnaBqCrMiOszg4ZAo+NM/S9Z7Q+SYh+mGgnIEvIynMIa4RahshALaXMxeElPxeucvOvpM5+Ly9pEUowfCYdDe409XQ2tdaZcWhKZi1JzGfxg9zImsFWESwzmGVQLHc8BQ0qGUPWXHTQIfTCYADe6lul
 7pk8kS81
 nxIR7lN+6DGBzO7aSYpPDolnwnwuJUYp6f6DMzFcFO9L0ttFMrw73HH/YIDXAhLKrHF8MWbII2w8SdyrQgMgFkJd03I5yDO37BWenJEsNANeQH5T9O78TKR9S0tuMNTXrligfu64TE9VU6VhgQ550fFBDQFqt8glake82ybZk4576TmfLTKHDBSUVDnEeMrZ4myoSEM/LyCgUPcVGh7duqXlBkcMf/5OZuPTUE5CGj/pzvofKI9/RHw4zl9oPn9bygS5HIf58EQyMhqQlwkvb2L8XKV//8pwpej8LGXD0LKUeAgHCaU3FOGJ+7Qn0Katq8xxOjm4ILbUltzv1E5ZQ71aPkngb31MmzJhwhMsXrHm+tQ0CfHd7VouPjEx0vwou3wmZ0rfCiMU5UxwogVZBm9Atiwx8n2T7IT6I3eKHWazdliaKE8jutDGvR+NN4oRJ7eoh3EiHaoAjGIgmGffH01dAQuJp7tKC88v9InEB3P96U2wHlPfSmXZGbiZFy98ANOR6
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
dependency checks often prevented tick suppression in "Zero-Conf" setups.

Solution:
- Replaced the static tick_nohz_full_enabled() checks with a dynamic
  tick_nohz_full_running state variable.
- Refactored tick_nohz_full_setup to be safe for runtime invocation,
  adding guards against re-initialization and ensuring IRQ work
  interrupt support.
- Implemented boot-time pre-activation of context tracking (shadow
  init) for all possible CPUs to avoid instruction flow issues during
  dynamic transitions.
- Restored standard rcu_needs_cpu() checks now that RCU supports
  native dynamic NOCB mode switching.

This provides the core state machine for reliable, on-demand tick
suppression and high-performance isolation.
---
 kernel/time/tick-sched.c | 130 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 105 insertions(+), 25 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2f8a7923fa279..dee42cea259a9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -27,6 +27,7 @@
 #include <linux/posix-timers.h>
 #include <linux/context_tracking.h>
 #include <linux/mm.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/irq_regs.h>
 
@@ -621,13 +622,25 @@ void __tick_nohz_task_switch(void)
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
@@ -643,45 +656,112 @@ static int tick_nohz_cpu_down(unsigned int cpu)
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
 
@@ -1200,7 +1280,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(report_idle_softirq()))
 		return false;
 
-	if (tick_nohz_full_enabled()) {
+	if (tick_nohz_full_running) {
 		int tick_cpu = READ_ONCE(tick_do_timer_cpu);
 
 		/*

-- 
2.43.0


