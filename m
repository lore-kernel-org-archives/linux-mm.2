Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1304CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135EA8E0016; Wed, 15 Oct 2025 04:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DCB8E0002; Wed, 15 Oct 2025 04:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0234E8E0016; Wed, 15 Oct 2025 04:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4A8C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E47F88BAD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:33 +0000 (UTC)
X-FDA: 83999672106.28.22AB362
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id E056D20008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516912; a=rsa-sha256;
	cv=none;
	b=nf4rs5dZcWy+xLdJr3xfbbzDmHiqiQ8GxEqU6mC61OC0seOyEA0wzRGzB8yux72Axn4CGF
	2dygNw8gW7v+Xqnp+qpO6xZlOAsA9fdpR0oMgALk+xV9/OF1e53at+eoZ8yEDCKXjDodaT
	i9EGfCBUgf8+CHdh4V2U5SS2bq2eu3U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=95JLeA5pBrLWW08YxeG13d9XW5R7v2ei3BEG6R93cbw=;
	b=OLnhSkWGXH9Q/G+XvX4kD8+9oGwfmaciHt3v4xiMuyZiYTvx9fs2hX8zR/uxmFor7Tgypj
	dKOHrtKWPhZahQ+H9SKsNl5ag3H8+oQtqwouh2xK1VafmRbUP+fICGIwAzea8z21+VEumx
	t1ee10T1B9QhUFilIiSdKTiGn7CkAxg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C10E2309;
	Wed, 15 Oct 2025 01:28:23 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37F513F66E;
	Wed, 15 Oct 2025 01:28:26 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v3 09/13] powerpc/mm: replace batch->active with in_lazy_mmu_mode()
Date: Wed, 15 Oct 2025 09:27:23 +0100
Message-ID: <20251015082727.2395128-10-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E056D20008
X-Stat-Signature: kkqgt99j4jqnz539i9aqiib6h54myaxm
X-HE-Tag: 1760516911-745352
X-HE-Meta: U2FsdGVkX1+/XeYYYccsof1CeW0QPh3cKw0SoiQKbrETCGh/Xaax2fui+95iUjVPCpocxEVRalm+FGbFgwhbsVGpv+vJS+lKJmdG2uUJlkNPS8J4z0hLDHiauxWZ5Pj96GVyOVtqDW99Al3YT6NnuecRf9k7u8G9TWc1PExnvfck4j30fx2CoAFY2P6sNlZ7T483bVmLpPd2dDdsY8PPCkSJXeZEKIoOphyYOmJ35e1zRlS7cmzWO4FNxioqYSfRHZKXN6chFT+QLKtLVeXR4ji9ZLs+Ks0dXX6wDLqT745JxubvfaL5N5MjdrE7U5ao8qISSu+L0uEY1A+W69ge6YqMuCumOosuuJ6ClxijgpoUT14wylbnnEjvwcHvpssFt9XRxyzOTuHjxCoCKEZSTyRhsWo20soDuvb+NLMqLWH8Mh7iP4St+m6iasb4Cs4zVOGmXZZlltJuF45rqkeymcbs4lkxvYO+Xp6NrdeOSkRmbMvVhY13NjHFklDvFxo4n3zUv3idCR+MynQwOnZBKZ3BdhcEQn6Y3gNLuhJ68ogi4qGwHcDf74CpVi56DMu9X/uMH4keNjtDfX4GFzf/9aKxz4v8JLMlwoJ1BoewYA4bgnm3ZZ5tDGbZwJ0MHL1NF/Xtr7hcUYWyggEEDmOlD3vLLqh9ZaBeNjHmLK5wWD7sbizw4Qz2B4DwW8SfX8U9D2LDl5yvomMkBlqTfcCzK/kik5kr6KJG2I4eT/cWSFM8kzZDB5nifHF8tFi/t8tCwJMeOsHuHMPxW5C6hMFbhum3ksRqNvBWdhdN/SLDecByQk5zyQYO/2bUx5DaduSPw3RTk2Tb+sC7wSIxlpR2P+duHHQhs7Nt+dcGVjJ8lc4QfoutMtoUUiMYc9Q3Net/JcfwjN12MRVHUZ5zFpFT/Is/Qe+gfCqWCzE72tAKNnvLS7n4RCaoYsYR1I1TVEhm/pGQMgeLL6Luy808c+8
 coLgTwjp
 ks7AKobGQZVKVgA+rxXU8SA3g0r9lTj3HZLGqz8WF1cc4w19K0YMyAQDMZfogxg/2fLjOKBS8fU7rI1bpHwJ/oDsl6QPTfwUEMaPzCP9aEXY3+eVeRiJ1C+3f/RYHGvEpO+tyrdP6CtMgM/ZW7fbx+yl0CHgC161WUNCnPjHjIfgA5MwkLVBbLi6uMXvxOBOiLwVG843iE5c1Q1slMQQM9mqP/kNXVAzMIbS5vC9ETmfw7/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. As a result we no longer need to track whether the per-CPU TLB
batch struct is active - we know it is if in_lazy_mmu_mode() returns
true.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 9 ---------
 arch/powerpc/mm/book3s64/hash_tlb.c                | 2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 623a8a8b2d0e..bbc54690d374 100644
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
@@ -51,14 +46,10 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
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
index 787f7a0e27f0..72b83f582b6d 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -100,7 +100,7 @@ void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 	 * Check if we have an active batch on this CPU. If not, just
 	 * flush now and return.
 	 */
-	if (!batch->active) {
+	if (!in_lazy_mmu_mode()) {
 		flush_hash_page(vpn, rpte, psize, ssize, mm_is_thread_local(mm));
 		put_cpu_var(ppc64_tlb_batch);
 		return;
-- 
2.47.0


