Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC30CD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F46F6B0095; Wed, 13 May 2026 00:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB216B0098; Wed, 13 May 2026 00:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E066B0095; Wed, 13 May 2026 00:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039F66B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1705140721
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:49 +0000 (UTC)
X-FDA: 84761161338.06.D42543A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id E431B1C000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lIW3FORP;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S+2+n0EeWlT9N233B3DCjrK281LY9WwvxBHqWwygqY=;
	b=R+0zK+TSv6MFbYf0riW6LL3Ibg+ar81wJTNPDcdrRd990vlO2B6aiUBBAcGTmZfK7/ahmD
	xKSqLH/7WdBHsEON7732yCo/6aRbq4UUl2uatBdU3kOaboDTpQ9s31S/FycKg7nMuhNbXe
	KVF4t69cL2PbGG4ojtqRwCdhPITP14Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647608; a=rsa-sha256;
	cv=none;
	b=1rlcEK3D8HZ+fFn4GwGMCkR1dHR9NaqvvOVEGN4PT50oeIhX1LZsxxqsJjMO0NGddRfiEr
	DMxNKgTMtNmxbo9zwzjvl/wiGVCoj6kQs0+hg6bRPxs5K0YCaiqtFYucQ7xjCjr3YZ7Xpi
	14O5bjkg6fIpKok92753jYi7+ZomM1E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lIW3FORP;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0F8D153B;
	Tue, 12 May 2026 21:46:41 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CF7FF3F7B4;
	Tue, 12 May 2026 21:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647607; bh=/VtGJUpqahylL9FXKyFDWvbcltW41sSjLkPiO3QjB70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIW3FORPZfchew2OOBv8QiV9uI3NUa3oPulIwDl9POM3RmBCcfaJ8h5uZXTg0/F1a
	 uA8ljxN11BJZ7aberPRpPN5IYcSheCGLt6+YEcH95VEvXcbKi9ZO80GnUYCm+pTeeE
	 3dTdUBoMWwpkDhyjDCYQGvI9C2ClgXfpSlZPw55k=
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
Subject: [RFC V2 05/14] arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
Date: Wed, 13 May 2026 10:15:38 +0530
Message-ID: <20260513044547.4128549-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E431B1C000A
X-Rspam-User: 
X-Stat-Signature: 8wyx7pmzdjgu1dtnz5n49aq7xwyphbhh
X-HE-Tag: 1778647607-531127
X-HE-Meta: U2FsdGVkX18jMSN9TKyGuypsnf9droTEu3rIO+Zl9NRNIBuuByjhDnkK+DljKOY7TO+FNItaxlGAP9edD5p+NH2b7kuAcTWxf5x4+LKxo3EpxJD99NYL7luOD8INqBYgBgtmzSdQ8fkab/5Hd/9h9PvHYXdQQ/KkZ2m5cfU3BFzJ8JUWZQ7zOppvOo0x3MVQ4EOEipkqNXFgvx/UyZtLdta9Jh28gOvtK8fRz9xKC/jW364zkemMxoszW1+OW3eTYoJ/nVZh0u9XDmdjDUwbazZ9qC22bX43ycxqzeoho5TmfXJ1L4CitB56k3A6ObsBaKtHuk1zNnKaHFv+hw33ZrL+ZAv25/UvsIDl4ltpApE8LL29Um1xQFUt35tzzY5gSdK1rJQaVEB84wlDIJEDE0EQi7S0KyBLG9tMXtt/LhNeFATMwz85HmlCCGULCIEGmGpNgR+9nTkEMPk668OaIa32cJBbTZnHO0C2LsGZ+7WvP7dPIA+84O2gPf6+R0QNzA+USGuCmZci8Eb9fDRqpjLLngIyzQplUMFHS2r3oGdK6Uj5aXQZWGImZflUSDd/KGz/8bBqnjMXnNfOLxZCaSjcAPdVfD/Z/ecD7MMb23V0HLoGrOLE5xr78NuWI6wey9XAZLOk0TKAdq0EEGcP2WNaf535cn/We/VKFFZWDq8m6cqc4m0WudUTBsa5drtjHqFJgohOhR5AX9paVZftNZyb8JtIon1SQTMtG4IF9aroBhUY6kAv/EOZGeWa5cT8/N8px3l/5h+F0xKVSYK6uGn2wKIj8a5nGVytQIV2K9iaLtVq4Q+inNa2y/CrR+TndqUBWEA7ZBDQMQedsIx4yrUx/wxDzho5rKZXRnCXsmlbeqqTHT5vSgYxFb8A2c29Jc9avit4XYbTgZ7sLQPCiC032RBCJv4tGJmrNEHkxUWvQ+4fdIwr2JOzVb1B7EuI0gIX7efpMkHijAYHTuc
 vpEsZQs8
 KFdttNuXjyQIEB+GMQETYZIWMF/GPEadG8XV23lq/7lwxVfHtGQQtltuHt+crsqzYk51JFxZyJvgIgnA1JpgxhjmH7etYWUlzm6tPqP1vihJm5nbAfWd01+sx2e+T3hGPlO6DfjsTRN139lQT1LjnGgGOUz95um+fsnge15k2WCLfPLCSqvY3h83navm9QZSVwzc03ioVqWQ07w4IM+9idCd46SDMmLDvrPm0YEDMIbDZcRW/0QslQQVIlcwBl9RmkruM2KjGtOmoV7+/hlAQYld+aEevEoSD/O7QYrTF+jNIZ7WMLohf5hHn62hC3qeSDwRigKZN0OYI9zFQDEAnvOSS/FeHjjnpu1ukTXJleTsVDSNh9zkVjXEwVG9zE0ixu8+ZW19gFWHLJkUD/lQoYpwmqnYTRXKHzDwYl5rA/CYTDKPl5eLefre7+A==
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
Changes in RFC V2

- Moved back helpers back from arch/arm64/mm/mmu.c into the header

 arch/arm64/mm/fault.c       |  2 +-
 arch/arm64/mm/fixmap.c      |  2 +-
 arch/arm64/mm/hugetlbpage.c |  2 +-
 arch/arm64/mm/kasan_init.c  |  4 ++--
 arch/arm64/mm/mmu.c         | 12 ++++++------
 arch/arm64/mm/pageattr.c    |  2 +-
 arch/arm64/mm/trans_pgd.c   |  4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 63979f05d52f..12131ece18af 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -166,7 +166,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		pr_cont(", p4d=%016llx", p4d_val(p4d));
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index dd58af6561e0..4c2f71929777 100644
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
index 012558a80002..8eb235db7581 100644
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
index 19492ef5940a..e50c40162bce 100644
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
index ff677505c4d4..34e2013c1b7e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -347,7 +347,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 {
 	int ret = 0;
 	unsigned long next;
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = p4dp_get(p4dp);
 	pud_t *pudp;
 
 	if (p4d_none(p4d)) {
@@ -436,7 +436,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	}
 
 	do {
-		p4d_t old_p4d = READ_ONCE(*p4dp);
+		p4d_t old_p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 
@@ -446,7 +446,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			goto out;
 
 		BUG_ON(p4d_val(old_p4d) != 0 &&
-		       p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
+		       p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));
 
 		phys += next - addr;
 	} while (p4dp++, addr = next, addr != end);
@@ -1560,7 +1560,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1726,7 +1726,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1747,7 +1747,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	 */
 	p4dp = p4d_offset(pgdp, 0UL);
 	for (i = 0; i < PTRS_PER_P4D; i++) {
-		if (!p4d_none(READ_ONCE(p4dp[i])))
+		if (!p4d_none(p4dp_get(p4dp + i)))
 			return;
 	}
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 1898e07595cf..2edfde177b6e 100644
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


