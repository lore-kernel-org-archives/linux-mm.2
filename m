Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DEBEFB7FB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891066B00A1; Tue, 24 Feb 2026 00:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844D16B00A2; Tue, 24 Feb 2026 00:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7917C6B00A3; Tue, 24 Feb 2026 00:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68C1D6B00A1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED3ED58825
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:08 +0000 (UTC)
X-FDA: 84478181256.30.D88239E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49790A000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909987; a=rsa-sha256;
	cv=none;
	b=V4dBp/hx64KLk8TbBftRmouMymnuNsva1apwVuCZK77EBUmserrV0fcJB1UFrPaUgkTorS
	eyIkNgD3dMjVS0brfeySnmQq8qAT8wXRi1Padw4YNqyvygt+EStXf8PV8GdC7QizG1Yx6j
	w8p+mtpYsPya0FxCcdVg2/zZPHN3zjU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxiVFUuLeDkSxqT3ivdHS3XEaH5+5qZe/ROqDJWk8+A=;
	b=EQAQMnXCkOhqolABpnOy8k/STFLO7lMvE3QrEE1hnRZf8AK3t2FhNUux41/PogwyQSLcDc
	navuB0Z4hBsm6EdNT3ZJXW79rp4XEHZX3dXNV4IJfpUxRnUy9zGQ6P+ozDhX9pJ45fi2az
	67LJIzAu9dLdTtHbQp2rK+GYH8e566E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDB95497;
	Mon, 23 Feb 2026 21:12:59 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C46A93F7BD;
	Mon, 23 Feb 2026 21:13:01 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [RFC V1 08/16] arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
Date: Tue, 24 Feb 2026 10:41:45 +0530
Message-ID: <20260224051153.3150613-9-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49790A000A
X-Stat-Signature: 4ripj9pnuuh415fkqifxjtxjgpyk44qu
X-HE-Tag: 1771909987-229250
X-HE-Meta: U2FsdGVkX1+HAU6+UK5VMf7PXEJdzqK6JJEaEM7beTTmJLwmNrtRTiPV2c5e0QTZ7y6axjJ5Buspuqp8usdnQErHOMJNphQlv9HJXuzZ9khMw78KuPwdvGUSNhMwpr8CuT/1b4aL3FECpGnZyYevdQXdqE8mGs8rXKwjqbKCqMfryLELFJcvHykIEAh/kiMWZDxGKRknDRnCZGTVQjSQDyjMN8c+BSGtDJ2s10EGqCoSjWPe82dvRBSiCQPfKG2due1bOdZcGz0461kxy0hL3n1Y7w7gNfwIytQ/6VBE2pBIINrv2/1ytgH6ksChloMgxs0mIfqO0W4uglIEbEwyXvZy5BQuD5PUIoOnezGp99YtAZIF2xzc/YFR2V6UYHW9VM0X1+j/G7nxoJ2hQKWWj/co74lsiDUAm1Pc5HJz4n885BBKnef8DG/zjD0KXckQkXxh0olH6b6eyz2+eqJf75lCoiOW6sn9XbtDUwHdxPps5inYbJfyZopDu0ZA219VxFbgf3A2bTF8W4MZVUG8f0oLmIDKViv1ASMICDI6qLvl+T3pw5+eAIb3kAcC2ozXECD+1AE7WvJ3E9qujKvWlZVVEnLo6StgnQ9xwMd+DU337knfSUJaC5xxtax5CTUCwf3xc9wfhL3XYfF+veWqG4YWub8KN6RIMchlXCOBWHM6lNVFsN934wz1tQidzdN6k/TSA+Ks3gSejEeVWx5N/nV4zdm9qFQlZkefYNRjrwBJOQTE5/ieDnavD6AXJvKqbpMr6dEDSQ57bJIykP5vfkipySS0dNKweS5E3pg9HmjJmhSY6rZBKt6fpCSMEl62CBdqFARu1nDnyoXTvTZ30onaidslrMv1rk6yVSCtVeaHmY+8mPRfdwK63ySr8wMesiAU0y80UuKcoQMqAr5QBYr38i5cmDDcNdBkOdJ/37I9Ust8xMhBE7Iq+1KEmAdvk5a82+utUP2NItME2Iw
 uRLsWS7w
 oTZ+cinXeJo0mAPdlawtRzlNJ4v7qpubWkT45N0oYnLp/3NtwlNXeZsyKtLma1EAJVZ04ANvQKkdJh39XCgUSlwMJPnAG9zYUuuVnW//bZgTglJUWurxMi+4G1yZCeLmQH4lvE9r6cc1gpdaC/uA5shzrCTW5bZtd7OaDagzo1VquphsqCoD1LlTrivQ1C7RB301Ypzczi52G0ZTe+YUSKxhJ3qbcHir+crTg8dKyLy4eeFEmUWOO7vHihsY59fgF1+uErei9HmYgh/gMMoitn0+Ury+LDNlYtH/tzo/FKWwa8A7tChdKqDUJAQqqvZvLQQ+htWxjfaIXX54KDiPhOaChVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all READ_ONCE() based PGD accesses as pgdp_get() instead which will
support both D64 and D128 translation regime going forward.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++----------
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  2 +-
 arch/arm64/mm/mmu.c              | 25 ++++++++++++++++++++++---
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 7 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 24ea4e04e9a1..257af1c3015d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1119,12 +1119,7 @@ static inline p4d_t *pgd_to_folded_p4d(pgd_t *pgdp, unsigned long addr)
 	return (p4d_t *)PTR_ALIGN_DOWN(pgdp, PAGE_SIZE) + p4d_index(addr);
 }
 
-static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
-{
-	BUG_ON(!pgtable_l5_enabled());
-
-	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
-}
+phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr);
 
 static inline
 p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
@@ -1135,10 +1130,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
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
index f41f4c628d22..7bb14765a98d 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -152,7 +152,7 @@ static void show_pte(unsigned long addr)
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
 
 	do {
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 15241307baec..ccf08ba06a48 100644
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
index e50c40162bce..d05c16cfa5aa 100644
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
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 16ae11b29f66..bcf32d1a92de 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -420,7 +420,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 {
 	int ret;
 	unsigned long next;
-	pgd_t pgd = READ_ONCE(*pgdp);
+	pgd_t pgd = pgdp_get(pgdp);
 	p4d_t *p4dp;
 
 	if (pgd_none(pgd)) {
@@ -1567,7 +1567,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
@@ -1742,7 +1742,7 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
@@ -2275,4 +2275,23 @@ pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 	return pud_offset_lockless(p4dp, p4d, addr);
 }
 #endif
+
+#if CONFIG_PGTABLE_LEVELS > 4
+phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
+{
+	pgd_t pgd = pgdp_get(pgdp);
+
+	BUG_ON(!pgtable_l5_enabled());
+
+	return pgd_page_paddr(pgd) + p4d_index(addr) * sizeof(p4d_t);
+}
+
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
+{
+	pgd_t pgd = pgdp_get(pgdp);
+
+	return p4d_offset_lockless(pgdp, pgd, addr);
+}
+#endif
+
 #endif
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index b45190507e59..0928946a9b19 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -393,7 +393,7 @@ bool kernel_page_present(struct page *page)
 	unsigned long addr = (unsigned long)page_address(page);
 
 	pgdp = pgd_offset_k(addr);
-	if (pgd_none(READ_ONCE(*pgdp)))
+	if (pgd_none(pgdp_get(pgdp)))
 		return false;
 
 	p4dp = p4d_offset(pgdp, addr);
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index 75f0a6a5a43a..a3a48c88e05c 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -162,7 +162,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
 	unsigned long next;
 	unsigned long addr = start;
 
-	if (pgd_none(READ_ONCE(*dst_pgdp))) {
+	if (pgd_none(pgdp_get(dst_pgdp))) {
 		dst_p4dp = trans_alloc(info);
 		if (!dst_p4dp)
 			return -ENOMEM;
@@ -192,7 +192,7 @@ static int copy_page_tables(struct trans_pgd_info *info, pgd_t *dst_pgdp,
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


