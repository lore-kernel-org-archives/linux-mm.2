Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9435CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40F16B00A1; Wed, 14 Oct 2026 05:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19676B00C5; Wed, 14 Oct 2026 05:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EF96B00C6; Wed, 14 Oct 2026 05:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF3C6B00A1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:45:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27EB716044A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:45:55 +0000 (UTC)
X-FDA: 85320750270.14.CA529E0
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2075C1A0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:45:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HIkL+ZdS;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cjoSrIIljOIInwRxHyN89H7Srl+gGPS+IjzpyYAnwk=;
	b=YdMI+BM5l2jNEiJA0ms/ge7SGcO4v2UsAD2UGKiZ8DzXf1rs88MA/bw7iBotb/j16Rpj9Y
	54g2AEWcc1S2rRMez30yqglkVjL/kOOIwWkRnqlwAmk/G37fMFsWOi641KfIyMQswD1rid
	a14tVKhF9Dp7OUu30u+jezBAxLTIMuU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971153;
	b=cmZwWE8UDcfdNBbrBWMPwS8FiKlUu6ju/pMVQZiPhrIiiypeqH4+pnErn6wZTX3BleZ8/s
	OWY7F2O8xd5aktCvTJ2cXNJ6bcMidA2fecOblIU58XtlYm/hHvBq/55mbwaakpzGTP/aK6
	seWKa+op+2guMCBtNEvDwnEWDPuZe4w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HIkL+ZdS;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971147; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=5cjoSrIIljOIInwRxHyN89H7Srl+gGPS+IjzpyYAnwk=;
 b=HIkL+ZdSxmwBtu7okcdRns5fwXsFRyI+u8xX0JAaGFTq9O7JN8E92ha3/Z48Swyudxva+Y
 YL2UuFN/33wkUZeD7ofjMGSjV324sDnY9oqkCEb8WMLoKjye3EhkHQyVPLaSI2Mwvi6XQi
 4WdpRkh6l1/NERnHnXBz8kTl5bRsjDgcFKTSzMg3oPPn9WIvO0QvzHp5W/nPUNu2xWudh9
 hKh5falYiUYuv1tjm9wKMzL/HwNdLfikpvlANBrb1ToP1E8HFeJ5vFStuOD40NarU1tnNJ
 U2Jr+7rWSnl+dojThkCCfHJkmBr1QKEZTEtyu5FyaxqG10+fZbviMYN0nofEyw==
Content-Transfer-Encoding: 7bit
In-Reply-To: <20261014094347.99157-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Message-Id: <20261014094347.99157-4-lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 14 Oct 2026 17:43:44 +0800
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
Subject: [PATCH 3/6] sched/numa: fix scan-period adjustment for shared faults
X-Lms-Return-Path: <lba+26acf4f49+844a7b+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2075C1A0004
X-Rspam-User: 
X-Stat-Signature: t8hthoe4oaktuyqshuixhzh8kmoxjzz1
X-HE-Tag: 1791971152-605264
X-HE-Meta: U2FsdGVkX18Ti9najykvTjSaPMJcaX+/vcprmz5vP2HSUmqEYwHKq2fKA0XHCBdFxnfD/IzFdNVlkiQeNxJVAL6rvlx1wfjmZ1aw5yhG8UMfg4PqoSBvOuA7RkgKjgkm6LXWOdOOJgLgrTVuMThFMcQdVAWPFKVm1lvGWqa3xvG+AMeMhaPWQ/YMUrZmSQY+OvWSMBhGOw0a6CepTdcrZCEIvtjgcATXPNnrUWD9fU4c3GcvBz9wnHKW7GvKkl0ILyAVRhX49/xTxgxgYDZrWsIwI0lXwJnVE5+GMoZbL12JpxDESRm/PfPKPFGBNvzsNlpQMHphopUlRK+JmQ9yJlJT8Bw/ay6UaWKOBMymY530qUScup5C3s15mpUtN7E+5kVJqubJLh++BrpxcsnmkByPhHEHZTu2VzBnLcglfB9JK8EzQLK5HcUMati94Edt3kxGlaFosvO6syEcnIL10tdzIdu+QfzR/4V9ccQmXoNOaQDkROlqQf32lRKkdx4IFZqu2aTu3LfjdfLxX+zx1FGmo1bVHAuaIc2N5prEg5ZE3VsWpwkB1D97a5wkCNwwBHCxW1hI9TRvgHCIX7HA6/xq3zFd3LI44Cw533dTuR2eMykikmZN8w7Ro6N4zAimphi1WdJY111pusaBibjQ9Lbs/b4W7cJeND5653BVK7q8nShVrz4665Bqy0fVpMtz/IRxbTjZpS4tMoSdXvPlI8wgn4AdwBdNmRTF1p8odJXbHjvsnPJ2C5tnQecSifW7Fl4t2PfaHOg7+OkFQQbjfADV+zHoMCfpmaYS1dSlPQFDyDJMe0eIRqKe0/gtlaHHYOSUvjTADk4nH0Spf3z2G9u+odOVqDJm+qupKG72/C6JcuW4NVmywaPrfL2zACcP0pXg0S9VL2m1ZKyPxjVWKPGQcJYFGuoCzSjfK/7KNNIWHKwb3lDzsUr8zL8f3GPnYR61tUQ5upiO5FFwwYW
 mj5kG2aE
 leZfJLPYhnabC1KokaC8JIV98OAgEqeEpODn0ITC3RdA2CUGXOOTg0PZUn8dMjZL3ArToHB7FoU8mtVUi76LH0kw6pU+29jj9LPMU0i/lRD3EwrQf5qf/0M+6rdIzdD0od2U0C9jKC8lwzk754zlpvY3fd7M26kSv+aZTLfNC/dOsM5clVRBdAqW7SoAc57xBhMmrg770pX/faPe5dZTj83PC2yBpbHvPM43kKMBlXtorvz9HjUr/itUlDWaQEniE3MyJP8AEpRwaTQ0tXtYPG36cDAise+hF/Jl5iXpl14+oHflpwEEo0HqoL54/MfiiBjsS1cEtcQOZMsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 37ec97deb3a8 ("sched/numa: Slow down scan rate if shared faults
dominate") intended to slow scanning when either shared or local faults
dominate, and to speed scanning up only when many private faults are on
remote memory pages.

The implementation uses the private-fault ratio as the slow-scan signal.
That makes private-dominated samples slow scanning, while
shared-dominated samples can still fall through to the speed-up path.
That does not match the stated intent.

Replacing the private ratio with a shared ratio fixes the
shared-dominated case, but the scan-period code still only has separate
locality and sharing ratios. Those ratios cannot distinguish a window
with many remote shared faults and only a few remote private faults from
one with substantial remote private faults.

Track faults that are both remote and private, and only speed up scanning
when that signal is large enough. This keeps local or shared samples
slowing scanning and avoids extra hinting overhead when the remote
activity is mostly shared.

Fixes: 37ec97deb3a8 ("sched/numa: Slow down scan rate if shared faults dominate")
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/sched.h | 17 ++++++++---
 kernel/sched/fair.c   | 68 ++++++++++++++++++++++---------------------
 2 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35ae49a991f..1be7a9ba7553 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -832,6 +832,16 @@ struct task_ipi_mask {
 struct task_ipi_mask { };
 #endif
 
+#ifdef CONFIG_NUMA_BALANCING
+enum numa_faults_locality {
+	NUMA_FAULT_REMOTE,
+	NUMA_FAULT_LOCAL,
+	NUMA_FAULT_MIGRATE_FAIL,
+	NUMA_FAULT_REMOTE_PRIVATE,
+	NR_NUMA_FAULT_LOCALITY,
+};
+#endif
+
 struct task_struct {
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	/*
@@ -1422,11 +1432,10 @@ struct task_struct {
 
 	/*
 	 * numa_faults_locality tracks if faults recorded during the last
-	 * scan window were remote/local or failed to migrate. The task scan
-	 * period is adapted based on the locality of the faults with different
-	 * weights depending on whether they were shared or private faults
+	 * scan window were remote/local, remote private, or failed to migrate.
+	 * The task scan period is adapted based on those fault patterns.
 	 */
-	unsigned long			numa_faults_locality[3];
+	unsigned long			numa_faults_locality[NR_NUMA_FAULT_LOCALITY];
 
 	unsigned long			numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 76532b8202dc..ec8a6bfeb2c7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3675,10 +3675,10 @@ static void numa_group_count_active_nodes(struct numa_group *numa_group)
 
 /*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
- * increments. The more local the fault statistics are, the higher the scan
- * period will be for the next scan window. If local/(local+remote) ratio is
- * below NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS)
- * the scan period will decrease. Aim for 70% local accesses.
+ * increments. The more local or shared the fault statistics are, the higher
+ * the scan period will be for the next scan window. If the private remote
+ * ratio reaches NUMA_PERIOD_SLOTS - NUMA_PERIOD_THRESHOLD, the scan period
+ * will decrease. Aim for 70% local or shared accesses.
  */
 #define NUMA_PERIOD_SLOTS 10
 #define NUMA_PERIOD_THRESHOLD 7
@@ -3693,11 +3693,13 @@ static void update_task_scan_period(struct task_struct *p,
 			unsigned long shared, unsigned long private)
 {
 	unsigned int period_slot;
-	int lr_ratio, ps_ratio;
+	int lr_ratio, sr_ratio, rp_ratio, ratio;
 	int diff;
 
-	unsigned long remote = p->numa_faults_locality[0];
-	unsigned long local = p->numa_faults_locality[1];
+	unsigned long remote = p->numa_faults_locality[NUMA_FAULT_REMOTE];
+	unsigned long local = p->numa_faults_locality[NUMA_FAULT_LOCAL];
+	unsigned long remote_private =
+		p->numa_faults_locality[NUMA_FAULT_REMOTE_PRIVATE];
 	unsigned long locality_faults = local + remote;
 	unsigned long type_faults = private + shared;
 
@@ -3708,7 +3710,8 @@ static void update_task_scan_period(struct task_struct *p,
 	 * migration then it implies we are migrating too quickly or the local
 	 * node is overloaded. In either case, scan slower
 	 */
-	if (!locality_faults || !type_faults || p->numa_faults_locality[2]) {
+	if (!locality_faults || !type_faults ||
+	    p->numa_faults_locality[NUMA_FAULT_MIGRATE_FAIL]) {
 		p->numa_scan_period = min(p->numa_scan_period_max,
 			p->numa_scan_period << 1);
 
@@ -3721,40 +3724,36 @@ static void update_task_scan_period(struct task_struct *p,
 	/*
 	 * Prepare to scale scan period relative to the current period.
 	 *	 == NUMA_PERIOD_THRESHOLD scan period stays the same
-	 *       <  NUMA_PERIOD_THRESHOLD scan period decreases (scan faster)
+	 *       <  NUMA_PERIOD_THRESHOLD scan period may decrease if the
+	 *                            remote-private signal is strong enough
 	 *	 >= NUMA_PERIOD_THRESHOLD scan period increases (scan slower)
 	 */
 	period_slot = DIV_ROUND_UP(p->numa_scan_period, NUMA_PERIOD_SLOTS);
 	lr_ratio = (local * NUMA_PERIOD_SLOTS) / locality_faults;
-	ps_ratio = (private * NUMA_PERIOD_SLOTS) / type_faults;
+	sr_ratio = (shared * NUMA_PERIOD_SLOTS) / type_faults;
+	rp_ratio = (remote_private * NUMA_PERIOD_SLOTS) / locality_faults;
+	ratio = max(lr_ratio, sr_ratio);
 
-	if (ps_ratio >= NUMA_PERIOD_THRESHOLD) {
+	if (ratio >= NUMA_PERIOD_THRESHOLD) {
 		/*
-		 * Most memory accesses are local. There is no need to
-		 * do fast NUMA scanning, since memory is already local.
+		 * Most memory accesses are local or shared. Local faults do not
+		 * need fast scanning; shared faults may just be moved elsewhere by
+		 * other tasks.
 		 */
-		int slot = ps_ratio - NUMA_PERIOD_THRESHOLD;
-		if (!slot)
-			slot = 1;
-		diff = slot * period_slot;
-	} else if (lr_ratio >= NUMA_PERIOD_THRESHOLD) {
-		/*
-		 * Most memory accesses are shared with other tasks.
-		 * There is no point in continuing fast NUMA scanning,
-		 * since other tasks may just move the memory elsewhere.
-		 */
-		int slot = lr_ratio - NUMA_PERIOD_THRESHOLD;
+		int slot = ratio - NUMA_PERIOD_THRESHOLD;
 		if (!slot)
 			slot = 1;
 		diff = slot * period_slot;
 	} else {
 		/*
-		 * Private memory faults exceed (SLOTS-THRESHOLD)/SLOTS,
-		 * yet they are not on the local NUMA node. Speed up
-		 * NUMA scanning to get the memory moved over.
+		 * Only speed up scanning when enough faults are both private
+		 * and remote. Mixed windows dominated by shared remote faults
+		 * should not create extra hinting overhead.
 		 */
-		int ratio = max(lr_ratio, ps_ratio);
-		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
+		if (rp_ratio >= NUMA_PERIOD_SLOTS - NUMA_PERIOD_THRESHOLD)
+			diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
+		else
+			diff = 0;
 	}
 
 	p->numa_scan_period = clamp(p->numa_scan_period + diff,
@@ -3906,8 +3905,8 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_scan_seq = seq;
 	p->numa_scan_period_max = task_scan_max(p);
 
-	total_faults = p->numa_faults_locality[0] +
-		       p->numa_faults_locality[1];
+	total_faults = p->numa_faults_locality[NUMA_FAULT_REMOTE] +
+		       p->numa_faults_locality[NUMA_FAULT_LOCAL];
 	runtime = numa_get_avg_runtime(p, &period);
 
 	/* If the task is part of a group prevent parallel updates to group stats */
@@ -4262,11 +4261,14 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (migrated)
 		p->numa_pages_migrated += pages;
 	if (flags & TNF_MIGRATE_FAIL)
-		p->numa_faults_locality[2] += pages;
+		p->numa_faults_locality[NUMA_FAULT_MIGRATE_FAIL] += pages;
 
 	p->numa_faults[task_faults_idx(NUMA_MEMBUF, mem_node, priv)] += pages;
 	p->numa_faults[task_faults_idx(NUMA_CPUBUF, cpu_node, priv)] += pages;
-	p->numa_faults_locality[local] += pages;
+	if (!local && priv)
+		p->numa_faults_locality[NUMA_FAULT_REMOTE_PRIVATE] += pages;
+	p->numa_faults_locality[local ? NUMA_FAULT_LOCAL :
+				 NUMA_FAULT_REMOTE] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
-- 
2.20.1

