Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13266C531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECBE6B00A9; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DF66B00AA; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90336B00AC; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7173C6B00A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 015751C0A7F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:15 +0000 (UTC)
X-FDA: 85020278952.29.E87CA98
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4BC20C0016
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nK949Y3n;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7Aeb1EqPNPxeMZD2pjfvJMEP/p6R5kd2OmQv2aIRuc=;
	b=V/NLT725rYQ8/KV8motFo3gt4ktsi829UZ6gSxy7nZtPuYh6tIzcIw3SZVsdPUUDVbhRnR
	n2fKaWEth33LJM5UGsnzsvqkqrM9RCqZrfV0IpWIwi538Tbf3b3uhMViWzbF3EJ19ZQGtq
	qsTg8R4Bkp1QqCz4vbL8TprZ/LMa2Vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817074;
	b=Di0vJto47aq09VgAWWy4eUiaARFIe9Lf9GkqEBnhobL4LhlcG550AqKYgAMzIJP3ACjMss
	0amZzEseVEsRS9Tv8L0NtYChc9tgoxp1jkNmB0lAD0BD01X+6ETCcFOzH12Qt/cyhE9ewe
	DfmasFBNQCY26gzpK+aOCRKWoSgNfRc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nK949Y3n;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=K7Aeb1EqPNPxeMZD2pjfvJMEP/p6R5kd2OmQv2aIRuc=; b=nK949Y3nrGDjkv8QlxPhotECHd
	0ei16+jvDOgaLnkS2fgQ/8LssmLM8hV+LMlCGYr4Z7hmGqhYu/mDgqQMo/rxmGMh8qCBX0sp9UYB3
	s6PjrlnfP4vSPhGEWJZUmgMeS5CPnNnCXbZTmLVR7f5JxWfezjR0Yvt7WmMdG0GCUe8I92mPDoYWt
	BX+tNeUq4krKyor4XN4JvmFuHChEec5bBOMuK4Xts7/l4CzbgBX9XrL7oAid5EBNc2qrb+nxseTMS
	cQe1AAbJq4Qhogyn4mYQgX7jzfDF72otK/HkK4DoPxkIPyc4IVXkxbh7+LrWVDlTzcNKXnCt7HvzH
	iX1vVq2A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000ji5-1RW4;
	Thu, 23 Jul 2026 14:30:37 +0000
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
Subject: [PATCH v4 09/14] mm: Check individual hugetlb pages for poison
Date: Thu, 23 Jul 2026 15:30:26 +0100
Message-ID: <20260723143034.175661-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BC20C0016
X-Stat-Signature: fcadch4httqhgky5a9nf1tw8b4mzo769
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784817074-409602
X-HE-Meta: U2FsdGVkX1/FWMc/dta1zrTbctXnPI07xbeDm2vz7PW4XTCwBDFoKJhH9Y/j78Zk35tIO+tmRJc0pQlOPTsa1sRqc3/LYKZ0NiWUmbCL2l1Kb56IMq8oMF+SdhhjSHPP8tKvpr892YkWGxr3zfbgKLYFkZZN/dtPsJGwSV+h5z2UhidcPL4GnlGFp/DY+AYa6SJ44kZB+FGpzoJJVoccliOrZWzTOp5TWC/buwt8s7KuKtoRgLct2PalrKEyJNJAE7EbHJS6nfz+AwG/VxYTcMN9YCA4neqr41Xl5DK/qJI/7/RCz9Z1htqWFUBuJIVjmFQ41OVWwuM/eH6L8RPACJ5eV4nO7xLS+yjUo7xrV3hLGVg2pnJcx9xwbavsx6BFpDfzLB7hRYTBy7R+ftrJepapjz9B+BbpExx6q/IYIgOUweWVI+iXM0BJn/YnZ5YteQLz/02qb2hf5DzyCr2UJIarXWNwPQy+cW+xbUYmVZKbhY7mD7B1b22S8S9Aqjl1IwPe3mTIvRR2IYyHqIuYmlHJlhTcAH0dWdSKcJv7Ma51hNChWVDwKHx1AEe6+FXNN//E7KnjXN65xcCyw/o4Hsfn+HsivXiHPW6cbnAsRL5Kn62GmotJI4nRiho+4O8ZGX15lUxwSWtigyQzHb+swA0l7CC2LC4xCpmSLdPVFK+iJVZbUxxJELXvTzhmaK/5cOS0+hQPAZlxbiK96YsqfgdOTXTHkvkml7+Xdpkv3Oa/5YC7tvUiiBEIXzP646h9Ja9nRNpg0CwJ9lZLmoFaVYFmP6a11W8MBtge0xfe6vsoTTN8A0SHa8AEl9hvIOUc7o//N1lwGAQRELzCRmlSilP+mQZTHl8CnMRPl0aSyU46s19TkF6ZxPjaLOW7AKpTX4BmB7Ef5XGTMcXc3sg1YdtEjYtOvM4VwvL1pS4Lc4PQVLEeD2AzLR+WOEtRYu24nCFBsYrOwuBFRJ2ZzwR
 w58gOZ/n
 1d3gFKZ+7HAWuapyqHeGMlIJzdUubQXRk64jdhMP+V3Uvjpp/gY+VoX83EVr7EcNv2rBcYeaRzhO3k32A8V4O8vv5tmFy47qaVh6svTZSfqttcgYZsXrwPoSCQLm8nuOAs1vQdxQJebZt1NRYw1ffike+lwZTJlaBqpRG3bXcyys7qv0sN8OsboRszCYu6CHA4oNUYTmnIcNxskQubbtUzu7QnCJTjwny6qHC3aM+MVgpz9f/DHkW2CM/Q7TjFNKkPtFNKhlEv0Wa3mZEF6BJ0/BFKPRu7AYj/avPy0zU9XTiDXx7V49LS9ebuhKR9V9M5nNyzrmn0RdmvYpPrPyPsdbz6SK/DNJfOF9Vw7pm1YVLwE4=
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
index 7c4652dd517a..9cde74320e48 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1090,6 +1090,8 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_unref_page_hwpoison(const struct page *page);
+
 /*
  * Check if a page is currently marked HWPoisoned.  This check is best
  * effort only and inherently racy: there is no way to synchronize with
@@ -1104,7 +1106,7 @@ static inline bool is_page_hwpoison(const struct page *page)
 		return true;
 	folio = page_folio(page);
 	if (folio_test_huge_poison(folio))
-		return true;
+		return hugetlb_unref_page_hwpoison(page);
 	/* In case we raced with hugetlb transferring flags */
 	return PageHWPoison(page);
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5076ee5d4788..73ebbc935661 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1817,17 +1817,12 @@ struct raw_hwp_page {
 	struct page *page;
 };
 
-/*
- * Check if a given @page in a hugetlb folio is HWPOISON.
- */
-bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
+static bool precise_page_poisoned(const struct folio *folio,
+		const struct page *page)
 {
 	const struct llist_head *list = &folio->hugetlb_hwpoison;
 	const struct raw_hwp_page *p;
 
-	if (!folio_test_has_hwpoisoned(folio))
-		return false;
-
 	/*
 	 * When RawHwpUnreliable is set, kernel lost track of which pages
 	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
@@ -1843,6 +1838,40 @@ bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 	return false;
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
 	struct llist_node *head;
-- 
2.47.3


