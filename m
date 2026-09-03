Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74007C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EE66B00B0; Thu,  3 Sep 2026 02:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245106B00B3; Thu,  3 Sep 2026 02:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D3B6B00B4; Thu,  3 Sep 2026 02:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5BFA6B00B0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:07:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 826B11A045A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:15 +0000 (UTC)
X-FDA: 85171418430.17.714E8C4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6DA4140007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GgIhfidM;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788415633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDj3PNZ3gDDebzmgweKVGHA+65zRZoy6JivpODRgFJ8=;
	b=0m5F5jc4BSYVk+1IuX2UvIYlz8biK/sioWL/n/t5AogjgE4n2ohx1Kzq4tMj5xf/+4sZuC
	RZBy2kyTT4mU7WtomoNT+3Nnrv7ubU7rCBkTg3dLsJSxjDt0MgANusqgpzaHAF0zeIw5R4
	u+UjAwkY5OEt3LMvXDuS9l4TnbTiu10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788415633;
	b=c+3KEbwJvHgUq9tmFf7cPzsMiUarvf5nLy2Dbdsb5v6Cx4xPjb+ixxz89vEu1i+BdfLUq4
	x3fu5KG/fFm2cpnk3PEPfauRwwZO3qPW0dmmB46SLTWkgQswqRmvV1scvWHQesTUDBGsRm
	kN9JiYOjfPHuUgdE+Z1w6JR8UY1/s0M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GgIhfidM;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51A8E1596;
	Wed,  2 Sep 2026 23:07:09 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55DF73F673;
	Wed,  2 Sep 2026 23:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788415633; bh=WITeshA5Gjlb1wS3L6JWLqI3qWIYQX4SJkJiHNHdcIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgIhfidMPwzwaSmCGD93QImBME/pihHBuoakFAk7mGRoLZvGyC/sr0tmulQJTP7Gi
	 uT6BdpU0oG4pxMfnzPOeq5e2umZBqSk9NoJYIApP7wY7TOFw0eT0YUfplGvAXrnrgP
	 qA+XtUid40qsh6PkWLuE0fRqAvD2Ch2eLgTGjWM0=
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
Subject: [PATCH 3/4] arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
Date: Thu,  3 Sep 2026 11:36:56 +0530
Message-ID: <20260903060657.2717457-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903060657.2717457-1-anshuman.khandual@arm.com>
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kfcioxec9w1hwrr9n9skgs7ht1e4781b
X-Rspamd-Queue-Id: C6DA4140007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788415633-971392
X-HE-Meta: U2FsdGVkX18d4VQUNprcQJs9/zmct4mhOa3/15ic9z3LHUPhg52Mo6/4zbAGZ0HeoroCFhlhmuFXLPHpmD+dp+GuXyfXA4ZFS04nAvNW6KkddmpWo/eYkFaf7rtxSNp4TRtQWi+E44Rr6IhdthcE/b/DuATBdtvCcsw6zqdTtvJPSPtc+D4w0IDWLWQHklAiGF8hHsmxW66i7CVb1JC6uxm99WTR0oKO3E9xzuOKt6R8Djf2Fbm4EiHe04uw/nbo5Bmhxy3WwtnfHI0C3rVAe3MIThYQ8EXyh5qNbp4znAjE3kdqdtxs4c/o27l2YWWWZBr2//yPy4mslScpCpbif6WsVrqqfziWEk2P5Zo5Vx0PxKFhlM3nY58kQWHMNyVO6OALFMzVgrtBZ80PJAq0H6B8/ZJN027nnKtyr9LQEY2sSC46jsE0w/P/YEH7qAmHATBKtSfWyKn0Ca+runJ4PhqPTmjyZ0aCEEA7uCzyqA8sFIDBbR+JXcI6Tu76oRrGaI7whRzoN/YxAS6GtoRvfU9Lmf30yKdqlqYTar8dICVOG7G7NgDHVoEK84C4Bv2sXkla4UJOy0Ck8BcMOWw+OOz+hLfgKsucv3MjOcU91wHcpKJ4OkHDtakwOn/BbmQb1fnSu2rrrZi4n24j/b4L57OG4i89I2HdQu0uO7p3h5pgZSequ4VXKrorPBu24V3rvvfAegcKEyBA1U/y3wQpX3qZu3bK41GZ6Qwu6PNjC7BNnu0r+uJeMlCsHgezbV3UQeGk9KlK6yWb2ktvJZTQGSFGw+/dAIYtkJz7imKkux8s3Fz2GKLLg2RQssPjnBYa67Rh6BnRiNMidwzAYhfhX9Cjk8EM8Fv6nLpeDmftlu6TGD30WMRnNrBXQfe+Ehvh6UhT7RHIBorz2fxle8YtWg+UCegnTfFWDQwigALbMsZ/1ZgUFBRLYgaRumifKj/9SqtutM+6tGVLH//mKJ7
 535vBQhm
 3XMTPV2VgzYKV9qAYU4ZYXRQWPGDvVD9PHsxBHuhMV+dJrhX0syWPHtFqaoN9yN9b4sbv67xazc+WlUCcJ01dyw/Fa9P8kT2EIzqRcw/pLeyeLLMpp153B2WwOScUudwdx9vNAnVszjxhF0Qh5tZvjmQ7UPsEWR2r5E3CmKdBZ8vJ4jbDwbwjG7g0R0Y2+7MZCg8iQoognGGkcYP7+rCwaCYcTrhhyTwMPybtVklk6ewOhF/+gmq8KErRYtxS8tps29CznSrsAlw73iOfm4h/gwGw5KDgcElKcBjh4E6GcS10JUo0KXb3F3L5aZLDioVvZx72OIzSgCBS9125jAxvgEVkSsKy4bqdmSkFcxCec+UT5GBT9RUNnjvYy8pUXVYX+oUVZ1iz6I0MrNObne5dX1m/c4Z5Nmu2Nz+OFjK9+dL8+WxVV/9wpZXCOdxgpfK9QVVxiMOyYgAPepqx3ngWRdmoUZ4XUMddt6m+IaoWqTAuK40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all READ_ONCE() based P4D accesses as p4dp_get() instead which will
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
 arch/arm64/mm/fault.c       |  2 +-
 arch/arm64/mm/fixmap.c      |  2 +-
 arch/arm64/mm/hugetlbpage.c |  2 +-
 arch/arm64/mm/kasan_init.c  |  4 ++--
 arch/arm64/mm/mmu.c         | 12 ++++++------
 arch/arm64/mm/pageattr.c    |  2 +-
 arch/arm64/mm/trans_pgd.c   |  4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index a8f07143512b..95d044cf04d4 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -174,7 +174,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		ptval_to_str(p4d_str, p4d_val(p4d));
 		pr_cont(", p4d=%s", p4d_str);
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
index 58a50809f91a..6f38e3618d26 100644
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


