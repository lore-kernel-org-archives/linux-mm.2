Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1235C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C88D6B0095; Thu, 24 Sep 2026 02:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B596B0096; Thu, 24 Sep 2026 02:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC2C6B0098; Thu, 24 Sep 2026 02:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 082C86B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:22:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71229C0264
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:36 +0000 (UTC)
X-FDA: 85247661912.08.2B44C1E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id C456820004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OPa+4zC9;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790230954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxyIbo/u3CdsE7qDsWfTtiTeOUnmJko1bwoqVR/WV28=;
	b=KmHgAsx9dX/W64jcjIFeorYvQsmELaEvlB30iJQv3xfd3WAnqmpWp4CyWgDqk7exFMfMJk
	WeEJqieo7NldGFj9r6w1oFy/zVveuXLEMxYPLvVj0K5harp/Z9I825Vo0+5SI9oMhSpDjw
	pQL+1tYBtD/esC4sbiDb+Gkb0ueRJYc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OPa+4zC9;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790230954;
	b=4+OmmYV8A9ExaLK1hKwu7Jaq+FGjR/3QqqqYbiVRk63TkONr7AKjri6PT/2N7h93e+4Use
	InupkcPyY77qm2xIQvKPS1hjko7RP+TqrPdFU52FnWQ2gEPkHYnfddSeAtErK9FXWGr+KJ
	c3Bseep5gsrOWSx0RV5+KDztL+i7ZGk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F1641650;
	Wed, 23 Sep 2026 23:22:30 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37B9F3F86C;
	Wed, 23 Sep 2026 23:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790230953; bh=Izqyl3NqNDKyfXa9ucdwjbJWtozKpu+9KkF7o0jxLqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPa+4zC9f9wtpdd0jHUw79KM+PmDxqo33Qy51Nr+CSk2x54pJbO4UOQECBNk17oDq
	 47MeSSMtXam3UGJyZu6M9VB3iRorzwxWRsq7g8W5HqFQbtmH5CdE98QL3hJFujMxol
	 IgHW3ux46V5woHgSfjyTUXHAUC4ccX0FKBiX3G6Q=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
Subject: [PATCH V3 3/4] arm64/mm: Use p4dp_get() for P4D accesses
Date: Thu, 24 Sep 2026 11:52:13 +0530
Message-ID: <20260924062214.1635078-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924062214.1635078-1-anshuman.khandual@arm.com>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C456820004
X-Rspam-User: 
X-Stat-Signature: 4tcfow3mfa17hpftow8mnzx97f95duk4
X-HE-Tag: 1790230954-737165
X-HE-Meta: U2FsdGVkX1/1SwNFxmdMeCr5P++sSQ27blaIwuETQH+5CpJnEtSE4Qweke+56WadSUJKxsHc0da8K0H+1xU547h4S/qpUPzq843RQW/DiHYOw7UiQBiSPVcpg9Oq3H87L56zoBeU8VolyKerfcP8dnuci5Q252sq48IYtPDXu+UgfeU+kCbutY4SWoyBqubTS/1OUsp0juk3Dof1h/Xj29li2ZW/h9fIBvbacnjhyNAUOKecEBRpi1Y6/W/gz1RGHJ9tBq/8yda9sTswJ5wCcwJjDoJ81dr5LD80Z+ozkL+Au85PgpKohbXLuOApOh/+7zPO47WAhJ+cJBOSMqNbsUuO0tOHjHo9tsk6mDv239V7pjnJ0wFm/G7SWngNbkp7kskJZIDRH148sekd6nuHl/6NINCbIoVl7WKTee7pB1Kfr+cQnJAJgFvjBW9TwfZnRf0YJ/pihSKzWcAgloBeehsTSojgmwjuyogXQ3XpdMUd5nwH3bUPv+H24mNVMXoczergbVzupcZ40nPbNNGJVtiOdFdHzPgSCGCb3mCPlD0e+6uNNdOqbKCDRq0okjzOTV6MzKhASVA096OzAncLmx0NcoaGXDqkVX8Xi7rux1xvnZetI70Eobcb588Vbzxu2pv7e94pW2pC19aAw5CgsMjjjsxcTOz2ClIZWcd0+eCn22wXPChS97aijfrFcU6gWg+KCgjsuvd8rrQDehfT3lfG+Z8diyZxAuV9fl9pfnWw+4dLnRnUpF9sGopw5VIKGhiI0xe8TvOxf+pa/wHIzgyS2VmXdxIzxG0GHFGniBEV+2nOBRBtlG8VuXujstCoYykni9UaPIIfjsJgnlc4Xb80fmBcyT6A5Uokiv83VgUbt71zKPp4/JKFt/y8N024wHW5qk2oFEVZzalqB1ZsNJu/wU0GaRIlNIrqr7K9kesN7CSRz0zB1U0gw3VC5Gltqm5vb+SpfBHh4/v3XVC
 3xNkn0cu
 SZoRXva6a3hykvk5MTJ9m0c1VxXWdpK0bQ6yAIodeuOIKT92Lzsbh4ouMJIIGG08/xhSTfRXR5xAM9jz5E2Wo32OqZFdMnl/ofeUcvZPkwbv4lbv1AO9iD81Gvu+maHFUC6dAdMmpUkdnA7E2niX6bR70vsLFrAh6Ej80sE8E0+JB0M080gy73BeA9oqouI6SwQyb5qy4hILust+geY8uBWafivhsy90kA85ZrN8FIHMeSJEBs3MHzIZ8PW0fL1RPmJozsNLoVJgDwBTKr7tDkW56/Rbc9eG3nXY0C8Xl4+2vA7qbMK97K+KSzJlogRLY/1Dr7WYGVQFufiKWmQyyi8bxBIOxojlrnK5FKqLJWRIUvJNvQttQGaIHO2mDNgCMUpHAXCivC3RSfSh1FQLHekq0ehFiUoV5/o3lZ8S/gd1L3R1AmlazCrCcKk5RmA09IuJQpMGsHQL8+1TsYb+fZmhBHmJkSCoYAx5nELpJE0mDdPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

For now override p4dp_get() which is same as the generic memory default
to avoid build dependency problem for callers in header <asm/pgtable.h>.

No functional change intended.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3

- Added platform override for p4dp_get()
- Replaced READ_ONCE() in pud_offset_phys() and pud_offset()

 arch/arm64/include/asm/pgtable.h | 10 ++++++++--
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 12 ++++++------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 8 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b46930f844a2..f235f68a7518 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -96,6 +96,12 @@ static inline pud_t pudp_get(pud_t *pudp)
 	return READ_ONCE(*pudp);
 }
 
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return READ_ONCE(*p4dp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -976,7 +982,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
 
-	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
+	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
 }
 
 static inline
@@ -990,7 +996,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
 
 static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 {
-	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
 }
 #define pud_offset	pud_offset
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 435e2e14c070..a6afd8929a10 100644
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
index 22efaee79293..83709d987e7c 100644
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
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 07b2fa4de57f..826856ef64a8 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -403,7 +403,7 @@ bool kernel_page_present(struct page *page)
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


