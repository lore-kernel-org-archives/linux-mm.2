Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062F5F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B476B00F1; Sun,  5 Apr 2026 08:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4A66B00F3; Sun,  5 Apr 2026 08:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CAC6B00F4; Sun,  5 Apr 2026 08:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20AD76B00F1
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:59:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDA808CB85
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:59:00 +0000 (UTC)
X-FDA: 84624507240.02.748EA83
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD88A140005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a5V1y4Fe;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OTMoz77Yb7VHAB553cXlMYhsYoA1Jus+1lDf2tDpdk=;
	b=s46qfwv3nDxbP2pt0smy4XWJDhgoL56B/xqlOH0Q8pgToeIwTnvYDFIKKaW+OGKJGi2y+H
	MnkXA2RjNDgY3dxV5VTqGw7xDkyh5PvEtQodcadFkcMPLU98p+PS4Rulcof40FliHw6oJ1
	imbX/fyi5Hi4ViL85te7/oRWEzEmJaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393939; a=rsa-sha256;
	cv=none;
	b=Ff9ClztMqL1evdGyoEFVRaVYBVN0vGHOhHBXZlHRqZd61UluVoyDnOxE2faNk2kjp/JQGJ
	lDY65mKBwFJkuKWwdPj4SEJz/GQ61ePpgFk+MviI0NPpq0tEwgLV+QVKMQdmQwGJKm07UN
	vpeYTeHz6nVmQaqde9jxsFps6rnlR1o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a5V1y4Fe;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35dac556bb2so2064938a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393938; x=1775998738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OTMoz77Yb7VHAB553cXlMYhsYoA1Jus+1lDf2tDpdk=;
        b=a5V1y4FedZK014z7BrsQ7zbBBHQ/keIzGGUszZ+JM314twUsSlPS7txdWNiRkRJFHO
         PidK85vKeBs+nuN6nKUB2Y9vuvHRmj60aH6u1RVM3CKEu/4/LKIaYKWAG8BTxnWlPxRd
         rC6Eo7eBUblGwwHpF/Qcn9S3WPONxsye6fYTYRc1txGEOtbwlWsXqse58F47lVpXqk9n
         mhRlDgoI0hXI8fNoUgB2K3Cz7EQNTE8JX9Nljb7DglTogD5H9l2pVEW7Fb2zayr9bMzy
         AIbBb8AG48IPmEQsgrK35jUYI5S5cpzpwjmJxhWc5j0nvpoRwxblSZw+YHr3tn8tXfAX
         3m+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393938; x=1775998738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5OTMoz77Yb7VHAB553cXlMYhsYoA1Jus+1lDf2tDpdk=;
        b=Jy1UfS5c9xu3CMXRWbCEGpRnz9BFkakj7usgbDm0GuryyoQwADjzStjEcLzwUFgV8E
         HwTEtLpoBkuCx7DLJnLS4zmbXBAqZRuWg08eGtoP6j3QFHmkxZAt40p+27u3umaNW7wk
         /mD74G7wKI31eumEwiXaZe7c8pNVu0KiDPVHYC5nZT1fMMmGjebM4Sqd5LgI5l+T6DyG
         rBUtZB5M0FxeNvVlf+nZxRWZlVlnUlw4Yst0xcQ5+o1B42n4YMeS/HV0oPJhVMSKchGc
         Bc33FnAgIQIzP6JNZrZeKYDPU+i+vNDKkie9wrKp6NuhlckGHyjEBVncCPvY8FKh8oTi
         evYw==
X-Forwarded-Encrypted: i=1; AJvYcCUAJAP0MQuXpHkl24H+1SWGTRdV1wdWHx79JTdTqoyXGKA/KhdukmF1DGegCp31GdeKivFLHtTcIA==@kvack.org
X-Gm-Message-State: AOJu0YyqOkmWGPQUPmAmpr/enulKH0Z7Z3Q9DvyYxBNWXbscztQj9JCy
	UhwoA20XixEBtBWoXiHE1GB6KYr7ONLiRjbcE3g0AyUH/eBL/uwMQTWm3a7Ob5+rduM=
X-Gm-Gg: AeBDietBqlFlXJcfot8BIRGzYjbR5BANS5kWIq9KogeL3iTMLw/S99aNSthm68qdD1z
	TdYShvymC1Pqrt1uVOca19fRx1JQsK6PpjoCE2teemZ+5NxyzGenetI8BhcE0ItkhhMpjWLCx2S
	iqCSZKE1NNogGGdbgesN+Nj6U+n9sXdKm2x/Orv+lGm5l87BONRb7/1NJHTa1HcsGgGSVlzc63j
	8Qhy4LOlS/aK605cg5vsBPYYHAPuvc4sXC6kDirLGEXk1VNG+Kz1fkxuK4dpS72aXTwpXgf4lN0
	Q1Rno8yQetXZ/+MApo0nS5eoZMukHgNAJUVL1zS8MhUiNuYa2iNNx0zwXMPvwqHhZ48bdpGSFEE
	HXWU4lXS3r9UuCmVMKj7rgS5mcaCaidhJVLIlthWlH6Vmvusxi7Zld3r6p4MM43DXb1YknG8dDy
	fIOvFly0C3Wpr33S+S6D1bcrHzpik6gsm5MwzQCpIyWrA=
X-Received: by 2002:a17:90b:2b4e:b0:356:35a5:4a64 with SMTP id 98e67ed59e1d1-35de6842dc2mr8500150a91.4.1775393937697;
        Sun, 05 Apr 2026 05:58:57 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:57 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 49/49] mm: consolidate struct page power-of-2 size checks for HVO
Date: Sun,  5 Apr 2026 20:52:40 +0800
Message-Id: <20260405125240.2558577-50-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DD88A140005
X-Stat-Signature: cjsgqkq5w6aid36uzm9fsco4pwkap8xi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775393938-281176
X-HE-Meta: U2FsdGVkX1+W5aaBASuRuAXCN+ULTo3gS9kCajrV5puobLR7OfoCxnJjqu5b3KRVHR3zs/6qkjpnQK3P4FYWYYy3X2sY34fFf8FFV+zTgI7ZNE5YM0H+pnJhyT4TUsQ5/KFO5mgofO/XRCOTJyaBClw5ODIQnHh9kG/3n4h5y8c5ywVigjl53AEtD5smnTsfGro1MKB6XszOV+XAm+euaKbSY963aKf4GzuFGIf69uryrsXXfEJ/plrGKhI/RiSUD0TtGJG5S6JlHkSSXTIK421jQjoOE2rrAKJHeoH31rorlus0mhvXWzf7EB64cBG0lmOMW8cKD8TLqZYKP5vWScYGdG4BqIsipwbNePflwpes2kexMJ4CM2NbRHBGtnu75d1D2zaIWmuxa5MEo1HOEl9kbJPVbPNimJwA741rJgu3JLfdRtaGpvzkhoqp4kdBXOVVlOuHQJP9EYetgoSus5/t+TB9VYWZ3LsaHLEZqwl+JoOfnZgdXeYiPK4DroSWkb6GlhAvCNa5G7e3/w5xOjsNLWT7syljDAkpuxHOR26+98qMgj2noMxnDYUtKtfOeBSnf0dFlPtzHklDA8gcUWLIJnGnoxVHysrrbGq9MrmiUFzNusjCTX8YdWWGpadCTg+0ulCWIeEkK1GjC50GzaY0k79Q7v8ohB3Q+83h/z+Bluapz022lvbNEdouw8wcOk2jPmi0ghddedZSJa4Dna2+JQqjNt/NWz3VUmZRolEuRl5qQcOoT5xQ5eYg95QVMSxN+sSF7UT88qTz7ox8iAkGK5jnk3mQ2D7QdhcnCUvBBc8V0f9MMjM0iBHs1hdvnO9CjxvwRRHbyVZX1NqV3Fyqlu6rnJBCHzlBembssTxds1jlFthwBPESgQ2lD2z4DEFfgI3CbjxJdNiM3PcEucy67fZWby1EkYZb1NMc3kNqTvN1cpzJSO/AHzrcFQknxxIBd8VJ4a9nu1/I5cL
 8xGYPAD4
 3g+Wrzaoi31xjkJ3Q9OCAqULHxbjhlHjbaDOVzVBUpLGHssDveoeGxlNHeM0qUyMcL9mTj0Q/0mJGtDHpy8QL6jNe7SZ9zX/yDvQyogBMchKmOOgyP3LCZ2R/WR9cs3pXRgpl9FYdorVfg/X3qNHsA7E50KdFzP8hBeUBGHD4cOGDK8GS7QgfGpHUHcyFe0oYw9XjTwkyszWi13rYIHqsq1XeKCrFkMfavIclPfZE9hFWgM6wQ+6mDiPK+8TPLze/rWwWNzhYlgg9Gv8zktiD5Qirjtzrqq352XBBvVqPm0HcJHNG8e+QSX7FKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Hugepage Vmemmap Optimization (HVO) requires that struct page
size is a power of two. This size is evaluated by the C compiler
and currently cannot be natively evaluated by Kconfig. Therefore,
the condition is_power_of_2(sizeof(struct page)) was scattered
across several macros and static inline functions.

Extract the check into a preprocessor macro
STRUCT_PAGE_SIZE_IS_POWER_OF_2 evaluated during the Kbuild process.

Define SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED as a master toggle
that is 1 only if both Kconfig CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
and the power of 2 size check are true.

This allows us to completely remove all scattered sizeof(struct page)
checks, making the code much cleaner and eliminating redundant logic.

Additionally, mm/hugetlb_vmemmap.c and its corresponding header are now
guarded by SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED. This brings an added
benefit: when struct page size is not a power of 2, the compiler can
entirely optimize away the unused functions in mm/hugetlb_vmemmap.c,
reducing kernel image size.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm_types.h      |  2 ++
 include/linux/mm_types_task.h |  4 ++++
 include/linux/mmzone.h        | 32 +++++++++++++++-----------------
 include/linux/page-flags.h    | 28 ++++------------------------
 kernel/bounds.c               |  2 ++
 mm/hugetlb_vmemmap.c          |  2 ++
 mm/hugetlb_vmemmap.h          |  4 +---
 mm/internal.h                 |  3 ---
 mm/sparse.c                   |  6 ++----
 mm/util.c                     |  2 +-
 10 files changed, 33 insertions(+), 52 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..6de6c0c20f8b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -15,7 +15,9 @@
 #include <linux/cpumask.h>
 #include <linux/uprobes.h>
 #include <linux/rcupdate.h>
+#ifndef __GENERATING_BOUNDS_H
 #include <linux/page-flags-layout.h>
+#endif
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
 #include <linux/percpu_counter.h>
diff --git a/include/linux/mm_types_task.h b/include/linux/mm_types_task.h
index 11bf319d78ec..09e5039fff97 100644
--- a/include/linux/mm_types_task.h
+++ b/include/linux/mm_types_task.h
@@ -17,7 +17,11 @@
 #include <asm/tlbbatch.h>
 #endif
 
+#ifndef __GENERATING_BOUNDS_H
 #define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
+#else
+#define ALLOC_SPLIT_PTLOCKS	0
+#endif
 
 /*
  * When updating this, please also update struct resident_page_types[] in
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a6900f585f9b..3a46cb0bfaaa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -96,27 +96,26 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
-/*
- * Hugepage Vmemmap Optimization (HVO) requires struct pages of the head page to
- * be naturally aligned with regard to the folio size.
- *
- * HVO which is only active if the size of struct page is a power of 2.
- */
-#define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
-	 is_power_of_2(sizeof(struct page)) ?			\
-	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
-
 /* The number of vmemmap pages required by a vmemmap-optimized folio. */
 #define OPTIMIZED_FOLIO_VMEMMAP_PAGES		1
 #define OPTIMIZED_FOLIO_VMEMMAP_SIZE		(OPTIMIZED_FOLIO_VMEMMAP_PAGES * PAGE_SIZE)
 #define OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS	(OPTIMIZED_FOLIO_VMEMMAP_SIZE / sizeof(struct page))
 #define OPTIMIZABLE_FOLIO_MIN_ORDER		(ilog2(OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS) + 1)
 
+#if defined(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) && STRUCT_PAGE_SIZE_IS_POWER_OF_2
+#define SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED	1
+/*
+ * Hugepage Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN			(MAX_FOLIO_NR_PAGES * sizeof(struct page))
 #define __NR_OPTIMIZABLE_FOLIO_SIZES		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
 #define NR_OPTIMIZABLE_FOLIO_SIZES		\
-	((__NR_OPTIMIZABLE_FOLIO_SIZES > 0 &&	\
-	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __NR_OPTIMIZABLE_FOLIO_SIZES : 0)
+	(__NR_OPTIMIZABLE_FOLIO_SIZES > 0 ? __NR_OPTIMIZABLE_FOLIO_SIZES : 0)
+#else
+#define MAX_FOLIO_VMEMMAP_ALIGN			0
+#define NR_OPTIMIZABLE_FOLIO_SIZES		0
+#endif
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -2015,7 +2014,7 @@ struct mem_section {
 	 */
 	struct page_ext *page_ext;
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED
 	/*
 	 * The order of compound pages in this section. Typically, the section
 	 * holds compound pages of this order; a larger compound page will span
@@ -2208,7 +2207,7 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED
 static inline void section_set_order(struct mem_section *section, unsigned int order)
 {
 	VM_BUG_ON(section->order && order && section->order != order);
@@ -2267,8 +2266,7 @@ static inline void section_set_compound_range(unsigned long pfn,
 
 static inline bool section_vmemmap_optimizable(const struct mem_section *section)
 {
-	return is_power_of_2(sizeof(struct page)) &&
-	       section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;
+	return section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;
 }
 
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 12665b34586c..bea934d49750 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,32 +198,12 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
-/*
- * For tail pages, if the size of struct page is power-of-2 ->compound_info
- * encodes the mask that converts the address of the tail page address to
- * the head page address.
- *
- * Otherwise, ->compound_info has direct pointer to head pages.
- */
-static __always_inline bool compound_info_has_mask(void)
-{
-	/*
-	 * The approach with mask would work in the wider set of conditions,
-	 * but it requires validating that struct pages are naturally aligned
-	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
-	 */
-	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	return is_power_of_2(sizeof(struct page));
-}
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
 	unsigned long mask;
 
-	if (!compound_info_has_mask()) {
+	if (!IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED)) {
 		/* Bit 0 encodes PageTail() */
 		if (info & 1)
 			return info - 1;
@@ -232,8 +212,8 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 	}
 
 	/*
-	 * If compound_info_has_mask() is true the rest of the info encodes
-	 * the mask that converts the address of the tail page to the head page.
+	 * If HVO is enabled the rest of the info encodes the mask that converts
+	 * the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
 	 *
@@ -257,7 +237,7 @@ static __always_inline void set_compound_head(struct page *tail,
 	unsigned int shift;
 	unsigned long mask;
 
-	if (!compound_info_has_mask()) {
+	if (!IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED)) {
 		WRITE_ONCE(tail->compound_info, (unsigned long)head | 1);
 		return;
 	}
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 02b619eb6106..ff2ec3834d32 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -8,6 +8,7 @@
 #define __GENERATING_BOUNDS_H
 #define COMPILE_OFFSETS
 /* Include headers that define the enum constants of interest */
+#include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
@@ -30,6 +31,7 @@ int main(void)
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
 #endif
+	DEFINE(STRUCT_PAGE_SIZE_IS_POWER_OF_2, is_power_of_2(sizeof(struct page)));
 	/* End of constants */
 
 	return 0;
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d595ef759bc2..0347341be156 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -21,6 +21,7 @@
 #include "hugetlb_vmemmap.h"
 #include "internal.h"
 
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
  *
@@ -693,3 +694,4 @@ static int __init hugetlb_vmemmap_init(void)
 	return 0;
 }
 late_initcall(hugetlb_vmemmap_init);
+#endif
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 0022f9c5a101..bd576ef41ee7 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -12,7 +12,7 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#if defined(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && defined(SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED)
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -34,8 +34,6 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 {
 	int size = hugetlb_vmemmap_size(h) - OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 
-	if (!is_power_of_2(sizeof(struct page)))
-		return 0;
 	return size > 0 ? size : 0;
 }
 #else
diff --git a/mm/internal.h b/mm/internal.h
index 02064f21bfe1..121c9076f09a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1026,9 +1026,6 @@ static inline bool vmemmap_page_optimizable(const struct page *page)
 	unsigned long pfn = page_to_pfn(page);
 	unsigned int order = section_order(__pfn_to_section(pfn));
 
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
 	return (pfn & ((1L << order) - 1)) >= OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS;
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 77bb0113bac5..7375f66a58d5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -404,10 +404,8 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	if (compound_info_has_mask()) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
-				    MAX_FOLIO_VMEMMAP_ALIGN));
-	}
+	VM_WARN_ON_ONCE(IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED) &&
+			!IS_ALIGNED((unsigned long)pfn_to_page(0), MAX_FOLIO_VMEMMAP_ALIGN));
 
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
diff --git a/mm/util.c b/mm/util.c
index f063fd4de1e8..783b2081ea74 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1348,7 +1348,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 		foliop = (struct folio *)page;
 	} else {
 		/* See compound_head() */
-		if (compound_info_has_mask()) {
+		if (IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLED)) {
 			unsigned long p = (unsigned long)page;
 
 			foliop = (struct folio *)(p & info);
-- 
2.20.1


