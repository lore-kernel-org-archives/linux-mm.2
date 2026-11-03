Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5B5606FAD9
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tdXY9YGt
Received: by kanga.kvack.org (Postfix)
	id B4F966B05BB; Tue,  3 Nov 2026 05:17:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B277E6B05BC; Tue,  3 Nov 2026 05:17:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15F96B05BD; Tue,  3 Nov 2026 05:17:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7803C6B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:17:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00345C0382
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:34 +0000 (UTC)
X-FDA: 85393406070.10.B2CD2EC
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23371180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tdXY9YGt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHjbXN5GPOj+3N/hZYmdpYePqr3N047W/AZ1HDpQr5U=;
	b=gEacfxLl2FOAiwBA3+f1WQ0ETQuDrSpce+pu5NFnz0Ruuj2oPjQQk8Bjgam3+KrQv9Addt
	nr121ls4cP2Br6eAbHCWFcBeTGnBB2gaDcv6C9e/fqGyPurpdhit2oyadst5kcbIKEkYq9
	SnQeud6vp/nhktDaZM7EnF2GkUL3vww=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tdXY9YGt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701053;
	b=CDkN4ETFYiKEhsmM/nC+7HsGX+R3Z9/OGPCngWoOZLj6eEwhBvns2qSnkAnYFbeJjKwPHL
	9Uflimad4k1GHbUem7AKM9ivOeVHadyrQu6AAYgcKzxtBmg1sPok0C7E450rDn9ai6w+PB
	BQ2R0G18U/q4ItYAj7Da7+ukyi5tHWU=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3550c917fd3so5454304eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701052; x=1794305852; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vHjbXN5GPOj+3N/hZYmdpYePqr3N047W/AZ1HDpQr5U=;
        b=tdXY9YGtndddtYbOmEsBtqfSqHJxPY0SKJt2HuRw6IXqBrcjrFFBriG15HUn4RedoT
         TuaKUxx0B6zE3SkpyNh3oLrgVV9NVQDmg9FyoNa0TdNx85CQadq3rbUYmlIDwXBXRljn
         bteIhaoW8TGHjQFa9eDcf/wk9PVYEZDgo5kSZ73HqAK0qs9BEPsX1TMB2UUCRqGX2oN0
         qPn1M8ecUg+lH9JuDrO7RU1GiQHk2e+2YY5Yn+gePqtUEqvxXnfVuWxtRiizCQMKKKPC
         c8mx9zqaFu/P2iLlQuOsTdFPDF7bWEqkNFSUN570c0m7k7fcMXRwxw2/y40PczpWcfev
         ox7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701052; x=1794305852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vHjbXN5GPOj+3N/hZYmdpYePqr3N047W/AZ1HDpQr5U=;
        b=iP6WtINywaveuCnXzY6eoLb3rxDunn8L8S+El6k+UdyffNSwPf3RWp1SUQg6MOCumY
         oFbVZjOSYLHwkU3uotVw4l6Ii2RDBmOuFs2svAtYsXuL+37P9TuSwnavroJA590caxnj
         08p4ZuwXy1Z8qfG2eqdIlNJC8i1CHLMoD/Pn5wfML7903wXNubtfv3vKdfGVoO+mTcI2
         bNcpuSgG2F/DdqcjFMgSb0z328dsi0Ajl2rnOwVkPmO7IcWLch62NaTiSovL7JQheiV2
         0KfGH85lzo1RudnovAr/iuYIdtVySb+lgGqFKxFpuSgGzpf0Pf9VCgLj4LQA6Mg7UODv
         yGXg==
X-Forwarded-Encrypted: i=1; AKwUvByJAjgbk9ohdoZPsMe+jljGqUV183a8Ouvy00PfxGYBmLLKh5K1EelFuQOpAwzJ5QP7LXurU7bCzQ==@kvack.org
X-Gm-Message-State: APuU4Z9fu7p4lTK4v59Sjg9T6rllcpz0m4QRc4kXzagyQZNk1r48akxN
	kA8bRdtynM2xylTlnMlRRmmd8tCydoT56xkfoKNc827G1bh2hozz1loa
X-Gm-Gg: AYBFou3cCuBJZkdbtZ27uBooNEGAEtcUhoKJO1undlWmFAU7mpGzT93R4jvhzYtxdmQ
	7uxWwXIyGYrEM2YVkLJocuQQ8aRPcIBpkz/2nkmKuuIxgH57AqqJfcVxPHSmRVV0O/LdkgfdvVr
	o6foFTMSCLvUpUiCfQ2V4+P7hVX+Vee5lIMlm1NgJFEKG6ZabYREHM+lOdWwYA9uP4r3cuCenBv
	7g2MV+VtJyOchJy8oQ3BYtc7EOgRqDVUCQeRDD5OGvL3tjdHvOyrHyjmWVGXBwGTVPPXC/CMVP6
	FZYBkJlY4nZlMkp97hx076FqLrmQEv0rrIBMs1Jnk4zjUlXoI1NKy41o+kg98B85ARIcgbspFrG
	xJCP0o/cF/+pSOD/fv0Lc+XSpplglQataVHA+Nspcxbndfl6iBmuZ/kHj+Zl0B8Y9kJCQww5x4K
	oPJfZ69B4kVbKXg6iIxUdw3fadMMyukj/p5WIr09UZG2a4nx3odRmx3Ywv1eorzbZof5EQPZb6Y
	rq+ddNlSTjWz1TrY9mLpWVSt2cUKpRh17xq0HaM4ZpBd4KmHUkK1Y8vJZ+TXpFaAR7OILdj4+us
	vTSa1ytzvjsKH4KmW3wMq0bEVEFfGPnF00OO8wGicwLukKaCVkw=
X-Received: by 2002:a05:7300:5b89:b0:36a:1732:1e7 with SMTP id 5a478bee46e88-36a424c7b7dmr29521974eec.31.1793701051925;
        Tue, 03 Nov 2026 02:17:31 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:31 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v11 03/10] mm/vmalloc: use vmap_pte_set_huge()/vmap_pte_clear_huge() for PTE-level block mappings
Date: Tue,  3 Nov 2026 18:16:51 +0800
Message-Id: <20261103101658.766905-4-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 23371180006
X-Stat-Signature: xriukwtsrgsc9antu7giayfqeae7rtcy
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793701052-469071
X-HE-Meta: U2FsdGVkX1/JqYtLDj9GrfpEdBFXkS36P34hrZ5Eh+hIT1/l8zHTC3A+47A4P9PorIM+hemnaNVaJ4GaUtMBjTVEO4yMFEUuGvFo5Bh0VLx3LbwY0LUfMBbANYbOrmhkKDBsKD2R5+ybyMQju8NH566pUoCxrUXEym2ffFe1XJVNPBnqbKDX2LPQeTOM+u1aqBXUaiUaZf+L4Y/iBJUwyEa4BlDg5r4c7Wz28oP5LCXUl5w7/zoID1sNT1Gjy2Vmobh4D98v+pavohlLp7RtyQKGWrDQowN1+1l08PTggGJyhCHk25yYqGJOxeOIV3hU8P5Y1kULgXQgBwBY/kJUD9bXevZlQxacdknFqP7H0ABapo9+mJVGqj+Qgp0vZm1aEUpuAAywU3bQmK4U0+0MI8kJ5n3ba6YkCUt7iHR+w9GgHO0g2ErGPGy6dFbi0Mij4vxZqcxbVG+mzYfMwbQIzK6lLTig6IDhSyNdv2Pj+Ke6J+ua+01vwgj9FDSgqCbav3v2KyyPmYOh5PHh6ww38w1ZwsuLqxJQTFDtzvoZT0ZJxBwLoLGebRlHTlYjrVXnVacXbV8NpsZZoKogW+ctkUY87bn8kSyslxkd1+ksepb2G9GXJOcvcMHfFhgK6PXGUVD7bug80ztkUoTZuGb3M5gqDzadBPYUKHb9gSzbfWJOdh8i1V4pgDrsByo35f0L0APQtGCQm5JKbchIU7mnDlDEgfh2vS1Mqbc2y/GCnjwrx0Asm+qXQYlqbxthn66oX47vbmWmWxBW6wFsselx4zJpqZXRK5hCQzP+vT0Ny8MNlbPnQK/uPNJj2i0Lk9daTwNZrluXBrN1QrYz0f3nvgcIsDkYu1QG0ZmchGLJ3rEQZvbgJgjspD9lTBR1s6Zbwk/4QYseB6Y7dkAaKTnYSUGkq2T41HTrZt5fNHrA3LLnaUtRF0lg9HNFnAUU5UVkkHA/ZE8N+IweW7rQmnh
 tKq2xgzZ
 v67yg6HVMyH565AfrRGvyxE7QfwyBd0cMtethjoCAUxYTBzXbSfG6HClGJnp2Im03QKgSKLZL/adV7zrQhMcScVkqn6slP5Bb2nLkYuS+n9AbHZhj53dM+s2i1fhMG4cz6jHIm5Rlrkq2ucvWzrvwsIk1FLtcIcIvW1oqTRs+YOMLo8AxoQCyYov1W5RlwirqpYVfm7mljCad002RGENA1zHatymIaFqTW9GxHjlSGBGJ9dfHbDSe61dJ6XO/zid/f2iTMgz6aaAvKhHjiD3yqYhgWUp6fy994SNvFbRQLJnga+n8qZok/ZLDU2eqR0/Q+QZtahNXDyn+VDjLGQlIJdOFisU8CdykQv18pp06HeAtgfb/X4U1G8MaTT8QXLhDpKm9KX+I9l1vYYXBKVFjEcNOEgcSwit2RtaKCmv/Du5JrRD7WlyYocMkOmvuLmyHBiQkV7icfxNVQDXY0R8YsopSZD99UDEGP1H6HwdvAed675ePRBW+JnG2WVNdXarX1ZGyNVGQFJE9ZzgCl6/5ndnz441TdJ47HUhUQB07Yn+2ywxswc9y/lMdTcQt5ERdCvk6L+JZF28PWdziQbGaVA0hLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.

Now that arm64 and powerpc/8xx provide vmap_pte_set_huge() and
vmap_pte_clear_huge(), add the generic fallbacks next to the existing
pmd/pud_set_huge() family and convert vmap_pte_range() and
vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
around the block-mapping paths are dropped, so PTE-level block mappings
now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
longer includes <linux/hugetlb.h>.

The fallbacks exist only to keep the build working on architectures
without PTE-level block mapping support. They are unreachable there:
the callers only run when arch_vmap_pte_range_map_size() or
arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
which requires an arch implementation. BUILD_BUG() makes that
explicit rather than silently doing nothing.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
 mm/vmalloc.c            | 19 ++++++-------------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..78689941b637 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+/*
+ * PTE-level block mappings for vmap.
+ *
+ * vmap_pte_set_huge() only has to be implemented by architectures whose
+ * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_VMAP_PTE_SET_HUGE
+static inline void vmap_pte_set_huge(pte_t *ptep, unsigned long addr,
+				phys_addr_t phys, pgprot_t prot,
+				unsigned long size)
+{
+	BUILD_BUG();
+}
+#endif
+
+/*
+ * Likewise, vmap_pte_clear_huge() only has to be implemented by architectures
+ * whose arch_vmap_pte_range_unmap_size() can return a size other than
+ * PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_VMAP_PTE_CLEAR_HUGE
+static inline pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr,
+				   unsigned long size)
+{
+	BUILD_BUG();
+	return __pte(0);
+}
+#endif
+
 #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f7aa4686fe5b..df37c8490ae7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,7 +38,6 @@
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
 #include <linux/pgtable.h>
-#include <linux/hugetlb.h>
 #include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -100,7 +99,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -121,17 +120,12 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
 		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			vmap_pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
 			pfn += PFN_DOWN(size);
 			continue;
 		}
-#endif
 		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
@@ -391,25 +385,24 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 {
 	pte_t *pte;
 	pte_t ptent;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	pte = pte_offset_kernel(pmd, addr);
 	lazy_mmu_mode_enable();
 
 	do {
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_unmap_size(addr, pte);
 		if (size != PAGE_SIZE) {
 			if (WARN_ON(!IS_ALIGNED(addr, size))) {
 				addr = ALIGN_DOWN(addr, size);
 				pte = PTR_ALIGN_DOWN(pte, sizeof(*pte) * (size >> PAGE_SHIFT));
 			}
-			ptent = huge_ptep_get_and_clear(&init_mm, addr, pte, size);
+			ptent = vmap_pte_clear_huge(pte, addr, size);
 			if (WARN_ON(end - addr < size))
 				size = end - addr;
-		} else
-#endif
+		} else {
 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
+		}
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
 
-- 
2.34.1


