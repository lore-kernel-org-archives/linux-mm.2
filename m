Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62D7C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0C26B00A1; Wed, 23 Sep 2026 02:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AF86B00A2; Wed, 23 Sep 2026 02:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59B26B00A4; Wed, 23 Sep 2026 02:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9510E6B00A1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A00D1406F9
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:24 +0000 (UTC)
X-FDA: 85244050248.17.1252CBE
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id 636FD180004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nHOzBRX6;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+a2Rdy8KxrMJDsvufLYSYTpVzrgqa1a95U57Pa83CJI=;
	b=neX5//8dTkMve1EbaG7QaT0a2JC99/Q6ruoUjSmCqiptE0sUhqW2MvMV1PkD32iZ1Kg7kV
	w4pYNbvrPujWpCHzKq5tMeb27JJwWPS2JOYR9LIHnmvwJCm/hYvNXOB2Mrl92rGE8+L4KC
	6reQD9J4+FpZFGwV4upyMb/D+zOHPtI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nHOzBRX6;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144962;
	b=1e8VfhtySWgTnS0wh5KuCDgeJMOUqrmhDqr0Ts5vge/60URgp0reF0kic7JItGbzXJJ36I
	eJfukC30m/jTHYF8GoFqySE3V70cby3V0biDME+8M+O7pN2ugX36nT33ho6JtIVz1sZMCH
	dK+32m0uNkPAknO9Ct6nEhFmxvz+C3I=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db22383fe8so2354155ad.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144961; x=1790749761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+a2Rdy8KxrMJDsvufLYSYTpVzrgqa1a95U57Pa83CJI=;
        b=nHOzBRX6g9EHbPjBAMJpOexUhkUJmKJYHphHMcx7TkFNbb5m5XpdUnwXCC0MLI+YmV
         64tE2iY5extI4U+FnOeM5+SZPdipPhidAT3lyBx6EaV2eVjF4zJPnZS7/Xrui96rXmO2
         6/z95119OjCSrdG/vC70LRCrDUSMx1Knk2NsfbHbTWNyNMolPbF+4Y68EZIeKGo24SGn
         qeyRj+viVmtm1vBANKGUSFr9XB3rYnjaubiJkuBewzF8W0egdChvxR18AWL5SHdoH3Ra
         Kbh3ywDyxaok/z7DLxoXg8CClpb+bCfHbg+Z0V2W6W0QZBbZG6zAwjslIJhzP8hCZgeE
         ZrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144961; x=1790749761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+a2Rdy8KxrMJDsvufLYSYTpVzrgqa1a95U57Pa83CJI=;
        b=PwrKuX0TycM3R7Q6XtGtj9eZ4YzU0vICyWOBBUAtAHNMLcYbXyKk8QFE32swkVVKX5
         P/FfBu17OFISHzrbtzfoKWWbuwS5C7KB8fC2V4alaqgxdsMf3VO6v5dDHrJg1Bvqs5QE
         loINHiWiShWK1VquPlB6XXQC3RHabVgcNwQewCuB/ExJt2HCwNXhVj0no4coMvHkWVd/
         ziDIcItFuU/X7F2hqeFAZ/z67NZ0KgEdimzJADYKBadmR4kP2HV9zIddoPCqn0CUiOSX
         +fumu1e3ujTTVIE4d8QDNMIz3PCnKDWBDc3FXndmOWtMeDmGRotY7BTkBqyCgy/0fkWh
         d1rg==
X-Forwarded-Encrypted: i=1; AKwUvBzS1U6eAtpUpX0unb2Gc7t3K/X1PtKf/9p1KYYI+T8x+Q6KxpRa2GKVT1heX9/QgeWXWLR5a+HDSQ==@kvack.org
X-Gm-Message-State: AFuF++ljh8TLyj0VvFtt63dqM76m7u/izkaWvIPrjXy9YM+0MndnyXer
	naZx8pEQuLGll/incJoGUPUIiPSqHPpc5rywWM4amMv+L2h+l7uCKHio
X-Gm-Gg: AYBFou2XLjVqM5OV7PcPeNlEUdLsuO3Xq3LietHY2hDf/5AhIaO1/n9rXH+jToPZ3Qx
	CbJOQF9acpJ4hr3P9gL9lhvodL0foX+z3w7bHs4FT2dCZIqnShT0gTuZKs4nl8WYVHzarq16COA
	SxxmWrN9DEP4GzIBV+6BstLObMQdkZaCURReZTcGNRLkxX8zWNeFwo1F4yg+1HyDK+mNpx1KyqK
	u0HcTvs+cJEIEMq51bKcQDohUtbYyoJhkLEbg/+BIjgqpWmVubb5CbyMyDy3vtnm2sgXSXCskZh
	v/li9iWSro3FBSz1SYkFLsjaeIxd25sWuuw3M1bPzwWc19nvRHeO0QDNawkoGQXDt3anEyxX3Ty
	AZHZcngV/pItUW8Da5Rf8Hx1m2bM03wasDupCdUW7g7Ghxuidu6RzosPwuYW3LeI5ZJraXPntjp
	IZLa4umYzksb3mGx1IQaXPG/rtbVZPZItTaChNN2epsHGgwz6Vpk+S5LqdFne/ZoyZW11GydsrI
	XFz38pOnE+JQdAiG3TAHw==
X-Received: by 2002:a17:903:390d:b0:2d6:df31:5bd0 with SMTP id d9443c01a7336-2df69d22254mr17039015ad.10.1790144961284;
        Tue, 22 Sep 2026 23:29:21 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:20 -0700 (PDT)
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
Subject: [PATCH v9 07/10] mm/vmalloc: extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Wed, 23 Sep 2026 14:28:29 +0800
Message-Id: <20260923062832.479455-8-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 636FD180004
X-Stat-Signature: 6c4czg6r3o1k5nf5hewcswhk97y77eq9
X-Rspam-User: 
X-HE-Tag: 1790144962-619550
X-HE-Meta: U2FsdGVkX1+/6yLCZ1cLMXZn0t6ojqTn3RwQWB/3sak/OeptTKZV43SjYOE3MGRo39tL4SnXj3Jc7IYGW+jGgZqWXfQNzgsLNlpj1LxektEqQHGg3OtuL9ADZ9HIKy3URsaS6e1ASQOBToFP1mNvl5wPkAzk3rSnJ19ZnAR734Mc+U7a28HMnBiYkt7kohzIcTR6Pfx4DgN1OvIlTicUlRodDvOjt2u8D4cKtOFBTY2T3/mjnjzkGbuBLfSy5YBolvwhFbKgodByFB/c36ssXF/ZgGZxCQgezK9DLWYHIbAs+4Wu4P1wlyVuZRt6D5kd5I45sDS6WOWwsnWi+At5i4g6d7zZ6EvLUkI0VzG/f3P5RI9Wzm7rjWMRGgsDbkPkuZNlDWIHgJPrm+1tzZFIe03+ACHUsO9LBt/ySZ2BFo9uApNRByeiQjqJtvJjZxgUVa99P0BDgBw5anEaE9MipPmw04+ocM+g1CIvx7x/XBKuNPNh39iuQvno/NYoSJb1m60TpF9jk+y4HKEOO3pTWR3MVo+Zi4x8gIrM+kWtEL/MVV+4ytLoleKBHNvyv4XZoo1MH2uzEv0cDo+XcxwZRFc9fRuYzeTGFaZI2iRScKj7EG47QGh+RXkSYQo39srz0M//8afeacDKYIdXlJWG+HcKYYKjdhoH69/scXKbOZX/uQ2rP5U9reJpj2mmqhkF9HsW6Ldc1OdfDUpDIei5eGNczJt8/m2rIWO7KqQiJAs+6KBVI2CjUDN2Dmx4KeUCFBmnkH4Rkq3KR6Dv1yVFjE+CjD5RaJFCJAMQCVazIB4cgynxrzs346GmpUAZIzTfIgr2McM4A0lS1qjePWlirxj0aKVtfOP9EoZPqsEI0/3LUF8WZTzJp8UAJbPvDP8FRvXEeVbJqtJkmyNienuRvg46w/lPWPa58PmseY6rRjy93pcMZBQkbSZ8y/+SEf3nhuKfXITAl3vET4O2y1D
 38odH7qh
 +jUWvAf+dbD0/FLsYFkHEsuOO0OSrQxQmxulFyMN1CR2C2wui7prrWhQTUHsP90OawwDkzZKfx+gYWfgb5Cu+UgHJvd+buC4XkNqEdrsbL1v7I8XIVk05OjAa5CrtwcHrrSWqGAoVKm7ij23O0zv4QjAeXlKNCuJNVm9TVExxfQeoWNl4b43tVo5oubyhNQbkiFwPE+WH+bJx5uORerxyjTl26kZeYeHoKJxFrXbK4i3WHZrgaQyh6LSPX2ZOdARvPhABhAZ6/y3aYkBCrkdeMWyRR2s3z9uGpQqxQ/Tg9webERFtbJFgUhnFMs/us+mJIuyyHwTVM2QbGkC8PQJto6gUN9xkCDp8lFIqcv/XL21ykB+07rb6ev9TzsAiCHuFlupC2kBHS0WNut2OpKWahlrCodyIKkzgBBBLzD5v6L+1wcExTo+5c2KqKE0tv73Z4PFOGGV2exoV2PsgBCciYXLRkGC5bG2mDxGuyTrwm75A/dQE6FN7jM7z53QKBscb1YYMhCNDJtELjls6uXLZE3tiz/sgYGPr8Y7Aalp1J4i31d3Mxe6jko//gKVWIWBn314NdbsUMSyI2SMt8WQ7TfuSS/UdmC8W1EZ1
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
contiguous-PTE mappings as well.

Rename it to vmap_pages_range_noflush_walk() since it now handles
more than just small pages.

For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
iterate over pages one by one via vmap_range_noflush(), which would
otherwise lead to page table rewalk. The code is now unified with the
PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 84 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d475e52110e4a..6e0dec73107a7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -558,8 +558,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;
 
@@ -590,9 +592,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
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
@@ -602,60 +605,88 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
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
+			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot, shift)) {
+				*mask |= PGTBL_PMD_MODIFIED;
+				*nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
+				continue;
+			}
+		}
+		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
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
@@ -670,7 +701,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -693,27 +724,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
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


