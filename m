Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2185FEA8542
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C646B0089; Sun,  8 Mar 2026 22:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735D86B008A; Sun,  8 Mar 2026 22:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6455A6B008C; Sun,  8 Mar 2026 22:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 571F96B0089
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:08:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 185941606A5
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:08:00 +0000 (UTC)
X-FDA: 84524889120.21.340B35E
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D956160002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:07:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jxjPjnqU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773022078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn2CrPvigyubKEvhLFY6y0EU5doWg0tOHWyGKpSN0ek=;
	b=KxXKLWfrFgAfJ/8Iiwjro47KEmP8DPF8snJ47eyFZfTPKUpTnURrdKfOOziHLKZicI71fI
	5BihQ2cRuDrbcjCJ/tVynN+xsawtQHJIlhnSUytoj2Zdf3SzrsLB95lH71ifDWjpLRJUZe
	ZL6J9GdIagt0bvYuEMDOCFq9TCwM4Nk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jxjPjnqU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773022078; a=rsa-sha256;
	cv=none;
	b=jBbE2m12gLajXcUm3JcBAUHeynBiWIdgDJrjXDznsUiMBrAVhivqWEaLl7vqNTTCz3JQes
	hRyx9q88hwkwEOJXs1GlscmN5yI5lywYDMUhMP/IsECgoC8vVwCtooLDm2Q/DSvpN6Ngec
	yZLkllN2/oqomRObbWQPjATXbEIibRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773022075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vn2CrPvigyubKEvhLFY6y0EU5doWg0tOHWyGKpSN0ek=;
	b=jxjPjnqULvEez8p4Oy7hdYwOkQGz1hX7HYANCPl+tjIG6YKtj9++2Nk+cax/xIfyCAhUOu
	OtIoU4B1eIms7cVGebpndOgcNcMyprydgi85x7kPzVtGmtYmNOwvZMpJjgba4KSyFjOEo9
	YJ4LyL5QnlzE/o8LYlWZDRxnNlki4vk=
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
Subject: [PATCH v7 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Mon,  9 Mar 2026 10:07:10 +0800
Message-ID: <20260309020711.20831-2-lance.yang@linux.dev>
In-Reply-To: <20260309020711.20831-1-lance.yang@linux.dev>
References: <20260309020711.20831-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D956160002
X-Stat-Signature: 5c7gf1kd7krtq3xiwthf4aao1yjq7qs3
X-Rspam-User: 
X-HE-Tag: 1773022078-707004
X-HE-Meta: U2FsdGVkX18/jTy6hPgewIJKv1cQE+y3mudNbg8YN0wk1ms+Pw3XcF8KF2YuUIGT18eXRuhjsr0OD7oWy11/P07biJ3Cz2AnXqRqxqosuBbEhmSY4v9McSzrn9TNASh1f3aubrMSh5O9nW9onM5E94RgWGnLgXCSVa6ns+LEn0wOJ8VT4kJhmTDg7riGhe2MUINM1nOdQPnzY7dNb1i3up72aXqO8wROpD6gKN8JaTYhKDkL2iLRXhNkWg65RPt32++dS/Kvh6xgKSqDdjUHPue7RxiTw6ORUcLLquGwa1AXNKxXpmxou1MC+qo/58HfkDPe0ZMoh6q+Qh8yEGA0zZPvOiSJZS7DxPnn9bEzRkC8OB5T9JmL5+GriFlah9mst7aCRBlBBQoz2vbXiOsyUe2NRta2bO5wExqRWBNDdUDkSAxbkFmFi4vWRbPAHKzMMe7qZfkShgLAdAPuUpunAguhKupbmifV4WmrTRx8o25kez95ODx6hhom/y2oLhksA2YQFiYN8QVln1DELye8uYAdvWj7wuTaCrEAWflZWP1LCB22ePwvpHfxcevDIPtJNSAlVqTMnpstVAv347dNz0lBe0yBBZnepzLsCfiuWiLWakYQ3w3+eh1tWQI08b6SLbiCqa0I5ixL2dR+HZaFCbAR+ChyIwWRHUt1KTFQ4QHziBktJ5QBtKBJ/qUiwf8Jy2d1up5+jjoV9IbAq76HfsakxS600kJWXU0GPQn/1f49cWsRjMNPGdrUpBr/cRv+D+vsXuuxORbuY7k7Is1UvhYUbn5n/0fUZj477SeHdH6qPmy8vhplv7SbbOt+69sIcKMD7bID+0MbBV/00s9XByEoCHY14Ultwsc9Afv+lwopqnQt69YDfJcH1B/2DdRWjSAHVzpVsAzL0Bk3B648PHt1pEQywWjZ7KZ7vq9fgLqRkAOJc3hpS0n7dMxx4W65ml3IYS2qw/dCn08KEMW
 rBb3TtAy
 iiyQ57+ka1HPG9jBS+8bAWQR+g2EIn1LzhFHgrZVZ9n8WV3JJkLbKIlQ11g+ALaAYJNNr8Dd3vHEZ//afExVbjCUiJ4ZzRmM9ir5LhYMjuF7trPS8HR9K3ozHgNfB0OCIxfJ5loRIlgn6KfiCYLhaLF2edsRlhk0xY2ts71zaS7XfAx3oNAKIAZ7ytqfDUArd7sCQizD/EFaWm4KaiZR4quNkfTe949zmU+e7XmJ/xcWKaiGd3+DXWIIhoFGEkrX7Vf2iePBU+7Dij/K+vx+0jZ62BcyNlLE/TeW04EjzDD8thxA=
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


