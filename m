Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E491F532F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD556B0089; Tue, 24 Mar 2026 04:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E636B008A; Tue, 24 Mar 2026 04:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CB96B008C; Tue, 24 Mar 2026 04:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 206766B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:53:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6C00E0BA7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:53:42 +0000 (UTC)
X-FDA: 84580343484.19.83F9F66
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02095180009
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:53:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hnis4mFm;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774342421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kze1ges43lCb7kREwIJMd42h9t5NMryI/FoPBiTgyD4=;
	b=NbnckwzePMKbNn3vaVOBDsjfDEgE5ZzW29OTataKXqEs3OHhmHMKzlo4m44MaDbjcIpEXL
	NLcRdYx3vvVGL4qWiiR+A9FVJOG8jSDpLnstpRBAIqMTCcrL+N4BQz/0P1/CtRc1BXyCuj
	M8A1eqsLLJzK+Y9ep+n26hjZwl2OMLk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hnis4mFm;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774342421; a=rsa-sha256;
	cv=none;
	b=8I2bcPKGgGQzAYTIO91HUOga4PykVOq0Rs3ES0QCSWYDbVvqnxQxCKbwdj0OfTP80Jkgd8
	rHTrWugdtDV/gCmpW9idp4Qs0ZWie5ZIXsCQkIuTJQ/+TFCzEKgEx+5c/YLaODxUkfvP9h
	DDaj49Tq5z0w3UEYKw2Opn8RzO+IV0Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774342418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kze1ges43lCb7kREwIJMd42h9t5NMryI/FoPBiTgyD4=;
	b=hnis4mFmxk8UE5Ph4hvLT2YpX6ce7VQ4AmCZgAMaj4z+uGLDqMhYDoJvPDCWcfi0cgNbJi
	IFKDU7+TfEUCxM8/gnJq65wUDQYGfxvbQMfNvAu236q4OxM0y4MuqWhoswILqskVnJIBLo
	g67MREHBdhQsfRHzMJd6jBxvyOqpGck=
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
Subject: [PATCH v8 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Tue, 24 Mar 2026 16:52:38 +0800
Message-ID: <20260324085238.44477-3-lance.yang@linux.dev>
In-Reply-To: <20260324085238.44477-1-lance.yang@linux.dev>
References: <20260324085238.44477-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02095180009
X-Stat-Signature: g3co3esm7d56iiye1o93xq7fzfdci7rk
X-Rspam-User: 
X-HE-Tag: 1774342420-401427
X-HE-Meta: U2FsdGVkX1+WADXKDpZTD5ZfYuUX0BktYBCLPDw6Rza1kz5MMPf3hPhSL0x9/xPZa1DqtWPOdzB+NIhbeopPw5jWrSm/hxk51RlOo37GFtbYoLvrLGh4N5cJ8Kpw0DL/J5xiIq3d8gkZU56sltqwBQ7ewbmIo9ZWlAI7wtrdTnknXeIHPUgWzsSsuZxYgmlcKLlr5FmioaboYbKNopQJMbmenf2gcOJiqrMMcEwdGu4B0fu2Xd0N5eT4glUTqAHVvP8KRlGfYa9laJUN9q3gheQcSvJoo5v4z2aUkQSwwMWAmoC7Nhg/oomgVA3YWsEic1E4AsFHPqKkc84tzs1qTP05oniqYaHD3sTruRrvwAwi6146euHCKAfgvNR99g5t/awKPTy2yreVWEwcylV/dCeBsbuoTU+nfwUj7CDTnx93FaqpFA9vI0uQDpWuKmcHAa3xXYQtnVGoumxzDL67WJ0V1AHnixac6t2WrIy93nSHPW2oHzFox3apCWpw/2uSN0ze0NmphJRRlGJCh55N0hoWQhNSk+E623wQRPUxtedwwcR56B/otLizj4nl9ynr3I9G4fssFTSC+kRnUus40hVP/vwz7ei8ZTOgKG0WPiExO6JwuiYqV2n9wO1d1/HPxcBsYUMDLKRa8LRkzjtD75YiVS9KGTsqjLG9mEqaP+tki76ns+HzBbDshUlhmkcrrAK1yhOE5qAY5ACbXmi5w5htSbZd+ZJBfOGwNJYfzovyXCVnVRG4bs+wbhHn55UUXaMiHTUFdHALLSVRb3g/B2wtebDzziN93cRxxLFaTJczsCdPDkd3SWbaD2NYg4DlbWEt/mVpyEy5WXsQDhb29vsbj4hLCwLUxwR1uQTn6bV0OtPrHi8x2G5VY3lrtA0NI//M77gWR9f8aoeX7W7SvYjVQGG/y+pL6vLd6NBrTsX1DsMYJQM0dClX8p23movTUYfjtfWMuiL922oSAt5
 FTZxoRca
 OABAXvU2SAYVxzFZTI2NGqU0dElmAFouxyI/MBVtIf2KTS14MLtHEGjLETQcfpWJvXs0xZVv/ZjVzDNMDVSSOVbBPSmPXqqxWaBzLVwv4iy7fpdFlnZLcKnnuylQ0jAKGfmNGRd8TzAtA7rAAVTa3isjB96o6JqTR3sotOK95StD35U6YWw/sjubiVtujzHxcd7lrgTJ3h4kYQwPTHC+eylIG5cVP5CvvOO3t1UkTySb+jMuk9Iz8TAzaAFMkooe9HN82LPjOwb7X6f1rakbAqqZvY2R7IiAWb8F6i0hzovXOw9LgAng3fuun7JiF6mXjRUqM5JoIwUii6ElfFovCQkTghw==
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


