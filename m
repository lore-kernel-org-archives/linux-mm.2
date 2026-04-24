Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71017FB44B9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 06:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7406B008A; Fri, 24 Apr 2026 02:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67886B008C; Fri, 24 Apr 2026 02:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57996B0092; Fri, 24 Apr 2026 02:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0FF46B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:26:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F5E11C0AE2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:26:20 +0000 (UTC)
X-FDA: 84692464920.11.CD34FE9
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94B84140006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:26:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fB+5sM7g;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777011978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4i42uUk09a42HzxE9DZCh9MNHfSJlOmtFh/Ez0FeKo=;
	b=eQnA6EsHLuzOdvgSEH/WR5NcnDO4Ci0ZiEoaVSJOedemhQtjDGxDP/70ZmCqc8mG3n/Rd0
	fU7CZtjb7qvhklmUEZH3uZca8KH2I3bP7dxT2hLiIguc4fG7xR+CPR2VgjsIZVTm4cS3KR
	ouGDIuz5zIGfvDbBAafowQ3mv8i6udw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fB+5sM7g;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777011978; a=rsa-sha256;
	cv=none;
	b=qdAdSXu5nB8sgZOnNHntNriokVPUVhWa1PbSI0JtixVa865FAKeFtlt54rouUYMWyHYMOV
	ZYr0PjrS0sl5pfJlGuidJDeuQAImxAoew++0ajdj+KDoWQ6LbqA4Rcvu6RQoBjwSYrDkcu
	gxLBGbiHRLxPgKzs+Xx3fL94OlMOSwI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777011976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4i42uUk09a42HzxE9DZCh9MNHfSJlOmtFh/Ez0FeKo=;
	b=fB+5sM7gMx2on5aLQHGonIkRBU1HzC1Qr4OzNjxhHU77wNinnNBc9rippSgLMbbXX6/ENR
	YhqKF5dOnXSibRmTfsDJJHzi8TgFN+umza8gWguEhfnrZtGvFoHTJ/0qtb96e7al7099hI
	0uh8GEjClEWTmvJCfoi+JokTjJch4VE=
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
Subject: [PATCH 7.2 v10 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Fri, 24 Apr 2026 14:25:27 +0800
Message-ID: <20260424062528.71951-2-lance.yang@linux.dev>
In-Reply-To: <20260424062528.71951-1-lance.yang@linux.dev>
References: <20260424062528.71951-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tei4wic9myoaseowm54b3wetkks9joab
X-Rspamd-Queue-Id: 94B84140006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777011978-998500
X-HE-Meta: U2FsdGVkX1+ivKLbhApY7Lkwd0CdiPvDwaW0xdOsY6dF7tqWA+SG6vB7PkIzXY+u+UQlPfgWEFF+rjsV0mMDGUexv8BwbwZHwBrdWbr/cLqthITNFv2yPSSnAF10Rcj8kqv1u4DjfvlQ2jwLhHMBqVCYcyIjDAEsZIcDeLKIXruE4QKrxTLDcksriEttV+60RaX2EZ/UeQtMAt6wvaDzNzFr7A/Z7fMQlAwgzQqOa8jhXWX5QW+iM6rH19Ree60PlyFK0LEP4FYKbRk1kUakCRVOtQKOKXoh2uqxYL3X/ese4muXMsFSua2dpdJ+2Ai5kvEa2YlWKIpaz6cF5mP5T+mxYnT1VnvULzD0dxrOZ1sy2Nr+Z4pM3BQdZJ9ameCn74Szc+/DbNwdCxKha/9Of2ITK/0TDXkj81j7SP1haPiOcCruMxoVyCcqLsN68bSqY/LGIRidkeL9Zyx8Z0ErZP6Q5Ig81VInllif8rtkqJLA+4MstzisWp/iPzNHBi8qlDvzkTvA+JF+npJjPnvFFK5bujMj9Yi4EU/ODv4lA0ggZRsjGE8XdMpnQnF+NYI7TqQl/zzDnY1v8LjJXRenFuoZjYfHA/Ygcqdcu2guPH0CyKJf9nozA9Xzxu5Ek2VP2iP4WK9KUPY4HgTWfEutnwYqRgz09zsF/JgYWA5Nz5VGsh7NyNC4cHplSrZGEZSnloZCPrPkrVWqzCGVa8f4LMXVmkzVaAl6n0BMihZUdpS8XFcIFwf2thca3OSnJGGe53x1LNJjJ8tSKNGuTlomFVTzWRCOzYIFKahWBwJmLmJe2eM8LyiEdAPoNDO1Q4tTJzJKqMRflbUftNK1lv8WzRkF1vRNs7MztNHzLVqb7IbgCvIl70iIljYjrIdvqf6NayiqlT4wkPfwN0gMdVglw6fxM17Cosqs5jOczSqNvBlQYxE1AYGIhwTk7tPc27c4YiVDstKx+sT473MVXUv
 Z/FUp+uw
 pIGurSJEppH4wYwq45GwaKc7rE6UJL03++GMVzMz4suRzCrFJu8iLvEAALOQDftSFlwzG88bk6mtd2oUWx8RWEb6HDXqEul3z82FsqhJwUXgsLiqu/3+WD8JZcbCAIZAE6RSYt73QmVR+nUIVE8zTAihdhsTYwo5tS3pY6gXfkkd5G69dnizM/ARhE72s/9uJ5xqylpG6ZYWUCSViIFxL43XfUAKj1PNBaeMO3tHbPcSZYl1wtMIAZQRCk5JntTCY29RI9bGI/Icsig01HfTNC6ow4B2O2Xvb/fOaa9/V8Ya4WmB2cocjKABRzRR4MmPjrzqrgsjzlZh/XQA=
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


