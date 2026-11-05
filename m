Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09620606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mXr+2q0k
Received: by kanga.kvack.org (Postfix)
	id 9B63F6B05B5; Wed,  4 Nov 2026 23:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967A76B05B6; Wed,  4 Nov 2026 23:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4206B05B7; Wed,  4 Nov 2026 23:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF836B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:34:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4FA71A095C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:27 +0000 (UTC)
X-FDA: 85399798974.16.83E97E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 13A851C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mXr+2q0k;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853266;
	b=OwQ87NyXwYNBcM1Ymj+tSCYLIHj88rx0ebVPY8s1Ny1RaQriZTdQIajWKSShhgY3PuwK7x
	h+Xcg5rJK6SLfsRGAw49e/OkAKYEShMsrHnZuUpuieMjAmcPEHv9RGYg5RlbpdRrgNZjYD
	m6tK0/dlE0DJCrj8HGy/iH6SgLlOSoU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mXr+2q0k;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gDPj65v4kU4IoOQgkvIJRh3qMYya8c6ta2Q1iTNIEM=;
	b=5Yd0LG+R5MIaVMlmfYE7+zNoUFnGieUjn/5El/GMe5hPHxnZIoqkKYauuRj8WNtSC+GInk
	8G23lNV6lq1/l263S7LD11pdUIb/X/7gu3DrDzvlrt6WMMHCkR0U5vaPSSGJn6EhnFNB58
	fwTB7eVQC5uDtu+Ebep0ULCe+arC3nA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39AFE19F6;
	Wed,  4 Nov 2026 20:34:21 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E6733F673;
	Wed,  4 Nov 2026 20:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793853264; bh=YMvyhBBWtwmuxhWT7mouYJfWEoDx0fz5M8Us5l0el7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXr+2q0kLwlFvxodJ1lH29upT6NrCnrtZ6SE5usG/1+6VbJ0D+uxxOKSyFAb4GKuy
	 aWQZszzdI1FgJZWALDPvjKW53MC9oPL3u0DxSo8O8jWwkOT7+K3Fk5lwoWWvN+HlBP
	 LROVLc7PBvdRSJz1JxNLH+TQRi9+sv0TG1IdAbQs=
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
Subject: [PATCH V4 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Date: Thu,  5 Nov 2026 10:04:03 +0530
Message-ID: <20261105043403.3326445-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105043403.3326445-1-anshuman.khandual@arm.com>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13A851C0004
X-Stat-Signature: 6reb1t93iiy47b7rmopgcfsyfgck7c1b
X-Rspam-User: 
X-HE-Tag: 1793853265-805697
X-HE-Meta: U2FsdGVkX1+d2MWOftyTNT4Kl9uNfFaOtNiAjia/IWknGZY2ia4GIOlEM9WsKpHsFCHxP5QeWhsS+Vik7pHHLtF5ZQRW0EEcR/b2/d5s1THcQP+y8WNBf2s+xsrbIU1T9JeDqEsPOcNVG2As8X00DRljMndPS3+1gBEIESfOpPVYn0t2G5wt1RoRo5xE22hGjxovNGcOsRd7zopXDGUuAmMl94NdWefDkk2ee2dxKLRD+A4yXfvLAhORdqZ6Fy8jAqALnlaA73GhGnhVgXu8u2CUeoAC9TrqX9BkGHudI5nhBqb+E69RzN7xik8Zvl4+eSjBigdSihdu0y9eZ37IaDGV9G+q61cMUeGFrTlcLkExevmXnh7NxvQKC6X9ed9tjDkUABz4AIhDaB8yl0SQWSk8Q8d+YoWPn8kJq2D4EiaqeEx3u15LLvrHu8P0Le2wG87duHJUxB4KdAa3TCTwC6HT6lbbWg3mouYE8unQRWMdZWJsBgOKkN+dmvQ5GaRxEPEot/G5cokRbHH1a1lo7w4pLNO4qRtysXEohjm+zqLAZOduBgG5P8LBiquzP4YV3SQgJbUsZEsUOtohzFQVwpK/mbxuUeRuo37Uod3iR+GH/gXXKuTBFbDtEHMTxdpLNCWAy38ERkwWqhEXvtaO6MKrCtDRbFHm9bM83E35QSkvGKtONZzhhBZlt2YAEFmek0Lw+OIZHx2A8/M/4mYMZSIWLrhm47hCUPf14gMSKiOO3dmDzhgLwO+qCArqjc9A6QFk7Fq4Nxk6Ny8jX7bR/LXqmXXPTMovYXFBqiNjPQVhkXKTNxjjONDuqz7SVtpiebGPYqXKZ/YazPfMLXn/B/igBktdY21e7C8J6pcBqmicPmdAGybXKaECnDiRLIIuxaIVwFagOghajRD+6sWSYjHL9VuOSLS94MFIGTabAQs9lQq34zWnjRUHUr5WHicJjIVpsNPx2HBzKCB8yz5
 wiFu9iL8
 zeziI40B1igX22XvLEmnfW2xJXOdribw8tnavk5AzB+lJlbMdyARknSBqho2wwIDjwYRMch52wDTFThXMzvQZOzG596ONu69XjBPycFZsXfkZ21YeeLLxpfRMczbyBoilEqagTZw585e6x/shOQo35vL/wRArcYKhXtJabXnUMDrCeVn8vg8b2DOmGvmCV7VhJu5iKTuIxCEILfP5jdHwNoNYM7baiJb7cWaDVnJF7JEiy5su9n9nPIPy03PmUxORyCccntQdDF7TJjto9cmleH1d7exft2ny75zmLd1J4zWYdWL0QmTnn1DLCJKL2I8cUpAXw4PJWKIMF+E7BrEwCogvqz5qdquRT8q5AnJNugA3BI0a9jzTqBD6ErNBEu/IeY30JT4DMUPjmRn00OU0LuFL7xoc/m5peoBuQwQtfWxJ8eUMrDcK3CV1f2fyNYRSeW9djv/zmnaBYaMUnBHyIer16EtpYT9SnhWfmsjxJqhJaMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace READ_ONCE() with pgdp_get() for PGD accesses in preparation for
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

Instead, standardize PGD accesses on the existing page-table helpers.
These can be overridden on arm64 to provide 128-bit single-copy
atomicity when required.

Both READ_ONCE() instances in p4d_offset_[phys]() could not be converted
into pgpd_get() because of cyclic dependency between <linux/pgtable.h> and
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

- Dropped pgdp_get() platform override
- Moved both p4d_offset[_phys]() inside arch/arm64/mm/mmu.c

 arch/arm64/include/asm/pgtable.h | 12 ++----------
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  6 +++---
 arch/arm64/mm/mmu.c              | 20 +++++++++++++++++---
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 7 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 8dffa7f787ac..6a38de07e599 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1072,12 +1072,7 @@ static inline p4d_t *pgd_to_folded_p4d(pgd_t *pgdp, unsigned long addr)
 	return (p4d_t *)PTR_ALIGN_DOWN(pgdp, PAGE_SIZE) + p4d_index(addr);
 }
 
-static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
-{
-	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
-
-	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
-}
+phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr);
 
 static inline
 p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
@@ -1088,10 +1083,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 }
 #define p4d_offset_lockless p4d_offset_lockless
 
-static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
-{
-	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
-}
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr);
 
 static inline p4d_t *p4d_set_fixmap(unsigned long addr)
 {
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 934b534c5b89..0b489fbeeb07 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -160,7 +160,7 @@ static void show_pte(unsigned long addr)
 	guard(irqsave)();
 
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	ptval_to_str(pxd_str, pgd_val(pgd));
 	pr_alert("[%016lx] pgd=%s", addr, pxd_str);
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 5771bf49e1fe..e05e5b41ae50 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -284,7 +284,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 	pmd_t *pmdp, pmd;
 
 	pgdp = pgd_offset(mm, addr);
-	if (!pgd_present(READ_ONCE(*pgdp)))
+	if (!pgd_present(pgdp_get(pgdp)))
 		return NULL;
 
 	p4dp = p4d_offset(pgdp, addr);
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 4dd8c1186471..f61f5bc09467 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -102,7 +102,7 @@ static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
 static p4d_t *__init kasan_p4d_offset(pgd_t *pgdp, unsigned long addr, int node,
 				      bool early)
 {
-	if (pgd_none(READ_ONCE(*pgdp))) {
+	if (pgd_none(pgdp_get(pgdp))) {
 		phys_addr_t p4d_phys = early ?
 				__pa_symbol(kasan_early_shadow_p4d)
 					: kasan_alloc_zeroed_page(node);
@@ -256,7 +256,7 @@ static int __init root_level_idx(u64 addr)
 static void __init clone_next_level(u64 addr, pgd_t *tmp_pg_dir, pud_t *pud)
 {
 	int idx = root_level_idx(addr);
-	pgd_t pgd = READ_ONCE(swapper_pg_dir[idx]);
+	pgd_t pgd = pgdp_get(swapper_pg_dir + idx);
 	pud_t *pudp = (pud_t *)__phys_to_kimg(__pgd_to_phys(pgd));
 
 	memcpy(pud, pudp, PAGE_SIZE);
@@ -280,7 +280,7 @@ static int __init next_level_idx(u64 addr)
  */
 static void __init clear_next_level(int pgd_idx, int start, int end)
 {
-	pgd_t pgd = READ_ONCE(swapper_pg_dir[pgd_idx]);
+	pgd_t pgd = pgdp_get(swapper_pg_dir + pgd_idx);
 	pud_t *pudp = (pud_t *)__phys_to_kimg(__pgd_to_phys(pgd));
 
 	memset(&pudp[start], 0, (end - start) * sizeof(pud_t));
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 711d734a63f7..1f56db9a946c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -434,7 +434,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 {
 	int ret;
 	unsigned long next;
-	pgd_t pgd = READ_ONCE(*pgdp);
+	pgd_t pgd = pgdp_get(pgdp);
 	p4d_t *p4dp;
 
 	if (pgd_none(pgd)) {
@@ -1649,7 +1649,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
@@ -1827,7 +1827,7 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
@@ -2464,3 +2464,17 @@ pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
 }
 #endif /* CONFIG_PGTABLE_LEVELS > 3 */
+
+#if CONFIG_PGTABLE_LEVELS > 4
+phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
+{
+	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
+
+	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
+}
+
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
+{
+	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
+}
+#endif /* CONFIG_PGTABLE_LEVELS > 4 */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 172bc516164c..b3b7c508564f 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -347,7 +347,7 @@ bool kernel_page_present(struct page *page)
 	unsigned long addr = (unsigned long)page_address(page);
 
 	pgdp = pgd_offset_k(addr);
-	if (pgd_none(READ_ONCE(*pgdp)))
+	if (pgd_none(pgdp_get(pgdp)))
 		return false;
 
 	p4dp = p4d_offset(pgdp, addr);
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index 7afe2beca4ba..06470d690f9f 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -134,7 +134,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
 	unsigned long next;
 	unsigned long addr = start;
 
-	if (pgd_none(READ_ONCE(*dst_pgdp))) {
+	if (pgd_none(pgdp_get(dst_pgdp))) {
 		dst_p4dp = trans_alloc(info);
 		if (!dst_p4dp)
 			return -ENOMEM;
@@ -164,7 +164,7 @@ static int copy_page_tables(struct trans_pgd_info *info, pgd_t *dst_pgdp,
 	dst_pgdp = pgd_offset_pgd(dst_pgdp, start);
 	do {
 		next = pgd_addr_end(addr, end);
-		if (pgd_none(READ_ONCE(*src_pgdp)))
+		if (pgd_none(pgdp_get(src_pgdp)))
 			continue;
 		if (copy_p4d(info, dst_pgdp, src_pgdp, addr, next))
 			return -ENOMEM;
-- 
2.43.0


