Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96387CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077F76B008A; Fri, 15 May 2026 08:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0274C6B008C; Fri, 15 May 2026 08:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6B86B0092; Fri, 15 May 2026 08:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD3766B008A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:00:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A65061408E3
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:44 +0000 (UTC)
X-FDA: 84769512408.20.2933C46
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 12C4840005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iUCxLgWm;
	spf=none (imf11.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p91zokl5vLWP1TBLn/VtgWTOXeQiN7WAmscGLgTHTQo=;
	b=oxOFjtKCe7ha9c240bS//rgL7+Tfl1K9cPcfgOB+FwX4zpLnzXOzKXSX1gU5jkSND3UVMv
	D1O9HwnLExyfhu4wSQPMxlTVPXTWxzOhyfmSxhXtOg0k0iIUd1frGfH+zHdq0MnLl3z6Zl
	VK86ibtRcLIAFsuLccRjQNDuiyDFj90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iUCxLgWm;
	spf=none (imf11.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846443; a=rsa-sha256;
	cv=none;
	b=rbGH05veKePaOLdV5slU5Qdcio6gxepQ7lV72zVaPfLAqU599TIthcPTMsvvupByv5E9+e
	Jqwxs1SgxGm8H6XHaXRkbEwWizHT/1xnK2pChmEeYvegKpktJLws9gMuBXj+3xf3Sf/kha
	0RSL+/bblWMW+XPpsePoB3pcdj51k3M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=p91zokl5vLWP1TBLn/VtgWTOXeQiN7WAmscGLgTHTQo=; b=iUCxLgWmPF/wA9Kvhggt/M2s9e
	zaW0chl9gd8t4zyC1EDKAX3dwMcbjUtrUudTtYJRjQ4I5iY9e8u8mcfO7n1sDwC04eRlutHp0eSSd
	MhJ0isDJCdcR4N1oXA19EJ1crkPfGFcpdXbhQGSFVOADVpp2r9Z4qom84FhG9N8kXl6EUx0VMHO58
	xDgUAI6B3tqW7iCIqe2pgI8UJA/oj7n4NZdHcpv0hAgpKTVyqpp6HKvpL8/D+H+UvSHyRxWJlazeS
	hhLE7FmK+2HFSwKgDcGUrQyyv2KFq/ztFGn0L8nDlgy4/TnW6t5EjgjHd1UnVZzVn2fG7Zibyan13
	hNBpUKKw==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDW-00000008GVY-3kCT;
	Fri, 15 May 2026 12:00:35 +0000
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
Subject: [PATCH 2/6] mm: merge writeout into pageout
Date: Fri, 15 May 2026 14:00:07 +0200
Message-ID: <20260515120019.4015143-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: hpn9qt7yhrya8r4dfe3d8cddysisrti4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12C4840005
X-Rspam-User: 
X-HE-Tag: 1778846442-196186
X-HE-Meta: U2FsdGVkX19oqH0Lv6RRy6f+IoEhAYxxglFsuxssOf7KdfDbFCBhzGp+5m5FDK/GpYZsIgK3iOq0guBiAns0GFo6hy9eRt3iQS0sTK5sBiMLMnAKtXe2nn/YG9Vibkl02Db43SbN6ru6joreoINNaOJrVL1R++UH7iB33p34juETqPi30rcqgtwUe65iFUxJhnjOTt1IsKTHfajBAtkrc7Gs40466Tz8hdnhkeTrPdfd+AVyt/miiMG0fNpowumehD4FRu1mzlRZDfEaFlpo3iw5H+iB1NAKSGrvlar95HEmd//nmmJnG6IDIR8e8RTvNNRBmjrTcQ6pZ+vggutAtz9CP88PdM25WhyNKV3eYVfvGsd0uolNVsQD0w19Lo607fDhZKBwrVcvUdWNKrPXTyHB313NJpakwmHmZnTlzM/29GP9ZUZWAEOTip0JlWO2wLb2Sk/YPY9yu1LIHoGCXcYMM1hjwOjEDr2mUW+SxHHiP7OfjNGwTe5PjJgnX5rWlFyO11xd3W2ef/mKJ0hREVKS1D5QIJlmW3T0AJQniY3GSXLFoONd4Q28D321dSsDcM2ZhR3GI5dXYD0kfaD1xgMn0+N81/BRLzdEPJCYE+fwKcSQliHUQM0tjB2L7UboCqOiGFh4mqXOxiTxqmP4RR8fuCmRP0xpJQ9X/xpg2szgvmyxjRTdMbRZFPzZvmb61wY9e1/vD1BnPwjWlDt5SP5gMTgbg1sFagwT/BpeL2qciTqH2f+i8czJ7rS6ZWn3WwEhOmW4Qs1yQYo3gNNEfrZmp0Wq4Z0fA4s86l2qKVo1Wk6UVMvmo8N6ln26AvEUMCG1vK/APGqRQuttwsgzHNEM7nddaNHtNbKh6VpMW2V9CDDY7ZrUEtYsWOJR44+DjY7HRNPfi1knZ0iaBwcUGpv9LlGQmjswZS3i9uFtNI9gWI4VBOMlwQpUf7lViR8jQuGDRvRlWkgTBFgG12N
 KiFmQQSt
 9ilbbCFDq54M5sOcuKyszCQooCMPcp8VwDxUJyX6PfQctumqxLrlX8c8jMsWgyLwVVu58nd4P3NfbUIHRp1buSxwcaatEvV1341399eoOfM3BvrgK1drYhvc+V+o3T9re3zhl99UPrOhhW4trSaqtvb+W3xAjIW7+2xk+3/vPsSZLes4CuSzIMIlYgmpuudx982+sOxjkBALtb9o8Xc0gOzXW5Wzd8Xdm7raonEXeUaxpq8/3g9y0HxRU/AL2eymQQ6Lihys371Aev1EaDjw3ZFckNrIwVCCOogjMrCb8TTnTPM9GY87fSKmqu4Z8pumzQUePEojbKb5RRKwlEFp7XG6+vi0r3V8tXMLTRrn0xoKMP1Aq+bzH1IcDT1U+FchaogDEuSwqjQwhfmaOLXwyqsJi3WBt+FcWp4GNp8T7sjlCvHgcBHydyViVox7rTLxlK35KgiIf7osof0cW+70FM4phOah8o8jjLubXDmp8N6BbS5OJNRsquOIaCnAvOQf1NB1UuSsWzkVHP/KBwjkrD8WLwrNcwX+btcn3EVHu2+Jqgms=
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
index bd1b1aa12581..dc0d4312ac6c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -614,45 +614,14 @@ typedef enum {
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
@@ -676,7 +645,33 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
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


