Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2785CCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F5B6B0093; Thu, 28 May 2026 08:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A015E6B0096; Thu, 28 May 2026 08:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916E76B0098; Thu, 28 May 2026 08:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7936B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2530E12045A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:24 +0000 (UTC)
X-FDA: 84816801888.04.C15DA85
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A7811A0004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UktwYdte;
	spf=none (imf19.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TytwpWLnDeE1HK4gfpnSCfDskt11IQKRJRva89Dfd7g=;
	b=lBNIH9a3bSnwUwamF9ffpv/sRUkkGi0yxIK3VCO6LcQJ5DJ55dOPbh0HjF/pI0vumE9oVC
	ZB6pCKGd+mUGDAEg4UkNmsrVVjYiAtAUSSmkOOnJvQdYoh2giCZNBUK8FtdFPMH3A/g3Xa
	prFaMRUacxo38SrQ41oK0rod1a0zu3M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UktwYdte;
	spf=none (imf19.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972382; a=rsa-sha256;
	cv=none;
	b=XT2nply+CuNp9NYbrB6rS5RYggC0byy07sw+ac6MmhXO50olnsSH7lvFyBJ24vjzSejCJZ
	XMEp/CmR23SwylVpQ6yQ2v/x108uRnC/7eMDqTS0sJlX+9slvFwVLS4Cd1Rg/jgPslMUC5
	VT5asiGQId8kx63DVS6kc03eX/6l3Yo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TytwpWLnDeE1HK4gfpnSCfDskt11IQKRJRva89Dfd7g=; b=UktwYdtettdZTR4IDrNggXrXYR
	/1eAV4qNXl6460AriSlNkDpVA0zDKwJH2irnVU7+roXFLduCj0qcksIYgjV8r1YeO5oPA+pLTwM5b
	FMUb39mF96/ClN1sNyOtOpDn+jAFv7gjLzGxyLrd/+5QgbPBJrkCg3YXlJtJUSmstGw8yhmzggrAH
	KKfjn25uXC3XvI1hbYoh0zNOa9lbW4frQdSr84ObHpvjuJh1uMbxDMhachCZF57vaCOpu9jc57x4T
	4DUNPhFXqtknXjCITdD3fXC/f5YZeViszbgyY7cTevFM5/zzqzBd8ui2K84SNi0UtD5OxI+X3RV/1
	oIommhOw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa7u-00000005jeA-05vC;
	Thu, 28 May 2026 12:46:18 +0000
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
Subject: [PATCH 03/10] mm: merge writeout into pageout
Date: Thu, 28 May 2026 14:45:19 +0200
Message-ID: <20260528124559.2566481-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: w58egsxtoa5tgssqxiz84orsxxtfiqhi
X-Rspamd-Queue-Id: 8A7811A0004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779972382-339460
X-HE-Meta: U2FsdGVkX185y/eTNEYoycBFAh9lRRUD5rzfZAW06o593sDjzfknRNF2qnkov6OIGyM/ZOMsCweOFrHw3vuzV+pxHyuLPbeGONF8RskuUVCPbfahXLtywkb3fXf79APQcdP7UhCbAvfK2TOuVL51iCBX9gbM0N0Jp0Kl9rdzdaB2cPVQY0lNvbmlpRDc40N9c8rNGewUrEDUhzpw1MGEGWr2YV01kLj5lAw5IG6HS2F/vpohKIan38VMcxknur1teaKij9d6Zel0IVzDnEv3Hby/4Ai3BLMZoQm+0yYTEMubtppuK+skKDf3aLW1LcVULbWhf3y9KFCTjN3kMoGV1qAmlrA//l66l4S6ZpwvElpOD67nnkGqOgkuTGw0Cfj7vblFvEfNIP1AyD4AlezP5ekDbveKyLmsIeywsMehOG3Mznyb1FqHBjdqD84nROxV7WvpngGwBukejIRIX+HUhfwd5kQHWeQ80LRJOfDI5nJbJQLv50ZvtGD34iJw5sxR33B6vJb+3X5aRbCZnrMO8g+AAqOAJuFSzhT/JP4M1GHM/oSv7cC+QY8uFQEmJ3J3rvsqM98ku+J6EdNfNkK2LrwwfzcaElQ3Ek4xH+umqYeXJ2quPRG/DgH8ItJEg+Qk+PwCPt4CgyJ+XG+wjG1sm1L9JfONl6WL88CJ7GAddT1wIXbwQKPTVb8k9BTrzxeKOoK3fFd7NWtYv2z4jOAAokJkNgYZ7b/07ytHMtjmV5+Mb/jDzmDLds581Gki6X8SSjVb258mqG9kdi8XRzeFTULIzdTJa9KXeUydlmRo6r/eO561lLqxTcBmZImFtkHiLVqAaEONoazVMbnoCiDf7kjfAJ1cokgGYgy8lRJG8ttAWpuYKJISBQ3St9uaqwmJxcYuk/9HkQAc38PTtyLj1Q+WG0BKt+6/WAnC1u96MuYcWswyKbpUn7ltd66irJmv36uFqz90tILPBJUN5R9
 NSlxvIGz
 cpFlkfXH/G7J/Eidz+B9tT3EeZht2ae1Ch/gOTd5679LjFoZ0inaYceVg2Wqdj7+OyKAkHECwQFibbb75nuvYxWPdZ+GbuU5h1OeM1w98TR84+oM7fQKm2OwUleDJFh8YbCs2t+zGBYkwSmEXV+fxSqCNv4XGD6r6OUlpfrHukxMMkxasjKeE5GNEltpryL31sSVmswfG1Gcewc5/tdcV7HuI6qJaNkrAITOO66YBHQ2oCBmPijEvrC8iX8BDnkz6Eu1ZBRrb7loqhnNeb8uk3rUiTOJNkpWJYuU+LsKx5NKShqZvvpUIjNBoZgYD6amrJn+8VN5nP2XetPhYKnmad8jz0PKsatr90sVzcAvEF2UZ2PucNE9rfQH/yq5T7947lxdzGzaafthZC63bx8MN9L7UgkZxSVVXkW9dhPznBVDzQJExKGeiGbgIl6DxP6cBiZITQAXm33AJ3e9MhmvviYVneu7Smki8uEjoq8c31p7R9f+vS+I+e9wQj3mtcw1nS1ACWNZWecJD+SgbaHw2bl0wMIaYB5itZsICAQrKqTOFox0=
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


