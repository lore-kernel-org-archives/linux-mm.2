Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8974C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D046B0099; Fri, 31 Jul 2026 16:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345C16B009B; Fri, 31 Jul 2026 16:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234496B009D; Fri, 31 Jul 2026 16:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E79B16B0099
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 625684014D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:14 +0000 (UTC)
X-FDA: 85050158508.15.534FD46
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5161A000E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="gQzW/MN0";
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528492;
	b=PII5MBBtLt6ptqWFdf3sdWeiGMIwBUw29papTXAiz7kUlcbpBWRjbX8Z1/rWUs/yQAisuP
	ziJ9ntQSeSBeKCAxjQlXlTd0S2BPYuHnu6RcoBFkwhby6J4z04oT4b+TqQgglItGhqK/0/
	s9R6GTBAwMeTQEszlYviv8aIlzR8CBY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="gQzW/MN0";
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpbi7lKcbzTERg18/T6z9Nlhbo2QXLkGasNl6s9KsLg=;
	b=lZXycs61VNLBTgKdOSDN1yegyavw21JIC+eOrEEMyvPjFhDalDjfR2GFEwhyitS3UKCpUu
	91Ju86X8HTmI390tN4t+hFYe29BpcXNB/QycmsiZnvzH3csoB+n8YHIPuVSM6xqKkpYMYs
	FL4BDPdL58fvJe2wSW/q9Wk0tMNWheg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=tpbi7lKcbzTERg18/T6z9Nlhbo2QXLkGasNl6s9KsLg=; b=gQzW/MN0ar4blbV9S3CDmJvxz7
	GYOZxOHvNCS5IvcvaHBIl7XynkL3Qj5tuw8QwY1ggAUROMeJRJoStC2Xokn8bQ8VrwvCWtWwzJQ3p
	apB51GbndDPgHZJbl+n2xEm5I2mkb/x1EXn7ll1d0B2ZZau+DBCeGpOBQ0eLmVwYHGSOS0cR04hHR
	xf0LaRKD6Z+lHQmegLQnnit8uuI/ke3tzklOjiJX9lYP0VYyP0V3SaJk1pylJ0z5ALKpiks5TMS0X
	TZuB012ZUBYVIL3cnuhcvLtoj1RtqpwGM6MGTVcIwCRD+KrIJrwC9/4JwWfDunnigYrZQujURvqSm
	/eMiqXrQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002PnQ-1DWg;
	Fri, 31 Jul 2026 20:08:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v8 10/15] mm: Check individual hugetlb pages for poison
Date: Fri, 31 Jul 2026 21:07:55 +0100
Message-ID: <20260731200802.574821-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C5161A000E
X-Stat-Signature: b4i9dqip3dskmed48y8mcgxiozannqri
X-Rspam-User: 
X-HE-Tag: 1785528492-224349
X-HE-Meta: U2FsdGVkX19MX38uNe7Y7PRqQdQ5zD2qplmQw1G5OVzN45mQJpub+pxe1UhkpyJfB0i31Ex2KEAC4JiKavOv/Vdvkun9DhpD38U6eEfJbA248dmGO2A9ti3iUYP3mpnr6EEbZEhZ9WlNPaGiEkD+jqllceTiVQeEUvJ1R9Y2tMO8GgEwZnbga1cyoKC6IbPxGvNgqLvssqQHjpMjc0W+elZrzSZnff2rdkrjLUMcqLkkWlW3q8tzL2JtUgPP0RKSurQ2eNjDNdfNR+fV5nUurVmtLbmE2t/m1XESpWq0Y5SGqDKiFrHQvrtlizqKHp9tyrnTHGiD99N5Gtz8/eYrb1lYSTn2ri08cgY3QkFipids+pW//87yGKwjN+yRn5xRZ3ku9KXxtK/5XWFuoFb8REcenzUpCDC8F4ChYsNTrk/TtdK8HAOvkDmOu8MhpddN7t2cjOg1ANSBB6tqv0O//mOPD7Ki04ArEyeockooSsAxj8kyXdTI+76UvdAFIQiYsZHSjQ2F0a8wIISmJDv+WS+gDYuhahrEGXGlvlnT3dBSOLZU9ctUVuc4WWduBchAPvL0PCTBhB99X/2NKXyEo8BocYZ7G4nEfmVKhh9lLDkcmoO6pX+qazu6RZIJ+Vfg5DNpGnx/OygYOz2qqp8OYuduh6846HTNcuWwRidi0NpzA6FxeV3bcDy9/e+uIkg56gjNG7xRq2t/baYWMwh5iGBud8LO2aUIMYox34Z/hMB5ErfqPtV6qSGZRX6TkLAfaSLO141Yq42nWFl1P8YjKToIrtcN3VXvW5fWmCd3+DNdq9ys5/znLFpncjp+nIfn0x/8UeFCxPGyofrMnjRvIyTTtxCPwv8riHPWsqMK4p0y5L7dNlOjONatorqVyU9VXbbHZKA3UVmLRLficYzqCECAjjQAuOg6I0lGOK4pTDA4c+aRv5WEehYGvUJFWwATQdcDwain3zVxuCk/6bq
 21lKG1F3
 nHnyNSsd0uKlb+ISTeWX7vOZXWdimhtyN3VytQNl3KMwr2Efv6aZD/+R9tEkfMSm0+pCIdjY25tVSgOkAvmeP47rGCW35WVqIHlux1htUBZSWQt8uUmDjWFpqvWxEzfbmg8Nz5sp6BD9g0NS0Uc+I2XF6UVve5E1uJmgyoUVfMA1bYNHft+R2tlr6SD8GNWfvYSEyE5iTx5TI7kYeWuwRMIR0zSIyoXmVOV+OoQ9Bt9qPWJlk7whykNRw3636VIpYZWkChlNU4AF/LL+pEIVMSdedAsmSKvYRLCyYwmQJkWyv0fKDybdtVeweee5pxPAhTkTLjo5RrUAJn3ZOS2bqO2OvcNWjwmjtSqOj0MDc4Q+fy8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So far, is_page_hwpoison() has returned true for the entire poisoned
hugetlb folio, but we can usually allow access to the pages which
aren't poisoned.  It's slightly tricky due to not having a reference
to the folio, but the hugetlb lock can save us here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h |  4 +++-
 mm/memory-failure.c        | 43 +++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4fab3fbfd430..ee026ba9b0b5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1094,6 +1094,8 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_unref_page_hwpoison(const struct page *page);
+
 /*
  * Check if a page is currently marked HWPoisoned.  This check is best
  * effort only and inherently racy: there is no way to synchronize with
@@ -1108,7 +1110,7 @@ static inline bool is_page_hwpoison(const struct page *page)
 		return true;
 	folio = page_folio(page);
 	if (folio_test_huge_poison(folio))
-		return true;
+		return hugetlb_unref_page_hwpoison(page);
 	/* In case we raced with hugetlb transferring flags */
 	return PageHWPoison(page);
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 437a2be6c58c..c0a402522c21 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1820,17 +1820,12 @@ struct hwp_page {
 	struct page *page;
 };
 
-/*
- * Check if a given @page in a hugetlb folio is HWPOISON.
- */
-bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
+static bool precise_page_poisoned(const struct folio *folio,
+		const struct page *page)
 {
 	const struct hwp_page *p;
 	unsigned long flags;
 
-	if (!folio_test_has_hwpoisoned(folio))
-		return false;
-
 	spin_lock_irqsave(&hwp_page_lock, flags);
 
 	/*
@@ -1851,6 +1846,40 @@ bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 	return p != NULL;
 }
 
+/*
+ * Check if a given @page in a hugetlb folio is HWPOISON.
+ */
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
+{
+	if (!folio_test_has_hwpoisoned(folio))
+		return false;
+
+	return precise_page_poisoned(folio, page);
+}
+
+/*
+ * We have no reference on the folio containing this page.
+ * The hugetlb_lock keeps hugetlb folios from being freed.
+ */
+bool hugetlb_unref_page_hwpoison(const struct page *page)
+{
+	const struct folio *folio;
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&hugetlb_lock, flags);
+	folio = page_folio(page);
+	if (!folio_test_huge_poison(folio)) {
+		ret = PageHWPoison(page);
+		goto unlock;
+	}
+
+	ret = precise_page_poisoned(folio, page);
+unlock:
+	spin_unlock_irqrestore(&hugetlb_lock, flags);
+	return ret;
+}
+
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
 	struct hwp_page *p, *next;
-- 
2.47.3


