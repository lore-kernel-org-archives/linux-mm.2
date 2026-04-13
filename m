Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC648EBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C566B0089; Mon, 13 Apr 2026 03:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213B06B0092; Mon, 13 Apr 2026 03:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A0D6B0093; Mon, 13 Apr 2026 03:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04D226B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:43:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACD7CBDB85
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:43:57 +0000 (UTC)
X-FDA: 84652743714.23.A093E21
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id C42DA100012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:43:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N8ruRDyl;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dq7A9F2uS9NBzcitrHUera4fwiqvquYPVtGYt+ZQHw=;
	b=cyUwBfYeRtYDynJaf4G9dewfybaGRS9cRo/kY7wCCSG30fbK5k0DFWCvE9/xMh1G15Yhpc
	3uPcvCOHTadaJixNpdOGHPhsSB5v/8kLHNB5m6m/siEyZlY4BruYojWStfaja6T3fieFyJ
	dgouiMPPi14YdXRTFl18gKeEXUlSp3k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N8ruRDyl;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066235; a=rsa-sha256;
	cv=none;
	b=RtbcLdnLPpZ3ouIsSK5y/abD8R7n6TsW9fb7fgXOYbEqGW6ea3XPa4/FyWq3NUKlRteq47
	gpsr0VXVDCdYHXJPAJseriefL3r5FFCtOz5TgQTWsktQkQXDpoLeO3EVrn7Tr6w8noTbpv
	u52XAn/J5Nk4kFzD2rAYT0nyeMPsIhg=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12c20010f10so10473803c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066234; x=1776671034; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dq7A9F2uS9NBzcitrHUera4fwiqvquYPVtGYt+ZQHw=;
        b=N8ruRDyljyhjmk+CutD4ey/dd3atXsi5nqw5pr/DJ4Ngi1ViLf696QxVJ3u6KHhpE/
         wV1cUPV2Ac/CT4RdOxcUXuvfwYxI25EMPQsJcCjCU9Jx2hVMJLbeKHeIEPQNXVee2E1y
         nHRGa0Jz++m3O34GG+yQg8+CaxUTKFG5K26eGeJ2trVkdzmNz1hdtqZUlyMrNWOer/S8
         PLjeXIFRSZk/OO+X8jp6rZJ7oMYunlu0O5fxWPXwMn0zl4U/b/D+mWvhVZz2Lz3zMW0R
         9maJ8LJiBqT/v11nvD/psx8ubER4UvXs5qvpnAd5rjeE0WYViKtMJhgsdwkkqSMmbVn0
         cESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066234; x=1776671034;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2dq7A9F2uS9NBzcitrHUera4fwiqvquYPVtGYt+ZQHw=;
        b=Ts+QAbOUBXcXBCwWY2IwoAt+45XiqEnv8M9Wdii6BlyHWQ8Pb3kroCyeUiCQf82kcQ
         Ou5UusGceurGQeY2ciDOKy5AZJKCDG5ChW5YyNk/GZ3w92O1j6LN6xetVQUfZ1wERF8N
         2V0+7BAn9G+UKtXjmfibqv2eNzzjAHo9bCB59DXHPKY3kqXT+bSyF2zZAbY73d5gzN7a
         +MqUnv1ZYmZW3wKl6J7C95PYcr5Bfu6zAHSHIPM3a98L2hwBfKUEpVUgdmjx9ek8ryUj
         7aBiQoYN2xgQ46n4pJyW1FDx9T+lQNggp0ORFFYLaTEPm8B8z+VCIDYx4XkuxUlSCVw6
         JQ9g==
X-Forwarded-Encrypted: i=1; AFNElJ+O+LVTPSwEzNaLRDXN60/Getww2AH/L8WvQP5BqGSYU0f//bRelfTjCYooJcftyFKip4YWuNSeAg==@kvack.org
X-Gm-Message-State: AOJu0YzqrahLaMgDuCIoBzZj0bTzStJKOQNBlmnVeZe2IjPi0JedNNr7
	wrD7r6uvw9jy+ALgiOZyZRP8l41gSm0aIwf1mG5rUb66p0Br5Vy+Q5uO+qocj8XM
X-Gm-Gg: AeBDievYUPN/qbCwWo++I7NiZ3Qd6FkNmvgoKuM7WxTDM+8a4sKSq5RTKO8hvE7fVZD
	xaUp/LvN+xMojglqayy1zo6o2ja+Wh5cyhHsmRZHyx1XFe1chuS+2jzJnR72YpnONMf7DKVH7ND
	BHrRektT2Jtbc66UrxpDcq/KRzw7sd6a9cmgyPXWOQd7Cy9ofDFjx4nTlciQ2GgpWqWDehioHxZ
	aTW0GA0CDkVk5nd9TB4CX2+05/FdJy85fhfQbPR0W4uLWY7xS3JxDvcKo1P85e1UoJCtDgQHkcp
	mR0ogu22q9hc5+dR9Jn832UavisHpeeFcXtjBViuqfS2T1u1s0wxS3znaHepnUr4dzBxg808vbv
	xkKJaTdhD9J4lrROIlxTUdDlwRb4KcZNa1unXCnBnvjnHxrLX5YUCJWacrOfyyqr6FbvOsTLlhJ
	C7BBr0VzFkL32UZ6r+
X-Received: by 2002:a05:7022:439f:b0:128:d5f1:d594 with SMTP id a92af1059eb24-12c34e7b83amr6713439c88.10.1776066234304;
        Mon, 13 Apr 2026 00:43:54 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:43:54 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:09 +0800
Subject: [PATCH v2 03/12] rcu: Support runtime NOCB initialization and
 dynamic offloading
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-3-06df21caba5d@gmail.com>
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
X-Rspamd-Queue-Id: C42DA100012
X-Stat-Signature: oie66hjrt7tdhgszby71t7k6o4tba5jn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776066235-339909
X-HE-Meta: U2FsdGVkX19t8/gEdO3j3on2GzfVx27dadIfPcp/oWTpezwUUbqvm+8gJkQW9MUD84bboCGQ4it17em6ozbsdZlXGOsszX5ESjSMiNx2iQSQ3W5BjKImU/0bfZ24MYRDTTHq0Cf/pLb0gyppcvxE20SLEpIwZ7i1TwndVTX9SyQb5gr8xgRr+jkpimVD3K65sqCp2lQq11hd9V9zw7cBlno+rBa4T6qBBTk68cNk7koPN0bIE10vtb4sB4JUztxZNi8mmMIz2vvdVJRwunz+oAl7NBat/b3L91qqy+0nqSAdMkprinp6a+eM0AUlWwobHbzhjBZETAUWM5L72RZ9iT021wXCo+Nu7NdkqrDB4OtcnT7+8jWueGm93+ZwRT82FNX4VmyNyeePAJX1nFz9C7fAgzZoUPi+5BdlSkcm/SPmuYPrb6KPZmXXWVYQivIslyPCMWjn27xZUxgx6bujWdd1fnxmoDx9EZg2LP4KIZ/XLre4gjgg0KD/4cOZTTPEZ9pQImaIvfzGHHAcvuKNK5GrWaEs40/t0DaU4v07xG6q+MQWYNTgZiSnkQ7zVW8rcaItblNcU1pH0yfGysROMT9EB8IzSNgYOyhL0epylsp0M+F2qdyGP+rDtoZbi76jy1qgdcTeumHmg1ijH1ylqcwW0wT30+rCxHx+JM4V0rfgnrvIba2hQ8S3Zixy35PBSHL1reSAkeL+EvSnCnNyS0f9tkzJ236yJXrf8l6CMg90jBDHX6Aug9NLjHuD8FkhdEpP0gAp5yG5wJSwWOlUGDBlhOJ0LEog/qgMPE+zwRbzztLeiDT6pN0PgOeSnHxwtknXxesC7UPR+4PRfdC9LJOWZXR440IvGz4uP3ksasrN/32+zfOk9BBNDPYNGBnsT2R5cvNs7XmY5CwxWf8hzVjsKE4wLt42MEsQp4+ebKc158ljo4rpkG6CugPNNscvUN+/5vgyFM6qBezBYxV
 Aqu7CEg6
 j9hWbALyeve9oEgW9Xtp1YSd5F0Lbyu+fD3QaRr5zR3Mxe+YA73XTdr4KP9Ace0ukVQkof7wBHReFSDW6Nq3ffvAlR2tuiYC3QAP3Du2Lm2VAa6+orpfs2oEw/q+HqghG9WNoGoubOkhXlkiA+x9xK1WzvxePPYxb9hrsyhZftW5TKw5nLcvAHeH/2rvkQFoT3ZmnrGc3lu9a8ZkueYY7LmRV33v4diMc+wB6UH87kmrSJuN6ubr/ksHGIYP6ozfGrBERjo5cmJsOsklwT7v+oVHNG0xeSoWtzUJrfHrDcrEAXVqA1+H1Psj9iCxrv+ctkLwBtErBxF99dbz1T1+rmTr4+/FSS1IxEa2pMh7jh21uNBKqbFkUkL3BFnlWUkiP5BmGWbXuRRbL0f2OSQF1c1P5LCUWokp+8CNo/XwzAX8/td/TzE6YB90Lfw1+mD0nJAi7wOauPOTwIdATbozq1D/o8EOMnNRS63YtmPjcBXN99C+1x7w5CL7kdWNY3DPEuhqj
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
Dynamic Housekeeping Management requires CPUs to transition to
NOCB mode at runtime when they are newly isolated. Without boot-time
setup, the NOCB masks are unallocated, and critical kthreads are missing,
preventing effective tick suppression and isolation.

Solution:
Refactor RCU initialization to support dynamic on-demand setup.
- Introduce rcu_init_nocb_dynamic() to allocate masks and organize
  kthreads if the system wasn't initially configured for NOCB.
- Introduce rcu_housekeeping_reconfigure() to iterate over CPUs and
  perform safe offload/deoffload transitions via hotplug sequences
  (cpu_down -> offload -> cpu_up) when a housekeeping cpuset triggers
  a notifier event.
- Remove __init from rcu_organize_nocb_kthreads to allow runtime
  reconfiguration of the callback management hierarchy.

This enables a true "Zero-Conf" isolation experience where any CPU
can be fully isolated at runtime regardless of boot parameters.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/rcu/rcu.h       |  4 +++
 kernel/rcu/tree.c      | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcu/tree.h      |  2 +-
 kernel/rcu/tree_nocb.h | 31 +++++++++++++--------
 4 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 9b10b57b79ada..282874443c96b 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -663,8 +663,12 @@ unsigned long srcu_batches_completed(struct srcu_struct *sp);
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
index 55df6d37145e8..84c8388cf89a1 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4928,4 +4928,79 @@ void __init rcu_init(void)
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
index 7dfc57e9adb18..f3d31918ea322 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -517,7 +517,7 @@ static void rcu_nocb_unlock_irqrestore(struct rcu_data *rdp,
 				       unsigned long flags);
 static void rcu_lockdep_assert_cblist_protected(struct rcu_data *rdp);
 #ifdef CONFIG_RCU_NOCB_CPU
-static void __init rcu_organize_nocb_kthreads(void);
+static void rcu_organize_nocb_kthreads(void);
 
 /*
  * Disable IRQs before checking offloaded state so that local
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index b3337c7231ccb..36f6c9be937aa 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1259,6 +1259,22 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
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
@@ -1276,15 +1292,8 @@ void __init rcu_init_nohz(void)
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
@@ -1344,7 +1353,7 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
  * rcuo CB kthread, spawn it.  Additionally, if the rcuo GP kthread
  * for this CPU's group has not yet been created, spawn it as well.
  */
-static void rcu_spawn_cpu_nocb_kthread(int cpu)
+void rcu_spawn_cpu_nocb_kthread(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 	struct rcu_data *rdp_gp;
@@ -1416,7 +1425,7 @@ module_param(rcu_nocb_gp_stride, int, 0444);
 /*
  * Initialize GP-CB relationships for all no-CBs CPU.
  */
-static void __init rcu_organize_nocb_kthreads(void)
+static void rcu_organize_nocb_kthreads(void)
 {
 	int cpu;
 	bool firsttime = true;
@@ -1668,7 +1677,7 @@ static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 	return false;
 }
 
-static void rcu_spawn_cpu_nocb_kthread(int cpu)
+void rcu_spawn_cpu_nocb_kthread(int cpu)
 {
 }
 

-- 
2.43.0


