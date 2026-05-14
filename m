Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C8FCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E526B0093; Thu, 14 May 2026 05:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15A36B0095; Thu, 14 May 2026 05:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04716B0096; Thu, 14 May 2026 05:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2F876B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:42:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B3F4401EA
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:01 +0000 (UTC)
X-FDA: 84765534042.07.7A9AB46
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 843A54000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mkQlBqa0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAa7S8+lmtacBoTWuk3/nEzfs1vLgSAXTfB0g6A9cN4=;
	b=sdKnyWO6bJPuiPxy9tWKFzFmraJS7j/3QqlgQiLr3A2NEYhpTDPxbG1Jdm7+OsWNGWmL25
	35MIs3k1QCXF3hZeiU/wuod2NEmc3qeishTgRx2CS4eNc+8T5n04a9DNWlGzvSGJEfc1Fb
	GY76cce4+p9t8laO8UkQaSrSkMUJVU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751719; a=rsa-sha256;
	cv=none;
	b=XuZQitgKI0cbpnhHOxbKeNGMuW+48xY56wxo2Jzqp3XSejXRSkHVX5zWGLyyF5qgRNBRzB
	+Eo8woLu3xlx1hL1hGJezIuYZ0h/3d4eRg/KHmo1mmxe2uqJG97iVYN1C97RYhtroGyqcf
	3Zq7PT5EBy2GQRUt4rfQfTv8uSrk8u0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mkQlBqa0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-367c26471f5so4043588a91.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751718; x=1779356518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAa7S8+lmtacBoTWuk3/nEzfs1vLgSAXTfB0g6A9cN4=;
        b=mkQlBqa0dxyWjV3xy/Yx7QuWZ+OkM/Ey6OaxJViJhRLl162Lc6Spe3eZuHqhuVIYAy
         C8XABtooDoK8vBD8G7OmUW/oabWqHqo+TKbxLA2stZ5qLwYPAIkha56i1IYw2b1PKNyg
         bURMC2BjOTQ82bg2pR80E5fMLzYiMGosKC4jmU0bB4TyVm3NIP+9WeONez9FTwHiWySs
         gu/xVzhvCx99I03icd6AA7KQ825vMAqi1PIbuPRkGIByYygskOzkkp3q40RF/em+yCie
         bQoOmVeopH/yrnZqWx141olsPUkYA+JMhgT6Pm6tGEUIAch35hLuY4vO/sP8Yg9v5vvk
         H5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751718; x=1779356518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XAa7S8+lmtacBoTWuk3/nEzfs1vLgSAXTfB0g6A9cN4=;
        b=WPWFPAFAJaETtUhpQNTjBWyxjFcV7S5n2w0a8v2jKnGKCHeTGV5qucfWm0hQpVEsq/
         NnLIanVbBpm0gYWB5XL3LMnzd8FpyNoPFChHLumfk1NSUWA9gCYF5iJZgQvjax3ZFwZ5
         oyOObagUnxQjTbeF0iqEOcuDoR7le5snBfT4uLUxoRkh8DDO/NBPhYEfuEP9+FDMuub5
         2G/wBDtrFnamZbNUJqp2DnRg6IAJ7p/IA0JInc9JCpiTWYWXtB1PJ01zPhFVxtngNVdf
         RU7MB0epyH/Y17krfBs41ZKS++ErW+FpiObY2Ia6D6x5PzczI9hfPygnl1BntHARJTDA
         VQeg==
X-Gm-Message-State: AOJu0YxjgtfD3fPysEVqWPMdqaD6ZjsZGIGeEsvUspN+q9jdfctsKywm
	kCFHmnqYb4M2pi7gnKNDnaoLmH+YfC/Bn0xtFbHWStBJYJwNzQhiNno7nyX/01c8D9k=
X-Gm-Gg: Acq92OGLcD+qnmjLuJn1PEs1F5btMH7GgUTOMjO3jpy8cJajWJQ5ANODl5U63i7FByf
	kbA4nCFCLaFGZ659ciWVD6/x0SDQFEuV3oQBvCwAhP2N5MMzNqWCjiGeGO3iaBBCBhVqRQnuWbx
	QsZRvgHTtULrIW5TEzYhqfyHM+ZqhYYoFomGmAijFJ4VOAttkhaPmj/AuTpJYwh3lpeFD+QTPDx
	WF+WN+E+XYYiYUMyw7/hV4zW9uatJ2y3hO6w6rkgGda1KCP8GKY1c8T3oOnpWAoDwA8TUnmOJv0
	b6mtygyhj96i5T4G6bxswXXhR/N0ab3R9AG+lemim63lYJYv2Os6F3MbtRoDkFhqQghGYtqVliQ
	lxTtsNcsMgeHQz2WlLisEjQrebS8Iik4Re9B3Q0/Ji24dYCo35PkjxqtTL4PYAxgig/M4u3ezp0
	v+wsdT04VgferlHtvLMTEMvrFXRYkUEc900wwJotbKQvSweg==
X-Received: by 2002:a17:90a:1c97:b0:368:ddd7:abcd with SMTP id 98e67ed59e1d1-368fb7992e1mr3845479a91.27.1778751718260;
        Thu, 14 May 2026 02:41:58 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:41:57 -0700 (PDT)
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
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 4/7] mm/vmalloc: Extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Thu, 14 May 2026 17:41:05 +0800
Message-Id: <20260514094108.2016201-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 843A54000B
X-Stat-Signature: wot5hyccr58qcwyheqqj66j5zkqznjgs
X-Rspam-User: 
X-HE-Tag: 1778751719-786571
X-HE-Meta: U2FsdGVkX1/hln8PsnsS52WWdjwqXdD2+YjCEUrf/tyJqSRwQYzW9ptUCKuo+/Dto6fnYzpb0f2ri8wpXTChXD6lmlI/J7eSKwJEK58/92ipDqyYwFWj937RMX5RXpN+BAaUA7TO/mWRfw6rR456KxnEzjw6MTBy/Y0sRUAY4E4lEmHnQLvXDGiHZP5LiFZqiIbzx4t7ZLfXtIs9a2xl/WaTeIDPz87STIdVqLNua7Y85gu5+EWG6w2DLB3tbvWQ5PIJxdCFmTgZ0jew/i0wbo5D2Fk6dVbW0CrtV3FVuEYo/f+Mi1/0bjXMMe3vmh9lB9fTfyiFZKTwMDwmGOnnLKTVNBDp6dByk7Iy4fnH1LUZX8xfRAVCkMPx2KF/xWE7b6nrq+ZrTYzESlqRiGsQRgByDKxuh5f9cJJ9/JyYPAOW4UBwAOn4pBpJ/qwmxHVC+m1laDKgzTwzXZc9UaRDnr3eYrxO371u4rRMRs2I2B6J4J63hkmJqtixm67LVwIBdbh3TTZZnN8AcdHkVf2Sh1IzrpA51O48E09NwgbHvqubKFviU9sVpiVip4pCsCZ5VM8glpNLwIVFVOnHjoUN/XgRApwMaizUiMPXcyccAB00CY1VQUz8OyJ6jEJhLnQ+ztTBBACQGQQVBIcgQ9wHNbav0i4uCZEM6G2wX9Ysn7AHHd53gJAMYlN4NR8HDNXnzQ0poxu7ZrscjpFvE0OO2H85OYrPn5UTs22GwdYfHhtyBOSXfhpdV6JtcJJ/x2MA4WeRSHsY1jzJOUy0fNPmjrTxnWAzNpP8utZ5xEvTTl5xJSNvM7fgZRNkce1J/7UKM4tLAzn6MnzmYnbNbrt91rwx/gQ/QiCOhijPAiZCZLYT6isGObVmvXZ5bTNZUE2W0HGwalScBAyehc9QVvQbdZd0xoahB6O0IAonS3c8d/RKBiV2sUvcybD3Ds6HFCqpagB13yOW9J2crD4402q
 qQZdxH0g
 AGLqtVureTmsiTkSjEf+sfxq7EUjgmv4KvPFpIi1aJZypAKm0DPG21ldlZ5HMTW4fvHJxOFEfab/2Spgq6p4o4L7gwIQ2LfBoFRrdWpY9vXzKEBrmp4NSRNmD2/5W2KOg4/bdjRiFqdIIDodAaWzcrycDraHpL9CFnXtbDXagHg9+fag/GTgzOdO1jcotnNTRlxUbJ4oVji2OhkwcLPZzD853SjNUTigX3WPCHQ7Ql/8Gk03yhpEyWLX8HmlCqMR6wEy6EtFcGlmYsv5YUzgR/ssMRMEo98Z+5SgiBMPSh8rEiuacLpkB4xz0WlU4t9fyWTA0ZgLdPlW1aNUpMCeJQXxxkS4n/R86st7lMfxs6VSG1QjLJnGWFT4JVvk//zWYIs7iaWOs7WxfHfK3MYM5UCnzSsQQduiU3m6Ge6uYl/tSMWdJHaLaAZnwI5vQc4aOr9LJBkDHkf/ykp0gNp41PSjroD5EjEa14HO78c6D02m82Gxh6kpe2RYASGQHuqbgGdyL2fG7s7j352rGOVsK5FTjC8yQsUe9RzsixqOztwe8WEXIxdftaDTy61ia1/BcV7zBuTYGXYA3AWz/MFBSI7+o+gUfqTeXtfPh0DbGCzGBZDtWnQ7uvNZL0A==
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
 mm/vmalloc.c | 64 +++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9bfd0aa34..516d40650 100644
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
@@ -597,7 +600,20 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
+
+		if (shift == PMD_SHIFT) {
+			struct page *page = pages[*nr];
+			phys_addr_t phys_addr = page_to_phys(page);
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
@@ -605,7 +621,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -615,7 +631,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
@@ -623,7 +639,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -633,14 +649,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
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
@@ -655,7 +671,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -678,27 +694,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
-
 	WARN_ON(page_shift < PAGE_SHIFT);
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
-
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
-
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					page_to_phys(pages[i]), prot,
-					page_shift);
-		if (err)
-			return err;
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;
 
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


