Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C390EC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C5C6B0147; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E6D6B014B; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C117E6B0147; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91F4A6B0149
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E027D8068A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:27 +0000 (UTC)
X-FDA: 85041734694.24.248B862
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B0B1100007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pNByJHjD;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiPqnGTlzZkqSP3ffPXBYZQSSxT+ortkyXzCH+6vsYE=;
	b=zaiJ/bFosJFItuTUUyEFq0ghDeIDjbVW/H9/wtiFvCAuYNvD7xcAwla+6xVhjW7ATFFQKN
	DwmtTEUws/9MpN9tP9/4aGuFpB24ifBERRuTyWGAaflCvJGySKF1i0l1Th7gCGEY6cWtov
	eQMYs0EStOJPHLpvd/iYX4D4LmBzDxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327926;
	b=G4JpsuLQ+yUaBIlDOq9qYNub2rKNLU8/yI/OB+LXaTdRkuXTtTMf1Mh0Mbx7uFxoYi7OGQ
	rGROg9G4km0pSoy2Q8amkGd92TisEexfsAYA32SJDhkNdBaf/v+bWb3vf1ET0+V1ZkQOiI
	5NRIGWH/m/XfYXhzsU4vVrQ4P0tjc4g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pNByJHjD;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EC141688;
	Wed, 29 Jul 2026 05:25:21 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE5E43F66F;
	Wed, 29 Jul 2026 05:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327925; bh=VT3ho3BDN6It7Wq4bu9hBUUHlhEfDekBy++RLrcgVt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNByJHjD7WlRk8SVhUnw1epzvnXa10fmiLbaom/7p8f1pbgbMj1dnpaEFsqfvDGiA
	 WbdXpDGjtW9+R5R7e5/a2HRt1Ae+tC52XEffIj7VeXqbSFCjgcjxv8MSec7pqGtj1B
	 LmqPZKMpzfEgtyU3NjsifaWOfQ47Q1WqpQx7WMCg=
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
Subject: [PATCH 04/17] arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
Date: Wed, 29 Jul 2026 17:54:39 +0530
Message-ID: <20260729122452.3797443-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: py8eit5cp8479d9kkfdj4jitpeqgoqkh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B0B1100007
X-HE-Tag: 1785327926-49166
X-HE-Meta: U2FsdGVkX195kI0g3ev+7ahS3agSVVblzSqvSbMfiqcgiaIvc0JLQZUYjC5+HaC1CXAmgUHkCi7Pw56YCWeVoqOVKHTxYRW5L4cD2nZQ9gBOSuRG6AZobxE4MQ1ouDyrDoVVV727N71BUTrSFr9m/aK7Yg4ePcChRWPyWpYnrgsGKTvszFA4ZpNxzUB9aBXNFy2D04bB4OD7wE7/z5p4b1oZcutpk0BF3WI9Y4fqwQ2KJk0v8F06f9lFOj2fhZnrZbCD3EHRpun96V6XAU6qOmlI5EgFyxmcy8WsQhyGKuo8hQQjRlvx8TvtA5hEBCB54huNmwfuZZAKZitcow8kBMhKnG1e5SGnwPrTazO446Ngvoo5bA+22qf5//Oh4+tAdfh8gz+axArlvb3IQ2d+5euQHXSsbGWF02UGIcSiaUaoRMKtVUPStZMjP8awSPvz/2UfI4P5HuVcVJV63YvN34dZRwA5IqRH1EMiWjDusOGqsa3/gCTuphIzqennfJM7Q7/y8TdhDwI4xcp6ZXk7ggbeooUuN3c4VFnjkx+5J2WcYuONM8Vd2x9QyJAM444OHyM+MVzen8tZhOp4skzqIQ6rLo8Og+NdFTjcnb5jCU5WxHwMW40fbBqMd0OgethLEKk8zydoRLT88WCkgA4BmwDKApzl+9SGSvYZ9hR48PjvVNItHVeB8eonqZoqc9UO/cJUegZjEGXyOdRYhTyrOjmWaEQoZDNngP5o6MMiZGgD516KvUrAWKlmUmOMbgIhF/r+sTSyNccqAYuXN+NU6iBqz7MmTq6Q4ycYY3p/EX7E0FqOm/iuuC6FrfnXTut5gtA6kD6yze0FA1S+zg3w/If8gT7QhT9vCQEmNQ+ik0q3tczFxHEgpLaD+Z8VDKwQbeB5gTlGoU9N4uxqO8iIv3vLozvDAFDX7pV/ZgePVJdlVgB4dZp+En3DcER4Fh7mN4MQ/uCKeSQyZkhmEip
 cBUUCO70
 5XWZavjGXlp6LdjviAlTf01f17wOrFNyjxjN4RYZZ+Az+GzwtYH+CTHseWdpkffendJF/BKoKVbNGREVsbAjbgwIpXKWWRqwX5GCgngb1hGbH8YL8D15Su2rRA0MJdRylQr7p2Fo8TyLhb47TiZ81Dhk9bFZmePE9adwL5LNbPVIr3zzmu04T8L0iV3bDbnDkuE2TpJtUQe6nSmnuYbw0OVDVl6/j8ZAyOq96T52Dpkdd+VSjQcWkFENBxUiFcWxyg5rFNgrvHlMi/2JyMWJbTiiVPpbP6ug3ZgO+/i+OPEgyDN5XQ/QeLrNRIzDx5mDqwewQykPG7aoMOZEYOE7e1HfMIZPmeIMfm5UNrmyUsOnYDNipVIdT7zsFDgrx5haFLLMrp6rKyP6V8muD6NdLxG71tTk6YnAFLJnXtT3VCsey+ryfs2dxzOHY9g==
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
index ccfd4ff76f88..6f3d30b689ff 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -168,7 +168,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		pr_cont(", p4d=%016llx", p4d_val(p4d));
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
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
index b1926b661efe..7e2bec43fd4a 100644
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
index fd1ce8649686..aceb20e48251 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -368,7 +368,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 {
 	int ret = 0;
 	unsigned long next;
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = p4dp_get(p4dp);
 	pud_t *pudp;
 
 	if (p4d_none(p4d)) {
@@ -458,7 +458,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	}
 
 	do {
-		p4d_t old_p4d = READ_ONCE(*p4dp);
+		p4d_t old_p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 
@@ -468,7 +468,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			goto out;
 
 		VM_WARN_ON_ONCE(p4d_val(old_p4d) != 0 &&
-				p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
+				p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));
 
 		phys += next - addr;
 	} while (p4dp++, addr = next, addr != end);
@@ -1574,7 +1574,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1740,7 +1740,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1761,7 +1761,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
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


