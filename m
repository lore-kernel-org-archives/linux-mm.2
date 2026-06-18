Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC57CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA4E6B00B1; Thu, 18 Jun 2026 04:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC206B00B3; Thu, 18 Jun 2026 04:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A466B00B4; Thu, 18 Jun 2026 04:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5F46B00B1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1DC51A068F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:57 +0000 (UTC)
X-FDA: 84892405794.04.658DD3F
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id C87C44000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BDiCr+v+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfwAKcFuVrniumYvLLu8JFz9uYaRHWvyegwwsVszSZM=;
	b=UDLlBpMO7UcAJbJKQ9/ZKZbzCCD1OEW/vZ5qrfeg9julaC+0NqmTnNrN+RfmDcsZ38hiu+
	GCVR5HZor/WCFwDtVd9VUftpO0VhL2ASHxFX1tSprnL629jmtugz62PO7OrLcJKyN0H0fS
	j/i4FqYE143YDYr8RT44cBY6/k5lJQs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BDiCr+v+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772475;
	b=QRNZ0V323m9Jf5uj326CnTwnWOs8mYiUcxwIni3eLllhtQ0HIqXT3hYqcEzK+kgIrvZ9R0
	h0Gh8q3xy2nGE5wDtepBVwxIiSsNmOt9SVIVu9MMIYPfak1Z9wQ0aFwuFXj8cOpl0sMOTn
	A7mMWB+NKrxgkf9nopLj/B9XdaGoIec=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-36da8439078so544847a91.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772475; x=1782377275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfwAKcFuVrniumYvLLu8JFz9uYaRHWvyegwwsVszSZM=;
        b=BDiCr+v+LXcnQYf7fwRGkxiBhoZjxN91YiF+H/E/6RUGc0F2wRpoJOhuhVRYRyOhT1
         dwtRpu1+HFpnM/UKrFESZ7Wq/1GHdYqkkKg3bZ/nW2oKGGamMXYI/Kcp/8i/eQp87NX5
         A4zk53sByc8sXcJC62jFWcjr0iugxALD+9TCulcRqDxg3XhtQtrVNonV2egnrRdlApnH
         uw0Y2Kogx0wWkS8F+yGfF7RAHV6nh/gGj8NZxYugX0mEbE7MStYVuxEkXp1hGvgy+qwf
         zzYIBPsVrJBgpEAYLblw7m5YDkv/CbJef1oH5BG7vRlqzk/o0k9EUULg9EsnMU9ZfvQH
         +dUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772475; x=1782377275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfwAKcFuVrniumYvLLu8JFz9uYaRHWvyegwwsVszSZM=;
        b=Ez45ozmmaEp153xUy5jIUI+Ac2hRYXClvOL76+QE+mQeI6GCnLU/CPknU1QsseYeOi
         LqF1LhwmRy3VO4/2cHDqZyG+zAL12lsvdZ58MbaZez7CZrLfEYwrBOKs9L9Lthd7V8rh
         i3r7Zjp+jH44KWNqb4YkYA7KHMHqq6srNOJU2Rzb+sKpe5rSWQ1vcPv/qZixtDQHjv20
         0XN8ji2odmLVaa0/kycqEW//0Pvl8HHVMiC4taUWigAl5DEcagAPvAYhoRIEhz8CXp30
         3ILM8kncl+AbuJ67Xc92evRTGyKFxKVfTWURuB+NL8NAKu4q2fRwXL9yBU1bc7p9x0mz
         B/0g==
X-Gm-Message-State: AOJu0YyexG7WKumXVRkb/MFQgwZMPJz3qLtJnTYPUJVnV9ZHrMb5hAwD
	NYEVxuZIwRjlBX36325aEm2kUtF5XMe3xC3uKkf5AhjLZb0DVgmwoDb1LayYCQ==
X-Gm-Gg: AfdE7cmsV8ocTrG3WKcEIpqCYYHKX5Hj9TMDCIexotkVjGqxq2d+AiCKW+Wl95kJ3ZK
	oJT4G0KgNNljZNdO8Fd5gLk6pG+MlmP9G78G3QU/lDsqwqmK+wjU8NfMVWh9Gfca2u14NZ/TqrR
	f2ca1JucamUbYYEzx6EPVZudHvqoJ4AnvIKzNKKfKdn78vCskhpeSJSRPLmTMCsL7XbNAd/SH6L
	eR+iRRvzToSPse66m7FqExH70Vc9/3/EnwDUsn/t58Qe/2KshtLi5/oGXcxNFN6W5vDoeR6djHw
	70oR/T8HGLfuXrdRGWlG9EBysl6HjeSbkwEl1FaO7W09UKIXsB/+pujlND/RiDxpU1peQ5vfEVt
	5UAvINVtdjoAdhAvZYsfKoNJeKWPO7/iEx2wNTen7j4Dls/otW9RJxO/0vGwPHJnqey+AN8yCCA
	QExC4tOXIqZkvfO9vuZZiKnpai//eWLgde8/uGHKpka20pAg==
X-Received: by 2002:a17:90b:390f:b0:36d:635b:85a0 with SMTP id 98e67ed59e1d1-37c936a1d28mr8015697a91.3.1781772474606;
        Thu, 18 Jun 2026 01:47:54 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:47:54 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 4/6] mm/vmalloc: Extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Thu, 18 Jun 2026 16:47:24 +0800
Message-Id: <20260618084726.1070022-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5dcayqajdyugpyou4urnaxju9rbnzgoy
X-Rspamd-Queue-Id: C87C44000D
X-HE-Tag: 1781772475-181298
X-HE-Meta: U2FsdGVkX18CopZ1wrBXK1QcACXXLffXH2NgcsNUCSh69ObHu+4av4XDIIO1QScVNLpbw+zqzm+z58uA7eMVeAETn8qA2kzUtc0ZGEWsG6ofURdjLMEVf+4ZctH+pLfPECCgG3BwOkImFyiCkk/htTcgZX4sBDEQnzsi2ea/VqcvFsz+SQJGX/xF5R2E2XngueV1+yave6Bx59IJYKKPSWUgD0X6lMU43tokOQNQBSabH14Zgy/ALC2d/As9YuL+FsPi0rN1hEVy8EEntTA+tvJ5W5JDW754fW1QZLZ4LuPMjK2fdLnzg+PZPeR67J3sf59pCxApcS0M+6dItC2O1O1ydrkhkZlwenc6js+kX64ideuAzWqFqJ1uzBq5yO4RlmTRo918YZaHRAATN2dVFbx+0mKeK1CVKYxb33wG8BELK+W+xJpQ8ib20f6BbtgKVLrxqu4dhshF3XaayuU8jQNviD0nJMJayoZIISIz/pNVagUP03ykk0V1ItohTVp8BCVxE5Jsj6IibEj3ANZSPbtXkE9vD9JSMr04NfzEAsqxSXKCkyeKDFnO+8n19y69n7XYiEQkNm+Ktku+1cK8wyJqn5uOXlGEhgGG+x82PHWflfPtZwjPgTKiXPeSQInSGTTlaLO9IeRYra3vLd3aM+5zQIC3AsYw4XXc4Q4LH3S7rWd001J6+HsUFuzHuGKCfYWQFMwGtq4FiOqKmBFuLm9aJAOua49VOdqBKZhwkzUXHmGBnyXAkBVSk/FdLxv2KM2iUqjxTvD1oIaYl4kSN1cInjJCKa4HcKQ1o7icun9KqGJIwl+0GBS02ttavVBY1W+IUgvHYthtV60Z0wHWG7mJJUFltPb8sCkmdx/RkF6p/JkprZXZ3BoxmdBijwX+WIMKB0k5bzuJgDRwIXGgv/swIOUR1B5m1O9khAZ6Mp8fQSOUrKxkDFxfi86I9muVFq+5IiwDK8ylxyxRQXL
 o1VyjVUM
 Fwe+AcXG7BOQlqFW7T4RWKrnLhhhUKQeg0LwdOw8F1b024vmX8ygOeBkBywBrjoiqhBJqeTn2b+pnZwrIsYwO6TXr2flPbna0JhWjj6snTcwBsZUEHkIPaUQgNYyYj/1xEl+vI/MYNOFf+TNbOZ9YZf3iCDgDH//nBywfsOoCaxJcTgYDDeWUshQwJKtpVgva7QZeq60tBFhEhbMsAqB+6R6up7XN8nf9uJqxAxot3AwSNVynCWLceQAzSA4rswchOUyFKrn2YQoT3W0fA1wH9VsnpoPyGLf+ZmKXVWMBz8Wl9JQaKHf8p/+Nxm6CeERnh8WRYLAetmUOI8bE1n7pdZCa9FHrgQCdSzfhkXxZFAu/fc2bRsi0pjAyjToUZd6bZwnYZ2+gSfJ0EauoOAom2og0y07oLX17qNgXqhLevWBefQGl6mAJuEYQsvDWhQA5j+nO2hqtvKVvUO8wi3NezPfwgHBFeKCzSXhKP7YX56e+iCH5RtMn0BLR4h8fX8Knaenu1aHUxEqjOTQTdjrf3V74L81k9vJAoMkVKl0v8P6T4Vtgea8n1CuO7hBq7cZ4wqZ2kyPnb1IbIyaojOAjgJiZnQ2aukeszGHywWADS++o6nAxHhYBL0d64g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
provides a clean interface by taking struct page **pages and mapping them
via direct PTE iteration. This avoids the page table rewalk seen when
using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.

Extend it to support larger page_shift values, and add PMD- and
contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
since it now handles more than just small pages.

For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
iterate over pages one by one via vmap_range_noflush(), which would
otherwise lead to page table rewalk. The code is now unified with the
PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6660f240d27c9..253e017130e09 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -127,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -149,8 +150,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		}
 
 		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
-		pfn += PFN_DOWN(size);
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -542,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;
 
@@ -574,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			break;
 		}
 
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		pfn = page_to_pfn(page);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, *nr += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -586,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -596,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
+
+		if (shift >= PMD_SHIFT) {
+			struct page *page = pages[*nr];
+			phys_addr_t phys_addr;
+
+			if (WARN_ON(!page))
+				return -ENOMEM;
+			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
+				return -EINVAL;
+
+			phys_addr = page_to_phys(page);
+
+			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
+						shift)) {
+				*mask |= PGTBL_PMD_MODIFIED;
+				*nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
+				continue;
+			}
+		}
+
+		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
@@ -604,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -614,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
@@ -622,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -632,14 +656,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
 }
 
-static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages)
+/*
+ * It can take an array of pages which are not all contiguous, but it
+ * may have contiguous chunks, as hinted by @shift.
+ */
+static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int shift)
 {
 	unsigned long start = addr;
 	pgd_t *pgd;
@@ -654,7 +682,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -677,27 +705,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
-
 	WARN_ON(page_shift < PAGE_SHIFT);
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
-
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					page_to_phys(pages[i]), prot,
-					page_shift);
-		if (err)
-			return err;
-
-		addr += 1UL << page_shift;
-	}
-
-	return 0;
+	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-- 
2.34.1


