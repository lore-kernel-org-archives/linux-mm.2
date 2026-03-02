Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6632D58E5F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 06:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C1E6B00AC; Mon,  2 Mar 2026 01:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233D96B00AD; Mon,  2 Mar 2026 01:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1329B6B00AE; Mon,  2 Mar 2026 01:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 014546B00AC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 01:31:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FECF13BAC7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:31:25 +0000 (UTC)
X-FDA: 84500151330.12.E157E36
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id DF6FBC000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:31:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w2ziNo0s;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772433084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn2CrPvigyubKEvhLFY6y0EU5doWg0tOHWyGKpSN0ek=;
	b=JLEhfp3smk0UwI1W1cuAjAwyFRUh4eKFO2MGnJeuS2qeIF7oidhaRpDIlQs8pdANalIQ5L
	ojB1ahk1J1sE1jCNwnnpz3GVVixAAEJbzIjkesn0v+Fl5QIzgiZbl1TdQBodl1t97H59Jz
	RKuHzjt7Tf0uy/CTfOuHUVvIWSYhfdw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w2ziNo0s;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772433084; a=rsa-sha256;
	cv=none;
	b=w/8TGanKgseuroPyW2hgj48htSLJ6Bnk8DToCfdWgEZU+PgafBb+LCwqS6TMoBvpsP0aWX
	XuFqeSeIholppntSmP/o+83ePjag7pNjW46QIwrKZ3TBRtg9DlNkfUIgQ55t4PDqmUD0s+
	q12AOXwp0WNYp1Vjxlqw/VamV5zfauY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772433081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vn2CrPvigyubKEvhLFY6y0EU5doWg0tOHWyGKpSN0ek=;
	b=w2ziNo0sXrzyuhn/KC3kYe51xjY3KPxJPLwHLuxT0ynfPUoR1Ss7ef3E4M1kriQHPtPloj
	ilRKdwNBRHvRiYQgdoZrrJ6pPQBSWEfdPsGz4zugLBvmIxtuUanbJoW8bujq5OInsz7oCb
	a9Q5rC7oRmaUqOvBzGToB4SQ3y/c/SE=
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
	lorenzo.stoakes@oracle.com,
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
Subject: [PATCH v5 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Mon,  2 Mar 2026 14:30:35 +0800
Message-ID: <20260302063048.9479-2-lance.yang@linux.dev>
In-Reply-To: <20260302063048.9479-1-lance.yang@linux.dev>
References: <20260302063048.9479-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9ipp66r3u3j5og8wweh3mwoz7fprntr7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DF6FBC000A
X-HE-Tag: 1772433083-856890
X-HE-Meta: U2FsdGVkX19wqOZfe7fiOm5QJmxGLeroXMFli8jPHe7QHf1BUCewrmmwETlT6d8Pop1y7oLl10tFMsb9PHkeovDWzsStheM283m2cxfnCU2Xy6xl1+F9w2HRWe71MVN7a4m1AR1lwCJoPAPkk8gN1KoNa3wMoFUP71btkoE8+zB/aZfjTmszt+kxR6Z9P2KzqdmrPJpMDyBZCvTDbhPpOKU3D9SaJ5MiOckLUGqHbQpn9Bk3mD9Wd4WwIQZzySJPua8DZmSLwf0ul1oYrelGWyym0kmrxW/IiK2NLm+UYp7Y/5pTUlOFEogR7aXvR4frrBwLxiyznID8AJ90FLTRudGSyKuJ9S9RT2u6vL1KyYzgzFj2dGzwS8SKqiSHmDrXEhgUo86u3R79ALBJFGKcdNJbJjdAPIO9sdq691LEz42uNwIHUqy4OI70ZT8YjAitAg1pW9T8un29YnEAggGukI+4A6kfeQd0WwNt455f/etSMkcGLurNSf/RoD4SkPLSQuDfN9IAyJF/buwaLa+PyQhzRDcbhRw7xs84p838LG03YBvYOmykfAXvMcjDcU+Qzs2aFuMYcrvLs+a53IPkucyjdoEYSBrtxNkQIlzXaBWnPvLtndnO2hFqAZr2DyINhe0bg6rJRCVQSl9ned9BifLMtlTIqkUE6MaJLUVI3WIMUgAGfu9BdUemBBnJMeBFec7pUo3ASfshsGKUJehZ0HjATtmmcfot/eWQOUJrYjRaz7aCQ+ZJ5ardcQEBkhvnJuyDzL0MgCfHM4A9ZxbCFl9p68N9rtorbamtcyUwpE5oZfmSi1rzhYDCBomzBYSk5ano7cIbXGX1lpMD1mvh16msBLSY+OK4uHiVaOZKuH8Qfp6DDzKWvxuuUqmpPR4F0wqO7ka0SfLI9hjRUu0Ytc+J4qhsj5Lbow8EGnToIZMWjQWiWjv0PRj4+zj4nud+zKxPrg3c/QU=
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


