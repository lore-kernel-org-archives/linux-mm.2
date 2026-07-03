Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84695C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA646B00B7; Fri,  3 Jul 2026 07:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581516B00B8; Fri,  3 Jul 2026 07:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CC46B00B9; Fri,  3 Jul 2026 07:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1963E6B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:42:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 849AB168464
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:48 +0000 (UTC)
X-FDA: 84947278416.15.EB4CF81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7659C80008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bZE5qae5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783078967;
	b=upFSgTNOrKs7i3oy2cK7DJTz7MBX0x7Xu6Y/rWMzGIeZQC6NtDJ1+oDAl5XatMJuSUO25c
	ITpOy9cCqlOY+GPCS5uqR2kzixeTOxgaJBpoCkzHL+qVbwJIc3EiCQ2qAWJgr7ntwfIrmI
	H7uXL8Eg3iMF8wo7XkvbB1nUMRQrXbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783078967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yg0lz8Jg9E5VcjlhmOCHXO4YaykLXADpl2rfVwfd4X0=;
	b=bKbDyrcxz9K5UGvfyrHqbWT7tnCNWpZ1PRoUPpUW8r/8eynh+lKk474QarbelHYSeoM/CG
	3gPEz253H6HDiaqIwQxH42Fbsgtj1kQoAc32/JyV9tqJ2PqQOlkmBSA5auRtzAheFvXEye
	S3bpEWn3L08ptnjTEdIF+lrJWJoJeEY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bZE5qae5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61F7D3587;
	Fri,  3 Jul 2026 04:42:40 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 85C5A3F673;
	Fri,  3 Jul 2026 04:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783078964; bh=BRu+bhG7aKPiwT5vuH3zvlt7PlvdsDOhL/vNEPHmmuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZE5qae5+56oO0S3uNA4ZnaxllNJL7xt1NU0E09fQ779TxsZvP3TNcLz3cnjE+9yK
	 aPal0ieAg0R7/f/NZT22vH0T1f8E7ieCwBTMhNTpGz/7JKySJSfrYj3blLLbOsbd5J
	 JP0rBHMBYdhLeAFN9ToEtIptslmqlwFr3u/d4WVI=
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
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v3 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Date: Fri,  3 Jul 2026 11:41:55 +0000
Message-ID: <20260703114202.365553-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7659C80008
X-Stat-Signature: g15t6aye1sp9ngocequ5ykrh4h4qk1sq
X-Rspam-User: 
X-HE-Tag: 1783078966-943376
X-HE-Meta: U2FsdGVkX1+DdvLldT3mzYeoiElf4Nqie7OclmIPDLmU0rQvV63N6GhUkdKmr07qhbMPrNLu2LwGz/YrOTtc6AZlnH+2v4OZv8uiFEP+X1rEdCLzxBAVQO7IzdStvmk+4ntiq3cZGdVAcQquPJIGHsimH5Dw5h/k7zmO9qKWkVcxNm/jP3HizEh6pxZ6LjOdGS3UsBv9oj5mSS9mhdh0EX9VexrLNb2ai4VIZ7S7CI/y/6xXiKNkB2iWLfc+uS6d1FA9uK2XgAmsgCQkN8hpcu7hpsfRWiNtdTW++ItW8fP8fOshqghdSdwlCGoykZU1kCGOxdK9q/antp19KFDp3vEKuJLzT9oeHn49Wtv/CwBPAVr5PB1YhLqeW3bxjqwlwrpW0qJ8tsARAMw6tEwYTBJIAXlDG7Dp0L+EptYWz7XhL05EmxwDq51CaQVcoXEfYQWI0CQAZdOePLTIEnLRKnK77JOh96p17qt+xJ07cj+cxK3eNhZ1u0i2pfexXfpvYtlpJwfqqk3sIWHL29jbN2zcvRoADbErfIaGSd8hvcxiLxgI1icTCa5illWhQDF/z3/yf5LtnLULw1XPrea4Z9mVOd6paGwCWJ4rP5+n/Kf3RCpH9t8jahG7JxBNpSA2cbd7R/6rbBS6dYvnVg0PE6a0oQyv6t3vK/109BiHferDfKKJYCPR9OyBVJ3n8sdSxRbSuZAKDNDtKozwYK6W/4bZHw+F/dkCupZ6DUZU3aFNXb4bFD3vxuXAZYhsGuYy35IisGAAcx5elUk7Q8DR9U5OHwLlBO7D9DJz921YOJ8XWKykyOoycyo2fsxMICYE+WQ6LVbMnmis51hDS6wDuQMxKF9taS6ZuNDoOHJBB7BfWjXvJB1Q5UMFrqHbwzsAj3sXiKmId/H5OrkX0gWvlj5rLTvAg3lJSUXyG+sZcULVrnoezSRb01oBAPO+1qFbTqVUqiWtpXzV/2mae/O
 BDZvGksE
 VdMFOjJDDvHdX+CnZsQXbk1spALPN5wvQabpBB7U/htUA1N6UbF4m/hm017hcIqvJQ+uT+RhCuLpntUnC4Bxo0jKgFAOzcJrZydfcK/p6rp7notuHVf4ll6eZfH9HsGEl4+cCrkWJWJPgRKXewnAl1jFZjSS8JQB99ooF2LJ4n4xnbKZizB5jQHfD1t8cdlWdmv8ItgcRJxQsw3CQ4u3FnUX1f7Q8lzO4QbzetYHfkZUAQtjXSZno9k8kleGEZU43jAEsy3IP3lkOV+JGZzrHcc4Tdf1gOS60XB7Ma+I19QuwXvDWgFAvJAgy7OPSMhzkI4Nch2cids6PS3EPc/TOU/a5+sRBXKNLseaN6EwkzYHHA3v97MubZBIxW3qVQsbqxGyWlQ0TGYPE+Z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_unmap_one() handles hugetlb folios when memory failure needs
to replace a poisoned hugetlb mapping with a hwpoison entry. In that
case page_vma_mapped_walk() returns the pte pointer to the hugetlb folio
in pvmw.pte, but the code reads it with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Just use huge_ptep_get() for dereferencing a huge pte pointer.

Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/hugetlb.h |  2 ++
 mm/rmap.c               | 16 ++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e90..6996d02acf171 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1261,6 +1261,8 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
 
+pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9f..03737daa348c0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2095,14 +2095,19 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
+			pteval = ptep_get(pvmw.pte);
+		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
+			/*
+			 * Handle PFN swap PTEs, such as device-exclusive ones,
+			 * that actually map pages.
+			 */
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
@@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-- 
2.43.0


