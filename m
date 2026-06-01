Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80C50CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817E36B033B; Mon,  1 Jun 2026 07:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C94B6B033D; Mon,  1 Jun 2026 07:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC1E6B033B; Mon,  1 Jun 2026 07:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57DB16B033B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:35:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D26C120647
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:09 +0000 (UTC)
X-FDA: 84831137538.27.CE99FDF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BF434000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ka8PtKLX;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf04.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TytwpWLnDeE1HK4gfpnSCfDskt11IQKRJRva89Dfd7g=;
	b=ye0btL+RNSWA0s4HPzMfiZLote/558thx/ec5fpNrql/+YL8Xcak6Ny5UxGeJ/C3f0llm8
	+YNfWayObGtvDNkQPACjI8zlWA1tBSM6wJjI9EzOvDhqOsm0Ijfp01+qfKubgFpWl8xmh6
	+F8628avzR9/rFmOOI3yhM4qctXh6aU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ka8PtKLX;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf04.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313707; a=rsa-sha256;
	cv=none;
	b=m3hGk4FfqzGzC7tCEdjCBIf863jdAMqMCo6MWsgLiZF1RhaQdWtlcMCN6tE0W1svhEIjxx
	8JQTahnHBbVVPu7bCskACMyuCXfxZH5XBbVjxnPoC/eVXR6OJQU11aHWoq/JQGq4tRqV6r
	LzlWdH49MFJyxe1FxSXEqoxi8aqtS7A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TytwpWLnDeE1HK4gfpnSCfDskt11IQKRJRva89Dfd7g=; b=Ka8PtKLXI3BuQ9zVl8bQH8L0ym
	9/VSvr1zwXLfWjTOb/KwQb7PUfnz1PjjLR/EbZiZpKp051nRZJdiOiH1hMyqRJWzaXtA/pUzRuFt+
	WiKzBIm0Lde1zFjjB5A6utgx5UayP4+cJBSrgSchpjIybYfu/rK6+b+czB8lYyS2+/rAQh+RKT5Y7
	9UmHieDsXml1uSVRGbEM1SuUCyMkZABDpX7Ov4BgATjUIhPLwXafIQ/+QIunHUAic/8Y90g+MI0p5
	pKbZgbFv+YuciXJC5MeuOfGQ1l99M/+Tl07cTlWXcfTo0KGSysmbmL8uAnmHL98hRP8jCZtGIRubL
	5hPX2SOA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0v6-0000000AkZf-3aCi;
	Mon, 01 Jun 2026 11:35:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm: merge writeout into pageout
Date: Mon,  1 Jun 2026 13:34:28 +0200
Message-ID: <20260601113449.3464734-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BF434000B
X-Stat-Signature: k3pnrmbdmr36xjhue1ecuujhnzfepg7a
X-Rspam-User: 
X-HE-Tag: 1780313707-544301
X-HE-Meta: U2FsdGVkX1/0KkthNXUAhDqrjWOJqvL6PPU5nyAOalWrOpKmuw/IGdl3kO9yuh8Rz3uEGM9aYiew4wOLfZAkas3q6BezdjPl5N9RJVN9w6qWBN2v+juumOk9Lwh2bgxRJVapFKMDcvyp5cIM8EIRYpqP/U1c4t+uChEdWPQri1it5j6M2yOQVrCCc/AGl29gkI7bu+Z0yDpgw2p8WNBV62SonbLlr/SL2wjYOmwuQsehr2DjuyImeZAJub95oQBxCJs64tpxL4vc8apwarYfLWdpF4HAc4jkqymfUvfV45PikGuGijE9Rti4Po6pKpnCtKn8ahBgowt13XKHzL1NVcTKvcfGCsy7BfDOYeKokKDgA6+tahlnyQsrYG8jn+eB7lEJhiE1usdKbACWJAoXItf2kN6C5jPmiddWUh+m4Lq9c9qF5bVXstWosjfsxvqNFuOXVrAqnH3k63BkdTWVrWmsBuepNZmivmMjopht6C3vwreYiw/KYgTlAkTyWb9fI9pL9M5kLsAfKTbbvuvrxK6hVCuOP0kKsFatT9Iz4sslJP4U5md+mv5VXFy04yxggYh3lkfdKHx3zVKF7iedWC/9fHIrQQ2Q1qPkKtP934LoGDyr/r9qSC/+4fRHIDcFT9lC1/th++ZFPBWNAeLkCWV+CYrpcGVrPAxPMMLg0NayPFX0g+lIIs+IlARtmcYCrhE9GF0AQuynv/oKbNxmsJdFvdWXRVjSLp32FDHPQZt1wbYnd12cP7Ut/JimlKyNzDohCDaU6wObpd1/Rg07/HvnS6Kxlk+e0/30C2v/f5/88pQ8g1CeQdSv+80TQdJ3WSHZBmX+VSFixbm1aH7Nj9TOMElZLatOAcjSOslBr7M0E8nh2qRdDd11p62ec80S8AIQpjIJFsqrOmkyjF2Qjxd0CDNbNlQShgDES/G4D1jKNt4JrfCEf984qaABcooUt+Mewnqe9hPHWR+Sn5+
 E6cdBHxa
 b8xYZf3XCIZ+Upf/KfSKrr0mXDgLHg0zdsnNQOfBoi4Nwjs5Y7hqpXSfYusUtmwDr0xqK6TkozppiTfrLMw0Tia8eoyTq2SCq4VDp1EUU4uUngi+puSVpzvAvUgs0qfvL535xjxcZiVJ6yYTylGvyCfQ+8b5HW8GWzzfermUqLXLrUCue/8mnnebPTeMDB6em9gEhGh7mspT2WQJU0xBwKXNFGP0efA6TuRA/j1G3dNgc4/nd2JGtBrE33j3Y/RvfvYTmEFfahXv1UCAn+6DDZdNQeYfVJXQwtin3Ecf8o6T3AKoRChmL2RKqi04TSYgGvvTDjX4+rOLCipD6jfGEKg2epQDVZ60I7Ja5ZvtzRe4TeC32KrsFtOp2tg/nwCs/qe5vzfKwJSOcaHv04oaKN1f12/QqMjbE33hjJWsl2N6k/pzVYDGaARmD6BRc32JQMi+vjUfJO4L5qQf4Uv8Q9GVWOsuc/cYfYxrUDE0ez7iFO5q+WHNj3xnF8mR3w1cCzujnJIKioqcqCLeGE6JMdLqKtYLyaPHUU9+vTrIGZZoKFQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

writeout is only called from pageout, and a straight flow at the end, so
merge the two functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/vmscan.c | 63 ++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..d7303eea1265 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -612,45 +612,14 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
-static pageout_t writeout(struct folio *folio, struct address_space *mapping,
-		struct swap_iocb **plug, struct list_head *folio_list)
-{
-	int res;
-
-	folio_set_reclaim(folio);
-
-	/*
-	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
-	 * or we failed to allocate contiguous swap entries, in which case
-	 * the split out folios get added back to folio_list.
-	 */
-	if (shmem_mapping(mapping))
-		res = shmem_writeout(folio, plug, folio_list);
-	else
-		res = swap_writeout(folio, plug);
-
-	if (res < 0)
-		handle_write_error(mapping, folio, res);
-	if (res == AOP_WRITEPAGE_ACTIVATE) {
-		folio_clear_reclaim(folio);
-		return PAGE_ACTIVATE;
-	}
-
-	/* synchronous write? */
-	if (!folio_test_writeback(folio))
-		folio_clear_reclaim(folio);
-
-	trace_mm_vmscan_write_folio(folio);
-	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
-	return PAGE_SUCCESS;
-}
-
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
 static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 			 struct swap_iocb **plug, struct list_head *folio_list)
 {
+	int res;
+
 	/*
 	 * We no longer attempt to writeback filesystem folios here, other
 	 * than tmpfs/shmem.  That's taken care of in page-writeback.
@@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
 		return PAGE_CLEAN;
-	return writeout(folio, mapping, plug, folio_list);
+
+	folio_set_reclaim(folio);
+
+	/*
+	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
+	 * or we failed to allocate contiguous swap entries, in which case
+	 * the split out folios get added back to folio_list.
+	 */
+	if (shmem_mapping(mapping))
+		res = shmem_writeout(folio, plug, folio_list);
+	else
+		res = swap_writeout(folio, plug);
+
+	if (res < 0)
+		handle_write_error(mapping, folio, res);
+	if (res == AOP_WRITEPAGE_ACTIVATE) {
+		folio_clear_reclaim(folio);
+		return PAGE_ACTIVATE;
+	}
+
+	/* synchronous write? */
+	if (!folio_test_writeback(folio))
+		folio_clear_reclaim(folio);
+
+	trace_mm_vmscan_write_folio(folio);
+	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
+	return PAGE_SUCCESS;
 }
 
 /*
-- 
2.53.0


