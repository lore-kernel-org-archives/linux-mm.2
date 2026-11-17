Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D79606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=efnLP78w
Received: by kanga.kvack.org (Postfix)
	id A85CC6B05B4; Mon, 16 Nov 2026 20:28:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35D36B05B5; Mon, 16 Nov 2026 20:28:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972E66B05B6; Mon, 16 Nov 2026 20:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 621896B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:28:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA212C02B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:19 +0000 (UTC)
X-FDA: 85442875518.29.8ED9B64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 129EA80007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efnLP78w;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794878898;
	b=xRQy9O+Yf61RDlZYN51E6D4zVY71JoXxACSdgLugkV30W4i6HEKtkPGUghwVbJVGxIl3T7
	Sm3vuKxlPHU8fLG6Loh2SDFf9Yt6dyA9CHYbOKaWYUEdjyYaabTRzxDBwxVRaWY07h8gEy
	Wmg3Murlff844ywd5z+gPWqCplglYAE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efnLP78w;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794878898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1mKjrngqddQVF90xUO8yZ+KVFOYiz3lNSzRTt6HsWU=;
	b=d9D3RV2dlCMDAJYBFmvjLEuP0ZTzTWVvUjB0eNYSAEiFiLN1sVP5FlR45iaGHYQXmYCzcQ
	AsPMpc6rGpSAlrT0sXCiLlsc2SecWtslYJIU/Ot5SY9QVh5dCQY+ZKK258dyFa5ZaDIPAD
	KWd9SRe7GJq2fqMqEfTzx4Nbrl5MVLk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1076E1713;
	Mon, 16 Nov 2026 17:28:14 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B3EF3F673;
	Mon, 16 Nov 2026 17:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794878897; bh=MNgJS3tmZr67R4aVtt20pj54AR+4mHx5Vy/nifYKBYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efnLP78wsMuLSRStRhVSKzUkA1FuVJGFYLX0P/v0RCycvbOEokAVXKm+T2AE1/q0N
	 m7ENDanLd7m8NimKVx9JTGVsjd9uLSFKDnCAOqUASCbUdnm3DUwbGepqbdmdWr/Job
	 4iWkDuj5K3hjKUMQOlkSlPEmXjqy/BAPjVvIyc98=
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
Subject: [PATCH V5 3/4] arm64/mm: Use p4dp_get() for P4D accesses
Date: Tue, 17 Nov 2026 06:57:57 +0530
Message-ID: <20261117012758.3814093-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117012758.3814093-1-anshuman.khandual@arm.com>
References: <20261117012758.3814093-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 129EA80007
X-Stat-Signature: e7dit1t5t7xm6famdps8bdtx1arhaq9t
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794878897-641471
X-HE-Meta: U2FsdGVkX1/WjTPvLu2eXwv/yn24yO+i7+LZ2W3qW3VbAKIKIehcNsige3UNFkC2Ljjg8E8mHGwULHiPstXOkj74HFQUAlyKXC/1qSyy5/oJyt0pH1X+EPiPcwzASKGTvXIdRtJ5V58feX+A43u1c6OagShv4ro40sPhkC7qvdtKWCYvjgA3gAyQEevZnX6ILnVNZIOqMds0BWZ/PSrljMa5II5Ix+jczwJ6G0Rs2C8UxhJQMNVXzut5DeL+J9CZ/KTAQBNOIbUhovz3XLEf3zQ2COKR3ioC59Q5wW5gAZSWEA5J83SBjZF8Z7Qv97STvo6vmwhr761ZUK4MP1ZZBgsxRExZ1RKgAQr5phWGB3tEKWsK6m80FUBYR5TjyRdSU2FNnGyR/ai09rpmaUKSK/rq+KloPyBJ18d46IPcP2jEc5sm/o6Se5sYrarbaOc/JEXN9Ur5NhzidfJimoFTKElNUOPmMOOSaoPvlzgVf+f1db3PL26UNlWln6JM54QLf2/HgxFfkpVu/g5DoNaIIkTABPIdn+kOlZxfeT1gCz0aukw8oKi5NJwTNmInA0qYlNcAz6v83PfXstSH/z8EoUuGzC7+GzphZnhRKpAWwyqW7EYpvHBONzz4+oO4UWy00uikpbb4jUiM8UfFlcrOB/om7N1S5AGaWHwfHH0jelEydtgN/AH2J4GlNwOkFPwQaOKr46I5MC/nk+B9RfLx3L6UdPRZ1riPEdtLwO9DEvWhH2arEHmJWbaulE/beDsib/9U+ltfBWJ8np4qXPLAUTQcX8Rwk0eLnzqSjL8+MWKyJ8obKlWO04oypTHYMx3aQQtMGRRazKGqzuj1onU1z22aR2jeYjzddPe3UP3GF/84/ggJ5oRPfEz0L+CE3DbL4dhQnG8w0Zu2BMzvOy5v9bAAG/cIBJukzEWkadsmLk0wwt13+tRqdNrGhe42Tv82t+d+JoKDW9GvBPg4GND
 itJApZgC
 YV0TviV/7Dntqx5QWxzi7nXjmYMfgo/F/Hr23e2U8JxVwYVOAnN1miSbzCIV0QKrlzBNws7DLA2wnMi2hEjW4Bz2yzv4DJC/eF/oA2ZN5x7IpncCSHEh9/vsjqp5D6x5BJv7FfEUeup3AkUDxeR6MUNzv7dEbUK6K0L5OAHQR/r4zSQ+vWiCrkwVuB/m9tUZe9+W6QZXOpqyRkEruhIbc80ylebj5hfRZKHpy13TWtLe/Zov2cpjzfu5lxYLmhWLVxHR3eW70jGHV1686kr+c7s5ivl/D4VCVCm9VCtCrtpZjam5ImCMig8kXSk64KoZLYWERwUy6lrdUStLscjuFpPsuhOUPSTzf2IITIvuy8sMm83iojOYADU/F6MAWVKIq1J6NkrPHn5atRDx53iYAmAsg2bhTfYfJy2X/ZsLCOX54dDYWnDJ51+PFG2Y5h9/J/33K2eb1XXlTKdjh6tcrneMJhS3KWmKx+hwQnOFvXmrL9sQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
atomicity when required.

Override p4dp_get() on arm64 platform. Although the same as the generic MM
default fallback for p4dp_get(), it does help avoid build problems while
converting READ_ONCE() in pud_offset_phys() and pud_offset() because of a
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
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 12 ++++++------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 8 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ad6cd5a71b71..7b3463ff2014 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -96,6 +96,12 @@ static inline pud_t pudp_get(const pud_t *pudp)
 	return READ_ONCE(*pudp);
 }
 
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(const p4d_t *p4dp)
+{
+	return READ_ONCE(*p4dp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -976,7 +982,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
 
-	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
+	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
 }
 
 static inline
@@ -990,7 +996,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
 
 static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 {
-	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
 }
 #define pud_offset	pud_offset
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index ea0cdc730768..934b534c5b89 100644
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
index ce8ecf5a308f..2620223d9218 100644
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
index c14e7404f971..a11c1949561f 100644
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
index c544a61a5afd..172bc516164c 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -351,7 +351,7 @@ bool kernel_page_present(struct page *page)
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


