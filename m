Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65E8C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E563A6B00AC; Tue, 28 Jul 2026 16:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07446B00AD; Tue, 28 Jul 2026 16:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0886B00AE; Tue, 28 Jul 2026 16:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A92AD6B00AC
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42E4D80518
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:37 +0000 (UTC)
X-FDA: 85039363794.24.940C414
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id C268E8000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XOxc46qt;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zP24ps2bTVnLAZw5T1TmZXb1LiR7BO49jFSQ5R+E6ys=;
	b=ERbjd1dtUJOb9GuU0rdGY/B2qqDYnqUn6hIIo1XLVlEF1Y9TwRvO114bFQXX+1gUMRBUPH
	M6qeGKQklvJamE6Jbsa3B5sFa0lJIoHuAHzeWR883lqjDu0/1ZxQibdNRDZ2KT2QZkn8Yn
	FB5+M7S373GSF21mQesiOusys9PUBDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271475;
	b=KoorgyGUbBJpfyiS3HM+9AO73L5wTu+aTxrt55diDxJ7Hx0u2UpL4Z/yG3PzA1YJxfnoZw
	qWnZMgMZWiYTRvVYCmOR4NrITx/JRXYrram/Md30vvSdCSOpDByXPmU6Mb0S0OlP6gbQwl
	G/ELImN8J7/98ZmvMDo61D02R9PTasU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XOxc46qt;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=zP24ps2bTVnLAZw5T1TmZXb1LiR7BO49jFSQ5R+E6ys=; b=XOxc46qtUtrCw5i5oR1fq43c00
	VPkXGFfqz5qe+zuk6Lebg3r8cXFBj6jtgBMSrHwPEhpCPe/PkB+5vebU6Em5lBGzVroNRKeaF7GEU
	ZdD6XSRr9czuE/mT7uxiAY0smI+EWEsKHcY9QM4scJYzVVlsIZFTRsmcXvpNfprJN6YkBoU6Comtr
	tNpLf32aixUuk5ZFeY9Gfx5VH3439TZ8vOSJcKj/IKQf15VjEJ0R65M0TT5qZzt0bwAq7E3c38sZ8
	NxMrH1pRvMm5YUMm8G4l2sHhAY0PfIYPzu2Vbe7kVYjY3fdruGRTby6jeDu0GIzshb3VNcRoVvR6I
	yi1ZRNSw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooep-0000000EFWp-3uHh;
	Tue, 28 Jul 2026 20:44:11 +0000
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
Subject: [PATCH v7 08/13] mm: Check individual hugetlb pages for poison
Date: Tue, 28 Jul 2026 21:44:00 +0100
Message-ID: <20260728204409.3396238-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C268E8000B
X-Stat-Signature: w548537akog8ftucbh7njrejat8p1m84
X-HE-Tag: 1785271475-602545
X-HE-Meta: U2FsdGVkX18Pd5mTTG87esppshXdPjPHMNXFjGGZCT32ijOTNTRcAPkybSuxvu+BrN1jW3rOdr3gCvbTOhjeaFUHkbAwy0ZoIKM7tm4Dm5fZIezUQhW7nZhcj104CS6lGsACOPuMHE/eEYrfXw6uMLptlVQluxV8U7BQOuZ6ZrvlS0iGi8zxwyHRQE7efUOP1RWwbFXvr2Nt2au3TvM6xn3hjusbOZ8dLnzUsdkA5rCY+eYr2NN8NveRxBT8egwtR/8HZV3MtxvkAKHfBJdNgJhMR60rtjqaCEKfdObfOA0+k1JXr8+9biENWBnA8cuwwauOGZBY3AOUdQ12NcnwiJLxNSXuX5Q1viunr4YJvp/vVybRPu4H5dycIss5nKTnFmYwYFO2XZGpxHGZSpP7f0yMFUmBYvuz4kj+bKv5dHrJrrt31vZ9GWCa1wZkbt4CdDIarHeHPI0h1XhshinytQ2nshfW6MnCjxmezXFPxWV3CMyrwkqKx3MBboUVpT1P3vwrh6x8/MTZ5FpaPgs4R5PKARl3dG9CmiD5ehyb5JizXRs71IiTm+0wXzJA/x4YIx4yEa2dRVmwgL/qkoN+JlpVqWVoq/FcEdpLm7mH38ASuepYYoRmOdNnjcv00lM8KM25yLuHrDUQTt/CW4wT9QCcFmLkn5HxzdLo2PTan6Kqcg0iPkWlkJYJgWtln+lkT1B99vtyNolk54w3VnChNUwMe6CPDULGX+Tb8oPcIORtjk6MxXzjMWdd/rNIoIDs0douwx2UXxqbBD7IV0XaOeH8fPzriIBC0u5hCwyYXP7zHtnBjqWlmeIqfRc+k9qN47D31EXep+z7j4pbkvBW9S2yVbKbCz6udB7/Ct6UgFmmBjhgVGstObVx+1yZ0ZSYs0NNiO/Xkcu73Ta5JMBXoDmJd4ZkHX0VvS47Ce+36rZFQuNH9SrKbMf/yoyJTgzaYSOMwZOojLusObJApKq
 zzKmv+O4
 f9FwWEEd6Bl9o8St4iguykx1aM5FX1Jc117iQdW+nG/shjb3Wcs+BICabJg9t03yxPQkS9PVzHE83qQgrjVbY7gRhSvKNJnkUYgUODmxuyqoSC7yE+9Y56z6YMHBtEirpTXLXdg5uVqYkdnu1nLYAQOtfva1q+I62KTltB15uQDkggQkky/67Nuzi64rqt1boRy30jg/+706Ywsu5B8gL+N/NL8+31j+kPbFSOujD8wFzDJRcFqXTRg7RiIXMdGRyP3cQzk+B4f7G/ny4PQRgh2XDl9Y7nlh2Y4OKRvd8wZdrqNsJsNtghgiJojtP0himJC/Y75oV2m/FjSU=
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
index 30470f8ea590..ab2094ed320c 100644
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


