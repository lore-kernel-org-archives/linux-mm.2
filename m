Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE2BEA71B9
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 03:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80F96B035E; Sun, 19 Apr 2026 23:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57AD6B0360; Sun, 19 Apr 2026 23:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E876B0361; Sun, 19 Apr 2026 23:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 962596B035E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 23:09:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21D1A1A0861
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:09:43 +0000 (UTC)
X-FDA: 84677454246.23.2FF52A8
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 49AA840008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:09:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lsiu4R9R;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776654581; a=rsa-sha256;
	cv=none;
	b=VVHghmXGADhdSxXwPT2dt8RCdk/HzH2738r7F8V726apH92xBGGh3D5aZ5dz0t7rGw5Oi/
	ptetg9hPBIKz5U7R0C3+80K7kgHQV5KD/n2Y9EZKZtAMVlmVzAEbt58UlmaslUa3eDu/0o
	j3T5D/aWU7VYDEGPr+0+9sg7oJMiCFQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lsiu4R9R;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776654581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kze1ges43lCb7kREwIJMd42h9t5NMryI/FoPBiTgyD4=;
	b=ohInfZFaXRZAhkotRajUMB4qC1ktvTd7H3LS4Kzg+1QrEo80f4IeWCXGj5iglggND5t03t
	cktrOupMF1eyQw5Jp4sbduE7jvjJx5Ycexy61VZSid5KAX5JCyDwXHLKoGHbrRQvT28e++
	sUQg7OGS1DTgaUlw0RMdKWoBQRjNMT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776654579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kze1ges43lCb7kREwIJMd42h9t5NMryI/FoPBiTgyD4=;
	b=lsiu4R9R78Uh7jhOdpJFHdpolaOGSiGwHJTEsJwIHTqD0iF9MJDaWYhdVdsaOy8mUgmAKs
	RPOoizlGuZWzhBeLfaJYoqklPSjqoSjOlOUwFwEVdyVSA9VARCEajqu8G3c0y2/62g0S+W
	zBZZaL+/ItAZMUCTJjnc+nOfTzasN88=
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
Subject: [PATCH 7.2 v9 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Mon, 20 Apr 2026 11:08:51 +0800
Message-ID: <20260420030851.6735-3-lance.yang@linux.dev>
In-Reply-To: <20260420030851.6735-1-lance.yang@linux.dev>
References: <20260420030851.6735-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: xtn39nmyzf7fcfu3scz46wiwsm5o4gni
X-Rspam-User: 
X-Rspamd-Queue-Id: 49AA840008
X-HE-Tag: 1776654581-705702
X-HE-Meta: U2FsdGVkX1/gUzktI3A6u0lbr6dsEbAQI+C+0gDj0fLZvtqri7+/IrnJsz5bC/PMzrxWKcJHxa7/L7tv70OSPTfINCNyOwkGrQhNSeLJJdkPRORW9778C31SkIDv+s544PwR/f7iiKk8Lqswj2GD1+j/QJZitklmamyFLIVLnfyzu8Sm3QNi96F/aRvU4iqVS3AzMB9eF2FqOQSVGK4sf0gNNXJR4DOIXn3Zrnv78knEeGrU5BJkW8md8tRGb9hqlPZPz8DhrxRzGnjc3v/WrWPWzJXoJWoniHNkst4m9ni71rHf02bWahuKPoxeFKn0waocJ6bVzXQbUUyLPb4UOtx3ai1cEIYbykbprMuyEKn1gNpUX1mhbzno2eZoSK+dqETm07EPM76ZklnxdQr3I05zYOHhsY6GteIWKup5UaLk6Y854G+dJjb+/STGxJjs+P+ZhPizc2A+M1424J1TBpSFZwQL6NOWSNxe243MxPDpdKMuMhn8kuhpYSXiePOZr3uYtVa1JixYdonh/wSsrClLf/P9qRAcbAsgUcxThOTPpiYjookM3gwxpbN8G5QEWLIHob5zzahGFggBiNSngCfDkQ1+fkSOrakO7/HR7NqvgHCDXjf5SUd+MXb4OGEdP2ArAzeGJsYdRnailQw0ZZkvTU6SeG4zkZPlCLelBeXlM8W9Q6wg+5ONlrQbN9bYlpd0PFCbOy6iKG6evt93DzPXGRBwwzLWtjPVDr1cxZVDVr7lihaICRp+zarbXVvc7pvdLoEfgQ1pIjSRU9BLp7FkN2cCD9bsgJrWPSnjxvAT1Xt1x8MrUoyMU1pKNrrIcavAEOEptkz8iM5+6R1DR76wW7istkGlRgroGN95BMyflCZjIioQ+sl4As3peLZXlaNrrBJyxL3xV1TG1k0JVge3lXfA0Vd70squQf6CtJhJ3d81aDLVGui/JEh8cvFkIzYcu0vBaftm1yXjLkN
 gV/wDKDN
 VRrcjmRZFnJmCAhBZdvJ34AxOWvYALG3MUWMmhpop606FsbQzKPLlGf0g0YKcpjJecb9Zqqzw2EpXbn9IePflszgROVa7CtspKq9erIRv0CfkeTDPxBP7+yJg/BIL2vCxtbruhyKT1kE/XkHmy4nPbwN6043zOl2/YIYsj7NSBHArRJz5RnJTBfUXqmYRrXq7cX702KVnk2KZmd3+ag90oX13W+JKj2hPcTG0GlhTcs1fyYXrSdsTkG2ji7uhFNIic2LVGjSQiNlpYJqaLwdW/WxFCDdPSZquYnmNCLfrQiEnpk+nxRwH0QEAlpqJyaN0mc+Rco80EDZWYQirVTD8Jwi2Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Some page table operations need to synchronize with software/lockless
walkers after a TLB flush by calling tlb_remove_table_sync_{one,rcu}().
On x86, that extra synchronization is redundant when the preceding TLB
flush already broadcast IPIs to all relevant CPUs.

native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
flush is always in use.

It decides once at boot whether to enable the optimization: if using
native TLB flush and INVLPGB is not supported, we know IPIs were sent
and can skip the redundant sync. The decision is fixed via a static
key as Peter suggested[1].

PV backends (KVM, Xen, Hyper-V) typically have their own implementations
and don't call native_flush_tlb_multi() directly, so they cannot be trusted
to provide the IPI guarantees we need.

Also treat unshared_tables like freed_tables when issuing the TLB flush,
so lazy-TLB CPUs receive IPIs during unsharing of page tables as well.
This allows us to safely implement tlb_table_flush_implies_ipi_broadcast().

Two-step plan as David suggested[2]:

Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does
not apply: like x86 with INVLPGB or arm64.

[1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
[2] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/tlb.h      | 18 +++++++++++++++++-
 arch/x86/include/asm/tlbflush.h |  2 ++
 arch/x86/kernel/smpboot.c       |  1 +
 arch/x86/mm/tlb.c               | 15 +++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..fc586ec8e768 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,11 +5,21 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
 
+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
+
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
@@ -20,7 +30,13 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * Treat unshared_tables just like freed_tables, such that lazy-TLB
+	 * CPUs also receive IPIs during unsharing of page tables, allowing
+	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 5a3cdc439e38..8ba853154b46 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -18,6 +18,8 @@
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
 
+void __init native_pv_tlb_init(void);
+
 void __flush_tlb_all(void);
 
 #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 294a8ea60298..df776b645a9c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1256,6 +1256,7 @@ void __init native_smp_prepare_boot_cpu(void)
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 621e09d049cb..8f5585ebaf09 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@
 
 #include "mm_internal.h"
 
+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 #ifdef CONFIG_PARAVIRT
 # define STATIC_NOPV
 #else
@@ -1834,3 +1836,16 @@ static int __init create_tlb_single_page_flush_ceiling(void)
 	return 0;
 }
 late_initcall(create_tlb_single_page_flush_ceiling);
+
+void __init native_pv_tlb_init(void)
+{
+#ifdef CONFIG_PARAVIRT
+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+		return;
+#endif
+
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		return;
+
+	static_branch_enable(&tlb_ipi_broadcast_key);
+}
-- 
2.49.0


