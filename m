Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E7ACD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 20:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC156B008C; Tue, 26 May 2026 16:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46276B0092; Tue, 26 May 2026 16:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D351A6B0093; Tue, 26 May 2026 16:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE4236B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:00:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26B6BA048D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:00:37 +0000 (UTC)
X-FDA: 84810638514.10.71A0070
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 896AF4001A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:00:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="I/TvkTAk";
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779825635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4KVsNZKCeApUdbKhZR/AgOn6THu7j6lteiPUEwq08/8=;
	b=nD2jgeLU7bsR0f5Iyvg+1tsHBKjCkB16FNM/QN21YTPBSxzROzdhUaqwcU/GAAZQbg7rvb
	4FB5Jze9vfvxa5HY1TZ9SuPl7E8NoWFywffmxEUp6gSIwrBIBca8TOxRsk+O/W/ngnpdnk
	4TpTOhN9cgzaiILdQ6/TDX1/um8XdQo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="I/TvkTAk";
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779825635; a=rsa-sha256;
	cv=none;
	b=INHJRtxGCOpIGWvN7hH+Njh3Xj9922WSeRFut3oYC8usP0b2hbpdYg/uWo6B474AJ9x0zS
	IQYs7x7t7Q3kqm0ptYjGxVFJPnEVppZ6I1pkpmZ07Cp/DMS6ukneNUc4ZbVBpkUPrsI8Du
	PF+kai1sj3jWJz3AHq+DHyGZS9SYwz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4KVsNZKCeApUdbKhZR/AgOn6THu7j6lteiPUEwq08/8=; b=I/TvkTAkMzMRADusDDDiQdpQMh
	epUhH9455EA+mQmdK5hi1lnMSOOPvzhLXrFuU0reXDOJYHaCdDp1VoQa1pYx0rYaq/frUQLb9cSdF
	06s4ckkpn2nlE7gP1KmBTM6k5iVbvKfamDQRRS3uCVhT2jUVAf/qX3nl62nJLoGuCeGeVHqMnU6wz
	Q1L+BuwQ9Sn53y9/VNHaD0OaiO4eYI46ljgurfZNgsI2gKmnDzqxjqH1rCTB6c4sbdmtGzVfS0dbo
	9fgrCiavnhtS+XOlHC0jfOpEiGkNg81ZlISVQ78AozkYpso/3wrC6IcsJs3HNkltrQxo+0dV7C9Tv
	z5rNMNdg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRxx3-00000001U3h-301H;
	Tue, 26 May 2026 20:00:33 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH] mm: Document the folio refcount a little better
Date: Tue, 26 May 2026 21:00:30 +0100
Message-ID: <20260526200032.353868-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 896AF4001A
X-Stat-Signature: akbebz7fybwgargopy866ua7gnb5fear
X-HE-Tag: 1779825635-690506
X-HE-Meta: U2FsdGVkX19sBTstxugSoIDXNZfm0n2WpeXW2lkPuWWZWZ2l7Bm+KFiBcouZqUACQuSAWCCyT3m8+wt6jQVunjlHJiXNsu7NzXQlooAdqzFW5rx9kcovJz0cmMiUDG9Ji6pEywR6E0F4eUZc8zko7+tfp9hPX0dXJrNDhMa9E8IG9HOSfHh9hsAuBl2RWBQya/kHb4xGIBRf2QcW1/dsQH/5unjZr4IkP5nZhTdFXkTAfNqoM8rnsYDCbD4gC/rhT36eyFiITgAGL8Sv8CAb4c9rhZPvDOq1AkDeiuWsUw/cIy5B5TasCuK5QbgxaZ8pWksEQdpX0Jhw3/j3VeW+64OmKK2rwLVD+T1rOrz8CCuchQ23VmR2gScdoffWVbomyhl+yRKm844n/mfzC/8pM5zY39d7O4PAgBFRiH5Cyxk760rOYcWlBqwr0djj+pTQid4TjyU9MYwN/mQ53+XxbkZra/NQU2uYFjTRe5WAMHnMEDOnuobmsKo149YEvVuHZtZNmU7qZ9z05v81U4gT5ihKxACHTiar73IvYmrbsIX6qB4ML3COTp1mVbg57blnV8TAmbslKIB4Kk8qBtP9h3JjGdqTM5YmLm59Zz9ShIivt6K67KWCHtBwBnJzJKUYfPmZq/0qnX0DtqRQzhoPXe0NWHCOFQHUN4qw3RujiPd9wv3zSmz03hvZDSDRQlVWKHHsdLq/r5lr746Zrptd7lZhQawzsAkLbuBvVm7RNPRK3nzH4EBQnHsKyMYMzWia3QmcgLVuWXFKKHs1z45LM+nDODGEGVuoO9vGmv29MYbNpINDkLytlCe0TxE7KjUIZY1w5PNbjqvyrrMHoMzwFSKESOYu24gl8DmwsxxLoo6RNTEU73b/Tv3iWmLTFU5zfqRdAjVXOM0HhpuqaDkpg9HsKrWP79rG2T+Yhc0nv3DRt2zqsI9Q4r3pXY37RTUnF043qtVn629JRM0wBRm
 mBd+I5xJ
 M+PKaZi5tOa+SKc9TM4Fklh02s8MCY8n46a3E6fk0F68IrxlbHrCvhLISChgstCH8dPW0cFXh4Rzp34uPklZsjNV8xrWUtnxbw76nkn3TKvHnXqUKeoab1Jq83hxT6UblH9HiZuVvkwOTo/du+FHcjqmHYJd99OET2F/1n/oUNfNyc7vRFvxqse0IAFglzL5cNgHI8qs09R04W23jQg1gSzE3MMk/QKyI2u4HeUtQ/62Hs5mauKkje/w/zal5DnGhN2lO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expand the documentation of folio_ref_count() to talk about expected,
temporary and spurious refcounts as well as the concept of freezing.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page_ref.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 94d3f0e71c06..9f5c75d06f76 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -71,6 +71,12 @@ static inline int page_ref_count(const struct page *page)
  * folio_ref_count - The reference count on this folio.
  * @folio: The folio.
  *
+ * Folios contain a reference count.  When that reference count reaches
+ * zero, the folio is referred to as frozen.  At this point, it will
+ * usually be returned to the memory allocator, but some parts of the
+ * kernel freeze folios in order to perform unusual operations on them
+ * such as splitting or migration.
+ *
  * The refcount is usually incremented by calls to folio_get() and
  * decremented by calls to folio_put().  Some typical users of the
  * folio refcount:
@@ -82,6 +88,18 @@ static inline int page_ref_count(const struct page *page)
  * - Pipes
  * - Direct IO which references this page in the process address space
  *
+ * The reference count has three components: expected, temporary and
+ * spurious.  The expected reference count of a folio is that which
+ * we would logically expect it to be from just reading the code.
+ * Temporary refcounts are gained by threads which need a temporary
+ * reference to make sure the folio isn't reallocated while they use it.
+ * Spurious refcounts are gained by threads which, thanks to RCU walks
+ * of the page tables or file cache, find a stale pointer to a folio.
+ * These threads will drop the refcount after discoveering the pointer
+ * is stale, but it can surprise other users to see the spurious refcount
+ * on a freshly allocated folio (eg they may see a refcount of 2 instead
+ * of 1).
+ *
  * Return: The number of references to this folio.
  */
 static inline int folio_ref_count(const struct folio *folio)
-- 
2.47.3


