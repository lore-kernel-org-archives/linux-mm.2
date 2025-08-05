Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419B5C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465F36B007B; Tue,  5 Aug 2025 13:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4166B6B00BB; Tue,  5 Aug 2025 13:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD3A6B00BC; Tue,  5 Aug 2025 13:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 002846B007B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:23:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F6161601B8
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:15 +0000 (UTC)
X-FDA: 83743374750.01.29E9A4F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7363410000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RPqrm+1O
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754414592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loNmP5Yp7b1LW1PihsJKm/LxgToSLOcZ3oBfkhcpBh0=;
	b=GRGsIyuYFL4HU49vVg1Txe/1Aenb43IyrVokDoCuX88ZXliF+qqgnflM3QSjH4pNmxZ6U3
	D4A6CjsXu3TP4+sEM3/KUmw7oj5fQZ618QrXyxrP8o5FajeX0CxXU1tmJP45Xt1BLzo+Dp
	QdLks+n8SFokHoRDvg3FleHSXGPhJjQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754414592; a=rsa-sha256;
	cv=none;
	b=YGqeuWjGoQySSyk7zXYmaVOLfLGKaS8Uq3sM+72FX5BD5sQsO3pCpehP/jUDgr0/AkNFzu
	oGjGROmvBBlSzprmuUqV/2McAjZN/n6AOZMPeuVQwrGeeNi/OHk9FiwccnHrEviLwmDRBV
	9Hb+CmxHAmTyEAZ7fiXOSEQlANeQIOI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RPqrm+1O;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=loNmP5Yp7b1LW1PihsJKm/LxgToSLOcZ3oBfkhcpBh0=; b=RPqrm+1O0l081m8BRX/PGPkpl1
	kL7nK+arr2ceGpFH3c6xh0baDzmOZP5hKKYUvG2KGOlatiCIXUcwyygZP+SebxZXDXpjmqLpitQv2
	lx9g2PHE4O4s9jerBrPvv1bBdpCSVsxmAUne1ZcC4Sq/kqO3mLkyoUR40winyWc917wcZTMkcFZgJ
	uWSqUvpjjwk0Bm37DSWkz6c8JuIlpCaBIXu4Yhhlo5FbTOrbIy5AlxTlEUsi/jhVAUF9bjzseuh8C
	DOAa1fNWOZjcjB41DZfQRXYG74av1bCHKv3BmHot2snFmJ7muLJamdn70b3TlEIXinafI21sRgxHj
	WdaQ1dAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNV-00000005T4z-3sIZ;
	Tue, 05 Aug 2025 17:23:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 04/11] mm: Introduce memdesc_zonenum()
Date: Tue,  5 Aug 2025 18:22:54 +0100
Message-ID: <20250805172307.1302730-5-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7363410000E
X-Stat-Signature: 4nf931aaot59qim7y53q6aq8rf75kpao
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754414591-314529
X-HE-Meta: U2FsdGVkX19JHEQVFOsx8WJm9DQdr2ITSZSTiiosBNKfJbV4bytsSY8EjFhGKezi01vvDcru0/C1XFJfOwZ86EAHBgOx1hTo9M25Ut/asxpjWhg5ScGmAobFQs47BLU8DkRFs92Xs5ZBE3erWmvV9MKwhOmrFoROz3B4P+pYe2ZekDXpbkr/9zj5sM/o+aITR/0g3sEf2XuB3w9lPEe13ckG8xspYsBrdwUlymcYkNdR/93QnLVokobTy8PMGn8qDxZg0qudGB6JQtl53acqf+I1cRf+qi5+MJVswhkaZBBi7eb0ShMXIXyApDwk6hlHEv3lHdldFy1skOwJ1s+wwqplapDWZm+L+O/Gig0KQqvbiDO77WIZu5rsCM4YlKN2L7NCPlyNgexxPvQpSNPL8S5g4s2l0SeN4ldX2pAGsfRObfKpTdWUe4eyJiVqF7L7eHtr00iP1kIEpHAt6YnpG3XH5d5deTsdlMqjLlYkCgCgpvlnyAJnzYigGK7gKtv9uNFwZShy/ZYaq5WW15eHuMi7+BE9hwtjXXZNMyDBuaQ5CQqYJP0mUyvzzRe5fLs9ZOIgkOT6/pfGEGElpVK6wTElIrb4bC31glMCymPVmsTfycZ5yAWgwcoPOqtkvjbv2QoBUm+59TG3NnK9B7odNcr9FS3dQpp09aVphkM0xFn6bjM32StHl34KxChEktdEWih6VoWVGuvfZXWChStPDjl1rBK6g2y0gvalBG9kGmMO66tB0q+sdPYpcrFJzyst4B/yhljJqHfk5dUmJhJbZJDlst/LNgRfkR3elMkZB3JAUQ8uaWzEJ9vZnnRqvbrNpqZlR11OoGrygw/U2+jjQyjPTYUM1pwyXp24M04+chNCley/wUFbFnqlQsD1swSqlcQpOkUIWNlAg4CgDfSXHelc6KnlPzMqFKMdqcggdnc49QfLh7zEb7KmSIS2lokh2Qbr3ozDPwVTWO+PmpI
 GRa/P0dN
 fe9lD9UQCztm1GlY3uARDD+Ti5olgL4bwHyhC1M3XNdhFWzt+OAoE4ELEqGZQHLl/C+LHPw5gsMxCR7QFh+eQXNBFBbmo5H1QmxxwvbG+vJQAA0sFFxkFQO+NGovtto3/Vcn2RRSAmRzheYQcVI4Fg4Yeee78fP9GTcJhewhBWmceo+r6/1vwXkeOmbkWrPdOnmtO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove a conversion from folio to page by passing the folio->flags
(which are a copy of the page->flags) to the new memdesc_zonenum() function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mmzone.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b4852269da0e..001a696756df 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1169,15 +1169,20 @@ static inline bool zone_is_empty(struct zone *zone)
 #define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
+static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
+{
+	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
+	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+}
+
 static inline enum zone_type page_zonenum(const struct page *page)
 {
-	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
-	return (page->flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+	return memdesc_zonenum(page->flags);
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
 {
-	return page_zonenum(&folio->page);
+	return memdesc_zonenum(folio->flags);
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-- 
2.47.2


