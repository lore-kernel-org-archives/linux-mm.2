Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C69CCCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657F28E0005; Sun, 19 Oct 2025 20:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1508E0002; Sun, 19 Oct 2025 20:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F73F8E0005; Sun, 19 Oct 2025 20:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37FA58E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:35:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB0DDC069E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:35:02 +0000 (UTC)
X-FDA: 84016622844.15.B7D44D8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 474ADA000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:35:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=crQ0dLzz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760920501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnEUxlQ75LP1Ikf6IjcEIwk3pZQhxkEHvIBtAe/p70Q=;
	b=H8/Q/0votbGTWjkFqHicdOy9o8VUJOS3w46upvL3KoK8as7dMmlBdlL5GEhTl2mjyLOK5W
	ojU1KVu1tlKQsQNXaIOQApMAyKrdTB6Of7vbVb/CMMVtyydRbyWE00VGS/r4t/mdqY/Teh
	g2nAwhs2e/2Fohhr5vrqEGQrQMJwwNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760920501; a=rsa-sha256;
	cv=none;
	b=eN3Jn6UdmB1T85HJOcYIHcrBOatqnLfnz5+4E62LLOByOrHHc8KJ7jSQMBD4/yhkpCSrP9
	qNhs8t1u9Nvx6SlIRq1Ummd7Mn4qaoW4SNsJhVCrz8EOGH0/ersx9kjY2Trd5dHkzuWvIi
	lwSbzHAiP/E4r+RhxQI4eJMLks8CDpM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=crQ0dLzz;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=KnEUxlQ75LP1Ikf6IjcEIwk3pZQhxkEHvIBtAe/p70Q=; b=crQ0dLzzgBf6jLQzsaINwk9ZcD
	n6d8xkZ7MzW9b8z6NK8qkpg5v+ZUc6nrF355Vjz+WvzKseRRKzE/HgME8vhJSukG+ThQxNIV73nD4
	Q0iwKRdoCOGE8kuoppqa5EyKpAEaG+6xZPS4L0LAq1aGC6E+e0FJPeJgoOy6BSfxkPA9GIDuaYPZv
	PMZi8+OpSg7WHJvDSKqmq8whNIafGUVlPq2ysb71+Juc58uNF8K4egBUAM/xpffQSVw4Gkir+O1ld
	9rRmw//lmdVIcEpK9etUpk7s8Rih5ksoeIE5C+/UqnR+phda5oJ0FfDMtlUcQ0p66Lc1MEjETx4vH
	sknObrlw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda5-00000008t78-1EOD;
	Mon, 20 Oct 2025 00:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 2/7] mm: Account pagetable memory when allocated
Date: Mon, 20 Oct 2025 01:16:37 +0100
Message-ID: <20251020001652.2116669-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 7bstgii855sb9ehppfxt9a7jhr4bgh5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 474ADA000A
X-HE-Tag: 1760920501-35704
X-HE-Meta: U2FsdGVkX19XaFkHHFi1LGh/wKGx7UWgj/7RJeWUeCNO1SgCQGlI3OGJtXo55lermnJBc2Et5IHEKk9chodmHRhQTwYpIlZeSac9RVRamyra96s2mPrb9ctVNovbeVGjV2iRkmD3NgfOE0zpDUcsfhrT851yneZXQOfWuzW7S1eBBwx7dC1sYbrUcU/+xTiJS8nQ3tWZl0mKDC2LnMTevOM1Uxkv67zZpRyn+dyjnVz38aeJP6QHxnGE6k+sic5LAWrdVZ1C2RWBeUTJjlrloA3vnWTEA/xm8imFboLjInXPQyNBX6j5AHaprlFgsj3oe762zfga4IU2vDYK9TxO2g6tNoDXfWshB7yuetG7mG6k+1evRjXexLVcwEO2my8sAXjCJKjwsVys0iWN40MRWcOQKJkQutycHqGx7vCikNGjNx8bjuZpRDqGS3FSWKs0Wl6wl36NDWLnbVPtBvsFczb4c9arYwJlZ7EjvWKhP7W/83iNaEJ7Z1Ejjx2TcspTK/pr1Glgs3bV+vnPOaR0OUEzKK2pATruAIu68lR38E/GAzjppqwVPrD9Y5XiWG2ri183AZ7AmHgCR6WfduuCUIQVVCZ5o+VeVajEXS9P6reTpg68/cQ3YXjRBqYT7Td4NfgMCSGmxb8Oof76xWVuNG47HjEyqFCYg7DZyudXe1mSsZf0B/Bnwk51BJnzmn1bK0lLeqpOMpRWIzsNqLWInpXQ/7mWTo4i9p1iqL05NfJdNs763Qe17IB5/3OArDyETV4zUbljwg8UntjonG/AiFs+p2Ud6A8xcamFB2bFcq0ZUTqL1cehjqKhTf72puCVwwjxWXyf39LzMnuwlEU7R5lfPaQ/T4Ol/wZVwipUoaBNmgOHohym+0v1hz3Llpw/PygLG6wM9F5v/4vJl+jZC4hclMOlHl57h1nReUmOu2LgEqzGZ375Cumv2wm+k2MbJaJBC+nMpdVyDqfeYMb
 QXYP4Lcp
 QCGdRP5m682235HnXoHuNG6cqAfwC53bFbzPZqfg1EDgL4c8EP1kkezCeGpaCQ6f7kC/JR3mq1WG20Mg34vllpf4AWefrnwhPCdT9/pDeGtNKfPUhkt6d3UZ5C7ANsNtW8QvmaLAC7DqZh6xyPb14Z5l7dL7y7p1lpoArft+A051PkBbV8h1BymSNX6WxS2jAq4ZVa9XKi0bCIT9rk+jYYY+3lADdme2MiFvpcNc7MrxYab77jOJt5TZpg5/gMO5iaqsOoM671wMPEjM1X17cwYQlrG9cvXXdEUhTUXPgdOmF6tU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the accounting from the constructor to the allocation site.
Some of the architecture code is a little complex to reason about,
but I think this is all correct (and slightly more efficient due
to having 'order' as an argument instead of having to retrieve it
from struct page again).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 11 -----------
 mm/memory.c        | 11 ++++++++++-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ec9365375d9c..ade37df5ea2b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3044,26 +3044,15 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
-{
-	return compound_nr(ptdesc_page(ptdesc));
-}
-
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
-
 	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
-
 	ptlock_free(ptdesc);
 	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
diff --git a/mm/memory.c b/mm/memory.c
index de9f999ffcf6..033fc4e29232 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7280,7 +7280,13 @@ long copy_folio_from_user(struct folio *dst_folio,
 struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 {
 	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
+	pg_data_t *pgdat;
 
+	if (!page)
+		return NULL;
+
+	pgdat = NODE_DATA(page_to_nid(page));
+	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
 	return page_ptdesc(page);
 }
 
@@ -7293,9 +7299,12 @@ struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
  */
 void pagetable_free(struct ptdesc *pt)
 {
+	pg_data_t *pgdat = NODE_DATA(memdesc_nid(pt->pt_flags));
 	struct page *page = ptdesc_page(pt);
+	unsigned int order = compound_order(page);
 
-	free_frozen_pages(page, compound_order(page));
+	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
+	free_frozen_pages(page, order);
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
-- 
2.47.2


