Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFC1C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2816B00A2; Thu, 17 Sep 2026 01:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85C36B00A3; Thu, 17 Sep 2026 01:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C446B00A4; Thu, 17 Sep 2026 01:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 910C86B00A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F274A1C1C64
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:34 +0000 (UTC)
X-FDA: 85222129188.21.CBE373B
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C141180003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fcNpGp4K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623033;
	b=bDb50vSA80JCMxaEz4TOaha/1ejN0Vpo9+LLsW1Gy8Oz4UU7B9LYqYTl3QFLucyYgySGXG
	P8ucJdRhkb3SHt7w9JAlSA/S/s5lUztByROZQ6E7ndtrpt3QTX7HWf9DGK9q3nk4KbHJCS
	BBIydYJtu5hsN95rUXvRhn2Iv09FXlo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fcNpGp4K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XToDi6fIsVYoV27kQlhNobBUYsIv/tm0eptMLl1rq74=;
	b=wAyQF4Dgr/yEoq/uuvj8WV7R1gug3ZuSIW2l8slNRj7OgnTUDTycQRDBJAvq+JJcus4VWA
	7++jcGT544mF0BJ6Y5ExZ20rlOQ9o5Hzkktmmm3khbgUHO9bziNKw5a+OK8f8ClMs2SHqN
	gTaOtMIu7VyzJpRJmpcdXW+4ZrGkLIE=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747eb79f7so3212455ad.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623032; x=1790227832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XToDi6fIsVYoV27kQlhNobBUYsIv/tm0eptMLl1rq74=;
        b=fcNpGp4KnNujZkGtGeVYut558KrufGFJSv0CeYZkIZIN8wC+o0moNw7CfA+jsLIF/T
         avooc3FJK4ZNcNnpVLBXCKkEumIavbVz2Xn8sLc1wZGJcNy68b4VtQbkMPXhmP0Xg+Zm
         +GYZTE1bV4/STZWByPSCsgY6e4OvBdWpCbHx+mq/h1r7f6B+AJAm1dCH/GWhOLOXGSAq
         /AInA+KplK6tTYQTmnRO1csAO/BmBL3SjT/x1uIDNxtbssrZybKjI3u9BwnjrM0Mf0Gy
         YvVqQT1pie+JatickkZDofoxCFDfy1ug9AlEUwqQJlesoOYOX07X93MCGr9btzTpFSVR
         debw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623032; x=1790227832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XToDi6fIsVYoV27kQlhNobBUYsIv/tm0eptMLl1rq74=;
        b=0AT3hFvy+pGOtqSLU2AE/Vev9kfSQPZYzvPI5iCBV/6NIi7vAj76OY/x7Rz3QMjAf/
         Hu1Ol+rMber+rYWaO9NJgq/c2OMVLbTNuugZlwHaEITMjoGtjBemncNg+22eqK0VgrOK
         4RxQDsCRiWxMT40KcSSE1x3OVaged1bk7IXEfB0sMKezWVgwjwbadcFwR9RpqCtvav3u
         HZbJWXmPYFYNQ9g4mobq7w35nRA7OssDGxUcRkUB+3O7EBrR37Z+7lg5dfhoBMh66VrN
         Pt5QwN8W069x8YvY/yCpt3wUvf+cOpJ4GSbB1tN+yQR1xVpq2TwLdJprzhquO6IWatEc
         PqAA==
X-Forwarded-Encrypted: i=1; AKwUvBwnM6AzoVHxQqmI7fDgi8IBUZRB9QRV9iPLEwiXV7rOQ5Irp/qXMvcztYLJsIOIDhmNeLJG4c5wCg==@kvack.org
X-Gm-Message-State: AFuF++kvqZgdzM5Ae45Qacp/f9Zq5VN0Onhzo6M5hd0WyCTCqju6XJmU
	Zpks/pwsak9V07dp9IuWmfhLNwP2xzbF6xCopIrl1kEgf6h5mFA9omxi
X-Gm-Gg: AYBFou1NLsqYkkCub7/k0sNGFGOt1uXM0p/RjQFWJ/N+rLEwV1WMAOxltRy3rycQFuY
	CV0tId2ZmUkysDOhPaOYI3cp0Za+kI13LwEY6e6ULfoEIR7XAqotA77tEg6tUNVtVn8eEnX9n5T
	L84F15U7EPaULr8Yo2QFPuikkGjxS4HP1wXYiUJQDLaPLmXBpDgmRrUUYEueTQOgDgLnijX/k0P
	H/ZEOUe9qaLj9pbwUQIW/PEyBDwk5zUzQlqS/ju21nhdK7Ppd45ZxRO4rK4SZkNVCDcl6S82ZuK
	NJkd/9uIK3s0k+HZmiZcSXHPkAj3t42/X6v5DPtr1+1sCSgRnus6jdC0A84a+O7O1iPRYFwdRIS
	Nu1owlCTwl4FEB1b3NBChXK7KbatZ/gvSbcWTm5pGus8tEHbs2KUtPZ8m8YHLLfFKBeBZ5ct1PF
	N7YKG/PDeyac3F9Sr2NihZNyVxP+yV4GVckqu4qJ92PqUjizHJgtJiNQ6LP8vXiY1w1FsX2Uz4c
	tkb4m+O0MaB1v9d1dQX5j77eV0=
X-Received: by 2002:a17:90b:4a51:b0:39d:ee20:1e28 with SMTP id 98e67ed59e1d1-39e1e510f73mr15610978a91.21.1789623031887;
        Wed, 16 Sep 2026 22:30:31 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:31 -0700 (PDT)
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
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v8 07/10] mm/vmalloc: extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Thu, 17 Sep 2026 13:29:30 +0800
Message-Id: <20260917052933.188679-8-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C141180003
X-Stat-Signature: 6m49fqfgj9nrdytx9qzjhy8rarxyci14
X-HE-Tag: 1789623033-472626
X-HE-Meta: U2FsdGVkX1/XtAzgSZ6Q3pUMiOv2vu9Jk79Q4J1ZmzxPSh9Y8eh0P+pBH4wuzRIiH85g/ju9NDmhsl2J9eLtEZCEtHQsQKjDMKXB8dNNJGZxYqhk66cfWQAfGT45qXyo6m4hwkSMsivA5b/BnCGm0qXq22IfZz69gfuts/H7qq03ZYBW9gtee4VxRF9P6m5q4xUvhpq/nvK0k2FF8TUOBztEGmcYRUDWE768Tx3LnTJoDxK1c3P+dT2UbVLjf9Uetv+GdZRRqd6qzMMQXLeG6m8iVW61BdWMLro8MBKJcTBHakY5N4GkEw1iPqsPC7QCWrIzWj6V+39M+JYOrcMSsi7OYiKcfgLqhwfe9aiezODIPfI0Azo4EvP21dipVQJ335aLhxxM4eDkLf1CGqgyFCCqkPmqZSG4AFZ/WnI08ilHyCPo9IHVblkcF9jp7P224vCB8kNFp5Ug+0EzvwLAoJP32vlxosmKpudLl5q6Ir0LSol0e4hdveSnMPivQ/mSbizQcAJTEPtVMzCxEdEOB2xT9WTMqG+iX9CbOmBi60alx+sstO0Q7E1pt86yzyUAtq4bNnFnug2YkK2LGSrrHxtzdi5yxAvqXT3iyxoPpEiecje+RhBjpHGtEcs81r68xG/6OlCxAUdcqpgmLDdbBpWuyy9ihK5UwSSHroYXI6cts93WDC6DezfulBwv7Xqn+s/21M6W5KWjdNk0iDvYxjQKv882H7/SLYJnAnmZRsbQLaWrALOLB3vfCoIarB2Owxl6CYD4RKXzuE/cLJ6GLML9RnGO5xXq86sMOiI7MIdmPEoT8Ham/HCWLOXzV/j0Q+IWQbCby4X2/pEwARB/1nlkpCa0rVA+eRds0Gjvzdk9ydS2S7TgjRY7Z+jszJrZJ3vrQSD21imbbo6ZWXdaiYfT7RltYlrN5w/UftjD6lcZCvMeYBfMC1cLhczznlzKEe3ZGcFuE8ZkCcj8ENL
 rYeuJYcL
 VgDOVgXylCwSAsrULK2LmgStEWW5kzjgw4p1dXP5kfoX0/9Ch5jjBkDN1l8sFOZKTCvk3SxgovZILK6o7zFz0e7NFa3Mf02wX8NZ9/Sxcy8Q1aCts7LM91DE8Cfos4039HoLKqgRcwLUznjBObb5CEx93MiRNLXQmYu1YfDl580R3d3Ya0pF9g0fNIOkT1eykuXj60bvwXd3PHW/9yJmE8WFTcDXe9CAXmVjnZNasV1Tg6u/0tzObRQe0X1jvcfO4ZKgSZIslR56flOKWmAhha+wVHHTU1UXYuscZ/sDDJrLrpplTN7SZRrDxMZD9fsoIPXKHUy33m6PhnELXrWQbNMR0fzSXAWmnMR7o/Vxg6tnEFtPpHzZdMGpI+45vmLTB4fO3xXqe728WdIWvd35CynXNv6Sf5P6L7mh2e3MjTstXb8/9143lYAK516i7isIk3tweujH+jSemedb97lcpNQknpxzAXLxXxeLyhQKkjJZgjUv2kFf/76X/vUsdNz5hwSeaIe69gKwt2O8TqdDcjMU3DdqD0Bfo/tIGu74zLgVdTDnAH+rAX2ODScswp6pAcOX8I2bQ5urVR3esGt2PeIndyOGILwhVmGHSnPhmln8jC8BPB23ZVnGukj2cQQY/91cFX2xaD1N+qlg=
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
index a0508bdb7d36f..cf1daf931a6f6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -535,8 +535,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;
 
@@ -567,9 +569,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
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
@@ -579,60 +582,88 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
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
@@ -647,7 +678,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -670,27 +701,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
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


