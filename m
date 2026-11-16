Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9F0606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZR+QMJir
Received: by kanga.kvack.org (Postfix)
	id DD4556B05BF; Mon, 16 Nov 2026 07:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB196B05C0; Mon, 16 Nov 2026 07:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1076B05C1; Mon, 16 Nov 2026 07:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6D06B05BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47CC7A8718
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:33 +0000 (UTC)
X-FDA: 85440963426.08.B23EB33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8FED120008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZR+QMJir;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833371;
	b=BqS99lImAHnhlYZv0fnxcKPu8sFalim8f1uoHsTr7fGUMrqW2yl7wdPRoYMIWTDN3dMOa9
	2TSH8rZQH0eyhfHNMxWJNym2n0lL8AQpcpsAdiwsAY1k6E+pt//fbhyQ6bl0FOANv0LnKf
	beEOh0eW+W217zOxGWFcSO5k7eXebfs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZR+QMJir;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCmockRw/wwrY3GaIDLa2rah9UYe9pgctw5IGTJqrjg=;
	b=VKpSAaE4FJuWvnXh5MdOW8ZTCCHuLKEYbSiTiBn4Ncp/4fvXlQ3xOQflfI0XGieMVxtsPM
	r5pa+OOSFLOzcdnzGmbjbiMXQGOiguoEw7+DattommU+eFKKVfuY7bstqm0uFVsYhSJCaO
	00/R6WnXIaraoLhwKgxsmKEaxt4/e/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D529643D76;
	Mon, 16 Nov 2026 12:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033A01F000C4;
	Mon, 16 Nov 2026 12:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833370;
	bh=pCmockRw/wwrY3GaIDLa2rah9UYe9pgctw5IGTJqrjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR+QMJirApvglfDQeE1AHBlrmnK7I43VX0u47WLqAKgisWV+yDlquNV8ha1dAV3np
	 n9gomt89RYxCuiYmQJztRy11wmJKE5YyHPNYpnz7TpeelxUMHCWZYV34c7MQPOvYRO
	 /j2Soan9sWqkI7e2X6x3d5SWEZCIA2L5V/XxplbCjFeCtHc19dqTUU2NZjcVzqblA7
	 N39WbS+KZl6cs8M30wchBdK4NLdJW/r4y2V5M70by+4qvsWUb2fAGV+pGqqP0G3i7H
	 obE1ag0AHuOZVX/jKshMHQnqCafgsNeCkqOJRfLjlHoDACNg/ziwfyN/kvEP9sXjRY
	 xHsFm7UOYz3aQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v3 08/10] mm: remove ARCH_NEEDS_KMAP_HIGH_GET
Date: Mon, 16 Nov 2026 13:48:30 +0100
Message-ID: <20261116124832.662455-9-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6qsbddt7sjnnch6jstkoz8xbe4bwjjif
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FED120008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794833371-185971
X-HE-Meta: U2FsdGVkX18HjsC63gGXHJmW3Ivg27gehNxRJZxjVRZ0SKZDnUhu5+OaVWIeY62GuRh+r3AyNVNhFRvKWM/5CHwC0FZ7JmNF8tgX40OKwXn3NbRv7pidssfIWgDHpgAnSL5l4nIGMda6byl7tBD7urAEqTfxkfReL4fCN1OYK8TLBXsVzFyvyElwyLLK35wLuWAXVygX9ZpZpY5e7hTlDIkpBJsJC7zco8KIOspX+K0Rtv+cuGXAMHpCbPl4b2TkDtDoQdrW8MbmwzhYqFYmrxUwSAVPwriV5+GKZLmhwz2fjZIou1hPVEeQYcXX9mrzRdiCbkLT7BH6ds8h3qQwRyG+78jVMGMNKS9fzJp9V+AiVr9/1GHbuS3xxOpZLBDfyJ9R+g5uLiVCwqnRTEAhvjJ7AWL0vuzZ4rQ8xUQ02ThQ2LN994qAYRxACRdpaIUOW/roYsKPzCN/vltJUk/2J9cUwnZ7eCL7skM6agPAkYcjb/S4UVne9jbwOXBzI74pRPX8DCrX5V0+GloaDG56Ja6siCTZedxfzEQLloirjytGy1kyjhbE0MAeByxGlTX4cGrLzEUfzXa4fTcd/WYQPZhuuwXCt75x7ZmhGP5cZkw60Q9n5Uow1SgYsg1NZ8Cdff0cKqN9MBHABQJRSbr2wwmG2vf8E1C2R+LcPOhDYKCFpdlNdjx06ttqHjpMT8mWe4AQlYTFKeSntjMxcW+RiIh4Ia3lcbjD/SL+ftl3fksmhsTEsYwl4P8WvhrSohwf6O07GRnHy31ZtgKj1LhbhiUvK/PObBGTcQW5WeOUG6isIJRwmSqCeXdag49pVMD8ZG3o2ui/uoF+geN/AHSdDzgNTYEVRHzouL1PXklBebJavI/RB9bRbYVfauk/dCIB6mElCAELhbu/BO/Ae8/VqqahIKImgf8GCBCBIOhiHMc5fBwWrf0uP/qG+f5pSK0SaMe8RJVEOT/3A5HlZ1y
 JT43TlAb
 aZjIHGtsoetb/AWEv1sexrLd4EqtLdeuUOAv2pSk3sSVBIsNhH2y6R11YmoVbBmLfgKzMCs8v4Z5nBkxpjxFRKsPTxWnM8uu9iQz5fBfGh2vGf89Kl6SU6SrKPNAPt56xhqnGbTRsvrqPLZ3m9oQcQRMEIMc1iZoxN+V8z7muNkhBHioOEVA5rMORuo15RIZ4bRY9x5XYHshDQjsujBMETuMyVnCdqsbpaYCEbSiHATwB/toZR6jODvu1QEvTUdj6KxOE5j1NYnSGu/Cih1B8OmS2tQMW3iFERtPr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

Arm has stopped setting ARCH_NEEDS_KMAP_HIGH_GET, so this
is handled using the same wrappers across all architectures
now, which leaves room for simplification.

Replace lock_kmap()/unlock_kmap() with open-coded spinlocks
and drop the now empty arch_kmap_local_high_get() and
kmap_high_unmap_local() helpers.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/highmem.c | 100 ++++++---------------------------------------------
 1 file changed, 10 insertions(+), 90 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index a33e41183951..214164f9172b 100644
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
@@ -238,9 +219,9 @@ static void flush_all_zero_pkmaps(void)
 
 void __kmap_flush_unused(void)
 {
-	lock_kmap();
+	spin_lock(&kmap_lock);
 	flush_all_zero_pkmaps();
-	unlock_kmap();
+	spin_unlock(&kmap_lock);
 }
 
 static inline unsigned long map_new_virtual(struct page *page)
@@ -274,10 +255,10 @@ static inline unsigned long map_new_virtual(struct page *page)
 
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
@@ -313,60 +294,32 @@ void *kmap_high(struct page *page)
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
@@ -393,7 +346,7 @@ void kunmap_high(const struct page *page)
 		pkmap_map_wait = get_pkmap_wait_queue_head(color);
 		need_wakeup = waitqueue_active(pkmap_map_wait);
 	}
-	unlock_kmap_any(flags);
+	spin_unlock(&kmap_lock);
 
 	/* do wake-up, if needed, race-free outside of the spin lock */
 	if (need_wakeup)
@@ -508,30 +461,11 @@ static inline void kmap_local_idx_pop(void)
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
@@ -575,8 +509,6 @@ EXPORT_SYMBOL_GPL(__kmap_local_pfn_prot);
 
 void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
 {
-	void *kmap;
-
 	/*
 	 * To broaden the usage of the actual kmap_local() machinery always map
 	 * pages when debugging is enabled and the architecture has no problems
@@ -585,11 +517,6 @@ void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
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
@@ -607,14 +534,7 @@ void kunmap_local_indexed(const void *vaddr)
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
2.53.0


