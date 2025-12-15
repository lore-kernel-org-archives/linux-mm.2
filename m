Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E2EDD5B17C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824586B002D; Mon, 15 Dec 2025 10:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADC86B002F; Mon, 15 Dec 2025 10:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D1D6B0030; Mon, 15 Dec 2025 10:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 538D96B002D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1338989440
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:42 +0000 (UTC)
X-FDA: 84222027204.23.CC02374
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50DFC14000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y26enKQJ3yEvFYP+NLxL0wp54BhcnCPNCri6Vs6D63E=;
	b=uUqJZYKhabYLUg6O/VXqeBTrQ2J+cId35tWkh3aQjni+RO9k0ZxvJpvhJzWSDikt0+ZGBX
	SemDurWUfB94NLMIhNgaL0C6E/8Koyjj+LqlJUg7fYrHkkbQZhecuav5KoLBclToHygrEZ
	SC1fLf2Qhtdh/ORK10kMkJpVAa4khSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811080; a=rsa-sha256;
	cv=none;
	b=6tT4sIgO2QZbZzllca0s6v+XMI00/XlGunME9nEyE5JNSg9mG2NW7NjlIoTQyG8NVlXms7
	ho0N0CZ/4Whs8US2V7RB0MUfEmAb11vzQ0IAO/yk7vTWTguz+q8IQcgFEU5styrfOgrMJz
	FOVM554i/L2/XtXjQh4SLF8fNYeM5MA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B0D916A3;
	Mon, 15 Dec 2025 07:04:32 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A02B3F73B;
	Mon, 15 Dec 2025 07:04:34 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v6 11/14] powerpc/mm: replace batch->active with is_lazy_mmu_mode_active()
Date: Mon, 15 Dec 2025 15:03:20 +0000
Message-ID: <20251215150323.2218608-12-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1bsw5jfjdfmoozn3rebyfsfh7wjk3yxw
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50DFC14000A
X-Rspam-User: 
X-HE-Tag: 1765811080-561794
X-HE-Meta: U2FsdGVkX1/GC3kvVQt8leEY8VkQLvlTsZxShngMRr67Cw6PCPVVUZ7555lY782T/YgGYcvF8lYlxwnTVo+kPUkWkKRUVXFWFGasJRYM2o/OvZTq6mXnaSxib6VmRclx0UgmJRFd5/GYXyVFGj9zzVyb5J8CyESIKg1YaJ7kj0sCu7bK5thLEsIyM7L2TxmcCciGy45i6ZNT/qV3vgs41hOdKHfgs0JLPrS1jC/+7jtFIZrX5F65shUbd2oVIP4j492nJYngL2lBbvQoSa1yal96/ps1htcaoSxa+tXolaxXhWQTDnRa+jzcV5sCcGgbByQdz4ACLAoE2OPx3zjqcEkLJGEq/YQBCz+vj/MDJ0+ASFd7lQ0p97HqyeTTIwOWUegWCobXt8EgsnmZZ++JWxKytQMGQ86T3mkAlvi1/miJjHpnrykLwiKnXV7HOfayzWt7nxwS5ACsWeUPCd/ckubYrRFUYF1xsV5o7EbzmKyU/nWbUDQ/kjEqXQNyLN4D1UIhjf5zHUSYHsk+tMCAU5/dTEeH/eWTfT5WIWcZyfeLHgt/6zvt01jGV2M1AZynojen5YKvdABptsn649+bsUQUyLMEs5LBkbNXm8ws6Iw0PQfOkgBylQYP/pimLfHjDsP2JT1Piiz13+WhqBQhN4H5gBqDSFhbB7BJuOpdHMc9Qr3Rli9M/KZS8UWSLRbZUd4FWctlBWzNWmhg4XHWwUR8JgiUyYoe5CO81WHEWcPfvyDcjEI5jgy7szRCCZWqMF9KRIaqgnQ4tu95LA86ssQC1m0qLmQ5SkP2MxbKq4D9tONwpf6GrgnL1BRRhWX+pXRn2/hN4dyXwuYHlkpAgi2kfufCpylfyRzTO/DRtOqV38MbQcIXUDN/jZkqJhzVNQNd+Iv2qdOUE/b1QHtlGXfev5PhPBkJpoeat5tyLpQyx4vEBdTMr88x7YmL91yPr0d+lqsNUFhvHe3tzSj
 3k3WZpnf
 fSt6kQSaoVkr54BCEF3YqlNgNKAHhO9SNlECrwd7kakZqdE+fcHX9Ch1jWygLZXe54dI2pLb+/5GigVkkx8CIaI3igAprJwQOswZZdLEgs00jDFjTJk5BDWLnk/maLKspCdzCTpZEXtxxEC+x03SCfyLMrYeiHsaCoEW2JQNz/yOguf/XZbEXNoYEn6j8rayfvgaFtLGODoViXp/41+sV72kX/1RXUKFtOo5oCXvR5LrCag0BNNsILjDXx47mtySLozIx1R9HutIRwM6jtVEu+Wr+OUb27dL+k04NESn7AF8vbNO/40O9nTjTGCseEKrtElNgQK5tmqZS7Fq70OQFXtJtri5XNBSetBI6nz/31zhS60sFbmMAwSgleA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-CPU batch struct is activated when entering lazy MMU mode; its
lifetime is the same as the lazy MMU section (it is deactivated when
leaving the mode). Preemption is disabled in that interval to ensure
that the per-CPU reference remains valid.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. We can therefore use the generic helper
is_lazy_mmu_mode_active() to tell whether a batch struct is active
instead of tracking it explicitly.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 9 ---------
 arch/powerpc/mm/book3s64/hash_tlb.c                | 2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 565c1b7c3eae..6cc9abcd7b3d 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -12,7 +12,6 @@
 #define PPC64_TLB_BATCH_NR 192
 
 struct ppc64_tlb_batch {
-	int			active;
 	unsigned long		index;
 	struct mm_struct	*mm;
 	real_pte_t		pte[PPC64_TLB_BATCH_NR];
@@ -26,8 +25,6 @@ extern void __flush_tlb_pending(struct ppc64_tlb_batch *batch);
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch;
-
 	if (radix_enabled())
 		return;
 	/*
@@ -35,8 +32,6 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	 * operating on kernel page tables.
 	 */
 	preempt_disable();
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	batch->active = 1;
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
@@ -53,14 +48,10 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch;
-
 	if (radix_enabled())
 		return;
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	arch_flush_lazy_mmu_mode();
-	batch->active = 0;
 	preempt_enable();
 }
 
diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
index 787f7a0e27f0..fbdeb8981ae7 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -100,7 +100,7 @@ void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 	 * Check if we have an active batch on this CPU. If not, just
 	 * flush now and return.
 	 */
-	if (!batch->active) {
+	if (!is_lazy_mmu_mode_active()) {
 		flush_hash_page(vpn, rpte, psize, ssize, mm_is_thread_local(mm));
 		put_cpu_var(ppc64_tlb_batch);
 		return;
-- 
2.51.2


