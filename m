Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3D3CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A398E000F; Tue, 16 Sep 2025 14:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932448E0001; Tue, 16 Sep 2025 14:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847C48E000F; Tue, 16 Sep 2025 14:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F3E8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:12:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B6CC831F5
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:12:34 +0000 (UTC)
X-FDA: 83895908628.28.E903CBF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3CB171C000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:12:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XOJqcPWl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCyVtyoVDIo5zPTCpsDqkMUO7A9ONdcjpAAg7RirPx8=;
	b=1am7oWt2fFNyGJn4MhxOwQSShOhgGz+fwjaqmoUWxoVhDJ8L8jPOP9mELlHfNQ7SdCqo9O
	R3DqTFppCGQggS0WfLpYkykUj6tfAw89/NURZZs4Jlqn/Xistrrm8ayuPXH9HONjTuc/FM
	N1iYXwauYoGT/MdFmMeVXPD33IXJF+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758046352; a=rsa-sha256;
	cv=none;
	b=roFqnTEq0tnzO1CJZRSUb+t3XL2qXjTz6te+5pt1HiQZPf0hmiSVurKHnRKNPyJkFKXgNv
	5jMqbAve19MfD4CNi/Vmz6pMnilYwOrJ+xRX3Dzukl45+ZGE3shljGMO6Xoxbph3Ns+/pu
	xlgf6CsKFNkCxW74yh5vbdueOzvTdaE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XOJqcPWl;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZCyVtyoVDIo5zPTCpsDqkMUO7A9ONdcjpAAg7RirPx8=; b=XOJqcPWl2c1AUf4uNuY1Y3jbWp
	Gp9oxO0Bi0w9UEokXtGilDXz59CeDa4CADPQrsl2PBkXdKA+6SR36pYSVjw79TPpm6bLak0hkAX2S
	QWjAKYRqVHEmBKmwSB2bOXHD95Hf0FBh4h+3ugn08X2ic/G85ps1kda0E182S/g6/aJmMqr5xJLuN
	Xd9iv74SbnlcLMvRHfo6H/MVvdJGTgX142GomfY1zDtd3nCSCvORTVc8ejg0uQRq5UcBa1Bl95tj3
	nklFDMoWthtDq65I/U4a5Cy1ltGjeWSvdg+YcH8l2gcdjzIqe7HrsjP3WF1IM3GZdYnQr8LvH8cxy
	dO1XYSGA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyaAF-0000000A4wM-0xNq;
	Tue, 16 Sep 2025 18:12:27 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: akpm@linux-foundation.org,
	david@redhat.com,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] ksm: Use a folio inside cmp_and_merge_page()
Date: Tue, 16 Sep 2025 19:11:59 +0100
Message-ID: <20250916181219.2400258-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916080533.2385624-1-xialonglong@kylinos.cn>
References: <20250916080533.2385624-1-xialonglong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3CB171C000A
X-Stat-Signature: r3qgunz3wpunthfpg8nngcxk3dednftm
X-Rspam-User: 
X-HE-Tag: 1758046351-297566
X-HE-Meta: U2FsdGVkX1+xQdYhhNPo3OcU2Ry5beEZdNb6viS7s7n+VRT/CfT8DeaBXz2f7l8BjY7ZUQcMwQ8m1yxOjktv2O75T/2JGwf8bG0leB+sIOBjt0S7HpvRYo9o6OjfI49xJshtbHsMDFmEcR4Kn8CURHKuLghD2ogCjVEAqUhSDw1+m+e0MRDm39xZfSpSzVHldXHxrZOWbPbJ+wAgLymbApEuFL5mngvx1IM6YdQvmu12mK6T0sRnXMgcBwgbu3rBCCGQkct+RBMMvfMCfy7vehRrtsSCUgwjdt0/zHNUq0CSU9mtAF0YJTJcxUUjUBCTaBkeYC56MyJOMNrMEkKpPl+JZ0MrLPuUuOfZksE4r75DoQU+6MxXIn949/+wvUA9azlo3OJKYHZW/O3aBN+EXnvCDvKrHA0SkhkQTlejwnE+YOXLO8+1dMIUOHQ6GM9GcNtUnuxZt7ARX+PMWZ+MUvqHph6Ds9mN8wccCKuXZLZ6xRRQG7mLjXhDQbj3rGpNEO6t1atHiOcfEczsnwD3nzU1xHRPsU6oJJSott4a/pYxRMPLS2UKx1M/W5SJlpN0F+WNRIUNkWWQekXQEI1McH0hRkh4Pa2YFbTZ9d34gHx5Zsi92bGggacG9gSxwtuwJIIb+OCzoNKck/YStFVaqvwCzYg4XqrhBllrVeuYRqawxa29A5o6fi8OX38HiRp89lsigXXkwm0o/YjWBIANCg6OvJZNRbWGbUGRK8bm2hSd7ZETaEYiDtzmt++vLbQ7CiHieYBelM3v8zUSaIvHfxWXMiyKKcQcJHvSg/DvaMwzXB8JbiOmo7cN7s43bCWiR9QFw59wB2U60Ryj2TGALS9o7+oV8UXkL5DCuC45QJua5PeOM6RwIhlPIDowWe1E2AVicYFWn+MaHp/b6KfTVJ5oUW24aZE9EBt83lEhfeH7S8Z/+jlGhbJ/N63gT+vnsGLSfhETyhqgn1j0QHe
 u5Kkge9F
 Z5MiM+XvCnA9nAuO+gPvicJ3nXF4BKmCm9Wk6ucKrkLrCIPZpxh87FJNBD9chBBqXMzQiAHMlBlolJbbrVE23r/NCfKd+fJrKf7yNFWzn7jmsfZoDMOlj1IePeI0SqocEXU13ke+HtRtrxfOKyOa9S2z9Gtoc0LTsOctWwshNLfxKO1RCMKnWFZK9aUxtICsNb4q1yWy55fs5EyCswqTx4k/BAzNkAWV16ptTSIZq73E3G/DJHy0vYjN2PE1H1TJT7wmm0pBjUc+lVMa9A4bGLwMVj+zcgnbVLqwhLbWDJkM1lUkCi2gJoOZVr49caf6HLA4G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This removes the last call to page_stable_node(), so delete the
wrapper.  It also removes a call to trylock_page() and saves a call to
compound_head(), as well as removing a reference to folio->page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/ksm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 8583fb91ef13..47655ca8f9a5 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1057,11 +1057,6 @@ struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 	return folio_test_ksm(folio) ? folio_raw_mapping(folio) : NULL;
 }
 
-static inline struct ksm_stable_node *page_stable_node(struct page *page)
-{
-	return folio_stable_node(page_folio(page));
-}
-
 static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
@@ -2221,6 +2216,7 @@ static void stable_tree_append(struct ksm_rmap_item *rmap_item,
  */
 static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_item)
 {
+	struct folio *folio = page_folio(page);
 	struct ksm_rmap_item *tree_rmap_item;
 	struct page *tree_page = NULL;
 	struct ksm_stable_node *stable_node;
@@ -2229,7 +2225,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 	int err;
 	bool max_page_sharing_bypass = false;
 
-	stable_node = page_stable_node(page);
+	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		if (stable_node->head != &migrate_nodes &&
 		    get_kpfn_nid(READ_ONCE(stable_node->kpfn)) !=
@@ -2268,7 +2264,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 
 	/* Start by searching for the folio in the stable tree */
 	kfolio = stable_tree_search(page);
-	if (&kfolio->page == page && rmap_item->head == stable_node) {
+	if (kfolio == folio && rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
@@ -2349,10 +2345,11 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 			 * the page is locked, it is better to skip it and
 			 * perhaps try again later.
 			 */
-			if (!trylock_page(page))
+			if (!folio_trylock(folio))
 				return;
 			split_huge_page(page);
-			unlock_page(page);
+			folio = page_folio(page);
+			folio_unlock(folio);
 		}
 	}
 }
-- 
2.47.2


