Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F373ACA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB5C8E0012; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B8D8E0011; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505EE8E0012; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0A28E0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0539E1A07AB
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:40 +0000 (UTC)
X-FDA: 83830225080.18.7F6BA78
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E305C000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Zd3g0YOy
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiGgeSZ27iTAdmYuvcCkI0FxYSr0WHdLAdy+gfyUYSU=;
	b=NAi9NLJ5jgsLuckmU8CCbGvgTmuT55snKomEoE5akMdl1izyxRXLFuUGFGZkZJFXkCuMrP
	Qw6YqNs9yzXclmkCtuEPW01vnGKQAC+noIRn5qIlKASF6hOky2LzHikXjwZ+1r4PPDDXmi
	HaWqyCX6lx1AWiHYaVcrGhCEb36Hhi8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Zd3g0YOy;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482458; a=rsa-sha256;
	cv=none;
	b=tcHqDi8WEbM/w0Gkks3HGyY6qY/YoE6E/0Gzpw79h1x0FUnnwps8EpF1rWDy/3JZKMkadF
	7ECnQZnqgNFX5dH3zQhN262qZJLsP5MYM7Zx3w+6tsT0M29poJb4zoiwL3Pfa0qAhi7ea8
	1yTqZX1QaOl6sKPhOuimjnoDaEZM/sA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YiGgeSZ27iTAdmYuvcCkI0FxYSr0WHdLAdy+gfyUYSU=; b=Zd3g0YOyAAx2X3D1AQaLv0SFBX
	jwDeLzZC0/qxXSwuyrEWh/aS9UAWQWMIbMx7+X6F4HuiIqDNgvyQFt8YHZrxD7ZbkBOEJc6fucWwP
	PzxA8zSHRlwHpSKntVrgDk632cBgRiWt8VWcJF1xJY6wctGN0SvVBxM/DcXoBxiifD3y2fseiePVP
	w71euTg9R92P/264rUlAjPA/0rmZ/IR73bV2xJhE6sFaaViBGml6qnkmoSq62ne9bII+bko4R6yQE
	6WmpolqAtz2PUMxSzAlWIhhE5AI7twrdgLfLMHtqHlOlVNqRnPI/6kXGI7G8eUVt/pT1NfQ8vcKKA
	lw4G6fJA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwF-0cq8;
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
Subject: [PATCH 05/22] mm: Constify compound_order() and page_size()
Date: Fri, 29 Aug 2025 16:47:09 +0100
Message-ID: <20250829154728.3397606-6-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: noxyhxxo7prqq1xc6mm6jzai8t94q1r3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E305C000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756482458-34846
X-HE-Meta: U2FsdGVkX193NC0qMcLUmYAMu3CMRQyYRQJc0RK1mLGaFmItrUc0L1yA+s0B0KskvgNvK416WRFbpNSZOYvf/1Y3ZZJvdJUE14ws3BTPZVAAWPJQrtM3NLTFWs2sl02P7sPBQnmbVrtDVKtai7E7vB9fLHGr4GzlXbAcuIj8t+ErfsB3lRpPt3mPG9GqJa0vhR4oasrUseMlmporTzMr5rQcx33Rf0hNEGRKZ3NDDg1y8l2IdUVbL/GThp7VfMpKRb2GYJQDLQvA7grrY+DZwWQbwQ66NBzS3Nv2HCXIxAsgCZxSn07Aic2PkV/88Pf6yRP04Lhqh+UXjlxE0Do/ykFvm4tf7WDvIBXdS2IjiwFDnBcZOLeF9R4gGwfcNBeGPlKPivG6Dlkc9fjo+HOxVv3yxZD4fZkSIMk8yi7jlGOqmOMF2dH2gi2Cs1nPUXLjjUEqWp0jZydP2XGcboHnRFD2OLuYBkEUtpQGzG3yS/w1fMQqXkh2UcVujrmeHyepSn/bFWBCVezbWgrJPe0ozfzag3xfIFovBe8dgzKHPfLRdItYQrTiZubDS+NMQFDFUuv0PfLJksznguKGmaka83QJVg+vdyewL0HFr3eSPuaMv5qgyRubnt6uOBoHsAh074XX3xUlbmWvdDwSscj2A8lmfW0RViDpxqJO/SHi9gHI85aPX9/OOBOXY7aIJRDXOwI2lvx6MBcMT+TI24qejPbZVNjaY1e2FTeVPqsR1rBVIANOfMy+XRk1oW8JSzEbhDGZf4rTxX4+fpU1SQxpZVNi/m0+OHNPxf0MwtDvf7jdAraFUgkl7vc8IMwivGD3NbsIARsa3T++OLfNE2CYq1cYBX2moVkUebu1x7vbrbs//n5Sv9vCk9RqY57uqa93CCPiL4MW5vRk2e6oAwIN53F44xEfSBL9mJV1kzBXUUs9u33aLHYwryOn2VupJ7s6Qnkktl7B4guLRG+xGjH
 91X5ibgI
 tVSQlbpzVZLho5xYCXCSCx3HhdcByhP2SHOzWzr8N0agf07rZEMThg7NcLgLO64RqQ9lOuDnY7VFrb8ct4M48RdjJ4HNZfGqx2wtAwCRLBaDiCdwMajwe/g4seNYI4HzT9KzfN61YD0Z2fE2foYAg+YwM4gwE1kuiHDGxf1GBGtNvpPKrWkhzqFH9bYIHSawVp8hPs1khzX+OF6difvmjageLoJJUxUv5XAjBczx8NqTbEOgBeme3fvkY5AuvyyfaVhEu/o+t+Ni61IE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions do not modify their arguments.  Telling the compiler
this may improve code generation, and allows us to pass const arguments
from other functions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00c8a54127d3..02fddbc38647 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1020,9 +1020,9 @@ static inline long folio_large_nr_pages(const struct folio *folio)
  * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
-static inline unsigned int compound_order(struct page *page)
+static inline unsigned int compound_order(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 0;
@@ -1240,7 +1240,7 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
 unsigned long nr_free_buffer_pages(void);
 
 /* Returns the number of bytes in this potentially compound page. */
-static inline unsigned long page_size(struct page *page)
+static inline unsigned long page_size(const struct page *page)
 {
 	return PAGE_SIZE << compound_order(page);
 }
-- 
2.47.2


