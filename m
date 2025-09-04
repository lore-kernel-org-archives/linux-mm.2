Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B65CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112BD8E0001; Thu,  4 Sep 2025 08:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3068E0013; Thu,  4 Sep 2025 08:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2988E0001; Thu,  4 Sep 2025 08:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D92A78E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80D7056376
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:28 +0000 (UTC)
X-FDA: 83851571496.26.73B2E36
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id F00E7180011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tWQ/OmD9CmpzqUNR8GfFlqWGjLcl1VDbFZ1Nh40eC1w=;
	b=KcD+9vep/c8pbzfZMulUHfnSl6gPxrCFgLbGccRXaXFVAnw9Xy4n1VhG9NGqBNYLqzhaPn
	iZdt+bha/iyD4eOY1Jb9xa2VQn7gzx2FMcSO2XDZwmgOLb9Npbb7a7whgTXH/yiBMYPxJK
	2nZi2idP7En60gGRsSTCXe6ddru7JeI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990707; a=rsa-sha256;
	cv=none;
	b=im80XhUEJ5KJB/fA5/Ruk1PiToWeDwQ/AF9Rz9FuzpkUz6PthpaXwgAy6AJvXNqo3G/7Oq
	9d5Vte7DSJZVUo4PW5s73LOOTvcbJCTScUelIGtGmM4fyq5B0cLXyQ/IJR+NPSJ2JD/Kcm
	tYORtWNhYZ7VCQSoXFlbhxVK130YTSQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 741D025E0;
	Thu,  4 Sep 2025 05:58:17 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44AD33F6A8;
	Thu,  4 Sep 2025 05:58:21 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 1/7] mm: remove arch_flush_lazy_mmu_mode()
Date: Thu,  4 Sep 2025 13:57:30 +0100
Message-ID: <20250904125736.3918646-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F00E7180011
X-Stat-Signature: wqsqw5h9b9i14sz69wnroo6jei61q8y3
X-Rspam-User: 
X-HE-Tag: 1756990706-659308
X-HE-Meta: U2FsdGVkX18fOL4oYHjdlg1rJVnIThj6piPpwQZS6sKdtjJZ/eOi7isBtEJR02OsJGW8kJj4/Hvk6n6xfvOJMtQyPqaj2qHXQ+e8+L8U2b7/Gk5/Zu0pv6uXr4DwRsmmmmspFV4oXbFC71EZ1lziPPnPRH9jkIAhsZm/rJNIkiEpVZ3bk4WNw7e2S1FijnaQG1wOhGOxfKt94B8EAfNy5mctThk+21DmrI+cPjgUsSQ9Ktz0XrnHuCOPRrv40uawrL2i0PeL7UD/NIRgqI3r6znEMkIPebvSeiAVXue2nQaBVBiz9WtoFHBjxSQhCOPJ2VxaCfsKdlj3HX6wS3xx0BoJdNGjhEZeE2KRHp1egBSWcMrDQMqjPYPrH6ZzQ09zMd11su3A3lTj26yml9PexENczUyzSwqpGQ0+eKluplgJRl1wXtaegVkU5Zyqv3fe+wKnteAvxEy9xL7h9cQthtWKqhVEmP3hQJs/S8N0JkuXGYSiURUhaqZHJ0Ui6MIS3W1zvZmH8/iu8zDAH1Lmqekkhkp587OHwsLjQovezd+P3AaX26b+wc+f07ZAYYEivJuh/NjVAbAgnwaiUlI044Hn+ixhQtbyeroSmNu7yAFtyr6BBOLlI7dPDo+eMnFuPx5paPBUli9XOkwV75N/VnjhUqHK8hUICJizWbQmzoYzR0ip/qvQek8Ifh1QmG1WbEO/5wdnitf3jIretaubgSNhYMDxVJQPOhWHv5aTQ/1PLyU9l34Y6ElCg8x4+xot5w6rpy5kU6Vjaea5kXER4As6i/rKdXq8cq/wS29WEeUwmwwFOU87etO3SHXBaGIIQGit0e18jcLwcnqn7IAswblJP+vObyyF75yb/qDSTAIQaWonO3SR3ru9RwVjCFZRPqlOzRadKLU=
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
index 4c035637eeb7..8848e132a6be 100644
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


