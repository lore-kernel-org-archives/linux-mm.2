Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D4CC88E7D
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9366B0093; Wed, 16 Sep 2026 00:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A820B6B0095; Wed, 16 Sep 2026 00:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE046B0096; Wed, 16 Sep 2026 00:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71E606B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:49:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 937B21205FC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:49:48 +0000 (UTC)
X-FDA: 85218397656.11.B5AA37B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id C767E40004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:49:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QoW3Rxkp;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789534187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmQ9Fe7cHGrxcFUuHgzqonHChHO2g3YGuWgt9bNYRPI=;
	b=OZQLhRLzwXxECZ/RPLE2fKfL3IEP7Y9rUMp+zPaEP2gQfBYbqNm4ST3nJ3eXWXazP12BWx
	DBd+hxcBojGaFyV73348/o2xh6kt5ulISVsudLDkAeq/IJyFMhW9LPf9T72b/t/KV1SIlq
	ZQeMYGPX47soKu7pW6ZzcOgOZeXBpzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789534187;
	b=zNO1UlOl0jiMryRqazzkD3cOKELNqLWtmHaHldCwx9l2d/OlT3SMQER8vsJUlHyZdmd85b
	UOUFv857CjOP6CjfTUj/ygEkhwdVuXOa+1pMG8zOWakznezCbdgnR4gxNZQkOxqjsaLQVE
	UmrDLnJrnk0y5c7EVpA4vwdInBpYSrE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QoW3Rxkp;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A7581516;
	Tue, 15 Sep 2026 21:49:42 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 093853F86F;
	Tue, 15 Sep 2026 21:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789534185; bh=+FY3+CYyIjz1fY7lpWOX7WGahZAF+qIh85nM2GpHoxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoW3RxkpsQUhzNuWJpE9fHmFGXxXHcCADhZagjnTeUrAsuWjZu3BvE1b0VXkt6oCH
	 Z7DrtGW+rhDLXz8RvjAaM/XkeeUEdLNMATwZib3ZL2XmtP2f4+xtTo1nJ0MqnQpFsw
	 mGG/m2mfmR1Y4By6YKd0pxV+28ifmh6+dUbr4lio=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 2/2] arm64/mm: Standardize printing for pgtable entries
Date: Wed, 16 Sep 2026 10:19:33 +0530
Message-ID: <20260916044933.2689426-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916044933.2689426-1-anshuman.khandual@arm.com>
References: <20260916044933.2689426-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ynb4iuyxzam8auzpuk59rg7z71nscqe
X-Rspam-User: 
X-Rspamd-Queue-Id: C767E40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789534186-992477
X-HE-Meta: U2FsdGVkX18hYoCbTsSZejSZComN9WM5w8p72qtgAAFgWst/WYSHRCWmHDtpTTfjmSSzwyksBUMzAz2TNWwNlKMcud44NcOZpANGWBNlwnFFtMg/J4/v4Y8YWz6F2wMN6lgs6KuP/lAFnxczv7hixzJPYDnCe/DbGgXZk1k5EeHIlXMPe6Fqj22vBXvU5PZ3VBzMCM+Kr0jbaDBqUoIJAMqNZTtk2bNXkRh4BEO00XUIvMeXXEWbPryy6uO7HDZxoMWBkIB05C8JSDRmLnWu8Yt+HpmFZVkCMk768ivms8do20WuZCIIY6wtK5pyBWQ/LYdF9YplRKsSaFf19B9sGGWcWeIj6UINv/8+Eoa7qECN8AajLT0wd2NCvsd2d2xghsMMHvTYwWJkCI0KdVf2S7ZJKsTmUdEHuseFZHeQXtnFKGUQ6SFKHiG4OLLXLHcNtkLrdjPxamu4/IZOvtuARK30/uH8C250bQK+eN6FEhG/C8xRcTAEbj6hK8rUs8IE9YSTpssMu2AC380Yheterb7O7f+B5LZ8df8tnJ/kBs126ziq7tSfrDVZS+CDgEQMFWecwSmBbYRLWSoInyEDgFELaVGjzY/EglXPOCjq9bNqkAnlm30A4rac195EEUzwbrSB3t/pl0idzoGvfMqhOE+lCJkHt/0/UhmVc4qN/UqkaqAyvXfigTn2PsP/aWmoc4yMwc/IFeLV/zoh4i8tq7wDMadS7ug3IdZQwws1giNNvbx99h8yzs5nCVqscwfylpt7rTR47j5FoeYe3or4T/TAiYIQd+JTX7llhMC6ZgOTuMAEKzW+CzUt4mCmjvP60j+nuMiG5eyi3xJbpUOUEmXiV7ij05ZmfTZCfWPm8OKpEfheSa7iEA79lMj+PAslAHxvlIr+BVGbVv9IgheSy3AQXC7nisV6b2/hM/eksOnf9EpSdBuxlBvm9xFMwBiBecBnofzOA0kFlh02syr
 eMCZ1KMA
 qy5c32e9QjAwnWh4tJT1sV4rh5ep+OMIDcsQyQMmnF2OSn3iYxE5IutRV3LWetlSHQj2GQCtCp0e9vHvRpl8KSAHBz5sOqjzP6cw7xmZEuhG2QdS4pwg675+l82e4OwMsxXeSvN4feY9JmaGgWk9JVCsYHbxIytnPWKPLx2wGNKMDiBkxRABRQsCbken0ceOM04Hr3N2vJWfad3bdgFiX63Pdx/QLNAWLAJw/PgfACXidIasxTYVxyvEHKapSbDLRwkEr9Vw4jvId5+ALY9y/DwW8LDNttTWvKOO+0MlQtaA+oxbcpevP0ArVgbn8rOFXz+cVVn7rdUcOOPz5lO/hjwCBbasQlk1Ac9J5rpR5/DwsbqoYOiENNwLHFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/fault.c | 16 +++++++++++-----
 arch/arm64/mm/mmu.c   | 16 ++++++++++------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 75c3e463df2e..2cecf6ba6df7 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -131,6 +131,7 @@ static inline unsigned long mm_to_pgd_phys(struct mm_struct *mm)
  */
 static void show_pte(unsigned long addr)
 {
+	char pxd_str[PTVAL_STR_MAX];
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	pgd_t pgd;
@@ -160,7 +161,8 @@ static void show_pte(unsigned long addr)
 
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	ptval_to_str(pxd_str, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%s", addr, pxd_str);
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -173,19 +175,22 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 		p4d = READ_ONCE(*p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		ptval_to_str(pxd_str, p4d_val(p4d));
+		pr_cont(", p4d=%s", pxd_str);
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset_lockless(p4dp, p4d, addr);
 		pud = READ_ONCE(*pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		ptval_to_str(pxd_str, pud_val(pud));
+		pr_cont(", pud=%s", pxd_str);
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset_lockless(pudp, pud, addr);
 		pmd = READ_ONCE(*pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		ptval_to_str(pxd_str, pmd_val(pmd));
+		pr_cont(", pmd=%s", pxd_str);
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -194,7 +199,8 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		ptval_to_str(pxd_str, pte_val(pte));
+		pr_cont(", pte=%s", pxd_str);
 		pte_unmap(ptep);
 	} while(0);
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index cb49469707a8..e589fb00d1e3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2411,6 +2411,8 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 #ifdef CONFIG_DEBUG_VM
 void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
+	char pte_str_old[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	pte_t old_pte;
 
 	old_pte = __ptep_get(ptep);
@@ -2425,15 +2427,17 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 	 * (__ptep_set_access_flags safely changes valid ptes without going
 	 * through an invalid entry).
 	 */
+	ptval_to_str(pte_str, pte_val(pte));
+	ptval_to_str(pte_str_old, pte_val(old_pte));
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 }
 #endif /* CONFIG_DEBUG_VM */
 #endif
-- 
2.43.0


