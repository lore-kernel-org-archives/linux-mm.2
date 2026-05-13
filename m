Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207AACD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799366B0098; Wed, 13 May 2026 00:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770396B0099; Wed, 13 May 2026 00:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD3C6B009B; Wed, 13 May 2026 00:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAAF6B0098
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A86E440710
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:56 +0000 (UTC)
X-FDA: 84761161632.16.8BCAA87
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0112E80008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JO7yhyBb;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEX+2Ym7JpcP0+RHWoBaPddkhJXYY6DHiRaLx9DP154=;
	b=nQmt++VU+Z8xkSMdLLdwR5xFS6dwaFn5nH8TXsDTtThRClI2IZOgiE67CzidXFPdhumxu7
	58mZLIIaL7NcY+TYJCb4ZpXTc/dvoRbtH9SbokAOUPZ+iNy04p28yLgnw9VqCEisQu0gCg
	km9V9C9ae6VZIXlvwD2eFtWDXSt+Rw0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JO7yhyBb;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647615; a=rsa-sha256;
	cv=none;
	b=PyNgDutPqo+JRtLH1C6I/kU6/Nhh5Z4tVYiBGXiw6Qxs/b7eXpAvcZWJxTm/8AQ7HLzJQr
	tj4/7fXpOrtqDg5icJZhyw78xJD3T/0oZrYlLGlvXRczjeB9c/+4NeLIo40eLapVUo30VI
	1Gi6XK05jFnW2QTQH7xBOmcUsCVwQ1c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7168153B;
	Tue, 12 May 2026 21:46:48 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB7783F7B4;
	Tue, 12 May 2026 21:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647614; bh=aNGNLik2cFTbHuQIkoEf2Aq2TD9aOisnliZZERSED6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JO7yhyBbSg/dVCmvGD666/97SNj4HdCyfiYpLjZRubsf1LWuBmv3nSxg9HWlmFiy+
	 y7lBC6JgqOXedNvCmjVMb7XtobyLF3IAUGu6YwRddVHK/Mk65K0muOZ2IudRBZoPO5
	 AZ00SMw43vBMZCkUVsVM8zwOfOg/Ab/1FaFGaIII=
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
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [RFC V2 06/14] arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
Date: Wed, 13 May 2026 10:15:39 +0530
Message-ID: <20260513044547.4128549-7-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0112E80008
X-Rspamd-Server: rspam06
X-Stat-Signature: jx65rtsqocttyx4dese7s7iseuw4k4up
X-HE-Tag: 1778647614-760896
X-HE-Meta: U2FsdGVkX1+fwijm+ZQQpMOcgvHhnP1JnEsmW5pLN+3+95sWpHWC76vYHM8UAa5vLL9n6WPJWuE/n5QohXilbkrYQjHdB1ZQR5no1BFxc8NWGlZpvdVVhg9DwLwm6fnrszKuwWL9T1xkG61MJ6YPLq1e96lXz24slYyZhnJcVcEGyzv8dRH65nIVCIs7T++Bef4ItYMZGQD/kcR39MMfxjTo2PL72Pi4niKPENSmlyKnJd1MJ1yv6RUQN+hTOdD7f9uTIyVPaI180Xb/hePOmv8ip12xWd/Rhp3n02+mGktjtvi4OFCgq4HtHoVj79ScNMsp0VcSGLjh07Jz1OWhiRotRcR76Gts/rcr2nXiHrpyZGdAXny0cjQyfLCKe8hUrTjZOOA4hdzaU1BLAdxnO6ncFF397256moxFJkXHZwUAjmV/b5kTmmUWJXNndaiGJJTI48oYEwwMs4+44MNJdGObKFVIwY5oZUzcO6K/CbMnfh8055wBfzuyQht4s1UpaQLHk9zUHHP2BmItnrh8HxC0bQpUhfmTfJzH+6WqkPELjLfnFAs1zgk9tUp/loVVoJW/dt0u9h64+WQEraqcLzZ8dMOoZ220eHeWZtJZPGXkRgLIEYtu1+dAWfDDwR/iBfzp/w8RrGeXMDkGTQR3JdyyjBel1UEZfHSmQPayeMVeCzk+tGOrtYBZuAVzi7jHX5HifpDO6yHdldSVHrhDZZ6ae+uFg39hLmQzPfjaeMjXcP2plp6DgIGu4xARpwzXJe3+brCGNc8FHPToawURHdOTfwY5HbOz9WP8slyJl+TCRJt3LwHDzZGEUaLLd46nw5N+y8/RUBLMU801wsfAWn76YLNXK+YQP0ZFyWQ4G3wrfwfqUzLBzpF8eW11ZeaT96U1XKK5Czve9fODjn0LiBH9vGAu32hEmAn/7CNoFM2IwrPir2hYYF94xRPmxLY4kUjdvbVo4MFXq5Q06Mr
 qEQIKYjI
 Wr5GoZa5Z1LJeAdLzSWGyWw6BZo9DhEA8l0sKerr4m3mYszARArOWpxYzYxQiyw/+mIEVpFwzUcvPVLsqUL8E2JDlagCirF1PC41m2s7zX/CTA+iIGP/chg2IxUf+bmTiq3R0GRgn5VD9PVbJkigCeoeZDC8ifxfQss7IHUL7ROUqFpzDRkTN1JFuZgDKCHmvmoTqdJjL/AIhVFFDUVs9hLY3MVAcLsiuBcMgH9BSSX209cdIfURL/uAsd6e0movqWDB65o8bhN2pdIxpHwRlrauk17c0qDj9t9TaP5IYAsU3S+JDwzNpgU8J8rwzeHxABtL+u70d+/uqZajPK8GdUPEsvxZaLnivcGhd9ee2RRtbCPhXkscsZPPmEwjXYs5sV0UWoKybNEoIstWBgV7XHxVN0G/PWPQhwtn7xzdBDzbp1so/emmPKdtx6Q==
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
Changes in RFC V2

- Moved back helpers back from arch/arm64/mm/mmu.c into the header

 arch/arm64/mm/fault.c       | 2 +-
 arch/arm64/mm/hugetlbpage.c | 2 +-
 arch/arm64/mm/kasan_init.c  | 2 +-
 arch/arm64/mm/mmu.c         | 6 +++---
 arch/arm64/mm/pageattr.c    | 2 +-
 arch/arm64/mm/trans_pgd.c   | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 12131ece18af..5c61f39f7f29 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -153,7 +153,7 @@ static void show_pte(unsigned long addr)
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
 
 	do {
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8eb235db7581..d4c976128bbd 100644
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
index 34e2013c1b7e..7fbb2ef86cfa 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -413,7 +413,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 {
 	int ret;
 	unsigned long next;
-	pgd_t pgd = READ_ONCE(*pgdp);
+	pgd_t pgd = pgdp_get(pgdp);
 	p4d_t *p4dp;
 
 	if (pgd_none(pgd)) {
@@ -1587,7 +1587,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
@@ -1765,7 +1765,7 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
-		pgd = READ_ONCE(*pgdp);
+		pgd = pgdp_get(pgdp);
 		if (pgd_none(pgd))
 			continue;
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 2edfde177b6e..9d70f7c0bbae 100644
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


