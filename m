Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BB8D5B17C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDFC66B002B; Mon, 15 Dec 2025 10:04:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F796B002D; Mon, 15 Dec 2025 10:04:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EC16B002E; Mon, 15 Dec 2025 10:04:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A10776B002B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7332A12F92
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:36 +0000 (UTC)
X-FDA: 84222026952.28.F35A555
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id AE3591C000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVndtn13GZjkQXq4nJ2Yz56uyt5Z2O0y34NnRlu1iqc=;
	b=Ucd21mWKOWWEL/vs+ygnW6iCEohrqURKRiEfh1gIr9dm6oZ6TMFrmg8+xI1KufhQR/uGyY
	Dtfpll86dSkWsaJYVP1CjPgka4KIbsX67ih5UvmWveCg+RpZxnSIYBX+VMQhbUunHteMPr
	SKyAqBNrc9OhQHThLP3KzauZf68ZINU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811075; a=rsa-sha256;
	cv=none;
	b=cNfMM+Dw18H13R/jWb6Ol96/Eio+PMawCwzdE/zocJCoZonjSJrp9jHcNjxLa6l1sdtQzH
	DTlGk6Wkm9KYgRg2h/PF1H3E6tRSG15fPHiUng4GP8fXByPa56sDMKFbpbvSsTSCQ+FT3a
	WwY4ccQYdGnSwEhsnfHuwmltKvJ5h3k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB8BF169E;
	Mon, 15 Dec 2025 07:04:26 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E8EC3F73B;
	Mon, 15 Dec 2025 07:04:28 -0800 (PST)
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
	x86@kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v6 10/14] arm64: mm: replace TIF_LAZY_MMU with is_lazy_mmu_mode_active()
Date: Mon, 15 Dec 2025 15:03:19 +0000
Message-ID: <20251215150323.2218608-11-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: inwfcxfs7hwqad4wu1wacg6b9fbchh9b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE3591C000E
X-HE-Tag: 1765811074-451594
X-HE-Meta: U2FsdGVkX18osq8PZdwrGatohntp31pdRi4LQX9YB321229P3+4IsfrkHIpXc1s5UPxZkNgcrDNzac/mHobHuh0beBbXnAB3hS77ClxMWgMIJqskfj6BTSrKskX4qyDJUDSPqKOfFk1ryENl4yYxPpbVp1NjLqZz/bVlT21P2i0wTSY69dFwaOnm4SBzDlEUkMzmNlV7gyKrjLcNs6lJHIgLd0LB9nBSfttwtcG21DveQwEZfHmtvoPjGovu8chQMP+135uca1BE5/C+rHzyTV52/maeuPgTuMKxLbVcCBiLOKM2dH6WBlIxKg1mEwatP/3ClzW6RISfDRkeAER335HBtZO84wd9zRCsFPRjhabQJU8m8lPN5MRBeerWS0+Y4xbOshIazWQiaTrn22pASbVfZLVkWWjaDR4HpPQMmCwF0q9KnNnEOCljZBrjqczXEjpAxlCP9qeQzy6/DGdz8M0eQIAH5KCqFOxMkYZwo83QqUTyBXpvcpoZitcFoEjZ3RvUB4ekrL4XzWt1/h/Qji34YmPyq5wY/sb9GENi4+7nWF136aZ/kk03m3KsKfbT/2LcndXNE/OgZA6Xh+By7kF3Tlbexm5Qvq22ivfAJL+y8sQT1EP+FiDHy5z5FhY8nmz76L34DM4bQSk/Io9V3JEsIXtmUBkdz0xFnQMoN93J5W72FwCvJHbrIEYHDWBGa+qKE6i/4/Rqwpowh0o+j8Mk5ADqzc5u7SGLVv5YJFgj8vdwHBGywNvZpP8//rOkubDW4nXlzcy7GNrtOqZR7ztruVglYJvZGPzTk+ZUxXlMDqmxlAQaVAkpHw1VcI8oTflx0IWciLuLJ2tYi39/d569riCLGaHruD620Ffo0zJNHeswyZCZqj5TS5tLe4dXResX4LXROrStEkZmHg3blFGEWThETcXGmhHoWZzeP8Yt9aKADFE+I8cRP9qck0uzObtzVVAFeFUh9KClR0B
 XI4M308P
 w1niSj4mx5lX2ko4zI9eGyA78Ds03wrbrphwB4D1XyGVnYwd+2v4LFO17xudm9k5YjqVQTg9gxQG7J0Z38RFP9SM6HGSdX+6J7O09Rx7xgX60XCHN7kjyElzcDguDogQnY66YA2yhXNKHA1IYSfKJSVGK7c/iOzG1p3UQfCIw9GMJy5ZzdOW1Mm3qs27d4MxwfuQoLo9+8WP124B5vAZGs9K/YfG6yez2UXVFGnqqeJguJQV1ABIj1bq7H1JgoISuVZke+PfxgpygUPeXFR51O2NdG+PLPF1wd5Mxuz+8+f4lO6Jn4f1UNcR6u1Wf1RuVgORSb+8Ou7WHJtg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. As a result we no longer need a TIF flag for that purpose -
let's use the new is_lazy_mmu_mode_active() helper instead.

The explicit check for in_interrupt() is no longer necessary either
as is_lazy_mmu_mode_active() always returns false in interrupt
context.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h     | 19 +++----------------
 arch/arm64/include/asm/thread_info.h |  3 +--
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7f528c36d53c..445e18e92221 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -62,28 +62,16 @@ static inline void emit_pte_barriers(void)
 
 static inline void queue_pte_barriers(void)
 {
-	unsigned long flags;
-
-	if (in_interrupt()) {
-		emit_pte_barriers();
-		return;
-	}
-
-	flags = read_thread_flags();
-
-	if (flags & BIT(TIF_LAZY_MMU)) {
+	if (is_lazy_mmu_mode_active()) {
 		/* Avoid the atomic op if already set. */
-		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
+		if (!test_thread_flag(TIF_LAZY_MMU_PENDING))
 			set_thread_flag(TIF_LAZY_MMU_PENDING);
 	} else {
 		emit_pte_barriers();
 	}
 }
 
-static inline void arch_enter_lazy_mmu_mode(void)
-{
-	set_thread_flag(TIF_LAZY_MMU);
-}
+static inline void arch_enter_lazy_mmu_mode(void) {}
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
@@ -94,7 +82,6 @@ static inline void arch_flush_lazy_mmu_mode(void)
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	arch_flush_lazy_mmu_mode();
-	clear_thread_flag(TIF_LAZY_MMU);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index a803b887b0b4..e7cd017b07c8 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -84,8 +84,7 @@ void arch_setup_new_exec(void);
 #define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
 #define TIF_KERNEL_FPSTATE	29	/* Task is in a kernel mode FPSIMD section */
 #define TIF_TSC_SIGSEGV		30	/* SIGSEGV on counter-timer access */
-#define TIF_LAZY_MMU		31	/* Task in lazy mmu mode */
-#define TIF_LAZY_MMU_PENDING	32	/* Ops pending for lazy mmu mode exit */
+#define TIF_LAZY_MMU_PENDING	31	/* Ops pending for lazy mmu mode exit */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-- 
2.51.2


