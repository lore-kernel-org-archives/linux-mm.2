Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58694FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F316B009D; Wed, 25 Mar 2026 05:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA98E6B009E; Wed, 25 Mar 2026 05:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98846B009F; Wed, 25 Mar 2026 05:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 983136B009D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 243B51A082B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:23 +0000 (UTC)
X-FDA: 84584014326.10.7795872
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1AC9C1C0014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VqwumYTo;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZ4K3OH2k+TMiRs8uy+rQGZy9UvXhyZuqnAHChX5WtE=;
	b=m7WM8+IzyM7CY7EHXvDa8ctitbSsbOP88dl/RHtCgoEDGuRLP4d+gGPfYKvgDbUjtKP//L
	Zr1I8ulMDzUMqLuvGuIq2Fj/Ykw3ZtTuaBKUSjAqRrou9+QnCORtN3ttHy+ev4AfN7QZdM
	6ldpmFAd/TNtWoYSOAwFfBRZfjJ5mkY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VqwumYTo;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429821; a=rsa-sha256;
	cv=none;
	b=HbjLGYUAGIUmEpfdCoXa/xVEbkVD1H7xlNY7gmL79FqqbeDSlRZuxAqATf4T9PS6uh0l6z
	zdY1tiEdBxMNZe8rKs263To66OAwPEZvdCyrTXiCqFn5TmZvh5d3lqcuVJXcGKOMU6VntD
	sPbVeBCac0pGQopEJqSrWoi2AOyw6jA=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12a80c36350so3820739c88.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429820; x=1775034620; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZ4K3OH2k+TMiRs8uy+rQGZy9UvXhyZuqnAHChX5WtE=;
        b=VqwumYToKUqgsfpx6zPxZh3pcvi6/2qqRg6PGjIVqs5uT8aSsqPETMcHd6PJ5ly5Cc
         zAm2t0+15ECNfaNLHDspxxZl8xjsswZNgwMdypBkiS6zqR6vdwK+CGJh/2tVAXuGcx72
         JJFUX3JlL9l76af9O1nAeiHK9Hh910pr9I8xwDIM2UCdw+wVtYc8Tntx6jVVmP41xgQm
         2VDgaDoyH0EYiUWAGEDulETM9Bku+65SJSkN3uuvPsHFttHREFI5FJoJElqarwi8nEzn
         qd+lxCPpeWyXs6d5u01RpASVJHFSwlMywKYCY5DvFLbqqU53zy6YYTPSwdtfrdeGSdMj
         JwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429820; x=1775034620;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AZ4K3OH2k+TMiRs8uy+rQGZy9UvXhyZuqnAHChX5WtE=;
        b=Eg4df3/zOP5jZRQF6NG0xQMeei6Z8JxnWIXr4fYF6WlCNllttuCOmIJ/8FGIuLhx3w
         fnMZpKyv5rA8AJdpwnHpyhdtpp0sIJlj2hfKYmSnYYG8b9MQPeFo1KPl67/o3yffSG39
         PO2svOzS3KK/CI+F5GrpC4KdgBlZQMI1UKT08ZZt0v1quOAcsf688JIKrvhTJsirZmN/
         I4suKZ9kqaq7Jofy0xcNFekPMpSJ1ox19THHjRadeH//SUK+yph+I9cIE2jPEe24BHrT
         y9WcPFRsoNCUs3jntbjshhenmY4QJhjLkYqW7z9SQhnF7SHMjx1lSYBvpZGHrmZz3j6H
         6eSg==
X-Forwarded-Encrypted: i=1; AJvYcCWHZlZebTyTxco8z8rU/ztEJVb5IsCEtGY3QRo91I1eZb5R7AKoMhEszrzsjo2CQZ0LsCwJeSoWAA==@kvack.org
X-Gm-Message-State: AOJu0Yx8Y/eB6PIssz+P7iJ5cugFqP3n66HrbCpyYcBosa05GbfedE/x
	9JAJtBRSSNc4l4E0WzODtKrqPp8RmcE4c4nJX1LnpomY1vX0Wb8OKNu2
X-Gm-Gg: ATEYQzynHugfS9RBqncdmaK7DLXvPpZsQ/EN9zR3EDoWSssa0lsidCycKdjU77NEgT5
	oCJdRH6CfcbSZc/0vDdYavfqe7xdOAYwERqiovXLA66Kv4nJqtrL6ERtwuWck1c/QwSCEBnGFFo
	yt8tbncH/06xO2pGOf1oWhb14QywDMhaOf+LZTWKQMmnbLIhaF+rkorY0SWAqXx+k7N4XyQr4Qq
	pWyz3S1MHtaUr9Q1uhMJvbi0zdv14Kpl58kEopmHKyt40QDoxDPR7JjHTbtZ0h8VfffTwV0bUcU
	iIsK54hTOuz+3ifU9KznKP4eDIppLUnXfXbaltmRR5y+1hGKg2SZNwmwTeYREAfqBYTDilLS4vK
	9sxKkdmrGued0I5XQnGhEo9yLi2Dl/PpaR8lktmNAlh3CjA5/eWpKKvEzc3PuvRuNNU/HpJYill
	6CP3ThJxCa+SxTEUbW
X-Received: by 2002:a05:7022:618b:b0:12a:6ab7:3f7c with SMTP id a92af1059eb24-12a96e5ee3emr1202993c88.5.1774429819632;
        Wed, 25 Mar 2026 02:10:19 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:19 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:36 +0800
Subject: [PATCH 05/15] rcu: Support runtime NOCB initialization and dynamic
 offloading
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-5-919cca23cadf@gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: m99t7j8zuxwef61muwwfwxqj31hdki48
X-Rspamd-Queue-Id: 1AC9C1C0014
X-Rspamd-Server: rspam09
X-HE-Tag: 1774429820-93368
X-HE-Meta: U2FsdGVkX18amJr2qAabV2ve73MchaE9C2nI0AzHBYJTkiX7rcx5zi36vsu2iSuCK/6wNIBcHbaefxH+Qx/PW/xsxBWPnpCfta81AxgjHkEJUOqkTaBBC8w9CrGxMVbczfeo2FskSRpO7aQ1ny4ViQo4AH17+Oh9+i0spAcIiBJoG4BiZ3IwlsqnXPfcFeJW9kiL6NLM0DLFzNXEu859iYaARpUHz5gU84u3vDrJ6I602XoH4ydp0sZf2sPA8Vub6fP4qCru+bWBs2V5TIRenyS6TGwPY7t4nRLArzM+I+6IcbgAf2+Mkf8PMWY8i2OHa0B54ResOwVBeJm8cHI7kz5qf6OnOyISO0HRLoJdoRXBE+ZC8iJ1cZH83qs1+mNHQ3uzLLmimXWRg5icy+DRZbersQpDnJ9f2RrelGktSZ4lPO5+WDQISaS9KpaoI9QW9YtMOIakcbzAEiq5jm9OfFrWfIUecCyWH4dlaH7kFI+gpno4WD2eEIz77CxlssKtwNy2zgUWn6X8iE7evrZUOSlvHWgjERAm2Dr1e5fPjYMgZTD3ISZhPlQpK0SJZvbM11yahXuBqPx2mMgGZ2ZgVgIW1Yd7Vu9L0OP6RHOW4ahJ8dBGwrofiylaoSWQWePDrnwp+IigyNKzcjpxTVjNH+fzHzfX34vEQ1BDWWjV5O8L2at7Am7ZcKh6aPPrEfpuEdXcbwpAbHlwnoCU0XeA6kksXYZlGoOidMpaTBHZlbuCj7yh9RJe2uH05JEWjeCT1rvjCWbdOau5TdGBkPDvrbdN6kYm75MUti6Pmsa7kx6X0eE7c8vo4Od228P4P6ww0Alxw1zZH/06FPqKO/Bo5rwC5T+SLdoPTSZs2Nu2SCbkg1UBhAOvklwUA7DedAtRBAbgo0O7wIMgj5yxr6ON5rLPTSm7vnVjVr7pA8Jj3SvBLbma99m6tbTuglHQnFp67rT/RUIabEzGh584AiX
 5kJtABrc
 CpnE3SVxR/UlhBUo7sJEK4O6D17LJ5tqYYu5gxSLSlt5xH63kGURVo7ecsTIttqSJ0D6qTARei7aJOI9jqTwvbFJEICOXJqmtp7ijRCgOgJx6ecq+4sfnyhy9XHnYSNejr3d+oW34jbwndrePHWwBFyPOnHYSIWRv/xku1JYYdF5aub6yPjRa7DbT/DvA5wpkQ65RGdtneJoiEdLjgEQXET6041+L5glrmH59KYA1Cn6ZNRWgwpa5P0lMWeMIYPrJ5tGvde6IYlmXtDNhCCag4Yq4j4rIUzDSf99fcwzMcg1NPO8p0uKEIgHg3muwupgeWwfjjCz7vnMD/F67N4Fd6QChLk9iXXLcofO9hUXMTnVfSi4zpSYd4utNpnBTMknKIK5G2m8k/2LSX8jF0yEwk1tL+1T4JF8jjYZNID/u7uk043XtEvHO/F8L3SSS6Jq4pmQPuj8FesviNYdPCnPCBS0fIer8UTz7o8pmAQBf+OY0LBQMf3wzQiF28GatP1DpRh1u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Context:
The RCU Non-Callback (NOCB) infrastructure traditionally requires
boot-time parameters (e.g., rcu_nocbs) to allocate masks and spawn
management kthreads (rcuog/rcuo). This prevents systems from activating
offloading on-demand without a reboot.

Problem:
Dynamic Housekeeping & Enhanced Isolation (DHEI) requires CPUs to
transition to NOCB mode at runtime. Without boot-time setup, the
NOCB masks are unallocated, and critical kthreads are missing,
preventing effective tick suppression and isolation.

Solution:
Refactor RCU initialization to support dynamic on-demand setup.
- Introduce rcu_init_nocb_dynamic() to allocate masks and organize
  kthreads if the system wasn't initially configured for NOCB.
- Update rcu_housekeeping_reconfigure() to iterate over CPUs and
  perform safe offload/deoffload transitions via hotplug sequences
  (cpu_down -> offload -> cpu_up).
- Remove __init from rcu_organize_nocb_kthreads to allow runtime
  reconfiguration of the callback management hierarchy.

This enables a true "Zero-Conf" isolation experience where any CPU
can be fully isolated at runtime regardless of boot parameters.
---
 kernel/rcu/rcu.h       |  4 +++
 kernel/rcu/tree.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcu/tree.h      |  2 +-
 kernel/rcu/tree_nocb.h | 27 ++++++++++++------
 4 files changed, 99 insertions(+), 10 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 9cf01832a6c3d..fa9de9a3918b1 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -658,8 +658,12 @@ unsigned long srcu_batches_completed(struct srcu_struct *sp);
 #endif // #else // #ifdef CONFIG_TINY_SRCU
 
 #ifdef CONFIG_RCU_NOCB_CPU
+void rcu_init_nocb_dynamic(void);
+void rcu_spawn_cpu_nocb_kthread(int cpu);
 void rcu_bind_current_to_nocb(void);
 #else
+static inline void rcu_init_nocb_dynamic(void) { }
+static inline void rcu_spawn_cpu_nocb_kthread(int cpu) { }
 static inline void rcu_bind_current_to_nocb(void) { }
 #endif
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 293bbd9ac3f4e..3fd12ac20957f 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/random.h>
 #include <linux/trace_events.h>
+#include <linux/sched/isolation.h>
 #include <linux/suspend.h>
 #include <linux/ftrace.h>
 #include <linux/tick.h>
@@ -4916,4 +4917,79 @@ void __init rcu_init(void)
 #include "tree_stall.h"
 #include "tree_exp.h"
 #include "tree_nocb.h"
+
+#ifdef CONFIG_SMP
+static int rcu_housekeeping_reconfigure(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	struct task_struct *t;
+	int cpu;
+
+	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_RCU)
+		return NOTIFY_OK;
+
+	rcu_init_nocb_dynamic();
+
+	for_each_possible_cpu(cpu) {
+		struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
+		bool isolated = !cpumask_test_cpu(cpu, upd->new_mask);
+		bool offloaded = rcu_rdp_is_offloaded(rdp);
+
+		if (isolated && !offloaded) {
+			/* Transition to NOCB */
+			pr_info("rcu: CPU %d transitioning to NOCB mode\n", cpu);
+			if (cpu_online(cpu)) {
+				remove_cpu(cpu);
+				rcu_spawn_cpu_nocb_kthread(cpu);
+				rcu_nocb_cpu_offload(cpu);
+				add_cpu(cpu);
+			} else {
+				rcu_spawn_cpu_nocb_kthread(cpu);
+				rcu_nocb_cpu_offload(cpu);
+			}
+		} else if (!isolated && offloaded) {
+			/* Transition to CB */
+			pr_info("rcu: CPU %d transitioning to CB mode\n", cpu);
+			if (cpu_online(cpu)) {
+				remove_cpu(cpu);
+				rcu_nocb_cpu_deoffload(cpu);
+				add_cpu(cpu);
+			} else {
+				rcu_nocb_cpu_deoffload(cpu);
+			}
+		}
+	}
+
+	t = READ_ONCE(rcu_state.gp_kthread);
+	if (t)
+		housekeeping_affine(t, HK_TYPE_RCU);
+
+#ifdef CONFIG_TASKS_RCU
+	t = get_rcu_tasks_gp_kthread();
+	if (t)
+		housekeeping_affine(t, HK_TYPE_RCU);
+#endif
+
+#ifdef CONFIG_TASKS_RUDE_RCU
+	t = get_rcu_tasks_rude_gp_kthread();
+	if (t)
+		housekeeping_affine(t, HK_TYPE_RCU);
+#endif
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rcu_housekeeping_nb = {
+	.notifier_call = rcu_housekeeping_reconfigure,
+};
+
+static int __init rcu_init_housekeeping_notifier(void)
+{
+	housekeeping_register_notifier(&rcu_housekeeping_nb);
+	return 0;
+}
+late_initcall(rcu_init_housekeeping_notifier);
+#endif
+
 #include "tree_plugin.h"
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index b8bbe7960cda7..5322656a5a359 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -518,7 +518,7 @@ static void rcu_nocb_unlock_irqrestore(struct rcu_data *rdp,
 				       unsigned long flags);
 static void rcu_lockdep_assert_cblist_protected(struct rcu_data *rdp);
 #ifdef CONFIG_RCU_NOCB_CPU
-static void __init rcu_organize_nocb_kthreads(void);
+static void rcu_organize_nocb_kthreads(void);
 
 /*
  * Disable IRQs before checking offloaded state so that local
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index e6cd56603cad4..9f5f446e70b3f 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1285,6 +1285,22 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 }
 #endif // #ifdef CONFIG_RCU_LAZY
 
+void rcu_init_nocb_dynamic(void)
+{
+	if (rcu_state.nocb_is_setup)
+		return;
+
+	if (!cpumask_available(rcu_nocb_mask)) {
+		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
+			pr_info("rcu_nocb_mask allocation failed, dynamic offloading disabled.\n");
+			return;
+		}
+	}
+
+	rcu_state.nocb_is_setup = true;
+	rcu_organize_nocb_kthreads();
+}
+
 void __init rcu_init_nohz(void)
 {
 	int cpu;
@@ -1302,15 +1318,8 @@ void __init rcu_init_nohz(void)
 		cpumask = cpu_possible_mask;
 
 	if (cpumask) {
-		if (!cpumask_available(rcu_nocb_mask)) {
-			if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
-				pr_info("rcu_nocb_mask allocation failed, callback offloading disabled.\n");
-				return;
-			}
-		}
-
+		rcu_init_nocb_dynamic();
 		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, cpumask);
-		rcu_state.nocb_is_setup = true;
 	}
 
 	if (!rcu_state.nocb_is_setup)
@@ -1442,7 +1451,7 @@ module_param(rcu_nocb_gp_stride, int, 0444);
 /*
  * Initialize GP-CB relationships for all no-CBs CPU.
  */
-static void __init rcu_organize_nocb_kthreads(void)
+static void rcu_organize_nocb_kthreads(void)
 {
 	int cpu;
 	bool firsttime = true;

-- 
2.43.0


