Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8F4FC5933
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94696B0088; Thu, 26 Feb 2026 06:34:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72DE6B00AA; Thu, 26 Feb 2026 06:34:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75B66B00AC; Thu, 26 Feb 2026 06:34:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2E7A6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24B4E1CE90
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:10 +0000 (UTC)
X-FDA: 84486399060.15.9B733FA
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 928D68000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IWSKImJr;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c14WgMu6/15qhuICdOLPBmddgsK8PG21SZ4l5q+gLlo=;
	b=Im7LuhD38arPpDuCIRv/uodZvAsA/6qRoZ7TChcoH3o3WEPokz+XF3aXzsNlUzVYcEEYHZ
	e8jfLF6oQvV7YS1hGNzZaL1sSjZm769gGPpSL78ktnbsw3uEh+8cNHwc9jCgB9wUorj5jf
	orh541A/0P6rJWLw1v34Q4VXpxcn0L4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IWSKImJr;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105648; a=rsa-sha256;
	cv=none;
	b=ByuqHg/ib4MrfopKqb6BDgfDrdsyMgwsaaDtxmFYZ6d4g3uHpksNZhFPm6hap2z74y1xuI
	fZFUrIzWkV2djz04Jeo/DvWbGlRlUv4wu04vX51CNBdzmf91nCuRZl2OZ2yDdaF3Fn0dEk
	pxmCp6AP/uWi5D+X2zqIiB3X5JGGgbQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c14WgMu6/15qhuICdOLPBmddgsK8PG21SZ4l5q+gLlo=;
	b=IWSKImJr/lhTtq+7dWWCDBff/3vlsDJfZ5E4/kWREeiGjoKal7G4aXUV6deMVpg27q/Yop
	OTsn9HimEI/nuXkSIAWQ1bqJnFpUQRDmLiv4z/EhIzmdzFMMJB1Z54wZ7psaJRXtZ10qtQ
	reVy6qgPIMnhvu7EHAlifyWC4llEGMo=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 12/21] mm: thp: handle split failure in device migration
Date: Thu, 26 Feb 2026 03:23:41 -0800
Message-ID: <20260226113233.3987674-13-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e918t7tnshwo7ekhuiqr6suwtk4h8ep6
X-Rspam-User: 
X-Rspamd-Queue-Id: 928D68000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1772105648-275807
X-HE-Meta: U2FsdGVkX1/b0OC1VZN7q8Q/oDcJACUodQQJ++XBOKFKsisXevgCSId4LKqM+9BwlRvKOadolMcdsry6So/gWdWd6/uO9RxyDA/UAWpo6qVnNTumqxbHp6VqeFby7MI0QdyaRqN0iaNga7CNyTQ925blwITURmFva75bybWBY/dm4HOakz/24lz9BAWWhk61jKac6Zh6oQFDZFlRrwP8U4e6VLRufv7seJ1VcDG1TPtELv3pXIlLgjox2tErbWpkOwlLXKQto0Y4R2QXkDuzbMvH9utBuqRwqjswJ7yJYfwofDBS7dwsSSUPchEBHy1y0SfiN3rEgSqnQmblxHYAIE0JHjH9LOMMkIQ3LuW0gldGKxFGJ6LcBh1XyNmDgaVixfJBJZksPVT0bA2suobwY4QU9W39xsfa9VCsECaKBt32P1W9AgMH9FIogJc7YLO+S5Q1P9t6hJhdvFmgkKAxjxKKShko936j8tY9FMjgV54Q+AoHwvyKBGBjRSqUqu0UkZt5om1Lmhjl1g94iHondoCxnOTLiMTk4756Qi+Z74w41aB8kGtkN6SgkpNIDSMIVRDH2B06dReSaJhmdFqAV8dGeHEm8vWm5Z72v1x6H6K5bhygKdbUmWlx3ar2sQvwKfyJ1fhCggTZw9Mz0KMHm+Oqtfw39oPHfgy4yKHynSX4XUZWj0mZDEDJKOXZkG75TeuPhkgsGb+tuiTbMxQRcAqyxMHGCOAegWG3bt2iPnrNnwwzjzO/LfvNGyozMj+h65UUzybeWl5kbdJepEC7ybPYJdq49dzIEd9Zidwfq6/5I0wARkqQBhLtWDDldDDDDe/llLyv2W/9nKGVXEGV1OT/msicgaGSCnNyn7GrEABKfipg8hvFUuWwuOh5TkJyrxYxARvYwE9anEvnt6mR1tWucTZg5vF6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device memory migration has two call sites that split huge PMDs:

migrate_vma_split_unmapped_folio():
  Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
  destination that doesn't support compound pages.  It splits the PMD
  then splits the folio via folio_split_unmapped().

  If the PMD split fails, folio_split_unmapped() would operate on an
  unsplit folio with inconsistent page table state.  Propagate -ENOMEM
  to skip this page's migration. This is safe as folio_split_unmapped
  failure would be propagated in a similar way.

migrate_vma_insert_page():
  Called from migrate_vma_pages() when inserting a page into a VMA
  during migration back from device memory.  If a huge zero PMD exists
  at the target address, it must be split before PTE insertion.

  If the split fails, the subsequent pte_alloc() and set_pte_at() would
  operate on a PMD slot still occupied by the huge zero entry.  Use
  goto abort, consistent with other allocation failures in this function.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 78c7acf024615..bc53e06fd9735 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -909,7 +909,13 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	int ret = 0;
 
 	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	/*
+	 * If PMD split fails, folio_split_unmapped would operate on an
+	 * unsplit folio with inconsistent page table state.
+	 */
+	ret = split_huge_pmd_address(migrate->vma, addr, true);
+	if (ret)
+		return ret;
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
@@ -1005,7 +1011,13 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		if (pmd_trans_huge(*pmdp)) {
 			if (!is_huge_zero_pmd(*pmdp))
 				goto abort;
-			split_huge_pmd(vma, pmdp, addr);
+			/*
+			 * If split fails, the huge zero PMD remains and
+			 * pte_alloc/PTE insertion that follows would be
+			 * incorrect.
+			 */
+			if (split_huge_pmd(vma, pmdp, addr))
+				goto abort;
 		} else if (pmd_leaf(*pmdp))
 			goto abort;
 	}
-- 
2.47.3


