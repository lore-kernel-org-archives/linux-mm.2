Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C0C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01E96B00B8; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82F06B00B6; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD696B00B8; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 552F26B00B6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E3DEB5EDA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:13 +0000 (UTC)
X-FDA: 83743374666.16.92F7942
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9DA8214000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lo99li22
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754414592; a=rsa-sha256;
	cv=none;
	b=EDV3qeGvlY4QQi5tEddgfSwe91Gi2sYpcSSh+u0Xugdf7TY2Sw5+G8gtEQxJzy7KgUGSfj
	FBFHqcmY8p/LEgJx0WkZLonxdlEFWUAfIffzvaRV3G8pzQ2Tdvj6OOU9jBpbLTVa1vGELh
	QMVCXMqKj7/b9ZWb/GdFZQ4IZRUIoos=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lo99li22;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754414592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+E9YAAS7qngKpHB/Xnm+VfPL3PFOWJ/EZKXs+l6zAT0=;
	b=UinWgPOfN1bDbC6tPXJaVAVwHZYDsbxD+QdT9OB7QJNifrOe/u2W+H8/Zsi9YF+nUPxOCx
	yYUMP8WaejYLNERyhaG4iDkX733DaDQX3TO1nNej/41pKyGDFX2a0m5xY6CysM+ho/pCQC
	uxFqKsLGigVqxOIx05QRe1gPXFTF9RA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=+E9YAAS7qngKpHB/Xnm+VfPL3PFOWJ/EZKXs+l6zAT0=; b=Lo99li228pjLRmgAG6s/u6cXzS
	Uxr9kaaKyWAgYdDoKvscNjO5zv4hEtbzOmVAsnYf8Tkji4T8cdR0fWK6P6HXOSCsHB7lIbQfurKog
	kYhLh9qsnCHtSAhIx8gjwk7GjZk+/YNtz/dttG52LSsaRJiEgYjUspQkPrj2JAQfgDi+RWNJzVx8E
	Pv32KLJC999Y2Fk51/QPCkdNVMu5i467h1Oqvlnhlsng3uMEHKchx9ptpa10obseSk04D4Ac2Aign
	IdjMqv+CtlK4Wy+H3jgfDNJTiR0agW5CU/eAlnsWqOqb1+hzfaDDhBnd1pxkgq9K985eL24Xgv5Qu
	dY749Mkw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T5X-18Hg;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 07/11] mm: Introduce memdesc_is_zone_device()
Date: Tue,  5 Aug 2025 18:22:57 +0100
Message-ID: <20250805172307.1302730-8-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c8bgpd5shqfi9u1q1b5jarm6wz6k7amk
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DA8214000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754414591-994287
X-HE-Meta: U2FsdGVkX1871X5Zqdj+YpMDpNbJ6GCLUCp3eW+a3tD70jZc2mdLAgmtv+Jq3+HwSsDCSjUS79LigDKSWiY6tbTTpmpq8t7568aQqEGMCQuXjenE5x51pRfq/CxMyNlhnY47RM7dc50gQZyU6MVZPOgjFxDBUYFbBOwEq/KViVJy6TFZcg81v/eZwFqiUF8PizSUo4YN8PRoVE9fFdt/+4xZ7szxCL0LjOYGa72nwR81ugayAOwQ/oOGzvxjhT+b0jPgJwQ7GOlzhIZZMrFSPtlZPlU/BJecmEz+a4zh31auJr4/ZiHzvqRxIXCH9LZ9YO1xFUMV/NYMnNTdfAH/fIurSrN/8XJmH9eKrHZvTbLNE7o4Ayl8lVpbKMYCMdrIo9wMvTAbyEGmL1hd8QI4h9jtif3VkBQyUWU68ZiVCxBdU5LCG83bIwzskE9/omnC09BUKOom9v2d4C2nu/KWgB8uHeAkagUWYh6U1xbrr6/pUtEfYOhmtqxh0CXeKtPxYc0b4AhoHTv6RaEXnuiXe1qy7rXJ3Qi9hHkvXEa1qYUe8hxWOMvuttrkhlMXSfQJzmAhgwIJGCTJ3OJwEjo2qiF5zYIptNW84UDpBmh/556ctLJPPmNx+I1W2j0CwEJMN1MSI+3raMKQxSZExIUPAVEVP2WZ8AEadkUGuo9I0HkyWj7co8dWFfGcGnuX5l3FiTgeSIC4jmDNXQ9+b4pTVJNfJrVOPNoyuxOKmxjkpOkK5EE9Tu3PZki8LEcl4Y35E3YkiBMUY0Zg5CJMf1DGuWhbYBWiv0RjwxQhXMw2MSar3PG6C5o95P7wS9/q78EA8xTCMYBRFYgo/6lHZN3+CkHqyYd5VwRZmBniA9mVfmH+wpELEuP3Ux9yTzxkgTPaPHYN2WUsP3mnPSxhWJPD3qOk+Po6JMovPDB67A5hIbKy5bmrmsSlag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the conversion from folio to page in folio_is_zone_device()
by introducing memdesc_is_zone_device() which takes a memdesc_flags_t
from either a page or a folio.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mmzone.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 001a696756df..0210f7eea825 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1186,14 +1186,14 @@ static inline enum zone_type folio_zonenum(const struct folio *folio)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool is_zone_device_page(const struct page *page)
+static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
 {
-	return page_zonenum(page) == ZONE_DEVICE;
+	return memdesc_zonenum(mdf) == ZONE_DEVICE;
 }
 
 static inline struct dev_pagemap *page_pgmap(const struct page *page)
 {
-	VM_WARN_ON_ONCE_PAGE(!is_zone_device_page(page), page);
+	VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(page->flags), page);
 	return page_folio(page)->pgmap;
 }
 
@@ -1208,9 +1208,9 @@ static inline struct dev_pagemap *page_pgmap(const struct page *page)
 static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 						     const struct page *b)
 {
-	if (is_zone_device_page(a) != is_zone_device_page(b))
+	if (memdesc_is_zone_device(a->flags) != memdesc_is_zone_device(b->flags))
 		return false;
-	if (!is_zone_device_page(a))
+	if (!memdesc_is_zone_device(a->flags))
 		return true;
 	return page_pgmap(a) == page_pgmap(b);
 }
@@ -1218,7 +1218,7 @@ static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 extern void memmap_init_zone_device(struct zone *, unsigned long,
 				    unsigned long, struct dev_pagemap *);
 #else
-static inline bool is_zone_device_page(const struct page *page)
+static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
 {
 	return false;
 }
@@ -1233,9 +1233,14 @@ static inline struct dev_pagemap *page_pgmap(const struct page *page)
 }
 #endif
 
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return memdesc_is_zone_device(page->flags);
+}
+
 static inline bool folio_is_zone_device(const struct folio *folio)
 {
-	return is_zone_device_page(&folio->page);
+	return memdesc_is_zone_device(folio->flags);
 }
 
 static inline bool is_zone_movable_page(const struct page *page)
-- 
2.47.2


