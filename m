Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F93C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3406B00A2; Wed,  6 Aug 2025 08:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93546B00A8; Wed,  6 Aug 2025 08:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81F26B00A7; Wed,  6 Aug 2025 08:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7C806B00A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:52:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50901C022F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:52:50 +0000 (UTC)
X-FDA: 83746322100.23.CAD7EEB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 08E2FA0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:52:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KhVlaV2N
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484768; a=rsa-sha256;
	cv=none;
	b=NP8TpL/EJnGt6VsP5YXL9SQ/HYgR9YIXHoDYJODAXpPo0lIFPNg69rPs0c/kJwz7n7q4Md
	9L8oi/felRpkPOv3ne3LXFLKV5WD9LfsAQNer4WPu9JVwKXK65Cs9my9LJUD/+aO0Iyoqj
	VGxUlDZePbb8gPeYaYAjwoUEmGatkHg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KhVlaV2N;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Jp3sjcfdvLtJk4Rci6uppBYGesPl01rdF38ruPw+teo=;
	b=usgT49RLKrPeLN2IdRK6vuUGImiE+kGQByvkZaxOKda+uC1EFdkOpjyLDPiLipNQ5TMKxs
	x4z/2GFAcvKdcxZn8oEOPwu/RXGvGBZ/dSMJMksW7XWeiyPI9WUxndBbW7rG/rpJ7O3snl
	rSoVOvNXVxLjNMdj58HBeFo1O787+QU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Resent-To:
	Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description;
	bh=Jp3sjcfdvLtJk4Rci6uppBYGesPl01rdF38ruPw+teo=; b=KhVlaV2NpewD/ZzdH/jbkhasHS
	vfbL38wo78okLBsgATkVX8jcABM5tEzRGofG81UWusS9ouqRGzsLWQ3vUMaP21A3eKR8uLbXzua7G
	PT27yEnhw2KYdKKiiScWYnON8N9foeWVHx7GD2KwXWMcSmZ4oizW6WrM3N8BBw+l/bO1ahQ175NRk
	DSebUnyND4/kHs6vOO4EHz6qsZAlOSNeM3PHmn+GoNZg492ea2NmcPa6yJkcsP5NuxBjhogACMLue
	wLyY5Wt/mGWa58Mbhg9scaDCDQzobClYITfCZ3ARM/VIPkXmTymwQH4TXqoemgNvNymeAXIEHlx6w
	rc0osarQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujddL-00000004Hsr-2jRG
	for linux-mm@kvack.org;
	Wed, 06 Aug 2025 12:52:43 +0000
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNV-00000005T4p-3TnR;
	Tue, 05 Aug 2025 17:23:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 03/11] mm: Introduce memdesc_nid()
Date: Tue,  5 Aug 2025 18:22:53 +0100
Message-ID: <20250805172307.1302730-4-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08E2FA0003
X-Stat-Signature: tzy654adwgqcqss7pxo6p44gy8k3g15o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754484766-677319
X-HE-Meta: U2FsdGVkX18MaTgG4TsLpj1+E4ddss1P1VEumBN/upCD9snRKMofeHWVTrASvAomk9iigU/xWDJJKe/jM7Mq0mzzEs+8ov56Ut2mfoJi1sjFkNmcICyLOvtcrCEqbQkN3/iD+smcxl5lEyAci/xo0Q0tSL1od+Aq2h8SVs/W14lPY5BBLadI53ONLdBgVPbkGa7SD3NNr4weEU5K0f68tj5tO47brlmfCLqA0xqkiYMbOQVK3yvBIk2PquaQTgfxKMxlezh1n8L9lP6TDbHopREohbBCAHvxZlLvHmddQZmvXg90XJ1gE1a0AZIWUnhRBwpW7NFnFKotArfH5Hg5x9cl15jxGudhUaRKm35JARPCAMkaQkVeGTfgeO7e+yC+jdTW2k5dP0EHGbKRbViLOga3VUZrYqnsTAfDlR6tqhJmxw3O9szabGMkUbWd40oPTvDqAQUSCQdwW0RU2WevoDo5dUPprW0kLVnBde0iDIOpIN2k7NOouSgzB9vW8kHnwYggYBQtg8HuU9kLyMzsZZ4L58BMxBm1fVCww4PvZx+2lRvSWzAVbyvz4sx+rCdlFsmDSXAgjkFpgyN8jEMDgqU72KBsPXFSYIWSraQP3+oHxjfNilhl1vy3RHeUKRyGyYKne9Y0bxP0VVrGcGP1XfKmNU9P1pG5Gp0OBRgunAk8Mi0g1eyLvKg9R887EgB7VP2Jy5fXFbHqX6Q8/f2tfnLEQmwUJmNhGE4aAX3lIANAyLoTXIMalcSqBef8Xzwys2j8MKDv2uhOvS4Ze75NVqdT88hpqw+1O4PsSWlI425e1zuiijP0+xHqcSytArHNl3r3neTjd83UaegQ5vPrtRNJdAwUmys93dA2DYW3r65s7QnTXtSASCycOYQ8W6jlRFPwY2SmJ4bkOJI2C6x0Pu6EYkn2pMT8AT02NgOlmAzZL0FoHLgAZtdwOi1dvWMsKaCSOyfO4HBWSEvmcHx
 az9wlGNn
 DFSYYJ43pIoW1Vg9U3Ro1CWY/o/5gbidmiIAmezncEc0a2/Sz3rryQL5jtBS+Gt8reVn/hGJLumr9bJK9aig+BAVsUmIT3jXqAHC9MFwWMSkhUQk5wNBRvSaU5N1nPNlr8N1Ah4PACAjMIeQPEe9NGUFJu0OCTmiFGyVXXs6k8hKcGiadMy75kS4IySttmhZIHm46S/1Uv/f5ZHzoDqMS6reJM6UCNKbeYF/0psaITi77X1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove a conversion from folio to page by passing the folio->flags
(which are a copy of the page->flags) to the new memdesc_nid() function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 21 +++++++++++++--------
 mm/sparse.c        |  6 +++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bfdec5ad3afb..c64423869b30 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1507,17 +1507,22 @@ static inline int page_zone_id(struct page *page)
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-int page_to_nid(const struct page *page);
+int memdesc_nid(memdesc_flags_t mdf);
 #else
-static inline int page_to_nid(const struct page *page)
+static inline int memdesc_nid(memdesc_flags_t mdf)
 {
-	return (PF_POISONED_CHECK(page)->flags.f >> NODES_PGSHIFT) & NODES_MASK;
+	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
+static inline int page_to_nid(const struct page *page)
+{
+	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+}
+
 static inline int folio_nid(const struct folio *folio)
 {
-	return page_to_nid(&folio->page);
+	return memdesc_nid(folio->flags);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -1740,14 +1745,14 @@ static inline pg_data_t *page_pgdat(const struct page *page)
 	return NODE_DATA(page_to_nid(page));
 }
 
-static inline struct zone *folio_zone(const struct folio *folio)
+static inline pg_data_t *folio_pgdat(const struct folio *folio)
 {
-	return page_zone(&folio->page);
+	return NODE_DATA(folio_nid(folio));
 }
 
-static inline pg_data_t *folio_pgdat(const struct folio *folio)
+static inline struct zone *folio_zone(const struct folio *folio)
 {
-	return page_pgdat(&folio->page);
+	return &folio_pgdat(folio)->node_zones[folio_zonenum(folio)];
 }
 
 #ifdef SECTION_IN_PAGE_FLAGS
diff --git a/mm/sparse.c b/mm/sparse.c
index 6c1d400f8962..549d0501be47 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -43,11 +43,11 @@ static u8 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
-int page_to_nid(const struct page *page)
+int memdesc_nid(memdesc_flags_t mdf)
 {
-	return section_to_node_table[memdesc_section(page->flags)];
+	return section_to_node_table[memdesc_section(mdf)];
 }
-EXPORT_SYMBOL(page_to_nid);
+EXPORT_SYMBOL(memdesc_nid);
 
 static void set_section_nid(unsigned long section_nr, int nid)
 {
-- 
2.47.2


