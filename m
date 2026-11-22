Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D2A606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C7UykgW2
Received: by kanga.kvack.org (Postfix)
	id 04AA26B05C3; Sun, 22 Nov 2026 13:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16206B05C4; Sun, 22 Nov 2026 13:45:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCBC6B05C5; Sun, 22 Nov 2026 13:45:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF77C6B05C3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FB06A0343
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:18 +0000 (UTC)
X-FDA: 85463632716.18.C529DF1
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69BE5A000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=C7UykgW2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3OjgDawoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3OjgDawoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373116;
	b=kWUZN9c5o35dy98Dp6RUwo3amOnLcyGnFrClGynsqThbpHnQjKIIzSTpdLB46LbrDNzljR
	y4ZfGrB5889mxXwQmVhDKsup4WWB6zEeEMMKnuCEDyaJO/Q9gwmHOgWMLBelN1Hy01Bf1w
	Quijh2Xk8gjqolI1Yj4bmuccbDPd+Ak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyoGyMPHCZrPmXyDUiOnFwReVbPTH0j6B6OLTrZnNqc=;
	b=OdDNNmB29WgU4P16Xmek8zl+JyUaPQFvnq0vPOPVTbapxGT4S0q9qjJWnQOAotPfQMwPzu
	UIgY0pA44+nfNXfs1K93pqSGnewrcZJUMhruGs5gpMOw6sbASAfdPqhv/MIFpghO5aPgtf
	jkN+vGzAUmPOiIKbvOoMxBAFja+reyc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=C7UykgW2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3OjgDawoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3OjgDawoKCBc6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2f053f95aadso18896845ad.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373115; x=1795977915; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DyoGyMPHCZrPmXyDUiOnFwReVbPTH0j6B6OLTrZnNqc=;
        b=C7UykgW264ghi1nDUMjOaUsOvUlzF6a/S6S9MBz9aozdm70aZ/A4SRW7/uIl0A90oH
         YceEg1el5HjrrYTE5cem02aMiH/IP0m4rLvwsGLUWWUWrKF60wEEC3X8yK8AXT7rgMXq
         F1gNDyGLus5D90YxjzepWi6zwyKRZVeBgJZ5Qx5ZXaHGvzfTPdp+dxZXY0bL2OcrkmiS
         4wetVMVsjYdPxFQ48kSA5YYqyx0ABhNJtymcACetAuxw0cbecIAkDxMHQqKf5Yc5wfde
         pLZjLMQq9+0GOGZTVskQM4M+zxmLkuDYWpNiXCNaEkhppTJTlmuU801bj8ZrD1HIp/m/
         kG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373115; x=1795977915;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DyoGyMPHCZrPmXyDUiOnFwReVbPTH0j6B6OLTrZnNqc=;
        b=yKuPNNVXxKv9S8VpkWyamH+oeM4Bs/Ddx8iWodG9CCQEEnr73wclF4A3tgBfDbxmv0
         jk304m/scsM6eI8rtsyLrZAm+aZv8R6emlB6tsU3y2HuHkJVx/yvSoqoH6pn6dtCljp5
         akxCP+bks6KFd4hK66liF0nHaj7DEtu2/NlN7Ur5o/Ibt2XunTludmrc2PtgHcMec6/2
         GVkwcD/7zcUCHw5N6aJhEYiYH5FhUcMjzy06GEab/XlyPRFg/JG0D3DwSqwYKbytCvyj
         f12g7KpDWJBwFao0Ni2sJT4lGI5FahtxJpuBeVoJkt5gt0aSrC5GAmomwwuo3yA2/+r8
         YIXQ==
X-Forwarded-Encrypted: i=1; AL+hErGNDWdRJ04BeizkrkrD5QhV63RzZfowZqf4JUmarbVdG4sJWdzrNnihbAjaMD51l4JdTyVpoeBNgA==@kvack.org
X-Gm-Message-State: APuU4Z8ZytaqlIQTJd0CsbRuCi85CpgAT5mVgKtZJltqCzuP87oI2DPq
	jqzkbZlONVrwxsm0FoVzUcAraYPrrqqVE2zY5D50ZCpqx4ScoNhF6/+8W+AgARbKLne6UYeZFSs
	/pjUavP3hfA6upc5I1JeQ+A==
X-Received: from plgp1.prod.google.com ([2002:a17:902:ebc1:b0:2ef:d19c:27b7])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e80b:b0:2ed:ef1:f78 with SMTP id d9443c01a7336-2f03f11824amr92868135ad.21.1795373114972;
 Sun, 22 Nov 2026 10:45:14 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:49 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-16-jthoughton@google.com>
Subject: [PATCH v3 15/19 DO-NOT-MERGE] hugetlb_vmemmap: Use
 try_populate_vmemmap_pmd for replacing in-use PMDs
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69BE5A000A
X-Rspam-User:
X-Stat-Signature: i4mkxfw1o6mrzuasxtpsgdfor8yxag77
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795373116-999631
X-HE-Meta: U2FsdGVkX18ykO38dKYJH031cItAkK+lzLIkhsLgMzhzI0SqtF37sJOYoQRAjOBNp0Uq6K+hZUF4x52Kf+fdVbUZ4mBybPZeYxjXomZatGz+Gf2cJ8K3aI0tdmbBiz7c24W3a76iWuAee+FKsQIvV1OzP7mhQMUzNT1rQBabpAjTuU2Ifly4jUqWgWBLsApfqm6P0dZ9iopHxYalDYo0Umcb9iXMMUYGJVf6oQ+IndzMgyrmVGksAdQ6gQkU4OGhQIikvD9zSKOmtDQKLihJ31bS3kZXIqNnWwtOHiguhpPN05yUTvGQxI+6wasqpN7tjgJp75FvxrrTfMOFuKgnbfaDcz0X5g18L/zOyc/u5Gak/Cp7eRPC7uaXEI8ZabWm3eX+NRcZOAxoy3oBXUC7tJahgV05Q4LqOD0I9ZyNkdFdGgEtDe8jAoelEl4RTA+qaxiD9dNxifVJBgg4ZKsf82XmK9mqdZHHbiU9ssSw1PedPaAlwFfBd1+M1tQ+vXNs3SIqOMbTPl8yYav155GcgS2yBiGgJUWYJO7yLcmVQsQBQrqOPFrJ2nCMOj234N+HZwgsyJmbY+8OD60fmtUag67o2Sn3AQiSUIYvvJQ7Zq0xtYtiZuFCh+tkxSJ0lQlhiuBBB0X/7MIbE+hA6ivG3AuHJnBUe1JUnYxvHBRmFhMYw6U3B0YfE8vDmpRQc5/UjFKMgGtpBQ5gBH62b3uwvowWpIsiccZTDLPf2dkaN3UCfsyARKI9r4cWhGAMRWQnOMYWLstsF5sOV/RlghUkIbOdI2afv1fpS241sVRbbym2rZIAMzfX5KruUo52gGvLp3PHlLDehOKlVcIejwnfALF7Q2Ux4jCFYq9wQ0y4U443V6+FOaYxPbpiDOoQEp3emPEC3MDCB7IZW7OkUyVLIy/GWIj19+BBxiozMpZFp/eR8AqHM0FSM/IuiESzBCLneMFSLwGLG6nkFrN4XVq
 7a3/HgDo
 i84CqHTHocDVTvw2SfAZNxbeONrz36UYd8C4+IailW/zwC5NMag8S+WX7ld6NvIENJXlHnGF5RBxBnNL6LjsGXmnaYt+0CHK2e+qrw8L6wyap6zvEPRgwGzG5SaY4w2rp30Te5WnDIsdmFJKEBfGmStdLVUFuscW4sFz9d/1V02GNT9jdEdzqTYKaauxFvwHEo7mHxPhRBFf+0FUoWybqfjga01ti8cA0WfMcW0rY5+gyDfNG93LaC03ROghHlFmzcqzcvViPEQOl2T/ZZ6TL0Dkboe6LPn6Ur9VpTQJG5DnXr+yKti6JjBEKZH7G9hiTunPpBhXs8yq1Zpq3A5SAz2JnQTs6UPAHt3qJfz6DaZjQ1TQqlTqp+FtbeARhGRpBMrHz9CGHtdmmWQgjl5MRQhd7CnS38nVcGKf/wHhLbQK2wwAg+QwQdYJotnFVf6I7iuU1TC2NI03+o8T5Ny0MQ5OxB61Ax2K2fPkc+VVeiOTmhBjz/Egf/c9KXmYnXPFrZ4Pasax3Rb04lKljUL1wGKESoueOih7JmdyP0NJ3EmY7/2foUkttUCJEoD9sr0JH9Z/tMQcTADCnzAa+ptbcDJUwQNrZicBh2YE8tklqg12UiV0fTpIg0B3b9ffhfiUXDI6BXHPAqT3M+MfcvTYNZd2jdA0w15arnldpW7f5XXf/1i1R9RI1E0uQnL/28TdC2XQfty1Qh0EwWs4krP1d/QCzu8BuZbAOK5YcACTxgL4vl+k3vbCoCGc7OM0FbwUS0j0Bw7WtO+EHFd0aPejxsLwypZQ+MgaFiRp/BbzvOejJuCWBAY9h1RlhDxXKdjjuMaX8722Dd7hjCEfN7dz25hjF7PwXz6+XlKCG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 06a36da302d3..e37c94e6d929 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -21,6 +21,8 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, pgtable_t pte)
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PMD
+
 #ifndef __PAGETABLE_PMD_FOLDED
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 0133f7ba41d7..ad76df0b811a 100644
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
index 4cacd7aee719..d3230588f31f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -82,6 +82,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
 	pmd_t __pmd;
+	int ret;
 	int i;
 	unsigned long addr = start;
 	pte_t *pgtable;
@@ -101,8 +102,15 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
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
@@ -111,13 +119,6 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		if (!PageReserved(head))
 			split_page(head, get_order(PMD_SIZE));
 
-		/* Make pte visible before pmd. See comment in pmd_install(). */
-		smp_wmb();
-		/*
-		 * On arm64, this requires BBML3. Its support has already been
-		 * checked.
-		 */
-		pmd_populate_kernel(&init_mm, pmd, pgtable);
 		/*
 		 * Modern MMUs allow overlapping TLB entries with different mapping
 		 * granularities only if they map the same physical address. So
@@ -125,12 +126,14 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		 */
 		if (walk->remap_pte || !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
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
2.56.1.809.ga0b61035b5-goog


