Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51035606A88D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gwt/fNWO
Received: by kanga.kvack.org (Postfix)
	id E169F6B05C9; Thu, 12 Nov 2026 06:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEECE6B05CA; Thu, 12 Nov 2026 06:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C026B05CB; Thu, 12 Nov 2026 06:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD1DE6B05C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:25:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41C728052D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:25:55 +0000 (UTC)
X-FDA: 85426237470.28.BD0CEBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A36C1180006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:25:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gwt/fNWO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsiyTGE3E/PTM1EG/tisvzM/pe3H12wpmJnKZF8EROE=;
	b=eUH9K3o60m5GDsNCvGtpbmAOk74IDqkpeNhvMDQCBQGZYjGW40VKzN2OJkV5UJgrTG9KvE
	X/WKGRsc7hrHGauUMIgG4Wg+l85IqQcx/o3fGtloh2eaVpCQVTcwzKHml8FymwfM7c+wmp
	VotE74e/CtWWy+DFzgZpJfZMSwAxGoY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482753;
	b=R1btacOGOcxv8TDwptjqSwfB2jv9Ovsho8LvmWspN64qxI3MP3sOLWtGl5Og4DU0nkvRUQ
	sUiCp3V2mJxAmqPXf/52DBdn18o2wA6JYhn7nGNWxwnqH00IsKNfPkT9uwCqt8n+J7yP97
	/ETXxIL0HGFZ5zYatN3MznZyR4FxGXs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gwt/fNWO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E29F61248;
	Thu, 12 Nov 2026 11:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584E31F00A05;
	Thu, 12 Nov 2026 11:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482753;
	bh=bsiyTGE3E/PTM1EG/tisvzM/pe3H12wpmJnKZF8EROE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwt/fNWO4++DPBZwX3yvy9kSW4ZY0iIGZxE1ev1Ec/HjhSJzhR9dp8QRwivd0Ht3p
	 xcyNJ5+Ii5dDH71RIZ/WrlxY6mzgvXWVa02xFA262X3UF1UJDZdpbOOL5DarZthRox
	 DN+DOS9qOr+0ba/mcrRaxwYV+Ybkuc67H7niR6nt9NbeCn7vnFaMQobSRVuEtgl8ug
	 JVUWeJusKt1vvnf9ZAo8P+0iaKoRUjQpRGZXx1MCjtbwdxVohJ1PHAIXYqZs7D2blf
	 R4yqBBDbfrOZMrRPSlacC7QEwj7+AGVoP+3t/kOZWKkOqabrUHAaMtG7o17D4v6tqs
	 QGNisUPNnJRdw==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v2 2/6] mm: remove ARCH_NEEDS_KMAP_HIGH_GET
Date: Thu, 12 Nov 2026 12:25:24 +0100
Message-ID: <20261112112528.1116405-3-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112112528.1116405-1-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f7bu3akobsycf35mej4d3rdabze45sxn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A36C1180006
X-HE-Tag: 1794482753-817472
X-HE-Meta: U2FsdGVkX18t1DaTUXYDdr4e0dXnRTWlLHQ4x3O21eVz8glJUrK78THxxhFfCaHYeftZlunU8rB1d0jBmqCHc5c2YwoXr2Dc7uwa0G4kdR2gzDOExY3rItpMPQxpg30q0ZgRjUPWIkc6wC6O69Suf1d6K3I/zaO5Ycjgl1FlNSIytqgk7RnvI61zEHTlDSSb3LMQsqPYYa0rEJzamtpVDAjvQeHUdgncKCTP6dV0HR7HVv5we2uO1bek300FkDTDtrQ/RYxoQL2hBr2kTlnZQ3wZbVomn6Iw6+HiuUD+8dc8rqJV7x2W7uFtyfP8LLKQws13c3Kk9dqRQKkGwQgs0K9T0HHIIYOFbX7Eh/zNj2yioKa6lstY9HQRxzNoQ0D454w3+n5Fv/aZv68xf1/jvURAW+9h8gKUM0idzon91reuugoeJKKXu4jGNfqXaFxrHUYPAOrQtJIbn5LWUrRHfLMut/bfKlSVeua7Ve3xcwHIKSDtP82EaUf+ef6Q+XLOgsPG7AF1NjcPW+JQ/IU+0t4cyN9v/MWKSDXK70gUcV+EFwGnUwLfWC5ZAN+GapL41xJlS6iD6wvkq4SySoJ2WGQZiDlG/7uKMD33VGYOx7csywkDJxib2Kzi/LSKasfKU6zDAhksculk8fJk1cgWMnOrhEOmMBrrZwf+s4xf2XTP+FyQWfZYwZvJBDfZh4vC/2BOp6T2VFLq3dDOHB1HaF1untdhLX/8AD/QBNOomuzN4jwB3SfyLkkUL0KHksPIigRJWPMWCNJcCTUHjl2RlFRdbtHJI5vrpAHv3vm0MqmBbWf3wXlzs+SDh5/YG4kZgN6ozfo0jWy6D9ZckQKUEUPsKKJE3yHoXEjX2enzUIVmNrqoByDFGc3+7dqw99RpBlC2A4WBSJSZjpfqJOPFC9BeyQLe/iUbKe0Klr81yiU79qStm26Rga5sa0HXdaPAgzcrYRXCtqdKLvtkwSk
 xpgCKNtL
 BvBRP7SlhS3V/BitSVJj+aHqC4+Ad7FCd6QxuYqh7tl3+a7YpBseeEXkbdKfIChaBkRkx4SwG44X4HLLcUmU2eZtRtuK7VhD+6xRL7vYqAEdAkkmZomNzXsWxEfstAH5D7cIsZTPAYiDDwV1ITzrZiZjQDPjdaEkuYYfi1dtnApRchHKDSBapqTHSYJLMGJpr8HKNgA/KjQnbbFtSgU1fi+Ma3akILhVj4+t5e7Dri9+fz3HBaU5KkY6t9r1TaoN642Zz
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


