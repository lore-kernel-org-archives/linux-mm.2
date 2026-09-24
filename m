Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A28C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CFF6B0096; Thu, 24 Sep 2026 02:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E61E6B0098; Thu, 24 Sep 2026 02:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CE86B0099; Thu, 24 Sep 2026 02:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2A86B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:22:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4840440256
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:40 +0000 (UTC)
X-FDA: 85247662080.02.CED39FA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9519AC0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cm95oBd8;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790230958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ek7RsPFc3ldWW7sBn2JVf+V5hwOpTIaWWyHZgTHyqoc=;
	b=275k5x6XL9RZQw61VgzNzyba1Qa0deLTBqDRj98VqQAoneE4KOuSXhBhzJih5TL5gRVFjg
	P4xJcAnPBKpYyAhq8JJ5E6NXTynBhi/bDDfY0iBmZxYy5YALgt7hFrMyDJtAMom5tYMH4t
	yYUWoFC7dwsGxE1PNdyJ5ULIq2dRTpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790230958;
	b=CvG0vU5eKr9RMUmLtl1BY6DZdVhAe0pcESzkXsyHqCzGBKgVAPJqR87bKPdQFjjTxUYipR
	8hHXdoIxQb1zcAlaUcTrcPNtNjMe3xsWNZAFv0Sf9Ibmp7xj9GfDsTMKzUO801csxAGQm8
	tCtNRhBfDXdyXMo31q5F6fyKDjz/SXc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cm95oBd8;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 484271682;
	Wed, 23 Sep 2026 23:22:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F3B23F86C;
	Wed, 23 Sep 2026 23:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790230957; bh=MbarBIp95Pz3ZZkxqGhq8vWSNi6Qxjc6YojSk+L58R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cm95oBd8XRa6BEsVHeaJqsurIo0tIR1i4OeiLxj8Cdc7CcvCD46G8IgbYQsSmTzOc
	 3FcRm11y545CyEPF3NAyOUvtK4BtG2vOmoL2R3uMNR8dc9tNGNb5jGl/6JBpuZ+J8N
	 qQf6LBycrt1yMY3dsWI4qtF0DGNZtG52JoaPJPQc=
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
Subject: [PATCH V3 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Date: Thu, 24 Sep 2026 11:52:14 +0530
Message-ID: <20260924062214.1635078-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924062214.1635078-1-anshuman.khandual@arm.com>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9519AC0005
X-Stat-Signature: 1u13pxbkg38mgfw6spk1a334qwmodufd
X-Rspam-User: 
X-HE-Tag: 1790230958-959339
X-HE-Meta: U2FsdGVkX1/hODu4cb4lpygO20jootisLMcHDXNWzfQdGNciYZ1e+oHXXPRPMgLLQiat14JrPafED/nWbVXtqz0McNBI/+OcznKo1hgWrmatErsLfQj14z77q1CTK0BipS/irfpOVhkWXcBZBKDyqCl/4TYMareCeyKa2xEImmwPs31UtitkCMz2n9dqMjsldsPd4QjO2n/UE3M7jYYphVBuqGZ2zGzNd5b5dm16jUT3v9oqZVbBfxEdIpJHcySiFFgFetDHQiNDVGfsuVr8kut1qDdlxvYVzrOD7R96zVK4qO3Uuc6B8EL8Qu1rc2x+WEI4VPMFKN3MRxWYe3V3EgLFpHR8MzsXjLtUY5IVbkvL7+/Lpbj3TyyimlXeyfU77xRJyTWh1/I24ip/DcUQjFf1lPh2mWBsKO5eHDTQf2fmZKwu28YaN9xf3eaHIfbF0i/mU5LoK2Fm9SibMONazIYrP1cHefQo5oL5KSZhz/JnXtP4v08DkOQpfyxbWs7WFhl3Xmzf+VhOp12iwITVFeHSHkEydS8pC3B0rPd1aqVskHntQTou8M7PUWjXfS2QZ87pZ+8Ec7ChlKWdsBlyGsq3mj2CuOSrkI7C/NXhb9wfCNL79LESlSGnQBj1CWgcE2oHDeDQWDbAqVn/OVjrPxkt8iHhT1J2XHg0INu9E1yZ9Lcj3BZwkyqgTs1yhjD3yffDy0vC3fJrUEGWs5XgOZhRb5DZ0FH/58u8cGRh+6Y+HfNbSMclhe0ngZWFrbuk8NBcCu+bJq3ScfK+NM+2oAwSj7CbyWCKM7jadwyGAjbeNyvNdmzesAEFcC0v5pUrnDWAf310tpwR5lZUKsihQ+OkI1gpTp+C3snDE8j/rjSBWI/Z1/yUedPQ/z3koZP8hvqM55a44GPjTNU64pJcNxb/8jf1wy51kPpX5Dx2yViad3SKYNzzXGgEYLd4A1IV1H8I12J/cbvXMwX6jnO
 ki7NWtF6
 rw/h6w57ES3JvMosEcMvafJZ3A741cu2vUZYuNbPPNQXFO1G4qLsLyOYCyehfdgfnS1++9AbpwnR9ltK3COKuj2RksAb1LXj0zmLA7jxyKYlrvy8F0VJYmHwjeC3qUOzUCP6KqErBgz969GfKUPlX/qNGyEGxG1F4qaINVC61tlBgtlHxGnffEBIA1YC8W89g203Zx1g4yKnGFfiWNg0lAgFUPWfRWghEe64DehV/YTuq5Rrj2aGQT9+DZH53Gi7JatYyHwLH6v3sRaEtPsbPsewW3igH6nRcA71wq1nnBeyavixWkLnPROcGdFyYwWXPqC/Id0KACGq3j/DVew3nxUgQSUONU2FwANW1mguiFHJIk1Abx9H5jZehh1mD79Yyyh/ch2zmzl4e66EzAuVCimf8c+P902RQe2aGDGETjiEHFQqQg5pOgV6nw9yu/eERegeCzUx+cnUEsN6755rID12DYPovi8O/0UT+kfzzYCnvLhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

For now override pgdp_get() which is same as the generic memory default
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

- Added platform override for pgdp_get()
- Replaced READ_ONCE() in p4d_offset_phys() and p4d_offset()

 arch/arm64/include/asm/pgtable.h | 10 ++++++++--
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  6 +++---
 arch/arm64/mm/mmu.c              |  6 +++---
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 7 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f235f68a7518..05d273f276b8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -102,6 +102,12 @@ static inline p4d_t p4dp_get(p4d_t *p4dp)
 	return READ_ONCE(*p4dp);
 }
 
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return READ_ONCE(*pgdp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -1102,7 +1108,7 @@ static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
 
-	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
+	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
 }
 
 static inline
@@ -1116,7 +1122,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 
 static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
 {
-	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
+	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
 }
 
 static inline p4d_t *p4d_set_fixmap(unsigned long addr)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index a6afd8929a10..43f25418275a 100644
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
index 83709d987e7c..76d8d320aeed 100644
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
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 826856ef64a8..dfa1356daac2 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -399,7 +399,7 @@ bool kernel_page_present(struct page *page)
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


