Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A9ECCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C868E0113; Fri, 24 Oct 2025 16:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167778E0112; Fri, 24 Oct 2025 16:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5AB8E0113; Fri, 24 Oct 2025 16:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7958E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:45:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C16BA160F73
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:45:02 +0000 (UTC)
X-FDA: 84034187244.13.72E8F6E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2DAE840009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:45:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CmHcj8uR
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338701; a=rsa-sha256;
	cv=none;
	b=2d/81eVm/F/uJsKV0txXCsDtJTW5p3N6izsnRRiyshll9VnEZqRzBc1cDPgTJqPHsW3Scg
	C5HDQtFJo3bwNMcXktuFXHqxjkzM+h8cNL07b43xVzBhKTgC9DL2lL82R5Kr2yIgO73zjR
	quPFuLDUXZUqp7mSzbaai1aPwVYVlE0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CmHcj8uR;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fw0A/tV3HrM/a4f2XVXsAgp18cuJjJq3U1ONhF3Vinc=;
	b=v5hR5NQtZDscEl601SnOVLAUYyryN2vRC60KsTtPrqjBjQ9DkHzYQkIHUsWWpOFqHxdvKC
	OWsA8WVMr6y7WwIY7ZqHgyJ0zTQ5iqiV9zGeqHW+RB8nSHJFsgG/eRKb8Int+zjoDUqgXV
	2XavmgmL8JtQgkUFBorVD6j6vOWbpw8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=fw0A/tV3HrM/a4f2XVXsAgp18cuJjJq3U1ONhF3Vinc=; b=CmHcj8uRY43cs5ubR5w0sd9XnL
	1522736t8cEqs2PYXstIBWd9clsSDZ8XYnFeGadKa9EC5mCPcl8os7mZICzrokKnP4SGjSea7HGCK
	5tg+KDuokx7bAaMs8RY6cxXbQymiFu1Po5gBhHqG8eu9kOGVuD70w0xijCx67+TjyA74T7GqMia5Y
	eWK7XsuxFcSG0c0XGmwn1JYFHL9tenS6M/TmIszpY5gyXMz+j3/IO07ea+w5CDm2M9L+DMiG+v5tc
	2XZy2KqjT3D2H8pRimesneFc4CZchMFqvcc6CFRvsFvaH04pue7DabHVEankJsNtk9+y/jPESTf9E
	XonCYInw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKSk-0Zlx;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 09/17] slab: Remove folio references from __do_krealloc()
Date: Fri, 24 Oct 2025 21:44:24 +0100
Message-ID: <20251024204434.2461319-10-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n3z7zqj34is74rdz7pr4fa8s6r6wri13
X-Rspamd-Queue-Id: 2DAE840009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761338700-565371
X-HE-Meta: U2FsdGVkX1/KGuhs6xhEHsGPGRel49NqgEwZmVcdLg6oNJMHCvkSlMQQyx6aTuPD9JFzmxeqPCLQByP3HHukikE+KC03wWydx2L+gYDMysIY1rYsgGu/iP3OWkTxIa2sLjMwuuKAhpOQLjBPuhUg09LMV4ewyAmv3+QJlL1mY7bxCo4inxkwbRxIbbbNqUpQ+JIJHCmjyY7wLaLoZKnTi8UMgZ97imUwWTltcSNZo6ARouMiMN6QMh7DKuki4+0QlIxcTbpgp2flZoRrS2a6zxfPtPf3uTObZTaw+5/K2gy5USHksI/s6cUyOWnNKwjj1csmhkUTTxt7v6qgW5O//G4pbzRmGd//t3bwFQzmo9ZxzltGX5uAahMYxn5zYMwwKNiRp+C0U0L8AGbLKmwCL7zg4/FqJfwYDDz0pUNRwToSpIu/P1gCNAHoGNjsG9g0mQq7EGQba4yA3b+jAye7KYwf5wKnuEnX8FAADxk7v20OsbmfFA+rx/A1DXLfdcq4hy4wWFP04G5ndWVCmo79iZabmUlZSWkwL6fCyYVxX2ctrhONpJxy8+AGUV3X+JYuMTzQpWSWrstOnk+xmasC+v9ENqJRjJjo679YlJhI7ZXqz5+HAy5A8cZA+C5bRUppWtBZMEUsA1gluBP4MHeBKpY8njt567vftoRBfgg4yuGV2cMdOtCN6F3Q9lpc2l5sFz86vrzWPYkR+6UQE0TZ50bq8O7pu55+/gpQihF7tmyego8R6DXoagloxpEu+AgvZY7ysG76lY0EoMw5pzwVLuGF+E77CePLyZ73NgHx1lDh7JBuoVAKEUCGpSLTvKGFs7RxF3HGRUjHfy8RUW2+OYThv/GAuauV7SgMZlzr73OyzBc/D22Fe3jCZAJSQBMdbfIiOaj50PHc0SSJYU3BJavG/i9wbnz6f1c6Opbw81HwlqDvtCjE6NrY1qQUKXnC1U0qF++kmYkEymjZJ3q
 2LbiocJh
 LmN25pe4KxqrwBlOLXQZlHgDyjjRcInTdfRvlRRN5oAtMFK2c1JAfJRYaRvNJPpkj+sOHa7F6TCf6M7YWPhBM8SKPeX9ytPw+Yug5mX2Y1hcYi4rQKnFcoxjwFiNwnE+M5smDt+s2sctWv2D5wSnEHyDSA5JsI+DvXZABSMv3oXuHoBNileMB0otiI6eoLOCw+lCUqMqdG0n8cwJQIiVaValaeCpgdRwHH4ZOmcel/+1zIdw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head()
for large kmallocs.  This has a slight change of behaviour in that
non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
pointer dereference rather than a warning.  We could add that back if
really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 100ed979312d..4e282e7782bb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6924,16 +6924,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
-		struct folio *folio;
+		struct page *page;
 
-		folio = virt_to_folio(p);
-		if (unlikely(!folio_test_slab(folio))) {
+		page = virt_to_page(p);
+		if (unlikely(PageLargeKmalloc(page))) {
 			/* Big kmalloc object */
-			WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE);
-			WARN_ON(p != folio_address(folio));
-			ks = folio_size(folio);
+			ks = page_size(page);
+			WARN_ON(ks <= KMALLOC_MAX_CACHE_SIZE);
+			WARN_ON(p != page_address(page));
 		} else {
-			s = folio_slab(folio)->slab_cache;
+			s = page_slab(page)->slab_cache;
 			orig_size = get_orig_size(s, (void *)p);
 			ks = s->object_size;
 		}
-- 
2.47.2


