Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF60606EEAB
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wqHDnZkI
Received: by kanga.kvack.org (Postfix)
	id 18C706B05B8; Tue,  3 Nov 2026 05:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163DD6B05B9; Tue,  3 Nov 2026 05:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051E56B05BA; Tue,  3 Nov 2026 05:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA13A6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:17:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 563BBC037B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:22 +0000 (UTC)
X-FDA: 85393405524.06.018618A
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7ED6840004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wqHDnZkI;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIqgn31oqWqTiWXF2IW0vHwpw1vMj9WhwN7adf+gUg0=;
	b=OiqZZqJ9qyMLtme7Bn1LsBe5ZOLjyjl/exLGc1ksL5VvK8GItyzXNd8jUPh/Z6eTPFrghE
	1oAfMQXiKHQ0qaQbb/35D4z/3bK1PiTYGHTxOB7EqeWwvpK21qTl8DwUsz0dfhsTq9V4hu
	r2S9RlCZxJq9umJJ+MEF46bC0fH+Clg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701040;
	b=tD7lNentS4/CKvhR/qsdEg4fhSej0nG57BEFZ+Qf7bLavvOXHVXNaF8nn+gnjFy74MMKn9
	/uBkM4ZLlqeAcsbBbMhVtaADLwIpDlRCu7Hco0Wqe3gJCIqLYqfy5fUGOXNPiGMEz7G4oQ
	4ba2kRf171yvmOtGp7J4hPOnexDVqfk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wqHDnZkI;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36a1947498bso3892729eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701039; x=1794305839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iIqgn31oqWqTiWXF2IW0vHwpw1vMj9WhwN7adf+gUg0=;
        b=wqHDnZkIdFJdqqH1vQUXzq/0C0VCFeqZ2rtKBe1sszv9JeBx0Ebt2VDPAe+nT4OWt+
         CH3xi0iNsBFGNvViVnuVHckej65qSB5FPYbSxL/eCKr34RMPFerZd44VJ+x9QVPGytH2
         MXMwOkITChv5KV8wqYVypKnRHYFGn1dI80r4kTJ/U3JC24ulV++c3VV4jd6ORuN2MElv
         XwDpU+QObCVm9x0IhlctS7Pgc9Paa0eAckP31cvR7NVkSiYKECwFkgjNPrtTeYi6aKx2
         53j3aWa47fp74xFh9r7aEQgA7QzvoIXwWoqYV/hkfW45ryok11kPn8fKLKcYqN/PtB3v
         bVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701039; x=1794305839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iIqgn31oqWqTiWXF2IW0vHwpw1vMj9WhwN7adf+gUg0=;
        b=Kx8clPuL6D0BMM6jLkaTmnLuZuZEmo+Dwqg8IbZZ8c+VqTL+mBjWMRjui85qIjW3RI
         lphWYrA8/MKZMrRZA53mDoVm35Ddq5iKlxzglceFp90e1mFprzDQm4j5qQy9Q2oMMpgX
         w1ihg2Ygxp8uFCYpvdJpWtID6GgjR5ny/2fAND6GA/aOu2DXW1kyfOqyAWYH6bJleAEx
         WyeHBZwfAK9qFEBpfJUDPbEiWAob1XixIjxmPPuFiLkOhDP8+aa85ebmHyqxXcFXV9lA
         A6k92Yw4+18xK7Zfh/ZUDZ+/h+HPoKYLTQaZ8coZ8G5+sEZIfZNOx8em9zHV/zmrtOfC
         dL4Q==
X-Forwarded-Encrypted: i=1; AKwUvBygGJhh+8Bopyo0upIjk5X++9SbuLaNt4I8T14GZYs/es1lEZBcjsSTwdodARClHWC2cbGKdgEunw==@kvack.org
X-Gm-Message-State: APuU4Z/Bste6ZQggN1KcFmt4vLsqDOf3tygGFKjRtRh+s6u35+of8Cuj
	/W5DpzzC6cHismguAFNIyf+zo3/U/hOsRG4minafmO4wm8gVgf7wvB1d
X-Gm-Gg: AYBFou37iA1ZnktMi0Y7mSzmcSceZ1v85XPNUwRQhAcokT9QB2Fu1cf+nW5TmP5KA2Q
	1yK9srsQOupJRGAQhTsZor55Lx4YDcJ9hlckmVMzfgOlsSF9udG5z28Ydd/2kUnAFJL+R1AGyXL
	i2mXLDuOqePdiSEplJnoQ1zlAw85fIUWkRhIhukf13NlYLSMowR4Ffn74fJi2fHWECfNPWIjixv
	0dsocWTrD17shhlvYtEUs8FI2ZEr8hz/qzTgiKjJziNXowveggDV8MaknRj/X8C5cykte5ugQ9p
	mW37QS4Y4Vjl+YKBXgclkhApXtocAYVffae5xwrCs67RVGxmFzFcYA4+HN7oZnk2lY3GxGZ5+vD
	OXNZ5WjBAw9YpXDCinCqIiBjI9ZUNbmDMtFtn5DDacG09PWM99kBcBwc6iKLrorG6KHN0NrDzgn
	1dHy0jCuwRYxjUggO6hLPV/DicoIk6ZxezAqyvr8bCQOBp6jLjsDp/KKFErmQ+PSTsVkCIrcbkB
	ZJO5S3EFjqYOXEB0PoxitDRGOm05/doKsCzrSuBbPgEdU23SKPn8zhm/+3jElr5ZDwgmrecj/Dt
	C/Vzx4igWODqQWCp1aH0C5anevBOzQ==
X-Received: by 2002:a05:7300:471a:b0:36a:2382:7dab with SMTP id 5a478bee46e88-36a4232cda7mr18277051eec.6.1793701038947;
        Tue, 03 Nov 2026 02:17:18 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:18 -0800 (PST)
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
Subject: [PATCH v11 01/10] arm64/mm: add vmap_pte_set_huge() and vmap_pte_clear_huge()
Date: Tue,  3 Nov 2026 18:16:49 +0800
Message-Id: <20261103101658.766905-2-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: rb8u7xia4qpi5i8t41u5r3zcs66xnykg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7ED6840004
X-Rspam-User: 
X-HE-Tag: 1793701040-137753
X-HE-Meta: U2FsdGVkX1+8TMwtu22fPIxTc+rzCIpAwywh0u+ADW47TFqeOKyYPSm70D+jFnb47rfY3xRqAtaZspTlh0046+HLx9WXmDDheUb6xK31+Jj3sG1L+msdEtdJVix5bBxMDLAjASwSlDK6+2PZ2+oxBHL8mVf4hquSuBK58w1Q869PlLaAy/B+QdcaHT8dJH9CvGzwbmhTuFJ0ePpeZTQT4xhendQPyKmc6bxBfN2IR8H1IIXDhY4neAfLt9jkriwcPDrkuIZ5F0oTyLR5mqVr3loRuL0BTVA/zlw7rZdMD8bB5+uUjl2+shEVSX9sZccrsKv98xVBGeSiDi9a06xu8o/jyV2hLI2L80lrKRM225sIXzrwrPQNU+CeqeoTj6puToNBUCQgds23HB5vG+fIrBgYDHsJ51xLVVoTeO8EG8YeF5JksAtb8b7NEPgH2gMrjBPvR8mEnNKcZyY2EVQpvCkmdmtTewMRiOQ7+Ml3ViJQbxDgzQQd5GFGB1nBWvlSewzfXc6m9ENd+gXjL6+g9KPrm5wDFGqB8Qh2KO4bhg7Pocl79iqn1WOdGHbjz4igBLyfCcfLCkHLHjJZCKdSO6782qtwZg07nUD5YW25V0g0AF782hjzeR4IaT+zPIvkvSia8x2yhKw0dndi1CJwn9s0rwHREKoRXQQTPTYCyMzivKeVcxk4LpEtBv45qcJM0TFe5Xrj+nycDd02dhdRIPt/7rGV1oiCcHWLXhvhAjsgcPyKrpyfx1QtP/7inJQpy1uTllSGfkMYHQfcXE0ppP/vuW8j7NohFuL0vPD66KUHHymAitTqYiUDltMkfqXNnabLIzoraCwNCS/0XDDKTabgRBqnRUOEZr/GTO+Q0jdhodBpvkK441bf35WoRhBOMNpXnXbDD79AzydGoFLDUQZKQq8zxJzwwH/sQx48dmDyO1wd2okNQfzBHuylHWwFWmOB+TPXk64d/sU0Mzs
 hRAIFUSr
 ceaWe7wbM8LqXfwspPzWBjXdEPdKA3E5YOmoXbJuoUcgvzQ9Hz7yiExBvCZUn5Bw1zMb4qsky3var5EKDRtrGGeTPziIcwwAxY80162s38VRIoaVAwkU1kguHox5j7GA4EYrfIgHq93i0Uwp1ThObNF2+wwh8YFMBiAJ/J66NvL86nH3wAtZXfdGLfDMb6OXn6CjPIb9rf+fyZDhSOXEhGerCs733HqfZUfj5Xp7KnZgj5XpLjVKTakkR+kZX6LaYDCU6L+zMOTSZ+mECSpnfZ+Zerv4vZ7Oopp/x/1ACcymcI2AYs/EahOo2Ls8jb5D8mnu4nZ/1pfOcN1pSoDl2tqpB1w5yyU7hZeRvjhKN6j+XFL1Cdb8lMveHKDm7SrpeYU0ZV6fYsmDh3GBF+6io6h05/LEajv6CrwI5GVbl9ojsqOwtDq3tcIRWHz5Jf0smDd1erizbvSDZ3SE/60Iv5BCr+dqOgt3j/4Mlg0UuOvQQ4HPvI1/qMA7YuwrghP6Z4dyzqZLVwRE8Ckt58tqmBVZ8y1k81ss/MRC0vCuycmf1M1RPit4fM1dgEVvXupp32PlPMUo+Wq/8Db/Ihd8dcczsbxTn9qu3hZTZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
HugeTLB internals it does not otherwise need.

Add vmap_pte_set_huge()/vmap_pte_clear_huge() to arm64, joining the
existing pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
__set_ptes() and __get_and_clear_full_ptes() directly, so they do not
depend on CONFIG_HUGETLB_PAGE.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  6 ++++++
 arch/arm64/mm/mmu.c              | 28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485a..fe138590972a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1927,6 +1927,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+#define __HAVE_ARCH_VMAP_PTE_SET_HUGE
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size);
+#define __HAVE_ARCH_VMAP_PTE_CLEAR_HUGE
+pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 140520b351e2..2929bec8821c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1912,6 +1912,34 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size)
+{
+	unsigned long pfn = __phys_to_pfn(phys);
+	pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
+	unsigned int nr = size >> PAGE_SHIFT;
+
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
+
+	/* For vmap, there is no valid -> valid transition */
+	VM_WARN_ON(pte_valid(__ptep_get(ptep)));
+
+	__set_ptes(&init_mm, addr, ptep, pte, nr);
+}
+
+pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
+{
+	/* Kernel mappings only */
+
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+
+	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
+					 size >> PAGE_SHIFT, 0);
+}
+
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
-- 
2.34.1


