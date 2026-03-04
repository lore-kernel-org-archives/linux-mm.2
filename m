Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24661EDEC01
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 02:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0A46B0088; Tue,  3 Mar 2026 21:11:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1316B008A; Tue,  3 Mar 2026 21:11:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6ED6B008C; Tue,  3 Mar 2026 21:11:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 721C46B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:11:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 088431C331
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:11:26 +0000 (UTC)
X-FDA: 84506753772.23.854E667
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D1AB14000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:11:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fgUYM/d0";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772590284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn2CrPvigyubKEvhLFY6y0EU5doWg0tOHWyGKpSN0ek=;
	b=6G5ImXaO/SNvC/l4UWVhTpJm/puWGER1NxiyplovW3bsPH4MGfVXchPLz3fhK3F0e6a8VL
	eB3xYdzaalkBJUq+dCpjJIMA3Z/+QGqUUqz7WyA1QSjCH/Pe7E72EOvPhwR+r3p+he2KTN
	H7GiW8p92wWySi2Z1K1V3hhesLnLiKI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fgUYM/d0";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772590284; a=rsa-sha256;
	cv=none;
	b=zLH3pPLxepOq8G4YFf/1FfazTlp3TCWN45emg9ZtNuOCBgXoYe9tTjQ17Y996aL8hDWi3d
	QVSNDQosMjNfZyCNyd/dTtsRQqE94qpYIaCX3F8do0HjstHu1ttQIuls/u/yYhO8m12gIA
	HAZ4op5zYFaQx+p4Fymy3d+W0k0LE8A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772590282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vn2CrPvigyubKEvhLFY6y0EU5doWg0tOHWyGKpSN0ek=;
	b=fgUYM/d0P37bsHPqPX4Z+o0dKS/1BrCWa8RGt/Nvn9MWX5D3ln9TuZSj+0EjJMPcTmH2z3
	8f8a6A1fjLymFVq3c9xMaOEMs86p40x2Nh0ih2lOE2Scf3uQ2nBKi5goxTitYTMxqeIKtO
	KtwSs9uUVV8FHNDg8aeOFN25eSCnKN8=
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
Subject: [PATCH v6 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Wed,  4 Mar 2026 10:10:43 +0800
Message-ID: <20260304021046.18550-2-lance.yang@linux.dev>
In-Reply-To: <20260304021046.18550-1-lance.yang@linux.dev>
References: <20260304021046.18550-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D1AB14000A
X-Stat-Signature: ryn4fdw35z6too4oxsjgiruoid85rfee
X-Rspam-User: 
X-HE-Tag: 1772590283-308177
X-HE-Meta: U2FsdGVkX1+/zlwnk4sMrtWeWmJKNPUK6my5Xdtfgp/jCFfxsotBY/+0ZAOKgD3SnDuAMgsTSYAF5BLnU5dokvQi58Gq4TZQWwsmj7pQkHbKkSLC4bzSG5PMk4qa7e886YPylNKi4XZwxPIjFhE4d8T0RYXJPGqXhHuq5K3SAAVwxP7R9NVKyRygu/PQLbB3Birr3ni5UaNGBNx+nGjs8pP6eeNAbHHmbnD/YJVpYmWIy++hoU9cidrjYtzo+1MpOJr3Ez9FEtIW6TMSeY/QUUbYgEj7Ps/kdBQA6gZXtpNmLjTd3cXsjbGw8qwfdaqHWXOK/1rkdBzd3Eutp6+gBnUbBE4a1/cNa3whW8l7FDyOUzoAnuly4MPq3zTTE4bJRBrkedcGSfAMNPnD+05EfkmAY/DT+2bO74EHR1GPNUKj9Po3EOQRPQYbM93ZiyP4JoctghOC03pbAwWWHGRw0Fpg8oQG+DupcYh+ygRg3Kqe619IrYshGdCbpHyboWSbCjhKYQ8uOyWq7VFxNvlfnEMSfrzW97iTFElNgNGagwZvRQHMIp2ooBtgLJVvGu2GrWcxR9Wk/scyMWF21IZET5ZF3zkGnQbNriw0C4pfj9hBu56eSLO+gvi9ixUuB41RAc0Ov8XXt8+OaHJ5WhiEcMnTns+H9mN+oKNu3hnUqv1AoFTO9sHtyK5mhv3b3Fv/uZ/57oWcFbrAMmV9PLEURpIRU9uAlqJRE7lAvhA1DfU4JKn2lRFS4dObdg4PWYEKZoJLyWphqgtHzr6CoxTbhKNCcebpXebQmXsDVg3Fo5N/DD4g9HkfG1gw783ra4yqqLRNAlpFJXqssjITzCpInbXi6Pxj6QDnRRn0bMo0KIoove7zGqHP8Wtzks0pMheVN2Nxgrk0/MGi93HpHnfuWAY8+zJKLFBa8266yMsuhd0nIvDnG3L+8fQWK7J+Ga/5cFLoH5JS0oD9Rv8D0Tt
 J3iSldzi
 MVXZ42rmmkGyVrSxW/SjNI3qLO4Nuns8014oEi/F3xURqdpwlySXibzCPkCTQeSGow2T5MDZ+YlJElKIrkcQJ9ndnpHU3cfCZ2m8jPG8EfKErqUqJ1rUQ5lgPy6iFJFuYPtHG81G9FCD48oeReZN7RbHh0UJGu022xuX3uTTcgPWCgsSL411Q1+zITtHjfYx3llhXZGq1+01Es72QVuM9PJLug5hUcbvcAWrNVnIncHKDSvSTo7NjL3XV8CoTMuq9Lp/mJeMjABHf1Rb/JddyyokoGiByfbTKxv22cEKC3Ymes0w=
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


