Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5F5EBFD0A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72BB6B00A1; Mon, 13 Apr 2026 03:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B1F6B00A3; Mon, 13 Apr 2026 03:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61096B00A4; Mon, 13 Apr 2026 03:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2D7E6B00A1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:45:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 870B8C3A8D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:02 +0000 (UTC)
X-FDA: 84652746444.02.FA06576
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 92B9D1C0003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I0gkdrkm;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3n2Y5xzqBT13fCT8NafM8IZJKMHdw2LLWT217qys08w=;
	b=2Xmgh0IDzW5yE7o17MbvRJMMLPYnrhiJjdsUY7aGt0jZWU4hQDEF/6M8bKi6/uwXP/FY/b
	eKvOvF8eFyZnSQfLVDhzqcx8wUneI/TvHRzesIfZCMYVknzG9eONt2xA9r9uCojOrZ1wBV
	YAHBAikBkXQvuIUoEKThIRJsYPkjERs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I0gkdrkm;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066300; a=rsa-sha256;
	cv=none;
	b=ThVlZ9aaupB4X79hJE/LPeKQLGAffDO/4fZTukWDs6ABHi6ndW1uVh5+i7c5crRlTIPB6i
	b2ccRD065fvEPOO8TQt/ccSlgkF+pWZWy2DFdkw4R7dgkgbnkQMuK0K5N2KQrpotfJJ8u1
	nVoMMm5yz5MnCR1NwPbK85ryM3RL/jc=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12c15414820so2798711c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066299; x=1776671099; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3n2Y5xzqBT13fCT8NafM8IZJKMHdw2LLWT217qys08w=;
        b=I0gkdrkmwKQsEjY8IZer3OEUKKvk2sOfHfd0Eimfj5y+yi7sho2vfdDry8IdYU7/KI
         OvldPMcgxFFxlMyAFl+LfD0FrG9pmlkJAfPZfys8fnmfPd8b5/JUe38NP4XCkCbXe1dJ
         A8MAlcfsSC00jenQUScpOP3pFuRl5lk/etsK55bmmm0KWtjOjFGq5IUqSmIs00mpASPm
         8Lw1wAyUA2YI6xRiK227pTP54t1M5ynFio2HT8W/Z4BfFk9hOHtX6vXoL2SXpEFuIdq+
         Mq/8rcF4vzyq8+XZC4XseSBL6l/typIRt5PX0lXeY9wnG+FCskpGC1LehfNkVpkGj50t
         oYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066299; x=1776671099;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3n2Y5xzqBT13fCT8NafM8IZJKMHdw2LLWT217qys08w=;
        b=aQPVdy1aC4n9LkofJ/r0Kwqs/3bPrjV6CpIB7ItptL1hsFJJJf+UOF/4XKTcPqroSQ
         zDqYuqO2hG5PPt+j6JZXNbuKYHpMw9gPIWucBnWMi8hMHjAiTYs1Q3SaQ615mgS1fz7G
         pNnWRgb0Mm1eh3OD1xGPYdbyn+uTnR9/R57ifJ2+y4Bt75CKMSG6YQqwSayFajdI5JGm
         pHb7+vUgYEKCt4U5WWb2BarLrt2rVvpGySLXXLvlQDOEZwzPJ6ehHNeZbtuhstPiiJf9
         QEpMNv+/hYA5rwjg9LTixrA5c4tsK9HrwXCOE04UpdFIqRfxCXdAhxp/J42iNiv46q7K
         9TUA==
X-Forwarded-Encrypted: i=1; AFNElJ8P4vSuhg1LX3wE5SzPXx0fLNeOkRc/IGFEH8psvgSrbCwhpUal56tN65bRU6dSk9KV+sljUoCh2w==@kvack.org
X-Gm-Message-State: AOJu0YwsUhliK+Ar8QHuQ5Yz3Nz7+g5CTl4KiQQFyhakE3/7wL0RjOG1
	EEChhyZK2at10uSKC3xT+wrZX0zxHC+92tyHyKGUQUnOr6jYM8oVGvmSJjLIZ+hU
X-Gm-Gg: AeBDievk/9BcHH5ZxSE8hCj2dbZEXdDSFZPh/+zVt1exdnv/50FKFrG2ZpAIsKPaNAp
	FbJewW7PGKoiU6grvZT04h+8+VZ9WFYBLiVa8ce3WQVxgt0/7XrzvzSC8KHZdHQ9LA4V3nWV892
	1jtcuM5Lq8Kv189YjVQDzgCoGw53lVhmnSMdh7+HK81OvFI0e3CSBYP7GXtBzQeLDFXKaNY+XYT
	+DYUec6oGnGysrTzDMPrKfN9hqhBDmUwrUo30dY7M4CAWT1mscA+I2b9st+y4syHuq9xjOWKHBm
	ODutp6oquwvmhNzOaXc5khFXHE0Wi0CKip//dqIebDx6hYqHuK2eYrHi6rLIAFyHcqUWkOu4TVg
	S41TwPmWkijpH4G1AZ/N9adDYpUrJM+k6Sr8mre+2OnUXBGHcIFB9rvbUuCso2ZMsEXeiGu90Hw
	IgOkXI9pBKoxVvBXQD
X-Received: by 2002:a05:7022:e1d:b0:119:e569:f874 with SMTP id a92af1059eb24-12c35300841mr5317906c88.17.1776066298973;
        Mon, 13 Apr 2026 00:44:58 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:44:58 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:15 +0800
Subject: [PATCH v2 09/12] cgroup/cpuset: Introduce CPUSet-driven dynamic
 housekeeping (DHM)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-9-06df21caba5d@gmail.com>
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
X-Rspamd-Queue-Id: 92B9D1C0003
X-Stat-Signature: 16atzr4etr3g5bm5pbw4jhkmb8ef48k9
X-Rspam-User: 
X-HE-Tag: 1776066300-152895
X-HE-Meta: U2FsdGVkX1/Ru7SZbjpxsVcjJJz1/F+IHdQT/Zl7MlptCLAghuBuOE5LNnt8A4rJ5MDW0RpSDSaAILXcC5aPJ/VZ7tjhBLYjzcxpMayHYttjlasVfine64IHStoPm6rA4imErdAxxONAJHSi1884t1rHEKZMR8AUBVznEUdpco++m5IFWc1iXt2RPXlKoHklQvIamhZUYKdOcaz7PJZvPrzv4UO19IJH9XV/bJItxYVAJ0K1yHSZJwfe7RfW5nR3ooNiTi6UBjEuZP2j/47nLPoRqXssRMxwmo3Jq+dYPxzyghuh8f1SQM6PN4ZeoyhA+iCNLZ3TRSeJk9unOiGKe+BYXzfOFFRBBIdvE5QZ0QL3MLbiJFVV/F+sjUiCdMBSDs2P9FrvI97EOKBBDlyF0epXjcok1l22ezaZjQLEwVdURY/j4Fr3+/Q4HO93Us24e4lg/SH8Qkt1hKOB88u0gDcgNCT6gP3M9R0rZvkf3bTfyYSLQFx1EW6fv1HUHTJu++9Db3dBpbHBrCCFEyVHNbT5jviN1J6G4AUTRv2CDBuXE/4yOXmepMCoGliHMqCfWgMgbnn1uZsMPclb1j1Ozc2LOFOs4NSDVIMhOnZzTAp1HLX5UHfYzSGk9ZHduGYT5U/AQMcRcfkHnfNWsPeH8ys4dc4GG0C5wiuH9QldkXIkL7c9SPwxdkUiY9sa67+/SjvRZNA4dAa9hrBoBlRmtgEQaUj/mS3XzpOrlWq0kv3AZ8FJb0N5WtZRzTuiu9PVau9pm05qR9jkuzIy8gJkh6/OPNsyp2G8Xm9uumLyZQtaUoCFoq+bvimpM6UWeIKNY5QtlwkELuJl3/YobxQn+ESH/S3wdZciDkQNfuqKbVIKPhVW5t85hjtqmY74iXer6WQ9GJkzaqN5LhlMjtTk3HBkwePdWws0sWit408sN6UGMenHb3X7suNolWfKiX6JwKPQYS4Db62iV+W84me
 UrXIMMiY
 yXmEJBihr5qA11ByAmkKXerncVJTJfdp62buHZb4PsN4JjSpOtIAjyyC4GGAz4uFOzUyE4ucb3YPLx8lC4Z0BNgSUwwFnfsYRWl3u/DD+GOC9S2cx/IctqzFE7dzeW4EHn7d35a5krjgL528yjl4DtPWNI9XDVc5klf8IfhtZEOhSeFlLsrgaVzLL6TTsO0mJi0iNlZcyRS829OGBpr9mWcxqu49VCZkJ9SLKgGMDlRqjn3dq97q3e2rWEbhmJQBBcAiiB1apcRJd7iYowFYyG4j6R/Hb/Agre6XlM1Yb+fbEHE0OfML/rDrNx/RxeuoPorYP1s50iE/T7Jr+3bzEVy7cMnUoTt9US0T/jJ/zT6PKSIALU3lZp5C6aqMiCVM7hgn8NFXJd5UoQ3/ShxdiP0Qvgl8FcZGlAC76sW3OwXTPRKT0Yp3PhHQJLrhTDwMu8exOgMGjv+xRLrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, subsystem housekeeping masks are generally static and can
only be configured via boot-time parameters (e.g., isolcpus, nohz_full).
This inflexible approach forces a system reboot whenever an orchestrator
needs to change workload isolation boundaries.

This patch introduces CPUSet-driven Dynamic Housekeeping Management (DHM)
by exposing the `cpuset.housekeeping.cpus` control file on the root cgroup.
Writing a new cpumask to this file dynamically updates the housekeeping
masks of all registered subsystems (scheduler, RCU, timers, tick, workqueues,
and managed IRQs) simultaneously, without restarting the node.

At the cpuset and isolation core level, this change implements:
1. `housekeeping_update_all_types(const struct cpumask *new_mask)` API inside
   `isolation.c` to safely allocate, update, and replace all enabled hk_type masks.
2. The `cpuset.housekeeping.cpus` attribute in `dfl_files` for the root cpuset.
3. Hooking the write operation to iterate over enabled housekeeping types
   and invoke `housekeeping_update_notify()` (the DHM notifier chain) to
   push these configuration changes live into individual kernel subsystems.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 include/linux/sched/isolation.h | 12 ++++++++++++
 kernel/cgroup/cpuset-internal.h |  1 +
 kernel/cgroup/cpuset.c          | 36 ++++++++++++++++++++++++++++++++++++
 kernel/sched/isolation.c        | 38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index aea1dbc4d7486..299167f627895 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -48,6 +48,8 @@ extern void __init housekeeping_init(void);
 
 extern int housekeeping_register_notifier(struct notifier_block *nb);
 extern int housekeeping_unregister_notifier(struct notifier_block *nb);
+extern int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask);
+extern int housekeeping_update_all_types(const struct cpumask *new_mask);
 
 #else
 
@@ -86,6 +88,16 @@ static inline int housekeeping_unregister_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
+
+static inline int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
+{
+	return 0;
+}
+
+static inline int housekeeping_update_all_types(const struct cpumask *new_mask)
+{
+	return 0;
+}
 #endif /* CONFIG_CPU_ISOLATION */
 
 static inline bool housekeeping_cpu(int cpu, enum hk_type type)
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index fd7d19842ded7..3ab437f54ecdf 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -60,6 +60,7 @@ typedef enum {
 	FILE_EXCLUSIVE_CPULIST,
 	FILE_EFFECTIVE_XCPULIST,
 	FILE_ISOLATED_CPULIST,
+	FILE_HOUSEKEEPING_CPULIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1335e437098e8..5df19dc9bfa89 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3201,6 +3201,30 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	mutex_unlock(&cpuset_mutex);
 }
 
+/*
+ * DHM interface: root cpuset allows updating global housekeeping cpumask.
+ */
+static ssize_t cpuset_write_housekeeping_cpus(struct kernfs_open_file *of,
+					      char *buf, size_t nbytes, loff_t off)
+{
+	cpumask_var_t new_mask;
+	int retval;
+
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	buf = strstrip(buf);
+	retval = cpulist_parse(buf, new_mask);
+	if (retval)
+		goto out_free;
+
+	retval = housekeeping_update_all_types(new_mask);
+
+out_free:
+	free_cpumask_var(new_mask);
+	return retval ?: nbytes;
+}
+
 /*
  * Common handling for a write to a "cpus" or "mems" file.
  */
@@ -3290,6 +3314,9 @@ int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_ISOLATED_CPULIST:
 		seq_printf(sf, "%*pbl\n", cpumask_pr_args(isolated_cpus));
 		break;
+	case FILE_HOUSEKEEPING_CPULIST:
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(housekeeping_cpumask(HK_TYPE_DOMAIN)));
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -3428,6 +3455,15 @@ static struct cftype dfl_files[] = {
 		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
 
+	{
+		.name = "housekeeping.cpus",
+		.seq_show = cpuset_common_seq_show,
+		.write = cpuset_write_housekeeping_cpus,
+		.max_write_len = (100U + 6 * NR_CPUS),
+		.private = FILE_HOUSEKEEPING_CPULIST,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 0462b41807161..a92b0bb41de3a 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -27,6 +27,7 @@ enum hk_flags {
 #define HK_FLAG_KERNEL_NOISE (HK_FLAG_TICK | HK_FLAG_TIMER | HK_FLAG_RCU | \
 			      HK_FLAG_MISC | HK_FLAG_WQ | HK_FLAG_KTHREAD)
 
+static DEFINE_MUTEX(housekeeping_mutex);
 static BLOCKING_NOTIFIER_HEAD(housekeeping_notifier_list);
 
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -196,6 +197,43 @@ int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask
 }
 EXPORT_SYMBOL_GPL(housekeeping_update_notify);
 
+int housekeeping_update_all_types(const struct cpumask *new_mask)
+{
+	enum hk_type type;
+	struct cpumask *old_masks[HK_TYPE_MAX] = { NULL };
+
+	if (cpumask_empty(new_mask) || !cpumask_intersects(new_mask, cpu_online_mask))
+		return -EINVAL;
+
+	if (!housekeeping.flags)
+		static_branch_enable(&housekeeping_overridden);
+
+	mutex_lock(&housekeeping_mutex);
+	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
+		struct cpumask *nmask = kmalloc(cpumask_size(), GFP_KERNEL);
+
+		if (!nmask) {
+			mutex_unlock(&housekeeping_mutex);
+			return -ENOMEM;
+		}
+
+		cpumask_copy(nmask, new_mask);
+		old_masks[type] = housekeeping_cpumask_dereference(type);
+		rcu_assign_pointer(housekeeping.cpumasks[type], nmask);
+	}
+	mutex_unlock(&housekeeping_mutex);
+
+	synchronize_rcu();
+
+	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
+		housekeeping_update_notify(type, new_mask);
+		kfree(old_masks[type]);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(housekeeping_update_all_types);
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;

-- 
2.43.0


