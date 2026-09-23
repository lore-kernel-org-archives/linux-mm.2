Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EA6C98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4226B0096; Wed, 23 Sep 2026 02:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E6D6B0098; Wed, 23 Sep 2026 02:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939776B0099; Wed, 23 Sep 2026 02:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B12F6B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAF7C1606A7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:59 +0000 (UTC)
X-FDA: 85244049198.23.5D52F7D
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id 193521A0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CaT5ItiV;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFifGOrpSVWAs42j7AiNSWIOQBImLaH7pX+Uvfxk6V4=;
	b=XlXZfPz+7C9l9YrnY6Wo24HW/2wgiyhR0bgyF/JHk+KDNFIAO9me6wbWb4YGkU1u9qOuzX
	1mSNc7IBjN2oYWi8IY1C7CaGIf4SjmhhWLd+Isyz9T3uiIbJ/E/dsXUcYGSolhGY2c03nM
	yoFz0BJ1NkMqgHmlx5tO93YW9Thd+Eg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CaT5ItiV;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144938;
	b=C3YPRFg6Z2htIZ43L/h4lbOWbF5kl0LTHxwK5f49KoUT1lNcxbZ8uqi7ylAixSIwcLOoYg
	XPTM65lItIpmecGPdAFvHyxsO4bMpPZExxW5UdStrvPv7Wz5s4pMxFHVcdbKx/gRyrEwV7
	0XHShyAxoEcKvveACyUuO2JisQic0Lw=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d91ede8035so4936625ad.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144937; x=1790749737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aFifGOrpSVWAs42j7AiNSWIOQBImLaH7pX+Uvfxk6V4=;
        b=CaT5ItiVCeTG7/xr3cH4m8AIvQPEmCZ+rlEZRcwlUVUiDZ+LcjMT1oTQU3GJ5V6G+3
         j0U47vK+Qmf3bs0RWjsVBJmSsF6hYm690OgafbBqX+XVBIoSdBp+uF5TPR9DS6BP4xKd
         eJCtBmjXVej1fZzkLinuI5m/Ge9Mpc6b8MJGl7q1dXLgNtRzuWpDV25VIuUOzhSr/0c3
         +AkCTu6oiEv/ei2KOON6diIcw6eG4UXsosMwv+pcoWibQ1GYjgRlPoo4EcVwAhwL+YKR
         prS9/1BWKkkJE6/vTN4+IK0pubtNpMtYQu1f/bcTCUdcgqPd5nQLmLdbNajvfsyFk7pP
         vGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144937; x=1790749737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aFifGOrpSVWAs42j7AiNSWIOQBImLaH7pX+Uvfxk6V4=;
        b=chU5CeKvKFe022M0W7JuxDKUlouM5BzZXRN94Mu0kaf5tMZZlv70zvnecLPXKkUO7E
         JZsCom3aSpasXbNbY53cj4uWb+WD9Yhcyxsoyh7F64ouMMEJCjKWRPA0L/53VQwc8TdV
         wp0IvmgRCvH5YxPRv/p8ZRBm0EVAfWsq03PlrV1rb82+8AAEswzR2RjsAQpAXtOrxFnu
         V/iMWfJdcBrgp0v4iWDqO5TbxeYhiXa31SGHDvQdvnrRjxEa0AtbGgkpXMhlgbySj8Aq
         7Q7wPMBQL2+5b67QXkAAKUmlsTnZVBTvBZzkixOJMVc9Zekuthowd4Cn1O8kEwJGf7SM
         DcQA==
X-Forwarded-Encrypted: i=1; AKwUvBx5jwh3+FBej04LZyzIJf9GRJU1O59nc5I2p3c8vSyll4MHfKZp/3HgDRXLeD+7gW1fpLcEL71aEg==@kvack.org
X-Gm-Message-State: AFuF++k99fImgX1hHwkGPwIVzbHYwTC8YsYb88KBASN6ebY+BNByaDi1
	TFjkhWEcw0RYJjOwYe9ISznnQzxykUeBf3IYUTElaVt+Mc+L/2xjnI99
X-Gm-Gg: AYBFou2uV9ZcSvIYL4Aa1848sqcS+JadruFzFCz5RRkE1iF/ZOS8XuudcMn80AtQwK7
	qaZdIVguBIAS3XV99uNjtNhdJAsCdQAcQO31PLXCQN2YyezP+1kYWnMkHt/neh5oVOM63glZ6MV
	2hphtwSf97tg077Mw1larNX+cyiH3yqUoZ+Q+i6T4pRvYNGgrKccq2ClXsF0qMDV7ZByj7R4X+v
	p2gdELpnMZCeOsdOYdP4kEIXG5EcXEROXKm5DVYtnCPlKJxHM0Oomc6jlMS0/RzNOARJqUA0Uh1
	kYsmx0Gi51yul//2FVIiPU7FrJ9dNpJfPAIx1x5+InsDZ4gt1girWO11z2TTZLePMCrNJ0bzjZm
	+9zPZ3s3DNPkog5sdWhnIYWfQckeLdeJ73X+966cg89jEkXgbFUzoAakNi8mcKcL/n+n5qJLxDu
	yXLMLX7K2yP/+IUWxwYHMAh/wXPl6+nWKVP0cH2mbeDpskRxOe90bfblifTzTOko5Yzc5e6GtUV
	AAQjsao0ET3nWoe5G/wZIwvbDOBwufT
X-Received: by 2002:a17:903:3904:b0:2dd:c100:9435 with SMTP id d9443c01a7336-2df69e02500mr15989755ad.51.1790144936998;
        Tue, 22 Sep 2026 23:28:56 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:28:56 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
Subject: [PATCH v9 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge() for PTE-level block mappings
Date: Wed, 23 Sep 2026 14:28:25 +0800
Message-Id: <20260923062832.479455-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 193521A0003
X-Rspam-User: 
X-Stat-Signature: euwu1k5whq4n8fisfkor7bo94azepcrd
X-HE-Tag: 1790144937-931057
X-HE-Meta: U2FsdGVkX1/os8EyUyKHZwj64o3yQf6BPrb+YOUqAZAhQZiT9f8VTlA2JbponRCcU0Xc8feLH9zZXjxiTlzmSBA1+RoOK9F9qYnOJ8JIXtyw2fHOzK4T/zhoanAmRJ8/z/+ec4qwX2o5uZHQcSX0LzxciIdB4ERlWnLVxcDUyrxoeow8Igr7+MHocmbXiCu+jVvfEl2DFCVnneJSSrkM7c9NGN3RqSdCvXMSQZJTlL3yT1F/lns/1TsRzRDPWJn6neaCK3euM/Dii1hN3HlA1lx0QVQWXclWgccHVCX00LDJBa/MwuYuxkKwMjR0t36J27JbbyzWq6YIGwrkks40aD/v3gpr3bqK/qbKhFDLQktqUIyDGNFEhdKnVs4w/2hNLV8tB/InrVZlQzBwXzPOacPBByxk/e/mIEACLrhZNamcu5kRqbJ6vFgZShyX3Xc6WvoCbgiLBZbt2q52KwR2590sTFX8/+MnbdWVsebA17hRUMNAVA+4mEetVy3StcaCpjAOyLoNFkPQT2M/M57sNVb+ej1BuK08hWCS1VDUx78/7nRkbbfbfclMemN1+KRQi3TQ3n+9GU6X3fs2/s5GGpAdCPSrRz4uEPXSsiz3gCY9rIvB2ONHcXfMUdmYCJKW2hor2df19Pnhp7BknHqhcQRHsMdbM+UWOl9Bvx5KoOoeRdRYA98BEZx5yTfdQg2KskcX0JmYZrMvlIAGtYSaWrdSe0ViM/FxIaAa/8QfAUFKtBxMlkEDt82/4Iqch9s+1cbMRqETscs2GejOfsNDMX/176Pr2YXfgxXRI1t0cjELJk7M38hW6YhHXTFU5OVvxWKMqvFK8RRpMhx+pwgyeAXM+Z6NpYgQtXHCUzVXz7myeeYFelDqC4Vs+RnVe6b0TW+dRHNC+pTNMhx5Fu+WtZIDwmGVBmf5DV4eUA81BhYa69FolzYERpsc9OO9GsnxXCLFtBNPnppm/hvRjU9
 f4/hgLIs
 r4j/zQmr5hsB2LErouZKkI+cDlXb3DkjjUEmoFX1258S86jiaJ8u0Qti5nop+R2ib8saAmVTtHpeO7ilZpNDmrBCzjcFAKoeTffK2pzkMREnPcbdKD9ApjghmT35IYOT+T7VxsrIU3uhqPfrkVcu1lRwBEGkrknWP1JTWgCVUGkjz0kiGQZl0sLWlQXJjM+Csb3rb5GVzUCoOvqEZeu08QyRyOAQMFr/ifZI8hIyaskKbfMcwcGN1bbD2kW0AQw1+AdlbPuG2zp/JhZQAGdebIvnvhnjwFUgOfu09Ntndgj6CVvSZiFqcpQeOcxWY50nwtVTvELZ6++/2jYexK4ikX+KPcemate2oT/CwLJMOs/WMJIG9UPc5oWXUBcovwUTgSWheaVGBvUuF78fn6EBEsce/Av7lr0vSVXtFtfIDUuV0gQzrjESznuvQ0bMlZADg4g/EZYj5jgJnsxDdGAj6dMJCXziwtCu82oPwZCMO6CecoxMG5yXQY3LMWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.

Now that arm64 and powerpc/8xx provide pte_set_huge() and
pte_clear_huge(), add the generic fallbacks next to the existing
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
---
 include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
 mm/vmalloc.c            | 19 ++++++-------------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a8..a7fd51fec8a17 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+/*
+ * PTE-level block mappings for vmap.
+ *
+ * pte_set_huge() only has to be implemented by architectures whose
+ * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_PTE_SET_HUGE
+static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
+				phys_addr_t phys, pgprot_t prot,
+				unsigned long size)
+{
+	BUILD_BUG();
+}
+#endif
+
+/*
+ * Likewise, pte_clear_huge() only has to be implemented by architectures
+ * whose arch_vmap_pte_range_unmap_size() can return a size other than
+ * PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
+static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
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
index bea9f76ed7e74..fb757d95bde25 100644
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
+			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
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
+			ptent = pte_clear_huge(pte, addr, size);
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


