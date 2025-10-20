Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CA5CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623EB8E0007; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC5D8E0005; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284A18E0007; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDE18E0006
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5DE8567BA
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:02 +0000 (UTC)
X-FDA: 84016577484.03.B418BF8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E490A0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o3L4Jf4A
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760919421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5iA0dZyesWILhXrmeeTGKLZlpaO/LU1Sr5uzrLx3M8=;
	b=mmA5+vk5rLIgDTfKLMwddxzddIBXs1ttKiTERYjZH3jgVuahQDEslQdSj4bKx+/nEfHk7F
	gi0dZP9mDXVoyTQUGPS0OE4mbAF7hfiE8AiVLvLV1zJV1kNxb2fdRF1RFZE8/hLS99vH2L
	bCPPZQHJg9PsMS9PEPW4ekaVpRscyaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760919421; a=rsa-sha256;
	cv=none;
	b=ZvFiYRcKkl19bzqZig6GLjTaGWPS36dG7+EVcIGlGXxwnPo+6tvd1lNNFhgx5yw3CtOJmT
	HpVhvS8FYfmTjXwl6TeJz0p/RapVbkVemCTYsAPFMadtGKNzBImICbqF4+dtyEcY79fm3J
	wqXPDUD4bEeY60aR4oNUJzxGFZD2n3A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o3L4Jf4A;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=x5iA0dZyesWILhXrmeeTGKLZlpaO/LU1Sr5uzrLx3M8=; b=o3L4Jf4AeAtrJuYT/Xd/HR2Bds
	dwkzdRB7X9UlbxJWl/ijSVGkK15VxkOCibe4RzN5yBlSYtXfpVsOXBUrQhW2MX5H/GPwdEdGMGoI3
	hYXo7IaiW4IL97p+RY41v6LSzqq1s3HeiQ40UuE0JGx/Hv6Av4n2bb53736PYgI5X8GYyE2h3sWPS
	xMYB/tfHPPYD45CJ6QNzmiJdSUiuQQJOCMvh04gXkxElz1yWhIiGZ/JVYEHmdOwshJHODGeazajj7
	6i+pOvfnsoUkRtVbxdh2eva+eNdivZbokFKoOGie5WiOrIGhV1hZBVPFai0wUuKjcdnpU697FeTWs
	SvSyqI6A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda6-00000008t9Q-2Avk;
	Mon, 20 Oct 2025 00:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 4/7] pgtable: Remove uses of page->lru
Date: Mon, 20 Oct 2025 01:16:39 +0100
Message-ID: <20251020001652.2116669-5-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 7xwe57jbcpm6g6cf3aa6qcykq7xn6fdc
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E490A0003
X-HE-Tag: 1760919420-913858
X-HE-Meta: U2FsdGVkX19HqQu32MMptswu/WcxFludNNdZDFHtDJZYn1JV0HRGMCUPhQ1R1cX7R80+53wMPV4et3V75FOWoLp/rNE1oUK1k/dJDOfNyYP7Qo26mdkPfPOyXZ80pCEQcHONdyj7H6luZIg+RfUkp0vvOXt8469ywZIz7wlt4+C9UfW4aXTP7H4kMFNUB9Jt0KEurA6V94b3AuuzLNnUB/vQGTqd0chozqM4p2qlivbNHZ8v4O+PiXXnA9YvDvJkJXEIJUWl1ro88oETHYamn39N+4REMAX6LFg5Ww3kxt68brX4Iorm0u5i2Md35hdXNkHeuF19ccAy0i4PRDkv7g9BMe7LrnXj4FvAWqMNIMfslDsgxkM5YvOfZ+uM90fxa8C4Ic36qZr0ul4bwmKpZxqqprw8sbl8iEu7/OohYJln4V2nlI5XSK4Tm+mRX94XxZqDVf24g7TG3vFvGha2MIGDCeiMiRXuAyrVwvPVxgXBQIwb3wtm/BBwliPCnD4QvQXuhn/aTHvlUd1mUtQPZuTW0WcjQrFDSSYWyelWJ5h6Ct26ob0tkOWJdv7T56TZLTs8BMkiKbunuKfncHX2ZaxBoESOMvuEBHwhs2hOJga8dGeHdtk+ryCohM0HBI63vyRFGhkqdq5IQ2tZcLJXoVo03+ZYS+JNM04xp1nhGe7Q+Vp115Qe//heJ1kn3UJ3m2IUdHygyWLjIbRitCspMZ59WSzkOthG5H12gheoDsuXzeWBba63b0TX+kr1eDmKcbxFlD5CEseJMO8ysgUV+wubAb6HbXAbdpq9gpLP6a7byWrWXuY0pXAfTFz3Txt+XRLKFUC46O4s5ylQYTqUb5wcSgtRt/wMujdyxRHsCD82ACSnR0X8IRXDb3OgzB3mmHZnkXUlEk5DBGVpqV5VFy+Dk53zE8iM/GEnU6lDByhcuAFfN0Z57lWdH42hRl7zWunlXIwcmhLcune+FoV
 YoFF1LXg
 fOS5DyZOS5RwBRE/DqGVVCplJ43++EwbogHLJOYSDJjypiBpAYNASOxN3cAm9JFCtpv86Yt35z2fpL3sk4tz2O0pxiYs76tSj/xRVGnMw/RNAHhkdf94p/m7fSGeeQM+m6Vako7TA/D68kTm6vKSZP/u2A0yneRrByz8zFT8A3GbvXiKUNNLp6390YAillKyvrwuxBXRzDf0MPrybUs641s8f0TOYBYpnEN2m4o1m8DJQ2iPBIXLYukXydOl87LMbSBLFRjDC6KUu8QnFETFsaEqTjAesWrMLrfoH3WJTgVqvFas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use ptdesc->pt_list instead of page->lru.  These are the same bits for
now, but will be different when ptdesc is allocated separately.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/pgtable-generic.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071..f40bab9e6c46 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -164,13 +164,14 @@ pud_t pudp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				pgtable_t pgtable)
 {
+	struct ptdesc *ptdesc = page_ptdesc(pgtable);
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
 	if (!pmd_huge_pte(mm, pmdp))
-		INIT_LIST_HEAD(&pgtable->lru);
+		INIT_LIST_HEAD(&ptdesc->pt_list);
 	else
-		list_add(&pgtable->lru, &pmd_huge_pte(mm, pmdp)->lru);
+		list_add(&ptdesc->pt_list, &page_ptdesc(pmd_huge_pte(mm, pmdp))->pt_list);
 	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 #endif
@@ -179,17 +180,22 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 /* no "address" argument so destroys page coloring of some arch */
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
-	pgtable_t pgtable;
+	struct ptdesc *ptdesc, *next;
+	struct page *page;
 
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
-	pgtable = pmd_huge_pte(mm, pmdp);
-	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->lru,
-							  struct page, lru);
-	if (pmd_huge_pte(mm, pmdp))
-		list_del(&pgtable->lru);
-	return pgtable;
+	page = pmd_huge_pte(mm, pmdp);
+	ptdesc = page_ptdesc(page);
+	next = list_first_entry_or_null(&ptdesc->pt_list, struct ptdesc, pt_list);
+	if (next) {
+		pmd_huge_pte(mm, pmdp) = ptdesc_page(next);
+		list_del(&ptdesc->pt_list);
+	} else {
+		pmd_huge_pte(mm, pmdp) = NULL;
+	}
+	return page;
 }
 #endif
 
-- 
2.47.2


