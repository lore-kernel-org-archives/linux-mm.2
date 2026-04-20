Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A01EEA71B7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 03:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCDB6B035C; Sun, 19 Apr 2026 23:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66A56B035E; Sun, 19 Apr 2026 23:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D545F6B035F; Sun, 19 Apr 2026 23:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C343E6B035C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 23:09:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8885213BB7F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:09:33 +0000 (UTC)
X-FDA: 84677453826.15.931D238
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id D40BE80004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:09:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXtcEMIM;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776654572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4i42uUk09a42HzxE9DZCh9MNHfSJlOmtFh/Ez0FeKo=;
	b=2ltFM97xJ3uyA9JX+Ln8k2Cr4Hzv4JN2/ftrGnB5BjTV2xlI1m2E8j+Q6ftmrBVvqI7wnR
	bGkLHg4gN42y37fpjPp0c5dqtuAHIJX5+96x5oafNZsXZmcxO1V6ng8k2fkqDU5S3UVQvp
	lsvDoj/y06DXLV5YOy4FLUf5ZbqAvUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776654572; a=rsa-sha256;
	cv=none;
	b=Zjd8W95ewoDKuBii5nsXJQWMGZxQ1Cyub2dMO4ZqbRWDzKUi2hkS4iqiQNXhfYd7tUYLd0
	3rPmAReoju4UXayaVjlOyArI1s3lSMU6Maf0RnbojbN8McpborIze7yVFKPAIXth1TO6QA
	Go9zq4ihjfCJGDd87FDHxrvdAkcYb7w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXtcEMIM;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776654569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4i42uUk09a42HzxE9DZCh9MNHfSJlOmtFh/Ez0FeKo=;
	b=vXtcEMIM7Fzk0OEIjJMtHMzuQXOAwdxaEqcpZhL45zPhsnBWphbNumB+4WuJAcakH5/OU/
	gWzElvIWgUg3nAFVv6M5DqTEJik79BxCrehKu4MoKfRRJZCxfel340GfTt10lJXjqSQjQZ
	KA7SJAiDcsK8wEWC0AIEVtX04pQwOGs=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org,
	david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 7.2 v9 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Mon, 20 Apr 2026 11:08:50 +0800
Message-ID: <20260420030851.6735-2-lance.yang@linux.dev>
In-Reply-To: <20260420030851.6735-1-lance.yang@linux.dev>
References: <20260420030851.6735-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m58snk5carxhfzpmakx7xezqxenwfwff
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D40BE80004
X-Rspam-User: 
X-HE-Tag: 1776654571-185783
X-HE-Meta: U2FsdGVkX18jM1GCx9ixJ/YGGZ70V/glgiY12XwYBmUQXjiWmkg6VVusEoQLT/FFCYvBWKdrpPkIhG7EQBOVkGXxzDNNGP4VWn73VBBiOfcy24oNd93gme1DXK5zZLkehBfDg+YENUsO6GTm6AmzBUlvKKHe/EX+I5Ta1O7QRWyPEtPAa+I03BBReyJMtPpx8leVZ50yCAZFGj3/r0VX8/tQjD1/Blbdry/SWwhv1gHLX07XUgo9WZJ352xcKIyxwkikpWu9yVxBL++4CivZsuEmWvANDfaODjq14as1Nq8Lc2wK9AS/B25TYK2ycdi6Tp/a74QX2T9Fe5kr5fm/7LdvWN4mTcxeW3nqfn+IGyk19+eDkl2QP9WbZdrJl2wLhD/18d7R0738CjPhFcPV7k6bl4ITJKdMNZJpJoqXn9J1xrMoel1MW0OY5V5lzdMTMZWXHRKYFyXOcptopTDEHmEPXWfMIzCrrQtcf84VV/nKVdlEU37X9gbyQYKxLWBSZD5C9Xbo/bVMV6s0nn5UMnbXp0CAZxXTm00sbyPP9d5fOyaTeu6Slclo1dVHF5A4gWhPw23X0nZHC6q5KfcVhRf1iWlIRRpthABktQp7V61odWcbyVLYhf7INo3yEbKKGoDjfuhgjAgmePuDa2GhnSSQBi9PpZ9McBpOp/K7loK1RCdr1HDVRkmcmigdLoFmJ++R5ytdjVfPc7jIlleFUQINlmnzq6Ec1dDN+QJ7rSEg6oFrjWuLBhB6yx7GVWmBitaN+d8UHJkiB8+/W7PU/zcQroiV/mmHuiClcIZBNJIWktWcNku8d6z8pg2kpuGkdcVhxMUTiygmjz8Ztf68+a3z2z6bNRjTVfi4+F6U4pChtWlzZGbQyUKIoqX4Segb2E/gP8imLB9kcJIpNyUfAqfmrzLfuCp3rBMUHzaBhst6KyVkwHmypNsLLE7X6wpTflX5lSVihAaNVUuq/W3
 4pVFfLaI
 lx7OHYzWABF3M5dQM3pNWQl2ayoxohkjbaNgc62PN0sgSMNvOlMm13t0AnEEpFwassZ7bhIXoO+1ZJ2lM58SpzIpPEB1whIynqBSsBSqwDvHo85whBr/2iGc13WrtH+//hQrxKuIqIkiyZqJXwrlV4ULwH8gaEKwyvh+92rXinzoZDlPOK4zNYsXSa0xQB8RrhmkYoItSehL0oMex+UG80kAWsOpSVIUJZUvWVB2K/S7QemrgXBSsnvpxyrs5ZIh/Nne+SfNEMzaxYQoURFLzRmyHK0AQl9xbjWHci6QNOmoFfaikbRFz+JFq4FnGbYbX0QB3RX8hmP/Mu+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When page table operations require synchronization with software/lockless
walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
TLB (tlb->freed_tables or tlb->unshared_tables).

On architectures where the TLB flush already sends IPIs to all target CPUs,
the subsequent sync IPI broadcast is redundant. This is not only costly on
large systems where it disrupts all CPUs even for single-process page table
operations, but has also been reported to hurt RT workloads[1].

Introduce tlb_table_flush_implies_ipi_broadcast() to check if the prior TLB
flush already provided the necessary synchronization. When true, the sync
calls can early-return.

A few cases rely on this synchronization:

1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
   of the PMD table for other purposes in the last remaining user after
   unsharing.

2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
   and (possibly) freeing the page table / re-depositing it.

Currently always returns false (no behavior change). The follow-up patch
will enable the optimization for x86.

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
[2] https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/
[3] https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h | 17 +++++++++++++++++
 mm/mmu_gather.c           | 15 +++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index bdcc2778ac64..cb41cc6a0024 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -240,6 +240,23 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 }
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
+/**
+ * tlb_table_flush_implies_ipi_broadcast - does TLB flush imply IPI sync
+ *
+ * When page table operations require synchronization with software/lockless
+ * walkers, they flush the TLB (tlb->freed_tables or tlb->unshared_tables)
+ * then call tlb_remove_table_sync_{one,rcu}(). If the flush already sent
+ * IPIs to all CPUs, the sync call is redundant.
+ *
+ * Returns false by default. Architectures can override by defining this.
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 /*
  * This allows an architecture that does not use the linux page-tables for
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 3985d856de7f..37a6a711c37e 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -283,6 +283,14 @@ void tlb_remove_table_sync_one(void)
 	 * It is however sufficient for software page-table walkers that rely on
 	 * IRQ disabling.
 	 */
+
+	/*
+	 * Skip IPI if the preceding TLB flush already synchronized with
+	 * all CPUs that could be doing software/lockless page table walks.
+	 */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
 }
 
@@ -312,6 +320,13 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
  */
 void tlb_remove_table_sync_rcu(void)
 {
+	/*
+	 * Skip RCU wait if the preceding TLB flush already synchronized
+	 * with all CPUs that could be doing software/lockless page table walks.
+	 */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	synchronize_rcu();
 }
 
-- 
2.49.0


