Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5236EBFD0A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C32E6B00A3; Mon, 13 Apr 2026 03:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375596B00A5; Mon, 13 Apr 2026 03:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264D16B00A6; Mon, 13 Apr 2026 03:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E88F86B00A3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:45:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 987C4BD99D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:13 +0000 (UTC)
X-FDA: 84652746906.22.CF03195
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3F221A0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VITbZYv6;
	spf=pass (imf19.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQ44lW/U6rKhLB+VxvVCzN9hwjYmEMV1dg+CBNB6cSw=;
	b=ms/UCxs9DRd94prnuzGbmGSzY/Box3uDV4gY5VSGJMJTZocH0Tvul5+H+od8D54ktIeP7L
	LGY6dJw2O9hOPvcU2J4ETK1YqfVsvIAHPzYBSmbA0+ACkU8fqaUy8g72EWzvhLYT5Plzkw
	z8ORDqDTvsrb06KIBuAXu/TOH5xG6SA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VITbZYv6;
	spf=pass (imf19.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066311; a=rsa-sha256;
	cv=none;
	b=YPnFsr0qWuXXfgV06jRuN4EID1GZxHgwvSrgn3UvCO69r4/8jaM78FobkTgSCD98Y83gSG
	TZXpecfLqy2MMWk7ORjpTFsaxAOuKCkj7enfsyAkpuPvM5iRMhvzdrLhM/5pEuEi/0g45w
	8EoxhIPIHNUUThL0xaa8Cv3J5n2hVXI=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12c19d23b19so4090757c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066310; x=1776671110; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SQ44lW/U6rKhLB+VxvVCzN9hwjYmEMV1dg+CBNB6cSw=;
        b=VITbZYv6bdoKVkSCDatmlUNwyGQuxaal4fba8B2HzxKEq+Bjxd3zLo1A0Wq3BztTg4
         wafIwSx8FVtKINmwwik5Ls9tkQFs1NVJcX305444wkm+KF0u6URucJr1w6oJ0u3fjmjg
         PMhT/I+A7TbmPKg/RvC6UW1IsvX+R9I6e8LPl8W/IqotAm9t8ilGN4/96SFXbRn1MWCg
         faAGZYnB+D6z8Zf68ovmYa0TEnJ2syzOD6DSZwNLPZdf+2E7zt9DlnYPi21D8nr6AUFF
         pQL7OLfixDof2tfL5VlfNjefkGE7wXWT5EiKMtUMeDaBSiL8kPfYERMpxmmaOP28x6zn
         nvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066310; x=1776671110;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SQ44lW/U6rKhLB+VxvVCzN9hwjYmEMV1dg+CBNB6cSw=;
        b=aR/Ojf9h5je3cnh6X8FOuWkDr/5MiCyNoJ4LDkRFIlxDaWbJsHFHIpvpcW50FPKFCi
         KQL8AhltuW/NL6AO3wrAxd22jha4nBZy0+KFrDAUzmg0jasKWeZaz0GrLYozC5A8KKMB
         Q1Is7n5UJ8YVxUdZgXN3ydWeKQjRqdoH8WxIwJYdb5T8mCAUzcCl+yJgSZgiHcl92NIx
         4CH4lQoAj/WbvxxfurVA6B5A04q3nZwyjDKB5Iim731Vzhr3d/sj9Rwo6HZJ1gsiUUCb
         ynMUGn8GxCuyDdbBOlluAOWnafZnKNurP8Drjc+HNWdS4oTrwfzf8r3S3YB6T9DycOxB
         +JFQ==
X-Forwarded-Encrypted: i=1; AFNElJ+HwXN5vMjJEwxhVSDEu4sPOrypkm42xmAfK6MgH8+G41GCBDKBLmQhzKhytmLMpOyD4iX+QZPp5w==@kvack.org
X-Gm-Message-State: AOJu0YxTZC+AQjid3n2EUeOBayemOqsg6njpgiOqJFCJmaWjtml2IRii
	U7fxBFpmEi1erC169mjNU2PyLz6cjJnZ23xT/7svlwbGdDYFyAnFFTuypGKXQVQi
X-Gm-Gg: AeBDievc/YHB7xrWq3x4VyvNyxd92zmB3dHJLo10Q7ZAZqe8OhVzAjYMpfohTZ+/pp8
	zGGMZEOZGdYTat/gCpFJTLA75lVi6+e7zZXsDBCNv4uCkkC4zLPzMB9cBm4uFqrh0Gl9c7507u+
	wCCa5SG46Wd28QpTP/n3OmKx94//QYhlpjfiU7kCXJs7QnpP4ec0VHn4JXXgKbey08j2PQv8x9d
	lLRl3LaqbL8yn3RsCiRZWpzhOdCHWUDVibiG2NWkhHEh6ew0i02v40zhHpxK8Qx1up9QNyCjRUT
	+FaPVsyLG39vm+nL2RxupcCpD/Sp76PC3HvPG2v8lmmSiJNZd4la/elbM1dTee/z6OUiUiibT8B
	VfHs/7O92jz3RODro42tcAFzP4hXEiX4JXCraQde2rT7Nd2uBqOPHOM+qCoHyr0k+fCr6M71sai
	qyTvjPxWj0tmJ82po6
X-Received: by 2002:a05:7022:622:b0:128:df80:1852 with SMTP id a92af1059eb24-12c34e55bc9mr6509824c88.9.1776066310149;
        Mon, 13 Apr 2026 00:45:10 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:45:09 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:16 +0800
Subject: [PATCH v2 10/12] cgroup/cpuset: Implement SMT-aware grouping and
 safety guards
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-10-06df21caba5d@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: A3F221A0004
X-Stat-Signature: d6xeobhcfsa31rofa3wc19358hameerg
X-Rspamd-Server: rspam06
X-HE-Tag: 1776066311-455860
X-HE-Meta: U2FsdGVkX1+BiNk8YEjufMaM+3mwMyWV89DAUawbMEenGxg7weyp8p/eIOGnOBiaatCv8xwnq9kS2As0/svP8kADYUo9+rqnBF1yaFTqLgagoCSN5fyGkBJdc7+uCme8reeWN3kzHvWyK9j0Jo/XtBPG6zmjEzOFa/Lm3LAzTMIk8yFzOxyLVhrlsAm2CGrIh3qVJiTZ8PCTqCTa57VG1dOUgSm59H3pcYcxlj1rj7NdtKvLUFZ1SHA7gUm4jxNtJu0Y20na1LJ1t6S8pDCFAkaK8lWOu+8P6LneXDXFvjylxLoIvxVLYLVP6xEZM7mdHuOBOCZC9Am9IgljkHzrO8FBkdx4hpkG/8wTlqqqrv45nMiKoyjcYR3Yrww62Bjl3iAkV96EwxpUycczoPzBKfM72D/ouH16m72j0ha19AE8uaLUsqmARVYEIPwOTQjW8ROqrgmnpfF7TvANxig5IzIS/Aps+HdmMiXCwQdcXoI6GsP/0dx5B7CzWYpIlK1kmAL9p3I0C2F93yOd1Ci8PXy71xJSfQc+/VeGos3OJTY6pivKxQuFJGeX8vMMSDs31dyuxD0oWiWYHZP/3x1Svd5URyHalWwz5yX4CVXOIo45DeKZ0kTrdkkHYWDBMeXRviAsjyq5jCfqyZ4Q2gB2tZhPaB3BseB1vSvA595AIxQvadlDVBYbw2ws+68P1W6/0omQZuoZSFgUCvTKJiBfTlyp3dv2/p2UYfLOQ1R1KAZZxKMaJFl1rVGX5rX819XgGwkdYj1Pmyn9yp0FCx1qIx2p3Q5DnU1S5mwE5K3eQxDbznqWX5yF8d2QlmrW+JA5RG+YS+1qBefHz2apuD5to1OryAt/+6GWjKVRugmuB/8ph7xS/IiaXMPzkZ+pATtRZ9+5GPLNzx9t5TnfExiipElTBHrzMsXPow5oj5+kSDnE1+qPcZANSGmrjYiXp/wlLfQv9Q4Mgyj8vf9C72S
 Vi9t3wZl
 SzpS4/1xP9bMhybHcQSDbduLaFvX6rgx2NHdueoNbYQ5gacuvLvv0NPefET35hA6+h9ZVwZeRAsoDIUsWe6paTt5dm1KKIwZMdzHnv+Y/zm3ibT0XQrR3KzKyvHLqProjB3LMzM45A8RHlasmXZfMM1nUSROZFV3nERsUGSvMBhwyUqBc33PjeSMe8ruXz7JsnLzCjnWVLxVgsOPjXk1yB5OcYAW2JVkIgYPkBi6hnrY7g6mBdgA2tkJLRGxErBTZdlfZ2iSozG23+PFx4L/UZeEBKHtg7DW0UuyrusbCNFT0pUNXEV8xt07RkuB1hlRiUxfTWAjAl0l6eiRttbil+fvvKoJ2ebHwXSVqC1Uaa8koGw20xCrvvlkH+KqcdchNQ3witwVzU+f3lsL4BR8BfVEzRC6clj4TljyOgw9ony7uy4r8v0VPV/J146ONMlVS89BxtMTM78/NzYfYcLFiAe4vP1mxi+TlMzAqihly5i35s2YhKyYiQb0q9Yz0Y+NOSW666Dc5j77Wh+WZlFU9MhrFAFnAEQViA9Ed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dynamic Housekeeping Management allows runtime configuration of kernel overhead
isolation boundaries. However, configuring CPUMASKs that separate SMT siblings
(e.g., placing one hardware thread in the housekeeping mask and leaving
the other isolated) can lead to severe performance degradation due to
shared L1 caches and pipeline resources.

This patch introduces `cpuset.housekeeping.smt_aware`, a robust safety guard
to prevent user-space from splitting SMT sibling pairs across isolation boundaries.

When `cpuset.housekeeping.smt_aware` is enabled (1):
- Any write to `cpuset.housekeeping.cpus` must include all SMT siblings
  for each CPU presented in the new mask (verified via `topology_sibling_cpumask`).
- If an invalid mask is supplied, the write operation is aborted with `-EINVAL`.

This ensures the kernel's housekeeping constraints are met while maintaining
maximum hardware thread efficiency.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/cgroup/cpuset-internal.h |  1 +
 kernel/cgroup/cpuset.c          | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 3ab437f54ecdf..162594eaf8467 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -61,6 +61,7 @@ typedef enum {
 	FILE_EFFECTIVE_XCPULIST,
 	FILE_ISOLATED_CPULIST,
 	FILE_HOUSEKEEPING_CPULIST,
+	FILE_HOUSEKEEPING_SMT_AWARE,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5df19dc9bfa89..4272bb298ec3d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -37,6 +37,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/task_work.h>
+#include <linux/topology.h>
 
 DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
 DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
@@ -156,6 +157,9 @@ static bool		update_housekeeping;	/* RWCS */
  */
 static cpumask_var_t	isolated_hk_cpus;	/* T */
 
+/* DHM: Enable SMT-aware boundary checks */
+static bool cpuset_housekeeping_smt_aware = false;
+
 /*
  * A flag to force sched domain rebuild at the end of an operation.
  * It can be set in
@@ -3218,6 +3222,16 @@ static ssize_t cpuset_write_housekeeping_cpus(struct kernfs_open_file *of,
 	if (retval)
 		goto out_free;
 
+	if (cpuset_housekeeping_smt_aware) {
+		int cpu;
+		for_each_cpu(cpu, new_mask) {
+			if (!cpumask_subset(topology_sibling_cpumask(cpu), new_mask)) {
+				retval = -EINVAL;
+				goto out_free;
+			}
+		}
+	}
+
 	retval = housekeeping_update_all_types(new_mask);
 
 out_free:
@@ -3225,6 +3239,18 @@ static ssize_t cpuset_write_housekeeping_cpus(struct kernfs_open_file *of,
 	return retval ?: nbytes;
 }
 
+static ssize_t cpuset_write_housekeeping_smt_aware(struct kernfs_open_file *of,
+						   char *buf, size_t nbytes, loff_t off)
+{
+	bool val;
+
+	if (kstrtobool(buf, &val))
+		return -EINVAL;
+
+	cpuset_housekeeping_smt_aware = val;
+	return nbytes;
+}
+
 /*
  * Common handling for a write to a "cpus" or "mems" file.
  */
@@ -3317,6 +3343,9 @@ int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_HOUSEKEEPING_CPULIST:
 		seq_printf(sf, "%*pbl\n", cpumask_pr_args(housekeeping_cpumask(HK_TYPE_DOMAIN)));
 		break;
+	case FILE_HOUSEKEEPING_SMT_AWARE:
+		seq_printf(sf, "%d\n", cpuset_housekeeping_smt_aware);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -3464,6 +3493,14 @@ static struct cftype dfl_files[] = {
 		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
 
+	{
+		.name = "housekeeping.smt_aware",
+		.seq_show = cpuset_common_seq_show,
+		.write = cpuset_write_housekeeping_smt_aware,
+		.private = FILE_HOUSEKEEPING_SMT_AWARE,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
 

-- 
2.43.0


