Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F53CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3EA28E000E; Tue,  7 Oct 2025 02:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEF78E0005; Tue,  7 Oct 2025 02:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C188E000E; Tue,  7 Oct 2025 02:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B23138E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:31:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B63387F0D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:31:09 +0000 (UTC)
X-FDA: 83970345858.18.69AF140
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1FEE180006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:31:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759818667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=nm+ajaSV/xyiSzQKJfgqTW5GZsupsd8CN7JfXxujEak=;
	b=tFav+7deuaHwEVJIATtlq9ezdEnd+IHbzlVfAwtMWn9YgMnvxtOx33wZTN6/yRd8FFjlps
	hHGWa+Cynib8Q8cFBbdtplrDFQfDLFnfJDEN5BNaaClPlsjhjwq9xzvD23Uh4elPsSnbwp
	CwDH7Ens96MyJ5XmyJCwt6zgoPmp5Mk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759818667; a=rsa-sha256;
	cv=none;
	b=mh8Gz16vCNQKxkwOo88SKGmYdaNQkPkU2EyEmo2D1sqDiBXy3Jg6VEgxJBdKwuDf9G9Ztz
	49k/1u7XnPUaSDnkDvciHXTLQUZBmfYiJohHF9mXpzZwVOGrpz7WfdyVVRIeyeMsmRoKoC
	CraEU4I++QkuyZIiEyAs5Ug/XzgcVeY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0FF714BF;
	Mon,  6 Oct 2025 23:30:58 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D75343F59E;
	Mon,  6 Oct 2025 23:31:05 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Replace READ_ONCE() with standard page table accessors
Date: Tue,  7 Oct 2025 07:31:00 +0100
Message-Id: <20251007063100.2396936-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: az3b1p1x7c48tcfrtkn8c6rjs9k7nryo
X-Rspamd-Queue-Id: B1FEE180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759818667-319439
X-HE-Meta: U2FsdGVkX1+tLIWobfbOyaOl0Dr2dwN+7QA6Ikd/bawrdZnod01TSbeNm7aNmOnMT4CKKxqyr1v9Ov3lYvmOjamo2Ya6apY2AFe4Yny4b6LIYUfJFDeGJuXEUstDoW7qNoFhxVKh1O+32pwBYfbPi6uoPivbN6YuY6w5HwMpHUaliR4hJSsi9A9sHrZhNpPBbOK49aERVkC5hr47wJ97gOeBrdGT176bzgyqX0RDoCuErkgwiXb44ORbrNqFZr0zn/KyfUhQbzVrhFg5qREUYX20mFOmUMPLQsMjrl/KVbc4LptDUvzmyWCWth8cPDBznomukL0n/HlaL66I/C+JzcYGjw3tZfa0k5X/xhoXzLdEVaRdUK8NzNydhBIzCweto9RKhMG/uDhY6E+A+r5MYcPhdBx0+zVRv8XmsQwyNAnUhBAZPfRO+r/N8qZpeiuzmYoGCKBwJijjhqWRM20qg9+NVKphKJRfZaYQir8sXoMVvwLwcGqQ5fKxkxnj51iKHaflhZSfysOS2PI40BmEq2NyaE6O8eJnDVGMHWNd0BdUUtEbaevusxxR6aNRhfqA5e97XtW42SyHR+Xe6w7XnRefRjS6CDo3fc1mxB+KjpmR+NjWsKn291vs6kZoCLcelgZduEJaytYPQeQPwtI1b8D2uThoMvi4XMD5Pxx1HxfeZXP1mY8uIYyYv0K9ygJB/PmCr3Wv4hT6tUxUZVjhsnec+JX1c5ileVEm6QaWRV7+tJT0eqcdwQLYawwp84/+BmSitcYtKeoisTVFemmQleYH3XlsC0jvNibZtb+axhQEzpFgCbUZtn6jucac8ZnVL5EHtGPYpjS4rzo9WzhyWjfmzCG3NObBOQhg1jned2fT1xBPPsjwZmR1Oz89aVD6ekDSJ1wJtTiwAvWxmNFUw0j8rMJktL6w1iqagAskRjc9oe5QJqoMasCwakPM1TrZNmLFz6rQRr0DFlZTAoC
 R+GgaylF
 8+PvApPwuM7c7dOeOtRxSYPYvBS+fPLXq7ZwaopN7XHmfRmyYw42RvaSECk4n+eDgnj4LNG3jeOBi43ZdMss21d24PC61A8ytFfA4QA1vLKik3RZrHmkSBFKE8DUnULR2qIQw3go1bLgFBnvrlEGJqD4YFyHN3303Qg9e28/9uU+edoormvMgmrqVzvarhFIPP0LRoww8AvhwFR99239ChOskeY/JORxXcQRTf6X7nNY/1zevxNxq3oyx9RnxURlVVP7npcn/KZKRfCSoaR5IjHiDWrMNGB2dFx7a5ZQUXs5qtiap9t5tnPN0mqDRpyovKbNoDgJSi0Ri3NhWCllzC4RXGMFVyN2Cub/fGACJ+xN2kx1JcSH7tzM2P+CT+sjDNAWTJ+V3j0OuqnGcqA23tdyeCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get()
that defaults into READ_ONCE() in cases where platform does not override.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 mm/gup.c            | 10 +++++-----
 mm/hmm.c            |  2 +-
 mm/memory.c         |  4 ++--
 mm/mprotect.c       |  2 +-
 mm/sparse-vmemmap.c |  2 +-
 mm/vmscan.c         |  2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0bc4d140fc07..37e2af5ed96d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -964,7 +964,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
@@ -989,7 +989,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	p4d_t *p4dp, p4d;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	BUILD_BUG_ON(p4d_leaf(p4d));
 
 	if (!p4d_present(p4d) || p4d_bad(p4d))
@@ -3080,7 +3080,7 @@ static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
-		pud_t pud = READ_ONCE(*pudp);
+		pud_t pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
@@ -3106,7 +3106,7 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
-		p4d_t p4d = READ_ONCE(*p4dp);
+		p4d_t p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
@@ -3128,7 +3128,7 @@ static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
 
 	pgdp = pgd_offset(current->mm, addr);
 	do {
-		pgd_t pgd = READ_ONCE(*pgdp);
+		pgd_t pgd = pgdp_get(pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff --git a/mm/hmm.c b/mm/hmm.c
index d545e2494994..126c3f42e525 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -431,7 +431,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 	/* Normally we don't want to split the huge page */
 	walk->action = ACTION_CONTINUE;
 
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud)) {
 		spin_unlock(ptl);
 		return hmm_vma_walk_hole(start, end, -1, walk);
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..50f841ee6e84 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6549,12 +6549,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 		goto out;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
 		goto out;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto out;
 	if (pud_leaf(pud)) {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b48985834..988c366137d5 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -599,7 +599,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			break;
 		}
 
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dbd8daccade2..37522d6cb398 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -439,7 +439,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(READ_ONCE(*pmd))) {
+		if (pmd_none(pmdp_get(pmd))) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 674999999cd0..14c2722b955b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3772,7 +3772,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	pud = pud_offset(p4d, start & P4D_MASK);
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
-		pud_t val = READ_ONCE(pud[i]);
+		pud_t val = pudp_get(pud + i);
 
 		next = pud_addr_end(addr, end);
 
-- 
2.30.2


