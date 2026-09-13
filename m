Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F571C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 05:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046536B0088; Sun, 13 Sep 2026 01:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B276B008C; Sun, 13 Sep 2026 01:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27866B0092; Sun, 13 Sep 2026 01:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF63B6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:20:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F85D40259
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 05:20:16 +0000 (UTC)
X-FDA: 85207588032.01.E1FE852
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7B05F40002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 05:20:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yo+prUFH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yo+prUFH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789276814;
	b=V2Wri0jB3fkoljqgRigrYZRiRXd7B4BRz38x7WgaZSfS/Ooc+h+hSvhxLOWtYy7BfSYjTn
	sLxko4n+ABFMIzoqcUsa5k3mTSt12gUuN8NtJbIzmrRgFp1h7z8020flRHSS231g0Og8QF
	VFJJ5mI5k2pI2d6PPyQxJgVd5imBMjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789276814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=al6pO6MCASdQxVn4x9t1K82bQLC1cP8MXGPwZE1R87g=;
	b=qAOlcr9UVWoR1A1y5xEMaZynk/I7KowdFS2nYsRuM7UNSVepXhzF90xtVbKjtEtmlIJHCK
	619/vD4lGb1u+S0llqTfcjkRvV93ddMdi2W5ufjvM9sC1VKeT/E0rKA7Tn1vEPTq3kf4C/
	bI4yxZbg99DgyZjoYCPexTF5RGRQELQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NMYn3pbfZMJwwPcgVnZkDAC09qrdHDK3+hZHa3z6uk4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789276806; v=1; x=1789881606;
 b=Yo+prUFHLs/xWM/XhCDAN8KP6uq2i1UCGPQgoXKEvxYTlntSRFCGhqDu5XrUaCha/s4IEVzA
 4ko+nQkhugGu79Z0UVGNmNUxRgK5o/WNU6DYx3ggwwafBEky3UbU7cjaTO9Cv8/GHxi+gTQFWFz
 WOPFqBXhyyQ5WQ7PWpH9UPHk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8181c55abab0265d;
	Sun, 13 Sep 2026 05:19:56 +0000
X-Mizu-Trace-ID: 8181c55abab0265d
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero PMDs
Date: Sun, 13 Sep 2026 13:19:42 +0800
Message-ID: <20260913051942.40889-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B05F40002
X-Stat-Signature: 4aee1fwakwtfurdcj868i5mowdie4xqa
X-Rspamd-Server: rspam01
X-HE-Tag: 1789276814-401996
X-HE-Meta: U2FsdGVkX1/sayZJR//T6s5+Fz8+TI/f7n4gc0cvmo2c1saCKXGszQo177kQ9yBLzKcxiA4aTinbFF6ttZ4fSTL1DXrKxDbmpwxowYoKbNh0QiWhA195+5dX7X0UT9K4EbIda7aQ6AqJ32Ee20j0BH1EDsA/SykyODF94GLyKRltPjNhFhI1rU6UnM3hksam65p2m4IgbkANVKJnRArTKO+hH2hCIX8LyHooFN2kphqiDHTnKCnwBLGARhI1SCl0LD9+IyWJHu8UPCXiMk/5X60qXqx6bSxnjyOwQTXw4YkhcOqRmCaqtVo3oUgseYm9Pon2UmKDEeIDIGjf13enMtvrKeE4M6Zp58blRuRVV5QfX/fsejfZr7xC+8qYsqWmfj1BzzIkBePLZjchlLus1t8KkBEyXbmh9zWIWqBlCGTMHBrXTwOFh678513yOQH9PcmPShqPgUWHa4FJS5hnMjC6j88ie3zWRwZ5Ojd1pmZNLBo7jdmJIPfMge+pEf1d/06Z0FTv5gb+ZqkCYNt/jl+vvQl2wT42i4itvMCb6m3au45UF4cSOoRI5hMgvTq6Tf64YUX86cP4JmCGUAaXk9/CnmJ8InA8rJQxJWAjNBScW/W09/JjuGgcJ2AmBSonhIP9/gmXyAktdJI5TPAhYqscvExWJi6ndUMfoa6AnEv+0+4MuAr98Fyk/Ekk2Hq46LyHfnVLqexZHqApApGpNA0dDLXyYwAUkMGqJiayK+p3oFDEGi1C7c7cL2jhrOtf9ln+oyc6+uSsDbxddIJ5pt59MIXxaekVQZ6asSOwcdvBpjtwknv54jK2c+s+dQxBWYJZhRP7E1iz24jOtF3WWFz8VxdsAZ3couBN9IDy5CXso99pJ+enMRAyKDKih212xNpjstTwiyWPZxxOGdtjYwrKadF2poKE+JIsl5pf1+xHvlF9I5dRYFw75oRoGKVeMAZWz+WUoL5pKRK2rVx
 LJ+7rL/t
 /mDp/k0r/knbX2/7YY238yXmyGUZ2NxhlOtYbbGgOC0p/2+AFh6Icfj5Uik1iIP82wFJB9jHRE1s3Xe1coRAiG0iTo15eqYqRSXW3TbrBdVzIm+L/vL74ErGw5IS2pehHIXt3CglxryiMn/2lS5ptANWeIx4ni4AgMDwf8LNdG1DHo4tuFlhHstFslLH/NqlnFwMGkYPw8HdgS9RX3WGFTp0zgKH1jHfLrbTd47oQ7boWBKcp+sXkJwKdkQaSZTSEH7W7hjrk7nAdYmRQt2ZbJkEMl6baVEApf4KQdOyWmW+GPak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

has_deposited_pgtable() uses !vma_is_dax() to decide whether a huge zero
PMD has a deposited PTE page table. That also accepts raw PFN mappings
of huge_zero_pfn, although vmf_insert_pfn_pmd() does not deposit a page
table on x86.

Zapping such a mapping would call pgtable_trans_huge_withdraw() without
a corresponding deposit. With pmd_huge_pte(mm, pmd) == NULL, that causes
a NULL pointer dereference.

Use vma_is_anonymous() for the huge zero PMD check. This matches how PTE
page tables are allocated, deposited and moved.

- For anonymous page faults that install a huge zero PMD,
  do_huge_pmd_anonymous_page() allocates a PTE page table and
  set_huge_zero_folio() deposits it before installing the PMD.

- On fork, copy_huge_pmd() allocates and deposits a PTE page table when
  copying a huge zero PMD into an anonymous VMA.

- Raw PFN mappings use vmf_insert_pfn_pmd(), and DAX file holes use
  vmf_insert_folio_pmd() to map the huge zero folio. Both use insert_pmd(),
  which deposits a PTE page table only when arch_needs_pgtable_deposit()
  requires it.

- Moving an anonymous huge PMD preserves its deposited PTE page table.
  move_huge_pmd() transfers the deposit when necessary. For UFFD MOVE,
  both VMAs must be anonymous, and move_pages_huge_pmd() transfers the
  deposit as well.

Keep arch_needs_pgtable_deposit() first so architectures that require a
deposited PTE page table still return true regardless of the VMA type.

Commit d80a9cb1a64a ("mm/huge_memory: add and use
normal_or_softleaf_folio_pmd()") removed the vma_is_special_huge() check
in zap_huge_pmd(). That check skipped the huge zero PMD deposit test for
non-DAX VM_PFNMAP and VM_MIXEDMAP mappings. Removing it exposed these
mappings to the incorrect !vma_is_dax() test.

Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
Cc: stable@vger.kernel.org
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6895b38e4704..0ed997a97416 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2529,11 +2529,11 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
 		return true;
 
 	/*
-	 * Huge zero always deposited except for DAX which handles itself, see
-	 * set_huge_zero_folio().
+	 * Huge zero PMDs have a deposited page table only for anonymous VMAs,
+	 * see set_huge_zero_folio().
 	 */
 	if (is_huge_zero_pmd(pmdval))
-		return !vma_is_dax(vma);
+		return vma_is_anonymous(vma);
 
 	/*
 	 * Otherwise, only anonymous folios are deposited, see
-- 
2.39.3 (Apple Git-146)


