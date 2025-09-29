Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C4BCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 11:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2308E0028; Mon, 29 Sep 2025 07:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63178E0002; Mon, 29 Sep 2025 07:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04228E0028; Mon, 29 Sep 2025 07:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95AB48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:42:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C43486C3B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:42:54 +0000 (UTC)
X-FDA: 83942101068.06.06F9234
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68192180004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:42:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d5FDUCj0;
	spf=pass (imf24.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759146172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfADzoiCbyBtyAaLw463Wx6LUyiLBEBIcUcZudbfl5k=;
	b=goUqVohg71MuNmYi0rS41vG/ZpdLOcL5cYq+iy/80NlbAacZXnRkhiNjWSDQQOKi4TjLKm
	oC8QkqTjrAbD2qN+CPN/LVa9wCtZ4oIeRck/4O2jV6522YggTg+ob6j5wj81fWG12qpDaf
	qxS8oHI2Q/6lqotjWTItIL0ugoCPjpo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d5FDUCj0;
	spf=pass (imf24.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759146172; a=rsa-sha256;
	cv=none;
	b=22um2wN4KEE8Xp8EI05jLJbtcV1wM0EgyZXhyDpXl+HTO1xDU86UlGDZmfk2Eu8iNOixcY
	7oXP9OVmIV1/DbCHXXfpRIESNawXbIqmEvSGAGVuhnJu+PuqfiuHh/pVahva7DfXA+iEXC
	JDHxPkKwHUrqvWs2ukA8WswmwE4pv0U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759146171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FfADzoiCbyBtyAaLw463Wx6LUyiLBEBIcUcZudbfl5k=;
	b=d5FDUCj0PlRPg0H+hspAUVGtL/5igYoL0ZYjd6yKM7iSFnuoC3uCOiQOwh/EbMDgOBBrj0
	5hqB5m6NkLlE84TxlgA8UtsKqYcLDnxCBBtN+UYV9awVznQNB1an1gHM8JTSPM6Rrvlemn
	uRAyH4TtgG2gk6E9hXYfYVWvMezQwxo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-M6vFsBw4NUqOLclGlyQs1Q-1; Mon,
 29 Sep 2025 07:42:50 -0400
X-MC-Unique: M6vFsBw4NUqOLclGlyQs1Q-1
X-Mimecast-MFC-AGG-ID: M6vFsBw4NUqOLclGlyQs1Q_1759146169
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4CE7195608E;
	Mon, 29 Sep 2025 11:42:48 +0000 (UTC)
Received: from gmonaco-thinkpadt14gen3.rmtit.csb (unknown [10.44.32.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6910E19560A2;
	Mon, 29 Sep 2025 11:42:44 +0000 (UTC)
From: Gabriele Monaco <gmonaco@redhat.com>
To: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Gabriele Monaco <gmonaco@redhat.com>
Subject: [PATCH v3 3/4] sched: Compact RSEQ concurrency IDs in batches
Date: Mon, 29 Sep 2025 13:42:24 +0200
Message-ID: <20250929114225.36172-4-gmonaco@redhat.com>
In-Reply-To: <20250929114225.36172-1-gmonaco@redhat.com>
References: <20250929114225.36172-1-gmonaco@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68192180004
X-Stat-Signature: ytguzmdrny98iqq1dufzh8ccjcowkufm
X-HE-Tag: 1759146172-88504
X-HE-Meta: U2FsdGVkX19TpH15qSh3kSeg3crFSFOkPLQfkXqa0VYKJ+G4OUaiAt5f0OodIghc1OwvZG6i453MepYCbdOb0MS7L/EuFmZj4UlOy19N2qav9hPATPgxdjd5n1BcBYoDLNHJLv1lGkx/CjfXCqTGbGnKBEjgjE4BoON+t71LAeP0LMI3tIj8oykGHyXWMafCICmGwe6Urvxz931i+5in6Fn71xodcqvD3+h6ZSsB9DR6xoRA+trLmyfPyb4CYzcE1g+m7X8hhaBAVcBhtj1uL9StZFYYRhXeQuJ9rydQaRnIzP+PHso4FPJHrz9Pn5FGckD9hPNRfwsPTimv2ORvn7wr5liBqjOYtxdZxghWZmomgomVC6YyyV5PnfmgmujyIy0PcxXD8d2GwbgLpOFt7pMuovxvIfxga37ama6oPwXu6C3hn/ZyjP+CWlGxFQizwZ9NH5jO8/+6f5dt0axfpcO5Fx+qDwduBpjn3eSE5krnapRDVbibyBXeZZLVJStfTvnjectAyWeCwvV/zjoJzGQJiHbDA8l6Ww8TpjHyOnoAQiPGYw+9fmwVKyH6OFr+c2ItakT4DcJVaKvFXFOIElL3QaE9cuiyf2wXPN8yXQ49aSMbMaTh/RQ69AKL5RJEeLt9zdq4HEcp/CXXDhOQdrNdGZ0/t6e2L0wSewkqsh4xS0lOHNpxw3zH3EDeAvzv5jjOaRzwRQH5ZvaUwvxiZWw2LG8Eghs8LdDAJw7y+oZiHpvIISDvDBN0UacHs6E7AmHrP6LPPqAVfnorTb9fYT70ok2eA0+3Spt860M4sPmIX0MtSOf4ZehB3RHS6WXxTHowTykBey9IO8vq73ZcDsjg4bnyTVrQGaD97VA2WbLzvmaIiIC2s4/PG9dxiTeXUGgVU/QmGQl7AgiEz2lCxSGqAq7+oXtvW49OHDBLzPapXTQ41qChc+8Eh5Jdj2Y4CTUINV/M3DXhgF5d9kf
 mtE7rGTr
 CVUOBJ0dsgUIvv9hl8RiNY+z2GsNNxfiPkzN5V99ja0l6GpHdi9ew6gemazGQZOHggcqilc+ekZgBPmo7H28hTDpkNIgubBEolGZpmhu2j+lDZg2mu8BWMZRyBP+O/irwJDNmV9twj+Xvesb+DhTs6tB6nvNaqWWNWbPvnUSk+fYLTI3cbg5fx2J4MS38U+/fYASO6hqd31htvinDC4hTF7qg4tIKH6gN+h85Vy0o4sA0/D5MIwTzdAM71+R8uSrHy5kw4JZham5LV0geqmrztGhPo6+jzRYYD0DMDdMgeu19iFmR6sUhxEde81I863CvyuTWOeHArMeOz/Ijtk80HBCDmkUA/rEZ9Rl+E6u8C3tppZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, task_mm_cid_work() is called from resume_user_mode_work().
This can delay the execution of the corresponding thread for the entire
duration of the function, negatively affecting the response in case of
real time tasks.
In practice, we observe task_mm_cid_work increasing the latency of
30-35us on a 128 cores system, this order of magnitude is meaningful
under PREEMPT_RT.

Run the task_mm_cid_work in batches of up to CONFIG_RSEQ_CID_SCAN_BATCH
CPUs, this reduces the duration of the delay for each scan.

The task_mm_cid_work contains a mechanism to avoid running more
frequently than every 100ms. Keep this pseudo-periodicity only on
complete scans.
This means each call to task_mm_cid_work returns prematurely if the
period did not elapse and a scan is not ongoing (i.e. the next batch to
scan is not the first).
This way full scans are not excessively delayed while still keeping each
run, and introduced latency, short.

Fixes: 223baf9d17f2 ("sched: Fix performance regression introduced by mm_cid")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
---
 include/linux/mm_types.h | 15 +++++++++++++++
 init/Kconfig             | 12 ++++++++++++
 kernel/sched/core.c      | 31 ++++++++++++++++++++++++++++---
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5dab88707014..83f6dc06b15f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -994,6 +994,13 @@ struct mm_struct {
 		 * When the next mm_cid scan is due (in jiffies).
 		 */
 		unsigned long mm_cid_next_scan;
+		/*
+		 * @mm_cid_scan_batch: Counter for batch used in the next scan.
+		 *
+		 * Scan in batches of CONFIG_RSEQ_CID_SCAN_BATCH. This field
+		 * increments at each scan and reset when all batches are done.
+		 */
+		unsigned int mm_cid_scan_batch;
 		/**
 		 * @nr_cpus_allowed: Number of CPUs allowed for mm.
 		 *
@@ -1389,6 +1396,7 @@ static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
 	raw_spin_lock_init(&mm->cpus_allowed_lock);
 	cpumask_copy(mm_cpus_allowed(mm), &p->cpus_mask);
 	cpumask_clear(mm_cidmask(mm));
+	mm->mm_cid_scan_batch = 0;
 }
 
 static inline int mm_alloc_cid_noprof(struct mm_struct *mm, struct task_struct *p)
@@ -1427,8 +1435,15 @@ static inline void mm_set_cpus_allowed(struct mm_struct *mm, const struct cpumas
 
 static inline bool mm_cid_needs_scan(struct mm_struct *mm)
 {
+	unsigned int next_batch;
+
 	if (!mm)
 		return false;
+	next_batch = READ_ONCE(mm->mm_cid_scan_batch);
+	/* Always needs scan unless it's the first batch. */
+	if (CONFIG_RSEQ_CID_SCAN_BATCH * next_batch < num_possible_cpus() &&
+	    next_batch)
+		return true;
 	return time_after(jiffies, READ_ONCE(mm->mm_cid_next_scan));
 }
 #else /* CONFIG_SCHED_MM_CID */
diff --git a/init/Kconfig b/init/Kconfig
index 854b35e33318..8905d64c2598 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1918,6 +1918,18 @@ config DEBUG_RSEQ
 
 	  If unsure, say N.
 
+config RSEQ_CID_SCAN_BATCH
+	int "Number of CPUs to scan at every mm_cid compaction attempt"
+	range 1 NR_CPUS
+	default 16
+	depends on SCHED_MM_CID
+	help
+	  CPUs are scanned pseudo-periodically to compact the CID of each task,
+	  this operation can take a longer amount of time on systems with many
+	  CPUs, resulting in higher scheduling latency for the current task.
+	  A higher value means the CID is compacted faster, but results in
+	  higher scheduling latency.
+
 config CACHESTAT_SYSCALL
 	bool "Enable cachestat() system call" if EXPERT
 	default y
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 30652bb4a223..14b79c143d26 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10784,11 +10784,11 @@ static void sched_mm_cid_remote_clear_weight(struct mm_struct *mm, int cpu,
 
 static void task_mm_cid_work(struct callback_head *work)
 {
+	int weight, cpu, from_cpu, this_batch, next_batch, idx;
 	unsigned long now = jiffies, old_scan, next_scan;
 	struct task_struct *t = current;
 	struct cpumask *cidmask;
 	struct mm_struct *mm;
-	int weight, cpu;
 
 	WARN_ON_ONCE(t != container_of(work, struct task_struct, cid_work));
 
@@ -10798,6 +10798,17 @@ static void task_mm_cid_work(struct callback_head *work)
 	mm = t->mm;
 	if (!mm)
 		return;
+	this_batch = READ_ONCE(mm->mm_cid_scan_batch);
+	next_batch = this_batch + 1;
+	from_cpu = cpumask_nth(this_batch * CONFIG_RSEQ_CID_SCAN_BATCH,
+			       cpu_possible_mask);
+	if (from_cpu >= nr_cpu_ids) {
+		from_cpu = 0;
+		next_batch = 1;
+	}
+	/* Delay scan only if we are done with all cpus. */
+	if (from_cpu != 0)
+		goto cid_compact;
 	old_scan = READ_ONCE(mm->mm_cid_next_scan);
 	next_scan = now + msecs_to_jiffies(MM_CID_SCAN_DELAY);
 	if (!old_scan) {
@@ -10813,17 +10824,31 @@ static void task_mm_cid_work(struct callback_head *work)
 		return;
 	if (!try_cmpxchg(&mm->mm_cid_next_scan, &old_scan, next_scan))
 		return;
+
+cid_compact:
+	if (!try_cmpxchg(&mm->mm_cid_scan_batch, &this_batch, next_batch))
+		return;
 	cidmask = mm_cidmask(mm);
 	/* Clear cids that were not recently used. */
-	for_each_possible_cpu(cpu)
+	idx = 0;
+	cpu = from_cpu;
+	for_each_cpu_from(cpu, cpu_possible_mask) {
+		if (idx++ == CONFIG_RSEQ_CID_SCAN_BATCH)
+			break;
 		sched_mm_cid_remote_clear_old(mm, cpu);
+	}
 	weight = cpumask_weight(cidmask);
 	/*
 	 * Clear cids that are greater or equal to the cidmask weight to
 	 * recompact it.
 	 */
-	for_each_possible_cpu(cpu)
+	idx = 0;
+	cpu = from_cpu;
+	for_each_cpu_from(cpu, cpu_possible_mask) {
+		if (idx++ == CONFIG_RSEQ_CID_SCAN_BATCH)
+			break;
 		sched_mm_cid_remote_clear_weight(mm, cpu, weight);
+	}
 }
 
 void init_sched_mm_cid(struct task_struct *t)
-- 
2.51.0


