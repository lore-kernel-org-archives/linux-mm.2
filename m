Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E6CE9B269
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D926B0089; Tue, 24 Feb 2026 09:21:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645BB6B008A; Tue, 24 Feb 2026 09:21:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572CD6B008C; Tue, 24 Feb 2026 09:21:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4106E6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:21:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06E395648B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:21:31 +0000 (UTC)
X-FDA: 84479563182.04.92CE974
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id D0C8620008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:21:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o9jlh0Mr;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771942889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ftf+6nHpcHnhVbfQle8ikpkQkfjTgGA5SgbWctBAI1k=;
	b=Z7MfEmTnOHpcB4rvi4AUlxS1+4wBGtJzOBjalhg1bxfps8XHQLdzXL4fFBuiIyQkjtLKdG
	NRvxncgChKYNwxBB55HZ9EQFs9cgDQmtl4mXWULfvBJdm15ghZ92FOKlweRQiTJbIXvPcK
	E4EarAibmfz2pwhKpkipk0O6SRTAIyQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o9jlh0Mr;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771942889; a=rsa-sha256;
	cv=none;
	b=y5fzj1MeBM68EV8t/R27AptrWHF3rcaZqZwUwDyXFy8mYo36ph7Bt8mia8oDW5/zn8J17l
	BWQXxktA5bs/NC8S+zOsVNWfI/zPsTuZiby7CnBTZd/Xe2csMLzgJXLI0YXs/nEFXfCFN+
	BTTQHQXTe5Cw1e0EIOOgaIcn6Di5X2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771942886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ftf+6nHpcHnhVbfQle8ikpkQkfjTgGA5SgbWctBAI1k=;
	b=o9jlh0MrC64et33agy4TtOcDGNAFpq2a66jieTkh92Zy8afHt05hHjGDJwNcJKNYR4e21O
	gNfaOQW8MhrWaXg36XkSLhomJaJAfDM5MPtM19OEdRVyidiwfQLb74cVCdhEPA3zyvoFfS
	GudLn86DitzE+qdGtFPZSPayaA2D0DE=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	peterz@infradead.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 1/1] mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocation fails
Date: Tue, 24 Feb 2026 22:21:01 +0800
Message-ID: <20260224142101.20500-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0C8620008
X-Stat-Signature: 87hiz5z863os4p345dgnexbbaejrq6g6
X-Rspam-User: 
X-HE-Tag: 1771942888-537429
X-HE-Meta: U2FsdGVkX1++JaF9hqA/gYfVtzsSpBm3IAYvRrU1R1el6YhT4CchRzFo59yIobcNc7KPwvwXRFi1gK4ya1MLmzmnvmrpWODnjLHknZuD7n6EUOo9Om+vrrc0IyHbaEvojUazZexG7c9Uj60Yu7xiDhJSZUqOtSUkTp/yEa/CdtX/J/OS1Kjxz6EHF7zUHl7e0nFMG8hBluBDuzD5mWJAKC6cYblP+eFgzLOikrTkGF6aZIIoi+RmHPJMl7xKn8zkWlCi0Z4UCKEqriBIs3GCvth43yZ00y7M82ER+D5JreHVnZ6rJYl/AUOU12p+VDGhq+vtjzjbEXwzNLngHw+wmD6n3vsc6Zz8xPzsLNSdlfpYa/XnceGwfmBFtiGmYIy42F5Id8/sNC8VtP0S9X+7QeySP+1Bfcjm1Xk6yHS3w/c90vIs0KZyraP3BwDHRDbuX22WmVovlubIXsW1ye1jx6ZBxTCcqnxA0rXh3QLOGANJpZBUQ1HeWOHWIyi+d6CedrP+mKOy0wPjkWGpXxOqAIexHxNnRIzRh9reFYyNXKjW6zDZxcUP9m6Hxy0s10scemLlU0JIRV7MwM99Y+3Te14I0O8VnWs8sewmEdNK1WrIz0T1GfilXmIeI5/T3IiQwCiqaZ0A2LsHFXSPkO8o+5nQ282llNx8NUcxoobCoGdymS4QSzY1y3SCQzC6G3svzx6VqkYoTqKR01/cRQ4bqDL03UY3tnDZnChgg0I79NfdcV6s3vmDvzQ8eoz91K0USYVsVVZMnU1xpMQjiD/wwIarcCDUjErtHkST12KQau4xwSaX1UYQbK+rGvNo9kqnaC6TQud77OI1BMSLtooQODznLqcrrf9NN5ZHp5gwz+kPgMW37uVh5x1XLAWRNab8NCBUqOUACfZJYjaIbpubO6kbgRehNni2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When freeing page tables, we try to batch them. If batch allocation fails
(GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
batching.

On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
process is unmapping memory. IPI broadcast was reported to hurt RT
workloads[1].

tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
(e.g. GUP-fast) that rely on IRQ disabling. These walkers use
local_irq_disable(), which is also an RCU read-side critical section.

This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
period (synchronize_rcu()) instead of IPI broadcast. This provides the
same guarantee as IPI but without disrupting all CPUs. Since batch
allocation already failed, we are in a slow path where sleeping is
acceptable - we are in process context (unmap_region, exit_mmap) with only
mmap_lock held.

tlb_remove_table_sync_one() is retained for other callers (e.g., khugepaged
after pmdp_collapse_flush(), tlb_finish_mmu() when
tlb->fully_unshared_tables) that are not slow paths. Converting those may
require different approaches such as targeted IPIs.

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/

Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v2 -> v3:
- Remove explicit might_sleep() as synchronize_rcu() already has it
  (per Peter)
- Add changelog explanation for why tlb_remove_table_sync_one() is retained
  (per Peter)
- Collect Acked-by from David and Peter, thanks!
- https://lore.kernel.org/linux-mm/20260224030700.35857-1-lance.yang@linux.dev/

v1 -> v2:
- Wrap synchronize_rcu() in tlb_remove_table_sync_rcu() with proper
  kerneldoc (per David)
- Add might_sleep() to make sleeping constraint explicit (per Dave)
- Clarify this is for synchronization, not memory freeing (per Dave)
- https://lore.kernel.org/linux-mm/20260223033604.10198-1-lance.yang@linux.dev/

 include/asm-generic/tlb.h |  4 ++++
 mm/mmu_gather.c           | 21 ++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4aeac0c3d3f0..bdcc2778ac64 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -251,6 +251,8 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 
 void tlb_remove_table_sync_one(void);
 
+void tlb_remove_table_sync_rcu(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
@@ -259,6 +261,8 @@ void tlb_remove_table_sync_one(void);
 
 static inline void tlb_remove_table_sync_one(void) { }
 
+static inline void tlb_remove_table_sync_rcu(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..3985d856de7f 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -296,6 +296,25 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 	call_rcu(&batch->rcu, tlb_remove_table_rcu);
 }
 
+/**
+ * tlb_remove_table_sync_rcu - synchronize with software page-table walkers
+ *
+ * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
+ * broadcast. Use in slow paths where sleeping is acceptable.
+ *
+ * Software/Lockless page-table walkers use local_irq_disable(), which is also
+ * an RCU read-side critical section. synchronize_rcu() waits for all such
+ * sections, providing the same guarantee as tlb_remove_table_sync_one() but
+ * without disrupting all CPUs with IPIs.
+ *
+ * Do not use for freeing memory. Use RCU callbacks instead to avoid latency
+ * spikes.
+ */
+void tlb_remove_table_sync_rcu(void)
+{
+	synchronize_rcu();
+}
+
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
@@ -339,7 +358,7 @@ static inline void __tlb_remove_table_one(void *table)
 #else
 static inline void __tlb_remove_table_one(void *table)
 {
-	tlb_remove_table_sync_one();
+	tlb_remove_table_sync_rcu();
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
-- 
2.49.0


