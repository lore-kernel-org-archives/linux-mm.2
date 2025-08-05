Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70AEC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6856B00B4; Tue,  5 Aug 2025 13:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686CB6B00B5; Tue,  5 Aug 2025 13:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CF26B00B6; Tue,  5 Aug 2025 13:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6626B00B4
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:23:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA563113CEE
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:13 +0000 (UTC)
X-FDA: 83743374666.13.AAB1337
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id E0A41100003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hu3GlCJY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754414592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LANZOKPApTACtRC/RZNHRi7qBkE5QnPXvtr5q0sT+GM=;
	b=s/ohcfPvM9rAFtD9NdjIsw5vdjlXn44YbLBlY8EwdbttMCNmdcheBeRwcafDOwt4IGWvtD
	qKhfRNiafZ8hBtfCxXMqTT0wJf4XeCQDJC0UOpWhupzvMYvJgPNwR6m9oupi3Hmne3PjIv
	0I5ZGKgm1z45v50Bwr67i4CBX7yykqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754414592; a=rsa-sha256;
	cv=none;
	b=GkVvkZOBOVFH6bl0mqLVBzfPjn+8FVIWpUA3c0Wid82tNGs1JwF+L9DMHveaMVv0dAWzGm
	e9CGznnUgeI2Zg9NlhBlcvwe5UbseQXLZs6NBkAeD5WXMs0G78vDC9pE9zb0jb70J6ywgn
	EMXbDcfGriC5po3xMFPDs8aWmuvrgNg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hu3GlCJY;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=LANZOKPApTACtRC/RZNHRi7qBkE5QnPXvtr5q0sT+GM=; b=hu3GlCJYXXzXtySP2YNCQzsEiK
	dxAB5t1G5hDJXpNd+Cc8/kx3Q01Xm4JSSZKCMJxrrpC8worYVavunF0pa/tCq2UXiHdrevJAwdLtz
	T0Ju7wCEAZ4ql2RIYrgMqwtYj+zYF54BAhZgB4d1qh0lmhhool+xrtPCf/vI0CZ3n3fZWzQOe+bSk
	0nYw8mF0fufbsgmoM+JEA88Rku3x/kMWzGYlcbO0+a1glFe49YKAba+yjMq1JMULQDy6VMdFlkIVx
	hFvNqmxl1tWAFmc57dygeC/owtQCutVF64iD6V4Ofe3RpzhEunJQtpZUq3qGrbV1hTe3prq+BqAj2
	E6t9qPVQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T5w-2IKg;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 09/11] mm: Reimplement folio_is_device_coherent()
Date: Tue,  5 Aug 2025 18:22:59 +0100
Message-ID: <20250805172307.1302730-10-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0A41100003
X-Stat-Signature: botgwbsxhmmuymcfgis4roeum5hi8tem
X-Rspam-User: 
X-HE-Tag: 1754414591-305206
X-HE-Meta: U2FsdGVkX18OiF9ieAaxMrObyzSRbj0e+/+pDNxj2zOSudApVLwm07wz7wsM3J5k6ZWYtWNca3hfHDWFxFGlOPhZdy5DknXVbvo2EjLErR7rYyJmV+mQcAll8howf0ycSdJ0MPXB+Y2YCktsxrn9e9eADzN1BBSv9oBS9oO/2a0Qiu/TazqL9Ge9tEG0+QBx9eXV2UlRI2qAD5xJHAWHCUYsRqjnnK+HAqTFqmr+rYFg46CrZt4sQ1ajjyzWxfv+SQ98ABYjc6gKDHb8tEBK1mc27qRJSGiWKx+AaHG6egrOL4W7EY1H4RYQDf4StkQ5Kg2+HoHKbnH9nt2hAtwstpfuYOyU/zuh5wqZ9CjSWESIllDBx+IwYXfMMkcPK0pr76UTSnTqG2pZXxRXDsG4xxqokvE20pK19g49dEX5uI5Fyqpe5VR/F3ihsfQpIah4Syre/uHKO7ojC/hkvNtWap58/4hBIc0IAzd92+xQ1UXt00Uij0/4MFYIzVQuI3OuJwrc9RVfp+t1kkwkpVr7RYGQxrAHA0ZAPO82J7KvDHzoX/VWFEvcqKp8K7AN53gciiqafYJPGFYT0cCyfAc0kxNj2Vo4IqFfQkPN4fQXqkWWgKR+GY7evTQ8MKQ6n3Rp5cUSVPCpVS/LNNFrdVP1seRy0N0SvsARoLJv2c7/LZf+d1SO244NeLY+CQkg7CDqIb+GkGP6pMYQjMv4AqJw88VT7FTPsPphMiK8HHL09xhIjU2AU3dJEUZI8gR3fZ4FtzqQ3fECJfPuxxgvkGRG9Xno3J7sApbXXpPtlhivwNWneihEfUmutozAyj2WE0W06IBxwE5GMyIIUO2kihiO3mFcz9jNzYnk+L8hkxZ13eNTMQiPN2kJ1amtArw/pBrI6InYsvDT2r21yV3lbsRHhwqtVkDfzKdtlRyRocpFpgLchkuZ9y5FjfvJW1l0VefzGrJVnZQ26iPQtdu0scM
 rmeLeeqC
 kBskDjH6CVnhOscZD4R5FWNE2dQ/RK7XftJDDBBv3mT4iHLEKliyou1di2rl9fte6TtQ57C63FRfrp6mN4kkjUDE0v3OdRqofPX/wZ0jUW5d7qCM2GKbnOxU9fKaeGNdXJRzYaQsWjVlWstkXE7rFxdGQdIFJ2iq969ujKMwNtohUo+TxC1SRiPhzgfybYiZK/zMeN3VjQsRFTiZZ1rRe1t5sDaGZ3IWkBWZME7EGSFd1uqOq+GY8MfwqZ+QVGwppQXVLaR9u99qiKFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For callers of folio_is_device_coherent(), we save a folio->page->folio
conversion.  Callers of is_device_coherent_page() simply move the
conversion of page->folio from the implementation of page_pgmap()
to is_device_coherent_page().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/memremap.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 5d18cb7a70e5..06d29794abe6 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -177,15 +177,15 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 		page_pgmap(page)->type == MEMORY_DEVICE_PCI_P2PDMA;
 }
 
-static inline bool is_device_coherent_page(const struct page *page)
+static inline bool folio_is_device_coherent(const struct folio *folio)
 {
-	return is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_COHERENT;
+	return folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_COHERENT;
 }
 
-static inline bool folio_is_device_coherent(const struct folio *folio)
+static inline bool is_device_coherent_page(const struct page *page)
 {
-	return is_device_coherent_page(&folio->page);
+	return folio_is_device_coherent(page_folio(page));
 }
 
 static inline bool is_fsdax_page(const struct page *page)
-- 
2.47.2


