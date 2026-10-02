Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC17BCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027AE6B0099; Fri,  2 Oct 2026 05:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19D06B009B; Fri,  2 Oct 2026 05:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D939C6B009D; Fri,  2 Oct 2026 05:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B81AA6B0099
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFF87406B0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:39 +0000 (UTC)
X-FDA: 85277115798.23.8F6F68C
Received: from mail-pj2-f25.google.com (mail-pj2-f25.google.com [74.125.227.153])
	by imf01.hostedemail.com (Postfix) with ESMTP id E02294000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FHZmQ3sZ;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.153 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+u5Tl/52qc86tZapuAq3nOJxQOQrMAgPsc9gP5V5sE=;
	b=BnRb8ZtW1H215Z9VJh9QzCAdtyyUjVNCtY6sevRFWC0t84uwDjrXZqHRztOssdS6kVVjqr
	cPLxLQNvn8OnXMywbMV3Pt/MP2SbPifoN3tkFfyuEFpZa/sYBUZMR3GEcFMwc1ELI02loD
	Hv8Tj3OFe2gj3M5THW0t3Vjd1rHuNdw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FHZmQ3sZ;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.153 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932237;
	b=5qklh2WOUymtY7Yfir/dGFyhnti8fN+aDTSiKTpmo55R8mF+jj0FTFakPCiBnSc3nsqpEH
	dy/HPrlPMMtADSjHGNmuTGMsNP9OgCjc9o9E5U7p5Xh6UQdBudF92HAU/52+4aPwLiAsqJ
	Kw7G8MpEVylhx1jRjdbJsjsOQPD4lIE=
Received: by mail-pj2-f25.google.com with SMTP id d9443c01a7336-2e2e688de2eso25188545ad.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932237; x=1791537037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g+u5Tl/52qc86tZapuAq3nOJxQOQrMAgPsc9gP5V5sE=;
        b=FHZmQ3sZrU8Z5Xo/fN/b5bd6kgsL4BCZQb2CtGEfY3JjF937Js9vx7urVq+b6/oLTN
         b36n5m+KYGPFKBJG23jBUSYXsC9IsIi6JNrx+wiZ4TX3G2C1D45NZGQm0rbbBGvGil37
         XyBQjEyD3GfgrDH2/U3DSF/8bbO6CaLzvH1PTI0GY756L1oPtkEnnn+qkkQKxZzbRNKT
         NK5PzK6YgstY+rky5ar1i6s9qOyOM+50hlRlKWZnz9Y1gYYhU38WjUJuq7U6qYkO6Xcu
         3hWirhi3WN2UDK9Es4CuhNBLsWTDCUdY3C13fo6XER1ojqT3GHwzbuw+sFhV4w7BzQu7
         4qIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932237; x=1791537037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g+u5Tl/52qc86tZapuAq3nOJxQOQrMAgPsc9gP5V5sE=;
        b=q7/kMY8BFyYIgPuQRI6SbecOCGJ6uEHRG3CmjwSkFvA3jpggaNMQuTFB71SvdN6ZvL
         Srr2kyCyOvU0c0p2lHP6FsprKrgyXGHJjqsYUYHdYzsDnaCl6r4Ft2HRi0gOJQVbXyWf
         pRVXg5csCx2AqnPpiod+u9QaLn2hyS+yYOstoWspYAcdSg3OO8qLvwWw7mWmMcVNUfRj
         Qx6vTwuBiuOYEu0/VK+cPw8t8+4cMhXgDCHEJo0vR9F+0jaeVsQqKrZWlg1n2XQnQU1i
         WAzqP7GdC40iAm6To4zjRlPyUyFV8HHOE0B/+9dDo6q02qKYH79Fikbe0ON1VuY6cY6H
         JSZw==
X-Forwarded-Encrypted: i=1; AKwUvBw3sUYUTVdehLfGEaFsVooosKa4FPXrv4y/kxJxbULzjvCuR2ODeNaLIobqnqp1Xtyk8Aploz6gJQ==@kvack.org
X-Gm-Message-State: AFq9FYK6mPV0wm+ZpBI7kxRo1xEN1hb28fYdnsQDPtNSDfBTSFFkhimY
	8qPx/G6KcpixipPMajcRNEIOoAPobDAs98oQTWinxlR7jnIgddi8SATH
X-Gm-Gg: AYBFou2rIcFMSlMaMM9ejKqsGVLO7pqqd/BLgpwymszLc/9rrE1VLr7hsGNAagMSSxr
	4stF6dx4+Wt8xEiKssnd9Dfnifvg5RgQKe9YPmx1mgDNEKO61f1p0B7dHqpZgozZCOKKoIsW6HG
	rygPB136SNFcGE9HXzx7gwZVFQO3KN93a57xfKvd42uSOLxYkAjADmnzwyhGy/x6NDPyi4G9RPX
	jaIjwcIBosMtCNJZG3dhMSRcFle8ALxZHTVDGtQe/Eau6y8bAzEL3u8zqdRyJz/LTkf/UPA8izx
	hUBm3qKGmwEETasI3HmKYhUA54sgEzsS0D0p3HOvLqmRv8xu2/m2FiqJX3yRIQIX52VGrKHMuIK
	xG4BQWP2t1T8IZ8+eQd9bealYPOuY0Sb3OQ3xKF6PTcbf6dxV3OC9Nh3u9sIAxwz6dZLDUX9OLf
	e7dac+LlRawCzA01pZwy+vrJyGzvf2ffDMY7qk1UjKBtIbvoAOIjcNSw9Klq3+cPbXtR2B8xIvs
	p2nmSUalI8qgFzW4/005YMjPntB9yj5
X-Received: by 2002:a17:902:dacc:b0:2e2:c03c:f625 with SMTP id d9443c01a7336-2e49b6121eamr18607265ad.13.1790932236632;
        Fri, 02 Oct 2026 02:10:36 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:36 -0700 (PDT)
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
Subject: [PATCH v10 07/10] mm/vmalloc: extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Fri,  2 Oct 2026 17:09:44 +0800
Message-Id: <20261002090947.869220-8-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E02294000B
X-Stat-Signature: dsn5s9a71yd8zqxmtunouuda8c8ysmw5
X-Rspam-User: 
X-HE-Tag: 1790932237-971695
X-HE-Meta: U2FsdGVkX1+1RAHTjBRK0eFmcYXba2wK+wV/wqTdZskPdO4J1ZJIiefK2d+HmTgdfk3QP3garnx2RPe5OSLlQbQ8htxv92LsNI1m362metmVYZAa5qAamFLrIIVJ/Isa5YAigExTykblyicqtqQ4x1C37icWqNvgqF6Mtz7ckyMlddcGRQtNOh6qClwwq+ecDvnFTg0Fo0bUqZzsxZoyw2XwsoGVqfoA2Myo4WmAkDethxvVg9wLHJfToxjHKpOrmZhXhps8yORCuP3vet11x8IWNzDVPR0723vRedsB6+jC1MScjnF42cpvj5vdtWPpiNXoN+TZcEhN6j2c1OfTdV8D+3ocSI8DPHCL18ROW1+geJVeZugnZTmuCtK2dnIps76fqUXAFZ4zPImqfzIt8arV22Pw1pB3xJOzSuybHoWOifPSUFbOo+X/d4C2FEZQFET6Pql9c/I/TfpdePCxAJmemkLLTID6enovBD8uDEG2TMigGEohJfukKuTfbJlbHpsiXPgq+wZ+kc/+5yeRhDhaZpSG10iUlA01otzyJ5lCyYSVS6RcoV6ehnNqEKDldL3nfS+anr0eKwi4IZqsCC9JDieXrZpqCC/tqHC30WsDDivWVRkqdmXNHdQi5Xk1Ar4YfEf85CUaNXDaiACtxtwucAMNwB1LL2+/ZryRTPpyVo7fWi6EkwLAT8UWv9tS0jvyeoqOSrc2/Nc4f0PtvetphY15fXmG4zYe0c2AWoGIJgAV5K/pSDFuDWyRMQHFdUNw+XVKEuEQsiI/i4Yzw64UbR6iLbrPPBtbqRVwht9+hfJ3k4avbgo0sETJ8fqZUYvwrphNsFZr/7b3GpRYO9UKYSD5lYMjfEa/Y/yFfg4EnI2MyJpW8EfLHoBPewjodcoy+dMKQUskHZ5jwCTtLT7HXNDWafnsw+VKFyJnYyx+QXFQN+6FtYHlciE4SV3HHgRV6iBNn9SoADb7lOo
 IBDiccdk
 yQMa18hg36lEA+VAOQXZdCxEJw9mmhFt6ggJBfk/lv4RunZG028O8Ynyqom31a0aryeyMXtF+5G7uGbNSC5PbZTWsn6vtkUc55ToSv1mhUlef8sXSQ1KyMfp0P3uvlE0UJOnmdIDpaRXHWZwBYGdA563nSu/7j4gP+WBGhS0LZp7yM0WOGdCLGgTO2Wa1uEWUCJ6qtza7rPd7L4mKSyOjClJf9eQwOJhrUzTiDP7V5/Sfxz935JUHYEUuPNatpQtosyHEQKLVts1TakbEO/+QVURlL5CgyETbLP/OyzxRSIYdYvfGPvCH+j75f3or1RuJ+5uFACsLb/wURJO3Lm4eAdQUZAgET/x5H9QChB64yDlcLMlSA8t1oCw6tTUHTA1L0Nkq4dJE1bzZF7qE3JhM7IZmnzPbKFA3djO8GTJkQz868fhDjM3QRxWM4V2qq4USk2H15mzWCF/Bg2fJF2wDMpjkSGWPVh7RBCHNkEMqaDtN8Xtp+jO6daqpS96anYaXs5MD0iiPS+MfQFEd6jhMCY8xB+GWQ24ZyK7qaG+RsLGuFh0cg6/W9NxLt7I9GiQC0mkN008hnk5ufY6sMj11m/ouO5ZCEwt//UMA
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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 84 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 72ec1b48a76de..99bd22c086bf8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -558,8 +558,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int nr_pages;
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
+		nr_pages = PFN_DOWN(size);
+	} while (pte += nr_pages, *nr += nr_pages, addr += size, addr != end);
 
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
+				*nr += 1U << (PMD_SHIFT - PAGE_SHIFT);
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


