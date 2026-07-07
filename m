Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF35C44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968186B00A1; Tue,  7 Jul 2026 14:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940566B00A2; Tue,  7 Jul 2026 14:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8070C6B00A3; Tue,  7 Jul 2026 14:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F82A6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:17:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF5F21C3ADE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:31 +0000 (UTC)
X-FDA: 84962788302.03.149D9BD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35A4B40007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LS5oQdNQ;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgVb6YtgHwG9vIEy3hHu6uZOO7cLsUkyj5p0N+oC/Qo=;
	b=O84wm+3cpfU4VtOkNsq+54GwiQR9VuwNMiTw1+0gbkvhpJT9Bs8KxjhgZgCzmG5p9m97zM
	nAxO4wC198nA1XQFk6bMbRlbFkC8R8ihuBrcLBs3veOlM2GAoxKxlACLQ4jXcNhcIWK5WQ
	rZRu2P9ZjPTwFx9AjNO93OXFoQJs2K8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LS5oQdNQ;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448250;
	b=j0yuDSy2HQrKWbzYQaUEODQDSsUnzV8waKRgPdw9yS8pVE07ppSZCyTiqjanvZ/wkhk5yW
	TH90nYEG0VMR1v3iWKcDiXJuWBetcI+W4nk155/imAGrra0yjSduze2xi0SExKc5zjgxsU
	40iULR2vZ0/dos1AJx5qLjbLC4a6Cz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=JgVb6YtgHwG9vIEy3hHu6uZOO7cLsUkyj5p0N+oC/Qo=; b=LS5oQdNQE5nIc4JqufqyoJDKbm
	wCXO5VAjayqKhXSTMRQet3V1e3hoEKiIlW7lvOWJjyKr2C67Uy4JCrSrXZnxvoAwDZtNE3Gyj3yf5
	SbV/dwXrjwsQBh+vhPxCv++H0NlhQk5wxJs/nUxuD8tTgrsEL3Na7yBDTLTLumBLHr9BlZzxg8Lw7
	wG34x6t6d6sPglMprDC0PwqrxriD+i8nNp4iHqNQ0dvY3+d4J0XR162tefwz+Mfejb+XOs83uCbkb
	GDd5WGNHTNKWFkplQjfaJA9xwkLZbvFbLYz0hbbRS5feNQ9sTXohRKG1i5iSnp0dSm4oFMxPPjqyB
	ZSmILQaw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whAM7-00000000sBg-2Es7;
	Tue, 07 Jul 2026 18:17:15 +0000
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
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] mm: Handle hugetlb correctly in is_page_hwpoison()
Date: Tue,  7 Jul 2026 19:17:09 +0100
Message-ID: <20260707181713.208282-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707181713.208282-1-willy@infradead.org>
References: <20260707181713.208282-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nmqqf4ekwru177ab5hry15y5s7hdt834
X-Rspamd-Queue-Id: 35A4B40007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783448250-695520
X-HE-Meta: U2FsdGVkX19e0AZEbKmG/lKhi1vocX1MxypIEfAZECXEuFlMohZ3t0oZdy+p2B3kyhbD1TN8PTZlycRFiOw8E57KMI0XEh1WGodm2GrSUOgcNNrzwAjPdYgXtw/0wCeOSlxZJW50GrAWoCKl1yPyaclMgeVp+QilY+SdUR8bBJbhO0DRyAxr4kbIrE2a8cs41dD5II62f8Vudqq2QKl47VMkoOadiVH+9NS9qEqX8o5jhIDPqcsfbD7DesrlxxEHCvB4Da9nzHjlxm/TeTNasqw1M6y93KuaHHNWpLrw0kyLp5FRPjrj0CdoIfsVt9IlxGPa+RiiPaCJyHQQIkX8HqbwG/GEgKkw45oo65pg/uxf174sWyLGb81j1kNtA1zvgKePCedVZNq8074yhSZqEPD0B1Sj3QBVa/o8zi3RJ+zRDprQ1BygWDKaeAazE0Ihaym96F0hD94t8P89cTqLkmDJC5xS2ZXu6uWGBrUgyvR0QJZCG7WaSFpsyDjm+3kUx4HKx1yHXeitTlgMQ+SrIUio+TRFi30yiDPYyGqWKCF8oSUIakxRdUwMXuBab/eaWoa9+KiUT7pAaKID6ITInrimq46Nk4uaPuIOMQnDJZA0wdPO9eiChZRCrbsQX0mPy62zlsGeKDF859L0HvwKOdRQoqeriw6wMmgc9IOicKtKRXdVviZTUp0O7fONYkauNrz+/tc1cnpLjfF14N2Y37FvgMhMWvjVtqRGmVl8373njGVs+dH+lW1WP+L8fInzGOa4Che0l6PVqILnRvvZd+4NvGemEYo8DRATTU2xpCUtn310HBxTQLJx4K7SZZDq2yn6usauDSCyTbyyfYT4UV2xgtgpC/2ORtZMocyrIBgmYAZXG3EpUs+Oa65xoiSMCakyrB7l3AsIokpAsosfSm1hj+bZ4yfjoIw6PWnudIkWVhcVrh5TpUl0nTMbaOSkWPX4/CSbg2awztFJhGn
 jZir3eYe
 W5aJyR6pcGQeEYhWwDrwfeP9jJmVl4hPQTbCO5if78Et+XjIStcW+T/MxZb/p8eCk4A2ZhLcL5tYWcjGl7htqVAdUDpZCt9IDaTv9he5cMsOOGktgAi2D/2o9nQuBhL5Au3J+QbIicJH6eX+HrotngaMzcAMplmsYzkuEamV7hMDUdPVJtfldnuahtovI/jpfYwMUxrOSlewr4rlXs3aqEwHEGR7d3w501MV1DrqZSTvjb6I3ZTqccpULIyVMoAISRzHq4Zk1w9WGKruqlTzDMx/GDEddon/oIGDMlmIqIEBIDKi6mMbHAk081NtqiQLNZ626dMwZ0LwLNWvvmxmZz5qvUeikOWKGJXDu2D1ooakAXtO88ugxXydp/g==
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
index 2abaf99321e9..5df0bb618b05 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1070,11 +1070,6 @@ void hugetlb_register_node(struct node *node);
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
index 7223f6f4e2b4..b0b451b4e632 100644
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
 
 static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..0980791108a4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1822,19 +1822,18 @@ static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
 	return (struct llist_head *)&folio->_hugetlb_hwpoison;
 }
 
-bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+/*
+ * Check if a given @page in a hugetlb folio is HWPOISON.
+ */
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 {
 	struct llist_head *raw_hwp_head;
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


