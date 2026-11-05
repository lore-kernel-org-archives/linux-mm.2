Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888A8606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mBfyVHJI
Received: by kanga.kvack.org (Postfix)
	id 410D06B05B4; Wed,  4 Nov 2026 23:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1486B05B5; Wed,  4 Nov 2026 23:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289EB6B05B6; Wed,  4 Nov 2026 23:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3D396B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:34:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50A201608ED
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:23 +0000 (UTC)
X-FDA: 85399798806.29.9A82AC6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7C4F140006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mBfyVHJI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdZJpnovM6lNRF0Mo4Sv+yVKUzBD6Nyll5FbjHeB/EM=;
	b=54Bf5XbNnxVLk/YDfAUSyNRZEodkLDgdow30jIBMd0MMOA/E4KqwfYqWDJbW1RbsN6TwkY
	WlxWjOvloJyW39dWkIh47fiGU2BIt2FqAAuVUwcuzQ/dsRmonmY7+11r/NtL/XmcjXi/g9
	n+NchhF8JCzC++oSoUkeWus4B/35hSk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mBfyVHJI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853261;
	b=8MudVSl3okr7E6m3YzUq7nMKJfymCW1nXhzmLsGP2cRC08GbCJgwYcfKRdOyxtWK6OjKuH
	axYN927TZYdC5lKvk5g5dFJpWmYT9qmmbsYmVZUMMYJUTetWm8IW6gQRbxdhwAUrcTAsEG
	XN0g8hkZakj2b5biqPnTfZzDYwVrGWI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BE6919F6;
	Wed,  4 Nov 2026 20:34:17 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFE343F673;
	Wed,  4 Nov 2026 20:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793853260; bh=rp7aWu/XoIApf8cmDyYFxTYta3iMIp0GH8RXgCLwKGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBfyVHJI3WDJls8iQzO2ir3C/Qtnby7Q3jYY12atOyI16ZW6FgoB5+wGLCv6GIwfh
	 CNdfROy47FKqMUo+kU55cfnxPonFz6FddklfX1nsHdy/BkLqYyaAcTWgx1zznV9+UF
	 q9v1+yP7MrIk4om5xqSuA618OzL7WzAPYg1kQFTY=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [PATCH V4 3/4] arm64/mm: Use p4dp_get() for P4D accesses
Date: Thu,  5 Nov 2026 10:04:02 +0530
Message-ID: <20261105043403.3326445-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105043403.3326445-1-anshuman.khandual@arm.com>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7C4F140006
X-Stat-Signature: kc6fcoi8wsncxzj6e13451htqae443qb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793853261-609339
X-HE-Meta: U2FsdGVkX198G3Y4CvQEZCDlUU48hFg7jDmBgWTajXulDz+q8GiOsrP4sPKjBbtabeS7RKq5cx86RN31bltjmtmF9OIrkgl2aDx49k7jQvExxR7dn5qhvIO2xG7JSQxya7Ij/wkWop6LglmRV04r20wCVQ+/qn/psukP3Nfuobbz86rmsukyvyM6edMTmeeixujiiI7CW6DmNMZsv4kEFfLPeRrT9yTnbSI3cN9vUqvlYrwra+Hmm9YGf0JLfVU9LZ+YPKDS9nXgonwjJ8AzdVdczigrd6+9kNlW+ckVKFo+dTNpCaCO7eA2p4c8u1KPJR674cWMpcV8O+thtc+VyS6fUo0WaIGA0qAqFCtkSQnbBVd86Uw0qU2qYQBEXwmkab9lB878rz9uq6RRAzmxiAEF1nOjgTBesIwTMwljDIE1ALnkAWvBWl1bQjJy1+BaudzEhnW2L2wrFJihyEFH3FfaCAvsQev/PyYszw3s4tdfztkNhXldXDJ4cCViLHynRkInXywEKCGssAz066qQJw9QkR1Y+1b4xtHgPINpW+HtstMF/LRQPDlCSJVt9BGCxVKxnWri52RaCbhtZMfm+c1HSUEkL7jWt2jhL+HPe7zFXVNmrryfY14HUI9IeBwRYYag27zHmx7FcJJi+ko0hpso27JODz2mYVSx06dRXPFPGBYyKI2f412KWozwMEoUjSuEzhaCQN//83n6DVwuHIoVF9jJqCSXhbccLQaFyG72XJ/S3tEQ3nMBsS35JVouyMN92+M+gcxrm9VGnjZEkkqQXeL4hm0FS4lY+Vc36RMEggGEj9Ao2BkhwDsnnzLjRb6ufAEvlWvhpXZZMvUiH0eLcR1sNw3u6C9gmRhS1/9LAQAj+WNCggBubLac5CgP2Mz14+m0J36XBlZfsZu4W8psBkgvt+CK7+uhYmpMWLW2gGCFTUHA1W4u6glY7iScWiAtb4XVFDGuBDILcRi
 Y/isoDBi
 q+sMhqe8pQOmBOkAzlnsMoUs1ut3m8PKHW+Y7Y6MjNXVbAMjO35nTZFa4lrGA3YwFjD+lRJfoVpn/D9UNjBM83wC3tJvh16qCVWqZYDQYKfDrMWsbI/6FYb0BNbKD9SQ8ALbml4SXk3sPdg7POVWkkJy6Fr7dYqlbd3UuJi732DWb4DvReo1j4ZisQ0G+vl5TAKDwrM3Q5U8bUwWOvphbJaLalHE0CqdtjeiXs/penno9reEY+W60lubfppZRpMtWUM2yykPJOUydWFR7145qvTutB6vu6tGzkdpEl1MX0FOxP0nvYAjiank+gnnOVrl67lIA5Xy/yiA4Iv1Gjpb9rGFgRcpudRQf2nvHjk1MeOt7mOUtMrkFb486oItJhr1QRDvg0T9LeDh0jFtYwCgSKd+NzCidS4iYDKHN8L0mzQKAY9hnjRLLCj9+EWprebVmdQPjoaT2VeGiib62i6va8mjAyjRuEcKnax9mdpyg45nvKv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace READ_ONCE() with p4dp_get() for P4D accesses in preparation for
supporting both D64 and D128 translation table formats.

READ_ONCE() cannot currently be used for 128-bit page table entries on
arm64 because it does not provide the required 128-bit single-copy
atomicity, causing builds to fail for accesses wider than 64 bits.

Although LDP/STP provide the required atomicity when FEAT_LSE is
available (as required by FEAT_D128), extending READ_ONCE() to support
128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
so doing so could encourage other 128-bit users that would either fail
to build in configurations without D128 support or, if D128 becomes a
runtime option, silently permit tearing on systems without the required
hardware support.

Instead, standardize P4D accesses on the existing page-table helpers.
These can be overridden on arm64 to provide 128-bit single-copy
atomicity when required.

Both READ_ONCE() instances in pud_offset_[phys]() could not be converted
into p4pd_get() because of cyclic dependency between <linux/pgtable.h> and
<asm/pgtable.h>. Move the function inside <arch/arm64/mm/mmu.c> instead to
workaround the problem.

No functional change intended.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V4:

- Dropped p4dp_get() platform override
- Moved both pud_offset[_phys]() inside arch/arm64/mm/mmu.c

 arch/arm64/include/asm/pgtable.h | 12 ++----------
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 26 ++++++++++++++++++++------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 8 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 96cfcc70acaa..8dffa7f787ac 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -960,12 +960,7 @@ static inline pud_t *p4d_pgtable(p4d_t p4d)
 	return (pud_t *)__va(p4d_page_paddr(p4d));
 }
 
-static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
-{
-	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
-
-	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
-}
+phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr);
 
 static inline
 pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
@@ -976,10 +971,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
 }
 #define pud_offset_lockless pud_offset_lockless
 
-static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
-{
-	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
-}
+pud_t *pud_offset(p4d_t *p4dp, unsigned long addr);
 #define pud_offset	pud_offset
 
 static inline pud_t *pud_set_fixmap(unsigned long addr)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index ea0cdc730768..934b534c5b89 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -174,7 +174,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		p4dp = p4d_offset_lockless(pgdp, pgd, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		ptval_to_str(pxd_str, p4d_val(p4d));
 		pr_cont(", p4d=%s", pxd_str);
 		if (p4d_none(p4d) || p4d_bad(p4d))
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index d9a870836faf..2a0fe0b0f771 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -74,7 +74,7 @@ static void __init early_fixmap_init_pmd(pud_t *pudp, unsigned long addr,
 static void __init early_fixmap_init_pud(p4d_t *p4dp, unsigned long addr,
 					 unsigned long end)
 {
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = p4dp_get(p4dp);
 	pud_t *pudp;
 
 	if (CONFIG_PGTABLE_LEVELS > 3 && !p4d_none(p4d) &&
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index c9ad5e75b073..5771bf49e1fe 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -288,7 +288,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		return NULL;
 
 	p4dp = p4d_offset(pgdp, addr);
-	if (!p4d_present(READ_ONCE(*p4dp)))
+	if (!p4d_present(p4dp_get(p4dp)))
 		return NULL;
 
 	pudp = pud_offset(p4dp, addr);
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index aad29bcc7622..4dd8c1186471 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -89,7 +89,7 @@ static pmd_t *__init kasan_pmd_offset(pud_t *pudp, unsigned long addr, int node,
 static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
 				      bool early)
 {
-	if (p4d_none(READ_ONCE(*p4dp))) {
+	if (p4d_none(p4dp_get(p4dp))) {
 		phys_addr_t pud_phys = early ?
 				__pa_symbol(kasan_early_shadow_pud)
 					: kasan_alloc_zeroed_page(node);
@@ -162,7 +162,7 @@ static void __init kasan_p4d_populate(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		kasan_pud_populate(p4dp, addr, next, node, early);
-	} while (p4dp++, addr = next, addr != end && p4d_none(READ_ONCE(*p4dp)));
+	} while (p4dp++, addr = next, addr != end && p4d_none(p4dp_get(p4dp)));
 }
 
 static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7aa8793f13c5..711d734a63f7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -367,7 +367,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 {
 	int ret = 0;
 	unsigned long next;
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = p4dp_get(p4dp);
 	pud_t *pudp;
 
 	if (p4d_none(p4d)) {
@@ -457,7 +457,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	}
 
 	do {
-		p4d_t old_p4d = READ_ONCE(*p4dp);
+		p4d_t old_p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 
@@ -467,7 +467,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			goto out;
 
 		VM_WARN_ON_ONCE(p4d_val(old_p4d) != 0 &&
-				p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
+				p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));
 
 		phys += next - addr;
 	} while (p4dp++, addr = next, addr != end);
@@ -1622,7 +1622,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1788,7 +1788,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1809,7 +1809,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	 */
 	p4dp = p4d_offset(pgdp, 0UL);
 	for (i = 0; i < PTRS_PER_P4D; i++) {
-		if (!p4d_none(READ_ONCE(p4dp[i])))
+		if (!p4d_none(p4dp_get(p4dp + i)))
 			return;
 	}
 
@@ -2450,3 +2450,17 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma, unsigned long address
 	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
+
+#if CONFIG_PGTABLE_LEVELS > 3
+phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
+{
+	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
+
+	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
+}
+
+pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
+{
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
+}
+#endif /* CONFIG_PGTABLE_LEVELS > 3 */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index c544a61a5afd..172bc516164c 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -351,7 +351,7 @@ bool kernel_page_present(struct page *page)
 		return false;
 
 	p4dp = p4d_offset(pgdp, addr);
-	if (p4d_none(READ_ONCE(*p4dp)))
+	if (p4d_none(p4dp_get(p4dp)))
 		return false;
 
 	pudp = pud_offset(p4dp, addr);
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index d119119455f1..7afe2beca4ba 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -99,7 +99,7 @@ static int copy_pud(struct trans_pgd_info *info, p4d_t *dst_p4dp,
 	unsigned long next;
 	unsigned long addr = start;
 
-	if (p4d_none(READ_ONCE(*dst_p4dp))) {
+	if (p4d_none(p4dp_get(dst_p4dp))) {
 		dst_pudp = trans_alloc(info);
 		if (!dst_pudp)
 			return -ENOMEM;
@@ -145,7 +145,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
 	src_p4dp = p4d_offset(src_pgdp, start);
 	do {
 		next = p4d_addr_end(addr, end);
-		if (p4d_none(READ_ONCE(*src_p4dp)))
+		if (p4d_none(p4dp_get(src_p4dp)))
 			continue;
 		if (copy_pud(info, dst_p4dp, src_p4dp, addr, next))
 			return -ENOMEM;
-- 
2.43.0


