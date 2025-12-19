Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EDFBE66881
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CAD6B00CA; Fri, 19 Dec 2025 11:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B92B6B00CC; Fri, 19 Dec 2025 11:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A716B00CE; Fri, 19 Dec 2025 11:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC50B6B00CA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:16:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8669489AA7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:57 +0000 (UTC)
X-FDA: 84236724474.14.7FF0BD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2D381C0014
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dr1njzt/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161015; a=rsa-sha256;
	cv=none;
	b=oUVwsKxvupDMTyYUY8UNupfSNRb62QfvPlRsSwU6IT5kfjMIC1H2KN32meayrhLLPBmEL2
	kuvkPgPv2kstbHdWUWf6mOmBHiqRr7FZawOGIfxWTKRai70mmxVEn0TdC4kLVP2+GEvfwI
	1WR9im1E87QLFmSLH3+Z7d6/GEaJCRk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dr1njzt/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oG9kzwziN2rWpW0J23ulZ8PPa8l4j1tYoxfToGcGa/c=;
	b=KBbg6f9O0jRy7U5yBfcoKHhiMOQwJZbZadES2kxzHR5v5JeOuwssWFJ7mXxXHgD7ZzYNbw
	uh7AzURdC5gfY5MrqyLu2pFG4Y1r5LzZmxNcbA7J/FVWCDJK9JppQsvVcWziEQB7DruHz6
	NSy2CHQePL93xA4l1NKFTYjaI1kb3fc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3C3241747;
	Fri, 19 Dec 2025 16:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC90C4CEF1;
	Fri, 19 Dec 2025 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766161014;
	bh=F/duNi/R+z4Zxeogcma6jsyj8uMoppVrtRXoOSW/Mnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dr1njzt/ZA2YkMrI9vlpvAk58EeOXzfZgvm82fooWsxvAjI+WLQL7Q/izIntoUvci
	 lNYwSN6zJDeOAv7Py5/fvtKwuZt6c2r6QNzKrLsZia6iFqr8ljf+27wmsA5sQxOs6C
	 NLuL6dY8TCD75VnCUFjGlNOmAgKtpE7NrmheisGdmSORBdfWQXvrwt02aM4URw2mmn
	 cKZVwFvtZcBGtj/TYUN05rtShkZUV5gWS9VMqCZm0z665W4wfFZKeO8C4ZqI5hJBmB
	 aNNcdeMS86UdNRfi3hcsDCaqTY/hITk5Gev5USZjW4RHdd+QAmsh8MnJGwlJmyb3a9
	 fJ9AM8CkZhLuA==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthew Wilcox <willy@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH 4/4] mm: remove ARCH_NEEDS_KMAP_HIGH_GET
Date: Fri, 19 Dec 2025 17:15:59 +0100
Message-Id: <20251219161559.556737-5-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251219161559.556737-1-arnd@kernel.org>
References: <20251219161559.556737-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2D381C0014
X-Stat-Signature: frgw8w1uc6oep5u8ae1g56i4gw5pgmxx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766161015-512682
X-HE-Meta: U2FsdGVkX18Ixc2xCtbG0MoM5YFQerj5G8IEGXro6j3lKxWPbk+o5L1EjyizwmQkm3fFnVYN7QqxbeN/yekCi/wqmgEzA2TqmDCPUWUuqzxrM+qDoIuticQrU4I4P4ZorGv8K8vtlfKbYVd/v21VaIqrgO8R2SJR1jyHMcgPu/TfHnXUE6Cr2y/nx7adttxZRzIx+iKs+nYrUTa3xjOnooi/3+CGgl6petaKEajr9f1JBRtVOFa0HN4+9IkP/r9TDUOoeNNE29xPQ7NlDpp7NU3RsE+Lgh+BLVNwxflWDSgpwyOKwSxfbtgPS0iQmj/YFLilZ/OTOtLzkhTz9Jy09PjmALrhVkjAe5JNSvEmKjpW/bJy/PcJCYdwugYsyltXdUCvtZ02pas9dNUCaHx5W7/rOijDYw9hd5MWA/w7BVmn0+rMiUkB2qsWqmEVAZs1td+UTwWoQY0MBCfwkw/KoySTMtlTTjC38CIbbIrBjyz75S0FymjsRK3pwqUwhwL768i5/higxI6ODkJh8eM2zpBjssMHJacyDV32kbSr9J0lamNrlP33tDBzMThTscHtpSd6DOdIanF2p2paksMqiQEu91eJxmQ/iQc4QqYKmiuvMlTNOESEzqd88UzZ+J6HIQNrnogWSwp26lj7ESD65or5hOa9bE+0Zix6t0u8iFUa1TY2si3/OGbj8Q7yjmlx/7fNyqKXT1fLzvIlsHgQiYJG2+qd8C7fHCCFsSZvY+ish9aFjHWOvEmuIfz+ExM3/uKWIdya7OxkPS5KHngQ0FyP3miDS6KbGOjo5RWnwK2+uqIcaiGfBIugV+0cuJZHRrRwgwEEwzmsM5yjBpeEdq6SKcNM3O/0gi/xLZil+Pxo7FjfKstvvNv8T/GZXapDfL6SsiuEYkd5v2J6d1gB6Fr9eM/5g6l83xSJtJRjuEyHsDTLQyjti+aMoMf6Ua04AH9G8GUo7vIcZ/8ABdq
 WIvSz+Ur
 Ko3PA3niglSi+uAwBnjGyLe50ED4hLQ3EGRJATHEWD3mtxW0613lzyepJlo0QNQrT1WPtDJ5u3WIwiMQKYJZGKE+pvwNuIDSWY8dWJIXuG3/vUyY8pHAreVltmXBfSCTNqK9kRJTFYnoV+WJFZpADo2nRUHVjks3FjEOKxItWe3t9rtGqykzrpUQHw86s1YNoxwU3GM5so6flc1yQF/xO/9mL4+YdAfsSl3VBYpGB8KnRHdz/6uqtmLrc6IEmJedHd1FF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

Arm has stopped setting ARCH_NEEDS_KMAP_HIGH_GET, so this
is handled using the same wrappers across all architectures
now, which leaves room for simplification.

Replace lock_kmap()/unlock_kmap() with open-coded spinlocks
and drop the now empty arch_kmap_local_high_get() and
kmap_high_unmap_local() helpers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/highmem.c | 100 ++++++---------------------------------------------
 1 file changed, 10 insertions(+), 90 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b5c8e4c2d5d4..bdeec56471c9 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -143,25 +143,6 @@ static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
 pte_t *pkmap_page_table;
 
-/*
- * Most architectures have no use for kmap_high_get(), so let's abstract
- * the disabling of IRQ out of the locking in that case to save on a
- * potential useless overhead.
- */
-#ifdef ARCH_NEEDS_KMAP_HIGH_GET
-#define lock_kmap()             spin_lock_irq(&kmap_lock)
-#define unlock_kmap()           spin_unlock_irq(&kmap_lock)
-#define lock_kmap_any(flags)    spin_lock_irqsave(&kmap_lock, flags)
-#define unlock_kmap_any(flags)  spin_unlock_irqrestore(&kmap_lock, flags)
-#else
-#define lock_kmap()             spin_lock(&kmap_lock)
-#define unlock_kmap()           spin_unlock(&kmap_lock)
-#define lock_kmap_any(flags)    \
-		do { spin_lock(&kmap_lock); (void)(flags); } while (0)
-#define unlock_kmap_any(flags)  \
-		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
-#endif
-
 struct page *__kmap_to_page(void *vaddr)
 {
 	unsigned long base = (unsigned long) vaddr & PAGE_MASK;
@@ -237,9 +218,9 @@ static void flush_all_zero_pkmaps(void)
 
 void __kmap_flush_unused(void)
 {
-	lock_kmap();
+	spin_lock(&kmap_lock);
 	flush_all_zero_pkmaps();
-	unlock_kmap();
+	spin_unlock(&kmap_lock);
 }
 
 static inline unsigned long map_new_virtual(struct page *page)
@@ -273,10 +254,10 @@ static inline unsigned long map_new_virtual(struct page *page)
 
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(pkmap_map_wait, &wait);
-			unlock_kmap();
+			spin_unlock(&kmap_lock);
 			schedule();
 			remove_wait_queue(pkmap_map_wait, &wait);
-			lock_kmap();
+			spin_lock(&kmap_lock);
 
 			/* Somebody else might have mapped it while we slept */
 			if (page_address(page))
@@ -312,60 +293,32 @@ void *kmap_high(struct page *page)
 	 * For highmem pages, we can't trust "virtual" until
 	 * after we have the lock.
 	 */
-	lock_kmap();
+	spin_lock(&kmap_lock);
 	vaddr = (unsigned long)page_address(page);
 	if (!vaddr)
 		vaddr = map_new_virtual(page);
 	pkmap_count[PKMAP_NR(vaddr)]++;
 	BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
-	unlock_kmap();
+	spin_unlock(&kmap_lock);
 	return (void *) vaddr;
 }
 EXPORT_SYMBOL(kmap_high);
 
-#ifdef ARCH_NEEDS_KMAP_HIGH_GET
-/**
- * kmap_high_get - pin a highmem page into memory
- * @page: &struct page to pin
- *
- * Returns the page's current virtual memory address, or NULL if no mapping
- * exists.  If and only if a non null address is returned then a
- * matching call to kunmap_high() is necessary.
- *
- * This can be called from any context.
- */
-void *kmap_high_get(const struct page *page)
-{
-	unsigned long vaddr, flags;
-
-	lock_kmap_any(flags);
-	vaddr = (unsigned long)page_address(page);
-	if (vaddr) {
-		BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
-		pkmap_count[PKMAP_NR(vaddr)]++;
-	}
-	unlock_kmap_any(flags);
-	return (void *) vaddr;
-}
-#endif
-
 /**
  * kunmap_high - unmap a highmem page into memory
  * @page: &struct page to unmap
  *
- * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
- * only from user context.
+ * This may be called only from user context.
  */
 void kunmap_high(const struct page *page)
 {
 	unsigned long vaddr;
 	unsigned long nr;
-	unsigned long flags;
 	int need_wakeup;
 	unsigned int color = get_pkmap_color(page);
 	wait_queue_head_t *pkmap_map_wait;
 
-	lock_kmap_any(flags);
+	spin_lock(&kmap_lock);
 	vaddr = (unsigned long)page_address(page);
 	BUG_ON(!vaddr);
 	nr = PKMAP_NR(vaddr);
@@ -392,7 +345,7 @@ void kunmap_high(const struct page *page)
 		pkmap_map_wait = get_pkmap_wait_queue_head(color);
 		need_wakeup = waitqueue_active(pkmap_map_wait);
 	}
-	unlock_kmap_any(flags);
+	spin_unlock(&kmap_lock);
 
 	/* do wake-up, if needed, race-free outside of the spin lock */
 	if (need_wakeup)
@@ -507,30 +460,11 @@ static inline void kmap_local_idx_pop(void)
 #define arch_kmap_local_unmap_idx(idx, vaddr)	kmap_local_calc_idx(idx)
 #endif
 
-#ifndef arch_kmap_local_high_get
-static inline void *arch_kmap_local_high_get(const struct page *page)
-{
-	return NULL;
-}
-#endif
-
 #ifndef arch_kmap_local_set_pte
 #define arch_kmap_local_set_pte(mm, vaddr, ptep, ptev)	\
 	set_pte_at(mm, vaddr, ptep, ptev)
 #endif
 
-/* Unmap a local mapping which was obtained by kmap_high_get() */
-static inline bool kmap_high_unmap_local(unsigned long vaddr)
-{
-#ifdef ARCH_NEEDS_KMAP_HIGH_GET
-	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
-		kunmap_high(pte_page(ptep_get(&pkmap_page_table[PKMAP_NR(vaddr)])));
-		return true;
-	}
-#endif
-	return false;
-}
-
 static pte_t *__kmap_pte;
 
 static pte_t *kmap_get_pte(unsigned long vaddr, int idx)
@@ -574,8 +508,6 @@ EXPORT_SYMBOL_GPL(__kmap_local_pfn_prot);
 
 void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
 {
-	void *kmap;
-
 	/*
 	 * To broaden the usage of the actual kmap_local() machinery always map
 	 * pages when debugging is enabled and the architecture has no problems
@@ -584,11 +516,6 @@ void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
 	if (!IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) && !PageHighMem(page))
 		return page_address(page);
 
-	/* Try kmap_high_get() if architecture has it enabled */
-	kmap = arch_kmap_local_high_get(page);
-	if (kmap)
-		return kmap;
-
 	return __kmap_local_pfn_prot(page_to_pfn(page), prot);
 }
 EXPORT_SYMBOL(__kmap_local_page_prot);
@@ -606,14 +533,7 @@ void kunmap_local_indexed(const void *vaddr)
 			WARN_ON_ONCE(1);
 			return;
 		}
-		/*
-		 * Handle mappings which were obtained by kmap_high_get()
-		 * first as the virtual address of such mappings is below
-		 * PAGE_OFFSET. Warn for all other addresses which are in
-		 * the user space part of the virtual address space.
-		 */
-		if (!kmap_high_unmap_local(addr))
-			WARN_ON_ONCE(addr < PAGE_OFFSET);
+		WARN_ON_ONCE(addr < PAGE_OFFSET);
 		return;
 	}
 
-- 
2.39.5


