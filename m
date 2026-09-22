Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314A0C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7896B00AE; Tue, 22 Sep 2026 02:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEBA6B00AF; Tue, 22 Sep 2026 02:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE196B00B0; Tue, 22 Sep 2026 02:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0F0D6B00AE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:17:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD9FFA0442
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:17:01 +0000 (UTC)
X-FDA: 85240390242.27.E903675
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0AB8E180004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cg8BnpDI;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLAWG+zZZwAZ8VbqEUmqIMJ4/VP13qJLKYc2nU29x0c=;
	b=HVkeixLhcMjqVLL2ZvN7EpZzDjNuYdfn0F3bzMNLHPyZAZM3zv30LBRMcCvQBTqJcCrxS2
	+1I6Q28/clZj1ylLdqKiHwEFbnNqOxNzM3D4JQsmlMxLWIdsBRY24KBayM0VXTuSM/jSa7
	1wh9I1PSRknCDA8HtrM6qor6NyalIGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057820;
	b=8Bv4BVN2vAH/vnywSQ9+RPIMoNDrgB6xlnjderLaMm0KhzZJcwa1Vhoxd6MCQwJOqzOgj9
	P4CAKf/z8KscLb1xHGTtK2JUZxrEF83bMsCKGyVilBN1Iu4v7kwuEhtMiI5XVZmpNyBKkR
	Xk/3wHd+BOVnWSiqb0xAkmKJ3ME3sQE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cg8BnpDI;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F29C152B;
	Mon, 21 Sep 2026 23:16:55 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F45F3F632;
	Mon, 21 Sep 2026 23:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790057819; bh=YPhwXo+wZb0LPzJLyEuEwvluXfQVUw7xmrdIkATrj74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cg8BnpDI/5IKSPk/5ru5ySdweqI1LGvk1Pa2oXZsbp3x36QOPFvgMuaia0rW5PPLp
	 dhvJ7I7EH2FSskGukOJLnUcHlRc6HS7ihY1PRZ+toTOH90AQVnzXd62YuoU6TOJP+A
	 12/IDLzudXUaqgX2a99CidvFZ2M8FlWRhdaFPevo=
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
Subject: [PATCH V2 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Date: Tue, 22 Sep 2026 11:46:38 +0530
Message-ID: <20260922061638.3967467-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922061638.3967467-1-anshuman.khandual@arm.com>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ibhp1cb3ppthog9h7orz4zuqfxwqbttk
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AB8E180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1790057819-895480
X-HE-Meta: U2FsdGVkX19K8j89XE29O/V6tN5JQN8i58FoZJ0IpIqP1pXJjF3vip8fWAEIiHo4B0uw+zdpnx5+FDCDaJTGFZiGDxfNteBjikENRGRGaaZRS6fts9D9KzQ+666+dzQRpddIdQ3PGWwekRbmvr4X2xtSxywGcgkShEdQtHizXd7qb92+WzX5XpknluMI1zVShbOdKp/nwihT6J5l/b5M7LLysiv07wiChRa/Uucjfn/o6Y8m5m2E5Qd4RMqj9lUFE8jH8DOsdsBa/fKMohHEjgE5aH7c6zYPQ20bW+kMQTRLALNZryWQk66XFxUw2hSsr6OsEa8s7KnlXFOStIF85fs54qFt4y607kxDDElNXNECohF9Z16rYSZpxJY4BHKOygU+GHHywshWPkRTZc9Gu17lL7Krsb0AK29r1LrWfUsNQ3vX4Mz22ytcgtODonDV76J+HMHxbj2cnGJ2txKe58MQ+g0+I+PpLH351O5q4vhwqzm4Drfk/Kag7m3eQfoE2IWSknNvUay9iSvReXcuvvoqBq+6SKxTshdGmI2nuPRwalDnNAOcctXvKdVOjthNKKLM94I+30ej2VTrHHKIZQNpQrbsHqrcQWkY5xteO3BNDjF9IHwriNHijgTaMxyz1GB8eRmjTkVW+L3Ew1l456xv0Ykql7WTyYBgJUAlZNEwm4UHAqzYYhCHaX94iHVj9lOfUkYTjxMlQ5+engtHNw2KwDk3lxgTydbjJ6L6tkILqh25YXlPd00NwCdvzgjS9OJCkuLI3H5HjC+Mfz43R7BsdbU4ZMAL6PJz2/NvRdwaOkTQKX+UHvjulPL5XTqSnaLBMdVnx2fi7qAVKcAOJwt4Bb3nyTzdbtb88kDNAWOLlRm0+XJg5dWnQqJ9e7ZuULGF22UbzonNJxy+JGndkO9A1+DLfSBseHC+xmDxbp9V32k6BoVQzcakrXNc/IJNCswqDhoLJVACC+PGwyy
 0rP/uNBB
 IplM27c9BqeUHBjhf59P4lEEZawE/QsTwWFaRknkI59Kfa9gGtSxdE6m7Q1Mbln4ivyOfZG3fDYISBKd+nIYA9Pcyenn0UEohmcNG+4VMSqVw8r5B1r0IuH9Bh1R89uQVISA4hVBPndxY77c9bjYTnf7MaUx/OgjEHHb+sXz3TJEwaJpwRt7oDFF51kUnvNA38wyKPoqfCITGZGN0DOmJwE3QLdH8obtvfnlXu5J4Xu7py4vFExA7W0n+BxC7MNuf78B1Tji/Y/3x1EOvUKCexPVteJfnjaZQEk/iFxg9ISZ8YKrAwqGV4tKX83sUIlNyA9fXnmb4dptWWN6JgdiSCR8rfwP0VgjEXQZvm9BYxSXcyOZAwoehtdhrIhmYzPbYOkmTXW9ZsL7Dl0b0spJsIyzgW8H1MYgTLpn21bCgbFwpxSuKc1yQrlXQ10kFjdVTCyEP65bLtEKHxaTTiNx/qZ5iZvjIA1yqKtuyDYocSxp9jeU=
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
atomicity when required. No functional change intended.

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


