Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BFE4C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24AD6B013A; Wed, 29 Jul 2026 10:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE4C6B013B; Wed, 29 Jul 2026 10:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E226B013E; Wed, 29 Jul 2026 10:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5F36B013A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 758D61A06BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:32 +0000 (UTC)
X-FDA: 85041734904.11.ED4DAAF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A431F20009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jXDXd5cD;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRnJTTIxgyJhzAEBmZRsAl++8ZTYNjGGc69RgLSTkU4=;
	b=WTFcVB94YVWqmr+Rp+72tqOls87qNgvmu8fNdlpfHy29UOiXL2TDrBOgq9d8nnpq6bmT0S
	w1gB9cKWT23tJfhqWfgNWmWBrPH+NLqv9GjlNSMZn8+tShdt1IK+CEEzyQmA1MK8lqMftP
	KDSSezoGM+YAHcQieaQmOpprtqwqdik=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jXDXd5cD;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327930;
	b=HXL7NyQt8mJ16fdZRhQD/eMuFVlSnx+ETgonzrIs4ZNSF/UNi8Ys03+6Scfct8HhJRqqB5
	E+Q5RyoYn1R2qehUKh8cyIYcCa4kHngB5ISKjcWM5+pDI8MsmD3Y/YXkG1bmfwLiXx6DaC
	w54PiXKAx9k9ZimVUoRIiExM+IWCef0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA570168F;
	Wed, 29 Jul 2026 05:25:25 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1705F3F66F;
	Wed, 29 Jul 2026 05:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327929; bh=un+ELP9ikVFH4v2qEoGWM42r/ujHaHAs6bDRsgwiF8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXDXd5cDeH2SWCOyZzNVoeIpfyIOczCOGisCQC0jApTdvP5v4wi+P+ceMm603tNWh
	 1O4FkdQxN4y8EcxaGr640ESUR2dQTqnxXOQS23PK+BK7gqfq+PFJ6nxfOGhc1MLC6K
	 vIVJoIkFTlyqVDOSn6dJRodAYkDN8phU1N1qW/fA=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
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
	kasan-dev@googlegroups.com
Subject: [PATCH 05/17] arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
Date: Wed, 29 Jul 2026 17:54:40 +0530
Message-ID: <20260729122452.3797443-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A431F20009
X-Rspam-User: 
X-Stat-Signature: go7ejo7gy8wfjibk6rfy1hqqxgec8ox4
X-HE-Tag: 1785327930-752438
X-HE-Meta: U2FsdGVkX1/lBoOrscukSXKUyGRkplqxcFbApn//5VQXjZs+t2hD1bDi31qjEyMhbbC6xER/t3zZ3/G/omCH44mHUKuEkiIR/RgmaPKI7lwqSNzZSqZdnTVl1I4wXVbpdo7pSfSnbWoXa42Ht+7HSRBwRoi5sxin2Cd0y9JV4RwWB9964yIN+66uPxl6/AFx2JRq4qYk6g3LCUHvkn2MmkX9mIGXEkllMKvqbXsY+YHbImo3Bg/iaFZPezZSKyQ03ujgKE6QxcWmI2yyTnYm3lJS9/Mx+lFfJvPzuDYLGyMCO1WJ8Mu7LhFFcHUh+I20c+n3YT50QFDnDPa8QPVeVJw94X2Xlf8MfRDKotvH0KtQsp4NNLt3xYXA14fSGZDfnltoPlobCu0TedVH4SeHrVyaAbtmGDmP42VniZ+G8p6oLMtahZwsfYam+Z4PiQpzHhibZy24WfTsgQPQmDIIeJYmWA/fZLkwAjjLyP1CK73fvcZGS/xBP1I3ZSpQ60g7llaE+MI53Hb16UvgXKKX6d0wPRLnJDVCsL7owqJKssp6YTcHOxeZg1fqvjiuXWUHFddB4+tcWvSRlzNnCk2FacAZ9wuO/kmK4R5fG7v2tTWyGxdfY7PiL5DbBMFocukDzFkOSQbxJ1rG8C0yacTk7RFNCyi2VxQokfY/DcK8lJ7bdBHp4Su7Ab/272vatrH3fr+enPdOdWqMbLjsLbQ6c2gMrb+JH08lXgMJ4AtLrw9lV8GbYWZ3VP1S9TC4yJ9CYx5GmiY8izAjEqVr0vcnG0jLW0cjS8ZZAg2uNCI8URm9oDXAS0t4135AMTy9dOerMLDhgmrN1GAI7F2XLVcx+FM175rGNedkSj4PVRZyPRiS1tfk5UEPnPVzDSblKJWNbE+sqRclzK4TkuMg2/yPCC9udaMYxUd+5SiRr9jjbg58K3N6H6xl95lfwvb/8MzxPNG0EgeeMgv8PJTmo5X
 OndlTxgz
 QVg/hgH0fT6sMc0Rfuiq0pEi86alJ+EUKji67nMT7M/CmuNUVh7pKai2Nw8NJiVQ5gA5TLW6nyHplh0IQy9ErkDNxjzIZowVMugYohQY7XMmNvl5X7hOl7lxXzvj9RVG2042xQrw0jShv8tEdK744gly9pLFGo7NXZrSfXy1ALubOFmirmwIH3LwpFFn2xSx8hdpyrrUIckqARaBQ5PgVwo/Q2A/AKSe20jRAWIUy94vpR+wYO+g6dVM1GJK1KmGkYYh0pQjE68X0TNvEJ95bgDl7exBACCW39AQ9nt+T0dYaVfDkqqy/lOTl5tJK219ahlCb5RCvVsV5W/iH9w9uBRkiYLxRCKxxr4Ef1RSiTQNAbL+JbiTrFmDuAO3uKmldB8DkxdWiGKsisFwh+YFdlYPrxBrPKq588AqJ4ODE9FIEFg9GqlB5zrHduQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all READ_ONCE() based PGD accesses as pgdp_get() instead which will
support both D64 and D128 translation regime going forward. That is because
READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
128 bit page table entries which is currently not supported on arm64. Build
fails for READ_ONCE() while accessing beyond 64 bits.

Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE128
is supported (which is required when FEAT_D128 is supported). Currently 128
bit pgtables is a compile time decision - so we could have chosen to extend
READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But then
it's a general purpose API and we were concerned that other users might
eventually creep in that expect 128 and then fail to compile in the other
configs.

But worse, we are considering eventually making D128 a boot time option, at
which point we'd have to make READ_ONCE() always allow 128 bit at compile
time but then it might silently tear at runtime.

So our preference is to standardize on these existing helpers, which we can
override in arm64 to give the 128 bit single copy guarantee when required.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/fault.c       | 2 +-
 arch/arm64/mm/hugetlbpage.c | 2 +-
 arch/arm64/mm/kasan_init.c  | 6 +++---
 arch/arm64/mm/mmu.c         | 6 +++---
 arch/arm64/mm/pageattr.c    | 2 +-
 arch/arm64/mm/trans_pgd.c   | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 6f3d30b689ff..fca716ed4513 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -155,7 +155,7 @@ static void show_pte(unsigned long addr)
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
 
 	do {
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
index 7e2bec43fd4a..41b65fd31f76 100644
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
index aceb20e48251..d5b6eb544216 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -435,7 +435,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 {
 	int ret;
 	unsigned long next;
-	pgd_t pgd = READ_ONCE(*pgdp);
+	pgd_t pgd = pgdp_get(pgdp);
 	p4d_t *p4dp;
 
 	if (pgd_none(pgd)) {
@@ -1601,7 +1601,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
@@ -1779,7 +1779,7 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
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


