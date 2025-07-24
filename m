Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFE0C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E956E8E0044; Thu, 24 Jul 2025 01:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46218E0002; Thu, 24 Jul 2025 01:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D357B8E0044; Thu, 24 Jul 2025 01:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF0B58E0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:23:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 509BE111B0E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:17 +0000 (UTC)
X-FDA: 83698014834.30.7CF2951
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id A236540003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753334595; a=rsa-sha256;
	cv=none;
	b=qLSCi+vmITCQaX6E2QgS0OpFwauyxcg7PCOXBSdi8srh3GnmolHG3VPgIjNdEMH/UT9ERh
	U7cc3S5szCpeeVi54XAAdCt8oNCOrJtGkRkMzTq9kzQ2hb28PWKhB/3I6H0xC3QqEnklF/
	xk+Co4H6d2hM5Xqt1Lp/AQDHoSa5z9g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753334595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BvKc0MPFZ96VL7Xz/7u0VA/SqRKAP7a/ChBeUD/s/KI=;
	b=1P8QWKmm30tS2s1c4mtFfDymqOLBBpURuLge/pcmCRfVl5hJLXhG1OFXFAH28Nnb7HZ7oU
	KURT5SeLJTPjUGdY+3L/zi9AqSli7vaQSJgwRlIwvtwdTrkDw3cvF1kkosi1CvJc5+Zxal
	sSQWPs/XPUyHHO+oLCBg4fDoQHs8Af4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BDCD1CC4;
	Wed, 23 Jul 2025 22:23:08 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 156693F66E;
	Wed, 23 Jul 2025 22:23:10 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v4 1/3] mm: add get_and_clear_ptes() and clear_ptes()
Date: Thu, 24 Jul 2025 10:52:59 +0530
Message-Id: <20250724052301.23844-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250724052301.23844-1-dev.jain@arm.com>
References: <20250724052301.23844-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A236540003
X-Stat-Signature: xednb9ezesogqiaobjcrk4nfj6rb1uog
X-HE-Tag: 1753334595-856421
X-HE-Meta: U2FsdGVkX19mHzk62z1nXf15B97wduXN7/n7hqx7mEdz60LnDT0ShLS8JLx3jVuTye5LB2vHFGOVv3jdRcEkEWPNoxrjn04AyYlhWglZIlobJJrFZhXvhsnDey6n79Z+r/zs9G1XmSDmSM1qR84gq0T/dNx2GKWJkpPNFADxT8ae0hqYlL9fAZa6IXphqpf0DnFMdNkbOEx//J3HkdRBtKYcoOiwZDMR/qpWkUy/WB2AgBzVkaMtJ3PM6s2bhLueOqC5ng2bwdaQU7Yp2BU1xPASBP2SMmZWIWbCPBmqNwCuWzdcJJfaiMQGYGkEVAyIZrX6Z3ap1HluE+Y3CPFFE18fIyx49VXXLHzOw6IMrNKwwP4xE7AbzTrjYKhCVkBSLR9X+G30ICq8m+roPXoFu5gQ5FPXmrk/ocR/jB/muSMYiOloMmccxsfgdZPJycN4aXGsAIFFpK2WOTz6wsXGeKNb/COOmXXNOaZk2jw1urlKcGFPVwRW+gWl+VAoPwpsveZ1VKuy1UZUNpyRWsaeM5KAmqO/55SRQe8yx2nQyOkw7dBbZW6er7OpeGa/xlHKcLD1jsIR4dCx63xJ4LZa8gDeVEfiqS73gOQdVWtI0NCXA9VZxwAlEOpDP9mToCTDwkmmfJSJu/2+9EGUn1LH3oAxmz52f1khQaHkvv8SkVEyYonvDmJNqL+X4ETwxmTP4JC/tduxtmj7bpMNmMwbaoE0S+f8J2tuIRtTjNXAr+494kyyBvw1fKDLJLTf1bXUvDxbficXotUDlavijvPK054NIFIGN77IdIRKrVJwtfiuAGi4AptUXnAKJgjfQdUNL66vdfrBe3UqV3YDFnfQ7hmSoP5UQ9Rvy2bghAfyrIVh07/OY7TF7hf/TuzvsQNZuFl8eAtkJLxp0hjcnBlezX2Kfje9EhP1gZ4rwfp9avTt683b2kRGAC76DLZvu66E+2d6rB5uCogMUi3emWk
 K3MEHnjJ
 AzdJJXtgO0fkGPcZAqmi4eIwU+vrfsIiRPtzpcBUrqxWXHIsKwNi/LIJQ06GwXDutgCCotUvI0trTtGAq2DUJYIcCaW7SpGimOfLfQIpSGsuyoppU4AaZFY7f5Du+ZNfjmexq3pz3JIDXtW3rgMCr0zGaHtqKTaAV4sacNJAGhxCiF5vLQCmJXGCLId7Dpadxtw88ymFqrgLXEPS0HfrzGkafjerrZMKq1R72hoZxO5z6wI75EMwGC19+RbSVSAU8iWofadx3ZZsTMWsS7Qym5nCCQ691NVlzoKwi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's add variants to be used where "full" does not apply -- which will
be the majority of cases in the future. "full" really only applies if
we are about to tear down a full MM.

Use get_and_clear_ptes() in existing code, clear_ptes() users will
be added next.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/mm/mmu.c     |  2 +-
 include/linux/pgtable.h | 45 +++++++++++++++++++++++++++++++++++++++++
 mm/mremap.c             |  2 +-
 mm/rmap.c               |  2 +-
 4 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index abd9725796e9..20a89ab97dc5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1528,7 +1528,7 @@ early_initcall(prevent_bootmem_remove_init);
 pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t *ptep, unsigned int nr)
 {
-	pte_t pte = get_and_clear_full_ptes(vma->vm_mm, addr, ptep, nr, /* full = */ 0);
+	pte_t pte = get_and_clear_ptes(vma->vm_mm, addr, ptep, nr);
 
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
 		/*
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3b99920be05..4c035637eeb7 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -736,6 +736,29 @@ static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
 }
 #endif
 
+/**
+ * get_and_clear_ptes - Clear present PTEs that map consecutive pages of
+ *			the same folio, collecting dirty/accessed bits.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear.
+ *
+ * Use this instead of get_and_clear_full_ptes() if it is known that we don't
+ * need to clear the full mm, which is mostly the case.
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline pte_t get_and_clear_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, unsigned int nr)
+{
+	return get_and_clear_full_ptes(mm, addr, ptep, nr, 0);
+}
+
 #ifndef clear_full_ptes
 /**
  * clear_full_ptes - Clear present PTEs that map consecutive pages of the same
@@ -768,6 +791,28 @@ static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 
+/**
+ * clear_ptes - Clear present PTEs that map consecutive pages of the same folio.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear.
+ *
+ * Use this instead of clear_full_ptes() if it is known that we don't need to
+ * clear the full mm, which is mostly the case.
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline void clear_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, unsigned int nr)
+{
+	clear_full_ptes(mm, addr, ptep, nr, 0);
+}
+
 /*
  * If two threads concurrently fault at the same page, the thread that
  * won the race updates the PTE and its local TLB/Cache. The other thread
diff --git a/mm/mremap.c b/mm/mremap.c
index ac39845e9718..677a4d744df9 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -280,7 +280,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 							 old_pte, max_nr_ptes);
 			force_flush = true;
 		}
-		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr_ptes, 0);
+		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
diff --git a/mm/rmap.c b/mm/rmap.c
index f93ce27132ab..568198e9efc2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2036,7 +2036,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			flush_cache_range(vma, address, end_addr);
 
 			/* Nuke the page table entry. */
-			pteval = get_and_clear_full_ptes(mm, address, pvmw.pte, nr_pages, 0);
+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
 			/*
 			 * We clear the PTE but do not flush so potentially
 			 * a remote CPU could still be writing to the folio.
-- 
2.30.2


