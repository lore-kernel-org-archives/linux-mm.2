Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D96606A335
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThKu98bL
Received: by kanga.kvack.org (Postfix)
	id 80EFD6B0270; Wed, 21 Oct 2026 19:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4ED6B0271; Wed, 21 Oct 2026 19:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4706B0272; Wed, 21 Oct 2026 19:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491E26B0270
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:35:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6CE5806D3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:02 +0000 (UTC)
X-FDA: 85348241244.30.051935F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3ECD92000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThKu98bL;
	spf=pass (imf13.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792625701;
	b=RbQfPMHbe4yjn99Dh9Acyv2WpnLYP7IVvlQ5YTBnbIMFXW+DYlygmceCP1oGheB2A7mRW1
	uPMCWTtCdly4pm/5i82q6lwl0GshDTebktYtlPAk020neSkLW+Pkc5eJPf0j8dXO1763gL
	QLazpTO5VXv8dw3fG+YSMygE5KQ8EqY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThKu98bL;
	spf=pass (imf13.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792625701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0OKI6y4OhutfG+XdOF4GNKLKTZK5pihXdnNjvnUK40=;
	b=ryxjY+dIZKDtdLLorr0kOchQx0qR5vmVP+VnRAFezgPjjojEsZygaLjKIs/+rCodKkUz87
	rTcLhxApDfvJ9F1dvRX+lkdG5KRGmG9SCESrYtkKZaKScIWLULsq2NdjBUT61DF+PIT6Oa
	JQ6AKbjQeOne/aYiNnmZ3YLXTnh7kDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5F1660052;
	Wed, 21 Oct 2026 23:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8201F000C1;
	Wed, 21 Oct 2026 23:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792625700;
	bh=G0OKI6y4OhutfG+XdOF4GNKLKTZK5pihXdnNjvnUK40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThKu98bL5Hm9KlQ+BnEeF+JKlx2Uc32JqxYiXn5wjG8ZjvRH9jmi/psE9vWvAzn6/
	 rgVR35xjDQjQJ952FtrRHOcxnR1yqHn/TUXUPb4dYAIBSUEvGxhN2u3pyRsGpRV0j9
	 tjFVrXK2w3oU+Wtocx851k41H4dXrtXP9ejMZrohWHqLuanjw7gAWls3gVjXc/1W39
	 fp0Bzwt4TLLyN6exLax28bZQ+4GTCC/yHu/ju6DSQhQUBM20rzYMmw8su8sYZawMUk
	 oVHgzgJIrMJatjIiHJ9FQ8FmIxT66w7yP79YH0OVIlZe+ltM2eN95Mo0qhBk+6VkZ1
	 pkLtrRLNzKfHg==
From: Imre Kaloz <kaloz@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: [PATCH v3 2/4] sparc64: flush only the aliased page, not its whole folio
Date: Thu, 22 Oct 2026 01:33:38 +0200
Message-ID: <65ae69ec96f854a010ef8407144958cc290a1bf2.1792609488.git.kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792609488.git.kaloz@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ECD92000B
X-Stat-Signature: epeo7shz4gj8yjba7gsg8aw83xid3yz1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792625701-619661
X-HE-Meta: U2FsdGVkX18A5zcEVHWeBwP3b9ayOSg6DNYOPiPCTwWevUBYDJXlHC7hqyik7KJcCFnZSyf3F1rC9/Po2xOgjCkTfTfQUGKwTHGS/xDbn20LHRqwcm/CTziXr4m7l3uvACDNfPMc81KhZBD5FKrdVIkgriJTuLgGgDdeYhTNg07tbO0ndFuU18rUXF9UuwD+wTTUU1cwqxDYBCRJplk+KdlfcMxdcpePSrFRILEr1PT8jUjfaLFuPZC5H/seuIez7FBqGrmYXKcVyCYNlIuRP9L61Z5YLEm+DxJ4Pgqr/9ZeakTCu/aWkTAVhP1laeTHOG8N7p5DlfjAE+DPPFk2rabW3ZyidQK2/A+2PeJUY2XmsS9nUS4dLByng/smNW/vo6Nw1sCXNrQwAWoJ8SVL6VqTAyGWI5K7l47q0Pv38X/8Usq4MKLur/dMTREYijHIIEP6Eu7k+5yPxHUHEpHSyXYlIrg41FN8PXUfrdFzy+vUKUpUDfumKSx4SfLSc4bBUNb6RFNgr/tdqUUXpEXxdQBYQq7Q0gjicrCVg9bAPeUS54Ee0H0BuuLcJxQ9YzUK5KvlE4rxXGXPvFHNH25o4xfmuJ8IczVzP6gluA8l81PYGtEnlY1psi9fkTAIygt/YJvdHF735PY7os87I1u710L+e4ViZ3Riag4Bu5p6sP15jFPvGeCXBiPFYL1j3YIpOKRTQXzELyIOHnAhZ8gzmZTkUMVYbhwSl5unN1JozWUb+FEfoR36KFYIQP2TQsTm89Wx6+lCYUB4VgJ3SX2lW9VVbniIUTxm7qm8nbunNjNCE31rFRwBpNHu7ByQNePzaF1t6OEuywzEClIwQvt4IuMeZZyt+hkV7NzgXY51VggeQ6G1WnGG4xTEnNTGkX0CrEOiE2lfNVvVfulksVIrlmXbP9TzH4FHRbXvJoD7OOesxqH2ziqsUlkiCg4JUxzP0Lvz6IJKRqG+ry6spJN
 hx5GFuDl
 pjPXN3sQdLnlZ/B4PHu+EeacwwEKMHmkDHxS6poqyLky5GoCGwu2qgx5Uz4iNNcRWBCET+eYv9DEfM9Bs1vRUB4p5xlJxcS1EIKIu5UHOYLN8nCAD1q7mfPPj0/sQNAohzMDEOZkPT/oD+SMcGGWqhvwuYeXqZF2BYG9j15tl8PJm8fzRy9KeVF24Ye5UHdfy+J+zITtcuFGQHn+n52cVebZT8Da1gqoeaLALeyQqN4ToWZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since the conversion to folios, move_pte() and tlb_batch_add() flushed
the D-cache of every page in the folio a PTE maps. Both are called once
per PTE, so a range backed by a large folio had each of its pages
flushed once per PTE of that folio. On SMP, each page flush on Spitfire
and Cheetah is a cross-call to all other online CPUs.

Flush only the page the PTE maps instead, as before the conversion.
Both callers see the PTEs of a range one at a time, so every page of
the range still gets its own flush. flush_dcache_folio_all() has no
other users and is turned back into flush_dcache_page_all().

On a Sun Fire V240, an mremap() that moves the 1024 PTEs of a large
folio to the other colour took 7.3 s, about a million redundant page
flushes.

Fixes: 1a10a44dfc1d ("sparc64: implement the new page table range API")
Cc: stable@vger.kernel.org
Tested-by: Stian Halseth <stian@itx.no> # Sun Fire V240, SPARC T4-1
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
 arch/sparc/include/asm/cacheflush_64.h |  3 +--
 arch/sparc/include/asm/pgtable_64.h    |  8 ++++++--
 arch/sparc/kernel/smp_64.c             | 24 +++++++++++++-----------
 arch/sparc/mm/init_64.c                | 22 ++++++++++++++++++++++
 arch/sparc/mm/tlb.c                    |  2 +-
 5 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index 06092572c045..02c969417e7b 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -38,11 +38,10 @@ void __flush_dcache_page(void *addr, int flush_icache);
 void flush_dcache_folio_impl(struct folio *folio);
 #ifdef CONFIG_SMP
 void smp_flush_dcache_folio_impl(struct folio *folio, int cpu);
-void flush_dcache_folio_all(struct mm_struct *mm, struct folio *folio);
 #else
 #define smp_flush_dcache_folio_impl(folio, cpu) flush_dcache_folio_impl(folio)
-#define flush_dcache_folio_all(mm, folio) flush_dcache_folio_impl(folio)
 #endif
+void flush_dcache_page_all(struct mm_struct *mm, struct page *page);
 
 void __flush_dcache_range(unsigned long start, unsigned long end);
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 0837ebbc5dce..1430489b9ac5 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -946,6 +946,10 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
 #ifdef DCACHE_ALIASING_POSSIBLE
+/* This flushes only the page the PTE maps, so it relies on move_ptes()
+ * calling it for one PTE at a time, which the default pte_batch_hint()
+ * guarantees.
+ */
 #define __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)				\
 ({									\
@@ -955,8 +959,8 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 									\
 		if (pfn_valid(this_pfn) &&				\
 		    (((old_addr) ^ (new_addr)) & (1 << 13)))		\
-			flush_dcache_folio_all(current->mm,		\
-				page_folio(pfn_to_page(this_pfn)));	\
+			flush_dcache_page_all(current->mm,		\
+					      pfn_to_page(this_pfn));	\
 	}								\
 	newpte;								\
 })
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 4240c129c5fe..6681f5263865 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -991,8 +991,9 @@ void smp_flush_dcache_folio_impl(struct folio *folio, int cpu)
 	put_cpu();
 }
 
-void flush_dcache_folio_all(struct mm_struct *mm, struct folio *folio)
+void flush_dcache_page_all(struct mm_struct *mm, struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	void *pg_addr;
 	u64 data0;
 
@@ -1005,7 +1006,7 @@ void flush_dcache_folio_all(struct mm_struct *mm, struct folio *folio)
 	atomic_inc(&dcpage_flushes);
 #endif
 	data0 = 0;
-	pg_addr = folio_address(folio);
+	pg_addr = page_address(page);
 	if (tlb_type == spitfire) {
 		data0 = ((u64)&xcall_flush_dcache_page_spitfire);
 		if (folio_flush_mapping(folio) != NULL)
@@ -1016,18 +1017,19 @@ void flush_dcache_folio_all(struct mm_struct *mm, struct folio *folio)
 #endif
 	}
 	if (data0) {
-		unsigned int i, nr = folio_nr_pages(folio);
-
-		for (i = 0; i < nr; i++) {
-			xcall_deliver(data0, __pa(pg_addr),
-				      (u64) pg_addr, cpu_online_mask);
+		xcall_deliver(data0, __pa(pg_addr),
+			      (u64)pg_addr, cpu_online_mask);
 #ifdef CONFIG_DEBUG_DCFLUSH
-			atomic_inc(&dcpage_flushes_xcall);
+		atomic_inc(&dcpage_flushes_xcall);
 #endif
-			pg_addr += PAGE_SIZE;
-		}
 	}
-	__local_flush_dcache_folio(folio);
+#ifdef DCACHE_ALIASING_POSSIBLE
+	__flush_dcache_page(pg_addr,
+			    tlb_type == spitfire && folio_flush_mapping(folio));
+#else
+	if (tlb_type == spitfire && folio_flush_mapping(folio))
+		__flush_icache_page(__pa(pg_addr));
+#endif
 
 	preempt_enable();
 }
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 103db4683b16..8d01aab43cc3 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -214,6 +214,28 @@ inline void flush_dcache_folio_impl(struct folio *folio)
 #endif
 }
 
+#ifndef CONFIG_SMP
+void flush_dcache_page_all(struct mm_struct *mm, struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	if (tlb_type == hypervisor)
+		return;
+
+#ifdef CONFIG_DEBUG_DCFLUSH
+	atomic_inc(&dcpage_flushes);
+#endif
+
+#ifdef DCACHE_ALIASING_POSSIBLE
+	__flush_dcache_page(page_address(page),
+			    tlb_type == spitfire && folio_flush_mapping(folio));
+#else
+	if (tlb_type == spitfire && folio_flush_mapping(folio))
+		__flush_icache_page(page_to_phys(page));
+#endif
+}
+#endif /* !CONFIG_SMP */
+
 #define PG_dcache_dirty		PG_arch_1
 #define PG_dcache_cpu_shift	32UL
 #define PG_dcache_cpu_mask	\
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 6d9dd5eb1328..1221814ca0e1 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -144,7 +144,7 @@ void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 
 		paddr = (unsigned long) page_address(page);
 		if ((paddr ^ vaddr) & (1 << 13))
-			flush_dcache_folio_all(mm, folio);
+			flush_dcache_page_all(mm, page);
 	}
 
 no_cache_flush:
-- 
2.47.3


