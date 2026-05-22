Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC779CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7B76B009D; Fri, 22 May 2026 01:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F466B009E; Fri, 22 May 2026 01:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E256B009F; Fri, 22 May 2026 01:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09EFC6B009D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1B181C1619
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:14 +0000 (UTC)
X-FDA: 84793934988.13.EE28185
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEF114000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=saTaeXHU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYmJyQ0ywc8EPBT7bjoKD+k2F/54dp54XhgQCkuTPK4=;
	b=5zSupLUGhfeRgpBtel/7aDnqZOCt6pGXO6sxV/7GmnMHeeYvVzP3q2HaAWpro7a1vd8pfA
	ALTY3SFTxO9ZSOtYfiy+af1GGaSwDqZAu5OnjU1N8FI8gLvvByh1qgZafEyHpGjAH+eq9s
	NG4kTfj/mQLjKgUtJpEpmTdbuVCSgts=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=saTaeXHU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427932; a=rsa-sha256;
	cv=none;
	b=xetqfgnyObMwQ9HYkMmX3zAoUWtp/7Gkk0cjK3T6LlSNRou6tnglkjPbBjfi2SX8mjCfke
	+7GzpFbPDRTWhb4DA1f6wmwioFNjFPye3/4oRAykfVaxUdlhbMirY4Q3+gTVTfgKkEDG8v
	X856nScAU/L3Z2dRBEkg8oM4xcF+cdk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bd2051167eso32367355ad.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427932; x=1780032732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nYmJyQ0ywc8EPBT7bjoKD+k2F/54dp54XhgQCkuTPK4=;
        b=saTaeXHULSARVD/DUjnCh29rcaXZS6UaNQO9kz/VLOvdQgdtTw/MXMmTjt9bn4R05o
         keTk8FcOgbMOFf2NMoqNwzcSb4jym8aEQ8lPk/BWguNc/bbxhrl7GKUjGSAL5ha32KtL
         mAzwqlxcLZCEe9dG2Z+t7irzZlGYTPYY2LzHfqynnz5On730ogm+n+oyM8JMd9EX3iSl
         01ReLUgchMMqNVRa/2Ehu55qDOCmv85e0VpgZhWMBJmG1Ei4KJmOs7qeRFSH+zEXxE1Q
         6xe1jKnO+vIcoWydqMpzE9QPVRFec8qEYtrNI6LY9L7o173YbdqgJ4HUZwTG3gtnmksb
         qTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427932; x=1780032732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nYmJyQ0ywc8EPBT7bjoKD+k2F/54dp54XhgQCkuTPK4=;
        b=kJQF31/4+FLDKxxoBw6bYUhujCyzRehM+BvXsWBh4mJOSedUGVIaa5GkEG52td61zd
         uEvj3MWaCiBW5zz9nrGFU6bwXxHfVFwUzpZ4l1Rp0ytPHe1xJD66oJ1xWVRGvHSNFr6X
         ++3el9S0HCc/yDEtLebc/4Fv7TouEE7B/pD46fFPKOlqmKIsLGFWM03kZUS6CgzxUn01
         Qx7pEjs6Xl6F9xc4uKw2Uoz5KhHjx1BLitIjuBFg234L784mbg2Pv4VL1Zv+nwkdqU+o
         j1K48Q2XrEWMpkqVAaD20DtwCBIjzwhztJuaSIA8cnU2IWm5xYayqLMrYJpE9RSTtX/M
         /c5Q==
X-Gm-Message-State: AOJu0YxvymkNspXv6703iZNQmtWryUXa14JaNBFWk5xjE12efcWPPyPG
	mMsr82J2kzyv9zn68Kc0H+rsnnOfqr5wYTBVeQocJuSjCu4dcc5cjj0DpJZ1v0G3
X-Gm-Gg: Acq92OH18YLzo4KkE45VrX8iHu1GzY/RHFDT8pbggE2h8u7J6tFEhCHIJCLLCC05644
	EYQI9zbje/cOvHfmXgqgALTNC0BR2R3FrlKM5QFeVhKG3bBk+7JFNmCbuhZswDCEMCA8UqEnzKK
	DQ/32fZAjDJDYYNSfzJaeamAHbY2b3CCiJuKLCdK4DAidBLu0tGCLmToLZ5oVitErm/G/dXFDev
	qxnWwMDNXjO5LrCErMNWu7yLUyQzIQViYyxXjOlgDBF2QeVtjvdu80/dh2C9KDfsE/zJcqM1Gad
	tPN3JG3lhpYf5jX38bDFD9BnWuw0B3LlqQnrxCOBuGjymOXIgpikMrPoF54D2i4+1bVexfTcFOv
	f0hbY56D8fBXSU17Y/pW+iaY1tVtFHcfWfmmhjubOWDZB8w3RuVf6OIX64495AhLhvJnCxxem/c
	4nI8J2SmvnZkPzcVArRJYe8zqazeptBmS+MSQHbGZkAK/GKGiljGY=
X-Received: by 2002:a17:902:f544:b0:2ba:6ed6:aa35 with SMTP id d9443c01a7336-2beb05e4133mr22071865ad.19.1779427931640;
        Thu, 21 May 2026 22:32:11 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:32:11 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
	jiangwen6@xiaomi.com
Subject: [PATCH v3 4/6] mm/vmalloc: Extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Fri, 22 May 2026 13:31:44 +0800
Message-Id: <20260522053146.83209-5-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEF114000C
X-Stat-Signature: s5s3mfbgxgzpmo59idwyg1zib6q453y6
X-Rspam-User: 
X-HE-Tag: 1779427932-513390
X-HE-Meta: U2FsdGVkX19+5lvWE30McAEALRMS7z8myvAcxoITeVJknUfpCruMtZ3nBLT25+CFbVV9OFaU/4c3sb3vhAnqcsjKnryKJJqZc4GdrHEbY0KBAmt8433GZBX3cdMQJU/zR8iqu7qrmhPqe5cPcKhVZmn+8EzkVP603IOkPB8aBQlU2n73tAjQ2r2mM4EyMORU5vAMTcesfAioBGCMIZB+TgZmsr202WVOlxsn0B2QZG08h9R54cWNTFFw7KVemLQ4ygUeivoEFbTyLmT5N74g8iY/z9PwqbcoA2A+ggTM/fVRnlCoTiNEDSRRynRgPWXSgUoEUi1NGfE3ET6P3HOeFDN/wqZwc/YbFrAyEH7ngd1wKT7XaHxwhbuJczFumhWSbjyo8X5XHaU6vJ1OKfn7vM9zgJGiZL1VUnZx5NLWrpD0/GpNAdWtNS39+TW9ZfFuwqlAMNpkxozzK3mUS6kbxjITlLaibJrrxGpwu/zKi6CWA9W+UXMS94npor7dihRZk0xUp0xfoiKJoVNOZOxD4kRxQKGtVwSj0m4JZxs1cDuo/NRBEH8lTf1f+Ox4IP86zZJ8f6aBfgIhqZIy8MQu4XNU/LorDwkJ/sXaAOv92+wn6i/Kw0MtFIOG2c1LAX+JbUxT0p0bXjGx/woDvj68DFjKYy9oPBlFTz5UIUN98qEmn9Txak/3RyKci0L+FeEkepU8avkoJM7stMNYzNsip4Q7JhBuAbB6f0hiK/S5xrlgCyryCyLAFHDejUd0hiBwcWiVBeMq1FFGxGTR6tt6f0WU9JaVfBOZOHVQk2KiEQddN/YEzoBi5H78521BcohmAhJuj/GoCeUE1ybD2GHfQFjMGuQzlGLor8VnPLZz06ldQThvz/YA0FEORmHz96WRGUGOe5jXAh8KlBczt+EAqu+eHMshAmJbWe0+fMUxIdOdYZaxre6dTi8Ndz2k+8hMUjgiJI1OdRILsIOWgs/
 2pYPznBb
 LJVI9zezYu3/MtgLD/C1VKDdSYS8HpPf6rDKy0O5/nf+T9NwsJYGKo1QBoc2nxYfk/toBlau2lcyx5kJ9oECEgYEoc0Tw9XukwpGbJ4jPl0wjnsLOOGty7VlfLXLYkpR3VAyMYPWEpiDmtg4f/tRvGtUfVa4G6SPvP2nrc0O4oUfwgCgowMO1pnrPWBMMZwDo4AlxgqdLmoFheTFw4zLD+ImOaBYfdhj9CqIoo0GpFd38wt1s5g/iXCQ7/bDkIm7FBS78TYBdZTKqor7RP6EAR8p3GCUf3j1apjTx3aIdpl2VLFAvsv+Yzw5HfQd+KnqIhK93Mh6Bi5+INjBfx9ejWzdkRIeBrsHJlgv9k1vIZLgv46xwJXK5uvyGDEUjLSA5f6LgY5xCFoqmXC6tYcfL4LhdUUyLx0w5HlYrX22t6X9HKGhbK/zOL4YhMWl3pINnHoE6ghBWA08ptLiCQHJQd94JUhZbzPhNqq/VoDmizMnMt7mPnUsd4t7MhdrPXRsXJ++pdTk8BxK1tByOrvgz4iNO0XBZu3nsKioreLVEH1D/LI3F2IvZy4g/Y3U2bXtmqd1wMMO5vFAyUk0=
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
 mm/vmalloc.c | 71 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 31 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 53fd4ee460ea4..deb764abc0571 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -543,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;
 
@@ -575,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
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
@@ -587,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -597,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
+
+		if (shift == PMD_SHIFT) {
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
+				*nr += 1 << (shift - PAGE_SHIFT);
+				continue;
+			}
+		}
+
+		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
@@ -605,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -615,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
@@ -623,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -633,14 +656,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
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
+static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int shift)
 {
 	unsigned long start = addr;
 	pgd_t *pgd;
@@ -655,7 +678,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -678,27 +701,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
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
+	return vmap_pages_range_noflush_walk(addr, end, prot, pages,
+			min(page_shift, PMD_SHIFT));
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-- 
2.34.1


