Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43759CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A106B008C; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3A56B008A; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7326B0088; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC99B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7688A1C148B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:24 +0000 (UTC)
X-FDA: 84857978688.25.444DFF4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 525901C000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LKy54eoQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f381bunMVrNL/C5c9XWgPM0aHnXBUcQ0fqjfggVLbzc=;
	b=g/LR1X9Z7Ba/IHORLUHE5uzmGK6Vsmqyqase+imcMXuwLR6aZNcNufMjNEFriSBIWmwpGe
	fMuPB82NLW5+HLQDx3tzaaVLBOZYNe1001WNrssSTU81AAKGXxY7B84RN3qaYZri8rLLpk
	h+bd5zdQu0zSELTO9koT3pMmKOjl3nk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LKy54eoQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952783;
	b=M4EE/WY+vaLgWtQpNaslGbACBw9sbklIIid+SkgI6vnTTSludXsRVMM1WaPZ4T7lUENAh8
	b7NARzDY/LRAmbtY1PO1/9xKhc2JS3u14metgQ7NNxZnvkYWuAyXpsoCzxfO9UbpNSoYKc
	meMEICpSDJWyKlWKQQKDIvKhZZYXRsA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=f381bunMVrNL/C5c9XWgPM0aHnXBUcQ0fqjfggVLbzc=; b=LKy54eoQxdcNjWIjMYELZKf8wY
	aUPM7LLesS5MzlJJuXuELR5XdSssdP1suhJ4G+ZNEEb8GA+qeGi0R4i2y2btjUc6sJYVDFrXl/SKF
	De+VDros5JsddJIqspWx+7DBzwyzNkp9Yd/DfiHFxQ83lTvYjpptUxG6KOFmfF8d9QNHjg+Hgxbf8
	tHyUzY8xjMEbKiOwHHN8QCaxMtFabgmcrogT7O5Fajr2xjMYdJ47ycuIHLpqiyCb0t0rJC9Eghxt3
	b409+r6uYHXPXsBrmpMat0Q+JrlEJPIApTtflvhFbqTkWXO11CtGajsl4pliaLRmWcoSU1MU6iZ7A
	qUBKOeMw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAq-0000000EQBC-1nks;
	Mon, 08 Jun 2026 21:06:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
Date: Mon,  8 Jun 2026 22:06:12 +0100
Message-ID: <20260608210618.3437216-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 525901C000E
X-Stat-Signature: pkr7k7eiz137hyoshyomu4mjt54q5a63
X-Rspam-User: 
X-HE-Tag: 1780952782-957649
X-HE-Meta: U2FsdGVkX1+pZJlZ62iOKPEAi18gscEWLpbiK2decS9qbcTY7vchyshLJ1kJBb42CEPAjavw3I4hz2Jt9y2xF/2Xpdlj6zz5uPjqjoYjETTSs0TLdtpdZkw6gpt/dzk+qyXKTVMaDEyLsdodfOJDJp0gea0CuVKVvrfI6GCc9DnfYBcCO+j3cKKYivyOLGPvWkGRgaPDXp5TIpM9pKeI4QQIhntkUdPb8qZyRK2/EEkXAtD7kjpXYM1Ag2NA+pFhM2TP/GXO0nF6udK4Vz+zwgF6jLH4/fKnWds/V7sIPF4jrVklgx4acZlN8G9yc9deECerqrkLnbcwaGfX4VHOvQ615jsaX0kIDRHJM4Vcc4KhrQ01BYbZ7hQQkwY+Q/obbn5/h+CS7vvXW5P/7wgH3r9fWZy7o4sRCUEs81HC3OR2UCrdQMLfXVC3MFZgphCHUWsCyOqf4qlwoEVV8mg7evAz5vJjVhOorb/qkWy5Rnv77tCUqo4g2KMJrc369HlgSjIyOYPHvg0W2Du5mvPlw4WbQUoveRCYPuJ1Njp+TEyGGl3rEV2ekDpm09YKERWh3IGh3AGV8LOvi3yQ1N9pkNXOOR2ADlw+3WL+JcNUO4hYeV0fv+cf2cKQJruQ5ESmk5LqHH8vFd5uTXiABIosYjmTeLgXPKIZ6xnP5ZGQUaC8v9pmXiPtazW3qr2zcdGYhFjRnVieEZe1xE8vZNZTEXFAObcOKrbof5lBEFIgRR9MntoNRED/Teu9r41FSvusAal43NJMBTnLKdYILMlN9CmiUSrPlHAfZ0oHrdbPw0XuojaNP+sYPW6o2Za2l3zkig2zrzuuQZ7yHT/B3Ul56HSbDn6iImrDaIpwP3g373OIbm1WKOpBMR5FpB2prAEDarvNGrUJFHD7lYQiun1EfvO9BzCGW5Mdz00WrG3stjL3IJGr7uHKoHFOrdBn33zeqkvOuwczE1F48Bc5AKQ
 YoXC5+LD
 kFjpUOrcIiCgj/svDK1hGOngwxo2fl2BwIq+b0yz8ipXv05MQZZqZanMBPie7GFOwkPeaFD0uYgdCL/bPok/bcJ1cNJB/LcI2O0/ezn0KUFlPEFgAtRjvdVEUd7QhnOHhzV2sb9i270T5zF7GV77dJ/lmlnnm/DXLUDHkoGYnmuRsZoqUYRWF5Hurtk6GV2nrI3kpjcuy6SZUDayB37QInZtiXcNe32nudGZ47B5izcYO6qgKWc3bLpH5/C4DYx9jrD9juVl4Ehtne3pTxBUmQdxAiwGZXIGmNVrfuDMAvFj1DC0uY1gKANcDPDQ1VvyntGxs3y7mgFlj+Rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is supposed to use page->__folio_index.  Use page_offset()
instead, and simplify by working exclusively in loff_t instead of mixing
up loff_t and pgoff_t.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ntfs/compress.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index c904858dff3d..b279f38636d6 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -105,13 +105,14 @@ void free_compression_buffers(void)
 static inline void handle_bounds_compressed_page(struct page *page,
 		const loff_t i_size, const s64 initialized_size)
 {
-	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
-			(initialized_size < i_size)) {
+	loff_t pos = page_offset(page);
+
+	if ((pos >= initialized_size) && (initialized_size < i_size)) {
 		u8 *kp = page_address(page);
 		unsigned int kp_ofs;
 
 		ntfs_debug("Zeroing page region outside initialized size.");
-		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
+		if (pos >= initialized_size) {
 			clear_page(kp);
 			return;
 		}
-- 
2.47.3


