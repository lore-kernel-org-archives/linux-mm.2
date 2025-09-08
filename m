Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F7BCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564518E0009; Mon,  8 Sep 2025 13:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5149F8E0001; Mon,  8 Sep 2025 13:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F0E8E0009; Mon,  8 Sep 2025 13:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 276338E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E467F5760C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:15 +0000 (UTC)
X-FDA: 83866723710.29.6CDF9D2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7ACB01C000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s6op184R
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757351474; a=rsa-sha256;
	cv=none;
	b=HffXrbL15spPsmCGYtBDv+qt8s9TXK/dK2f7hC/8d0APlI8gD3UM7yjp8kObX4VKY7P/9I
	Z2spn42tpNJzHyifryBUXvyPcTZxaUoQlx+D4SN3OZc/R/7x6nu5+vNu8x+Kv6/+eW4WBg
	UTkU+mBqxoVjtMpDUm/4l9ly/1MfdD8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s6op184R;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757351474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0Ppi9mOUpn3LaqfcTI6Q3tvaRjeoIU5df66lidM3a4=;
	b=2pqd1OICZh5DgDYpfuAgoL3CMV4ivXZlpIV4ar05VjZfWP2aTpuGH4OiAsLq+bl10Iro0X
	9ObfovHurwuGbBPei1fru186I9llmSlAhnCUj/oDqS57j93yyYD80Tu+TCpkG+quel0SqB
	xcrytAhW8t27wofuvQxcmY2GsCcs3qE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Y0Ppi9mOUpn3LaqfcTI6Q3tvaRjeoIU5df66lidM3a4=; b=s6op184RkZFsm4qkT3FDQXi+bm
	sxuiYzM+1LDviqHqg/HK3ByK1vXGBnSyedNi1/tNQHWt2Tz4O2PgRnLhZDdL7vjHIGDlvYgC98iiT
	QTdDZq+7u7tY2evNQ6BNDjezBbF5QDKW9kOhZqc6WtUgP2M26wvN4weViiuW5tOH1aPlWL2erqCGl
	X10/UcjMG8I4z1kpTgXIVznRlX5wcFm9WQ8+sY4Cs871AXleHzT5DkXGldubHJfXr4/GRI0D6G7h8
	EFwqd/9zBchOOCtLEzCxET12wko2mcpx1x6dv4xoGQkIdEgFmSHuymeYjjV2JdbLtk0TZAX3yzdC/
	2OXnESRA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvfOU-0000000A6pR-3Bb8;
	Mon, 08 Sep 2025 17:11:06 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 2/3] ptdesc: Remove references to folios from __pagetable_ctor() and pagetable_dtor()
Date: Mon,  8 Sep 2025 18:11:01 +0100
Message-ID: <20250908171104.2409217-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250908171104.2409217-1-willy@infradead.org>
References: <20250908171104.2409217-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7ACB01C000C
X-Stat-Signature: prn5ddaq8g6i3hxmqutz71hzfwgxqxur
X-Rspam-User: 
X-HE-Tag: 1757351474-194183
X-HE-Meta: U2FsdGVkX18YFmPazbgjWvWiyyDB+IblfWfTfS+duZVNGR4x3Sq0SoyNoylfpc9KStHun4o7OzdBs+RLq+qyWdBdobBjK91GZxmGqNEUl3GNmtLUI6DggHB8R0MATGGgG9BMy7DI1W4gUl4XTUACEf0Vxkr0q0KeA8w4Zukl6tVXtKJfAihobHdU6GO7/yCAWZmVhkI2uqq9NNrew2eq1KQjU3Sn+wKrW5rmTZSRz+euctJRLOPk7DJZCmtOCg8s9OILlo5/LzY7SzqtXYlg49+sPVXYpa/PwJ9TwLUYHUG/xcdJVA/ne3goYsF0j2bsiiBX/e+hHXRt5ZTPOoD/GtnO4sVJsJwhQbQFpvk1t/lz3VraCoZBGQJrw1zw+hXCrGYwJGdDtkFA6kwlzP3WBeOuYkTtfqkujlbDGvNHX9ivZpq3yom0xtDlxe/Oaiv5agXbha72JNNjA1eA/4FHo6r64yuhPw1K7Q6XPgw4uifl4U+dDWHLGVH5u9XtXezpYAMbeq1prkYK74clNFfZ4Vi84aPceQoEIKseEkA/L1tg2St99zZfN1r+d1uQtrz8LIb/A+ohDh4lPP0c8uBO9a1D1PtPGKoSeqMcUQJc0mG2Wwtc+47wFx6KeHzDMv+vicf1frnjsKAnDihrd9Vj5MUgVKpX/f9TQt8FsBdWwtVoz0pl5tyd4/MXuRN7tSzNMHVTl1M/jZLZ5T73bqNIdh3aFTcG2u5wtLFBiLfWd2pII7h2ivM4pY+RoZrjzgQSNw7GCpb3AJ+mu+YMOZHurpMSGsLBusoRadUb3894osS5a0t8Vg5dqoK9jnqlVFml7x4WawX8MCqGbbR0djtqcodiiLkPdjXuOQh3iHzu7FTKVqz03cXe8uJDkSt3xA0rfa2FZvkeXV/G+kqwsNQj/Y7UNP4flAqUkuiHPfdGrsARZqbt7w9hkiuPi4KkE1kw8fVgs2V0aIhMpkk69TO
 gJhATqIG
 tsO+tMyIjgpMQyLiaQFw+DU6T3DTjhZwjaCMT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct ptdesc from struct page and struct
folio, remove mentions of struct folio from these functions.  Introduce
ptdesc_nr_pages() to avoid using lruvec_stat_add/sub_folio()

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 46eb2a7c4fb7..3a339bd7a2f9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2065,9 +2065,9 @@ static inline long folio_nr_pages(const struct folio *folio)
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline long compound_nr(struct page *page)
+static inline long compound_nr(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 1;
@@ -3034,21 +3034,26 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
+static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
+{
+	return compound_nr(ptdesc_page(ptdesc));
+}
+
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
+	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
 
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__SetPageTable(ptdesc_page(ptdesc));
+	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
+	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
 
 	ptlock_free(ptdesc);
-	__folio_clear_pgtable(folio);
-	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+	__ClearPageTable(ptdesc_page(ptdesc));
+	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
-- 
2.47.2


