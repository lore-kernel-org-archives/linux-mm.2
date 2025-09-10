Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B87CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFA68E001C; Wed, 10 Sep 2025 10:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78638E0003; Wed, 10 Sep 2025 10:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67988E001C; Wed, 10 Sep 2025 10:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A4BD98E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:29:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7341F1408F0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:36 +0000 (UTC)
X-FDA: 83873573952.19.542C9C4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id CAC0910000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sogD4AKg
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8JvJveXqLeq8nJSEHvm9/6DzJ/O8gR4CJoZeVTn2M4=;
	b=gbkN4Y/VeLjKcH+Y8Mah4INbAczE+iRV95EIZ/7vn/9PKO8vfKNA2Xxj+40vKvWhSbGTmu
	+IgVw65WsRIZCrantwykRElRzrPG/o2fY7jXGdKz77f9wX0aeqo2vknp/IL3OtDC0NRbnu
	35CDDaC0tx6jjZ6iorUHSzUghiYlGn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514574; a=rsa-sha256;
	cv=none;
	b=uE7dOuoMz7nwwZ8ja63q2Sfg3cbiYakTd6QQmrp/sqrdLV/kcFXkh8UpnfmCSPoyudpnsr
	DHLcwozyFbUHOkuq8BWbIVsdaWFtY9UnSltIQl0GwS/dY3TEsZgpLhNA1g7GPW/aroO5iJ
	x9Qktlr+W/uAPtXf2EAJ70b7jDUXE2U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sogD4AKg;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=L8JvJveXqLeq8nJSEHvm9/6DzJ/O8gR4CJoZeVTn2M4=; b=sogD4AKgmrrQMnrOOeupYwn9R1
	KCuHqcIWPbDMuzGXs1iGtY0/G4GdZsNrpRtorkDaGB144T4fBSBOfYwQIozmUqY4zkiNlvoh/efoB
	xS3t1R8YkdKlcnHICvDY41CS/ICmk5zw0VLGQ4TemxxYXdwkzawMPX3Wb8S37emzttJ/VfGe4CvHt
	Ff7Q3W3aic1AtMau2n/T7D41OT7kHx8YwqxC5g5DHZD2+3rh0RJw2Y6Hs+xzdlw7AdZ8/LZU5UhY/
	QWH9qhf2M3AmJQPLKYk/P9aBsABVKarSvqqJa1LhRpwKeB5I9QVL2Hx/re8+uArnVqMWgCJQOJKI8
	uegbk3iQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwLp6-0000000ALQM-1DUg;
	Wed, 10 Sep 2025 14:29:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 1/3] mm: Constify compound_order() and page_size()
Date: Wed, 10 Sep 2025 15:29:17 +0100
Message-ID: <20250910142923.2465470-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910142923.2465470-1-willy@infradead.org>
References: <20250910142923.2465470-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9t78mhspwutoi113swexem1yqgsr1d64
X-Rspam-User: 
X-Rspamd-Queue-Id: CAC0910000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1757514574-583086
X-HE-Meta: U2FsdGVkX18PNoXhIbaurB9bF7Ad+hTD1WRVDw3MWRYfgF4XGMZRZLIuOB4t024ePhDQMs/KX/dAyuXQpBfCWkM7culgtE9NZK+CAK8MK71zQ3UqKfLDBit0zRCmP/5FqS9fzcMYBp0dUC45zml3V/E4ugNiHQVM8/VKgOLek8pcrPSBPJumRBrrA0mSreZkY4yiI7S+uTtH8EhTUBXhlnMjLOyzSm1HTve+cRjEaSRWQ3hMHyfp29yvp8TTpfoWbzNE4w6cPqMlj1FpCOZ5awGnuw4+8Y0iqyG00JoDKs9yON8kQPLTGarP213qIQukPiuQMxPjF1BO7i1IZlSFWh9ChSY+U0v23/+eLYbn9eY6WSMLjRorkHKt28rwugzafP1SyWbrbjDK/yMzjXlNJ0iTkfaOGD2+xh3Gz6a6+g+nIOLPk5b3kDQGhmh5DtJCssQlhPqkT8MdmwlUm91aQf+8d4iXDIwZ6N+YocpZqSNDJx3YSLthsLDtcCmnrPk0X6r+JRDr3iGC19pI+6PP4K4WzhWGBoaJlAL6TlAtZcTW0c5vYv0kT/YTFKz8gExNywzCDisdqBv0vJsl5VjLQjvkNp8NWEtM/BT8CbP9uJYwkfLbPUNtPP9BivnkMRf6dSkNL945eZ5qXa0PI/qksMG4aHJWzVlrV6cbq70Azhxjju+mvL6kINrM4xStbjZFPsbWqSPr/ujokdMyB8mA7Y6CVFyAVtZMopJ+jd7BHOCT8o/kX7cJFjaVokke6bSR+oVeSgDpAwp/vPEPh+3qLWzQOoCWJ4U55v55x68UTEQy5oVVFX9CdtSS/zXyRNviSFZZ0/QNVOUi72QMZuUdE6b4BbiH3u0uCWvh9mWaM+sVEzXC6R1XUMzKsNKL69jD9je5QJuOI0ChBZMUGtJZpdJ/J/KTH7Kyad4M/D4fN11n0NETqbUbvPiKyxQMHVFC1UekgCgYQoB2jakcEoQ
 MAOLL2j9
 tMAXjzpwPxQMPMtuaKq5rV10WKmNUkTc8GQ9/QqGXAfBMVtefXD7WfpWngYHgqda/6nG9xW2RbUDXwWwv5ScCRb02SRSLjdt62M7iRdNbEHCgC97oP2IhE3uAY3RvK0swOMkZu3ZQLf4HvE0MRkCbsYOKbL1Ic4nVtV0i9J9SOyVPuAAHAhzYi4cO65kSEkUb94ihFQPTAxU0tsB9LX52HcdXZyy4hxEfddiut86dzMPbL6B/cmTAmBRFjD5tH+CIE5zSDgIEUNlql2Su5zhrs1DRa33AkXxWaKG802VWrEajMqM4HE1SmtM3vA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions do not modify their arguments.  Telling the compiler
this may improve code generation, and allows us to pass const arguments
from other functions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 892fe5dbf9de..5ba30a8c6c6d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1036,9 +1036,9 @@ static inline long folio_large_nr_pages(const struct folio *folio)
  * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
-static inline unsigned int compound_order(struct page *page)
+static inline unsigned int compound_order(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 0;
@@ -1257,7 +1257,7 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
 unsigned long nr_free_buffer_pages(void);
 
 /* Returns the number of bytes in this potentially compound page. */
-static inline unsigned long page_size(struct page *page)
+static inline unsigned long page_size(const struct page *page)
 {
 	return PAGE_SIZE << compound_order(page);
 }
-- 
2.47.2


