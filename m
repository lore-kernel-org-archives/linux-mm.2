Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E20C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B236B00AE; Thu,  9 Jul 2026 14:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2446B00B0; Thu,  9 Jul 2026 14:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1906B00B1; Thu,  9 Jul 2026 14:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91B706B00AE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:48:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2391B4029E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:08 +0000 (UTC)
X-FDA: 84970123056.18.ADC4DFF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82860180006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8BLG0jP;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622886;
	b=W/La0625yiP3B9QJP4fWD2UwzY5jTIEJ1HUDTHO7Q5+YGgClW4eGFGN+8/c/ztzrT9qKzB
	H6rgU1v2S0PFORGWjt/LBMqmraaXazjTKdcmg/8BmNngK9n8kjYj7e1LGnAVw+yBFhIdKP
	/ZacFRTiVCH6hnTXG8XOLE2Ou7Mn/AY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8BLG0jP;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBjegxxMfo8QzONw5chVSOjBUp3XLOtX+LW6eSxSxz4=;
	b=3z5uLu0EV5YKNQQ5AqZRB+AqVFTWxIp45w2jdb3GVrrkFALWo5hqEP7qa2OOEPscbeB9jz
	iIo2EWXvpPIKVQCiZvAWI5tjVffOfI2U6TgUrR0EdpZyRqJia0bTYeEuKIDPMALUvhLNu9
	J1ir24hTubMvckWKtVC05XfWFHbvw8M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=fBjegxxMfo8QzONw5chVSOjBUp3XLOtX+LW6eSxSxz4=; b=d8BLG0jPmzLw3dFray8Zg/jprv
	uh0nwOEossHMSdkj4yW+CZGvTLjeJkfdSD7WkRszCiSoZ5lmVHRQsvUnbh3Z9e57weTf/fMve6xlU
	hkI76Fva4ikvoQw8RPFG+NmIjxPvlWkxSoq56ToOU920mWkzoeH8zRTzSUG2YLBonhXLHgM2EPEVj
	Xg5s2v6AKLwUWC4HCGTQEElufkbERoPzdn9MdH71oz83Axwlmc0o50oVcpxiiPmw669rKb6N8ecFm
	NBw32A75BEmqwQPBs9Y3jUVOwAUs901l7/qXSXCUGHcN3blJ4BKsvAqoK+/7T1lTUaQA5dxejqrPH
	z5y1wbBg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmh-00000005OhN-00xQ;
	Thu, 09 Jul 2026 18:47:43 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 07/10] mm: Handle hugetlb correctly in is_page_hwpoison()
Date: Thu,  9 Jul 2026 19:47:35 +0100
Message-ID: <20260709184740.1286561-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 82860180006
X-Stat-Signature: xim8x3ir4iy6fsach5qkya7pncpcea88
X-HE-Tag: 1783622886-407655
X-HE-Meta: U2FsdGVkX1/K6eEnfKIzYDfIN/4SNOs3bvKZTOsDccNLyE18pzkU5vDSbTShFpGYENZW5nmadS7AciBHM3MTp+GZg8GtN1LwKQ9/597tnC0CjPe419K21DLIfjk0AtT9H0MH4WUpk7s+LRSaN05+Ad4bkmhQBmnb/2JAZDTnQAUpPlKGwbAB3/Dg01/0h7ZVnmad3RxSu9nQ+mfIW2QvevPwktpTIF0yUqV9Np2F2xa+1BxdPbotNwiAVEgvdBJ6aFCk7A3XYEPcaqQKf7O4ZZdVO0EwnP1S5xk1NpU/KeL7O9Ed2hop+UT5NqpXx9eGHDe0D+zkhd15fl3b1g0muFgHh7ja26nRC9TIXqL3akO3V6WgrtFEUl5adi96c5E916NxAvXCrH0AgQvALOfqAzk65NKCBqrq2xWLcZFwKAnLZFjO3aRn0wZuvozt6dtiy29YTV5Imyr6WsRkMcTq6Ifha8FeIi/Aj2fq6am+LtP5HSYJOmDfBObu29wZ4YEwhJEfC8rMAkv0E1ItNE6eze/g7Z8xZqQIRskMVtbJpx2+YyGGojjB5Xnjd2pL51t36Fnh5FE2ZNND+Q8o9Zbx7QCwAUXdlPucLoVU7LZ46IxHheq+UD7GdOS7OA/WD8cKRBRbncv9AIaveuCS01MornKAmpJm6c/Uq+28c8WSQEbRnVVdyaKXc4/d1esVRMluVf9wasgz6+3uAg1SBvKV3apf69151e9x4b66PT7WrgfJW/LXpYPPLssK9PCGRtA2W1tgKAUehU9XEJtQcHRMotGz4/PfUYjQ3CZ++w339DLqPd76xkaQx8fa2kue/MmlAOg+E6FciMVgmBm5JH2/tWV9tja2fX/HUr4/tjOwcORDxYe/tRjdOVj9wXynqRk7AJoBV1wex4zYVT6b0FzTiPnTyo6d7Hq+mTQbd6wYL96QRpimAGMVWlxBYyWGmIqS6Pjzb1P5v/zN6ZtBQ3E
 u6D6a+hC
 kmmMJ9yYDN9sVgMEFhBTF0kZHh6sG7QLywtZKQpPb7hkT9jYuf2a5Exgij0iTpmTUOE7Krnhz9xohkxbS6FdPHjreH3KIqGQReCpzOtQfSMjSOC3gxqQndifSL7OPOVDOBornlNWZb8k04XJ87rGnDqoNgy1NvM8p3/x+RrF/8LvGr+sS3kTeH1DF4OhFzKRA0vIlinZdm/VooTFU+5H2zz6PcBX4LwOpM7ASgZ+stFgI/7xjfdgwfwhgeEIczhCGHXsqBHpM6Xkq+ziVdahJXzM+wJxs0pfCSP+xNcRZV0fE8BPjE48YbWBpY2lw9kBYM1dBYEvLnhyTTyTJxd5/otHMf6bTo/7UXC2LwGmfUACHSvWmX2hBHD2c/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Checking to see whether a page inside a hugetlb folio is hardware
poisoned is more complicated than I realised.  The correct logic was
in is_raw_hwpoison_page_in_hugepage().  Make is_page_hwpoison() the
official entry point for "is this page hwpoison", no matter what kind
of folio it belongs to.  Rename is_raw_hwpoison_page_in_hugepage() to
hugetlb_page_hwpoison(), and remove the attempt to handle non-hugetlb
folios from it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c       |  4 ++--
 include/linux/hugetlb.h    |  5 -----
 include/linux/page-flags.h | 24 +++++++++++++++++++-----
 mm/memory-failure.c        |  9 ++++-----
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1760df6f2709..725bb945a440 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,7 +198,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 	struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	size_t safe_bytes;
 
-	if (is_raw_hwpoison_page_in_hugepage(page))
+	if (hugetlb_page_hwpoison(folio, page))
 		return 0;
 	/* Safe to read the remaining bytes in this page. */
 	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
@@ -206,7 +206,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 
 	/* Check each remaining page as long as we are not done yet. */
 	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (is_raw_hwpoison_page_in_hugepage(page))
+		if (hugetlb_page_hwpoison(folio, page))
 			break;
 
 	return min(safe_bytes, bytes);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 18661a7cdb37..1878642e75ec 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1069,11 +1069,6 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-/*
- * Check if a given raw @page in a hugepage is HWPOISON.
- */
-bool is_raw_hwpoison_page_in_hugepage(struct page *page);
-
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4185a03a45cf..8e57c12a7301 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1068,6 +1068,9 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
+
 /*
  * Check if a page is currently marked HWPoisoned. Note that this check is
  * best effort only and inherently racy: there is no way to synchronize with
@@ -1075,13 +1078,24 @@ static inline bool PageHuge(const struct page *page)
  */
 static inline bool is_page_hwpoison(const struct page *page)
 {
-	const struct folio *folio;
+	const struct folio *folio = page_folio(page);
+
+	if (folio_test_hugetlb(folio))
+		return hugetlb_page_hwpoison(folio, page);
+	return PageHWPoison(page);
+}
+#else
+static inline bool hugetlb_page_hwpoison(const struct folio *folio,
+		const struct page *page)
+{
+	return false;
+}
 
-	if (PageHWPoison(page))
-		return true;
-	folio = page_folio(page);
-	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
+static inline bool is_page_hwpoison(const struct page *page)
+{
+	return false;
 }
+#endif
 
 static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 353288cce1b2..58ab8166b7ec 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1817,18 +1817,17 @@ struct raw_hwp_page {
 	struct page *page;
 };
 
-bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+/*
+ * Check if a given @page in a hugetlb folio is HWPOISON.
+ */
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 {
 	struct raw_hwp_page *p;
-	struct folio *folio = page_folio(page);
 	bool ret = false;
 
 	if (!folio_test_hwpoison(folio))
 		return false;
 
-	if (!folio_test_hugetlb(folio))
-		return PageHWPoison(page);
-
 	/*
 	 * When RawHwpUnreliable is set, kernel lost track of which subpages
 	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
-- 
2.47.3


