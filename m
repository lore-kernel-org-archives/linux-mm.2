Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBB8606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AXFs+T6V
Received: by kanga.kvack.org (Postfix)
	id 0D80A6B05B4; Sat,  7 Nov 2026 08:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0897B6B05B5; Sat,  7 Nov 2026 08:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE07D6B05B6; Sat,  7 Nov 2026 08:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC8F36B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A608212032D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:24 +0000 (UTC)
X-FDA: 85408457568.17.4E5817A
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id CDDF1A000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AXFs+T6V;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tSO75+dLoTbxUTsccW1GH3+P5H454b2/ssDfpBt7oM=;
	b=b2blm20agExhf1rmRjiBXlHDj/XbmUIFVufz1RirQu2G8O/5HffejfoKqfE7bHJaZTct2D
	S27Rgc/UBU+qVo/9AamfqN5AydltJLVwmgZsEOi19MhQ0Nibr3R+hUkCQNOPkeWL2cb7Kg
	fK1+li0so+IykMgIa/OTsptI2CG07Os=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AXFs+T6V;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059422;
	b=xmPKatwcvkQc5dmWVTw5lzWEjcCrm2d7RmoDDuLTDbZkcZIwj3C4MoKLPeNDvO+tN3btZn
	62wh0ju1XC8lsQ66E4Cl4fXoiZp4wFq0E8ih2nkREYkpXQu9taD/YYNODhHzSCkdwWRMQ1
	XHYerPijazEp/z+9WuXWRBvJ6c9lx3o=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36ff9c9da34so2075494eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059422; x=1794664222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0tSO75+dLoTbxUTsccW1GH3+P5H454b2/ssDfpBt7oM=;
        b=AXFs+T6VMJgU23z2qdgNs9rAMh4oecClQ07F8qIxKgdNRj+hOqmR1zDk4vIK1zC7T7
         So2Pyd0WBQH1XRht1QnUpXEmJTcO6CE3zMFgZU1POHbc5RDpwHDgHMT8wddNry+lvO4K
         Qy8a1e6HujYXOZCLZaoMCjIMh6nm/UfQmhcKCCyo98zOQIRyNJIlmBM58HKXh9glYkuE
         +sDkmqn/YTsk7ZPWasjgM2doNzatdXtZNa8KIXADEfNWjj75hfBHaqmsh8/GPesD+8m/
         gesjdCA4sFTgZh4eyB0IkY5sdev70Xc0uGmVvrGQdO1aIIcl59NqIuwhC1APxPuuHPKU
         Jqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059422; x=1794664222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0tSO75+dLoTbxUTsccW1GH3+P5H454b2/ssDfpBt7oM=;
        b=TA4RlIRVB+uQQ3CCQeaT7ZTm6lvS8auhlr5D/+BZMu1dJRr+BrPcstC9FMJO6NTQRL
         xkOqclXSG47jP0IETzKKKgCC8c60dJ3xbn+xRbA0L0el/JO42rEAhRmGVxuNwVPSPPX6
         0oOS4YbWClZfMA5Xq1KbhMK4k/Z2/Bb+RdFaQTTRRaYGemGP3/eGdXQh4XgUihIw6GVd
         13sb4e/BXtxSlRX5trOXjhxJ/p9Fmu6e2pm/aZJtN4g4tpFalA6ybB9M1LXwHN5Axi7v
         jWsQEXKf3+E2GP6B6X4xAKjcGPH34jpHunbZrL35CKZoLlzlGxJlRjaX9EIshaeVxqXL
         WPiw==
X-Forwarded-Encrypted: i=1; AL+hErF5uLq6toCLPKUrdvqfNEpWnLWf/hZejjDJlTxLv+5FTBV+WwGRutSDkyZVH23sw6ab6TOX3vIy9w==@kvack.org
X-Gm-Message-State: APuU4Z9oUtfAvGjDAKPwp8SAbbse79x2Z0FJPaogOiY92cVpC8Wz/JEG
	gKjkW3JA9LXanBTf7JCjlhdMoonL50cT3h2eMuaDw2sbgcGXzah4+aLY
X-Gm-Gg: AYBFou3TXZys4g1ag3/rcc5PhbJL3XLZ+jYp2X/iUgKvoKp+TSIATnIc9B4fKjTSYqA
	sbVCP/ZNLS5hPABGqXcbAv3v4hPgxfPlWWTQbEYhvxGjRYsurWEb0MEjwgyGQKFw3R1gxegI0eU
	PnJxCKwsRDUv3zzqMGI/NcUChXZbYXvmXDrhsFy1AaFLlWjc5zFkprfwNRikzCxLkR6+x4f/3ti
	MYSDtrf+P1qc/hI6FxRC5g9idnZ5CAhxudLko60h3i2sc9hbabKtiFJKjWW0Kq/RsPLiyKXcDwe
	UeHW3usczC4fhOOuNw+wIcGh/7FkkxeP9wF6ZQ58JKlubP/q77np2Q66SFm+GbYsasQu5UI9xj4
	V6TwxjjIEUKxd7RzbmqsZnQGnzqt4dopc9/Js4uT2FwVWNNKjR3ImNg/lElU6w8nfA8IhGFqCMe
	h/P1D2NHJ6+5D/gZAXFBPWLTaP1wMM6aziBgL9XzHK0+diZJu9nQJtL/5COcfwfWbDZwwQGp96H
	V3Ca+Itmsdyw4ftT8RE4gPe21mpIRhj7VsWYJ7vkb9i4VSpny/kHuBISU2wQx7nd+F6+fU+iCUR
	lTgp19HZzhpXaCnfESYBERButj6Wggd1H6LbgX8rXyNW/kUbclwH+n2aHA==
X-Received: by 2002:a05:7300:c8c2:b0:36a:2289:c599 with SMTP id 5a478bee46e88-36f76522120mr8195640eec.29.1794059421478;
        Sat, 07 Nov 2026 05:50:21 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:21 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 03/10] mm/vmalloc: use vmap_pte_set_huge()/vmap_pte_clear_huge() for PTE-level block mappings
Date: Sat,  7 Nov 2026 21:49:46 +0800
Message-Id: <20261107134953.748622-4-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j3qqj93eefctoey7fbs9bkd91d5ykgo1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CDDF1A000A
X-HE-Tag: 1794059422-759998
X-HE-Meta: U2FsdGVkX1+OrvtG/YKIQNPzXZtrHRWmgqoBzuC2jXwlLXCzwsfPKUhutgz0BpDwQsDmsok0nQGa0UHLGgd4+b/HUIuGfN//S0l53qBxPfIOKTs30/8dlnUp3qDfYPh8jx9s2rK1cLySoidRzmSFTzybSMHISSQSqHgpKDWgYQP/do6lOiNWgL3PPulVWXjZvvsh4Dd/OHitIJ3CPWGzIsUp2NvOAJ4YYpQsL+erUj5knk6Ixq3pL5Ma0b0ZVoDnQrwkxdSqqaxXIWDo7bigFdMleyKRV7XC26X+OIryKmqAo7WL6p9kBmJSrrPM7NGBsw20X949QccVeLWp1/IlQDXE9qI0mPDCMcd849lVZVAC59q0xyxTd3AX0rJu35N3XGtRFU+cBUSBKtPTmDI1A6vfSZ3kUdWAywuKeZoTURc6lcR3/BSQBwNAxkWGJWLlTuqQkXaJoxJ2Jz9dsbJ9vOB+etG/34lPLe3sFfk4OYfyrMpOkGSNyyjcXLHcPjnn3huM9tmyNOYbbtKx2kyDDTfut65QN29bnzy/NoiV78baZ9W4UHIwgGhiYmm4fx27Gij4BDHH66OmqSIXW2rxyPFXnoaJGtRp+fy91BLDyF5S5JO5dSL8ZiA3yqN6LP9ZXHfsV4t0AMIP7pqkFbzzXio2OAlVk0ul1GMHMqLqKYe8/8ayTYmMJthGG2CupoS4xZVmoXorI7kHJ5lRa7ewSzS58qCyGr/mZvy1hBc5y1eVQwf1G7lq31x5JoQKuDE2AzQOzdFrYZxM60ol6VmEWIwMB22L2A793rXcp2R5yQ6rsZQunW5/4oSHKDrNcc4gIraM8T28BMYMNMT8yPfR+gAnqtHgcYbixaSgPiMptv4iPNia1nqzRDBQcmEym5dC4vaPqJn6CFGDzX19H1UmWBOYYbHIzfhQq51qZBaHCtHZNIsBJkLDL1GcpTbXdaJmdm4FaHBhIF3LMmwbE3M
 bSU1cho1
 h1FN+/fXfVYaGY2rR0kSUm1yibP6CQyycX/tO/eBQsyMKiRsM94rGwrMZlxH4LkI1VkVZ2dcR0Muufc0cAxN1WNNowzGArP1PnDHLGCHTtWGiCoxRmicQeTY+xUAJ897xfViCHvThSCnNTTkIQjBwxtO1VeAC3QMZcnwGJKwL3c93faBTzk5OERMJKpgmTJQZ8O+6jS/gSpbGUMFuIvK47YeGCGCFCSi0ST5HvI7ucpBAqLHis6zwOA0KiylNMZs2YgNHHMARc4TnIj3QvO6PJFyvHSZ7gGxpn/lS5gZ8AU1lHCJI5K+vGu7Wea8/8UnkMSKFjqtJGv6hB6Zx/u35S3Rz+txAU7K7yfs2HzpqWzOueCiD0ZGG4e6nEndmW/v+SiWYEe1+GSBVo+Vhs79yrvuYmRfZN3dhSumlgrOop3ppHh2lR4/q7z/zv0CBJ2REl8nOGxRmHkAU6REZX8ZEkTknDVbzH7ysAksDmLceF9ttXsKNC5p7fXCaCyWtofQ7vL5YpnO0HcgQ1mh2uVxCn0a98VnZ3vHIUze9CbYTXb3z+QOd6kopf4DzPNbA/pokIfjtHvK/dzIdzX0=
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
index 780fe849ff8b7..7e62479db5df7 100644
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
+				     phys_addr_t phys, pgprot_t prot,
+				     unsigned long size)
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
+					unsigned long size)
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
index f7aa4686fe5b9..df37c8490ae7e 100644
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


