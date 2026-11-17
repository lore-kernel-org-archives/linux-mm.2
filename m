Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2ED606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=j/Y5K/W1
Received: by kanga.kvack.org (Postfix)
	id 63F216B05B5; Mon, 16 Nov 2026 20:28:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615FD6B05B6; Mon, 16 Nov 2026 20:28:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52BEA6B05B7; Mon, 16 Nov 2026 20:28:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C95D6B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:28:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88E47A793B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:23 +0000 (UTC)
X-FDA: 85442875686.12.25D13A7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id B213740004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j/Y5K/W1";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794878902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlQ8X6WzNhcNIgXSPIWirhAlwHa7mSr0UHoc8/wb7r0=;
	b=UclM/OpxhIGvCkdg4eNBEVuF8PYSrWAogUL4C2rpIIj8R7FTss3+CbkaoMKJTcvoG+QRHv
	c0GEWpzF88iUeYytpNDU7NXubX0tIPTiMkAoX4mT5K87twdUW+CcLmM5nGL1evE8Gmovj3
	3g84JY7vOE3TpMhAo4YKx7AB9UdrwLo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j/Y5K/W1";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794878902;
	b=cRovVxBHEuzDKSx9NXLJRkpmpnzq6ZB00tukB5Qs7k9+w05yh2nd1YutOA8pkp78o9HNa5
	8HeXe1CbD/oW0DzbTLPO8fWSAG030m6l6rJ9rQtviR2BkaHm+x+t9gGzGhH7O6j8VS0I35
	iDJZ5MDsHgIY3E3xmILj7M7EczM/re8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D651B1764;
	Mon, 16 Nov 2026 17:28:17 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 198043F673;
	Mon, 16 Nov 2026 17:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794878900; bh=LnEejaEQMb/GDrHjcskRfEjL7Sp1VSfP7vv9MQxjRyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/Y5K/W1Fc9vHYcFlBQ285gLu2ZZHi5OJ9a8Dm4WVZU16NSyCgLbBqpayjL+i24Tq
	 5RZT5c6511SxgAznUBEDh/KCj/RNl9qN/qBXvUYZQ0NJ8wgnerddSqtmwUdQd50LGL
	 YfLAjBoIikh8CYtLxUexe2r4+wZVyf9fcpgTurP4=
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
Subject: [PATCH V5 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Date: Tue, 17 Nov 2026 06:57:58 +0530
Message-ID: <20261117012758.3814093-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117012758.3814093-1-anshuman.khandual@arm.com>
References: <20261117012758.3814093-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B213740004
X-Stat-Signature: bdwd5jb9j5z1jcrbghtx4tf31jnbkaw6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794878901-704471
X-HE-Meta: U2FsdGVkX18fXeXTA6+4iPBQjPTV8lNa5xwhviFFLAwwS9b062UzrA7XKryJ3PFK6dbSJjCi+mHF2Cg4Oco8axxs7H0aoTfPqVWUk7HwDvd//3YUvaC2qiTYtrT8oFAKeB2UPY/pvKS7WTvjipCIxaLBv4/aRG+rZ70xlgXKX/I/nWKI8kDF4iBrMguWW0or+VrHVODGsmCszCbxtbu26IkCgjtJzdh78AHhB2beB7mWD/5UbhjdzXTg6HMvHGw/Zc3Gr4PPExvr9i7xdfNeyjGxb3b2ym4kUrOTTd9BGCgw9ptcyVVrMNU3/VEsWP6ELD3dDnOiX2MEamJdPeU+789hnpxT4Z+dCQ8Fq567xxm1W2AQojdjgUU4YSAUpoT4uLLqsG/jfOqia7RqZVbEZS+aF9+fh0MLJdU3Zkb32yzp3zeFNVzZJMSprvvTDnopvqpX5qwQIrL7B7D5C/uyWQFY5yTEmIG0PMnR6peae1QqwHJlrxecmqRmF2QiImiDobRhuPl0N0Ur2TYcuZWbJ4PDWW7r9aKuFfXOXJXOf2k8hkJI2yt65w5ne0EwMiWu/9Zs/RsXTS18YTI8DBLg5qDCFKFyndOs8DIdypfXNG9/SMC3dRr1yW/9/2DL5q8zAvom/PjebBJwzmpRm0PYZ3xQu6qh0i3DAjjYWH/AmnexcPrbfBfODOjd4kgzns8SkNfb//MgfS3gkBHJAf+XdeLxoTWOd8oLR674RWmlUgwWMydXodonvUHi/0OxIDUNZTFYi2xQqixVVlQzqQbWfPF1KmYwKH5+kO1O3Idyg2ks6PD54/oS5w8vFuqbFh+0Z4CsnivzPkFOG66WGaqf0qtTfx6LfKb31waH9Ly5b7OUtrpparRR0q0Zj7BwVDA619JDgDJGFTM/TkrD6vv+UxGcluPxjJQ8FZk8iQjyw25JVUA8+qBAQmZtQhPr1Jxue+egSRBzPU9Zo+WJYMk
 OEt8vi6F
 y/lWhsd4EnvGkLj/6Xn5wcZXvyMLvjK1bIdwh5tu3SKQWUSmgAUjxSqvAtEsWWHpOahV4qWgruuzVyt55RhybM7Fb47wrDK9fq9hKYBGlc6RWRqGXPROeRggTxOrF+c2NB5LFqLBPVvdTl8SHFN8CbboITnoZyN3n/+BDvEjE3Cxefyv76ZLFc02PNWtiLOUWLOXBO4wXekKjmEoAuIsW/wG6uGwDK2TO7yNXcn4X2M11tHsPFmnJz9+i4EJNX2gKDIpl+ZxuN8VT0NlphS1lpDGKDxPtU/GWAx3XVPf/nX4ZsHGM5jUk/r0QO8KWPIMUqFZeV+qAmuW1s9Q3IbEdPYoa3k+axA+jZD8fY1TVEZU3bS7fsl9AjX7H2pXSqi+JmRK5SwU05Mi1EpJLZ3jRn5libuUGc1ngc/XgW6fO4gZ8CqRPBTD8IV4uJ2Px54C34i8DKaHGn1QYnnB4im3KoL736vIZ8u7guYsC/rZHPXK0Jpc=
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

Override pgdp_get() on arm64 platform. Although the same as the generic MM
default fallback for pgdp_get(), it does help avoid build problems while
converting READ_ONCE() in p4d_offset_phys() and p4d_offset() because of a
cyclic dependency between <linux/pgtable.h> and <asm/pgtable.h>.

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
 arch/arm64/include/asm/pgtable.h | 10 ++++++++--
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  6 +++---
 arch/arm64/mm/mmu.c              |  6 +++---
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 7 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7b3463ff2014..a760c65de5cb 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -102,6 +102,12 @@ static inline p4d_t p4dp_get(const p4d_t *p4dp)
 	return READ_ONCE(*p4dp);
 }
 
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(const pgd_t *pgdp)
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
index 2620223d9218..26efacc6c8b5 100644
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
index a11c1949561f..d0a4b8961c7d 100644
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


