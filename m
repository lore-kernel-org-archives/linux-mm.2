Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14089CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61996B0104; Thu, 25 Jun 2026 07:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E395C6B0106; Thu, 25 Jun 2026 07:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EB56B0107; Thu, 25 Jun 2026 07:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADAC26B0104
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:30:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D23140687
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:32 +0000 (UTC)
X-FDA: 84918217104.12.96FA947
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D4DB180002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D00yAIF3;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387030;
	b=BEq3A8LgQ8kInQfqEVV9K/j2HZlnyFgbY/0c9gVXLH0c7ePOhTNBNylJOD4cz9jLQfBdHX
	A7kuzOCe3fiA23hqYAH82nX3pRUqMqc09LVW6dAm8+SbUz19arX1nXs8DEoKpSxxnuASfb
	VD+YnDefMe7v3/k+qP/u9iZCaBlJSqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n/XdUgT+cr8KuU5m/M3XusJFn1OtXKKq4gYIp2UKNU=;
	b=5SbNoIeIHFkspbRkMe7y6f+/CBzA6TXOwMt6f6ifmH2NNlU6/iXXfpKuNc2QxRJ6fPhmk1
	1vScqfwl26iN+gY2N2/xPQDqZ0pG57WjJwHSV7Gzgj3VTRFIZWqv4GCDb9U3cAPweHtt/l
	h4NVYlqDdMmle62DoPMv5chJZjetjJw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D00yAIF3;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3321328E;
	Thu, 25 Jun 2026 04:30:24 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 72CE23F62B;
	Thu, 25 Jun 2026 04:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782387029; bh=Ib8HLtVOx0bEstNiQgQ183JVLf7OFocK8ZFR9pqwh+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D00yAIF3PxWlFQ7TUPdyDv/Bkj2YGFHDJzLdp6WtkJ3941gqW0Tlc5PQ77i3EdsD0
	 wW2iicZugLsxvqgCZ0MbrOxkaRuVF7sbD2nf3gU665s+IsSrXI2sKFC4bK0LQgm5rT
	 TAdYoJBI2FPE0WKowUceZqoHbAKlu0CKJgr37Kho=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 2/5] mm/rmap: use huge_ptep_get() in try_to_migrate_one()
Date: Thu, 25 Jun 2026 11:29:51 +0000
Message-ID: <20260625112955.3254283-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112955.3254283-1-dev.jain@arm.com>
References: <20260625112955.3254283-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: riboq3aiuc7yzn8kdrtg1xotqq64p5yx
X-Rspamd-Queue-Id: 3D4DB180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782387030-221256
X-HE-Meta: U2FsdGVkX19hRWfjG5X5MXDlKFFhRIdK2XPA/ZbSNN6aK7uPC0g0Ma/x279ycj9eLk1cAApRHPkGlH4MXpkR1ONQIOcFzC+aP3akWjtB3fOw5HL15O+OWh4FoMdhe0UWlDPlNL/4V4YJBAbg9RVNLCjVAyARqiRYMMzUHHObq5GcjBVV5skKq88f8aeR9dsDlXBDXr07mxFurUVcbwyLfOk7ykNtnvNs78eYhua+dxrCQabvmHSUuEUdCyDhUKge8FBjSYhVYZ15bNMnsY5crHDMI8STlbqYY1pD16P/e8LJmKVnXR+hivxhPWsqUMbXTQFJI6Tq706lqcSe8Sdb4KaMidGH5OG/RQSLbLP2E9kWF/9NeMTcFjAtEultzwM3wNqbBGWgZCuM/ONSs6LPoptVESC9XsEuO+3XZQsLTfc8CzMUPiPaZLHx7Wgj2mWUF78kZmAPt6cX2G7BPsaweLVLSv/R//3vv3Z83cXgRDChS+yYzpSBMzGYyvPg4fmCRwXMhI6AgzJ9tCk+nwldJcLPcrrQZJHHNY00SrU3mr/qoA2tnHCPPTrfQLj6hBM7+AScP4EGv2QlVezVNM95Zd702fdKlhuPaZRtWX+04l5yYyXQ2XZ2APU8AZSTyHX1nTKkPs1MH7YoAAkyrYh1iUODU5wBnpgYGWNuuOxFgqANnMg37/pol1mEGtTQh0yPSZDuuTTQPsIy2NIghBQCdO60AObFyX3E/MPpdIOwkOVVlaxxTMNxUDiOkpye1mHp96jazPwn7fn6BHWfU/hD75l5dATH+TOyJ0kTpYTdRXR2gDqHW/xI8AkqefKvJN21s+nfe4WsnYi5IR29btIQ2XL89xui3eewNJiTcC/MCMTTfIY0BBQOvnLPqOna/HElbG3HCAb1c3MxPtB74s8HWapZOCj7qmbR+KuP7IynTE+9hmSGoWzo14H+dxpm2llBUrwTV9VeNbalIcpmvV7
 7YFyCD5M
 c2+OyHwoArm24+Jk/rX58rV/GTnxuQEwaSjICHjpDEeUdBkp2gq9UCw42aCSiRCX5HOpa8k6GxEY/5xA9WyabmmcKPmm1UcWxwkgwPpMvWYpB1ClPxl4bCK2FOkkx5DS+ZT9dcO3ua4kOkp8F+h5qZR0snx6ewcPfPd1whQmZNANirq9jy3tygXSJMTEKNnSwvcXhqYjB1FyOixJFFqy0dYsLM8NO++JMgd+TdAFzkMOJ8OZggV1OtlPvuZArxoHGBoFFqirCU4ft8lXfgG+NEOTF5WpuMdGkc92FTLMY4h9L1aXursaRUl2836M8eVyqQgw64bKeOD6ydf8l7gv+o/w1XHAPVXe3vpJ42dTZS5I8Cm4N1KZTKSUdw8Of2vG6vk41/+SFeWSNg8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_migrate_one() is used by folio migration to replace a present
mapping with a migration entry. For hugetlb folios, page_vma_mapped_walk()
returns the pte pointer to the hugetlb folio in pvmw.pte, but the code
reads the huge pte entry with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into
try_to_migrate_one.

Fixes: a98a2f0c8ce1 ("mm/rmap: split migration into its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index aa8a254efaecc..abc3a44baaa3d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2505,11 +2505,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		/*
-		 * Handle PFN swap PTEs, such as device-exclusive ones, that
-		 * actually map pages.
-		 */
-		pteval = ptep_get(pvmw.pte);
+		address = pvmw.address;
+		if (folio_test_hugetlb(folio)) {
+			pteval = huge_ptep_get(mm, address, pvmw.pte);
+		} else {
+			/*
+			 * Handle PFN swap PTEs, such as device-exclusive ones,
+			 * that actually map pages.
+			 */
+			pteval = ptep_get(pvmw.pte);
+		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
@@ -2520,7 +2525,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-- 
2.43.0


