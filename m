Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC67FC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 09:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742E06B00A8; Tue, 22 Jul 2025 05:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3896B00A9; Tue, 22 Jul 2025 05:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2286B00AA; Tue, 22 Jul 2025 05:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 472EE6B00A8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:42:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E73F11601B6
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:42:55 +0000 (UTC)
X-FDA: 83691411510.07.4CC1A97
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FE5320014
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:42:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=2Cp3Cg6e;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753177374; a=rsa-sha256;
	cv=none;
	b=mkq8ghIEyrYOHAMRiRozCXHvelkCJFZLueG5nxAKLucNK6VySVPfTkvsI2/CAalxRNz2aI
	htnzyJUOUPYhB+Kg6/JIrX2sgKDZW5l3wLzs6J+aMQ4MDNP8y3XDbqjUsrAVyHjMe4z9bl
	R6OcGLoxxXJ0L7r06W3HGL6CZaq8h6A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=2Cp3Cg6e;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753177374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGsooM1ApyIs81SWSpZ620H0z3hTQFaebPIcfnU58Eg=;
	b=sRU9bBaSi+I2O1dRQCYzX+YKqi4jlYdQA1ezhEAyxghWn7lj6xX0vOvXbzFHJL1qoySolD
	ibBHFm57DUaE0VZPCM7x3IBD1NDGdL+U3uTO1rUmjvzhgRogICs+8E14lty78GBQZgaiqG
	YQLKluHzi5woyr5fHJ5RYsNxliLM1KA=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bmXPQ4RMpz9t8x;
	Tue, 22 Jul 2025 11:42:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753177370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NGsooM1ApyIs81SWSpZ620H0z3hTQFaebPIcfnU58Eg=;
	b=2Cp3Cg6eyslS2Hx05RQHV0KDG6jw2NCBt5lsymHhDDjSR2IXuUQA35n1ypOjb/p+xxKPrs
	Lf9h2NNMyxlprJbzzPcb+He9Ksb1GWalvJt1tzLBBSSS8NueHWyQ57a7C0+XQWn161xdp/
	95Rm9YMENqlR4Hv96BolnDqK2U/u5kSpMkYtJ9E+hfZ3mVSIUSmpziZ/TPnuTyghcFSRAG
	93FoO3kzsgk4xj6Vtr53oemKKcc1NBXUKl780lwjkc+a7Bv3gWrdYZxe9I5qV4bIhBAE+y
	HsbjyYUXlEX3hAQSJ9cgHQEkNgIUMfbG4UP5RMkZGyaytJNOz9QkOvzGZ0apsQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC 2/4] mm: add static huge zero folio
Date: Tue, 22 Jul 2025 11:42:13 +0200
Message-ID: <20250722094215.448132-3-kernel@pankajraghav.com>
In-Reply-To: <20250722094215.448132-1-kernel@pankajraghav.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2FE5320014
X-Stat-Signature: 1ka84j3ww3g7sccmimw8ohn6943qroqj
X-HE-Tag: 1753177373-384067
X-HE-Meta: U2FsdGVkX1/F8BCpIFx6QmC14iMiLpGbILMS3v8JuMDz2ynKOUXnTqsGbDJILopQGGQ3i6DDxWqNux3XrFZLcD4XOmsl0Tw+c/VxKRUBaW8KqrPF9mtxyGCFNzQKbNIya8BKYSxcg326MNdFVEX9UXo5dk4l8WbaLssozz5rg8fycIasGbxiWB7e1WBfgKshr/tQnocYSE9s3+KiR8J2YKQqrNjy9WQ07tfyS9czaLlvG7ho99b52c4p3M3ezg5kn2a/kHBjj7iGM96gasqX1gPs49MViA8HgeRYXlKRXoZv6YVmeOM63u+OjlH5kgc4EPasEFlPsSbhgYDlsrhwae2RBHR+lEYrfMLF45+vorX2omkNYs/UUEhLW5zkqya6sTL4OX4lg9LveN2HK4xcKZjctBSepd243cpbiM1OpAgBuB7QC2ncjoUQJ1DGlDgVSHblqPAtOu6hKescz22ymQZIMT7vhcVnhOrehdnXPpl5zAAvEKzfBkX5FXJIJoiWZVH1wija2POqglqcovD9oqnt6SUWv2CgqMsfnXqysie76osEGMSbX4T1StGlTUXvhLjU42KdH67EQeriVoVw9oRV6ihI5GMl4THA/jGBJxwrJeVW4A1by2UW5soUFnush4qWUgeJuoygZ5p8gQn5feIzEU+1PqkQF/Njj3ig5iFmq0rIWlUtPQdl49b3e3bw5mLO8Bk48SxPRfGP949FXaFV+Cskb/WKG3TOblOLGUR/Zeo/5CW3PH4lgvU3j4aio1AX7i01q1PfulYov6RH8AiGMqjwOAEKB38FWV9OCPrUVXPaGX4oFhlPn0QwIPWkVwonocdK5nMwtuNPm/eHIi5GQRlaFDWBW6CdY88xn555Ztuwk3DeaI4Mlv2cir0DPkPdny6zj0jZYh31cFx1uWfJBrkjEP3fPRb3QzycNuwNxIeAG/5i7XDkGQzHS//T6voURGMDIl4CWiPQjYe
 GrpnbegB
 2yTxQ/+K9PlFXXatSmcgI9FViSF25eVkiex5WOHDWo3ITxmFE9qQXqUOZv3sjyJrrV3WcMv9YdMJDuf7fAxic8V8I4ywT83qO83nJ9qA7NiZKJfm0Y2q9CudcUtiR6f9xyP4Ed/M9LlIJaYx6jqAnP9TikyuEYaQuy9u6FvtsaGuHeJJ2cOBjMXAACBWrN9Vdy4tmK9vKeiaHSQwReu7fYuofXuK8QCJOBuDtR2oMBZJrN4kdG4H10pTnVy3735KwNMrJDDFdQQ12ctXSOmmGdzjqdyNaGiJKBD5mdTRGj30Wj6EfG15H+A/600kaMxMap7SQLeYbC9rU02cf6KZ2UD3wD3EuzP+shg4KB3Y7wqQBpUH042BhQuZjAE1nEkpKb826TQj0VGsbtdN4RQopzeVtsXNAGRZy0BYybpEstjxopnkgFzCMO88Cn9YKuCpJmGJO9L+zJn5s+sw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

There are many places in the kernel where we need to zeroout larger
chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
is limited by PAGE_SIZE.

This is especially annoying in block devices and filesystems where we
attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
bvec support in block layer, it is much more efficient to send out
larger zero pages as a part of single bvec.

This concern was raised during the review of adding LBS support to
XFS[1][2].

Usually huge_zero_folio is allocated on demand, and it will be
deallocated by the shrinker if there are no users of it left. At moment,
huge_zero_folio infrastructure refcount is tied to the process lifetime
that created it. This might not work for bio layer as the completions
can be async and the process that created the huge_zero_folio might no
longer be alive. And, one of the main point that came during discussion
is to have something bigger than zero page as a drop-in replacement.

Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
the huge_zero_folio, and it will never drop the reference. This makes
using the huge_zero_folio without having to pass any mm struct and does
not tie the lifetime of the zero folio to anything, making it a drop-in
replacement for ZERO_PAGE.

If STATIC_PMD_ZERO_PAGE config option is enabled, then
mm_get_huge_zero_folio() will simply return this page instead of
dynamically allocating a new PMD page.

This option can waste memory in small systems or systems with 64k base
page size. So make it an opt-in and also add an option from individual
architecture so that we don't enable this feature for larger base page
size systems.

[1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
[2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/

Co-Developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 arch/x86/Kconfig        |  1 +
 include/linux/huge_mm.h | 16 ++++++++++++++++
 mm/Kconfig              | 12 ++++++++++++
 mm/huge_memory.c        | 28 ++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0ce86e14ab5e..8e2aa1887309 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -153,6 +153,7 @@ config X86
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
 	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
+	select ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	select BUILDTIME_TABLE_SORT
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..0ddd9c78f9f4 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -476,6 +476,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
 extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
+extern atomic_t huge_zero_folio_is_static;
 
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
@@ -494,6 +495,16 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
+struct folio *__get_static_huge_zero_folio(void);
+
+static inline struct folio *get_static_huge_zero_folio(void)
+{
+       if (!IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
+               return NULL;
+       if (likely(atomic_read(&huge_zero_folio_is_static)))
+               return huge_zero_folio;
+       return __get_static_huge_zero_folio();
+}
 
 static inline bool thp_migration_supported(void)
 {
@@ -685,6 +696,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
 {
 	return 0;
 }
+
+static inline struct folio *get_static_huge_zero_folio(void)
+{
+       return NULL;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
diff --git a/mm/Kconfig b/mm/Kconfig
index 0287e8d94aea..14721171846f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -835,6 +835,18 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
+config ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
+	def_bool n
+
+config STATIC_HUGE_ZERO_FOLIO
+	bool "Allocate a PMD sized folio for zeroing"
+	depends on ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
+	help
+	  Typically huge_zero_folio, which is a PMD page of zeroes, is allocated
+	  on demand and deallocated when not in use. This option will
+	  allocate huge_zero_folio but it will never free it.
+	  Not suitable for memory constrained systems.
+
 config MM_ID
 	def_bool n
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5d8365d1d3e9..6c890a1482f3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -75,6 +75,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
+static atomic_t huge_zero_static_fail_count __read_mostly;
+atomic_t huge_zero_folio_is_static __read_mostly;
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
@@ -266,6 +268,32 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
 		put_huge_zero_page();
 }
 
+#ifdef CONFIG_STATIC_HUGE_ZERO_FOLIO
+struct folio *__get_static_huge_zero_folio(void)
+{
+       /*
+        * If we failed to allocate a huge zero folio multiple times,
+        * just refrain from trying.
+        */
+       if (atomic_read(&huge_zero_static_fail_count) > 2)
+               return NULL;
+
+       /*
+        * Our raised reference will prevent the shrinker from ever having
+        * success.
+        */
+       if (!get_huge_zero_page()) {
+              atomic_inc(&huge_zero_static_fail_count);
+               return NULL;
+       }
+
+       if (atomic_cmpxchg(&huge_zero_folio_is_static, 0, 1) != 0)
+               put_huge_zero_page();
+
+       return huge_zero_folio;
+}
+#endif /* CONFIG_STATIC_HUGE_ZERO_FOLIO */
+
 static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
 						  struct shrink_control *sc)
 {
-- 
2.49.0


