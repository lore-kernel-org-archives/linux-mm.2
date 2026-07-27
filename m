Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A85FC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428266B00AB; Mon, 27 Jul 2026 14:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB186B00AE; Mon, 27 Jul 2026 14:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AE76B00AB; Mon, 27 Jul 2026 14:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3F086B00AC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 622DF120149
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:46 +0000 (UTC)
X-FDA: 85035354852.25.F056EC2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id C9EE540005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rLuqctr0;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=;
	b=n0mUDxm1G3LUghbFkWVEa1gPFQb+8ylffJw6sbTeES/E0KFDvYBfAN9fV6GnN/1Je7j8VI
	z5fO5Q3IlM/pzQGV7A4joQBnaVgXlVdLYlQP74fcBKkBXyvZ2hoVMK2IrBMZFs02H46+r0
	4bk+xKDXFaIwOdLf870hi0Eq6mYviaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176024;
	b=21MzKc4a0J9yGVSFFtylGtT5Iy9p6bTzQmVrh/IbN2tQYydtWEPWbPWw3tcPlPIajuRsr/
	NoIMDTEsWyUbD0YTkyDBfukJskadHVsBZlv/5WL7SJNP48vfibDUadBYnjhJ6LmyCrC2lk
	CyUAgAFOtKGUWzS/lX5o6f8wqadE9bA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rLuqctr0;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=; b=rLuqctr0tNPXBH609jMeeZxb89
	Gra9CVBS4HSjLDcqQlEmusssxYeJlnC4T9kbkRkzySY2IlNh1HhiLqTj0pYLJPxIX+/iYcnFkSWas
	wAbPDBvY3ouZiJaUY//4ml2u9FPiGU/tt7ulNFdLWxkBoOInrJ/sFbawQLx3utcsJpNcpcAcGND5R
	tqhFz8nze3LSWelxbXBqBVeBG+3dFfuGNhSTepL8mbejYsXB3zassPz9PB/wKxBZF9x1fSV8SGdpn
	dX8G6v08CpykY5a/qKfPUbMIQyjl9rIxhL6/b2lTaH26LjpqrEXA7I5ioW+XcPHuMkJp5euXXasj0
	96BT4l3w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPp9-0000000BD7Q-48jb;
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
	Jiaqi Yan <jiaqiyan@google.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 02/12] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Mon, 27 Jul 2026 19:12:58 +0100
Message-ID: <20260727181310.2671972-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9EE540005
X-Stat-Signature: cyy9qjoejk79r3einxngdgzysq9pfs6u
X-HE-Tag: 1785176024-715747
X-HE-Meta: U2FsdGVkX18+qo2TXGFYCTDEaB92D24XJPdGgDnOj98PWec98mgpBWnHogHRkkC0Us9368uZOCUgbu8Q8wuD2rWa+5GHmC8Jpnp+hzHY7CwKWrPcrLQUZ+MqmGIHWhfrHYT+v4rz0ak2gF3iTlJamnwF+d9nAARLQNPT/lWNAnU/upXjax0SprRs9Zodw+GRy4bWXGrobUl5ORX/Prp+FQQGbgs2//iSr8UXIYeyhGOtcsU5sJDBdj7NJVVQtpi/WpjOq0jxvy3eswz/QDY7cKQsH8rhwQ//WLz9YNNTdkIv4h4EYpgUnqMHB8c491jGBRbHfAO0weocKmLElZ6Z2R38zqOdnChRPfAsT36o+L/NSACertGS5pKbWE7KgteV76WD5fHV/vby5wDKDhD3KO25ZIACD55zMy51elAmeTzgHM8HG3FOXRbUdTcPy1PXCI2Any2MWijDMj8qYOPlGN9uHEA/YDImqDkDlYt2XYyU6uguzdQsgOs4EDE8piuIPBgF7+KtSBTt3PTDAsmvQfEaR/UfLADoxXuHqBWTurSC++bxR9QQ67rjE6nMLsJRHndLDgbdm/0hxlLUlUPNwNKIaTqtAC3rRP6sHUyxfP1j8TCHIIe+0iNYEan4VErezTX485NjWRrZajgbRK95kG2j7HRgnJWHGwyP3ezxrbfbhhayxkhIo7ypOMWMTrtaA0bffFSWk5I9Y4T99UASH1Pj0c0BFNjI+RclZ0MX9hbmwl8ETCFSQoeM6049iYnemoxxW9A3dm0Mu93DJUHlcq/X/YdD3MmD5onDPRoMWFhG3+DeIgn6sAZf6atzkXTrMLUYa5/Dp5jfL2I5pYbAeRcyIa3FYFZx/cNZYx82MYDibIkocg6cECVD2qMmw7XLmxvCuyK7TRza/yaRvNoglqHn4yrpNCaDML4UdZYoGGWRgfxgQM5o+kRitoiLE5Gi3/LJoi33eNA6abgMQeH
 yPJ4T02T
 Hd3y+Tl/3QathxDY6y81bKtMZVka+FTCXAm5Ctbm81ee1O4AFC/lGvrQMgxH2GjcO8y5zY2xYSaxlnOFehSt6c4dkHI7iDYTvt5I50t11NIPYxnbPz7zxzFCaoLUUelX/GnHiiio+g+F7RLm7QwY85/Dybip4Gfzv77rNaPCrwGWvD6mtcoHsJ3G4jcU4HwgtxkjWAdshoJVij8tmLAaBmirtSaj7bNy2YGiNF/Nq1w0fa8iWHXSvBnQP9VEpC4tftDRecLv+InKSpzLDCJsAo2mmk9eMNBEacbgwT8x1ZoaQRup/cfb1Tm5YzNlQhAOU3Rclcw8ROuBcDXasiqHbSq035336f23vjHpy3wLkrbq3X/PjS05T2U6Giw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better name for this predicate.  Also make the argument const
to allow other callers to be made const.  No functional change.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/page-flags.h | 4 ++--
 mm/huge_memory.c           | 2 +-
 mm/memory_hotplug.c        | 2 +-
 mm/shmem.c                 | 2 +-
 mm/vmscan.c                | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..4185a03a45cf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
 }
 
 bool is_free_buddy_page(const struct page *page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..353340309107 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
-	if (folio_contain_hwpoisoned_page(folio))
+	if (folio_has_hwpoisoned_page(folio))
 		return false;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..33007e8e546a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() cannot handle large folios
 			 * in all cases yet.
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..492c9bef3620 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	if (ret)
 		return ret;
 
-	if (folio_contain_hwpoisoned_page(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..70e54ace0e74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!folio_trylock(folio))
 			goto keep;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() can't handle large
 			 * folio, just skip it. memory_failure() will
-- 
2.47.3


