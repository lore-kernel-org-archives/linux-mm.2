Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 039E6C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C691D6B009B; Thu,  9 Jul 2026 03:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F9E6B009D; Thu,  9 Jul 2026 03:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FFA6B009E; Thu,  9 Jul 2026 03:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CFC56B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:39:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FE38A03FB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:39:00 +0000 (UTC)
X-FDA: 84968436840.19.D50B3F1
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E10440006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aX1v15wj;
	spf=pass (imf04.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fk2AnNyTURv/eSeaFRjqsjfwR0678HcFAycOaxoU8q0=;
	b=xqjQDUFG2L4G3K4e6gl7TpTKdRp6UjJVnt54xG+aEJfAW0yZzJIoyT/+UwJQqJo6tNZkhv
	KS+eZxoP9eddtWTK7FL50Y8L3pQaIFTpOpBgHxPHU7q8sqOC+e4xbo9cEV+RDn0+y02U/S
	pU/IhES7fWHKuQMWk7KvHXARSfqCUyk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aX1v15wj;
	spf=pass (imf04.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582738;
	b=4//LG+ANUrf+8bZR09DYyZbTUrdY8kP1T+msIqUcFYibI6wUfKoYuNfySTeR22qDGr+E4v
	3sxVmYKRf64rjGhguCY/LVGhjfdqblr2U5s2IYrlmB5kPxlILgACk5cH84hDxNFr32QGFj
	WCeXF5YmhQWeKn3cKRfzmUchT33KGQs=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cabc0a1ab6so21533125ad.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582737; x=1784187537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fk2AnNyTURv/eSeaFRjqsjfwR0678HcFAycOaxoU8q0=;
        b=aX1v15wjs7pVRkiwym0Bx0B711oxxDVbCW2KJj6rrMc2XjPVskK+Qh6+VwguAzMDuS
         DPx+vkmaX07hQ3zf49Dmx1XkllvNdY7/lGNAaYb/kedpTBErmTD5/ouaqzt2d8ToqdMX
         ihCSY2Jugk7yCWEsoGms0G5UGSMM+5pY70dVurIRjoaGRFbVVNp89guNufltUEBgJGSe
         UvHojsfa0g2VC4vyXSNeOFUWb2H6gQoKIn6x7bIQCqIcCRdVQIqC3dNsX4uR30ecxcZ/
         EnUnaRgGZVxIh0gQG09NDvgGO5/y/3JsbMjCphWMcURNru2Ww4WxLSjLXarlGRxNUxul
         rrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582737; x=1784187537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fk2AnNyTURv/eSeaFRjqsjfwR0678HcFAycOaxoU8q0=;
        b=mYpmWWRoX0wq9EpmmlG3hXg3l/sjg3cHwj7Dan0YFTaKm3f7R1N8d+rg0PRFLUV00Z
         91K+mkzLJuw+/TUfGAK9bHisj5qVexhmd5G0UKmayIzZ7E8I2yEGT4ncQUQP7hqtLhCe
         PTm6cfTfisafLjflrbObFbh4Z9iJYGfePwEl/FZQFQhApgGg0sOC0th5gBt9M2UE9by9
         WWaEQz2+nMJBCa85qK25KjFF2Rp+CMbsSrdsxKty6NxZ/Xo29lHCVTmOwyKY8gkCarAt
         fScDaoRumsWeVYGEQLdFE0IJAZJ33CV0r8zm4DL+YX4X5Pa/6ru8F+OhUUVJ03X4egn7
         K5WQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqs/YczhpwDBUDT/N+iZWqOW/bxOLqi7cad2tzOXCYDihb6DcYyzdryCxvUzwJYVvoZcEG1OP2/Cw==@kvack.org
X-Gm-Message-State: AOJu0Yz9xLOoD0d8ig2K4OXg8jVgG70DyVvZmJb8QbMJUkclB9+7BIIM
	eJXccZ63bGG5mE1bLffAf2mvPuqQCCJzfxLxsS9VDSQlT8Rs09tt0eqS
X-Gm-Gg: AfdE7cnz3XM3gJisgzkv7BxXZLXgVkc0CDEbRhsa6Ni9I1jj1YARL60U2tyI1k8cQQ+
	va1xi2dy4pjOgmdfUb3R7szZoiZEbpcKs2/NyM5jShqX1kP0dJNGCxbGp5pL0U5W2qVTD8pb2TW
	+LTwyLmQzaW3uD89owSNEURmtINJ85mOQNjPQbw/fvj2geWI+n+C9bQIoUVJaTwLSiO9XYsX5VX
	X68jk5XdCbzEpbc+H7qoSVWd5c8sC8pnKWYrh7itkz/1xnaJDVeVGFFPwXXkXokyh96nOz35knT
	QaL3ZG6Nhys0ls8GHKgto5hIDgq+iKHGk1mEJwFBIoGggT8YMqefaaxDWhs294F9F+9Z8hV40Zy
	CAKnWJBN/gQjWnlXGhhTHJ76EMsGmx0n0Me8UAS1xeXDXLlvxMt3+pYNGoHgmCSl4niLDkWJ5yR
	mMImc3GqmFwuxSI/61PBRAKkLUnFDpohdm8XA=
X-Received: by 2002:a05:6a20:7486:b0:3b3:26aa:5455 with SMTP id adf61e73a8af0-3c0bc8c42e6mr7909704637.13.1783582737175;
        Thu, 09 Jul 2026 00:38:57 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:38:56 -0700 (PDT)
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
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v6 4/6] mm/vmalloc: Extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Thu,  9 Jul 2026 15:38:21 +0800
Message-Id: <20260709073823.6643-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E10440006
X-Stat-Signature: 4hxa5wnfr7kxx4re56afjfwdknwhmgnb
X-HE-Tag: 1783582738-677299
X-HE-Meta: U2FsdGVkX19M56ax6XgIod36w/HGH0b0ehG48u1M+H9hPXvJ3vj6Y5sFr2rFtDGBWz88cksWgofSMegoT35G73J0tnrxwLtA9b+pPazE54aey1yEkU/vDgNYSBmoqjl0fIJg4hOVyG75jMlCZ+2fPgByQQM8V0SPsz2tE6lN5ybKeXdUPviR9eDAy3MsmtngT+w9HfU744iZnuWDu2VaVollYyuNIHQqhuvp515AAtxJTH/kmnqwPdDwon55Tn/ZncH2VzIZWmYJnAwV/4Upom2kcB/5UPB9p825WI2yFVBZ54pYmy+AUUFlNQPzthUzKydo7JOSN1GC0lRj1ybI6Ut+oM3LgEPMQI6wycrVzvmOnBiTdffAy2ObbNsTm7Oh/rRAuO3sfsyEY7FqtMBO10QqLQG9NILpQLegsJVuJNBAK2AcMdRcRgPxYwMNoQau+PMtZLSYbx6n/7Q2ATbfBgdqV+N6JvigMifpOpMZwHTr14+DeGwjoPadmvxIPbaq4d8F8IWtLI3Q5YbD8YRaJ9aQ7xIJ7PzdxO9RIwJ8i0uuKePfgB7RbMGGirUI9zcE/YP8ETokKCVv21RftG9YGJYtBjKFUMJ7TF/vJI8//bh6wq+S5DSp+4rlmCRkfTzRGNBS41uzyk8Ma3OrXBA2hgnkYRKKfryJHj4OdLdkHLuejfUMBsshJELrJfJJHaPdnAhKslUVEg6Jaq0VGAwm7ecS21pcQKnxt5v6q6lpSERacHrYOvUM1svIFoScq+5U1isK2hmvtix+hX2BOc+Mf3kShGgKm2yaBTJ9M55SyEFcWBaa7mjX7NJY4iBXP6kfAUCRqPzRSxb/phinmc4SOyotZRs+ZvseYNsfbqCxAxNyLoUCjn0bDflA7H6KxJIZn60j2Mnhd1qCYz1CQJcTdUCAdP0M5qzP7/if+zlHycIL4h03ViF8+oW+UDxS3txXn4aVBl7GCQj2FLNOdhe
 1k5UaxkY
 zFcW1pgJomoxdDlAOuKgVkiqztIK8pH+37uqT3IFVNsVYlNkFwkpuvJL42rugCMT1KfaDx0zGoAVLTFYuokONCK72ImIq8u4is8z9Ct6KHGw4d3h27A8bnIDKxPGOYpXz0iDr9yX9BuMkZcUmNNz0+mhjautGhTcC9tIEPLuTHjjunB1Esa7bpDLHrb4yeVN3fBRd02MPzHEVSjo6ev+0/Kp46iojbLvJKhmDuRiDDUz9F8Tmuwb19HtcGsSRxpKSvTgyv4C48THLcJId6SP97BdMovzDiTihzk7XnFkZIe7cqD79LM9/Sh7PtWIbZ+9XqqUattOyq4bwgbBodObkQttB1syuyiVdwJ0P1J4ZZ6w/79cfg6WTjyxrmCG8a5vYkC7T+L1LxSxe+v3e+UnJ1PC3375ts5vujpL5uJVLQS3qHKVqKSnNd7b9CFmW3bjzCFe6AGxaJ6JhA/TiZGjVQ/hosxW9OvDw3l7/5ITIk3eMIXdsFA/lpWO+HdMTAgmkoBKjO8m48VnvwWL1IGJ9OF4yIUPACpPd2abeBkhb6iwrhEq0VGKo1hYFYlV2AeaDWfXqc8CRqVie1uQhGbO8J4+K10dHbkZqiquP
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
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d7fef85b241c4..d2a4d649af549 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -125,7 +125,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -147,8 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		}
 
 		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
-		pfn += PFN_DOWN(size);
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -540,8 +541,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;
 
@@ -572,9 +575,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
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
@@ -584,7 +588,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -594,7 +598,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
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
@@ -602,7 +626,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -612,7 +636,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
@@ -620,7 +644,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -630,14 +654,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
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
@@ -652,7 +680,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -675,27 +703,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
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
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;
 
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


