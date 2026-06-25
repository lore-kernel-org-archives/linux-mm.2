Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38DFCDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50126B0102; Thu, 25 Jun 2026 07:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26D66B0104; Thu, 25 Jun 2026 07:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64D76B0105; Thu, 25 Jun 2026 07:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4E6A6B0102
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:30:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 146B2120668
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:23 +0000 (UTC)
X-FDA: 84918216726.10.0F7B1F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0AC8612000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VaLjxRt3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387021;
	b=OI7vefxrugUrtNUvr5Dz6kX3VLvLYjyfX9aKTqsdUa6iG1oksOL0p6e4QGnPaHVm6lMOnE
	f9eGxSseUShocZpsdOCcElmYFQp/wjxoChAnYB8a6KcYloBLH+L4Tr4cNdLizHNinSRhYs
	PuxP7TC/rAwyJQpLmRYQMDOurVJUurk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcE8kF6GkuARqeVJ1FJg4Qpv0enfw56e85+vK6XjtB8=;
	b=lRveXGT35uKiq8FdOqzXrF+eLbF1Cgb2eNJPRVmP+AB2LJcdHIetMhw8Sqo75/LqZLLTxk
	R4OaRs7aANh+ix1drgzVCA21g6Kfbri/2qEnxzsa2/vTJGOYWpTgm1H2nizbkNRqYm9cpB
	krwwusdixw6GDRfJa+TSU9gUWVRO0Tg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VaLjxRt3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5847D2C46;
	Thu, 25 Jun 2026 04:30:15 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 065623F62B;
	Thu, 25 Jun 2026 04:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782387019; bh=QtQ8GPWloMli0RbtDXW5k6ZOS1ivmXc5LVDMq/8ZE0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaLjxRt3/7/p0anZpXqR8+DAL6bdCNHL3CUiUSzwJtBPmWo0qYBn1WDY7pWuXqFjq
	 monTMitTvtDfW8B6chmLjY8d3MAnHyUbwQQ7tVbf2qGbaIDhJWU8jioydOr+eHztTW
	 X7Rif88PZSY7xHy3jhDuCDhfJBZtdzD21Ro+O/BM=
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
Subject: [PATCH 1/5] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Date: Thu, 25 Jun 2026 11:29:50 +0000
Message-ID: <20260625112955.3254283-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112955.3254283-1-dev.jain@arm.com>
References: <20260625112955.3254283-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0AC8612000F
X-Stat-Signature: 3mpp4cffhufoqpmg4887hx8aaboxek3o
X-HE-Tag: 1782387020-367158
X-HE-Meta: U2FsdGVkX18huBNBQNiYK2HkwI7bMxONQoFdGSJj5Zuw2ITHI1WKh2hTGRD2t5YlOk+IT1t4DR4iCaF650I3GZqh3093imu7vDRbEGg3S3CinfAJ7DcTkR4PF5ZCs0WhCyP7CV8umMFC045tO4jNfAFyTCYz9wSHvCsrMRBt1xYT2bJMPFioGwEY7AP5AfMsITA+8UgDMzLQmdE3r/4PHEB0hMbZpRqEDS684DUviUpUq/IBIWgPlDUQYC0mAuBBLW126C/O7u/BUa1OXTqqpCkwN2CKkDx13tC3nYO2CbgAuy3jaY3X5f0DMPecrP/xWC78Wu3lR4c+ofTCIxDXgjiX8eu3PB017EyJHZr3vZb3YM/hRqPBrmeFQx60ltXNnoNZLZlfH6BrcN0ctiuC9JWxnDtDSX3VkcDVeQUoX1tmnfPNwM+ugAxft2pBEKotFDsCt4jRJwTh2xw0zTbZC4uL7CMXVVUZMO3sQIMKtcyvU+e/eAzSkvv1+sh82KXHCcnqYonZwgMe4tH4yrDrtj8/XSjPR2Dz98AtrYgJAv7YfH/i7oEWZI8+6zUm7O8NnvciLMwjzcgaoWg6r/SqAhQ7LJUacKo2tfcmOT/eXfgMPVZ1w8aOfHA34VsUUFWOVbb/u5Kf84pEKN+oiKy42jmC4t1ZblkqGjbOEjDGI7V8IwYgBJVLhDWYPnSO6ezEr9zTjUkxE3WaqnU4hEcOTD6fGR7zUH13YdNLXRnb1ZRoJoncR9l5thQnxlxcd1XvvHBAYH73GvGB4G+7MLvCMHQekXSa6vMb7TyGzTIEn8JMpjLquVE/BmTzXrHRcdVrnd8CpTjXt5igUp3UOE08wmMduD9hr2Bbt4XWslOmyciZ3hRNNlAusVpHMOMEH6lE5LF+nfL1HaISL6O6Yo/k+Pbvh+fzNpl/nwVojXJcKJaEijAqZygoZjRYdS7nIleciMZ6kMQ2WKZ0i58Tqfx
 donft9xI
 1Va4qh3cY63wZ+kw7Y6FhK38vPTnfemguxy3JYfc8Usrmtr7T355vlJoRlZr6BQMhO8/v3TykIIgEGNLpXV+/aAkF4125eglR4g9W1uA58xd/pf40nZ+wO+UFX1iqYjydIUDPJvF+pzE13c6LUxBoFiq7qeS2/aHom9KO4DmTY4LFG/kAG+AY8IGav0vWsLCcwcbeQ4KAuBeyfoEtENLAmbuNWbbjImDJjCvXLkrL0eOtuaQRdX1XGFdgH2/RXJUrSK1biuf6pLEZtzspOHuBBNt9O23MvNq9L06k20nrgvxCzXj6VANDAVblqvPLm7VIIDv0KeX5OGb47GOKOAfJd+oy+5tSRy0YE2eHOYjHdAKFW9DnNlZD3z4hSIAlUYoAUqWxM2lII6TVto0=
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
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/hugetlb.h |  3 +++
 mm/rmap.c               | 16 ++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e90..fdb7bdf7645c5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1261,6 +1261,9 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
 
+pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
+		    pte_t *ptep);
+
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9f..aa8a254efaecc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-- 
2.43.0


