Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E27C624DE
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D8E6B00B3; Thu,  3 Sep 2026 02:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE9E6B00B5; Thu,  3 Sep 2026 02:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFBC6B00B6; Thu,  3 Sep 2026 02:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B77AA6B00B3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:07:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 410A3A0484
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:19 +0000 (UTC)
X-FDA: 85171418598.28.3A759CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84179160003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=POYwD2pH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788415637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRqdRCuj7wQ6F8VvLGXMZbbe8ZSKcv9OW8hrSO5XMZw=;
	b=qCWG6oLKo+huEyo0+6veBZDnwsl55vtcTS8G+SjsfNE8gnaXPKxY+qqy2c/K7ZdiKy4AJn
	ww88hfi5hFvteNlY9R9ZUfJvNZXiN3+GDGigBzAROtlTHm3UNz4gGgil9wMHhFaT0rcmK5
	sTXeuYtolH8wQq6KG77HDVx23T3u7Xc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=POYwD2pH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788415637;
	b=1qJmAgoyu2HsJXWeVMgc9470+ltITi6GiuseCbLpMQ1ctsd2Atm3UN0VolM3Zo1/I8T/hV
	kS84Rd57iL66tCy1NlTjFcFlYiuEI0cqFWDckaIiugo+SCIJtcHVt5XuU8r4spMRYjkWmF
	NZ7/ia9Uxs/lBa30mk2jFO4lx/dCozg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A4761596;
	Wed,  2 Sep 2026 23:07:13 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1104C3F673;
	Wed,  2 Sep 2026 23:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788415636; bh=RRCvk8AHwrIHgucZgMeo3d4bx61Rqtuocq+rKtw+8mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POYwD2pHXvaRovzg3w2novbaLV6mxbra4fzmXVQndnqcPZhve86LX/IlapM6s5yH8
	 EUcecmvxZqpITQkrexEGxv8S6W5XVZ6/y/5y+qnbwg1Cd3xmEx9G8WtOJqiQSZpU/X
	 6a/ICrlsqCvE41Mxqx5Ee06q6dG2rcaveCQaMW/o=
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
Subject: [PATCH 4/4] arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
Date: Thu,  3 Sep 2026 11:36:57 +0530
Message-ID: <20260903060657.2717457-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903060657.2717457-1-anshuman.khandual@arm.com>
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5w4scy91n3pa3jcyfnok9iuck6ger8tr
X-Rspamd-Queue-Id: 84179160003
X-HE-Tag: 1788415637-604017
X-HE-Meta: U2FsdGVkX1/8KQzGziJiLICZOZc9JhMRpXt6m1VLr+y2qUU61Y2Vg/6fT3WiI8tuDjjJyyPzZll0YW0QAFxd5LY9j7b54QIR9J/zJeYkcH864xzfNTtidkoOn6AO5ehBAcjC3sfO694r6uYb8BKtYMcfWKMWc7StbPadlM5PGWLvd2h+fnUqoCqCPeoBu2TiCUlYxabRnf1Y//81qTmJdqV2dmLEu1wCwPuJQDLUKGnQ99s0ov/agLIOvax9Tjv1Fuk/m4g5s5VtZSuGqrUspbx6uOZ035pjRzg9HtJwsa+u2J7MQ93XqDeCtIe4DG6Rj+zIesjwH6jJ0RkTkKz634dP9bCdutvGzHqdCu2w0AaJdPwMNrpLJYJeqPqxpUE2+oh/sV4U1CnduAwu+QH8hE+KyvMbi7Fzj3yZgnpB1dsjgvRigbfLuULr2MWxIrNWX/3TkrLlvJ5XhNgHIdJlnespeeED3lSi1JoImDwoUS3Hv/rpF/3kaKiSKP8nlXfnRdyIFsxEfLF9ZjfZoScq0K+O7l8zki48ZpbMrO0bcD2nF+ER1unvL7CE7lNiLj5cAARM5czC14dTp3nxbE0HUDGtgcKxyaP5cQnik5wwKgJ9ADYsldnG5J9BwBRuC30FXnwaMSTvrHWQcyTLBuZ4D85SegCuovQ8Gl+8QbATpJ+MlGkvfxuLQFgF0XJTcqSOJoeHegUwwM6fnmx670trl1DH9J2epDJ4s+O+XJLMvf8/wcERV+uAIDXORVhH00SQRSvKf9cYQrX1pJhPYn5HXBkkzrPK3MFNPi2cKbaobm6rWbo/TXf7ufHfp31NP78z9lBwfNhW8uIV38WWlERjN/vpusdUK8aJouNqd6t5WuXULMBb4/eyElY4sbDkn+Lp1WL9C7Z/xa66eVUBPjD46chJWBPmEoYUPbhkGtC1xomao2NnlaC/TSdyN8oog8P6rY6nnYgmoKbrq7qax1S
 ApvJHdge
 iaa1KD6z4q0WwqFuqAI9yMm8KNEeWAvd8tB3PsniCMnDfILJH9jHcCpTVUTRKKma9q5lgWIJ9bp9kG9IMwTf5WFMu8ggfLuyXfhgZiP2p37rf8Gp9lb2p1G3jYMrul83U4VA3RzoJQMCRhdYwBlSpSbNouOQbm3gw9qjAwcDpdF4Pb3/bbSgryuggoNsTSZ0m1rGTQxi3TQ/+udHfViE1dKFJZCBFuiZnTYhs88XSaZ3hrzDET4QJ7vdkaUoHvuqobEG3c0PAfHQuUvXJhYlJ4EpYH9sWDibekG/u+I+J38E9miid8GR/XfINhDhbbt5QGD1lRQ+BTW9lqLt+GRTVIrJySNRHqbhuILuFSes/PVq2ke5MSr/gZ35c63pCV3i+5Zy76wvXr3+lGmjBzgmaBD63pMdUm2C5nujCmgOACEPOC4+Wwtl3c4Yjkouh4Q2X2g/jFExxyNmkdZydE+64igJfnUVa8cOKBSpVlRm2vdj517g=
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
index 95d044cf04d4..1de76ced0403 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -160,7 +160,7 @@ static void show_pte(unsigned long addr)
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	ptval_to_str(pgd_str, pgd_val(pgd));
 	pr_alert("[%016lx] pgd=%s", addr, pgd_str);
 
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
index 6f38e3618d26..46ff9a92e73a 100644
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


