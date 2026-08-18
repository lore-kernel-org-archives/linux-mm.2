Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D445C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841D16B08E6; Tue, 18 Aug 2026 02:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F25D6B08E8; Tue, 18 Aug 2026 02:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA626B08EB; Tue, 18 Aug 2026 02:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33FDA6B08E6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:11:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4D21140B34
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:07 +0000 (UTC)
X-FDA: 85113367374.24.72B1D97
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id C6B4D40008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fneTun6e;
	spf=pass (imf07.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787033465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFTkBKzl9DDztkv9Ak+eApuO538I5zXX6YMBdyPiC24=;
	b=qdN5SOBfK1byzExKZ4d5ZEsG3CrhipefB562pqe8tzNVPgnq9JLRh+iI/R+Z9daoOrrzKB
	pC7vG0GPDovVzwyuT63x0sY1ibBvzXTVE5dSNkKyZdXkevzxRv7+gYOgwtiBsbAh4paTOa
	uAJWxQ2GSlbws2co6xz5Upy/vaIFMlM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fneTun6e;
	spf=pass (imf07.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787033465;
	b=XXtEUWOb6y79HkSphltmZp72lOj2tveGO3ob33kyPuGVXHXvqnTcOzQx9i26p1HOLleKMk
	AOQeOztHHf/GGvQNSKXVew67yreF4Lj2kaHGpas7Kc2ipV8si655FWgG90VQUcD3Sg4YMI
	4aZHCPjE3EYMqk0MjbtfT0feM1k1lFc=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso5492048a91.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787033465; x=1787638265; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PFTkBKzl9DDztkv9Ak+eApuO538I5zXX6YMBdyPiC24=;
        b=fneTun6eRg8xSdVSXlCNS5tROjMQvJ/1HzORb7ny1QTL1UrpV706Sy8b91VmbxA0bH
         okFvAumhLofyaeM/Ea8ytqbqTy0JgLdUITX99/jl1uV+I9sCU3Zp+xvDe9Dl4vT8FUFc
         AJAovrFZIWQfKkj66slGuOcuZebLrCTxzRVfzXLo+L8flzj0WI/K8vT3JC11gZKoDExr
         TScUHYeEZG9ImHBvhAGu4MWWqSQ+baxwWFKIw2RF8H9977fgxNQ/RPrsuc2wJ6HFV58r
         +p70CrPQnyBrQId1W6rGE52v0jny23QUADkGah7G2Bw/9EVBQ5RRotLm4RkuLaat0oPi
         FMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787033465; x=1787638265;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PFTkBKzl9DDztkv9Ak+eApuO538I5zXX6YMBdyPiC24=;
        b=Wdnkyv6dvzVzB6diq7qLBVt3T/Hfl2OTCjm+Aa7dOIkAyA/zZaVSkNKgHU7smqzjbm
         3iGTG/CGvdh+0umfzqBLBdXR87RXlNj1b58IeFLam2Bub7AA8LZnooMmMKkObYVPjSEc
         dOMPqwELUuBeCY5+Mmqb5xG0mHTyanU3jIn/gyCLfVUtUx8t7yIg5C65HPqQbFSntSIr
         l2tbsqR7VJpZ75KchNqu9J55Ht/H8bqA9KiLPJ4Y5LE1zo6dnHZdBDx15jdpnDVS5WX0
         zn4m2CYpaLO15MRdHWq3h+zffk7GYvkE9/kSeXPlgQSaF6HZfiGDLlBBPqmphRAlgIqI
         hWag==
X-Forwarded-Encrypted: i=1; AHgh+RqAkMc48isDHVN4uxiewiRcN1MCLCmtFhl7iflYw7yMOBSuihoJWMbT5lY0x3eQVq8sesMt1D3TRQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1mcg/oauRu6nHxcbByWCah9ZpKeY2nAyk30fdy5bMc8KVQWUq
	VEnxezR8qPjGMPbjYG2gIUSpfo/NLvuhnoxuhscZL3rLxx6qJcQB2NbJ
X-Gm-Gg: AR+sD11N0xq4stJee51+5qRl7PalzvmC1+fFuJswy1Qhcswdw26EsyY4XCs1m/JD5j3
	iIscldc9cIno4zew+IsZnc9zZfajItjt6fFuAFUocwt5sywiXFSIukS+V9oWGnQ/pICZtCLLNxc
	9DHyPL08SQdHAdbUuHjMfA5Gvj2DdV+uxkMidr/KVIrQ+/mOZU/3PCEL3/JDF70oAtBKydBZuK4
	/y0mfw+7A3WKeqLmHNJ9udyZTND4GuVRp1rX1SMpQOkIIj2Q1IpiwTT0LcE0ck10GuEDkhbM4Wd
	EIDbEAv7xvo7zN23Jr+OdRqkBgbGnIVGH9KcRt1JN8do1Z/65M4Yn4fmRUrc1MvZ1QlbasiVQdO
	9/pgpqEoQU65ia8clW9D/vdo+ZYWYh8hgkxwFFhrPcjk28m2G7JssBnGNxv0SmMsguM/Zu4nygG
	MIqSYjHVUpzL73sYKy97t2WMq8ZF4zflMFH0IKjDmfDjWuN39WtuEbXoRwArFRnLUN2uF6wLUZ3
	ryior4=
X-Received: by 2002:a17:90a:ec83:b0:381:e74f:8a6a with SMTP id 98e67ed59e1d1-3933b8c1041mr33609337a91.16.1787033464444;
        Mon, 17 Aug 2026 23:11:04 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d38bf94sm4633942a91.9.2026.08.17.23.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 23:11:04 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	shuah@kernel.org,
	lianux.mm@gmail.com,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 3/7] mm/damon/perf: add debugfs statistics interface
Date: Tue, 18 Aug 2026 14:10:27 +0800
Message-ID: <20260818061031.827057-4-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818061031.827057-1-kunwu.chan@linux.dev>
References: <20260818061031.827057-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6B4D40008
X-Stat-Signature: 4u7d4r93sfec9uz79bum1h7wktk4dnqy
X-Rspam-User: 
X-HE-Tag: 1787033465-212099
X-HE-Meta: U2FsdGVkX19u50pK+Yb8RKKa9C461tjDrEnQDfrFFw+ZqpFqoBs8X4Mp77ZG+4P1F7ElS9+dLFBblbOgwBdpS5URmjMFG9XlZYBJO+JOKHGAP3Pq8fDtSvqG4mrUz6HzYTn83h3At16PZxDjOaGeoMi4JUn1eNKPNHD8craVqwYi7FEj87QoDPak/sXWb4RULj8VEc/pnVx1Hj5v5C2OFa+I9V9rXGUaTMSbJh9yK0fCaIcU4qkoijLMf+OjznhNPEWpOwmPqGX7MMBy0YStH3b8gSQQLfrsJYBNJydl0dkPx6n2ffcfMK4Lkcs6tEYSXPCItxL4yzl3tOsHRL2DQ4OkkotIcupomA/O61SWtQ2cRFP7nPa15zzekwDbtz1KySTcQGUPGm0Zd4pgGiMldVEznwefHbcSM8T7W+kpcndWcUgZuUo9kMwBCVyDtgsl3RixvqHDao/k/+F9t4VtFVkowazwG1YogqZQVvFL82Q1vpOa82qqDcbcdi7xnAiKIMsNRCrhpN+B+3dhoFCeDtiQeqWizpFegUaU0B2Qarcshcbt3WUOyS83Sfkb39xX5BxsIaP2Ay8A6YiLfEOqReuQosnwRWyIpPxCPtwGKTlSUvsicWvtUh0zCnkSlpiS1PG+AFgKgz7MZQ2UtZ4sLCiAeHN6J9oA00TGip+dkq/a/8P+JmJMr08fXRsoUMl573r/kD+j78HLZiiJuytS0mugWl06TdoHRokp2cK7lkFOfl6OwRHgrylZGtgIpJNCC0FahigMYOXofm+Gu/uZGQGNsxFTDkzmwsWUI0YT+NBpzAGvDHlvI45mLAMVOrecarS2aFNUbIpGi/VVHcQGem4ee8WndV7gWTkKQ/NQmTJ1137bSXT1ddAvPx5Q2SYmBimxOfPHYV741M9h5VB92UboNG2kLwOxxE+AdNakPFyjmrFnEb63OPFfnXAfd24zR5lyz4ZcmODY+lJq7VY
 e/eKycAk
 33U2gC8+F5HvBFafXK5Zp9DoQkXp696HjASr+QFwYRV+XgoUYfJEYCWgBhG2ucPlSZteUOODDa6st5d+cw6c7rJcaDDbC1Epe8i4w+CzG5fiCwtpovU65a7O05T3yOMn6woLNCqVA9pZmEL+QzY+Ed3t41nnE83p1zWbY0uhbKBlj0JSaOnki2+WL41PwQ8wxCDCpx/kCH4nyuK5pIfNl1adRLtLCqEaTPgFrNmpXa12smsaVWdLzyJCEp7RIcLfCvxr6soVqQ6MvJAhG0CHwZkdzCeikDu25bE55Dkm6SP2nxT5WzBWgXszN1HxoEnAOS67ejgxgPRMEgtP0IjYFYERwZwtqqIh3cInjiv7TKdo2lFQQvW1qD9idE+1eBb9/g2LeoYzjiLlo3nx2ryj2SqVk0x6Ah0B9evHAJaK6K5WskP1i6Ic9tNIsHB34RbHTTwu4Oc5ul+3Wy48EyaUzPcbcZP/HcduiANoI9j+05hW6+cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lian Wang <lianux.mm@gmail.com>

Expose the aggregated per-CPU counters and the global event-stage in a
debug-only debugfs perf_stats file.  The format is explicitly unstable;
tracepoints are the stable diagnostic interface.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/damon/perf/Makefile  |   2 +-
 mm/damon/perf/debugfs.c | 142 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/perf/stats.c   |   2 +-
 3 files changed, 144 insertions(+), 2 deletions(-)
 create mode 100644 mm/damon/perf/debugfs.c

diff --git a/mm/damon/perf/Makefile b/mm/damon/perf/Makefile
index 5c46d3da7ef8..150cbaa875fa 100644
--- a/mm/damon/perf/Makefile
+++ b/mm/damon/perf/Makefile
@@ -2,4 +2,4 @@
 
 # Observability: per-CPU counters, tracepoints, debugfs perf_stats
 obj-$(CONFIG_DAMON_PERF_OBSERVE)	+= damon-perf.o
-damon-perf-objs			:= stats.o
+damon-perf-objs			:= stats.o debugfs.o
diff --git a/mm/damon/perf/debugfs.c b/mm/damon/perf/debugfs.c
new file mode 100644
index 000000000000..c54dd7644ac3
--- /dev/null
+++ b/mm/damon/perf/debugfs.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON Perf Observability — debugfs Interface
+ *
+ * Exposes one file under /sys/kernel/debug/damon/:
+ *
+ *   perf_stats — per-CPU pipeline statistics in tabular form
+ *
+ * DEBUG ONLY — format may change without notice; do not parse in
+ * scripts.  For stable diagnostics, use the tracepoints under
+ *   /sys/kernel/debug/tracing/events/damon/
+ */
+
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include "perf.h"
+
+static struct dentry *damon_debugfs_dir;
+
+/*
+ * perf_stats
+ */
+
+static const char *state_name(int s)
+{
+	switch (s) {
+	case DAMON_PERF_STATE_UNINIT:	return "UNINIT";
+	case DAMON_PERF_STATE_CREATED:	return "CREATED";
+	case DAMON_PERF_STATE_BOUND:	return "BOUND";
+	case DAMON_PERF_STATE_ENABLED:	return "ENABLED";
+	case DAMON_PERF_STATE_RUNNING:	return "RUNNING";
+	case DAMON_PERF_STATE_ERROR:	return "ERROR";
+	default:			return "?";
+	}
+}
+
+static int perf_stats_show(struct seq_file *m, void *v)
+{
+	struct damon_perf_stats agg, st;
+	int cpu;
+	bool first = true;
+
+	damon_perf_stats_aggregate(&agg);
+
+	seq_puts(m, "    --------------  ----------\n");
+	seq_puts(m, "    Counter          Value\n");
+	seq_puts(m, "    --------------  ----------\n");
+
+#define STAT_ROW(label, field) \
+	seq_printf(m, "    %-12s   %8llu\n", label, agg.field)
+
+	STAT_ROW("callback",    callback);
+	STAT_ROW("valid",       sample_valid);
+	STAT_ROW("null",        sample_null);
+	STAT_ROW("addr_zero",   sample_addr_zero);
+	STAT_ROW("kernel",      sample_kernel);
+	STAT_ROW("inv_phys",    sample_invalid_phys);
+	STAT_ROW("enqueue",     enqueue);
+	STAT_ROW("dequeue",     dequeue);
+	STAT_ROW("overflow",    overflow);
+	STAT_ROW("ring_peak",   ring_peak);
+	STAT_ROW("match",       match);
+	STAT_ROW("miss_tgid",   miss_tgid);
+	STAT_ROW("miss_region", miss_region);
+	STAT_ROW("miss_bound",  miss_boundary);
+	STAT_ROW("update",      update);
+
+#undef STAT_ROW
+
+	seq_puts(m, "    --------------  ----------\n\n");
+
+	/* Per-CPU breakdown */
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		damon_perf_stats_snapshot(cpu, &st);
+
+		/* Skip truly idle CPUs */
+		if (st.cpu_state == DAMON_PERF_STATE_UNINIT &&
+		    !st.callback && !st.enqueue && !st.dequeue)
+			continue;
+
+		if (first) {
+			seq_puts(m, "  Per-CPU (non-zero / non-UNINIT):\n");
+			first = false;
+		}
+
+		seq_printf(m, "  CPU%02d: st=%-7s cb=%llu enq=%llu deq=%llu ovf=%llu match=%llu tgid=%llu noreg=%llu bound=%llu upd=%llu\n",
+			cpu, state_name(st.cpu_state),
+			st.callback, st.enqueue, st.dequeue,
+			st.overflow, st.match,
+			st.miss_tgid, st.miss_region, st.miss_boundary,
+			st.update);
+	}
+	cpus_read_unlock();
+
+	return 0;
+}
+
+static int perf_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, perf_stats_show, NULL);
+}
+
+static const struct file_operations perf_stats_fops = {
+	.open		= perf_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/*
+ * Init / teardown
+ */
+
+int damon_perf_debugfs_init(void)
+{
+	if (!debugfs_initialized())
+		return -ENODEV;
+
+	/*
+	 * Create the "damon" directory first.  debugfs_create_dir() mounts
+	 * debugfs via simple_pin_fs() before touching debugfs_mount, so it
+	 * is safe to call during initcall time -- unlike debugfs_lookup(),
+	 * which dereferences debugfs_mount unconditionally and crashes with
+	 * a NULL mount.  If the directory already exists (created by another
+	 * DAMON interface) debugfs_create_dir() returns -EEXIST; fall back
+	 * to debugfs_lookup(), which is now safe because the mount exists.
+	 */
+	damon_debugfs_dir = debugfs_create_dir("damon", NULL);
+	if (damon_debugfs_dir == ERR_PTR(-EEXIST))
+		damon_debugfs_dir = debugfs_lookup("damon", NULL);
+	if (IS_ERR(damon_debugfs_dir))
+		return PTR_ERR(damon_debugfs_dir);
+
+	debugfs_create_file("perf_stats", 0400, damon_debugfs_dir,
+			NULL, &perf_stats_fops);
+
+	return 0;
+}
diff --git a/mm/damon/perf/stats.c b/mm/damon/perf/stats.c
index a869f115bb26..ae5b0037a31d 100644
--- a/mm/damon/perf/stats.c
+++ b/mm/damon/perf/stats.c
@@ -291,5 +291,5 @@ void damon_perf_stats_aggregate(struct damon_perf_stats *dst)
 
 int damon_perf_framework_init(void)
 {
-	return 0;
+	return damon_perf_debugfs_init();
 }
-- 
2.43.0


