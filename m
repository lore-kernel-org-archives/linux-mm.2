Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EEF1C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C7B6B00AC; Mon, 27 Jul 2026 14:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DECB6B00AD; Mon, 27 Jul 2026 14:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD416B00AE; Mon, 27 Jul 2026 14:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3CC26B00AB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 612E71C00AD
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:46 +0000 (UTC)
X-FDA: 85035354852.24.23F9FDB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8CFE140013
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Gmn8AmlZ;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rf132WtRmSzSxiFh5bl0EzlR496uNHjo/zfgkA9sYuM=;
	b=j0SOwJUiIrhM71ykyb7DybTaKthz8RnDA8nIKzXcI1Pvzeut+k2kCAuaD1ivq9yVo3W6bx
	9kdWtNSPSL97VpyHUuEuyNWPq2qjTo7sl45n11NFoXJMKRIaVW87n3s7glsYJLQLHqWRV0
	bilL0gw2HviMlHv+N74Jts4LzvJ1NbM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Gmn8AmlZ;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176024;
	b=2X2Z9pQa26BYYdPMQRleCHRGjIeTxvVZRH0JjOCFVIk/93inshSZztNUqXgTeTBrY69hzf
	If7TpycNghkzxUdKrW4Gnb7o3oaUHm+wzS4xUQUgIEt/e6pi5Ay7GwsRAUIRhJ7S3XJGZ6
	2iVE+008WZdtMXhua2FsxA3A6QO4C0U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rf132WtRmSzSxiFh5bl0EzlR496uNHjo/zfgkA9sYuM=; b=Gmn8AmlZF1G0Z2phJV6LnBq+6W
	acSIKwSHIa0QCTd2i/6D6LzG0c8wkTbo+Ay8M8x2MYUcnH7AW9gG53S5iW3qhFByU+eqvvZNwZkIf
	S2ls056TYoODRQHkB7datzcAub0LGKBkYwj1eAoigASGEwyc5txJwUcSf4ImjS5WAycBAoLkz17O/
	97vngmClSoljUVHntw9Scglvm0OSmgTiMt0WYE9RQQ60GdEl+7rphIZ4JfLxQvUniZtmaYbTHD7L5
	Jo15NPW3ocb+G/IQTpJ7uSJSTr6oo41Gq/XMMHcOF6W313uICGxOcqmGM1IUjljpu9y9CsakZoNxj
	eYATpAFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7a-2DBz;
	Mon, 27 Jul 2026 18:13:12 +0000
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
Subject: [PATCH v6 07/12] mm: Check individual hugetlb pages for poison
Date: Mon, 27 Jul 2026 19:13:03 +0100
Message-ID: <20260727181310.2671972-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8CFE140013
X-Stat-Signature: 9pcua6hwm6fcj571qkpr8kec9h1hixjz
X-HE-Tag: 1785176024-906074
X-HE-Meta: U2FsdGVkX19G/lP6Niwr5f+WgnbGti9sd6WlpLL/3zXltRwYXkvd15eBpANfm+Pw9eqoW/z4e/E8/4en6mIOI73Q3JeTIPIq0zjm/OeYY3GMWJ11AQqAJmgmm/luHF/8VZDX4G+AYRbrDWVYBWpgq7pvjSZ+9yvGxZt2evYKANYLGsdyN+gtsnHRnq/GQjRGQ5ocftmxbpE5iztP1JZ4NCaVgpeJzTA7NgQM/CdCfASOvDf9fKspySTq3JxXWRjsaguAtTjtwjT5WMakq41akmKGNRIQWuTDF512c0NCoMx4JQ27qIRjbM1F9LKNipC/a3d2hB3EAhkPBtM44DJPMoTJjEFNjVAbgIA7cvClktjSZ+lDw5viFyYIlpDsznyYWWeK1YmyHVsX0YujoyD1kliZUnWUgm86tMwSLh2UatRP2y0vchlG5O3Tre2e5ZcOdLKSS/tIw6aE827B4B27ZgvpBo/RQzATpEMlGwASgKfGnLnnNju1Y/MocoM0gMek2vs1wJUFQUAFsBi45eWf6agMzSubNNM3Oi122nFaKyqaOb7WwTJjN2gWw26YMgIIz1YxlNeVgWWNyluksvUuTSA7UxQCi+pc02UINSzimfPZuXncL82SJ6A9M/NX3iltskvxG590NTU5zw3bzR1GYSUNOIDTcTxs3qrgk4uX+hL7esk9t808fK3AKcegFT/Hk+RwxrE3AsIQgPwCBkgK2XZ7vyAs3TwigO2kJCgT19uxS1S4s19OUzA9CwThjvssn8Ge3kcsCamP5Z3dJIHxsswjOFGTwXCYYih2DFdf7hBEwEJWxH0xw9LhDRkeu0qpJ/JjI0UwdZ7+jpDCv0XUDLL6wPKpdua4UmzkuMGvDCXGuYRGB7ItOO/QZtsrkGZF1/GxPcoAvZ1TNpINOKfrCIFCAj8l0XytluITq3j6YJmwG8iQe5weyvf0LVfuKdAyyHly0CuXCS2uUcrysWn
 zikcHoUE
 3lLiIXssri3zWB2FFS8NtG7FP3GPJAw5iwB+KI1kDMQt/N8lkxI2j+1UHGewtbpVHGJcsOQ2QPQ1iPwBBV0wNYUtUXs4jXpr3ts0DST52EZsE01qH9Z6JI2qe/XMgZqKvjeOOM1Y5HYluxZ2bCeyXe+8kIEicCQ24apuoqTE2b3UaY9gxB3UiHChkeUonZLHduOiO4cCTd1/gMzPOUFRTKCv91xv7ueO8K8es5EUApSm+c0f2VkLooDC19h+h4NPiKZ4xpURdud9vvmFf3XyDfF3nk162Fu/bRgO0heJTuh6zeI/tBfp1kmFZik16BoQv9Q0zzrSymXb2uPU=
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
index e358f6a33d27..6ca7e1df7f73 100644
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


