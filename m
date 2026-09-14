Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319F8C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 04:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D1C6B0092; Mon, 14 Sep 2026 00:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117746B0093; Mon, 14 Sep 2026 00:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23ED6B0095; Mon, 14 Sep 2026 00:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3C906B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:18:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F31F1C2B78
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:18:45 +0000 (UTC)
X-FDA: 85211061810.16.4F46E3D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C2D9180007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:18:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v2bylMmI;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789359523;
	b=pQtbof3lfabusdT9ZuhwVri2w/bXDjd1gNrbefWl2EoAe0VRmNkSzzYZ5Syhd9kqwea4dD
	qz9KfqqFBqyiPrM3/1KceGaKMavdKCmLHIHKU08q56hGsBYaD1JuLepZEZTFqwlhGYeKES
	690G3O4WgoEfKF8i0+UdYb8FsRq7Uic=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v2bylMmI;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789359523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOiZiTTcnOGDiQNW6U8572Zud0tx8Q1ZcO5S5HNlCAo=;
	b=1RI1k48f0LTFGzRpWMGtd2jx1e5rvL/mejW5kO8jv7HWDjBrpMPTRu+7WcCP1ryXRtd7LW
	DL+ZxAhzDpb7I3htLOGVtO76NkFbxqIXiNzVprqvLaLxDiHS3Z9ZWKgSrI+tjJUby9QpKf
	VtBcR5S20zs/XyLC7+IAhHdYhGio7lE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HOiZiTTcnOGDiQNW6U8572Zud0tx8Q1ZcO5S5HNlCAo=; b=v2bylMmILt3EvBjj6MUA9IPF+K
	rDN/3MxBs4Akwii0ZCS5VDYTTgvAiu4KSvdAqErQoMAz+Cfz3+Sgpsn93up2dXEDkH61BOU9oOFZr
	6MdDqhsWD9VSXJ1vGG+UHCWROHwJdGmLsWW6+e2b1ccAtsVuHSXsyXfTYwyO3fbtTTaUDIjVm0YHE
	D7h3pjglRTpo998zzlJeY7W2/y2DT4osN0xzJOfzYerPjh4EhE8IgDeamAdjfvgtn2/fes1WmK5AK
	aYfg1Ms6SK2oQz54LcjDp7ZCYUh3q1uQlE6L/9aVEOgfl1WKlLt6EQe+AQNrNfReUGvd/NW08qcJp
	DltpjGkw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5y9K-00000008hGx-28L0;
	Mon, 14 Sep 2026 04:18:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] md: Use folio APIs in free_page()
Date: Mon, 14 Sep 2026 05:18:09 +0100
Message-ID: <20260914041830.2072626-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C2D9180007
X-Stat-Signature: 1ku6ni8jyiptmz54c4gxaws6fuewb15a
X-HE-Tag: 1789359523-501295
X-HE-Meta: U2FsdGVkX1/csCJThD+hLs5kqXLUp3yqWwHkQFuV0MYlQS5RfxTEAsAj7tiiDk4lSiCfdy2zDysFGsSrJ3Ml/9bXpN9tLJPpTzcc9ppApH+lCDalwb8DqnhReBQvWjsxy8cOyekWXhHZfVSslldbxaZk3wGUOv0PqOUkWrBPzDu2D5Ux61S0iI5xFupzK/FFnCGMSEg2mCs3ah1PyasJTUj3/a/PICyRHtusXcZpCbFgRGCLUT+9N/f56O6u09+dNGbMLWVSqARTq1hJOK+rJrZTVybWDiySwQS8zhaJxfu/TYkdTlPNpW1Et0M+ppbo0hZkWxvVIiv1MmQyuCr8PkFUtO5B5kM/csgYXSKLm8bhpihOhAjfxvoi7+oHCzc3eN40R+bSkPkooRmu8tt8bjts5IBn5CcIRg97Paq/6WIlF7DT8S1Vng7UJReG8EyHXAcxD6zJ6bRYgo7B5HCiSs/pweXq0bIiR14ai9eWWle3wpfIESUtcnlqxODKu3NiaT/6p36IAzWPP3J4/A370j/2eoKpHREsxXOBGmo2JcCVwc+5ExIntCMCi1PB2LbI9pi81mGiQqYaGNSvDBx/7NKlod2lOhCnddqgQWoEpQHZLozCM40sGRzwhLXCJlX46ihF1zMD8o3d4nEqwb1jdf2sOGBvb+r84rP0VAH1jMUNlYBrVeqhes4HFU+yTQLtUlJ8WoMG+lWNn14C9+QcyzgE3QbpaB6IAc46klyTLiS5stmsHOPDVRT3X3CVvW+/ViioomFjOLEct8jTfN2jB7yU9plOix7Nb0UPID5/NFbgb4ViVaPTCnfg2tMhPNgJ3GHAsCmFMHwf5rN70LEqdIufyDYUm3dLNvvWLW9CC4N12WzZBtGPMOe/5QTUKJhIr9BKxRT3QnN7Y2V9C3HAHbCAkMEjhu4/3nDyxVwmjl7ejgBiv1pMZx0QXWic9AymlZCQlIpeDB7Gj2aehjm
 dEnMbbdP
 UAym1mUwb50Ux0Qv3WzaJaA2pw2bzY/0umUQNCovlMbfFuxAzhOlcbVe1TdYicPk56DDrbaiEch4NOrx5IHHFkKKKAOD07O5S99WLvEdwey7M05CW7e5Cvgq+u05KfxVUgHD8L1pmXO+1aQmI3CtqXyP68xlvD/ByftFJJ70Bs/izdSw3Iedj/IV0J6LDWsq71eaoZ0EqXJkZ6Wt1TkZXRaJKAd8siUPP5wKzUAqFZeuQ6c7YxvcDF7TbOENxZgf7hc3wyjXw07IkQU6E7jm7VNaLEHiNzv+PdtIf7nyui6ryQQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the page to a folio.  This removes some of the last uses of a
few page APIs (detach_page_private(), page_buffers()).  Replaces two
calls to compound_head() with one.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/md-bitmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 5f1637f974c1..7b42db87d536 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -533,19 +533,18 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_detach_private(folio);
 
-	if (!PagePrivate(page))
+	if (!bh)
 		return;
 
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
 		bh = next;
 	}
-	detach_page_private(page);
-	put_page(page);
+	folio_put(folio);
 }
 
 /* read a page from a file.
-- 
2.47.3


