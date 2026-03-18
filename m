Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858F21077617
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C536B0328; Wed, 18 Mar 2026 16:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44176B032A; Wed, 18 Mar 2026 16:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59F56B032B; Wed, 18 Mar 2026 16:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2D996B0328
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BA001A019D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:21 +0000 (UTC)
X-FDA: 84560351442.15.0D9D319
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A65AA1C0008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+fyh4Zy;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hV4S7S8nl3UYkyfiqXmZJLQy5NEF99d3mC5uLbqC9lU=;
	b=A32Bp0aQC+asVxNm5nAtlxLUeh4bC2KVCfs0L73mkcEOglWiK/BC8q/KV83lE8OcVEZe7s
	kU23+OnBE4usw+vP1PyMuVIPHcH/IjdRDK1SUJ7PPz7pbumOHEA8wlt8GkloYhtVgZbQwk
	Tcpc4Dj/nQ97dWEbl/oZgYqq37i8wDA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+fyh4Zy;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866419; a=rsa-sha256;
	cv=none;
	b=jHn2OHs94KDTV5krEipAY5nORBUdjoIoGREmZvQNl5ciJvy59Utwv5W+liNsZYTyBrvHJL
	/X2scD/ccIQ2PvY4R9Yy+eOKVOHuBPhUDei2XuI7VX/5aBmMJZSzmd9/kMixodJJQgSkij
	MC7T9lBcNgmumBKjeefoWSqtE+3vEfY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF26141642;
	Wed, 18 Mar 2026 20:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADB9C2BC9E;
	Wed, 18 Mar 2026 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866418;
	bh=E01AFawUgRlaY07x436+rCWEekEc+HPRai65dkjw64E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+fyh4ZydYkd4WFvJ9Xsbol19Tx+juyZovtGPhzUXgZNtJEdqz4+Fp13fEM+TrkZX
	 VZ7noDLS1+abHTKUs0XHYP8SRahlrrqTW5A2R/HBTZlt2xdzyZxCEcGxl51u/kZfIT
	 SH7rIPlU/CGxGsokn7r37FvNu8M+jOSm2CxuVoo2y3AnqXKXrT2J8O4iZKqccrGVhI
	 zHECftogKwOR60GR3J96WVFWxPjWucpOc9zqveiqMuOHKOAW345mkJODgvtvojmMx1
	 0a9WHW1xwqBq1cM1O7GBUYa3yQyrlCukYZaAXGfv/nqVfbmdan7GpQmJfE7El0O4yZ
	 /CW4HSV0JOa0A==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] mm/huge_memory: deduplicate zap deposited table call
Date: Wed, 18 Mar 2026 20:39:29 +0000
Message-ID: <3e6343f91f8811fd1cf66f03ddde493daf95c0e3.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A65AA1C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: doh8fa8tn9qqigj71hbpnnh18jjq1f5j
X-Rspam-User: 
X-HE-Tag: 1773866419-12366
X-HE-Meta: U2FsdGVkX18c/U3IbFbbSOQZd52IMUbhqy3/b+fJvCD7ybuF4dh1/34c+Ma4c6VwnhMLNjXNmbY1r5JHKoAy0mP6w159Gw1H6WtRsn8zMgBpcxH7qGNTLyIM+dp1P9+s2GuRSjhZ6PPudwx3Gr3BlGsFqxYbvry2NgYYwz5/BztHSZF9pHvU4uK1FR8vVNrnGvwz3PMVyd6hqwWuNDWCB2OX3FwyLVut7bWUJI0K9hxcbT6a/rZy0uygdc9FCpm8dQxk3xjDkZCi/LbvrVdbvqsgH5balGCNoggbnFtvYCXlrG8DYl0jYT9RIrukOPWoiW7V6putY93vjEbQKP4WO7JLJVDcSNcxCeYexzfu2GrvsqqH9N3KbBcIysLqp5u/FlcU/KZPBRVHNJ+3+NrOy6Ao04T1zskYLiGfSBS3sE2o9eAEgFRgqIBrvW1tkqDBcY4wWboXnjXaQEXuxGWGWuWkYBNBKf1maDMCLIuh0L4LlEwnKVVNkH/ENKK6eSMm7KasFerGynFxv0wNKm4z+GeaBpsmqIh88knjccDnTLvHlEZBzbNTFq7tM520DvV8l2TdpvZqM1IfawETwUWCl9rH1yjrCbVzDydY1NHU8vuklyZQ/VVV0RoRUSKexVhunTo6vagKGzPvuURln4kOXC1V86+g1ICzSmJ27ZSVk9gPHqXeQ1+/2xmYHlcVKFJmiTXweysBKlE0s883jbKPRQ6O8ojsv/1Hx3trpHvg9TmNtUCxTnZOWjkX0KjkYGoD7nmB440/aiwj7r1q11SypJ0r8sYaKY7joB1rEil+sZdtROLZ00cGeWwB9FJf4FD2H4DtrXhse99tkBAtiwsxctn5hL0+0rnD50zs3B6hbnYzMrcUXKAHALqxAfZSBLxLYgouJbvE/mc527v2thI8NTU61aINzuoyJpKxoH2xIwWfcCYgzu6Z2PCSxlR2cQ2co8kNVFKRADifhY/lTvD
 m0hlPTL7
 hBiM8Sa4FW+37u9hI8iJLmWymhO+7hAQUtvj7TBAhp6iAyy3HBm6GvgS3sSgOY0taxhxDNzsiCebG2KZZ4Dhln19cL2ovosEfU0kGFlBJoI1xzjXGvSAeDAMU7XWC/Tyfje440ytT7lMZNTwfyFg8a5HQywKRZpizhlk49+k0dZArjqTxO6q6j6GSR+X5sJ9Pcp2XYIaGxKovWd09NCYjkC7w3K5fpFKOODfwSeZxQkQq04ST3i8HOL7RkgPy1UrlHiWhwmo2hUSjvFm2mRUuFUsdXAvjtg7Ivl9Q04ntDatitwWjJA5wslrIYnh+pNWfWBLL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than having separate logic for each case determining whether to zap
the deposited table, simply track this via a boolean.

We check separately if the architecture requires it.

Also use pmd_folio() direct in the present case.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 015f6d679d26..bcc74b0172fa 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2432,6 +2432,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 {
 	struct folio *folio = NULL;
 	bool flush_needed = false;
+	bool needs_deposit = false;
 	bool ret = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2451,23 +2452,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (vma_is_special_huge(vma)) {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
+	if (vma_is_special_huge(vma))
 		goto out;
-	}
 	if (is_huge_zero_pmd(orig_pmd)) {
-		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
+		needs_deposit = !vma_is_dax(vma);
 		goto out;
 	}

 	if (pmd_present(orig_pmd)) {
-		struct page *page = pmd_page(orig_pmd);
+		folio = pmd_folio(orig_pmd);

 		flush_needed = true;
-		folio = page_folio(page);
-		folio_remove_rmap_pmd(folio, page, vma);
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
@@ -2483,11 +2479,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}

 	if (folio_test_anon(folio)) {
-		zap_deposited_table(tlb->mm, pmd);
+		needs_deposit = true;
 		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
 		add_mm_counter(tlb->mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);

@@ -2507,6 +2501,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}

 out:
+	if (arch_needs_pgtable_deposit() || needs_deposit)
+		zap_deposited_table(tlb->mm, pmd);
+
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
--
2.53.0

