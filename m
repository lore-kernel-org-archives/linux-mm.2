Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD265C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A476B00C0; Tue,  7 Jul 2026 23:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5656B00C2; Tue,  7 Jul 2026 23:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA48A6B00C3; Tue,  7 Jul 2026 23:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC376B00C0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCB071C3B5D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:45 +0000 (UTC)
X-FDA: 84964134570.08.3534216
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C3F11A0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YeC27i1A;
	spf=pass (imf19.hostedemail.com: domain of 37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyOZS/IOogCiOtSe1oniQEutV7yDNXcShcSAXMB8Vac=;
	b=7GtngL9qml0jSPwbkzs1Z7wc149p5HUIuOw6ErIixOgVnknCLgaS0+v/w9lG/RKeLV4SSR
	4mZNrfVLMt362WU6QBOMJT1iMqjsn4ykwVoWTo45riOFksX/Wcqc5FUBg0h/xHYMRWmblY
	+GhSh5BfFrwh/8R3cZTJx6wI9fL9RgY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YeC27i1A;
	spf=pass (imf19.hostedemail.com: domain of 37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480304;
	b=5dWSMi1BMy1Ha/Z0gCQHgkswnb9jYqTftGkD+0E/qHinBhXWZHx3qm8p3rHyjEm6ZXULuN
	Vvot3U+CAuQQj4JAaLaor9AGEDXy3ZYZDoiq8n/Ntdt1UcuowsN1g2+3jwi1a+9WXN2IBk
	i4qgoCuviyNaUt2F95qzw/wfO10+SHQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c6bbd0afffso5414645ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480303; x=1784085103; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nyOZS/IOogCiOtSe1oniQEutV7yDNXcShcSAXMB8Vac=;
        b=YeC27i1ABNCNOvAA0xyK9+VVZZ03zVWFfnJV/wwuXZHxD9nu4RBXHKt+/QN8Rq3WZ6
         Ood/rrd/YiVrKeei63mEbIVSucFBzvoJZKn0LEcwANg6TNgrhYP/ONLQxFSC3dQ25jvO
         GYQNOsq9BmyL/f8D0VWGZxrjh/RSlji3fzPlHAwnzQCNsZIqsHY70HvsvM09MZfnU4Vo
         81+xWAOVw3zAncFUc1KDypUI3y7CFISEGa+KONW18P9i4LLzo/2MFwhXMCcOUf3mr8Vc
         pMaLZjYq9iw6rcNj5M2zBaFxdBf96z8UrwkoYjXHw5Wa9W78BdIs1uCfMZzAZtner5xF
         DNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480303; x=1784085103;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nyOZS/IOogCiOtSe1oniQEutV7yDNXcShcSAXMB8Vac=;
        b=VCKaJLt4HFeYJCpIGCku204qbN2uOe75u630dXaoUXpy9C4yJ7rZkwprck09uUDLuJ
         U1VYfUyU1uDvjMTTyn5ue50A/JhfZ/4nVLavDOrGc8q5VFQk8Bewa6Pw/UHfuQW/dHOq
         wWUMNKYiUP1R2Vo2feZhGMzUYT1NnAdtCRA5vAL5nk0TrFbbfnbCPv9WEkvhRmsRgz+O
         1IY+GCKR6JyL3yT81Q9k+KV2ICYpeXlKdO/4Tyqx7eQ/f/DGhIsIbApNmVIgQc1zwp3F
         9Dr4wiOAtnx6zK1c4UGBUIry9nUe+bR9Dnrb+SLb91bRzgvffQ8ykt0G4jfiQ8JPfLXr
         ppOQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQzpRszJbvVhTgwS79otun56Rb9XFRlIW/zWYhgz5Qlz6kzAFAGhqV2pEcI+tnubOv+5/zswygnw==@kvack.org
X-Gm-Message-State: AOJu0YxMrySl/GSGzYSWVhbjhKQp8KJJeWqx9WYh12GWbby8NNxCVYqP
	C7SHhkWXKM5AHGpVHR+GnstCvnRHLM1GMN26/+vxkVLP70hhcOf6CM7n7F5QXTktipfLUiaZ0+U
	wL0fCYJRzI4s8ux4M4LrCxw==
X-Received: from plbmk12.prod.google.com ([2002:a17:903:2bcc:b0:2cc:e106:f652])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4684:b0:2ca:9ab:e723 with SMTP id d9443c01a7336-2ccea481a57mr6652835ad.33.1783480302952;
 Tue, 07 Jul 2026 20:11:42 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:21 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-12-jthoughton@google.com>
Subject: [PATCH 11/18] hugetlb_vmemmap: Use try_populate_vmemmap_pmd for
 replacing in-use PMDs
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C3F11A0006
X-Stat-Signature: 34nh7k1myjauz8ars899tnz4n7m9frer
X-HE-Tag: 1783480304-534131
X-HE-Meta: U2FsdGVkX19VjxlF5Ls4eWwoAUKqe/l8DXfGeB2GdyodtBmeGwZQEFaYUdNLDwPNEYqdwangkwnWq7G7vGjhkm2EyuP/a2aZ8hCZMgS/o/oZtsLDJVJTYXXJAu5JbQ1Hgrr7urMtC5PXMxMK1Xo5tjdHbIUZSlWAwOIvBQ6cHHxAtC86qI5ZsBc/XtCH0j5Yf8niPkHd4Xz23NKvr58eJlAO+w0UTgkSWoJNapoZQtK51T2dmej26hGwuhM2FU8o9C1tBbhIP4+HYpgq6nBoan6tKc8PIOhE9DwChxLNUNwgo/RJDNl3EhzATrKAVnv6CRReVCIwuJGfC7KqQCsK9RNJ3N5iWtR7Re0KANKVhf6GSOkXGiALsnbu5vDPytQvEKJYrDFLH6G9EWeatODgwjFjm3m+2OMTcY+pCJ3rR/6k+Qo38dORTrVfzLqjOmuerrO0OvqHwvFUl9I2GA5/U7qz0aIRn5+K4uSTXLB65osliuOtv0rcjugl18peyL3JA/CQxhJyA62A6/+WwBwjJjehyhORvpJhI9RP8SKuvK/OceMWXR/UF5RvTF2/ZOdQmlUv0Gq4/+JqY6tFVi2+8Ld2XB0G5RHgGmWU9tsLXRIYmsmVJnmOAPU6/cVxXXC1968+XYAlol+3Cdhh2fsTsUvNPZmfHQIt+atDq9Hr7Ebmlb8P6trtHNYh3kKQVubh0eovZRv8c/dTo0rO4DC/6oBshcAbVZNd1Fd7B9ThBeV2qHIuco0VItO1FWRzQOKGrPBLpCaCAOFoOrmN1VIrS9I9xZlErW1MCsZ928wxmkqQtcbe4JzOs7QxVO+jzccG3W4wgWsBuKfAjNM32g/GLMWXvJ8BuEznVHVvKODzaJMIbJhMET/V+kUtHT9mxnW+WEP8vzCKBGYUlfLSgUzpHrUsetx0XJ18ik7GZJsYWmyVnYJA+nLZKu3sySuymAgbpz2zEswfuNm13Iuu34j
 2mcqhRP5
 pdropkke/aXP8PC0Ca/yh0tFM7wDtPwTNkZBDshcgaFnRsuYpfDvTNvZO88uzz7jrjqf9oG7Iz5IINbyS0qf98gwC/KxNa86f9bcVdC6Lxk/j9ZN4mz6v894v5i4CjvYtHMCq18lYNw/LXr9H2fVRWU/MiMSOaJ6HXykY/r9ntnjYs62YEiNARRrg2v09AGLQIhm1Iv8eSQcoZVo/ltHTuN7FA3UIJJIssCJFEK+Ubzs/rpNM+bQGtNjNnTcsITyqbheG/bl81fK5vEX14Fj0NO5GneDn/8CsWllnohBxBN3pg4Krf7x/e51vbeWyttoKq7o6zkMDtHfBhwOr9HxzE/6T25NY1cEbuUQcJpEcWBM6E0y4cztCXNKPVc+xwY8IS8EvVERbcpv0lwGwHT4Ns2378BQ8Vvhp+UXdBNKx0ZDsdBAG36uTpVHcrla4NqGoKbx9mD8UA6WWLTG2BCGe2sAzwmq+mpYCVql+2JNR6ITcK+DA233ny6kiAuYhVVij7QAtQsOB0OBMzuykMZ2fzGJRKPtELIm763KJLGSP91IeDqXNGV+4gopNHn22QhRse0gepMJTCrV5fg2glCUdF1FE+kdcv+pQ9GF3iFad5l4thUa4xGHsu+3+u9vvOwxCUReqgNtq7faLgnSHuw/rvwvAcB3j3Dn0Llah
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
not require BBML2_NOABORT.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgalloc.h     |  9 +++++++++
 arch/loongarch/include/asm/pgalloc.h |  8 ++++++++
 arch/riscv/include/asm/pgalloc.h     |  8 ++++++++
 arch/x86/include/asm/pgalloc.h       |  8 ++++++++
 include/linux/pgalloc.h              | 20 ++++++++++++++++++++
 mm/hugetlb_vmemmap.c                 | 28 ++++++++++++++++------------
 6 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 1b4509d3382c..c8946250d431 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -121,4 +121,13 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
 }
 
+#define __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
+static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
+					   unsigned long addr)
+{
+	/* BBML2_NOABORT is required. Its presence has been checked. */
+	pmd_populate_kernel(&init_mm, pmdp, pgtable);
+	return 0;
+}
+
 #endif
diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 248f62d0b590..9322d962c9cc 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -24,6 +24,14 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, pgtable_t pte)
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
+#define __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
+static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
+					   unsigned long addr)
+{
+	pmd_populate_kernel(&init_mm, pmdp, pgtable);
+	return 0;
+}
+
 #ifndef __PAGETABLE_PMD_FOLDED
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 770ce18a7328..8dbbe62b2574 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -31,6 +31,14 @@ static inline void pmd_populate(struct mm_struct *mm,
 	set_pmd(pmd, __pmd((pfn << _PAGE_PFN_SHIFT) | _PAGE_TABLE));
 }
 
+#define __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
+static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
+					   unsigned long addr)
+{
+	pmd_populate_kernel(&init_mm, pmdp, pgtable);
+	return 0;
+}
+
 #ifndef __PAGETABLE_PMD_FOLDED
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index c88691b15f3c..47b56bbd6236 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -82,6 +82,14 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
 }
 
+#define __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
+static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
+					   unsigned long addr)
+{
+	pmd_populate_kernel(&init_mm, pmdp, pgtable);
+	return 0;
+}
+
 #if CONFIG_PGTABLE_LEVELS > 2
 extern void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
diff --git a/include/linux/pgalloc.h b/include/linux/pgalloc.h
index 9174fa59bbc5..ed446d95ca37 100644
--- a/include/linux/pgalloc.h
+++ b/include/linux/pgalloc.h
@@ -26,4 +26,24 @@
 			arch_sync_kernel_mappings(addr, addr);		\
 	} while (0)
 
+#ifndef __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
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
+static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
+					   unsigned long addr)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* _LINUX_PGALLOC_H */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 977249e22ed0..b445febac0d2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -55,6 +55,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
 	pmd_t __pmd;
+	int ret;
 	int i;
 	unsigned long addr = start;
 	pte_t *pgtable;
@@ -74,8 +75,15 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
 
+	ret = 0;
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pmd_leaf(*pmd))) {
+		/* Make pte visible before pmd. See comment in pmd_install(). */
+		smp_wmb();
+		ret = try_populate_vmemmap_pmd(pmd, pgtable, start);
+		if (ret)
+			goto free;
+
 		/*
 		 * Higher order allocations from buddy allocator must be able to
 		 * be treated as independent small pages (as they can be freed
@@ -84,21 +92,17 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		if (!PageReserved(head))
 			split_page(head, get_order(PMD_SIZE));
 
-		/* Make pte visible before pmd. See comment in pmd_install(). */
-		smp_wmb();
-		/*
-		 * On arm64, this requires BBML2_NOABORT. Its support has
-		 * already been checked.
-		 */
-		pmd_populate_kernel(&init_mm, pmd, pgtable);
 		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
-	} else {
-		pte_free_kernel(&init_mm, pgtable);
-	}
-	spin_unlock(&init_mm.page_table_lock);
+	} else
+		goto free;
 
-	return 0;
+out:
+	spin_unlock(&init_mm.page_table_lock);
+	return ret;
+free:
+	pte_free_kernel(&init_mm, pgtable);
+	goto out;
 }
 
 static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
-- 
2.55.0.795.g602f6c329a-goog


