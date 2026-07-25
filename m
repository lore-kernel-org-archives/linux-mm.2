Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E9DC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E33E6B00A5; Sat, 25 Jul 2026 12:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CF76B00A6; Sat, 25 Jul 2026 12:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4834A6B00A7; Sat, 25 Jul 2026 12:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19D9F6B00A5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D6C9C0274
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:05 +0000 (UTC)
X-FDA: 85027762890.13.B3BBF4D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id E37A3180006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="BZeo0oA/";
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w135vdZkdaB/jReXI2LYBKmUn2lW/7fw2pzK/ZW/NKc=;
	b=mqr8roLpFYwH9L3GGQTQ0CGGcDb33iH6Km3br7wDTLFLWzV323d9dXLXwfCL1xSeajM5CG
	hShQrmaRKsth3hYLb5Rq+swMXJrBYMCpohomNg7u6DPyyMtYDDwWwZ604zR8Oq1BCBpu5C
	xHT9HVA0VzMUnobA3fnCVlUsv3T3fYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995263;
	b=cyNi9ThLBmoLZ9h36M4drkNNBmzTPsY7ueyl5U4iYJ9nQY4PtSWbqD4V2MvDpIXkzAW9mX
	hNorG0AcFNJyD9+lQ8VXnWCsECpDf8DkQ5fnbfOGDq9ZCALne/ysKrM0x2kfKScIjVsSkG
	v1U9EvJ9X/YYP6DeqpoWmscwXk1XDkM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="BZeo0oA/";
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=w135vdZkdaB/jReXI2LYBKmUn2lW/7fw2pzK/ZW/NKc=; b=BZeo0oA/sHAwlpi6isjGgkZmCw
	HVAoAzoF2ZpocFJHYeg9W2cc+k39U8LHU9A21qkbSmtF5vgirOYpWROXGD3rje+H3Jot52gJyGXpO
	MmKVxzOwqqO+WiUJF/V/UGbrebS/RkuMK1mPEdKX9hpfb5X6VWYdLsUnNB/uh29iN/naOTbUGr1rK
	yoa0qjxmAy3EgdlillSyQPcN09bRWRHsrqezgj6kv5x8LvO3PWqXXGzx8xWvo+WlzJP9R+gSrMhzl
	xxDqSXsYKJ/9pkuNhtilTlUgwTk4scYBeY9Z9+sytuy/Q+AnUcGr3TVGvKuFDWC4+lncYAL+NQ1Ia
	bfORI9cg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7c-0anP;
	Sat, 25 Jul 2026 16:00:44 +0000
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
Subject: [PATCH v5 07/12] mm: Check individual hugetlb pages for poison
Date: Sat, 25 Jul 2026 17:00:35 +0100
Message-ID: <20260725160042.1557264-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E37A3180006
X-Stat-Signature: estzukfmpa8r76sx7une7pf76wbzqttt
X-HE-Tag: 1784995263-733657
X-HE-Meta: U2FsdGVkX184T64wDkuhikNBK0gx7n/aXsK6+14gm+xag8pD19JoNw8sZUAKNfCTC5oU7yCbT95R1LimANw1hZomOQ1ovplMx4nZZdR7oEDdyCZWTDMJgqCs2ifwcpnfoALbxC7XQYht//T+iC7R4cNl9Q+yNaempa20dcD/deQVH9ED+IshLuN5RzIo2pj+w2ZGRbEwrnZ6FZv0vMTCASQUd70AsMVGr6ijJ1J5qUyvgw2446agJdpdY3Iz8e9KNdPjeDcaGZ4wucCV/6zwkY0s/qPu9c51dOxT7iGPl/os7YhbuEn+RaVloZynLLVr7IW5fujFirqytyCN+nRgCxpzu8fdGFNe/PjZDLaJc+c9pVr4urv0rhnaFPDX5GVAQzn/VutzdwuJA0bVTnmkxvoZIg7hSJwx313IiVDYpriVzb8aldi1ZJRjbyfR/cLuIjHSjQdDAeCDYniu388raAojg5Imgot9bSJ9m3elL0g14PB8bBEKwB8MMWKeFlrywfmHls4T4wlK7iaMxm7L5xNFIYSGkacZ6ZTnjQClVw4tGL/MjwUskt04uibbwM4Lthq8q99mXt/zCGoANf/IeiXHWFIy1KR31iQ/NlGhQ2+EcttvL1DGJJ3WN1Wj12YAW/4AwqLdx35YGCnkG4orFFGSvnHM3EdSbJpdT262XDUclAJ2Tfn+P33k9nt0+OGn0O19kSWr11ClFSU0VBOBXmaa7bxvVXh2T5vYzqF9r6H3CDTFP11awxRV6DPsHBXQZ78U/y3bfz8qC82E6FuMP7zQXDozrTgMM/75qCN/U5073rGYARfWvITpl+pp/zF73x8NE69q0P5llpin99dMp9VjBAJLAEHQ0D6qCQ9KtbHlRTEFxNC4VPbbEtf9Q/HrdfKlFScdPJwJaZ7kiuxz7G6MEivHoVXu+e1OpfoPI4sblK5UFqQzsIKXQ0bUQwOTQPKaE3p7jaXB/eU2fff
 BFpcGFuY
 oe2SFJzH984HQ/j71LOCiEKHaGShdY3/N+cu15d180loga9TRrKhtY4Py6fD33Lep/+mOEgkNv8UnYEBNe4n0PAa7STv86VWV+sVw4Zpnrpa9O5lSo6zKVSvLxonXFxzD3aE/bTysS3c0XQsd8Ofg2ddnwn5YfT79dn5Cisw8AxZUycb/rmgPdjYbIh29AVMkKXNtsrm3iVyx+84lVV/aZuLlAPyqlwR06UF+WlJ5RwzVaMTu2VDM4j2yrnA9PS/+iVwna8OC9qU+p6Qsi6uHZknLfy0G7YHjRMScx7gbxeKS6jwbLJPPXOzxLi+Qj6/D/3j+ZLmBcZKI4RI=
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
index e2f50b4aba82..32f91935b210 100644
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
 	/*
 	 * When RawHwpUnreliable is set, kernel lost track of which pages
 	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
@@ -1848,6 +1843,40 @@ bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
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


