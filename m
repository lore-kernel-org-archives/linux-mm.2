Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F94EC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125A76B00AD; Tue, 22 Sep 2026 02:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FBA6B00AE; Tue, 22 Sep 2026 02:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69806B00AF; Tue, 22 Sep 2026 02:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD8336B00AD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:16:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32464160415
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:58 +0000 (UTC)
X-FDA: 85240390116.29.46B36EB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BDCF120002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bf29M5Gv;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHeru9HmgZndZJjJo1Oo39VKwGZsGjV/zQd7b8sh7QU=;
	b=peKSUNkM2x38P2rbp14MndM81km+MwE1BWxRtp1F4ORKeXBO3GaH3FhSW6T6JaqAjs6cxv
	c9KZL9SZJYDXmv4K9DErsT6iWByXWYblV4IuBlBUqVXfOdGrKkQqsE58pAMSoPRhCZNZ5s
	yfscnFruqdVb/Excx0wn0q1UqzMm3Lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057816;
	b=JwYr0v10dRK4wPO5UQH/WJtCG9lYfAZNIDO4ywLdHfU+K5ACHwlRDxZo5kMSu9Gm5LKs1s
	Mzywaf+FIb1vTgCwLnYfB8SDtwAqCkIfyjWlB58Qkp9ZFoLFWOMzLE+MbL1KPpKOif0uSb
	5yCXppIdiI5arLD3zFvKjrlL4xbe6l4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bf29M5Gv;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1DB4152B;
	Mon, 21 Sep 2026 23:16:51 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F81E3F632;
	Mon, 21 Sep 2026 23:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790057815; bh=MpnntGHJ8hu3lzncZnuAewJpmhM2iJ+Ei03Xl4MTGF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf29M5GvjhPa+GXFpLah+FqNO9adCknuWuj7gh6DWF3CdMKtV6K6W7uzCfTThPuyf
	 o8sfPSxEtlIUezX0Zi0+ZvqwPDUwIhIYiYhXYNOS7X2oieTub00Jofeg0p+zeEEaoc
	 uZv4pSO9QRu+iMo3Y54vBM4l+fxijgjrkQZ9cD2I=
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
Subject: [PATCH V2 3/4] arm64/mm: Use p4dp_get() for P4D accesses
Date: Tue, 22 Sep 2026 11:46:37 +0530
Message-ID: <20260922061638.3967467-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922061638.3967467-1-anshuman.khandual@arm.com>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ir97b7pk41ns4bzyw554cxajyt14u193
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BDCF120002
X-Rspamd-Server: rspam03
X-HE-Tag: 1790057816-439618
X-HE-Meta: U2FsdGVkX1+IKpjNZT1DsLTIFxXMbWJgy4kh+L2v3grwHervaaFY4b3kvAR4ZmJJbXvj22jy/CmUI3M00O+mje27JNdqEX5cL44tuRCwcM68YvDzQa1k8gSJiZOxwwllo1Db3miX5rAb9lz1uNOvJXCkBVkGNMbjTwKyr+Vp3z/i9e2E9wiDzG7u+SPwGi0hvPabpgRjBHN/R1k7fqwFTVNapPUrd36zhTRZ9LVCtFfyQjIfS15UixxcsTP/ABDdDnuMpL7ZjgogRGaBntaGmTvjYP02V/4/JIJwL0s6W70ifTzfV5Auq+VvqBahX8b0p+rgjlxoPjsKN4iv6FDXvaGVv/db4C49ztW33HQCKq8l5unjyF9Ckf7DCvLbWMD3VlzsiQL1xfvH7A7wbffH1GyCnVVpxP8sZQpwx8RCzpJfTE4LJzHLcVSanfDJNsyCiQTBL2ngn8sBiwYNxhIh9JSmwXrCKTOrIuz4ejier8sRrg3UYFwl43UvUE3I/RFsu8BoE/ZSz8QyXz9zJbkAOJGN6geTRIWnwAbB2vwX1pilMnHvOth5SeOjm9TdrQx/Nlen07xGvwHevT3ep/62b2P4WxnnOGffsD2/eg/T6HDKoCCDfRg47mwWb7hDkPB/3DihUF0UNYJueoKtE0r1z0qDERSCCfUWyhxtmJiLqg8kWdTN0y+qLlEnp6mLwTb5IrQ62oGudfb8iX8vY8N0QGfLXOLqCXlSgWT+p63Pkrh4MlWYH+ys65WL3rGth/Dzuk+4/Zi4VAl3fe94hl7Vpr1l6YHIW3Ce3oLmm0qOsVlbizFHWtTKckD98qAf/NwePyYnOAIhJAEuy0a7GOKXLIXwL8Sy6WmTHSyOgbTcZOiaUGn3PGWrUlLOHJr1taJF6FUonjpCyuXJnyaticQHkPRmSkykFrv3iaWphsmFOQRBWXSfP0Vstk3uWvp8BqIaMLbvo07bo6Q6rhfxPjU
 m6KmP+2M
 Ft8PVIKZbOnTz452UBeKWfC01je9zksRxFuVbyTkAvb364Xyo39xW98YrwMSOns5JYfsBkYhgqVXrC3IPa0nVAafTNi26RK4HZfCBto31J3yhMnqtq4i+4o+fmFM1RB9+DSzOS3ejZOPcHMuAbvD+qerwg7cX1elQ59KAXHYmnaMeLIgBRD9CN0beyrH6zdtgkOgc3ehGoiuMJtTPPYUYxBz4hfXGJG3azYVcIdHHNK49qK4bK53EsIU50rCDUR9SGXDaN6D11evRpjZN5A5yHfY1zoKFYRmHnkehQ2x5eWkmiiK8Uwv3LbKqzsxmPWnvkcCdWimWSarp2Hsk7fTDJ+uAMQYvj5enWjktT2h058/giIN9gXGXcE05KsP/CaMRAq+qzdlwe3W7hlAbYaJktggWvRhI2b0oiMQJ7A0uYtX0PAFjglefjQ3v5CCi+yDQrrNesC6P0ZC0nEGyd2tgyBtbCmFl1811jrImj5h/ogTqtRM=
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
 arch/arm64/mm/fault.c       |  2 +-
 arch/arm64/mm/fixmap.c      |  2 +-
 arch/arm64/mm/hugetlbpage.c |  2 +-
 arch/arm64/mm/kasan_init.c  |  4 ++--
 arch/arm64/mm/mmu.c         | 12 ++++++------
 arch/arm64/mm/pageattr.c    |  2 +-
 arch/arm64/mm/trans_pgd.c   |  4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

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


