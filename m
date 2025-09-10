Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58431CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662598E0002; Wed, 10 Sep 2025 07:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C1E8E000C; Wed, 10 Sep 2025 07:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550498E0002; Wed, 10 Sep 2025 07:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33BB08E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED79E1DF6DF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:17 +0000 (UTC)
X-FDA: 83873185074.15.CEC934F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5B983A0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fMBcqgoq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uI+TOj/tfjnfjNP9SvH/f7vF7sh4/M3TN7DIoSsDAGE=;
	b=Gp/q0zmKTJdq6m8cXwzCQG9vo5e0xb2ojf5ZoXco3mPolI9WZYvhkrYx4EAwxSIKvXGau5
	w3OeswtSZvtfGhZsSGwHQlgzpLyTzhTWOaxBrlIT6seLJMKFI09LyruPBuF2oWpV1Abcw7
	WBW9DbR3Ht5HHDZDdg3QiuqLvSt/fLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505316; a=rsa-sha256;
	cv=none;
	b=OgcEOTJWgm+OmEzUEtG0VScTJWg7Wtw68GjZgwSNHeDchCqemLD+LjnLzC41m0ovZ60t+0
	vv+FCyvaxWfREz6586VwH/uxJsxg/ajwFLPLwd19Wnxr7BXp2/64Qy2WNMOEFtshE4KzTr
	xzv2PDEjSyMSJSt9eZupKc5Sf/DhYKs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fMBcqgoq;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=uI+TOj/tfjnfjNP9SvH/f7vF7sh4/M3TN7DIoSsDAGE=; b=fMBcqgoqRYQWz5rzmdIDmOiSwW
	yqFRWm3HqG9R1aGz5RIDSCPs1xgJy+bIpuUmE8fCvUdjp9w13usMtijZc6+3uPodaj7r5EmvU0WCk
	vinY6qt3Hf59jIpCbTDjAKUGACFkZx4n3K68kyWPSqFcCPeNNbDV7rkmjeUb37phDHQ3yZL5Q0Edw
	yj/BA3k90yDnUCgYxwu57CmUrRMs+0KNB802OyPgU0f61JdOb84x8vPpEqVJPYnmoJo6Xxx9jXqc1
	Or34aye+T90Ru4dUGdUR+/h5CTASrblOWDTRtJ3EGAh/Qdc+HhuFXUJErm5qMQc8Mj9GXVYl85S02
	HyNDAJKA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MEx-2WbK;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 08/22] slab: Remove folio references in memcg_slab_post_charge()
Date: Wed, 10 Sep 2025 12:54:50 +0100
Message-ID: <20250910115507.1991829-9-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B983A0011
X-Stat-Signature: tpjjjnudgyx47bktjkii16n4pd88mo49
X-Rspam-User: 
X-HE-Tag: 1757505316-414745
X-HE-Meta: U2FsdGVkX1/Uoo4DmU/3VJbZzo7MS9qiyf/NuzDWYh21Vbn6aQvt3xoKGc5irdRUamf6ZMQ6nBzjaw23oInhlU6wcl7GGAwYacJd8DEgqoLXEavtvFPhh3IhMBo+xjXL+dOz8J+OznRkqcGxttS2CRY5lu2eD3vDJElXaLrhBTKVV1q3f7iszp4mBHMFUdNdzwhNxW5Yb1fxsnpJk/EIkNyEpOT8NyMntmaGVu2sIl7LhxbtdFha8RP8rNyAvo5FTj7UsKmToP9qrSUSm3X9YuvyNoDfjYVA1BvDmuiTEhfmMclYOQ+ZfaOj3liTWrc35tt5tNoJvF0Li/L5etKmN7UGO7PAHyLoAHR6a1/Kw6oWNxqe/zyNVPCDNtIWTR3uAH3ElWRmWycCffQ9YXRne/A9y3ZMjxPqlDP2n/BIjMbB75znCJqzRXumpxbWB7CTYVewDGvED+7R2HpzcpFSecZdAJe7a3Lvm5wiDCi1L2U+GpCs6piAAqgh1S6IyCtWQ4fF4N5elIpRTuTwAMdarw+qknFH8Sl2yhLcGlLj1AME2U8V1gxHgcc7mtH2Hj9f8BI6UM6WTZzODdu2nFmAWGbuYpCMyyAO57Ce7DgXgn9KFHQtgqc9y4Ie25pBfAyYaO6Q+0nYHWvVSq4sQxSxF/9RcIcdYe3GD+XaERarfvGrUWF1RuY963EsyOdpH3buLSB1aoqaYXI4+VyMrN35pFC3s8ee5B/EhnAJ7OAoY28V4+x77CLHcAkgM4uLkRyxsC16BizG2XHNZaqw8YzG6E4TR761OA2IttpauHM+noy6BXpEnR3DiOqQmCdyeI0Z4DoFB5Mo61otegSSJfbIrP1Uw6K3gAbVBCbQbxx/5V2QHPscYzdwYwu2ZMgekEZrsS4S9FZEKWY6+jSVjd6fbDNj9xvl8uJyJCxg39ufqGSTld/oLhjR6GnBleYQVnc7auHq/dux002xlB42S7P
 ANg5mlPl
 S6Ua77TpisaUIOGjBoChsSWqdWcXGbzOGC28rq17OR8z6T70ZEFj5G1S4ODFqb2+8l7C9sWlfNuLlDQKtQJkVs2dvIwXcNSykpwWYdQcdA1IEZYq47GJbMjq9kJEx3+1BweV0EFJQ8QNfw3eaBYDcuQP2+oBUL65HsYq0pE4dfQ44hdkxfMh2xZlYQEaDAfFEsgKG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows us to skip the compound_head() call for large kmalloc
objects as the virt_to_page() call will always give us the head page
for the large kmalloc case.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b32bffdd6e3c..9bca3e4b82e6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2304,33 +2304,34 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 {
 	struct slabobj_ext *slab_exts;
 	struct kmem_cache *s;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned long off;
 
-	folio = virt_to_folio(p);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(p);
+	if (PageLargeKmalloc(page)) {
+		unsigned int order;
 		int size;
 
-		if (folio_memcg_kmem(folio))
+		if (PageMemcgKmem(page))
 			return true;
 
-		if (__memcg_kmem_charge_page(folio_page(folio, 0), flags,
-					     folio_order(folio)))
+		order = large_kmalloc_order(page);
+		if (__memcg_kmem_charge_page(page, flags, order))
 			return false;
 
 		/*
-		 * This folio has already been accounted in the global stats but
+		 * This page has already been accounted in the global stats but
 		 * not in the memcg stats. So, subtract from the global and use
 		 * the interface which adds to both global and memcg stats.
 		 */
-		size = folio_size(folio);
-		node_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, -size);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, size);
+		size = PAGE_SIZE << order;
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B, -size);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, size);
 		return true;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
 
 	/*
-- 
2.47.2


