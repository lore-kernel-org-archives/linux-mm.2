Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3B5CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5696B00B0; Fri,  2 Oct 2026 20:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C066B00B1; Fri,  2 Oct 2026 20:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43AE6B00B2; Fri,  2 Oct 2026 20:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98C8A6B00B0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01078A084E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:51 +0000 (UTC)
X-FDA: 85279412064.20.69149D1
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4537120002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kQvpVEp1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3nErAagoKCI82C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3nErAagoKCI82C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986910;
	b=310s//q70cHj2jXypwnOL4WOG3u23ijjX3XtVfLfI1oA0eeiYbUgvPe6D2l2+mBRtfam2N
	Rn8XjkK/+mXMuiEZoYl4VSRWajG94o11YeZqttVbii4DaYRQp3QBbKUYQQeowOat2PLCk3
	a3W0RSKVsLhYB6EnJrICPAFGea3e2Sc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kQvpVEp1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3nErAagoKCI82C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3nErAagoKCI82C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMiZSMFdM56iT7i//29GA+eRMEhcqKKBOVTZB/kicf8=;
	b=OA7FPg8b9WtZl8gU3qbBm+M4e9TtECGwLVeJFlHYoVaMktderWVP/atpiN5brv5KMIJxVT
	Sh0s2/HYZDYWTTWEWejDO9ng9qvDhzPoTJXA3rnyPSGmuYfGChTCbut18I+A6oM0bY9jOb
	pSZbEI4nET+A9+1U+3RBf909iqYEBYc=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88be38f3a0eso82395b3a.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986909; x=1791591709; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BMiZSMFdM56iT7i//29GA+eRMEhcqKKBOVTZB/kicf8=;
        b=kQvpVEp1lvKuepjmFuvBSofKhMOhSMV39yknyvfhXBnv7/xCalIopBzHyFB664J5Gj
         TaOWzfW7QTz/z+0kF0JGQMYSpU6rJwGs0fitnuOIwdhYneWPhKYHUaPWF8Yod6q/3xab
         W3ELgx3Jt481hU7qPugzL+z7Lc/UfnZljegh7MBSsZpvGPbCQz53zlODa4MXZ+HZKATi
         aIM8r/wQJmJo4gsOHUTehzgSOD0TGvX536YgQQ5Ig2QjcQG4dH7Opfh8dbU1Owl9abFE
         WXuKx8/FVwef2lVGFbzJKWrz4j0RPCto5qfsA8lcy9QbuhGvDaPD6NYIWSkQheJE5Y1R
         mDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986909; x=1791591709;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BMiZSMFdM56iT7i//29GA+eRMEhcqKKBOVTZB/kicf8=;
        b=ZVD+mig3GeWJlQSw1lKCYzyqYht9MdulEngdqr1UDEUyIvb1DYHj1ocjf/SnXdQEj1
         ro4bNuEyL9NaIEEQOgt/G/IjHv45sHGZ5jUN2icnHTWgPz357EVNwsjrn3tarhTPexlb
         /T9F/fTNzaEx8dkesk4XMIgJ8e7VsqcqnnJnUb3FPBt0Bm+mhpVNX4/fUCVcO+R7zvmD
         JlfhEjxTNuWwbZXxgZI5lRyUcAhYPYJ9vwv3eu1j92M3bCVX1hpyF8bLLIt8wYOgi3ug
         KXnpbB7p6tWTZP/2yUdD9FXbSbYIPs+i/9pVftoEshCHVz6WO5ZjpnxgbfFXOQUXI8oS
         VwVA==
X-Forwarded-Encrypted: i=1; AKwUvBwg/Tr3VREDXOVU4yu1+hfH3d5bbZm+nWM7R9QODNHtNK49p3QHyMfrGa8ELDfK/eDpSpNip7wLvg==@kvack.org
X-Gm-Message-State: AFuF++mYEZKBt26yT+hC9eAatcbT0BDMtuSnZpV2Who/mGsUdlEnQnxG
	eY85JJs22aNlxvKeBwUF06dBs3UY1grd5G6lXQZPoqu4LErZHHXMFfvlne/U6LVCzFdU24T3F2n
	uT/NPHX7Jz7LZWxxYrGtm7g==
X-Received: from pgdo3-n2.prod.google.com ([2002:a05:6a02:6203:20b0:cc7:492f:3ac1])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:4327:b0:3e0:df81:23ef with SMTP id adf61e73a8af0-3e0df815706mr74686637.74.1790986908868;
 Fri, 02 Oct 2026 17:21:48 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:19 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-17-jthoughton@google.com>
Subject: [PATCH v2 16/20 DO-NOT-MERGE] hugetlb_vmemmap: Use
 try_populate_vmemmap_pmd for replacing in-use PMDs
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: yn9f1mrdie7gkjzpkgaww3szbxera8cq
X-Rspam-User: 
X-Rspamd-Queue-Id: 4537120002
X-HE-Tag: 1790986910-395189
X-HE-Meta: U2FsdGVkX19EP8Pxpq/wK0hzlP4vp+jeZgqZCBuxOOIy0bH7KFYCjE1bS44mk/WyCkE31P+ckKLeLq53zoRJnsg9EsMyrgp62/0AxKAmfiIY3NlD0amObRPjl8bRXodEimN2rYpHiJ8FTuDOYLSvaUCy3qatylylX4AoWD+44yv/eA6BqMwfoM1y/uyXROQcHL+7K+HoejaxP7Ob0Y8SfDxERH8+aSETh8JIV4/2olsxcdmQrle/B8kBw8VKxUNtH/eHTr7YeRRiOP4mAL9Jt/kDfRE0bc15riKdDha5/pFry90D6eEsvMEcnDHcoRn0DNZSQ6f2PqA1b/jj8fQ4aKYy29OE5/N5HSqakD+JZnJPexUnoetVMrz2Jjm86ti6W80P6w32lKcFxJtsHpWL/9Oi/PnlWyLMpu5RZT0m6iQ8yIxCa49ZOdw7rmsjubr/lT8PZExWtJM89bFgODaGlR9qXFnIBFKpCjfWYquzx5v0W7wQ0PBn8Q1U4iJj8VimcqaWDeTDGqs+jIRk5a/P/Nez9mGhCE4Ir53cuTnjNXjLE8+qWqlFF1UZzGTUmnwFqJ+MGvCH2um/DXLiLgXtqrkDCAfswtYBYoaKXT/bbztyAYhPmAr3te+WtUlOxwzwTwsdGXVNlZBR+a/atK/r0AoD/i//A6Z5JbTlAvZ5boxZIlFyZCHrNwu/VHIXL43T8SLjvzZ/rsSbYRKFb1bnBvLnj6woCwo2shp7R0pV/HEQ3vZAd00kuKGsUt7hgLIlulgu/ytV5Q4+iiiRDvTGYt2CxajE0Z0VHoWWhbcpMFWXM0Fr6TWc2SDRAAyz7bncRXi/o26Fudh6hChTeZ3XpTtfDAE4KYghAH8agxNkwA3Cxgfs8HztxpEi9IkWlyPhoFnT/eYYCWEM0m9+EmUXNv3eSbCOr15QmWsGhObSUzzZQJKclTrT9lEbogx8xnQPS/CQJS5xBIIn56t/Jz7
 jpOeEb/o
 ky1eIAQpnHiaH6vgqrFwb0BRMmuGbIpj38jssCYPAbndDoeDo7HzLOGKTt76y9npMKF2NlTADx35ivJ0TYbsJwJUr1AMu0YuqzecFCs57dV9mD2FSKDOaBVC2xCsCT5ZHt/OSPPxmI8po0uDdc/+fW0n6Tih+00zguxH1L43XrC5vZPmsIj11C4L/WdszU9bxRnwbHrisxGIL3/nU6RK/7jVLtUU8UrpHkJn2iERYvJcN4PVVfYXyZX96RcNNCQKstdYMRH5GaUGg1TvPqTcy1zSS7QFk1K+88r1wOa4ZghubDbuMwOVdR5i0W7/GstFRC124koFiMFk4CMtX7plVR0uY8fZhBX1zduUOf7vOOLSqnL9neP0a48FU3/nyX9fZY7VR1yi8jUf1ZiclaclTdNCQlU1vn3zZRclHM29zxUmLB7ih7AUX3MqpvX8HFTf70+yHUi80BrCXxU8dnuV8iLTA7fVIfx1XCFMmQ+8T4scXz3lDTnFK9HqTAajUCfyPozzi8LtrXG6zWdZA2yp6rp17TkgJtg+s2kES6izYtnFtREN/cCNAsK5CVkRikfWqzSFEIYOkbnNOadfaoeNtxxHxLQiUN6+Ai3tvwTkTiwqS36DtvwdOZtldK6b95qTY5qkoT8k+YRrL39Q2nGpy1oX42Ck99plZvTdM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This routine is to be used for updating in-use, leaf-level PMDs in the
vmemmap without introducing a window where vmemmap accesses might fault.

Because try_populate_vmemmap_pmd() can fail, the split_page() call needs
to be moved to after the PMD update. Because both split_page() and the
PMD update are done under the page table lock, this rearrangement is
safe.

Only leaf-level PMD to non-leaf PMD (mapping the same physical pages) is
the only transition that needs to be supported.

Collapsing a non-leaf PMD to a leaf-level PMD is not used by HVO, so
try_populate_vmemmap_pmd() need not support it.

This patch allows arm64's implementation to replaced with one that does
not require BBML3.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgalloc.h     |  8 ++++++++
 arch/loongarch/include/asm/pgalloc.h |  2 ++
 arch/riscv/include/asm/pgalloc.h     |  2 ++
 arch/x86/include/asm/pgalloc.h       |  2 ++
 include/linux/pgalloc.h              | 21 +++++++++++++++++++++
 mm/hugetlb_vmemmap.c                 | 25 ++++++++++++++-----------
 6 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 1b4509d3382c..0263329fb7b3 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -121,4 +121,12 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
 }
 
+static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t *pmdp,
+					   pte_t *pgtable)
+{
+	/* BBLM3 is required. Its presence has been checked. */
+	pmd_populate_kernel(&init_mm, pmdp, pgtable);
+	return 0;
+}
+
 #endif
diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 248f62d0b590..0553addb0afa 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -24,6 +24,8 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, pgtable_t pte)
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PMD
+
 #ifndef __PAGETABLE_PMD_FOLDED
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 770ce18a7328..b9b4b25fc6f0 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -31,6 +31,8 @@ static inline void pmd_populate(struct mm_struct *mm,
 	set_pmd(pmd, __pmd((pfn << _PAGE_PFN_SHIFT) | _PAGE_TABLE));
 }
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PMD
+
 #ifndef __PAGETABLE_PMD_FOLDED
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index c88691b15f3c..f8d24b97cbf5 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -82,6 +82,8 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
 }
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PMD
+
 #if CONFIG_PGTABLE_LEVELS > 2
 extern void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
diff --git a/include/linux/pgalloc.h b/include/linux/pgalloc.h
index 9174fa59bbc5..1dbecb748028 100644
--- a/include/linux/pgalloc.h
+++ b/include/linux/pgalloc.h
@@ -26,4 +26,25 @@
 			arch_sync_kernel_mappings(addr, addr);		\
 	} while (0)
 
+#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PMD
+/*
+ * try_populate_vmemmap_pmd - Populate a PMD that is in use by the vmemmap.
+ * @addr: Base address of the remapped PMD.
+ * @pmdp: Page table pointer to be overwritten.
+ * @pgtable: Pointer to the page table that the new PMD will point to.
+ *
+ * This function is only to be used to update PMDs that map the vmemmap to
+ * point to a page of already-populated PTEs that map the same pages.
+ *
+ * Implementations of this function must ensure that, while the update is taking
+ * place, CPUs will not fault on the remapped virtual address range.
+ */
+static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t *pmdp,
+					   pte_t *pgtable)
+{
+	pmd_populate_kernel(&init_mm, pmdp, pgtable);
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_PGALLOC_H */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 1eca03a3def3..9e0f52474bdb 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -88,6 +88,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
 	pmd_t __pmd;
+	int ret;
 	int i;
 	unsigned long addr = start;
 	pte_t *pgtable;
@@ -107,8 +108,15 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
 
+	ret = 0;
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pmd_leaf(*pmd))) {
+		/* Make pte visible before pmd. See comment in pmd_install(). */
+		smp_wmb();
+		ret = try_populate_vmemmap_pmd(start, pmd, pgtable);
+		if (ret)
+			goto free;
+
 		/*
 		 * Higher order allocations from buddy allocator must be able to
 		 * be treated as independent small pages (as they can be freed
@@ -117,21 +125,16 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		if (!PageReserved(head))
 			split_page(head, get_order(PMD_SIZE));
 
-		/* Make pte visible before pmd. See comment in pmd_install(). */
-		smp_wmb();
-		/*
-		 * On arm64, this requires BBML3. Its support has already been
-		 * checked.
-		 */
-		pmd_populate_kernel(&init_mm, pmd, pgtable);
 		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
-	} else {
-		pte_free_kernel(&init_mm, pgtable);
+		goto out;
 	}
-	spin_unlock(&init_mm.page_table_lock);
 
-	return 0;
+free:
+	pte_free_kernel(&init_mm, pgtable);
+out:
+	spin_unlock(&init_mm.page_table_lock);
+	return ret;
 }
 
 static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


