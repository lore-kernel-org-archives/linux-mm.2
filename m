Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4E3CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0253A8E0013; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1CF8E0011; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A758E0014; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7D6E8E0013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7537F119A2D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:40 +0000 (UTC)
X-FDA: 83830225080.08.5367D02
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id C139614000B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=viykmvHH
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482458; a=rsa-sha256;
	cv=none;
	b=qLFlQuq8IAMYGA7nnVTNeMqiGQOkm6J9WJ/moXkkd+29gWZWJmj0HEXMF2kmXANb40eJTM
	FrRhdAY5fd424Ceh8EJV0IXseaP7epb2EZx1Dk4OecyB4dHGkp8J9S477RNwxKyNp9GAc5
	Cqd4oy9TPABO3Jgn0TxvPyFenlbpwac=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=viykmvHH;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6TB4Af8kRC0EBV9A5UK9qhn6gexb/5ADqrMx8UiRX4=;
	b=YRai8Xe0i7MAYyHbNtcFyZpKodRBTNkflpiJnib4FgG3GWCNWh7Do6SrgRAYdF+qI7gqaZ
	6725gm5tVPFY+G0IVBUFKxTZ35BIZHX9eLkpsmRs7FHJu2W5aTd9P9ZPUA0kJ/jqgkedpR
	9v3Rd/7LtEymknLsomKfrE+enIadOSk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=c6TB4Af8kRC0EBV9A5UK9qhn6gexb/5ADqrMx8UiRX4=; b=viykmvHHbUAPvHI1bW04/gAn2e
	y9jeeEBPoS+MDspipnXiCtpGsgeneBSv/f3DQl+sRUVr1Y12A4dR0R0XJxT2EVc+819GB1AX3rvGD
	Ld2vyjbtF+3rcwBu95QVud22vy070ELEBYRcBAlEv5YbCDGeW3R7tQ6JkUmwAngc9vt27pTj18Ss+
	Kz4G95Msmg2OOqwvDiRb1hd/VEfPSWdtNd2Y1b6JKcjW1hczR44sAgl53Xks3MmpUzYojNllCMJkB
	IJ8kipnNWFpB4wlUFaqijLULVYfvkJRfS+fhiYtwqgilWjTyCl5D5yE1Kw6WG7Ajs03ORbk5ydUGO
	viwMlfpA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwg-2uUT;
	Fri, 29 Aug 2025 15:47:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 10/22] slab: Remove folio references from ___kmalloc_large_node()
Date: Fri, 29 Aug 2025 16:47:14 +0100
Message-ID: <20250829154728.3397606-11-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C139614000B
X-Stat-Signature: 81cbyptoijquq1t65qcwxsmh4uds9jio
X-HE-Tag: 1756482458-425215
X-HE-Meta: U2FsdGVkX1+DFFQAyKhKcdc/SqWBOtaGRRXZZn6LLajtkA3pE/ZeZWRTy7LhhiUl8jRLwlGoNiVuM/qxYQjUVzkmF9dg/c8x2x9hjLRHb8vwLk1QwAgU1PRwaXzbZZxnPMfSF5U5+WnPMaXuSBva0pwVChfCMm0ixz0b3Cuxcw8Lqvc3ef1qkfvePjCtz4bx3yHuAt8jB/gVymHrbm198QDT9JKzvsrC4aYj0gavZ7rL6tAzxuhoP7e2WCtEQ/irOJ09ZdunwQvs72YjsFK5krpFmf9icaQ3XSW5wgsWXSUhKofkc29x0HJPv7f069vwn9VPfMIEKrfg1Mphr6snbguF8HmEx9Jr67//OXbYsMEE72n+KjJuhshXuhZrSRAWsd673M77+aBbfK7/Fjz5iz+Y/fAwwYExzK1gyoO/gypaB5uIqUVj94cAMoWtxNetSxnV5ZyVIDu/kSJ8SAoboKhY0bpEoby5SoDh23X93PdDSJgwVLaqqlsda7V1l4d2SZ//kS40gEqhNppJCEMW+ysjfdorfB/zrlx2h/YjkGbbvYKfqMR62awzY4fTUfTPrhZFohI50T1J/0Mr7ut5z7IVAYidK9E4yFlKztYFnDH5KjzWozJXKi4xanJhdRqQTC/bH2rzNz1lcepJX4WyBAKJY+PJdgwUf4eKCjiIYDaNB9PmcR8hb0FRqz3QHKZl4LD4w7QhO0+5h80y3Gx50P29eqicSAmV2Z9gs4HSHa2L51Wuzpo2W2AehlOV8ce/b+kuctBKnAyweFFddtoFYzsfoJp0CIkWNQVH43SC69WFrHCraaNo1LkDe67FokNGoc4jwLkNkcrAnqaPdWCMHDsfoYUX86m1ECwmqK9YaNFMbJ9kvDtm50bK9YmLuQ+5JkpJXP7+pHdnO9ockNcHWJEMRz3hrfCrljFMGhQRZSPOy6TUtbdBZcRzdNdCWD/iV0f+4Imi7VfoPmc16Zu
 WwUvYvWa
 lrW/d+Ykd1w3PlvbSiMlU0TrvjiWauHX4OCFA5iSScx3d3I94lLlcb/3wUa8aKuvJiy0kJ9fPytJj+ktIqVMfSQYQ13xIHa9Ikff/8fjCOe4fQJGcsLv0lwBFlyKTTH3UhGKlFkcaopon3YjxD8KcmSR2IUEdTELkaffT6Q5m2NiutDloE+x6reZ452Uy5PTgb4Q1DejE+AO1PeTfb4sDopETIUVkQt+i+fizD0WO8bRcWkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 883a351255bf..4e8104b05ed4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5272,7 +5272,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
  */
 static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct folio *folio;
+	struct page *page;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
@@ -5282,15 +5282,15 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	flags |= __GFP_COMP;
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_frozen_pages_noprof(flags, order);
+		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		folio = (struct folio *)__alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
 
-	if (folio) {
-		ptr = folio_address(folio);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	if (page) {
+		ptr = page_address(page);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
-		__folio_set_large_kmalloc(folio);
+		__SetPageLargeKmalloc(page);
 	}
 
 	ptr = kasan_kmalloc_large(ptr, size, flags);
-- 
2.47.2


