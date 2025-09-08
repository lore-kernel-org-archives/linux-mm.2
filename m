Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91897CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2D18E000E; Mon,  8 Sep 2025 03:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82F68E0001; Mon,  8 Sep 2025 03:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72CB8E000E; Mon,  8 Sep 2025 03:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BABB28E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:40:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7117686DC4
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:41 +0000 (UTC)
X-FDA: 83865285882.18.A537E82
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0370140002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TqQU0p5nanGkZzKBNm5/YAgWc7NZLPBzhPX4sXJNxoo=;
	b=AfLpCw1ykGWIIbuX194kJRSfhUDP5NlI8p/5UeiB3/9as8W+a0AOX5MQsHz1CI9cecrGEY
	FrVIcvV/f01C0sz2UY6fhrdTFIFiZNBQBbC1nWkGcoeo/7HE/0sMYFuFGnYvp6aCYoWCiK
	96RAYPjmOKVksDbGeB5JeOATrGbbUtU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317239; a=rsa-sha256;
	cv=none;
	b=TGdr6koNJEkh1sKBd2sHpxtvelClEiuzgDQIJ/BKVo0QP84fr6WOwv5QVBiXq1EqBDIisa
	w0EreeU0MANUEeCbYyN0BaU4TLdu5ILGgTwmTMoO1y8ia2tAbt7SfyJ2xWZslylIMy8Dum
	wN9mVhsMsQxZk2FV3Me7KyISrWIebZw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751C0169C;
	Mon,  8 Sep 2025 00:40:30 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20C3A3F63F;
	Mon,  8 Sep 2025 00:40:34 -0700 (PDT)
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
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 1/7] mm: remove arch_flush_lazy_mmu_mode()
Date: Mon,  8 Sep 2025 08:39:25 +0100
Message-ID: <20250908073931.4159362-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0370140002
X-Stat-Signature: t5ihk3na874xdfkdfe3kdgbcf8mzfa5e
X-Rspam-User: 
X-HE-Tag: 1757317239-638308
X-HE-Meta: U2FsdGVkX188BTKLFx3wZdfgVjTChGBkBvAoBAC9pn3236h2HU2rqZC6jejGVY4f9lVF3N2QklI4izStjsZNtBs2ebc+x8B27zDt3hgQbTACkLe+EuGWpJYXamDNYEkC+0rfogG/vazLJz/5XbO3mq3zo3V/wGQDtbmmhmX7qWIskF47y4JAdCF4ufOu5vgHIBsD+3gWgN4X3+6lRAU5E5WFpO2XHGC/ANlP1mibmJf5rxZUIG/sy/UIxF0esfLq0SaTocdffgr2DzW/MjVLvcNZWY9FX85epLWeo2wg0DibvspP7RPcvSUPhx1lwey5phI7YDP2DdFYF09xQyCajJNFaPBkwqRuXupvW3E5yMUZSS3SLQZF6+5sPbZyDLROi1JC9ACmntuUDm/wgJRDh/c/2Pjw0abL1vb55wTJEd0KjH6QwuxWKScz0D2t+Pt0kV68Hy/jqVEhMre+S1UM8u3WHajbREPd55XOu4IgOcD0CKWPfazF/RzHBcrQepFd8sRjU+u0YE3qd7iJLAuIwGEyovXrYJ9zKvZs00Xyo5+ju1Ir0REp8viSgy4yAeq169n+xAsO70GydQJJTv/qsh5M+NUzKVO59EjMD/T7grWyr9ZL/ozH8JExdv6tFyGggkgqwFCutvO+qVqnRdh7+g3UynV9qxMeTbRRkoK/xI0lDo3bSqDD/+cymOrIFbQruDCyKu0af5moqEzCA7uvpLHRnx3Dzs7F/XGd+JfkdCKPYMySWM6v5q/etqqCAPAHrTlRcDnWlRc3LwPl2pOKhTjNcwY5p/YBnwaSeOs+k1/Bp4HCpRWNGxtp2rOetanzc0a+/AeZ7/AcQmHTjOop+XaMLQSiUl2wtXVKT8/Ft5ad/phcC0vCvM/Cl8UAgwyr8B2b8Z2VVqlLUii+G9QhuK2yb6WGkv71I9rzfBvv6+YTQGBg+Gmnhwhnye4mXiiUgfatRvW3+IJef/PjIsP
 5pYe0tok
 WnqYhTsYMXQf+txTTwpcOJ7vH9BMflN3axGpol1KHUySPUH4f9BUIpp0K97hm2+Ja+m4c+96TVxgCYwva8IEk6GYOd5By+K6TmXgGzOOPusWM7bnW5KpEvakLFat/JR0W9Q0zR1YjfyNj8mt8tndhpSsCLy9vrRcj6gaDclOGErmUNn/v+9Qq5tchzp6URfmtpIfESXWefGmLq43uFoUKdgugYRfcSUvHJQ188V3ujnf6MPyPEKCbwkm/Ak2BjISYBTIwBir3ts5WY+NSvMjt8oOieA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function has only ever been used in arch/x86, so there is no
need for other architectures to implement it. Remove it from
linux/pgtable.h and all architectures besides x86.

The arm64 implementation is not empty but it is only called from
arch_leave_lazy_mmu_mode(), so we can simply fold it there.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h                   | 9 +--------
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 2 --
 arch/sparc/include/asm/tlbflush_64.h               | 1 -
 arch/x86/include/asm/pgtable.h                     | 3 ++-
 include/linux/pgtable.h                            | 1 -
 5 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..728d7b6ed20a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -101,21 +101,14 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	set_thread_flag(TIF_LAZY_MMU);
 }
 
-static inline void arch_flush_lazy_mmu_mode(void)
+static inline void arch_leave_lazy_mmu_mode(void)
 {
 	if (in_interrupt())
 		return;
 
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
-}
-
-static inline void arch_leave_lazy_mmu_mode(void)
-{
-	if (in_interrupt())
-		return;
 
-	arch_flush_lazy_mmu_mode();
 	clear_thread_flag(TIF_LAZY_MMU);
 }
 
diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 146287d9580f..176d7fd79eeb 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -55,8 +55,6 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	preempt_enable();
 }
 
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
-
 extern void hash__tlbiel_all(unsigned int action);
 
 extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 8b8cdaa69272..cd144eb31bdd 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -44,7 +44,6 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
 void arch_leave_lazy_mmu_mode(void);
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 void __flush_tlb_all(void);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index e33df3da6980..14fd672bc9b2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -117,7 +117,8 @@ extern pmdval_t early_pmd_flags;
 #define pte_val(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
-#define arch_end_context_switch(prev)	do {} while(0)
+#define arch_end_context_switch(prev)	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif	/* CONFIG_PARAVIRT_XXL */
 
 static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 94249e671a7e..8d6007123cdf 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -234,7 +234,6 @@ static inline int pmd_dirty(pmd_t pmd)
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 #ifndef pte_batch_hint
-- 
2.47.0


