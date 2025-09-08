Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE0DCAC585
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA2A8E0008; Mon,  8 Sep 2025 13:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A628E0001; Mon,  8 Sep 2025 13:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8705A8E0008; Mon,  8 Sep 2025 13:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 775A88E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF0931A01EB
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:12 +0000 (UTC)
X-FDA: 83866723584.10.AECF47E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5386520008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=krlmfCOt
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757351471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1A1SpJsgvlzRTLF2tzYzjTDHSoZiZjmEw7h5Uarz6NU=;
	b=YbVUAR8zCRUvn22H1U+48eUHojT/v5iTLWgkZioVC5ECFTjKnT+hUcjbZjOqKRdqCRBFD4
	XqDZmitPInHE0dwd5wTmBHyO54F5lQEloCy28MGeDHYmLijANP6yzvqrSBuw7CW/E/Eb7I
	g+pSIkJmWEg4OLZz5AZrDH+QUPR7pcc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=krlmfCOt;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757351471; a=rsa-sha256;
	cv=none;
	b=Xr8Gy/x9hr2/zJyRU/D8WI4QB96EbnHrEeZ21VXFMXBJ5To6KJZjzNvH7FZCtOykfIjC90
	hwwJE5e189eqUZUlxYfh2cG/KF6NQtPQ9cnDBbWl40k4iIwhhTpPWSOKVwXpbdtmHU8fUi
	dnzgYY7PkNpNStZb+oLAJyowmXXGcvg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=1A1SpJsgvlzRTLF2tzYzjTDHSoZiZjmEw7h5Uarz6NU=; b=krlmfCOt15H4gRohnVOcvgGQ3O
	6oXFmQjelo4ib442Fxp9I7IGDo7uyhaHoao9DN5WGdNK9qLguZYW8BR8MG1fnS1BkYZZaZuIm8mQa
	UU802u0YQvr5ktNg1M1NRtlldR+L6KaAZmyi6u0+u745TKB0iwBxKHyfFlWTGO6uCtyyttVjYJkox
	ZwJTGGhe7vStvorV6Eqqi6/Qd4qg/3XdruJh5w0GWjXIZHHA+XKnrDXDdEDmhPO+h2o9+shgqIxUH
	auxzUiLx/yZK1ivNReh/w7DzgLhp6HNPwS/t1lw0PzbI70xVmC+WcPXkTDcJ6dDnyrNH64O7ge4Aj
	0raZArWw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvfOU-0000000A6pa-3Uwf;
	Mon, 08 Sep 2025 17:11:06 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 3/3] ptdesc: Remove ptdesc_to_virt()
Date: Mon,  8 Sep 2025 18:11:02 +0100
Message-ID: <20250908171104.2409217-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250908171104.2409217-1-willy@infradead.org>
References: <20250908171104.2409217-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5386520008
X-Stat-Signature: r371kgz1gn7s1uifeea1b77zp61nf94f
X-HE-Tag: 1757351471-869425
X-HE-Meta: U2FsdGVkX1/IaECJ0z4QjjXJxgmNr6BlGyI4pA3L6wxMNTl6qhBgSAu2swaV2cbcjVMEutdwufTfM7ge5MCd7mnhSCykPZN6MfsBtsCRKChRQZeClr70C13MBZg95OXuHdDCJOuCsPyg/bgt7ys0yD4enKAfaQL/ljd2355wifsTXxOZXbjE+zRN2pvEJ+9xYVKKsA0F9JyEAoYwkYeYOtwprm4zKJvLi8Ah7cZY8/n/G7sZFClLhY+j0FXuhqLE/jWHqB5drhzxiSetL906njU0FnKn1m42kIL2TXlsT/RNh/IKXwoOV0hqGOlNVp1+U23ZB/gdVU6WXxREq1lc97ijMT+pIZXTHjqnq2pEazN98E1RN0niTF7nvlpo1dkAdB36odwQ53IK9aWrb2H9j5/V7lozyd+V4q3uF5M2OY+S6VaddeVhlPd6axMRFuNAwUs+aSmbKhoNFURsGH0U5E2K7I2lWr+TkcspZc3BiF9+WCnqXLwi8QwTqH3QTnbdblEI3oW4tAbnEaXFSHHj7hz0MuFqVi5YrCRGoW7fAGe7/tTmI66TWLbu92R4Wo0td9Nj/rMhGXo4kRGAZ6L/QbpunWzCf/ikQ38iw7WddUim8FSW/v4hgNpQIIxtfjHVHHoS3NDKuA+4et997h5jthlygziz35mhlONfknBL5SzqPAsjeuOMVbQFuCYvPVT9/THSE7AV5A/ogEzrPpQO555GgTW9k1b/QPZUwuobY23nBU28q5cbzOg1gtiH307ZyWvZyf54PFXj8n+nBN54eQLXWT/s0KdPJ/UK7JuceY+gIg/RZPMLrdrniiFZBXcLCAXFsKOgat3tjvy00mALrmKqXKPYdYeM76ImPX0OuX5kvIyk5gJ78mNGycqSRmUPTG1L9G1x7oBuFmqkP9ZuVG1R6S5L1HRKjihg3AaMjQTz1uY3BqEkCwPStRhXttkDttHiWRmR9L0dQnresnM
 EMFZX0ZJ
 0mKc+p0POWG7tfSHuPXNueoSGSuN8NWscLyGPxHz9GVmgYt3YPLCt20PO7VarMKQFk0jrvwvH+bzh/xiNZbyItnRFTWjm7psI5W9L/WssnTI4oTretEvvpZk02HFXNoEqdANynzVC1Jsj/e60jiJ72RrIr+2+3U/vZm2FsEHbiE8BaQZTS97YMhKZsdp5CFrBweW9UY1j+G5Af5S2Aa2EAcInuCM7CL4raTJ/Ju7BSjp1jvzgLTc4cS5cbA7V+pfw3cF+d60jaPD0mDlbgUkY9EsSQQ8dun9pUbLyGV6ul8EKblYCXbL6TMUBczb6qW2aW0hZvRNCCaMpdYyFf3XcHLm65Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has the same effect as ptdesc_address() so convert the callers to
use that and delete the function.  Add kernel-doc for ptdesc_address().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 arch/arm/mm/mmu.c      |  2 +-
 arch/s390/mm/pgalloc.c |  6 +++---
 include/linux/mm.h     | 11 ++++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index edb7f56b7c91..8bac96e205ac 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -737,7 +737,7 @@ static void *__init late_alloc(unsigned long sz)
 
 	if (!ptdesc || !pagetable_pte_ctor(NULL, ptdesc))
 		BUG();
-	return ptdesc_to_virt(ptdesc);
+	return ptdesc_address(ptdesc);
 }
 
 static pte_t * __init arm_pte_alloc(pmd_t *pmd, unsigned long addr,
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index d2f6f1f6d2fc..f56ee9aeac83 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -21,7 +21,7 @@ unsigned long *crst_table_alloc(struct mm_struct *mm)
 
 	if (!ptdesc)
 		return NULL;
-	table = ptdesc_to_virt(ptdesc);
+	table = ptdesc_address(ptdesc);
 	__arch_set_page_dat(table, 1UL << CRST_ALLOC_ORDER);
 	return table;
 }
@@ -119,7 +119,7 @@ struct ptdesc *page_table_alloc_pgste(struct mm_struct *mm)
 
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (ptdesc) {
-		table = (u64 *)ptdesc_to_virt(ptdesc);
+		table = (u64 *)ptdesc_address(ptdesc);
 		__arch_set_page_dat(table, 1);
 		memset64(table, _PAGE_INVALID, PTRS_PER_PTE);
 		memset64(table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
@@ -146,7 +146,7 @@ unsigned long *page_table_alloc(struct mm_struct *mm)
 		pagetable_free(ptdesc);
 		return NULL;
 	}
-	table = ptdesc_to_virt(ptdesc);
+	table = ptdesc_address(ptdesc);
 	__arch_set_page_dat(table, 1);
 	memset64((u64 *)table, _PAGE_INVALID, PTRS_PER_PTE);
 	memset64((u64 *)table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3a339bd7a2f9..2c3b99f60297 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2912,11 +2912,12 @@ static inline struct ptdesc *virt_to_ptdesc(const void *x)
 	return page_ptdesc(virt_to_page(x));
 }
 
-static inline void *ptdesc_to_virt(const struct ptdesc *pt)
-{
-	return page_to_virt(ptdesc_page(pt));
-}
-
+/**
+ * ptdesc_address - Virtual address of page table.
+ * @pt: Page table descriptor.
+ *
+ * Return: The first byte of the page table described by @pt.
+ */
 static inline void *ptdesc_address(const struct ptdesc *pt)
 {
 	return folio_address(ptdesc_folio(pt));
-- 
2.47.2


