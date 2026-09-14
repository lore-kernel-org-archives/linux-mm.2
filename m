Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DF1C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 04:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A05D6B008C; Mon, 14 Sep 2026 00:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E016B0092; Mon, 14 Sep 2026 00:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EE46B0093; Mon, 14 Sep 2026 00:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8E36B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:18:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4B6F120753
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:18:42 +0000 (UTC)
X-FDA: 85211061684.11.22D8F04
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 57A5C80002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:18:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kc2A+7jd;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789359521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4chEaOjoN9yQ/BXFRXOnQ16jio7Vi+Ozuc940HohS+k=;
	b=3cscs9/RKDkrn5B5kGf9Az/+xG7XwL6YiRb/e/5V1k2hzaXIVXah4yTEBGludLrbBLfPRU
	GbNlqWh9E8wg0Q3MJW8KxKR/a9n78/K3Z6u5LDM8eguaTQS1gVDLNxetHAMDQV/3wzKX84
	Kx5euH00LJOS93mr1Ix3uRbx2+5iEl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789359521;
	b=ANRKlUTQW1sJ17iJShYRmR+t6CsdCb6eyMDC3/lSDchvM3WgFulD0wosRrcPzSoEI/seWk
	3sKs6KfuDqi71pU+RFJez3bq1YtBCF6ttci+XJ+2ZDDBLnS8PKOtJJEo/yBMWD4MlICbS1
	YI3Qt1Xg8R+JwqwTbh8prI3BxNoNnxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kc2A+7jd;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4chEaOjoN9yQ/BXFRXOnQ16jio7Vi+Ozuc940HohS+k=; b=kc2A+7jdgBYQ1W/+6/flgqBCoD
	boPvxRb0PO3nwGj1LTv032o0ViM9luEtc1kJbI2szQPu3UHFobumKtWfo7nSt7fnNhbQT+aMkPLDN
	wQMaqIFmNc62vR2HeEkkBBZBwQus7uGr9gpiym8Jj6nqMzf0GVwxvAMsAmf/0+Dgrv+WoG0OpvDeS
	ZqgQvg+9Jf+sB2b+oMOB9qulEediMAl7UTq/xljTLDDr7GEOdwXSQnAmVqwPNPdE1l8VTxj4to28/
	ccKWIFfzd4i24/8cDsyG3DYFb4ABERugHlaHC8cDIIY4IJWDD8np+A1zptgMNAFep1qwKcIX5iOac
	z/cGNcUg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5y9K-00000008hHX-2bM1;
	Mon, 14 Sep 2026 04:18:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] md: Remove the last use of page_buffers()
Date: Mon, 14 Sep 2026 05:18:10 +0100
Message-ID: <20260914041830.2072626-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57A5C80002
X-Stat-Signature: g6d9xxkmyjhjei89p6epbg5h84ji1qw3
X-Rspam-User: 
X-HE-Tag: 1789359520-412741
X-HE-Meta: U2FsdGVkX1/BLX2jHCaBdnfkL0ml4CCY/5XV2k/bloYrW85m3eRniYw0CY04IlIIfnTgtnH5mC7O17hc4uW8/baeQI9r1kelAZy6MK4giEitLp7SRioul2FOawMaeCzKe/+zQQUi3MA194e6zRKzq8CYNVF6HW2QN6Z6UkSmg7SwaqVcLWC92ZKqU4k1cyfMWfjUSpKEi/dc/wd63v62mmg7rsuyBd+HUb8GwLJRQValJwNQ3PtBU/7mHgEQi3imJb6+Www9jbjxHFojVbtCVgPKxAnye7h2fIoa1nItDA47f/T0x32qldeFg8Q7N3a5IF3BP6vCTyU8WuBKWyuHsAFJb97B+LGqK5dlF7yDo5MfYoskwoeFvD0BLlStV7L/RsrmiU4aWxmqKUY4XBMy8px8fqulQYlrZxT6Jp+2hVUe32xGGcXlTbP2n0p1IpQFKsLDrNXVh9c1hppNvcn2WFIvDAD6P0UTx4t+kJJM52Qhu4qSmBXHruGVHj30DObxiBEbBPNE9JtwZsryvlXxcpyrJgVO9OfuznTY419Cjl5Zs8lB9ju0GDij4gwXMvsvt/AHq1Ztzzjk/d7kcV0VHh7/M6bJbvcRUcwDgJrCikswI0ZQiAAkdk09RtNGFJyJTCRXroxOK4Txy7gjbN2go3vu31ZGBoj7hc8xwPBXtM4PWBwDP58tPE7oBPF72JrMa7aOYriRJrBZP4zt7O7hgLtYFDndLK6nE8+Y2nQCxyfRn6B/Voqw2r3Wy0oNK05EXfUDNs2cgN/Vi0kbnSiwDmjnYqCAKCWqYJIq4Ee66tWpWBM6DuPyh8wh3a6vvp/d4rvLMc4o08+14NMpKigGC4a2YaEZDTXkueUNGpWCzjV8HYvqEszMypiXjVoVmF1h5QedwPotvJDsjOqDzHgnAbUDnvLfu1I9sgfhDv2oTLmHYOS1mHkyIEMxza0GVdYiM9rOjZMlfnuC01UKo73
 iQn89H3s
 omVOUyKja0DeR2CEK+0ocQT6IAJJJ/OU2ys919ZlLLSxyzOWsyy5uG4KEndMbPmyptkM4vpfTMvO++lLE0mI+bfnP1n/vNE0rFp5cmkG86mhrje2uoNQGyDHBtNPgBY74J4UR2u7njZNqjj1GthQC7jFbMnoAHw+UpoYcZw5gpyda9A2M1uY63MQyg3q43vhtevqQ0UeLl8fIaWNnoWWcx08jrC6OEa75acXZpQ2GkUNBGFmN62ABM08VmFGQibLdqkftCEHG4iSh1ImtOwcUjXXZl7UqSLwORfQmvdKQ1Sxre+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the page to a folio and use folio_buffers() instead.  This
does introduce one extra call to compound_head(), but will simplify a
later conversion of md-bitmap to use folios instead of pages.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/md-bitmap.c      | 3 ++-
 include/linux/buffer_head.h | 7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7b42db87d536..c2528220c406 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,8 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_buffers(folio);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c9918176adaa..1d5eb6ba4576 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,7 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
+/* If we *know* folio->private refers to buffer_heads */
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,
-- 
2.47.3


