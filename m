Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA4A5105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE686B0092; Tue,  7 Apr 2026 22:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FCD6B0093; Tue,  7 Apr 2026 22:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C106B0095; Tue,  7 Apr 2026 22:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8B846B0092
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9CC7E2911
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:44 +0000 (UTC)
X-FDA: 84633863328.12.3CCC684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 169F340006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNKTa01p;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616703; a=rsa-sha256;
	cv=none;
	b=Fuhsa8GV2xY6Tj/xEfaDtFcIIMpBYlY7TbWANbbBpTGMDqMm17OXqS+y1vm6wEpNuiV1xI
	/zsj3LVZiUcnswEqmxymM4dvj4PYmlslNvrgEqoZlmAMBENnY1h2j7iW0oBTyqFfSxiGBw
	exWC1ydZKF+cUfNtCDemsyFDH2HzQH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfEJGQkOg2o3WNMaKGJLy2ouK5PnZENAR6Z2/gFdBJs=;
	b=xAccoCZQyrU5GF+Q4rkT/g140N4o5dqgK4jsRfHKkSe7AC9AoWevPaSo9r9mWijZUa+jg3
	yfo/LfRmm9NJuKv9teq5l8wHbjPXDWTaZG6BtkdpOcZf6h3AnQ1eZr/wcZCSCyiBbK7jyE
	9ZN4cFjEOnwm3HEtAlbXP3JxGxrivWE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNKTa01p;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A18DA60138;
	Wed,  8 Apr 2026 02:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9872CC116C6;
	Wed,  8 Apr 2026 02:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616702;
	bh=vLbaLx4OjOo4lPW5G2eyteG1jD4WkqeXjsMrkMJ13sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNKTa01piFnudi3PShsKsr4fjMQhJQweXnRAGNJInS81yIwQ0/WNgLRLHXzOtXi8T
	 +f+GOdgecQ0+UKlxiWWECMDV6AUIMrOdtUAbRrZ7XLxpMMytszyB7FQGlte8tETF4+
	 37ds6U1eurtYjfkcH5ysxGsB+MTLyUhUkScCx83nAspwbJq7IHGUtbRm6ymsgtTQ2W
	 y5twO6kfteIv78kJHPd210N2a3N7djdUf/DP/9MR0beotXu2yYaDv3ZdIHd8CqabmW
	 /DDW1p9LILJ1vaNB0SYFBXpPz+kxV0UbcWu61Wwq3vqyDsoHTLvM/ZVT1a/qKGGsBs
	 p2tOBr9D8GzzQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 3/8] mm/vmalloc: Extend vmap_small_pages_range_noflush() to support larger page_shift sizes
Date: Wed,  8 Apr 2026 10:51:10 +0800
Message-Id: <20260408025115.27368-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 169F340006
X-Stat-Signature: 5y5jafoa57kdkom4fscf6xd6qi995q5z
X-HE-Tag: 1775616702-916622
X-HE-Meta: U2FsdGVkX1+VQBw6xTiO847BW8X39Aqz2ZguHjqpNIIu3ewQsvI0M0lbR93ACDn/g46h/VxN/gwhe+goGjDzH3VBPwgfauic0p6JZYrCBdbqaxyUd11E36BNtOcsavQvPnaV66nKAKT6F2ZmIqp/1iE75aumeNPESM9uokPFnzDO+KyZTrSgvSX9uuk30V2mxZ7kpiTsP3J/tK21Ye5xG1GKnf/OhhhF9kKANwB7NLu49QA8N2QwE87uQCIB9aWbefRnkxpBSFs9X5ZkyobbCvnWXb4yRJPdWF/lgd8FL7gvQGenoui7deaKo1uBsAPF5bCE+QJSBqmBXd7hp7edYhSLjf0kfskdrHVSv26oJKuwUi4KGoX1JICyBVsvUpXzMZ+tlcOwWXrAPMDvQ57cKPxbDSkTO7yDINVV6G6h7VEoYtN8OxAh9HGxhv73wpt27woQS7PrvycbAUbxpTEpuVtnsVw3Que81CQQM2s9wvgR6uQXZb3XOSm/To0JKr2UuQFm1CS/+/pchFGM9k7KySa0FjMHaHY+3P1OoK+LRyDcuothUhjfGMatH+e+KPAkgwW89tpEnxEbLElAV/5UOsFJjc+7HTrTKJDlVs9WPlf3xVYzk874BysBcARA1S9wliZxhVDwlrCX8Vp8Co7UGBAiE8AstwOoKHz1jLsOEe5tORT2UsXvSVg7rEcYU5fhu3W2vbm4TPbrDoSeSIHLU4fhtRXkmGSycATXh8ryWWOagbiBw8KVqxJlPUY8yQNrpWPo7uaFfx0bim/nMf9pRb6oY4gxE8bjOExZL344tGyCxpaQqFZOzx3CR3zBcaeuJDwivrRBr1TS4L0S9Ql4UbBmvWxzLkqy0fEefZ4NNw6zwjhJrlLPVoSwPdykpIvb7InyOxAvnzutJyphAB+hmcyianvJAwN7Zj4x3hycmkec+0FXzhoe3+zsTUPKeagSuRoMkq5UFwCqq86f44+
 ZsyNsopR
 GuSCDSgokbq0B1eetU52h8IqpJCwH1Glm9IvLhW6WwPvFyRZZ5qBS1rpq3/mPX3ey06fOE1wyiM1prBWR8GcXQNsHqzfjdyilmNenw1ZIn0i3XATUZKrqagtO+nGj3caqLM5qunKx63uD+ldJTWEAh+Yhb8PFRTIVXZRd0HplRwuCpwUoUcmJdG71RH0ZD9uxOVvNTMiFc1OQvp25Yq2nfY+St6u0MhXT02PcgOq4t4W0iDx7Z/X43+KXcC0PgHs9a/+QxjELxijB59y7wTU00JfGr9lUMtIDmECJhmmr+T56BD4btW0cYn077oI6naryKXe+GazMgqkJmQE/h7wDzombA/IeCKhxNtCQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap_small_pages_range_noflush() provides a clean interface by taking
struct page **pages and mapping them via direct PTE iteration. This
avoids the page table zigzag seen when using
vmap_range_noflush() for page_shift values other than PAGE_SHIFT.

Extend it to support larger page_shift values, and add PMD- and
contiguous-PTE mappings as well.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmalloc.c | 54 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 57eae99d9909..5bf072297536 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -524,8 +524,9 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned int steps = 1;
 	int err = 0;
 	pte_t *pte;
 
@@ -543,6 +544,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 	do {
 		struct page *page = pages[*nr];
 
+		steps = 1;
 		if (WARN_ON(!pte_none(ptep_get(pte)))) {
 			err = -EBUSY;
 			break;
@@ -556,9 +558,24 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			break;
 		}
 
+#ifdef CONFIG_HUGETLB_PAGE
+		if (shift != PAGE_SHIFT) {
+			unsigned long pfn = page_to_pfn(page), size;
+
+			size = arch_vmap_pte_range_map_size(addr, end, pfn, shift);
+			if (size != PAGE_SIZE) {
+				steps = size >> PAGE_SHIFT;
+				pte_t entry = pfn_pte(pfn, prot);
+
+				entry = arch_make_huge_pte(entry, ilog2(size), 0);
+				set_huge_pte_at(&init_mm, addr, pte, entry, size);
+				continue;
+			}
+		}
+#endif
+
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (pte += steps, *nr += steps, addr += PAGE_SIZE * steps, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -568,7 +585,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -578,7 +595,20 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
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
@@ -586,7 +616,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -596,7 +626,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
@@ -604,7 +634,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -614,14 +644,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages)
+		pgprot_t prot, struct page **pages, unsigned int shift)
 {
 	unsigned long start = addr;
 	pgd_t *pgd;
@@ -636,7 +666,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -665,7 +695,7 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
 			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
+		return vmap_small_pages_range_noflush(addr, end, prot, pages, PAGE_SHIFT);
 
 	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
 		int err;
-- 
2.39.3 (Apple Git-146)


