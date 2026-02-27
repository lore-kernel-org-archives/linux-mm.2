Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459B8FD9E3D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CCB6B0005; Fri, 27 Feb 2026 01:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228B56B0088; Fri, 27 Feb 2026 01:12:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127B06B0089; Fri, 27 Feb 2026 01:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE6716B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:12:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92FA41C559
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:12:21 +0000 (UTC)
X-FDA: 84489216882.07.146DEB9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE2791C0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:12:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772172740; a=rsa-sha256;
	cv=none;
	b=fzkicuHENAHocxlXYHwGRTjB1l+b9ZeNnf47BdBWGvNkf4W53qxFFS2hiSAxVDY5M12zeb
	73xvk4buPLM9Oaf1HQ9fHSptUpVDlUunD91cAXLt5b+0sU/q0B+lluDpeF+C8rBOK0aNcL
	X4VWD0NqJYQnqmb8gIaYXwbh/mci76c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772172740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3ArGwTIT7PspPu8UJJJftHjKNaGnGWQMuYtD44nBgoc=;
	b=huXyeJLrqNvhqoKfmF+ti/y5jJK+qpkPnZZyo+hbDR58nqRkwuLeLK9Jl4pVauhQCrP8Dq
	ftZDZROqm1Gun9aWAQBtJU+gN8SAqjsn75T2uQQQDYLHUHeyOmGbq+u7VQ0duhiieSUCiT
	ifl7dQF1f3erXVANjmctkkqrh2GM/eU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C2AD14BF;
	Thu, 26 Feb 2026 22:12:12 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6336F3F7BD;
	Thu, 26 Feb 2026 22:12:17 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH] mm/debug_vm_pgtable: Replace WRITE_ONCE() with pxd_clear()
Date: Fri, 27 Feb 2026 06:12:04 +0000
Message-Id: <20260227061204.2215395-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE2791C0005
X-Stat-Signature: yi31qhhrn4wsqued71aegmtfc1cw44c1
X-HE-Tag: 1772172739-169476
X-HE-Meta: U2FsdGVkX19amLFGud5FCB7kI7HH+7f/fcH2WmQJMZtkd+Ko7DdTK89/bocTtBw3f4Cgd5fhJbCHAfc2ZcyDiaNJaN4dl3dBrrAtItOLrPyHky4pSaC6oC34F6P75zPalStEzh/ayXILsGf1IyxUAOjp0AmPW8tvHYqulh2/RSSKOS40QxjAzmm/Eh9YV3rH9p00Yckg9EB+WmtmRoSegkd8x7evLCHoqY3lB8laRKLNyo6ARj55eZMTFhQTmSvHIY3vXKMPDZ4KUPrGFnOp4y/a9NA0iu9knFM0TwSyNqoRj+HvgMGAfNPaaw93Ogg8M/lp9pitEy7XE38quPD/Kx93qQ7+Au5sjRRxTnaiYPvrtpx+drHDwBfN8Ag3YjD6uvBVtRRo9JN9Ja46uKOk22eOjlVE7G5o4cu+zgSuCn77VLIeXgxYVCspuExjNpk3YjG+X2WkDKoWTWdpsah9t07Ps2SYA1yzcsg7pSuiRKAB9hPRRwPJ+Z2kaeZ23OXMA6A8cR/lijenegV2M6n9PaHtFLHxsKqVrpd92Hi8gm7aigjrQMSF0xXptmKPmPKOf4p6U+mixk4CF7BGoias4/4I7J+EHra4fA+xGGwK86DGRweXbjyEQ2kH9utLAmouAGjZ8+2pUMgdgpFfRTK99A0IgzeO36q2Guw2jI7fCMWM3WqcGPZ9Kciba18C6PyTejjKYyZFe//G0O+IulWIYqQN03i/jXOJIItc7QyKYy7by7B0G7ls9t34DTcORNpx2B0tZqrhb5scvR4uE+ALgo+70yX/8xFGWUMCZt+PKAXaR1x74UFTlmEbYmSEQXeuN3e/hKO4u9hZuTnp+/7/waXsnLQ8fAq/UDYedLiq7MXxFX8gGAmsrdGdosnwutxbMNtrZRPOrLbmdJ7jXqO/m2i40u+I9mA6htWoNHk7/V7KcJ/HXyoaPF2s0UGyimV2qZrB8TAU39xb5uPIk++
 5X0HRCGP
 rxmg3UDqv9yByZIc18jFjNO+rFdGN0ojEpSKmAxZkdc5H+4LAXUBSxmBvrHSW7bDyhfX2Ws1y1x/pj8d9yvXj7H7nlgRX0x9dfDI7ZCthZ+Wr8E4F6zySHNKZFq76AsYQnbiOt4vsES8drUZMHMUH8VOFiOBFTUuDBCvtsws2RfeG/euADeA0BjJ+zQo2HIJNPHnJnRGCXdIHk8MZD/KO/LZB4uyEU0KAtPfxRi+boDuZZRW/urqpU0McPaxK5UoHC9Hj8wiBBh7IyLdWBkr+KnIeFcC12aQf2pCrlZJUmIgkxw+sA2pE8SsjogGEE188tpM/28m0hKg+rzjLruRhK8FNYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace WRITE_ONCE() with generic pxd_clear() to clear out the page table
entries as required. Besides this does not cause any functional change as
well.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Applies on mm-unstable and tested only on arm64 platform.

 mm/debug_vm_pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 83cf07269f13..23dc3ee09561 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pmdp, __pmd(0));
+	pmd_clear(args->pmdp);
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
 	pmd = pmdp_get(args->pmdp);
@@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pudp, __pud(0));
+	pud_clear(args->pudp);
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
 	pud = pudp_get(args->pudp);
-- 
2.30.2


