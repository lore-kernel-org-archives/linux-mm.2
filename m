Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9268F532F8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604CF6B0088; Tue, 24 Mar 2026 04:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EA16B0089; Tue, 24 Mar 2026 04:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47DE96B008A; Tue, 24 Mar 2026 04:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 386096B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:53:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E61A0BF322
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:53:33 +0000 (UTC)
X-FDA: 84580343106.26.ACB98D8
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 394334000A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:53:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfZiOVLP;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774342412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4i42uUk09a42HzxE9DZCh9MNHfSJlOmtFh/Ez0FeKo=;
	b=EM9IpR4ZTNEic/jpNHATs8NfOdNom1SFKmKm8vQCB4VoOVKm/tuIn3RiJGHogBRaS3CAoS
	D9yjwfjKZN4bVehuNsnShxWro764WkdL1jhEEashs+wAAehZobvQo58PdFgXrwZWNk+o7R
	+W4B/CHbELKUnDyVtH0OXD0YNgWmOys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfZiOVLP;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774342412; a=rsa-sha256;
	cv=none;
	b=uedVa6rAEmj73Dage0CMYTf2nwBXWS1/Xr5NAqaYTXf6Pz/OGkiczMZrzOX2Cro/CtNyfW
	FXbk76HMmnSQgkFe+Ky9f0Wt/B7yrwgKdMb7mvv9Y2OBiEz7gTjVADaeVVC5T/zgocDx5a
	OFTzc4N9niwG3YzqSmSi1s7vw9F+dfA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774342410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4i42uUk09a42HzxE9DZCh9MNHfSJlOmtFh/Ez0FeKo=;
	b=bfZiOVLPMKSauHlnb2CihyiJSRqCLYaNHoEysG29XcsVxPVbt/L8QA8FsXXbEMXk50FCPn
	SPiaiSVXikhWgg+RF2PDxDOwAuJ2y1Mphr2eC1iPeU7k/byHcFHNdnGThc3ZJolikPLt0O
	Q/Utvb4y7tulwQbjhKpwXUn1WcdoSEE=
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
Subject: [PATCH v8 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Tue, 24 Mar 2026 16:52:37 +0800
Message-ID: <20260324085238.44477-2-lance.yang@linux.dev>
In-Reply-To: <20260324085238.44477-1-lance.yang@linux.dev>
References: <20260324085238.44477-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: xwknafk61n3wp6myi1w36cjduonhho5k
X-Rspamd-Queue-Id: 394334000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774342411-756739
X-HE-Meta: U2FsdGVkX18SNlon8/mzJJut9P8CT23QbD5nOhp8yJhSP3jJgHbgXAs2hwfILB3UYst77aGUEGRXFc/d5rftbk76gKHRRPxxMn5jE7sbuUcXhgGGj+8MeWEjJvji5qN5yPGZl+UqnsgbN2qQLTNIL1qiRZnR7Q2/2eCjiSvrd9obaNOPfuKsOUx4pFJqB/RLjZyu1OxQtJTS1HcfaElZzv5paHEDny0KVWjgpnK3zG2qBnYkY8VJZWZm89Wzusm19VY9KjTSH71R6vsgYowauDCCIm1NADHYV6lJn3Ep4Uke1UDF3MTefZNyfvAx706yWo3diNPEzCE1q+tTImOiEqh04CyRZaPkGt39vTxS0NL27r1Cq1t58p/YltDJ+dU/7oIg6kTzlxydKV4R8F1h21fncwyEKIqMHAQqP2tcjNKRSzdkJWqZY4Fi5h765XZ0GKCFUx6t9Vr1pAoOL49H6ujgdIDKEQkjw/DfwKB2JBpa8eUITomCeh8IusMt7Q8TpwlwUSLY5gDQq6plY4ZjYWcbwuiEjXP8jPS0g5VGRLD6+jam8Q9fXhOH0gCdBK58r7IZEeTmolgc6paGdh23kJTk1BG7I/cT3RW8XV3nmdb6RvVEyteX8dbfFF4S0IEV0k6lt5+AjP0dimHSGFqvoBjXYReq6BUbjDAUYP+PmsQ52AiYDtiP+WWRyYdBaLpzFpuexkeQ31WIiPw5Thlc/bdNBuGhaIeko7WS/GxC7gZtJvpKMFoa+nLLRNzG1kcjQN41KVQJnuDao1ghXjK5wmQvewdjLPsLNpts1YCdpSBASIlJ073N7PI6JvRed8qPGjN2CNNiOkZXWRxxt9jarcSrV43bEquS8f2Hv+E0OdDrVpkkCLFRgQ729KyFTGjzwEiqbDOGXmTbddAxW+5UufYNPY5X1jFXdKjG/kmnhoVwsjkiBEDlr0Hv5s/c0FoGNn/1pLivKlahcsgwqXP
 bm83uMXq
 629ldZ7EXuohtIPd6gtuAbcwE6/Rw9n/ZXUJfWOeI+7mq1rNaOMoFt8pra+p5AUM90lIE6w8s3Sdc30JsSlxhjsQWZV2SjskVkOmxw8Kbl981hjt9yheTLILNUIvhCZ33EdnpniNtp1Dq0g8zpGsWCI8WWQHiqqZzyygwBBGZvp3hsL1fY//9zGSmfi6lCUnOXWG9nqEftELSIDYzwljxcm/l8dY/O8RNawD2U4b0RWKMbZsWIJ1yZ36dIirLsqTAb9s29wMQNiv3CVNcrYeNcC3/K/k2yIjI0/8UMrl2eB1WN66cIMa7ee+fLKRgqcF0Y61Btm4qXuukw4I=
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


