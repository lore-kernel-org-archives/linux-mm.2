Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D67FC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FAB6B0095; Wed,  5 Aug 2026 17:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636146B0096; Wed,  5 Aug 2026 17:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0556B0098; Wed,  5 Aug 2026 17:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB956B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFA4C805BA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:08 +0000 (UTC)
X-FDA: 85068448416.30.DE1B265
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7632C100012
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=q3PtuWGH;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963967;
	b=PvkN7nd+4KpzwwpwWH0uo1eeIMlYTdJJa3PSyHHP+k3FkslSvB8OlayPtWPLyD+Jt0/rem
	dPS+STNvRTuGm4CCNCiIrkH9EMY2Q52E+raTUyRp7VUBcrM0S6wEXA6LZ3VaBXf5/+4zMj
	exoxgBj/HaGOuMbBOKM0QjGSiFcu124=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=q3PtuWGH;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWYVx9PrtYRbmRHTLoskq3BUZKyEU0Bnui9okShtgwA=;
	b=oWeZtfOh47+yGpDwvaLIzyQXvM2tWiA1YkWO7qA9dCdTSKVuMphTFl3hM4PAt8w+xUTUP3
	Nqgq4kVXG3nz9j3QtBd3UBTJp6psHvVHsn8g0b/hWGogdXBj8mMJk5rrrGZZrTzsU1bbRf
	/0HMuL2FcwPuPDyvA+7gpbrfGxlySCU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=EWYVx9PrtYRbmRHTLoskq3BUZKyEU0Bnui9okShtgwA=; b=q3PtuWGHCxeGkQsu8Ki73aS6y2
	NpBR5E6JQiNftXKAXA2KtAYIAS1a1/g6d9aGWl1Ja6OMs4Fj4LWzNcYINUeaa5iXtGFnaCxepQvMe
	dd8D+o24jIWgf7HqAhAJSBvmg5PKJKxDP9Uy/sFv6bmMV8Iin/v59v6SIAzZ68GCEPa7qS+VYBagc
	/DGeEDfYFh3HV5st8DMZIS/yHbe4YqFrFb5cxqsazNCGiCNe6nUIwGlwWB+DVvBLjoAN8rfz+OxTO
	p6xd+kkareme6KiN3i0GOABDZpncg2vkpn6aFj4rPjudzI3JNzWC2RK94BD31el7x+ET8LtjGHdvL
	L2NStb9A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioK-00000004h6N-1Lc3;
	Wed, 05 Aug 2026 21:06:00 +0000
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
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v9 10/15] mm: Check individual hugetlb pages for poison
Date: Wed,  5 Aug 2026 22:05:50 +0100
Message-ID: <20260805210557.1118966-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7632C100012
X-Stat-Signature: 36rmat3hm5hsdqj7k7yq3t5wj9nkpene
X-Rspam-User: 
X-HE-Tag: 1785963966-459238
X-HE-Meta: U2FsdGVkX1+tZsrisHiQs3y9f+O2b5QHSrr60ld+14YAWOmkJbGRJpOWgPKEdXbC3cVIguPbU7oEZbDHhqUir/5OFZH3Pkp0erg7b+AFf/csqhkM9eAGGfFEu7DMFGG0UYJRKbkkjiFIjrtDHgOQe7MDDLrIYnCxetRYrRt8GXdU0xneiM93VftGY/ppcYbF7bYmo5HeDi4xRYy0LE1xVvnHQqWRnBgmrYkiOYPoh804ONR5cRnGGMuedqsbkeqz+7jPekQQERks0vXqeLYihsyOZQTVZ3b8KBwR6fFWpLCyJwlZKKlNAcvA9t15/Ri5bdpUfDCFyruIVaf1Moy8L9EgBFlkLbrpb12a1PFgCxx9LQf6BQVgbfNhmXUh0CvDL1pBzEzjQ2RpggE9S+LYSFPZAF2AvYPhAYYUd54GA9Rk1hio2lI811sFcXZT+t7VODrpFyIE5wMcGjaPB6v7Wnwm3367gai5dQaZLwPldTBD7nrvMWuw0B82yctRcdMsRd7Jf07QQGL2iv3OLgXhBHVobp6eo0JqMAGwhriCbCOo0l0fA35xSGLr8JunWTKTyx0H4p9p3kX5JdmE/DrfSZu27o+JcMGlu96Kf+ilLVH3ltR+qPXbUYagU98QDNuP2HjcIGgT0FYo4Dgtl5l0XPzZd6hOXzE4ziEd4dQHaR4bP/pBIo+M70ScQMKuFmKPyFmTlJ4DaibD17+4lCFUTcBmMZkdwlirjOyxFUjtRTBCrcRlNN54BTcqmC7OE7Xf7gWRGxDUcQufBzqfrLORYIlkA0mi5tJ3qAliwSndTWgg3V0jQyZRPhjhAyG7+VBoU6oSJgxlYGGY/JUA8yXhDZ6YVs3GhAhgRn6W1MuBbPn9JSImmtLEs175y56IYcA4xtut1QWiV8alCqkR64Epx5/1lN7m3q9Ylw5oAVtpzLtyYXqFLUs8coexy0pwygQXXstKn7nODRwjKdUgbVs
 bsmtlgWR
 179kc1v6QPyagoimls+n2LWkGjmNl5NsIKAil70ipMZrP2bz3B3VN123p4wmYDeuj1Bq1qUH5BZLjwriuAyL7Ec5z+HZG0OAyvF1gIbxpUhgVgbmU0gG5lbPFDHifa+7LiKJvGuj8Nmf54QQJS/PwwsVYPHXqfZ8G02DGwymnMaqKxUIr1tePrJgdeJPIA4SVp/Ix9SP9cTQ/XtCb0QzyyoDo9DLroAMoKdbhe6wAgm9qb/DG4SCzFx0b0beFkkTdSyaDLtm5RgtUlLaukQVWFC6Y6MZ0B5aO3kRTRQtMIS/PZcHMDzUFsDz7xaGSZOpOiv6TDxIk5GawzYqkhKAVYMQcEGie/ook38+yfMSCzBGpoCfhjHZwx7Iyd77Xvubn7It5xQDGjAb83GuiTwWhUT4T41agB4Ztl/KS0SWoJ8PM5Y8m3DDkZGHDXb8bFRARwMs3
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
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/page-flags.h |  4 +++-
 mm/memory-failure.c        | 43 +++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7e8784e852fb..5d01e5b28d0f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1095,6 +1095,8 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_unref_page_hwpoison(const struct page *page);
+
 /*
  * Check if a page is currently marked HWPoisoned.  This check is best
  * effort only and inherently racy: there is no way to synchronize with
@@ -1109,7 +1111,7 @@ static inline bool is_page_hwpoison(const struct page *page)
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


