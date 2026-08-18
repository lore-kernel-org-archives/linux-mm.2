Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 838DCC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7F06B08E2; Tue, 18 Aug 2026 02:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5815A6B08E6; Tue, 18 Aug 2026 02:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449EC6B08E7; Tue, 18 Aug 2026 02:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 035C16B08E2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:11:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76FAD160A52
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:01 +0000 (UTC)
X-FDA: 85113367122.28.F5C28E8
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 870FEC0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:10:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b66I5I80;
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787033459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOBdbjG7wg0kpAdHn038dSyaMR4LfRYkZkjGzLFsJjk=;
	b=y5Ku6mcV2egwljtNWiGwM/tErvh2NLeb8J3Rxp6jiyJQ9qS/yGIDUHZHWT+wuo1tuS5c4X
	Uw7kDdmGsYNfyK7y2mKfeMsW7ojIv1tWkxxyd8qx79++PYNH0HFQ3q8yhOHTTfR2sF8ShN
	bj3sW6XNrbVgCFcpLu0hN7+nfF66Kj8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787033459;
	b=HpKWD1kUfwDL0+mtFDBDrQTkZmYHmrOaYquXjKFfgC1ESrxPfQ/E4QkVJqiS/BR0VIMxA2
	OYAFA7FgSnyqaGdgnki7JLLxns2/N+rsstWA+Ps+oEDHFWKSVwD3YLhH9hfYcVYdi/n73V
	5czvK7/oqqW3m1Y0zE35wSZIFv8k2yc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b66I5I80;
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38dfe910e9dso4203072a91.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787033458; x=1787638258; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DOBdbjG7wg0kpAdHn038dSyaMR4LfRYkZkjGzLFsJjk=;
        b=b66I5I808YXpWJaMphHTE5uUf4+ylmq0Sp4EMNME61ep412RAiVuSzo88X9i6jATB5
         nAGGg8o6u6/9svbh4C6XDx2bboGoSA4bwv2gQctcZCPnsi0lDROmbm1V+7ENIbHyuFrs
         pRoTcizgzxba6fAX3KBXDSXGTdaOheMPWWmr43Re/69BwD7IuIUuXKZtIyY23brexpbv
         tfPOwe3ZwdXzssQx1C+TbYG+e6Y87ODrTWICBuklnY3+WKeFg1Pm/W5NNC+NuuPeRmeU
         +asytbIOsfCF0JL0rbJ695Iz8m7kZYNMuuf4lwt8ZOLkFuJHbNJDE+w/ofTo1Iu6wash
         GLVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787033458; x=1787638258;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DOBdbjG7wg0kpAdHn038dSyaMR4LfRYkZkjGzLFsJjk=;
        b=flrlYkgjDrfzVBeOV/UyaVpcjlUB/doeoutjpQ3eSt5lZKXXO8fWY1RsuraNjf5eO1
         r4dn96Ec0dlIJtqP8DAjswndxxRUt2zJYlujg72z38QmB4lgr9aCh6Fnva2WX37Yhkan
         vJ5eqzqBshGpqIjtI3Sw0SJAHUzIVA81lF+PJLN1RRLDu6nkTygShHohQZS7LQZ/jPM4
         +gFRieM9xGy8ZoFxMC2+tLc4Ug9kc2SarwG6IQs4raqSmqRGQ/CQT5Qgs/wMUjX7D8I6
         I/O/wSQNGABfYYj1AfTFXFWFa1TP71pHqqaMsvPDqpkap4cn0EODd9489YvOOTChAB2t
         giNw==
X-Forwarded-Encrypted: i=1; AHgh+RprhlDGFPhPOkppgTqKF6aizG72YnOBgwXV9gYjFpK33i0TYqDeuOmOS11reKOJr8A8+opLT0csbQ==@kvack.org
X-Gm-Message-State: AOJu0YzYnnDGIQ1XfmYhNxJZXxbIff2NSpRHVxFESBee3K1zmiicR8Sw
	trIMo1/QGmSTH9E3aiMP7N1noBpEoSqq4yO367Pdq+zyF8WcT1EoDeL4
X-Gm-Gg: AR+sD13BBNTbxXbXVekSCjg4E/7AmfW7qu1Hv/wDLbtJep1g66vvux4vxj5G9odxTDN
	YrOo7jUCACvcCxSl3301d8UqsriD5qHh4myhMzuTnhHkdBXTGfoSgPjLj8xVMLLTkGuVa5JaK/X
	zhcdOFPfP/I/VX5IdDoLiEZ516ZcXb4x6fIs1tI2HL1M0ULB1kW3WPIUztpQNnDtvmouCaWxmMn
	q16ZVXa+aRNF0bwKNFlpQWEammI+XK15Uo/B8WkW+W/wtD+cjSEaWaxPlydctbacnZ4o16ywTWC
	Xaql9e8HUPypKZ/0qxmQEyvBSd75+Cd7XV5yNa4eOJGbrmpEOS/2omjH6wfbqhHQCkAmLsBcb8U
	096iULpLN4t+JA7NpJD6MfjAVi0Xhae+J6zQa4tgm/oow5hCK7xbd1DItnypfh1Z7nBqEkZwaTg
	w1UVni6M+sQ2S5Etx3GFpCdQiui+Q93c7hg2Q1vsfMfla0WDycEja41VyN0BQkHzRnCksFrDnCw
	CP9h2g=
X-Received: by 2002:a17:90b:5685:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-3955a799fcdmr8128358a91.11.1787033458228;
        Mon, 17 Aug 2026 23:10:58 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d38bf94sm4633942a91.9.2026.08.17.23.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 23:10:57 -0700 (PDT)
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
Subject: [RFC PATCH 2/7] mm/damon/perf: implement observe API and per-CPU statistics engine
Date: Tue, 18 Aug 2026 14:10:26 +0800
Message-ID: <20260818061031.827057-3-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818061031.827057-1-kunwu.chan@linux.dev>
References: <20260818061031.827057-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mr3g1ti8ekciusu7nf8atgobnzknezth
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 870FEC0009
X-HE-Tag: 1787033459-308237
X-HE-Meta: U2FsdGVkX1+KJ9DTLR6Zfcb5ZJ63JQKs3xr4ZLn5aLJRGh0P8M73ggRLTQYWR3iu+rHHsLs/mR4xT9nxyo2HKaY7/Br0/bkNdXwhHQQlluc5cZ908Zumn6Hmv2kkgjJ4oGyDUNaZPsiyIJfZZ9rRAGR2AO0Jx+9swG3+Jb7Le6vkdczSl7Sso8TdelG26K47sgyuMtwAniWcctiGlxH9yjjSAcH1zIve+dyDNnacTOFXyFxtrtDsvqc7/BvXQmolBQNdFSQ/c/+x+Bq8UT8ZcPV0W0BSEKHIsJ4v4tb3+6UupOPLl47ZLQqJ5qx9zcQNeK1ENSP43R6fQ34vj/HSNu+jOHkwZjtLCB8V4cZwj0bm9XzJPsoHyddkiqb03Oe1GgG0SmA8Iu1VSmxXOQL15D9fhVveaFy1Wy3aG02toY45bneW6WfJM3TXvMWxYo1nVbrsbKYqBPrg+pPYbdrWr/FMtRknbuq7kL8/GSMJIBdN40lrBPO2Tzwta3Lm9+G/CNAvi218cCWUVSZZEROPqNMhUYoPqXi2IWNBZTcEW9nCQx63ORFvk3r8ItmIkf4b40NNsNdptUvBPWSHfVJplNSxqkqg3uftS3oD2MVuzgCnY/7lsoRYDLnHs96edmgjvzsEDd3jEakk0sYOxBqdohJkVxLaiX0phBn7qs4TB2eIzrlf5HG/8yaaZnfpOBYb+ydYevE29cN3EGQTs9bVb1z5BpMC9jN8Yx4qBxTtUf4i0c16tu+C+YG1kLxDJshZb+zqUScR8JifigELGzxbo05EkLKVst+LSqZgbT199NI/yIUFq7MP6Frh7WIzc57LCID2nsUBdMWpsZuBePT3UHot6A5t9mYqWLhsXv9Jalq4N/woQlOZQKaQNsWWtPodOVL9tB/r5J7MQ5HN+HCCpf/iKMJZNmppavQxzh8Xzm9htNHvQMqFdfEROmXDRZ5WfmFgHht4+xADrIj6QMT
 ATmfKJt6
 GN+axplwtKdW1Be5WburQ7v8VYlOXKEJQatQrMTlec+TJnr+KrrhYyADBRvmpebT9JpH38QoRTErJEKC7FuKJhccKtN6ka5UdjeUTZur/UxTifWUQHZuAVJa1qSkxKjSRgEXJWVKllZfe/jexjjiQpY4GkrEC8m13D4XIJh4xn0Ltyn45qekArdqfCO0j5ATWAG/TUb8Zsk1Egn9J99a51Q/9dMebpFqK5w2+8rPc2CB8tWBzDmCNFvLKdZ15ZFYbq3NPGUSaAlQQZWxopJ5oKWi6vaua5XPkb9goCScpo7v8vZYm75VI4WVp7O4AKgJ5VXJ+jyhh7H2XlEKNudkAhgpzjOww1zbqoGTxO7wGyA1N8MGDYZmCH4klX5B+lUyE6IP0n2PmMASK0nQLLOgS8gocJeB0qlbcRUSX17ZLr2og2eevbfYU6011RdWK6PknkQAcbPj33P4L7pWrl4LgDnqH6hFlXcZ0OSEKnssxFJbsRFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

Implement the observe_*() core: per-CPU monotonic counters, the
event-lifecycle hooks with lazily-allocated per-event per-CPU state
alongside the global per-CPU stage, NMI-safe sample classification,
ring enqueue/dequeue/peak, match/miss/update, and framework init.  The
global per-CPU stage advances monotonically so a late create/bind/
enable cannot regress a CPU that is already RUNNING.

damon_perf_observe_sample() records the execution context
(process/softirq/hardirq/NMI) so overflow callbacks can be verified to
fire in the expected context.

Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/damon/perf/Makefile |   2 +
 mm/damon/perf/stats.c  | 295 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 297 insertions(+)
 create mode 100644 mm/damon/perf/stats.c

diff --git a/mm/damon/perf/Makefile b/mm/damon/perf/Makefile
index cc0d4f1d1d28..5c46d3da7ef8 100644
--- a/mm/damon/perf/Makefile
+++ b/mm/damon/perf/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
 # Observability: per-CPU counters, tracepoints, debugfs perf_stats
+obj-$(CONFIG_DAMON_PERF_OBSERVE)	+= damon-perf.o
+damon-perf-objs			:= stats.o
diff --git a/mm/damon/perf/stats.c b/mm/damon/perf/stats.c
new file mode 100644
index 000000000000..a869f115bb26
--- /dev/null
+++ b/mm/damon/perf/stats.c
@@ -0,0 +1,295 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON Perf Observability — Per-CPU Statistics & Observe API
+ *
+ * All hardware-sampling backends funnel through the observe functions
+ * defined here.  Counters always increment when
+ * CONFIG_DAMON_PERF_OBSERVE=y; tracepoints are guarded by
+ * trace_*_enabled() for zero overhead when ftrace is not attached.
+ *
+ * Per-CPU counters are best-effort: individual u64 writes are atomic
+ * on 64-bit platforms, but no cross-field consistency is guaranteed.
+ * Snapshot reads may race with concurrent writers.  This is debug data
+ * — do not build policy on it.
+ */
+
+#include <linux/cpu.h>
+#include <linux/percpu.h>
+
+#include <trace/events/damon.h>
+
+#include "perf.h"
+
+/*
+ * Per-CPU statistics
+ */
+static DEFINE_PER_CPU(struct damon_perf_stats, damon_perf_stats);
+
+/*
+ * Per-CPU event state for the state machine — the maximum lifecycle
+ * stage ever reached on each CPU (any event).  Set by the NMI
+ * observe_sample() (ENABLED→RUNNING) and by lifecycle functions as a
+ * monotonic "best CPU so far".  Never reset to UNINIT — destroying one
+ * event must not hide that another event is still running on the same
+ * CPU.  Per-event per-CPU state (event->cpu_state) tracks individual
+ * event lifecycle for correctness when multiple events exist.
+ */
+static DEFINE_PER_CPU(int, damon_perf_cpu_state);
+
+/*
+ * Event lifecycle — process context (kdamond / cpuhp callbacks).
+ *
+ * Each event tracks its own per-CPU lifecycle state via
+ * event->cpu_state (allocated on first CREATED, freed on DESTROYED).
+ * The global damon_perf_cpu_state is also advanced (monotonic) so that
+ * debugfs perf_stats shows the "best" stage any event reached on each
+ * CPU.  Diagnostics are emitted via tracepoints, not dmesg.
+ */
+
+/*
+ * Advance the global per-CPU lifecycle state monotonically.  The global
+ * reflects the best stage any event ever reached on this CPU; a late
+ * create/bind/enable must not regress a CPU that is already RUNNING.
+ */
+static void damon_perf_cpu_state_advance(int cpu, int state)
+{
+	int cur = READ_ONCE(per_cpu(damon_perf_cpu_state, cpu));
+
+	if (state > cur)
+		WRITE_ONCE(per_cpu(damon_perf_cpu_state, cpu), state);
+}
+
+void damon_perf_observe_event_created(struct damon_perf_event *event, int cpu)
+{
+	if (!event->cpu_state) {
+		event->cpu_state = alloc_percpu(int);
+		if (!event->cpu_state)
+			return;
+	}
+	*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_CREATED;
+	damon_perf_cpu_state_advance(cpu, DAMON_PERF_STATE_CREATED);
+}
+
+void damon_perf_observe_event_bound(struct damon_perf_event *event,
+		int cpu, struct perf_event *perf_event)
+{
+	if (event->cpu_state)
+		*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_BOUND;
+	damon_perf_cpu_state_advance(cpu, DAMON_PERF_STATE_BOUND);
+}
+
+void damon_perf_observe_event_enabled(struct damon_perf_event *event,
+		int cpu, int state, int oncpu)
+{
+	if (event->cpu_state)
+		*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_ENABLED;
+	damon_perf_cpu_state_advance(cpu, DAMON_PERF_STATE_ENABLED);
+}
+
+void damon_perf_observe_event_disabled(struct damon_perf_event *event,
+		int cpu, int state)
+{
+	/* State unchanged: the event may be re-enabled later. */
+}
+
+void damon_perf_observe_event_destroyed(struct damon_perf_event *event, int cpu)
+{
+	/*
+	 * Reset only this CPU's slot.  The per-CPU array is owned by the
+	 * event as a whole and must NOT be freed here: destroyed() is
+	 * invoked from the per-CPU CPU-offline callback, so freeing the
+	 * whole array on the first offline CPU would leave every other
+	 * still-online CPU with a dangling pointer.  The array is freed
+	 * once by damon_perf_observe_event_free() at event teardown.
+	 */
+	if (event->cpu_state)
+		*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_UNINIT;
+}
+
+void damon_perf_observe_event_free(struct damon_perf_event *event)
+{
+	if (event->cpu_state) {
+		free_percpu(event->cpu_state);
+		event->cpu_state = NULL;
+	}
+}
+
+/*
+ * Sample observed — NMI-safe.
+ *
+ * The @cpu argument is the CPU the sample fired on; it is passed
+ * through to the tracepoint but stats are always written on the
+ * current CPU via this_cpu_ptr().
+ */
+
+void damon_perf_observe_sample(unsigned long addr, u64 data_src,
+		u64 period, int cpu, u8 reason,
+		u64 sample_flags, u64 sample_type)
+{
+	this_cpu_inc(damon_perf_stats.callback);
+
+	switch (reason) {
+	case 0:
+		this_cpu_inc(damon_perf_stats.sample_valid);
+		break;
+	case 1:
+		this_cpu_inc(damon_perf_stats.sample_null);
+		break;
+	case 2:
+		this_cpu_inc(damon_perf_stats.sample_addr_zero);
+		break;
+	case 3:
+		this_cpu_inc(damon_perf_stats.sample_kernel);
+		break;
+	case 4:
+		this_cpu_inc(damon_perf_stats.sample_invalid_phys);
+		break;
+	}
+
+	/* First callback advances state to RUNNING */
+	if (this_cpu_read(damon_perf_cpu_state) == DAMON_PERF_STATE_ENABLED)
+		this_cpu_write(damon_perf_cpu_state, DAMON_PERF_STATE_RUNNING);
+
+	/*
+	 * Record the execution context so callers can verify whether
+	 * overflow callbacks actually fire in the expected context
+	 * (e.g. NMI for IBS, process for SPE AUX drain).
+	 *
+	 * 0 = process, 1 = softirq, 2 = hardirq, 3 = NMI
+	 */
+	if (trace_damon_perf_sample_enabled())
+		trace_damon_perf_sample(addr, data_src, period, cpu, reason,
+				sample_flags, sample_type,
+				in_nmi() ? 3 : in_hardirq() ? 2 :
+				in_serving_softirq() ? 1 : 0);
+}
+
+/*
+ * Ring operations — enqueue / overflow are NMI-safe
+ */
+
+void damon_perf_observe_ring_enqueue(void)
+{
+	this_cpu_inc(damon_perf_stats.enqueue);
+}
+
+void damon_perf_observe_ring_overflow(int cpu)
+{
+	this_cpu_inc(damon_perf_stats.overflow);
+	if (trace_damon_perf_ring_overflow_enabled())
+		trace_damon_perf_ring_overflow(cpu);
+}
+
+void damon_perf_observe_ring_dequeue(int cpu)
+{
+	per_cpu_ptr(&damon_perf_stats, cpu)->dequeue++;
+}
+
+void damon_perf_observe_ring_peak(unsigned int occupancy)
+{
+	struct damon_perf_stats *st = this_cpu_ptr(&damon_perf_stats);
+
+	if (occupancy > READ_ONCE(st->ring_peak))
+		WRITE_ONCE(st->ring_peak, occupancy);
+}
+
+/*
+ * Matching — process context (kdamond drain loop)
+ */
+
+void damon_perf_observe_match(unsigned long addr, int cpu)
+{
+	per_cpu_ptr(&damon_perf_stats, cpu)->match++;
+}
+
+void damon_perf_observe_miss(unsigned long addr, int cpu, int reason)
+{
+	struct damon_perf_stats *st = per_cpu_ptr(&damon_perf_stats, cpu);
+
+	switch (reason) {
+	case DAMON_REPORT_MISS_TGID:
+		st->miss_tgid++;
+		break;
+	case DAMON_REPORT_MISS_NOREGION:
+		st->miss_region++;
+		break;
+	case DAMON_REPORT_MISS_BOUNDARY:
+		st->miss_boundary++;
+		break;
+	}
+
+	if (trace_damon_perf_report_missed_enabled())
+		trace_damon_perf_report_missed(addr, cpu, reason);
+}
+
+void damon_perf_observe_update(int cpu)
+{
+	per_cpu_ptr(&damon_perf_stats, cpu)->update++;
+}
+
+void damon_perf_observe_drain(unsigned int total, unsigned int matched)
+{
+	if (trace_damon_perf_drain_enabled())
+		trace_damon_perf_drain(total, matched);
+}
+
+/*
+ * Stats accessors (for debugfs)
+ */
+
+/*
+ * Best-effort per-CPU snapshot.  Individual u64 writes are atomic on
+ * 64-bit platforms; no cross-field consistency is guaranteed.  This is
+ * debug data only — do not build policy on it.
+ */
+void damon_perf_stats_snapshot(int cpu, struct damon_perf_stats *dst)
+{
+	struct damon_perf_stats *st = per_cpu_ptr(&damon_perf_stats, cpu);
+
+	*dst = *st;
+	dst->cpu_state = per_cpu(damon_perf_cpu_state, cpu);
+}
+
+void damon_perf_stats_aggregate(struct damon_perf_stats *dst)
+{
+	int cpu;
+
+	memset(dst, 0, sizeof(*dst));
+	dst->cpu_state = DAMON_PERF_STATE_RUNNING; /* start optimistic, take min */
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		struct damon_perf_stats *st = per_cpu_ptr(&damon_perf_stats, cpu);
+
+		dst->callback		+= st->callback;
+		dst->sample_valid	+= st->sample_valid;
+		dst->sample_null	+= st->sample_null;
+		dst->sample_addr_zero	+= st->sample_addr_zero;
+		dst->sample_kernel	+= st->sample_kernel;
+		dst->sample_invalid_phys += st->sample_invalid_phys;
+		dst->enqueue		+= st->enqueue;
+		dst->dequeue		+= st->dequeue;
+		dst->overflow		+= st->overflow;
+		dst->ring_peak		= max(dst->ring_peak, st->ring_peak);
+		dst->match		+= st->match;
+		dst->miss_tgid		+= st->miss_tgid;
+		dst->miss_region	+= st->miss_region;
+		dst->miss_boundary	+= st->miss_boundary;
+		dst->update		+= st->update;
+		/*
+		 * Aggregate per-CPU state: the pipeline hasn't passed a
+		 * stage until ALL CPUs have passed it, so take the min.
+		 */
+		dst->cpu_state = min_t(int, dst->cpu_state,
+				per_cpu(damon_perf_cpu_state, cpu));
+	}
+	cpus_read_unlock();
+}
+
+/*
+ * Subsystem init
+ */
+
+int damon_perf_framework_init(void)
+{
+	return 0;
+}
-- 
2.43.0


