Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C99CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1DD8E00B5; Wed, 29 Oct 2025 13:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA3C8E00B2; Wed, 29 Oct 2025 13:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F116E8E00B5; Wed, 29 Oct 2025 13:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFD088E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:15:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D37988DAD
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:15:23 +0000 (UTC)
X-FDA: 84051802926.23.BCDC029
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C25C01C0011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:15:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mCctPaF/";
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761758121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzfQKL/P74birS3vfbaJ1tu9wIsMCQCjuGD1SWeA7uE=;
	b=QXWOlNd++5MG4ALCjNj7HVCApcBSFxGRsy3Unz2GotpgCDHBgRoj9RdOxZfSy9srkyczzY
	McqbqyY7bfFUFplRnTgzuBygBRd9lPahTkywZEKsFOYwHK8vBC6Rxq3sDhl7OlkrlPQqvC
	2VNzn/sWjlRjDnF2hFSxJHUjoOAXFkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761758121; a=rsa-sha256;
	cv=none;
	b=7NEE3bn/+y8M/qZcF61jaYL5PqPF6LFSgXTYIg+bYvTeJ+xvs7GHKty/XzAGXVjwRryKBC
	eed0KRsPow8CgByj7owGRFsHrdnQQFYymo5TUHtSRNlm12o65Fj+S1HzZbwWdVg2Q5HA/L
	qgvhCC0V+m4VLwI6ssi0uxrz945pSFA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mCctPaF/";
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 374136149D;
	Wed, 29 Oct 2025 17:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E0DC4CEF7;
	Wed, 29 Oct 2025 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761758120;
	bh=t3ByI2ggpnXN7fpU/j1XfFuDuzjdaTgYJk3bPpbYU5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mCctPaF/s4Ej/qaUy9NBWjZ4tFp0QCR0mZ6Q58I4iogldTOoS12UFHS0vHbG0DSph
	 227Cm4eZbmJrh0L/NPvh44Kt43N6IyuWC/KldVbmCoiLr50mqPOn4lsXsfukXT9u+K
	 SBwatwsBkUUf9NSOFWQllmDLp942vZS35JrPpXugYhl3MQY2Z3swCE0Lc1cVMzrOLm
	 q+hyKGuAJkkwhVPyyL8Zd0mjnzZC9T1HST0yNNQxlFzyBGHCKafdtiPPmxzYYRh5+I
	 K8ivV6rg0eGcNpXKcdo4UXxI0eBtAIghhVlnwJJpy2Ww7H0rESJJHmDQURxNbt0Hv7
	 4WzSv5OBoFaLQ==
Date: Wed, 29 Oct 2025 18:15:17 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: Phil Auld <pauld@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Message-ID: <aQJLpSYz3jdazzdb@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aQDuY3rgOK-L8D04@localhost.localdomain>
 <xhsmhzf9aov51.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xhsmhzf9aov51.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Rspamd-Server: rspam05
X-Stat-Signature: qfmfa1r1oyqjfdkgem1xm9hc9wixoj5k
X-Rspam-User: 
X-Rspamd-Queue-Id: C25C01C0011
X-HE-Tag: 1761758121-138440
X-HE-Meta: U2FsdGVkX183vOEAsWwo4DE/IBfunNonh/5O42ehmnqKV1lGqekMbB6FrPGqFFHX46kAIlgeq29cQA10fBHr01beX0+rgZSfFBLhpdUcZqbjJwuG3H9fQ0FXDx1lkAeAPgTXDAmgLzIKe6fj00k/JNPR21aE+GwOThY2JIKlTleemDmBDeDBl57y5M0k6dOyQj6H23e9taFdYAZ+w0iYXx1aBiTr3gLmpM/0ooakJ76d02rGCUz6PmFwoDxsHkKxgRplBME4naqjvssZvwJNRw1JGw8Zw82T/mLcHVjy9FmKs0V+Sb1iBJiaZRv56lmVMIG/kSLHBQZBM6AQ/FC8krndvpi4FeWxTDjd1h4W9/3KqLNck1ehXYqbDTYRb/vBgrKRdOONKkS4EvLgNKvs+HZm2ijcHpXIMYEWwEaSAP3gUPHR+DQfh1iHlCCTzoOCy5dSIg0Klnu5++ct+qvY58t2eCZixU0uzkntA4dOyP27Vd8JGRi3fVLAogLMfKSkIg4BMEBYpw92DkiZ9aieTsIvcSE+FwJ+QJgrJuYnzPdFdVfoikw/ZdOJ4FllQOi9PFPefLnOIbNds2aX0COvfC7ILfqcV+x0fLnnyQrsaewnsKGLJguwbo8PpTwolHK7gZRXUx4o+S41YS4tutvEIS3exri0r+PS7Fzu5EUotWo23/XnViwncmcUi1A+pREc05Z14HgjmW8t8fZKDQYrCmcFe0OKs5MGiESyVPS6k08dXtTYSPf1ps/IYGAGpInwN4o+f9IlitURBupBne3R6isHIsHu6Cz7bRmWrfJ2j6bno98YWEJCEr0LbIE1CjoEyZZOwmfbAB0tCiFfio5P2F1kFn35NS8DQWMYbN1cFAUnKwFwkAgat2Gc7oiq4fWAdrXWgXh8tSA01A8gdj5AP+5AWzDsIZ9Jgj1o1Z5gYdptmA/bnbruDVSpvIkFrizaskbOgZvAZSNiayOVjZ5
 5XBftKnk
 FfdaCIggPwuUNflV8mCJOs5BaBodgD4XPgcSy89THQPzoAh0Rc3FnbRDhd9pxDORGrbwWrHj5iIVYkz1RYaCyDpLpoP5bwo8d6NcnxL+D6v3K9KMpfHv/l5V8K5R8T14BXjmmB/XQ+08Mcps6F6wvM4TmpifMqGB8voPYsLOv5s0nonbipZbizcI6bfcMmV8CSBhqkKtfdfUYmmT1q+oIhwiVa0FxEub5v/u3V5KjDKMdUeSQKCnd/mpSGnMxbRDf7IiDQ8fuMmzQlhBxJ3nRpVUeoDlRlhrTAsZvWdMP/l6HbOhP7qENVxrskzNdUOz5TOQV7b8GBRfKj7d74yFPJuwWCFhmFqDKuNAPVp5jhoOckF0GCdbLZLFk4lXkWzVw77h+PA5uILZpxW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Oct 29, 2025 at 11:32:58AM +0100, Valentin Schneider a écrit :
> I need to have a think about that one; one pain point I see is the context
> tracking work has to be NMI safe since e.g. an NMI can take us out of
> userspace. Another is that NOHZ-full CPUs need to be special cased in the
> stop machine queueing / completion.
> 
> /me goes fetch a new notebook

Something like the below (untested) ?

diff --git a/arch/x86/include/asm/context_tracking_work.h b/arch/x86/include/asm/context_tracking_work.h
index 485b32881fde..2940e28ecea6 100644
--- a/arch/x86/include/asm/context_tracking_work.h
+++ b/arch/x86/include/asm/context_tracking_work.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_CONTEXT_TRACKING_WORK_H
 
 #include <asm/sync_core.h>
+#include <linux/stop_machine.h>
 
 static __always_inline void arch_context_tracking_work(enum ct_work work)
 {
@@ -10,6 +11,9 @@ static __always_inline void arch_context_tracking_work(enum ct_work work)
 	case CT_WORK_SYNC:
 		sync_core();
 		break;
+	case CT_WORK_STOP_MACHINE:
+		stop_machine_poll_wait();
+		break;
 	case CT_WORK_MAX:
 		WARN_ON_ONCE(true);
 	}
diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
index 2facc621be06..b63200bd73d6 100644
--- a/include/linux/context_tracking_work.h
+++ b/include/linux/context_tracking_work.h
@@ -6,12 +6,14 @@
 
 enum {
 	CT_WORK_SYNC_OFFSET,
+	CT_WORK_STOP_MACHINE_OFFSET,
 	CT_WORK_MAX_OFFSET
 };
 
 enum ct_work {
-	CT_WORK_SYNC     = BIT(CT_WORK_SYNC_OFFSET),
-	CT_WORK_MAX      = BIT(CT_WORK_MAX_OFFSET)
+	CT_WORK_SYNC         = BIT(CT_WORK_SYNC_OFFSET),
+	CT_WORK_STOP_MACHINE = BIT(CT_WORK_STOP_MACHINE_OFFSET),
+	CT_WORK_MAX          = BIT(CT_WORK_MAX_OFFSET)
 };
 
 #include <asm/context_tracking_work.h>
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 72820503514c..0efe88e84b8a 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -36,6 +36,7 @@ bool stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 void stop_machine_park(int cpu);
 void stop_machine_unpark(int cpu);
 void stop_machine_yield(const struct cpumask *cpumask);
+void stop_machine_poll_wait(void);
 
 extern void print_stop_info(const char *log_lvl, struct task_struct *task);
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 3fe6b0c99f3d..8f0281b0db64 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -22,6 +22,7 @@
 #include <linux/atomic.h>
 #include <linux/nmi.h>
 #include <linux/sched/wake_q.h>
+#include <linux/sched/isolation.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -176,6 +177,68 @@ struct multi_stop_data {
 	atomic_t		thread_ack;
 };
 
+static DEFINE_PER_CPU(int, stop_machine_poll);
+
+void stop_machine_poll_wait(void)
+{
+	int *poll = this_cpu_ptr(&stop_machine_poll);
+
+	while (*poll)
+		cpu_relax();
+	/* Enforce the work in stop machine to be visible */
+	smp_mb();
+}
+
+static void stop_machine_poll_start(struct multi_stop_data *msdata)
+{
+	int cpu;
+
+	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		return;
+
+	/* Random target can't be known in advance */
+	if (!msdata->active_cpus)
+		return;
+		
+	for_each_cpu_andnot(cpu, cpu_online_mask, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)) {
+		int *poll = per_cpu_ptr(&stop_machine_poll, cpu);
+
+		if (cpumask_test_cpu(cpu, msdata->active_cpus))
+			continue;
+
+		*poll = 1;
+
+		/*
+		 * Act as a full barrier so that if the work is queued, polling is
+		 * visible.
+		 */
+		if (ct_set_cpu_work(cpu, CT_WORK_STOP_MACHINE))
+			msdata->num_threads--;
+		else
+			*poll = 0;
+	}
+}
+
+static void stop_machine_poll_complete(struct multi_stop_data *msdata)
+{
+	int cpu;
+
+	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		return;
+
+	for_each_cpu_andnot(cpu, cpu_online_mask, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)) {
+		int *poll = per_cpu_ptr(&stop_machine_poll, cpu);
+
+		if (cpumask_test_cpu(cpu, msdata->active_cpus))
+			continue;
+		/*
+		 * The RmW in ack_state() fully orders the work performed in stop_machine()
+		 * with polling.
+		 */
+		*poll = 0;
+	}
+}
+
 static void set_state(struct multi_stop_data *msdata,
 		      enum multi_stop_state newstate)
 {
@@ -186,10 +249,13 @@ static void set_state(struct multi_stop_data *msdata,
 }
 
 /* Last one to ack a state moves to the next state. */
-static void ack_state(struct multi_stop_data *msdata)
+static bool ack_state(struct multi_stop_data *msdata)
 {
-	if (atomic_dec_and_test(&msdata->thread_ack))
+	if (atomic_dec_and_test(&msdata->thread_ack)) {
 		set_state(msdata, msdata->state + 1);
+		return true;
+	}
+	return false;
 }
 
 notrace void __weak stop_machine_yield(const struct cpumask *cpumask)
@@ -240,7 +306,8 @@ static int multi_cpu_stop(void *data)
 			default:
 				break;
 			}
-			ack_state(msdata);
+			if (ack_state(msdata) && msdata->state == MULTI_STOP_EXIT)
+				stop_machine_poll_complete(msdata);
 		} else if (curstate > MULTI_STOP_PREPARE) {
 			/*
 			 * At this stage all other CPUs we depend on must spin
@@ -615,6 +682,8 @@ int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data,
 		return ret;
 	}
 
+	stop_machine_poll_start(&msdata);
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&msdata, MULTI_STOP_PREPARE);
 	return stop_cpus(cpu_online_mask, multi_cpu_stop, &msdata);

